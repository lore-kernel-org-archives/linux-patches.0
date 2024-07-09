Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C6314BFB0
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 07:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720511552; cv=none; b=heSBTFtWykEwOMKxG85XgqW+cumCthwDA9Mi4pKzRPJ9BNpayi4Mu9oiPGCBTzvyi8Hk7AmzVPfPKYoLV/r29LQzxImZjOelHNOh+DSZrvzr1qHLApiw0u/nyPUyjFnRB6ty0kn7eW8fsKIvMrm2TRLvcwWxXUpfDzoq+cteyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720511552; c=relaxed/simple;
	bh=4huwY83Cip/KiWjo4Fuer9HzRe1argLs9dYsNwYiwCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZ51QqCn7jtzKfcUTLgoDDmQtzM/sX+DtU751bd2GC4GBGvKLoeAbRMQO5EeStlO/HyJraj/FZrbyHWRZCxsrMjqcA88uAnVMT8OBF1EBTrLmsWrvVInHg2sKSZiZ+He1cyie2FoH738PhoWi+3bSDl1Ei/X1ylfJcdQyNMklHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2zvo0TV; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2zvo0TV"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1fb0d7e4ee9so31160375ad.3
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 00:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720511551; x=1721116351; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4huwY83Cip/KiWjo4Fuer9HzRe1argLs9dYsNwYiwCk=;
        b=b2zvo0TVuw/AC/nhv39QvOyQv5vBeB4XMaFpEE7IunJx6odECsT0yAHOBUPJCalWAD
         Z0z3rAtwtXygrhNs7HF+t1yr8kRIIlerqNamaj7GDzIO5olWAFx1XWBFBne2thX4Y+x2
         jctwvhgTU63e4bhdzfR+RTUCJ9B79X/i+J3d6XGSXD3J9pHEFKc0MCRVwI0ApkkfXkux
         bJbQKPBku31Hj/Cgw82lHd0sAlRvcyxFodx4Ngq4mCoM6nCYOQqlQ2wVdS8h2QzDctas
         9SMk8ie7gCnfxg0KdQ7CsjNIcrhBCPxaMONzK8HR7A0B94S8sjYpVmIg09yPCndPHAcQ
         H4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720511551; x=1721116351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4huwY83Cip/KiWjo4Fuer9HzRe1argLs9dYsNwYiwCk=;
        b=wLhK8f8R37FQeCxM8aFnXKojQfBfzaDVvP+odh966Gqt6ufCtAuPwXcK8Apu0bszFa
         vj2IuMGsCiwcwmbRg357b6G5eecjsinPGKNTWFHmNPP/4Uv7SQHr0f2WqiuCPsIqkA4k
         46Tpa8xMrXJX3UPWS9qHokFdOQi3zuw58UK1mDXRRJZRuLlZN8HlGKAuX+hzS4+ypAE/
         PgxpiSbv+jR++LXH/ipw1k4veRdwQbMq+Qbvk4nwQu8zbxKhTKalxUOatGAuODugHp58
         fyLTn1cn63Q2A5zdBhd2MNu4gzLB046ng28AyKDngSOSQUe+fF+J4Y23rVb9oc+d8gAb
         X5QA==
X-Forwarded-Encrypted: i=1; AJvYcCXldYk8IlenP29M6zqprBRU0DlPj8BToli+RCSiLuAbuviZ9k7023MfzPInr+gBFJNYBPOeqhL1S3SIA7q5pGaxJ+Yhzo+T0w==
X-Gm-Message-State: AOJu0YxLYCz14tbLvvkT76gHcDo4V8yZ9S9MMCEu1F/73clJYLj9pvDC
	By6xvXZqPKgVCyqX3xpcbAyrHKyvj1ObadcZZmS6n6IJb/ZqL13DQQ7zRv0dCsKb1xUHKrLLjv+
	kuXK4cAelGKU9wAuUMnP1PyutrIY=
X-Google-Smtp-Source: AGHT+IEsiTEi2w47DuEz12pAyq/B0P5SMlLRpynlMjhW49xEuBs4PU0+67uU2G5y8PKx5VM+2zmkAZyJH+aqcKZ2NZA=
X-Received: by 2002:a17:90b:5384:b0:2c9:6ccc:2fbb with SMTP id
 98e67ed59e1d1-2ca35c6cad8mr1496604a91.24.1720511550658; Tue, 09 Jul 2024
 00:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528163502.411600-1-ojeda@kernel.org>
In-Reply-To: <20240528163502.411600-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 9 Jul 2024 09:52:18 +0200
Message-ID: <CANiq72=FUyYgv0Ng__A4GYh=dxpDD7FF=Fr9_pdo_HRithuAFg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: remove now-unneeded `rusttest` custom
 sysroot handling
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 6:35=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Since we dropped our custom `alloc` in commit 9d0441bab775 ("rust: alloc:
> remove our fork of the `alloc` crate"), there is no need anymore to keep
> the custom sysroot hack.
>
> Thus delete it, which makes the target way simpler and faster too.
>
> This also means we are not using Cargo for anything at the moment,
> and that no download is required anymore, so update the main `Makefile`
> and the documentation accordingly.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next`.

Cheers,
Miguel
