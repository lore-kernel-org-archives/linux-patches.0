Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92034D3B5
	for <patches@lists.linux.dev>; Sun, 17 May 2026 08:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779008335; cv=none; b=W4EnRB3EZQZ/+XLcBjP2Lm/rIU5HgpPunusdrGlun9mUbCoMqxI372R9gYSYhbHb1HQgYt4flfsOwj8fQnILgsoLCPwzLDKO+GirKNv3CyFDibnAf3VOQKkJnpNTiS1BHNSLA2jqSlRmbHOE8URFc6ZW1oTuGGxiMBW3UHJbdJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779008335; c=relaxed/simple;
	bh=EGDYLLZiWbYBwOMquyklVR3ty5/+AvduHltxt6fuaOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IMvnDJzJC9PtaDqVrAjjjSmg5pfWDMLBO+MHN2ckS5chMANbpIQ8C607AcLpJPRbGPJ3IvFzP5lZg0eDOKJR3LreeDGm0TzxQQS9zE9Mr05mGBfroQLl4J7/bzQiBxWkdjpLrpDSUQ3tj9huhfIkZ7jRehKO6HGfcK6Efe8OfF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=cYRr/Tmr; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="cYRr/Tmr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779008304;
	bh=EGDYLLZiWbYBwOMquyklVR3ty5/+AvduHltxt6fuaOU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=cYRr/TmrD8g2gqCjsr1AxK2jraKSGhL7Mp3rgNKBQRJT0IZxCAWqdEV0Ck4jT8Qi6
	 HU+TirXu/gDEkzUtZGbRKro4pqLgQ1YxhBO/1zyBGt9he8lUzUX+jFOhLj06oTuHoC
	 V8f3BZDtK2qZUGvMVMnSMJOaapSfWSI9OHXAwFPg=
X-QQ-mid: zesmtpip2t1779008298td77be0b4
X-QQ-Originating-IP: OnvlFHb/FLRDMDFG2KNmQL6pRfvFm3h75zyKXAWL1N0=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 17 May 2026 16:58:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16581266638349175935
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
Subject: Re: [PATCH 6.18 000/187] 6.18.32-rc2 review
Date: Sun, 17 May 2026 16:56:55 +0800
Message-Id: <20260517085655.754611-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260516102236.209957148@linuxfoundation.org>
References: <20260516102236.209957148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MczAcLGAPQL2FYmamQZF2WpwjCDFJFTIwSFO7P7J3GXVeo3IUGHy0BEq
	A43/60Szky3XhdfT7WBb7OTLAORr2V51zR0QaKJOo3ezzkXwmwU32rrpjg3hCE/8tpfEx/r
	iKH03FAE6q1D+keEPzccfmP8CNew8nYr4XPt+mtOSrNyQsbyOmdP+eANlKKX89Of40tYH79
	vPJhCj+NW/jdBoEXOj4gyFG+KSwY8VfXWzizugQyQTetbPk3mTpMs/KXDoLbp/+d2V4Vk3X
	65Bt0ScRM5ZTluv9Fe1C08raxIqYZErDfGZZiQYKTFN49ad++hhpBoUa+RCnTs6rywrMd37
	dTG8tBehyBRwNdjFBO2z9hMInV0xo/Rvw4h4MjIWkX6aa7TiXYwJ7tc0NAzA8tLV4YX/L8d
	xIn54NzeKLSl5NTMyQ+Rh3mdjPRtckc/Bt3hkgbRWGr4Vg+lsAU6KqcqtjqVfs7tqDtfJTl
	OP4Osd/73Qrn61PHR8n/aPt5YpMorf43KSpdAZVCdWij5aREvLFUn6FcCHKAKaHQA1BPTOA
	x4h+ygOYzdw0vibPIWohD3HLzxCM8euRNb4EJfi7BxIgzr3U/63fvFtK3KOOdhuaizNyMlY
	K1/zm3qgYG404pWjPWnj2ZWvdopTS4RY7TSv9UQoVRGMdUw/PPrPPF8pnKsgwQPn6aQxl8y
	lgF2FU+2TsO395/nVnQ+oWSMF8Bh0rnTGJRw3jyDpvYCnZ30ih4ed6YBLENxH+CtM1LqiaV
	fi991EDZWT7NnWQblNVhwkRdIychx+e/lUG3hXCW2u5hjoUhHtQ/hG6M6JxrQNtk2Nt5EJp
	GF7aP2lrrnW6jXfvFDfBvE+tgKc4TzcT5YXIXLkqdBWQk75rfpFW3MNiLiQTaxKrRNhjhz8
	LTv5UM5UUqHfWHf3jncsaVnz0wJR01Vg3jRYnAeSENOEnHpv82wO96fW4qFImECHp4QX7YO
	lhdh0HaitYIkWFZCNH9lexQC2k5pYXAmjyRKduqWU6l3IEbPNx4pio5+tPWd1D8LyIrpByP
	ZFOkFFErqYnuI3o5oreosPxzMJAqMNqOwjm0i+4pwmRVXAv/+a/oGAb9SAhCJ4PBevbKTcM
	FEZ3122fPUDn3dI/in0ofP2W53H8ZxcKw==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without 6.18.32-rc1 error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sun May 17 15:33:49 CST 2026
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun May 17 16:03:52 CST 2026
Linux version 6.18.32-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.32-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sun May 17 16:35:13 CST 2026
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.32-rc2-g2ee21fdc348b (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun May 17 15:04:20 CST 2026
