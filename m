Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0551A6806
	for <patches@lists.linux.dev>; Thu, 21 May 2026 06:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779343726; cv=none; b=C3RMlzZP4TQJ8wa80K0byPqlAZpj0EXM3puUTk+4Dq7SvT38JBChtOh7MVbimm0DM8VxQypqwtThFCdD6cW7racV8P5dXpr2xOAIO4hm64lEGwAIYd9jvlZf3SWKleVk9zsCtk1uh/um6ujqMQyC0JgreAAp5DtKq5YF4LU5ssw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779343726; c=relaxed/simple;
	bh=lK0qXiaKe0/6Jz1GnuzGCLwDNCSso3TwJw9y2geVDLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pjAl3QYXQA+VyHSj76wXW5fGtQ1TnPoeJ6uc/n9X6T3Ug4JooKmuXeLd1SoiSSdQCcaZ+xdKGX8exaD5i2tJAei2uGouRdzO73SfjmKN/hHaE/pg2fnIPGypioKQi2bVxwSn1Zq7SoexloGLBBK9vwRkxXGLLlatvvu2UXdW1CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=BpgkYGHv; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="BpgkYGHv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779343699;
	bh=lK0qXiaKe0/6Jz1GnuzGCLwDNCSso3TwJw9y2geVDLc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=BpgkYGHvtgMTTO3FHtY6GaQV9RlHp16a2RfGQrWuHWsHGmp2tx9p77VrF0x+psbtM
	 qxJdY0ebEdJRkcP+kDTb+zJ7T7TH/1g6OzRHMvHqhCVA7OmZNI6brej26g4W+c9TkF
	 MP/rnMDFmZ1y25DOCB9ZEd7oCfr9EkxQLFdZvS4g=
X-QQ-mid: esmtpgz13t1779343692td0c60c00
X-QQ-Originating-IP: 2PLor4HyUO1Hkt/6YDGb7lTq1vS9W181eRmVi8yAc3U=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 21 May 2026 14:08:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10739255474463228470
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
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
Date: Thu, 21 May 2026 14:06:42 +0800
Message-Id: <20260521060641.1160944-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N9zSUNWYtR2/PVDEC3lGO4AAGGpemtWvh109i42aPXYZk6+cOlynEVsa
	JxIPJDwosx87m7GbkT7T2znbFAe+IswzmSAE6YD7QcwOMt3vfVqPhy9dXlhsH0LDRMTrNTW
	lYBca0bYwGaHjgkVBbmIQsgnmEN2WMAvClPcG6OnFFIVJrf9/Lb4Z/N+rzPDNvgDbiOm1lG
	of5TEb/5F0gP+et2/F7j7wiCqdVJleiGOnMAa1dGq3XLNuZ3OXiO8wvV8DFcetdXX6ih8WN
	FtBVTT4jpkGhuH01WLxD4d0lERCQJpy0+2Fre22YlgN2DX+iQGduwr3nNJXajgEDERpoSQu
	tk5T91CODDqopf0LEYGLWBj0zGXuQVpr/eZxe/XvarYTnMAauXEjsCoN7yYIMt1aW52zXMq
	SRcGeqvyZQgICuxLCPom2cFk9rSQU/5DirUZ1Qljp2W4n+/7SKXBjWf8Kshdh0Ohd1Knw5H
	51GijUfWI24IA7r53hrHiK3jhEhqK8Tejo+xjOCJC5vWHOBDEhdjkuMIxbc6QrDxji9/QbC
	4+mR1tz/QNqHgIqjA5iRR/eExzVBlxHFTF0Siv2Cd9v9ZxnQ6RropqZYk9aiitzAlmqee+g
	Fca/ecb8hbDwOpuF423R34bUxBnw1buklGFoGnotNnwpfUl8JOt+I7ef37itG4tP7oEoOhT
	8toXd79aEXE9tnQmuvrSXLNrqH6GVNkrAh+nXywOFXNdO+D/NR6mo/6FwVt5jxlNPBJbar2
	Ah3dw7jVAZ+m+FFUq5DKypmpFDXW9JAvF8tuRUVdV86eCfKgNvgEmBK8wIPoJK5KQqBbCGD
	Z8RCWej19UP1e0bnElSvnEtKUZxiSRg6v1Z6F5aPx0qJmeuefG0E+KZi5D8DNYM1FUDCErD
	65y8OMRtbBCcL3WyToQ0A6/1vVGtQ1cPbgt8SGZyYr88inaFN1RWhcXDKy5Bi2gzDZaHamn
	pK5uXj6cmMI2vdZmI/6j+E55ZljD24gB7DgLw6JNnzZARG4GwXAPtsIyZO86i91snbnH/7X
	rCt5M1eiPcyljAch1Iy7B5jYEgoyNQJ/AcwZdCX+RPZLiDO+U4geMDRZZbW3GbitFt8KaEX
	a3H6VEQx1yxsV2M11fNo5blAke66vvti2ARM8z7xbmI5wuSU2TBbgCrYW44ACozU+97XH4P
	BVCm
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

I means that 6.18.32-rc1 is 6.18.33-rc1.
Log:
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Thu May 21 12:18:48 CST 2026
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu May 21 12:33:52 CST 2026
Linux version 6.18.32-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.18.32-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Thu May 21 12:49:11 CST 2026
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.32-rc1-gb7adc4ce3f26 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu May 21 12:01:24 CST 2026

