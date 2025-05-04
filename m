Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAE0290F
	for <patches@lists.linux.dev>; Sun,  4 May 2025 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746385348; cv=none; b=slLIvGGF/1wH0f89jfAsAzUDBK3txBUPAWcROiEYfKUlrT58QZ6tl3jzUiYAWPzYF9+NlIrg2F3TLi9IIT2GfAipSdUjJYgb06xxevBZf+ihxQrq+Gp4C0QZpjAt4NjjBldBywy75IqR7wBMWQ4OvriVbP3a2+2VtLBRgWEIh0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746385348; c=relaxed/simple;
	bh=gWhqncYnT79JitMZOxQNY9LoBk9q4Nc/oFC/nBl8/SQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qek6i9dXEQJpCBmOS9tBoOUl/tabUBf47CHjS8tO8zEOJAjstQnzkeVKQ1Va3ihVcZWVrRu8Jmn9gF75ruQ2ThjlLblydivMDqAMwioio9uU+kpZsCNQhjMgFX1cxDjZk/Cxn9mxrE02I//gXR23sngwl99O9XEqCtVVpQkPPSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUJo/WW8; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUJo/WW8"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ff73032ac0so406771a91.3
        for <patches@lists.linux.dev>; Sun, 04 May 2025 12:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746385346; x=1746990146; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWhqncYnT79JitMZOxQNY9LoBk9q4Nc/oFC/nBl8/SQ=;
        b=GUJo/WW8XbEovQkXF6xaoTdXM52Tw5XqhS6cQqhTsA4FwTxeoo+YY5K5aO38+gp+Z0
         gB39SqRn93EREQOSA+MDWuZOl9Fg59h9eX2+TMqKx5jHW9wotBF8zDtDX8LaJNHRC1Ly
         eUeLe7HtNijO51OELmwShqBIWNtmMOVMze0xgsNnUZ5tTuh+MD4ulTY3hrZdjbJATrHf
         V54kP0YBm5WL/eeYjmuO46pK3PCGDNDS/ktaXLdCfcOhgukb+zb65k2+RNUfP2tNx0Gg
         SjJanBa0rHMB/zyDlfbLA6FBKMW51Pg5ld6oEYLxMOGfOl4nDAvVHcYtav18nk3WTiu8
         BqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746385346; x=1746990146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWhqncYnT79JitMZOxQNY9LoBk9q4Nc/oFC/nBl8/SQ=;
        b=KsQI96wtg2tSf3drMs+WHdxvep10SOuWikSZI28X8ac+/Prdi8Z9D3x2QdBltsvWO9
         fY0LY9z4ipvwsJM45K+6YNb9whqcPgqNUutEF316y9WSR6yy3onVa3Y2EEOb8g204tW5
         puttmDIofj0hSnGjQWAXebXs06aC7xkh1DQOzHtdb/doZwJCA3RydvUdBuHI7W0n60j8
         TpclUhV70WGIA4bPURbyQALK0moNbQQW/9bKVqD7Mt+4KIQa0FvoP/hpBuc5YY7iMVK2
         XJJuBabR7yciB+8L3x/Iac/L1kQrfG1csdT5x84SKkVsXkJCcNVaSa/E+6DnN8Nkmz0u
         P4SA==
X-Forwarded-Encrypted: i=1; AJvYcCVSti9ndagBbZBrPXxGmz8D5cyoz52kgbyABhHL5QnvNURYlBPU4bqX9t22IA9hPVx9pliwPgQ2@lists.linux.dev
X-Gm-Message-State: AOJu0YxGdcY9c0v2vIVzQJYhxMQSpcMoiTh1ZNFxOLkqdXy3X98oqPJ1
	yf+ZcTXi+xD07EfgXt+qY2sXG8G4AYZnZpAoTqXMT8OK84xgZwtsoLkSccgSn971Ic6zSQCpxpC
	4WqNA/0BaLIGhOz/7PnG0LSj1gpQ=
X-Gm-Gg: ASbGncvcJs+acVZxnuKjLP51VyH+kxS28ZJKrAi/WyTzkT9u5R9bLKkg2wp7obyEhOI
	Lactq2uFwLr7jIGH9VU15cTUPy6kCBFXDy94SBVm24f2jmiCWeroV99EjmZSWNO3ayeC53q5DOH
	DHd4a5RKMg1TEZT1KmIxbm8g==
X-Google-Smtp-Source: AGHT+IEO0raa8GkuuUNuEp7ZNefeofLseoaoOs06qtWnnjKYQ6iOYJix1qXEG05SOHHwbs5jqIqPiXaFuIPCWJpZQIU=
X-Received: by 2002:a17:90b:4b49:b0:2ff:4b7a:f0a4 with SMTP id
 98e67ed59e1d1-30a4e6c0e69mr5864090a91.3.1746385345937; Sun, 04 May 2025
 12:02:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-5-ojeda@kernel.org>
 <CAJ-ks9k=uxxumgEU84-54u8OxxJVBsUprGk7Ht31ndoumHB95w@mail.gmail.com>
 <CANiq72=Q_Vbfh6YhDsNeCBDPZ-q1d2HNfaTj4azAsd2Q-zPfEw@mail.gmail.com> <CAJ-ks9mAgR3N+cxL6H5XhAN-iWM=T66vuWr=LEozj8bqofBf6g@mail.gmail.com>
In-Reply-To: <CAJ-ks9mAgR3N+cxL6H5XhAN-iWM=T66vuWr=LEozj8bqofBf6g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 May 2025 21:02:11 +0200
X-Gm-Features: ATxdqUHa3BzmXCDKf-vPiiRQBie8yaB_bY4-x1_F18HdvVt9ZxcHIW-X1fAPluM
Message-ID: <CANiq72nQeHpZFk3KYGsgGO0Sh2TgV8T2z7Pahkijrgd=T64KYQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] rust: str: convert `rusttest` tests into KUnit
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 8:39=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> One example is https://github.com/torvalds/linux/blob/59c9ab3e8cc7f56cd65=
608f6e938b5ae96eb9cd2/tools/testing/radix-tree/xarray.c.
>
> It might be that these are necessary because the xarray tests don't
> use kunit, and so are pretty inconvenient to run. As you might have
> guessed, I discovered these host tests when my patch porting the
> xarray tests to kunit broke the host-side build :(

It can be useful to have some tests as independent userspace things
(i.e. outside KUnit-UML) to use other tooling on it, but I think for
such cases we would want to have a way to use the tests from userspace
without having to remove them from being KUnit tests too, since we
definitely want to test them in the actual kernel too.

David et al. can probably tell us more context, e.g. I may be missing
some plans on their side here. For instance, for Rust, we wanted to
eventually have a way to tag stuff as kernel vs. host etc., but that
is longer term.

Cheers,
Miguel
