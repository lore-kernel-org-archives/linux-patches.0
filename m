Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4AA1DF754
	for <patches@lists.linux.dev>; Sun,  2 Mar 2025 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740898485; cv=none; b=V31wp4oRPxMuDgg5H7iYB5PAGK9mhhoiCC11JY3g1YxBIYXNqZHdR/xgrpkbzUyrJtRwrdadJB/bsWWkDMl+c97vkscSbLIIPa4BvukKN20S7aNjQA49WabwK+s6CLGfo8n1ByJyPRTuOBIish+2VkMdbXFJZKekIa7g0uGd2sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740898485; c=relaxed/simple;
	bh=x1sl17MlhyGn7a4DsGY06N7SkedY6GXf5M+vFSktdXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmGuUDw5oKMCtYClfrjmJ9oxAKRiAbmLwdOpbdJ8i1J693yBtCHY9hJ3JjNzBeS8RD2RnxIxL7Plcn36B1TiPokfDMdkdYwbXt3OfZB+uhtcXy0u58TT+KW/rwqf/ekY8TaRDfqtjHGbtYowKGglqYyobIbVvxIv1UCmRGgSQTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jtjfqnhT; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jtjfqnhT"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f74e6c6cbcso1003536a91.2
        for <patches@lists.linux.dev>; Sat, 01 Mar 2025 22:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740898484; x=1741503284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RH50xcsm3w9EAvFEKvX4IOD4cvYkCw20gTdnoq0oYts=;
        b=jtjfqnhTw0/S4V2IkINdDw6gBdNQtsklhF8Yh6Ezny9gSJcf8CByUGhQOYz6DCxVRl
         J3W7wwmaLPN5qJMF4lNIbzrUBcPtj6WEWPB6HLut2smkOdWjzSXBHKjpF8DnmkayvsDJ
         sXdr0MAPveIZPx1udQqSpvl/nP5+q1LASqpRpd5GOvqclpXXkpkTT5WBPC/TrGzZ/Blc
         ea50ZRe7rky/QP3fWCjre9dlUSxzXx5Ep77lUtGzPPqj8WgneXGY3z7k8x2tvOQs1GbM
         9WAwyOD2/EnA+j7D4nfNgvYekaMwWt7IfF7jTxhcHeIhaDWT8EXdEiGSxvETd4ca31o8
         oKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740898484; x=1741503284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RH50xcsm3w9EAvFEKvX4IOD4cvYkCw20gTdnoq0oYts=;
        b=f23ycJ+xFVVqQxInmk3U3L01Ci5ThX7Q1XC9QB43vis76vpZdYg8gDKUiojvezj+ua
         tsf+xIGEYwQGbN8pvQkSYl/mAHzx54uOzkPhjp7qikWmfc7t+Gb42qUF1UDWgUUgKev2
         pyxEPprvdZWv1S0kBXPlpgzgOqO2lr6rO8sU1kHMSTfAnzqB8p2D3Xpyfsq4Nus8M7S4
         cVVwnmxgVAnXNM78Lj7sKVpRD7aiyePepo0hz3K56BY6LKgEPgI/XGBaRIeI/BpOeh+Z
         5aK+5Z4imkc3khZfF36lKd9gbf9LFc4izUrkPRqc6EW/EukNneQbSjj/flaQOLZTguge
         4Wag==
X-Forwarded-Encrypted: i=1; AJvYcCVRbC7CxbzV6Zx+icbMrBnLG0pE2b6VAVVo1JXGrSep21FpbgxxwnoL7cLC1/TsLWlUJ6ggv28t@lists.linux.dev
X-Gm-Message-State: AOJu0Yye8oLEt42L4S42/qZMoMTiGhzzgMmDfQNQ/YXgWksa6vi8SokR
	AmAoXXH4rsT9x1XF1PBE4K4CHX0fV64WE7t+cihvoib7xq/7tU53qBOuk4lTNZVqhtamXgzDcq4
	v3a/E/L/RCxr4wQVAiOueeeRXfkE=
X-Gm-Gg: ASbGncstocCIrylX1dWRmwsCXz7t5f+WMobivJOlwWU+fywH7QBN5bBGwcXr0JgYLnJ
	BrllqeGeIXWgkXBcSN7wCpgf5p9CSCNAxoBT+GIu6bDRVpDNZEFTHSP3ZRtnT1YH4NqGsvAzYXu
	8pJHZ4ygjp6gGh+UKBcSpuxgDnBQ==
X-Google-Smtp-Source: AGHT+IH/HpdC5c2ntwoUexbl3FGQdhO1VQIGXrZoFJRa7qJpy5glII83KoHTFhfyZpEgHHy3fYGiMf0NHxFD6DEEMQo=
X-Received: by 2002:a17:90b:1d8a:b0:2ee:6db1:21dc with SMTP id
 98e67ed59e1d1-2febab2bdf7mr5608814a91.1.1740898482556; Sat, 01 Mar 2025
 22:54:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org> <20250301231602.917580-2-ojeda@kernel.org>
In-Reply-To: <20250301231602.917580-2-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Mar 2025 07:54:00 +0100
X-Gm-Features: AQ5f1JqlzIC1SFXpGOf9WwRIHGTxmhHtxxGET_lxoSbzWK3HdSahnru-4p4t798
Message-ID: <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in documentation
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, =?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
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

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is
pinned in older LTSs).

Cheers,
Miguel
