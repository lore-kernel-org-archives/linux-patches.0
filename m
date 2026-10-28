Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216403;
	b=ssAqX5VklZu505WB3YgA0zv9mLmwM9OsfOO4noeFvSbu5s08HdAADiwQ+uu+Q/v4E495
	 Kpfft/ZuQUoGJLVX71lTC6uwjd5tnczhO4rmuitE0QVlxUUNp433e9oxlqaNR4FAb0G8i
	 xaLjcApdz2QHh2m7yXJ3o9KoJuNpVd/pmveGfaYm0IiuRcMeLifaFMQffmQJApQ33XTuZ
	 gr8HRuLS/8j2BaR1Th7qxUhP0RXlnixxi8o/qddh48NeLwOhhQM2oAQNUvME8X6zbDqLm
	 YOOJSCVnetH2lwC90jyj5wel/23jlwI4FpIK9I1rED7c75ox8lQIjR2uMNNoMgCbdbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216403;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=nJwyF2mn4Tdqv34swlNJ+0D5Z/lmVXQxTUkaYYAfdbI=;
	b=3vpty5669aGiDXrhxkONFXHSHbpcF23lB+VO32ihmMy8CrnG58filXG1pnDvK5TcH8+a
	 LMKtUgJYx6ucliJSrvslXMN6k7i4MBuBH8MasS2Zkx/uBSKctbd3bHJszes0dPRVNj8i0
	 Bc487xH3QE3O1vjdptE7vdripYk4DZd3PJZJUaG3qEqHeJtpt8OXR1kybuU6CFU+N6JDw
	 SID/jYB3uqMnxGNezCggD04gg3ZCLrX74akCxRybH07834HRKx5m8QwBy7NOekax/fYTn
	 avQmg2cvZ42jWO2x0Ek8xHiOHOijPT1i38+0jHiOWI7p2fGfUcmppzmCF1Vhpo3GQUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989C606A31C;
	Wed, 28 Oct 2026 19:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9989C606A31C
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
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Date: Wed, 28 Oct 2026 19:39:46 +0000
Message-ID: <20261028193950.85921-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.115-rc1-gadc8e434cf08 #1 SMP PREEMPT_DYNAMIC Wed Oct 28 17:52:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
