Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7EC2EF66B;
	Tue, 26 Aug 2025 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230961; cv=none; b=gZ/ipsIR8f6HSjZCg/7ehAht7nKctVkNhUNatRfLUULvcisLB8mFPFwREeETjVu9Z6oZjwh5jd4+cN+ST9hjIyYq9/BxL5noDZiwZWzM1jiGuKVGmBzJkk36thziHUUyFNZXkl7/IxQRAYs9SC3S4+B5fFqLFdYCYBEqPjFI4xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230961; c=relaxed/simple;
	bh=sN73RuLs3/tMK2PgpQFbf7oCyh/zGteMMI3zlvbirpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfgxtDPSbBl7q/VD0G/pJFsPoFxZoLDx0BUWoZlKacWLKUXGoWwbUHLs+O1MYr0BBGV74dqQGbs4ztua1ofdm/w6f1sxx5LagZ32dNJ0DaeXxO5AGu0LOLjnLRbJuGBE4PvmXULojMQXodsWQU5mhcHpEWt3HMtB/LI+AeUzY5Q=
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
Subject: Re: 6.12.44-rc1 review
Date: Tue, 26 Aug 2025 17:55:37 +0000
Message-ID: <20250826175536.30283-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.44-rc1-gc7e1bbb35205 #54 SMP PREEMPT_DYNAMIC Tue Aug 26 17:42:44 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
