Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F235142E83
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 01:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754011797; cv=none; b=Dig5/LBCdFUAEqzG2TXANKHiKzlWmagWH1A5Np69tW69IQ6afdyY5kHBuvqXJQdN0lFu2Rph8fKmclkSg/rE9e9JantbJaAfvt9nqZDWkjriagNw+K6KuYn3MTTvc0kcRGkZQhYmntOO7NX8CguJI9Vd0iMe7MHCDZRT22R4HBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754011797; c=relaxed/simple;
	bh=fpitKmcCNonqrgDa6ogqIXTsC5u62fxygC5JgaSu9Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=nf7Vw3Qsz2ZXeRuemHWMqrvy0bosLZqW83uKxra+pxlWMM7P/PlZW2UbEnYBCSUW5yEyYf3wq12QoDyVkYzzPs56vpxfj1paaSxmt6S1PLfGNnlN+lg6+ujAkwTwo3Z2wfO1LPWdkBzkBDk3xKXqX4rEtuF18+A/PIUbzNCd78Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ZrvNC6Gy; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZrvNC6Gy"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 1B68921176F5; Thu, 31 Jul 2025 18:29:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1B68921176F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1754011796;
	bh=fpitKmcCNonqrgDa6ogqIXTsC5u62fxygC5JgaSu9Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrvNC6Gy04EPu43guW7m6VJ3i59QxLapkr8l84skHVaZmy+0SZls1y6Gm3q3fOe+D
	 WcbC87l9bijr/k9dFsjCFNKzSpdno7y6fKQC0Md2Ee0Z+dPtG4TKlMwE+W3dTs/3ui
	 WBeNcXNCJMzmIS4k+zSzMURXVDRvDPqkzVccddYs=
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
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
Date: Thu, 31 Jul 2025 18:29:56 -0700
Message-Id: <1754011796-27079-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.41-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
