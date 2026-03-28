import rateLimit from 'express-rate-limit';

/**
 * Global rate limiter for the entire application.
 * Threshold is higher to allow health checks and general routing.
 */
export const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 300, // Limit each IP to 300 requests per window
  standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers
  message: {
    status: 429,
    message: 'Too many requests from this IP, please try again later.'
  }
});

/**
 * Stricter rate limiter for sensitive email-sending endpoints.
 * Prevents spamming and potential API key abuse.
 */
export const emailApiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 50, // Limit each IP to 50 email requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    status: 429,
    message: 'Email sending limit reached. Please try again after 15 minutes.'
  }
});
