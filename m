Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216404;
	b=w+oufDejzJ364h7IhqrQp1axUHJ7hsYQ4ioMfMkrjycvPgcf+7B0IB/ZfbaX7eW1fU81
	 G2r31n+YpBCyeojtjgyO05J2d22ZucjerL9YiAFjROFmix24nLKGTv/mnGd5b18m1hSS2
	 K4BUGHSP+gVNRxldfV7YIp777CtxEr5URE535aa2hLUjutq6OAHQF9gc9U9xG93PKc/Qs
	 1vVeJ1txcWuqCb4FIE45wny32QZYBlasdaC1OhmObSq1EbLPHtZMGcaDKEMgdShh49Eem
	 0JuR8C2/FH14dnOh7f2pnvxelARjm+y38Lp3Y5jcdxFX/Cl2BzMf2qOjs61u+OjbS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216404;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=DAVpcxfG1NPLkc6KxAq4YIssFOhxpmdhXy0mM3TV3jo=;
	b=bMZQBbcTsxAQCuKRLIkyKF5ut4UUelJQUICpPix+2+65b/MYWkRl/Sj5SzN6WH+AAIdf
	 GEVKUYgP2BpZEXJNzGTMyrwQiuYvAHlaFOhzgQ8StfIqYBXLPdAU7xAxORD/x/ft1BmhO
	 j97tdyyumqdxZ9MWQqu3ya5tpu+pS2EJIBiu6M2mfz/4p6VwCzeZf8Z5W2dh477nE4uYO
	 oQgCKolRX6usa2eL9kTWDTcnHy6+AL3TE6Cxwe2dW2/FdE0+zB4cO4s613PxqAWzwtnQm
	 qRa6ics9VObiITjggR0OYTg6HLTamzfvYNZ0dqoJ+9BI+LZmdH3UEHyaIDejVrSLKyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FD8606A31D;
	Wed, 28 Oct 2026 19:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0FD8606A31D
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
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Date: Wed, 28 Oct 2026 19:39:54 +0000
Message-ID: <20261028193957.85997-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.161-rc1-gb6e2b2f6f7e1 #1 SMP PREEMPT_DYNAMIC Wed Oct 28 18:32:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
