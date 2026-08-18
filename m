Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2614A3C0A10
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068113; cv=none; b=g+vyQVTXYnvdz8/nPlloBi2Xw+KSQdEjsqNZdJ3V/Pd+XrsU5Kydp36oK6CNcDt8fxuAekEB+VZMJfKtMxItzyfL+6Bl7BfIncXx+PkvRaIGwDxGgu2AxRAZ7xoJmSvWRti0EQEu+d4qDbfyncf7fVDutH0DMylRTYHXrQ9Ra9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068113; c=relaxed/simple;
	bh=tC6+Ykg2AJDYKu3X2Gn0TPF8iUrXk//6O45xXE52eM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gmA70wf1U8bYnqmKB2o+G8BzHEkW6rNpITco1NBsSsCBVTfAZahopuvuIMVc86WFEoTZGMsLfBLWtdGcOo4Z4rtd86CCDlbbP8KVC0oFT97SEJwmm+ojiez3RtukZWFnri4G9UclOdIPzqY9vJ//G4/nbTO1r1g1Ez7fGH7zCmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=C5zvcsqD; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="C5zvcsqD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787068087;
	bh=tC6+Ykg2AJDYKu3X2Gn0TPF8iUrXk//6O45xXE52eM8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=C5zvcsqDmDNc8ozKEGjRd4fhMiNcMAxT6PLQNbsaJF2SFIOhVEvsVOYZQd1DVO+Yv
	 guDyGPpEj4cU46bMvFNIkRa1zl1SNxwcL38Nf6CQVFNnsOcSvXSXluF8S5LxOuDd6C
	 5yIaonFmqfmRpWll7mQwHVbEvZLZG6no29MECso0=
X-QQ-mid: zesmtpgz5t1787068081t5902bc93
X-QQ-Originating-IP: IVL2sHTPvKookZKE7IBSz5F9RZ51I68l0gPv2ME2yKE=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 18 Aug 2026 23:47:58 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2033148876574600725
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
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review 
Date: Tue, 18 Aug 2026 23:47:56 +0800
Message-Id: <20260818154756.2900434-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MxRSPV+z0HAoDg1KuyAl92iM2pF7PotsJx7Ctc4Qdx+4xFXoNGjA2K/J
	YjDeOpTpyxw/pu2HQJv/VRblmmZS/6wRTyVXYlHfXsJffjerXrDbLAUS6BiKDO8KtfsduRU
	V8JN0A4qQktv1v3d1iGYjaTJhSpO/lqN0U2s0cHXysCquVnAqtm1Aul08chifgwO02gdJYB
	ymHipdCHc51eOwfIsfiJeMC6uIFIfbB67MW34rV+cFmQlx3L9axBUzZkkjO/4E0MM6woNS9
	vamgljmqIZeI87uUMg+9+Y587Yadf8rHeVZCYBVLtreHyaihvN3BLbWrrmhe64bzY1mmMpW
	zOxEHFE/6KQcwhq5VOGXJVMWCjeG6sOwgHbiagBvJ37UHCltcqNON6jloF6+knYLhtddDh2
	4mke8GlvDSiwnDfhh/ZrRBYkRXtixZ6H6mov8UKnpbGgP4GbE4Q+UpPl19P5c+zao9pH46e
	3eohqZON+EAQQ8tJ0NDe3zUAYkMCBr5QkuULDJTj0nhrAWxyGYQKEYPvT7pIpWTnLwESXVx
	gN1uiF4KBgDjZfUfRPH1uiUY34LUAZGzS3b1yWOOQoB+ZqWMvFRuN0o/vpSph02tGmFH5BE
	mDijmYkTaKwOgzwAv5KR4AFT/apNOW1bRn30Ic+Z7NeJl07eeQMySr7kPdZZdz++OOLmtgG
	H1tZxerVt6cgom7j2UVdph+X3qGfeptRe5T7Ymf38VZz/qGbY29pbK6OflkvTKqbWOxirAv
	1zRXruCGwSvEfhk82OmkoJ7GaB/7qwWpimuKi78Y/nWcdx8QkipQ6+UxkUpEYM9DT5CjrOs
	F2WbxQZySJxs02rHMga/sqcU+3x6tdhB32WYNSREW+/Zm+99S1Oy/NU6oSmO6aEAzZ/f1ZS
	2uZIL5q91OG+kXbBPbiMdURJdx8uZx2FYYyVNg3zQIsAjHCwuP9RzKQPXlODXHulzggHhB6
	7IzjzFoSelLPskSihwXxcTZ4wXI3J8QSvZniANCcH5QSFACBl0r+YzGiqVA2gWu92JKMLF7
	5Hnnu/MAQpAM2MId9lZBkBVb6+wf6GV0D4TsOUuIyCD5arTwd35HmZL3D+3klBpXlkVCxZa
	becV1c4iXDfmwbABURW4rHPSj3bbj6IDG7hZerAmvB0boHw0X8FxMr2XLE8ltPylw==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Tue Aug 18 14:22:15 CST 2026
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Tue Aug 18 14:39:54 CST 2026
Linux version 6.18.45-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.45-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Tue Aug 18 14:59:32 CST 2026
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.45-rc1-gbd7005a98dd1 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Aug 18 14:01:23 CST 2026

