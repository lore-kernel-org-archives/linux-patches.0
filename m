Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161889;
	b=jwn5WRw/BFYuf4S2iTq24vOgIz4JabukzP6NTYkR7T1IwlZqFWzGlp/hRWZ1nU6AIVvP
	 0d4dOnaFSvfkOZkddau1qfYuq7eiHYjEHWO0NDRiKSYJ2Sfk4+O/C0VK6z3OMX3Ej9wo5
	 Md6XZ4+r7Os4G3EKJKAC1V5CZVP9AAgJC58IHFEzjAAapmkWgy9ZHKvD21F+abHo+cl5+
	 oIQwAeVQMVOG0nmMPdNMDzlWuVaZ/Uc4T7ilh6P5WhHHcGgbMD6YXUGToxYKEEnp6z3n7
	 wu67D+xpzL8L57F74cQbskwCmjo16Fwo+5PHlmFuDcswz3dNOT5IUj0nOdg0zKz35CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161889;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IbOtfEUBoZrJqYfpt5d7UyLYdr2/aYU79G497f8pCYc=;
	b=30gIaGZNXZOdZPhrvtwiSbdyDDcFvUII8kC0uMOVICaSgir8tJ/+/Se/iGJPI6KNMZ76
	 7EAsSKYTevXNqcEWB2sxPFgdi1M3JlusXi8qXtBeJr4x3nujeltEbA/dztRJKr1Pqidc9
	 fsv3iUHIjkHtk+X8cTEAU/ZpANavzCDC7/mzrl7gmRMzPoSkccAHfgrmh8ZTxaQDuqwbg
	 Y8b4Vv0qmsrTlyHPZN43z7pXndeySYv49+vGm1LyBOB4SDtncpGPQgiAtNRW5sFAV5K+f
	 93DTIz9STmwmmyfEjf99emIobSye6kux9eR5SGWvVrXwE+CLWQWdl52T4FRbl3L4d0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=MtF+edYu;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A8606A32C;
	Fri, 20 Nov 2026 08:04:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 348A8606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=MtF+edYu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IbOtfEUBoZrJqYfpt5d7UyLYdr2/aYU79G497f8pCYc=; t=1795161888; x=1796025888; 
	b=MtF+edYuMCeI0FiJmdKlp5xCvnl0xGJRrU1+AjgpM40fuTQ9gh1wxB0FW0UwLpgW6NAEC8fr8Cx
	7j4xc35B12LQVhK3r9wevcS1PAaTJ8lOwkRBhDUpe38Eynb+BwaLleryVKKI6B3g6qnhJU7cTn2Lr
	+G0H/0gKF1ElBGRuA73Lqq57OoZnX1Z8nxY/MEymNjyqt7piNtaKfqWsSpDjhApKH42ne02PmuI+H
	MbY8WktXrdGeaeq32IN2fimmdPWPdipTRncT8nvZiq6p5L6P2Z4PoXxsyuqJPyN7cyD1L/zKYPQ5c
	J6LD7p/86c/iDfaB6VG7Q8CRpjxkHkzAAAQQ==;
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Date: Fri, 20 Nov 2026 07:55:51 +0000
Message-ID: <20261120075553.27436-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
References: <20261120055248.913352689@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.6-rc2-gd6a022cc5dc8 #1 SMP PREEMPT_DYNAMIC Fri Nov 20 07:53:30 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
