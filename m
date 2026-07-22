Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0A037DEBE;
	Wed, 22 Jul 2026 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739290; cv=none; b=jxn03inSXC8eRLTrOpa1W0iNoBsXN1f101FbgB5GCG7PSAMcNzioQJJ250aO8JAIdJniFQURVCp+26YhQmxD4d3RtYWCE+Hbqpv1Dt4A/L4bpVFJvgM+Ht5EgbYJ171Lnb9MsvUP/iDWsCXI4qz7ifZKazdFWN/t/4DPCJDo5HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739290; c=relaxed/simple;
	bh=ge3cALZidnog184V5mmt6++H4rF3mjVhzQD/y+RwTOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxCwnqKQrS+jzDKLldYJgLK6Y8U3r1vgZvKqDXLZ/bnUZ5Sr8veIpeCu0qnRSlWMvKeDEuUm4MJApCgYwZo4nDhsfG0jRPv2coJ9hzDpkojHtTIjyaLDMXT23KW72/q3pxZsQUmjv4LxsTPreChn15ztXGwgIkr30DdM4O6qLhQ=
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
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Date: Wed, 22 Jul 2026 16:54:37 +0000
Message-ID: <20260722165441.41928-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
References: <20260722143218.909123637@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.178-rc2-01030-g2253c703247f #1 SMP PREEMPT_DYNAMIC Wed Jul 22 16:42:05 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
