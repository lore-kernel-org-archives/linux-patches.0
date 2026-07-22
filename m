Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F92B374745;
	Wed, 22 Jul 2026 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732491; cv=none; b=PnYS15mN1Kx/ktmneQ8q+c5C1eXEJpmZb1u6kadBe6No+m8AyPQ8KyGhMIKkhJO2f2iDAXvs61kWtvjRA6z8ynSnAyplhhtZQO8fsbOH4EAuqn4ytNJc/1mwCjBcQbqoLBhDW2pQzMThvFhwioig/4Zmkh+i11s2mxzBeqokbhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732491; c=relaxed/simple;
	bh=V/y/2xeAiRc3fOhnzl5smfKA+5h1HUTco0Xvr/CZYwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Okr5p0WJCNWJNVDnjKLaT6MfXghApZMYO9QV21Qr2e37Ck4cNlFTBPCnwKmahe634/QcnX9LHWU8U9N2E0ZsWyhGvHPTZwS4VPqqdFeyLMMuRYwFYfr7LC4n1wEqpHcShNk6ApiwawuvXoXOQwVPL516WnzIKbmuzo7tWTSKsvo=
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
Subject: Re: [PATCH 5.15 000/812] 5.15.212-rc2 review
Date: Wed, 22 Jul 2026 15:01:10 +0000
Message-ID: <20260722150114.33488-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722142759.100285390@linuxfoundation.org>
References: <20260722142759.100285390@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.212-rc2-00813-g51593da9146f #1 SMP Wed Jul 22 14:51:40 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
