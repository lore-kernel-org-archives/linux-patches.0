Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.254.200.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795077750;
	b=UeMleXB2yLVDRk1FIyNvvmapPlcQaIcHv7SwIaAp5aTBcniQsRgaHtgGBEReWVFe1CDf
	 SrQAhCdnLCCtNxIqwyetz3+d9Px7KfSS8SVhMPlT0SxSWQPnYnGmZx4fu1Ziewr6ne7um
	 Zm8PEypEn2e8RlTaw+Lj9fPEbEphouvyQH+qWnll/Q8KsYn2VrFv5nC9DyXIc6beUfUfM
	 upIdGpJqgsoiAUCfjshy7bX1mC0P38JnCcp4fhmKnPWZY5t8Mko5XtkHOvO+ePEkMjeaL
	 PgJHqqZN0BoNIbUxTAB56oHCbLFceeYOxqQGY7P/qzoBHJ1WMoGjh92uUMSm3SI9KDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795077750;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=lpvUcFdcfCKRwb5Cx+YbGLdBgQjkCAW3ss4qQgjYQB4=;
	b=azWjIA8kR0cPP9FyMvg8MuDQb5JFyhH0R/rakbDkKtyNc6EtsxSygkdIKHKPUrZtU/ai
	 emUo0gtNR+mn8emqVQ2Dz33mhhyIFvhtjmwmhBkSMMXx9yRCMmHt98oBmg/DNzztKov9x
	 LLfNKG2sBNiSWFDUHTB0uGXeALTH3ilK30iKza7frHqrv57oeLUtdPTimucrVpZBzx24v
	 zCOz3ADQwksP6U+QRwn8CYeCJjw5TcpRwUW/CjdI2xdkZiUbyxPfHoBrf+/yeh1ybaHGe
	 Vq5Aa77Yz+6pfaPdM6dGw3MIlDkYRQe6sCYNinO+DuqIf4J4A3VK3ezF/oN0aHjw+xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=XafYExIt;
	arc=none smtp.remote-ip=54.254.200.92
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE6606A320
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 08:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14EE6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=XafYExIt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795077731;
	bh=lpvUcFdcfCKRwb5Cx+YbGLdBgQjkCAW3ss4qQgjYQB4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=XafYExItyLcBwW0O5vejKgHPbUm5NBGKPk0amrKMWZeu6e3jt7oG4eJEMMZSyDtzR
	 XK4eXhOGsSzaxuXe1exmuJQF/9s9bNYkje19Apj1Y5SK4NU/8Yvcbbg31y0I3vjWUN
	 GKSg5YI2g60Olse0SkRlS2ACzYMDfvyZylCiGZ30=
X-QQ-mid: esmtpgz12t1795077725t62f63861
X-QQ-Originating-IP: bDs//Vc7rTiHiET7Hjj4zCytEBia8xXCEiZKxUC1xs8=
Received: from localhost.localdomain ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 19 Nov 2026 16:41:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11313103928963220471
EX-QQ-RecipientCnt: 21
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Date: Thu, 19 Nov 2026 16:41:13 +0800
Message-ID: <310E160BE2CF5E67+20261119084112.3616604-2-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.47.3
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
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M/ESU50hZOEX1dufSpouXcCbrwQ3ditX3iPeFtGsSinWzIl7JI9uGwmt
	ef2FOdbzvLRmU/bipLEq2VYlfz2dkDAq3s3dcsm1nTPxtd/zCTbszsDp9lBsePY4vWPLtpn
	RczUytMmQzmS3QZRdTQsoZI2tieAHfrQAPw78bgAKVHq1Z2S4qV5Xn2eXUC0F6VV4DHZ4VP
	Mp8OuEOpM3dSluGyAyQ1Ewm9l7vU4XJBW1x4T7jrKknI1q1XcEU8xhqr2Uoai+pQBB6uy/b
	h9EFTSrcFNDXaA4MNaVg3EAl0tu8p6fpCxy2mR/df3q60T+fwQGJNiP1tBs6dACh+rqOoAm
	fLdhHeqRIpeEaSNYEYml+4xi0gOgaWpQshwymjXa7grkZFe/592HSjva6muGpCfDXWyhW3M
	v4Aj9EBStNo7J1LXfvzKB+g6AsK+p0epm8illUWheqx3C+CqaioLM1bprIXrjIVfimBR58u
	J0NNYQ0ro6EmpvWaqBPs/S+dAhbJwvw1zHkfA6zwoutnKWCZVDtxzdXQ1pVIiTZOkOSagDy
	5PbtCkgGCyB22fo0HZzgey8ZeFoWgidqmtVs/3hLhLXi/yUpAabq/rXKgRMwoSDVEjfGjxh
	Q+SsPd6lD6cZ+vwDsSmj/Q81nIu8tXHmSVRBDWpmZINSQGK+f94nmfOPRCZuzcedhorzPVr
	LztQhO3vfOvt7IzY3sLkT0NaXt4aYS/RY7izLsNAPUFSjbj42SHn2torkdZkIq6Jhbx7q2Q
	nJk0wDS0mrK2AfBs8xgqFVrP+WwYyIZO6dNq7fwEUClxoMxVwg85DmZZu7tZ4hqbUwagyuP
	lqAidc8Tl1uMGL2mYUyXfep8+vCgHlfjExpPU2C4NeLv+sBhlyPK8/JXXQNpWP+MTG7jc6q
	tWbo+RhJOLa9V4FvcZiDFbL2XlBV6xDPGFfX9Sy1mhvavwuIg8nzPdgqe9hWrs3BNnUI4UO
	XRa/3Ft1KLpBoiZyMvlbSaRxQTruJG1FflqFtEgEHv3DQ+2I9bZbOS+hACWrrojGDfcozr/
	QtM/jvYIlVaLlYU4LSOImiR+RzDmwhu+dfR+1Y5cTSgEYJXWGAS6V0HmMK0Uf1FLuORKUN4
	UQtYB9AMNUZ
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.65-rc1-gb8cc618d685d (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Thu Nov 19 15:59:55 CST 2026
Linux version 6.18.65-rc1-gb8cc618d685d (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu Nov 19 16:17:18 CST 2026
Linux version 6.18.65-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu Nov 19 16:34:22 CST 2026
Linux version 6.18.65-rc1-gb8cc618d685d (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu Nov 19 15:39:59 CST 2026

