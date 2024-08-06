Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DCC15A86A;
	Tue,  6 Aug 2024 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722975752; cv=none; b=gwNmKve9g68pvAfs0CI3+p0lzskUaqawnXCPwpLrRn+tVkVYHq4Zvk3qUimCezvEn/hS6coDvxnW8TJADZcm2nOG/w/y1w4djYsmtmsrGZhGpx6YPvLTzQqYq3lja0zfJsPNhkPBFAEUDghY9Ftr4ZoFf4IXXkyyYXICNuNy/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722975752; c=relaxed/simple;
	bh=7hhuZPwCWoHDh3Nb7CXytQVbtXr4RcdwCtfyV4lINms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPLra0PkVV87X8LRouqRz5Wwl2hpAvqwke92sh7qS6Fd9dEwkCWRui1Mql2d40rZotF4vKrVbq83+v3Klexkk4YGrfa4QQKs076chlr4npyprNWpgEfCGAUR6wpUPWqrdEp/nJ1EYa0tkCZEkYyaQ0KvVx3ZiplxvwM73aPkiFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kw/mjlmf; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kw/mjlmf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MYybD5SLMzapCQO58foqsnf1cmmlW9Z2kDhawKVRCgc=; b=kw/mjlmfsBgOxvAcbF5ljB+5m5
	A4fE02YEbYBJ/iaZ203Be5LrhbmmwD6I6qMfkVBVeG2yvmKT32IElQ7zx1XqiFYt72zalLcHyExvr
	OC8o93b9/LhlN14KrzpSWoH4qSgHhdO+1pNiGnPzJoYJhrNJTNAsiMEV7c3G1uRvMB0yWgin2TfJT
	hsLVnTNwaX6u/9CDEwRaYkra82ME/upyNLPCKyrub0ZB598AiGfd1lb8CmHe3SrrIPj+GQwYyZRjv
	EKjIA/mZff93nYXungdkjQJxCZ5NFcek8JUS8P+BLn4mlneS85Ps3XZYPg9ZIDYqF+Lkh00Gitq7g
	MkQAso/A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbQhG-00000006DN5-0jkW;
	Tue, 06 Aug 2024 20:22:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1F91130066A; Tue,  6 Aug 2024 22:22:17 +0200 (CEST)
Date: Tue, 6 Aug 2024 22:22:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <kees@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
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
Message-ID: <20240806202217.GZ37996@noisy.programming.kicks-ass.net>
References: <20240725183325.122827-1-ojeda@kernel.org>
 <20240725183325.122827-6-ojeda@kernel.org>
 <202408061241.855CB28@keescook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202408061241.855CB28@keescook>

On Tue, Aug 06, 2024 at 12:42:41PM -0700, Kees Cook wrote:
> On Thu, Jul 25, 2024 at 08:33:22PM +0200, Miguel Ojeda wrote:
> > Rust functions may be `noreturn` (i.e. diverging) by returning the
> > "never" type, `!`, e.g.
> > 
> >     fn f() -> ! {
> >         loop {}
> >     }
> > 
> > Thus list the known `noreturn` functions to avoid such warnings.
> > 
> > Without this, `objtool` would complain if enabled for Rust, e.g.:
> > 
> >     rust/core.o: warning: objtool:
> >     _R...9panic_fmt() falls through to next function _R...18panic_nounwind_fmt()
> > 
> >     rust/alloc.o: warning: objtool:
> >     .text: unexpected end of section
> > 
> > In order to do so, we cannot match symbols' names exactly, for two
> > reasons:
> > 
> >   - Rust mangling scheme [1] contains disambiguators [2] which we
> >     cannot predict (e.g. they may vary depending on the compiler version).
> > 
> >     One possibility to solve this would be to parse v0 and ignore/zero
> >     those before comparison.
> > 
> >   - Some of the diverging functions come from `core`, i.e. the Rust
> >     standard library, which may change with each compiler version
> >     since they are implementation details (e.g. `panic_internals`).
> > 
> > Thus, to workaround both issues, only part of the symbols are matched,
> > instead of using the `NORETURN` macro in `noreturns.h`.
> > 
> > Ideally, just like for the C side, we should have a better solution. For
> > instance, the compiler could give us the list via something like:
> > 
> >     $ rustc --emit=noreturns ...
> 
> Yeah, having added noreturns to objtool myself a few times, it'd be nice
> to have a way to make these manual lists go away some day.

So it would be fairly simple to make objtool consume a magic section
emitted by the compiler.. I think we've asked the compiler folks for
that at some point even, but I don't have clear recollections.
