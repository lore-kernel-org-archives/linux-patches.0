Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49D318EEE
	for <patches@lists.linux.dev>; Thu, 14 May 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778774386; cv=none; b=M5/Y7NcxNsonPgJimBkGeFBsshPEFrvy6OBvfRuUGW5xOuBS93TVepyK23ai4Md//RQ75w2BW0DuBQNKCfHU/JCrsedKPR5fZpyMj3Z0BFhIaEPwo6unneEeOHPmR1QqLjovl/UwqKC9eljGFs6d4euSUgSrEGj0s98gZ3y8C0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778774386; c=relaxed/simple;
	bh=QIsDG66HnAC31RA+POj6UTFZ3PY5KCH6nE1mFBNkGUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uh8vzUVdEJNNbFa7eqvSFG1AnAEYO91Yc8zzMwqQX5dKRfk7galLQ2KTldEE27b3BcTJUiN4OZW7k4TvznufVknaxL+p7QzK3vtzj3w6MAW3zd/VVRgxFbDUdFETn9aCIQggeFw+5kw9SXiGK6d5gqkqH4dJDUpGHTFRFlBsCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CJZe4RpF; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CJZe4RpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778774358;
	bh=QIsDG66HnAC31RA+POj6UTFZ3PY5KCH6nE1mFBNkGUM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CJZe4RpFb/jEVd960yyHW4ajIIkNba9RRGjBMTW2c4rhywoPAghGS7ZxpDbdTeP6/
	 k/rHEwr02Vc22FXzDQedu50qBsjIFPU89vVhOl4u8vy/IixqJSuzcIYufoHPm2LCsx
	 D3tWbgU2RL9NbmofYR7a6+Usb7Xg5SM48guXixSM=
X-QQ-mid: esmtpgz16t1778774352t1070e312
X-QQ-Originating-IP: LuWI56tf0CfKs5BEqnAnu607Ih8bt8YEWiKbRxpL4ek=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 14 May 2026 23:59:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6921566505251205290
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
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
Date: Thu, 14 May 2026 23:57:49 +0800
Message-Id: <20260514155749.487213-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
References: <20260513153744.746440810@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N/BaP5J2bFjvbYkFpxsefG3Q9iT0BxsAfBDKGUPvBN4JoYS4A/Yu0PPz
	SMQL9WW7zcFxBALnW12M5eyNFx42hWhftqsmkfd1oaqAvbDYsWvZEfmRykQjfwbuWemyBPF
	9V18+txnDjvFGG/FBRQhqcf0k8bpWAHA+rNOCLlt7Dsomv/AekpsfSIBa2u1cDBOz2qkHpk
	o3oVQEUAO3O77Gp7n7JU6QBmKnFP4WaQ9X0rQhYpnnaAKCYOZRuRheLX0UGInhUdHdJDzfM
	kO2EQeO6fYMMEwCoZ1I+TjP0OnIhyENcEANqJ80FFI+EDq1deSMTx17/TSOSVFw/+il+Q0G
	fbrYGrJJ4/KvZHiuGuy7nuHEwgiUikbscAObHTodsc4i8aje1I9YVZNaQopPtno4ljEyXqX
	lb1v03O1oHamVSsa9eKhy9g38Kpub9H48BBlJw9wPToBNaAih952jkNlyT+kZJAj+4spOG2
	0RILgTbbG71mVSIQ1MuMDiaVHeLZK67tI1GRUrsALRMPFvZuKuz1DopSsUv8koKQpRUMZTR
	5zDFb5zepvBQvAyIe3LeUV+5/YUBN54hDfWS1Pq79Gjh3naDATpzxgtis23GliBrJvIBHSL
	PHsf7MAT4g6iDTotyxNHJvzeAAxnNvn6yfQC62xqrUaddTh3qxVE48+BCMJ8n6jCg/kdYzz
	my3TzO19Qn8c4Cas7HoQuu5iN/FM90Bjw+24tl0lEhWAEshiriq0ubPSAT14CVm5guBtyis
	I3yDIImdX0g9wy+HoXatpEXGxt844klfQRHT66bdexihCoZSRvhSJKpXRRGT0WxMQdAq2gc
	tJGaNMrCtKwCVhrKNL5fhq3cyOo8tydoV1w+49PlNFjFrZaUQuP5yE6v8Hxobj2I0hdeXY6
	qG1yrwle/JS8r0K4m/SdampxsDnnLLm4OQonc6q2Wk+xU2oI8Nip+4a1dq0V1rJJFB1w1U9
	WSZwFqHjE5QrVCTOozf+HTgbZsPzdyloIVzz2r4EVDusyhX+c9NoZBUhM7e8srk+V7wM1+D
	ayM6Sgys0AtA5mZ/oFOGuFWYmJ4qTZQY0rqBRcivIujLjcYUmJ8nmZj5qxu2HAAic/xd4O8
	almQd8Kdt5Zayqx/D+gT6f8IUNRIzM6mA==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Thu May 14 23:10:57 CST 2026
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu May 14 23:28:41 CST 2026
Linux version 6.18.30-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.30-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu May 14 23:45:36 CST 2026
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.30-rc2-gf83e9543dfa5 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu May 14 22:46:55 CST 2026

