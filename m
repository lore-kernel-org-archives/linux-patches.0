Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8C21FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 09:29:20 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id v127so27187381vsb.12
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 01:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlEPnwSHAjZr4NXcVpqzSG2AW1hG4W7rPTERaEZE/P8=;
        b=rJFfuSn8QWqsY1C/Cs3RGIp1ElNdVoXaCEe7apJpvEsCvzA0o2G6fa7bSRiX3cy9Em
         RAoiy1jQxGKKcOimAavu29f7AiPA94DEp/fehPo16O6fpJs56NDpf5RfcvgvTl3aYezw
         T5dARuIzB+7iCPpcBE9AfrYRhxHKoOPk8CHMPb9Ix7RbqamsnLPU+H94l/ufz1pVC2He
         abCWUJR7F8puA2qhoSseFXcLUV5ZrSJ0esF0rtLOXosHvnfQcOyiY/dDfrh681S0dX0t
         Vl9egqV0jQgnFDJ5OF0XH6sxdHJKWtB3e7yHdPG1xptDYWOTuNaI1RuEONlluwcvCKX+
         7GCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlEPnwSHAjZr4NXcVpqzSG2AW1hG4W7rPTERaEZE/P8=;
        b=7sL6Oz5HTnGSsjZeZfTVJ/ZM9zmWwOMXQ5UR/MLW3HqEKCiin+JG6Qq+KBIdzcW4gU
         1cRM0euDLNd88YXZSbxF4Jm9Yc2zdLUpYyRV1hix9+D1alRDx7N9B/mas1j5+Vs+ttwx
         aydF3QQHn1BVaAmsLWpcakLaqmNC9CrPWuSo9LV08lk70MFxDBEuwd/AOE9oURZGJhT5
         hfKXH2hyiQwA+tkWX1FW0YuEsESLqb5hednPJZO/mBFdGxQAJ7HuGbBVd/1NFNLFp+cN
         YZJbfaXB9enm/aIhsvzDLkAPJ0CBeoHmA8cg/0C9YTtsmsrb94SU1JUzBOubgNK+zXHm
         gKYg==
X-Gm-Message-State: AFqh2kpakbePIiD49kUqilpHTRx/2iYhbloBn5gBYawCLG2GDhOEQP/u
	ajzYUXEp5NE/cDjUAOowYZgcNwvjWkBbb8qQLhRLgg==
X-Google-Smtp-Source: AMrXdXuD/vWSIHrO86e7jvneaPF9xijTE2czSJFhJSQIV8crGRsjdhOyrbDG9UHVrxcGQotByo5ZQNweJ3w6ywDP/Cw=
X-Received: by 2002:a05:6102:5587:b0:3b5:32d0:edcc with SMTP id
 dc7-20020a056102558700b003b532d0edccmr267127vsb.24.1673947758901; Tue, 17 Jan
 2023 01:29:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154909.645460653@linuxfoundation.org> <20230116202025.GA3397667@roeck-us.net>
In-Reply-To: <20230116202025.GA3397667@roeck-us.net>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Jan 2023 14:59:08 +0530
Message-ID: <CA+G9fYswDKDVtmSNw7VhYCYynY3m8+taBcKN3-XRBa+BKDuMnQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/658] 5.4.229-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Chen Huang <chenhuang5@huawei.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2023 at 01:50, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Mon, Jan 16, 2023 at 04:41:28PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.229 release.
> > There are 658 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> >
>
> Note: Exactly the same failures are seen in v4.19.269-522-gc75d2b5524ab,
> so I won't bother sending test results for that branch.
>
> ---
>
> Build results:
>         total: 159 pass: 153 fail: 6
> Failed builds:
>         i386:tools/perf
>         riscv:defconfig
>         s390:allnoconfig
>         s390:tinyconfig
>         um:defconfig
>         x86_64:tools/perf
> Qemu test results:
>         total: 449 pass: 413 fail: 36
> Failed tests:
>         <all ppc64:pseries>
>         <all riscv>
>
> Details follow.
>
> Guenter
>
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> Building i386:tools/perf ... failed
> Building x86_64:tools/perf ... failed
> --------------
> Error log:
> util/debug.c: In function =E2=80=98perf_quiet_option=E2=80=99:
> util/debug.c:237:2: error: =E2=80=98debug_peo_args=E2=80=99 undeclared
>
> Building riscv:defconfig ... failed
> --------------
> Error log:
> arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
> arch/riscv/kernel/stacktrace.c:58:36: error: 'struct pt_regs' has no memb=
er named 'epc'

The above build error is caused due to,
riscv/stacktrace: Fix stack output without ra on the stack top


>
> Building s390:allnoconfig ... failed
> Building s390:tinyconfig ... failed
> --------------
> Error log:
> s390-linux-ld: drivers/base/platform.o: in function `devm_platform_get_an=
d_ioremap_resource':
> platform.c:(.text+0x594): undefined reference to `devm_ioremap_resource'
> s390-linux-ld: platform.c:(.text+0x5c2): undefined reference to `devm_ior=
emap_resource'
>
> Building um:defconfig ... failed
> --------------
> Error log:
> ld: drivers/base/platform.o: in function `devm_platform_get_and_ioremap_r=
esource':
> drivers/base/platform.c:82: undefined reference to `devm_ioremap_resource=
'

Linaro test farm also noticed above listed build errors
+ x86_64 clang-nightly deconfig, allnoconfig and tinyconfig.

arch/x86/kernel/fpu/init.c:181:2: error: 'struct (unnamed at
arch/x86/kernel/fpu/init.c:181:2)' cannot be defined in
'__builtin_offsetof'
        CHECK_MEMBER_AT_END_OF(struct fpu, state);
        ^

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
28-659-gb3b34c474ec7/testrun/14188759/suite/build/test/clang-nightly-x86_64=
_defconfig/log

--
Linaro LKFT
https://lkft.linaro.org
