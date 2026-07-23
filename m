Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E33DC4AB
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817077; cv=none; b=StobpFjSKTuhqJU5L7MoMqubs2CBtQfGd9tSXKQksn/JYaWZixU9yGKDZt3nwHHwLiWRVLoEYaaHieqmC0ru2RS+P7k+ewZoO+g/7Xd8BJW6xop+F+rXvVp1eEnBQTkrPmp+2ANc/TvaUXF+Ip6vN85LkxJgYS4sDxY6mdtB1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817077; c=relaxed/simple;
	bh=f2pNBP4nnaOpQpRbTjHsJJFRMexLp+DflSyo4oNeqAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZJo19M+RHFgeHiCfk6LI0+vCa2z8SvKDy2k8z51fLmYPyqZByyAn7SLP9oV8bAysgTQpHJiM7StMA33o0n0Atc+soPGed/YJAiETK/+BBdhLC0bupyqjbKDNi1r4YscGDkoAc9T05aEnTR+20mIBsI9hqu9ugkuIwHpyCZz/ae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=lKG4CVZ2; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="lKG4CVZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784817051;
	bh=//JNm23KlmgYWU9537Xrywm4JHT+Euz7wvylKoSzJdM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=lKG4CVZ2p6PVsi58xtSYnOAEh+RjaNQg7reezj3dqwR++V/VraGz2TH/N26hyWO4h
	 7AGwB5b0GrEZh5nKuDpvHZ8DEqrJTlqBtWSkSX5o4ffp2THf/p2PSfspyvI4JNZtUX
	 B/ZCDIbucQw72Au78Ite1BdWbcR+fkBwUbz097hY=
X-QQ-mid: zesmtpgz3t1784817044teb6e5ff2
X-QQ-Originating-IP: LVH2R1vgdpWN6QN8DvTEdIuXfo23sFgYWBc+V2CelFM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 22:30:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2420314321759530120
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
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Date: Thu, 23 Jul 2026 22:30:40 +0800
Message-Id: <20260723143040.1106118-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
References: <20260722143258.264584003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MWdgP8+gtiFR4W5pNBAXBIGke9uwj5wXkW5vkgUqOX1OE6ty6zwC6tJ9
	y3z/WB3tkzPcHiIS63UOUauBSIrZmtl08H5yQjY+HA63TRKqNFDkaeRIbb7jWTFITK5Adxf
	cIfBH8T4miFpokad6eWgpZRfoTmJZNan+pMWjCH74NRjB2Q/YGnrhBiq1fkH0J1NP9P82BC
	oii7+yiKh8Hq6shUjq8Ld4chkhrr1d/8bftGg0Iyw5KFtksJqUNpVgV+RAdlRl9NpbfzJEt
	6ZAHNaATD92kSazJ6+MNNjMZT3ycl15rHRkcPB7TZqgJQxMiollM7hKXb9ThipC39xN6s2K
	LoAk+jAgVOlWUOtPF2cNujTpZDDlc8Yg8mE95VJ3pUln80WX69+0vSAJteRhxuUWKPlzT11
	Ii04FxeiWgCa5pFlAUOKctLo6jT+uMxUvg8vFd7saHqXOTmenFF2B5IEfWuQTkRqgf7V+EH
	jb6h2B0VR3Wi9dPTws2rtfIxWavONc0II4sRM6tAhx+Qhnhiir/24mxLXMrvjd1R0cT+xh/
	tnbDsy/amEAndNpjmIbJq3NSJTdxZHoBxGE7A7+RSc+2UYHi3VXkP2yDsS3UhfcjRylRoCE
	QISsZ5iQ4/Or3MUbdo/v7FMU8GpQ9tjdgJ2MEtFuNdDTCTfyAfLw1Yc0a0FuCNJkNichNnO
	H1E4VGIf7pDebBlH2HoyMu4IZ2yPdOhHHDcaMUnzQWdkoPwN8iRsv+avOKBMzl//YDgZVti
	+HWEJA2tUizryHHsNZkeCFzal9fd2MChCZNWxOThM4cGww+uofaBQ8mknvv61yMZB0t+GKu
	0jiexiOyPv05pZSY1AudU9AS2uucmWYgdeG9Se/ac90oZ4QyA+hiKrDe/UKU5lADVh/xQVq
	kNVs8Bs5i8yO1ZhjW9M40uafMXi6KTyDHqZwlZ+Q50pPBIFkqzo2fzO1rZF1vX5iFxPfDN/
	7/MuCg/TSEUvfwllvO373BdKw2f5GENjIf6jHw3zX2Jdc46icvpY/7rk/JVDGVEd35JkCha
	bIgwxPLu6Yq3VYpzO/X8x1o0sELp+93yHS5faoXQDC9yjQv5fcU7ib88dEkxO9N1eRthkth
	g==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Hello,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.6.145-rc2-arm64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.145-rc2-arm64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Thu Jul 23 17:17:24 CST 2026
Linux version 6.6.145-rc2-loong64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.145-rc2-loong64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Thu Jul 23 17:34:21 CST 2026
Linux version 6.6.145-rc2-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP 
Linux version 6.6.145-rc2-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Thu Jul 23 17:52:06 CST 2026
Linux version 6.6.145-rc2-amd64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.6.145-rc2-amd64-desktop-hwe-g1700dc538781 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu Jul 23 16:58:43 CST 2026

