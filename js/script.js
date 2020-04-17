$(document).ready(function () {
    $("section").slideUp(0);
    $("table").fadeOut(0);
    $("section div").css("margin-top", "-14px");

    $("section div h4").click(function () {
        if ($(this).next("table").is(":hidden")) {
            $(this).next("table").fadeIn("slow");
        } else {
            $(this).next("table").fadeOut("slow");
        }
    });

    $("#button1").click(function () {
        $("section").slideToggle("slow");
        $("#button2, #toggle").toggle(0);
    });

    $("#button2").click(function () {
        $("table").slideToggle("slow");
    });

    $("#scroll").click(function () {
        $("html, body").animate({ scrollTop: 0 }, "slow");
    });
});

function showCharts() {
    new Chart(document.getElementById("firstChart"), {
        type: "bar",
        data: {
            labels: ["OK (71%)", "ERROR (29%)"],
            datasets: [
                {
                    backgroundColor: ["#41b3a3", "#e7717d"],
                    data: [5, 2],
                },
            ],
        },
        options: {
            legend: {
                display: false
            },
            title: {
                display: true,
                text: "TEST SCENARIOS"
            },
            scales: {
                yAxes: [
                    { ticks: { beginAtZero: true } }
                ]
            },
        },
    });

    new Chart(document.getElementById("secondChart"), {
        type: "horizontalBar",
        data: {
            labels: ["OK (75%)", "ERROR (8%)", "WARN (17%)"],
            datasets: [
                {
                    backgroundColor: ["#41b3a3", "#e7717d", "#fbc02d"],
                    data: [18, 2, 4],
                },
            ],
        },
        options: {
            legend: {
                display: false
            },
            title: {
                display: true,
                text: "TEST STEPS"
            },
            scales: {
                xAxes: [
                    { ticks: { beginAtZero: true } }
                ]
            },
        },
    });
}