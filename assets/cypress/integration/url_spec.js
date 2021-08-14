describe('GetShorty URL Shortener', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('Displays the new URL form', () => {
    cy.contains('Long URL to Shorten:')
  })

  it('Displays an error when given a URL without a scheme', () => {
    cy.get('#url-input')
      .type('googlecom').should('have.value', 'googlecom')

    cy.get('#url-form-submit').click()
    cy.contains('URL must begin with http:// or https://')
  })

  it('Displays an error when given a URL with a malformed host', () => {
    cy.get('#url-input')
      .type('http://googlecom').should('have.value', 'http://googlecom')

    cy.get('#url-form-submit').click()
    cy.contains("The URL's host must contain a dot")
  })

  it('Displays a shortened URL when given a well formed original URL', () => {
     cy.get('#url-input')
      .type('http://google.com').should('have.value', 'http://google.com')

    cy.get('#url-form-submit').click()
    cy.get('.shortened-url-box').should('exist')

    cy.get('#shortened-url')
      .invoke('text')
      .should('match', /^http:\/\/localhost:4010\/\w{8}/)
  })

  it('Displays the same shortened URL when given the same original URL', () => {
    cy.get('#url-input')
      .type('http://goodhost.com').should('have.value', 'http://goodhost.com')

    cy.get('#url-form-submit').click()
    cy.get('.shortened-url-box').should('exist')

    cy.get('#shortened-url').then(($shortened_url) =>{
      const first_url = $shortened_url.text()

      cy.get('#url-input')
        .type('http://goodhost.com').should('have.value', 'http://goodhost.com')

      cy.get('#url-form-submit').click()

      cy.get('#shortened-url')
        .invoke('text')
        .should('equal', first_url)
    })
  })

  it('Displays a different shortened URL when given a different original URL', () => {
    cy.get('#url-input')
      .type('http://newhost.com').should('have.value', 'http://newhost.com')

    cy.get('#url-form-submit').click()
    cy.get('.shortened-url-box').should('exist')

    cy.get('#shortened-url').then(($shortened_url) =>{
      const first_url = $shortened_url.text()

      cy.get('#url-input')
        .type('http://differenthost.com').should('have.value', 'http://differenthost.com')

      cy.get('#url-form-submit').click()

      cy.get('#shortened-url')
        .invoke('text')
        .should('not.equal', first_url)
    })
  })
})