Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3187B14B96E
	for <patches@lists.linux.dev>; Sun, 25 May 2025 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748207592; cv=none; b=QUP+A5z6dyckMz3N+q3f0RKXGbfEHgcB5rIudbFxxmtT0+lIrvsVh5AYBxgPwwwsuo+OLAOy0HaRmUgIW56+XBhb+mpUG6z299Jt/Kc/6mAm4W6OOp/wyaWd6YhXm2wuQ0vCHhsJKgQlpihDtpFSawc51h3/7MguzIWBCDBfE9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748207592; c=relaxed/simple;
	bh=yutOagRm7/jPjwci0FN1tltP5msoKbQLQUfg1GE+uf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K5DOVCFTBPeO4QvlUIBFG55h6lx/HxNzyBlOXiXoWiAB/XSxXIqeHX24apS/jEPDh7O+VzVwNZi8MGvAV3qrl/9/K7xkXHrgY/zSkAGlrPUjVTSPJeJj8sM75/DwIOJOAJKQ4Hoo1nDRCgW8kRONCwgCrOwBwQ49Bab3qIIyXPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MkVpnw0Z; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MkVpnw0Z"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-231f39b1b7aso1003245ad.2
        for <patches@lists.linux.dev>; Sun, 25 May 2025 14:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748207590; x=1748812390; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XX4Ox7nGMplfoPZEHRnuA8sBW2s4IqgCV4sN1QmT1+Q=;
        b=MkVpnw0Zqfd1KWaedLKWBVILdNXgy0eGcjeTDGK5elNyfb+QP1zgGayV9eBu/wjhn8
         QUIg0BH1GoXkfZJNZWdB0IXfR0hTAJfsLx5UbNcbYXbnnccv3GMCsp0/tXBckt/1kc3S
         HRtdEUsUfJnhDQdmOLKhG5mYekD1HIFsTfQiJwMdCePQwcPnbDDmL3vrztoISygSgRr2
         Jor8qDZqEZ0IFh9KxFkzwHF0FcYu6bbcDwqbbqpVDvfb6rmVcsn7sEVYeTsnjZ/H8zOo
         ZZqSkJGvuWRKTCnLd71eMyATt6TekZV29mcSHikKjk6EUWe/Ljp2KfNIemKiKYQmbF7K
         P4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748207590; x=1748812390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XX4Ox7nGMplfoPZEHRnuA8sBW2s4IqgCV4sN1QmT1+Q=;
        b=u4QQzg6j/GpRAOMbjMYr3WMWqfKpVjwIBCZWtJXmxlLotSS2/zX8uX7QV4dqyN2IrB
         voKMFjK2KnA/YrhoYatcAT3WWg9PBj0F+lyUGgxB7bJPbpj2vRDrlSagRKBHG/Wf0N1n
         rzqinIAu9j/hj7LdJC+T7m0ELU7eDHutlCOhln1PNU6xzK/pRbrOEy070s8/UJntdhj7
         Ui6URId+d9RPs47VpgXdr3o9PSDsAx2szWZkRryd+Bh6tSL2LptHqP0+Mmb62PrifvM+
         U9ShM8ybopv43nmXH6418NRsPpJs/8IgG5YPzKohNZdZl2j2y9De1ws/3DNabXZVPrkA
         v8cw==
X-Forwarded-Encrypted: i=1; AJvYcCXwk9vBuWgOaGscDT6662bFPWLzQYQWmr58EhLN5RNIhQKzTxTA8k8vtdFAAaXcHj/nfNugSJI0@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxu59AHvosionlaz95PCcmiwgXUz3pFw1SEt52weurSE6MgJDL
	qVmUHXIfJ7wYeMtUp4YvqSa5xaZGUS845IcO8q2BrBOeZATsWvP6qLstzl9m/y6S1Im6/40NUsT
	p+rfUEmiaAbdDQ+tdJLCv0J5hM7VYPcg=
X-Gm-Gg: ASbGncv61GcENhOJ8SjY4x05b9K4/vkinXiOM9Hj5MOO37NeZ3IDD6U49LAKlY5HKpT
	o6wgLZEavjJTT7C4IzyHCNqfYDI9oeFtgqrHBoJSmGPBcX/KSwkd4zZCmU5LySLjDM61qulc/5I
	ikhsTDzLZs7G5KnExocTSs+njCARkJYwWE
X-Google-Smtp-Source: AGHT+IEfUYwvhLO0+MQrywuylW3sHqV8LRghvR/dDBShngF/P39+CL3M+a5Jusbe8qTBUzOuhXFa4dSPxQN6zgvf04k=
X-Received: by 2002:a17:902:cf03:b0:21f:356:758f with SMTP id
 d9443c01a7336-23414f2f960mr42912265ad.3.1748207590309; Sun, 25 May 2025
 14:13:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org>
In-Reply-To: <20250413005650.1745894-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 May 2025 23:12:57 +0200
X-Gm-Features: AX0GCFu4PPuuef2Ppk43U8NCIUkz-S7uTimHbFKJFw7xJySv4__UfxYhAvWU-hg
Message-ID: <CANiq72kSsfBm1rKANrxyrcX=X0MvfJZKTYLGU-yRFaMzBTQ2Rw@mail.gmail.com>
Subject: Re: [PATCH] rust: add C FFI types to the prelude
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 13, 2025 at 2:57=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust kernel code is supposed to use the custom mapping of C FFI types,
> i.e. those from the `ffi` crate, rather than the ones coming from `core`.
>
> Thus, to minimize mistakes and to simplify the code everywhere, just
> provide them in the `kernel` prelude and ask in the Coding Guidelines
> to use them directly, i.e. as a single segment path.
>
> After this lands, we can start cleaning up the existing users.
>
> Ideally, we would use something like Clippy's `disallowed-types` to
> prevent the use of the `core` ones, but that one sees through aliases.
>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kc4gzfieD-FjuWfELRDXX=
D2vLgPv4wqk3nt4pjdPQ=3Dqg@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

    [ Reworded content of the documentation to focus on how to use the
      aliases first. - Miguel ]

Cheers,
Miguel
