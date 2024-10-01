Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7A1C9EAA
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727802486; cv=none; b=aEOt55zDERj9iODXDMGxmenFJzGbk83a1gn9ldYDkBA/6v0EPr/x5DnzvqEF2jhOAFafJtFsTEG4h+B35BQrdcExZ4MwW+K485OdYsJghKovTr0h9ywkpLdTezylDasgOvsYK5hpC+OeUuW9RBEmSF5nBije+XNgrsxCq8o+ACE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727802486; c=relaxed/simple;
	bh=vwbp+UPz/hdu0MRIIMeSyF1qi+KBmELnI6g4Wa93d9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jAobJWCYUyE7nZHntngL8MzHyGPDr/Qdwd2PPl8BY+VJeanroFvzjQiztGR9OuMVWrvnC/nCfYKOSj6yQ2AfjUWp3rCCU8hiPd1yLYY4vLLeAHXeugp4Hlfp5AybwrfKFulODOe75RNu7QquoUkGk0PyeAUaq9BKfTCWtesVJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SxlqYcYT; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxlqYcYT"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-717880daae7so299183b3a.0
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 10:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727802485; x=1728407285; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwbp+UPz/hdu0MRIIMeSyF1qi+KBmELnI6g4Wa93d9Y=;
        b=SxlqYcYThbqAteTwVpJATYk1jN5rg4iUPT4NHMwip2VsYcrQgyQlkFq0fUhRdyK52/
         ALPZfU3YHBxQ+xWoCo7Q238bF/amVRoeVwkh7rptcfQZ+P+HC8RBqP2CxJRWmkAzjqXr
         DjK5wuEkbMkxUMGSVZVJtWOdkwBSQ2wMIYYgbJ/khdA17SlEGMbA4p487NIZ1l5Xcw90
         LceXqgtSMUKGg0AFhkNkQtE+YgEOUvFQLV8kKMngHpsgRo7lz6g2GS7S+XN0bPIxDU9w
         5V0gpJX9CMzCSLUuYtr5JLul+/J+G9iN8eRgQFBnRlbY7sB6oXFPvl+/nLlwDlgQ1xnk
         9u5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727802485; x=1728407285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwbp+UPz/hdu0MRIIMeSyF1qi+KBmELnI6g4Wa93d9Y=;
        b=jQwrP1KUbvOz9ufP4U7ee/t8n5Fi25mkaozJYAlEOTMHycSCklYpkvnBHUnFepVicK
         +B0T8qUG4x6+n0fgikzqxc4tCZTu6w76hsz/ikMrTwtscnFqYValzlnkoc4QopXtcH+K
         v8Kyoig+5BPA5C2zrOdFV8tMN2UbwwilWl+mwIwp+If4DwTmSSD/dqAPM79rQnxe6sPY
         VJDtmpZdbyPaiHQ2tj38++D0xreLcsUEHcGuAGgSyzPSCCIuyszThcs2xx5XyneRCqog
         PAkzDOsMWQf6B3YF7OyASExMqqyjdpcJI5CLqbgPFor5soGG8ZzDHx82oJUZgjtt+jCJ
         odtA==
X-Forwarded-Encrypted: i=1; AJvYcCU2UKJU9TfIesVISt4/w9/dvFCw8CmSfRvEDsfrGhjodnFPZ/Ma5bELR52aU+JaZeDQBHL5KIud@lists.linux.dev
X-Gm-Message-State: AOJu0YwbxDY6VSe+w0+BJgRxkwRcvUK9XPomQGDCrmzvTxllqVbrc4c7
	4ZNK1Um0lz3/kM14m7DRC/HZfPcVLhNO69Iv8SpH20eeAoWF7Z+JC+2yjLde2+K7zq7NgPP6Lww
	2PZ6e7PElJxdRHNIZQZAB5RY8AMg=
X-Google-Smtp-Source: AGHT+IHXiDWrZCIYTtFJIHnFKlVdyYsAIHCO1/HxJUKXpCHOIjUjLzYXJy2WFf/Ckl1G/UBzfmYHkIFgZAMA36G3DXY=
X-Received: by 2002:a05:6a00:2e9f:b0:710:51cd:ed43 with SMTP id
 d2e1a72fcca58-71dc5c49741mr260314b3a.1.1727802484673; Tue, 01 Oct 2024
 10:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
 <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com>
 <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com> <22A86237-4168-4D4A-8782-7A65AFAEC44C@gmail.com>
In-Reply-To: <22A86237-4168-4D4A-8782-7A65AFAEC44C@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 1 Oct 2024 19:07:52 +0200
Message-ID: <CANiq72=MKW-Kt50CsV1DNw3Dj45fXucFzhB0uyNJyNq04_QbfA@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
To: comex <comexk@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 8, 2024 at 12:22=E2=80=AFAM comex <comexk@gmail.com> wrote:
>
> You can always hide the pragmas behind a macro:
>
> https://gcc.godbolt.org/z/WTEaYWW8c
>
> It=E2=80=99s not perfect, because warning names sometimes differ between =
GCC and Clang, among other reasons.

That could be an interesting option for some projects, but yeah, as
you say, I think it is far from ideal. It breaks `clang-format`,
wrapping functions/structs/... would look weird, and generally the
syntax gets on the way of the "normal" code (so even for statements
one would probably want to keep the start and end on their own lines).

Cheers,
Miguel
