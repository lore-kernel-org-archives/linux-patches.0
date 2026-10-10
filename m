Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37B7136672
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791669473; cv=none; b=Ze7N3S702U9YWXMwGcPoqCZU/s/Jdw4lI2HR8EwtBfzSTP3cnaPxbqY7IYyqO+G1aMBfIu0fGLZE81PJJyur7SMpu3dyb+RDSblQ2Ap8X8y7wgPS4EjBNF46Cek5It+i1z3QImiyV7xX2WdapdvBftHbFJlpcUv0SvLcIVRp1hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791669473; c=relaxed/simple;
	bh=kF1vIg6wuT7JfeciO4XWmCq8rpqhNnRk133JJ7iDXSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=okGiuXpX8b53V9kbp9tcLOsqA515viwT4hI4MN/Grp0MhEB13wR9M4sCkFViHu/ShVmEvM4Zw28oFSjfCyL9gYYeunzQ6z/FU5rl+STthKWtOCorsv1DZUajljoRPEifJyU7bKDYPQlWPc3u75Kc3m0FeflIqhnqkC1TMEUEUYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=C45nL0Bd; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="C45nL0Bd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791669446;
	bh=kF1vIg6wuT7JfeciO4XWmCq8rpqhNnRk133JJ7iDXSA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=C45nL0BdVrTi1liO0j1GHJJByWNap5lUSvRHcOIknD+4BWFuhR88FJioNuYKdSRRs
	 PFJ8RXxe2Cbptd9zmltMDdI+NzmnlCoynordsvmukQzp8aSzqwHJJescv0S+YvoKRw
	 it08iFg2MXLKmIP6dbzuqcVpzDjtaaSlGFYbH8Gg=
X-QQ-mid: zesmtpgz8t1791669440t4b658cc0
X-QQ-Originating-IP: HnqkvZVzdsNCBZznttJs/eYN10dkI2YMrSJMi4M4ux0=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 11 Oct 2026 05:57:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17404115560996670581
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
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
Date: Sun, 11 Oct 2026 05:57:12 +0800
Message-Id: <20261010215712.3161965-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NU60Kbs86PFjGc4SHltBQk0qJlKu3nSY8/fQ6lqUtZdx4JLmwp1oj1BY
	TtCQUdk7ET3GmeY3GGU9teBWJyPF3BElGHiX5EejBztgq+EJllxlMlX+IHWs0gJ/AfaXNdZ
	c9fdE8hYoaag261hQuc0cLtpPgg0Uxj2TPAzYR6iFwJaqs8jS7rNDHMM8SISCP/slX1VwEZ
	kCc9AWjeknr9+eUxJaBXVbhRe6DKfBhbDsUYVhGmzVe/jg0e1wzrDf0qkP+QJEM1ZkFYWgO
	XcLvxH/SLUBBY0pCst0xPXikt5u2P0bQQLZM5Kp9DlIISsYW1zbgQkeQDaeHAhduebDOsjx
	uCttP32hgRJ0s26rCtblcOxaKec7tqoRgxupzd8k0JXuppm2Rj9GNwq8G1BUvyiI169Whl/
	3pCWvTzZ8h3TYRzDTZToYt8ltRSw8O7wE2orT5iKtEgIRFfi0XDf1J1Mjz1KiQ2s8dEaK7V
	2j+syBz42CpUS1WakY8t7hzAkrAsiu1lkAXwhyaHCTtlgz3AIJ39sT8o21sHjGC9+9q7LIg
	9xZ0qjPY/MpejsCnCn5N3cC2Y2pheiLv5mASItPToHKii9o91yZhhe4PIraB9b/NNF4flMv
	JF4f5xxSSxrvwy2Haw6P3smeNFxImtcB6OkZT3G2MHUNdO6QF+H1MDXElGGt4NFJR2r0Fs0
	x7jzZb20KI/2y2osG6gcrw4SNtj6zBUYR/lf6XCknLvtHrm21lZGogXRnfg5CRvy0MRoCJz
	4hDO1QcoYhnW9LiT7GF47Y0/8KuV62pvZi6vFjEL69j8GIhqXPxNtMvENEUe4pp7QJnq30X
	DXjB2a3h9EXJBNe0sIlka9iTsuWapMX/7F3E6XE072S92J5GyLe2AZeWpChCJstXPIvOYXk
	jUMhXrjgcolE+uguz0ILlTvr+Mh8JycY/FyZ9Zo7p9/uWb2v9JDeUmTVp3Ijge0L+1G9mlS
	ssTxx9yD569qt8LwKA/DiA11P2IMCTGn3Y2Rkcukhuk4me/saLSDvRBx7YBI/iypCN++Y7N
	dTJraIUQWhHrPOgISuiPOE6DP0p4WxaviAgaS/N+Ae8LoanL7Qtj7sMjsYOW7+UCor5ExfR
	w==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv64 config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

log
Linux version 6.18.56-rc1-gda42e30e9b04 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sun Oct 11 04:00:00 CST 202
Linux version 6.18.56-rc1-gda42e30e9b04 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun Oct 11 04:20:41 CST 202
Linux version 6.18.56-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sun Oct 11 04:39:54 CST 2026
Linux version 6.18.56-rc1-gda42e30e9b04 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun Oct 11 03:39:16 CST 2026

