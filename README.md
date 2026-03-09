# Engage Learn Monitor

An educational platform for managing student learning activities, quizzes, and progress tracking.

## Project structure

- **`frontend/`** – React (Vite) app: `src/`, `public/`, `index.html`. Build output: root `dist/`.
- **`backend/`** – Backend services:
  - **`backend/server/`** – Node.js (Express) API; serves the built frontend and handles auth, DB, uploads.
  - **`backend/ai_model/`** – Python (FastAPI) AI: chatbot and recommendations. Run with `cd backend/ai_model && python -m uvicorn api:app --reload --port 8000`.
- **`database/`** – SQL scripts and schema (e.g. `railway_core_schema.sql`).

Config files (Vite, Tailwind, TypeScript, etc.) stay at the repository root; Vite is configured with `root: "frontend"`. The canonical AI code lives in `backend/ai_model` only.

## Project Overview

Engage Learn Monitor is a comprehensive educational platform built with modern web technologies to facilitate interactive learning experiences.

## Tech Stack

- **Frontend Framework**: React 18 with TypeScript
- **Build Tool**: Vite
- **UI Components**: shadcn-ui
- **Styling**: Tailwind CSS
- **Routing**: React Router DOM
- **Forms**: React Hook Form with Zod validation
- **Charts**: Recharts

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or bun

### Installation

1. Clone the repository:
```
sh
git clone <YOUR_GIT_URL>
```

2. Navigate to the project directory:
```
sh
cd <YOUR_PROJECT_NAME>
```

3. Install dependencies:
```
sh
npm install
```

4. Start the development server:
```
sh
npm run dev
```

The application will be available at `http://localhost:8080`.

### Building for Production

```
sh
npm run build
```

### Running Tests

```
sh
npm run test
```

## Features

- Student dashboard with progress tracking
- Teacher tools for creating quizzes and lessons
- Admin dashboard for system management
- QR code generation for student attendance
- Interactive learning workflows

## Project Structure

```
src/
├── components/       # Reusable UI components
├── pages/           # Page components
├── contexts/        # React contexts
├── hooks/           # Custom hooks
├── lib/             # Utility functions
└── data/           # Demo data
