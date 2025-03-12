Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A9B2356D8
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741800530; cv=none; b=aUADZ/c5i006uXgDa4FU1Qq0tCj17SaPmY6XJyMsN8ejlYFG1eagwXghRXoy/Nat4R/4lYafwZtjsKXfFq6XTkwtUUs9rlA0qmpW5gWX3BL2OQFlapKfw+eIN9EbQPh4q2lHxOhAebETykToip6ZU2zCtm2jyrWhIH3FQDAEAM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741800530; c=relaxed/simple;
	bh=V52VOIG+AN8GNl0MT+KjeTlqmFc1TeXWtkQxXGBTtdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Ghywq4IdfBY0EYQ4HmfH21qmTNlejKfIDLELp6jdjr4CHUi1pQoseqjIRx7wZFHgJECE+giKS0Jdvwo2EcKATG4OnTPynLZ32xOC3sqqHF660VEG/btY6fnBbhGU9+0DeoGJ9Q4vmBKZ1MfZR2SF2pZdajRPsTqFMSt2EUbhtJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=UG2Yvg3x; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="UG2Yvg3x"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7FED5210B151; Wed, 12 Mar 2025 10:28:47 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7FED5210B151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741800527;
	bh=uouLbv7KI5UpdtrF4kAaKELsEwGPcWJyJ3L5pY9vXBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG2Yvg3xl4eOJxBz53EICZ1jssHBLgDOJ9IYMl2MP54YxOXFYoqU22/qRtbsk708s
	 fSc6vinjv2hl0OlSFTVIX506w+aJbDt/KKTNY7MijSxrUh4JrbuKSCEhG7VNmdlbJ+
	 SF007T5Vl7Mx0w1tUGhVpqBLHXiyMr+k+dsnPlbY=
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
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Date: Wed, 12 Mar 2025 10:28:47 -0700
Message-Id: <1741800527-19107-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
References: <20250311144241.070217339@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.7-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29937477  17837074  6320128  54094679  3396b57  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36684481  15081117  1054416  52820014  325f82e  vmlinux



Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
