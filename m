Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236B6C976
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 15:56:41 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id s1so13805143vsk.5
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679414200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHA0cbdS1dEyb0KuPSwVES+1ODSyv2r98Cp2t9mhxB8=;
        b=yar+ksCzoZkluxr+vs0ZiQVsF7HNpXYgn8MTm4RndKU9Fo9SxqinqibYQ+b6EAe3TG
         NCy/89MkYu56pqRngTI6LdM54Mi0lEBqmjZNeNNZkVjj7q7r5FH9fvsFoFGmPpuXwa4a
         VDLyqm+gxBA2N7ihubkc6XwAdfFPAC/ceNVjOqC7+hS0wQSlFASt80Dm1YKeWXceTQTn
         JDEqvP8HmcOHjPEwk1gJd7eHpojkdGh5uM4cvf9RNDJHKwsENKO+iMy0ais+/VGpX173
         ACGyR4G02X8UUrNCCD9BDNdqqudS69NqtZYdyhCH0zGpK6CDBH+vj0/tbzOPo4kE/ynt
         YecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHA0cbdS1dEyb0KuPSwVES+1ODSyv2r98Cp2t9mhxB8=;
        b=g7Em1wSoZFSf4b1g9mgthQMrPCxAhr0olEeiUa/L3crkPoGztp0qNMWNtZU4rq/W97
         V0Ej9TRMdB2/UhrFsgHWLA5vSPO2eZxXwRmKVSBaDgkcdMgU32+0fHaIdbfkP5d9SVDT
         o8+Y6ccPZUOGZ2FoXFcEbeHVYj/TuNJT7lksbzttEG7bFX02pm5Ow3KIhkw4d6r7hGtq
         0ZeOooQvJqLd6YvMorZGUoR8RqC/+hsZCQHyjs95tFKujzSi9vwig8njbbXtOGWMpPsv
         j+tGsqUAkh86eLz4Sg07TIykP8Y0ZE41buPgNvpZR2Q2C/pA3LkYdJRmLcY6Ma6Duq3O
         jLIw==
X-Gm-Message-State: AO0yUKUELGD+MMbbaCNC8gM9bIXeXsV1EaZYsS3UqTtzxwINCgrTUsVc
	qIW7RmPfYbC5k4n73vZ5032RasTCutgFN9f3eT/oww==
X-Google-Smtp-Source: AK7set/6uZ4VQJHCSPEmC6Kx2n6cqlS8YV4W7n02P4n11z6JEfRsyN55Trd6Z4oD/280pdj9aUGBapt6Wv6iGdPSt7w=
X-Received: by 2002:a67:e00b:0:b0:425:d255:dd38 with SMTP id
 c11-20020a67e00b000000b00425d255dd38mr1765286vsl.1.1679414199753; Tue, 21 Mar
 2023 08:56:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080604.493429263@linuxfoundation.org>
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 21:26:28 +0530
Message-ID: <CA+G9fYtC86ZEBq=qT7ZymtGVKfUurebVGXtTo3JbKYRS_4+B=Q@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev, 
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Powerpc builds need more commits,
RC1 to RC2 the
  - Build  clang-16 tqm8xx_defconfig got passed.

But still following build failures noticed on RC2 with
  - Build clang-16 ppc64e_defconfig failed

---
error: unknown target CPU 'e500mc64'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
error: unknown target CPU 'e500mc64'

---

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/64: Set default CPU in Kconfig

following commit also missing fixes:
--
From 77e82fa1f9781a958a6ea4aed7aec41239a5a22f Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Mon, 19 Dec 2022 19:45:58 +0100
Subject: powerpc/64: Replace -mcpu=3De500mc64 by -mcpu=3De5500

E500MC64 is a processor pre-dating E5500 that has never been
commercialised. Use -mcpu=3De5500 for E5500 core.

More details at https://gcc.gnu.org/PR108149

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Pali Roh=C3=A1r <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fa71ed20d22c156225436374f0ab847daac893bc.16=
71475543.git.christophe.leroy@csgroup.eu


--
Linaro LKFT
https://lkft.linaro.org
