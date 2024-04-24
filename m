Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FB7157499
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713947030; cv=none; b=urZJkPrW50JMZkNMLdVk3JrBeQMu42bFytAE4Al1+b4ggIYrO/YXOvB220ha8l46vghpan07zS4MO33qqCwCL7YJYzT4MU+gWlSu9madl7en8whe8oeRLEENS6fg0oJ1T18DQyoz3Z8M2BI8kuCYx2a6h7xXa/9vkUSPyre1zWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713947030; c=relaxed/simple;
	bh=Zp3ox78TP6hxWDah/Xpqv+ArZs5jq62G8JwODJB4R/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+X02cEQWfJ/0xSk1hNjBygdzySnX0O6dudQW/LvFzckmRSUlxvip+5hnZ9zFB60VO+Gr2KlOF3Q4h2kaBSCtbRWghwBZFV3ZHISu4+par/HTfO86PTiLhfYjcqZ/zEpR7BCtOJqDjR6dwygpBmTUr7oxi2MPXgzuMhP/XtCrgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YaFZq3N2; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YaFZq3N2"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4daa1be011dso1665218e0c.0
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 01:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713947027; x=1714551827; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hPFo+IxgUQ2kIlqLDAB9FNtWLgx3YKcW7YRqfGcT4is=;
        b=YaFZq3N2TzxM6fUo7rUiH2+ZHrfer0fBU/GR2AW4McsS4B7rodtyRF1jG38wm1pi0k
         64Q8m0wUDEIiNIvaw0Vkc3sXhos5JuS9RzVJHTlsZUUihg270P3XAzQ8UHNlInulDNvc
         s3+lGZjAq3dOT7CJ2PgZt5VfAZW2tMyFPrLUGQTOR2Hi8fiyFZhMjHHC+53udR/KuQs+
         sTwZfqS0MJqCGnJ8m8ZEzYzCAxSNfa0TsDeo6FLxGMG9aD+iNlZY7HZFBpCzkrSEPVXM
         VqbSS5j3lkUN4mOwI9t5BPriLBDJaDcNNgxrrlfNhCvxxxks7TI+mpfNvAOQn2k6CaaG
         bD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713947027; x=1714551827;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPFo+IxgUQ2kIlqLDAB9FNtWLgx3YKcW7YRqfGcT4is=;
        b=dRNYXeYOGNPt9dyf06GfBmxfhjLVBMnHHCGQzGlTFtvCnqghM9DIfz3pOmQg/nQeLi
         /gd1SAIJEugVhgKrcQga2kHn3XWkrgnDB+Fr0qDUpa2CAHdbndan4CB+VMC6XV7fRAMd
         F7GJw2IPmQLCnpElSpBaYlkp51j9ZunzJ8AYqjETbAQVclFSD+EXk8cJA713Pk7PCpiC
         RgGcHcZWmm9qYPSuKEwlziwyd5wFfD86lorfMRsRK1nZZgQkCpB5TzFfiayoUgKFishA
         k5Z8uPH9DsFBFtivCAfNnXQ2YMTk2vLJMGiETo5gXIHrXmFtx2vpC/gbMmCcTzOTe7SC
         fOTg==
X-Forwarded-Encrypted: i=1; AJvYcCVOq/f5+Q9XBdsx92tEB6eEctD1J+mYoGYztbiKeXAyARr00dQ5XpxTubwuhmBNyqRsJsciQ90G5mfQWXChFaemqg6ZgxDipA==
X-Gm-Message-State: AOJu0YwGauxBFTIWkkyA8mhtLXdQA/3WgZ1uA+oSBWsDrvJOHI9g7fk2
	gjSv4yuc2UaLw+vh9n3Qrq+D39x2tnfCCrVvUU/EVICqhg3b8vfMiD7z8o9WAtkhF0xNAbPjfXo
	k1ARADeej0OfScNa+sPWVvCA4lZRbCtszoaSVQrtqBRKbNBIibzE=
X-Google-Smtp-Source: AGHT+IHZ7X76KDkGnfGA3Bl/vGPMhc2BLowSx3pIZsvhaqPdCqZCneOazFLgOUQklJc7AYOw6nVgw9sTtiQodVWHsnE=
X-Received: by 2002:a05:6122:3284:b0:4dc:fbc5:d47 with SMTP id
 cj4-20020a056122328400b004dcfbc50d47mr1633005vkb.16.1713947026616; Wed, 24
 Apr 2024 01:23:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213853.356988651@linuxfoundation.org>
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Apr 2024 13:53:35 +0530
Message-ID: <CA+G9fYuv0nH3K9BJTmJyxLXxvKQjh91KdUi4yjJ0ewncW5cSjw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/141] 6.1.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Apr 2024 at 03:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.88 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.88-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As Pavel reported,

LKFT also found these regressions on 6.1.

The arm build failed with gcc-13 and clang-17 on the Linux stable-rc
linux.6.1.y branch.

arm:
 * omap2plus_defconfig - failed
 * defconfig  - failed

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Suspecting commit :
-------
  ASoC: ti: Convert Pandora ASoC to GPIO descriptors
    [ Upstream commit 319e6ac143b9e9048e527ab9dd2aabb8fdf3d60f ]

Build log:
---
arch/arm/mach-omap2/pdata-quirks.c:259:15: error: variable
'pandora_soc_audio_gpios' has initializer but incomplete type
  259 | static struct gpiod_lookup_table pandora_soc_audio_gpios = {
      |               ^~~~~~~~~~~~~~~~~~
arch/arm/mach-omap2/pdata-quirks.c:260:10: error: 'struct
gpiod_lookup_table' has no member named 'dev_id'
  260 |         .dev_id = "soc-audio",
      |          ^~~~~~
arch/arm/mach-omap2/pdata-quirks.c:260:19: warning: excess elements in
struct initializer
  260 |         .dev_id = "soc-audio",
      |                   ^~~~~~~~~~~
arch/arm/mach-omap2/pdata-quirks.c:260:19: note: (near initialization
for 'pandora_soc_audio_gpios')
arch/arm/mach-omap2/pdata-quirks.c:261:10: error: 'struct
gpiod_lookup_table' has no member named 'table'
  261 |         .table = {
      |          ^~~~~
arch/arm/mach-omap2/pdata-quirks.c:261:18: error: extra brace group at
end of initializer
  261 |         .table = {
      |                  ^
arch/arm/mach-omap2/pdata-quirks.c:261:18: note: (near initialization
for 'pandora_soc_audio_gpios')
arch/arm/mach-omap2/pdata-quirks.c:262:17: error: implicit declaration
of function 'GPIO_LOOKUP'; did you mean 'IOP_LOOKUP'?
[-Werror=implicit-function-declaration]
  262 |                 GPIO_LOOKUP("gpio-112-127", 6, "dac", GPIO_ACTIVE_HIGH),
      |                 ^~~~~~~~~~~
      |                 IOP_LOOKUP
arch/arm/mach-omap2/pdata-quirks.c:262:55: error: 'GPIO_ACTIVE_HIGH'
undeclared here (not in a function); did you mean 'ACPI_ACTIVE_HIGH'?
  262 |                 GPIO_LOOKUP("gpio-112-127", 6, "dac", GPIO_ACTIVE_HIGH),
      |                                                       ^~~~~~~~~~~~~~~~
      |                                                       ACPI_ACTIVE_HIGH
arch/arm/mach-omap2/pdata-quirks.c:264:17: error: extra brace group at
end of initializer
  264 |                 { }
      |                 ^
arch/arm/mach-omap2/pdata-quirks.c:264:17: note: (near initialization
for 'pandora_soc_audio_gpios')
arch/arm/mach-omap2/pdata-quirks.c:261:18: warning: excess elements in
struct initializer
  261 |         .table = {
      |                  ^
arch/arm/mach-omap2/pdata-quirks.c:261:18: note: (near initialization
for 'pandora_soc_audio_gpios')
arch/arm/mach-omap2/pdata-quirks.c: In function 'omap3_pandora_legacy_init':
arch/arm/mach-omap2/pdata-quirks.c:271:9: error: implicit declaration
of function 'gpiod_add_lookup_table'
[-Werror=implicit-function-declaration]
  271 |         gpiod_add_lookup_table(&pandora_soc_audio_gpios);
      |         ^~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-omap2/pdata-quirks.c: At top level:
arch/arm/mach-omap2/pdata-quirks.c:259:34: error: storage size of
'pandora_soc_audio_gpios' isn't known
  259 | static struct gpiod_lookup_table pandora_soc_audio_gpios = {
      |                                  ^~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:250:
arch/arm/mach-omap2/pdata-quirks.o] Error 1


steps to reproduce:
---
# tuxmake --runtime podman --target-arch arm --toolchain gcc-13
--kconfig omap2plus_defconfig


Links
---
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2fWG4dRZzA7WgJqyLQ8Rm05WTUo/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.87-142-gcde450ef0f2f/testrun/23640116/suite/build/test/gcc-13-omap2plus_defconfig/details/

--
Linaro LKFT
https://lkft.linaro.org
