Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A832AF00
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780891417; cv=none; b=JlqNuz+7Q0R2VkKNAXULMXQw2+YSm4DJfQjn8W1WDrPNSjX87WNVG0CF7AmtauneRpWKKXMwseriAx1lfF/UDiRwcDQYoQuwb/M0DIQsSifkd0hNpQKDYpHvyNyK/YfLBMiHqejMncvoTspFbGTxuTIJmDkvNrippzg+lcah57Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780891417; c=relaxed/simple;
	bh=U/tsal+rmzBloBrC1GPduwFaa6/XQho9dcwMkAcxEO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XnJE04xuBeZg7O0zpYcWTxdbuIS8nU+VbwsAQ2IvQsXqbkkaP+WPezni45Fv5ocKQzCB+C3vWZ27XvV2AB5NqJEwx7mUTpEzhdM51iVbHm1+bLve7RmoEjXtglsmNJ8OpIR395cPPOxAbl9quQrDs4Ke5M/ZKeqNORTHt9WZtUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dVp3UR+H; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dVp3UR+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780891393;
	bh=h7Fokc1elsJWmfJd5c+3oA7JYOnT99hDUiQla4RZfZQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=dVp3UR+HGOxuOwtdayBMNR7RjrNYS4/qIXyiHik08T7s0eb2F2+LC+EKMBkofapZq
	 ITr6aAHG+ENTLiuK6Pet8NDPNuoBTCmsN2Hu/taYuA9mWMusDRxhHp177/bj96IC2H
	 xKQ4Lv4mlHW8fVouH5YIZQctCWAgeLbQZElnRsvg=
X-QQ-mid: zesmtpgz6t1780891387t8bf71eab
X-QQ-Originating-IP: 8GAcMR5TM4hftvFEMGOItbzvF8JfcqXi4YQRk8rD9Rs=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 08 Jun 2026 12:03:04 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14729094490505157293
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
Subject: Re: [PATCH 6.18 000/315] 6.18.35-rc1 review
Date: Mon,  8 Jun 2026 12:03:00 +0800
Message-Id: <20260608040300.501601-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MAbyYw/5r7aNkqiNxAZRG9vCCgrBX5wBe75ZqQNRFgiWR82/2TQjhegb
	516x9ZrLJ2xByrB24YhLyA6HidjNybxJpZegqeQXTg/aIbqcZK9qEBHIdcnEEZ3grSANbYB
	xt1iYgGe0rL4kTKwvwvrIbMHXUPrtpfb6thZjazXLd8SFyr8t64/cybVxJPZLikmznja0Uk
	qE/oqvsHaxHp8+sHHFXyLEQ3ztSzfYvotBAMBAoVLxXUAZfm2ikIKkqOVnKSbBfD0rHrNru
	tqdVg69lnng3tnBY8oVbP0Hb8sLuPQNaT1HbehRwb8tW3ueuq2HiHZ4TI84gDX+6mTNvUBj
	r+x2eogc03GW39brjYtJyrw1swEZBtTWPUyQT3JDm4TwjJOQYSR07Hw4o+5CKyzpKN15fxW
	EKlZDjTL5LE7fokIYDwZwiwkpWjqbGJrsFlXZDVnGp73ae8Mqwb1CU1IxmySckHgp5mNyrp
	RvnCsnQzELVCzZUyGO+EskFgVu334ntYT2GOJS0aOFnbwqZ7hKSuFajOsFtIeeVPC55D45k
	6wh/yBxHk51bU8CJtkRZwFyrNra7d2DMFXF7ELVxLGZdzAUq9jIOwKVH6rxjol59zi3B5H7
	5+hRUxOKrlFmV8QxkIHbFeNDrhLMuozQITGu3NEx7Rpp1Q1EwUZo6rMwM9XXph0kV7HHZVF
	E25eGjs0liVKYxpyePd/uYU7dcUOB5vs0Fbx98ou+7MITf3lXfksfHmUfww5JaZNParnxhR
	57y574zoQgJ54FYZj9TOkOXrA0UeL6cYGwswqOFvOlEB12kE0NTggUaplk1rLke89pue+rW
	gJ6+BzNKCwG/ItTvOx4ld1gr+sd+LYPnZhCEsDqNtoX0iiAiQ5Uf6NFL7PNUdRvkelHoKQm
	itOUz4m+VlEBCQMD7/nhOqdIP9AQbjYCi24K/C9rG2fY6IRqqGaU5loHqFdI0UTQe7b8y5t
	EWcP3uZ/1slA7cuqV/n58ABXXh/lG2cNw9pICLHxGn0Pqsmmyp447/pktXL/Gx+Y9ZBnrfW
	E2qEKojeJCD9MjgiMi8TfQXHdGRvfLNtCWfyorzMBPEb+sH57mOdVLUsNUHi83V29X7uLNj
	R17FgZ+U2QFIGMRk/pJZoHSFwT7s40E5w==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Build tested in our x86,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

NOTE: Revert "KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor" which reported by
Marc Zyngier <maz@kernel.org> applied and arm64 built ok.

Link: https://lore.kernel.org/stable/87y0gq8cov.wl-maz@kernel.org/

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.35-rc1-g24a2e29b003c (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.35-rc1-g24a2e29b003c (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Mon Jun  8 09:47:30 CST 2026
Linux version 6.18.35-rc1-ga392253fde81 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.35-rc1-ga392253fde81 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #5 SMP PREEMPT_DYNAMIC Mon Jun  8 11:23:18 CST 2026
Linux version 6.18.35-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.35-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Mon Jun  8 10:20:57 CST 2026
Linux version 6.18.35-rc1-ga392253fde81 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.35-rc1-ga392253fde81 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Mon Jun  8 01:26:28 CST 2026

