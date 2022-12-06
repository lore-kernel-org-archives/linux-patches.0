Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B477F180
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 00:04:45 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id t17so12792515pjo.3
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 16:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIMcbh4Uza3ztFNGSDLU+/U5crvobqjVftiDBSiwTjk=;
        b=pSZbv8jBbICX53SlYjb8kfYWE3h9Xp3SKfUcz9N2Xlw4pqyBzRf4Yk8A4IMeEJ+878
         i1nF/+l414qa4Jb+nYx92bWOfo5PFuScpurW212olKgS1QqkNhB9HFOHAn3nT1Dw6YaN
         PYZl/j0wGMXUV96HKRjH9XjVErJr4ESYh/QtGAyfafw/teHs0DROzMzugRtToH77GZSc
         JP/1JzgLTqrdlD+XEgeSSl9RGZxgf19LW9ZtGZcsITWSfCyjNObwmseVYM7bb64XkKr1
         SYgd+HeBUBZeiN/tZam/6FgQpk0Lc4sE617p91QhKBlDenDwmySowdQrGB6xBpOgBtCn
         uZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIMcbh4Uza3ztFNGSDLU+/U5crvobqjVftiDBSiwTjk=;
        b=cohpk8J19Cn/v86Xc9QrHLD7okWVNjZv4qURSzJTp2zCjkK4SSIUK2wte4aQDRcWNR
         g92qo5mHQl4CHozNxgpT4dk0TXWPdFmDNhSagaCUeuaBQHLFupwxfNxPBg2RzM5VU1jh
         Tb7lSCQ3VAfruAHzdHLhlLvMK8GsnayNghQYCO9KwngT3Ko4ZfHgLydN9jYeThp4xZU4
         E/KZLEq/ZLvPMIroTbL6R3uTMbjbEoaBkCjQD4r5chnzPEa+Uo7adxZzRdB7d/WwljaZ
         1HcBimW9aQSPU3gatJpVy+h6Ag+7hMWfeqP1zPmZ2APqYJ8htAd1odK5Nuqu9CsKXthJ
         rYuQ==
X-Gm-Message-State: ANoB5plICE9rxdLkOie8WHTx+CjTVZskGz0z+C7HAqaVR9yAZ6LTfKtn
	ghqRmyU/u6H6ShNy9EDT9o1l1l+jC85pvIbubbTw8Q==
X-Google-Smtp-Source: AA0mqf7o+e/O4Si5bnux9v49E5VbINeJXvopUH90PUMpqIJ6jEiLmVFajyOtNlHjSUmScud+fQ5NBZOgC9+va6fzbYI=
X-Received: by 2002:a17:90a:6382:b0:219:fbc:a088 with SMTP id
 f2-20020a17090a638200b002190fbca088mr53133493pjj.162.1670285084989; Mon, 05
 Dec 2022 16:04:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205190806.528972574@linuxfoundation.org>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 5 Dec 2022 18:04:33 -0600
Message-ID: <CAEUSe7_2g6fde2JU7_yA9QCK+FfdLshCRnDd81FF3=SJwwDAzg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, guoren@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Mon, 5 Dec 2022 at 13:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.15.82-rc1
[...]
> Guo Ren <guoren@linux.alibaba.com>
>     riscv: kexec: Fixup crash_smp_send_stop without multi cores
[...]

We have found regression with RISC V with GCC 8 and 11:
-----8<----------8<----------8<-----
/builds/linux/arch/riscv/kernel/smp.c: In function 'handle_IPI':
/builds/linux/arch/riscv/kernel/smp.c:195:44: error: 'cpu' undeclared
(first use in this function)
  195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
      |                                            ^~~
/builds/linux/arch/riscv/kernel/smp.c:195:44: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/riscv/kernel/smp.c:217:22: error: 'old_regs'
undeclared (first use in this function)
  217 |         set_irq_regs(old_regs);
      |                      ^~~~~~~~
make[3]: *** [/builds/linux/scripts/Makefile.build:289:
arch/riscv/kernel/smp.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:552:
arch/riscv/kernel] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1900: arch/riscv] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:219: __sub-make] Error 2
----->8---------->8---------->8-----

Bisection points to the above commit ("riscv: kexec: Fixup
crash_smp_send_stop without multi cores"). Reverting it makes the
build pass.

In order to reproduce:
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
tuxmake --runtime podman --target-arch riscv --toolchain gcc-11
--kconfig defconfig

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
