Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5828F5C
	for <patches@lists.linux.dev>; Mon, 17 Feb 2025 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739777935; cv=none; b=siWv2lt5zdr/qmQRxxGZcMoVmDQH7Jiuk54F1/IPGj6547oHi5JyjqIAs6LmpmpbGrDKUPvDzIbH1WXjsLhPH4MP6I/EU9CA+fIAMelQ0IusaCtqu7+wTrjxrK4AdhGHXHFJUcCr4yBhHwD+ji9IBOAZ8yG7ZSlOIgukvgFsJQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739777935; c=relaxed/simple;
	bh=o3q5Mohf7PVZHZun6xxeIiXGynUtqsaAjaH9JUJndfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kpQ60e/ziD0j8I3HFUF2HI/fM/BX2l/A8dYuv78BwMEDClNcN8xOWWtcNeFpomPZaAq3WwxH/1y3ead7dC4oZaE51UnwtzoaWLUcSBxBRI/Lri1fhxdSHWTzIRWBxFXn2fn1qwXDxristBxVOSBbEvwLZZpL/KVPaaK3be/U+Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GXtM+Z36; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GXtM+Z36"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4be55c93be1so100936137.0
        for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739777932; x=1740382732; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jwI8anyOyQtHe3taV6VbhpulS2/ZTxMEIIPtJmg1WRE=;
        b=GXtM+Z365ElvCXrgiRxhZ9ZPUsciUZF+Aa03whsdLdJHIkc7UhBIX87XJ/yQAKtwrd
         67rKfcciznpEr9AIiXv2cRWBW5aRY3DZZslalBQs7NltuE+U5jqsge+M8sssXbPSeZto
         VA7dvbBc8x3CxDroUg73r2F5Dd4ahsd37ubSnC1E/xem2RRf+URjGCUIUzwOBiH+kIz1
         PEst9GUYeTkWHEohNVlfe5+MoY5T+sWHLyX75O2bO3wDxbXGrCsDII+uVR2sKwXmfA9w
         aqZt8ZLqd4GTFDaytICnvJPOwnFvDaE23z9yEveY48+nuYV1wQnNUZ9FeNijGIEf0zHE
         JKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739777932; x=1740382732;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwI8anyOyQtHe3taV6VbhpulS2/ZTxMEIIPtJmg1WRE=;
        b=NDVKpngrpSbvfVMWbuowrFROXGZBAO7JikFsoUe68DuAa0IzO2bYUtzfsy5WRkwkQG
         UtYCs2nq2C1L1UFnibyl2HQsLAC3uq9XR+IWtYkQv0OGnllJ2ycMMnSMRM7fKwGq5NLg
         erEVJF9LhyNfgqisRfzhdGz6GXTHR7FVh1VHfl6OWfs7luJcQt2MGZYb0ELSAa7S/Ltu
         Xc1JNgGB6aWM97OS1wATG4I7mr3SKKRcCGlRfqSb+tuSKCAr/Gh3udMlslIHqRXHUSHi
         i8+n75zGoelyOGQcTkA5gV/7vvza60zP1lnK33cdYQWFp+/0cQKBZH7uABYRAVTbvhd3
         6B/g==
X-Forwarded-Encrypted: i=1; AJvYcCWLqsuFgNUl/VbvR4Wd7IpjdJ/N7XuYkLzir0cVfWM73OhkNlAesl8+RYqgsr69PceIxwt4f9q3@lists.linux.dev
X-Gm-Message-State: AOJu0YxOscT7kH0LOSaTW/eFTeNANMkGDOBtrskvzSZp5nUCMZ0rWJDH
	VSslOcCPb1T8L+5mLBtiZ+2TgcSxCoPSwgULdntuAsPV8mndmmJcPFWJAnJvDBpvDzm6Iehs3Ps
	XMQx9NRFggBqN3oo5my52TUzDPwZrPMMdXIrMJjOQ9/oAAkdEf7o=
X-Gm-Gg: ASbGnctnIq+ezEBEF7zarG/2H1m52C8NcDNlsIt5UqGY9zuOJA58WRAMRSq42hJC2uP
	oFetltnq26tVaixSSHDi/DHMXbUT9rjngxo1h+vvJunRRHhXfebNo617yj8ZggDY2G7tn0WuqaF
	s=
X-Google-Smtp-Source: AGHT+IHIomYH6wLpOpghSdaUEjkhzRp96SGuOIHHvKJUtJWgnW6RIgsw2Dtyn2AYg0W3RUIxf7Otmyq5pkxRDQ0M5Ic=
X-Received: by 2002:a05:6102:150f:b0:4bb:dba6:99b7 with SMTP id
 ada2fe7eead31-4bd3fd83d64mr4375684137.13.1739777932222; Sun, 16 Feb 2025
 23:38:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075701.840225877@linuxfoundation.org>
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 17 Feb 2025 13:08:40 +0530
X-Gm-Features: AWEUYZkqyonr9_UF2TlkWkSaWReRRBluM-paFS4RwfOE78zPBN5yQ0U5Y3-pXdo
Message-ID: <CA+G9fYsBu8DOLEDQoGrdZmjwZKvz72tMmrVPnQSJLNMbefYymw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 15 Feb 2025 at 13:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 17 Feb 2025 07:52:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regression on qemu-arm64, qemu-armv7 and qemu-x86-64 on 6.12.14-rc3
We will investigate this and get back to you.

Test regression: arm64, arm, x86 selftests: memfd: run_fuse_test.sh

* fvp-aemva, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-armv7, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-arm64, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-x86_64, kselftest-memfd
  - memfd_run_fuse_test_sh

# Test log
selftests: memfd: run_fuse_test.sh
./fuse_mnt: error while loading shared libraries: libfuse.so.2: cannot
open shared object file: No such file or directory
not ok 2 selftests: memfd: run_fuse_test.sh  exit=127

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Source
* Kernel version: 6.12.14-rc3
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: aa95ced31609f49f9342be3c04e538ccf5b2ba18
* Git tescribe: v6.12.13-419-gaa95ced31609
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-419-gaa95ced31609

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-419-gaa95ced31609/testrun/27310664/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-419-gaa95ced31609/testrun/27310664/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/history/
* Test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-419-gaa95ced31609/testrun/27310664/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2t4Mt9eXLqMfhglIHy5AoPdnTUz/config
* Architecures: arm64, arm, x86_64
* Toolchain version: gcc-13

--
Linaro LKFT
https://lkft.linaro.org
