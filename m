Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A45C17BA5
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 08:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738397731; cv=none; b=V7IFWVo84Up1R1WUsfYGgvuHG/Liz1arFF419aTyHlSPfsQhnI4uR6Q4nvbfyYWJ5h7H+cFm18BE5GG5DDLiAjpr69YzQUTRTFdb52OQ5m1oIwSeIhfDMv5UrVlXfFk5Bu1Bgcg1SPiJNtqrVQCBUehMr8k2TuxyUoRXpDTIO/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738397731; c=relaxed/simple;
	bh=NnrgFiKITlZcDATaIB10Z7h2bMRKbIUtRG4xLMjJdM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=vGCUkpXiNvpgkOSPfKAu2SFrjV6VVL3PulYRy2zpG4qQrny9fIPjItiS5DGlGyTxqns8OHYLR/ELObgE+r/BrtFMATLknIJJIXN2bwT0fRLKL2+t18mx2XOE6QQU+G79mYJg5pCBsujeJvpfvlRbku+X0YFbGzLt7Mfny2yv7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NHa/qOQ/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NHa/qOQ/"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id CB597210C333; Sat,  1 Feb 2025 00:15:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CB597210C333
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738397729;
	bh=NnrgFiKITlZcDATaIB10Z7h2bMRKbIUtRG4xLMjJdM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHa/qOQ/0dL3rX56GWU5SCmxfD73+hAkvhGkoKS8kVAFynOozN24QT0c47+oqDt8S
	 SM43z4e/Yn7IEfEMs3Gf8KjeataSSnIZDmvn9ES8QBbJks5zvbxzqPin2qhaYrF8Oa
	 Nv/IqIvewmNGlhUBvR+MPdyy2yOWNVB8XNFAe27Y=
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
Subject: Re: [PATCH 6.1] 6.1.128-rc1 review
Date: Sat,  1 Feb 2025 00:15:29 -0800
Message-Id: <1738397729-7287-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.128-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
