Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E096348C4A
	for <patches@lists.linux.dev>; Fri,  7 Aug 2026 23:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786147003; cv=none; b=bnGSN2+xHuOQE17Khsd4LnAcnD0LxvpaB3zdja9KiZ2QGHwzSh+uBmDytbFwU94Jlkuvjrk1MpQkKCYODsPGA6nfgdM8F4iJHvV73Zi2er+c7TjJKNU0hLhbMC/q6kqmDjpXt1Ry19RnzA6vavG/XHEP2VKZkrAHR+44BuJLUqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786147003; c=relaxed/simple;
	bh=fztLXNkLwDRldFAmG1aPaLQNpdq3egGVMw7zm4MYGdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=maOmBHr8x6HSGsqbXCINpJ6AM9dasopIM21NGHp6fYhfNxZkerspeUi18OuKRxZCGMFe36LiTBndxQtETFR2AzH/1KWWOc2lZ0W6yY8jRf2Nx/Zr647fxjwK9WuAOKLAsrSMR3M2tYhY5ilItaJ7dCyCLPX83hyNy9N5lCKLBmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=LydSozzF; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="LydSozzF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1786146982;
	bh=7zzHoUy+XXElensoWWqn+e+95Nf92DyhIWN8zVXtZu0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=LydSozzF9HL1GL1es9+Z0WxLT+0WRz8dbOx2EzfWdM7A4vAmk0h0Ud7aeAJn6rY/h
	 oRyaCs0mWxv8L6peo66YkkRl3BXNLbseSqKllylzS8jlBYpjWbSrffk6SrILukorJu
	 XSwbIw/1pXDavKekCiTbmgwtIHM3YdH8GZzyNRLg=
X-QQ-mid: zesmtpsz8t1786146976tea63db26
X-QQ-Originating-IP: /nekMsCsHimHHSWq6nbJ1SfFEIeAR7lPuL7J+lhqhvI=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 08 Aug 2026 07:56:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3036720188150160835
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
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
Date: Sat,  8 Aug 2026 07:52:08 +0800
Message-Id: <20260807235208.910225-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Nn0cKypYUfjdAuFw5qvlFTt/cS7HnOKx7Z7INCGALxhPB+yTda/6sRyo
	DGDK6ZFoNKh7hK7T50uUxtz3cr/k47EmBwePyjHLpMrLq5++dl0J1Z6Lu4/u4nU8ywdZewl
	bfYwGSMF+qYafQGq6xsKmXb/bsmNQjERmP0BU594D4sd3174muaMjOiAej+7aswFOA2TBjd
	XRZYmEHCqWrXK4W3u4exTmXmn4UcUWU1YTdiyeklGqpZzSrc7imSto6W/ry3drT036ClgBi
	QGzpOhqYfgx69Ypi4VN/C/yiRpRdtM/ECC8+zjgoxtw0nCI0qrNpaFg1rAE7egp5KYLIdVc
	C2WfwmtOXjerXZ3MJqzrMTOMwTKN2uWGFGwCoabx+tiuxIjyLeUn1zRiCjR7RnMGrdKHvpl
	ylhJUVbJirZN//Cgd9CjDJJz52FTUhQkFXU5PvjvjlnLu9c31zEX/8yOpPT21X2VuTrJ3aq
	DCz+EJK8jSEeSTk6ONVoywd0ngjVP9hnU47FtKzEk8oMdVFdQkM8Q4F16M3RL14mpNKD35N
	JzEo7bYZS/lyKBKrnpYF2+MSRSIV+N3eI14X1xmTzO9+qcoLa4H9USOkhqGWDC1NuQumzgN
	rmh6r/pQj3Prpu1eCa6ywi2XFdoBezGe6P4w2klpHcu4Q0DYZ8WjxAajpHKnVrU7rrJYSQO
	06+LWLlobhLum//yr0PYF/Vo1aCHEUfP6oADDDgtd6nnKCvrmO65esY3QqKYXri/Dm8jknp
	k/x6NG6wo4LF23YFBaXfrgeOQfxHooAcIjBoeer6Iwf7Bq6nXI15mGIpiNHuxgEcrQwF9Xh
	wnwVYTxowTqJ2jmmBPgOYn558dEVuYkblT5TQCWhC1cWLfzUgNkDt0puu2F8ivxYdd3p4JA
	I8QNvrXkJLYpr0KfoVaHDfl4aYjwh7M07EyA0Yy9Aiv4u4UGMJKzJzS4FWcQwRXNdj3Zzw1
	gS4wpCKJXadw8sPyt/LLEgL1wI5HF67OMSIqA+B1KPVcdwHGnute+lNe/1K6aF4+WAqcOMR
	lUVvrW0vYeE1TZIbGw2wxJGIown8fdmIMJgf9F35CqxPMn+vd99O0w9jnFeGY=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Hello,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sat Aug  8 07:05:57 CST 2026
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Aug  8 07:24:23 CST 2026
Linux version 6.18.44-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.44-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Aug  8 07:42:00 CST 2026
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.44-rc1-gd06c9b57c3bd (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Aug  8 06:45:23 CST 2026

