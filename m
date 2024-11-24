Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AA1714AC
	for <patches@lists.linux.dev>; Sun, 24 Nov 2024 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732492572; cv=none; b=hEyjdVwqGGrYtnH77f4DcIWbWemC51v40/qedvoVbV4VJiGVDK9x6DO79F7jhGX5XiVeLRSNqgXECj8fxcqPVzE464A829Aq0pqNnILG5rpkY8JBTu/QFTfNj7S3a69Xk37hbETxJ3VLcpAZrpPwsblA9b0n3tG+cDlxax25/BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732492572; c=relaxed/simple;
	bh=BEcuvNrj8JDYTsw68D9XSc1FNx/lPzGaINUfsEXci2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZ3ZhIiHv64AZSezf/hzgZ99amAHekG6AOUb3ChG3ym7QdGzFJZEf+fd3/5mRIrYes18LtrPCuRPMKa9kOcmMTkDGbkLTUOr3fVFOFApJFCTRO2ZTcQXo605sdxVka1/MqnMFNb2Yp3pAcUmK7wcu47/+Qr+Mvd6OEkFwCPxMtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qdz23F+F; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qdz23F+F"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ea704b1c2bso650840a91.1
        for <patches@lists.linux.dev>; Sun, 24 Nov 2024 15:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732492571; x=1733097371; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEcuvNrj8JDYTsw68D9XSc1FNx/lPzGaINUfsEXci2w=;
        b=Qdz23F+F8JxOwt+rT47ct5SKNcjTu/OP2P6LAmPPbhGBQffyzJusATmD75fZ32MYcS
         VoMRTiMqjHzc3G0tPlJMxI7MZ/uBtcuA/BfmtMsjltgnLt1U66/3DBQjfcGWrVpW1U6d
         PzIT+KZVHMWjWCl5fmlFQd3toi5bXkGoRUEkiZWsexJ+FHJ+vNlpZYxPvu3eMxIac56P
         jaBxlmvXBjUw5BdAPFnPPSl/XH/oGmSR040fxbWuGWqdEJkCxFGSEZSXSa+AMc4S5m0n
         EiUyy7b8oWDJPDIIhk9ndQfBlhgaKREsgpLUk2tsvsD/zTl7B6SYunWl6tBOfgIY2VsL
         g/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732492571; x=1733097371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEcuvNrj8JDYTsw68D9XSc1FNx/lPzGaINUfsEXci2w=;
        b=sXi7soGwF5Okz2bMmBD6F4Z/l7uBXJVH3khVAvLJo0+16z9/e+YTMhYCfKjRPenhBC
         qnoofVg1f9anJDiP5Lu3+dPu8d1KtcIoMpynaxQmpgUOXcdUsCXp7FGkb+zjSjuPGspB
         FLjIXk8MQ6zEzqIIt4vqFQiysVASA+jqhyHgG11ox3Un+34saJDWTvZsIDk83aWh51Xp
         wPo6wGoH8NPgkaj6iyu7ab/3uSuG8MpLHIAAB2gMfupbnyHRLzHrk455wT/8RqGWMiET
         XrOUWeMLMzcrpobQAM8pfBzVNfbID+y1ozW5kWRBKOOiKyav9J7HWTaB1CTV32bbjElS
         eJvg==
X-Forwarded-Encrypted: i=1; AJvYcCUAQJrAr5h0+ngaf3vfXpzt9l2UwMcLs5syW6b9dgzzuLvhXe/gxYVjsO4Rl7FdFf6jDPGdcApW@lists.linux.dev
X-Gm-Message-State: AOJu0YzT5FKjGfmMRJe8Zua+CnRcg60Gyojiw5H12tF6/XwB2isGdskO
	Y2DcjE8r0neD3DdPYs/jL+K1m4i7FRlZ8Th/uFOy8JlerJ6owXqMcBCJoSyNZl3+ctHLEub52LD
	qZRop0HDCaTP6RizqFAQ4VVWgpVk=
X-Gm-Gg: ASbGncvaOalPNSbOpP6UNBeCXRjhR2cqSoRyyRaHfaGJuFSesllEjMlkGdU2nP8o8d4
	N0XMFLUVlb4XW4dJir6U6Wx2U1g6Y3g==
X-Google-Smtp-Source: AGHT+IFjUWF43u/ROhUxo9tM85utRv+Ecq1g4sHrpaDwuC22Uwm+z/tdd8bUZbed3ovdPCNk9h+NMYan8RA/Vm2PrxM=
X-Received: by 2002:a17:90a:e7ca:b0:2e2:c1e5:2df3 with SMTP id
 98e67ed59e1d1-2eb0e9a412amr6098614a91.8.1732492570768; Sun, 24 Nov 2024
 15:56:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241117133127.473937-1-ojeda@kernel.org>
In-Reply-To: <20241117133127.473937-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 00:55:58 +0100
Message-ID: <CANiq72=hN20i4ZcVFRVgbiGNtq=FDDOVjeyQt4gf4-BrE5nd_A@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: remove spurious item in `expect` list
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2024 at 2:31=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This list started as a "when to prefer `expect`" list, but at some point
> during writing I changed it to a "prefer `expect` unless...` one. However=
,
> the first bullet remained, which does not make sense anymore.
>
> Thus remove it. In addition, fix nearby typo.
>
> Fixes: 04866494e936 ("Documentation: rust: discuss `#[expect(...)]` in th=
e guidelines")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
