Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8694F23BCED
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 09:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737621; cv=none; b=EIxyldCd1RpGhnnFTv40lmYWgz33bTsxXQ1/6KtHkAgXoE4hLbQ6aXbMWL4pS/MMmeKaXYC7haPQzlt0pA7Nq86EuaQE34bickZYFP9xWfpEEEeKdeksXL2oHotbRlWNHmxcmSjDlKG4aBcQRVorC0HEhPmtbe3QiuYRN7emCkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737621; c=relaxed/simple;
	bh=/08myWiVr98o2wIOyhU6OTEXsJu5xDUiiXJJ3NU59eM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3KCsEYJgg6b0kHaCqaMWwzFwxBdHz/HLl+sOjD7MvSJ/yASqidsoG+Dck29l6rEpIepCj5Hwn+DxarpDqF3vXZj2YifJcVgslB+mclpUIU5+GAtirTYAoMsnqRBotqVgu/YJTSKlIzvzPPsbWT8NyWEXgfj2XpOaajDzaomNB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=F17QjMdA; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="F17QjMdA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787737599;
	bh=/08myWiVr98o2wIOyhU6OTEXsJu5xDUiiXJJ3NU59eM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=F17QjMdAfwykneARg1+CTFkIiGF3VvoaOtdpJqigCqnjNd4nMaBPpMe+Nglek7I2w
	 g48DGidFRXK46pCIgOkS0HV5QSndw0rLwMwcwoHxhMb7ZseSjNSftoC39OkFfv+xlq
	 hYXip5C+w4AhztdyjQK1mdm62Rxc2dmZ29lCwQrI=
X-QQ-mid: zesmtpgz7t1787737592tdcc00169
X-QQ-Originating-IP: ENEuChos8Qz78gGHQtKW+AJSRrpWaai3sNQw+IJDh+M=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 26 Aug 2026 17:46:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2521073373441743776
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
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
Date: Wed, 26 Aug 2026 17:46:27 +0800
Message-Id: <20260826094627.3189636-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NuVTqMOgygVlOvrhLkMjw2f1/ZzX4ZRqIph+07gAOPXPt9QygkZbMNz/
	CHoZQFceZNNMfLH/vyC6emsZ+m9Dc14dOAWH3C7Om21Mba+xmCIdW3fdFTIBRyM4bST853T
	evtKUmPh36bi4kBUWY+rWEcGrw/70+eRJADMtbv8vFSKQT2UaPbPW7xeuppNHRqhnLNgIGi
	sgXfqJWcvw+U3uf/brM2pcXXrCyftixmgTDXrrgpJFXtktPsGO0DwE14VeOrE+hDjE8LLS8
	JF+GnMJ7UH9lpzmmk7z2ZUlwmhJSnBSOPNfrQU8L8xXcjOPysrWwrnI0eWxsjj5/hZ9jcLk
	ue5rd5JZw/5D9zYV4aUaMfsnXcD3X6NMr+T1D8r3HnLSaeQQWx3Z3Lg5si8UxLEImTWQ+3S
	HBM7Ooy0Ju13gHFC+KmSICQJpwolKUgNtmWFwbg+CIEEexiseZkUdQ/FkNFt0Zju3ENt5Bg
	mlKxQqR7/mcup4elMGLIw1Ii1tkSrvk+8mak4fmN+9HUKf4CK68rYqdUFknv5kq465VF4dG
	EgcxDaRMFjGynaws9CF66nKlLzNoLMZ60BrBR3Y7i+bdYFIaH+iM8wSxv2rQ8siRu6j1Z03
	wB9OhOxq7H6rfeophBklFZeNC7/CgKLAcZehKXrT5Q2cxGf6955cjjV85gg5xalUHgsn1zc
	85pyKqYy70JK+Cy6ggx46VMcuun4qdScFYF4J3LfHJkG/eUZU12XG2Tw1pdi2AIzKov3P1r
	0CteFrbKg7i7wNoU75HNioujaCUp8UT2+xlbeuA31/bkko7u6kYtlxDjXePJcHqWBT+cSGD
	bSfVVXCLtC6g5ukKSWtGBPLJ6dgPrBq/y9WsXzUWoRGOmdXSEG84gxQoWVvlco7f+Xg7XtU
	1cYDzxUdBFoCtPVQVRZpETRE7OVo/qQ90qCWBU4wkC230QLW2FJkw9wOqTLmEtI/ddSMdQB
	1mgeYRwo5SxIKzCgFJLj4o34fjLW0HMzBUuH/CRYEzqNJe2D5cj2AUxA/ct5GMZzi6FPgjA
	fGSYlYo5rRIdhU0AMquD1j2x4zUgFRccN2PMyScPb/ZmEPz6/EBQ+aoF8/YquV2YFNHFKq/
	h0wVXMRIrR4f+2YrXJLa+/osWlkFZHgxg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.154-rc1-arm64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.154-rc1-arm64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Wed Aug 26 15:06:21 CST 2026
Linux version 6.6.154-rc1-loong64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.154-rc1-loong64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Wed Aug 26 15:24:02 CST 2026
Linux version 6.6.154-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.154-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Wed Aug 26 15:40:33 CST 2026
Linux version 6.6.154-rc1-amd64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.154-rc1-amd64-desktop-hwe-g8147a3c12dd2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Aug 26 14:47:41 CST 2026

