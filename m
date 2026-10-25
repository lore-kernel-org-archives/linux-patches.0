Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792953167;
	b=qy38GGeHLubm4zHiKFVGaA9GeRdMdoRYvEyBxEzBmPpZe+p4Fo0hqhGYz7gDaofawczT
	 0r338K9uInou8i+KM75WlIqcpbuD+4+0syWhsre921iUkImdVSIXc8r+9R1TaDYgCPaNJ
	 H1mQi7aIGcmNvuiGWUp6e+Ij4sGmn5voeAutSaSqHeheS2WcxTDnXlA45027IibYzPMb1
	 exSid7tfWQalZ46KrDwlRcEFBoqY77TqTq9noUApXzFGlu3Q0NrUb6+gcB6fVLDjPHjb9
	 XPAsk7ZwC05tMlvao0JMNGmrxhq3Vlm0sE0jp1Bba9q9zauI+9o5tQe7qMCTa4xpitQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792953167;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=hO8s1UdeGjEr1BdeJr2tulptNCWVs0C/84eLT3W1K4g=;
	b=ZZY6ZvhhnB1ALRdONP9alFbwrH+lFpH9UJljvKvcF5iP4CxBR9DuDiLA/8RwJ78lrbkq
	 aCtWVocQAUDb0bioetHbK/xYKBZbAjXeJUZWQI6vjUkRYkV5JoMW75Lp8zP9WxBtHyJxS
	 2omAk07hr+Fs+2SEPbmxxXWGZzXCPJ5p0VqncbYO/5UU6TSGfBqEMAh7hg4OVzGym78sa
	 k3mXuws+QuWLe2uJHcdmsnx34cTQx0wXEzEPyJ3URJ4XL+SaRl8qqIJV2JFEDFPCYi3N2
	 Ek8DlM8QdiYBi6zh2YaSPkSbjnfZCtxPs5SXYzWkeLuhvJbHIzqLDydgNFdRqGPIdEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A682606A31A;
	Sun, 25 Oct 2026 18:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A682606A31A
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
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Date: Sun, 25 Oct 2026 18:32:22 +0000
Message-ID: <20261025183225.3200-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
References: <20261025125805.309934791@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.2.13-rc3-g638c94931487 #1 SMP PREEMPT_DYNAMIC Sun Oct 25 18:27:48 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
