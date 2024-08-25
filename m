Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29048664C6
	for <patches@lists.linux.dev>; Sun, 25 Aug 2024 20:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724617337; cv=none; b=BF0CcdBGyIxJAmPACFhXU+VyEVeoPJjjYhAWJw1SFkCIpo3mOkydo+AdQjAsHH3TgzcRmTpnMCHYEpgOpJ2sl2mGSBcN8e19c7AA6EaqHDmmfn7jeU+j/rFPxnDbxs4jzC6uG4Bf4UNUProDIDLL/aoh7ILWeyomOCuDBOXClCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724617337; c=relaxed/simple;
	bh=GYSyNOK3k1Vwvu+qUM78Phh1+2YeSoxQg85u3iLzFEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SXV1B+LEnlbVRvx7H08CvFzCQ2jIfwUyhuN18vS8qOGbR5fel/H4Ky7lAGj9/Al+C40VXLGQ8apGR23gFSi8cQO+bXVQK27puxAjze5Qs+qjBQ8JVpQ5dJYjzAXE3HSbRykxudJuHbdchGKBUQ5rlq8ONQCMauFFOLxCh8baGtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jRwADrfW; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRwADrfW"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7cd894e2adfso580272a12.2
        for <patches@lists.linux.dev>; Sun, 25 Aug 2024 13:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724617335; x=1725222135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/YBMbb7bDw+tUfEn9ELV8y2Lwvjiv14mYFxssAzGRo=;
        b=jRwADrfWKaNlq8LRNs31GO6tA5BJ2EXLR02/dJ/vBR3G8TauBd1kGrH0SunqW2G1iW
         4999iwfFLo4jxn9Cr90lFJZ9ARXGcE0cLkCqFop3Cbh8Wc2dFcCvopioHLDPWP1CgVMs
         KWGPQLZqpOO2zS1K5e6Q9wf2HKEfd5+Zri5w7WjbZ06YLaNPakiExqRK2DyLyx4m0kto
         BFKV5P0DEuDAPYJ7wODlGGVIW2GjwkDUNURBBNLYD6DRz3wSzFXJHWIMPtJALGJX3JE/
         1i1o/afQZwGC0jvWyMBq0nm2HmQIfN5BA6Me6msSYZeAMXNB4C9WB+TcFAqdC58MmcEh
         Ufvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724617335; x=1725222135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/YBMbb7bDw+tUfEn9ELV8y2Lwvjiv14mYFxssAzGRo=;
        b=a3cJpzA7ZmeLpxluGdjyfsNx/cDlkXL5OdE7hRbz3VcCmvwz5HpgoViIPUZUeLs+nq
         NsjB/FfoNunM+5NqTwK+3tcJhb0CnkhezLrPpu4p1I4WW5qgFR52NzvC1LyOCWTbAdnY
         JpcAilLTvIC/fSJQPRDV8IneMDVlu5T6O417v3eN0zqq2mW2eUPPGVUTE0pcU1wpxxko
         vX7Y/thqb0SJaQFjXPdUz9Yt07f3+USMuihx8/PZFuIBLrT1jrDqRpvLoBlKhvfbLBDv
         iglhH05vq/FytILThEfn/FDCnGKxKUv0NyDXxQ3XjUME1z71oq+h35GvAVC/WzCIubzN
         +OyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzOTpHevU4GPBwZFxSRR4yFZ6853SK7/ncGvgs/GGrg/hDbEmVPcy/dFFQgx9/TmpRirPaTqN4@lists.linux.dev
X-Gm-Message-State: AOJu0YxpVkaQFjZh+kzoyoPreeQ5BN9cHxo2S3x21yO4aiYSs/Ehx7cC
	eFbTR/Bh0NItbodpMN+Aa83KgkIvMc/KO7dToRm1QoEa1P0zd7SDSNSM2+OqvvLfRpS3FZucS2A
	u5cBrqSvSoLNYanTQtzzdoJRJ6OE=
X-Google-Smtp-Source: AGHT+IHCmep9UepNduc+XY5Tzud3PFNGZ8xoRBKUCUNs9JGrOraBzt1yGvUVLlvm+mlvyPkNrStBGRCpiayAi7lCJI0=
X-Received: by 2002:a17:90a:ce97:b0:2d4:d74:ea4d with SMTP id
 98e67ed59e1d1-2d646dafd3fmr5964512a91.5.1724617335360; Sun, 25 Aug 2024
 13:22:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240818141200.386899-1-ojeda@kernel.org>
In-Reply-To: <20240818141200.386899-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 Aug 2024 22:22:02 +0200
Message-ID: <CANiq72=gTVwJmD8eW5Yoi=rROH4Kf45+0NLDVbG41xmTr+XKGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] docs: rust: link to https://rust.docs.kernel.org
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 18, 2024 at 4:12=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The Rust code documentation (i.e. `rustdoc`-generated docs) is now
> available at:
>
>     https://rust.docs.kernel.org
>
> Thus document it and remove the `TODO` line.
>
> The generation uses a particular kernel configuration, based on x86_64,
> which may get tweaked over time. Older tags, and how they are generated,
> may also change in the future. We may consider freezing them at some
> point, but for the moment, the content should not be considered immutable=
.
>
> Thanks Konstantin for the support setting it up!
>
> Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied series to `rust-next` -- thanks!

Cheers,
Miguel
