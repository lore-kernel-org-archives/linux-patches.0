Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161871;
	b=Wa+Ux2wpWzx+c3pRiScHTEcTeW7G4PFg88Fa9GW4cp6NkcWivoYNIHA038Z6+/YZYSfk
	 ooO2PYgKzTG3wTo5mImz2BPr8RjCnzlpp4A0Ptb9bjbbjErdHYvh/eAbQuJ9DpYdNjIc1
	 9R4RwCqm3V0EozTMmIODnU6F2L92UxwTT/L1TCs4tiD55ic54OeYbaoh5X51x9Q/O2uj3
	 NsZfqbiQa2dES1WXVbxxbeVy+lqEo/KjVt3y75bnLZOB7c7daA4p5SvAqDfEXLg6PZpK1
	 vO73BMblY/O3PEjxUTRKud7AsaiT/3nKREPvf4u3bWet4NUuefqMS1fx7fqsZfF7gbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161871;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=utDpMLXyyuizh1d/rY0N1jZbaDL7trV9vkL798WdrCM=;
	b=gGClwd/ci89yvMK+rqG6n/KQPN9kcPa1T4SaTk1NjKAenmAqYYLGkHEjDWxamLRluXIu
	 jSbP8lvTDViQAd6Vrh+qKTVLG+mOmx/tPaangonLL2AcT2JkGvzFDr10dQL/7jthbcjNX
	 lem7Wz3hUZZMUP2ynmXk7XYKeIZHLldJ8OMEzqyaYE/L7JxgjI6qEWzI4aGkJu66drZr1
	 bsvCctNvxS0SsWvUKATr0PMXO1cw1Cmuzc0RzOaTzW6ArtBt6kicuf0HpFxQtFeYsvqan
	 ocoNO77IrxBnk1KI8RhQNUWHe8EqoUgMSq/+LkDT0qXf/wVTqfD30Ix0Zs9VkdpWyQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=QtYDRjT8;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCAB606A336;
	Fri, 20 Nov 2026 08:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BCAB606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=QtYDRjT8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=utDpMLXyyuizh1d/rY0N1jZbaDL7trV9vkL798WdrCM=; t=1795161871; x=1796025871; 
	b=QtYDRjT8fZpxQdGPyjnVaSEPz2zD1MGvUFBb/7FoomxLLJVWFDF2ahOKxGBUPyACQXKJ4L4pyx3
	a+v+v2PyLkIGSFybPAdDFAUALc89DAhwQx2/C4G2Ufq8A0mQLjeN/YkQf0DT6RVcAXnZL9l7prn3p
	frPSSDb39zaNCARjyQwJ7PoBSi9ioYvAh8afTttMWew1STCpFriwBjerQ9jOvwGHtlE9Rjvg6694V
	fsmIIsoW+0oKVN+2+TFov4xXt8m78P+AOP4XTbYfd3LO/yfT85HVMRKnz/j+bmTCwQ+nRVVhK1A2m
	hdtOA607qheIdZr5yiZI+HP0E9+pRQM1/IyQ==;
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
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
Date: Fri, 20 Nov 2026 07:55:38 +0000
Message-ID: <20261120075541.27319-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
References: <20261120054951.366579794@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.119-rc2-gfd1d7c3cc36c #1 SMP PREEMPT_DYNAMIC Fri Nov 20 07:43:51 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
