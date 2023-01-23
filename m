Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EAEA21
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 08:09:23 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id 187so12005159vsv.10
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 00:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7c/pdOExCcpLLZUD6UA3m2abu2a1/Ie4TH52nAygB5A=;
        b=U33m8q0XyJQsgPxNmhR8Dj4rfbqxHdDFumhoFfPeYGnu3vV1RYXFseHMwdEKUqImxL
         y3drzFDspZvSXPdG2IalmZs792vA9OP4TABizj6X4wY6lQTG0cO7VSw/HDS80+6R4Klp
         FU6q55BEIMSjagGZTknunhScijwjxCYsP3RupTzKmfbrIhAaVrUFNsm8U28U0jeacgQL
         iocDYOeJEkXMqR6KECJ2pFFNh82qv2cfRdo6xbtIEv7qVNj1ytkrP/BcajaLp8HLGwv1
         Hcdo6ccu3AB1scChpieAUCJSOjkKNyR5ERKe2fGpqX4lzy1BMMo84aiF+2Cymf/V9n/I
         iUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7c/pdOExCcpLLZUD6UA3m2abu2a1/Ie4TH52nAygB5A=;
        b=5BwEeLYBRNkn1z2gnck1r4GAJqMth8YdIYrnVduGcNqICWIIu4ZwDLB4WDzYEBcQsD
         FMVhWt7OZkwWwdLBw7lWon21zSyZd4OcOkuzdqBF4q0HNjiHaOsHTTttKkLWTPzy7LJ/
         NvX+Ippc4ILdh6bP5zRba9v7tC9D/0c8wzFBSxykAQxAsyZ2F0L9dp28HudDgodjaSTB
         KYpC6AFpZIMbl7VZVjZEJi5YD/J7YfRDBFPuIPahajvGyKVwsaCgv/q6BdZ3bbnaLuAL
         9u49RWZf5Wc2zDAKTdEnl/Sg+aVqwTODbNzmhs5hFZIFFejPvdx2cifIKO/EB7anHxLG
         6Q4A==
X-Gm-Message-State: AFqh2kod8qyP4jknEQJDSQuag1oEOA2wkVtBf5uXPgCshRlTW/j3S7uu
	IQqw0GXmyqsJw5OzyVYPwqLC9RRbpMIh6q6Sa3T4BQ==
X-Google-Smtp-Source: AMrXdXvpdjWNCIvZ712IPqqtV40RJsW2ntvWQWa078Hd7TKDuvhollsWd5E60URXbG01RNQeUmXiZ9lf9HUm3Q4FQ8k=
X-Received: by 2002:a05:6102:4425:b0:3c8:c513:197 with SMTP id
 df37-20020a056102442500b003c8c5130197mr3009317vsb.9.1674461362523; Mon, 23
 Jan 2023 00:09:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org>
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 23 Jan 2023 13:39:11 +0530
Message-ID: <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Masahiro Yamada <masahiroy@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Arnd Bergmann <arnd@arndb.de>, tom.saeger@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* sh, build
  - gcc-8-dreamcast_defconfig
  - gcc-8-microdev_defconfig


Build error logs:
`.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of
drivers/char/hw_random/core.o: defined in discarded section
`.exit.text' of drivers/char/hw_random/core.o
make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Error 1

Bisection points to this commit,
    arch: fix broken BuildID for arm64 and riscv
    commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Ref:
upstream discussion thread,
https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/

Steps to reproduce:
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.

tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig
microdev_defconfig

Build log links,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgeCQc3ZdltaEFoi0Cw=
yJlUcuk/

--
Linaro LKFT
https://lkft.linaro.org
