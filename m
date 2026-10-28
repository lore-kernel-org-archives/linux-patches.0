Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216406;
	b=YxM2La9L/7FVAN1JrbkBVcAKOK4jEEICMAkabFNX+tx12zpT0jpki5nARJZQCpMYUgXc
	 kmT7tbPAAW0iV+7YhJsQRbKg7W/Y1WPmPwD44wJGeTSdjpO8QyiWk0DSDWW9JlufB9KvW
	 j+TuGodG3n0zmx0xrqqmYZvwA9B3FDR3mIJYedoCD77RCjzoqes9DBITO5IZ6naRUyzr4
	 qTl1GQDqdpgNkLIMRHBV19uXPl41YYq24gJ3mjZ0pdML4hkmgHdhjcTnS89Kmyd5hfsbQ
	 0kTQz0crD2E89ZiUAN5zoa1kNAql3NPZSsgYWSVJCq8rhBlgG6hsstNwoWTCt5oYw9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216406;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=pVNE0g5fy1mxIpd6Ve9u5tldGemGzs50xQBCyV0innM=;
	b=xdwFBrn3QBifqftM+wip2LflUKkQ/dwJFyah8ePlgBB4/yMuGkRtTD1AB6KX9fNngpJN
	 vQCQGgpX8BfAal9yD1un8VgYtKCSejg/MUiJpCN1s3ph9PR0I3Y7hhMBmiLbhFYsTQ2FP
	 Ec4r1XsRqa78RazfRRbUDF9nR8E7LlbIFG0Yt4yxQubinrcOE2P7tNrWbmCilyq39kPkM
	 h4y2VczsSPUbzIZLcaE5lpnBGiqHx8U8sI6Jf8JGRtkWKRAYCvoZqCCxgCWcvgLwHHEWB
	 mvvFA7iA5hdYXUORvBMuuwiAKfbr0K6WN8C5jc6AtNnfgu4v5BkH4/bVjkXrP29XvFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434F606A338;
	Wed, 28 Oct 2026 19:40:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8434F606A338
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
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
Date: Wed, 28 Oct 2026 19:39:57 +0000
Message-ID: <20261028194000.86039-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 7.2.14-rc1-gffd5404639e3 #1 SMP PREEMPT_DYNAMIC Wed Oct 28 17:56:20 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
