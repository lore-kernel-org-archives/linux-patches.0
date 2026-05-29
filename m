Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3605B3F1664
	for <patches@lists.linux.dev>; Fri, 29 May 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065908; cv=none; b=p6s6A/N7xX8CJmj9F46y+IKkhxA/7YBYlzOe8sJVDJOybMqh+rbSGw2rJ9Y/Ipxnu28R2LUlxzcv5VY0QpeozpaP7gpqT50bh7ewbAaBA4GP9ekAKLZ5cHgZOWa/f1GkahA+V3+JXo3KQDZGaBkYtDsrMNWu+bQBCHNOenCPo2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065908; c=relaxed/simple;
	bh=V9wVFrjL2s+J6A1HeEIPVxKxw1Vqrz1KQ6SjM4LVf00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C9zvvLRX7fLixSMzRTzThIWdFn0Xk+YXIumBIM39JuxfsXgQtshZlSuWfDsjeT9/KGLf6t4DEn8Rmn/8V/WKnv3rMAGzGAnX9Cgl0NxqbRMQ0+rSrHW/Ved8La1XCmEI1xPuIJwCD8bLxH+Lo26yBTeR1vZePiu4rdAP3sDfjdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ofgK2H2W; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ofgK2H2W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780065880;
	bh=aQuiN57gGblTDVdeHTf3pgndGWjilaSgrAFg/rCxDco=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ofgK2H2WLl5ouk/HOTgjUtqX5wvTwUY4XjAyNwZh54CxNeFhRTrEybrWWVdJwjSHI
	 ffJfU+/PUduP9tXDTV+Pyo0TAIIGgPWq9+XgTE2IlLOLh71uZEu3yvCwTEaHTBlgV3
	 2Hl1lsjmkhOrLqyMJ5KKOASpbYlJLPBNTOqO0qb0=
X-QQ-mid: zesmtpsz4t1780065873t868af0b4
X-QQ-Originating-IP: yQD9oCqZeyI8NxAwMemD0/auxZ2yG5oT20Sph+Z0SnQ=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 29 May 2026 22:44:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15854156992415530431
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
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
Date: Fri, 29 May 2026 22:44:27 +0800
Message-Id: <20260529144427.2989037-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OegHrGdQ9dQUJeug1R/+dFU3X+7wfva/cchgOQCdT8XJtTnuwgmzq2pO
	82BzEyU/aA+0W7XPtUuGTlA/uZ2gtA8f/bmDSjK82tA7mYWAz06dOUiZdyh1m/GV75GHpQY
	llKUj8T9El1F/ogA90+SN3rOHEJNvvnBb0oKypSVRD93wFwi5aU0XWWVzHd9SVkbZqBovfg
	Cikh6ZIBfIlvohH/wEbQr1kTLeEAEXaC1aY31Z1k0Pn7C3hDPlgPQssVkwiVTTtAJJbLCFT
	S+swb/hz/D7f1rXWG2rvgi1oKBVXr5kFGdPymaAhcjTz6S/cx+KQNYQJJEFyBel9S0tN10E
	K+OdGWPyAH2XioDA4SMXjSaZ5zkWqshlqGkgMVhqQ0+mzFTasfJTl0aE8GTVrw5tnWZ+W4v
	5RdwtoMOSsa7JkrfENhFOmR/CMQLwvLR5iTL8/mFKHKwM9WAFHrj1MCLgknlq2Wyn7jb5ig
	KMSn46C3VPFltJPMlgoj5Sbc46BlqDrM9TdN18n4Mz1M1OvCQJ16AQbgMpzWq6SjtgjUpju
	j6GPtuEYkSKoZeBt0vdVQO4sk9YppcPDxhV9XA0fsVhzAS0oXx97fqKU/4O+tBmvSeeI+A2
	VOUFRjGnG82amB/A9kVVL8ewrPPbwGAWkEQuN6tJWdBoLY21Sk11pt+/S3A0r0d4Iu4uiZA
	KOiBRAX/LXhTJjJN246VSGlBwfb7k410ZAXLDXXvs+irBZV6q8ALFBS62KdNaGEvExl8fZC
	Y8CQ4YRo/rqHhJFJE5xmEciiPhW6MJQMsyUIn7LDe3PBReUt760pmKuMqLC278hOHfyI+7k
	eroetJWYYzShh05Cc3xsv7ffq2yykDfo4ZthVOdak1FSxzpV3gVP2v6OdT77kJ5sTRBV8Nn
	Ya4/duITufd9wio1xcKJOWfpJj9wbQHrzk58UPbzjcsJH+2/oeQDsga1TI/C91Tayqxm8SW
	Fim2+OXbgylQ6UmSFw6+V5HZ9EKaUcWJNIsCGAAgjPM5WKsh6kS6FsESmEm+qVHp+ep7M/3
	YP6wKIJLkvNoe4Nwl5gKQfjGS28nnkQX2z7LlLKBifzuADMMT9DzNsmcGnBMsmqUTcMVke+
	u0hXVFncnrrYRHISMtKU9c5G+jR+rbkz88rdzjsfcF8IdzeLLVtj8I=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
strings vmlinux-*6.18.34-rc1* | grep "Linux version 6.18.34"
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri May 29 22:01:37 CST 2026
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri May 29 22:19:13 CST 2026
Linux version 6.18.34-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.34-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Fri May 29 22:38:58 CST 2026
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.34-rc1-g89dbc07155c2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri May 29 21:40:40 CST 2026

