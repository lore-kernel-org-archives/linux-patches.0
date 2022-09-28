Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2DD23AF
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:32:05 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id h7so7697687wru.10
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=E7cXoL+OAINuYKkrN/dHEiq/+/562x8zxzlLQXZ+zL4=;
        b=skVKVFFMPlxSnl6b8fU8ypL75wee54Ef1ETjlQR7+vG+XcDynY3nptulRkdvzOuQAc
         ryEeuuyhpdmlbhjJrfQhFZrB5GedepUpxo08DmZZ22hplu7Yvwwa1TEF1VbBkKKNc21l
         9EMPYWxLpaCGPLouBijVT6SurpTvLKDfv40gvNBzVbuLtL8UzqB0Nscx2RqhD0Oigqra
         2wW2dAsTBfpgggEnEitZ8G/uxNiW3g1/o/y9lB1AHj0VKtMdnGaFTZrkQg10TY36ujz4
         NE5hEsIXi/8FZITSWhYH1xlnZ6Lq/GB3CAS8bKCtpPE4B72FV7j6qsrO/XuNVurDJarW
         Fayw==
X-Gm-Message-State: ACrzQf1T00v+j7IJ/M1UKOyiLQLXY+mStpSbP8VPgICqDTlf4hC6wC1R
	l1g48Lq5uHL/ts/HzLSpKWI=
X-Google-Smtp-Source: AMsMyM7SDIXEylyKoG9yE7AyA0r4afRknvFCOI0I0KfbpxFoJSX4zbK2LEhmLIh8dYTYfqEFEtDlNQ==
X-Received: by 2002:a05:6000:681:b0:22a:3007:df45 with SMTP id bo1-20020a056000068100b0022a3007df45mr20145418wrb.149.1664375524035;
        Wed, 28 Sep 2022 07:32:04 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r7-20020adfda47000000b0021e51c039c5sm4337350wrl.80.2022.09.28.07.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:32:03 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:32:01 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
Message-ID: <YzRa4U9iFMm0FAVf@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-26-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:56PM +0200, Miguel Ojeda wrote:
> Note that only x86_64 is covered and not all features nor mitigations
> are handled, but it is enough as a starting point and showcases
> the basics needed to add Rust support for a new architecture.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: David Gow <davidgow@google.com>
> Signed-off-by: David Gow <davidgow@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/rust/arch-support.rst |  1 +
>  arch/x86/Kconfig                    |  1 +
>  arch/x86/Makefile                   | 10 ++++++++++
>  scripts/generate_rust_target.rs     | 15 +++++++++++++--
>  4 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/rust/arch-support.rst b/Documentation/rust/arch-support.rst
> index 1152e0fbdad0..6982b63775da 100644
> --- a/Documentation/rust/arch-support.rst
> +++ b/Documentation/rust/arch-support.rst
> @@ -15,4 +15,5 @@ support corresponds to ``S`` values in the ``MAINTAINERS`` file.
>  ============  ================  ==============================================
>  Architecture  Level of support  Constraints
>  ============  ================  ==============================================
> +``x86``       Maintained        ``x86_64`` only.
>  ============  ================  ==============================================
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f9920f1341c8..3ca198742b10 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -257,6 +257,7 @@ config X86
>  	select HAVE_STATIC_CALL_INLINE		if HAVE_OBJTOOL
>  	select HAVE_PREEMPT_DYNAMIC_CALL
>  	select HAVE_RSEQ
> +	select HAVE_RUST			if X86_64
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_UACCESS_VALIDATION		if HAVE_OBJTOOL
>  	select HAVE_UNSTABLE_SCHED_CLOCK
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index bafbd905e6e7..2d7e640674c6 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -68,6 +68,7 @@ export BITS
>  #    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383
>  #
>  KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
> +KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2

I do wonder how many more things you will need to list here. As far as
I can tell there is also other avx512* flags for the x86_64 target.

That said, if this works today ...

Reviewed-by: Wei Liu <wei.liu@kernel.org>
