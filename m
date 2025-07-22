Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3B280339
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 18:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753208839; cv=none; b=mRBtU0ncL94rttZ/yxaa3P2AA9kmF+weNPeawFO2J0IaKYFR0lQMuHBxqM5vxA3SPjUSEWmBLjNGdqJsQb8emzJOlpPcJbOJhDsYZJHM/KZR8eQnkMJj0ZXyTjbbK6DQFpKH7HFa4umlLhlubAY3mEWJBR3FoeSmGg/uWSCXQrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753208839; c=relaxed/simple;
	bh=TzuX4mInNFL0Y71HlZ/CxdY52DbWevcbHeKa5VEl6b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3qXjypiL7gWf0At+OatwUbji0RmLoGR9+7Ih8DQ7/KmcaEhpAWP20d9RQMQLs8lKXQ6iDfMD9LPFbwZbJfvO+ZG15WtTz7WM4UdSusaipRbL6MfL9FVgC4tdgwChxCL5JFSPgLJrs8OABjSA+KrCmUdfCAeAQGdDNQBatbK+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXGaLC4Y; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXGaLC4Y"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a6d77b43c9so4487493f8f.3
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753208836; x=1753813636; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Z8+WxTUCxaG+bKBH/CjfFqMsRzOrc36DXiZRhX8IKQ=;
        b=NXGaLC4YQDhDqpZnCZgw6woSAs4CUYTnDFFgSWsG1VBJ36tW5huNmlkaazDdnm0wLy
         T1N+bDp9nNx4U9bVVK3E3yxj12MWGZ2TTaE3PgVNWwf2UnqsfY5SvHoKvTTstSiMh5xH
         C1y5M15A+GvMrymP6kTmFl50yNQATOryFXTa1rcNlp6q4mO3YOE7IccytJ1qsxU18c5h
         DMuZ91eEStQnbRSOwg69hn+NCCHDLtAMsn6vz0Y+T07g7dZjdW+KPQHTurx1s7b5W18e
         QheXQ+srPruZ+VDbFhD4SQ+MfjLXjdTsPS1PpWU1GscyyuS/nhsAkGY/lkZQA67KpfSC
         i59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208836; x=1753813636;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Z8+WxTUCxaG+bKBH/CjfFqMsRzOrc36DXiZRhX8IKQ=;
        b=scJVR0hCMf/EzBdnPosXO/Ib2DcYUqtc53EECCTQ/SR1Kvh3AG6PmI0nUZqWUbE5Qz
         MDAFEETBcOQKowouPjR56hH4R9YpgIyYQy+zLo3wLOAlr7TqvIPWCrZTtispif7ZY6kF
         iJ2lZLUh7ABg02B2iK8uSCeaNgMdMMZ717DwFsV5SL6JKc+i2M0tZPIYdiEZcKygGfuS
         q5A/URLubhLh1tRerIOPh/WyQ4EVDnb9u8Fh/3bPW9o1+3e67LwAUVzbXmYNw1Yhu4m8
         JtJ7KMjuoAKugGnp8UcDNkWNzXHN+KPNyc1zg14pqKL4AzE8aBI/o5H5tiChFdRKE7xa
         BN3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1dg0wVafNUVr80eNOJqm80tlpiDx7xGgIzEbcNUSUzEdfA5TbE/agNPZMM9h2k2ewJE8AaRIN@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz2JHUGItk1hci+ufs4V/4FMw7wvZTOj2T/znod3UIEutZ1XGt
	lZQHFrorm5ho3Milxliwjh+Z4NrPNw/l6NmvgctsKhxTs850YKuKb4to+tfBcf6LaA==
X-Gm-Gg: ASbGncuVNAgphWZDHsQnZiTNCrAhQGpbuL/90+8iz2WkDRRyuuUyu5JfIEdJEI/bzxz
	0p4nkrp7EOz/MlJa8O84Pw3FAJvMIqzd0Tn0IZOS5ebHz6H87a0vWy1PaDyDbxF73mVRP3oOGMP
	YHQskTaD/C2U1FETpRagyMzrPSS5fjLyduSf39LVjoJU1XBfTk6CtNy369Cez/pNGjjOjs0x7dN
	j3BZVgD94CZIyAH1UZI5Ydr0uBwkxVTiRg6kqSVHSAJb1yJzcfUQNQ1gFlRdafI687P9Eil9Zb1
	c4WbM88eGA1e06qietBX/6da5KbbQwLdPOOoYV8eaRSJLGXqhAm05/Jhc0xtYcsZ/MWd8OJDQCt
	/8nJ9sw40jo90iSCNeot/BfjINl91P0WbK5RYKd5b8SRZPOUnIAsQapY5tw==
X-Google-Smtp-Source: AGHT+IHWIMlQSVzvAq85Yom5KJ9BYmsTxVnjI5RbzJDAcwDVZQTDVOTdmdUULBd3ut0q8DI1kuLuUA==
X-Received: by 2002:a05:6000:1885:b0:3a4:f644:95f0 with SMTP id ffacd0b85a97d-3b768f165f7mr219753f8f.54.1753208835850;
        Tue, 22 Jul 2025 11:27:15 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:53e1:3729:be19:c80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d807sm14296542f8f.73.2025.07.22.11.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 11:27:15 -0700 (PDT)
Date: Tue, 22 Jul 2025 20:27:08 +0200
From: Marco Elver <elver@google.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	clang-built-linux <llvm@lists.linux.dev>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Message-ID: <aH_X_AVUDoP7oB0E@elver.google.com>
References: <20250722134340.596340262@linuxfoundation.org>
 <CA+G9fYu8JY=k-r0hnBRSkQQrFJ1Bz+ShdXNwC1TNeMt0eXaxeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu8JY=k-r0hnBRSkQQrFJ1Bz+ShdXNwC1TNeMt0eXaxeA@mail.gmail.com>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Tue, Jul 22, 2025 at 11:30PM +0530, Naresh Kamboju wrote:
> On Tue, 22 Jul 2025 at 19:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.40 release.
> > There are 158 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> With addition to the previous report on the stable-rc 6.15.8-rc1 review
> While building allyesconfig build for arm64 and x86 with the toolchain
> clang-nightly version 22.0.0 the following build warnings / errors
> noticed on the stable-rc 6.12.40-rc1 review.
> 
> Regression Analysis:
> - New regression? Yes
> - Reproducibility? Yes
> 
> Build regression: arm64 x86 kcsan_test.c error variable 'dummy' is
> uninitialized when passed as a const pointer argument here
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> 
> kernel/kcsan/kcsan_test.c:591:41: error: variable 'dummy' is
> uninitialized when passed as a const pointer argument here
> [-Werror,-Wuninitialized-const-pointer]
>   591 |         KCSAN_EXPECT_READ_BARRIER(atomic_read(&dummy), false);
>       |                                                ^~~~~
> 1 error generated.

Thanks for catching this. Newer versions of Clang seem to be getting
smarter. We can silence the warning with the below patch:

From 56c920457a4e7077b83aafb0c9c8105fb98b0158 Mon Sep 17 00:00:00 2001
From: Marco Elver <elver@google.com>
Date: Tue, 22 Jul 2025 20:19:17 +0200
Subject: [PATCH] kcsan/test: Initialize dummy variable

Newer compiler versions rightfully point out:

 kernel/kcsan/kcsan_test.c:591:41: error: variable 'dummy' is
 uninitialized when passed as a const pointer argument here
 [-Werror,-Wuninitialized-const-pointer]
   591 |         KCSAN_EXPECT_READ_BARRIER(atomic_read(&dummy), false);
       |                                                ^~~~~
 1 error generated.

Although this particular test does not care about the value stored in
the dummy atomic variable, let's silence the warning.

Link: https://lkml.kernel.org/r/CA+G9fYu8JY=k-r0hnBRSkQQrFJ1Bz+ShdXNwC1TNeMt0eXaxeA@mail.gmail.com
Fixes: 8bc32b348178 ("kcsan: test: Add test cases for memory barrier instrumentation")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Marco Elver <elver@google.com>
---
 kernel/kcsan/kcsan_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index c2871180edcc..49ab81faaed9 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -533,7 +533,7 @@ static void test_barrier_nothreads(struct kunit *test)
 	struct kcsan_scoped_access *reorder_access = NULL;
 #endif
 	arch_spinlock_t arch_spinlock = __ARCH_SPIN_LOCK_UNLOCKED;
-	atomic_t dummy;
+	atomic_t dummy = ATOMIC_INIT(0);
 
 	KCSAN_TEST_REQUIRES(test, reorder_access != NULL);
 	KCSAN_TEST_REQUIRES(test, IS_ENABLED(CONFIG_SMP));
-- 
2.50.0.727.gbf7dc18ff4-goog
