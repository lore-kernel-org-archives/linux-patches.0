Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAC387587
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 09:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725406; cv=none; b=tTZBMLn2lrCKXAtu/eEytArExK255ybm/6JMfjXTFRpdEH+Nf0oPWvOFA2WtUaVGcEOai82c7pQCaAKjIiNpEoImKBMEaRY/bsq85ERqzgTLyku+o4VZ91eKPjDPr0QJoogndlxsjCtfky5sy4Q2Ff3J1QMjP8BuyI/Yzivy94A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725406; c=relaxed/simple;
	bh=qQSb7fQvmOvZjR5LxAN8Un0/0l8PKun/japrGiWREc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cfbdZgxG3gywty+TX8oGe/+IDizi1WXq+ocPQzj24ONpLz7Y2gW1OzHiErc5OCKBMUSxvjZpCShGrRd3cPegs9gA1mMvzPfa3iLOoOOSO4jstJn3H+Z1i66iMZ4Qu9g/Ajn0ethKOx76AMeAVGR+Y4ExMUGD22CRLAY3siJQEjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=HatChpJv; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="HatChpJv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1775725369;
	bh=wU/DuXGDvMLpiomE48tqtZmns9g8Y/8tzlP0/JapsG4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=HatChpJviMv+RvsxIW6T0BUIFUHVWbgZE19FBIf4pIXSB6v2XHg72TcxyI0FnHHC3
	 M4mMv638nJUdU9sUC5OrpVzD5OMkR4MOSx6HJUnKJ1qhHCKwzQk02xMearUfdZrP8l
	 E+mWjGutte4Yw5V52Zx5sIojw4IgbQ9ypj8p5nIM=
X-QQ-mid: zesmtpip2t1775725362td7d0847e
X-QQ-Originating-IP: SH8xwkaohHkd2uOl7TnxT1CDColrBlp4tBbtnKlzqMY=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 09 Apr 2026 17:02:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3803652542561349405
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
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
Date: Thu,  9 Apr 2026 17:01:36 +0800
Message-Id: <20260409090136.1212179-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N4LWO32kx0SKlWDAB8MfxTzcUg2ZbsuD4hOsVbgWSTQx/uKx4fYku7Dr
	2KRpHX33K9QPLnmwa0a2FzWfO4kNUU9ulz5oYrLQKhqqUjOY6wRrffGy2KhU/+fFwrVpsLN
	tdUzlnBUGnVovlcF/Bw2ZSWat5OldcnTOYJPD7By4K8QcjRbRpNvBwEpPkeyCSIf3Umo2q7
	IN0tx9UEPkUPkympSc3TkwhkO5pPcWeLxXPL3JhiQiR0RRSRw9ZOnx3kxoZe79zS3xdoIzo
	lNchar4uxQ0OBQFRzaKTSXeHOXA9zIstpmPV2l1tw4QW930p5pcRxZlgdOkgBiDNMKhpXCm
	X6DMlpA6d91v2jd3tZUb2boK/jJv1kBMlC+7Jhf1ZueqgHaHbuohGIhoBJEX8sfIGNhgmGk
	xgIDfTcHPiQW0LFcPAxbUYE3LjglOvaUWqfzRxYWA1WC1KDtyK2gN/dsJcbP6pPcXe5KvB1
	481MdRTPXDT+T1IXrvlviDrRazEvf4923E59VHMfJaubiwOdZ/zgGvIC9hsivUh7BlmwTXN
	GMY1DXN1HXgHYJBYYGbPPJB1rWBIrpw8wT/9XvvbgTUyhUf1WkAob8ZcwcZCCQBUhZ4mWid
	21FtmPJ4FEdC+vgo9TJ9RJkkBlqAxalPgeIstKTsM7o9aNuUsPSsH91eC5iG6XGUkgk3U/3
	9kPAkNmy8XmJbIXCFwUw3tOCKMcdTmLdxbgXV3wvaYs+iIJRLg26y9iTu7UOODP9+u7lHzX
	fKBwOPXeKWV5y+BUzQlElNT79R6u1NuylV2dqLnwiViczIm//nR5kBv50+0ub5QDBnlbwc8
	L6z76jz+u5UYV4rVhwMObti/aZGwE/3NR2xEW0Y4YMHIXgo2Xb4c1fnJ5EYsce5IXwQAxnx
	UbxxxhVX3FkTlw4sDw8b6ElCL1hFj6DNZyVNSwK8yOy507O80dfjBCkTAS5sOa99W3Ncp+x
	dlpc1UR+yr2w0Mw/iJb9ueWGx6cO3YM5AgS3nprjFSxfhK7rMyk0dQJY0syARcvKxGolL4G
	a8zAAnvLirO259Bx60sV1tqTL7epTwmMS3Ynr2HKqNXVgVBOGX6ItkSZraX4B/LDb6Wtgpx
	59Lpibt8u5SmMnI6R55fMI=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/decbc7d88fbf68488a7d90e46f6d3e59

Log:
strings vmlinux-* | grep "Linux version 6.18.22-rc1"
Linux version 6.18.22-rc1-gef4577f805c0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.22-rc1-gef4577f805c0 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Thu Apr  9 10:58:20 CST 2026
Linux version 6.18.22-rc1-loong64-desktop-hwe-gef4577f805c0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.22-rc1-loong64-desktop-hwe-gef4577f805c0 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu Apr  9 12:41:56 CST 2026
Linux version 6.18.22-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.22-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu Apr  9 16:04:33 CST 2026
Linux version 6.18.22-rc1-gef4577f805c0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.22-rc1-gef4577f805c0 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu Apr  9 10:25:32 CST 2026
