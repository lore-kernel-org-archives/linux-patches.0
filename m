Received: from hop.stappers.nl (hop.stappers.nl [141.105.120.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663826FCE
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 18:03:08 +0000 (UTC)
Received: from gpm.stappers.nl (gpm.stappers.nl [82.168.249.201])
	by hop.stappers.nl (Postfix) with ESMTP id B300D20167;
	Wed, 30 Aug 2023 17:53:10 +0000 (UTC)
Received: by gpm.stappers.nl (Postfix, from userid 1000)
	id 471A430417C; Wed, 30 Aug 2023 19:53:10 +0200 (CEST)
Date: Wed, 30 Aug 2023 19:53:09 +0200
From: Geert Stappers <stappers@stappers.nl>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
Message-ID: <ZO+CBdxxuDBrdDR8@gpm.stappers.nl>
References: <20230830165949.127475-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>

On Wed, Aug 30, 2023 at 06:59:48PM +0200, Miguel Ojeda wrote:
> A few months ago we started a webpage for the Rust subsystem and
> the overall Rust for Linux project [1].
> 
> The current `W:` field of the Rust entry points to the GitHub
> repository, since originally we kept information in a `README.md`
> file that got rendered by GitHub when visiting that URL.
> 
> That information was moved into the webpage and got expanded.

It looks like "mdbook" and "webbrowser view-source" confirms it is.


> The webpage is also nowadays the entry point to the project,
> and we pointed the "Website" GitHub metadata field to it.
> 
> Thus update the `W:` field to point to the actual webpage.
> 
> Link: https://rust-for-linux.com [1]

Where to find the source for the MarkDownBook?


> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 12601a47c839..7c8088e9a11b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18558,7 +18558,7 @@ R:	Andreas Hindborg <a.hindborg@samsung.com>
>  R:	Alice Ryhl <aliceryhl@google.com>
>  L:	rust-for-linux@vger.kernel.org
>  S:	Supported
> -W:	https://github.com/Rust-for-Linux/linux
> +W:	https://rust-for-linux.com
>  B:	https://github.com/Rust-for-Linux/linux/issues
>  C:	zulip://rust-for-linux.zulipchat.com
>  T:	git https://github.com/Rust-for-Linux/linux.git rust-next
> 
> base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
> -- 
> 2.42.0

Reviewed-by: Geert Stappers <stappers@stappers.nl>


Groeten
Geert Stappers
-- 
Silence is hard to parse
