Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306D02B9A6
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 19:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751572267; cv=none; b=rDamwsMrXVNuKQQwgVgiZqYfpMW0+UXhRd1GaKntoMsecfD7KWm6p6LT4y22Z6zpRgekZwhNROwtbo/S6tn4imS3nFb0qtCzuseowXg9Z2Yss1x6ta+lWE7v65jGDvuyweB+PkXI9MW0l+Z9NOVVCP61ChW2UzJ2jMsk2lGbLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751572267; c=relaxed/simple;
	bh=r1Bjv6exezlOou7UHlFP7NKHZZDfQ6aDS6bVRdZjNz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Eup0KyzrRda9PG1kM3bMegta0G5APlhkfyFj/ziBRLwgfPEs0V7kewkg0Rvm9+PsqfjMFu4tgeSJMSxGGygW7MyzwdczP0Vdjsav8TQlnzgiaRqljubhcqXGstGKx8W4SrPxUZYGtWp6hMvhX0GyWibg0F62VzP9DRZzpjV9rz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XN1jZiKP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XN1jZiKP"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id BCE69211222B; Thu,  3 Jul 2025 12:51:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BCE69211222B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1751572265;
	bh=ztGDueWUWYHfaxLagV2gxF2SsbHbRPFNj2sJ6WLsyLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN1jZiKPsxUrIv8UKCsUsN8/wst0XdwG4N58RNtdKckyfbRl6fop7swxio2aK0FPy
	 z9b9vv/GgstRBVSHbux7QBI+beo+XCRewfWRkhFPETVQtRQi4lB/5MYDK8dIx4b3Xv
	 /5J68K3NpsRaMP7RJUsK1Bm1EBtO6GleTj2ira8Y=
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
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
Date: Thu,  3 Jul 2025 12:51:05 -0700
Message-Id: <1751572265-25811-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.6.96-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27323349  16732218  4640768  48696335  2e70c0f  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34707028  13854434  970368   49531830  2f3cbb6  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
