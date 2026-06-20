## Markdown

We do use mainly plain markdown.  Occasionally it is extended using shortcodes.

## Checkout

use of git submodule
use for of hugo-goa to maintain css customization
The `stable` branch keeps my customization. On request we merge master into it.
The `master` branch keeps track of upstream changes.

    cd themes/hugo-goa
    git checkout stable

## Publishing

After setting the variables `FTP_HOST` and `FTP_PATH`

    ./deploy.sh
