Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021289;
	b=cRzn2wLmR/oOYVz6LoNuyMpzvcbuu5GeLtaYN8FxRvITtj2/iisD/lT0SAAehQY+qIq8
	 uLFwiIYYvYtvH98jZnl4s52uQ0w649SieBsLD4kxqSP3MTidHabQiUhER1sVtHC/3D/AV
	 VX/GPM5AHOnc3sxdMF43xr2kGoc22ng0mZIVSiW861NLeKgaLAtfSS8Jso+LEXNO652xx
	 ldDKv14gzyNALqDemqzQbZEPj/F3hcrTyCsRW2sWHtJT6YssywJ3ruV8RJ1WksVb1J6Ib
	 +0UkNBFgBjdiZd5nKax5YzRBRHcvw9/T17zmHmrETBteSZsY+iSGHnIIrSV+s7i8f4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021289;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GlccxDWpywF7+I/SuRXzthVKZXZKDwIX+1zgdn7uLcI=;
	b=I4YbXn1BKt6reg0XeK44So1N900WQufXGRnj37KkPkM0bX0VppUvhfGBPC6mpBVw4WR1
	 2bY+4JBbSKSguVhdZBUfRfqn8wuLTcm2e13G6jHgYYGNqA7MQFpRQRUsxPxrd1ilPZuRX
	 qoUEDDSZqfHUet7BbLMPFI03tyGquWFYUUcPzFy16K9eXjI/W/Kt0UkhrCU3GPHMy1qZd
	 tX9IhlUJVzohnIMwboIEgVP/zYC+WCmUvNqBFYlRDxgcU5XqAUJr6MxWx/SwGQ8yUUv83
	 EIQKv9NplLT+6lbV1z4sQnaloagm1cZ+6rHdems38+otL1+IoHdKvl9MlCljnRhEd2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=GH6Ah925;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E11606A33E;
	Wed, 18 Nov 2026 17:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32E11606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=GH6Ah925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GlccxDWpywF7+I/SuRXzthVKZXZKDwIX+1zgdn7uLcI=; t=1795021288; x=1795885288; 
	b=GH6Ah9259hnlsqE2KsD7WIx2OjNdf2ToCNhESMVa4kh+/MhXhFHW9LfVjCQiE/kWyuMnS/wjRFk
	HVPwhIkKq51Y4Yy5G0jN7Z/fzAoLTMCkmvoYqLE0fbJdGkX040PgrRxHBTHyrg/VOshb+1Gm4Ujcy
	aaI8c99SPM8KrzgQ2BhtGQARgDzOOJ7gtLFc1X2647XUxZV1ZjuF+mHzFDiSCqYc0ATUAYzQr6bp9
	vdWI6yzvmxDv3wGOhGIhAtcT31x44I8hDN6cjU9BBQSDEpUWg+6ljxcTTMo11N71G37UX0MQBbdnk
	9mUN1Ywqn/yaVxtADAuAYodzUAvnA+FGt9ww==;
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
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Wed, 18 Nov 2026 16:59:08 +0000
Message-ID: <20261118165910.35715-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.6-rc1-g62eba995b019 #1 SMP PREEMPT_DYNAMIC Wed Nov 18 16:56:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
