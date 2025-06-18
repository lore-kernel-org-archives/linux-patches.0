Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1032F49E1
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750269531; cv=none; b=lVDCy0D05UV77vjlnJQa3i7/PtFBvWxrgtTwm90Sv6XPSLQ6rvXymTI3rtKQTsHppas7OAQQgPYQDvEvdyUL3nfjinEyVNiih4pu42kIZhzYZ2iXHo8jg0EPGQsbrnbL4XLfpBLIgCcyx/vDvTjTvxKRc8dPIZpNpsY/q+AlOa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750269531; c=relaxed/simple;
	bh=yEY1XlBhOvRGa5ZD31k7fM1R014ZurnCFqLB5Q58eog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=sNjUUvYKf4xHHn00peLQ9RGuFYsw5lKVFGgBcL08lemftKBGa4FIRwPLZB4UUxHlleK6Z6WJgEVfNzrKuT96+PYNoRgkfSCSLMaxUXs0vjqAJIV4cRVqm+v2UOIu1rm9++JXBEFesOXksMXpabKCVi3lGPy5k0fcwoF/+W79n8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XV0TEzsF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XV0TEzsF"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 51D05210B16B; Wed, 18 Jun 2025 10:58:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 51D05210B16B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750269529;
	bh=nqCPh2CObwkVEgHYaZ67xU9Z4NKvIM/nW8SOObMpPKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XV0TEzsFtakDkW9TfuOQ0a1HlJCuBUNHh2PeSChGWq8bL6Sz5hoc5Z+VW64WYptmU
	 oJxwL//yTISXKuYmOpTgfaQsKnRSRAPmIO5xPcQ0pyKiukfvFky7OeWtzBM99GuUOt
	 9b1telU0U3DxBvfsZTrcymvUPtFjCQeVMwiUrcOo=
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
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
Date: Wed, 18 Jun 2025 10:58:49 -0700
Message-Id: <1750269529-28193-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.6.94-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27323024  16732614  4640768  48696406  2e70c56  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34718829  13854454  970368   49543651  2f3f9e3  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
