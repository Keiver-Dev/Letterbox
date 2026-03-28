import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import { globalLimiter } from './middlewares/rateLimit.middleware.js';
import routes from './routes/index.js';
import { errorMiddleware } from './middlewares/error.middleware.js';
import { corsOptions } from './config/cors.config.js';

const app = express();

// Global Middlewares
app.use(helmet());
app.use(cors(corsOptions));
app.use(compression());
app.use(express.json());

// Rate Limiting
app.use(globalLimiter);

// Routes
app.use(routes);

// Error handling (must be at the end)
app.use(errorMiddleware);

export default app;
