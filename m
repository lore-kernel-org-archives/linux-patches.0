Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643055CBD
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 03:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KJ3ysgyf"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6d9dbe224bbso3805793a34.2
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 19:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702352322; x=1702957122; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GfR12TX/dwvBcAH+BhtOx1KSZ94OetGmBU0H8LS/sPA=;
        b=KJ3ysgyffdrc8oU8D1MeQvQgVZpCl8ZxE+B0AAH4gvm99eVcA5frHn/sfK+GirKEO2
         3UWhMnqoQK4UpUgggyx5JhQmZVWJFzyzcf0ErBk7WH7TLJLbE/iWvnilmy4jyVOfdUfN
         bRqInZSlSRej70H8LZP6rhDeV2f9OKPEAT4ZrM9yh0V0ECv/h6AETu/tq8RLvjhGVOhE
         /zuL4rfJ+4uj+6leDAEFvKKWRl0uChRlV4dm4wHJdLaZHBHErj/MLEr6byWz9Qzas0nV
         HGIzcWirCiftk8UIjncVrCRTtzsHCpcewlUe2qxEtnoC7/uhENuhY5Fl2b6pCV8dKmmy
         SyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702352322; x=1702957122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GfR12TX/dwvBcAH+BhtOx1KSZ94OetGmBU0H8LS/sPA=;
        b=uf/A6nfwa2Q1nXZcrbdRWoKziosbUjp2lloUQ3Lg7ZrVgq/wGvmPlEbOZoTXp54m8Q
         9/M/ucIsowEKF3jzmYoJi9fbkjzlkbWvs8mHJ2GpN4uDHsvgKibGmfJCliv24G3Aru68
         Ntk2DAZAqynhPuLMrY0GB+Icugs5xTyGy2jm13mtki5Ln72k/b6s7A+9r5rVceupZW9V
         yU2yGy80GpiFTIFytEaHXDYUBuaHhVn9DKOfCqgHHQQTKK3IM03KJJsoAmOGIdemWMzL
         WvT0FFnv7VyyyCqeWG6YIfsM1CZvF74FHRX7ZcYw5U4WoOwu66L/zz8EFjhyMVaRp/36
         Qm5A==
X-Gm-Message-State: AOJu0Yxc15cPUSrOiot4tiiKZBaQSNXqtRtb3bTuRrx0ibTOHq67NiNC
	qOrl0uZ0Uf/BD05VwO8yhm8QeA==
X-Google-Smtp-Source: AGHT+IHp9MhyQyyikun064nStAYIA08DlIfICK3A0xryOIlufQLKkDvyKTo5uaCMgB0OOlCdHV/vGQ==
X-Received: by 2002:a05:6830:1e83:b0:6d9:d7b0:b with SMTP id n3-20020a0568301e8300b006d9d7b0000bmr5579222otr.17.1702352322240;
        Mon, 11 Dec 2023 19:38:42 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.113])
        by smtp.gmail.com with ESMTPSA id v15-20020a05683011cf00b006ce2db9e6c4sm2008714otq.36.2023.12.11.19.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 19:38:41 -0800 (PST)
Message-ID: <a2fbbaa2-51d2-4a8c-b032-5331e72cd116@linaro.org>
Date: Mon, 11 Dec 2023 21:38:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/141] 5.15.143-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, arnd@arndb.de
References: <20231211182026.503492284@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 11/12/23 12:20 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.143 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing new warnings with GCC-8 and failures with GCC-12 on x86/i386:

-----8<-----
   In file included from /builds/linux/drivers/gpu/drm/i915/gem/i915_gem_context.c:2291:
   /builds/linux/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c: In function '__igt_ctx_sseu':
   /builds/linux/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c:1284:9: error: left shift of negative value [-Werror=shift-negative-value]
       ~(~0 << (hweight32(engine->sseu.subslice_mask) / 2));
            ^~
   cc1: all warnings being treated as errors
   make[5]: *** [/builds/linux/scripts/Makefile.build:289: drivers/gpu/drm/i915/gem/i915_gem_context.o] Error 1
   /builds/linux/drivers/gpu/drm/i915/i915_perf.c: In function 'get_default_sseu_config':
   /builds/linux/drivers/gpu/drm/i915/i915_perf.c:2817:9: error: left shift of negative value [-Werror=shift-negative-value]
       ~(~0 << (hweight8(out_sseu->subslice_mask) / 2));
            ^~
   cc1: all warnings being treated as errors
   make[5]: *** [/builds/linux/scripts/Makefile.build:289: drivers/gpu/drm/i915/i915_perf.o] Error 1
----->8-----

Bisection points to:

   commit 09ebdc1b3dfacc275d5eec3f1dcf632f18bbf5a8
   Author: Arnd Bergmann <arnd@arndb.de>
   Date:   Tue Mar 8 22:56:14 2022 +0100

       Kbuild: move to -std=gnu11
       
       [ Upstream commit e8c07082a810fbb9db303a2b66b66b8d7e588b53 ]


For GCC-12 it's allmodconfig failing, for GCC-8 it's defconfig (i386_defconfig, x86_64_defconfig) just reporting new warnings.

Some reproducers:

   tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-8 --kconfig x86_64_defconfig

   tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfig allmodconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

