const API_URL = 'http://localhost:8080';

document.addEventListener('DOMContentLoaded', () => {
  fetchExpenses();
  fetchSummary();

  document.getElementById('expense-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const errorMsg = document.getElementById('error-message');
    errorMsg.classList.add('hidden');

    const amount = parseFloat(document.getElementById('amount').value);
    const category = document.getElementById('category').value;
    const date = document.getElementById('date').value;
    const description = document.getElementById('description').value;

    if (amount <= 0 || !category) {
      errorMsg.textContent = "Please enter a valid amount and category.";
      errorMsg.classList.remove('hidden');
      return;
    }

    const payload = { amount, category, date, description };

    try {
      const response = await fetch(`${API_URL}/expenses`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (!response.ok) throw new Error("Failed to save expense");

      document.getElementById('expense-form').reset();
      fetchExpenses();
      fetchSummary();
    } catch (error) {
      errorMsg.textContent = "Error saving expense. Is the backend running?";
      errorMsg.classList.remove('hidden');
    }
  });
});

async function fetchExpenses() {
  try {
    const response = await fetch(`${API_URL}/expenses`);
    const expenses = await response.json();
    renderExpenses(expenses);
  } catch (error) {
    console.error("Failed to fetch expenses:", error);
  }
}

async function fetchSummary() {
  try {
    const response = await fetch(`${API_URL}/summary`);
    const data = await response.json();
    document.getElementById('total-amount').textContent = data.total.toFixed(2);
  } catch (error) {
    console.error("Failed to fetch summary:", error);
  }
}

function renderExpenses(expenses) {
  const list = document.getElementById('expense-list');
  const emptyState = document.getElementById('empty-state');
  list.innerHTML = '';

  if (expenses.length === 0) {
    emptyState.classList.remove('hidden');
    return;
  }
  
  emptyState.classList.add('hidden');

  expenses.forEach(exp => {
    const item = document.createElement('div');
    item.className = 'expense-item';
    item.innerHTML = `
      <div class="expense-info">
        <h3>${exp.category}</h3>
        <p>${exp.date} ${exp.description ? '- ' + exp.description : ''}</p>
      </div>
      <div class="expense-meta">
        <span class="amount">₦${exp.amount.toFixed(2)}</span>
        <button class="delete-btn" onclick="deleteExpense(${exp.id})">Delete</button>
      </div>
    `;
    list.appendChild(item);
  });
}

async function deleteExpense(id) {
  if(!confirm("Are you sure you want to delete this?")) return;
  
  try {
    const response = await fetch(`${API_URL}/expenses/${id}`, { method: 'DELETE' });
    if (!response.ok) throw new Error("Failed to delete");
    fetchExpenses();
    fetchSummary();
  } catch (error) {
    console.error("Delete error:", error);
    alert("Could not delete the expense.");
  }
}