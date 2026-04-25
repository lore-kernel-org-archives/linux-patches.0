Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB9315D21;
	Sat, 25 Apr 2026 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777102419; cv=none; b=P67gy4ezpdI6Hqvf3ZMWFso8fBPBR9AJ+hjjgNp7+BGHRDOMQqIMYC7MKrteU5FLMOMtynoNDEb4DIig0lcZBJcM886DQwYFzUihVMW4RmuOPlCExXuryHaGRRCuX7JhxK68GBUzSMf8SnSw7Lk6Kq6uoVNLNfMe+EVS5XSnGoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777102419; c=relaxed/simple;
	bh=gmW3wE8CNXkaxQ/gO7ln53g+rEQL91o+kub6ZuASuno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvZgk6iPSONBB0YG6DaywxWUC/v2a8WgfKykFqGOB/uYowiA8MYD2KVhWYhUvGp2PZd46iorbnKs9H44Y4x3jdAkyYUuF8Kb69CxIrLrp7poCDiw+QDO3+UozHYUMJDuReXZDoOKiYT8whLHJJjZd1VJziFbWp0AvzV1vYAVFOc=
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
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Date: Sat, 25 Apr 2026 07:33:22 +0000
Message-ID: <20260425073326.17786-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.25-rc1-g2bba374400df #1 SMP PREEMPT_DYNAMIC Sat Apr 25 07:23:55 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
