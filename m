Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA1238175;
	Tue, 28 Oct 2025 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659617; cv=none; b=l5WSjHl5zH06nJqyP2vho/lDOLVYrRSu0CIiddCQuXoRccQGv8elnnqZFanfw9A2bj88KBaas2fAihPaOeuiZb/LB9/ZAe7K0llDPulTX89PrLJ7LpozansMfZicv9UgmUmA82HGtraNkRQV2Vc+JKBvU6jUU0WZh0ee8crtPV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659617; c=relaxed/simple;
	bh=0u2/fbkXJI/angwwahe7zaIEC8AS7cdA0rrMeSIxNog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq88dZF3Xj3WG8jAKD7fma+LeAQ9oBgLsBgUURomBbOV+FEKR/46qCQDn6yMDo8mEaF+XvUrxTIeMzliWLxswc0Rs0BkTHoJ2yyaUgz+JOUJlk/cOLs7GLMpnKCrZ+kUZSLTZHtF0Yd2KnSegs2pazpfqxZpdF3L18epWQ6ElWQ=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
Date: Tue, 28 Oct 2025 13:53:05 +0000
Message-ID: <20251028135309.3754-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.6-rc1-g10e3f8e671f7 #118 SMP PREEMPT_DYNAMIC Tue Oct 28 13:25:13 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
