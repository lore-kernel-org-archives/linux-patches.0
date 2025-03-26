Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E6F23E326
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743010901; cv=none; b=DEaCzk4gN1l3ffflHflpAAewqDQbSBhQbjhK6GM1Wu1MDRr6MwlIk3wMvF/4kYzq+tHT16sD54Wa39tdi0l0u6BFew2S7FZpjq0k6G0OO5BXlOiLJr3j/O1GO9AADWREvoE/HYMx7w80ntE4fCrDE2lxSY9gGhF5bhL/aHERNls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743010901; c=relaxed/simple;
	bh=QWcAU5Bf/tJiv14blMoU5qRG461UGi6cUJ2OSEyNX6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=IiKdxph9sIgJCletTFkT0Y7Znvr4nOUAK+HsPSHjroEc9tZq3LInPp0DelxBQa1DPbyifnMPBsHmQ5XeVlv1Tt7g5ECvXazg3yaqAdwlokU3+k2dphExUFgxLAtyWvfs9FGA59kJzXgis9chqdkMK4rkgRXVP8P1QznC9ifnaPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ch98438N; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ch98438N"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 61CAD210235A; Wed, 26 Mar 2025 10:41:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 61CAD210235A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1743010894;
	bh=vq/m6UX+jgdE2OJ3ZOqLq5fcypQ7sNuUeNKGnfH2CQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch98438N9bjqD03FbT4mPimN7YbJzyoECXdcTSTsg+cR0UPJsnVk7TS/K6a79JEWx
	 SQiEMedMHR26vSIwlk+RHVUjDx1TnZ2y5W9BKlql2ljOa2YHD1mu1ZqwnL1Ck+FoS2
	 Ac5kkF0zdm0ymnWION7Yxq8R265arca+xVav/qLA=
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
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
Date: Wed, 26 Mar 2025 10:41:34 -0700
Message-Id: <1743010894-3733-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250326154346.820929475@linuxfoundation.org>
References: <20250326154346.820929475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.85-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318965  16715522  4640768  48675255  2e6b9b7  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34688860  13845666  970368   49504894  2f3627e  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
