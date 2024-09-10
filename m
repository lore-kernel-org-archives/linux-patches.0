Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB261EB2F
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725972903; cv=none; b=vCtQW+faazHgX37APQSSSKmDgrB98xFkUbgBij/HNhzgrRCXqicm9KMMLIbmCCyZi1Q0Z5P62Q8KMRBaVzq9Mk8OiHmhCZJrk1XG1YSwqggkDo+e5A6NzFRbFloJBW85iPLUKCBaZ1EW6lr/fTeHqIipE8Ln9SPz9WcpVvBF01o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725972903; c=relaxed/simple;
	bh=SxAkh8uwuAT5ozfDLH78xfu4BSQGaw3OBgkizGvRl1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9phPzc4QI3BpF1WYZQgjocZNglMrlrcKMQ9DN34T3i2swSIanEsKEDKp17hC8TYW2V9TXUHQfv3hyM0TwIdNvOMMepjDxmiRFWKeTuPDXR1gHXV3QBLQocdTMV01E0qC4I3t3N6cObIuVTaqn/jtdDZ3VE2VMbZeEH8GRFC6OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mIQ4wTwI; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mIQ4wTwI"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-502c8f50c5dso734659e0c.0
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 05:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725972901; x=1726577701; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VKyjedl/ddqMl2FSPgpGenJy9ELX4V7Sr7TvuPEW+L8=;
        b=mIQ4wTwIkWyKv2eHiA4rTeQGzbyWUHwJ4X76gI96u/U0PgciQ81STsF6bbqZ+EKlIk
         TpSBJfJN37zeDVj5872QgXwFgOl/LH4dr31sdPpPlCNT78LpN8uYXIfxBxRDOnErNDLH
         OjSAZdzgg07nacFeB/x3x6WLaaUaYbd0GBVfetFB/yjoUo3VRUCyxMh28ymXx9D3rh3R
         VSx3uYZCu5JoePclW5ycG6MMINTzvNTD9r+XKSeLQh1i6AoB2jqABfqoSoXR5HfDIBNO
         tl9RD7iJWRpzx53pQsRPWcK6FGPM1N5dlpzpyJFiQFnGCg/GK7rxtmHYCkbQru6s1hZp
         9iYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725972901; x=1726577701;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VKyjedl/ddqMl2FSPgpGenJy9ELX4V7Sr7TvuPEW+L8=;
        b=PzKPwbOi55wX00O+yQwCCYCYfNXtu/RNHh4Uvvjp10WGpGeM1/clEg7rch4BD8eCi6
         3Rqsbtlw0uzJCyJL7C6ZTOTKjP9ZUdkSqYeF9tphWH4PA2r71PcL1HDRkmj848f9W8lL
         SZioevZRJSakkeZY4G8ZPK5Hv9P3lkk3HDjBLq2vF8kd/qDnGq5LzWnkycCT+ZgAAl9p
         lYZ7t3BwQoADzXwAtNYoOVU1RXnnvi+NZrOSpJ7r9cg4DBRL8ktcnzOFWz7mimX4t1ft
         7OYzgLNKHcLjskfkRZnzhBHRwjKLfyS81NhEbTtfJABb61TFv8/doWeCSJx9U39oR5Ax
         vRDA==
X-Forwarded-Encrypted: i=1; AJvYcCXYKq5pFsg+iRKXfe4nEHZuubl9+XZicjEXo/LeHLno2UUm6wLFI6THz2tRdNVplM7ndefIb8ya@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbis+A8yMcTo+SDTaxbt5i4lo2NuED40d3DdMuK6tEmGV2OZWP
	YChROTti60GOunLIhSIUTErrLFs5yKhlTFvteNDnqsRTEbcvPkDwrA591UKT0q1S9hTCqOmWn1K
	BxJA9nLwuChvIX5yyaAlOnOb/UOYccMR7LMXNHg==
X-Google-Smtp-Source: AGHT+IE9Y+kfYN5IvRsvDOEmVUj0DoGGOvJjlae15nGIZcPP3XpU1vBEgCqkifEGq8ljbZO+kQainr+wo6QGkyfH4b4=
X-Received: by 2002:a05:6122:ca7:b0:4ed:12b:ec99 with SMTP id
 71dfb90a1353d-50207bfb04bmr11342577e0c.3.1725972900980; Tue, 10 Sep 2024
 05:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092557.876094467@linuxfoundation.org>
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 10 Sep 2024 18:24:49 +0530
Message-ID: <CA+G9fYufdd0MGMO1NbXgJwN1+wPHB24_Nrok9TMX=fYKXaxXLA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Peter Zijlstra <peterz@infradead.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Sept 2024 at 15:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The SuperH defconfig builds failed due to following build warnings / errors
on the stable-rc linux-6.1.y.

* SuperH, build
  - gcc-8-defconfig
  - gcc-11-shx3_defconfig
  - gcc-11-defconfig
  - gcc-8-shx3_defconfig

Build log:
--------
In file included from  include/linux/mm.h:29,
                 from  arch/sh/kernel/asm-offsets.c:14:
 include/linux/pgtable.h: In function 'pmdp_get_lockless':
 include/linux/pgtable.h:379:20: error: 'pmd_t' has no member named 'pmd_low'
  379 |                 pmd.pmd_low = pmdp->pmd_low;
      |                    ^
 include/linux/pgtable.h:379:35: error: 'pmd_t' has no member named 'pmd_low'
  379 |                 pmd.pmd_low = pmdp->pmd_low;
      |                                   ^~


Metadata:
--------
  build_name: gcc-11-defconfig
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2lsNsLYIfqdkNQOzLLZO4lq580E/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2lsNsLYIfqdkNQOzLLZO4lq580E/
  git_describe: v6.1.109-193-gb220bb28da0f
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: b220bb28da0f6a629a0d88be3f8e57ea5025c728
  compiler: {'name': 'sh4-linux-gnu-gcc', 'version': '11',
'version_full': 'sh4-linux-gnu-gcc (Debian 11.4.0-5) 11.4.0'}

Steps to reproduce:
-------
 - # tuxmake --runtime podman --target-arch sh --toolchain gcc-11
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
