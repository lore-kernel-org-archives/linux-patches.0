Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF19817
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:10:08 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id w72so5513117vkw.7
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 23:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjPqSuzor2mexKiakowxVQr4nOSsrzDO0rfbtbGNoJ0=;
        b=EVERcEcMqSr90XjlxF++5xpZEtsLFuRMqwSNiXlc0zPwSqcClBFfrozDsHWkFW7BXE
         eKEMo6xE036strpAeBm6CPGX0OEMWBmL6czhjrw7LXmCPLjfxCtztgG6lVgwauixaqAY
         Y3FOZq5N0myiplQ50oaCQ1i0xLhdIxQU4jkEOAdbSe8OhhyHrIEgwSgFZKZwS2epivvR
         DIpX6Om4oBKxRYS9OsUdGFC6rR+n7CB7BAlgkxCYdmGLyvCUl463pF3Bhsw6tweB+lZS
         1FXp+IbXI8lRTCwVwyKSFYaSAg+T72fmR+p+PH4BHhNCCkpFa++sF8XQVskThvRwy0JR
         YTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjPqSuzor2mexKiakowxVQr4nOSsrzDO0rfbtbGNoJ0=;
        b=wu8XkLiuWoquYfMj/1XFsu/0IyL6t5fRsKYShEHsKs4UCD3iBycN/R+x5aybnuz5Dz
         urWmu0WEdEfPmevoILn/lfp4o3RIJ+XxL3GQ4D+Z4f0nQjXqQPOwekA3YMrEIMCE7uVn
         Y17m8iHK3gzOdPa1E9zrxiITIPK1kRy5BhptQ5SOxl6MlgZSKmfqLOj/bRao4tjEosAW
         BgTQOpfiFzVL1jlptG534gkCjSnGweMSKicuqIcrOiFvgR7enTxG18q2cdtDXuvhG/XN
         EzCPADLimQx29wYNlypdtFtlo3pXpPKvR/zYlXHGZps/mmPB7WhA2x4Iqle3ikZj19e+
         R5GQ==
X-Gm-Message-State: AFqh2kqTEQqXGoPlECK9zPtRllH/7DShAW290+xvzXOaD0ZkzgL0NXQo
	NM2GKw46dw+YdLHqfNelhOh5HcY9ISxOVZr2L13VIA==
X-Google-Smtp-Source: AMrXdXvlw86yjS3bdxq8s5wT6J7Oljmynzmd4ce2Jo2uBxrWlKKExzHkg7k5D2qomyWH8IJo6utmWr8SzlbfCo+2DZU=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr3075127vke.9.1674457807360; Sun, 22
 Jan 2023 23:10:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150232.736358800@linuxfoundation.org>
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 23 Jan 2023 12:39:55 +0530
Message-ID: <CA+G9fYsEvpCj_vSFLxkKA6tzdNOhimqZYF+WCLKYAiNLtrMvsA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jan 2023 at 20:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.90-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build regressions found on sh:
   - build/gcc-8-dreamcast_defconfig
   - build/gcc-8-microdev_defconfig


Build error logs:

`.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of
drivers/char/hw_random/core.o: defined in discarded section
`.exit.text' of drivers/char/hw_random/core.o
make[1]: *** [/builds/linux/Makefile:1218: vmlinux] Error 1

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
https://storage.tuxsuite.com/public/linaro/lkft/builds/2Kgdvgv8TfoAfi1b9HBQ=
rkWJO1G/


--
Linaro LKFT
https://lkft.linaro.org
