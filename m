Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625144;
	b=DJqwBvWnn1ozQ0QscB7jHH70bPAvZ0+Zs/jJ7uxoZzRUzdUd/M8J+eUozTDndFTO1mUB
	 wl0KemQQIvU8qNqJWuouVp92WE21CgSA/n41JVr82hSzhYt8i3ZPTgEmho4DgSFOPYUIn
	 ysuYEWk2ML5SSh5TMBs/o2eiamf5U8C5oeQ+ULB+dlY81m4oCkGcmQ9k0ZoUxjxqtesk0
	 raR8/3XJAkQy4yc11Yu+shuVFOABdIjJTU7GAtQX8riO0OchXrO/p2PhnXCvRUfujeiso
	 3vFkvy32NMGVIitVkfxI+bBxT8TR6tHr1KjkhY2H8fJ3vYLvCySzSE8MFjhMWKrhitw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625144;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vC74YOAPrBcAC9LMP7HaSPzA4IqP9flaTn0o7gnLByI=;
	b=fLxN/OThD0sGIEFD8FRhFWlcrmOXufR/v7u0EFx53bbHyOC2WcsKDTrd0Mc7yHI1o8N7
	 Zhsta2L7fzopPESHqKG7//ML+3LPvjPlBJ68YQxAUXTkfzbB3L3VYGutuzEw55HMUQ7rj
	 4Cmlb400KqC7vw+pJhFvvsHK1YHCSfwy4YV31Hq6r1AhXxZzTPc+xxUPr4J7KtD2z2IPD
	 mhhFG38DhyEmBT6L1W/xLA7826X3/yxPEme3ZLXrawdH1PYQN33RaSwXbn0eXRR/6CzNK
	 xdzFqsRma8Tnoiq2AAF/DQWm5MKr/UWN7YjIXKA6q7SgmbLE4+vqU/NHs1QZSzHIt4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="Z/Vehjjv";
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28C606A6A2;
	Wed, 25 Nov 2026 16:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA28C606A6A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Z/Vehjjv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vC74YOAPrBcAC9LMP7HaSPzA4IqP9flaTn0o7gnLByI=; t=1795625143; x=1796489143; 
	b=Z/VehjjvbV6ckWi/Dd6idtHC80NSqO9NXHnQfa44KrW2M1x82RnVInJ3Q9vHa/ykq6TR48F8Bkx
	KnBMpwcogTd4NH22MOk3yOP52qq+wSXQkyZnXBFyWZSS1trzLeQ5r3WufX5AdUyXNrKHYwH+CsIVk
	rNPyFgp0D9OVMOGaqBKnkbZOkCo67h8LO3A/CJIPGRZv5mgENIBpsJvIE6cxFXtmZW96nUm9edGGL
	A+P5NrknY7PfG9p5l3ZjdlqZLFJZz4v/E1ySoSiEiatN8M22Fk76Rw025Q+gKW35O4ZOTEVfIVA69
	C3kQLoCWk41hAgqyPzuJ9RkN8fL8FOlAleoQ==;
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
Subject: Re: [PATCH 7.3 0000/1005] 7.3.7-rc1 review
Date: Wed, 25 Nov 2026 16:36:52 +0000
Message-ID: <20261125163654.740362-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.3.7-rc1-g7f248ec61cf1 #1 SMP PREEMPT_DYNAMIC Wed Nov 25 15:12:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
