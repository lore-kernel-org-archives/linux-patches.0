Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CD5A42
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 08:56:21 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id mn15so7626732qvb.13
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 00:56:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJTF4kLOKsfF/dL9+8uFkzScHFlje+C5R7BmCYFvyJ0=;
        b=EUxNynVLEcHSPnk84qGDY/quSsQ7k8vEvDA2JuYYMqTBrx+mjaB/RsQPpp6GYl2TEh
         hUIIKzTLm7RZy0HJuyrul6UmiDLDhenSdOgTLfi+XDWYF/bRswMJ1XcC/7+rwGqwRCGF
         jwtCyPc/yBXgZrkNKraWhufMEyNE/LSFDD4oQJ08bTCiCBe14jhOGKeZqCJmCwOR9Sil
         qWVP66igxuGN97E9Fcfkvt+Cj0PlmXJftPZ7d0QiCJoCWFLMMuFUV6AkzAtwccCrPHvb
         1axT2yRhaLFNbPMEtcVGcxgMD3ttd6ciNN7TQI1gO37tWnVuE+U8dcoCjytUd8bwD4Si
         HaRg==
X-Gm-Message-State: ANoB5pmS1kZmmzGt6oIY4nX6UBb7D8Ka0UOWBjNY97wyS/ihpcmGaFe6
	y+FhDJ2RMbU6nzdf+Xnmb9r5fmq4Pw2b2w==
X-Google-Smtp-Source: AA0mqf5mk4wtrNzFrEea1znCe2mhWOYlKwALWSU1zWiiGBPvUgos5D2igrZ95Prb9DX2IUXi4wtwPQ==
X-Received: by 2002:a0c:e64f:0:b0:4c6:eced:ba49 with SMTP id c15-20020a0ce64f000000b004c6ecedba49mr20099995qvn.102.1669798580025;
        Wed, 30 Nov 2022 00:56:20 -0800 (PST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com. [209.85.128.182])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006fa617ac616sm698396qkp.49.2022.11.30.00.56.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 00:56:18 -0800 (PST)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-3a7081e3b95so164425927b3.1
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 00:56:17 -0800 (PST)
X-Received: by 2002:a81:f80f:0:b0:38e:e541:d8ca with SMTP id
 z15-20020a81f80f000000b0038ee541d8camr54658604ywm.283.1669798577394; Wed, 30
 Nov 2022 00:56:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221129210639.42233-1-Jason@zx2c4.com> <20221129210639.42233-3-Jason@zx2c4.com>
In-Reply-To: <20221129210639.42233-3-Jason@zx2c4.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 30 Nov 2022 09:56:06 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>
Message-ID: <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>
Subject: Re: [PATCH v10 2/4] arch: allocate vgetrandom_alloc() syscall number
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Jason,

On Tue, Nov 29, 2022 at 10:09 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Add vgetrandom_alloc() as syscall 451 (or 561 on alpha) by adding it to
> all of the various syscall.tbl and unistd.h files.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks for your patch!

What's the policy regarding adding syscall numbers for VDSO-related
syscalls on architectures that do not support VDSOs yet?

>  arch/m68k/kernel/syscalls/syscall.tbl               | 1 +

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
