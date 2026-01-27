'use server'

import { revalidatePath } from "next/cache"
import fs from 'fs/promises'
import path from "path"

const DATA_FILE = path.join(process.cwd(), 'data', 'supplies.json')

async function readSupplies() {
    try{
        const fileContent = await fs.readFile(DATA_FILE, 'utf-8')
        const data = JSON.parse(fileContent)
        return data.supplies || []
    }catch (error){
        return []
    }
}

/*

Ya quedó la parte básica que ocupas para poder continuar. Ya quedó la 
parte de poder leer los datos que se envien mediente el registro, asi 
guardando la persistencia de datos. Ya te toca la demás chamba. Elimina 
este comentario cuando empieces

*/