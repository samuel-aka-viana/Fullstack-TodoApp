import axios from 'axios'

const baseUrl = 'api/auth'

let token = null
let config

let refreshToken = null
let refreshConfig = null

const setToken = newToken => {
    token = `Bearer ${newToken}`
    config = {
        headers: { Authorization: token },
    }
}

const setRefresh = newToken => {
    refreshToken = `Bearer ${newToken}`
    refreshConfig = {
        headers: { Authorization: refreshToken },
    }
}

const login = async credential => {
    const response = await axios.post(`${baseUrl}/login`, credential)
    return response.data
}

const logout = async () => {
    if (!token) {
        throw new Error('Token de logout não fornecido!');
    }

    try {
        const response = await axios.post(`${baseUrl}/logout`, {}, config);
        return response.data;
    } catch (error) {
        console.error("Erro no logout:", error);
        throw error;
    }
}

const refreshAccessToken = async () => {
    const response = await axios.post(`${baseUrl}/refresh`, null, refreshConfig)
    return response.data
}

export default {login, logout, refreshAccessToken, setToken, setRefresh}