Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A07817
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:09:28 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id q141so5487378vkb.13
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 23:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l+yTYlDwMs/8VLwuGIhXdyxg3bRiWziZ42OeRXEy0kQ=;
        b=Nza06cIStYfGFwNEm5+/EVYMiXXvKDJFM4Gc+sWZboo5WU5Nl3EK4JZ5V/GV7CNNqu
         q3AbnWHmn/9aw/aIuMWdDd2vf1zG5vutMxP1D8kSDeqBKhpUe3F1lDmakfEPGnuxh6zl
         YxonePUOEpUitp0KGAQvdeSADMHQSl7pEaJAiv1dTLbhsu1wCY6ZzM6aSyQxcHMPgxFG
         IiJPl54PkjlYIpcgNPlXm9icFG3H+4m1UVsMHN8qdL54bOcVWtvcglQXz3SmyYVkcOaH
         73oYElU+GTKRe0gEBU3Nay1RwDPytsaQPq8V9NfbChwpj6ajNwOEOo57XwkKSqWUnwu6
         e2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l+yTYlDwMs/8VLwuGIhXdyxg3bRiWziZ42OeRXEy0kQ=;
        b=hfHROHuwfiF+VW72NKBBr8gVxZAoI1Pp7q2ipcpMJ0mgktSkoizGHr8YBy6+eN0k85
         JM7ReI7MwqdzCDn2IIEtZszJ6FgKfNA7u5wyhXJ//OlLaaoCYOOQmM6PMpXEbInZ9B2h
         scN5gbDCFhnsfJ5YtObCbiAKYkkuCuRrsMxcAIaX3dRc1sS4cIhZszdR/WVtzw2TauJS
         5tlIlaaXUaFYjlRRqcfieBpKhkemHUqebOAQGfPhVqWX9RWPaysLO86q4P+6OoUtwSHA
         Crp+vA0EpOx/utYCvY1emZHafPts2ZuDXm3AYbOeoSjgyPUX6gMsjk/LArb8w0EXFUMn
         0Mkw==
X-Gm-Message-State: AFqh2koSlDKakQhy3iwTP7fkD1YiBf3zEX2f8zA/oU5Zh6AMjP2gZNvR
	qw2cz5KiXSxbmJYp91SFYvkSu+kSL+UXDgoayfQ/iQ==
X-Google-Smtp-Source: AMrXdXvjN8CIjK/t+dcB/fpWQDTmC82wWzDZDxzKHCXMXEVKyBh6qx9vdkPyz1pFU+MqdDSv9SmESuTcDn9lu5GQ9AI=
X-Received: by 2002:a1f:5dc1:0:b0:3e1:9fdf:7740 with SMTP id
 r184-20020a1f5dc1000000b003e19fdf7740mr2972059vkb.20.1674457767097; Sun, 22
 Jan 2023 23:09:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150222.210885219@linuxfoundation.org>
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 23 Jan 2023 12:39:16 +0530
Message-ID: <CA+G9fYuYi1Rvv19R_EVdht_7LV9qiR-6KVvZUGjct3kEk0uQTA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/55] 5.4.230-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Masahiro Yamada <masahiroy@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jan 2023 at 20:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.230-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Regressions found on i386:
    - build/gcc-8-i386_defconfig

Regressions found on powerpc:
    - build/gcc-8-mpc83xx_defconfig
    - build/gcc-8-ppc64e_defconfig
    - build/gcc-8-maple_defconfig
    - build/gcc-8-ppc6xx_defconfig
    - build/gcc-8-defconfig
    - build/gcc-8-tqm8xx_defconfig
    - build/gcc-8-cell_defconfig

Regressions found on sh:
    - build/gcc-8-dreamcast_defconfig
    - build/gcc-8-microdev_defconfig

Regressions found on s390:
    - build/gcc-8-defconfig-fe40093d

Regressions found on x86_64:
    - build/gcc-8-x86_64_defconfig

Build error:
arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1c1:
unsupported intra-function call
arch/x86/entry/entry_64.o: warning: objtool: If this is a retpoline,
please patch it in with alternatives and annotate it with
ANNOTATE_NOSPEC_ALTERNATIVE.
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/rapl.o: defined in discarded section `.exit.text' of
arch/x86/events/rapl.o
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/rapl.o: defined in discarded section `.exit.text' of
arch/x86/events/rapl.o
`.exit.text' referenced in section `.orc_unwind_ip' of
arch/x86/events/intel/uncore.o: defined in discarded section
`.exit.text' of arch/x86/events/intel/uncore.o
...

Bisection points to this commit,
    arch: fix broken BuildID for arm64 and riscv
    commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Upstream discussion thread,
  https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/

Steps to reproduce:
-------------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-8
--kconfig x86_64_defconfig

Build url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgdmU2GQpPtTDTC696G=
7v6ytm8/
