Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8362147F3
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 21:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744235596; cv=none; b=qj1OSfz9+AFuvfzcFPVMTHHMVHkeT4ZMz8jpLOgy2N7klg/VcUK9rFOJ/dyOz4Q8u84XoT9HvaO7mzcVA3bo3XnYYkrlCcNOBy4FLIq3wLZUH636DtB7E9mJePOK3Gr7w9bNn0KZr9nWoA1J441A8MY/0aqaCCl9Wu8EKSd0VE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744235596; c=relaxed/simple;
	bh=FDKPD1lNkys1gBdpLGebFxEB5tYdC6/xm01UvetLAMQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfU645Ba4r6Firj1sfUiU9k+mWmMkxjP9gB6iTWhtoIB5KsF8/IYbzr3Zt/mQG/pdCL+KlHW6oljuqLTpcOcsmrSEpU6AK10LRCM/odAKwML2Uv1P6im3t8i65S/CvzF2EG4YM8kb4i7Pp46us8qtvVcaWXY1Po/+E6bIJT7w+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PPgBWf6f; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPgBWf6f"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff6b9a7f91so19805a91.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 14:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744235593; x=1744840393; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDKPD1lNkys1gBdpLGebFxEB5tYdC6/xm01UvetLAMQ=;
        b=PPgBWf6f3WTw6OYvZLfLJy6MxSm2OzKnXmEPbEepH7YCdcHjO5Bw9Cx4h185YSniwN
         +U/NexV6isQ7Ikch00rFd0k+/ebiFWhML3gR5BB08M9vUf+0eRfFitiVZuEVj8qkyoFZ
         svT4pzpqz5GuxdBo4p8LRUcpJzm+uqg/eMtYhbPBhVXIrK5sDH/4rZ5BNaDMdwHI4QpE
         2SCBZ6kq8EgyVjrwb7/D6JikfYlR1vnY4LgqE77G6JCAb/cV73i6MoyPZIpMIQd+tsNS
         //dAPdnwQ4LBk82Qx8TU2B0q+qyChH0i1TGQ0hiSSyYhU8kGPC/JXajz62UUNwGJtNK0
         Wo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744235593; x=1744840393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FDKPD1lNkys1gBdpLGebFxEB5tYdC6/xm01UvetLAMQ=;
        b=nhvqbJey5hkW9Cm+yh3Ojnas+k+aXm8eSWEAs24lP9tt419EO4XxO9nwDUZQRDBX3n
         a6xBortPJFxmRXp5hK2H+b/gJE/CYg3UjMiuodV29ngHiGTndJzbogGpoVDOv67w9fnm
         KiT1kzwF/GgV1W0K5CVhoXN2CoD60SzPoVinXIw1XprIOELEQqp2GEwVSAwnWaKfOGn1
         yPwF6R4xt9lw1PqO2Xd2adl4RptNMSR1zvRWK6HiSBrarFTnLkD5msJrG60eQHC3nEkm
         Mfad+pjK/LqScqEVt+2+8tD/PzsGOwpWxnnAIyC3AI+/tcSo6GejWZqdUSYHpnvNPNQq
         fpLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWckhrTYQpzLzjkClh4no2kHy3BvUKz/7rckc+eO8yj2Vzvtcmr0UlbH4kELBcJ+Bgf9FuL0/nO@lists.linux.dev
X-Gm-Message-State: AOJu0YyNb9H2R9tBOAo/RgIhLPTjIg3Jx+gt4ShQUh4E6gOBIBJSVxG/
	7QFrDzBneBsdLfz6nQSctFdxLenlJi10bgttFm8VW6TpMsvCDdH8+Px/g9Zu7XOlrEZIGQovxJ3
	ixIg4S6eL/aWzUiI/xNSWZn8QESw=
X-Gm-Gg: ASbGncvdcMmx/Ei2V8SQv+MVzXGxme1h3rXJ9hBN5Jyc0Pd85DmjZ9HbTN6niYGpfeC
	dMhiX3imu3XTicaOzhlvWFefXpVPolcti4mkJl7rBXyytaE1ZDt+tG0MaA7Mc80/Blzch25GGpt
	+DKAartuhManTJFMN6YN47ZA==
X-Google-Smtp-Source: AGHT+IFiuhaY/Oly3F84cyX5S5R8FUrNDPu5Xzylln3EzIuMjB3WyRn7MtyfEuyKE/ITRvwSR7ZCmrBzmJQr0cXhyI4=
X-Received: by 2002:a17:90b:3b4e:b0:2fe:b77a:2eba with SMTP id
 98e67ed59e1d1-306dd32267fmr2318847a91.1.1744235593163; Wed, 09 Apr 2025
 14:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org> <CAGSQo00QxBbUb8AxwqtRKXy96na_HUVmAG9nWmX=cVvozqwWaA@mail.gmail.com>
In-Reply-To: <CAGSQo00QxBbUb8AxwqtRKXy96na_HUVmAG9nWmX=cVvozqwWaA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 9 Apr 2025 23:53:01 +0200
X-Gm-Features: ATxdqUEHQeM8b7saMWZkuyDOWEJ-eHfp3twazwBDYlb872_Qrhvs9x-AXSKsD9A
Message-ID: <CANiq72niPycmVwHBfqttgD+X1qvg2L_P-=X79YEREUGLitqoaA@mail.gmail.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
To: Matthew Maurer <mmaurer@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 11:35=E2=80=AFPM Matthew Maurer <mmaurer@google.com>=
 wrote:
>
> The problem with this change is that some `rustc` flags will only be
> valid on some platforms. For example, if we check if a

Indeed -- this limitation is acknowledged in the commit message. The
priority is fixing the issue, not future features/needs, so I went
with this.

In any case, if we need to test a flag that requires the target, it is
likely we can do the check based on the Rust version, the
architecture, the Rust's LLVM version, etc.

As for `target.json`s, the plan is indeed to get rid of them, since
they are permanently unstable. So any features used by the
`target.json`s need to be requested to upstream Rust (e.g. flags) so
that we can do the same without a custom target specification, so that
eventually we can remove all of them (and thus `rustc-option` will
work in all cases again).

Thanks for taking a look!

Cheers,
Miguel
