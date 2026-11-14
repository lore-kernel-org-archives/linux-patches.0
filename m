Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794643228;
	b=z5J3LEwohWO/siLoTx7jrRBjhfYY1Zu2T3KMR3UGARwbu9mldqmmBrxUHN0KdYZ+aQhg
	 UNS9BGsRbsZOTAsFlsyBl7ZDM74TW931ZNMQ2d+mL6JZmvKCRKMEETNVpw7KOGFt/IDAI
	 uC8wgLkqps0g2dbOd7F3bjpZIrlt3Q3pHcXk2Au4bXmWda+hkrhJf7LWTf3Jb9b/jhr26
	 YpcjB/FwBL4lfZR9zKPThwZq6+HlJa0QzTst4P9YjgLcZ9i94SQ+QSklr6ufmj2/mYjde
	 JZOfWudKYlbPEeR9zSPpG2kXKYovBCGDLsAX6i6WeEXKQkeD+jd/9NZ0BOTOINhMx1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794643228;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JP4jgX34T6MQcf8dxCFAQwBrwZa4mGZ/Xx+Lud2Vfy4=;
	b=ubmY0nWP9gV6EePTsuqEAFJVR4kFacv+itNIsVBB3JqRiTJlLF8PKMR1Xhhc6nkXUw8K
	 E2y9cYuTzBuvjrhrv/9sY1voISbyeQgSEkcC44VnKrXF0YqRksWc5SGviYHz3jqggV9Pb
	 6SH2hPxwT2P+LWjKaBSQeLxeZ5LOjBcSmmx2VCXpXT9qV5jSlfuAgX3Z9O0nIZOv+yeD+
	 O6GnDejaBo6Y3iFJIxZ/vgOYB+Cz3D8UyDjgVsxdhDunnn/8QRPHH0j7rAc/WzMmowuBR
	 SfWg0aNtOKR+OGJI1ShHSPR081tVkkhm5m4YHiK27hCRRBQEKV3rao79HXrEFQfsY+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=m3q0ASoK;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EFF606A32D;
	Sat, 14 Nov 2026 08:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18EFF606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=m3q0ASoK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JP4jgX34T6MQcf8dxCFAQwBrwZa4mGZ/Xx+Lud2Vfy4=; t=1794643225; x=1795507225; 
	b=m3q0ASoKyQ4U60wnuobqOZU+EoYgoABk7I4ihF8eYydUHc9Vh/3Ojm7+3vOlpze/P/xFp3AED/J
	y4yYcxzw/hwQLwnN/JCmsF5+i/MePeuSZzaeuCHPH9mX3+NKF6JUdT5ZrzFZYyBQT5EBhdC8X4rzZ
	alcN3nSbdzSOZy2TFPKksYrBAoYiDsQlXJyGsdihPLetoXUpyWCuNnM1lB1zTuRSgTaKjYJ53IDMv
	e14lzaNBZf15ToqKgHVOGJ83xtTcPpI7Ald0UOQNBWj4lcUO6L0hmEFjZUE2vTv3/qgad+ISiUemz
	Ga/L90YBf9CBHE7WxWQZFUPyAe8UnnPPZT3w==;
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
Date: Sat, 14 Nov 2026 07:51:35 +0000
Message-ID: <20261114075136.50674-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.64-rc1-g910b5c0af479 #1 SMP PREEMPT_DYNAMIC Sat Nov 14 07:25:26 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
