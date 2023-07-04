Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98567ED9
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 07:01:11 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-791b8500a1dso1255811241.1
        for <patches@lists.linux.dev>; Tue, 04 Jul 2023 00:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688454070; x=1691046070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9pLLIHKvmmk4zC9SwsHcTfPMPfVegexthgZQWT/NwCU=;
        b=a+pGwLbbwJCReamWGknbZ4TgzzLts/gLAaV9nWXDmYXu0RTVp+HIc+Pa5JAYWjgpdF
         H3fX/q7DfDx0zMsbAPblAmXluwU/A9dc0AhZezBWT79vpiLO+o1tuCH6sGyzqFChV2dC
         Uc1eqxPxYnhMHR4q6neEN0OIycj2nx/jme2PN/0FqU44PITVQ/4tg+vyfWar0vJmN1eO
         fP+xS2MijKwNJc4tHpHwMpSqMHBYMnThA8K7aVAiPcJOekMHvfxGmpnIPr97LeieNmJW
         SQczBMVI3gEGRq3onvjyWCQhxP0OHv0lDiSOehDBzyPnTlqafLzgjAM6ds8/zcm+lGjV
         d7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688454070; x=1691046070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pLLIHKvmmk4zC9SwsHcTfPMPfVegexthgZQWT/NwCU=;
        b=BpxfrZpTLV9INsgMdq2ocbQrPe2mUMvmF3eCLFuVgJZe4jveFPuboPz0tNGtLIVMbo
         Fs6QEzJMWacq471sNXIsQk1mXpYuG5pQbcrTVWd2phCiAnkJqelg71U+82Ij9CsFrMTp
         lvhjDN3ua9+w1Rp5plmVqqJoTDqK8aC/WPe4lJXnNahSNkKLHrhsB2l5NFkVZ2hJ75Yu
         a7MM0vh8w3zIc0Okq6kz6jhmaJMblOG+HF2nVlUIRRmhN8PhVLpmKGHJQKFsrXoSoe91
         snZE97hSHTDWpx2A7qSlA8WaaGNnzlBjeEnumJyJNoC7FySjBQpgncDGwI1wFaacmWi0
         8Blw==
X-Gm-Message-State: ABy/qLYTFfcixQfazjqIF09bSSMX+ELYFcyLxYEUNVOBldZUW1MVMI88
	5FFnt30CqeQtUnfrzeYZ1u7OEgvGk/iLTu99ZmXoNQ==
X-Google-Smtp-Source: APBJJlHHFru7hehy/Zd70AaP3FWkvc1cUSv1H/u4Os+sP54Zrm6/BsfpbzuKyGRVs/aUbzDELUweyKecQMONkFL4CGM=
X-Received: by 2002:a67:f413:0:b0:444:c294:afc7 with SMTP id
 p19-20020a67f413000000b00444c294afc7mr3671389vsn.26.1688454070103; Tue, 04
 Jul 2023 00:01:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703184518.896751186@linuxfoundation.org>
In-Reply-To: <20230703184518.896751186@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Jul 2023 12:30:58 +0530
Message-ID: <CA+G9fYueycAbx7DDR3S57d43UX49SOGnW6igQUZ0voEcapxdYw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/15] 5.15.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-parisc <linux-parisc@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Vishal Bhoj <vishal.bhoj@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Jul 2023 at 00:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.120 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.120-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build regressions noticed on stable-rc 5.15.
This build failure started happening from v5.15.119 from date June 28, 2023.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on parisc:

  - build/gcc-11-allnoconfig
  - build/gcc-11-defconfig
  - build/gcc-11-tinyconfig

Build errors:
=============
arch/parisc/include/asm/assembly.h: Assembler messages:
arch/parisc/include/asm/assembly.h:75: Error: symbol `sp' is already defined
arch/parisc/include/asm/assembly.h:77: Error: symbol `ipsw' is already defined
make[3]: *** [scripts/Makefile.build:391: arch/parisc/kernel/head.o] Error 1
arch/parisc/include/asm/assembly.h: Assembler messages:

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.119-16-g66130849c020/testrun/18074467/suite/build/test/gcc-11-defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.119-16-g66130849c020/testrun/18074467/suite/build/test/gcc-11-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.119-16-g66130849c020/testrun/18074467/suite/build/test/gcc-11-defconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
