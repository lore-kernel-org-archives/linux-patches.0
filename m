Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F728185B73
	for <patches@lists.linux.dev>; Sun, 13 Apr 2025 22:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744583093; cv=none; b=HedwVYi+olRJ9S7gMKII/p8Uy/5bQscqkZgGrQla/9pbi3Nddndp/eufgKxTINz6m3w4Jw4hnDJvskNw0L0OaAvyJGzfOblFZGTOqmu9V8b4kFhUjb6IEotfs+bxk+Ti9FUBhMD4p5JvfpITW95Ve096sNt38PRIvjfOdeFz7lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744583093; c=relaxed/simple;
	bh=zFhWszMXgcrrhbxro47Xom7wsLkxxg0I4+qRejGxZ4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bpY8TF9uMCb+Dnjjq/m2a/rvJwNPuO2iKuJb2b4CQ41bgOqvIztHnXHHPL/h8P3dlBIdo9GTuubdp1le/DFkNsbaz+2HjAfOJowOGAs88K5sNXknvi1EtjhGNMX/wHtQvn8C9swKQCpEIo4GxmQyRcUt6osmZQYSuHkgtI237RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THYdfh7l; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THYdfh7l"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-301a6347494so741484a91.3
        for <patches@lists.linux.dev>; Sun, 13 Apr 2025 15:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744583091; x=1745187891; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFhWszMXgcrrhbxro47Xom7wsLkxxg0I4+qRejGxZ4o=;
        b=THYdfh7l875G7UeZDjrL4blxFbszP+X2aLxL3sXkVkwrBwI0PLYhvVQRwmbxS2PnCb
         Mcw/qcMpH9Qakwq0LqpKk0c+3SdzADzGGrdsNdWUsyCUaAfBOUfMZXF3IGCLGwdSWwqo
         nfo+I7xuwW4hNJKmY+3CTkxPqsBcLqv3GO3/pBsS2hQFFbNBbyi2YADpTsFOZySXkkxm
         YgwH6kJXMJa24lDXKdk8V8HTLdGMGqEqhqUzUh4YOamYbsBOdXO6lwl4B2IQeo2vlcWv
         d2FfkFiap5k3xSJMs1S0Iph19pkieozT27iSgnGyxVKQIQ7g9iXFtgVczKuIe2pKfkxR
         w9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744583091; x=1745187891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFhWszMXgcrrhbxro47Xom7wsLkxxg0I4+qRejGxZ4o=;
        b=AduoZN2/HBT0zHk/YcVzcYL7jUdJLoSh5dQZ48tkU2j/DFIpx2M25d4Q8xuWvZRopT
         7ff7pV6z/Rl+MfBYVeBJLuQYxSQqh9F4J4HCHB8uziDfKdHxP5kd6xlcR7Logdht7KyS
         eqIejQsZMCbtXAfftQnf4Autkox+4Y/T6xGtuR8Bf8yHqxHqM9gyKTB516tY4dXwwz1r
         t9ny73AtqGl5wHgaUCKeoOH5/TUtyQElC/Daj1ZKgyqNbZA58GgcvIZJm4ceGV8fLx2a
         ifAnMzkHS7J+Dv2OQK94zoE/XMS8Gd6G7EGzlNiXplOZM8C+ny//qQHHm9PTwoMvSbot
         HhRg==
X-Forwarded-Encrypted: i=1; AJvYcCXY2WaSAAhXeGw6m3VTIYyejXizXWgwYn6cl6FF5IoT/pPYa7kjszac5yipIIB0gIVgVqzUNeE0@lists.linux.dev
X-Gm-Message-State: AOJu0YxoNFz13nLBPrLxzZP53IcRRtBtCoGFO77JORwWk/RNhwmmqnyh
	Ay3P5wcD7egYRaArr8bj2PiH8TOVd2IzryH22BN6tOLjBZsKoUNEs9lNJhIdOqYq/ZowLpJ1FJS
	F6hrYjLoJwtegNYnLvexwblieygE=
X-Gm-Gg: ASbGncvnI0oEYchL0asU+CETGzUto7vyL9bPIns72GiOhbHW9juHaU9VA+DjPpTo4rO
	ORsnSSWQnx8CBD6SrVw94sMaUoFJ1HcEC/LJ2MBmbtx2M2DRj5R5/9+Dl2VF1DW5l+fZQzt0nfp
	pBNggv3HCoi7Jh26wTavKCeA==
X-Google-Smtp-Source: AGHT+IG/LchdQKMox22QGMHkIWwBwPyMFHqfgkcpLRiUpZjH6w3oFEuC/XhSYgZH5QECaauRKtTcSLIWVzEWcqpeoa4=
X-Received: by 2002:a17:90b:4a89:b0:2ff:78dd:2875 with SMTP id
 98e67ed59e1d1-3082378c78fmr5674698a91.5.1744583091360; Sun, 13 Apr 2025
 15:24:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org>
In-Reply-To: <20250408220311.1033475-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Apr 2025 00:24:39 +0200
X-Gm-Features: ATxdqUHU76_51ZQ1TnRtKTvt1ZG1eN1xA3kopPBEH1n6HKtgRxWv-zmZkdx8n_g
Message-ID: <CANiq72mxi7_RXCzEmWeLYs5x0Dy9j8BNYTA1ZSZ-8=yJFrfMyw@mail.gmail.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Matthew Maurer <mmaurer@google.com>, Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 12:03=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus filter out the target.

Applied to `rust-fixes` -- thanks everyone!

I am applying this one fairly quickly, to start to get wider testing,
but it would be nice to get some tags, so I am happy to rebase to add
them for the next day or two.

Cheers,
Miguel
