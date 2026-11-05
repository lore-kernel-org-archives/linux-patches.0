Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895432;
	b=hw869eccv4l9igpowaKP0DAjABmLZIjg/5Q7tVLJC2iRoTyuNKgLv8/jL+e3C/jT8TIX
	 cCBTPcSUHPGM+meo80y32gNruXjZ9SsGDCBNeQI4hovDv6j7v+BPMhveOFIbVgrYOmPmm
	 1CYS1P3kB3kDbvdGG5szyXaxo72Aao83MLST0sNcCEQJ6g4s78SwpmV5V9LCpLrNNvaDM
	 +kpaKbqMXgq4S7sqPN92vaGFi2PJKxU4cdPb1SDiaiVhsXPfqy6znXcNLYhnKyoPT+01j
	 8Nl6/f+jmjdiRMXP6Yqpn8WDoc3EtxbKHqWuvwHfy4Qjmyi8IYT4xDUy19vMjaBHzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895432;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=8lEStsPVWk5GuANNFPYYzcnesYXw3yhuIvUxRT5e63Q=;
	b=dPFiDmEd4CvG5dhLP8PtmiC8+sgJ/nSwQZI/g6yk+C+vM2Va/L8PceN783a6t4xHdTbe
	 1DFQVB8FC16x8q2xOQZqG0JK7dloi3xzjDCncP54kI9afLJnlkjyD5VzU1hFSYDF0Rpla
	 Ia3lmDOQBCFugr7Z2cJbUFwP9api9EdXJYlxUfM4OXRk61F41s+8/JeNRpmTmocO6ETQc
	 bTcLtkWdSV6MXWEJnVHUFQQ9NKPJRhG9ov9rYTBmMbxlFd08jiangoE0BKwCngwxcIp/Y
	 U94tBabfUpPBdMtHUex3ZXXGhRjfCRYo1UnHCtDq7YSaZCCZRfjJzfk1gSF/cOFVNjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B11606A326;
	Thu,  5 Nov 2026 16:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5B11606A326
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
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Date: Thu,  5 Nov 2026 16:16:37 +0000
Message-ID: <20261105161652.35323-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.61-rc1-ga7c80de5ffd0 #1 SMP PREEMPT_DYNAMIC Thu Nov  5 16:08:42 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
