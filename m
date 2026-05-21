Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352BD3A6EE7
	for <patches@lists.linux.dev>; Thu, 21 May 2026 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363851; cv=none; b=Pw3Y9Qym0mEVGGLOgytmhFjqujzH8HYHYNmpZ26VuqEezFtIQ8Zukpffcg3kPbvZ7ORpeIpqMI/vIT3j45CTnWzQPoiZLnWBGbzmgR9k1EBr1C5Fx+WVtVCx99ZNRAjdDGhaGUZyxVb3f3zzZKUK4ohnxuMKuEZ0aLPSkLPvT7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363851; c=relaxed/simple;
	bh=7h37GX1wcmywvJ3Wzq3s1EKqDrJo/hFwIrKJhy7/0rY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKGFUDDxqsWioRVRXzyoSdq0wcoIEYxStwWMjwvekoOWIJ9UqeX/lsg8y+b59QAA6a8oNTyGufBg2W5FehtSxsR+RBdRons6hAVP9fxs1wA2DMHgUHXMBgdyudQKKvCNCcwPoOdXk5GKhCisqzflmOKkjhVppsolDdp5MqAHFdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=YlZVLkwU; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="YlZVLkwU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1779363822;
	bh=Mg94N7FQgywmG02cYGRlFlcn0lX/r90w5Bzk+bIY0p0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=YlZVLkwUBG+O7m4WewrBymBNanpk2MeUYq2r2YThsZ/Kayz0ZlByVo25+2qCBQ/+t
	 8KqeNUw9mZAzYNsMJy8mJIsoeUPQXDZrycSqPXwCvuApDeoRRwQROp+usW/8GMPjEj
	 8VT7ok1QN4/wuOYzPSbrOBLfYcU5JfEvdqCx8qmI=
X-QQ-mid: zesmtpgz8t1779363816t1905b49e
X-QQ-Originating-IP: E4V5oVKH4h9VuNW3JnH52ZODYyn7jcOt/9iCo0lNCIU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 21 May 2026 19:43:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7367027533482139346
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
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
Date: Thu, 21 May 2026 19:41:49 +0800
Message-Id: <20260521114148.1195326-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NbAqzpwV8myl6G0oQv4muJuiK97uKZ4I9dPP87W2NnlzUpHekHCgPI4t
	3XIvOpknQtE6AUfJwITBIL25GGR8iegcjLfizu8q2dKOKc8C2UtuxMOFniZ1q6liRDfaJpB
	UQOEB+7+YUCawCb/nEYBjkd/GwyDdgV+SXX78ocz4c9oeqCgK5wGnzubzbx7tj99xjvmdMr
	vXj5vd9JvONj88BvC1B/NHL5b/QJLtJvCcwoB+xgfH2zM/uQ8RvsWTVWfjT+4zenIfBDGkt
	b976eqwSdnyAjFbhpPoZOY7ujNSmKogjh6QbXe2n/y7tuhicpBrbazG+bvRoimruuO5VxSb
	VXTt5xtU0qUKjIqPAK3vNN9AJtnaawruAbvDF/Nk2dJpfRxD32wA638FEcYqdbzIk1AQXQZ
	MoakHpHKOOpmeyozIWyY2zCA9Otd9D+w17RED0fUyZCGDqMCEMAnPEuibesvuqpQF1SgeO0
	WjNoMIh4gH/CR5vmIkhoAxny3H5noqe3nHqbelgiBpAY/l+BZCnLLMkbrwsbERq2k8hy7ym
	Jk6gP/lcY/U4OBsti1w3e4wZpXmwEVqrBBFGDzMLcAwcstGfApmwnjlN5uExC2isM/Oq28n
	fmhAc/FySp5OSgAj88ounx2+WJjAC8WcT6wi8ZWqiftuoQ9iw2jn5Mtuw16t6Ik9nlvQDRe
	FkrHUpWNzrb0hkEZmbnEY6yfFAA+eWfkCCi93fs/UsMNtIXio7c8iyJiaBje2IP20oq2qcd
	WkZUmDojC279Nml73A2mHDHwMOqW902/HcccELDN7lrB2amyQ2rYtriuKQGSW+u0KgnN7EB
	Eg1foB5YVEvxLvhg9PswuDJLxrfw6aRgAd03Sa/D/692CHJxH6jrkaxzgRVejT6BT/rYaXn
	TTvEm0KzKLxcFr9OCHoWO5qadCUnkmGa2EFNc3oNnPGWPuqG5bSi6kV5Bnz2RDPhJZ4qIkE
	mHJyFEEyUiSh2hmh+pupStWG1vzhXEQMYuWzV/MorTUm+X8LQmaPe77lXL3rSm59xu3eYDh
	+CYrcyd58MdviLWPBseQBITw1dHP0TH4MT7gCLKeWMAo6M6PpVWo9x4LPlmSM1ZYaRh0VTU
	KOjdtMGQqgZ
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch config successfully without error.

Failed in riscv config,
you can revert af7b502c916a4950d697b67f5e39c19cfeb5da4b to build ok. 
Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan


Log:
arch/riscv/net/bpf_jit_comp64.c: In function ‘arch_prepare_bpf_trampoline’:
arch/riscv/net/bpf_jit_comp64.c:1064:9: error: implicit declaration of function ‘bpf_flush_icache’ [-Werror=implicit-function-declaration]
 1064 |         bpf_flush_icache(ctx.insns, ctx.insns + ctx.ninsns);
      |         ^~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
