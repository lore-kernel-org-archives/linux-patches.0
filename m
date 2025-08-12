Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EB81A9F90;
	Tue, 12 Aug 2025 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028602; cv=none; b=BzbQAROzWZZvTBQyXVRbxbcbe8CFoM2Cf/iKDW+3Tiu4iRJSsChLi3u69PyCp/8dIcYpBTnguBfqw5Jw0DANclGMODtJL1QFeZvryGKSzr6Ro1JqxLbWSVMuyXO6Iy7oxJCooRkPFwEtDJ/n80sW3xz9yzntdJkqSPCGPzZEj74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028602; c=relaxed/simple;
	bh=dLWyLC4rUb+LX9nwcKLQBxxyO+E0JKaIyXTFPDzspuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLAK0N+Vg5v+6ImFe/UgtZbxc9atizhlR6xl4GfASYrm/NqIUsxemV2P8Jvjp0hqA5tQbakQVZ2GQNn39uJDf502baicqzt5DO0kV8OzHHS3RCfTYACjxCNkiANNn+UOYkSQEvJGFDIOd7JrN1laxc8zSUqJ7CU3u4Wi9RWBSec=
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
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
Date: Tue, 12 Aug 2025 19:56:06 +0000
Message-ID: <20250812195605.7929-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.102-rc1-g7ec7f0298ca2 #39 SMP PREEMPT_DYNAMIC Tue Aug 12 19:03:15 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
