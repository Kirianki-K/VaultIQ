# 📦 VaultIQ

> **A minimalist, open-source Flutter application for LPG gas cylinder inventory management, field broker custody tracking, and automated commission reconciliation.**

---

## 🚀 Overview

**VaultIQ** is a cross-platform mobile application built with Flutter (Material 3) designed to streamline the operations of retail LPG (Liquefied Petroleum Gas) distributors. 

Unlike standard Point-of-Sale (POS) apps that only track store sales, VaultIQ introduces a **Custody & Reconciliation Model** specifically designed for businesses that rely on independent field brokers and delivery personnel.

---

## ✨ Key Features

- **📊 Centralized Depot Inventory:** Real-time visibility into full vs. empty cylinder stocks across multiple sizes (e.g., 6kg, 13kg).
- **🚚 Broker Custody Tracking:** Monitor physical stock assigned to individual brokers, real-time sales logged in the field, and empty containers returned.
- **⚠️ Automated Stock Reconciliation:** Identify unaccounted-for cylinders instantly using the formula:
  $$\text{Unaccounted} = \text{Issued} - (\text{Sales} + \text{Empty Returned} + \text{Full Returned})$$
- **💰 Commission & Dues Management:** Automatically calculate real-time commissions earned by brokers and cash due to the depot owner.
- **🎨 Minimalist Material 3 UI:** Clean Tech Blue & Emerald Green aesthetic with dynamic **Light & Dark Mode** support.

---

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (Material 3 Design System)
- **Language:** [Dart](https://dart.dev)
- **Architecture:** Clean, modular structure (`models/`, `screens/`, `services/`, `widgets/`)
- **Backend (Planned):** Service-agnostic (ready for SQLite / Supabase / Firebase integration)

---

## 🤝 Contributing & Open Source

VaultIQ is an open-source project and contributions from developers, UI/UX designers, and open-source enthusiasts are warmly welcomed!

### Current Roadmap / Areas Needing Help:
- [ ] **Broker Detail Screen:** Dedicated mini-dashboards for individual field agents.
- [ ] **Interactive Modals:** Action dialogs for logging quick stock issues and refill swaps.
- [ ] **Local Storage / Persistence:** Integrating SQLite or Hive for offline-first state management.
- [ ] **Role-Based Authentication:** Distinct Admin vs. Broker UI permissions.

### How to Get Started:

1. **Fork the Repository**
2. **Clone your fork:**
   ```bash
   git clone [https://github.com/YOUR-USERNAME/VaultIQ.git](https://github.com/YOUR-USERNAME/VaultIQ.git)
   cd VaultIQ
