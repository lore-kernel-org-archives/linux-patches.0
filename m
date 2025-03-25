Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9361CAA9C
	for <patches@lists.linux.dev>; Tue, 25 Mar 2025 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742932112; cv=none; b=i69SQEF0Dy5n9czDfDtI/bGw4ICmJKk/1RfpyWhIGFUkdVo2txfIS5AWeLmGVXRizcyi1u1XJ7MNPxFqJ5DgRYKqRq66bfQSX3XaC2j01lDgbrgpFNX2T+aAPtPrvGrOpW0TJU/Rg3qKapz2AnTGZapNnAmCn8s77dvV/IvcYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742932112; c=relaxed/simple;
	bh=kWRz7TnGEyqbpdoqqbqwf78f4CQUMOrIDZK4ebHnEkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2nwpS8nOPssCcxy8OAIACxXdo5YV02jk5lExqnlv71wI88I539kZsADfypPQQHEmk0NT6r/sgO966LeLlCuakuuCs9grSeOoHh/cKwjjjVpu5T3P69FYMXZzNOp1R9O2PamrzuW5Ow107DqNsr832xIgm/+TYDjP1lDuRM3/OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YN8I1KK0; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YN8I1KK0"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22403c99457so14007035ad.3
        for <patches@lists.linux.dev>; Tue, 25 Mar 2025 12:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742932110; x=1743536910; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8OkNb0Gk1huvCdNeb+R5YeTaXEOuCO6fGN5IzB1KVw=;
        b=YN8I1KK0WLpltv0F2D2IYHLA4/eMvLmq+Xobiiv6kHJLRi9TTzrr0e6rxIMDiKP8c6
         e8aY/emdncuFY0WPvVVjVTaiDnij6zPQBvAo1PvJ8rCpCcs+201gW/zHBN0H8M2Md1Zs
         1y3ifgogAjDeb7itzLqM7iiCgWus1Z3LTzVSfzzzQZcvPen81sPJK3fHTqmyUYY9/gPH
         L9gTYFvDJX+QfUT9oYia0q8HnrrlD3hSZfW7p5wpexh8lLFJC3YesRifFdKL+uRN9vLK
         0+FKZ+7GUIApAiVba+74Y3Xdp7VvfwSgYG8tlYHij1GbyDo1wSq+uCkdJeQ2yvBuJUIx
         yS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742932110; x=1743536910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8OkNb0Gk1huvCdNeb+R5YeTaXEOuCO6fGN5IzB1KVw=;
        b=VWEBG9cvtqdMCU7S3l+awX/J+XtWPLEkT7KWyW/1YJV5XlExWkfGXydBONwWTYFODJ
         eRezs4j1THf8c0nWeIkWpwlM1+9Cb5LSXBAdd8x7nAZDh9vaiyK02T/yjjhPEaYe9ni9
         x6Et8Eg8lqhrWILww+OYVhIMN+LdG96MSxym/3hDB/f9E/t6xECUV00IrTHnAkcPi+Yz
         lWPTyj1uGP1pR5EH1+sr45dxFohSLhoohNglZdbg8aid793L5VhAUdZy5/O/Sz3p5EdY
         lOb0wi+zC0EhVW8+bxdpe3IUSL6sBt848ruGohkWlkkM0+oXJzh4/nVvZEC6Eqe3GDja
         ji7w==
X-Forwarded-Encrypted: i=1; AJvYcCX/HNJh0z35bOrWM2muEOtMFtSwcovG9G9SRYubxbKcK5ogaWSHg/W3vISc5A2ttojglCe/CLBI@lists.linux.dev
X-Gm-Message-State: AOJu0YxH2j2e2xrxT4zwWvLE+r68JHsuzqDklh0Dm4xzES6e/mdM+3UJ
	YeNMJbmU6cndYUXtdpaBvMGebj2/62fmtzmG+8rPcePP/nSyGyrW+L9iieR/CV2Ow9KE3QtBsoq
	D6JyLcmclAeHt/OvS+i0jNLu/Uko=
X-Gm-Gg: ASbGncvfnu1B0wHdTIPvTq9BWKJYviWvIqZhzX6/dcxQA5CsAAn6P2DoTCOt5t5Kzy7
	joRd+mE9simy0R6Qavws4g2ziu8azGNqEREKl+702sk8DTMhIDoTWK2cG8QChtA95qmDujA+sMm
	WYQyNEbgGL70Cts0wySxm2WUmv2g==
X-Google-Smtp-Source: AGHT+IFxBWD68KB8/HxS5e8dGM3BB7KTxo4N4mhnjuZj5L+9yyTC70mMnIp1cyTclOTT83cY3hEXidYZMRLFX4HVM5Y=
X-Received: by 2002:a17:903:234e:b0:223:5525:622f with SMTP id
 d9443c01a7336-22780c503a9mr99495195ad.1.1742932109937; Tue, 25 Mar 2025
 12:48:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325184309.97170-1-ojeda@kernel.org>
In-Reply-To: <20250325184309.97170-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 25 Mar 2025 20:48:17 +0100
X-Gm-Features: AQ5f1JpNyVdd47wH2I_NWPgt1x_uShOAv6Q_Kz6PcSYhTfdjyZuGqcfgDJh1oE8
Message-ID: <CANiq72kWumOHt=VgV3mb2G4mOE3bCVUCUrKdjk4caFJPVCTBbA@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `bindgen` issue with forward references
 to `enum` types
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 7:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Instead, let's have a section at the top of our `bindings_helper.h` that
> `#include`s the headers with the affected types -- hopefully there are
> not many cases and there is a single ordering that covers all cases.

By the way, I was curious and from a quick look at generated bindings
lines matching `type.*i32` for a x86_64 build I have, I see only other
three cases:

  - `key_serial_t` is not an `enum`, i.e. it is correct.

  - `fs_value_type` and `drm_mode_status` are both `enum`s, and they
indeed suffer from this issue. However, we do not use them and I don't
see any patches posted for them either.

Those are good news.

However, there are also bad news: if for instance we actually needed
either of those two latter ones, then we cannot just include the
header that defines them, because that header happens to include
others that in turn use forward references to that `enum` the root one
defines.

So in some cases, if we start to use them before we have a fix, would
require C header changes to avoid the forward references. Thus, for
those, I think it may be simpler to instead use a cast and mark them
with a comment so that we know we should clean them up.

Cheers,
Miguel
