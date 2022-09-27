Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BB5440E
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F438C433C1;
	Tue, 27 Sep 2022 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664292927;
	bh=sFsv2vn2MuycGfKw5zcFhEp9tzgTNZNiYQitk3gLW3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mRLNLDczWJyVtq2nhSSwUk+2kSk3aJDhURRQN8jmpfX3K/WhFVNNoc0WuOeSWfu0b
	 lSreBZmmsTa7dhVfyEGYWRNm6pNGYnwfyRr75ufUAi+kPUpH7HmONb9ZxecQtI7q9/
	 LNk7tT+QFeIPXe6sBG4qXCQHD07IltGPwHfwavmU=
Date: Tue, 27 Sep 2022 17:35:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Gary Guo <gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>,
	Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
Message-ID: <YzMYPGOQYdrVqjqO@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-9-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:39PM +0200, Miguel Ojeda wrote:
> This customizes the subset of the Rust standard library `alloc` that
> was just imported as-is, mainly by:
> 
>   - Adding SPDX license identifiers.
> 
>   - Skipping modules (e.g. `rc` and `sync`) via new `cfg`s.
> 
>   - Adding fallible (`try_*`) versions of existing infallible methods
>     (i.e. returning a `Result` instead of panicking).
> 
>     Since the standard library requires stable/unstable attributes,
>     these additions are annotated with:
> 
>         #[stable(feature = "kernel", since = "1.0.0")]
> 
>     Using "kernel" as the feature allows to have the additions
>     clearly marked. The "1.0.0" version is just a placeholder.
> 
>     (At the moment, only one is needed, but in the future more
>     fallible methods will be added).
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Matthew Bakhtiari <dev@mtbk.me>
> Signed-off-by: Matthew Bakhtiari <dev@mtbk.me>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
