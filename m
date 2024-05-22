Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697BE1171C
	for <patches@lists.linux.dev>; Wed, 22 May 2024 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716392191; cv=none; b=pVRO1D25y/n7dJUbCYJxzRyXrVle9+W7BiM2X1ccV8w1a33Z0Lhf03tVkrgA4x9uDtnTtSDVJ+MAv+itm0TtCz14yiZipFzED4+9w2vJeW2nCV5xbMVjNLzH68mIXhYYHZLQ32QKFwZJ9yPmbDEDJueC5f6tD9bSxvplBtycJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716392191; c=relaxed/simple;
	bh=ULFbJbVKQMWnZ1ms7vRd/YXmVFPFapk+Fu4aJyVk1Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MFodIP/gTtT5iaEXmhyILNzJQxnOCPce6kClvC9/aqWsbbA7Mx0cZIAr+CbN2XW74zB8dSTWKY5eX+yv9rpHzJEY4nLYjjqsOxY2HJf7zuxCm1LYOrnDnGd1fYo2tPpku5RRsqfHqZvkIQJmV9XDKNEKVZRluW8gDbKt2y+RUE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-627efad69b4so4488487b3.3
        for <patches@lists.linux.dev>; Wed, 22 May 2024 08:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716392188; x=1716996988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rBlAy4O9Lv/8JE6GkQCoKCu1hP1DJWjgLhKz1QEi/g=;
        b=t6TqZfjBiRMqeuEm78qK43eg7vulrvAUyOovMfASqhUIX4iNm5jUw6zdb82Q1KaIR+
         vVyOQxVjXe0isHOhineaQdxQ7LkUQ0YWdTFIEg89FnEjHqtcmzCtO8Gd5QmQzhglIn91
         52uKS+fuwpQXveKKOBunDj9yrlK6FYnQGbCS41IbHO5zD1MDl/WlzTSKnYV2/j87P3Ak
         jGk/Z+AGA50E4VlxiR13SNlwyYKOekDlgDHVeviZ1Z/CFRIByhuzapSIwAf8l7prFBTm
         lVt/DjBO6ANBO/kRKoMCH6BRSK448d7RS+rGwwM3UDdFZsn+K6AreiwVbrxHqbBgWCOV
         yD1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeSgAhC3qafozvLSIV7fiFQ+XQkPNhv5zJaJThRujVxC/0/pKlQCUv1axN/QyNV9zf3jpr6nAH5Qp7qkRV9lHqcWaAQKYOXw==
X-Gm-Message-State: AOJu0YzwgKr21KYRfmZfWKX4l0eh7gWPGxGsLWQR5T3jEr+6p+q6m1V9
	HdNPi06X5S5LXny4DpHhXEg+BxSd3jswxZ0DQ8SYDA31YCyy+VUBQ1jyIiQy
X-Google-Smtp-Source: AGHT+IG9CEpfEfL+WWLVe5F+6kdlx5IrtAsgnxG9XQHnc3Zs5/b2SeU14A95yfaHj/j2spiL+LIhVA==
X-Received: by 2002:a81:83c5:0:b0:618:25fc:e2a9 with SMTP id 00721157ae682-627e471524fmr25016567b3.38.1716392188120;
        Wed, 22 May 2024 08:36:28 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6277943ca66sm26920027b3.66.2024.05.22.08.36.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 May 2024 08:36:27 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-627e3368394so13150917b3.2
        for <patches@lists.linux.dev>; Wed, 22 May 2024 08:36:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXhu5DmMLHC5GzUlWgwQ+gcK6LvHQdCB1Qw3+C0raScsBy3IUC82yh+u6sV+w2KXlrN1Uu1vb9qV+galGn0WHWHwXlSqw6VBg==
X-Received: by 2002:a05:690c:6513:b0:61a:da7e:1f66 with SMTP id
 00721157ae682-627e462389bmr27860127b3.2.1716392187488; Wed, 22 May 2024
 08:36:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521111958.2384173-1-Jason@zx2c4.com> <20240521111958.2384173-4-Jason@zx2c4.com>
In-Reply-To: <20240521111958.2384173-4-Jason@zx2c4.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 22 May 2024 17:36:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUwVuVfAwDJkMNZFj+_+dKHFf1MX1=wrchUhHfKoP0Z6w@mail.gmail.com>
Message-ID: <CAMuHMdUwVuVfAwDJkMNZFj+_+dKHFf1MX1=wrchUhHfKoP0Z6w@mail.gmail.com>
Subject: Re: [PATCH v15 3/5] arch: allocate vgetrandom_alloc() syscall number
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 1:21=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
> Add vgetrandom_alloc() as syscall 462 (or 572 on alpha) by adding it to
> all of the various syscall.tbl and unistd.h files.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

>  arch/m68k/kernel/syscalls/syscall.tbl               | 1 +

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
