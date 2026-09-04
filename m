Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADFE368D78
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788551199; cv=none; b=iPBo80GIlXrHnwyYCBTEDo1OWrzYSDxXaBjbKJAPjgI/PYwYDm5Pv67Oec7COC5dgr2vnzQ/1BR4YDrwLU2lZKdTIz1gVerv/Z5JgKPRgmwxgXR/nKcFklp7SsLLgP5L0QhS5+kWtYBG2tGjDeJ447QEKYEuyToeM92D6BIw+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788551199; c=relaxed/simple;
	bh=Y5OfE5RetYN+Tz0y0lxN+Zusr9FUzQLGAiWkpONLRus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H2r/bR5+CCKwWoql/MtV72xCfAfDg268Mqcn+/Jb2YxkPJUW3dCG/U0JNBbjgqsm3nRkboM2L77AWl17MMM0HGbvzjwUzRQNZ7/9jxtheT4fYiJvVtQ8qE6SYInV8kw0QXz9beWz3gzX8U7wXCmcHlDqzAex3hHtwxpfUyrJIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=N6ehktTz; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="N6ehktTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788551170;
	bh=ySogpzswJxoAl7WyHwxHElt28x3uWsH2QkWK4MRVu8A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=N6ehktTzUMyZSanvsXF+R4tFJ3qnrf0Hf4zuA0XDAwGWqzokLnm7pGgZP/j3c+RIc
	 CFul2yDQqcZA2Av4jjocFlm2OHTYa+dmv7blSPCtL1eaYjoNUZjwDqNkGfFTg8eGpJ
	 hTeTHcwoK5KIR8KsemhUjinAn5MZgiP9PdbQjj9Y=
X-QQ-mid: zesmtpsz8t1788551165t062e92ba
X-QQ-Originating-IP: Mh6UQHmyb+mASp+4mMFL/LbRJAAX0oMHj0gvmf4T3tc=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 05 Sep 2026 03:46:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7964370203424878226
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
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Date: Sat,  5 Sep 2026 03:46:00 +0800
Message-Id: <20260904194600.10243-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NAU+NnQ/rJI9mukbpEhTMINu7zZJb8x50Tm4ob9vXGLbh9takl3VAlfv
	sfo/wOWgfgawj/OQ1pAe8U+PGNBR9bLIlpNJsaUXjrW85oiEuk2G7K4xDjEPjcmKXl7vAZp
	v3gzHvqFBh+IM9Z+iueBv8373FRX4cNQjGBbwGQCP2/0K6bBKwkWlhRMpjy+As+4T9NUoBW
	6XmKTHmUyFFLROUeDziVVw7pD/OFcRuSatv4HFkX0XAO81R3/eg0hHpYIElr68cNoEd+pIU
	hq/4ClGXzlj0NlpQHGpFvu2ewKN8iAVVtsTd64COCNtJB10bwu29duwPggERE7ptEPbneyp
	xmKXhaxit4QYrROZjqsmzM0Gnx8omuL9cBrv9joTH9UbFOxXcau/Ou4IIcRvd3iyca70stl
	hrA/ZMmJQTGOxmtNa9ZhRFMuGVXeIQ3AUWosDkacDJYWlO87QFJ6NCrfDD7uhXXWZkaxmTU
	YQxVw6UTN8EYYZuy7MuEnAZdjZh+VY6L1PY5UjGz50i6NPT8G5SYz1LTpiQlN51+cZkU34J
	gV/XJLKTYder6jFAIV2Z8iPSW/2U/CbTxQ2d80j6I61EOkp5bhaaRzXBNqB8Du4To6BGo6O
	INUTsWNuLz0g/eOK06O51scfmOv/y+hac5+lCHUDnpJFqZyF+0XKZPPss9FtbtN6vB9QY5R
	JgoFaeOar3m68LD26icuGOxeT9hqWO2KEr9qTxars0a+wF3xSWZ2Dj7tx0B5L5OYbAnnuWY
	NIUARsOh2ZHuw0F6nldDjvbIWwpOUcJIsLfRvC8ZIAQECapnEvDreSORDBKHdaRai5gleei
	gcI3CmU30AZFht8gTLp+podg2ko25fEfpNQBG/4+TxiQ5k+vqhItQ5LGk26HmaDymM5DOWz
	VqSRXnWmoI6B/8eMrrJbt/R5ljbLe8dM0gOFstiCNQs5qm++ulYkrWfGLn1RiMP55detrzk
	CutoM7ulURZtNK0TECNfh1npuKwRI4fBfPKVxmM0NZzDblvdLYf7p2f6XJMd7HgIe5qs6gG
	WIb0RQUG4RbVG+RIyoOqBnDqQTtRiiGUztIxUZFHRz9u8wXRW/+B/XdbDSvWVFwUmg0UKf7
	Hpt/gANLX8d
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sat Sep  5 02:03:27 CST 2026
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Sep  5 02:18:48 CST 2026
Linux version 6.18.50-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.50-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Sep  5 02:34:29 CST 2026
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.50-rc1-g96ff57c9007f (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sat Sep  5 01:40:19 CST 2026
	
