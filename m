Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C6922D795
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 02:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764297119; cv=none; b=aG8u666eBvIseXLvo5FkPbvvxJ9DD1joDKMPNs1+XAuUYIy7VQpARLiXX3eRTVPZ65g2EIbWiSj9WST28RWYRadBbnyH5kYcIwt+jSNABrt0rMjWaTqLLXcfzfN0aJMQSdLwlsox5nV6imfQR67NO0LykECfKA90F1sJPtkgOY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764297119; c=relaxed/simple;
	bh=IFpbffOusAAFvr8l9r6yDjVQw4lEG19XBmq3vDun92I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgHT1NMHrG5DNwjtvaqHvYQWAJANzrSeZeuaG3e4dyccuHu2Ljxij6yEjquarSJ2QANBIOOGEoqOinmow9RRxduHtCn+AjT96/8XU+tqoUHB3TmJrCJqPTbC0zJ9nGTxNrkpX3F46CU7RDY1K1Gh+QGddmrOj3aG7aX4cl3wnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFkdjFWE; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFkdjFWE"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640daf41b19so1829935d50.0
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 18:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764297116; x=1764901916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NrpZiMelpAfnsIkiCtzyTE49kXhH3oYDEt7KBJydAFI=;
        b=jFkdjFWELEVmLHu+7TS2l/S924fentZFSXoOfbUoRsZsas/DDS0ZtuIpFua3Re5Wdg
         cqXDFm0onqmmGLuUpuYMnnWRbOLAtqCPGSD8EeJhcKH/wvVQGX0LuRI5l4EUiij3WtKq
         jY8RsTaGiSiBN/NNMRmo8s6J/crh0IEjey02V72VPO/y0AidyvQASrGyNMwd3wwmlm7f
         CMCVEU6+Qyrabl9skuGfcK1ojmTVElYVlQyDuIDUd50s8px65OG9rPg/xAl4As4DaOdJ
         yYNR3H8llB+HPzvxolFmwo0XdiP8gvroS2HZxADCFDmkIpC1/OMPS5zBi9K1nJ4lj42G
         kG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764297116; x=1764901916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NrpZiMelpAfnsIkiCtzyTE49kXhH3oYDEt7KBJydAFI=;
        b=pDnuoueluibwFOLpmWdKkzpr33k1J4R1/wjL/aZrBOLilWe/paYCXu7syC1LZyiR0x
         2KqufzCw8YTWtULQOyJrzOSD+3axH5VVERWsSvuxrNjGkN20ohmZvvimPLpaT8msQpJJ
         iMwU0coTMOvlYYAQPLbx8mZzmmzXyn0Lbob2J3ug/fe6Yrj+VO0dTdDPEOV1XmoHC54W
         GUQqQUa2CVnYu5OUCjowZ6bm9aOoMO1iqyob2Kc5y2bAOEH4MBFhDa93T0Xegh6zgJ3q
         XksjBBGjdh45QAJ+1597f/0wbCtA3gFMgOfkllAwoLyYfWpHK2Up3PnUNwBxrK5lnpqD
         7mFA==
X-Forwarded-Encrypted: i=1; AJvYcCU8YwQe2jPej7Z9GmpCys6plJiYLXScnPC7nNz1y3PlAdYrO9wlDCWK0E77NEwBLy9TOr8ni189@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+7cjfcx02+y3Q70edcb9r8+KeFm5lz0vJiTpZRX7C49gYH8Ee
	RcsHxF8yw2ljQw5oMxO2EzQa/BmRRz+zMv6qiq6hQUcmZXpbEm8MF4W8
X-Gm-Gg: ASbGncuMtLQjqOFtFf4s2F1VUoDLRagtV25PwpOihTpZC6PMXNcWyGmYA1pCNllCoU0
	5zPJom5CwzgDb7K5Ka6lW1nMX9W4qjkluaTgqcR6tqWUGj/8PZf6emcGzOFOp6CiTFLgOtfkmtA
	V4n1xIwu5zO4l4JSRwEzN1qyTKNBvXZ6DniXgOrrYcJOdykOrzcgzUWO04v81pE34JeBvRF2ntz
	9ODei3auhwK9oHCbgN4aS2SLCayKWanZNUe7YGMxLsqZQXHwgWAfJ7IIu60Y1tIgkVgG8wc+6OJ
	77F6VwpVZFuDzvcL4MijeS/vRELfa+q3lPjQrsMLsAMBezaKm2gvTY/ho0pclvvFPBYfzAOtX2b
	4WGkxP9ptGZCWr36czv+Ttd3ou6/XWfcBpRJr055TapfTrWaBljvKv1beOb/agEZH4jBlutGBwY
	rMrzEsNAI=
X-Google-Smtp-Source: AGHT+IGsQsG7PRiJb7eAfz4ftwZpno+XvuGUcyUAKprNF7+YSwkgbokm6ADsOUlvVSxeFMNjEVusuw==
X-Received: by 2002:a05:690e:1482:b0:641:f5bc:6953 with SMTP id 956f58d0204a3-6430262febfmr17862768d50.36.1764297116199;
        Thu, 27 Nov 2025 18:31:56 -0800 (PST)
Received: from localhost ([2601:346:0:79bd:59d3:fad0:b7e5:396a])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6433c078297sm1065278d50.9.2025.11.27.18.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 18:31:55 -0800 (PST)
Date: Thu, 27 Nov 2025 21:31:54 -0500
From: Yury Norov <yury.norov@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Burak Emir <bqe@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>, Philip Li <philip.li@intel.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: id_pool: fix broken intra-doc link
Message-ID: <aSkJml0FI9KGdhUz@yury>
References: <20251127213340.180090-1-ojeda@kernel.org>
 <aSkFwsx-6Gu5Eu2a@yury>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSkFwsx-6Gu5Eu2a@yury>

+ Philip Li <philip.li@intel.com>
+ Yujie Liu <yujie.liu@intel.com>
+ Stephen Rothwell <sfr@canb.auug.org.au>

It seems, the below error wasn't caught by lkp, neither by linux-next.

Can you guys please consider adding rustdoc target in your testing
grid?

Thanks,
Yury

On Thu, Nov 27, 2025 at 09:15:31PM -0500, Yury Norov wrote:
> On Thu, Nov 27, 2025 at 10:33:40PM +0100, Miguel Ojeda wrote:
> > `rustdoc` detects a broken intra-doc link:
> > 
> >     error: unresolved link to `BitmapVec::NO_ALLOC_MAX_LEN`
> >        --> rust/kernel/id_pool.rs:100:31
> >         |
> >     100 |     /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
> >         |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `NO_ALLOC_MAX_LEN`
> >         |
> >         = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
> >         = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> > 
> > Thus fix it.
> > 
> > It was a missed rename in v5 of the patch series adding this [1].
> > 
> > Fixes: feb3fdf1239a ("rust: id_pool: do not supply starting capacity")
> > Link: https://lore.kernel.org/all/20251112-binder-bitmap-v5-0-8b9d7c7eca82@google.com/ [1]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> > I saw this in next-20251127.
> > 
> > I think using [`BitmapVec::MAX_INLINE_LEN`] is clearer in general,
> > especially for things in other modules, but I kept the same style as
> > other links in the file.
>  
> Thanks, added it on top of Alice's series. 
> 
> >  rust/kernel/id_pool.rs | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
> > index a4c37d6a0971..73a952d7dd83 100644
> > --- a/rust/kernel/id_pool.rs
> > +++ b/rust/kernel/id_pool.rs
> > @@ -95,9 +95,9 @@ pub fn realloc(&self, flags: Flags) -> Result<PoolResizer, AllocError> {
> >  impl IdPool {
> >      /// Constructs a new [`IdPool`].
> >      ///
> > -    /// The pool will have a capacity of [`NO_ALLOC_MAX_LEN`].
> > +    /// The pool will have a capacity of [`MAX_INLINE_LEN`].
> >      ///
> > -    /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
> > +    /// [`MAX_INLINE_LEN`]: BitmapVec::MAX_INLINE_LEN
> >      #[inline]
> >      pub fn new() -> Self {
> >          Self {
> > 
> > base-commit: a322638c15a678168aeb8dc11c8760f8a053124d
> > --
> > 2.52.0
