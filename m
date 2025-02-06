Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C6AB672
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 00:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738802550; cv=none; b=VglHj1WP2SyJFD/U+zeQIihcZgz/cjAdfb4FUDiAterE205gGNztAhTOZR4Yzeg/z2e1J01+tS+d9duRrH16Lyvpq01NteqZp8pVEwzHKRsJAyXpn7Gr6aTcniWtyV4lr7M/B23Ap6JyHO6AFidV2U3TEpA5A5DYWptSaaNyLKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738802550; c=relaxed/simple;
	bh=HypqwyNeYyIGDxd/D71t2fHwZv3HbVkZtldFgYlUkV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=fzmmQQMQx7brP49oZIWzhiZUo80IlF+wrG2Y4kN0LBwLFkjLgviP5RkVkjT/I7JE5EvdnYwU3XuBPTjfTojoFM1Z0U9y+lPAyNNhRk8MiDli7ZTTHbWYyMIjLIvQy4c93gC0l8/OLk/yRLzICVWGH1GKdC2btsK28+wq4EuF6WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=H1X5vqpD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="H1X5vqpD"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 3E52B20BCAF2; Wed,  5 Feb 2025 16:42:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E52B20BCAF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738802548;
	bh=EPL+R0bh0NR8q6Ylsp8lbKpOE8MCcnZCf64x+boYcHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1X5vqpDsCe7qfoI0X2UZTTagmTBERHprrsIzy5QGW2WIhiwHwLvkj6Clr4Cguuaj
	 swxjZ4XS1WGMXMR+HtmMpcRqnq3K0zdBLw/6pyCV7CJM4ZEXMM8y6YTc+r62mQ+nCM
	 IdxOM/UsrakgdgC3UnAT/0VMNSfVg7YKFQkKZJ68=
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
Subject: Re: [PATCH 6.12] 6.12.13-rc1 review
Date: Wed,  5 Feb 2025 16:42:28 -0800
Message-Id: <1738802548-7297-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.13-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27752542  17709406  6397952  51859900  31751bc  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36382423  14991749  1052816  52426988  31ff8ec  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
