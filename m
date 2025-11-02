Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6B1A9FB5
	for <patches@lists.linux.dev>; Sun,  2 Nov 2025 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762122053; cv=none; b=NeyiaPGOzzdUqDPzOLrRhftux6PMgbzA36JF6Mn0rUpOvPUPJyAme16g9S5IqRbEoudIrmA01BJFccMHlMluxnxbUJh7jEOY8gp+hsOZq5BhUzUwBEkFifmvzvvxISuk0ZgStuPaps4/FK2JMvjSxRHsjIrCuTalHS2cas1RIXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762122053; c=relaxed/simple;
	bh=WT7V+mIh7biSb9hoQQKTPcN5LrBBwROnmw3huldzWHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rfdLrnhkx/Hsa1OOSAiHJuvJgtYpMRn3IU0Jp82da6jiyGqiFbUOAuSwJ4MNJs/ZCg7qjeN895yAERwzmeJjClm0S182apNZI++qu2ZJIany8Nql+4Cdbsr/tgsAJM2quvZLPS+n/9idH53h1OTlhd2oDZBdKBDGsabl4wYy5cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ccTigMac; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccTigMac"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-340ad724ea4so298904a91.0
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762122051; x=1762726851; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldh/rrZAKoIw8nkk3grHKnCTpuj+wVkO9BtM8FlPSJs=;
        b=ccTigMacnXYDS3TysLVGMK2lUWrSk9h4qSc8pVUxYtwXEZLS3FCpw4NXnEp5BAB3c9
         OXQZEQ1WJAX+wXVOYl1MQeaZWXA88Gr7tJ0Pc1QYoSsPhWEoRQR1VV0orUc1TbBZLKyF
         WKXtqW31bDD4RGy4BEBLUsC5vgMVbDEAMYxmkfbW4u1BJJz6Y0D03ljNQCneNfHzR5EN
         6dk11HxpLeTIRZV3b7mw0FXoaGKG35/wA/At3wRlFcrT5k9fHvIPI9iMRXT1Knplf0Nv
         z4wgzaOqoUiq95LXNcwnjz3YTrWCZwwDVsoTogygdyf2ndQ1K/+em26YxZ1SpDkENLMF
         OQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762122051; x=1762726851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldh/rrZAKoIw8nkk3grHKnCTpuj+wVkO9BtM8FlPSJs=;
        b=ghtu9uHNeJpr4Gs5eS61sBwPboRgqSEnsDYc/kgp98LzKVKOOPjprSN+Hnk9If4YPk
         KGo3XK49kPmRqDm8JQRf5oehOOc/TR/6krDqn0xEV7US4+0bex/R/Rm6Y1qlkVFQx4/x
         QSqH4ljShX23cbC7kJ8nWotjhTsNkViRCySZjqnIAADYo5xGTj+AeyspNjo196B+oXPT
         GlKBo0nc+StfE3F6saBYa3RnMDU3XpGZgBWV/bMmn1JNQoqWO6AfKyArdo5x4et1iPP+
         UGzF+nL5aWGDD2b7LLZSPkO/pVrqFnK0gE+RKumW7a4dWbmD/SIZ7hrwPFnrkN0VdY8C
         BQ9w==
X-Forwarded-Encrypted: i=1; AJvYcCWsNowFX6TBZdfUf2mi2h59rr8CajlTP8t2qQMZEiV4hHhdmt2Qu7MLNCG2MXnz7hcupe+PORds@lists.linux.dev
X-Gm-Message-State: AOJu0YxVZ2hyq7SzFxCwvPl8E4R5F+g6JjTHiUvH3/DvwR+KbzyLEcRE
	osb/vOKN6tKyAldGNAeDPJCc2hRZ7kDcSL3PEQj5WfEQzsQaONpJT5r8jcRefgZAgZK67BJWdSF
	fk4OnrQtrPDUqY19xoo5lLFtzxHUWFjM=
X-Gm-Gg: ASbGnctrs7yBZq5uMHnfV4YaIfyiy/IczBEA2zI38mrMo1QvfrGDetTYDc10/mi1jLN
	e8Zqh8C3xqyWtVSBoG1/Gou/WeFegNqSfSUIiUTXGEYhhYLzXPfwx5k3Bqduv0inbjBnuFHrXB3
	usTR4Be4VY0L6ElAd1B17acbQkSbw/0ib9ha50jHLoFjSfTyyNheXFI7OGdMfvLqlAXhQRiWe70
	eftVx5Fqv8qI3eoJwoL64H6UuKHP/h+azVQJAWsuq7z9PN/YZwfRz3/t7IyeRKau1Dm+06WHs+1
	M0xz9ii3fv+RDaNa3KHUokd6FcE5qPi8mdJEoSDLNxLOWvpW0fmT3dFlEtbDNi09G0brHgn03an
	w/kM=
X-Google-Smtp-Source: AGHT+IHryhoTOrFuU+nX2/XXVf7kh67HIj6pJAwGZM07cNYk4Ch5KXgJowgB3YhvDy4LBmrqXMtVIjcCmU0HL6FeUno=
X-Received: by 2002:a17:903:188f:b0:27a:186f:53ec with SMTP id
 d9443c01a7336-2951a4da98fmr50067215ad.9.1762122050659; Sun, 02 Nov 2025
 14:20:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029071406.324511-1-ojeda@kernel.org>
In-Reply-To: <20251029071406.324511-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Nov 2025 23:20:38 +0100
X-Gm-Features: AWmQ_bmo-1G4gStAz5BNMs8sUlqk3doCuOqq-d5OyHMqc8oaNkX_-Dz-ZcwIf5I
Message-ID: <CANiq72k-7f91kNrAAnwFoRYyFYjRB+mo3PCRFzTkn7E-7xrCNw@mail.gmail.com>
Subject: Re: [PATCH] rust: devres: fix private intra-doc link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 8:15=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The future move of pin-init to `syn` uncovers the following private
> intra-doc link:
>
>     error: public documentation for `Devres` links to private item `Self:=
:inner`
>        --> rust/kernel/devres.rs:106:7
>         |
>     106 | /// [`Self::inner`] is guaranteed to be initialized and is alwa=
ys accessed read-only.
>         |       ^^^^^^^^^^^ this item is private
>         |
>         =3D note: this link will resolve properly if you pass `--document=
-private-items`
>         =3D note: `-D rustdoc::private-intra-doc-links` implied by `-D wa=
rnings`
>         =3D help: to override `-D warnings` add `#[allow(rustdoc::private=
_intra_doc_links)]`
>
> Currently, when rendered, the link points to "nowhere" (an inexistent
> anchor for a "method").
>
> Thus fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: f5d3ef25d238 ("rust: devres: get rid of Devres' inner Arc")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks!

Cheers,
Miguel
