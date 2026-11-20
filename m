Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161886;
	b=ZRBBpcFHx1Q8NmxCvYy2Gj1w4LO3pnQeUlCZdYM4DXEt3lqK3wWSrSEpDzpPWrEmwN2n
	 2ivjfJiPDI5z9+sKdHxx1k1ROIYRHYOWeUF+gIT60HhWgk/84F88Vcw1bPjd3zeCg/U2r
	 Vi2A7X2hvOeu+vzFToeQNwXze2jWhc2ibJnbN307HSZAPh1RAodJFPdRRyv5ZkjG6pEOA
	 AtiEGVGAEvxdrtvtdSzByfPXJ1L4l+sP5LGPzfum49uqjKtQMGVjhHe29szuQTjO9l1UE
	 iXjQ1AGVQZlWJRmJyjxYw6+XuEf5CrQEZ8eRHEasAaKBiHdtvRjWMFmAQPWAtrHhIMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161886;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OCbfYOxxBXh21gF5uqcZNK7WliM/oh6wIB/g0RT3p6c=;
	b=vNRF+6NH24kgJrS9xRQYStbOMNmR/1Hirss3xMX1HThTO6CjPRLf+WP372BQVEsmm6BM
	 JL7tGtVNpLVXWx0qN1OwwQYIHWpPcpelw9/EO3/XZteLPbaMgIAlzlPieZDcCSoHutSoG
	 gyqL5oVhhtMjfCN8n9DhngZY9Z3XCbQL166H8a+PezhaxhXL2Uvi8VqcPu562cnfx4I88
	 67mIONcvKbvnB8rrj9J8dXldM6t5/lAy/bQzKiG8OpQBpGtjb0AJnnoEKo73j3AP8TGAW
	 5409kV3TvpvbYYf+iQ9ueqWn4TO71aKSP0ND4PIIszTfGXcIzIuu0rqcj39e2WD4Wug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=DHj0mI07;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F759606A326;
	Fri, 20 Nov 2026 08:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F759606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=DHj0mI07
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OCbfYOxxBXh21gF5uqcZNK7WliM/oh6wIB/g0RT3p6c=; t=1795161885; x=1796025885; 
	b=DHj0mI07cOxJhGvQoOY3Y/3oIR5TNYb7carP3zqADSMv7lw7b2ETlLFQN/8ddMzUcUmnyT86SzT
	yXFbAgYKxIGHYgWPSQcLCL+cWWf0pjlBZaaDSAUJxFJV7ktq5z1tS4+ajTUXIcqj5bMEQMZJ4vaZ6
	YkFwxITdDmxYshRAZzXY4TnDb/OiqBzxC40kTCYBwuxc+MqFslESqHofupeQeUwhMEA7rymMNUhxo
	x0xL9JSUY0J+MtdpAA5xKT5YqsGJn0oG/TrfDsdLYdDoUmARBxKlNzg9aY2QUZHMM7BpSXXraeyPP
	55ySHSnQXiKNbB8A4L+7/JK2AQoRoyqvLkMw==;
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
Date: Fri, 20 Nov 2026 07:55:48 +0000
Message-ID: <20261120075551.27396-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
References: <20261120055324.975889935@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.163-rc2-g6f89b781437f #1 SMP PREEMPT_DYNAMIC Fri Nov 20 07:49:56 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
