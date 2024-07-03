Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C018A95E
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 19:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033487; cv=none; b=YayYk3FIOcZaaA3xWQGWA3hC2DgAY0fpXdRIlQotoz9VTPged2+YKQVu+qfZQAGA08KVgmEI2w/uudVGvGcHlSO/02j/1I2/AIDI9ppmz+CzM6qlFDm0NIB5LvfhEov9mMzHX9XKG9oW/jIWam2h38LV5EibWTStXYiWs6k/SIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033487; c=relaxed/simple;
	bh=Oc81FuqP3fYxQZO2NIeym9OJaFkN9S77RiMCzQDI9Yw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YfgN52x7WpD7fTmYA+aQtHQAdNMmoz3Ywl5WuoI5ViIcw00BmvOAmrvSpVR9VpSdXFT0JCvr7w6qKfBWSpvnhz6NA41dpIw7PCVO5pHBbBmD40rLRlljwYOsTahWWqzdOc2hCpMdNsQX6OOUprCern/iEClYguD+hhTSi4SclYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=jkxC1dbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jkxC1dbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E87DC4AF0A
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 19:04:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jkxC1dbc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1720033483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc81FuqP3fYxQZO2NIeym9OJaFkN9S77RiMCzQDI9Yw=;
	b=jkxC1dbceZx7Be7QJL7a7Ic39wHGYwkBltLiS8mY+H1iZtPBT9TDTthP2QeMMSw9n3UhZu
	ayr2cBoMf01X1+Uudntkvb8Bup8CzkZYMoIzQHr1tw3p2t5H7pSU3x8O9e5e+2pdsfOywC
	GRP6njc2YYiqHQ8+J+a6V9ddjs5ivcY=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75b656e8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Wed, 3 Jul 2024 19:04:43 +0000 (UTC)
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5c46c8b0defso999752eaf.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 12:04:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVilkxkF7DxcQiRlc+5MjiOndOyjTed8arUKKP2fbSI24dhivOfTUsbWDn2Ow7/G6NxtgH/sUip+hHWWgZ/aVUtRQcybJ5igQ==
X-Gm-Message-State: AOJu0YymD83nX2XOY4ftHOjNd7yNse5kSnS1jLPUFaHEMfewchZaK0B4
	sYdoNjfackkT/n0zCIju+GNIaQIbMFUg0qBLuUllCjRNqLb4nCG0QgEbrJ+R18KRJfzrrEh7LcH
	AhONSkEnsN59qGNz4N445cpYYj1I=
X-Google-Smtp-Source: AGHT+IF/1JsRrNHrx673Yy+3KzYSc//OID5zS/adculNKhtga+UJFUlkNMK+w1t4qZ56KmzV+zu/1jP+s2nmIVvVD0s=
X-Received: by 2002:a05:6870:6590:b0:25e:1976:37c0 with SMTP id
 586e51a60fabf-25e19763d7fmr1558743fac.6.1720033481764; Wed, 03 Jul 2024
 12:04:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703183115.1075219-1-Jason@zx2c4.com> <20240703183115.1075219-4-Jason@zx2c4.com>
 <fa6eb1f8-b681-4c3f-bf5f-4ca19da78b17@app.fastmail.com>
In-Reply-To: <fa6eb1f8-b681-4c3f-bf5f-4ca19da78b17@app.fastmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 3 Jul 2024 21:04:30 +0200
X-Gmail-Original-Message-ID: <CAHmME9ouVcCt6C6XdvvKACbCBLV1DaAuv_NP8=fXFN1UMeUu_Q@mail.gmail.com>
Message-ID: <CAHmME9ouVcCt6C6XdvvKACbCBLV1DaAuv_NP8=fXFN1UMeUu_Q@mail.gmail.com>
Subject: Re: [PATCH v20 3/5] arch: allocate vgetrandom_alloc() syscall number
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, linux-crypto@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>, 
	Jiri Olsa <jolsa@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Wed, Jul 3, 2024 at 8:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jul 3, 2024, at 20:31, Jason A. Donenfeld wrote:
> > Add vgetrandom_alloc() as syscall 463 (or 573 on alpha) by adding it to
> > all of the various syscall.tbl and unistd.h files.
> >
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> I checked that the system calls are all hooked up correctly
> across all architectures:
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks.

> Unfortunately we now have three syscalls scheduled for
> the number 463, the other ones being uretprobe (only
> for arc, arm64, csky, hexagon, loongarch, nios2, openrisc,
> riscv and x86 for some reason) and setxattrat (on
> all architectures).
>
> It would be nice if you could all coordinate on this to
> pick unique numbers.

Stephen and I were just talking about this when looking at the linux-next m=
erge.

Dibs on 463! Just kidding.

There's going to be merge conflicts anyway, due to the __NR_syscalls
counter changing. So I figured this is something Linus typically just
handles based on what order he merges things in. But I actually don't
know. What's the best way to handle this?

Jason
