Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E70319ABD4
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401760; cv=none; b=j8+p5LaOEFSKR040KfPPg/NtewhFXytiMtID/sthCeCS7biUiuxoGSaaxN6+9wHVbai+SCpp6PYmMRBdd47bcPpLrOrT4+fHNeNRYFxiF83ZiUJwluM/gkQ6rCdARYZSVuFYFMqJyT7rEnApG6cpcBCPqxa1lJ0wYBuBeIlfw3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401760; c=relaxed/simple;
	bh=lrJ2LzF7zlUMZm0btnhQN/Snt0WUKDPLpgPae//gUiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGJeP+3PF7Ge3MvRfbE4BVriIumH+OXlNSnFAwoxdvRscH21U9rA7t4Oi5W375MnunetF0NMMGLw2/VeMpju/Ddn4g3HOe478xsVyQHCJhl7NiWFfgWZ1paWGLK0AMyVFE3LpbRngViE18bvPs55dpixq20G8wnVRHSwDV8jJ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUuzmguO; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUuzmguO"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31373948e08so173083a91.0
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 09:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749401757; x=1750006557; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSjaCDZzns9NZ/rU9vg+pCrunxrSi24iyQgxwaNXdjA=;
        b=QUuzmguO9dpwfxJ9jUaR5rTctkAc5gDGxewXF1OE6heWkfmH1i/ISZuz0bwOJhpTY6
         4FyB0oQMssvWP7W2Gn2ByaiHY1FU38LMtCOWoL/ADdwjCtzKaMQaaeGmnpndDrES4cln
         UPJyvt6Mehmjjj00of/sh8MdajyBRHRsMWUmyzQ8qmJKIWa2Qj8Ngs/X4PlaF+B7R+SI
         14hqCJMGqx2PCMLp53/rTUjFDZ3gyl1/FoVwicgaTvhdOCxPSbOLyNR6KFzOyYQ82Edr
         E7+meBnN+Kxps8T84cJgrqkVeRrN0pb6U4TfB2Ozp700ltaw2qUhbS+hkOwAOVx3SsEK
         b/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749401757; x=1750006557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSjaCDZzns9NZ/rU9vg+pCrunxrSi24iyQgxwaNXdjA=;
        b=LrZbJo3HdZrZ91AF/Vn1HuKGKKD/89mlTxycbsKiPgAa13hwh8GobLh0c7op3dtj39
         fmQCJQVaRm1nEqNpHxV0pbqsEsqAqrCZPeriqeB+s/GQO2NJ8vGl8+vq1HCrPUxjr+ZE
         1KD/l8T5PvCWBLKP273F0XhhxsQbs5VOBT4G575KUJD0YS5DUYiemZ4q6luAkZZle63+
         ie2KmbDqm4xDEm1DKHEF7nTt5jSVnmgf8s9hbob5HuxqxlG0BOnmpz7++ZJyR8JWV8Op
         +RTBs5LxxDmC7l1pAf7oyTyMzPP1+ds1qJdbBtYIeWKiMKAFCJPyJPRqbJuiY644u+Bq
         j/Ow==
X-Gm-Message-State: AOJu0YxY6TvuHRS4iBzUYqVdqDarTqEIVbOySb+tw9t82XD3g4WsBmE1
	SG7Gcxy4JFNjkdHSITUsIGyCBVdxpCYEHjx2KPgt2CMa/LK1uSpG4/bGv7DBpE4dp8drRVgRtam
	OmvrYc6fzQ8wxvtEz2fw2h7sbstmK2nE=
X-Gm-Gg: ASbGnctoM13JrkowYK3osz5PqL2+CLbJ6CQp2TZJIJVAbzGMkmH1xGWcdA4DMuUetFY
	u5auv5D6hP145ByOOB7cXXBChNg5r14HUY6TdRf1j+6HzSJqxPMSNh6+hQvL6uNZpcnL2uG1sR0
	sbN0IVLa3krCgpoZ9pJYeJY9nhfaTZeZoeC/0uAJ7P09A=
X-Google-Smtp-Source: AGHT+IGkmZGpCtoYI36H3yUtvjrmSOb3PvMZ3WR83VJPV8zEEiF3aoRxqgFqf0hzcsX2tUpOnd945145uI/+k2leH8s=
X-Received: by 2002:a17:90b:3a87:b0:312:db8:dbd3 with SMTP id
 98e67ed59e1d1-3134e422457mr4453960a91.6.1749401756911; Sun, 08 Jun 2025
 09:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125543.934436-1-sashal@kernel.org> <20250608125543.934436-2-sashal@kernel.org>
In-Reply-To: <20250608125543.934436-2-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:55:44 +0200
X-Gm-Features: AX0GCFtg5vXXOQtvKzuqFbWiwUPEonHdI8Jhi4FBd11G-0o2n9_KiOxJiu6CJes
Message-ID: <CANiq72kEoavu3UOxBxjYx3XwnOStPkUmVaeKRrLSRgghar3L5w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.1 2/5] rust: module: place cleanup_module() in
 .exit.text section
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, alex.gaynor@gmail.com, lossin@kernel.org, 
	aliceryhl@google.com, dakr@kernel.org, gregkh@linuxfoundation.org, 
	boqun.feng@gmail.com, igor.korotin.linux@gmail.com, walmeida@microsoft.com, 
	anisse@astier.eu, gary@garyguo.net, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:55=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> 2. **Minimal and contained**: This is an extremely small change - adding
>    just one line to specify the link section. The risk of regression is
>    essentially zero.

The AI is a bit optimistic here :) Changing the section of something
could actually have a wild effect.

I don't think I would backported this, since the savings are tiny and
they aren't an actual fix as far as I can see (or at least I am not
aware of reports of "tools" breaking like the AI suggests).

Anyway, it probably doesn't hurt either -- `exit.text` has existed for
a long time.

Cheers,
Miguel
