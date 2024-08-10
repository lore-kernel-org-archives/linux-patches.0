Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33A012F399
	for <patches@lists.linux.dev>; Sat, 10 Aug 2024 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723301128; cv=none; b=gn0uRu8ATbf+YzcPNS9zAoOWdaTZIWYxyI8hWejEMDou6JQGeXC1hVLh5vTGZcXKrxOTgJnlZe3TNxHyVXZNkSHb1y6wZWcl/QPjmYiiLe6H1bxSh6vzi6TXZNa32kVr+1ONV7EAJvW/AjMPrnaDyBSrEDGOPTbIkJlQ+sKY4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723301128; c=relaxed/simple;
	bh=9S4F9A6PaX/W1YdIFNWkFn30l1Nc6GZXCt3lt+ixrQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFTLgaPemCO286DI6b3O+ouYMCzqT6T0eL/lZFjzdaxxAu6NdGbyQbonG4F7UsTygfbSyo+Y0dXQAV9Kaa2/EAndHOgR3QE0OV8KDNmIl2p5PJW8qPwxc/Fck8KWwPtKePXP7w2MaDHVLtf896c5P3aURxrNQAtYJFvmMUzQnRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERhUVZGw; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERhUVZGw"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cf93dc11c6so2382137a91.1
        for <patches@lists.linux.dev>; Sat, 10 Aug 2024 07:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723301125; x=1723905925; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9S4F9A6PaX/W1YdIFNWkFn30l1Nc6GZXCt3lt+ixrQg=;
        b=ERhUVZGwK9MugDHXZbbdR376r+MMFU0aAyfe5v1yNapeHmhTSqerCSAQjzS732VjmH
         QSnbhsTGPQe55OEv1F2cAKu5pegsWOWEgKlUijj6Rr5y1WqKtHLmrL58Ymmxe/aJmtlX
         G5YBeTyOzPz2MyDXafwywJLQvu/OwQTsK+aviomdpfltC4vKXpedYe+EoojnTL2DbodU
         vWVzW/rq6xjE/ipw+ZZmIEdjRMVP9p3S6eGSpou9tM0PzVADWjRQr4hFbZsuTdu574N0
         LWowUmPAxAaxRJGh2KJJ+osQlkMFi+ZWAVEpa5HtE97Y1IbSWYC5Tu4HxM0LnL+VHvsE
         X7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723301125; x=1723905925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9S4F9A6PaX/W1YdIFNWkFn30l1Nc6GZXCt3lt+ixrQg=;
        b=MZsOnCazwUxYyEscwE6Pp9PIJnc4Vu92MslIcRVyzUNChk5F2gbeQhRfXDKFT7Wq23
         e45oL2XxguLO6xBcM+zKyhEnyAvT6IZKe8FBwpxTLDE584yF/qDLQ96lv3CYvodqRG6P
         DVPanU4DoHi4A/jUHvZbV9EIYimh6oYRh8rFFEJJLHBChIZGm1vW8KiicLriB0JB5o+C
         pidCGNm0gw2erKSl5rLgK4WX77zmFaUU8qIrJpvz0h3oGa7tY0McP+h2F8dh4Bce6bAo
         /daRWcYWgn48HPpbKzZW7v0hciYt29gU0gJ/eFS4vhmPyo8SUudirm2eimrEgwvcYh2a
         8Qbg==
X-Forwarded-Encrypted: i=1; AJvYcCWAaBqzah1w84C9U4xd2mzZPJXVculNrvomPyFAlwC7OUg2VGcy8CcI7NWHHA4q4fZ5HCI214U4waWcK+Yj8u5b85B816bx1Q==
X-Gm-Message-State: AOJu0YwnLBmMRO2BmWxHg6kE8Hr+8pZGF//xkfaC/fVcGuofgg1R3Jrc
	ZMof+eUkq2MTRaZrY8oMR/h7z4MwzneJQt2KeyWNuCo/ZpdLCZydg8R0TTA2P+2pEp4xFebCh6K
	2Xtr5ubohG7MPn4VayPRI2sox/Lk=
X-Google-Smtp-Source: AGHT+IGfAWSZ5LwbG80gDM0OaU5dKBmBaQzIewIaSEbnuIWbzBzupl1sGtdFp/rRW2syqJvIsKdkY1uR23zTPg1Hxbc=
X-Received: by 2002:a17:90b:1b0d:b0:2d2:453:12cb with SMTP id
 98e67ed59e1d1-2d204531848mr1563929a91.2.1723301124946; Sat, 10 Aug 2024
 07:45:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-3-ojeda@kernel.org>
 <652ElsLaWV50vwbKOQc-kTFLeaf8wUGPKNhc8B8tS6EqgqzSj5k_tHgqCTUcxfSZkYvB1xC_N2pmNIA-oq2q9irSPp2XNaaiv67pZojm_9I=@protonmail.com>
In-Reply-To: <652ElsLaWV50vwbKOQc-kTFLeaf8wUGPKNhc8B8tS6EqgqzSj5k_tHgqCTUcxfSZkYvB1xC_N2pmNIA-oq2q9irSPp2XNaaiv67pZojm_9I=@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 16:45:11 +0200
Message-ID: <CANiq72kXNCww6oHKNiPr-mGq3gQsH-kUbK-C9B_3bY-ozkiznA@mail.gmail.com>
Subject: Re: [PATCH 2/6] kbuild: rust: make command for `RUSTC_VERSION_TEXT`
 closer to the `CC` one
To: =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 10, 2024 at 3:44=E2=80=AFPM Bj=C3=B6rn Roy Baron
<bjorn3_gh@protonmail.com> wrote:
>
> Cargo depends on the rustc version string not getting localized. Or to be=
 precise it depends on the version string being fixed for a given rustc ver=
sion, which would not be the case if the value of LC_ALL could change the v=
ersion string. If the version string changes, cargo will rebuild everything=
 from scratch. There is also not really anything to localize in the non-ver=
bose version string. I guess setting LC_ALL doesn't hurt either though.

Thanks Bj=C3=B6rn -- yeah, I agree it works either way (also for `head` as
Masahiro mentioned).

I made this commit to make it as close as possible to the C one, since
in the next patch it gets moved to another place where both commands
go together.

It is reasonable to argue that it makes it more complex and slower, so
I am happy dropping it.

Cheers,
Miguel
