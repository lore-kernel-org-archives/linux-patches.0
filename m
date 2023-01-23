Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39161817
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 07:16:59 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 22so4743566vkn.2
        for <patches@lists.linux.dev>; Sun, 22 Jan 2023 23:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/nTmDIKe+CVQP0G3n4sHN1YN0YVxf/pwrE7R3XBahY=;
        b=j0DuOHuWM+7i161REIceXJtlyGe6lPzVV83om8dv7HIdjBqtObgcqD7vyxgSi0kCqS
         L6vnZ3zskyNDsHwcEDPGqMgFcSotUTM+KOlv5uKgsF71dozfHHnXplumhn+OrLFKR6ZQ
         gT2+ihJZiTQMDOSZC4DXuorDglpsrCncRhUkw+dFhodRIcFgAKJlWhZY5gahNZuH0/eB
         N5u67mwj0P+/AqC4TuZNX+W2aND1zFecRIHowMxje0VQhq0LKgbxl7wRJQp44Ci8A1rU
         2xEZ4i3VsJ7cyiL21qDmxd7HyybDEL6paFqan8T3bBIVMsAnNjh+WCQFkSLt6TYPb1nh
         4SzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/nTmDIKe+CVQP0G3n4sHN1YN0YVxf/pwrE7R3XBahY=;
        b=g0OZAHBkvRJBXKRTVnAm3WY98h5kND6pUxgHsmO5yMilMJY3fF53JvEDuuFc0xli0D
         VlBNYoLKFHYg4AJyjcl2JIuihA4Or1RM/ZbLHvcp/hqF6slamah26rF9rFlrLKA2NG3s
         cYOB3KaUizCuksC15aCj51HDehjpY+Xn3PSV6fo9tHtzllgf1urVL/96nSTj4Euk7+F9
         xyfY6DSIUebnsQNhrNOzx3UGRbd0LPCjIg0FJp5Eu2iL1+cJQHBed16GYSUz5FGPxbpD
         KYeE7nCMMRkyI3IrqoXVDWaV+HH5EKa1b99GQhsu2XqgkwwiV/EK/4nP5WvE80GuBDi6
         VUtw==
X-Gm-Message-State: AFqh2koIZJ05QIK0fQtTNzRXhoF8BZ/3SoRMIuk5mUTxmCi96FVQzJHX
	X8SSyUPBanZSNVbwsKuHcqOnSEiWU9t5rCxLJZ7Xlg==
X-Google-Smtp-Source: AMrXdXtMlHG8p50ItK9g4I4f9Rz4TM/4HtgzphmZKhBxXNfUZkMl+Lv2xogcqWcFaaPZQky0COP8Q34qHkT7TYmy1z8=
X-Received: by 2002:a1f:ab92:0:b0:3d5:63ee:dae1 with SMTP id
 u140-20020a1fab92000000b003d563eedae1mr3077115vke.9.1674458217943; Sun, 22
 Jan 2023 23:16:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150229.351631432@linuxfoundation.org>
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 23 Jan 2023 12:46:47 +0530
Message-ID: <CA+G9fYtQ9SLrGt0TtW5d3ctZBHEpQpau_+pNzho=qHve8QiDaA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
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

On Sun, 22 Jan 2023 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.165-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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
make[1]: *** [/builds/linux/Makefile:1194: vmlinux] Error 1

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
https://storage.tuxsuite.com/public/linaro/lkft/builds/2Kgdn5w5X9wlz0EVgtSZ=
bTFuRYy/

--
Linaro LKFT
https://lkft.linaro.org
