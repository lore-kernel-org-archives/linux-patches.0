Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FD61FE461
	for <patches@lists.linux.dev>; Wed, 28 May 2025 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748419402; cv=none; b=IhKiXRvFBurBshzwrXwxZJ3XBHNsZdzNSX9FXlZu8QsGlEN0P8xCoGj1ujnmE5OUf/0EW+M24gC+IE6nRnYlwS3rtcFCYlQRu61wUV0fBUhRlDMV1q5F2zAMKYqqbo85Nu6Qde8FCfPsDBS7EuytNiMnsQzFJjUAlTV+8Y1qwvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748419402; c=relaxed/simple;
	bh=m1AgbkSD9ZhqsKYGnxQT5QuWasbz/mdwKFB3lNLS1o0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6P4hJOyZZlYzlMBLJorBSHOk8hSDS2BQv1L+7lkKV5/L1gJIrGOsEpR0wcAqNfLB4pUpH2dKAL0ZZQk87d7kjFpY8al4SYWOyd6nLzpyHNNfvcrXgczEaaXg8UaGVPZRjmkawB+HiNWIN/Pjdc0/JOGoiWgT089UFemSWWBWWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lq7qdmmH; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lq7qdmmH"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-30e5438316bso302387a91.1
        for <patches@lists.linux.dev>; Wed, 28 May 2025 01:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748419400; x=1749024200; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EOwFLOIjUGE9rMIYijxRVcus8CYn2cGLNdJL9ka6c0=;
        b=Lq7qdmmHmy0ohGNJckKoNoTU+VUAsVof88owu5AQXx1+3lv4DPpAiE4bv/Muo0qrAE
         PopSPY8SD6878xLdo9YhCM3sG5L/UTzlyRwxpJ0XL9lZpDogho6WEnJKLYaXQg90buO6
         V0Y8UtnGSL3+S+RJBw53nQGn1PDQG5VZR6CdcVfdHf8NDzHdGlIetE+YcXwDAQu0dvOS
         fLRYS36sPLhJC4ph5b57A8rI/P/Oj5nMdslj53973gQ8N+zhWsFsoN+73WyBErRwRmxa
         H1Wk1HC9Z0s9k1TYYQmSiWVAg8EnFx2WWlwQLPMG9cPBoOmfk+m9zxp3bNwFMlAebXLy
         nM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748419400; x=1749024200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EOwFLOIjUGE9rMIYijxRVcus8CYn2cGLNdJL9ka6c0=;
        b=WcoPdUFIrf8gF+j2o3r7afTsSltruPgfPSNnKh6LsvKVPY+PzDv11hguNFsF6BMsYM
         0y6DnRg7Ife2/j6kVqhLIFYNd9UFVRfVUE7dN+j9+wxxxuNuPhaVYvSLbcysoiGNuEnw
         1PFeMprc5yynu7bKfw2xjSvjHLaSZmFcX6x5zSG7quiWjq7tfR2LtX1+q8mX/0Q8B14Y
         nqNT7aGuvuOVsAM04wpzA3Nx1Ov4UL3vDhn93wIQh0D7Y/+MXez/6yJQ8rVsjg20QoJi
         sJ51bM+EE7LC0qH5FN6jccNqvaJj4cwe1eU50as6Xh+j6+L7pyzWTp3OE8fq1WNGp8lF
         r/mg==
X-Forwarded-Encrypted: i=1; AJvYcCWPtuU0BLT42Yp6XpbRApiVoKzF6w4hY5OnADm/J1WN5fjqLj3GSLPNGsn2r6PFCJPeWzJGXMp9@lists.linux.dev
X-Gm-Message-State: AOJu0Yydwn/SafMZxmSEB4dA5GGDTZaHZ/rX6yOvhYWJW8eD/qoyAive
	yNTaqKIsLR+JGpPrJa/S9aSPsC6fK3YPEwdqvx0Ur2NN3biMig3RqFCCakc7bjeYEvN08uTD+Uw
	DKsdozArZLgjoOkOXvrLRwAUarCrYl7s=
X-Gm-Gg: ASbGncvhHdzdzmAGlxKAe4vmbobQgntCVUAxoI0/nQt7Wr2Al+vN3TGKAMk+eKZBQnw
	P5VlaTRmb+Tc2qj2QMJA7LWPCLMF+Hdzo6EuIzQQEeyg2NrjaP3Glac45PhuNzkEvq+nZap22Oh
	wDmKC83wA2TdpjTywQY2ESmIwHk82FDG5p
X-Google-Smtp-Source: AGHT+IEiwicS/q9RUO/V8KuNVVyWFDIAjAK2Mnb5ZiQ/pv0ORt4DIc9nszJacBNbGZrUZagNVQ3qcC1eIdODchfFkbQ=
X-Received: by 2002:a17:90b:1b4b:b0:311:e8cc:424b with SMTP id
 98e67ed59e1d1-311e8cc4639mr847651a91.5.1748419400178; Wed, 28 May 2025
 01:03:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <CANiq72mj2yv4E7Dd+19fmP9xGWELdv6JwXULpu91oq0BMzob+g@mail.gmail.com>
In-Reply-To: <CANiq72mj2yv4E7Dd+19fmP9xGWELdv6JwXULpu91oq0BMzob+g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 May 2025 10:03:07 +0200
X-Gm-Features: AX0GCFvKE0fCOzzRb6dIal5zXh6Jr2moZJDyfrK-nCJ7S0wGurEFElmTeo_tH7w
Message-ID: <CANiq72m2vnoagiFBU81L=Z=AXa--+Sz-Q8OKcv-++mXvRu__mA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Rust KUnit `#[test]` support improvements
To: Miguel Ojeda <ojeda@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 2:10=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
>     [ Used the `cfg_attr` from the TODO comment and clarified its comment
>       now that the stabilization is in beta and thus quite likely stable
>       in Rust 1.88.0. Simplified the `new_body` code by introducing a new
>       variable. Added `#[allow(clippy::incompatible_msrv)]`. - Miguel ]

One addition:

    Required `KUNIT=3Dy` like for doctests.

The build error was reported by Stephen when merging -- thanks!

Cheers,
Miguel
