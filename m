Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C591918FDA9
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 20:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734035096; cv=none; b=nx36zN4tGOSfkzIK5gly2zsq4plMfyuON0fPPGJE3DKzU5W5mqGK7QOVwcXymSBJx589pl6ntwXhk9QyWGmJDVCokCyhVKoKsdGxC0U66y6saMLT17ocasPLMnY6LGLCA2ujb5znYr08GhzYg1RTo825z33NzT85uD7tk7BZ8Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734035096; c=relaxed/simple;
	bh=yV9T7CxTEClw3ojAbutwyowwYwyXXH8RWuHVjIqJgkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pc16fLPTAPWj69mtg59stPJ6DutBOh1FWBJG3tFAOQRcPgVajk7nY3gmft/LnN7HGZ8aDpGZTB39sQWz6B+VUqw2my0vUHY/mSIqel7himqgzYl5MO1EJp9xkCzKNIfJARj1c4QPL0GvyCjn3Zxj9D+hFmEVrSbxkoSjKKG07CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=godJoqEk; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="godJoqEk"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4afdf300d07so497599137.3
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 12:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734035093; x=1734639893; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xyk1k1r2jAN0cLHaRGF2s0N18A+YSZ8gAxSbY2GuSVk=;
        b=godJoqEkyRrcsKtX68ME/HD10WWbKhubkCWYLtgRCjSKmG8CQ5WPRf1dFk+CwtLvk1
         MxGJpyyupXc++xGEQsK43il8Oi3EZla5M/jQONsq/67+i6kbtwhpsZ0mSvrXNYBY2IZW
         JLOkuftFv+KIrMiWNhmudPHL4vOb9vFClq8bGYkahsGJo7ZYapoGWmxjBXAYmAkpFw5r
         9s6Go29bRO9q3QRAy9PC6a6QwAwNw1v2V2LmgfAsKiLndSphutzYKD5+BHUA1QeVdst3
         nL8MVfXx843XjeUJPQtjUgKVMqeMoszZu6MRFJY7DsVc3MBv2PRkaMiAmNgtNecZCuXz
         Fevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734035093; x=1734639893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyk1k1r2jAN0cLHaRGF2s0N18A+YSZ8gAxSbY2GuSVk=;
        b=v09yszzN5GKrnujN08mHVOIjudx/lZ53ev8mNgGH05EcfJcxnOb/sTBGQ0Dc9tFufq
         e2JBHwJJol6ooGzqxa5YpM4xgsm7dXlnFVJOrK4U+pkDmyhy/LhhucRyqY9e9EcQG7zc
         AtHt91XRWAmXyNkkgameNDWuUCxg18Vzrgzoz19Gm35qHkiQWQ7S1gQ4M3UZYPhimf7p
         RwGTljwAzRwaui5WhhXxv7FuXz83ILQ6H7yTdzar0xOyNYG4Ecj6k/KSvLKZNpxw8nFS
         PLCbaHtADyVwF6grJoTSv0xQCxKe8ydMwUprvsjMl/MJ+otKNDmJtjBM8hW8xKWt6kVa
         7gTg==
X-Forwarded-Encrypted: i=1; AJvYcCUB9c5j/eGSFU33TzPqEZpiHP1lsDk9C33HoVP1XdjBSTU1Nx2f8x356do46h6dSIHnATh0W7e4@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1di6/vVHrCmVlAZDKPuBDyTg/l8M9/ND04LjhZHxOvb5UcY/R
	LGBn7g3Hpz/K164nGbmeL06bC8IhNxjWocj1P2HEAnD2X5Snu7XOF/5liYNo7C6SfxyDiIIKX3m
	0uy8Dc2ZYLx2dejElgNDvOiYWG/lOXOK71hbB8Q==
X-Gm-Gg: ASbGncsdL/eEsRvu0GVppyiMARApu4Si/PvG+snKT2WIq23g8T5tDixQrXYtbhDJXBB
	XM3pKBSFfHpFwyeZ/hLOqTv2FQ1bBPsE0Lv/x
X-Google-Smtp-Source: AGHT+IE6vhYsuoPpswe0nSPSyj8CcBuRJJiRB+TTqVgTkTFg6/WgsSkujdn5pkuKz45a/zlvFALZgalThUsECtSfvGs=
X-Received: by 2002:a05:6102:3caa:b0:4af:3ad1:a26 with SMTP id
 ada2fe7eead31-4b25dcf59b3mr333942137.16.1734035093603; Thu, 12 Dec 2024
 12:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144229.291682835@linuxfoundation.org>
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 01:54:42 +0530
Message-ID: <CA+G9fYv+i=T0KeWvxhiCOFiMSmpUYeUOWwn_YunEaYTi8oA_Ww@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Thomas Gleixner <tglx@linutronix.de>, John Stultz <jstultz@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 23:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As others reported,
The arm builds failed on Linux stable-rc linux-5.4.y due to following build
warnings / errors.

arm:
  * build/gcc-12-defconfig
  * build/clang-19-defconfig


First seen on Linux stable-rc v5.4.286-322-g3612365cb6b2.
  Good: v5.4.286
  Bad:  v5.4.286-322-g3612365cb6b2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-----
/builds/linux/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c:173:2: error:
use of undeclared identifier 'DRM_GEM_CMA_DRIVER_OPS'
  173 |         DRM_GEM_CMA_DRIVER_OPS,
      |         ^
1 error generated.
make[5]: *** [/builds/linux/scripts/Makefile.build:262:
drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.o] Error 1

The commit pointing to,
  drm/fsl-dcu: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS
  [ Upstream commit 6a32e55d18b34a787f7beaacc912b30b58022646 ]

Links:
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.286-322-g3612365cb6b2/testrun/26292205/suite/build/test/clang-19-defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.286-322-g3612365cb6b2/testrun/26292205/suite/build/test/clang-19-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.286-322-g3612365cb6b2/testrun/26292205/suite/build/test/clang-19-defconfig/history/

Steps to reproduce:
------------
# tuxmake --runtime podman --target-arch arm --toolchain clang-19
--kconfig defconfig LLVM=1 LLVM_IAS=0

metadata:
----
  git describe:  v5.4.286-322-g3612365cb6b2
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 3612365cb6b2a875194a5f6d7bc8df7cc26476b3
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7we4wjwYp6rA5DbAHITARXUgJ/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7we4wjwYp6rA5DbAHITARXUgJ/
  toolchain: gcc-13 and clang-19
  config: clang-19-defconfig
  arch: arm


 --
Linaro LKFT
https://lkft.linaro.org
