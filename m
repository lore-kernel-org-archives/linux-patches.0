Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076DB4334C4
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 07:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926339; cv=none; b=gt3d/aI4KNKHsYLTF1U+lQtcd4UJ8KPZ863+FVSqvPNlVHCD1XoEPjmqRrcvCVxhVWHFHVLCDc/F/pIP3IeyzI4lqet2pUV9OCwhVuN3qj285qvMNHGkCWOerJvUhkIblluWaiicO1Em9QyhHava+p/BjE3bflYgHAWHTbN/wFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926339; c=relaxed/simple;
	bh=JaIrGRn+dc3SU5I7ef66KPmThq2h4KZ9xqHy9WuSmPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jLW0Wrx1N5azBEHn3vCi0KYkLLeCuLTU3jwqxH02C2shwspcUlP36Dr8g3MeSPaVkB629yyf8HFj0rd1VNQUXG0kL6V8EDmU903huX+fy8MoatZCYQXp0lH3WDmlwsvbn4nanthefGZf9dmbCgC4g5zEpG8W2oaIrgU+um8goRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=i5OQZ1Se; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="i5OQZ1Se"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790926299;
	bh=MKwdc3fa8Xx/fZuT9P6B93RFXHRcugDqtBhRwBo+4hI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=i5OQZ1Se3wAgnbJdLXDqTseM2FwFFcopKx3/L7gTAUZ1gnMLPXMXDyvSBXWUsBvAb
	 cZiI+LbDcPjzpRuE4MYn9KHDaAsBC8uc30xi5Khde0euYi+gGlJCNHLhBr64WU+nFC
	 8J4fKGxswnWGWTgKJuvipfVGrGCZoEdbz3ZtJji0=
X-QQ-mid: zesmtpgz5t1790926293t19690268
X-QQ-Originating-IP: deEPAhm/oRfQt1NYQ7Ht7TFpBDx/0s65Z0YGDulpVSY=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 02 Oct 2026 15:31:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2341451882088617699
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
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
Date: Fri,  2 Oct 2026 15:31:23 +0800
Message-Id: <20261002073123.722005-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Metm1JyOfdirPbrC3a6eXnaNx5KnPXTXZhrjCOn0ZWY/LivK7sGi0Dix
	uQ2088FiDSfDn8016cPxpccS5ifyiLHi83IQm8jyipdA24H7LUeFRHuCQUIt3+DvcOEXI+F
	vzW6x43t//IcY9UIUxNQlFHSNYk1AnLd3sZdwJGbIpgOunP/BiTH/frMNIJPaTLABTHKlkB
	HNpdL5P59Mo+O9D425MtHN2jsrxQx54TWdvKf1yMSdRXsEdjpE+4y0YRiztHYUp6l0RZtav
	qgv6Kz7nnemuPindNyhUyx02WourEitf15JZtgRzkP7Pnay6TahjdN0LDPh/ekKbJaSmI3A
	/C2Pmg7sh90zx/SnJQYjGz9+bt092tYj8cywYaHtLDy7roz37rMvMbR3goqZBHHS4oMEFWW
	EzvluiXfiHkBIYtkqJC+SqGWkewRNoFjdJOAkCbHzzcxHti7BwilPWRadO/ia0Vf6XpGcl6
	L2qaxqUfjUc7V2xaKT5gkLw6jTWxIS5TuDlF1kF98WkPMMODTMaKC9deX6DMduDUJI2xGWA
	imwLWwNoeWdly/WuSkWhmKEp6L7BWs7+nk/I5wou+V+PPTBbkllKnpqsMWLzDKvjgR1IRoO
	vuHzXQu0te6MCLm2kP33oa9y4d975gJ/IRNT/cm6LCD7B6ixowT7yA1FGe8xK3Qytc0W2Ju
	jnfmnTcZTYBz/qO37fCHAsRTew35hW1k7agCPp1QzmjR9G6A/DQTw3tY1ROoevX/4VGPU7Q
	j7GoGjHgvbWzqshT7u96mE4M9iq3xZob/y6lV6I/jH2Jt/MjCxI5dm3om+pZb0o5vJcxKvZ
	6sXtVtYs+Py5JiYaaULNLg5JgHnO9/Sup/Jxyi1knHkX4Mmc+XmcXNT3/SoTroRnJDjfQW9
	K0AWCo4tDwTV4B8aeQefu30idINIYrqTQGXhGeDIzijeEL7uuOuqKNiHuL1JL3vOuVbAmtN
	OTlM4NU3E3YK3+WUhvO7AEt/V+rKGuhT4iX4K5MBba61FyRIygHk4gQSwUzuQHtibzLhEKk
	2aQIteFrFIAmPYvNPLTv3s7lSc+PxYI8FT+KvYJVwuDfRb0kYLdHRYdDMMcXR1+F1tzsur6
	yIB8J8KqJOrrGb9L/vdShrKLL3kz6EhpeyO5WcTODQ5uNX/qQNybZWyzLTtJo6BYw==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv64 config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

log:
Linux version 6.6.158-rc1-arm64-desktop-hwe-gc96fc22d8d29 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Fri Oct  2 05:12:51 CST 2026
Linux version 6.6.158-rc1-loong64-desktop-hwe-gc96fc22d8d29 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Fri Oct  2 05:31:55 CST 2026
Linux version 6.6.158-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Fri Oct  2 05:50:16 CST 2026
Linux version 6.6.158-rc1-amd64-desktop-hwe-gc96fc22d8d29 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Oct  2 04:54:09 CST 2026

