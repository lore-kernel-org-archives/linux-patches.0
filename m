Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588F33EC
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92867C433C1;
	Tue, 27 Sep 2022 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664292422;
	bh=6v4Oqxr3Gg1DGJAp8ecODjIb6AxK0MJVn3dh8qzwnLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uJ/+V7PMj+dFdJBOuPQkF/a+vAHpeWhq/NssAVChneZvNbBsXXHMRlT2wxqNcL7FU
	 GyKU7JDD/uuN7WBWDMl5KQ2DqLKvDimdYhfsbUL+aVsYFn82zNxdFsJt0L8nI+cuUy
	 KmJGhbEVeenAZzYL8PIys6dNlcALv5DJct/9Xt1s=
Date: Tue, 27 Sep 2022 17:26:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v10 21/27] scripts: add `is_rust_module.sh`
Message-ID: <YzMWQx/WU/5h/SsA@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-22-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-22-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:52PM +0200, Miguel Ojeda wrote:
> From: Daniel Xu <dxu@dxuuu.xyz>
> 
> This script is used to detect whether a kernel module is written
> in Rust.
> 
> It will later be used to disable BTF generation on Rust modules as
> BTF does not yet support Rust.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/is_rust_module.sh | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100755 scripts/is_rust_module.sh

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
