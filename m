Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5670C3B0AD8
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 12:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781698109; cv=none; b=WX+H96CXyRJ4YCXhEK2YsrLezMacgM0MmpBMNxoyHpHP3sCtN/jjijwpcwet8KiORFrqdVOYKvN3N1PIcxvjHAGCd1OxTGCFX9e7iwa7/1k8o1l+IsAdS01D+FV7jYyl8uiIkw99C99iAdsUjsjdyd7b2093078J1fa0LT+LVCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781698109; c=relaxed/simple;
	bh=SMgrSA/kIjByUED9+XkXmN8xQD9JA6hPkyyYkau0aBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DToCy4NwnwqfJp7LyjQ3ERsmTttPeQ4QkIptJGWks63XHW41UxyjI/SWvDwGEqy0VuZRG6Pw70I/KBAss/7PHhH3/bp+AKnvb2uGTZnKglyq0EeOsOyg3/WKPRkNROVLQMy2mhkwGtoBx7yAUgXr5mb9blVE3kU71kxR/wBdJng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HFvNnWN6; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HFvNnWN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781698089;
	bh=SMgrSA/kIjByUED9+XkXmN8xQD9JA6hPkyyYkau0aBQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=HFvNnWN6fA0kXa4AQRrJKN4VKGHbAXkdGvavTMLteyHI3LwKPkSEe5tdRLG1u+zek
	 IjkGWvBXJURxQTjWcSUGIU4MbpQPekOCJm/nNhIvPJXj/DIJ+MLn3TH14BXS3uIsv7
	 taWg+lD3xhm2BJiHTqVLkh37P8tkWOnabMFjvn6s=
X-QQ-mid: zesmtpsz4t1781698083t041b0929
X-QQ-Originating-IP: Jb0C0ZXzNqY/BFbTVt39oM2OHBuQciYf+eq6X0aQM6Q=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 17 Jun 2026 20:08:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11797564057231867192
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
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
Date: Wed, 17 Jun 2026 20:07:49 +0800
Message-Id: <20260617120747.1241937-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OA2O1J/qT0Faq+b2gmU82E529Fk2xtR3zC41GU+9WV6cPAs+StJJTDR4
	f2jNrULRJ0mGWY/79tu1KL+MV+r5d9dDqHPT7rbus1I60OyBBP5j8ZFAo55Ub0u4oUxRwE+
	2bF2YFVWnk5lkZCvF2vW4sWuf8AzUmanCn/Np1c+A7vl3OHaqZLa04fGgvCXkZDaYvU6pI7
	kWUFuTTZ+QRJXdDthMX6bumbLA6BkcFdZyFAF5zvmvm5WInjI8yjoOkiXdxSLu88UcPB29T
	v/8H2f2bHKP3Hv22FLY3S0YilawKQkznfM+4XjDOz8s1sQbghPxyr0GVaJTmWhCdyvVDhP+
	r9Et0m+cJyiaVm43cEs+wdKb9roAJ9ndCU87RYkqv/HLCFJRHg1e7Cm+fSwi2jOzeK0G/sd
	6lL1lNVSsEOGlyjhLAxr0C9iaGx+CEgFdedW0AuUt1J86NfZMet8ouR2qsuHSs0+Z8lpPix
	Virm4ukhkXGeIkc8iIzRk4Yy6iHgSi40LfzU2f+gYijQo1EKmkWv8dWx84AfcnE8LBYJ5zP
	qqv+faWF8cBAjN8DGDrqsH4d7fO/ctBgoLqYgt3Y4uDYsARmCluLTvI/D/iv8qIlpYNtlVa
	pRQcLDk2a8Q9yxw8OFxzrHcinPXwaIZOkW/9lcoQUwPt+X/XhQ2vqkkrehtwpUg4Vvgnvvc
	l4AWrlddt7di9vm/XNO5gL873xULbMGn+2s4d0fcmxeeWlPGOwrjNZ+TsNWi5VGJ7kyUctd
	DtnqtH8u+/ZVmNYN5aeK+KdUTfTi0RRrL7nzkmiHYvoD6Hy5rgfOdcfnAEm2qYjPZvVbcxr
	fpTTjmKbqc173IAZ5RE6MRGOFROOw3y+m85ulugERJ8ksGYIl6dW62U5Mr28iGnClxmK//L
	+Rc2+FqARHl+7qgQjF6Soc8bGvU6os30MQSVM2Oh52+NUnf+i2W4g1SgmjT1dA+hgtkoIp4
	YUKFQyYA9xrJAU19JuZZQOtlEQJEGe0S7+P3o1QN4PL/PBZwXpXBszxmUbhO6+C3IqbFhKi
	xaTwemyyXJtclH4drgyaivHFHerE2cN0QB+wQqBgEonY4l951zZcMnDm/MVS9lFZ9CXrBau
	R6AejTkf75zcBTW5t1UdDZGvSp1LmVOo9Ytr7TNWE6zCse3vjNLwDVh4KTqaTNs/UKYT7tk
	mXO5fwho8na80O4=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.6.143-rc1-arm64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.143-rc1-arm64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Wed Jun 17 15:27:25 CST 2026
Linux version 6.6.143-rc1-loong64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.143-rc1-loong64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Wed Jun 17 15:43:37 CST 2026
Linux version 6.6.143-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.143-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Wed Jun 17 15:57:42 CST 2026
Linux version 6.6.143-rc1-amd64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.143-rc1-amd64-desktop-hwe-gc3a40fddacf0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Jun 17 15:11:47 CST 2026
