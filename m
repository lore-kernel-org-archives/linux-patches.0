Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED922DFB4
	for <patches@lists.linux.dev>; Tue, 15 Apr 2025 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744742894; cv=none; b=J3pqH/ZDgrXTS8tqRILYTpIGHoUpYmZtreVUS76kQlZxBVthEc/AODkudICwM47y7pXeNvH6XvvLv18yjrwEEe2FvgnLPP6KCLNif6wkg25Zf2x4HOksAO82mP6Xp6XSw+0yFQj2HNeb6yBA1geuK6n4loEolAsmyGmpJRfNKIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744742894; c=relaxed/simple;
	bh=2Kpm6GWhgo8Q/IOC4ec8PNWFZP8KUbljZZldwykeRhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mjPiUDDQrhQwekJtN32h9sKp3pLU3leYf+rCbdmmQomdOQTzOjKsrt/THuI7xtkeCkESC5d3DpMNaP6fNm6ROZBtobq3rGtAULdfijilGnZNNPltfpMd3E3eZzHXUh2m0q4QC6tR0JjN7NBxlegN9UmeNyvDDKHndks2TTu2z/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEdvpW8O; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEdvpW8O"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-301a6347494so1067770a91.3
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 11:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744742892; x=1745347692; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Kpm6GWhgo8Q/IOC4ec8PNWFZP8KUbljZZldwykeRhg=;
        b=YEdvpW8OG2uBVotb+BBlLkOIOqCdN05Xl/jEg0gIVfbgtPfHnEIFZiPYefvDMsfn1/
         btcKg3EzEaC0QkGVKQmlmT8LTz7+hNvtq3hwPadNmG1vt8doy1MO8QU2SgNcXJANz7Lm
         MAOPQB+RCOtFrbuHimPVyG2LC7T02fAO4wTRa3DjXYTzflXTIIsGmZJ1IZakgu6abRr0
         hVPQ3ogxuprkebcC03GcNcVFmyD57FWp+jdQNAEDiHHni02/VDbaJhEUHzzE0YlyaupN
         VZN/2ihQ5P6LxZ/ocAhxmLxxmDPKbx7OIcLAaVvsskJM+x4cbJi6raOYAHa1PxNZ8Oqh
         wKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744742892; x=1745347692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Kpm6GWhgo8Q/IOC4ec8PNWFZP8KUbljZZldwykeRhg=;
        b=nCryMn1bgx0XILlcsrAyzNT7vk01N1f5PI3Lnw4griNez3Gi2PskR7vaer8mrzHY1O
         vEiCDfV9DUtV3BzKV65PpzkfAURid2BrnCu78W8Ucz/6907tuGy9VNECDtHSq36s6af5
         jS3k5KqeazovC59GUqiye8RUf302jV9OssBNZNjIvVJY3Lmuklumm5DT7cBSTEvFHSAl
         J903A1NkbnotYyTA1ODha3XeUl1CLiGlFh1YXHygHZMIqxHMfxRihgJJub9b96PrmfsO
         bYEP/Jico4NmeCrGeYcj+PUFNbPSfiM8fSxwnzUgfiLB5/HL8l6IERm6nhugm+h3GV/C
         vwhA==
X-Forwarded-Encrypted: i=1; AJvYcCXWXe/IaAHhpM9mpgDrhoaCxPkKFSEsp1JZLgogpTU/5C61HGRRkfwDwgr9rkbs6IDlpjkfJTNj@lists.linux.dev
X-Gm-Message-State: AOJu0YwpX81enNQJ6hECEbygRbwhSF8mWnwU2iHfYq2VRXJGYWQ264D9
	6q5fMKaGhKsXICrqXEtIeMizr7Sa8yEW5nPNixVlTAN4vnzY8GdBh6azYUPx2HQ6EEd2X4Nw5hZ
	vuZoZ8Gok4LYF3q06COODy78ahfQ=
X-Gm-Gg: ASbGncufSC/N5z4STxhosHkVBQXcymvSlqF+HMgwqVYLFZFIbf4b5sd3lgEloiTD/OV
	gHjIvrfi60qhc68VCwBI3xQwUX5X2K3mR9l1EsY4+ej/wDfBFIlyOGsDdLOD7MmUxMTvUxVwC+o
	FNNHz7x1tsPEA1xsQnrSlANg==
X-Google-Smtp-Source: AGHT+IGL8QPPlQgTyuSsG4JtvKe3+bJVrcOq2MMMB3IlnsadEDXTmZNsLahV3jTtf451YqR9z6dcky4RKUZe/0LTBTA=
X-Received: by 2002:a17:90b:1d8f:b0:2fe:b879:b68c with SMTP id
 98e67ed59e1d1-3085ef97db8mr121803a91.6.1744742891943; Tue, 15 Apr 2025
 11:48:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250414171241.2126137-1-ojeda@kernel.org>
In-Reply-To: <20250414171241.2126137-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 15 Apr 2025 20:47:59 +0200
X-Gm-Features: ATxdqUHTA9TZry6P0hmW1nNr51e7jiPnolW0gnctSwGdT8fOOpZMfrf6lSkmxuI
Message-ID: <CANiq72=TjjW+L20su+N_7-FGMvhGZDTUEHnwk-Kz+XWUWyQVUw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: use `pound` to support GNU Make < 4.3
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 7:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus use the existing variable to fix it.

Applied to `rust-fixes` -- thanks everyone!

If Kbuild wants to pick it up instead, please let me know and I will drop i=
t.

Cheers,
Miguel
