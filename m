Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11CAD27
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740989106; cv=none; b=i2uj4mCNBv8fdi+2muqh5Z3tlAIWqcX3CcHZsa6wWe3aedx0pryBIK92GpNABsMWmL76k+oaCUbp4YgnWYuuzmq8dkwxIp2zHu62QIh9kIlO4TKZFe03pbZApcblsY5bq40ZVHqMBSUp2uK9P2fIAjNO2MWwb3M7j4XuYPhJdQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740989106; c=relaxed/simple;
	bh=JHlXb3zul+rNFkDXGVQOrWhVuAYvI+ZjVaYWHjEHsuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+9ce6UjX17Rtbf2ISX4c8Pr1YuC1sw5CkS+/4IlxFIYXha3Qq7BgdCMy/gcdxBTFYmvmktZsQ8UmlseYKO7Z9hLblxq363q1Xb1Xx2dW9BjYtp9RzsoE2t/VioR4p1q8ME6YPHggtpD53JBZM04C5JKON4ZYP39LwVT3hN2enk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pONbHsGO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pONbHsGO"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43bc6a6aaf7so1890145e9.2
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 00:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740989103; x=1741593903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBB9+bS3IdAEw2Zo9wy+KIRO8+GAYmgN6Dv1bAKxGKQ=;
        b=pONbHsGOPZ4W2xbRMaC4NS9FYyjJBxnKsXHmkwsmWuT7UfZ/dMSbeVnycf0JznZypR
         gI+gRru39v0+Ca0lw3TCNgleVuxF649fsHIR0pvGg8WLSdZWhKT7OHdnm7cO877kghzU
         Sg4f9dWaMmb8GbJtUv8KP2BlPSfbsD+P9bBHG5KO7ijHS8KtkmNXHdBBw0QesrT/rmMB
         GaLCyNCk+QgBfdc/tbskml+cj4US4G3n2K35ZSUvmFGAWN8fOYJt+DcPi8q73nzljJeu
         VjCOZYeD0wPkw2gz/qfo2a2V0OEpkcAT9hTFqD7ezQW4sIHNU9E8DNEY8f6XRnlmWZsZ
         Rwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740989103; x=1741593903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBB9+bS3IdAEw2Zo9wy+KIRO8+GAYmgN6Dv1bAKxGKQ=;
        b=JTcCNkvIQZrRyZiEDZFoFiS5/3qfWxVJREJG0CTuUEVKetTKuvUBVSMlqk6kpJpSm7
         JHS+hlalavBsDJJ4C1Bk3I3DA52xBff03uTWNbT60FB7TZssWZqyursnYgPIIToZSsye
         Tj9CRIXQ83W93l2jXwTuzuBNl719v4I11O71wprGlMiLG435dUckNty22XBDKyIPtzRT
         CY02qYZnnMuHcGG7QhYmOjoRSyyZJ08dtzNfDYm6UyKqPKzbHNqlUlbrJQNuPiVRS7T7
         AduLlTtHaLgnhCk5+92xzgsV2vNuJLzG2ldpufu/cAB4c7TcGEoDQj1Qe7bjGj/Um+fl
         /CDw==
X-Forwarded-Encrypted: i=1; AJvYcCVy5SHGgVpznkmsoUgXG+g+EdAvghqMhKilhl9lFxVRLvaR10OnUz17GS+MbQGeQv14TdI8HouE@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm7kiGMUDb1Zsmqk9lxXxPAXzC9aI89IfulWhL6qM3FutyJaTR
	cQf/6Xqd/LYnkwBGOvT2tHNCG+MhH32YeP7Aqgv2V2weuaFb1Wa481Og0UIry7QUdCsV9ZdOqik
	z/eWiLpxxEdKrXYnYXccYt5mS0M/34eye6Ro0
X-Gm-Gg: ASbGncv8x/n4V+1mNRo4agwM29Z7T9+fAgjt6sBl2/Lre/wrNv1WPDw0dwCfrwfhPos
	ynSPuHck7GfSVxCNIix9sUKG3P/wufj2SGEznBYtHCzMVVOvN4nKuFy+zmO6qI+SIrmoosmCIad
	bwmCTy5ku6B7EzYA70YZFnOaCEUdYMELuj5viSW4QRYLn0OWFXk0Yw256q
X-Google-Smtp-Source: AGHT+IGpdxgjf0gkSNOiBqhKXbQc9hRhwlo2W/nTX9MqGqqFdt/JgT25MM6r5uWJ1chlgrzzP+QlZYMm6vZ2gmLXFNk=
X-Received: by 2002:a05:600c:3b24:b0:439:9496:17df with SMTP id
 5b1f17b1804b1-43ba66fee15mr102753595e9.13.1740989102617; Mon, 03 Mar 2025
 00:05:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org> <20250301231602.917580-2-ojeda@kernel.org>
In-Reply-To: <20250301231602.917580-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 3 Mar 2025 09:04:50 +0100
X-Gm-Features: AQ5f1Jo80hSF1L-_KjqVRtXigJWOzdDSnpQhkOp567xZ9U8afL5p9lZs6wbyFLU
Message-ID: <CAH5fLggKXw-SCtR_vAOAU8KJaAvmNP20egmtV8KmX0xV0DA0dA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in documentation
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

On Sun, Mar 2, 2025 at 12:17=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> Clippy warns:
>
>     error: doc list item overindented
>        --> drivers/gpu/drm/drm_panic_qr.rs:914:5
>         |
>     914 | ///    will be encoded as binary segment, otherwise it will be =
encoded
>         |     ^^^ help: try using `  ` (2 spaces)
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#doc_overindented_list_items
>
> The overindentation is slightly hard to notice, since all the items
> start with a backquote that makes it look OK, but it is there.
>
> Thus fix it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
