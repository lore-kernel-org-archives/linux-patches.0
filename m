Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062522;
	b=nc4p6iNwjJjcBrVR61QkUXAuMbdasU6aax1koTeIZ1U2NM57qdK0nQyXq2w5EW7RocKT
	 87Ajtc4WGxPeUYtMSxm0vks4rLwHaaQ1EaYgtSic42I09pJQJsXodDqyU0t54SBoGyTyi
	 aVXkju3iFpUVkx/BCSuPmlVWDZ0J7GMwPAPL93oT/SlYSsgJ/W+uCTVRoKwcBZKS2rE+P
	 f7t8BL8Txte58dyXNTsajwSpK1zLqjPDPtxzSF3nCxJac0G7ev6KCG7/IJ+QSSCj+09rI
	 1GXjoZoO7HH6DucNi5FCdijK7RXqvzPR1ax1qU2+efU+n9RZnAttEAHsNtxrlKgFVZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062522;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=4kVnLkO5D0sy8OnnUiSYDJXNTMpJwq8swLFsDqAqxtQ=;
	b=HlLuiGdfnkLUu3xXkGxOlOF3Ty2Dgu7OPdKqgTnXDlT8WIb+9rkdlMmKnnnGfLjUdhmH
	 3x12PqjMJEPumiBpBXApXCw/81fDfqKlChdgsqS7TuqWP3hLzj1Ot0g0UeW+vw+Gn9IIl
	 xUKkCUM5c5KHoDqQ0LzE+qS4s+wIhbh615mlN1bkbAb3AXmC5rX11M+Xwr+9OXvB2FGXK
	 Jea+4l1cyQVneM617AlMIFLsfwZLv7JppgQkU49ifcoJderzo0N8KQ/7++fCQxyuoBIKv
	 B10K+IgwHDrfkORKRxSKfuXMLNsNnMHxRRj/WPdLer9gRl6bvJQ9d13ihMoXQpvP1ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B08D6083615;
	Sat,  7 Nov 2026 14:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B08D6083615
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Date: Sat,  7 Nov 2026 14:41:45 +0000
Message-ID: <20261107144148.27010-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.4-rc1-gc2e1b438ed5f #1 SMP PREEMPT_DYNAMIC Sat Nov  7 14:37:48 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
