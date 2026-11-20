Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161873;
	b=R5nIgHBRuK/9ZLuC9bB4xPXKQMnUfQB74773OtEm6QpnwSnl4kL6Qt3m5mNzrPEoqjrt
	 xRtpknBcPSHwD9AyQ7vlWsHDkFmjHvAcRlrFC5a+cRKOe+LZy+Wly7C/yexq5Jb16tY23
	 TAxaQqIJ8TRotJiKc86hkMq/01aRPLi+BEHh4bBh5jWzaey+AT9opBLq+ZtcD6Sb5yL1l
	 A37K5E16w3ZWDR2E7NnodVdVsUVdO4YxMPBK2h4VLJHMrRlv1IqU5SITM6uHx1mg8CsAD
	 meVJHu4X1qwaFR8DSEN9jGihtSMllbLnWjSHiiNDQ5hw/oFl3stGmIZXYMMMmOcJ8sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161873;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CMckLEw8p/4XoyKuw4lKkcH9bPxFY/IRI3daE8cb7jA=;
	b=mhUvi7RQx3aZuXVBD+15Fhoq4C2WWHbp0+CkGAGsDqIgGRdYXFGoFyXtI3CdfcYSX5cT
	 wf9JCuli58EUMcqh1qiaLhATLzQSib7tNcwkt4Yo7ywQIByjrVUwb3M5PdDcZKc9aSBET
	 Q4i8hsst0O1qiMf/H7+IjZhBHJ31QbWXMR3gQFGv3oIx7fJ9DbuCr2dqKKojh7B8MRUhZ
	 69wYL4RZ63PYAAPUS1rbD6wdgQDBJLu0Bl6HoiUcAb8GIhzcG2Sg1rjv/rmvmeVFl6UlH
	 LypyPLoRPwb3gyaxCpK+YRXW9/j/GIVSS3jwC3addKkNHy9UFc3h2ymkfg2iVQHE+UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="hFH/5CqY";
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A13660A260D;
	Fri, 20 Nov 2026 08:04:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A13660A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=hFH/5CqY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CMckLEw8p/4XoyKuw4lKkcH9bPxFY/IRI3daE8cb7jA=; t=1795161872; x=1796025872; 
	b=hFH/5CqYrS14Wc9zxwrGNoxfiG8iIw24mrOkukRuAhp6ic5bIRtIqweThnldk95HcCJ6XUbzVG0
	13Awgz8XkPVubKihIZxwZAg5E/AQXiu8SuZ4rY3xXSWtlBvfQeN1EFGalNt/74PCoUlzOKC2WbRBa
	REOzbBX78VkF4XZCezK4NfToCazqkIg1v+/VwtW8zbg/SWALtn8DNevAzUg2u5cf7CVUPGzT1LmDZ
	UJ/0gI3/V0H/XOTLga4kaw0myM6W0S6n4KMdvgkZ+ij15Fpjbnl6HVVQ6oVwThSiBLkDDpIs4ov9U
	NSPeP0QiU8e0vHlXr8P2O/iZsA9/iDgMhoGA==;
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
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
Date: Fri, 20 Nov 2026 07:55:35 +0000
Message-ID: <20261120075538.27281-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120055200.707545519@linuxfoundation.org>
References: <20261120055200.707545519@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.193-rc2-02817-g576eefd25e0a #1 SMP PREEMPT_DYNAMIC Fri Nov 20 07:35:30 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
