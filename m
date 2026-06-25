Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D737C918;
	Thu, 25 Jun 2026 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401268; cv=none; b=lT84B3xi415hXT5bInN3f4YStoWbLoQP48GcOqc63bLWpiJiEun8uAxwKTZmtY7Q/H+RV35ODGa4x9Mu+xEtNKnujT1dcaZrtDS02yQVoc/47yoJZzKFG4t9ZeukosoJv6gTLoM9Gs5Ym6iigqV22dKHy0zYTJdPW1boiPsTC7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401268; c=relaxed/simple;
	bh=KJw86/w0U5gKt1KGryPF8gbqM3jaQIdjWp3MF3G9eok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAdzfpzuTSKUzzo8SSKPusZpFr2c3Og541o35+p8XloTSiyPSjcWPmGUbjVx4HONg0iWcsoOd6RXsFAc6DTYAEF1Eh1DHYp31KhBjj3dZmaYMdmzyzr46X8wPp0dXGrHWlNAjKH4n9QAiQ05OVi1SstBjeGV+FtyAAuk20S4FoM=
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
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Date: Thu, 25 Jun 2026 15:27:36 +0000
Message-ID: <20260625152740.8576-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.2-rc1-gecd7772bf738 #1 SMP PREEMPT_DYNAMIC Thu Jun 25 15:10:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
