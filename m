Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAA1D514E
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299682; cv=none; b=kNGFIb6YcOtGV7iqKN5RkubsuHQ7rce783GdodJ4yovDsiaiQ9xL1hA0N4WHK/PDZ8UddCdoTGsRSN7s1xXMZ3hvk/G9MDjkPlgK34vFa22oRdiI6A1mYzvTHkH7asodc1dH5tLAZI+bALkOkqWbqUQZdQ0mc6OR0jl6nXAtaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299682; c=relaxed/simple;
	bh=8DC/CiaERW17Q5mUFwMipX/LNuykz/ZNwmGFCVVvf/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C28+JGDVcGqmmaeCwzssXr3wpTq2FOquWMCgv+Vmpvj8lADAkypgoJRN6+SJIZcnv2Wm90zruHTol0VDncnrN8dRd/tS1/23dVgj58A5bJ9MBwAR7TnzrFGbpB7HqzoqfIpzrAKXQ6kjDYGsT6CodBOmp0pK290bW1t8+OjUoVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JFirxtg3; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JFirxtg3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784299659;
	bh=6JzeASk9jwDLgL6o0FbyFZ25btIeFesG/TB+SvbFpwk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JFirxtg3sQOu1yh8AgTMh4CagTqljg4GFse1SXOV1y7MjaqE5KK4NLqjPx7kcDA7w
	 cxj5TRvTEkC7IxP9e6brvCfhlllXLs+7HWmZFC/XP/aXbby9m4n5GOi6svbCj5MpVT
	 21dmxNKfuGMc+HTpffAgalKm/XOzGVf84XUgYsnk=
X-QQ-mid: esmtpsz16t1784299652tb02afd81
X-QQ-Originating-IP: hZfxU+CzM6MzYjuR1wiZzMwDER2bSv9D9iNf1ncJYO0=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 17 Jul 2026 22:47:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17506133365807019503
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
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
Date: Fri, 17 Jul 2026 22:47:24 +0800
Message-Id: <20260717144724.111189-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OKoUMtfBBN2HS6Um5Pmfi787bCc3ooq2LhfxUUSJphzv761yDZY1yO4R
	/vnw3YkPZ0NJ0FcHStXICvmdxoI4QWnqXIwh8AJLW8fpaG9+fUlz9VzXuJxUoHdugPMw+Db
	ZlcSxtEJv6/AG0ZDhUy97DcsoL5yTmLgG3OMiLzZ1iqTm0xILVfUABhPNNjmrZ3rYlcDTWf
	PimDxmVfzOKfwIno/tCrxZNv8trAz9TGBQsWgi4cKq63cThvewddbgk4+FLGGknJEw1dNsq
	j9963GOzN0KCytJDUjHa/umAW/DCpcTsUxcWQ3QSiL/pDxFXgzXi60GNjOnLe6dASc1nn++
	wO/O8XiBn1VBn1S3U+Jqhu5cmhmq0DIFT5lCMUWfLorUeiAnOerHZJQmcRfCsSH17WyTI/A
	prf4K8uIt+gwqWPmiRugGFEAvwpaOEWPhiRcbAVS0hFbAbvh0UcoPiMIruyKUh0A3jOH/wX
	Ecb6TG1UhFmg6u8G3eQQ8Kk97uvc+u3laxjecOKhiJ5RfCq/+OvKjGIYiHGAxRM+9fBFvaF
	gpgQbOF/JbBI2mQ/fsEZx+3Ipo/xOeFxKOJOmZJGcYccpb4yruQOFcjlQDe6/9BcUbTocZN
	9I/e8gTRZo2J4ripxt5HANvNCYMrENErT/g3i16Ss+D3HjxIC3eGQyIMH0Qs1UQIB4N+s3i
	wYrzvvfysw1qlH/WDpzy7qYA7gLhBb7p/erCoVK4UDMuZuZK3c26IerCh5w1gx6g5Vwi0py
	ET8aLLclScPRPdsaXCGAVk1iUEpBDBdhNQbZA+/3YTG7zNnUw65zGwdgyhyeV6NAtBRDk+m
	DZJar5WCFk0U4jNg3GuhvvYBloZK7XWs8ZR1zdr/0So1wCtbh78ZDzBcOh0rmYIfYZe7h0q
	JfkPvCsPQOA+DkFpJTxWer6VwHcXTcBynxtDfcZonr3SAhss6YsDAqB2bOSPkrEKFQH+dJT
	8/kLH/b3iNP89JjA9ubat2gx7sWRNPUADhwzqjLqmodVSKIIsjFRuGrwalIkmjV+H2l55+Q
	R5pEmb+sCEgGcsZFHWCduIpZLFSeUB55z5YFAmdubqqNPr1W+b4Rhx7ulTEmFyIRGa+dW05
	W57kAgSj+iE9UWL3fjPFjnUbycUg1r0S3exhY4IhY2E
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Jul 17 02:48:08 CST 2026
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Jul 17 03:05:33 CST 2026
Linux version 6.18.39-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.39-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Fri Jul 17 03:22:05 CST 2026
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.39-rc1-g8b991bdbbd89 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jul 17 02:27:34 CST 2026

