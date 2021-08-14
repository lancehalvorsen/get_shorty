import React from 'react';
import ReactDOM from 'react-dom';

function ErrorBox(props) {
  if (props.errorMessage) {
    return <div className="alert alert-danger">{props.errorMessage}</div>;
  }
  return null;
}

function ShortenedUrlBox(props) {

  if (props.shortenedUrl) {
    return <div className="shortened-url-box">
             <span className="url-box-header">Here's your shortened URL:</span><br />
             <span id="shortened-url">{props.shortenedUrl}</span>
           </div>;
  }
  return null;
}

class UrlFormContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      urlInputPlaceholderText: 'eg. https://google.com',
      urlInputClass: 'input-ghost-text',
      errorMessage: '',
      slug: ''
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.returnShortenedUrl = this.returnShortenedUrl.bind(this);
    this.resetForm = this.resetForm.bind(this);
  }

  handleChange(event) {
    this.setState({urlInputValue: event.target.value, urlInputClass: '', errorMessage: '', slug: ''});
  };

  returnShortenedUrl() {
    if(this.state.slug == '' || this.state.slug == null) {
      return null;
    } else {
      return window.location.href + this.state.slug;
    }
  };

  resetForm() {
    document.getElementById("urlForm").reset();
    document.getElementById("url-input").blur();
    document.getElementById("url-form-submit").blur();
  };

  handleSubmit(event) {
    event.preventDefault();

    var context = this;
    var url = this.state.urlInputValue
    var xhr = new XMLHttpRequest();

    xhr.open('POST', '/api/url');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function() {
      var response = JSON.parse(xhr.response)

      if (xhr.status === 200 || xhr.status === 201) {
        context.setState({errorMessage: response.errors});
        context.setState({slug: response.slug});
      }
      else {
        context.setState({errorMessage: "There was a problem while trying to shorted your URL. Please try again."});
      }
    };

    xhr.onabort = function() {
      context.setState({errorMessage: "There was a problem while trying to shorted your URL. Please try again."});
    };

    xhr.ontimeout = function() {
      context.setState({errorMessage: "There was a problem while trying to shorted your URL. Please try again."});
    };

    xhr.send(encodeURI('url[original]=' + url));

    this.resetForm();
  };

  render() {
    return (
      <div>
        <p>
          Go ahead and add the URL you'd like to shorten in the input below. Then hit "submit". Make sure to include either "http://" or "https://" at the beginning of the URL.
        </p>
        <ErrorBox errorMessage={this.state.errorMessage} />
        <ShortenedUrlBox shortenedUrl={this.returnShortenedUrl()} />
        <form onSubmit={this.handleSubmit} id="urlForm">
          <label>
            Long URL to Shorten:
            <input type="url"
              id="url-input"
              placeholder={this.state.urlInputPlaceholderText}
              className={this.state.urlInputClass}
              onBlur={this.handleBlur}
              onChange={this.handleChange} />
          </label>
          <input id="url-form-submit" type="button" value="Submit"  onClick={this.handleSubmit} />
        </form>
      </div>
    );
  }
}

if (document.getElementById('new_url_form_container')) {
  ReactDOM.render(
    <UrlFormContainer />,
    document.getElementById('new_url_form_container')
  );
}