Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854712F7F19
	for <patches@lists.linux.dev>; Fri, 15 May 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865307; cv=none; b=OodJY2LJvDRcmModp0ZzYudH72YqEeWDrUjs6gh/xMTGyCiSB3ITqHA1jVZrIn+9rG3TkCRegQkDQPI3ZsfRYkzGkJmE4jvjsQfIwKOqBh98OrgOsYC+ib4acUD146sJTpBqqRVmDjZFQFvJrZaeUtc6KQeRUQrUHInUFXuzg+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865307; c=relaxed/simple;
	bh=DI/6D/R5nHTuDntls6I2FBYAisir9sF9H9f3qLqPKOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0F7hO6dIrgj+MzP+XKHHVzo6UMjWbc/p90Lmr9BLqxQ8NR5AIgLUnQ/Y4y/ruAhl42PWl4TmF9SSANjQyq/aX3qBBP1BWjRWHdYq4GoGFm4iUcxVfqqZjtFLjUK0wsqpH74uz6ilKb2OBfhPx98IUCiHokQAaF7agd/HJ15B/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=cbihZQJq; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="cbihZQJq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778865282;
	bh=+dkHU0yum/qGskzBEdOQ2VhQjD07OM1eCJK8M6tYl6A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=cbihZQJqL733IzgrAsovW4PHI9MfZI1TUAC2hNfZCiyc+T4hxnMZqsX1GWONENg8T
	 xoo/PUBRHdLtMwA+EzcFICHq9fPgRhSeF/hwIJ969gcG3GqQApYwyuj1gitkE75vS2
	 FDj/Sqi6m/oPq6ZwPa0LZ1jWJPsugugRx4Ajj0Fg=
X-QQ-mid: zesmtpip2t1778865277ta37a6308
X-QQ-Originating-IP: BVaw1WmTVjX6UJvjaRuQKIdWGuQDo0toGNBLtoMZANg=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 16 May 2026 01:14:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18348356817988327989
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
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Date: Sat, 16 May 2026 01:13:04 +0800
Message-Id: <20260515171303.613447-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OBP6NRneNv5in6VFnSCXlgjhpdEEjRL8jryzan7LYDwX55Rkpuj/fK5f
	iAPIzwhTxo8nJgXPdphvZwHM8m6zSSyO6sSYIvAg1MjgZcCRIS+mWRztVBprRj5DoqwV8HX
	4p0FqvLjGZzuQ5iygLTY8mn4frNSyNUAKbLwMaEP4lykYjf6GdUPJOE9u0iqqKmwrGEo3wT
	Kndnv499r3sSYt7DtKzbY8JdMoecONoxyWdZRgfJGWKOsyrIx3/GRNOfKMhbluO4KbubeTX
	yRptm52UlZdrdbYxP1SgrndZSHHYRBRBCgOq0UmVpbrrkt9Bq+94k9/1cjPafsb0TEbEf4O
	JkTDaJnysZfsWDekhi8JxSUnxadaGksthQGngfTT5TX/4uTihGXocvicI8RXYFm3Kq4Xv7w
	ZWPZIf4PjOe8cEJeknkIzHY9OK9u8naz4u6RVFv94r2d1nZS1/3270irY+OkvwhnfPdy3zq
	yYxIAupf3gj4nyST50L5PU0PTnG5lLBiDD4ZxVnHooSvZO46wYpGKifP6KvpbgOarygy1Fk
	zew/iorN16jTfVscM7E+YFmyAcgPHcVB8C0Jz44S0a2Xx0nXXycyBM7SU4aHQwe7BgdIdtg
	xzNKlzinZCvrcM4y0QTYZPSHxo3f6c9wsm5ZRHJGE5it4PMMOujiDW2gH53x4y1XfdXWqIX
	fT97su+MtdMVxN6EbHlPAnZQiwp1g5yqEuPyLnTY5sezXQSbo0krmvBanCKQlUkcFSuWV2f
	uKoEzVNVQpykqQ67uxCDAlF3yc30mkPn5iZMT3nlT8guI28TMHUuGdRmhT2+rgz1UTzP7Hy
	fpVp7uKFrev7lHMfkUzWly30ELBgVMN+evPxjyNv2oLRePOCZpvXCaLKBeo/0qDkMMX58Qt
	DgCucLdyUIak5XvnMyupGBKnC7AueRHCESTwBYP+VZb48wLt8mXMqMikx6EAAIxmt2A5CoM
	ngQudSmvGqvtKYS4b7rYf4n4Cmf6L4gGIb1ipg+vAsTArPp/dgo9/PmtkbBpjcSZOgkSxWg
	pIijnMKuFssHS/q6VOoRBJgP4Kt3EM6LcoaB6Q3FAHWuYu5uqsJKSIl0lAeRECiMwp5fR1l
	Q==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

Build failed, you can drop the commit to build ok:
git revert 0253904dd601b15da2983297d64c106a393b3aa3.
Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
kernel/sched/ext.c: In function ‘scx_enable’:
kernel/sched/ext.c:4924:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
 4924 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
      |                                  ^~~~~~~~~~~~~~~~~~~
      |                                  HK_TYPE_DOMAIN
kernel/sched/ext.c:4924:34: note: each undeclared identifier is reported only once for each function it appears in
  CC [M]  crypto/algif_hash.o

commit 4fca0e550d506e1c95504c2d9247bc92bf621bf6
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Mon May 26 13:06:21 2025 +0200

    sched/isolation: Save boot defined domain flags

    HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
    but also cpuset isolated partitions.

    Housekeeping still needs a way to record what was initially passed
    to isolcpus= in order to keep these CPUs isolated after a cpuset
    isolated partition is modified or destroyed while containing some of
    them.

    Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.

    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Reviewed-by: Phil Auld <pauld@redhat.com>
    Reviewed-by: Waiman Long <longman@redhat.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Marco Crivellari <marco.crivellari@suse.com>
    Cc: Michal Hocko <mhocko@suse.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Vlastimil Babka <vbabka@suse.cz>
    Cc: Waiman Long <longman@redhat.com>
