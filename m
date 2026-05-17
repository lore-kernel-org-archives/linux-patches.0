Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0029405C5F
	for <patches@lists.linux.dev>; Sun, 17 May 2026 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779019454; cv=none; b=FuDslfKWHkJ/nwbrI1uAnHfWFviA+gbIMA7EhkoqkPwQqpV/jaiKeNwghWaZzko3HCRt8lvR8FpCKqAh+G6UfIXYHfsTiJUDTHbaup41mq2wydmuT19rmsVqJFN06qCKtnOPu6vnoV2mRj2LHZeR9DltTPFxZXHW5xrFDsDb87Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779019454; c=relaxed/simple;
	bh=OtXWl+k3usGYBnvkGDVnXXEYzLVmykoJcczCN0snD2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WUiSL2xlnL+0srOrMwuBDvg4msnuZvF1Bjw993EqGqg1hL2mi+cfXQwDHgpMG3SmRv/grDcucW2EeYjgy/oGoo6e4vlbGilMJ0ZMCRD2QvA0CSzqSTV3K1mSnQXgWxaEvI8ISRkk2rWdtuyFBjRZdtxGS0MZZnoa/E48FRJQ6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=j3Atcre2; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="j3Atcre2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779019422;
	bh=OtXWl+k3usGYBnvkGDVnXXEYzLVmykoJcczCN0snD2E=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=j3Atcre2cjM5wzTrbseVc3AReYNZ6D24i+lOcOcTNn91y7KZlvWoDct0lqp/uanWA
	 1Mg1R/lCFS3ZlSnotgsdKWazeKJF9u1X8d1OkpDjnfTkPk02ptgtvi5iYkdqr5qNyH
	 aurAO4vU1YW11+kl59Be5M2WbuvvvnQqBEvoWwtE=
X-QQ-mid: zesmtpip2t1779019416tddc3375c
X-QQ-Originating-IP: N+lJ3L8fbyYczC/mV+z16jZ0gJdcxPvgU+WyLoMmYpU=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 17 May 2026 20:03:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12950981022435617714
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
Subject: Re: [PATCH 6.12 000/143] 6.12.90-rc2 review
Date: Sun, 17 May 2026 20:02:13 +0800
Message-Id: <20260517120213.765904-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260516102210.570453769@linuxfoundation.org>
References: <20260516102210.570453769@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MSe4HyfuRpiamruV7Z6nsiFRoTM8XM5TN54esKhU+iZpNphpv0T18Pks
	AfrSK4ERXgnwIeylFqXzQ2pCNZ0Mv5TVk9KVHKS6mjb9mqij0bhUW6z6yH69oovKjsyL4ok
	O184mLHK7v4yIAXqjDZaV5Ud4GalufHbpJfBxV4XPwknbDRur2r0CMFBwJ9PWa5qJW685oW
	DBS7IynLPxQd8wUuNA6WAXwYpmwcYIM+yW8rYpGICQFBXFtpaalp0d/w3YWHQND5maQ5HdJ
	DSzT3ITaI9A7ZrAa9Uhc7fHSxMe7WPW40nYsEbya3Abs2Ed5A06jDunss3/4mpNjkpTFvf1
	+1WapKeX3lrGl4IGC8R5o85qvNvoe/EsKnZ6YyaTXwdiKUEisQGyzcrpOY4uoELeq1XqxZ6
	WwOI48z4KxDkot4dX5C9iNCBq2/JY0OxqTNPhod/fm9obeLvAGUNjdf4MaCtVAoRMNIwEIR
	M9qgLdb5yE+lAZAzWYsn5pC0aL4qVt4Igpb4uhq87o1B+DKb+BSq4IYbhXLFnl2rcrsqzrF
	aQlHUtBEXA+b4HfeuyBfzhDURkb+Sgj5TGPN3tX5XtZ0jcM0O0GnQzQfe+KRl8Q5lG3VF/g
	aMOFXb39wVZFPa5vPdZzDk9qpVbXpTNvuyCYaxQ3zipYHiqyJ+zgcj7C0Vr0jPj0YEHWgQg
	wi9lDKsOyqSP0HTc9oi1P3io10C7vBcPYqjUnqqK0+muRqvRh01SeNoDKvauifHV1RXTF/V
	1Icp6P/moFU0gUPK+A5Ww7WSAW4ST33DAGLlCJJFVXxQBaU0ppfHC56t/mQQ8I+Pnk8+S/D
	ISdQcg8rBhezJEcBJUVN8OHYSHWuLSkLQrIPweFuSnc+YioCQ/hO9rCso8ZDihM+KHIBsFt
	1LOjz43MFIm1G13IA/C6sDBMfzf6sSf7o3eD99bcKtC9c0pVpe9JRazjfbMMnGCkTZNDnDj
	W08mze0CUGHQLYlPfwZsl5cuhlZ1kLmWj9PgIUjjeBvdVN0q1+x5Qp68+/Esl6jWWxBG74/
	m2MR492E9InPSbzvtaHuXsLy808SVjI2Y2OtltCDhdkoKkdIREPtAUPRx70CLSqUI3pdkyF
	WjKiFR80Vx1SDWt/N/+yhrbKcYa8W2pWBkZe67oZteTsCWy0G6rk0qc5lUjq7z27g==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without 6.12.90-rc1 error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Sun May 17 19:08:08 CST 2026
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun May 17 19:28:05 CST 2026
Linux version 6.12.90-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.12.90-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Sun May 17 19:49:23 CST 2026
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.12.90-rc2-gb82aebd59f80 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun May 17 18:50:02 CST 2026
