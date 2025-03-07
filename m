Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A24A2561BB
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375090; cv=none; b=MSU0u7zjv2KSlbxPaYUzFrXbIQbj9Xx4KTOtpFkA/3Zp7dVtMx5fwRqMGyacrQmEpNcKgLWG1V/lW2A20ADkgRGmRo83zPdC2KYRoRLia6h0rNSPsXIY4pFOxzCZv4PvMwGb+0Ws0WN1UPq5OxvGBLMEUoNpMeDs2GDCbJSU0yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375090; c=relaxed/simple;
	bh=0ai1czz6XnAW/ajDj36Fds97YxdsHeZ2OwDwpoqZq5I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=gJmfZi/qnCG4aD+PaoEegmmCjaJ1xDRux1IrlYsrSRpr22YfduPpf7DWC7fisd6Fr3NS6QKPUDIP4uGGR3r2OEZdSffFjNGa3WrL7NIwXk1pLsa1AhP9W5UChVekFQBT4oeZkHHN+RK9y8lmNkQVg66QMhuO55E+u/i1gWgbwGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qBnf8XUN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qBnf8XUN"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 964642038F3A; Fri,  7 Mar 2025 11:18:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 964642038F3A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741375088;
	bh=FgIIzZk1Mf/3xdjRZ/WKhRJnKg8SyWXON7NdAy2vErc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBnf8XUN4MKVnFLFkNEeOY44VJaZR1mImcxHmk5L7BXRskAzVSU80OLsNy+K4yHgu
	 HByrcji+CiffHF+MbsU1a5+5+hAlBmXgu7+KCP2kpisDcUDb4ma6GKYGKU4QcxI+eh
	 a3XSwbqSKsmr3BJm6A2xsydm2dMLh+YIOQqj80gA=
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
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
Date: Fri,  7 Mar 2025 11:18:08 -0800
Message-Id: <1741375088-19909-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
References: <20250306151416.469067667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.6-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29936840  17836986  6320128  54093954  3396882  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36667302  15081017  1054416  52802735  325b4af  vmlinux



Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
