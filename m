Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB241E833A
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742855786; cv=none; b=tbkU3e2KO4W2wWBPUf8LZ/TqYiIePWls0ZyoLyyRcoWyOyE4VgZM40hEYIItqzmAcat5AtXGRAJCPMCCBfM+ekNav9OT+vLquAl1UO1tL/hnF5fb2RCTxXa34AR+n8tbqsVZnRZbV0TG6l2CcSh2twEws85wsKIrKqq6fdmiSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742855786; c=relaxed/simple;
	bh=noLkjTOkKdGAQzY6kLH3v0T83S59RS3BZvbEAJQ1YUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sKCpDkO205S7dw0zovcwXEcby1uwPcMAmSuwUm0woL+uVPav2tKKkjPhOzRJt6zYMRwliKknuTpH6cEWQN48dXO8Gl3c7kN6ufYHZUtrqGJcDAkmj0+saTXmxED/lwo84h/vZ90+DyGQzMWyPaPLqyq0H6joe0FLjRhwz/ZJtk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIcFIEs1; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIcFIEs1"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-301b4f97cc1so1524902a91.2
        for <patches@lists.linux.dev>; Mon, 24 Mar 2025 15:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742855784; x=1743460584; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMwpvpGSihFpcWPv7SrmbBBHPmwSxCgI9Bu4MhCTy9c=;
        b=TIcFIEs12qKsaPpVGEw2EhOtjAySb+8DTcI27BfSBAvEeLJGtNfgNuRXNyVz3HP8qa
         PXiMowCnJUjvTHlPbUMW5m/Nnuc+52hsoDp7jgvMzKeRlBgMdEdbgq3ZRsH/A5C8pJtg
         l8TadxMIO/mAPdKU2h0EGRoFk3aSXCuDV9hl4ebgBJus+c8u7UM1kUYsbmPCDUDZczkq
         EaWF0Fzv0ln0KqXH36v/fBR/2hqVet2f/rBS5sDWBVatSfbhKm7f82YWcLLVSGeC3jmq
         VkZOE/K42Od73ZoY8vwPHbaqc6m5u8JxiIKWbr4SgwwmyBVzxKKIbA7A2iHeicUsviN1
         zNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742855784; x=1743460584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMwpvpGSihFpcWPv7SrmbBBHPmwSxCgI9Bu4MhCTy9c=;
        b=OJPsr3k2gcLHlBjQ+oAx9FcNkwR6Dqe2g/0EfactZoz2Rbf2DL8UcY/pJa/+47VzKJ
         SCALTuwco8az0N5gBE+wXkw9Sy7VMLjtvaCJfNfh4jleOqhD3agqFdh5hx2WX2d5VL4e
         tc7H+RZWPcxxqxx4J1i1+hzL0Mw7VoHyBaAulmH3CcQGDACYfly04wxX6QJJgwIjDw3M
         MRC3lGq8d8actBqZzrQ9lxCfxFNKF+MWGF5J6VvpSwTpxVawfeEgUfFSFL3Y+DlJ1M0h
         oGJpIZXsUxeTe8YP+P3aMe/+zwuU1ymHvChiznYOgL4UzmROWNx3Yp8Gz/EOV8LA+K3s
         wpOg==
X-Forwarded-Encrypted: i=1; AJvYcCWZenk/0K5wWYMZ8Obdkfy4lWKkiE9aanchv+/fD3FNSGkNdWWCYs26E2zNTR0YQedJtd01G3rz@lists.linux.dev
X-Gm-Message-State: AOJu0YzMPoYdHr0B3+4zUAiyGoALa3W8IDU8Vxbu7zKmBnnRjG47iX9r
	C0R+5jSJCyTrPrcavfT2L71iTTVwXloOt6XNdo97ImTY7pr6dQhhYYb6HqpL6kV3thXqQ6fYzLS
	l3lB/GRR3d9+4hjwjoj0DXPTJRtWhxOvd
X-Gm-Gg: ASbGncsz9APontw3ElTcJMA+VybmfevgDOiSpFRNPHmOa7h4ZNb7yD6WOuYfHcOG/P2
	KlOIMGfrIHrufL6hmmQT8sRpOFbNcW9aubkPZAsuV7qnitY6H0YWFiVGxqFb6fIsVq2zfp96jO9
	EdtZL5eH4qLMo7g6hsanjtQp3zHg==
X-Google-Smtp-Source: AGHT+IF/fJ/u4xiqCMQ2K1WXQtqCvrm0pQusiRTeRuSVmYcqrt8sQZo9BRnGZSEZ3hMjshFl7A1HNsUqnQTtmsQngSA=
X-Received: by 2002:a17:90b:1a8a:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-3030fe534e1mr7312291a91.1.1742855783991; Mon, 24 Mar 2025
 15:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250324174048.1075597-1-ojeda@kernel.org>
In-Reply-To: <20250324174048.1075597-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 24 Mar 2025 23:36:11 +0100
X-Gm-Features: AQ5f1JqI-eA9JFe0ePpg07tre0ZPyNqC1B9iegmOoeXkhSrZWtBSCl5eK_XXsWc
Message-ID: <CANiq72=4woD0Ri1OrLMb33O6+W5TuG07ga0+B275Jts_qYNeAg@mail.gmail.com>
Subject: Re: [PATCH] rust: dma: add `Send` implementation for `CoherentAllocation`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	rust-for-linux@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-next@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 6:41=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: Danilo Krummrich <dakr@kernel.org>
>
> Stephen found a future build failure in linux-next [1]:
>
>     error[E0277]: `*mut MyStruct` cannot be sent between threads safely
>       --> samples/rust/rust_dma.rs:47:22
>        |
>     47 | impl pci::Driver for DmaSampleDriver {
>        |                      ^^^^^^^^^^^^^^^ `*mut MyStruct` cannot be s=
ent between threads safely
>
> It is caused by the interaction between commit 935e1d90bf6f ("rust: pci:
> require Send for Driver trait implementers") from the driver-core tree,
> which fixes a missing concurrency requirement, and commit 9901addae63b
> ("samples: rust: add Rust dma test sample driver") which adds a sample
> that does not satisfy that requirement.
>
> Add a `Send` implementation to `CoherentAllocation`, which allows the
> sample (and other future users) to satisfy it.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20250324215702.1515ba92@canb.a=
uug.org.au/
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Added number to Closes. Fix typo spotted by Boqun. - Miguel ]

Cheers,
Miguel
