Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA5C208973
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278210; cv=none; b=NIAn8Hx6BDBRjWKYXyZMuUS7ReKtrHOO2F+BmaOmnYv97FwC2sY1zyEUdR6dALVI3FeU8iGmVtld5ylLxVW0Y73EMy7EK3PXgSeAxLz2G/rhGarVzA/YTmL4OfPWlVOYt96n+lByZrZp1r2/Pj1HwK09vWTDsQK32Rxo2zJ7Zps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278210; c=relaxed/simple;
	bh=MWoIzkcT8yZTDnIxswEwCU6cyHWzD+fbiFpLsyNRJu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fxVD2odrFoe4WIpPyey7XQho++IfyUJWqZM0fSdWJGpFAagFQqBi9stF6337UqP8YxWY+c5Xod2iTKulyU9zC3bGkgrGYSd05yZ92ANzp1hPa1XY2m2Oxs3uXw4GHE3i/d6bPoULJUPTiTSuRHpUrnA6DbhASVV1eCarf8cMx/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=DXcqmDv4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DXcqmDv4"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 37D3C208A7B9; Thu,  6 Mar 2025 08:23:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 37D3C208A7B9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741278208;
	bh=TpGvi6MtCgAb0JpKkzg3JF2OTXepR/JxKqqR317pwYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXcqmDv43aHiMRrXud1av6cpWQbzydXgUPV2XqJQSsSMtMaK8DRA1f0M2zT8ZuR89
	 2DYFMZbg6MJInIkiEdMMpPplHO21PoU40mOUxungUWbPL4ImmGcquaaGANlOdW+6yh
	 +apqLoVBKKpRJX2//B1/35NwsICpNmyX0ufoBfJY=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
Date: Thu,  6 Mar 2025 08:23:28 -0800
Message-Id: <1741278208-30319-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.18-rc1 on x86 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27755354  17713522  6397952  51866828  3176ccc  vmlinux

arm64 build on Azure VM fails with the following error:
CC      arch/arm64/kernel/vdso.o
arch/arm64/mm/hugetlbpage.c: In function 'huge_ptep_get_and_clear':
arch/arm64/mm/hugetlbpage.c:386:35: error: 'sz' undeclared (first use in this function); did you mean 's8'?
  386 |         ncontig = num_contig_ptes(sz, &pgsize);
      |                                   ^~
      |                                   s8
arch/arm64/mm/hugetlbpage.c:386:35: note: each undeclared identifier is reported only once for each function it appears in

Same issue with v6.13.6-rc1

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
