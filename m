Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105171C1F02
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 02:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764296134; cv=none; b=L0KqYUAtNwaIqBLY5AhpTnwO0mGT0qHRhVpgctNAy3hIXMI7VchDe5p82DnD6wEE1umvc4k0SeiMijprgIow8JrN9bh/SkukKzhjI+4RHuAEyLTb2+FeI2w15d8Z7YxmZG+8oKIyEqxGARdpaD37B+aMcyZohymFNsdt1goMLJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764296134; c=relaxed/simple;
	bh=P0GotVY454jdlemJ9Mif9MFDl5LNzfmtxmyVX17ZbmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzntNuqWm4wajMAPyMWozplhHmpulp3igBDlTIo7MvfODUAL7/1sf0Sv+vKG+wZL/oBY3upfLHaTG5w8hKAABVJXbbTGbhKr+/x1ES37gsIV4CBUraHon+5pZZTBeKgfN6GtiOso6S+9N4Ck99Nl0mbJGeqrCIN1OLHagWG2Tv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMuBDl9W; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMuBDl9W"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-640e065991dso1083077d50.3
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 18:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764296132; x=1764900932; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2CHLdpUp4Ssl7HkxIQWteLCgVD8+JnAniR+pC5eUNQ=;
        b=XMuBDl9W8qv/Et1elD/+t8/CnoI5JRK/1r409Gnzy4/USv3OO/Y+9jJVXaL9tFR334
         7ky7bXDB/mcKLidDWtrv1wieytgJFnrA6J0iSebNLO2oCzpymw84KgelvdtpICnqqynz
         urIQ4jruBToKVTAsTsq2oZ8IXJOdsRel8wWWrj5ne0OSZPDpR5VtSM89WRrlSvZsVdvj
         IFCaFRgs6In5+lfPITN3lJ6QUlWyvVzua03Beuz+l6EyYhnaQJ/+VL8J8xoUOE8CyuZ4
         YRVmG+NMx/uqfJMzEEtCHTguVhwXET7QUQ7U7vU74Z22COYBgVi8siiyLmauOwb5rozK
         4QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764296132; x=1764900932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2CHLdpUp4Ssl7HkxIQWteLCgVD8+JnAniR+pC5eUNQ=;
        b=MlKKHSJAKOmQmDzoUTxW7rwDcHWa0klZonaDAYJlydj2daA5ofZ4OQuRYiu7+aqMiJ
         nMrfC+JVGG3XOgHb2vHfZyoyvlY5+T3FKdfBZPzJ8dn7jx4THfXm9sRIfV9v6VbpiO4s
         PDn9nc0KbZB5k0QU74PGfKG+KqXapRUmNVK18H3N+HmuXP/l4kYJ7jRRvPYuPMo+Q0iE
         uNmDzrjdqhy7H6KeL7Yu6654oXtUZM6wDIhuJaOcbFP/OMWPteiaxrWs8w+OPgQ+gLsX
         Ze3ySm7JgEwFuzv0RxRfxxxC+AxKwClmSEkNtp91oBd5PharTeOuridxADJ2+wMkoLCv
         aOoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWobw5Elt/qMd9dY87z4Sd6MDP87XrqiGzgEkjtH9LjO9oJ6ZI4idLkVzoWjWi6J10+J9ULD4Q5@lists.linux.dev
X-Gm-Message-State: AOJu0Yygeypx6jZPLZLDBtvLXieAmhcnF/aPhA2I5i3RKaDTp3UPQZeg
	t9nifXK7ZgSnE8lYgmmBvvdfdbJfWk+hPdswTKD88tLtvSFrESsH6H8r
X-Gm-Gg: ASbGnct1e6WRNHgMlE1DR77tyBnRf9Hymok2GOqtKWSBdvBeBhQQM/fCQHMphbbdl8h
	8YoGTgotm5YINF4GiUq1GqucBayr/2FCy7UPxoXeDeoq5iRq84fJ6BcHRroYGhbwiydzZDiOLk1
	z2BTV+d+/msFwnpKn4iwXui3sgocQ7WKUeQPJXhDHiOixaYZCXO/htsrAcpJAoWEUX/eUN8pq+P
	EZ1qgHId56RIVeQmYbU/abYBc9px86+d1fSmBGEl2pD96D+zPGkCto7CjtvHm3c7EJlMsjg0bXj
	hRXDrJNa3ozooUELSRJKttND831zJDxVJN6devdWCW59b7BLUOWWKlhgUcDR+/dtyZEXUYJRvUP
	zAV9OqwVB726imvrCyBtiGvCQcJg4li7CdMEMFev6oeimm15WBkFa2WWkkzfWJmG9Sp9RlOQf2N
	c5Vx5tdhg=
X-Google-Smtp-Source: AGHT+IHnP7VicG6waOOzhu6TiR+B+K/9sG+saFcAMNFcFN/ea7k1BLVt9YbC7IMgWMjWFguUL7v5Qw==
X-Received: by 2002:a53:d68d:0:b0:641:f5bc:6980 with SMTP id 956f58d0204a3-64302ae4ef2mr14870221d50.76.1764296131954;
        Thu, 27 Nov 2025 18:15:31 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:59d3:fad0:b7e5:396a])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c050814sm1065368d50.5.2025.11.27.18.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 18:15:31 -0800 (PST)
Date: Thu, 27 Nov 2025 21:15:30 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Burak Emir <bqe@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: id_pool: fix broken intra-doc link
Message-ID: <aSkFwsx-6Gu5Eu2a@yury>
References: <20251127213340.180090-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127213340.180090-1-ojeda@kernel.org>

On Thu, Nov 27, 2025 at 10:33:40PM +0100, Miguel Ojeda wrote:
> `rustdoc` detects a broken intra-doc link:
> 
>     error: unresolved link to `BitmapVec::NO_ALLOC_MAX_LEN`
>        --> rust/kernel/id_pool.rs:100:31
>         |
>     100 |     /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
>         |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `NO_ALLOC_MAX_LEN`
>         |
>         = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> 
> Thus fix it.
> 
> It was a missed rename in v5 of the patch series adding this [1].
> 
> Fixes: feb3fdf1239a ("rust: id_pool: do not supply starting capacity")
> Link: https://lore.kernel.org/all/20251112-binder-bitmap-v5-0-8b9d7c7eca82@google.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> I saw this in next-20251127.
> 
> I think using [`BitmapVec::MAX_INLINE_LEN`] is clearer in general,
> especially for things in other modules, but I kept the same style as
> other links in the file.
 
Thanks, added it on top of Alice's series. 

>  rust/kernel/id_pool.rs | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
> index a4c37d6a0971..73a952d7dd83 100644
> --- a/rust/kernel/id_pool.rs
> +++ b/rust/kernel/id_pool.rs
> @@ -95,9 +95,9 @@ pub fn realloc(&self, flags: Flags) -> Result<PoolResizer, AllocError> {
>  impl IdPool {
>      /// Constructs a new [`IdPool`].
>      ///
> -    /// The pool will have a capacity of [`NO_ALLOC_MAX_LEN`].
> +    /// The pool will have a capacity of [`MAX_INLINE_LEN`].
>      ///
> -    /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
> +    /// [`MAX_INLINE_LEN`]: BitmapVec::MAX_INLINE_LEN
>      #[inline]
>      pub fn new() -> Self {
>          Self {
> 
> base-commit: a322638c15a678168aeb8dc11c8760f8a053124d
> --
> 2.52.0
