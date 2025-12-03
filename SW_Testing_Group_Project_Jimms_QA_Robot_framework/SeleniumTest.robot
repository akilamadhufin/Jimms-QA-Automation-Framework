*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser to Jimms
    Open Browser    https://www.jimms.fi/    Chrome
    ...    options=add_argument("disable-search-engine-choice-screen"); add_experimental_option("detach",True)
    Maximize Browser Window
    Sleep    2s

*** Test Cases ***
#01. Does all product categories have a "landing page"
Does all product categories have a "landing page"
    Open Browser to Jimms

    # Get the total count of top-level categories
    ${category_count}=    Get Element Count    //*[@id="sitemegamenu"]/nav/ul/li

    # Iterate through each top-level category
    FOR    ${index}    IN RANGE    1    ${category_count}+1
        Log    Verifying category ${index}
        
        # Hover over the category menu item
        ${category_xpath}=    Set Variable    //*[@id="sitemegamenu"]/nav/ul/li[${index}]/a
        Mouse Over    ${category_xpath}
        Sleep    1s

        # Get the text from the top-level category
        ${category_text}=    Get Text    ${category_xpath}
        Log    Category Text: ${category_text}

        # Click on the first submenu item after hovering
        ${submenu_xpath}=    Set Variable    //*[@id="sitemegamenu"]/nav/ul/li[${index}]/div/ul/li[1]/a/span
        Click Element    ${submenu_xpath}
        Sleep    2s

        # Verify that the landing page contains the text from the top-level category
        ${page_content}=    Get Text    xpath=//body
        Should Contain    ${page_content}    ${category_text}

        # Go back to the previous page after visiting the submenu
        Go Back
        Sleep    2s

    END
    Close Browser

*** Test Cases ***
#02. Test search feature from main page (search keyword is: ps5)
Test search feature from main page
    Open Browser to Jimms
    # Input "ps5" into the search bar
    Input Text    xpath=//*[@id="searchinput"]    ps5
    Sleep    1s  # Optional: Wait a moment to ensure the input is processed
    # Press the ENTER key to submit the search
    Press Key    xpath=//*[@id="searchinput"]    \\13
    Sleep    2s
   

    # Capture screenshot of the first product in search results
    ${first_product}=    Get WebElement    xpath=//*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]
    Capture Element Screenshot    ${first_product}    first_product_screenshot.png

    # Click the first product to open the product page
    Click Element    xpath=//*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5/a
    Sleep    2s

    # Verify that the product page contains the keyword 'ps5'
    ${page_text}=    Get Text    xpath=//body
    Should Contain    ${page_text.lower()}    ps5


*** Test Cases ***
#03. Can you find link "Lisää koriin" from product page
find link "Lisää koriin" from product page
    Open Browser to Jimms
    Input Text    xpath=//*[@id="searchinput"]    ps5
    Press Key    xpath=//*[@id="searchinput"]    \\13
    Sleep    2s

    # Click the first product to open the product page
    Click Element    xpath=//*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5/a
    Sleep    2s

    # Verify if the "Lisää koriin" link is present on the page
    ${link_xpath}=    Set Variable    xpath=//*[@id="product-cta-box"]/div/div[3]/div[2]/addto-cart-wrapper/div/a
    ${link_count}=    Get Element Count    ${link_xpath}
    Should Be True    ${link_count} > 0    "The link 'Lisää koriin' was not found on the product page."


*** Test Cases ***
#04. Can you find icon related to link "Lisää koriin". Robot takes element screenshot from icon.    
find "Lisää koriin" icon from product page
    Open Browser to Jimms
    Input Text    xpath=//*[@id="searchinput"]    ps5
    Press Key    xpath=//*[@id="searchinput"]    \\13
    Sleep    2s

    # Click the first product to open the product page
    Click Element    xpath=//*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5/a
    Sleep    2s
    
    # Verify if the "Lisää koriin" icon is present on the page
    ${icon_xpath}=    Set Variable    xpath=//*[@id="product-cta-box"]/div/div[3]/div[2]/addto-cart-wrapper/div/a/span
    ${icon_count}=    Get Element Count    ${icon_xpath}
    Should Be True    ${icon_count} > 0    "The icon related to 'Lisää koriin' was not found on the product page."

    # Capture screenshot of the icon
    ${icon}=    Get WebElement    ${icon_xpath}
    Capture Element Screenshot    ${icon}    lisäakori_icon_screenshot.png


*** Test Cases ***
#05. Robot adds product into shopping cart
Robot adds product into shopping cart
    Open Browser to Jimms
    Input Text    xpath=//*[@id="searchinput"]    ps5
    Press Key    xpath=//*[@id="searchinput"]    \\13
    Sleep    2s

    # Click the first product to open the product page
    Click Element    xpath=//*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5/a
    Sleep    2s
    # Click the "Lisää koriin" link to add the product to the cart
    ${add_to_cart_xpath}=    Set Variable    xpath=//*[@id="product-cta-box"]/div/div[3]/div[2]/addto-cart-wrapper/div/a
    Click Element    ${add_to_cart_xpath}
    Sleep    2s

    ${shopping_Cart}=    Set Variable    xpath=//*[@id="headercartcontainer"]/a
    Should Not Contain    ${shopping_Cart}    Your shopping cart is empty

    Sleep    2s
    Close Browser


*** Test Cases ***
Tc_10 Verify that user can click on the Logo and navigate to home page
    Open Browser
    Input Text    xpath=//*[@id="searchinput"]    ps5
    Sleep    1s
    # Press the ENTER key to submit the search
    Press Keys    xpath=//*[@id="searchinput"]    ENTER
    Sleep    2s

    Click Element    xpath=//*[@id="jim-header"]/div/div[2]/div/a/picture/img
    Sleep    2S

    Scroll Element Into View    xpath=//*[@id="jim-main"]/div[4]/div[1]/h2
    

    ${expectedText}=    Set Variable    Suosittelemme
    ${actualText}=    Get Text    xpath=//*[@id="jim-main"]/div[4]/div[1]/h2

    Should Be Equal    ${expectedText}    ${actualText}

    Capture Page Screenshot    homepage.png

    Close Browser


#Verify whether user can create an account in the web application
TC_07_Creating_User_Account
    Open Browser to Jimms
    ${path}=    Set Variable    xpath=//*[@id="navcustomerwrapper"]/div/a/span
    Click Element    ${path}
    Sleep    2s

    Click Element    xpath=//*[@id="private-tab-label"]

   
    Sleep    2S

    Click Element    name:EmailAddress
    Input Text    name:EmailAddress    ddd344@d.com
    Sleep    1S

    Click Element    xpath=//*[@id="pf-Password"]
    Input Text    xpath=//*[@id="pf-Password"]    Akilauni@123       
    Sleep    1S

    Click Element    name:ConfirmPassword
    Input Text    name:ConfirmPassword    Akilauni@123 
    Sleep    1S

    Scroll Element Into View    name:FirstName
    Click Element    name:FirstName
    Input Text    name:FirstName    madu  

    Scroll Element Into View    name:LastName
    Click Element    name:LastName
    Input Text    name:LastName    madu    

    Scroll Element Into View    name:Address
    Click Element    name:Address
    Input Text    name:Address    Nekala

    Scroll Element Into View    name:PostalCode
    Click Element    name:PostalCode
    Input Text    name:PostalCode    33800

    Scroll Element Into View    name:City
    Click Element    name:City
    Input Text    name:City    Tampere    

    Scroll Element Into View    name:Phone
    Click Element    name:Phone
    Input Text    name:Phone    0417218905      

    Select Checkbox    GDPR

    Scroll Element Into View    xpath=//*[@id="accordionItemRegisterPrivate"]/div/div/div/form/div[9]/font/font/input
    Click Element    xpath=//*[@id="accordionItemRegisterPrivate"]/div/div/div/form/div[9]/font/font/input

    Sleep    2s

    Click Element    xpath=//*[@id="navcustomerbutton"]
    
    Should Contain    xpath=//*[@id="navcustomerbutton"]    0417218905


*** Test Cases ***
#Verify that user can view the items which cost's more than the minimum  price
TC_08 user can view the items which cost's more than the minimum price
    Open Browser to Jimms
    Click Element    xpath=//*[@id="jim-main"]/div[3]/jim-category-image/div/div[1]/a/div[1]/img
    Sleep    2S

    Scroll Element Into View    xpath=//*[@id="cFilterPrice"]/div/div[1]/div/div[1]/div/input
    Click Element    xpath=//*[@id="cFilterPrice"]/div/div[1]/div/div[1]/div/input
    Input Text    xpath=//*[@id="cFilterPrice"]/div/div[1]/div/div[1]/div/input    500
    Sleep    2S    

    Click Element    xpath=//*[@id="ocListFilters"]/div[2]/div[2]
    Sleep    2S

    Scroll Element Into View    xpath=//*[@id="productlist-sorting"]/div/button
    Click Element    xpath=//*[@id="productlist-sorting"]/div/button
    Sleep    2S

    Select From List By Index    xpath=//*[@id="productlist-sorting"]/div/ul/li[7]/a
    Sleep    2s

    Should Contain    xpath=//*[@id="productlist"]/div[4]/div/div[1]/product-box/div[2]/div[3]/div/span/span    >1000