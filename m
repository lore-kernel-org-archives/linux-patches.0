Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25918306B;
	Thu, 25 Jul 2024 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721896461; cv=none; b=pOlnXxlgRsr+9vB+kRsTkKkTYlqCGXfuasxfHORwjHgR884jIAZoTZaW3lGPK2D8qhMKgwZHdlWrjmfmYlYV3kiubM7O57Va9TkJtHWMK+OxZnducVOEwlDQA33VOPGuVxyhxtNMifhivy4nXYEH2v9gl8mYKfzn+4ZOFQf+hKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721896461; c=relaxed/simple;
	bh=CYUCSCiQT6qMGLB1JGeosw7d/cfIvnQ6FkH4y6K83xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A38DDquCwGj1EZ62ystR2hpKfhf0M/EDE8Cdii8g03lWGW3Xtrx+3/0VtQyCKTyVf9DqpixpWm/4cmSd5zWYQ4T1GOW60bnZzTB+SeY2HmCdmUO3Dzv2ZvDlbIPm5GgCC5x0VN0u8Uq1cQgjkJHg/u8jigdrQuQsmMoqFzvhztI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sn+bn/RV; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sn+bn/RV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xwTaVS9IfoHYCFep7H/k6tGK/UXSddcW1U+BOJy+gcg=; b=Sn+bn/RVOIJrm5WNdtSg/ucRDJ
	teM7hWACXY6wg8bCIpoTEIcWmM7wi1Zu7G+n2QNjjBIbkwtkW4vlWlh7w7MB8MtmdwZccAxDTuFLj
	H66D71fcZNGI/sPd5ivUq+O4Qeeg9I0TvXId9H9Du2LsiU6hdOSKa2rG0RfBVSP3c3fqqDvStqx+9
	C5Ta/JoUASoEsV223N7XaHxfNvmIFGNzt5tYVBzvgk5qs/l/Y2I2wm1n0FkZ4xg0uUlKLAa6xZwI+
	sssPqAQiCF5qh34GXP3JaV9ryHh1/cJ8aA9nIAQkPxiu6lxSxQuMYP+p9ASMc/0y74bAiBEpOGES9
	ioOeHa0Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWtvA-00000003yHl-14ck;
	Thu, 25 Jul 2024 08:33:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 44C1D300310; Thu, 25 Jul 2024 10:33:55 +0200 (CEST)
Date: Thu, 25 Jul 2024 10:33:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gary Guo <gary@garyguo.net>
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
	Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 5/6] objtool: list `noreturn` Rust functions
Message-ID: <20240725083355.GD13387@noisy.programming.kicks-ass.net>
References: <20240724161501.1319115-1-ojeda@kernel.org>
 <20240724161501.1319115-6-ojeda@kernel.org>
 <20240724203549.2db3e36f.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724203549.2db3e36f.gary@garyguo.net>

On Wed, Jul 24, 2024 at 08:35:49PM +0100, Gary Guo wrote:
> > @@ -202,10 +216,30 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
> >  	if (!func)
> >  		return false;
> > 
> > -	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
> > +	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
> > +		/*
> > +		 * Rust standard library functions.
> > +		 *
> > +		 * These are just heuristics -- we do not control the precise symbol
> > +		 * name, due to the crate disambiguators (which depend on the compiler)
> > +		 * as well as changes to the source code itself between versions.
> > +		 */
> > +		if (!strncmp(func->name, "_R", 2) &&
> > +		    (str_ends_with(func->name, "_4core6option13unwrap_failed")			||
> > +		     str_ends_with(func->name, "_4core6result13unwrap_failed")			||
> > +		     str_ends_with(func->name, "_4core9panicking5panic")			||
> > +		     str_ends_with(func->name, "_4core9panicking9panic_fmt")			||
> > +		     str_ends_with(func->name, "_4core9panicking14panic_explicit")		||
> > +		     str_ends_with(func->name, "_4core9panicking18panic_bounds_check")		||
> > +		     strstr(func->name, "_4core9panicking11panic_const24panic_const_")		||
> > +		     (strstr(func->name, "_4core5slice5index24slice_") &&
> > +		      str_ends_with(func->name, "_fail"))))
> > +			return true;
> > +

Perhaps add a helper function: is_rust_noreturn() or somesuch.

> I wonder if we should use dwarf for this. There's DW_AT_noreturn which
> tells us exactly what we want. This would also remove the need for the
> hardcoded C symbol list. I do recognise that debug info is not required
> for objtool though...

I think the slightly longer term plan here was to have noreturn.h
generated from a DWARF build but still included verbatim in the objtool
source, such that it works even on regular builds.

(and can be augmented where the compilers are being 'funny')

It's just that nobody has had time to implement this... you fancy giving
this a stab?
