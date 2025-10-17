Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DAC5288C81
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760737415; cv=none; b=CEkIuTqvF+bOOZo7JQegPbqCjrZ1yvdENFBF+E9FopObgLHRePDtdpyRt+78ARN84RQ0gp91lttsBA9zWPNm4pFNh06GGDlthv1ikNDryeSApzANKpEpFhNJCf21wdxPNaHYkpCzGwhCQSbAtAN+nEbc6jBXq8C1TKIDwGKOdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760737415; c=relaxed/simple;
	bh=+w8wH3D3TX84Jk7CSj8oCefUB/NKGQD/b0LifId6SM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fMdvkV1aBPwn0VpDS6sEpFTzrzV5Hh7ncjMyqQSHxqUrCX/YUIPuQtArnSgnX0fqLyxoSTwQ/bo4UJXhtFLjzHMXP6H8Pc6c9Gswfm1fagFBmK2/tPcBPBFxlE4t8MKxW7a37BMOKsm3op8a8tzw+HsUq0ih/Bv6txBUwjqOjX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jR7nSGfb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jR7nSGfb"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 2A40F201726E; Fri, 17 Oct 2025 14:43:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2A40F201726E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1760737414;
	bh=+w8wH3D3TX84Jk7CSj8oCefUB/NKGQD/b0LifId6SM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jR7nSGfb+n1XdM7spwsU/1Q98ysrvPAc6I2/FFROeRbXFBKp7dNtRMyEjIBxAhSe9
	 9vihlda3I3ROhsEAV21paTN479RpGfcmJMfnm5Q2cn2s5nCh0F2IDsi/QHxAQdX6y8
	 et2Mtn/11zVP1mtyay/GoZkhNWnrrS/gvTlxXy24=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
Date: Fri, 17 Oct 2025 14:43:34 -0700
Message-Id: <1760737414-28141-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.157-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
