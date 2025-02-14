Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16AF15FA7B
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739558885; cv=none; b=jor9xDThmxICDaywUTy/Hq/usKuK2NUIevqAr13n0Lz5BlYxWOEnAXVT0OR2fGN2xx5gUy5iBetnpMzfJGhFB1v72zK1SPwr8YGtI4sNDppVVqwc0r/e4zilaZIwHQE3HEfyXQz4NJLaT7F5jYNm4t1M9EbDxForsEgREtS6Lu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739558885; c=relaxed/simple;
	bh=mbPXCYa0Euo1MoCU+SWGOw4OmTSsV7u/JIvOIPr+CKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cPvYpEOkkHJMdEovZ01EZVoMK8gpzCFNieUvuKnNXNcOUWo9mCx5xS3PQ5hbB9liKgCkwaOsVgv91ig1Hrc85+LO0BZW02cGYZ85S4sbq8RkAydicSye5hy92vi64xxeRS/9q+neV31Xah8coRJwkhbVIuZkIQD4ySyeHs8Fa04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1DT2nzl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1DT2nzl"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2f9f90103bbso520436a91.3
        for <patches@lists.linux.dev>; Fri, 14 Feb 2025 10:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739558883; x=1740163683; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbPXCYa0Euo1MoCU+SWGOw4OmTSsV7u/JIvOIPr+CKU=;
        b=I1DT2nzl0VeaeLLbKogXmOLjmERWzZAbPlBEQGg9y3tpu6OzjizdKGf7kAHr95/3eE
         sUcrOoAFnjsMQYof4F4AgtxjovBtqjNr87ZP6LS91T35m25gEdO3NwGeRO7lV9jx4jg1
         1Cjg82vlkshu2LigZXh/2xQduTejtegKWPFgqWKG5kO+oPSLQtjUHb25tUmAvkMwPpvo
         VWHBw4qq2TYZqfCoaWTsX2Bu/Oe0VPSPt86Z9EjsX55bgaUssHec4FeJNsx3UFGAOqMk
         knjPgfDuv41wMIciIfiRtaO0eWZWd+Yw7TQ+5R90fYO6vXHxIblaEiIwuCSo/KdVR3+H
         sALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739558883; x=1740163683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mbPXCYa0Euo1MoCU+SWGOw4OmTSsV7u/JIvOIPr+CKU=;
        b=I/kr3InUUGFaa9l/divIfMX7lFxCmzllHYk2Egsif9hN0tifWKflZVRVmJi8pmXVo4
         3xQyEpah8q0Syc9K8gRiOMtI8nQmFwUYbyFDI4JCZXTHXHaxqU4Yw4pf8IfTP48awOz8
         TEPCgIHABkqRGi+NTYyJFHUEKc9onl5PvaJWhnmIfW5I859Us3cuSSHqQ6gESo79lxHw
         DYfKmuKVMsueed8z8Ot6fk4KxWYqd3wsAEXHMCKpyNniI69F25ugVe8msAUwe2Enqonx
         0HS/V5Yv6TTGgw4XQtTlk7eaCDBUqRypL08kVEjCnQx8VXt94KFObO9uLj/ruZKulaPj
         gHIw==
X-Forwarded-Encrypted: i=1; AJvYcCUWTWYkS5KO9Ynq+hjvAwlHlxk/2KM5Vq28FmkSqp4tiqGPel/Xd+bnx2YH8/Ax4GYObSJKodjY@lists.linux.dev
X-Gm-Message-State: AOJu0YzYC28169BHWGVY6wbmP6BHUqigvzoQb89+mLNhlToMWyDRDJsC
	+8np3GCKHHdrreCgrDu+LRRbcVwu7FsHWz3gsik1WtXZRSJRsE8+VhdV8wdtsreD9SEdti5pdQG
	R6Yg6uQjaXNtLQTpI473qPE6QJYQ=
X-Gm-Gg: ASbGncseZZh0Zr74/oD5HGh8QjmgDD14S1jBPC+q3tdIgbkGVkWopEq/YrT/zYS1UYJ
	M/QEasVhyh/v63zbloI1djuf2+c9PP8JkFznv1R7Hvs56it4+Nq8wDocPLAk8MmMPQiJxRI0C
X-Google-Smtp-Source: AGHT+IGUeE04nboJL79uQEQi255Sh6F2ujsdzLVst5SO8l5tm1Su0Y1pKusKL+gCNnpOW2NARcGAkDEUDmt8oqZunC8=
X-Received: by 2002:a17:90b:2250:b0:2fc:1370:9c2f with SMTP id
 98e67ed59e1d1-2fc4103cd0dmr79419a91.4.1739558883232; Fri, 14 Feb 2025
 10:48:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210164245.282886-1-ojeda@kernel.org> <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
In-Reply-To: <CAK7LNAQBFX5q6yyKBJoxMoD5d9SwdKm0c23J4+LpjwA1eh=bZw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 14 Feb 2025 19:47:51 +0100
X-Gm-Features: AWEUYZkFZsSwR_pcKDqppTTtKFiRY98pi3gXltfVmX7IBbEAqUtXPZHv7bRa5Ec
Message-ID: <CANiq72n=95jgJs17NFAkit5uzxqtO9xij9Um3ybd_RiMCpFrDQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add rustc-min-version support function
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 2:39=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Do you want me to pick it up to kbuild tree,
> or will you take it with my Ack?
>
> If you go with the latter,
> Acked-by: Masahiro Yamada <masahiroy@kernel.org>

Thanks a lot Masahiro -- happy to take it on my side if that means
less work for you.

Cheers,
Miguel
