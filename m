Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693027;
	b=hI8S9NOejCi5vFGrM2+rNjqDq4DwsjgMwv3/y4H+00uXtNvu2yahwyx5HTPF0Ht8CNLC
	 WybL9zNtTLIEjbyiDa9jYw45Im0lNprPy9rgYUG6YYSZhyC0b2MD5zGg7gX4qu9k8zaiP
	 nPGu2gi+gMGqUwSLtjAamdoiL4HubTMUFXgEFKzyZ9uV9KHwhz0sB9vXp6KsCg2SZYgXX
	 rpwUsW0Esod9v0fhhWUscnpYBc0lwvsMLwFPbY9sfmb0PpPKWPDC92iv8AUkOX5w3xkQJ
	 A0SaF60pyct7DxuHQtFCTPjze6wehy7eaI7W57Md3NlCn22r6dvhQrU/yOBe6h/5HsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693027;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rxfLRNzwBcIfah1Dd0N8bQ5Q7YIZeEDdPZObdo6GmrI=;
	b=zgTZnpi+5B/VJu4Yeexh4kRBMzzTv6svy+2+4DbQDA0SOn444Rtsb9RZF4wlK/nUsN09
	 D5niYiZ4Mw2sGz+dFqoR6EFw4hUcMy2VHVamTpafnIaWo72aRmFBmS4cwcpXiSNJMuJjW
	 lP0Z2TqLoMN5R4tktjSMhPAeTc2xNjYW/58Gr8/SOma4XyHh3wSqeKl6PX5hEFBp+yu7T
	 uHzltXEoqA7TEN9E3hUg495PaGUgMV1Twh9rbrLcnCRQCTtEhu4dsr9IW3yUP5HbFMQLK
	 sRo0C6T7cZ/tkD04wyFGzCxLNkIhWE7ScLwCIfC1KrULVd9DvaA6n7tIzp3/Tda227g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=jcIgcEAU;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6052606A31C;
	Thu, 26 Nov 2026 11:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6052606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=jcIgcEAU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rxfLRNzwBcIfah1Dd0N8bQ5Q7YIZeEDdPZObdo6GmrI=; t=1795693025; x=1796557025; 
	b=jcIgcEAU0VNB7oXLMTR9eEClPv7KFw9MoXUbUWUbHrDbWa+r+VABk9ZCWR9536GR4rEXhS4BB9t
	ThVCMEGsKuFwyNazFa5jkf54CEAV6ahYkHRnbgQcdpDp1MOdY6wlQaTmHWqx/Oa3uJ3uLZKNaq5LX
	tHfiBNwJKdysg/79CCgXJDmqY+r+61YMzIOfS4OnqPPonyzh2qyUrFjbMCmmSdWixEIySEVHIWdCd
	JUyeTJBHRdSIS9VgIRZjvpNV95CWeApAhOPgeq8U3thYOf6sD4kFxiCnStu36xDdqx9CkWlNcZXwY
	qcjZG5EDoEOcNVnWDPcVSxznrChfUgVVz5BA==;
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
Subject: Re: [PATCH 6.12 000/815] 6.12.120-rc2 review
Date: Thu, 26 Nov 2026 11:28:08 +0000
Message-ID: <20261126112814.27840-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126105709.009001842@linuxfoundation.org>
References: <20261126105709.009001842@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.120-rc2-g4d01a7c6afd6 #1 SMP PREEMPT_DYNAMIC Thu Nov 26 11:08:03 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
