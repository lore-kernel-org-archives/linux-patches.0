Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6283D51C4A
	for <patches@lists.linux.dev>; Sun, 27 Oct 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730047417; cv=none; b=Cj8bssQxCMO2SLLFu3SiSQP3rOfAQBVn7tmFr4Z4QzzC99tLDZ2AR3MCRmYEW9krhUwdu2uUw+xMlmOvkwSdOBF6YJg5ylzA8bfDEnltbJ9meXnDcFF3ivbepVx0VCBJBaeTuYrtjQr0RPrcfVeWPp8OUCd7SsOkNTpo4jQe2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730047417; c=relaxed/simple;
	bh=FToPc9S3BvAs+olZK1wmHntHHxz0Ujj6LAuHXsJCEH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KZcjHll7pSp9NwiBVMKC7QkgY+FxI9QaVUS05ybq75ZBCMh1k/eRpzGLhiDcByAmq40M3WaAwT3fNQB4pri0xdlqp5NFiifCmzkcCT9rQOOTNQRyf2JsDSUAg17WqBMbG3i2VWDlmyHX/bBzsuzudkTGYAd1b4p7BLR2bZJ4maQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcUDEPcq; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcUDEPcq"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2d1b7bd57so593857a91.1
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730047415; x=1730652215; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FToPc9S3BvAs+olZK1wmHntHHxz0Ujj6LAuHXsJCEH0=;
        b=CcUDEPcq/6areoGyojD0oPho6Vp7zB6fG56ypkZAR5IPpYlHH1ASUOItUgtsLWZDKz
         MFIfMoMOhXOwITey5fGhkody+IJSUCk7qEKkZy4/kPQahWrOqyGJSc6DAe6kBDiOg9m1
         tqFpzPNosk2g0rnuaIkCoujikporEJ2PsVR7QwgcvLHSz/DryDyLTS2x12L+4+5FXHxw
         gI5b2vGzmfMN1XdEmJv28QIjpB/C1mmwSXPoHKoZxVwCtp6XVC24lE3ZdBxOUlEC0WDS
         Z30DcA3z76Ca6ZSUvJA7Qd6r5dBDhuer0zSueO0zHiUDwIh5xFGiBP3Fd4ivHfaaj7bR
         8CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730047415; x=1730652215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FToPc9S3BvAs+olZK1wmHntHHxz0Ujj6LAuHXsJCEH0=;
        b=NTT0Kt4LJVt2gUHg8oD5UsxVbMWueCp0ey/FB4qKZB4oqYHmdmatsOojMV6344xcb+
         hyKt5cieyaY5GYntluCrnLAO6jxNk3hKcE35MYh/w7SRy05ziFZJBV3R8Ypt6QiLQaDA
         7nER4zRUagkkK7UsQFLs0NFNKZT70pe3ZAHm5itQsiaXxisadJ1b1FNci/TLp1BmQSiy
         lyp2b0sxfez5L3Fmt3KkqAewwPpEXHUbUtfxoQza94I9/f528LsweC0WJRMggnX52Ub+
         QdKlkYpjS6EVOREG+U1b3U2FGLRYfr3g8v8Ie1CmZwpvkxZEO4dPsD1lNtSWUJAbUfY9
         Nj0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXX6Dp0s1PfaVUwaTixeogOA6qaeJOgXPv1OaC7YV1ewsKKUiDh0qzTu5FfTEkLTfW8INvZ/Br6@lists.linux.dev
X-Gm-Message-State: AOJu0YytCqaecFi7vGzW+PtmfhOZYlIFQEJTNiBYmYUJTsPS/V107Jet
	Xa0Z7xefZSDh769llVklGsah2ojto1a6tqypqrOuAiVAd1eYQIQXohJ3c0cKqlM4+kpVNp9DSSB
	239Rd05M2tfeIa1UlNQa0v6jxvy0=
X-Google-Smtp-Source: AGHT+IEt4zTtT+YS5nnZcPgirbh4CGz37SQraslG7OZG6knyttjYn/k8eYR3+m7M84T6Sg7AaLSrP4lE7JfHC6MZuUM=
X-Received: by 2002:a17:90b:3594:b0:2e2:9026:8bee with SMTP id
 98e67ed59e1d1-2e8f12e2bcamr2981552a91.9.1730047414685; Sun, 27 Oct 2024
 09:43:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241027145636.416030-1-ojeda@kernel.org>
In-Reply-To: <20241027145636.416030-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 27 Oct 2024 17:43:22 +0100
Message-ID: <CANiq72mAnkzDC+obtFt+i-x2_jkMpKgObJFURu-9ksT6tVHneQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid errors with old `rustc`s without LLVM
 patch version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thorsten Leemhuis <regressions@leemhuis.info>, 
	Cameron MacPherson <cameron.macpherson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 3:56=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus, instead, just make the match stricter.

The fix was very quickly confirmed by Cameron in bugzilla -- thanks!

Tested-by: Cameron MacPherson <cameron.macpherson@gmail.com>

Cheers,
Miguel
