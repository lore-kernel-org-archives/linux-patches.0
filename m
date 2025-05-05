Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03C25D546
	for <patches@lists.linux.dev>; Mon,  5 May 2025 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746458741; cv=none; b=U/zwKB1wnhaQBd0AOLrZNMTT+OuxJmdDQel4dn88S3yBqPJ3FLS/6yPEx/ftuEJKupsZF05KWepmSFoSShtzWBcu/q4kyHDlJeYdbJXA5Tt09x/ASP/EeredA+TGqfbvCWRvp78b3XBEGq2zydTxwdLbffpQubi/wFRYGLQw664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746458741; c=relaxed/simple;
	bh=k3cMIRpP9MAdOLr6JvQVd+B72Rzr+z/tx0HNQDqxZW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IPtN/MBOqjK3pRfzcfFHXHTMSQO1vfrhFlyDL4YXXFM31M3PcfEfdmK3bGJowbBeJ7KbesM0tPVHvyLd/gEISbH8kaKAClC1xx5FIrqVms16V99tlFhfiML3YhjZ1SgiL5c+O5sUGXbJOlYnLTBD0m50sAtUL3Y45NCBkM+LmH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AgMSDOsH; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgMSDOsH"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3054e2d13a7so295026a91.2
        for <patches@lists.linux.dev>; Mon, 05 May 2025 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746458739; x=1747063539; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3cMIRpP9MAdOLr6JvQVd+B72Rzr+z/tx0HNQDqxZW4=;
        b=AgMSDOsHI9dg10YpaQVgVW8qW/lzwjtDN2b8H8gWYWEvUXPoo2OxaTRUrNzripthom
         uPgJMcmHo0mm+Jnjy5FXMDwX3iECvPNKLX/Fl1dynjOHTRmiUKT+vx1LB8OqkkuND01V
         HpiZmvs3WKzB63mITGWW23T2jTF6vib8UtZ3NFOkW1KjE2st9Bo6ZhCEcKtadw0IP1/e
         bRv1v5ummrJ0eovm3/3kkATwMC3NICEss/AkSvIqNT5QrMrgnrdYC2MZvgQh1DTT/3h+
         i795T1EWq3gpKhcwGqOQKG8pELSSaGWwZZ3g2QN3242VASZu9YMQ5Q8hWe7mHynEPJ/6
         t+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746458739; x=1747063539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3cMIRpP9MAdOLr6JvQVd+B72Rzr+z/tx0HNQDqxZW4=;
        b=wNfNpKXSLFA/+guVm2or+ptChKuBR3KNaSOB8b5JTryd0h6TA3GwPlGM7UaaebrLLe
         YfMMxxVLmy7pA1tNKueGebAiJaZHBvWXYXaG//F/+8ki75Nj7BRrwOpZGkttZXHztIE1
         G9l1IsHtEp3lnqoYJwl8wih1pkhHg2lBh1Je7jQjNyEyzQYTK6E4bN4k2SYwHKzOfcMo
         sKjKlbQJWVQo+3bBwyAtlNleKoq7h3egz9C/IPecmmzvL67GCG5DAILdAlw4rZV4PKSD
         txEtYe8RFhnRSlj81avC7fiu2c5Z7E6xh83kxinPU9EGqr4qq1c8ReancbYzvvRWyzUp
         wLGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbvDqCwYktPQwFirfBafcBJgPMMGJa8lvpeO5RGAXRXazlBanG2xVCroCn1BYAwPzvQJTtjk2x@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+IH6l6EM0zxqZ2WWplYvX7nf73+p3ORIwjnnZMtPny6F5dLvF
	59e7PdgLPitrJjCIfRLaW2TyzkNw/tU3BPlVbLCmPLmNZvdtF+bg+nL8XMkejl9VsXUF820uUkp
	o+LCdit2F/Vg/i9rYt30TTMr/F50=
X-Gm-Gg: ASbGncsNKMkZ8pceo1KeAK9C8zOX921eltLbRIkCvVcsWpogS/njKECi7RdQKTJZVAK
	fC2PaX0EYXGbHmx1uL8AXv0/cPSyuxqGZY/DWIL1gDcg3AQi/2WpeEFLyxIFMWY7W93TC4XwQqV
	zFqIwIwjd0gckIsb/uFrCX4w==
X-Google-Smtp-Source: AGHT+IHRVyTkZMEkrjl1tb+xhWRz+XOO/RG+ywEWuBKUhWxMwlE4Nfhg6SesSBOEedXa+f/GB+dArhcsLbsvmsYMM00=
X-Received: by 2002:a17:90b:1642:b0:30a:28e2:a003 with SMTP id
 98e67ed59e1d1-30a4e621a86mr7214089a91.3.1746458739173; Mon, 05 May 2025
 08:25:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org> <20250502140237.1659624-3-ojeda@kernel.org>
 <aBiDd43KSHJJqpge@google.com>
In-Reply-To: <aBiDd43KSHJJqpge@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 5 May 2025 17:25:25 +0200
X-Gm-Features: ATxdqUHjO9VoZGiGMnlK5x2FmYOBWwyCMKRYdIXPOYP7wkN06j2ETlj7lPMEaGo
Message-ID: <CANiq72nLLQcuMou_zLTiDggpnS9pLySax8QSNxD9mU27eZNPUw@mail.gmail.com>
Subject: Re: [PATCH 2/5] rust: clean Rust 1.87.0's `clippy::ptr_eq` lints
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 11:23=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> For the list file, it might be nice to import core::ptr instead of using
> the full path each time. Or maybe just disable this lint.

Since they confirmed they will backport it, I will disable it locally
when applying so that it is a smaller change, and then we can
remove/revert the `allow` afterwards if all goes well.

For the other one, it is a single line already anyway, so it does not
matter much.

Cheers,
Miguel
