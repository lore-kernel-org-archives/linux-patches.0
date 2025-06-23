Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFA81F3B96
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713408; cv=none; b=NXKcxDt62g3f49uIdS/8UrBaZWy/c/3Jm5txx57Z7eLgsRgO6fv12JQvKvyK9mLaVFey2YphOF4jSOCsHGD3B+mTE5AJEMnWANidE9jkH9t3vRdUMsHwHmvBm53wyF2F/R7C2XlMdWZEx4EoAL+dEl/G9Vm+qR1OKwmkmSJsjkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713408; c=relaxed/simple;
	bh=LtDdaRCFnOzRaKVTAE3F/dlf7+IT0xFa6bseJet1gxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQQaKRUEMzbcxiDXbUlMOM3biGjvQUauaT8Gu8vZKT100MfJjjmJEYb3PSDODT+GKz7YSU/IAXk6JmWWVxWwbboWhgyeAJQdKgUSoAMxTNM1o7LTvadOxR0JsKXifgW580oEIfj2+tkCJwMb3VOGfJCVlwYTrieshAz2/nnH+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SLgftCek; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SLgftCek"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2c4476d381so3578868a12.0
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 14:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750713406; x=1751318206; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zAxIbG7Zl9ZnLRYF7XmoS7J2q0R3DwVsCI7SvRvrNiY=;
        b=SLgftCekrG+tCxrqT32UY0M64BbfPepxVBbd0mye0jdpqlAq+eqXdcwDu8Hg9uhmUj
         iJ94MUBasrIvOI9QBuZAdcxYYJuSdZxUZDx/11TaoDb7Qoe0N/KMghzyagPlsMsbIzu3
         PLQiMSkZQxBa9ARu0Z0IsQp3xIdxnWrMhvCCyEOhAVQGOMD7I4/0u8vPO6vSnYJ0L0Nr
         YzH/FqOrMR2V6KnL2rO3wUg5Fy3tRKh6B155rXOKBtK7Xg+wlIJzr5+6N7o/MyZBm6BH
         f+y0FWbrkrKgfwSHlXvoYo+LYa51nxFLKO+2omxJS94fvBYP0/iqPz3CSQRc+bGVBFcd
         OuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750713406; x=1751318206;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAxIbG7Zl9ZnLRYF7XmoS7J2q0R3DwVsCI7SvRvrNiY=;
        b=wkjBgqf+rvqYvEngDHXRBz9I7sPBO/m45PRLiLEsJyctyPfILTwb30TAjFLsXLrKi5
         1ISBMAwr2NaqAcQ3qF605DxyoEUhqFZExx1eGvN1cmIHxS98GMwSEmePUgaOG2fIR3rs
         suJTEYjKVj8I53RfzF5rThW5YezzOj5sOZf09fZzqZ3QvozwPidfXQGQn/Z8/3p3eRGL
         mbYKXT4ZbXK4ACxOmPe0SaXjo+uE2DtPD6YCxLmlYlVg6UMV4bLA2Wcgxb/p1Fmywaez
         WIM8I4dGjLTQWyGtEFJy0+Whohw8slWePimylhjp7yHfyJsJCtc9GZrehx43WywUNYO8
         s3tA==
X-Forwarded-Encrypted: i=1; AJvYcCUSRUIP8us1nVV2z7UPoRcegv1OpD2gLF0+Lhj88KReJIgeU7lDEQ1HnmhwQlctpWdBm1qco+dY@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9Z6tSgfroU58mlv5yoUD4Ha9m/IVy6F2Tzffxs2gEy+dykoEv
	LZYvLjatsOEPpMuxSF256T3qxmBVMpgsqDask2WIuJKjlwd+wb5GaBhyidzOkppvf6gimRU6B9t
	uLrf6AYWU8rYAWrIzsXd/7BOzgxu+WBBdWch36T6KCQ==
X-Gm-Gg: ASbGnctjLaL1IBA+5TZUquZmtSq2jePRrtm0xKM0dozduCDL4tNqFXWCXmhrsKD6jxp
	bamCcLv2Diu9yemdjXNIFSjjWrr2W7/rR44ZRM3aqJb5gHzLMkbSmRu/un7Kj1bddnKVTIzR4Ds
	B3mWFzIBKSXuPfMSGUPfMy8WLj4M43pOR2/fCOc8dA4lNQA0IMnGDsAYSwjxAvDXyvhJpV3O1rL
	qbt
X-Google-Smtp-Source: AGHT+IHdXTjLmFniSVEoVRLtzjN2ucReqYqHFsQsGXxHYWXnRGns80Bi6bWad99swFSENzSSlizfjzmNIUY68yEdsng=
X-Received: by 2002:a17:90a:da83:b0:312:dbcd:b94f with SMTP id
 98e67ed59e1d1-315cccc4472mr1503356a91.11.1750713405985; Mon, 23 Jun 2025
 14:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130642.015559452@linuxfoundation.org>
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 02:46:34 +0530
X-Gm-Features: Ac12FXww9_WpdOaHdkgJbruDk5iAmI9JDDJZ3Q-jbazbPa6fMcxkmYRxXtADy4A
Message-ID: <CA+G9fYtdHwOUg==LJ-uiH2xy_GXU97yb2Fui0PnXShG_X8PA8Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/414] 6.12.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on parisc, s390 allmodconfig builds with gcc-11 and gcc-13 failed on
the Linux stable-rc 6.12.35-rc1.

Regressions found on s390
* parisc, build
  - gcc-11-allmodconfig

* s390, build
  - gcc-13-allmodconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 6.12.35-rc1 s390 allmodconfig
sdhci-esdhc-imx.c 'sdhc_esdhc_tuning_restore' defined but not used

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build errors
drivers/mmc/host/sdhci-esdhc-imx.c:1595:13: error:
'sdhc_esdhc_tuning_restore' defined but not used
[-Werror=unused-function]
 1595 | static void sdhc_esdhc_tuning_restore(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-esdhc-imx.c:1573:13: error:
'sdhc_esdhc_tuning_save' defined but not used
[-Werror=unused-function]
 1573 | static void sdhc_esdhc_tuning_save(struct sdhci_host *host)
      |             ^~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

## Source
* Kernel version: 6.12.35-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 97420f337f2e873945307514e185ab28a4eab0de
* Git describe: v6.12.34-415-g97420f337f2e
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.34-415-g97420f337f2e/build/gcc-11-allmodconfig/
* Architectures: parisc
* Toolchains: gcc-11
* Kconfigs: allmodconfig

## Build parisc
* Build log: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYNm13k63nvGpMv5Vv07a4U9J/config
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.34-415-g97420f337f2e/build/gcc-11-allmodconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYNm13k63nvGpMv5Vv07a4U9J/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYNm13k63nvGpMv5Vv07a4U9J/config

## Steps to reproduce
  - tuxmake --runtime podman --target-arch parisc --toolchain gcc-11
--kconfig allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
