Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8261F39B960
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777139449; cv=none; b=AnXjucUJyPkH2zvBZCxRv8gNzp4TFFNFlaKtqkauBRqjD7vV9mOsV6a1BMulih4ZhtZwXXp+lsYvKRUyFfGaqZ1XmtkSkURpT3ip9/c5mF71wtx3WixYctpGMum0xHfgA/tfD0ycwD2/QqYaq7F9S+Ehf+kooOahBg9YFJIJInw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777139449; c=relaxed/simple;
	bh=Y7SQkTAZLMynaavXYwMgPgPHJMZHPBxRzxWN4ZHRs38=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EfLIb7+12YtfM5Kjm1xBmBcJvoK1xUzP7RBUHQCGFS4m4ONQObAOwuPKyEoSmj8bzlZxuddfhh806vqmyAdO2APOkKjzO9XKko1NEwAgdwOx4uukYcc/maAVemURnK8v/7JEy93QU7zi1QQMm0k8RRbBXVPABdge5/2XFbdfyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=khDJnS3g; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="khDJnS3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1777139427;
	bh=Y7SQkTAZLMynaavXYwMgPgPHJMZHPBxRzxWN4ZHRs38=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=khDJnS3grutZ1VRicPIiNIAp1Ldwj9HM7SM1CufjeXEhINSRi5zsniOGqmDqoiPWW
	 cLc7BC76YgcwWR2ecElHkJQ4OACQJiuxR2ju5ISzd60brDesjG6JJcyC2fSb6SzYzT
	 HCDeY9Hxbkg7pGFXxklvQzM9BFDBdb01q74vd2sg=
X-QQ-mid: zesmtpgz3t1777139420t31e62bf2
X-QQ-Originating-IP: lKSNzZeE38H2mEI/gO6dOmC/rJBq2OzSqLrEtcw9aQg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 26 Apr 2026 01:50:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2746875523663630047
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
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Date: Sun, 26 Apr 2026 01:49:03 +0800
Message-Id: <20260425174903.480962-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MdTuaOGnZwiP5TN6UfJgyajXwLK6PFP3psiyIhpaKkEMhLhI4d421VwV
	MYpQ4a6eRATfuTYqzGcZb6PuhA1UM96P3I5qgNE0EHo8f9198vZ9EjiVUX2uARCh0eAcSVb
	MJSpldy8WlC+V7tEl8Ytg+kUnEB8krnyEwYMz2RGhj0iUlf1mmlNekIzB706RwSrzQk6mqu
	o5KaFF5Mg8MoqxEA+7D8w62NN1rG4f7y8mNS4C/wMaNmGUDigEO96xe8a0fa9GDaXvRIEvC
	7Gcd+++z4zzr0Tu4HfV7HIrKXZ5G4m/+fWIALFnXx55p1mHKG+bxt/8pWpvh2jp7Dz6Xh7G
	hKERJSrEECTYNziUqUF82iHdJ70W+nzjTIXYE/nqUjSOZBxPK++lQTNDpUK9Cfs2OzF36Eg
	D4mfi5N+M8bTcuqRLO1mmpblF30vJtJWK/UQ6aCKMns9pk++g0vz75id3wI+XsdTD3UohW6
	asXraGNTQKYh8mbkuipmkinjtNq2t4RxeOSa03ckVgLMCywQ6Vv9bTYPtSS63SUOU+ITf4q
	Wap1P+w+PccFVyWANQYFpffUu0/SESATGq+vCV/kbyAv1X2jMSl0tw+wJN+61zCm3WVgQmi
	bexxrlceerxs/ZZ1NbJQG34qmQOXoEyw49vMMS/dnAzGK9PXud7phgnyQyd3RgGYe0frzuh
	OZtrNn0Z+NmZooKPZGHWk02bcOMyVc6nTh81IRUektbqjxwnWqpRpfALiruqsk2vXXykt7o
	pSihNz/KiP+P/v983jhAVfUHBFpPFDrT/Zg2zgJqLGhEC2yKiXry7AMo1epoRbnggMxdcN7
	3rbO7Ui9Hsa8uDdHomVKO5A7n7E/8L7cEaVpjQVKEAZQNsjJ5pmQmNWAj/1ic/Ttkjn6G2b
	FM2V8nddKmMfYjrFXuMhCTtcwgnnlq91p/BpZJqsgh5gWHOEQc2cuFju4oSxjJ6UOV8li5F
	JG7MKJ9tqNoCalgdDsZK+laqC7KBW3hGzVC3ahEgZ0U+5tKq/FJ+UYR0f32UYYKZQrxAkI/
	IUKOFQvRfdFs5eAv5eYwHxN4V8qVwWOAMFXASBuHJp+tOP8N366SphXECijtF3CLh6cq7yI
	JAeUe8c0uVL
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
strings vmlinux-* | grep "Linux version 6.18.25-rc1"
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sun Apr 26 00:40:28 CST 2026
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun Apr 26 01:03:19 CST 2026
Linux version 6.18.25-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.25-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sun Apr 26 01:28:01 CST 2026
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.25-rc1-g2bba374400df (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun Apr 26 00:14:25 CST 2026
