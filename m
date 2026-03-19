Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD2A36BCD7
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773903557; cv=none; b=puxSk6XQZQzdRXWvN0YtB6ofdqFRpcwvLNvVOsACxDb7pivRHYGRVXTZpH30Xzn/CMQpA33c9nwZyZUo+WnwLoc/GXsGHEvZ4dZGOI80T18MfPRl9NpIqfDrM/nmgmfW67Qe49JN9y47eAOuJkUsbpiWy5Mzi9WiZaThs8KgzDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773903557; c=relaxed/simple;
	bh=tfSo07p9kP2k0yOq/vyE8jSA85R5JBaNYmOl4Di8iWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dmy6xIo0jTkixG6IDUlsRzpYXECPwSLlvY9w+j9znguOBQU3JXkdaC5v8ys5peWsEfjrPLQdvbBowmJj0VD4P5ZkBsQXXf8JTC3b7cJWsUXJGePDC2g59RRHtTattFnL2GFU7wvEVsK+SPNhkYysKnN5/ih+BMwvpV7RYIa/JsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=eYVb1JgF; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="eYVb1JgF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1773903502;
	bh=tfSo07p9kP2k0yOq/vyE8jSA85R5JBaNYmOl4Di8iWs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=eYVb1JgFKg1jOEJ/VH1RJrDT3VdQa1mu4/RCCuTo2rOTLGstJkpz3kW/QqRXQRz7E
	 FDoOxgD6dXm2Fbr1qMSSbn2N8lvTBVbi8Ws4YDtoMCKsivKN/8fBBk87qfP35tNDJ6
	 7UmdR/cCPN7lMv4IP+6f0M7WDIhfXlQWNAdttrPE=
X-QQ-mid: zesmtpip3t1773903495t1cdd0f2e
X-QQ-Originating-IP: Z14SeiRpFBicsPXaWHT63VJxEZPfcm7o6/zAG1l1+gw=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 19 Mar 2026 14:58:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4130904497638004089
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
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
Date: Thu, 19 Mar 2026 14:57:14 +0800
Message-Id: <20260319065714.925454-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
References: <20260318122621.714862892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OPf0glEsUFOQi8r/9kwQt1mbs/ywgIYLyJQP1Zj/+BUjQPNSnXA2JHeb
	qWviGXUtBZgz7ljNNTSg1bHdTDIg7wRRsmS2+ZlXlrFHOw0gqoB2WYizLfC1OBGP+r0rhLP
	B+/Uh6JweFKAMZl3IduR1jupe2x2mEhcC3vsiIRjtBbTX3/xs+c29FF+QlAggCAsBA3AOZ/
	Cck4lKz5xWi2EBnygq+clrzoEz3Y0AJCEeRFLx1Axt674i487NPJ0m7k/HxWZlPuCz/vWNb
	zFYEoJT7raGLtI0BUwoF6/gaOnB7sx7zdiJfUT+igMZZ85MvN1iTAKR7hQKEvp7alOo6LV5
	B5V4iDqFjOvtkA2lqzINsoGwg/GVPBiiCSxMv0lnxT77USRyzoK7bYsyUcTnnaXSlgzETst
	VjXG4OoVwebsYVzQ6CEJBEnawhE60ELxQZXuKzJDmMhYGQjr8q8VAtBISG0R01Q3CKOOt4g
	HmN9/HvvcS7pDjyxuLyCgoUL1E+mnY3yjStrNKViSY9rOiIsRKbneYRDa/0xEdNCuw17/WS
	/MabBTNl9YqBCnH2LLf6qtUgkbFoHDUyWU2l19Hb3FZCZu8uQZy0rkblc5ezVn1EPJfWLq5
	rgtYD3Eeny6tkQEICwGumjpmTpPfmJVYwNbai8gWxP2E7i5WGg99FZ0cKWNxkhoCiH1zBPP
	KDVvgMoq6fqTiJtuPCGosA+td8PL/f7yNruy5Fwdysah9HpN8LxjZOBokqplIbJpeofUOp3
	ogBkSEg4ZbS+PVUYA5J7X3sf1hg7Mxb8Ra5f9q6fiatnDdGtVxijV/5w3p+116wyDxQ2RbL
	L2+EyWXySdmnZy0XXWiTJ0v2eI7g5Bj0Zb4fFnSN0izUtmlSFNcAcshnMh7B+edzTTVWQqv
	/WExbnvTC2QRNxCAuBPzal8LcS2TF7q6fA/p+Uza3g2Q0fIurveF2mqVc91XxzOvNnOpHhO
	mMopUplJUs9LxZ1wI6R/LTvnWweP3pZRzP1R/sIaoxDX+p+l6jQmmEORtj2y2yxdV3q2Oa6
	lIP4UveCISOwTGsFbdXpt5ellYYEw=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Hello,

Now build success in our x86,arm64,loongarch config without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
strings vmlinux-* | grep "Linux version 6.18.19-rc2"
Linux version 6.18.19-rc2-g1cc312cd0408-dirty (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.19-rc2-g1cc312cd0408-dirty (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #25.01.00.17 SMP PREEMPT_DYNAMIC Thu Mar 19 13:43:54 CST 2026
Linux version 6.18.19-rc2-loong64-desktop-hwe-g1cc312cd0408-dirty (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.19-rc2-loong64-desktop-hwe-g1cc312cd0408-dirty (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #25.01.00.17 SMP PREEMPT_DYNAMIC Thu Mar 19 14:25:35 CST 2026
Linux version 6.18.19-rc2-g1cc312cd0408-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.19-rc2-g1cc312cd0408-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #25.01.00.17 SMP PREEMPT_DYNAMIC Thu Mar 19 12:35:44 CST 2026

