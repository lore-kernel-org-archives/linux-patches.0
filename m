Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BC22C9A;
	Fri, 26 Jul 2024 07:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977516; cv=none; b=TrHJVaTL6zLs3AKhlYRaRNDnwkokETLbRPUVilRKEd9C6cPHLhkbbMFqGpCFbakgpMD8OSFTvVJg6g3t9S17xHD8QFG2aYfL0rU2T3OMLz3sCREPGVvFIbStSAXhuZAlBQCKiA752J6/UyhQYlevgE5BRyPeZrHL/nT0+mx3Oow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977516; c=relaxed/simple;
	bh=ml6HP+6LfD59Fkfz1qNcCtWxVdIfLHDonze6Pqk7QOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbKKdugsCnWbw0mmb3Lsasyl/yOswgkXJKlFYQK2R0LXDdIYvCwKAo9pAB7NACh0odeK73E7xmtzVyvLf4k5Qigow//V27tYadIwijTBumtg/TO3Xmb1JnOOrgjBr0HRuKDK8F5BKQyETbQkLacFI514B068TY26uDmhihxsXSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rOQD7OGF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rOQD7OGF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SrTVy4x1Acj+yuiVNbKqu99rXGrRGkIxeQTS8hcwktE=; b=rOQD7OGF5eqTc4LWb/NQqpGw5t
	SMNMAYLnaVAi4Cu9mkO5jCxK2FYQIZZdi2RHcf4RuCgRQ5mKKLhSoUMwYzmzH/ocRfmG3cPZXXVTd
	6ywgmI1OCvNBu2v/+rxBV85BdEak+uvoizNPKNsesVQhfZMMiSdk8cN0HALgj5gHcb466tS0UTuDf
	aftOAj766tG+NrXqAeyBl2DP++ru47WGpH8k/ULzluWTI67Q3h8HbZftnbc1Yrp7FBXz8VGHU5hHs
	0De0FygraCxW2wbv5cQ5iO6gMdoerBMl0yhMQSDm++f8TqiBu4TTe4A3A5YxtSSAz+w0G3uFAjUKH
	8StlGJvA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sXF0S-00000004AtA-1lJI;
	Fri, 26 Jul 2024 07:04:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5EDB630068B; Fri, 26 Jul 2024 09:04:47 +0200 (CEST)
Date: Fri, 26 Jul 2024 09:04:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 5/6] objtool/rust: list `noreturn` Rust functions
Message-ID: <20240726070447.GL13387@noisy.programming.kicks-ass.net>
References: <20240725183325.122827-1-ojeda@kernel.org>
 <20240725183325.122827-6-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725183325.122827-6-ojeda@kernel.org>

On Thu, Jul 25, 2024 at 08:33:22PM +0200, Miguel Ojeda wrote:
> Rust functions may be `noreturn` (i.e. diverging) by returning the
> "never" type, `!`, e.g.
> 
>     fn f() -> ! {
>         loop {}
>     }
> 
> Thus list the known `noreturn` functions to avoid such warnings.
> 
> Without this, `objtool` would complain if enabled for Rust, e.g.:
> 
>     rust/core.o: warning: objtool:
>     _R...9panic_fmt() falls through to next function _R...18panic_nounwind_fmt()
> 
>     rust/alloc.o: warning: objtool:
>     .text: unexpected end of section
> 
> In order to do so, we cannot match symbols' names exactly, for two
> reasons:
> 
>   - Rust mangling scheme [1] contains disambiguators [2] which we
>     cannot predict (e.g. they may vary depending on the compiler version).
> 
>     One possibility to solve this would be to parse v0 and ignore/zero
>     those before comparison.
> 
>   - Some of the diverging functions come from `core`, i.e. the Rust
>     standard library, which may change with each compiler version
>     since they are implementation details (e.g. `panic_internals`).
> 
> Thus, to workaround both issues, only part of the symbols are matched,
> instead of using the `NORETURN` macro in `noreturns.h`.
> 
> Ideally, just like for the C side, we should have a better solution. For
> instance, the compiler could give us the list via something like:
> 
>     $ rustc --emit=noreturns ...
> 
> Link: https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html [1]
> Link: https://doc.rust-lang.org/rustc/symbol-mangling/v0.html#disambiguator [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  tools/objtool/check.c     | 48 ++++++++++++++++++++++++++++++++++++++-
>  tools/objtool/noreturns.h |  2 ++
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 0a33d9195b7a..deace6fca2ed 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -177,6 +177,48 @@ static bool is_sibling_call(struct instruction *insn)
>  	return (is_static_jump(insn) && insn_call_dest(insn));
>  }
>  
> +/*
> + * Checks if a string ends with another.
> + */
> +static bool str_ends_with(const char *s, const char *sub)
> +{
> +	const int slen = strlen(s);
> +	const int sublen = strlen(sub);
> +
> +	if (sublen > slen)
> +		return 0;
> +
> +	return !memcmp(s + slen - sublen, sub, sublen);
> +}
> +
> +/*
> + * Checks if a function is a Rust "noreturn" one.
> + */
> +static bool is_rust_noreturn(const struct symbol *func)
> +{
> +	/*
> +	 * If it does not start with "_R", then it is not a Rust symbol.
> +	 */
> +	if (strncmp(func->name, "_R", 2))
> +		return false;
> +
> +	/*
> +	 * These are just heuristics -- we do not control the precise symbol
> +	 * name, due to the crate disambiguators (which depend on the compiler)
> +	 * as well as changes to the source code itself between versions (since
> +	 * these come from the Rust standard library).
> +	 */
> +	return str_ends_with(func->name, "_4core6option13unwrap_failed")			||
> +	       str_ends_with(func->name, "_4core6result13unwrap_failed")			||
> +	       str_ends_with(func->name, "_4core9panicking5panic")				||
> +	       str_ends_with(func->name, "_4core9panicking9panic_fmt")				||
> +	       str_ends_with(func->name, "_4core9panicking14panic_explicit")			||
> +	       str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
> +	       strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
> +	       (strstr(func->name, "_4core5slice5index24slice_") &&
> +		str_ends_with(func->name, "_fail"));
> +}
> +
>  /*
>   * This checks to see if the given function is a "noreturn" function.
>   *
> @@ -202,10 +244,14 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
>  	if (!func)
>  		return false;
>  
> -	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
> +	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
> +		if (is_rust_noreturn(func))
> +			return true;
> +
>  		for (i = 0; i < ARRAY_SIZE(global_noreturns); i++)
>  			if (!strcmp(func->name, global_noreturns[i]))
>  				return true;
> +	}
>  
>  	if (func->bind == STB_WEAK)
>  		return false;
> diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
> index 7ebf29c91184..82a001ac433b 100644
> --- a/tools/objtool/noreturns.h
> +++ b/tools/objtool/noreturns.h
> @@ -35,6 +35,8 @@ NORETURN(panic)
>  NORETURN(panic_smp_self_stop)
>  NORETURN(rest_init)
>  NORETURN(rewind_stack_and_make_dead)
> +NORETURN(rust_begin_unwind)
> +NORETURN(rust_helper_BUG)
>  NORETURN(sev_es_terminate)
>  NORETURN(snp_abort)
>  NORETURN(start_kernel)
> -- 
> 2.45.2
> 
