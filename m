Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439F52D2382
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 10:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756893800; cv=none; b=GRZZhYXEYIVBr5+mlOQZ8iJfQdxN6ZpbuuRDWpV6oaRSFqSeVsNQqtATYdu7cCOENY89tuoL+JXUIEjFJUS2HD49P9C+qvCUyStqnN7E/W7Udeb58QIswLciHHvS0EMclD6BaucEpzzn1YVgjKPIu9Y7LEGsVoEKSqBW/GvCxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756893800; c=relaxed/simple;
	bh=0ZPxvE++kjDwbZXPjF0sDxxNrHcRHnaI9qILXHsLE2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdKsHUWb8KY5m3vy5cDNjMVcRo9Emx47b0FPYyBwDnJJqm6v7H7YCnPEBwRX51sDnTBR8/s/x38Sd6QgRIIMbpcxciH6NB9lm92YzViP2d/ORy9vqi8RwqISoHqqiPPYOmUAsZEWdwLbWdZuh+5S1gUIRkT7jVMsHj/ef3VNmC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhTTlIME; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhTTlIME"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2e8d14a5so362753b3a.1
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 03:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756893798; x=1757498598; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgbMRQUc5eRrRBiJK+N/XxrKzBvJ2dEhNy/lilwY3gg=;
        b=VhTTlIMEca+gjUvXbpJstzGMfnhX5uFym4uJYTojwZh+2U41xm562snI/Nbx7zv3iD
         jJZenrshoXiNInSir3JvUyCiYrCu8WK+1+HkqdM/EgxA3TmGgUNQjLdhZuWXrKund1j0
         0F9r4ZY49kP4Dp1Yd7PNGcZwLmRaUiXdSj/Vp266RjWjwiAOl+NW4swxCctSbLKIZ/Ih
         8LM0xfyV7BKacq79jqwcIsX3ZNGgbsK67+jny3HQui1xdfS7eiZGX0uLGdLbp1xJPIUc
         agfVa5gaTSvZnJO/X1Q24yGOJPKyJmqMtUGDwVD+0253nUYFeuK02rDOJLWH/LASeouj
         yRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756893798; x=1757498598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgbMRQUc5eRrRBiJK+N/XxrKzBvJ2dEhNy/lilwY3gg=;
        b=OCMx9w3nzJ3dAE2gGdDse7N9dvJ4N4Q6pS/zJR+edSwxuaXUpd9F4SkITsMPSL5WTG
         QZ/8p0nZa4GKRV5XHSbmo8OMXkYkG71KaV6A3TT3FBXvH0Xxk+P8lddErejO1OTlOonn
         WopA3+/gfI4S3L8Za+8mg5Zcn2zjDqK1ISLM22iu4vFAZVhL0HqYMOmQLFFNH9pyZMi6
         IZc3qLIpeSYjmxD1zdaMU5ykCbtF6XdZpPwYfbPcMiOVcdNPHbI4gLKCQAvSPW21pBYy
         IirQ1LmP3pJQA14Z2YKrWETsx+tjMcCMdIEwMQM1Q0XJuhdnmZA+iB5obeq1U8QrlqRC
         HNRw==
X-Forwarded-Encrypted: i=1; AJvYcCVWSM7d0lO3TBRVffqORBu0NQ+5AmDTCXlWWax25TT5dcTRey6On2LUmhENyc7m2JNF2QNLMNym@lists.linux.dev
X-Gm-Message-State: AOJu0YxJTblsJ/YA/pMVuzpgKBw6U5XphgCuCsitvVWqDiSiX/gBT0T4
	TLC3BkUtqjJZ+Wv2fCns0lSKR09hEx22Jhjx4oF7UBs4VJNgSCzbvGh0DUB/Qk/n0Dqiuy3kCgi
	1AAO49FUMUwsb5Vl+8V9tFiBF1GRSXTA=
X-Gm-Gg: ASbGncsYP95rLLYai2rT4XArgL53n5sN8xZoQagSC4HXPIBlSiR1mTNRBalr1hZclwH
	3dlvShC645kCjpRx3ArwNGofLrr+8ZD4GIk/UPzDYs1MVVogN2ADuxTvmkBLx7KWIHEA3pbM1GE
	W6ruNtH+4dCWnWDN406iBttUqS+86dVlf00FKLIPr6fVUfN0EBdSzB7rCkbuGYVhxPo+isEZh7I
	PKJN16EyaXribSOBkhwE7SSDLeLqvGXgIED91TbQHYlA98D69OoBkBHAiFVod93AnRHspYmcCwi
	DUg1dhUegq4TgHRiCDpHSv8ocyRmGN+mwowO
X-Google-Smtp-Source: AGHT+IF1drbJnXtfZZ8zYkcNWKkBm91s6BKPijOBEDVGIWtcvxdjKU4Tan7TbgcI5ovaMpvUsGr9yGVrgGP9Pwve9jw=
X-Received: by 2002:a17:90b:1e0f:b0:32b:7082:b4 with SMTP id
 98e67ed59e1d1-32b70820446mr500316a91.1.1756893798517; Wed, 03 Sep 2025
 03:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829192243.678079-1-ojeda@kernel.org> <20250829192243.678079-4-ojeda@kernel.org>
 <CANiq72k7_GbFwRxW5vikF_SpiNcNm7Ff0oe6jyYX_voDg92QFA@mail.gmail.com>
 <2025083032-barmaid-rising-a977@gregkh> <CANiq72nAagBBPhyU3XdETMKBuFPbMMRaSTStWPpyLnByYPP=+A@mail.gmail.com>
 <2025090325-drinking-illusion-ef3d@gregkh>
In-Reply-To: <2025090325-drinking-illusion-ef3d@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Sep 2025 12:03:06 +0200
X-Gm-Features: Ac12FXxbDdR4QPlJmACRMoGL91T5xgbMv2dg4TrsLcHw3W1mo3SjnyY3z7tN85A
Message-ID: <CANiq72n-R_NaMzWtYe3430RwOpOtmxb9KP7ee5FxV+AHXGA2+g@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with `debug_assert!`
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 11:46=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> There are no "constraints" only a definition of a vulnerability that we
> must follow.  And for that, any way that a user could cause a reboot or
> panic, without having root privileges, gets assigned a CVE.
>
> One exception being if lockdep or a few other "debugging only" options
> are enabled.  Those are explicitly stated by their maintainers that they
> should NEVER be enabled in a real system.  For those we do not assign
> CVEs as they should never be actually triggered by a user.
>
> So I don't know what to recommend here.  I strongly advise against
> adding code to the kernel that can cause users to reboot their boxes if
> they do something.  But hey, if developers want to do that, I'll gladly
> assign CVEs for when it happens :)

Sounds good to me, thanks.

These are meant to be debug assertions, so it should be fine. We can
be more explicit in the wording of the config option.

Cheers,
Miguel
