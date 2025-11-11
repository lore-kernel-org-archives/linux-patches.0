Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D166352957
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 19:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762890320; cv=none; b=DKA6KSLQU1hA6HU9MWCpGSgICQjJQF+Oszz4q64n3jKnHBx7jBo6sdYSmomgs1Jt4Xbe7YS5JuJLf8BDe0zx4AqymX5LugA53WTLnsbs7aTC+SafS2W995Ueuz2gac6bJ1+b/KuBlKmoqwGgwnP+0NJ87f4nLm/XF+uDbngRwZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762890320; c=relaxed/simple;
	bh=Sg7FhLFPHYhYHz0dhqTZ1MP6Nbu0jdxwfOGdyNc5gt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qFWQhuU1NoYUZH4NgWCxI2PVm17rtaqVgjF/u7zTIGodHMTLOet9jvcaMcsRYuyRn8gtQa4i0dDBovo2T0EUCJJbkLy8wcmX30RJzyYKni9HkpxW6eS3K+CiEq98X9vpxz7aKp7jMTjlalCdzcj4uWLdsDbOV91oOw/dnwDGpb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnX3DnSB; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnX3DnSB"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ae1c96ece1so12361b3a.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 11:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762890318; x=1763495118; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg7FhLFPHYhYHz0dhqTZ1MP6Nbu0jdxwfOGdyNc5gt0=;
        b=dnX3DnSBcqVkYZG6ec70L2DLysWRM+00sO/4zxXjZtGT43sFZmns4/Tgb1/3ZoEOmJ
         79eskWIVYz/KavHZJqCxLkmihXG5ZMg1pllyZcCYntQEy3XtFauMTV3IbUNoWiz4P6fH
         FkcB/Nd0GlvK6CBi+9LXHattWmglFqg4oOUF1WXk+cvCr7AFbv7UoOayZ5PTJ+LQIdiE
         MkDzh0E2vtWtnc2ZzdAk1HtlShaCQu/EWTkNoHV/kOB2/rzaMHvtdtfbxwQnuaVx5DXz
         tRtiVt2riwSA8cucjpOZOxAhlS1Fa19DwD3Zp9ErjKFRP5VpLQFURUDm2Hffd9vajeXK
         zwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762890318; x=1763495118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sg7FhLFPHYhYHz0dhqTZ1MP6Nbu0jdxwfOGdyNc5gt0=;
        b=NPPN0BVhR3FbuRAFvEkg0uejcai92ty/bRy5wnU7t3qzfWse9h6d+3L0GS3XgvLYco
         xtZO5GDpBjsvt5XISTrgE6+h9rguIkfJkaXmn2gav+ouJ4uAABT4ZUoO5aYnchrvYaeD
         WxxXsMjzp8ZrVOxVrDPwfdA2IMClPYG1EDTh+pTlOmdq3D0Fl4lVzm2m8MzPWnGE04AA
         Fi2mtoU4oaEVjn+rnKpEPQRLjr0x2vCNd7bx/AwC96R6U+0aajzkJ8lTqh4dw1qwn5+E
         FJ1WZl4OQ0URcEBuFIwJtDQMN3FREfDQu8zdRj3LkQFpel2MbU2IjJPWg4y3Q40/cL6c
         rHtw==
X-Forwarded-Encrypted: i=1; AJvYcCUKvi7j8K5brI19/z/1982/IaPLPdXnmI3Pdpecfkm4ZIxRkUsQgDNSPW67NYpzVMymRc3LXhsZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7mpktCoh0fX2vcLP6E1KRUFReEdnVFVh5VHoTBfkV9Y5z6HfA
	qmICeuN18YnmjUZ9s8XVPi7/wFLI0WomIW6muxC2IW6MNTtjfI64LXDttjdfPRnPNaD+cUNo0V5
	J+i2Gm3WU/vBXfWtrBvDQ1SN3sAIC78TZmbg/
X-Gm-Gg: ASbGncsOI+/Icgg9neKrDsfF4WHCR/8ecHn1WnfaNTEs9rcn3MAiARwGZpqhPtxRYSy
	NErvCmHwltSI3dM9CZacaeega3ixprpH/AyUs2nNfovgOxaAzt5KC/ZVgSJaE6ni6aJeQK1OY2U
	py92zd/zGJoUMXyvL4auRCx1s3+5hOah9IBki7sZDIK/jKWdKLcGGHMRB0W5AYdl6JM+RG/ZAhd
	j/NGud7bVbp7x3FtBqQk3NyQQeCTuMCbjlb9zpTH1RZlYQquYED3P/tUja9l+Ho28uCZWByX92c
	uliLb8MZfiKHUe47qN96gr96FypU+qacljCh0F88jmG9mx4Cd9EboHg5Y7qdcVM5XWxgfilk/Zc
	OAdo=
X-Google-Smtp-Source: AGHT+IE5zjw8D+my40d60Ix41uKXNSt7HOnLAKKhJi0H3LCnV5CTo+qFPBfkXgqbqQK8w6cViFfsGq4E6L6246te+k0=
X-Received: by 2002:a17:902:db0a:b0:295:70b1:edd6 with SMTP id
 d9443c01a7336-2984ed884e3mr3098505ad.3.1762890318029; Tue, 11 Nov 2025
 11:45:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org> <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
 <CA+icZUVcHfLru9SRfhNGToiRmyOY+fLw-ASEvQakZYfU1Kxq4g@mail.gmail.com>
In-Reply-To: <CA+icZUVcHfLru9SRfhNGToiRmyOY+fLw-ASEvQakZYfU1Kxq4g@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Nov 2025 20:45:06 +0100
X-Gm-Features: AWmQ_bkZOKXuOXoFqnluk99fIIrWIqE98EcoUgehQR7XEFroNIarOWjMBHltciY
Message-ID: <CANiq72mS2SFfMsMgVvmR7dgBpYq6O23Gx9fQmDWuaqrz5sVNYw@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: sedat.dilek@gmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-modules@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 4:25=E2=80=AFPM Sedat Dilek <sedat.dilek@gmail.com>=
 wrote:
>
> I switched over to gendwarfksyms in the very early testing days.
> Faster builds. DWARFv5 fan.
>
> And was using v5 of Sami's patchset against Linux v6.12 as it cleanly app=
lied.
>
> Last week, I jumped over to Linux v6.17.6 and the next testing will be
> Linux v6.18-rc5+ (upcoming next LTS kernel-version).
>
> I will try this patch - might be you will get a Tested-by.

Sound good -- I have applied it to start getting testing, but if you
have a tag in the next day or so, I can add it.

Thanks!

Cheers,
Miguel
