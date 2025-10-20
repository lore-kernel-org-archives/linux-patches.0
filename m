Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA9234C82A;
	Tue, 21 Oct 2025 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761067149; cv=none; b=HDMNTPKyXMa9u2lcnIxxPDdBezxUXplh2Z5IPJ6f4bRCot0AqHAeke0i1/U69iNJ9pNf3ksUCMCe+nAHY4ph1QSh9YUQ25rTsyxeiIUFC4CFYDpr9qvapL2Ws8cW4fi6myj1tpUlaqCateLb+zBcRm/5EMR1hEpJEc1E058Y0NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761067149; c=relaxed/simple;
	bh=APDtLhXblBwS9DQRReD0gd2A85Zk53l59rWi0MPQ0rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BG2Xfmiv1pdZvuAn93UWenrPRFAv/QAkAofCu9nIn+sS7F/DNbV4Z+kffc4APtri7lth5cpjOzYT+Nu2kqriooXrWK4+Wor40J5/SG/xzis/zhonAzQqafG+z6n/7uME53SP+hJKl0IzccQvZalvisGpbnmLWNqGoNAT8NdNzBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z+uBgZ0q; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z+uBgZ0q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QzchzrjP8FlIuKSYCzJ8pjq9HCBr1gD14zJzjcDAwDs=; b=Z+uBgZ0qsiHGtjo8dv8YdnexnA
	JasO0byS3J/dlOB9ulPFmIBg7VmhciiE+D6ghI94XCSEzZ3d9pR4fAwPsxMhMbO38FCNC0YB3M8VH
	pdqZJ8APAjVTCOLjSOfvXg9L/CHHyNybafQBnexilywkjRf5S0UNBJKi0W52C7MpdGH6ccpxlLBPg
	67fg0xZO0Noc2Og65nJTMPG6uLkpJuQwlCyazSzCeoC3VUi5GdmTLKQqVWUuHU4YWjmqW9dBaO2hd
	pMzttx1cf0+S6EleJkT8bqHmJzy/bwg1Mz4FKwSbhWIUZXNrOYP+HxXGZ0kbmDACqC6vnGnG94H0F
	UDbfek8A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBF8z-00000000tCI-2tgG;
	Tue, 21 Oct 2025 16:23:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A45FC3030BE; Mon, 20 Oct 2025 12:51:54 +0200 (CEST)
Date: Mon, 20 Oct 2025 12:51:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] objtool/rust: add one more `noreturn` Rust function
Message-ID: <20251020105154.GR3419281@noisy.programming.kicks-ass.net>
References: <20251020020714.2511718-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020020714.2511718-1-ojeda@kernel.org>

On Mon, Oct 20, 2025 at 04:07:14AM +0200, Miguel Ojeda wrote:
> Between Rust 1.79 and 1.86, under `CONFIG_RUST_KERNEL_DOCTESTS=y`,
> `objtool` may report:
> 
>     rust/doctests_kernel_generated.o: warning: objtool:
>     rust_doctest_kernel_alloc_kbox_rs_13() falls through to next
>     function rust_doctest_kernel_alloc_kvec_rs_0()
> 
> (as well as in rust_doctest_kernel_alloc_kvec_rs_0) due to calls to the
> `noreturn` symbol:
> 
>     core::option::expect_failed
> 
> from code added in commits 779db37373a3 ("rust: alloc: kvec: implement
> AsPageIter for VVec") and 671618432f46 ("rust: alloc: kbox: implement
> AsPageIter for VBox").
> 
> Thus add the mangled one to the list so that `objtool` knows it is
> actually `noreturn`.
> 
> This can be reproduced as well in other versions by tweaking the code,
> such as the latest stable Rust (1.90.0).
> 
> Stable does not have code that triggers this, but it could have it in
> the future. Downstream forks could too. Thus tag it for backport.
> 
> See commit 56d680dd23c3 ("objtool/rust: list `noreturn` Rust functions")
> for more details.
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later.
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  tools/objtool/check.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index a5770570b106..3c7ab910b189 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -217,6 +217,7 @@ static bool is_rust_noreturn(const struct symbol *func)
>  	 * these come from the Rust standard library).
>  	 */
>  	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
> +	       str_ends_with(func->name, "_4core6option13expect_failed")				||
>  	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
>  	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
>  	       str_ends_with(func->name, "_4core9panicking5panic")					||
> 

I'll go stick it in tip/objtool/core; but I gotta ask, where are we with
the toolchain support for noreturn?
