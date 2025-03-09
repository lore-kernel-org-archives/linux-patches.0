Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A87714D2BB
	for <patches@lists.linux.dev>; Sun,  9 Mar 2025 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741530070; cv=none; b=UVU+wsu6na2VYjQTQweXW3UYTZa3sJZCRDzuFJZU4iWNhyKeI0acIWTz5FdeW5W+eSXvkftKHqm7QCoDPrLMwrY77Lfy2sf9rCm9g0g8lVT9g5d6O26MOjazdSlNCHCaAttMckw4ldV1FWbO2d2cIsnR2bkJT53HZ1TJ5pShcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741530070; c=relaxed/simple;
	bh=kFz5YSiZo92lO+L2dWa5k9GVCC5TiWRcKiFDODFxgac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TE9vYVl38UOxPfg7VDOZzgdE3BGeoHMtvYA8EoiQ+FPICy8fZyu0kjQ64G5ht8qzlafUZUE1sK3j65N7bUx6oTukcRACNMWG/8mbhtkTBltIYczofClLXqP84H8KzFvp6PZbV7wxDOJk0PpqW0cHe70H2QspWxQ+7OQ7ewFpJB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMJ2NLQP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMJ2NLQP"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2240ff0bd6eso6846655ad.0
        for <patches@lists.linux.dev>; Sun, 09 Mar 2025 07:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741530068; x=1742134868; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lcZKJiEWpL/ikPP0BnD1JJpmE5wF+3Sm+aFgv0bnpmY=;
        b=mMJ2NLQPZrwM17dz0Magpxmd1ogO1M8pi637JiI+6tG8DSmxNHInCiFTonpz0gMWZ1
         wjBcBBbLkLlb4l9oYBZHe+pPovDFHUGp2ChHk62FzAmkOr90AyrgpXO/qmVBSmC3yo+H
         nntv1/wUCKhzJrdtcEqSab3KO4YW4w5QynEC37GZPKZoSiAbB5pwa3tpd+VsY/Yr3lX1
         lc0ht2Ysn60re5JxNYjox3Vb01W66Hg9OXi2+qAfrPcNxk8lQTZ25Z7+aM/CCorHG6BU
         J5W3cKBhcz0jw6Tgu8sUNA5F+oYTYssmgDWTmbAL4UP35+GcxN7eUCbjjUdezo4aS1rH
         i4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741530068; x=1742134868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lcZKJiEWpL/ikPP0BnD1JJpmE5wF+3Sm+aFgv0bnpmY=;
        b=U2clZLMd/JYswv9VYM7OwEweMSK2/8dcMmpQ6qwfVHHec62HHLKTbmO95EBbmNj8y0
         NOhBUkKr5T6HRq7/1lREm4+h7G7PSgJs5FnbLcX2idsUth0XWQ8tOb2QcWeQyOs1pEGJ
         GozDv5oeuNwh4tpr9MfXBTevNXzie6t/zv7MmgDrF+DRrocDRjkhZ+VDi52y6aOLeYmB
         eoI2hcibm/MOjHZzQlJL6xxd/pxilZd33N246L/C4W9R3gfl0BcC5O8IQ2vE1UKyHypT
         kU5BG5H2wfiXbfBLtEti/pyHvv1N5m0kKatSv99EMgqDgejOnA3GuiWK/pJAq1CqDzcU
         +uUg==
X-Forwarded-Encrypted: i=1; AJvYcCXp7luJ/ppghgW52UK2TcjnLfAEnOg+wtJECv11yDJ9NBdwZfV4I0hgcOO37jDOXmoXF8clB1hK@lists.linux.dev
X-Gm-Message-State: AOJu0Ywwe2M17SSYFyQwOV/QeNLM4W/Al2ssCyrbNlXHkoGQxad1zB8z
	q/syxA786YYKpl5AC1cpi2oYgmvQQJkh0eQhiKErFZzUytPzVoB9bvtZnp2dn5hlH3lFn8hdZ/w
	glhdoWWNRMJiWCApHKvYxdiB9+RY=
X-Gm-Gg: ASbGncuktnssUDLygk5fSFbmJvC/d/TMH66SB2axulfsSNWtc4JYRLzVaxj9rtKznQ2
	jS9zJbcfxVDVvyMpbvl+JpzpJ5lZwswLkQ/nomhlWJzL5ZGz7DxER00wrIqOoLVFllYikWJM3Fp
	0DjkdA/ogHtzGsZDskxhFPqq40+TBSC80IgUSk
X-Google-Smtp-Source: AGHT+IFqt9+K+LkkhZQI/j7j18xLXdUrgiOh381NANrLpi56JrycNnjHKVXe6M7Y/1XtbBF36GrsX8R3V2l5l5/ytlA=
X-Received: by 2002:a17:902:ce05:b0:224:e0e:e08b with SMTP id
 d9443c01a7336-22541628a67mr37018065ad.0.1741530068141; Sun, 09 Mar 2025
 07:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307225008.779961-1-ojeda@kernel.org> <33f6c73c-4a2d-42b3-b033-921d2e1eaeac@0upti.me>
In-Reply-To: <33f6c73c-4a2d-42b3-b033-921d2e1eaeac@0upti.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 9 Mar 2025 15:20:56 +0100
X-Gm-Features: AQ5f1JpUGPAQ7z4B6Amb_zgIIluN1p4Baws9MpoHBcRwia-Wvg6nXk_7CSYTFG8
Message-ID: <CANiq72nu71ETyLpu=GwbzpnMJg3jetL5zSSh3AE+DoQDMgHAwA@mail.gmail.com>
Subject: Re: [PATCH 6.12.y 00/60] `alloc`, `#[expect]` and "Custom FFI"
To: Ilya K <me@0upti.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, 
	Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, 
	NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 9, 2025 at 1:42=E2=80=AFPM Ilya K <me@0upti.me> wrote:
>
> Hi, I think this is missing one final change, specifically 27c7518e,
> or rather, the only line of it that applies:
>
>  pub unsafe extern "C" fn drm_panic_qr_generate(
> -    url: *const i8,
> +    url: *const kernel::ffi::c_char,
>
> Without it, the build fails on Rust 1.85 / aarch64.

Bah, sorry, my bad, that is embarrassing... It is not just that one --
the actual remap is not there. Let me re-send...

Greg: no changes except for the 2 extra on top you will see.

It still holds that the x86_64 build still builds commit-by-commit,
and I double-checked that hash builds for x86_64, arm64 and riscv64
with the min and max compilers.

Let me also run a test for loongarch64 with the unrelated fix applied.

Cheers,
Miguel
