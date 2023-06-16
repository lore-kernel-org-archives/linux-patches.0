Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7318C07
	for <patches@lists.linux.dev>; Fri, 16 Jun 2023 17:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B20FC433C8;
	Fri, 16 Jun 2023 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686935198;
	bh=oYugvKskX3ycARRns+Q3JNVdPtAXrA9xWAu5PokkPE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hMUJcv2t/x02kV/m7nNOUJwHVJEaLLhow/G6fH/doP3rZh9yEnsv183P8uXt+ehz8
	 UYhI7Z4DnuH0mIJAHievM0a/l+qNYLsN3ceKcYWAOZIDNw7Ah46pdKhpzQ77dJ41bG
	 RPX58IoAqk8r2i3lGq/uVkQcZY8l5Qe+iQNiMMqWKeiQdffGGyL/ZyfurOw6WW0OsG
	 44igd7J8EPxrurdFwKyv87foQPddzTzExiWyYPH5k/cZHpQ/7Y2lQmp6ErxQIYDxkx
	 Drgy5pTTUusBjL7wOoqBck4/8Nd2EMqlFoenuVByatGkzKWfRuQBsb8JAhp6dK8dhQ
	 x986XhM85j/fw==
Date: Fri, 16 Jun 2023 10:06:35 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>, linux-kbuild@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Russell Currey <ruscur@russell.cc>
Subject: Re: [PATCH v2 02/11] kbuild: rust_is_available: fix version check
 when CC has multiple arguments
Message-ID: <20230616170635.GA3474164@dev-arch.thelio-3990X>
References: <20230616001631.463536-1-ojeda@kernel.org>
 <20230616001631.463536-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616001631.463536-3-ojeda@kernel.org>

On Fri, Jun 16, 2023 at 02:16:22AM +0200, Miguel Ojeda wrote:
> From: Russell Currey <ruscur@russell.cc>
> 
> rust_is_available.sh uses cc-version.sh to identify which C compiler is
> in use, as scripts/Kconfig.include does.  cc-version.sh isn't designed to
> be able to handle multiple arguments in one variable, i.e. "ccache clang".
> Its invocation in rust_is_available.sh quotes "$CC", which makes
> $1 == "ccache clang" instead of the intended $1 == ccache & $2 == clang.
> 
> cc-version.sh could also be changed to handle having "ccache clang" as one
> argument, but it only has the one consumer upstream, making it simpler to
> fix the caller here.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> Fixes: 78521f3399ab ("scripts: add `rust_is_available.sh`")
> Link: https://github.com/Rust-for-Linux/linux/pull/873
> [ Reworded title prefix and reflow line to 75 columns. ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  scripts/rust_is_available.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> index f43a010eaf30..0c9be438e4cd 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -113,10 +113,10 @@ fi
>  #
>  # In the future, we might be able to perform a full version check, see
>  # https://github.com/rust-lang/rust-bindgen/issues/2138.
> -cc_name=$($(dirname $0)/cc-version.sh "$CC" | cut -f1 -d' ')
> +cc_name=$($(dirname $0)/cc-version.sh $CC | cut -f1 -d' ')
>  if [ "$cc_name" = Clang ]; then
>  	clang_version=$( \
> -		LC_ALL=C "$CC" --version 2>/dev/null \
> +		LC_ALL=C $CC --version 2>/dev/null \
>  			| sed -nE '1s:.*version ([0-9]+\.[0-9]+\.[0-9]+).*:\1:p'
>  	)
>  	if [ "$clang_version" != "$bindgen_libclang_version" ]; then
> -- 
> 2.41.0
> 
