Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B3391E7C
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 01:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018070; cv=none; b=AcZzn/T0z+CA5kqpDe3aN59n8gCk5aqoJqjsPi7hqk6h0ywvt3t+QWd0GTGy+kCkUGkx3dhWOvcRIMIP5gCBBSsaX/AxRI/lYrPekB7eaIS4fpBpJ5z22qWvFxyLPR/zWqf0TQejtzup3VbK337SZQ3T9D+Sf2YuIFX9MMa+tD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018070; c=relaxed/simple;
	bh=1Mmjf8XmWqCbcLWeakoMZYc6KYsrB7yE+pMr1yyJtUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kGGgjrZHqZYZp83i3sm5p8VsRmXVz+WEOzYa9TGTndJHG7lvCp5hLUT/4bx0VGrBsYWv9jh8RLc6Hy0mptZS9uTC/d39XC8drvZg+sNpmpLDz5PUgcXnAf4JV17KqkJsZ03YrmfiqkFCjMpumaCmGt0+6i+584/Le22pfVeBdtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dWVVEENd; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dWVVEENd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787018034;
	bh=ErZG5FUYtEr7+4AWMo2fsb7dx742uhvfXbRl41KcURw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=dWVVEENdE6RaASZUmh6yQ2bNDbY+ldnWcuACw7ybgK+CnM04/kjb8D73tZhAegQV5
	 gvE5fmkz7cZxCz9hmr1iY/MeSoJxde7nbr15mS4VTgCnQX5Hgpq0O9xeJB0w0OzdC2
	 VTkCweuhgcC+iARybSe5Rlu+G8sRPZBelJYj2e0Q=
X-QQ-mid: esmtpsz17t1787018028t44f0a510
X-QQ-Originating-IP: qnmYM8sBksGvulo0VUPuUig7ogs1i7owAfdEehjvh9U=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 18 Aug 2026 09:53:44 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12254403041516689430
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
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Date: Tue, 18 Aug 2026 09:53:42 +0800
Message-Id: <20260818015342.2756394-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: No4GWyI4cWt6QtacbaOX9e8RxzgwtqWuE4IAbn+EneWSK/3Tf9SjZK4l
	xB3V3tWBCJ3QGSVZo5xOe6urnprhsdM9K3Tvra4NAOGFbMZd7dem++QjBV6w/wDLrdm55kH
	h4X6rLz6zuyakEl62oKI3efLBPsJFJBHprllK6dGIhIPIalBy5AfJu0dARfkcQvKR2VLzI9
	5XdNrmkucMxd74eXPrOYjXLB+Ngbkq/pAyp/l3sKjdV4Ckm5BOlxA73NqJKpvCWlomd3PeW
	FnybckJFaqUVw9QrVIks+gDWZD4rKVUqDtH98iEhU5Ec0rJljaCrd7soooET8/lwKTObltR
	lIBseRS3KXawz+is7gcrae3uf3H4KTFFfsKOaqEyt6POjIonq4wHnGG1N9E/sn7FGqM4Cks
	mXQ6lWTdhAFkbrNPUTf/k8pjlCnxen2OeO413o3zZvg+8rYnuvzFHjqO1xitawopz2QxFP9
	amM6QIOlHnVP17SYVD5/U8E/sz7YHqWkm8u00ogckhNbYyKh3v7kH8UU/55UVOpkbU8sVZt
	tPngI32c2Q4tArKm5sHQRIlMWqlrY02f5sftyTwMbTLqfNEjogFeZItlxwjRKRHkThNXGmO
	z4HuN040pOSHVOFWNqTEf/SfYjPhAKIpYuP7kowhTFtPVigUbLA1TuSI34x90kvkxmbSXRX
	0NUOAeKBoZBpQpsYYsbOdZN2oGCMCPUNNamxd7VoDKynUUeMWLAwRj2bUA7VSqAsh9gqHCA
	uKrOHw+UiFyrShNA98fg80mx21/dKii6V9qpgIx/MDxLBB04Aw8QJ/Wn3VJcIlrHKvOX/0x
	8R1LSW6PU3N1+WcmxQc0vgswho0IfGrl8ELNtmIez39vkc6gmqT6J+MTiUPEdmwOzWmuqvO
	3DPBn3UOW6nZBf75wXzLBDToRbfUap4KdMeicjiyqC4P/t4GFuHBPbb2VN8z/CPstUpjwZD
	ruvgAQAvP7TkLIq4PrKCo5ImwbPdNLI6LEQqYNI4eOSuK1pWTTivcYMKx3uQmSTzQPUuI4k
	YFLf3Qdk+4ZI5cC8MBa+InA2Jo7Go16nepKk/JIiuADk/BrzOxtw9+TINHJks=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.152-rc1-arm64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.152-rc1-arm64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Tue Aug 18 02:58:25 CST 2026
Linux version 6.6.152-rc1-loong64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.152-rc1-loong64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Tue Aug 18 03:15:28 CST 2026
Linux version 6.6.152-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP 
Linux version 6.6.152-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Tue Aug 18 03:31:15 CST 2026
Linux version 6.6.152-rc1-amd64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.6.152-rc1-amd64-desktop-hwe-g9a239823f9ad (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Aug 18 02:40:05 CST 2026

