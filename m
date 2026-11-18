Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021152;
	b=ttTfYdyA3yOCq5ISP9hPyl3mBYhFejftPn4M/3XW9K1eK1hb7BR2sf2JTcBBZuRo/F9o
	 yqJoRQ14uVpDxuTu0scCAEUbeoEBgLZ5EMuWFpSGLpGdA1gKGl//iLRWvpJGd5EeSCF9C
	 dRVkGfLB0j58jb3Jn1Rfo/XsxxHJw1iPLSApyoyxUsY6CUJ2RUBuCJ+Rb4KVBVsZJnZCj
	 GV+X+aFqV8pZFFytHsXQG9qT6y3Bt9OoU+q7DAgDlH2L1nNCdDmsnJAtATXg6XmFzj2L0
	 JHUe3JgxhRSv/ty0KuCxrpjvKZi7kCdMBUtk4ZvpP8HwOzqzZN9hBSqQK0WNfruXZ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021152;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SD/1BiZSr649hJTWcE3WV/i/WGSjOu8azJE0/6ze5To=;
	b=SDnTCslJhgBXOQ7JXW3CpizaDId/v+aPRFADUXTVfeD/F8wNRjf9L/K9c5YTgGOXBCST
	 IAz3rL12dLoAilUSaebdobqzL27Fq3JQPB8uo7Bj5o66+LGlNhUG2EXjLDynAbnxinBLm
	 zW1COhVDhMyfRXezI9Rnlq7thqRkb3Rm9JuafrS9x1TK3uRtVL8eWw6lG4m8ZJsTGKQA8
	 2/e7p4f3yNibe/FsSriYMCh3q/IK6YaBmoZza+Fgnu6eKMahK9ndYSux171CfPmME6xum
	 e/2V6WEL8ajBQJDD+sx8cs5iujhs1YgaB/zmK011gOtaJ9aB4gMEIKXojiViSjKZLlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=BilWqDLo;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF275606A31C;
	Wed, 18 Nov 2026 16:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF275606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=BilWqDLo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SD/1BiZSr649hJTWcE3WV/i/WGSjOu8azJE0/6ze5To=; t=1795021151; x=1795885151; 
	b=BilWqDLo+tvtyQMcazx1h9g4H5ZQYgJDxps1c3GoOQKyw3LxRvSLmQp3qvp7X+wCseogao6CYOS
	I/d7t9W8egRlUqssAGw6YVq/H1gC0WR6Q5Qwgx/BR8D6snBwwFqUUEx6N0HQ1iTQ3qtXZ9XWE07lb
	RyW9+jiXX97CbKHjbNYvdhSmdtYhXjVArlRx/3JKZF2IUyoOt9J+OWdsYLjKD/IJdPB5On2uf7vLB
	mW0QUPkFU5+6fN1L/fld3HaDK4Twry5TPH3pjrqidjOoyd8ruWK6Fw3HYwHqb+qkgw2//qpF+yyye
	39J7dTpMwjwvTZli0aswuFp0Aj6fjwK7vUuw==;
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Date: Wed, 18 Nov 2026 16:59:02 +0000
Message-ID: <20261118165904.35638-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.65-rc1-gb8cc618d685d #1 SMP PREEMPT_DYNAMIC Wed Nov 18 16:50:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
