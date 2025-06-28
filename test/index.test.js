const request = require('supertest');
const app = require('../src/index');

describe('API Tests', () => {
    it('GET / returns status ok', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toEqual({ status: 'ok' });
    });

    it('Health check returns 200', async () => {
        const res = await request(app).get('/health');
        expect(res.statusCode).toEqual(200);
    });
});