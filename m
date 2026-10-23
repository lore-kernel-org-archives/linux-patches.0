Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785171;
	b=HO4kKF2tcJA/NnWlP+61WfX3Xj3OFyacQ6ir0xEazcmNo+tuw2b8ZUPCSVBFwYqiBETE
	 q/giVnWMz7+oUqYQUTHCE8qtyha9LiWoif5EAnNRxiDb4Seq77eWt/ufCqO5sTjnP0nTv
	 oPrPSv+vrUTTuQ6vs3s4ZfEJTbO+Rwxi14/w9QXmlJrsajmiZAjr7q3vHkoxEJvOQZnJ7
	 S9DwiEIoCdyj06XS7Bh8Nl7imMbySjTIDlFuyzz7VP5dwLGajcix5XqGuWrVxTp59KyzI
	 3uwKpVMLqaIRPLgNDZ71E81WlI3M/F8aFgmEiogTzHSOYpFtAVLbXvCdd7OtsCliZ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785171;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=rnlgBlJdoi/Lf0uvy9ypW1BedLBEO284FqI2+C9pzoI=;
	b=C5rIUWuxWgRgvGnjQYVu4cJ+8Wqa7bZ28j/AI33rLIJvLEyiMTqhqPAw8juJN1GjLCyw
	 PthfYSKOBwAFVI7W1tsavDnE9wyK36Kt9DBk+XpoVVlyuR6DWh0Hh8SUCC3cqTo4r/0Dh
	 IGDygtUVzH3h9z0T/biv51pl5A9chVYlGC1Tf2Nxzy3qN3bjaX4QpCvFq+DMrcOg8Hk7R
	 LnajWiNXg0HX5PexpjIDrHfmKM1QWiNITHhaFVtgKRh2eLd8+22EYghToxMTNAgS2w96U
	 FoBGH14OOKAUx8Y8PWPi+ajVS0syjjx7e1ERJ4kihwuN/zQfLIttcgCJua+zK1eUPGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=XbDcnUce;
	arc=none smtp.remote-ip=54.204.34.129
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A84606A31B
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 19:52:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5A84606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=XbDcnUce
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792785151;
	bh=rnlgBlJdoi/Lf0uvy9ypW1BedLBEO284FqI2+C9pzoI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=XbDcnUceBoAQP1KHH8wibcgH1sDQ3RigQ0Ck73XChpFbEf6MirL4B59Qa96iC8wve
	 tS5iC1v1uPlAZh3sPfKLwpg7o7jMdE/PlZIjJRvhtLWlgrJWuHbJpQITuE03+lSfj9
	 /FIoRcMmZ3gmrTX7o4+uAEq2x94WinaqcU0vq51s=
X-QQ-mid: zesmtpip2t1792785146t50c22cbb
X-QQ-Originating-IP: Lzp/JTaI8sacwT/+K1muiCHUFVO0LZJkGvRkb4kJo3s=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 24 Oct 2026 03:52:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6745179872912661611
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Date: Sat, 24 Oct 2026 03:52:16 +0800
Message-Id: <20261023195216.2314828-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OYKM/pSuXZktyvI1Cr5T0vK7A81fatkvCXAaT2CFal49HL0LG3qJztlq
	npdXTcO7WqRfg/BLn7z5mRZRj4MkH9teFiv/wIq+nJFEYHUOMUBYqeUAlABKdRZ7Xl1umR7
	qSnIaPLIgsZcSQ1rrD3ncWx+P3T7dC3QiQMc/yO410qzQHdc9eOsy+r0I7wqeFQtCwbbD+S
	apyAaLAjwqfTi0kWdjDRCdPHpSbLGSGTxw9G2NTNZbjNzaVFvtn7z9IDcdqIAwH/qCylCGY
	tdnzT0C2O+hfdoUJUIU3+eBydjaZyCEE//rlIJ33uXX68Z5v1xHwDfn4p4RDn/zMbDF2f0s
	O3867mvJOVkHP1OEJ9m4DSiWN7Ex/0K73s4bkBK9sztsqDvbVShcMNjfNsnQ48nTrFiewrC
	RZxmNBMkSuNJcgYjayp1dnOua+JJN1SFHsTFIqB3VDSzfKJHQZlnB9ejUeiZLv8AsVkfqzT
	vM2Y6k2yfNkIV7rQ+VNhs1xIW4vzQgZ04LED1BbwqDOZcheDio1CrBzpde/urrCY2rV3ATG
	383INlrHLsVsY1ecTFepQJodWDFRo9reHUprhrQ+W8YjD/NbwljU9xmRjAiKXV7Fi9sWVn0
	2QBVstT/fOJPdaKJcUYC7rgFHv+HGa2QgScB4kG9cEdWQWL/pyy7LV1htemPYXevMEZYv0h
	k59pzCMlVE+8cf0McM1XoPQaGl6Yijdg5jGC+obmnxBnWdN03h2Mym9+OxGxGSIMPj43r9Z
	m0AMitv9ZXA7Rc28BUbv7p6uNULyEWRAAxvMb7cLN2DX/zP1kVZ+YV+cxyBKpwuSgNQ8EZ+
	unHoE9+sGg6OJb1lw2r65G7treGDuRLTjDU14mkdHbbtR9sikP3cF+kEWpXxM7+lwW1NVY6
	cYYdaZSZtFnZyb3y8ucRq4SQPPEompE2E85SrEJ0gUFd9/gmG/l7qoacF7cQt3lXug5ZU3a
	M9b46JPNE/6B7v9Ml4SxkOnNuhpQe7A3vm3BVtx8dLu+ifJ063wn5cFh6/dH4KBHjiNst5q
	CXyGVgvFlRAf1n1fnIU+z3MczrOHuybXKVAq+TUK1pm5/3GGT2WIDl6NrIo+JG+UcxXDmi5
	w==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.59-rc1-gbd77a04827b6 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sat Oct 24 02:16:34 CST 2026
Linux version 6.18.59-rc1-gbd77a04827b6 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Oct 24 02:36:59 CST 2026
Linux version 6.18.59-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Oct 24 02:55:47 CST 2026
Linux version 6.18.59-rc1-gbd77a04827b6 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Oct 24 01:55:04 CST 2026

