Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D323906A
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743607679; cv=none; b=MLZ0pR0q/tjRtxcdhJg3fOHkLRFEW/Q96iml2iNI2vSnMp0MLs8hwCDHy81bqmRaLy3eDLiU8uEvnLg09XkHDPspde49p2xwG4ZeTEy3MBVuhUY4NZLdnWfF800mE2PoS88IfL3esemWi59oY1spo3ZxS30F4L/I2wpeGHWfNE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743607679; c=relaxed/simple;
	bh=84wxmOUuZguUPHRF2Z+/DPs+bRzIW2iV+gP7Vzph/AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DGZR/95yF+vBQlY/LDvNNFKUm5FAt6WneVFhmfVyVqPqSs96/xORz7kQ63m8Zva0iSh+X1YzAaBzdzpQNSWYmLGLt0eui3kbFeZu9BEwCQNtldhRBjmwHslhlntpSxmaR45jgEUFJExW2h3ACSVGWI7N8vR0bAJGejSdjsNB4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EenGpvo/; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EenGpvo/"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-301b4f97cc1so1575134a91.2
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 08:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743607677; x=1744212477; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84wxmOUuZguUPHRF2Z+/DPs+bRzIW2iV+gP7Vzph/AE=;
        b=EenGpvo/yxrdhVXvOUwrsNymFq/jCTktlOaKTDad6JzrKzr7883MBl0YuaupxsI80F
         J5FpdP0BwMOmE/2y33DhjrzvHI9dUoq8DesgTtXPM84ILAqsTGWLZzs78UwaxrNbK5tK
         8ENY63FsqtjW+bjepsuKSvyL5WtWr4BkAY9D2nV5EuQf0z4LseUPn6cAKGa9m2C2zRPT
         1M58eZh+JGSLdI4bQ4TdDAl7E5hmxl224tDpcwMixTJbmKOJk64nb21mefKYjiaxMXEo
         +6Ej8WdMMR5dOZXg/vLmnb1UIXN2tYVrothTEzrhBtREAK4aWy45kBi0I5NkqinW3A6g
         MPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743607677; x=1744212477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84wxmOUuZguUPHRF2Z+/DPs+bRzIW2iV+gP7Vzph/AE=;
        b=t47c/nS1JwwOu0/QYXsvsaMibZZu61hN3Wy8KAkAe0jm1MdkkGhJTJ6WTri9KIiOid
         evLjZpB89paUkEyRWSM2xUAOiEvAuaKj704rgHSd+4wIvUKw+tgHPaPl2UM8j1iMNbaw
         ZnIcMwWdhHEJeQ3nI/JUxj7lclziGQJS2wKUwOPd+W7SOyYApZxbz46gqwmyZ+IxULV3
         9UTKUU5MNJ0mlzc1C1G+Okxu4T7A0fvi0EaYewWCm9QB5SlWRIkYynExy7M8hCXlLHlu
         4XQ+s3yq3llVq45YsikgFMHbK/tH75qkq/2IMcwDu548W1IqghJeLeDzvCgkjH+V5Ezp
         FEQw==
X-Forwarded-Encrypted: i=1; AJvYcCUAerTS0LhjNjvNDeM2GVLgYGAwSLqlywnfEHUiOH3likJePrt1aRx4XuJNGFmGEeQv3AqsU0vq@lists.linux.dev
X-Gm-Message-State: AOJu0YwreTm8nCidoD9YXZIZfTVw2tAreNszJ5VsKUNzRN6QE3bVifBq
	ebL1wB21ovJPxiUJgV3zyQLNb58iLTiWY1vAKRpw4KLYvP40vMyNXp5qqQJPP1AJabxIQcllzR+
	1EKKPmbNdLbaAWhlqP/pce5Gi6ww=
X-Gm-Gg: ASbGncus3yqgpDSDmHxgLy2dsW2OE6z8IW6G6ukxjl57E5LXOIYANhGnnB/XCqRtaaX
	rvQCvv1M2yfYNeKpNenMaExVBU8DYFhHZ6Bp8JAnilqP7t4qnLs3Suluw61qBEwaLWTSCDshy2o
	UvSFV1R031L9I1T3739LZxjbHgzQ==
X-Google-Smtp-Source: AGHT+IFgu8WJu4ETgzkoPIm09BkqQZYs+/o4m6q+OoOBxfa6QeCI+cNBBW7zBSkFSqOaR/bzrCPSWdOOUKW+krWRqlY=
X-Received: by 2002:a17:90b:4ad2:b0:2ee:acea:9ec4 with SMTP id
 98e67ed59e1d1-30562e636b7mr3562139a91.3.1743607677054; Wed, 02 Apr 2025
 08:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com> <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
In-Reply-To: <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Apr 2025 17:27:43 +0200
X-Gm-Features: AQ5f1JoRtbxlEpwdukshR1-PkgSkh2vofg1jzjX7AuGCKpYamwkZP-wPM1fWZQo
Message-ID: <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Tamir Duberstein <tamird@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 3:59=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> Rather than disabling globally, why not `#[expect]` these instances
> with a reason?

That is an option sometimes, yeah, but in this case, writing those
lines is also a burden -- one that is, I would say, worse than just
using `()`.

It would also need to be `allow` here, not `expect`, because older
versions do not complain, which makes it even worse...

So it is all about what a lint gives us in exchange of those false
positives, and about how much time people would need to spend on it. I
have always supported adding lints (I think I added this one, long
ago, in fact), but I don't want that we overdo it either, so I am
happy disabling it if it is going to be too painful.

Cheers,
Miguel
