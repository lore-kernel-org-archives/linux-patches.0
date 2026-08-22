Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCFC1A5B9D
	for <patches@lists.linux.dev>; Sat, 22 Aug 2026 01:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787360965; cv=none; b=AjsUiWisg7qRuwIjPXURrxR1MqvjpUz7mqrSu8T5ALmGILQH40CHwCe/0HdepuqFFg55yMLKsyFCpQvtF7vqlY8Tcm+/Xzpi+mO/YwD6cVQ+rmoKY5XAaxdlHENgRj9+dakbpyEKQvWGNZGK3ANTVjZOKugEOdfcF8GHz3zXIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787360965; c=relaxed/simple;
	bh=FCsi3Y1KDyNSGcEAFG/s8S9olPYJT1CYp9IvVlK5bPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TIRupGNkkoKLBMdB1XPJdDzbM5wify3cAZSgv6ZbynHcmFoQqw4ui/NSioT8O1PNGhoxnvbk1xUhNO+qmy99kVkH5VYqW147VfR8J6FX7uQzpUqQmh9mTUI2j1hPSPqepc5WLzTczmC35X4poPWGzqG5IVIBjHdgZOLUD3e1IcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=KARwFXQG; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="KARwFXQG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787360955;
	bh=/HS6PnY6GECRlkKYKvplYAOEPpIQsku/irOMbzAN7CE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=KARwFXQGv9/0KLva9ri/FZ/spZK0uf7KJMnLX9GauGxy2zMRqzAmj1wWsPumgjFQs
	 cImpvnlPhiTkO0YZEKT6LI9E2Xfv1gKIRHjtwyHpGVEtVo3IMidjsKRFumQCFCgLBh
	 F+qOH3j5f5e7s5jtKGlSWX4Lo2cE16oA+2tHTC0o=
X-QQ-mid: zesmtpgz1t1787360732tf9e0090e
X-QQ-Originating-IP: PMct6n+kEVa+wlm+1om0uYJtww66orNUE59JRHxrFRI=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 22 Aug 2026 09:05:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3598378241932703062
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
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
Date: Sat, 22 Aug 2026 09:05:27 +0800
Message-Id: <20260822010527.3523140-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NnSC/w0LuVTXhjKavIPOpZU1peTNVsFlLqaSu1FPUF9d+pccHuKBNllw
	bH0p30Z56hnSIaqfoLgEz/z348cwCBM7BrNYgY1pFg13FzuyEDELJ1n+xwcmi3zm3kiSBNS
	IsFbn84PV6sYHn0QtuRc2FqIXARuY5VxZnhzk8AElBuMZp3Ejc3QK9QTMwOZAie99m6TEVz
	uHD9PnUbYShUkGQ9hcXbFfpjxz+WAnJ42HaTg8k/2hYsxlmOjJmrG7bUNLd5khM+9l6DdDf
	tSjFc15Vqv/BNf4Q3FmXHIrUw32ClK3I93zHLNGiKYdCYytdQCDw3dGDUq2osT5YohMHPDz
	YJn3/OvvlXhRlP1bhOgmPiKsL/qxMW1KStpZtbPDOmo952ulsJL/HKcve1TrYzdD+JH0GCg
	Ts1Bb5SworOp/8aejXve9xSFQkAtEi2cBm+1Y3WBF8Mn4EQjnoMnhRqkuGt/TZHUk9dXMSF
	8+8An0SHqEdvJGYJDtoyJLzeeYR9d0Bjo5627f9hA3XpeiiHNM3FXodGnbU2brqA1OpTwnk
	fmB33xXLCl10AMnFtr1T4AlKo/iyVrpK0Z+wS8ed9DbIeu1Ajj7oZu99i+7qtTPRMk/aIns
	t7OdKHFzpbIseQvEajrAlNeLKGUo1ZzWRXnUsT6jxCCL0bYqj4tcq1jEoyB9w0UY8iV05/P
	WvlmhRBvmqO7LdITMuBEOeckrZvoiyUdMYN2Ojuo1nHP9r3/yrvCI9i0IlGIw8k23Spv/Um
	dwnW5qiiztwOVPhGMSXv87YqKk50xlnOd7XiNwxD693/hjPS1lkSANoN2a2InQeXLgA2HjF
	d+uNRASgq4vB7JLbI1aEdKhp3Oho1f7epSvMsq64zc9REyZLmPWd3JzrBwF1OzQemMfqdgc
	6osQB7Fp2VO9ceKCSRf6gQNFt8H6T6SVtkZXnn708Ozb0ewnvt7LDUR8JUHj6ErvrZPFSoa
	AiLNVA4BV0GzlHkwfLZ75ahTExWBCTaPU178mMgk+quEt+wXVtJCTjU0AbXF4Pbvnsi926N
	YpN3GAcK3MWZ4WHlhF7AcmD/gFlUzYHY8Z3f4ib8YircptT/RJhplbIfcojwH7W1nbgoxq7
	jY8QOocz7mkPRSfg5jmp1dQrySUCthodw==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sat Aug 22 03:39:19 CST 2026
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Aug 22 03:57:08 CST 2026
Linux version 6.18.46-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.46-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Aug 22 04:14:38 CST 2026
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.46-rc1-g5025dd57f7da (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Aug 22 03:18:44 CST 2026

