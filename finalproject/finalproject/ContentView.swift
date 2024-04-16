
import SwiftUI
import WebKit

struct FoodDescriptionView: View {
    let foodItem: FoodItem
    @State private var notes: [String] = []
    @State private var showAddNoteSheet = false
    @State private var newNote = ""
    @State private var screenWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(foodItem.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    Text(foodItem.name)
                        .font(.title)
                        .padding()
                    
                    Text(foodItem.description)
                        .padding()
                    
                    if let videoURL = foodItem.videoURL {
                        VideoView(videoURL: videoURL)
                            .frame(height: 300)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                .navigationBarTitle(foodItem.name)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showAddNoteSheet.toggle()
                    }) {
                        Text("Notes")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notes")
                        .font(.custom("YourFontName", size: 20)).fontWeight(.bold)
                        .padding(.top)
                    
                    ForEach(0..<notes.count, id: \.self) { index in
                        Text(self.notes[index])
                    }
                }
                .padding(.horizontal)
                .frame(width: self.screenWidth)
                .background(Color.white)
                .padding(.bottom)
            }
            .sheet(isPresented: $showAddNoteSheet) {
                AddNoteView(notes: self.$notes)
            }
            .onAppear {
                self.screenWidth = geometry.size.width
            }
        }
    }
}

struct FoodItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let description: String
    let videoURL: URL?
}



struct ContentView: View {
    let foodCategories = [
        ("Breakfast", "Breakfast"),
        ("Mexican", "Mexican"),
        ("Salads", "Salads"),
        ("Meats", "Meats"),
        ("Desserts", "Desserts")
    ]
    
    @State private var randomFoodItem: FoodItem? = nil
    @State private var shouldShowRandomFoodItem = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("Choose Your Category")
                        .font(.title)
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Feeling hungry? Choose a category and cook away!")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("Or, if you're still a little lost, click beow and let us decide!")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        self.shouldShowRandomFoodItem.toggle()
                        self.randomFoodItem = self.getRandomFoodItem()
                    }) {
                        Text("Get Random Food")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                        ForEach(foodCategories, id: \.0) { category, imageName in
                                            NavigationLink(destination: DetailView(category: category)) {
                                                CategoryButton(imageName: imageName, label: category)
                                                    .aspectRatio(1, contentMode: .fit)
                                                    .padding()
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                }
                .padding()
                .sheet(isPresented: $shouldShowRandomFoodItem) {
                    if let randomFoodItem = self.randomFoodItem {
                        FoodDescriptionView(foodItem: randomFoodItem)
                    }
                }
            }
            .navigationBarTitle("The Recipe App!")
        }
    }
    
    func getRandomFoodItem() -> FoodItem? {
        let allFoodItems = foodCategories.flatMap { getFoodItems(for: $0.0) }
        return allFoodItems.randomElement()
    }
}

struct DetailView: View {
    let category: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                ForEach(getFoodItems(for: category), id: \.id) { foodItem in
                    NavigationLink(destination: FoodDescriptionView(foodItem: foodItem)) {
                        FoodButton(foodItem: foodItem)
                            .aspectRatio(1, contentMode: .fit)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(category)
    }
}

func getFoodItems(for category: String) -> [FoodItem] {
    switch category {
    case "Breakfast":
        return [
            FoodItem(name: "Pancakes", imageName: "pancakes", description: "INGREDIENTS: \n \n - 1⅓ cups all-purpose flour (160g) \n - 1 tablespoon baking powder \n - 2 tablespoons granulated sugar \n - 1 teaspoon salt \n - 1 cup milk (240ml)\n -  1 large egg\n - 4 tablespoons butter melted (56g)\n -  2 teaspoons vanilla extract \n \n INSTRUCTIONS: \n \n 1. Whisk the flour, sugar, baking powder, and salt in a large bowl. \n 2. In a medium bowl whisk together the milk, egg, melted butter and vanilla together until well combined. \n 3. Pour the milk mixture into the flour and fold together just until combined. (It's okay if there are a few small lumps in the batter. This actually helps make fluffier pancakes!) \n 4. Heat a large skillet or griddle over medium-high heat. Once hot, rub or brush with butter to lightly grease the pan. Working in batches, add ¼ cup of batter for each pancake. \n 5. Cook for a few minutes until golden on the bottom and bubbles start to appear on the top, then flip over and cook an additional minute or until golden brown. Add more butter with each new batch of pancakes. Serve hot with butter and a drizzle of maple syrup.", videoURL: URL(string: "https://youtu.be/qE5ycgqswGY?si=hybRoDfMCYptFHI_")),
            FoodItem(name: "Eggs Benedict", imageName: "EggsBenidict", description: "Instructions \n For the Hollandaise sauce: \n 1. Melt the butter in a small saucepan. In a separate small bowl, beat the egg yolks. Mix in lemon juice, whipping cream, and salt and pepper.\n \n 2. Add a small spoonful of the hot melted butter to the egg mixture and stir well. Repeat this process adding a spoonful at a time of hot butter to the egg mixture.( Adding the butter slowly, a spoonful at a time, will temper the eggs and ensure they don't curdle). \n \n 3. Once the butter has been incorporated, pour the mixture back into the saucepan. Cook on low heat, stirring constantly, for just 20-30 seconds. Remove from heat and set aside. It will thicken as it cools. Stir well and add another splash of cream, if needed, to thin.\n \n To poach the eggs: \n \n 1. Fill a medium size pot with about 3 inches of water. Bring the water to a boil and then reduce heat until it reaches a simmer. You should see small bubbles coming to the surface but not rolling. \n \n 2, Add a little splash of vinegar to the water (this is optional, but it helps the egg white to stay together once it is in the water). n \n 3. Crack one egg into a small cup (I use a measuring cup).  Lower the egg into the simmer water, gently easing it out of the cup. \n \n 4. Cook the egg in simmering water for 3-5 minutes, depending on how soft you want your egg yolk. Remove the poached egg with a slotted spoon. \n \n 5. **It is not abnormal for a white foam to form on top of the water when poaching an egg. You can simple skim the foam off of the water with a spoon. \n \n 6. While the egg is cooking, place the slices of Canadian bacon in a large pan and cook on medium-high heat for about 1 minute on each side. \n \n To Assemble: \n \n Toast the English muffin. Top each toasted side with a slice or two of Canadian bacon, and then a poached egg. Top with hollandaise sauce. \n Enjoy!! ", videoURL: URL(string: "https://youtu.be/c8T_gtzHa5g?si=5nWwcwapJ4OS0XDC")),
            FoodItem(name: "Fritata", imageName: "Fritata", description: "Waffles are a tasty breakfast treat.", videoURL: URL(string: "https://www.youtube.com/watch?v=VIDEO_ID"))
        ]
    case "Mexican":
        return [
            FoodItem(name: "Guacamole", imageName: "Guacamole", description: "INGREDIENTS : \n \n - 3 avocados, ripe \n - ½ small yellow onion, finely diced\n - 2 Roma tomatoes, diced\n - 3 tablespoons finely chopped fresh cilantro\n - 1 jalapeno pepper, seeds removed and finely diced\n - 2 garlic cloves, minced\n - 1 lime, juiced\n - ½ teaspoon sea salt INSTRUCTIONS: \n \n 1. Slice the avocados in half, remove the pit, and scoop into a mixing bowl. \n 2. Mash the avocado with a fork and make it as chunky or smooth as you’d like. \n 3. Add the remaining ingredients and stir together. Give it a taste test and add a pinch more salt or lime juice if needed. \n 4. Serve the guacamole with tortilla chips. ", videoURL: URL(string: "https://youtu.be/a6yCQdx3Pkg?si=u7jABkkU7mzAkNgL")),
            FoodItem(name: "Beef Enchiladas", imageName: "Enchilada", description: "INGREDIENTS \n \n - 1 lb ground beef (I used 97/3 lean to fat ratio)\n - 1/4 cup diced onions \n - 2 garlic cloves minced\n - 1/2 tsp ground cumin\n - 1/2 tsp salt\n - pepper to taste\n - 14  corn tortillas\n - 1/3 cup oil (for softening corn tortillas)\n - 12 oz cheddar cheese (or Colby jack cheese)\n \n  ENCHILADA RED SAUCE INGREDIENTS: \n \n - 1/4 cup oil\n -4 tbsp all\n - 2 Tbls chili powder\n - 1/4 tsp ground cumin\n - 1/2 tsp garlic powder\n - 1/2 tsp onion powder\n - 1 Knorr brand chicken bouillon cube \n - 2 cups (16 oz) water \n **You can substitute the bouillon cube and water with\n -2 cups of chicken stock or broth\n **If using chicken broth, be sure to adjust salt and seasoning to taste\n **Bake in a 9x13 baking dish\n **Preheat oven to 375 degrees F\n **Bake covered for 20 minutes and then uncovered for 10 to 15 minutes. " , videoURL: URL(string: "https://youtu.be/CjoVxMSdfKg?si=jqmimYsbwDYd2Yzd")),
            FoodItem(name: "Steak Tacos", imageName: "SteakTacos", description: " ", videoURL: URL(string: "https://www.youtube.com/watch?v=VIDEO_ID"))
        ]
    case "Salads":
        return [
            FoodItem(name: "Caprese Salad", imageName: "CapreseSalad", description: "INGREDIENTS: \n \n - 3 pounds assorted tomatoes, cut into bite-size pieces\n - 1-pound buffalo mozzarella, cut into bite-size pieces\n - 2 teaspoons dry oregano\n - 3 tablespoons extra virgin olive oil\n - 15 fresh basil leaves\n - Sea salt and fresh cracked pepper to taste \n \n Serves 6\n Prep Time: 10 minutes \n INTRUCTIONS: \n \n 1. In a serving bowl or on a serving plate or tray toss together the tomatoes and mozzarella until mixed in with each other.\n 2. Garnish with dry oregano, salt, and pepper.\n 3. Finish by generously drizzling on olive oil and add on fresh basil leaves. ", videoURL: URL(string: "https://youtu.be/9WhwoiPvnq8?si=scVDfogoGjANH1lF")),
            FoodItem(name: "Pasta Salad", imageName: "PastaSalad", description: "INGREDIENTS: \n \n - 16 ounces short pasta (penne, bowtie, fusilli, etc)\n - 1 English cucumber diced\n - 1-pint grape tomato\n - 1/2 cup pitted kalamata olives sliced\n - 1/2 cup red onion diced\n - 3 ounces of feta cheese crumbled\n - Greek Salad Dressing\n - 1 large clove of garlic crushed\n - 1/2 teaspoon Dijon mustard\n - 1 teaspoon dried oregano\n - 1/4 cup lemon juice\n - 2 tablespoons red wine vinegar\n - 1/3 cup extra virgin olive oil\n - 1/2 teaspoon sea salt\n - 1/4 teaspoon black pepper \n \n INSTRUCTIONS: \n \n 1. Cook pasta al dente according to package directions. Rinse under cold water and transfer to a large bowl. \n 2. Add the cucumber, tomatoes, bell pepper, Kalamata olives, red onion, and feta cheese.\n 3. Combine garlic, oregano, lemon juice, red wine vinegar, and Dijon mustard in a small jar. Slowly whisk in the extra virgin olive oil and season with salt and pepper. If using a mason jar, you can simply put the lid on and shake the jar until well combined. \n 4. Drizzle the dressing over the top and toss well. Chill for 2-3 hours before serving and enjoy! \n \n **This salad is lightly dressed. If you like extra dressing on your pasta salad, feel free to 1.5x the dressing.", videoURL: URL(string: "https://youtu.be/nAiyDUDMudU?si=DuK3ZvVQyQQxXiR6")),
            FoodItem(name: "Potato Salad", imageName: "PotatoSalad", description: "Caprese Salad is a simple Italian salad with tomatoes, mozzarella cheese, basil, olive oil, and balsamic vinegar.", videoURL: URL(string: "https://www.youtube.com/watch?v=VIDEO_ID"))
        ]
    case "Meats":
        return [
            FoodItem(name: "Steak", imageName: "Steak", description: "Steak is a delicious cut of meat often grilled or pan-seared.", videoURL: URL(string: "https://www.youtube.com/watch?v=vkcHmpKxFwg&ab_channel=Epicurious")),
            FoodItem(name: "Chicken Katsu", imageName: "ChickenKatsu", description: "Ingredients you'll need: \n \n Chicken Katsu- \n  - 4 chicken breasts or thighs \n - 2 cups (290g) All purpose flour \n - 3  \n - 2 cups oil \n - salt or miso to taste (miso is very salty) \n \n Tonkatsu Sauce Recipe: \n - 3tbsp (42ml) Ketchup \n - 1tbsp (14g) Worcestershire \n - 1tbsp (20g) Oyster sauce \n - 1tbsp (20g) Miso \n - 1 teaspoon (8g) honey \n \n Cabbage Slaw:\n - 1/4 head cabbage thinly sliced \n - 1/2 bunch green onion thinly sliced \n - salt to taste \n - lemon juice to taste \n - spicy chili garlic topping to taste", videoURL: URL(string: "https://www.youtube.com/watch?v=vkcHmpKxFwg&ab_channel=Epicurious")),
            FoodItem(name: "Beef Burgers", imageName: "Burger", description: "INGREDIENTS:\n \n - 1 1/2 pounds Certified Angus Beef ® ground beef, 80/20 lean \n - 1/2 cup mayonnaise \n - 1 tablespoon yellow mustard \n - 1 tablespoon grated yellow onion \n - 2 teaspoons hot sauce \n - 1 teaspoon Worcestershire sauce \n - 4 white hamburger buns \n - 2 tablespoons butter, room temperature \n - 1 1/2 teaspoons kosher salt \n - 1/2 teaspoon pepper \n - 4 slices American cheese \n - 2 cups shredded iceburg lettuce \n - 8 slices vine-ripe tomatoes", videoURL: URL(string: "https://youtu.be/foD42-73wdI?si=VwR5uqo_JSwK2z4G")),
            FoodItem(name: "Lasagna", imageName: "Lasagna", description: "INGREDIENTS:\n \n - Ground beef – We used 80/20 beef (20% fat content) for a juicier lasagna.\n - Onion – we use yellow onion, or sweet onion works well\n - Garlic cloves – you can add more if you love garlic\n - Red wine (or beef broth) – This amps up the flavor of your sauce (avoid using cooking wine).\n - Marinara sauce – Use homemade marinara or store-bought.\n - Dried thyme – Italian seasoning, basil, or oregano can be substituted\n - Sugar – balances the acidity of the tomatoes\n - Parsley – flat-leaf or curly parsley works well\n - Lasagna noodles – Cook these al dente; they’ll continue to soften as the lasagna bakes.\n - Cottage cheese – adds great texture and moisture\n - Ricotta cheese – we use low-fat or part-skim ricotta\n - Mozzarella cheese – An Italian cheese blend works, but mozzarella is definitely the classic choice\n - Egg – helps hold the cheese layer together \n \n INSTRUCTIONS:\n \n 1. Brown the beef – Add oil to a deep pan and sautee onion and beef until browned, 5 minutes then add garlic and stir another minute. \n 2. Finish the sauce – Pour in 1/4 cup of wine and stir until almost evaporated. Add marinara, salt, pepper, thyme, sugar, and parsley; bring to a simmer, then cover and cook 5 minutes.\n 3. Make the cheese filling – Combine all of the cheese sauce ingredients and 1 cup of mozzarella in a mixing bowl (reserve the rest for later).\n 4. Prep – Preheat your oven to 375ºF and cook the lasagna noodles in a pot of well-salted water until al dente.\n 5. Assemble – Spread 1/2 cup of the meat sauce on the bottom of a 9×13-inch casserole dish. Add 3 noodles, followed by 1/3 of the meat sauce, 1 cup of mozzarella, and half of the ricotta mixture. Repeat, then for the top layer, add 3 noodles, 1/3 of the meat sauce, and the remaining mozzarella.\n 6. Bake – Cover with foil and bake at 375˚F for 45 minutes, then remove the foil and broil for 3 to 5 minutes, or until the cheese is lightly browned \n 7. Rest – Let the lasagna rest for about 30 minutes before cutting and serving.", videoURL: URL(string: "https://youtu.be/fVDsTP-pTXs?si=f6HkMF8e4OiU22HN"))
        ]
    case "Desserts":
        return [
            FoodItem(name: "Chocolate Cake", imageName: "ChocolateCake", description: "- all-purpose flour \n - sugar \n - unsweetened cocoa powder \n - baking powder \n - baking soda \n - salt \n - espresso powder \n - milk – you can also use buttermilk, almond milk, oat milk, or coconut milk \n - oil – you can use vegetable, canola or melted coconut oil \n - eggs – when baking, I like to use room temperature eggs \n - vanilla extract \n - boiling water \n \n _Instructions_ \n Preheat oven to 350º F. Prepare two 9-inch cake pans by spraying with baking spray or buttering and lightly flouring. \n 1. Add flour, sugar, cocoa, baking powder, baking soda, salt and espresso powder to a large bowl or the bowl of a stand mixer. Whisk through to combine or, using your paddle attachment, stir through flour mixture until combined well. \n 2. Add milk, vegetable oil, eggs, and vanilla to flour mixture and mix together on medium speed until well combined. Reduce speed and carefully add boiling water to the cake batter until well combined. \n 3. Distribute cake batter evenly between the two prepared cake pans. Bake for 30-35 minutes, until a toothpick or cake tester inserted in the center of the chocolate cake comes out clean. \n 4. Remove from the oven and allow to cool for about 10 minutes, remove from the pan and cool completely. \n 5. Frost the cake with Chocolate Buttercream Frosting. ", videoURL: URL(string: "https://youtu.be/GgOIdkV5PPQ?si=ydAY6VsfSfMci5OB")),
            FoodItem(name: "Brownies", imageName: "Brownies", description: "INGREDIENTS \n 8 ounces good-quality chocolate \n ¾ cup butter, melted \n 1¼ cups sugar \n 2 eggs \n 2 teaspoons vanilla \n ¾ cup all-purpose flour \n ¼ cup cocoa powder \n 1 teaspoon salt \n \n PREPARATION \n 1. Preheat oven to 350°F/180°C. \n 2. Chop the chocolate into chunks. Melt half, then save the other half for later. \n 3. Mix the butter and the sugar, then beat in the eggs and vanilla for 1-2 minutes until the mixture has become fluffy and light in color. \n 4. Whisk in the reserved melted chocolate (make sure the chocolate is not too hot or else the eggs will cook), then sift in the flour, cocoa powder, and salt.\n 5. Fold the dry ingredients into the wet ingredients, being careful not to overmix as this will cause the brownies to be more cake-like in texture. \n 6. Fold in the chocolate chunks, then transfer the batter into a parchment paper-lined square baking dish. \n 7. Bake for 20-25 minutes, depending on how fudgy you like your brownies, then cool completely. \n 8. Slice, then serve with a nice cold glass of milk!", videoURL: URL(string: "https://youtu.be/lIb_741_dIw?si=nLsTjWGFXTxzO36l")),
            FoodItem(name: "Cinnamon Buns", imageName: "CinnamonBuns", description: "DOUGH \n \n - 2½ cups all purpose flour \n - ¼ cup sugar \n - 2¼ teaspoons instant yeast \n - ½ teaspoon salt \n - ½ cup whole milk \n - 3 tablespoons butter \n - 2 tablespoons vegetable oil \n - 1 teaspoon vanilla \n - 1 egg \n - ¼ cup water \n \n FILLING \n - ¼ cup butter soft \n - ⅓ cup brown sugar \n - 1 tablespoon cinnamon \n - pinch salt \n \n CREAM CHEESE GLAZE \n - 4 ounces cream cheese room temperature \n - 2 tablespoons butter room temperature \n - ¾ - 1 cup confectioner's sugar \n - ½ teaspoon vanilla \n \n INSTRUCTIONS \n \n 1. For the dough, combine in a large bowl the flour, sugar, instant yeast and salt. Heat milk in a small pot over the stove or in the microwave until quite warm. Add butter and stir until melted. Add vegetable oil and vanilla.\n 2. Cool milk mixture to lukewarm if necessary. You should barely be able to feel it when you stick your finger in it. Make a well in the dry ingredients and add milk mixture. Add egg and water. Mix by hand or using stand mixer until the mixture forms a very soft, sticky dough. Knead 6-8 minutes using the dough hook attachment or by hand. Add 2-3 tablespoons of flour if the dough looks too much like a thick batter, but it should still be very sticky. If the dough is very dry and easy to handle, add more water to make it sticky. Knead until it feels very smooth. Cover well with plastic wrap and proof for 1½ - 2 hours or until doubled in bulk.\n 3. While dough is rising, combine the brown sugar and cinnamon in a small bowl for the filling. Once the dough has proofed, roll out into a rectangle that measures 15x10 inches. Use a small amount of flour on your work surface to prevent sticking. Spread the soft butter over entire surface of the dough, then sprinkle on the brown sugar and cinnamon mixture. Starting from long edge closest to you, roll dough as tightly as you can. When you reach the end, pinch the seam very well to seal. 4. Using a sharp knife or a piece of string, cut the roll into 8-12 buns. Arrange evenly in a buttered parchment lined 14 x 8 inch pan and cover with plastic. Allow to rise in a warm place for another 45-60 minutes or until doubled in size. \n 5. Preheat oven to 375F/190C. Bake rolls for 18-22 minutes or until golden brown and fully cooked in the middles. Set aside to cool while making the frosting.\n 6. For frosting, cream together cream cheese and butter until smooth. You can do this by hand or with an electric mixer. Slowly add the powdered sugar, a couple of tablespoons at a time, creaming well after each addition. Add vanilla and beat until smooth. \n 7. Frost cinnamon rolls while they are still slightly warm but not too hot. The frosting should not melt. Serve immediately or keep well wrapped in the refrigerator for up to 5 days.", videoURL: URL(string: "https://www.youtube.com/watch?v=VIDEO_ID"))
            ]
    default:
        return []
    }
}



struct AddNoteView: View {
    @Binding var notes: [String]
    @State private var newNote = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("New Note", text: $newNote)
                    .padding()
                
                Button(action: {
                    self.notes.append(self.newNote)
                    self.newNote = ""
                }) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                List {
                    ForEach(notes, id: \.self) { note in
                        HStack {
                            Text(note)
                            Spacer()
                            Button(action: {
                                if let index = self.notes.firstIndex(of: note) {
                                    self.notes.remove(at: index)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteNote)
                }
                
                Spacer()
            }
            .navigationBarTitle("Add Note")
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}

struct CategoryButton: View {
    let imageName: String
    let label: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(10)
            Text(label)
                .font(.headline
                )
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 150)
                    }
                }

                struct FoodButton: View {
                    let foodItem: FoodItem
                    
                    var body: some View {
                        VStack {
                            Image(foodItem.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                            Text(foodItem.name)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 150)
                    }
                }

                struct ContentView_Previews: PreviewProvider {
                    static var previews: some View {
                        ContentView()
                    }
                }

struct VideoView: View {
    let videoURL: URL
    
    var body: some View {
        WebView(url: videoURL)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
