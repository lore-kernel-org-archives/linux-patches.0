Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331BC322A29
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763414656; cv=none; b=YqHS9J7QXWQ5zt5ANwvC9aHlWSoqfrJVz3D3Ja7vQj8C6cghAyzRrCYsHTRktYU6kikyh9Nb+E9jjEYVBRqDjbnr8+F3kEp5T7ovkETkbkzHImMYDaetiBly3f2i39VBXGzeddmdF4GiXBcd14USA8I2o8M5sb+ELfJ8oiP7cOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763414656; c=relaxed/simple;
	bh=G4tcmLmD4TGgP90V5T3RjMU67lyU6CakfI184VKf+7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GfSYaDflMKmi05qSFm59YkngrWMmi6iVsSPgch/NXjGlrIRPEwKjLfzhZx7MV7KTw5H43JF0cYY3rB+M64+ZT3EfU0Xf/Bbnm7pMfqbFTWG5s91w4Uf591NphJ6b6EEPijZmHjmR/yI2IVPsQ8QEdMXM5cDXkKOyKsZejnI7fhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RlB58u7z; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RlB58u7z"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b9da0ae5763so392581a12.0
        for <patches@lists.linux.dev>; Mon, 17 Nov 2025 13:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763414654; x=1764019454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4tcmLmD4TGgP90V5T3RjMU67lyU6CakfI184VKf+7g=;
        b=RlB58u7ztdQhj/d7yQtEKK2mmdeVftz3MZrOKt5CMot6KVA7q2YQl0q5gHk/fTYCHv
         SJEzGvJiYyKfaiFeRlyWd/5w78m2TcT/zN0rPiPNh+3mQbV97WXAS1FwiZfmh6jvvo9g
         5g+LZ0RI/CyFX/UaZfYXnsmokVz8LgLMM9AyenhM4FySdUWN373lyHf0o4bBOg6ByrrY
         MKQeaJtDD6aHxxSOpFlMpauRyOm/35OUIprWAGTeiaOu0wKq1QsUB2AIo401wNsgudGD
         X2/BMajkxRZ9swYyjoi1qInCA2/0YNH6cCvYDau2IVzJYZSSlGS9M1vdu4tbKUA2MY8E
         JTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763414654; x=1764019454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G4tcmLmD4TGgP90V5T3RjMU67lyU6CakfI184VKf+7g=;
        b=AqzWlkd0ZZSXb0Ho0NGBaP237SXwyMYYR7lMvFkNomiGB3ZoGtnVue7U0DAxV/p+3K
         AAFLDBBj8jS/yCxGyLTPT8QefLuf4cfVlvSL8JTkQuG3QtLlaJSPcYmXj8vZovl40Mko
         iY+GH6B7KI7/E5fYOkBMWa7iwc8GnuVT38DwHZfKqCMbiNg9RKvxBhq41mDnyAcivHMY
         K6t2RVBMZVWadB21QKn/wLCvXvPmgqpncRJhX6bxvuRknH65rWbtgvq8EmUhaEmpeT3k
         raBiA8mnIub8VSF2R4pBnGJBqDIKGbyJDGvNRwIXPZ+Q+oQ0esn6orJFTQ84W2+ZQo4U
         JdSA==
X-Forwarded-Encrypted: i=1; AJvYcCV5cuz0Mnmo48Zj66nxeBO35vHcXGMGlAR+uvDQqPQIGLWNq8jgac5IwpMmSl+BJbUj1BbPOavT@lists.linux.dev
X-Gm-Message-State: AOJu0YxNHvFOyXblF3wrgAOKf6HJdggNrphdI7mpAz+hVcJw22ooqU2Y
	HkuNs9zmpos+x4rcUJoQe1ZJlDnkxkCUe2/QlzhPG+EbQXzlqMgZaWLiHQEVWJJSCZnf/CmzpAS
	cgILbpxr3lOYy+q+I9TZkr+TKzsCNZUM=
X-Gm-Gg: ASbGncsPhb0sz6DMlC64Aqj2BRh5eg44lLPsiSDk7sQ5LntB4oWHFxdsh7Mz+jZrmVk
	b0h3KOnMeEDJVeobtgvvkaqGt+b2MJvboF47T/CK+abJbQqA6noQRykJqR+tJxCLfMcYHjKI8lM
	XD59oGd0v8HpOEy9RMWHZ5oQMmyDuzT+0Flh+kOx0wmSVitNTuRMDEB5/f++ZkCK5UlpyNp8wNN
	x9mGED5KTpcTzVbys4I/9ncnWqJTf4k78Q4DG44rmxcZIaDkfSfQa+dKFf66Z89r33EW1fF1A5j
	AH+QUYa6/7VA/c+HOeZhFfjMMQO/OMcBwROATjUXGGPbg/DEo/lsx43ZgYKWbNY4DE8qHF74/8H
	8NjU=
X-Google-Smtp-Source: AGHT+IF5e9mxc2TlUqR/IuIzDsINCnyxiPRtbODMMA08p3mcq7TW15LDpP62M3hfNnb4H0E7VwOv9J4UgcE6VN2HjBo=
X-Received: by 2002:a05:693c:2888:b0:2a4:3593:5fc6 with SMTP id
 5a478bee46e88-2a4ab7784bcmr4270948eec.0.1763414654473; Mon, 17 Nov 2025
 13:24:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117080714.876978-1-ojeda@kernel.org> <CANiq72=-w2p8sQgUKYgPG3Tx9GSUNgcVUp24k0ck2RqYgupCVg@mail.gmail.com>
 <da4877d2-65fd-4ad2-ac31-68d55bda7c07@nvidia.com>
In-Reply-To: <da4877d2-65fd-4ad2-ac31-68d55bda7c07@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 22:24:02 +0100
X-Gm-Features: AWmQ_bn2evH1S1qhbERgt7QMqGn0X-tvVoVxDBYpFTLNd4sEA7R3dYLfxUq4l5U
Message-ID: <CANiq72ki4nMTzTnLN2hH6XY_88=dsEYO8fxr=rUaDnxktPtarw@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::disallowed_names` for doctests
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Rae Moar <raemoar63@gmail.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:13=E2=80=AFPM John Hubbard <jhubbard@nvidia.com>=
 wrote:
>
> Is rust-next a rebasing branch? I was going to request a non-empty commit
> body, in order to make it more immediately clear what this does. Somethin=
g
> like:
>
> The current set of disallowed names is inherited from clippy's defaults [=
1],
> which are "foo", "baz", and "quux". This may be extended via .clipy.toml,
> which so far has no entries for disallowed names.

What do you mean by "non-empty commit body"? The commit has several
short paragraphs and mentions the `foo` example (precisely to hint at
what the lint does).

But, sure, I am happy to add a Link: tag to the lint -- I typically
add those when enabling a lint (e.g. commit db4f72c904cb ("rust:
enable `clippy::undocumented_unsafe_blocks` lint")).

Cheers,
Miguel
