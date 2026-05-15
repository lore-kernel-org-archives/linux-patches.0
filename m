Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDB635E1A3
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778872164; cv=none; b=li14tsxReyXWycYtdlXc68hoVVS/B3I1QjHkep0ddusDer2iRvG1coidsIYv6FSWfQRqvDALYya29xWaAM32nWeAda5YBEOfx2DRD+G7MGgYKxl17Sx8ToHzu2arStot6LKKEf/dTzEcSp+swPuz6Yil5zCX+8TvYFHnvlbit8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778872164; c=relaxed/simple;
	bh=VeBwgf0HuoXPAtMey51z72jtJ7roDxmiJrwuB5KEgBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oxe5KB5gjt0mrnVHdcJjYM7BPCx/f6jui2LszB/wpz+ZeaI5sZNxQuNs2heWi4JUvEvOBbLqPVAIYb+/qe1dhX2W6KoykXST0XvxuhTNLcd0rAZTLh7ZtXqP5jiP/OdiXNwicySs1Fko0w5hkztBYLIqEpye9NwtsLZqJYw5Auo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=pTq1qJad; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="pTq1qJad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778872131;
	bh=23iRe8TdU0dLdEkgOluldeT0N1Pm7wPKRMbxXwth4Ps=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=pTq1qJad9ptiGLogYFJq1zOTZkJrIRo1LBVYfCfkQ4zErzfPbkWFfu4O7rzmO5780
	 Y1ZkxU0UMX5jVn3uhw/UO2HE2X+JSAmv8uEI/J+kvGiiAIkdfT+8uOrafGK/rJqD3Y
	 RPYVLMUKxt+hHR4nPnH/++s3GNU8M9suUnD4KJ4Y=
X-QQ-mid: zesmtpip3t1778872125t78dfdabc
X-QQ-Originating-IP: 5QvCL6rLhQgrKSHgBdosjsdGRVXzocSlEWUrW2oEN4g=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 16 May 2026 03:08:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14452000538527073916
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
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Date: Sat, 16 May 2026 03:07:14 +0800
Message-Id: <20260515190713.620177-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MsNslY5/mgXA1TuN2/H9QciPnYfirYutGohW6eGDHrU58rmDZ8JHVMEx
	WbMpwZWMy1bLRkK/xzTv3h6gV/aP6UD+oWfs+hZCBtB2LnODYEwaEAtfg8sOPEI+wu4xXGz
	uTRLCBB8/IbpKJycer2vF7xr9B7nV+QK+AsSvcoagWLBS7QjhOelc4fXunei6IFHlo7S9oC
	LfpQ8dmXiju2hpdTUxagoY1+cYVHkj2bh0/vropgZhpQMZYv4naJhhSeZfhk6Jfn5xWhIiZ
	DQ9ek0Zw5mn/OPMwluhrMUvaa4ztUeyRGZYt14Gf4gtSeg9rQaukbFf5r3c0TJ9RPWNfYZB
	k5RDy1Epm14p4whLhyEyNmjzntq0PKN4J/WYP0kw2pUch5r3vV8ixfF6QsFuJYjkhJnzx/s
	DjAwL/fFtvaWv7DYyCR9WuIG0xiiosuUgcNXl/eE2B92Fj6agNKaC0nKhP6qYKZcHRPLbZT
	7a0dU/9Er56KGBkr/qp9kdSkvZ6AhfKGX+T5bPFKztv6zd6rWOOFAqZJ+5O705N2bIO2yrL
	IR6Qu2phM/euNre4yFgZ0C3IPNp81nQ/0NNyvtNOCyZupufdCmg1kBC0kAJbdX/0TJMYgvR
	/QeR8NoobPv+R4Jzbp4c2hdj0EXs6OS6nAV9vn5l2uRhJ2BrxonYxAUAx75NNm9fwR0OJqi
	Z9TKpWhGbr7odDjw0FQrGotSQoMEjqw2d/efswD4yszO7FJP57EIglpxWRl4Z7VA/Vf55Wz
	Uf26xqi5IJObAbn+vHGOhBhkzdg4wjovmCS42ktYusc7p4p1qfSyUI+m4jtEuAgKZ9np8+r
	DfMdfAxmOIs7P0ONwURbWqQT3kf4VLuB9hTM+nazXE3wILksfjzQ4Wb3V/7s1MXROGQ38jJ
	fjed1JqLRKrZ4IcS8BGDAgNOYoEgyFvT3INzKLvfchJbYtrVwZvKSBBlW5G2UUwErROYf+n
	jDCmLgfHwfKUYScYlNTuItD+qz9gb4fh2N7mi36/iHqV+VE/s4VL91Bo4FYA3wJrtYaqeIm
	rCyrhtmbnEqAF/7zvNrGaq+V8NXCnLEtwwGWBBY1ecXFwpB8+5JXHZBt92M5JIQQJXhnD+B
	ACdXsPMKUmPIDZ1G3MVkD6/TcihptaaVHsItBGJ7WEr
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build failed, you can drop the commit to build ok, same as 6.18.30-rc1:
git revert 14d9ce90cf4855d638ecbcdb0c208a144d6f991b..
Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
In file included from kernel/sched/build_policy.c:63:
kernel/sched/ext.c: In function ‘scx_ops_enable’:
kernel/sched/ext.c:5524:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
 5524 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
      |                                  ^~~~~~~~~~~~~~~~~~~
      |                                  HK_TYPE_DOMAIN

missed HK_TYPE_DOMAIN_BOOT is introduced in this commit:

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
