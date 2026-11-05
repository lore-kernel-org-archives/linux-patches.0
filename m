Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881891;
	b=vtvkzE5WwFLiY2GmQXBiihuQuNHuQ9PbkJ9L4vKYLgTmLdqUMIW5gWNJKverV1ryc5Nf
	 0ykQx5mNCTyQfzpBVwlsEoVugI4YqBSJrDbhzOLsGYA6nW15mVjage8YU8XBafEPTFpkA
	 xQ6nuMfru3VpsImwv0lg9Y1U6EDn1xaFPXsjV3M76bsMgCC6B2fgtkMl1Yrv+9Gwvs6H+
	 H1gURTQ1FaxFPfmPCoBtJ/vJxsujPR1M9WnrkFl9eCFywMBv4zRksz/BsTunYrQ6MUM2L
	 /U42xmlsYppaKP6XrZ2yjF7gsXro06sFfZhg2enTRhmZOXsCNcpUFhZADCRp+QWJrmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881891;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=nPQCcrd0LHbxoNK8AMGZ6yKfmkiB7m69pr9Z+gI9aco=;
	b=KX8Ef0Mrgimhvfc5mtty4acSCoCzOjKmRWYai1ZQ6UG2TaHnMjfGZtiWbIpEiOp9sKTs
	 9cMpUDZ6dNjeAgD3x/5DjyZAf4yG5WS+F2w+NEb0i1k0wYl+zQAw/mFqNHzDhaRlZDw/5
	 DpGfl4X1wFY6a4XsIpfPEYX4YRUslVicjUKs2euvz8WX1jihVKCJ0qf8j4vnwe8TKKzrv
	 mowuwf6ozrCqSXWskPhFmq+ic4G1G9uTk7/GnjR4KL6tanz7ljnDEbdZUSItAoo86hsgk
	 VYgJrvHxHO4tAOwSDX9+0Qhdb/Q0zirmTee7vSROyx4nDYaWezhxJas6tk6JnjwBfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=lpC2roQC;
	arc=none smtp.remote-ip=54.204.34.130
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288C606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 12:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F288C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=lpC2roQC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1793881870;
	bh=nPQCcrd0LHbxoNK8AMGZ6yKfmkiB7m69pr9Z+gI9aco=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=lpC2roQC3kUhNzkZtPnfXg+gkfgpitnjPiSAtBjixFNPpbcY716vUl7d3L59QL5Po
	 Vfn7RHkuxFyTPh54LUGoo62gg1h09FU1H6csNAc/G/WjY0rUy0qtZsj7vAvobum17p
	 KrRVeHnsW4WCO28Zv5p4NNFn93C4W9iqrNh6w5Do=
X-QQ-mid: zesmtpsz6t1793881863t7c919a0e
X-QQ-Originating-IP: PjWpws/Wob451MYgMl+reGhJkP2Px/su/232CIZmEco=
Received: from localhost.localdomain ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 05 Nov 2026 20:31:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11215016198811326373
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
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
Date: Thu,  5 Nov 2026 20:30:55 +0800
Message-ID: <AA41A636D5CD1011+20261105123054.2073195-2-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MPAlP4yRn0xgT4MtLD/FFPC+KcG6UVaR2LSVCza2gA4xBmDl0Qfch0w6
	3J/alun5qqPGNolNsarkjUYTMKwCajcy4bNzT/xeKJmSCV2w/ay/lWB9BB0mTeLRXloKGLM
	NUnv19VchZxPZAYKIf00sBEJdy/OBRDqJXoIsqCjei3LmC9jtbpD/fTCT+bYpCjMw2ak0XD
	U6B5hdQwHqC2IwlLZAxm4Ed9nanZ1jniurMgUa2awE+Cm2PVqJAKPKLDYnok8+Si0x8uUNI
	5Gt5H65Zc2pdffTUsuGh8zudrmawoyv9ciC6rI0IWWuqJynOHgBCNrxTWyKpETSsrHhGKqm
	cIa6JPim52dto9KyKxjxJYuxj3LR1v6NvTJQzaQBH0SUlnu6MukZ6WnRd4XAJaUA6PpIt8e
	NDUtDYuTCzINkpHe1qdzZiOrRUbTZ+oFSWKaxUMlmM3jGd2J9DQipNbhLe2zJQY934+KKO9
	H6m5H1xnO8g08E58fnvW5jP1WlLodmVG/OhrNptxARVpjeZpoY37v3zJDDbJnZH9+bN9I4n
	hSQUg3ffzlY+N87e7r6IuyNoq/cF/lL/e2GigGTwNA5k73d7TmDAVP0KQLWItM8nsoCM9b2
	3R8FyELdWfxlX2292BYT5/ppyx4B0+LQUXErLrBFqZ7/DLYK3W12uekQMS93ynLY8ryRIJM
	KBCItoqGrSGo7CJgZZdZHdQiUs+7HvOfOjfwvTSEEiAYCkzK1EXXex+MbwL6lr8KuNnKRQs
	syF4lBs0dT1kA1KqM9UFqMIk6LHKga9FuNPKC/xWTYYkUElE6tN7QBAj/gKb2XYJgDmeEGN
	IzFceUBnQ1Mqn07wJ3GNP/vLF7ZvJzhc0nWi3U6oD1stgce44GoYRlA6TMtB/ntMf+wNrOP
	VlQRMpd/jwZUVFvopG/j7EAriBlijngVHAbQmAcJGLNSRYS/MZIScfz5Vbnlnxd+fiFn+ld
	BDScjBTmcZM/+5oIOfQzb0wmCJBucwMcl8EV8W5Z0LRwJqvKWqKYpQ84ypPXaPn3fUu/yUk
	oeJe3XfP73hN4pIwpQRsnxfhjdvoSZonKDx4uy1fnRzJEC0OFMuE3KR4A7Av8=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.61-rc1-ga7c80de5ffd0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Thu Nov  5 18:01:38 CST 2026
Linux version 6.18.61-rc1-ga7c80de5ffd0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu Nov  5 18:21:56 CST 2026
Linux version 6.18.61-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu Nov  5 18:41:25 CST 2026
Linux version 6.18.61-rc1-ga7c80de5ffd0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu Nov  5 17:40:11 CST 2026


