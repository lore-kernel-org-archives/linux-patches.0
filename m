Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC5037F314
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789244953; cv=none; b=EH4bjTnU5dsLWKHRndQXVSlRoj1o7UDXEkMPA8tUkIGQnAJRC+9dQBx0Etb1QeZmN/M+Ioog32JcYVKIDcD2eAULI/EDrT/Bza0fnjq6oL8FHDxq/uCwu6oEOBA3OHINdp5+RYrp53ERPkPJq9NBpUthSiLAhLk7a7379p9WTng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789244953; c=relaxed/simple;
	bh=WSrktti+GrZhcetEGyJkVS4hoQa2xPTYan99xmH3LaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bbOEQ4YY0cQ57it7j/X0G1eySQ4DDN4rN0OAQ0v6mAO6Um1UpXszi29kvRgNdnh62CXK+ItTm8hW2W8oclS9JBAPEtSXH4gqw5J3uy6lWkP4s0ZnPJsmnllqlIKOpLfKNAMcPFvb9Ze92eSP1NeaNbLt3Iv1mKy4BECMCpkAIio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=PUG6z/iu; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="PUG6z/iu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789244926;
	bh=WSrktti+GrZhcetEGyJkVS4hoQa2xPTYan99xmH3LaM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=PUG6z/iukqUbd179AOk+Cm5gXZCqyYZ+fGzS2MA4qZRBKcxV3qxjtu7QkAiypnrWD
	 0o/8GIVDyXIHTBDfOOW6/ECW5QeJgCxqX5uN4/oeo5EobUYQsrI9ObfDFTUx0f6MgS
	 ukQIlWBhoXTtsoZApwNDAv+r2Y7WcMZU6qxnWsZc=
X-QQ-mid: esmtpsz17t1789244921t2bebcfaa
X-QQ-Originating-IP: adESL1oPrDbLyPerAqF+h9ml0r83KhLlsXsqKcJ8MFg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 13 Sep 2026 04:28:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7332631638747606567
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
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Date: Sun, 13 Sep 2026 04:28:34 +0800
Message-Id: <20260912202834.849869-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ML07xMZF0r5+gDaD0jaenyQ8F7HZI7xhaQi4/o5zg06tv9TkZ8JRJ5yV
	pAbMPRxagnJgIUl1QSJhCQgz0Ko92XD6XclJmzYr8QNqfttQbTo2d1ns04c0PQfvq0qqyRo
	r+IlUjP6cYvLVl5MHQWbkCN2WWayc1/dNJf76GkkY4O5Cg19523U7MmTiEOL8NNaxAVivrB
	cRdCXntgLY9zW+qCi6G3w9SiVWO0Ep9jdKqK7Rcqx1LJkSKw9PgzJMkr6aMESl65mx3+L3J
	dG6EhYkfDm2W5dxBM6oFpLjTsLxGA99rEl+eQo4IJJzYx2EKYWTOMvorQvW/mtjK7yk5W2U
	E4CMYC9jGgCxT1gNwHHgfKQXR+4fOVzTZqUKTAb5zz8OO9hRZ3KWTMR8zCJOR0rgNmMiGaH
	f2sjljOXJ5a+OfuY4vgi4mficSpDwlk0PtM1r4JIr3KkHs47FU9uKjare4hZSctxKH01csr
	S+qSrBm0vLsGlPxWvhRvpjmEu/GGkzjDAbDpRoiuujDqjbb0UrjxZLLGWRhqpTl9OoofKPJ
	dRNu+IK2FzWw9GUfCneIoOIfeqj9MVGrxUqry/QDyrnqVv+pJjV2etG4E5phrzzsV2dulPr
	HcZsTXu01NyINY6ae0S4v169MxHctDEqg7Dq5anHZdKh2w/GKoqBfs5c1FB9fOJJy/zWEr2
	W8FCLKr8e2wx89fW1ONyR3Wd2uqh6xu6v7UwHuGjvwjgO3GQkvS47HJIg8YwaZLVrOqz2Jv
	AorPFoktY90Ez+Pj0iTyYodgZe4sxR+EpahbmX9gPj3huMBslTvKmF74D8KZd3JLqE1rUi4
	KH8xOKSYzZNDIaWmExSP5gLBgAEF9FbcvKQAzXKkgjbexyL/LQcV47aDqL4RWO0OP6y6QsA
	a/5s92ajG0ecoZ1ZYWD84B13Bc00mQWQQ2Rm3+2qS6aRM7KtpnPn7r32zyggGEq/JzWOflM
	epFFNkulOoU6RCL5j2W/OQNriIHKJtBaKbH/J/8rrg8Kn1Att0RGXGAJbQQIioGltFsabaZ
	E7/GX/juf1cmL09RSZlE08B4SBCDhnYIgu6+/h6ppf2iZeQA1OnHONlKfCxGXEMjdhucUT7
	pYJgaO1bWYKgGDnW5rAShU=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sun Sep 13 03:24:51 CST 2026
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun Sep 13 03:42:03 CST 2026
Linux version 6.18.52-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.52-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sun Sep 13 04:02:26 CST 2026
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.52-rc1-gbda8b5c5a396 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun Sep 13 03:01:12 CST 2026

