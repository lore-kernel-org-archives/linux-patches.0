Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FA217DE36
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737576949; cv=none; b=q8DBvZcz6V2Cfce7vTX5GMF9QaUx4dtbzrci1NKNipAYsROdpI4l9u0a7l8ZkO6uVY5DxPN5t8gkvCBrAUyX37HqlXbksEM9gGHDzMcBV3t3sAlG2L307MTzqA6hbK+7bRoN/4ZuaXVMxPCOs2npSsnWS4v6ZZXZUxy0+DUhvNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737576949; c=relaxed/simple;
	bh=mcsPkR8CFtxZL5nxanBMkHsFAT82k2MUpNolsKKPXhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=AVKB7v+wMqL/enXDhGN08t3VEhAFpTo+bBNvdfCY2HU0PqQcUAYRJPsZWeZlYfkk09i3dQtCGX6ipa8d4Ln+TNa/qXMCvdqvno4Y4hM8lTAoM2wxam3PEd6Omx+hQCK/ekdAfk92daGDYh2WW30GVisAbLXl8zMcWYJPQx5ikhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=h7/Tku/o; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="h7/Tku/o"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id DDAD820460B2; Wed, 22 Jan 2025 12:15:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DDAD820460B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737576947;
	bh=mcsPkR8CFtxZL5nxanBMkHsFAT82k2MUpNolsKKPXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7/Tku/owR2tRVafYIL1k1jIvJlhrNDhUp7YWxr5zExwkEq9wpmd+KobO4z96LBGY
	 /tXRT7BsVbT9H0X+mQS1QTAOWgMM20j43MDYJIq0BdGUoILYedLsdsvOxF4OZPs4KF
	 Lt8aB8jKuFmX86tdKOh9gNsjQHBHwlDzRojtRMWk=
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
Subject: Re: [PATCH 5.15] 5.15.177-rc1 review
Date: Wed, 22 Jan 2025 12:15:47 -0800
Message-Id: <1737576947-17766-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and kselftest tool builds fine for v5.15.177-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
