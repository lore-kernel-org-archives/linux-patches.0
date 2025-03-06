Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645C820DD64
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741263107; cv=none; b=uzz+YwYPP4LDcabKHKTdbuPtjDMcbUy4qgiakJjZVdrWWCrrAF/OcQaQfuqmy9YH6Xi2KKO/YNbZ2SCBebRixDKnJTGEf0qGORDAAQ9om/r5GKBLQQ6ft7ksv3nHtJKjjwMZCqIgFgxwQCK25A9QMMl+m4HssVh2NEW+B+8NnSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741263107; c=relaxed/simple;
	bh=yGHR6q86C/FTZvePUkQVx5rTTpa8kIUo5G1WKw4/rvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GKbIndePu1Kablzd/jMnZvajrJB3FzH9u+sHTeHevDlOlQaoDRsKTgFnPmS2KXDqULaJH4AxL/8AyqyjQV97/VoUovl465sSnG0mWTm7bkOsKx3DGhILr9eX8J1vV0IwsBmk/iCKMDorWRjybBfQ0pLDq/qHEMazY/YHFFyqukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JyxL1GmH; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JyxL1GmH"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-86714f41f5bso230513241.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 04:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741263103; x=1741867903; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lvsMJEXeDFDyZSd5Qb4nvCqLm7iXrW5gMYpeBFg/FxU=;
        b=JyxL1GmHoUMIIi/gZQOHKgNmfv21W9k50ceKDOSu3TCs7jjOafgb/AJpR99lwal1zf
         Cq1R7rXAetoFvaCQ66t3/IB0Eav9DeWbtONJhyc0ypIHU/DjHAO4fZc4bIHmtvbUStOC
         lZ22Pg9gm3e09rvHDr0BVpjiSGA6IY0yqgpaap0xNEntZoaUCOSUVh0Jnpsotl3hVDBG
         QwWkG4mZ+xi5dhCk76r71fOp0dUOiQqRySiucZAx2wSY4cxNQFTDefT9b4cIsPp8V5GT
         MetHEvbYNdq6k6JmwddQPcjB9iYziR3CdJWxxqs+wsJeQmWG/gp6bdE+lNl4uARc3AiJ
         dM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741263103; x=1741867903;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lvsMJEXeDFDyZSd5Qb4nvCqLm7iXrW5gMYpeBFg/FxU=;
        b=uT+JXC+Bn1658hfDHyOmraP3kPUSAfLpLMeKuVs0db7HUj0nasP6LHP5kKshOyRMr+
         ZiXkxEf5YVa3Oa5I/zVzn15+JPwr3XByGkp5lu3TgDDbyFr6h0PrTP9DS7sHz84qcRRL
         2DFrkM5ApmS3iaQnC6lEKPPq1PJlJM8W7q6JveMw7BI+DqTQbSLrXOi0APFKv+jgUT4l
         6730z5WqaDC+NPin7EELSL238svgWx4/Bx6mUGBpM+r56pBhGK7anLHH6z0aBNdukMX8
         LREx3Eof5mNV0Z96hla58gByeofGgTnBMAEKUATLT0TtNymloUgGYZR0UEskd+3VuD0k
         AbTg==
X-Forwarded-Encrypted: i=1; AJvYcCVBXEHQxHe61JY9ycWewUqvDETcshF3vTpMITnnniuEioeA3Cce5GZMGfOt4zCZ2nelIfNsKuQv@lists.linux.dev
X-Gm-Message-State: AOJu0YyWXpS91RDIW0AnZxAkG87K5Beb9dplpVGJDdJwJJ9Rb1bmVHcX
	wgaPXBV+D6p3iWu2U5gwsHr6BYqi0r+H30od3W6LzPlFpkhe5lc8SCcwKhUq7Mn3j7oX5zxhc4Q
	q6D5yxnZSC1pV2N/aRW0vXa/6nyJnI7eLi+VsJA==
X-Gm-Gg: ASbGncvoBs7jkSDKdSjEqUM60XJTNErEAPgQavgdLyyiglZxf/wWTKLmQ2hVQHg7+rw
	EzRLbgN1EMt8DnLfbiVQ9jfHWInokZRVci68ThC3bAAmsvf+CS1gF3ujs0c58p+8AoVQ/p1l60/
	AqlzErMb3eBkNa9QBq4BzgtE1Gk/toztAEmLM/CRwkLRXwc5qDqJaISg3b1Q==
X-Google-Smtp-Source: AGHT+IGBc5KcGLbAWgtcUp7ExaRSwgWeSAT7DBmv4XyzERcU07mDm5sOalOSAmOHcBLsW0Cxvf4/7QkDfLGyAYfM534=
X-Received: by 2002:a05:6102:5492:b0:4c1:8c9e:6507 with SMTP id
 ada2fe7eead31-4c2e281555amr3843283137.15.1741263103221; Thu, 06 Mar 2025
 04:11:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250305174503.801402104@linuxfoundation.org>
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Mar 2025 17:41:30 +0530
X-Gm-Features: AQ5f1JrDVgX0s3QgjNqc3pa_CeDdlSmtN5DgURin6xAPja7sGpmtxqmNb8IrzTw
Message-ID: <CA+G9fYvwoYVG8wgz6Lu68EO1z3m4mbBWroGEXL2w5D7P_4SG-g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Ryan Roberts <ryan.roberts@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Mar 2025 at 23:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 the defconfig builds failed with clang-20 and gcc-13
the stable-rc 6.12.18-rc1 and 6.13.6-rc1.

First seen on the 6.12.18-rc1
 Good: v6.12.14
 Bad: 6.12.18-rc1

* arm64, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig

Regression Analysis:
 - New regression? yes
 - Reproducibility? Yes

This commmit is causing build regressions,
  arm64: hugetlb: Fix huge_ptep_get_and_clear() for non-present ptes
  commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.

Build regression: arm64 hugetlbpage.c undeclared identifier 'sz'
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
arch/arm64/mm/hugetlbpage.c:386:28: error: use of undeclared identifier 'sz'
  386 |         ncontig = num_contig_ptes(sz, &pgsize);
      |                                   ^
1 error generated.


## Source
* Kernel version: 6.12.18-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: 43639cc57b2273fce42874dd7f6e0b872f4984c5
* Git describe: v6.12.15-531-g43639cc57b22
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.15-531-g43639cc57b22

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.15-531-g43639cc57b22/testrun/27516239/suite/build/test/clang-20-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.15-531-g43639cc57b22/testrun/27514393/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.15-531-g43639cc57b22/testrun/27516239/suite/build/test/clang-20-defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2tuR9WQOit4WjRC1XVxLJKTcQia/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2tuR9WQOit4WjRC1XVxLJKTcQia/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain clang-20
--kconfig defconfig LLVM=1 LLVM_IAS=1


--
Linaro LKFT
https://lkft.linaro.org
