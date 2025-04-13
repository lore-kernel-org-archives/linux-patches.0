Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBB618B47C
	for <patches@lists.linux.dev>; Sun, 13 Apr 2025 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744583038; cv=none; b=KXIezqn/tYih9r73D1AmXNDq39BakLAuTZCmybVN2GODfxkXhI3eWTPujXxViTukQH9BmdqsqzeP7uT40yHLpCxbDhwLfi9+q7ivM6OFaZ1nBpwFSzZAWw8gqwpbnfy4wt0DvHMmzqf9P5pwwbOGaoJ0LmCpAr9v0/O/HN6duzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744583038; c=relaxed/simple;
	bh=5FYs8INds7Ez4rx0YeDUnsyiLSwgDZ04qoFGJdZBQxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRvMkWoF5olVp5HfkTDf9WBK4I8wfKSON0052qRFKoC3rUVllUolmM+ImTFf+X52e3riCo8zbtBPAdYw9O5wA+donHO3XAs99navqMjBowJ0MHNk37G8837q+g7HXq0MzWFvzLu7bS5ihv5mWKZZRBoesILpGBdEHAGQTIaEdNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=McSgBb1W; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="McSgBb1W"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff73032ac0so578606a91.3
        for <patches@lists.linux.dev>; Sun, 13 Apr 2025 15:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744583036; x=1745187836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtKqjWftrBv3XifKdy8QoheRf97Hhhgt1ezEOn9xOFg=;
        b=McSgBb1WeXtXyLUVLhHCuDzpw50j3PJzu4ebUB73F/dFp5PBukr01/1lfqx8ZrhFGM
         N2U1yU9IYXpMSkaizrPerM9na3mbmCYLzPHP+/Nkk+TZpcxYpKL/Xg3pY+F6mrjsaHgr
         PCbt7y9Aa9I17k96X7uRedczm+JuqVXstC1OiKJ1DIizvW7lVIqA3VeFsdErOt0HIfA6
         lRrikTyRFI8xeBo/4o5NEuL2DZZai9i+s4c7/a8bUIApIrqQzO/2WFMOaX3lq47WKixa
         WMXYwURc6BciAV2C6JuKBkHYKdoNieWyYSLJrxY8bawWGATv+NjrbUT3GzXjs/BWUhnN
         laqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744583036; x=1745187836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtKqjWftrBv3XifKdy8QoheRf97Hhhgt1ezEOn9xOFg=;
        b=gm9JbcU8mMoO4aI3aLt+j5qCcDeuiiGInxtDA2kLdgl7ZLP8kzGQnSvYeNlodpbQQG
         0JPps3Kk2MEzEGcnGS7zPxcfru5TFxTFGMKfVAQx1vzsbZnsprOKP6Y4DZTuaDta5kvY
         HvEGhxGO5pnfC8jLThg3rwldHSGtntWi2Vdh+tH4qjlUERhAu6coJ8kzCQOSMbuItfWu
         Lo8L0tmTQ7XP1O9nTVPM0xfEhj+alM6rJ5o2qN0Tyi9wIMEDmTGd/x7keUVCX2QmqKvO
         hd03SD5QB4Dthl6QTFiFtqn1YPHxQBxmwUsxHNwcPrF76wThBWkLzFnjx33afxKwXGwn
         jWPg==
X-Forwarded-Encrypted: i=1; AJvYcCU5YQ3sqm1EWTGTnXwPjEbo0+cpSbv54jiz63AGRKRnOs6Et859gxJ+CGO3FdeSHosUFZWCG1MZ@lists.linux.dev
X-Gm-Message-State: AOJu0YxQEd69xHqWYiTbxqE4znJl5G29a68erUcLVF98Fym+3C5kob9g
	BFZyys5o7e6cpUx6FvHzjoLPMWANrmyvyoPQbvcZf4+1sU3pR/gAHUvrY17nwuKltV0NO06nTZ9
	wTyUGa4NCYx9dxtAra9zTZaIfQlM=
X-Gm-Gg: ASbGncv5cnLpeEFy71wL1cBh95seGK6vXOV5GdYHgr/RSga4CR+pCmAnfdioV8FDhIj
	GqFRomZruuxbF91DZCemdF+5YiLBWV4aX9791864/VRre5CfghqkVG6UXPU227J83+HTMcoQJsy
	IgZytPZjl1b3Qa+LyqtG9ohOqmoo2PBfCM
X-Google-Smtp-Source: AGHT+IFn54TeU1wvrhM+EETyqE2jfpAh99vnK/bWnAlwD8UYhKCBm3zw3fsjUt5iMwkM9AYvBYjY6Tn/XVChVgFGHIw=
X-Received: by 2002:a17:90b:4d04:b0:305:5f20:b28c with SMTP id
 98e67ed59e1d1-308237c95b7mr5577155a91.5.1744583036271; Sun, 13 Apr 2025
 15:23:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403163805.67770-1-ojeda@kernel.org>
In-Reply-To: <20250403163805.67770-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Apr 2025 00:23:43 +0200
X-Gm-Features: ATxdqUFCL9YI86SaWAnwIPahf3eeE-5GZirLfIgzlqffagRKgM5I46QYtOigHMo
Message-ID: <CANiq72=SxWfcnKy+82NddPbMTEtcyED8r7aEbivBHekodnnNHg@mail.gmail.com>
Subject: Re: [PATCH] rust: disable `clippy::needless_continue`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Tamir Duberstein <tamird@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 6:38=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Thus disable the lint, at least for the time being.

Applied to `rust-fixes` -- thanks for the feedback in the other thread
everyone! Tags still welcome for a day or two.

    Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is
pinned in older LTSs).

Note that we don't have any cases before 6.15, but I added Cc: stable
since I assume we may in the future, and it is easier to just have the
same set everywhere.

Cheers,
Miguel
