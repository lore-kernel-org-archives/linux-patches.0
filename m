Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2913D18757C
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 09:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725267671; cv=none; b=fd8EBmTYTklGWHPrjkZRa29uyHLevPWOuFqMvV+9v0L+Km/YX0vyHS+yh74nXDPLk2yyhdosbJSoy9ozrsNa3XC1j471UJfS/EabKxA3SSCclfebeb3BAG9Me1PM7HPTpOTBkC9W+NJymzP/OVI8mOs1d7DwJlVsqWvLTR0g0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725267671; c=relaxed/simple;
	bh=UF/oNZ5SbgpZ4WIfaXfqh3OBB6cIqxui1RRnAIkH+PM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbbryqHaFvl7t1JZheQOpLDrQqZl1827z1GJNLKZIkVRORfvC52oUB7zhXINBcxmp1Pk9p2dW8f65LYi+y3ljiF7CJqDP2+DhqFNhY5Vy4aNc5RKo/qfK0ukS/2c/7AOO8PX//2rCcuRiD4/IPFaVZhplz/QLR8vY8Gt3+w/Av0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ckd7ri66; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ckd7ri66"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-498d7c77e91so1337214137.0
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725267669; x=1725872469; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qqSh94kF96VerY0m3+ny14R8sqauQwh7BBb3bguK3jo=;
        b=Ckd7ri66WYKMebeICyOnQ23G7wMUEPQZrA76c8het0xWH80NJMZb9HDtn4G7Fo0N5G
         v2CMRYSbtW4E4tmYXh16f/wUSQdR3vGqUvh97QyZenru24BMBdkRSHYL+E0nBWY563IM
         H3JWrTd1rQsYQn9o8LGnIUSmqh4EtE9b/8fQeeLaCXvWhYr5UXKXXImrW2Erw7vTlp/k
         TzPp9McYQCEmcNgQQJjIrWv966PNTDz1dygA7t/iwgh56228rMLDOkKa7wp8jBUkS6l/
         Sx7qkDKZ6RNAl6zUMxTJYQWV6JtNnOqUuNd4jtZjMM0HZ9Y1bYoXwIHqIZxiRtNNgkJx
         akeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725267669; x=1725872469;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qqSh94kF96VerY0m3+ny14R8sqauQwh7BBb3bguK3jo=;
        b=OAH6JU8YSG0PgXCKEGKQ+jfKyFjwxXK5fFBv8Dh/VJeQ01AJlFfA1Sy39EWU9v7TId
         +jSR1NzMlIobNx7GmzN1//WyaXZ7+cNyi/aLR14D2zonLysofKk7V/COn7sLlrs4G7Pt
         BpCd5t4lrrj5HrUbmQuNBSapCKvFAZx2AxV49Vp2c5qiJ8paZ3BCce8zCmCWeI4KoTwa
         V4uMBSsI7j6a02qoLqAh4SXILtplN/XJytBDGzBjc7wBRXt6Crp+YdtY4kwiChpq+eLw
         r804/TpuqO2dyRRXMeekQgR1wnjhIWiInGhS03cGm21iTcpJDGhvH/2r6qpNKK2PTIoo
         38bA==
X-Forwarded-Encrypted: i=1; AJvYcCXauHmLBZtqbiBmySDcbG1qbDjIZaU62W970PxC74z/QS7Kc4tBeo5E+VCyvMdjKhwXD7D6gdn2@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/GDEN4oKRMNiFTy09jpsQ4dnu0v81+AaXzcnrWRCOkc7PpIm9
	PYZM+cuyjtwOgToYGdZHarrF9xb9pQ3GfIGPMUcKscHitMjgYNFybaPsLiNqaPT+EGHtA6dLbBr
	tlUto6VphQFVvK8Llnje0FRxAcOUI+Ozk2a9E5Q==
X-Google-Smtp-Source: AGHT+IEvo6sNwVTRnSmRm3IVSdi1vc5y1sUmNJLRLJrwsKN7lJkndFUCHSw+iSloG1P66HIall33Bpam1LCeHWDoX0M=
X-Received: by 2002:a05:6102:a53:b0:498:e25c:738f with SMTP id
 ada2fe7eead31-49a5ae82463mr15833583137.18.1725267669045; Mon, 02 Sep 2024
 02:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160803.673617007@linuxfoundation.org>
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 2 Sep 2024 14:30:57 +0530
Message-ID: <CA+G9fYscUiPT0Eo9yo4UhJq2jjYtvLhOofQKhAMEOiVueR-Vaw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, aleksander.lobakin@intel.com, 
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Sept 2024 at 21:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.321 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.321-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Apart from Powerpc build regressions we have noticed s390 build regression.
The S390 defconfig builds failed on Linux stable-rc 4.19.321-rc1 due to
following build warnings / errors with clang-18 and gcc-12.

This is a same problem on current stable-rc review on
   - 4.19.321-rc1 review

In the case of stable-rc linux-4.19.y

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Following two commits have been added on 4.19.321-rc1.
-------
  s390/cio: rename bitmap_size() -> idset_bitmap_size()
  commit c1023f5634b9bfcbfff0dc200245309e3cde9b54 upstream.

  bitmap: introduce generic optimized bitmap_size()
  commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.


build log:
--------
drivers/s390/cio/idset.c: In function 'idset_bitmap_size':
drivers/s390/cio/idset.c:21:28: error: implicit declaration of
function 'size_mul' [-Werror=implicit-function-declaration]
   21 |         return bitmap_size(size_mul(num_ssid, num_id));
      |                            ^~~~~~~~
include/uapi/linux/const.h:32:44: note: in definition of macro
'__ALIGN_KERNEL_MASK'
   32 | #define __ALIGN_KERNEL_MASK(x, mask)    (((x) + (mask)) & ~(mask))
      |                                            ^
include/linux/kernel.h:58:33: note: in expansion of macro '__ALIGN_KERNEL'
   58 | #define ALIGN(x, a)             __ALIGN_KERNEL((x), (a))
      |                                 ^~~~~~~~~~~~~~
include/linux/bitmap.h:215:34: note: in expansion of macro 'ALIGN'
  215 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) /
BITS_PER_BYTE)
      |                                  ^~~~~
drivers/s390/cio/idset.c:21:16: note: in expansion of macro 'bitmap_size'
   21 |         return bitmap_size(size_mul(num_ssid, num_id));
      |                ^~~~~~~~~~~
cc1: some warnings being treated as errors

Build Log links,
--------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.320-99-g0cc44dd838a6/testrun/24994013/suite/build/test/gcc-12-defconfig/log


metadata:
----
  git describe: v4.19.320-99-g0cc44dd838a6
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 0cc44dd838a6e3fee60d7af3ca412c4d1b824562
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2lTf8qakoJKDjTgS3TvH3naApk1/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2lTf8qakoJKDjTgS3TvH3naApk1/
  toolchain: clang-18 and gcc-12
  config: defconfig
  arch: S390

Steps to reproduce:
---------
- tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
