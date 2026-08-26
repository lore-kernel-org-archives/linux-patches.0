Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7B37F322;
	Wed, 26 Aug 2026 10:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740357; cv=none; b=AK33v2ycxTjmq2ZvxQQJbKkmMCavM7VBUwtFDtlgcLqzlSqyJOvevjb8pWdix3e7kWZJJbb0I/Ai7pgUQcSer/JUAAXX4n2spxpPVF2ttSyWti74j2N2kg8CZ0TH3z+MJNw9jb3lohN/lJ9i/yHPaRPkJr3KLsjdtGn8rInLj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740357; c=relaxed/simple;
	bh=+OOiQCUM4HIOll1JlDM4PHfCXCow2OA+kfTCX2tD04M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcVsKK0mCwINOoGG/qaFsZ5G0pbzKWGNNqQ21z3OESTVcstEBRH0A3ZkISj968LMhum+f50UsFDKmSlLwoozfOcqVPBzKFoXUL/V5Q/ZzfEh/ekNn9ga9cdJU72PeJ+Jkv4C0AYRbEmY1NnU6/U6EzqM/0h+dSlH0j174Xg70/M=
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
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
Date: Wed, 26 Aug 2026 10:32:20 +0000
Message-ID: <20260826103224.61318-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.185-rc1-02033-gdd3dc5dea566 #1 SMP PREEMPT_DYNAMIC Wed Aug 26 10:04:13 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
