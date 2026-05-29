Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998B93D1A97
	for <patches@lists.linux.dev>; Fri, 29 May 2026 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780071890; cv=none; b=TAcn4UfHAmx2cT4nVGR0yYcqEGvgzuv+2yxuiP5aTI3A2ldL6U6csnlA6MNV5e/nV36M64xT4ngxfE/L6VqAMRrR3QRz+ENE6A+Fk4pak7CjJM82EgwxxkhQzyc4HqMRZYUhpLbaVQD+o8h47LWZtQml2hKcd+ELH6q2tXAzcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780071890; c=relaxed/simple;
	bh=T1pP5aBg5JFTwCrWYHoRqNB5RHYZ5MEaYGMQWyQLM4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NFFxbRSLhHnfN/ZbgKAUy5j+jlgnJei88uag8roSisdfHAqjtuQu5otx/hBMbtdDG4ITzYtsd6b6y2DhmU45SOv2VetVCglaj0njppsNX81icVG7K3NXb3k1bVVZAmagUBE5f8l9JAaVg3qUHCYIlOGL5M1Nb/cep4Nha2PAHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=mBUtJ5M/; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="mBUtJ5M/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780071871;
	bh=T1pP5aBg5JFTwCrWYHoRqNB5RHYZ5MEaYGMQWyQLM4g=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=mBUtJ5M/VFTS/kX54w8OaADC+u3iKKR2e9tiXQSMzb9gr6Y3NNM7vhUwYD5FGlht0
	 B42hS1tISOEjUkDkXYY5jGm+N1EkGqjPcePBmVzu9bViXqzDv+n+bwlfWqlAlzpo93
	 ezUxR6qC+ulM5CrC49LVZYp5KIjczrp7wFH/Z4UI=
X-QQ-mid: zesmtpsz7t1780071865t1a99804c
X-QQ-Originating-IP: zC1wTD9JbeNCUdBboyPYCxtI5JuRcIQqhg4OZjLg5HM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 30 May 2026 00:24:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9354515097411844831
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
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
Date: Sat, 30 May 2026 00:24:19 +0800
Message-Id: <20260529162419.3022309-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NMB3uNxca02moidCCrFTGz3zEenlz5Y3F3rvKx4tOY8hH2ra+cfMhrcK
	zrpXzUY0eT6ZeBCHVENtkT9ZS6IXeC7fAwtLDRd31EDqys4L6o0wH5p0y1OngFQP7WUVVqL
	0HaKNARrc+ZbBoJSHEJOAR2PfeZJty3I9iEEsh7+JgGqzc1i8wqTtdtuDWMnG5CUIr76gEl
	uj8REZI+kIhjvFAvcA3RHAzLV11jtdvi8B03hkXeAneTn/+VoQ2P2iFqxXp21Iusigd+8q/
	3KmkF9e0q0ij2WtDyfCq8uoHUN3QXLOffoihTrbftGNyoRbUb78kZa591Wrt6FpDoXcxW/G
	TPTUpoG4opTTluWd+J7RCBRitAqADcPKq9RXeFoDYQWQ1/42uBDAxC33wEN+0esmZDbqIM2
	+vPhkOgi5qV5wRo+16lHygy7xqMfh2/7dDkpHVnqE9QUs2nuIYX2LeAT20ydpv8Gg9nPzs8
	GeGMEYCaq+WmUUiBz5qC+BgadDIigwhfYv0I4LwC/I9DrI7pW+vq5/BOYljDoWmy8En7cqw
	flZ+JPJhJ+9hX/EQ0dU916xM+MU1lY9Nmzhn7yFITN8IYfe2CcW31PGUvhiqHpvsSncMFvT
	L+NLtE7n+yPBGa61TPMwjeyw4C0H34amMBddFJIBu0hZfVzxXCXfyJ1sgjLMkXcYYMhB9cU
	VBlkVgHlcyq8gcuUYNGKCCD/5OoMs46D5fUO6cFW+tBZL16U1k2cB0GxLw4UlHVbSMCUnIL
	XzB53TDANhZ1EeB12OzU6NnR9F+KGIsQkQ6CjHKksArMIPCsaJBnrnVNehnsynGKT4sqgO/
	r1si1BdhFmIi1HKGCl7sZvQR9hNMJ2BD2iFQPrU60lwwlHFXpUfS+blmbAQ8liZ7g+pJN01
	CmvMLef2fGF6a+uEYp70aqerMttOHzD7/ac2g933q7UwofikP6q31jK2E+bRNClwcvgpSYc
	IRK1XQ7oE3GL9fHCNCRot/gbbMP+zlrykJbWcox5uTpKm6v8eGqnUoiAf+njA8OgLlR6oEW
	G3lmBybtU93bndFvTqcyDfsO4KadQHdSWT15nSOj45YY5RIFvt
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.6.142-rc1-arm64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.142-rc1-arm64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Fri May 29 23:37:09 CST 2026
Linux version 6.6.142-rc1-loong64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.142-rc1-loong64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Fri May 29 23:59:15 CST 2026
Linux version 6.6.142-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.142-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Sat May 30 00:17:51 CST 2026
Linux version 6.6.142-rc1-amd64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.142-rc1-amd64-desktop-hwe-ge3ea6021aaef (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri May 29 23:12:32 CST 2026

