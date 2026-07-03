Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0BB2FE0F
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 03:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783048477; cv=none; b=JqFzmYZX2pSgI8IBrd16USML6WmB3+Jgaxuyw40uoBfufF1jEtAusnvtYXawxaDj1bIDKur7kvl6TjcrDqfipIfpbpn4I/bXtnSuKDK0LQ6O2P6W7hTuVYafbgFwvFlYcQ9zspQxX9rduphcqsfAIHMUWBDxBq9NgkbhBK4+su8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783048477; c=relaxed/simple;
	bh=cxdDBuVa2kLn9x0fIhhQtPV5CB+ECRVwXyjqxYFfJ34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUVfy8em33yM1NAF8eWWCqT5AZBKDjiKoz0icM6CYS4w3PLudsJbwHl5Q9K+8FgJGminVtzCl/YsMTKgfAL1IB0k4IfHkcZQgqcB2mIC1FsLzTlmE3E8ENvSsxoVPV0q/4FROUkFcQo5yHClLwphtxCjowdxoaQWN2p4DyOJN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=lp68My8e; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="lp68My8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783048451;
	bh=RpNUHwd/WAZX8PHBCT3gpLXlqCvxmu71QefoOk+2zgY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=lp68My8elrV7nm8LNCbZ8oyGbsbmmzjEwquQWSpy5Br9aC0Fjjp0ziU2okytvjuAf
	 6MNBSK5G0j4fPXA9g3Of/6RCVkTJBUiQzLnI1VU5jDRaHMec64BmWZpTRjtRRWkAmD
	 Zdgazx5tN7Is+AjLBZvAOivZ8mQqHHfcwFDMU/LE=
X-QQ-mid: zesmtpsz5t1783048445tf7ec5f5e
X-QQ-Originating-IP: 0Psrm1Oj/qJqPluJeuyZj0Zp9rbw1Jx1OtfCJr3w/vA=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Jul 2026 11:14:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6667594136168282704
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
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Date: Fri,  3 Jul 2026 11:13:48 +0800
Message-Id: <20260703031347.544577-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MxRSPV+z0HAo8I7yjHeGiaPqZLlBgWLeW+zKL/PI9wuEjN5OQ6gsiYTp
	F2kKZx8iU4GVvF4Qf7balytEqtEXyDTyQlYoQ4qOQHL+IYsaUHE79v3qCg9cdwfgIH0+9al
	7SxrD7qJmOBT3UD/F8u2sC/904mtJh9C80Sxx9rzz+Mna6fZomEYm+6Ib7RJhmh7XW70xz5
	4px2ebaYT3mPylji3awcgrK7s3+ybHVZeco2twrd4ImOqMQrK1jtdd+lc8nL9f3OX+1VnbR
	cr5iaxu637m78CEuZpHrFCc0q3gjlRCleK43cg7ZRYbfleKS5NObO2WAh5MWNq+pIcF5WpV
	PCMzgRfOOywNIwTuyktqQNe2G4D+AdhA/DomVjV20WW6Bki52Q91UhOt/UkmjFf7QWCGG8t
	kxXvHXPsx1wheh3w9FjhvfSSpgfWS2G5g42TrvRIA6U9ANqtA/L1i0HxP3L3qGT51mGdCzf
	1ZITth95KaxOno939Bl5JDmV5CL7JxGFpV1imcxLYgvc5D0NZ79AGXeRyNtetEaZAW4pl4J
	xEQ5HaMu1F6eveJdYxFCOoyE9Mc6DvkFwIPHXN+kShvBo8BefmJ+UTvg3jowCDY980bzMEa
	9rFoQB4cD51tTQyvgsqmE+Cxz1mVaGHh6/YDxf/FuLkCvI+S6bqx72OfIlrJ2+lu9dfcZeJ
	yg+qLCK0ijNRFGxpmUtw6SxFf96k2xV1cNvlpdQR2qPZ0GBfKAFVbF7wNCz2pVN85cMk/RF
	GS27vSYU0CVgeQGVDpKwaV9mjFbuqa70LVw3ogAenmh8+CYHtz2js+9k99TRma6q/dWSMis
	SOTiP2yT4WQOA38fRFRjPmVJnw23JiMvzJEZyWuFkSea/2KWMVQT44WEOEzH3s/Fd8KFvOF
	I6Uo7OeVffyE+c8TRG1B6CZodgnMOIxCMrt5Vbs0CG05pWo3w9rKdhDPup1tIcIrupU/Juq
	h3ngpeRnWLnZyuGgivm9uYws7K5AnkWmtBZlUOvm/rQSMQ5pISJoYgZPKcrkxaD4V0xSuJm
	TjNd7Dk1ZREWd0lt4Uj5pCm5tIzJDWV8rlvuu/+OvUaIOvQY/XTXJGNRJM7CIgWCP23Stn8
	N5TGpML7276Ri4dlHxU03A=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi,

Build failed in riscv arch, log:
In file included from mm/kfence/core.c:36:
./arch/riscv/include/asm/kfence.h: In function ‘kfence_protect_page’:
./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function ‘mark_new_valid_map’ [-Werror=implicit-function-declaration]
   25 |                 mark_new_valid_map();
      |                 ^~~~~~~~~~~~~~~~~~
In file included from mm/kfence/report.c:23:
./arch/riscv/include/asm/kfence.h: In function ‘kfence_protect_page’:
./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function ‘mark_new_valid_map’ [-Werror=implicit-function-declaration]
   25 |                 mark_new_valid_map();
      |                 ^~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

You can revert ("riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()")
commit a8818008680a00a86c080a55e8842c714e9a62ba to solve it.

Build tested in our x86,arm64,loongarch config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Jul  3 10:28:30 CST 2026
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Jul  3 10:45:48 CST 2026
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.38-rc1-gd87316a03ed3 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jul  3 10:07:27 CST 2026

