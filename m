Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052E3B14D4;
	Sat,  8 Aug 2026 11:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786187119; cv=none; b=gonKTHh1mbAp6DdZ5iOsOc4J30WyakhgP4iTwmNpnb4lKL/0JWsARkIm9GmzCC5id4oETValDpAe4qfVLbnhriVN+9Dc3J4YhmzR/hdh2nECcABAM8VO+crpiggeG4cS/CpaJ/VN0Oy606VNYFlE9wMQfPeTW1pG0PlMa3Fpz+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786187119; c=relaxed/simple;
	bh=peY/XpHgtXrTMHQ3qfcPnr8lgYckq3hXpl4LUT5Hll0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVzl1DVzfnWagAWfuzaAyFYCWpO4oQvAuIsHoRdftDrOHzyb/rU6rTO4X/3ybi8BLFyTdcnxwoPRyIclquuFTNcz0n+NlfbaXvSPRrZLTGln8QWz8mqcX6pBpjJP6S+k8D9qvUp+Oxzz42p0hYUDXx4gWeX+chO3FNhVje0cENo=
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
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
Date: Sat,  8 Aug 2026 10:22:42 +0000
Message-ID: <20260808102246.28767-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.151-rc1-g1e59060c56f6 #1 SMP PREEMPT_DYNAMIC Sat Aug  8 10:16:17 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
