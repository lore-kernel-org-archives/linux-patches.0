Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B57291A
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:41:08 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id x14so16054591vso.9
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 07:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uuKMW0ptMKJc4hjZHBFOqY7/EqIKmrJdpJ+S6Gp3nc8=;
        b=hmFtNVVUHYCsdcx8wi+yS7rNqKxZgNqV4MrOYwcGg1qvX8iLLjBR7kxWSInTyO23Jc
         JqnHYvQ+iVl57BwXXypnMe+Y5GAxnWsrnhGFslNHS67R0JQ/IeWQWoEVW/b1pZJ8tsvS
         iuV1dvN3AOpkA1YLIaEOP0CMVANUI3ClvMznUtQxvmOrR0rVEKXb1uXutZFmaC94Ylrv
         XUc2D2uJh42k07yZVtUCM7dHJ+wl0CTUvPRNvyIIxYSOOao+N/Aeoy7YoRqlx2Lm5EEJ
         zXzBt6L+T7CzAk7PQdE48rTh08HLpAClSKnHn1LbKEbh3+JjCRbmaQDFZO8O5y+LDoq2
         nQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uuKMW0ptMKJc4hjZHBFOqY7/EqIKmrJdpJ+S6Gp3nc8=;
        b=mPSDbN53zw7kcfOkJSJfZ+lHEguxayotiRw7VKJdicADEK54X+GZdJAxBSHleu7l8i
         WjZuRRm/9WtdCBLPo9KqGfZe/nXLN1ul6LrHT2B+7HXoYv2KdNRKbqzqO7J2lAH/RZjT
         MBepIotjwrwJJiJq//A80elVU8fHWKWSmpcAR8c3WE08t0RkFl2qdch9wMqWUrezhKaz
         yJ+3713JdqZyCkyWudi9v0XUuYGhT4FFZi28aTDIM9gtaPD/ZIJR5rsisusXqb3RDEVL
         teccx7wIOOZ5pOzsXiuGPH+7uh317JJeeiylgqPQDReEmRdjoMsIeszY3TKEGbuGjQI7
         JkoA==
X-Gm-Message-State: AO0yUKWMdg2ZCOd0PejkzJk2rP+tvY0xhHdV2bkNW9tdcZmTPeBiFOkP
	TPK5QPQZDMZQuXiOlw0VMSwZq/qd9qRVYzRdJA6wVw==
X-Google-Smtp-Source: AK7set/8k/cmi1ZVJM0ILGR4qWng6lyqfkK4d7btSDpUzAcAh0vsL0Zpzwga7giOfJHSk+zPPTz1YN4pLR5lHAPSnvQ=
X-Received: by 2002:a05:6102:1161:b0:41f:2138:41eb with SMTP id
 k1-20020a056102116100b0041f213841ebmr570223vsg.28.1677166867671; Thu, 23 Feb
 2023 07:41:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 23 Feb 2023 21:10:56 +0530
Message-ID: <CA+G9fYuhcaYO1m29-9vQr-HK7_xJYouAAkM=ouMYzOBk+otCVg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / error notices on 5.15-rc2
anyone see these build issues ?

scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:
sh: 1: scripts/pahole-version.sh: Permission denied
init/Kconfig:97: syntax error
init/Kconfig:96: invalid statement
make[2]: *** [scripts/kconfig/Makefile:87: defconfig] Error 1


Need to bisect
--

commit 54fab3cc806aec70d7ce8440e511d56bd53a4081
Author: Nathan Chancellor <nathan@kernel.org>
Date:   Tue Feb 1 13:56:21 2022 -0700

    kbuild: Add CONFIG_PAHOLE_VERSION

    commit 613fe169237785a4bb1d06397b52606b2967da53 upstream.

    There are a few different places where pahole's version is turned into a
    three digit form with the exact same command. Move this command into
    scripts/pahole-version.sh to reduce the amount of duplication across the
    tree.

    Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
    to enable and disable configuration options based on the pahole version,
    which is already done in a couple of places.

    Signed-off-by: Nathan Chancellor <nathan@kernel.org>

--
ls -l   scripts/pahole*.sh
-rwxr-xr-x 1 naresh naresh 610 Feb 23 21:03 scripts/pahole-flags.sh
-rw-r--r-- 1 naresh naresh 269 Feb 23 21:03 scripts/pahole-version.sh



--
Linaro LKFT
https://lkft.linaro.org
