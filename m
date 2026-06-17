Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3A3B14C5
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 06:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781678348; cv=none; b=N4Fc3qRzLArQnDxtSMmGWg27CQIdTwUInATJeT3lL+ylWkVx+C0d+mtcDSieqfjAk8NzaN6B3HtJon4QNFCCw2T70y9gpsyq/3Pr5XZDDcWizUpyonEaxPZ7nPnwShDOqBRTlGYoxB4Qex3qlLk2RdOqcBqLICVqP0IkNdU0keI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781678348; c=relaxed/simple;
	bh=8/9ViRRaBKEF2YISDo1QAVs+IVqgYW8NHcoRlBWau9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W8KcDK76szlNmLrIb2wM5ylNlk0HF0YQchZgesuEdrd5DleswPePJwR8yMqkTLx/A4lRM77+AeBoO79nPw3IxliBb9lQ/Cg4xo2I1e9cvhn8w+736fiJmzo8TCugUlGdXS5Z7E/SW5XjdF5bm10KeQWo0DZVhxHh4n/0jMRxqW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Owpdw5Nz; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Owpdw5Nz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781678319;
	bh=8/9ViRRaBKEF2YISDo1QAVs+IVqgYW8NHcoRlBWau9I=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Owpdw5Nz+sCIUTs8Q69YvPr5HtCCCM21nUtZgAoM+oWR/ewQXIJbjgGRjUxV7VE7o
	 in9IHy+Ne1UBmcJy9f5zY4qfCOhl5LP1RjLi0uO88NRzi38ZVVKXkH68jisOE7Pl79
	 ZKJkxmBlio016VQ1hBoVic67qwBbH+V626IILVWE=
X-QQ-mid: zesmtpsz8t1781678312t3a5506a6
X-QQ-Originating-IP: L0uZcgUqq6qX+JAZdIvCU18Ar7NHQk/DXjZrshiJ6EU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 17 Jun 2026 14:38:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14321659712413733696
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
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Date: Wed, 17 Jun 2026 14:38:21 +0800
Message-Id: <20260617063820.880745-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NU60Kbs86PFjh5YoCQ4I3+fsJ1FXvYlJdJ5yI4wHGq/EyI0Bdqy7wT1w
	uj8tAB/fzOTJlEy89kn+3IzI6OZl2xX3bRIPUAkHqD+9/XqaL4G50Wfc9WoIP57/56MK90P
	xY9gx/8bWkfpx8xewYrSG8DHG3lHBv0vy+I4SrTxEd297DV+nhpzBZotkrGyB/ybE/8Lb02
	oelnHGLcEqUjNLvjAKKX6+QubKM4KUeqKbVi7gxA/rQOHHAooPTH+gNT96bKswb3wa+i/xu
	IuFja9F0qz0d+hbI+L3P7dmgRe05UrX2oTVa5E4Z+1+KN6aKMPahtaM02AUPovIghtYxllx
	qHqVRtr8BlV4luezXSfnICH30PEoqTZA6X6fhOf1l4HubOiEyqDXhMNX7SobUwDKuE/rf8v
	dvlArz1W5vq+fmJ9CDycmW3ZiHJJym1rnkydeQ22lzRj5CMls2V7BYZDr6VBItMd2ygtKhZ
	/xgAaXgnyQWboyeygZ239ue2cOM/pR8J5/8VIzIUv+V2hneSzNbk8SbL56j8oMoNczTFYFO
	R+T0AT097fcv0//hW23ZxRPD+zCAE5hwlSzDQvrE++p9pkKyT7tTUs952L+vqcItfCe6CzW
	5Mm7Omj44NAPU5TVj6CQV0H1w3Fit9VIDmmFTaAFCh85skCurYhCzt19ghA80GC7fREJgZ7
	xyBShZK85DSXN23e7hdnjkm/twXZr+wZOBVX9LSGfpXshOkIhCGCpFoTv61qn2mxSuD/lID
	XGxcpTTmG3OydU8JXo7zJon+rptZ5ndnXpEY2OkUN2dEaY+rLr5xUNJr0nBd/A5rmsZS5jz
	N29cA8AuPIVLrE4RKHDPmnO/+F8x4n/UBb72zdBE7vBNa7I05LR40AjZ57cOWD7Sd2LjVn8
	Hl21lbjxHnONLU+77/Hfe4kYMC3iz9q9TgaIIU7YdD3XPZ5XChWAHn6cdiCx3hKYRsKhtwJ
	g01oxEY9Hg1Fz9ry6sNDW6hal7e38L3NVCOpctPoppx52DsrPmvGE2ep8MqU+LV6ORWF9Oi
	XBRinJvkjX2pY/fZTh9MwAbLbaPdnbem3bxM5lTBZ3l4b7pfbBZ8xr/CEhVBrwQJNvPYw+Q
	auXKjcOd9vLSs9IAR0Ir9U=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed Jun 17 10:22:33 CST 2026
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Wed Jun 17 10:45:35 CST 2026
Linux version 6.18.36-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.36-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Wed Jun 17 11:02:54 CST 2026
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.36-rc1-g1b6356bc9016 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Jun 17 09:57:57 CST 2026
