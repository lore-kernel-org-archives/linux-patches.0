Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122B922A80D
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 03:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786158957; cv=none; b=b3OP1llZNCshq2G1xZbN12avbalzlPWKDcZrZKs+nnKePAgod8hWkOo7eoeMfR6u9gI2PkNVWp45ur0SNLwaAugsNmoirWQk9Llh99Il/BESupTZELmOsB3ziG3U/5TOg0b1l28B5gKJ62rl/+7FGTHLnXnKu91KwC8NURS1Vvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786158957; c=relaxed/simple;
	bh=pbwGfbUiD1ZUKrh6R8ej6gRWDGYpB2untAGk7KnpkFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SOeGvF/RGnsPWC4tE5LXOLsKpxgwgP5dR503NvV46e0lZ3hS5IXsM8N1QioiThdwh2NZHo126TBGkQ8GkOLZKMGRbe61ZX3IeKWFgY2WOpxWZE6aVVs1cVSo3G6SyWJ5g6Ru0t6nJK4JEau3EUDogkVkAr7UVFNTU1PzkcvQEqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=B8k0+JdD; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="B8k0+JdD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1786158930;
	bh=TwPP9XegA0eCZWd2793Qu516L0fIp572yCxm1agFId0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=B8k0+JdDJMbRPIiUGA5umVOG8qMgKoUdiGA7R6x5EA+kDnOyw+w8bgVrDcqV1Ce+4
	 rU2xDR2tLQ9AwWm8yZGLYkUa0AK7WRXH9fKQqKuLa9cUjmTF4Vd48swexsGHz5Fb8F
	 iDk87RpGZg/KuHEvhtC0eoSalFs67ByX3LcrDdtg=
X-QQ-mid: zesmtpgz6t1786158924te8bf3fbb
X-QQ-Originating-IP: snrNWxth08qIBXGxIWOa7kUOyDk5HfCOccukHMjhuWk=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 08 Aug 2026 11:15:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16489918695800404019
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
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
Date: Sat,  8 Aug 2026 11:10:28 +0800
Message-Id: <20260808031027.924396-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N06d0nmaM2HnZHK7cJiEDNRqYXc/L1A985TD8FhE/imdqoIkcj/JQPTE
	1ZnSia/DgR8yq+PugW+vSG2qFeb4AzkhoAR3i9LuXgPADui62nEXRTEF/ltWse8KhsZmYPC
	CJ2y1MdY8v9lVYi5t77LtFoSti+m4VzBEAgnLcSTWbFuxm8ci8rYT92ZnCAn1TRmpMZf1bR
	38vm1SVe/S66JRvTYM7CjPi1Av8fYjMVgyy93e31OFtdhSZoOZN13jIFDPFavKB3JKat6gO
	LMIHxWi1GwQO9O29Ib9zcQWLyxgs+MelhgOSQnMzv5QWeRLoDpRaJZYkfBgpB33unLWt3tF
	1ixnjgGqxdcSKksuAhCfeATNKllXTgMuYAuxJJ59ri8lwGgX5kfMl8lPwYHKDw/DSk1Q0SF
	MxuiVFVrah1qcO073ocUBKIiyeNywvi6w1cRTS5GWxffhnTFs0Axem2TpsNY4de1Apbbtm7
	5sW35uF9y8+++a3Od2U3vRdr3mz/Cna6ID2SkqsSbZL2GbpoEPTv5gMvhF7992cmG4LrZwM
	n5WHYJPvvhheDUYBMfeZtNdKlMINmn+CPl4+VQ9Lo7ZBpwADgH+jb6v7bn8KiaxVg2C96Jg
	bUvwfn0jWEy+HADIhf2HBvop01+YAh07mgN2O6umqTmkIW9XfcLZetKYNJaZjshOo6DFbk3
	qBygipKNmpGemn1c7EFwlpZRWccksuhMwF01vU+aH7FaC3k0WlzAFelQvWziUCBsMO4JfHh
	sUNuqB0HgN01D0emIsd2031IftKZR2hk9r2cUxoC5XrJOTkhtJzHBOFeHjdWeEQUPEumT2H
	1YsDvlC4AAk9BOolHH2ur7rW84QXVBFvNefL4SQvGqpseCNa6EjRToCkyrRV12ey65ICNnV
	yVbRMi0MhuZZNp/T0bOulNqCQmpyNKsWmG5hQbGA0YsnUME+jUFdzyUc/fg18cIKYWlAKzv
	QT4xs5HXsv6BRvcWpg1z8rZ8HlRhI7nXixLdd1rBXAbLGcAHdGoBl1c5OUpsAzdZd+UjI8l
	pZx0sxrgyBeTfhvqij1mDwk5rqVpYkM7AQ2WuhSUOI4rg28MGjaMCEGpBNtTHLIkruv1iO2
	jhOm+2Ez5G1dmfxtjuZeh4lE9IPZUddCnPsQHmJ+WQ9ve0YacvkU8eOWTpjF5QspK+9KeBK
	07f1
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.151-rc1-arm64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.151-rc1-arm64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Sat Aug  8 08:29:57 CST 2026
Linux version 6.6.151-rc1-loong64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.151-rc1-loong64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Sat Aug  8 08:46:29 CST 2026
Linux version 6.6.151-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP 
Linux version 6.6.151-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Sat Aug  8 09:02:19 CST 2026
Linux version 6.6.151-rc1-amd64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.6.151-rc1-amd64-desktop-hwe-g1e59060c56f6 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Aug  8 08:11:57 CST 2026

