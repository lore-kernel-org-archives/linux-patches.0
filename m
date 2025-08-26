Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57152D3A69;
	Tue, 26 Aug 2025 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230932; cv=none; b=DZAIxdGCkP5v2Dg17/kxvfZuwE/EMTO3z1rElw42Anr5dgFXXLoYY6CHuSR/WVED0KukCueEfKNTr626X/BkKyT4br39963Z++t8wu7qNugDW+Bzt2wK3p9RFh4d8rfF27uBF5W2N6oYhIMFGX+vnF1c3Njqq9PH0K1hnll0AVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230932; c=relaxed/simple;
	bh=GUuNmf1+GSoMIaOcHs8hfxHLXeuQ5TBmdsQrJxXXDgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVlZyrXaVe85AeNdOtdsI9v3SaG8BFdf0ulX/27aUJxzeq017WYSCRS1A+QuJT1wt5nYbGx4/Wd1TsK4WR4zpIHBvD7StYHKDcTijlsNPkYs4B9L+psD7Mmbu7cYymMg6FqrymZv0qEPoJU/X826K8toYrKcaDsUlMRY2Yg36rg=
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
Subject: Re: 6.16.4-rc1 review
Date: Tue, 26 Aug 2025 17:54:59 +0000
Message-ID: <20250826175458.30242-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.16.4-rc1-g2894c4c9dabd #52 SMP PREEMPT_DYNAMIC Tue Aug 26 17:28:33 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
