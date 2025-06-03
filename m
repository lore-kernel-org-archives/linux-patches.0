Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B1713AD05
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982149; cv=none; b=lPJWQdml0BUmPbOkOxQ10tGy5MR57AJPx2kQrRra/Vvwk0Vfa0Q4/UMwkWneXmpDGmKCSi2H2T0HT5TB1xj68AbP6/jH6eZK/J9oZ9EF/cxp2fs7/PuQ2VHFGU2dImWAW2oKg4DHWgkfw7R1qaGz6h3b/sp1DH5Nwisqb8RXGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982149; c=relaxed/simple;
	bh=vtcsE5rJwJv14ImZ8CR1t6ehCxH9+7W7tLtV/aP5bl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Tm48tcLWwAf+l8dKTfne7is4qKV0sZuTbvelDw7svGsuYloXm+8YF0U4tYdykERbtK0+OluRLoj5+Np4iAWKwyyS7ryBGqeXIFulVBXXhGXb4wr5X76BZ5W/66gPSTIWLT/2dkbQ/uxTd5sSktCzpO9A6bHfQ/qipijS4PQnpXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=X4CHQA7k; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="X4CHQA7k"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 506A9203EE0A; Tue,  3 Jun 2025 13:22:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 506A9203EE0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748982147;
	bh=UifUjLfzvwUDZxOiix1KsvQ8S7ETonKUekbSG5x6ksA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4CHQA7kuzynMYW2VkMEln4BfuWAXO1bY5FYVwRzbMyfuqGVY/qPYF3rUs4KcOoOk
	 3PpxWwYfprxVieWF0UooXWkb2ZOsTAVI8+4F2Qzvjr9TXB8LFLRqNBDYGnWanTrFEL
	 ORSO+LKbALWXGaFkFtSRVA2tj74SnG7PKi5z+N4Q=
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
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
Date: Tue,  3 Jun 2025 13:22:27 -0700
Message-Id: <1748982147-4835-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v5.15.185-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
23550276  11257962  16400384 51208622  30d61ae  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
30787125  12642704  858044   44287873  2a3c781  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
