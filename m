Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC337107C
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774346106; cv=none; b=EeZaztXSZ8CAnjnblAiLImjgfQffXrwLh9vi/u4WDn1YyffEVE2CYr9Ngq8oZXI4HJCs4dBqetcCM1G6+XPDKOLpFh7cMTD8mLIzlFlRDtl6caijCpaoI9JLM957XUSBVKdpc71y3w1QOHRXIcL/46gITO3Ooy0XtzMVvOqHsoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774346106; c=relaxed/simple;
	bh=LHZ0YYG/lxTn5zqYyd73AUc1BmmDqhxQw03YicpffUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWmWoeWx7Uu+M00EGIkh2UK9A4yl5QLev4AT8ysbaSDorFy/ROvGc7zuXumtOWcIPAt7utNNSrAq6Uog3W9nRjARKehJCyL4kv+bOgE4fN1TUKZWDVr02XvO/f1CDL1/0/r29t6LeQpzmn1T8Cb5EvPBTsp/EMeMCaNJQlVqV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=okQXqjQ7; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="okQXqjQ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1774346086;
	bh=UIoch42Y6pGyIidacBJRSmhpuNOWZOSUEtIFTmwuRM8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=okQXqjQ7wqCFNigV0a5RAm0zCAYXIK5wS4aXzRVVLoSt62ItVkB4aoCBxxMkoeT0l
	 gyDdJpJrTWVlF2kFxFq6zxv6jXyGjmj0Ef+d+wkv6e9P4VQAs5ZX/wl+ebaZOVP7R3
	 uA8zWqpxUDGKKQzABuTspy7Jaywv96oq6oyRPtSM=
X-QQ-mid: zesmtpip4t1774346080t0d1a2ff5
X-QQ-Originating-IP: 9t2R4NY0v4jle8e+c/cpfuzUqd30oXgmgWCzR8W5eOo=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Mar 2026 17:54:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13148438825957856425
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
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
Date: Tue, 24 Mar 2026 17:53:44 +0800
Message-Id: <20260324095344.565151-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OdYC5Mx+c6F+hvigkUQvjMiTNhUaBO0e+8uOEam+Uv/aKfBySu0frlPk
	kgw567wz6jKNIS+Ne2iGvIce81A+K3t2joKA0MLm+Xtpw3p60ZK5mF9aMQgMYW58+vESbbJ
	uHXrcIbXyJCbCR/BmCImYSMsMDuBBJFjThKBGfScjkRN2rrvkxzDGY2XxpcUROPzWMZAvMV
	I/WFG9pPSwFMKX2GKicleAHHAsdtuio7aFX3Nm4WABJoj9urT5Sr3eO1GDfBLX4C3Rq+UvZ
	5EEiVc2Ldln2VLqi22RnJCLA6lloGGuLTRLN4j7xmcBH+QchQ4lOLEp3nMThcbo/yuRgDe8
	ONxfFw+LPwXR/3vMEJFaOlKn21DUo6MVClDJHZAqEzU6iQVWIdGIq+FYYSfgWAmsJitmzXr
	YqXyrifdYBXyAt0KF+9yffD5MXn5agrZACs1K5TsvYHjklVpPjt9Ap67fOOQK/rN0M9uKwE
	XLwWdeFI2yyacqh/zCJMr0PlHyzj6RPHKQ1P7CakmIJLc+v0KF4CsQ0cZj611ewaBcE/CN4
	2NcTLCllIlgRflj4Teq+AbOvUulnlnixdYhPhhpMzBwmko0cZ2fuyUNinVfPFxdz/ZHngl5
	+zL5XJYmxlubI0EdWGjlvxnB2+1i9ftNEXLtUTOmRk5Ujiv6dBbg+OGKrvOStcZOgjBv4Jn
	1ejbd5qRxifgjNBSU5Oy8V1HVZeELyamIDUMabVa6UTbnc1OyjuscRFuKmUoDboV3sBSspA
	fVxt8wK488xt5UjzDCBF4y9n2/NCPHAmOzRHW0sbX/oRUUBW9eDqbOUg/KBRac8B1znoWWX
	zhNew+NZydpX7mCfm6JkEgRscqBbuh7DAx+ScfTDFhiMn5q+t+HqGW4bQq4noXtLEwjmED8
	yPh6GBMN80jrk0M5pvyVRF84BQEs4AWrPlHjccP6UWpFZ6BDyA8i7yws8adKvTeV1B3thmA
	x3IVflrOso4E03JRCxAQ0k6Jvlp27Fv1x7Pj3QkP1Gsp7u58UFzYR9gD5jLUdBa+GuNpXuH
	88oPRa0vQ/TRZcB0Soo3+HWXF9ZD+aLXYaxwMOZm60Ar/EMKr+S3tigWnikpYjrw9th0N4C
	Q==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch config without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/1768e5fc7f76e59c7c97a4b0f56f4adc

Log:
strings vmlinux-* | grep "Linux version 6.18.20-rc1"
Linux version 6.18.20-rc1-g81b464548274 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.20-rc1-g81b464548274 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Mar 24 16:11:27 CST 2026
Linux version 6.18.20-rc1-loong64-desktop-hwe-g81b464548274 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.20-rc1-loong64-desktop-hwe-g81b464548274 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Tue Mar 24 16:36:27 CST 2026
Linux version 6.18.20-rc1-g81b464548274-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.20-rc1-g81b464548274-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC Tue Mar 24 11:42:37 CST 2026

