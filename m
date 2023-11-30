Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0655766
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tP07mjiG"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cdd9c53270so1083981b3a.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 10:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701367903; x=1701972703; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RNgtprTXnSXEG7sYtWfKlL6JyfLEgg9nzEegbfWpJTI=;
        b=tP07mjiGAq2uBSfCZYassF/Bi+1opfJMhNyQbiBAqMPmJpXYMel1K3PSLQVHFyIhjB
         0vU2ZObmJOW9zNIjmf2gtACFSYU7W9GJa8isfsX5N9Q1ija/CY7kze70TW1pV0wd9hvy
         M24T2Z9HhGay6hA5k6B8+4Ihjbk79hLCP6JPj02DLwfp8DztW/CA8xjm7u6YDTHe8Kbc
         fgY0MsbOJHUf6dV1sc1ktVXGaNKZDJQIn2BNLmC+tHLyoBsPRCno+MhKbmIXs1ECTXlf
         IGHIbKkUkzMNpGj1alxRhxdhu+l3Nz4X6bq0y/s2oYdSGQIqvaD6xd9K18zXotPCTVeT
         L5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701367903; x=1701972703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RNgtprTXnSXEG7sYtWfKlL6JyfLEgg9nzEegbfWpJTI=;
        b=mNEIhU3gLLRhNWNNRhwsB3QfDqvsy0oCKlfq/b/13kO2SGoLMZMEC843OlMKmrVrOe
         BKJGoa/N+FdPtOX5uMmt5Dlk4TaNrzk2ZasqV+MDQLKEzbQ2pB8b9SdIc0mf5luw/KnU
         CevEZVYUO/NjywXB6WhFARYs13PKASqGfZK2anpDEUUaLh6UD3FB+TykHsaiuTY4QkHg
         yJ/ks3PZlUqyV+CcnlYzjdiKvzLjVAe5UF9jYucWkUBEtKZ0VKfbKZ70phT6Iy72W69o
         TOTNm+dRIxpgOR4fsp1ZZlosRFhrjrzVpTsJK73WiYruU81t87blfhbVGbo7Cj9xKG7x
         g1nQ==
X-Gm-Message-State: AOJu0Yxfed851503RyDejNZq0eiOR1rUyXr1+DOYEpdn5nDigm8mt0RT
	MVsGtM5Crn7ZQbcD4Yb2gm/dWya3pM7sxvOPmbGJPQ==
X-Google-Smtp-Source: AGHT+IGedkIyqsw0Qgh2ilKDtIK7r8EKT6xybDMBQyF5e/OvFulhnXxuxRY/6wWfVwGPFjlz9iPl2iAC/9bJsMESWfs=
X-Received: by 2002:a05:6a00:35ce:b0:6cb:8c91:682 with SMTP id
 dc14-20020a056a0035ce00b006cb8c910682mr26682257pfb.29.1701367902766; Thu, 30
 Nov 2023 10:11:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231130162133.035359406@linuxfoundation.org> <CAEUSe7-yhmQkr1iK-82+Sc_YpVtWUQhuKoazoXHF_3oP9XTt4Q@mail.gmail.com>
 <e2e50813-79ba-4c84-b6ae-6885cbef54ab@roeck-us.net>
In-Reply-To: <e2e50813-79ba-4c84-b6ae-6885cbef54ab@roeck-us.net>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 30 Nov 2023 12:11:31 -0600
Message-ID: <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Guenter Roeck <linux@roeck-us.net>, flaniel@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, 30 Nov 2023 at 11:44, Guenter Roeck <linux@roeck-us.net> wrote:
> On 11/30/23 09:21, Daniel D=C3=ADaz wrote:
> > Hello!
> >
> > Lots of failures everywhere:
> > * clang-17-lkftconfig                 arm64
> > * clang-17-lkftconfig                 arm64
> > * clang-17-lkftconfig                 arm64
> > * clang-lkftconfig                    arm64
> > * clang-lkftconfig                    arm
> > * clang-lkftconfig                    i386
> > * clang-lkftconfig                    x86_64
> > * gcc-12-lkftconfig                   arm64
> > * gcc-12-lkftconfig                   arm
> > * gcc-12-lkftconfig                   i386
> > * gcc-12-lkftconfig                   x86_64
> > * gcc-12-lkftconfig-64k_page_size     arm64
> > * gcc-12-lkftconfig-64k_page_size     arm64
> > * gcc-12-lkftconfig-armv8_features    arm64
> > * gcc-12-lkftconfig-debug             arm64
> > * gcc-12-lkftconfig-debug             arm64
> > * gcc-12-lkftconfig-debug             arm
> > * gcc-12-lkftconfig-debug             i386
> > * gcc-12-lkftconfig-debug             x86_64
> > * gcc-12-lkftconfig-debug-kmemleak    arm64
> > * gcc-12-lkftconfig-debug-kmemleak    arm
> > * gcc-12-lkftconfig-debug-kmemleak    i386
> > * gcc-12-lkftconfig-debug-kmemleak    x86_64
> > * gcc-12-lkftconfig-devicetree        arm64
> > * gcc-12-lkftconfig-kasan             arm64
> > * gcc-12-lkftconfig-kasan             arm64
> > * gcc-12-lkftconfig-kasan             x86_64
> > * gcc-12-lkftconfig-kselftest         arm64
> > * gcc-12-lkftconfig-kselftest-kernel  arm64
> > * gcc-12-lkftconfig-kselftest-kernel  arm
> > * gcc-12-lkftconfig-kselftest-kernel  i386
> > * gcc-12-lkftconfig-kunit             arm64
> > * gcc-12-lkftconfig-kunit             arm64
> > * gcc-12-lkftconfig-kunit             arm
> > * gcc-12-lkftconfig-kunit             i386
> > * gcc-12-lkftconfig-kunit             x86_64
> > * gcc-12-lkftconfig-libgpiod          arm64
> > * gcc-12-lkftconfig-libgpiod          arm
> > * gcc-12-lkftconfig-libgpiod          i386
> > * gcc-12-lkftconfig-libgpiod          x86_64
> > * gcc-12-lkftconfig-perf              arm64
> > * gcc-12-lkftconfig-perf-kernel       arm64
> > * gcc-12-lkftconfig-perf-kernel       arm
> > * gcc-12-lkftconfig-perf-kernel       i386
> > * gcc-12-lkftconfig-perf-kernel       x86_64
> > * gcc-12-lkftconfig-rcutorture        arm64
> > * gcc-12-lkftconfig-rcutorture        arm64
> > * gcc-12-lkftconfig-rcutorture        arm
> > * gcc-12-lkftconfig-rcutorture        i386
> > * gcc-12-lkftconfig-rcutorture        x86_64
> >
> > It's essentially this:
> >
> > -----8<-----
> >    make --silent --keep-going --jobs=3D8
> > O=3D/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=3Dx86_64 SRCARCH=
=3Dx86
> > CROSS_COMPILE=3Dx86_64-linux-gnu- 'CC=3Dsccache x86_64-linux-gnu-gcc'
> > 'HOSTCC=3Dsccache gcc'
> >    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x51:
> > unreachable instruction
> >    x86_64-linux-gnu-ld: kernel/trace/trace_kprobe.o: in function
> > `__trace_kprobe_create':
> >    trace_kprobe.c:(.text+0x2f39): undefined reference to
> > `kallsyms_on_each_symbol'
> >    x86_64-linux-gnu-ld: kernel/trace/trace_kprobe.o: in function
> > `create_local_trace_kprobe':
> >    trace_kprobe.c:(.text+0x384b): undefined reference to
> > `kallsyms_on_each_symbol'
> >    make[1]: *** [/builds/linux/Makefile:1227: vmlinux] Error 1
> >    make[1]: Target '__all' not remade because of errors.
> >    make: *** [Makefile:226: __sub-make] Error 2
> >    make: Target '__all' not remade because of errors.
> > ----->8-----
> >
> > It only affects 5.15. Bisection in progress.
>
> I guess it will point to
>
> >> Francis Laniel <flaniel@linux.microsoft.com>
> >>      tracing/kprobes: Return EADDRNOTAVAIL when func matches several s=
ymbols

It sure did!:

  commit 7b4375c36a4c0e1b4b97ccbcdd427db5a460e04f
  Author: Francis Laniel <flaniel@linux.microsoft.com>
  Date:   Fri Oct 20 13:42:49 2023 +0300

      tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbo=
ls

      commit b022f0c7e404887a7c5229788fc99eff9f9a80d5 upstream.

Reverting that commit made the build pass again.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
