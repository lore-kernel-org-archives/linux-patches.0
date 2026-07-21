Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFDA472F96;
	Tue, 21 Jul 2026 22:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672488; cv=none; b=In313jPKYeNAXzt800XD6wDhm7EfUZAVepODjSgbfF2qe+wglR0DxskBW6rBZOac6rItDlqV0oL4xd1Ls7aDbF5U6T5Gkad6sISxTEt4FQGLDgXiPIr/KrUUgekQdr8GtCWWwfxtDsDM3T7fYhEFsqspTviIO6Kv4g+XMK5d9pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672488; c=relaxed/simple;
	bh=pBVophRwapxrU3BPykFCFaV1RmVk2G10Zut7x/zuKL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC3ffD614YBZvrh4o+BgjSPsrlvTAp+moiUfph9CM2p6ORCSFWnl4BC8U5RhOOJXzx+E5ULNHJB1KLRZAQ+t8LA6hOiFt6JWucqIByNFAvSk4BZUH+LxO6BmEpM1yf52+e0n4yRqSwbzV0F+zVMdUtfcNti6isedXNXS08serOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
	pavel@nabladev.com,
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
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Date: Tue, 21 Jul 2026 22:21:12 +0000
Message-ID: <20260721222114.46924-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.5-rc1-g06ed1e6c413d #1 SMP PREEMPT_DYNAMIC Tue Jul 21 20:46:10 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
