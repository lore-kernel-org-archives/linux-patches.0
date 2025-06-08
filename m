Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BD515746E;
	Sun,  8 Jun 2025 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749399952; cv=none; b=i8YxsSmYrlEMJNbMENDXGJL1VNrMFt46fqBJe8i+0q2Dkx6Tf3lduZMzMrURmueaazu2XTT1mY8I2RkdNeANG1V+izLHdc2rkvXUmxryonGlYupqP39KyP1o1OayNWOenovrvdYx/x5KYQpNVfbb1wLRtoCwvIUrWw4yrj+YCKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749399952; c=relaxed/simple;
	bh=Va1TbSjqbI2pgSwaawgPxh3NVqwfXm5FttWoY8PlOKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YRqtF0XgnYeIZgd5Lh27EHW5XzQu/LXYMPybCF9qWaxVb2zf5Qh5Ehyu3cQ20G2jdJDqpshYkJFD/KENk0KGqRp73aeydGrK+UlMAuuWzHiehFkv+lUP1vJK0ufOosYzPMJY3mp5OQ2ZZ6jUhU2wOsyoTezzYM1grNonoRQ8iS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUyBO43t; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUyBO43t"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-313336f8438so591054a91.0;
        Sun, 08 Jun 2025 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749399950; x=1750004750; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Va1TbSjqbI2pgSwaawgPxh3NVqwfXm5FttWoY8PlOKY=;
        b=bUyBO43ti0+InlKWyh4rFDQTgeHXZhahSY27B167XZ829my0olAPwKmKNmnVAT2i1B
         t80wrvXfM0z6m6k4yUjm3cLxA0y3ViTcIFYOQd24b9Bxh1a/n77sWPhF+wB56L+8qYGi
         KFaViKB3R/cXc23/plOeScfk2w5IBo7xv7k/l3VWKcwa+C/QOF6CllqhpoCtTVBtoOO7
         5GMP/faVSPgElZeDrQISMqv0ceM8Nvubgb+dXEWzUKdaMW7NmCUWyLiYAGjQdvzBhJ54
         gAnQLWR4E2gbighPfcOGkFrUQidiLGSItPOd+i1CPtMZt86LQhzenGmoCWvVQ3JOOUBe
         ztiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749399950; x=1750004750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Va1TbSjqbI2pgSwaawgPxh3NVqwfXm5FttWoY8PlOKY=;
        b=RcIMhr9l+VyJ3YremPF1ZlqBST2IDQ7QvudJsgSUowp+97n+gDxDzAsEf6SHwm5FNR
         nJJF3vSl8HeHvCcarqcDqXqO+J0Jd//4vOMJVfzemUgdEdCt/4xY7SILZ3QRRvG3aO6+
         tqBSqehYzBJgkHoFc2YAEiw9CZQuzbJthAz3QWdh93/txV8Bpkk1btMv+lNtakbGqVwa
         nVzymUggSsjEip+ihFIFJE5ypbkpkCkV8Wi5BYT7gL1GUkk38TI6y3d9+aqp8gD3Og2R
         r7rZiEDw57rtkZkHU9xD2FCepi7B3HcX22Ku0Lh7m7SdJm5MKx5GAQlgv4KnH51l2Ftx
         ttHw==
X-Forwarded-Encrypted: i=1; AJvYcCWH0VAOGkfUrwq7H9WdGn3teotm25Hc09K+NwAplyG051MH/wHrr0OVELG57zHDoC4bKkz6@lists.linux.dev
X-Gm-Message-State: AOJu0YzweACxHi4AWOCnD/tRnykXTYs0kWga8k9zwgTiuaSBV8UXo132
	7WSGnc+yZJshVnhbFyQAFEb0LkDGntgFgD8I/BYaeWI3d5EecyrKjn+j9UDN9Xfg3MJJraVrx+j
	bAfN2DDNl69oOpoxegN5VTbIcerjZ598=
X-Gm-Gg: ASbGncsezrqVTmDqbeGadOX2vApIvuR03nM22455RfMtr/vAI0UrA15twsNOW8M+k1k
	LK28n18kbzF4JGejX5jpm75DH507St7XlohP0fCIVYVI0zO+DFnbcnN3s9dKQc6PYv/agjfbPLh
	zU1o2VU4u9hO0Do5PJVmSvkI1nI9Y+3cuWeyljn4GF5lI=
X-Google-Smtp-Source: AGHT+IEW3omqkNJDfhU8ZoJL0yKzGfVK5jywDam3te+/ue9oCB7B7Nob2m0ticF9d6pK3z7XWL00d0hE2jTDyPOPXJI=
X-Received: by 2002:a17:902:d511:b0:235:737:7bf with SMTP id
 d9443c01a7336-2360409dcd6mr55412335ad.3.1749399950244; Sun, 08 Jun 2025
 09:25:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125507.934032-1-sashal@kernel.org> <20250608125507.934032-4-sashal@kernel.org>
In-Reply-To: <20250608125507.934032-4-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:25:38 +0200
X-Gm-Features: AX0GCFtT_R4cZ5X4zaggASOXnbSzNJHThJNf6cWOW5majDssFLNveZWMOL5-zr0
Message-ID: <CANiq72kb3GDKxhj_+SniG-vwLmcb-=9P6HANdxxJrsVcpwF84g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.12 04/10] rust: arm: fix unknown (to Clang)
 argument '-mno-fdpic'
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Rudraksha Gupta <guptarud@gmail.com>, Linux Kernel Functional Testing <lkft@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, alex.gaynor@gmail.com, nathan@kernel.org, 
	rust-for-linux@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:55=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

This does not need to be backported to 6.12 since there is no support
for arm (32-bit) before 6.15.

However, it should not hurt either.

Cheers,
Miguel
