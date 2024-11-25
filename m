Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5532187849
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527753; cv=none; b=LVX9xd+y3k1CMBnetNj+UchnYd+CL7vHz1mV9EAJ3tLk91fH71VozS3HY71egdDG2FcOHSrea1kRD6lJWdIKPfK4bmAsGqTXNXH+/jmVU37LZWJ4FIm4C9E8LiUz/x1RZf01eJQNmEmtQe3f41R4UFVIVtNDVImrF6qbSI8KpAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527753; c=relaxed/simple;
	bh=D79QQIbDICLDOLd2x4NMBzjgcwjTiPN39k+g0fUIyOI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YwXZfYxdcG8WRYmNXcpVASdoQTzN0NcdtnZPZqfAyJP11brheQbv9YJ043kH4aH6pHggZAvlTkNmVRfbv9DAH+cXjrJ3Alpo4nAvxHf7S5ohGqkh9EyFpHBLFvfug0y7hIy3AwzZuPPntIdlCV3Q23e24oMvK6e3E5PHBo+awpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTVZNOhU; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTVZNOhU"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ea22159119so777274a91.0
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732527751; x=1733132551; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D79QQIbDICLDOLd2x4NMBzjgcwjTiPN39k+g0fUIyOI=;
        b=HTVZNOhUDhb/w5QWxlPFt9Qxltm2WOkUUcpoKRIzOffnYuTVRAgRz9JIFiqrxNnbxB
         K4eCanCoKJA1N+eDR5fwgnaT5t0mZxW30jqMVJ3hh6UEm66Ah18FPmpwb70UVdJPX6Wn
         WukEnGd+03dZzFIZVP2Va+hVnn3t+HzDLqTXgpqGnbBnOalmpxH/ZLSsQXwKbeSv5kOo
         To1x/Yem3zrwsa8jUnl2oIQ4vdN5H46PEoVAVQmoXoZUZsGHXPnFoSvth7rNDHw+nZqM
         tmyVjCZtVLmgHn6SsYTmxEK0/KnJUqI0apQOzhOT9wtcExj0rh3wN46G/ekrA1Aqxwnd
         TtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732527751; x=1733132551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D79QQIbDICLDOLd2x4NMBzjgcwjTiPN39k+g0fUIyOI=;
        b=YfIVaA2IjCKvhSg+Hi3HTGKo0kxcfTkERfqhNoe16deTiSdy1/CXOac4KqLhLWWi6u
         V5z8WaYGSeMtJE/R79RCT4TQBOOXKo5k8YK7lq4kibUxvZvABSBgXdO5+iQy0QX03VQb
         B+l/aEdr+iPrQzQPnzmPeGDVdXLIlTO8tbv7t5VdPyHeiQCJvpgvrVc6pMr7XxpsVt2K
         ofsZ4S55M8k5/6SA8uUiRKj2kGrZeIxgCb5I20nq0U8iGF/bMDIk5g7UIkrkmTuU9ONM
         Tu2ZMJRXRT2KUyHBPgFHCe57NH+Qujl0na9ZHpoilGsg3EOWxBF130tvmPfUofZWkd3S
         Kz6Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2HIHMYC+t0gIExQpNrt6rYUk39atQKP53GSryaRNvlPJMor80d1VmhpsnyGDBWfuO+N4c9nNF@lists.linux.dev
X-Gm-Message-State: AOJu0YxvKt4I0QJf1laxSuPteZM0F9DzhHEnBxCkyLkOHbqxb+fJcXc6
	XdMbwFptx3Go25NRgQkBFEJH55q62p5YakFolroel5QM2S6dz+n1e3Y6C/sZsfuzFn0Ss2y3BET
	8GDzKijVdVAUn7HCyBnfQ4+xVUg0=
X-Gm-Gg: ASbGncuV/rgOdS62+7dshuZ27V5ul+pHxM0SDmvvBPELeoT8w0tl55ae5HXzZcyCXp5
	BKNmVKo4EUGRuNytn8DUU6br0Xt7H+Pw=
X-Google-Smtp-Source: AGHT+IEGLZ++8tt2PlctfEq4UgYYL3skiDg2q+3/WmcEXus7ZhGZuBmsYxzhmr1PBfKiM65aW3eB0dSGItRD95f+BVM=
X-Received: by 2002:a17:90b:38d0:b0:2ea:b2d7:4a24 with SMTP id
 98e67ed59e1d1-2eb0e8906a4mr6483669a91.8.1732527751250; Mon, 25 Nov 2024
 01:42:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org> <CAH5fLggg5f0KpaObVtZc7WaxHjUqbhCDsn5CwnA5-3df2HEjnw@mail.gmail.com>
In-Reply-To: <CAH5fLggg5f0KpaObVtZc7WaxHjUqbhCDsn5CwnA5-3df2HEjnw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 10:42:19 +0100
Message-ID: <CANiq72moPEL5s0T3ELEDvWiE6Lz5oZv2hZnziV5A60EP65bkkQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Christian Poveda <git@pvdrz.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 10:08=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> Just to double-check, the problem is that bindgen currently doesn't
> get any information about the rustc we're using, so it may generate
> code invalid on the rustc we are actually using?

Exactly: it doesn't at the moment, but eventually a future release could.

Of course, people using the latest stable `rustc` would likely never
see an issue. But there may be people e.g. building `bindgen` on their
own, and thus likely picking the latest version, while using an older
Rust toolchain from their distribution instead of, say, `rustup`.

Cheers,
Miguel
