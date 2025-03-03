Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCA1DE3A4
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740994445; cv=none; b=FEqsrTVrBSfebrViPWOigu/7PH02ZT8B66C6NrrcX/U6+wU9bXD7QWHJXpZsy9xEG7gXGMLYpjfJc6fXp/O+xDR0HEwTa5WY6a1ZEWS2FqssjFCoRW2j8EuYYuzwpXE/nAuJrwPXHbNUZqJdDEA7/Pc12gVxaWFRJLNYQezNTV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740994445; c=relaxed/simple;
	bh=QQfQeOchMFjMIbBZd9BGjFJG6WdiEeD+IaXEtKwcvFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=evxiaQxMrFRY5D3da6LQi3rPqEsqKqCoQVY6Zu6xBRCTjitHLK9DbsDEWqj0JkaKhf0Qvsh+S/JjJnwf6Eu8uWG67P2VdX95G5QBJ6kC+GUi2oZcvbmuaIyNfgqK+EyFQqL9T3QaLmVhwo15GE3TmP2qKsetXllMFoC0B6/i7qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PJQPyhl3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PJQPyhl3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-438a39e659cso28231905e9.2
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 01:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740994442; x=1741599242; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXnZ3E5/TKOVFTli8c7ZgXogoCXoZZU7O3qVHvhvQxo=;
        b=PJQPyhl3l1rLXKERi4wKOsSSeHcoxAE+oAiobQaAtkO98X0Lc30+6xyPIjGlOw8cyg
         CE9e69gfwZimySBmw+ObEf9wa31azS/k6J3KQezquCVFoYgMnJbpp5BLHuScduXTQLWv
         lbaKm6CvMmKRbvs2cbkzDobxkp3yUB667hghZVSPwKbsqS1SlhS4nExgcEwSKJUgtYxc
         j0NqfnFegNGcnXtpB1Qj4h/HtqJGSwt1u0zXkv3h0W5Bj5mzS7daH+adVLezKPLlIa2A
         bsFnUYRsMl8xR7dH/CUNfGXdb3E83iWdaY7BabkX4SqsVJLkp+aLkYJ0FZ9Y7jnhINxi
         o3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740994442; x=1741599242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXnZ3E5/TKOVFTli8c7ZgXogoCXoZZU7O3qVHvhvQxo=;
        b=lAt/gO3zqi/1eOniDz1hGG3hm2KOxC+PfJMpE0llBxveH8L0inMjydt3afi0nGKwHa
         63P9dQQjNH/aKhrwwT1fNWyzIPzTQ+QRmkqX2VsoJDrX265gzafPG0+V8Zqx6ojIlYDa
         TIaqy9YxHspvDc8Xl7eyRkufl0K6kXY2daYbDw4xzw3NgR6cvtzDjrpn22jEb5spk2Fu
         3PEzDds1LHQ/JkPysIMAbpkp5jKjbS0kxbu24jSNF339txjFsJPvoqDs1yPq8jgeQAr/
         nf4ovCjpQEifiVx+hiWMXboMi7cVQbebop8wV2ItTdJBgu4bYI4xg8hpTf1RNZiOYOg3
         NW0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/H9ei8NvKKB6p5Ctn8t8vbJuJlOI7U7ZHE/39Qk6XF2G8PBsELqNI8waVo/ruHBp79G2DAwa8@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr/IILsUp7497/QfrrM9Z6pA4w4iA+Ek5nT0cSq5+anezFC03c
	jUE6RPPlJL8ZSoH2qlMMCpVfW51LD9+Mc23z98wZXlGDaLgfcqJNvyNEGLv3UAQwL54BeHLlGKy
	IOCi7SFqUMmg1nw8Usd8/epoJEb08/4BPwaVn
X-Gm-Gg: ASbGncvcSFztnnJZZEbEpm2SkXZ74z/8ijtu1PbCxdni8WB2hYhjcQLU1o6MjjfNIqL
	GTJKcrMmWjbBBvOLuoUZH1NccZiGBu1ItqzQZsZbG0i2OVSU1nQGfh+ycTRcDX7Ii/qiTbser5X
	gKZMqAhUlvVed0L7s3yAc3oQ6Sw8S4d6ywXoHJAn6Fgq/3h2Lk7LQYKz/x
X-Google-Smtp-Source: AGHT+IF7tkX24sQKlhC4282EiZxY+hctHT5EHwLzLcZo0eYUQP0MVXGgfz4uJEhk1VzgcXR0gnLyV/lIaiDtAcofzqo=
X-Received: by 2002:a05:600c:5106:b0:439:9496:181c with SMTP id
 5b1f17b1804b1-43ba67745d4mr107426315e9.29.1740994442374; Mon, 03 Mar 2025
 01:34:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250303093242.1011790-1-ojeda@kernel.org>
In-Reply-To: <20250303093242.1011790-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 3 Mar 2025 10:33:50 +0100
X-Gm-Features: AQ5f1JpToETt_xPFbUXkjE6L7wUMFuPji7pUB4N-gMgIpy2I89dr701AOdtWuTc
Message-ID: <CAH5fLgg_Ax3x8qLvJCE=0xay7gosaq0w_=xc4zu2dQ7tFV=B5w@mail.gmail.com>
Subject: Re: [PATCH] drm/panic: clean Clippy warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, =?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 10:33=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Clippy warns:
>
>     error: manual implementation of an assign operation
>        --> drivers/gpu/drm/drm_panic_qr.rs:418:25
>         |
>     418 |                         self.carry =3D self.carry % pow;
>         |                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: rep=
lace it with: `self.carry %=3D pow`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#assign_op_pattern
>
> Thus clean it up.
>
> Fixes: dbed4a797e00 ("drm/panic: Better binary encoding in QR code")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
