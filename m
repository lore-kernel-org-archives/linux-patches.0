Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64F3D47B4
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195760; cv=none; b=D+b8w91De7S6EQrPN6H6Ps2DZsKH1HaTHaSE1HdRA2J+Z+lSi2s4acKxqncERyh/3l0cfySLfWKfsMUL+iU+ktxsBjfBYOxaKGieNsIjuojmUycf4gcwcNFrGlsHwhT8kTY5ZoCLhV0DTAUZxm+yyCuxhYtysM7tkM58aBQYEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195760; c=relaxed/simple;
	bh=BaABlxggLMZzgS/KXVgnrNLnp21C2gp9jNxbzD990jg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OU2R9UPLEpWqPNFQicP4GKviDsJKAhnlQdJ/hHhR+e1mJhdA8MsZDInVckPwe21yobgi9JJOVVTHQlYDsTIlliD2x1zi95E+h+GtYbpXP57/9FWAyfgK0n+ZJBr+DbfGAoD4Lej0ATI1rnX2wMlvLY0nVKsXq260EuuCoK3Pz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=O5TBCbXr; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="O5TBCbXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788195733;
	bh=cRWp6rE6+iSZYDooVR19JCEDuPops+QtHdtTxPGhOxA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=O5TBCbXrgGQ36adAsraS2UXVXy/9fyFQLGJMEQMqRUCXTwcCOY6dsU3BX0qsqf654
	 QrY/JecfcwRfqkvS/INnIRKqyJPapioMgO2rOTWvToTQHdzAHzgVeqsH3SlTJNK7JE
	 lp6CyZBy1X2Vfl8t+UF07KYNtW0AnXks80OIa7Oc=
X-QQ-mid: esmtpsz20t1788195727t89f28530
X-QQ-Originating-IP: ZRgqizws9JxGfhks9sC3a4p6dV2Vwc4A9ulyPLuItas=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 01 Sep 2026 01:02:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10943433325430212063
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
Subject: Re: [PATCH 6.18 00/83] 6.18.49-rc1 review
Date: Tue,  1 Sep 2026 01:02:00 +0800
Message-Id: <20260831170200.709901-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NOIkHYnr7VzdkL58UGilhGhRX9W4nderSzANfZUR+D22EiMryKmqRfWz
	x27MqoO8tX/hhkk1/ORiwzeM/3bwWneWQ7fLCGk/S0ccd83xALMS3O0rxOUtEVrEXcFCtdm
	xzWwZJGmorudcPjrTAgP+mFPBLq0ObkqR3BN4pjJCUKvz8QQJxwbhu7nFKkwDCA16pthHG4
	7Jt24dYOTCaNrlksQLEB45c8rtXKyfOhxD9Ist9DKCjC0ZXv0iS5+Y/H6j9FOi8h62+uU1V
	LSBHlnYeWJ1jkuFPGAir+KmX/VUkNNOwRkha7kqPYitilGwrgZyjHiSyaypCeafMcUy7OQS
	znXRdWexNlKXXjr9nxHVVa5lgFrU1JqEMj3ztU7V/ZDTt52pi4d7cTyCk0zEqtMyiz8NEVo
	BKZXXa0p3fePrKpAqaC4taidnhO/PuzYQVsxdZ+f9vxDtUPEDpMR7h4sOqxtUGG/upCZ6no
	gLVps+aKN2EXkUfFREnAbEU9D4zTurML+Uvmsq4vPoe6bUwEyOcKKbpvcFWzs35R04FjYL9
	sreKeuh9sR0KgfOUYRxE78JuHkNGYd3qOOnV1SKqPFYd+LOsDoBpcSQWUaZakIDw9Ta5Hxa
	dgH+9o3EJZ7BeWu2onzV6ZBPNLRbuhkPx4Yj6eD7Ddjm7lItpYLMvt0xtWzYPH5f24l65xr
	deaL2KkCJLsxJ1/WUNO2YZaUAozKFZqT35eMM29QKNH+i6f1Exb0ZzXQrgyIN43mU5TiQ8y
	CHCgwNq9KxHnuGTapZ4Bif1a5eFaDSTxbQA4ENS2jKrpFacQb1v1INJlugDevx4APT9G9MP
	DF959kddep5c9b9bgUxXJ9OaWm+978Dzk4OUYHzQ/5/mF/ypLSbczSt/hvB5lpmFbq2wj6p
	K1rqCWA786SfkGznnJTe7H8h9ymo9csw9TkwMYHNosUIYiplKP5g3/5ZLF+hOBDvyfDjtiM
	jaNQQxdqPBFeJ04KrKWqp/535mnefbRNSESHc+LlCHgqhYmWjOb/cja7mKlmsIuLg0MQv+T
	YbYOyYpsTX+7ZihsY82/Lt+atQC9ALmvThVABD2ANS8+4M4qGxWutT8vKOhCU=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Tue Sep  1 00:20:48 CST 2026
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Tue Sep  1 00:37:39 CST 2026
Linux version 6.18.49-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.49-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Tue Sep  1 00:54:32 CST 2026
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.49-rc1-g52d189f2c6b3 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Mon Aug 31 23:58:15 CST 2026

