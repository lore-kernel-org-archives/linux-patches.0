Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9B445AED;
	Tue, 21 Jul 2026 22:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672485; cv=none; b=i+zo2rwZSN2lzZIdGZiQ/EJTRlt9q35vCiGn6P5viU/ZqGZf5w4aIpZRozTGoS4Vvnowh4g6pgg6AuQdwo4r/aBiHsevo3cOsJQRLHM5fi35hUOWgKV5Wb3OBZvDJyjNEtXX4MrppGXk0XaFBv9J5LQ7ry6qd2ypMYqYJ8kdBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672485; c=relaxed/simple;
	bh=jfthUt3yl3hPYzX5TSi9ryPWAyqLls2KhbdlO9xwTn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epgdJWXJDUqCco5Gn5f8m+tHXuJn3Pq2oq4Rgiz64iSg87pOQPosOF68ar0UDt+fKnUHDjHW/If9G5LyDHSFz4CdPfnQK88KbhV0J7XNztIzQYPLZKyfOJX1wYnqHXPLITcA3xoSs1VhpfN9hqW3P/O0kDPiclxq7PZZovrcKvM=
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
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
Date: Tue, 21 Jul 2026 22:21:08 +0000
Message-ID: <20260721222111.46884-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.145-rc1-g5b1c90a58c89 #1 SMP PREEMPT_DYNAMIC Tue Jul 21 20:42:54 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
