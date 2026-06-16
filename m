Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE6847A0DC;
	Tue, 16 Jun 2026 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628975; cv=none; b=N3Ir5xyugl7Swa9ZxLIvP3nL47G56yFApS5W0WaMPwIDPqE/1k10ZgAsT43EMoY+xVCD5Pfqjp4cpkYhW7z5kBq8f4Vjp00tZwGxyq9ueAMoRVMlsCaClEOTHFLbEFdv6MGQGrjxy/4rwSR0DQ9H1nZmYEiOhp6nayMu7j2LQx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628975; c=relaxed/simple;
	bh=Vv7XIEx9mlIZpF/iUk9dYenwTOrEn0hHSrv1letG5v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcXqOO2g2eM2uoaBebtxWfq5NENbxduKdDz4vhez+1gFG74hZ1uUfwCSfh4yZxbAJ8pWzpCzyQ8xNOwvSbP/BPo3NRSwGRs0YAqeIuPd9GFXXjOSlBD4wK6MC5CllPEzNyHOkSdczkdCOPQmHu6XXVCzFqfyHHoIp6jeQzTgnbg=
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
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
Date: Tue, 16 Jun 2026 16:56:04 +0000
Message-ID: <20260616165606.26826-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
References: <20260616145523.335696673@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.1-rc1-g281f1e815287 #1 SMP PREEMPT_DYNAMIC Tue Jun 16 16:53:13 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
