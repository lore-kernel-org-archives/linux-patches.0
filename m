Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0213B18E
	for <patches@lists.linux.dev>; Fri, 24 May 2024 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558430; cv=none; b=npoAkukEMinmNLfnI6r/kYeboPw+vjih9DO8QYas6P3edSdQc0XoFk3YwZcF7dHEId4RvWn58bv+iTr4TkO3hMoam/BfF/MbpAs8cRqHUr0mf9wL3cagK5M43yCOonueN9SDbWAz0uLUWgmN6CnQOg4sXjT5W5T+5zIpYTPSkZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558430; c=relaxed/simple;
	bh=J4jKhU2rB31y3MjXeQjXlJ26Ug7+zDBlfBWD4JhyTwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XR03nEjKbupqqEM3SXoUFqEvXpIk4D6LGK2URuZn2HqLBLmc2RM8et3weMC0n4eG2y81P4pYtwd3yVKk/PdCOvu41T0gpVpwFfJzUaloCAT+NtYoltvAIdI+VUnpmuqYt1QonCHWnAXeWCLzNxfXN119DHaBHUotdWk9THCMMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v05bKPAT; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v05bKPAT"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-43e2bca05e8so42721381cf.2
        for <patches@lists.linux.dev>; Fri, 24 May 2024 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716558428; x=1717163228; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1AdWBPJk5cBe/4Kv5WSEGIK67LQv5wPA9TlUppk5PQ=;
        b=v05bKPATIKGVsMUkg8Ppz3Ug2AadtonA1yBNNiP0D59YerHNkvNqL8mkXFcjkUTAoK
         zLvr6UTUH81IWuzpDsLmSzvYC/yY/FYjwOT8V/7q/t5TFxoZYGOwPft2TQ0N559Tv0AT
         sSjXHewtQHI+gMFMp8HcRHSbY4RVdoq+OIu/btojGwG7WBJdE5MtEQu2ULPO6qKnNzT9
         1MxEXhGC/p3Kdmd+4o5HGzJIUz1CGxvgJhwfpjg62fx58MVpcIR5XcJNpthb1PBtztyt
         4IuC8kddQ3kgjWTKyGfNIo5GbFpcj+ENuZOl6lDNxlmS20M6yaBPEavPdGVWpN8JB0cy
         Sv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716558428; x=1717163228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1AdWBPJk5cBe/4Kv5WSEGIK67LQv5wPA9TlUppk5PQ=;
        b=RlmErAZHU3EBQzFvVDzmViA6lYSV1SwJ1BIYfTI5fZlqojE6DmRAGwhK1ehOGSz9pC
         v5AEJh/HPa8AOxdKWOjhWxj0fa41QXg5fU+mCH+jI9QC1RNFEkbQSSZDwRAIJmgnY/wx
         sfJGFM6gmL/no0uT0ZsIVwvkm2J0AaoYzXbnFTQPfZAq0ReVbxIsfZyQ0wWd/ZYFNhyy
         X4hLM/GUYy7PV3yNo1LpOSVOTcubzfRpCUQiShsnj27ruML5UZwsKZb1NbP57vvi8FSk
         buqVmLfERqxaRmunYgRNaCSTIBzRuzPzusThL8TQtRr+TWX6Q95Tjz3a5UQrtIDSKKPo
         uy3g==
X-Forwarded-Encrypted: i=1; AJvYcCVKEsc/+P0hKtmN7vW38MYwVMvRnkkAZGuxlY68txYLqAq7bNaN6V9IbbVA0qnKnATGDLOftO3anuXswmXhvkPgfL/U2evKKw==
X-Gm-Message-State: AOJu0YwcBaZI8+F/diLWBYvlGSKPWnkDXw0zXbFH0T4km8aiE94CPT+x
	6DSH2CpDIz02XL7o4kuRb6/Q/Z/WeSSYc8Nd7ABI5He3KguZrndmrjuzXC4zyP9kODbzt0Ao+QE
	IG40XvHn50wFISW7y4enoZDi4XxxKMv4NpgBWaA==
X-Google-Smtp-Source: AGHT+IHogsSuuy+E3e3pnsuSrATsQOrGLSz4vi3QS2BdvkWUI2SzN070UwMpnAke8bJaN/PfoYBOKxmGy4L0+AdkHEg=
X-Received: by 2002:a05:6214:b33:b0:6ad:5f4b:d79b with SMTP id
 6a1803df08f44-6ad5f4bd983mr8922616d6.16.1716558427864; Fri, 24 May 2024
 06:47:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130325.727602650@linuxfoundation.org>
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 24 May 2024 15:46:56 +0200
Message-ID: <CADYN=9+vnu=a9ZbEXBvtW8OXs6L4xTqokLLDhMDrnjmE+dmqaw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/18] 4.19.315-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 May 2024 at 15:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.315 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.315-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 103 total, 97 passed, 6 failed
* arm64: 28 total, 23 passed, 5 failed
* i386: 16 total, 13 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 19 passed, 5 failed

## Test suites summary
* boot
* kselftest-mm
* kselftest-net-forwarding
* kselftest-timens
* kselftest-user
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
