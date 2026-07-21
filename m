Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B443E06E;
	Tue, 21 Jul 2026 22:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672471; cv=none; b=s6k/TOCRmM856hkvyaqg5SM6gB3IUOv2+3uHlQJ1M72oSLTRb5m3lmqYOPrStCsU57I28KJeuK0Lajrq3TYuRH2t+WwpC29Fi68w54XOPPFuYUimO+f+LYn+b+1gKCkC8Odlp0hAOXGlpAL6XBlHifB65HXkX5lT8XD2H3PWtVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672471; c=relaxed/simple;
	bh=Z8xeCw5wZ1wmi4talNZb1m0fRSoraT1w8nOYjoMBQ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctGXqIkPqUVi075RPvdR3an8SVqj2uUCtLpADgGulLXkWn6kZh14kcE+O8Lpzm7d4mo4bGzuz/QeZVrq0kGIlFHrlyjwJmKLmhJ1LBZ8532WpKHa7jgTkkGeOmcc3yDqytEmMDmWfZtJR5nxVx7EcX9kdqsQrIajOtUZlUvTFMc=
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
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
Date: Tue, 21 Jul 2026 22:21:00 +0000
Message-ID: <20260721222104.46803-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.97-rc1-g160123ebe781 #1 SMP PREEMPT_DYNAMIC Tue Jul 21 20:36:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
