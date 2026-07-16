Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC3638236F;
	Thu, 16 Jul 2026 14:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213713; cv=none; b=nTLDMGBm6FrUulO2QNSthDGz+bZSlCJusga/rVLxsbFwUrvsrapwO8o9bu1UHOV1z2PDVttyFt/p2eJPdu1ojDc4Hkp6KIf9RA6GBHSP1vzdJmNx7H5OhcF2pAggujleK9j+DXlsg0+c5gIurra2uAWfsymlIpOg7Apqk47HmQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213713; c=relaxed/simple;
	bh=wCO6BpBnjKFBywFe5FpVC2psWZY/PjsXTLjv+jwdrPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpNm0qXZXHSJZFxhtmxcJNAUfyX/E6qHSwE7AI6NQg+eG5UE0oXomQ3m7X95FQPHxoq4Yy/Q1y2m6TKsrytM5oukNiHX0Ibw7tNH57x+JaRip7gTX24EZBiSMZ6kqWDunosX06D5zCxUlXjw1Y0QjdwPie8I/x3QQUrh52iwxY0=
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
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
Date: Thu, 16 Jul 2026 14:54:54 +0000
Message-ID: <20260716145503.45959-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.39-rc1-g8b991bdbbd89 #1 SMP PREEMPT_DYNAMIC Thu Jul 16 14:47:15 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
