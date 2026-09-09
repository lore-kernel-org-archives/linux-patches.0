Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A9D2F0661
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 19:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788983533; cv=none; b=dvsGfkvTYaRwJbNZju8Pr0x4n1OZbAXckG7DCNnbEGHZjXQVHHmv6K9fOvqmF1TMf4fVV6VIMZY+nSn/Tn/UveBRUa9rBFIsfOktqUOuKZO1yVqMfZZS6ILgv2GtVdF3si1aRzm2Ay/XP9D7XafoqpJFoBGwnV+9ssmsveon6tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788983533; c=relaxed/simple;
	bh=847sgO0ksGozPNuXNxnF4btPlgQ7SR2Ukr2n2buyng0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hqFy4sGuC5DQRfXwuALg4UpZgjprcdlZdIbJDkeiNDIJMqYTJwr8eLc37wTEUrsXSkMkAhvqTpeunucYVl+xis/YQcw+/dSATfP8hVEqW1T9tqyKU2ppAaq5+nfXv50JxYmf3jdTHOywDT1Jz9XrNzpGHMaqmgSIxqcQbOP+Juo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=gMcWiQ/Z; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="gMcWiQ/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788983504;
	bh=w+e0CFCNccox73yGiNG/BFtBobIPS+RYstEA96SzeSs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=gMcWiQ/ZKsJ+Hyjs/xh5kqVDBWzfj3I5I2sIpblmOmm8zMr6QjydKUXJatNzgf8xw
	 b2gTQeD+ULI9ydCDuOnrgchPaZ7CpVwBl7hzAHZh/F6cO9XyqvkgDu002SbPOM6CXO
	 ESUt0yS+NwYH8uiKxSviIhmWY2HVG/ig//KRI2Z4=
X-QQ-mid: zesmtpgz5t1788983497t1275e637
X-QQ-Originating-IP: d7YA61bGw3SKUwANztmKXguhPOXYeUL97DAfFI4k5/o=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 10 Sep 2026 03:51:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7115221183154363354
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
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
Date: Thu, 10 Sep 2026 03:51:32 +0800
Message-Id: <20260909195132.1623875-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Njs2StTnUbMA/QqYbAHAntHRFMTwSVxqVWoSM3NIBnl9uqCojCKq+WOv
	0dRCDNboHBg3rk1XvWEkReuoeFj/QIl+YzcM+E0OoCZErjOcUKEgr4dnApI1LF9A8uq12Wu
	2Z6eLOeWaGOwWXEDwuTXdqay9iekZGWngkTGte/4G3JJbQ0rzTqT64IBtrz9yJsAMy8QfYL
	K7pGjRZ31A3hJw8k9oIscNyJxcapubHGVuvvh3E5xLhBoSyPrXOkKwyjx2Up8a7nejLSeMt
	CgGCuTFlfwZUc5lGbS2GWmta8cgqpM88Mzd9W7HDmiAydSOXiEtQLJBTsbIb1scHo0yJewk
	ivdeAMsIBLBGD/diiE2Ww9+9KZ+MUIsj/lyhZVweNqxhT06+STUMyJLhH0v9l45mIdbUqZN
	rHDvBM9RNvdhSlP1yC66nzbaNoGSM77mBu6yL6WsbG+fRU4UUSOFHxomb28tqm1aPu0NliA
	EkahJ0EKU3wakZEHhV0C3UpZFm0I2LVEs7feI1DyRjq50Oe0UKR+GioTPW3A5nbdV3gJZuY
	PfXtUBlVQJHTq0Fm5VgDfxt8fg5hcTmDC5kjCJFcDInp/X2iuWma0kl3Qt5WkyLrwrp7R37
	4cAELYRAYvdjpPlRi0bPJQOZxkBf0RIWohJVoQvyrEkB2+NdEtA+LVZm5mJSz+LXFKcTqap
	JtVY7lgThh4ui9g2e9Ds0aJB+TCjG2/KPOzomtDzJSoNan/bindmKuK86IlgRJxEQ4gOIHZ
	XDRAourRvMtWyotslapwL4hGsG8vlm6ODbSQtuMmBA2RWsCLVKV/kyM3FtzMeCk1RaCIpLZ
	dmhubtBOeOopSz7uQnADqVSSIOo6zjuW0BFQknsPIQpfCvvxB5PZwPNf6qZmHJzdkWpRcql
	I26k7M0m+Pt+wVEwdMaukcwL6GEvp348UeDo2+kJr1e3kkuTn/eoZkUE0Sk+o3ANiYk/4Jl
	58hsgSVAWRdvr4wOenlNX417GMkhgkMNIoTGsrf3HutlaBJpzAuCmhtSIanW4cUIYXkV7wZ
	Xoy5CkEPELBId+5HjhGMjstXRlN94rAeRZ33Lbs7twk8ZV4yjxMDilNmMkCTae1PRyqJAwu
	Q==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed Sep  9 23:55:33 CST 2026
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu Sep 10 00:10:35 CST 2026
Linux version 6.18.51-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.51-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu Sep 10 00:25:26 CST 2026
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.51-rc1-g4cfd5b1359b0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Sep  9 23:33:53 CST 2026

