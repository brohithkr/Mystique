let res = await fetch("http://localhost:3000/connect", {
    method: "POST",
    body: JSON.stringify({
        username: "bun"
    })
})

console.log(await res.text())

// console.log(Math.random())
