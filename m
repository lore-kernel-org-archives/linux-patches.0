Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64312E1C56
	for <patches@lists.linux.dev>; Thu, 16 Oct 2025 23:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760657117; cv=none; b=ph3ZU7Qob4gxo1Xy6nDkAEseh0sL+Hh1rUYkBnlIVPQKBX0M6rrRfFPcU7rW9GvZFrt0hOYazxLFmJFqKZujSrUgpsdAB8KJmJQJ98tcvG9ApU9243OyRC9wKr/Xju9CO6wrzgn+NAZ6LiozvUDA8ev/z3CdscKstg1MZO4f+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760657117; c=relaxed/simple;
	bh=NaoJwlqs6RJ9zPQIEFByuLYzAhJ363qQIKtmEJXBZ50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0xEGoMoq2VMTrEjzwv4M4pyMkhoxe7soC6XJJmN3pfkmlHw2TWZZOHWtretyBHH5HJL4PdziHqksfexDFOtHsTnn+AlY3TJ+MBlZvydOaq7gxIpTJtINHPjv/B0eVPuKf9dTGdhjNYA+sGEvk+S8hQODLXGM9WZtcEZvsCpqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeUgKoMj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeUgKoMj"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27ec3db6131so2046425ad.1
        for <patches@lists.linux.dev>; Thu, 16 Oct 2025 16:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760657115; x=1761261915; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaoJwlqs6RJ9zPQIEFByuLYzAhJ363qQIKtmEJXBZ50=;
        b=JeUgKoMj1visDShQqj3BfocTrkM5QjloND/VKPWKJJG+nqEoDDvq9ZUK0VyezAARNv
         UeBcZNwY2GKq0visK3SYDEbfOUy3NjOO79AGCq4Zpf8ySbNjM5eoH2JX2NHJvTXkw42j
         jsAd+JKmyr/8nshBPkrIw4rKFXEolpoG3a836h/y6i9rkn2xcPqxwcLWLrnkGkC/50Bb
         tcKLp6QyR6MmQTksbBQthfvmePAVl0hpPG51KVcyaKpbXY0AB6jHqja8BzaRoEKUIVZv
         ZoENvhO5NWXtAUm6yBKKwT/y2a8HNvSOtHHVr0wfAJy2B1PRz+6zrzQz5vDtSFzsr+9/
         lhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760657115; x=1761261915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NaoJwlqs6RJ9zPQIEFByuLYzAhJ363qQIKtmEJXBZ50=;
        b=dg5n+JFZnEhbmUWbfR+tUWlBtPhRPwvbX4H+jv1Xm2oFAYi78VRJQsniOa2MQb+Ip9
         RsVbJ5AZZyF5vlEvwzMVArcgC5sN9cR10RObjhy8Td9AXBNuzOt5hFToZ8XXuF6iBX0V
         4qew3Q7BO8fwEMnGifFUuG8AUXYSe8T+m5y053jk+dYXEDPpCoWHjMXI6rSm/6oT1Eem
         CMeolaDKOdLYXJuhRyWO28vEbVP2WsCmaKzjU8/IegvXPOPB/UkITEa4N18gJqOr4VHz
         pPKI5Eu9Z0tD4xiSyLMuHDqTP8TXQhFcNFa+Yx4ckxgI2bycgt9ZY+z9Fp7zoMJORN6R
         6fnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZks1JWU691Qo0C6pS/y8/FuxFYPOwnB+qUnHT90sYJbh1dmiFJU9ayUVVVL9SOF73kAsRn9UB@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb4U88j58lZqh2ueMbfB9kosl2NxV8hht7RO0UXbauf+XdqZVJ
	PHxMLXCBtDxk63OjBi1jHya/+aQctHMqP5+n4H9f8nt/ufNLy8hDo+btOqvE2Ahm3skHXxR3znR
	bBxP0xNkepGaYKGIdjNlDZ/GPi2xJXfc=
X-Gm-Gg: ASbGnctWLssdr4iYcvHntuIv4wzGAWL9yLiGtLrXJxrZFlwAcKZDhI+wTljiCixKmWj
	ZE7d5d3wWgBNlPQQA7Shg93qCH+6rRegpjdkEihRBfs96JM1PR8vszv66a0mgh5icse9ZtL0gOI
	AffcAYbsWoOHc4K2ppV8TC4xiMY9uJLFxgVEspWX5kNH3xH4ZBj7IChyShcTbhXkl6Nnr7Xn+2X
	WsrGole1wQA+hu/9NQPaKsdlnmgYCQWcAn/KIDr/q5I0w1cc+5eODBDh+vPb2siJ/HeR/GY98w6
	5sVNk6mYbFBWD5MjvXQs6a2eg81DzxTOwDwEFFPRFXEJMkG8ihILn13pvl+bNStTFbj5SVM2v46
	xm1Y=
X-Google-Smtp-Source: AGHT+IHKez+rkRZENZvy/hZJ8rzFedxcLXv76zCn8uMa8clcMKyVyIuSWC0YxEtCrU1ccFU8WzBv306p2NdIMP1l0SM=
X-Received: by 2002:a17:903:8cd:b0:26c:3c15:f780 with SMTP id
 d9443c01a7336-290cb7568c3mr9104045ad.8.1760657115196; Thu, 16 Oct 2025
 16:25:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010174351.948650-1-ojeda@kernel.org>
In-Reply-To: <20251010174351.948650-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 17 Oct 2025 01:25:02 +0200
X-Gm-Features: AS18NWAKsC4mVl1hI4d0Walzq8300iiHYVsaJlXnwFoTiPZWBDqN1Yy7f1pfzfY
Message-ID: <CANiq72kjoOWNFw8xuRHk9QzhfYHDjymKV_TTt099UH_f5Kv2qg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Clean `rustfmt` formatting and define imports style
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2025 at 7:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Hi Linus,
>
> Please see these commits, especially the documentation one. It is a
> follow-up of the discussion on `rustfmt`.
>
> If you are OK with it, please pick them up for -rc1 -- this should make
> CIs green and let people work easily after -rc1, which would help even
> if we decide to do something differently later on.
>
> I can send a quick PR if you prefer.
>
> Thanks!

Since I didn't hear anything, I will send you the PR after tomorrow's
linux-next.

Applied to `rust-fixes` (plus one I just sent to the list) -- thanks everyo=
ne!

Cheers,
Miguel
