Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D0C3ACA65
	for <patches@lists.linux.dev>; Mon,  4 May 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777914367; cv=none; b=pX2pEz1PNcvqhNPaMI6wuodUk60zq2SorhmjMPqZ3K+fqk56ZrM2ZE/uV+s4/aa/jSC54BZgqf92DHSRSChS08qaQ9kq8qoKY+o0R0HKcJa4+fQKs6z0FAkc6mj8po4xqd0mDveAmYkfHM8zGqtcCnyNOb1C8xkDyXH0KrCWqQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777914367; c=relaxed/simple;
	bh=E1AcLk8yHFPszixVdXasImuq2CqIwp8AyUQdxUPaFxM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ckzmJXApylCwPGQgknSJ/cI/jcLI8jqZExUjNXV+so6mRaat4liojqdCYNTL98+ajup6yQV1ITGMTQoHXhRNgk0RPXCFcl8SczCPwZEYUYoE2eiMvQhma0gICwwhQLGffS7rNcgjEwAq8f6FbfuwS8EZ21Vr8LrFAoxqJU0C9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=W+RxvsOx; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="W+RxvsOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1777914346;
	bh=uIk2Y9HeeoS78SLWasIDhipN/GYx9yAXe7UFugTa7X8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=W+RxvsOx+FmYogo6+yRY6F+4tReNC4BX542hjgpE8n6Jl/SlKSfZi61thdxKZcTQA
	 50EIi0JVczn6zygsFtIRKbmW0rnCBr4VJX+XKb4afW+Sh+HltB0UKYcrb5dM6AlJo4
	 v+/X9dY8YVLGHt2pjdC5u2YmVDFLjYemldxZBr/E=
X-QQ-mid: zesmtpip2t1777914340t6acbb486
X-QQ-Originating-IP: Nz3D9vAql6z84OnwlRP0yXkOQTkLzaThNdNgctz3tpk=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 05 May 2026 01:05:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4050741224278605350
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
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
Date: Tue,  5 May 2026 01:04:19 +0800
Message-Id: <20260504170419.1313610-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N8C4ARcmNX5DiA5Vuu0G32nvsp0ZRAptnS+GBqe/WL1vmxX/lJa8G7TT
	j3K5rs+qa1OENnEBWprxeiuIrlILGucqKjE+eXa3C+GKSWY0WGMxa5zuGokYS6k3UW2rLkB
	ZxWMNXDyqIBFLnIFr69p/UaFpo+nem6zpFPfY574qg6lhxrH1KCxyZqgJHBfW3xH/F3juBG
	hx6Yejb+UL1ews0Iq/GACVWgXZSEXHR+smzLCxgytDeU7ERKORqigtXWreXt89cbNfnfm7h
	1657pQADDXaK+Ov9VDsHwzXmZo7TKlhu+dsuzInHD/nFRB36YmHbG9FIbQq9W+89KBgGTiI
	S1TJ2IGkmdQ8dNUrbHhi4vG0qS6M/qe4JM9bXMA4OizpKolkayBJJgo+sJYQQ0SrGfx3XsM
	C7gRaAsLyTe2WY30WUgk9XxPJ0mP/WamzDpBpM2RwXa8hV1OnqntmDRuyGi6AXs9CS1o3/E
	gz8hYxTH1B7BY39UH3Ou5qTK1Ty5o6JXT46yZ5bJJfDyCtg+fr1XTZPfAh50I34qWcmHf0+
	IBm6AaDQFtvKzjsFokXKhEoA8knREjUayzaryFrBXBsJoBnh8kQGq4Ugjz4j9RkRAiDea94
	d/q2MXgv+ltzuvnsz4EntODk2gApsOprK/xvAhFLmp4SzVrh+cHBxX5r+nOkbpjeMk4LPt1
	SXOOcy1f1G0YjU01d5aS6o8A/8xmS9XXOAviqvsH7uqxy07/sLrLRkUd/3fDD3pI78o0Jkf
	bN29s1vMED6JngAd+98nY2gfDDLJxVUXoN7h4V/21HjUvQmXUzUXR/o7kzTwMHyM2DCa0BB
	L5S6nAsGDhQQgU0sU40c4NrjiERHZ/0DEgercdZQiko33x7rTcNKuPqvaEDACEljKL4fUJq
	Jm1wx+c/OI4uqBXHzaXOvnilfMAemHmOKOQQEjGTGEK9bUsjk9ZjHT/5K564Mupf0HWMwXU
	x45CY+xGn5BrCKLdmBiCwzHe9Ku5vcIPnVAFd6o2LbWzN4N/VoBUHuFy4toRefI4Nn2YIay
	300M9AIrEKrNUqWWqlQyq84NOnni8K3A0MxXWfrfKym+zydmtlU7ZQWkgvCzxJGEW99kswK
	w==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
strings vmlinux-* | grep "Linux version 6.18.27-rc1"
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Mon May  4 23:35:30 CST 2026
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Mon May  4 23:51:50 CST 2026
Linux version 6.18.27-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.27-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Tue May  5 00:07:43 CST 2026
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.27-rc1-gbc63ee3bfa32 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Mon May  4 23:17:29 CST 2026
