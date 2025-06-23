Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B3A2D5433
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750710431; cv=none; b=bLoKb1zCoO83VbjcMG4YQbVh42f3IpytClPhsZOA/dlh8woR5TGcVJYIzvA90YoSfhZ6rw9bJnWK0oQ+5EWAw+Xy/fiAzqRcxAZbcC+91P217rVel+PPJHbGcYHGpZtTTBMdmlrO5LdlRdUoA3mBGTSJuyKA//zN8JKwiZBz6v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750710431; c=relaxed/simple;
	bh=TDPcuBC+3194iIDORM/5M0k0GX6HQXVenukZhJrYlEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QS9XoKa29XnFqeoIISaseWbVLwSuPncn8H5kJOsx0ZoehDV+2cm1UxDKiPE/eX3QjIxRWNhErOvP0NC0BKuH9YQfIh9ig9/B0PKyy1X1Zb4m44Paz8Eu1pxjSi4Q3Up+BWqBAtSdO2BCdwUHimjuNIROQcSRA9bkOyutN1JcUz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SoCyF8eY; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SoCyF8eY"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-31223a4cddeso3466270a91.1
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750710428; x=1751315228; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TRUWTVvPr1yAn+DH33u9nddl4ICwL7m9XNyge0uZ0XA=;
        b=SoCyF8eYvyj6sDrE13rCdPyVfhre4DivYGeers8O+hTTo/okvqXOBjfbWLO0FGhoE4
         COOx4dYyO5cqG1otfZGhe02TQaRQ0dzvIBKD/jDoVUSbhZCmhhx6o/h3dPQnl82mfHAh
         mya0ez3CCssxfuwa6GarqQGjrnkLGfNoUkuJIdp/jXiuGQjwhPvJGXHKDTiwpyPHEBnN
         hb0msS+NpW2IjYrT37anKK1hEv0tXQ8Mv47wvTq7F7T06LZTwgE346q5LD8v8ukjg8lu
         Eg83Q4hH5U+jUYeYxI0ka8tY2Q75fsiwJde1ZAvEvjnE1DG45cHLGTdrqS0LMHW8KZLJ
         lggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750710428; x=1751315228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRUWTVvPr1yAn+DH33u9nddl4ICwL7m9XNyge0uZ0XA=;
        b=rj+N+8jMiRRf8y/HhhO/VnDbNFBsdBX26VjBxBp8TousQne/PT03LCuXdh27MQUlrG
         wK2em6QxBIlsPF2sQrWk/STiOVHORZ+zS75eM0JvTiEMzoS7ecBzIY0IsA+hiWpM/eVr
         8hESYPgnLY4mDidRJVgjqQuSpiS1uZbwkXULB1t3FAOAk++g4xFnvdA/XaCfrJQRcfq1
         scmQZC8HRJyIB7cHOGyj5PgYP7PoRVQZ9zqzDU904XocFvEYSeT9K4EVuhpkLG1H0nBX
         5NN3rgpG7yCpoxGo6X8iKpR3g8qFLqb0IrR6cYaew1V4l/rAerwy+x50pGGcIlHYoQNE
         rVog==
X-Forwarded-Encrypted: i=1; AJvYcCWT4QjfEWYSwJylepKDqRAMEK+rm/3inYwKDfbpyEwyE70vWZBYECRtx3iYncy0SURKMZdtbdsw@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4N5f8cgr2iM5IXrT9zr00bRoTqjee/6Ngsd9zFHCBzd8trV8r
	BjTW/vavY1LL5bl4QyXcOiRp1t5dg99cEy7C95uauuTu31GrAenQB2LcGq1Pi5CSxGytxRhi+kE
	CSdHY/B+JqriJ/VlqMuojwzI/+Y0GhoXLdG4Hjm0bQg==
X-Gm-Gg: ASbGncs3FwdToxL9tzpFGi17nXu0GY4hu5PpvcXvwCqfQciueb8QvbyVmcKOYYzsC6C
	7C3srFD4ahvtlKgmDz2UORAlaKF+g5sYy+8vLO54Y11eQ/qu/APeJ6z6hWEoWvfu8t6J83CEGIa
	/VKBfR+vh2HYbLJOvlXEso4iC/c33gm7aGST6JoXshn9k1wqlKCv1YuOC4F1C1p2K0YcNDsOsgg
	EXs
X-Google-Smtp-Source: AGHT+IH/jRTZELaiRlcOXYueghlWrSKvl+Er6wcSXSYeSJ4Ygh1TNzIY808loskXKKypj3EiWW7XbMMUZvUaCEZC52s=
X-Received: by 2002:a17:90a:c10f:b0:312:e91c:e340 with SMTP id
 98e67ed59e1d1-3159d8f92a0mr17862431a91.35.1750710428532; Mon, 23 Jun 2025
 13:27:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130626.716971725@linuxfoundation.org>
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 01:56:56 +0530
X-Gm-Features: Ac12FXzbqaWlyV-mY2jBAeAf_VzRigYao0-wWRbsMa_bGEBBFai-0Z6bbuS6vrY
Message-ID: <CA+G9fYt2e-ZGhU57oqWwC1_t2RPgxLCJFVC0Pa8-fYPkZcUvVQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/355] 5.10.239-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Julien Thierry <jthierry@redhat.com>, James Morse <james.morse@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 tinyconfig builds with gcc-12 and clang failed on
the Linux stable-rc 5.10.239-rc1.

Regressions found on arm
* arm64, build
  - clang-20-allnoconfig
  - clang-20-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-tinyconfig


Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: stable-rc 5.10.239-rc1 arm64 insn.h error use of
undeclared identifier 'FAULT_BRK_IMM'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build errors
arch/arm64/include/asm/insn.h:573:9: error: use of undeclared
identifier 'FAULT_BRK_IMM'
  573 |         return AARCH64_BREAK_FAULT;
      |                ^
arch/arm64/include/asm/insn.h:26:54: note: expanded from macro
'AARCH64_BREAK_FAULT'
   26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON |
(FAULT_BRK_IMM << 5))
      |                                                      ^
arch/arm64/include/asm/insn.h:583:9: error: use of undeclared
identifier 'FAULT_BRK_IMM'
  583 |         return AARCH64_BREAK_FAULT;
      |                ^
arch/arm64/include/asm/insn.h:26:54: note: expanded from macro
'AARCH64_BREAK_FAULT'
   26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON |
(FAULT_BRK_IMM << 5))
      |                                                      ^
2 errors generated.


## Source
* Kernel version: 5.10.239-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 7b5e3f5b0ebc00e3fd81739cee4390854bf954b5
* Git describe: v5.10.238-356-g7b5e3f5b0ebc
* Project details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.238-356-g7b5e3f5b0ebc/
* Architectures: arm64
* Toolchains: gcc-12, clang-20
* Kconfigs: tinyconfig, allnoconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/api/testruns/28836206/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.238-356-g7b5e3f5b0ebc/build/clang-20-tinyconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYOGFXQjUoxSVcOdLsYPowznR/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2yuYOGFXQjUoxSVcOdLsYPowznR/config

--
Linaro LKFT
https://lkft.linaro.org
