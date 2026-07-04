Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93511288C30
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130382; cv=none; b=Yvv0CSF0RSFnMHOltrJs/M2k3iB1Hh+j6ARzMemR/BK2RG+foxnf9+TNrzCo0wiJkNzGYo94g5LafZLGzodNkUHr6mD73DlsdJEdo9/CmtD3IDDZzRt36q6BG/FdxZmPoXNxuEEhH7hTRpWW9qtl9u5Qa4nD/L+jEryDAhKs4/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130382; c=relaxed/simple;
	bh=Hld71cANZUg3kQQbj0eo7ByxUckv3nSlaI94jQeeIU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lk4ubmQxQ9/BClSnc+yi7q0StPFPBhfwciZlMIHHzxKYTpFVQJbUVIEZ9d3FTT2mr714+2l/6OmL2kIj2HBX1/00RpYRIP+qxHG4cYWpXXOSxwj1yzURHtdmc6o+OqKzo8RZtBHESyUhCss0rjRS04DbEOrg1yezwloSgw2XRVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=RJ6PF/kc; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="RJ6PF/kc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783130351;
	bh=95G3e2y4YliAGQtdof++SdvvRuI8no4JUWbTcPlO8vc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=RJ6PF/kcMjSM2wBG+eKV7aZiKRhmh/jRDLBdrN3s2pER1+V9i9Pu/h0vge1tARKti
	 AiM6TKaXfeQSxxg44yf8EnPjaVD1hX88Gncf64mZtpnhkpYyBJjF1T7M8X2gZL3d0j
	 1A8caGDfTX6WOAJNjkxFzzUsiLE7LxcPZy+RtTCg=
X-QQ-mid: esmtpgz11t1783130344te21a08a1
X-QQ-Originating-IP: zawYPNEQUv66Cxd8n+lcxy44Qbh1xpcBdbaqUD7K7Kg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 04 Jul 2026 09:59:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4754575111604876633
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
Subject: Re: [PATCH 6.18 000/109] 6.18.38-rc2 review
Date: Sat,  4 Jul 2026 09:58:43 +0800
Message-Id: <20260704015841.1569932-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260703072816.644513463@linuxfoundation.org>
References: <20260703072816.644513463@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MeXtFl6q4gmHuK9S2Z5YoYqIQxKxqu/HfsFLnaoN3jw/hS7unX1c7Gwp
	O4+xlDbbmoz9k/mF7166Rx5OQgWrlD/1rP++Hb64l6nilvb4/+GwBnq22BRl9M36WWAJcL2
	yexYPDRPYG+7wrbhH+N9sGBitFiZjwwziQw7cSIefKd2OK7MvxsbYLVNmAe1Yu6bNH5NjEI
	+P4zepcwJCE06OzBGkfg6Ag3DXMlOT+Fz5aR2M3du6q7fplN6UmRh6P0NNQhEfRuvof/cir
	w9mezb7t0MEEVjZLvp71VQzoDfF9ZtIjuaxkoyCCCTDpX98ojZyqdhTsX+6ABs09vrJlc+C
	iY88R6/8QhXkSFRQblPttkt8OWlxeBigkeKUtxZeqxwAO9Iz5ceauCVt1VKTsE5DvNcID76
	IdpbOxK8uDVmLY7xzwYb18NWrdbJ65lHI9ZuZFni6a+N9xcqIkK54od4539QGaeW91FNVHN
	6dw75xJxUz6+LP6QwPoCRvBbb8wWSyAKTTVYSv1VtGQRHEIJd2Tey5GrjEzPjHAtLr+5QfO
	2JMo4BYbhAP2FF5TMatP+mEFbpomElmYwZ1VFP+05o1IlwI+WIDjS3c6pZFpbZn73ZqVLny
	e+cPhPLIc/EbFo4s7csg5RRK9cpN9qi862YH11q9/Rz2Wvgx79bCiDKZYGV5MszOVxQ2r8Y
	bwIynWb8kumE4oykTAoy3XcM1uUxX8J5KV3V6E1tR+TOd0M/qjUIMjV1CIV1Ov1RCih+Hdd
	Koupz3cuoRsxEhARXgeGlwr1lGMNLLWxrPsNkYVG/6alcVlilQlRQU/SUmCo7E/8h94BdoI
	J43sn6LLRV15MCpaQ7QvdCLRHGGae+KhNkbt1ppPVCsudJP5c5aR/HZJWgrBB6+ZNpSyoEj
	6ZBguWbQI+vy9CibdJkNOhgjtOX1oP/dhnnXtOgg/CLjgsb6pVWUaT25z1xOwwZULXHWEM/
	CWnzWpKsGdbN7ewozvIbW51fidGSXq111GB6ccZAjlTzqArEPkDZ93kyA9fZ9jJM30XG9rW
	oeEgxksojHvJyJAYd7C0EZzs1TKS4A6pQoYMEa0M71D8IMDjjbcaFWmPle7reDkYYQOO6Qg
	jn+cKd8yqVT
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,riscv,loongarch config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sat Jul  4 04:10:09 CST 2026
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Jul  4 04:28:45 CST 2026
Linux version 6.18.38-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.38-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Jul  4 04:45:54 CST 2026
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc2-g455fe3223158 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Jul  4 03:49:21 CST 2026

