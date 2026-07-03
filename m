Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B789379C3E
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 08:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783065727; cv=none; b=gs1llqtzmju2nu5BPqGeCSpdhyXkXc49RyulsfKzgakEoohH9MGKKb9C8RBzeD13I3DO7xfz7uBDJyjcQZe58qw+LT+0jOVegfESMa21mLskWtS6n2jOJzokX9QrGcF8mf+xZAT13uQYzWDUG3fSGx/heDgaunfPfbt/6yiMZTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783065727; c=relaxed/simple;
	bh=oufx/YT3B18z7DkgI3xZd+Q1Vx9EAplrMEvY5I4LI74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPdJLYt0BYimaOhDrYBW3MFd+4y0/GqJqfFVO9ILmUKlLJY+uWGx8RUZbX3RB3CKnyIPVXizOPKR/k41RQnxJTsZmHz0GJQOqfaYqCYbAkL2xI4stwAmDWfLSracJHlOVhjeIDGA+zhnocI5IrPH3eOLmhduuMUevw0BnENkW/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fs3CKy0c; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fs3CKy0c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783065705;
	bh=NNXufMQul2FJzTPQw9me9giHqSXX/0i609aKfwT0fHk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=fs3CKy0c6ZZM4ugJCQqTgzJclkgvndbWh9+PYbpqIZHMbtcyS65LHeGXCGX+vjC80
	 H10NnEunk0e/qRSG05vEpF0Lf3zbWMyONyGcUyzWvgNH+O0cr85KARgWPzF7nFnIRt
	 mx0MVJfatn/JCiH/4U0FNIXbVvSL/OFm82VrLurg=
X-QQ-mid: esmtpgz16t1783065698tef29bb39
X-QQ-Originating-IP: eYEIxAm8QAvKc69W9TO873BXENXnRHEHfnT77zTschI=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 03 Jul 2026 16:01:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15110257462297389488
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
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Date: Fri,  3 Jul 2026 16:01:27 +0800
Message-Id: <20260703080126.567705-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Mj9e7MGzKUWXaTTbyIGcHbeh0LIQR/u76P2qgjsL8vv+3lfdkwtl5coV
	8DOYPWIsZrvxk1LZBXIAwlufHkoNLf4Unjp3rOsa9OF+0pGHXv8smuwKbdjydIfMo1abIE9
	0TD1EBYckpFvgPHzqbJ1+3FOoLs+pbZW+wqKnpN4tnniYX8VRX1WvV4qC374GC7zCfMT+7+
	mes+cvqnVUC1Gpyw/51awHNSK1ab7T+myXMiiLhdWqrHP3gsEwjfb4Zix1mCEARiJliDBWC
	oxFr03eMoburwSLi2y/PT6BJ7XaRx4P4rpHsLUJalhvm6bw8tCKFE6jWHStAR32ZO38cc9E
	Ffr9M1BUl7tFnnx1Zg5wGcxvDxgWJCn7cunX2UeDMubNidzsmG0iT48KPdBBnJvzPc+vAc4
	t6n5lscP1sBZ+V2sOpCyyZWbMB9xNAyz5bPZyuoXHjw3kIVg9iv+9rWWWQidcHm/q91rQrf
	yHgYi2OK7Tz6i9eYtBvAXYI4HnJn+i0SJk3WkdLbKSkzrdQFlf3FhTndlVXoqaPE92BVG4c
	hAMngz8zUkJNc2zMeIfmLqgUBqoXEspu0lYl4mZdP+9Fx8+ThxewTp9+8w8ds6PZ8jReeG9
	imrIN1E4DgGds2nrvP/lTc5HnN5WT/AJURSggbDKP5ah/Nnmp+C3MvNZuzusEvsAF3wQNJe
	ghm5V95HcocnH1T8DzfpmGEKXCEbtbfxOV3BRxETn10WLYBg2bnBRnMFMnNRm3eqpivCb4s
	rX/I+TpLsaMDQ2BuLBoVjOX+NGoqQauT3rH+deA1Kf9Z5YVOozoO4UVrLlHh+4vjagoXtdd
	1lVbFVyvbisxYr1f/ekfYSajAjFjemOQ9EpRoqtbc9u5W3I0QSjZXVQUjqczGqCbIqUzqkA
	srke5h5F6zR4jQX6QHaJVg5TBNHSxFNb0OtsZg4/3hZ+ec3xab/ehiOjZD/ItIrn8osv9ks
	x1enyeECjxkOs/Fol0sRYYbWGThlHRQoPVuJwyPJrEyYjyDoyNabN76jsM8OJ2h2u6q/qaq
	HvE7cuBMrkQDIicRYt0jeI88gIkGUKnddtmuTOkxksB9u9VTIeeSpIYxjQv5LH7FYb4Hpg2
	5WZ7f5jCFmsOIOyF9eKmoqIo5+7Cf7XwA==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi,

Build failed in loongarch arch, which resolve in link:
https://lore.kernel.org/stable/20260703032401.857553-1-chenhuacai@loongson.cn/
https://lore.kernel.org/stable/2026070318-monotone-mug-74d6@gregkh/

arch/loongarch/kernel/smp.c: In function ‘stop_this_cpu’:
arch/loongarch/kernel/smp.c:616:9: error: implicit declaration of function ‘rcutree_report_cpu_dead’; did you mean ‘rcutree_prepare_cpu’? [-Werror=implicit-function-declaration]
  616 |         rcutree_report_cpu_dead();
      |         ^~~~~~~~~~~~~~~~~~~~~~~
      |         rcutree_prepare_cpu

Build tested in our x86,arm64,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.6.144-rc1-arm64-desktop-hwe-g383d9611bec7 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.144-rc1-arm64-desktop-hwe-g383d9611bec7 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Fri Jul  3 12:05:13 CST 2026
Linux version 6.6.144-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.144-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Fri Jul  3 15:53:55 CST 2026
Linux version 6.6.144-rc1-amd64-desktop-hwe-g383d9611bec7 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.144-rc1-amd64-desktop-hwe-g383d9611bec7 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jul  3 11:47:09 CST 2026

