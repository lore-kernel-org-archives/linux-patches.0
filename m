Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7CE9476
	for <patches@lists.linux.dev>; Sat, 19 Jul 2025 20:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752958502; cv=none; b=iSrbOvamEr7wYgHQCT6QmDBZlE6fk6fRuKAuLSDFRPS6T905qTfqpNAPJGWxBZfjmDRL52fOJu1RbtotVEtPEPqmbgzYfYtoiw9vRCkrAOWVys/iuG5loU3Py9IOcruW9sFNBdLHHOxsywFIzMzP5SrGYm7anhHcc2Qqnylz1cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752958502; c=relaxed/simple;
	bh=GQBzpFMnqoLsh0Qg2t2pSTObf/g0qvnCU1a/voob+BY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NaRC9j42cTX5ezLS1KPIYPLnP7wxtwv2cJuJRCboAxfEsEKbfZW64jKeWslupftBahzmm7RbH3e+76XAsqF+hg5Vb3fnoWe5Srown0ywufPO8pDaHO0p2BIy9zTakxS/yU+cU78ngFclQf09Vxvefu9f1rAYDSbilh1vHEozenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q2aMCxGs; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2aMCxGs"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31306794b30so576504a91.2
        for <patches@lists.linux.dev>; Sat, 19 Jul 2025 13:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752958500; x=1753563300; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYpMyf5txQ4BgkimxSYertgNk0vxadUizqxxBkE9GQ8=;
        b=Q2aMCxGskYReT9Zfoq0VQ0UoDhEZMFlmjTChfcbnhga5VOQT/I5htdferVj7gZJa7k
         M/t1anNWiNTmV9zoYnQVTxuqHO0emexG0gD92cbkwn6Xm6H35fBBfQiXpVR0QiCJIXMc
         n5JSXGiRsjfMMubR1LquUdf+adRpZxK7h5flvSOXQHIpQTSxF3AEqcmEkEGeXu9lUGbW
         PnkdVyyvihJCN2edkWTRVbyeJhX5cZealgtwCwQeLYi4txGepxvRZ8GHQcHR5O4OCbVz
         UV373xjU1z0O9rvZ9MvvGj0vLZDgtWRuvXrtS+9lH/dnj+RhZIkbJu9lTDu4el5Alk53
         ReWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752958500; x=1753563300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYpMyf5txQ4BgkimxSYertgNk0vxadUizqxxBkE9GQ8=;
        b=cYt2Jp5Y7GfA0G4+DNTsm9Bt5tJGt7We1ILtrnecCGod5JetqTWPEP83zfm6XnmGl5
         xhhhSsBCtbdG4/8bIGU0jggZEe9RH4nOlW85Pfn/Onr9s9CfUTeTbHmLLhPBd8pYrCui
         I+fsyMFife1RZwFcPeujSusbu+zc7U2mc66vxXx7BO0EqDWHEEMVC+cIb6vONV8i2uyA
         a9rnrDLpEXOpyKMRBz1oq/M21yyz25DhAdFEw4V2fPMpg1rilrz4GjwVBtWW1ukJEAt+
         u9vAKXdX9T6Rz3yKxeNxC/un8ETFp4de2uQCe4mxoXjAvafccD0gwipWyBTg8Hh1aLkr
         /ojg==
X-Forwarded-Encrypted: i=1; AJvYcCXpv4n3E0+XRvB5cwI58++gfYG4/c/6t3xcX5RRtzSfP8/STfU/9g1k9NxxoQZuwuIm0oRx0qQV@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5spwcHledeJJdqxBggmM6hJ4yYdgd8VWjOjU3Vjmh8w+oacnl
	GY/lKA+d4PpZLAjSGOYtFENQTby5WiNrL/nYYsYObtiPlUpdJ0aTaboChwmC9OdOpehJyaLDqMz
	Q3UrHDPeerRk6RtQepum34Ecj6NATlzk=
X-Gm-Gg: ASbGncupqzpj8KhSyruzf5i3Zq3qBPUzcRkrzRBJ05+lf2AAH/6VjkompsMrJ8zz4ha
	7aXyzWj/5C2paaq97EupPjmTywuUuofp5BG83hOcvARUiFG3BrKMYpj4AOfg/cRWZfr9rAwEa/F
	OIOyq2TCUNxEommjyouuLSHGopxLIM5qe9knWtkk2OH4UQsJNyaaWKAmaqKVigJ0MGda1H/hi/t
	PI7qLgVpLGwvRoXW5E=
X-Google-Smtp-Source: AGHT+IEuGXufeXJN9bMObQp6jtSAYdJYqpVKoAURpO4xc6KAolWmA2we5Guh8+1nihduy91vBpbyIBJzf1O5jVuBvGw=
X-Received: by 2002:a17:90b:540e:b0:311:9c9a:58e8 with SMTP id
 98e67ed59e1d1-31c9e79d3dcmr8495644a91.7.1752958500054; Sat, 19 Jul 2025
 13:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250719183649.596051-1-ojeda@kernel.org> <20250719203646.84350-1-boqun.feng@gmail.com>
In-Reply-To: <20250719203646.84350-1-boqun.feng@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 19 Jul 2025 22:54:45 +0200
X-Gm-Features: Ac12FXxHqmkSLKpzkLvxms1iOKh3BC29spTi-sHdm1FLOjvWsRSZaYRN3fJIK5I
Message-ID: <CANiq72niUM8YAiVWooxAPCy3c3Yqt6_1fjW2HN7TVLnmL_GQMQ@mail.gmail.com>
Subject: Re: [PATCH] rust: list: Add an example for `ListLinksSelfPtr` usage
To: Boqun Feng <boqun.feng@gmail.com>, Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, I Hsin Cheng <richard120310@gmail.com>, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 10:36=E2=80=AFPM Boqun Feng <boqun.feng@gmail.com> =
wrote:
>
> It appears that the support for `ListLinksSelfPtr` is dead code at the
> moment [1]. Hence add an example similar to `ListLinks` usage to help
> catching bugs and demonstrating the usage.
>
> The example is mostly based on Alice's usage in binder driver[2].
>
> Link: https://lore.kernel.org/rust-for-linux/20250719183649.596051-1-ojed=
a@kernel.org/ [1]
> Link: https://lore.kernel.org/rust-for-linux/20231101-rust-binder-v1-4-08=
ba9197f637@google.com/ [2]
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>

I sent that one because I am applying Tamir's series, which triggered
the error -- maybe you can put it on top of those?

If you do, please note that you need a couple changes -- I will push
them to `rust-next` so that you have them.

    https://lore.kernel.org/rust-for-linux/20250709-list-no-offset-v4-5-a42=
9e75840a9@gmail.com/

Thanks!

Cheers,
Miguel
