Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5666D2596
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC84C433D6;
	Tue, 27 Sep 2022 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664290951;
	bh=zUFmvTnUhtwo4Fi1w19nPQ98b7sF43egGphu3D2caOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g1PGxztspiNyb9AIDQ6kl2vzsJW4pZhWmBBo157w2b+j4dVlOdjfU/VpVoxgrgfHo
	 g/BN4XTO2AveMEBZj9blH1TlZCbV46O1o15EJwdMQM39l843j7h644fXibl84hdBpG
	 huBgBlgPSL4ktV7P1bFhf1zyxCDmbMkw1jsBxfb0=
Date: Tue, 27 Sep 2022 17:02:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>
Subject: Re: [PATCH v10 17/27] scripts: decode_stacktrace: demangle Rust
 symbols
Message-ID: <YzMQhGRr7EfKJeQZ@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-18-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-18-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:48PM +0200, Miguel Ojeda wrote:
> Recent versions of both Binutils (`c++filt`) and LLVM (`llvm-cxxfilt`)
> provide Rust v0 mangling support.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/decode_stacktrace.sh | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
