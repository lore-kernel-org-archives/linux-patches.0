Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228985;
	b=t0mJE4gAiZyMa+k4iJX43YedL38aPD5VdUdkLavxgrDWforvOzcxFtoK8wtIiCsZJbVg
	 7je7Bnvo3icGfWB0EtB9NOKA/kjJLM5Ezp4I7iz/PY/zgqGmeoE7HbxT2JkvpQGvOC+c5
	 AzZKd96pI8hNEBN1Nc0W7N1APcf/3XIcphVqGytaBLGrm1L64VzhzYjdu31QmYxz2RpKu
	 4oePI1qleVdBz9SMSa14MA9rURlSx4g7lUB4fCUA3bwX45WXhNu2cY/d5lEfQ8fHrWezZ
	 8SU3Cgd45P1a2+u05Y/ykHOOx9kED0RZpNcSeu6rGsUo5LPG5iRX5sqY2piYp3DeI8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228985;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=zgMKlO6hJ7BlOiBhlUKcx1eBr3Vryr4lwGePzp9S/W4=;
	b=hI+xu11VWB4dwSPynsCatjj/j5Ro/o0uLS4f8KA1emFIgZSq/GmNBlzMVOAhlweXUqBC
	 lSJUCOSbxz1HBlZ/Kxq/9O5emBdLzNl/eVoEkAwE6UeXvUqMYym9JHF6K66iVPTd4CxQ8
	 ++4K/2/D6fdvhsG+arL0XT6ZrL/+7/UFIIpNJ1aAIT3xBQEreAD0ljmlMxv8Emu47VDRo
	 6vtrD3mCl4dabkK0xfE+Auu2aNiE4ZTNMPO6rsj3fnvnjFYzt1y94+hBlW0qmgHkdmYBS
	 6wXH44Q/C/nUx2l0pIGVd9kDKdy184xgJpVBFCKTSSJEVEcFhVREg6OUquEcY1KwSFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74611606A31A;
	Wed, 28 Oct 2026 23:09:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74611606A31A
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
Subject: Re: [PATCH 5.15 000/571] 5.15.224-rc1 review
Date: Wed, 28 Oct 2026 23:09:27 +0000
Message-ID: <20261028230930.128308-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.224-rc1-00572-gb52fab5d514d #1 SMP Wed Oct 28 22:59:51 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
