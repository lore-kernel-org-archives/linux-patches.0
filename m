Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161871;
	b=YqLg6cPQ+1FoY2FdUnmgi6ubPXzjr8/oYM5olRHnftlqPWjosxB9Y8l7vS5LsgRYUu/0
	 NQcXhfJ3Vnl4jg4HB0GKEdROYFrJHyXAj99yMpr/V5noR7rgxjQmbbDWTukHnGbkYMgWy
	 RmpMeo+F3Kk2kva3poGu4fx5wLe92VQisxK5oJXCA8WdVxG3j/wEyKn18hDgsh/+pK9lP
	 i92BeoiQcNOXq8I2qJP6M97SqQdcq7RGlokk7eiPev8QxosX4/svrDa26Lzn9bxcM5bmv
	 p43RKWR4y41pQt6mlHdlmB5/Q2OV+hZ1E5SkmbfAAMjtTTU7x3dfYMxPeDRkORq8Q/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161871;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2Lb57z2RrQxxBL33Pkn5Qoa/H+Lt71kMuCNosn1tZus=;
	b=DEvUjJn+1Ks2dFtl8H3daMYKRqP1PvU2gtVomgUgOoj4Pkve3CZFZMt1xGuVUNeHZDTZ
	 YF4BIsw9dmSvQZuv29AH4A0Z12en1vD/b6X88djH3uc8M+wgjc6qcD2eWTZiQhcYgBbkV
	 bLlq3oBEu4dMR03LIILlPGC9wNTYfiAlEBU6GXRjQSZINSlAy22pnrwbBxdDEXpq1bx+H
	 9+lI+YG6hzbTS1oXwDFccnu7xxQWM3321qKBrVZO2vC5uVbaXP0kJZcauIm3EhCGqtZJi
	 zLYxwlBtQybY8nfZutYDN+NDDeo/ZfsCHDVFPc3bKu5KmLOAU15SBI9yYzM3tlwBilA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=X74iOppE;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDAE606A320;
	Fri, 20 Nov 2026 08:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FDAE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=X74iOppE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2Lb57z2RrQxxBL33Pkn5Qoa/H+Lt71kMuCNosn1tZus=; t=1795161868; x=1796025868; 
	b=X74iOppEYTEAK29jQBNPABxbAg+Bdm1aL8mJZWBNtRj6OiaolrPX/wDxsyzptJa6LS58uwNXVko
	NjjWXiIOzVJnCT3wGDDo80o/WTTDGnprz1tSYZxnB5Ac8iq5j3XjJc7B7ENzYNUv2cTckMcR1MYnG
	giGyU9j5FZOwXzIA4UNcyG6c11dMNEUTVZxdOKdqcjR6BZRPCIW5bzYXpx8/1znEj/hPtnkzsNkfl
	1Lz7ro6lr/6wyQdiuiAfpF3k3r8zXi/sJxIdOWWm9jB8FDO941FNSvR5n+VSAC7TlsrLwc2Fxq2Ix
	3YGfJjoYx+WDWcS/TajGyOO4599pQ7uRkyvA==;
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
Subject: Re: [PATCH 5.15 0000/2178] 5.15.226-rc2 review
Date: Fri, 20 Nov 2026 07:55:32 +0000
Message-ID: <20261120075534.27243-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120055015.328810133@linuxfoundation.org>
References: <20261120055015.328810133@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.226-rc2-02183-g758867facd74 #1 SMP Fri Nov 20 07:31:31 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
