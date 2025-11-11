Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878CF3AA1B2;
	Tue, 11 Nov 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762865949; cv=none; b=OzdPpCnLB83zoNjmBEhTY/8M3GiwGHsUlJQZNHiE7Vak7oHKUEOc91gYp1K7gioIeLcxAcfoIexvM8gb3qNmdFXXmXOR012Mxw3pdA8vSc9wUpqdjCTvMgjpYLDEDDvc5pWx6dB57/yxMiHk1Eb9nPsdzQFiuRZsW8O3fbjnJvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762865949; c=relaxed/simple;
	bh=ddvbVXcm7iv39NLysPDtmXYFiL1k++16nKGzsqlcDZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwmNnkCk6qDD2Sxvy5D7WNLeEPs+lQ8r8pOlpcmtA3PAi0+vSibFN48w3o5lWIAJE5reWO0HxpnOtllByRilq/pfMy6Z6u22Ur7RA3aKvUotyL1o1s1bWlL2ewWsHs/YING4TYuRtlRPJS+j3wHPhrGvdps41a0wvlw/zILR0/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Date: Tue, 11 Nov 2025 12:29:09 +0000
Message-ID: <20251111122915.25543-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.17.8-rc1-ga0476dc10cb1 #128 SMP PREEMPT_DYNAMIC Tue Nov 11 12:21:46 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
