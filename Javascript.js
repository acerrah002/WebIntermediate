//This is a 2D array with 2 elemtns inside each item Image and Description this is scaleable just add another element and use the image and description as template
const classes = [{
        image: "Henryimg/Roblox.png",
        description: "A Bunch of Roblox TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT. TEXT TEXT TEXT TEXT TEXT."
    },
    {
        image: "Henryimg/python-logo-only.png",
        description: "A Bunch of Python TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT. TEXT TEXT TEXT TEXT TEXT"
    },
    {
        image: "Henryimg/code.png",
        description: "A Bunch of Website TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT. TEXT TEXT TEXT TEXT TEXT."
    },
    {
        image: "Henryimg/Ccoding.png",
        description: "A Bunch of C programing TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT. TEXT TEXT TEXT TEXT TEXT."
    }
];

let currentindex = 1;

//currentindex = (currentindex + 1) % classes.length; This goes forward
//currentindex = (currentindex + -1) % classes.length; This goes backward
const backbtn = document.getElementById("Backwards");
const forbtn = document.getElementById("Forwards");
const imgslide = document.getElementById("imageslide");
const beforeimg = document.getElementById("imageslideBefore");
const afterimg = document.getElementById("imageslideAfter");
const imgdesc = document.getElementById("imagedescription")

function imgfadanimation(){
    //Removes fade class to have a adding animation
    imgslide.classList.remove('fade');
    beforeimg.classList.remove('fade');
    afterimg.classList.remove('fade');
    //resets the tick so the animation can happen
    void imgslide.offsetWidth;
    void beforeimg.offsetWidth;
    void afterimg.offsetWidth;
    //Adds fade class for animation
    imgslide.classList.add('fade');
    beforeimg.classList.add('fade');
    afterimg.classList.add('fade');    
}

//updates the empty img element in html to be a index of the array
function updateImage() {
    imgfadanimation()
    //The logic for the previous and next image to stay updated
    beforeimg.src = classes[(currentindex + 1 + classes.length) % classes.length].image;
    imgslide.src = classes[currentindex].image;
    imgdesc.textContent = classes[currentindex].description;
    afterimg.src = classes[(currentindex - 1 + classes.length) % classes.length].image;
}
updateImage();
//adds a listener to check if the button was clicked
forbtn.addEventListener('click', () => {
    currentindex = (currentindex + 1 + classes.length) % classes.length;
    updateImage();
});

backbtn.addEventListener('click', () => {
    currentindex = (currentindex - 1 + classes.length) % classes.length;
    updateImage();
});
