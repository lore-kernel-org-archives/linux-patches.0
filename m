Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D324886A
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806303; cv=none; b=oVl3Bwt8c4RFBw+H7VZQwMJMAhjAUOF1frIMwVw0+AvOS4pmlZFV7VspDHLQRsQxIGjcAA6CtG+P7Io76tiJ2rH3ypovvis9vE5nX0Gt/EkemyIamnJytvAjJTWTmSgb+d0kfJPZ1h+md3B/D/jq3NvikpAj43b2RPQ9whTxjwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806303; c=relaxed/simple;
	bh=siPTUVsIzTBsd/qDjepG4taN8q1/zJrghO9TL+s207s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b+qz0iYkFwZZ5wj1Un/aGZMqKyX734ENYgWVkPfih1zrb5iCT59qB5U4iwFr4+hDrGfOHFQ1Oc79X3ww48V3VIQsuKbBtNCXMAxRVFIX/kolZ7yI1FtgjNJIgGfoiQJLcurRpJ9Vwgwd9+cc3iBTevPMGqDLgiAla/I2viXGH+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ar+U+EtZ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ar+U+EtZ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-301001bc6a8so969909a91.1
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 05:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744806302; x=1745411102; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siPTUVsIzTBsd/qDjepG4taN8q1/zJrghO9TL+s207s=;
        b=ar+U+EtZAFC69f/S9qXq+U0tRJ1A2bM6oAHdFj4e3SWTTqRaZHEL9V7YfZ7EGsmzr5
         PrhNKfqgfBHV8NhTjDKeal9GJAS8kaFQsTdVZW2K6jNJiZHRLkid7IMYMnqtL4QeDHZU
         66jbfa8IKOcQCfaz/OSpVkxNflCWiocnD1hbCj5WApA80aZe6PyyEf4YYI2tmaueW4A8
         2liKJWSohX+qkAl5xqnVreK2y3Sp8++Kz4JGP0fAm9gzLziY+qqr6aK4/29qs2kxuCqz
         RZwFqTYPpXZGr6sQLYGORmBn+b2+ZOgmwolytZyPxvI0tiZQNyZBtX94WaqSYEIqIgBZ
         xmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744806302; x=1745411102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siPTUVsIzTBsd/qDjepG4taN8q1/zJrghO9TL+s207s=;
        b=Laq83bhwjQl5LOgzTJuhHUqeZGDlH3DjTKC0E71wywM9S9MAG2xTfpkerZ9LQF8IOL
         YmSiHRvOEOv4idMkytM9hbKCLeR6fs5E889ZbgVIzbQkKlbyKSdRBC/CFY84VNpY7d8A
         iVYdSTr3Av0EvkUVNw9Eyy0sKJPrqx1RPyD3RFxZPHwbOANfjGr4tWlS8xUF83A6narK
         d6bHWvwm7AZRV8bwfPK3amCx/wED1tofs0jV2sAXwTU0h6S2AxAzrC9sR7e0TUyyYpg5
         flgYiTAuqmDfbYiEtzM9duqcl3cx2HcTUoFP3/alhUiT/ARlUGGgLkf8LzwwpsUj2AaX
         XyOw==
X-Forwarded-Encrypted: i=1; AJvYcCXlLfgOViHDDGgHB3s7t4ZzGJCw2yzIWzeEZGT257Yp6j5IaRSmfLSH9sG51A4wliIvy8PRthmc@lists.linux.dev
X-Gm-Message-State: AOJu0YxJmeBv4X9XUq/MW0BdkPnnl0/uPJ9kYUUuZyDGlyeNe11OqRNA
	3Cw5SWf/gjQR8vDebvg1UKTSWwDCF890SLfa0t11pTIAkYdeZCq1HqkmErOuIyN8B1qmuiUC262
	lKbFnGP05irwznFi+cT9gzkfAX3c=
X-Gm-Gg: ASbGnctbX2oCC1Swi6Or0YK6EISMwlxbQNepKOLb1uZmn2hhf/LRJCxOloU7WjpR8Tk
	Qc4cXyJXsy7FPde99bGjM5Sg56ot/CU4D0Q40/EQs1jrtYnEEYYT8o9bzi8OHVEsytYOgeSUzBM
	p/4FLwQ5Mr+Hq4Q+Jz6obw3A==
X-Google-Smtp-Source: AGHT+IEtX7+Mzcd7PaVlTQ/xw6YegGp6oJpy5FiA5NPzkNyVsvhcGyv02RO1C1uD2MXjywGXi+E2R+MmA4vLZlpoRfc=
X-Received: by 2002:a17:90b:3b84:b0:2fe:b972:a2c3 with SMTP id
 98e67ed59e1d1-30863c503bcmr961540a91.0.1744806301728; Wed, 16 Apr 2025
 05:25:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250416122106.2554208-1-ojeda@kernel.org>
In-Reply-To: <20250416122106.2554208-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 16 Apr 2025 14:24:47 +0200
X-Gm-Features: ATxdqUFhmQ4ZxWk7yUIUSPcJ20pL36JoUN822yjRXlrDsVMepY9Ii9ArJvY4sQU
Message-ID: <CANiq72msZ7FUo0=KXQjMkXjfm3jVaNhhVDCu_BFXRTL_xC0vog@mail.gmail.com>
Subject: Re: [PATCH] drm/panic: use `///` for private items too
To: Miguel Ojeda <ojeda@kernel.org>, Jocelyn Falempe <jfalempe@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 2:21=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `///` should still be used for private items [1]. Some of the items in
> this file do so already, so do it for a few other clear candidates in
> the file.
>
> Link: https://lore.kernel.org/rust-for-linux/20250416112454.2503872-1-oje=
da@kernel.org/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Sorry, I forgot the Cc: Jocelyn (it could be nice to have a
`MAINTAINERS` entry for this one).

Cheers,
Miguel
