Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793E82D0603;
	Tue, 12 Aug 2025 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028746; cv=none; b=UdPFyRisD710/U0iE5gM/lHgSFeU7L/6qUCjK1eZKEivTB9NLty96D/xuew+HpIla07rWZHxJqOnfrhSAXRg/BeBrIZ6vfMSMEFVSSRI9qP9R1A0SsL7C3oc+xCOkwW001psFUH51LzpxukFh86y6hNarhfVp8l7yk3p7u6NTAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028746; c=relaxed/simple;
	bh=43645r6RDsD9iIKYQcwhR3EZ3tkhXZ38Dfq7MK1y8Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj3xFCo1KATKmYLH6zeM/viSU1bclZbd2NNzGUKrsN2bTY+9aoamFHqxt7+czdra9pQ1XuheC3k+8hq+sccDnVebcbmnclk2CPUm7uuyJB9E5+j/e4tiGqR1c5cHevf1ir6Q+t09LR26AWY2nKAa4IVZdQNDYPd7F2vhjcHeg78=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Date: Tue, 12 Aug 2025 19:48:43 +0000
Message-ID: <20250812194842.7474-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.1-rc1-gcd8771110407 #36 SMP PREEMPT_DYNAMIC Tue Aug 12 18:48:08 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
