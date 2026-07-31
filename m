Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44F42566F7
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 05:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785474400; cv=none; b=b9KD5gGkgnFSKKbNShqzlj5x29fehcYhHbTxwrkCaXUhOSq1bEwYGjGyEYJYIQURix1coO2iiD1A9O9p/EKbu/TW8rb/VXq806p83Opq8vn2PNBCpGmjpExlSWsZca0c7e0iqYCUlqpVKhSse1bjRg+X2MuotH1oAJI0k1jQU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785474400; c=relaxed/simple;
	bh=AC1aCGGF7i7PNCvAs2VTA83SmIkCRDsYvUzW4JlAGQg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GwqIb4+Vi1juGM4/Uss5+HrZlFBrkC7WfW27vkclYIclPN1RHqn1WkvUBeBSCD0ciIKK5acEKDlWUNRx3W3qZBwW7enQOUbrC9z9IMLKAYqKCOeejF5ZpmlTornEXdZXhFIcX4F8d9UtW39/r6LwWeDPhES+LRlKQxm/Cw35npU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=RT3tPTya; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="RT3tPTya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785474372;
	bh=AC1aCGGF7i7PNCvAs2VTA83SmIkCRDsYvUzW4JlAGQg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=RT3tPTyaXI766cutWCEX8JICha1OI58Qq/jweAXDb90w9iPBr6TNJoqohUV0pdwZr
	 p2WaDhZemvbOYbyG1dqCqfz6DUa35mxjlOqgBxPsHh6q2jOtCEdLEvy2EXBwkc4H2l
	 xbdaYPg6QjiH2Dpx1pIhFkP7HtuFOnkjJFmold1c=
X-QQ-mid: zesmtpsz4t1785474365t5463c04b
X-QQ-Originating-IP: xA2G7VDyRJ76V1Tmq7ui1U87cPouK9vQ7D4XA8/qAGU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 31 Jul 2026 13:06:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2940425011589697088
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
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Date: Fri, 31 Jul 2026 13:06:00 +0800
Message-Id: <20260731050600.550567-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ONalwM1aM/hiQmtOZV5Kwr4QRk//2jplMZ7VmSkGmE5g0bcHQwpEuLj1
	+i5hH66OYRFRM0y7XZBACWIMFc9W+CWGhzF0jaIga8Sky/JyG4uhrVhZvubQzmNXk31wQnm
	4b2PxO4Frya1J5bmpWpuOp01TaiZU9YEI7YG/XPQhF8LoyG25f4Go0a49XHujRDNQg3X7/s
	YKfRZ9cGwJ2eRI5+jFVOWSjKe2uqOb1Sup2/qMLhRP/MA0gDFSpEWw8/naw7QzsrgGQmoHT
	bJCRPSl25ezwm9GvcjMKw0IFfFIyVcWhqD9gdGtqMho2EqP0Wl6ok4hddFDTLA4NvUk9j0I
	bVlPeK0u6r52mUqTdGGjeX335qOBkaDEmF4+jhogq9RrV/cGh0dWm4WNsZOcSIl1X+VloSP
	kMd68fHZAxZwK1Bfy58s4d3sAqedjUd1J/+d/udF0tBS+lene+snWq9LmA4/jKs3irb3eYM
	PLgTCNDI5L50rrPArBUxFaKok8BvdzzcJfDGSxLei5A2m3q0ZYHd+HYBbWyzQebRnUK5QMe
	gPj1ZUY4EGuX5qpMKokynmroiNm/ZdqBp24E88ppB0fGapg87zuZCRbXsPMmVPemB2UZEct
	vhtE5FvtMIYa1pMqeW7+omeWC9uBmwZxKbwyuV1n1jfUICGqXdTF4up7soYb2km3kd+NeCR
	ZDV7AANcJTsX/85d2hqY5i0qGEM+tYhmmxDscHARuyujCTVzeb89uRtmqqNhUCRNJ0on9bA
	AwbeQ1Dh4OorYe8KwBYnJKfq8eqjp3K/EwQGw7SWht1bi/LF1huveXboOYvkPZVlwjpZcoJ
	uq1/jhhh3/y2zK2PnoBMB4LMSBHp6RERkCcOheMO5eg4u2z2GRl3G65hzosKdfRgwjvd2d/
	iM+/80xhgR2A6VRBYVHrWVd5/gdpfEWPjm29buGoiCzPqOLaMbeqlO7F1mfpETMT3vRmem4
	KwrsslCivHrTLzd49v22rdGC20iv7GJhJqf/W5R1ClY/87GKiczz3hYujLDEQ2MpAYAhiiK
	wEZI56wDL165H3JK7BgoGgfVvs84qqFTU1DMTRJoqZBeYasWZyc0H39dwKeoO+FxTKTkGyp
	e2ao/q2ritr
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Hello,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.148-rc1-arm64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.148-rc1-arm64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Fri Jul 31 11:50:50 CST 2026
Linux version 6.6.148-rc1-loong64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.148-rc1-loong64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Fri Jul 31 12:08:17 CST 2026
Linux version 6.6.148-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.148-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Fri Jul 31 12:24:40 CST 2026
Linux version 6.6.148-rc1-amd64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.148-rc1-amd64-desktop-hwe-g7f195ac3d444 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jul 31 11:32:42 CST 2026

