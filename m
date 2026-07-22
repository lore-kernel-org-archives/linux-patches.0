Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFD343F4C0
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 08:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708834; cv=none; b=S+boWA0p7DL2VWhbKJPgt2KzEw0h9Q/1uG/VQObIWxXXBbsyM//1mSGQesosj2BPgcayQfYdwO/l5Lpqzk4uwgbT0QK9MRoanBXlImVA+kM0tNJwibcU4NqY7+9ksW1cEJFOFNNoiWj3Kg1SKHLbMdf/bcm4SUw2z68VZ7/acqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708834; c=relaxed/simple;
	bh=h0exZmolevSAFHMaMCUhmcWBgHBKHV5vopcxMibkPEM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aUJMcnEksajtKeanGuVprqah1545G2s1Uo8U3wtgHsv53Q5YYhk5QcDpgcURMFgeLkeHSC6/SjDTJxD6+9lFXuITp/zAbyJmNs71w6kC4/ZlRBqm++0Eh1zp+ltsbB0CcypntTJdjIy9ViSpPJFFBN8QXvwQf4B7jSPJDiE5Jr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kbR83VV3; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kbR83VV3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784708809;
	bh=iKNePkvLO+Xkw4Bg0UaylTaIwN/EKafypBJWLgjl5y8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=kbR83VV3JyyYu1rgzk+fK1Jcd4MjGsr1+jUmVp0sM+njSTnSHRbcBx9uf5QBcwIUD
	 5K3mQQus1HlUEerIAEdW3zIYr0Tc4/oQsWAL9jGiH3xQwnoCOfI3f6IC43qXB9j6Jy
	 qXBOH/TYm0bmJLJpckaZmOGLtvREDI0iHaKHWT24=
X-QQ-mid: zesmtpgz4t1784708802t73708a2a
X-QQ-Originating-IP: bVGPw5OQyeFGT0ThO/+s3jTvmbzZE8gXJE3hoH4saXs=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 22 Jul 2026 16:26:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17902874601284001575
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
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
Date: Wed, 22 Jul 2026 16:26:32 +0800
Message-Id: <20260722082631.845313-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NvHY+L1zKPWo1GwNFvjWrNrI3vGhOBp9EvisgVlW5li1IGt2dYS+fepN
	xTCI9yD6AAuz8nqk05QEASw4Gz/bb7vRfK7AXdtbudN+UdCjB+qP6uKkSa98ZqDFbOq4J0M
	FyLlMieY/hB5BDL6NJFgegks9FPFh7Q0XXvamnUZd67Sh0TD5YJI89FAyMz04IMOoG04gy4
	y/J/wvmxMfPnC8B/6iRhddQtWExGWvB4V/eBhyMdh7a9dVoPYnKLefCVicd4Z2khrB6aTFr
	Dw8kNsUdxS0+tsFTO82xG0cRqgBsFItw7Dr07N1GOuUM3QWlWMEJHmEtW5PYmtXvLVMvnvv
	jIAQm4CiPWrhJO1XOMftrNxvGJGt+tvCENB9oLs3FlE7b2lchuEgaLa+nkTpRI+KIKLom3b
	aoke9ITzxTR0jW8rr84tWiQ7S19f2NvQ7yT9hN27scvke+1ceW1Wbosb0Ex2e/qhp3qFDON
	QC/wgoYlDmKHoLVL1HOLVKpciYcu5tUQeQLJ5DAFLEPiqoFwnNRIkH1BtklToqoqODYe0Rq
	xKEolq653M2BehvdyWoa1es+uNt2Xq9pshAafOdNTXYlqk6Dz/VL2PWr2iFDvD5iENFoXjM
	Wi4lqOurs7zmOkc2m+kUg7tvQObPfotXOQR1J+fNA/zDvk384EYNV2YIRwzqqVufaZm1gjf
	+9SdwzrV/wY1Alx8cl1odQIsdOk2eHmOI8Hco+7YK8tW7QXlLSGB66soEBnrkr4EoON0Gaj
	xiLUxd5I41vTWWakdHLcQPFkAg+EQDY85scFOJ0oYZ0d1wSMyR825nQmZQ3oYstAWCuCZud
	IzLy8jSoLeupsFg8voAhbB7pXWy9NBHVZHYNj7oQjwCPe3khF5WEsAk+TAmJTh7bFQK8baz
	xww++Zy1PL48Ow2iENRworBTfnJt+ulO5OhpUm6G+51n4LkxEj0n9759E2KTjnXh2EaQL5H
	kxZ8sFbdwWO/4N1DJNjvafiAMG8agmFl9GE4Sr5QMARtMUAxhaaS5MKkySPTLFiKVq/X0Kn
	Om8DGwLK+z3aVfGOVv0Fii7yMQv9SwVCq+V1mK8KGH6XP2dKqTXATlSdJMVyIozyVLGGUfH
	cY0Ohd76XGmsyQJP9fPyTs=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hi, 

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.6.145-rc1-arm64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.145-rc1-arm64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Wed Jul 22 14:02:44 CST 2026
Linux version 6.6.145-rc1-loong64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.145-rc1-loong64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Wed Jul 22 14:19:39 CST 2026
Linux version 6.6.145-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP 
Linux version 6.6.145-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Wed Jul 22 14:35:36 CST 2026
Linux version 6.6.145-rc1-amd64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.6.145-rc1-amd64-desktop-hwe-g5b1c90a58c89 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Jul 22 13:43:48 CST 2026

