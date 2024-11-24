Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120F01514CC
	for <patches@lists.linux.dev>; Sun, 24 Nov 2024 23:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732492553; cv=none; b=D8/2Pt42ZJVxh5tLo3ZGxC2iGiKZVvgoZOoLENA7I/wlBiZnLNHU3VjUzcRwa1JpPihvSbXP/7WhqW4IMYAknoV4v5DtwGJSmSto9OUxQngxSwQf60ybctGpPSdstfANO4rXVkYOa6OyvXUSED5pwrpOFr5ggAM9i8C0Om/kDdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732492553; c=relaxed/simple;
	bh=ahIJZ5ejiMwN/JQi1QRVHKcYWH3Zh8Fe+Ycej3jmRV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnpBTORh63Vv0rKTuTJUrqlDb23cmZgnsoptnArSkXkfE25wP11bCif37Ed9sq4xIV51N+Mvdm4UL7aB3fp6L9HFKcxGyAZrloG7g9Muf/iUdC4+LX1g9GxHxg6WlhBAYqoQbEUftlE/pbH3K1S8BFxyYuTRWXfzezPdjX71e0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQS2hNdl; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQS2hNdl"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ea33a70fdfso650082a91.2
        for <patches@lists.linux.dev>; Sun, 24 Nov 2024 15:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732492551; x=1733097351; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahIJZ5ejiMwN/JQi1QRVHKcYWH3Zh8Fe+Ycej3jmRV0=;
        b=GQS2hNdlyeyEfff0iu42WdB1gGEc7fYUg9hTiTW5ZI4MMdJ0jL2hBsnMcGR6U0QeN9
         B1urSU1vcjRE4dXbXScMc9V0WDLF1PxsHSOqU82wHwvpOSPnpo1ECoHKmytVlTus/gx0
         PswtOPnJ9zd4ktZ3ZLn1gJSvLihhQGdCdorBl/HPxuIXiCVU/cuN/4o4gd3r2vNeDcsd
         t/UfLNWQfEePUwB2n+XIQ9gr1465FpyW04Y+myEbdQD0gB4sRUCM1aN5p1mp6Yd/6y00
         dlO/LNXevfet3jJ6TX1+YkNM5Nw/dv5W4Ufe3+hY/0W9Rz4cUB6yYvCJ/HyCmHF8Zdec
         z5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732492551; x=1733097351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahIJZ5ejiMwN/JQi1QRVHKcYWH3Zh8Fe+Ycej3jmRV0=;
        b=gyicXE5qHQ7dwE+cnM73iHk5QKX7l2FpxzJun584iP5lx/uFpM9djUIjYuVRrnIGtW
         2QPNHNYgNVaN930JpNoNWhODN/GlpPwhUsJdWwaXGgOT9uWCqUxklTdCmDAN53FzJLD7
         f1YG2X3J0cyfpwYu5m3sEKjSk0foIJm0v+7saknn2F9VWKCRk98L2X1jD0gxOsrSaclm
         OF8lMhQo3vA0rnQdEjD09LjRliraDRxixe+ojXZF1yzT411TqmO+td6vf0bFNRi80fm/
         oAldBSbbqrjMWsZzjIQ32xXhtAfqrPYa/0mwmxQKwUD5Ix2MzsHpGE+l49L2ELj9VhfJ
         tw5A==
X-Forwarded-Encrypted: i=1; AJvYcCXUSc6OkJCJZRwZQtidyJwsEX0VYwuOq8ErX3InbILI53pzeVA6/ffU8zwi0oAe9wwK/TlM4dDS@lists.linux.dev
X-Gm-Message-State: AOJu0YyiZNIjd9nNbLbgyj0RaiEas1AQncKHlcfdvfPkn5ISnaCRNy3N
	TaVyFl2urEfaafxHMGhzyFpicQwsjXxNfevvsksJh+VT9RZtxPVwuO1c30nOFShQzvounoxbJ1e
	++cEOrgQKdguzq0umBXCLh2gUGTU=
X-Gm-Gg: ASbGncvbp2EbG04EAqMkv9qttMaem9bYATCD910EzcVwywFEq/Q5mHZKN6sCfiPXZ9g
	aud/RYpYc/8wugPkFBFre5OkjG/Vd1g==
X-Google-Smtp-Source: AGHT+IE0GVGXq6FAVz/1ZUH7H5yK+sxF6g6rGaYnxrsAhuXE3bPolOfAEBR2JrYP4HASDtXdNgIzJ9T+bA3QL/2iIhQ=
X-Received: by 2002:a17:90b:1b51:b0:2ea:580f:6c0c with SMTP id
 98e67ed59e1d1-2eb0e024be7mr6003360a91.1.1732492551429; Sun, 24 Nov 2024
 15:55:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241116181538.369355-1-ojeda@kernel.org> <CAH5fLgjU3BUU4nu6LscYKHTtZ8WSChXvf391v5v=xNK_2w7nrw@mail.gmail.com>
In-Reply-To: <CAH5fLgjU3BUU4nu6LscYKHTtZ8WSChXvf391v5v=xNK_2w7nrw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 00:55:37 +0100
Message-ID: <CANiq72mSo9aq9Wu0WemVRsC2XXDKvw2D=rTAXg5eUF3g+yHO1g@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::needless_lifetimes`
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 10:51=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> Does this need any backports to keep old kernels warning-free on new comp=
ilers?

+1, for stable, yeah, if we want to keep it Clippy-clean (which I
think we should, especially given it is straightforward). I will send
it.

For the LTSs, which only support a single compiler, there is no need.

Cheers,
Miguel
