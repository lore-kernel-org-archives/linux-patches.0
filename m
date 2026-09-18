Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A13EA955
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715758; cv=none; b=YWjaoKeHbfvxTyLQpXLOHBi4XbpjAbsUEbeJfUOi5m3QjrD8klrVnL/LaTrnRwcR7VBZGVoL3MWstlt02VtFKV0WNImaT7vBev9Avz1DwlknFuAzy1vrcSS3mOQ4cEk9OpL/tKUQcBy6wvNJz3Cy66uSwAKmxYnAVIh4NM1aB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715758; c=relaxed/simple;
	bh=f6I8ZBvZY5b21kGT4hWsOkKu80+mgenojDFqc2dTPTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q65KTguoSKu197ZfoqkOdtzXfS9cOl6n7s3wuuNLzlmm8lnz3b6A3bjm706UT9Br2LZmMOtsWn2QQjKwv36ATCtqr90+e+MxYYGkAuPpxLeExC5yqc3oKrt6cUWiCiEbDycybyUvK534W7b9C2zF8CbeYzNHf/jRrGUWkknfex0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WrJC3pZw; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WrJC3pZw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789715737;
	bh=f6I8ZBvZY5b21kGT4hWsOkKu80+mgenojDFqc2dTPTY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WrJC3pZwa8kQeoG6k0N37cfJLqpzQUjjJQrxbc9wbxxM6QGGdnC5B+0hx/NBzv+aA
	 fCypG/M8TIAeNAsLlM4lL6ISMWCsnuAvwgTYjRDeaO2h6kHI3RgmyPC8r1lqcsITiK
	 zOUkAvGUf75VUccmzSzc1orLwVuaawmJLGbywz7I=
X-QQ-mid: esmtpgz12t1789715731t572d7bc9
X-QQ-Originating-IP: I0E+fPeRutq4gtKTkzyRE+aUiarVISFWz028LK/FdjA=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 18 Sep 2026 15:15:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8646419534417741583
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
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
Date: Fri, 18 Sep 2026 15:15:18 +0800
Message-Id: <20260918071517.60561-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NchHDkd43sBtypd/+GxbJW6Jgl+QTZMYD215Mp7+HZa1U9c8mgo10YE3
	uZUD3gGiLYm/beBuBLcUmUzUKijO7bIJs8wWNdloQnK8P9B6941qq5F31aWVhZisGdwP4YI
	c35f5XC/ouZ9GIlEUiA77xLohD83ah7PCgogIIeOxdnD/Ywm9QZRkyyf0PPh9HNJVrNjAKB
	CjmzO8VcBPcOu12Me1w7+UgwbesXZngLe2XPPoLm9ytYPzHYFTZhhvN7y0d1aq+lCMeBK/D
	wd1ycCrH7ztAqrvlmIOIcRFBpc/B8hSMqtHMdPog6c1n9QS+RvfaD+fI7TghPxIB3o1bf9P
	WLEqhrBz2P/hLoaHCXKttNrh1Ys1Z1EWL5rJMjLd+OFXnHuQqJXv2Zq+EukKuKZcl83+ekQ
	qaXnD2soyKRG7bAnsgokEn9cRb+ysRhyQwaTJKR2YP0FXDqZ5aTXzDIu3LQDltgGKxk8SK0
	HQQG2wN2StYUwD/ETbojozqveXOXMP8k0aLadbV1T6AHkO/bTH+wqS01kp3CawtaN5ikuTl
	0w3FVdTlJFc1Ufe677ibNLmSqxW+vjkjvTotNyqYZ81sMm0YSIAh4pGoPvmnnHjNfJJI2i9
	wCoWehl7WSc8/7RQL7OVXv5DQxhVhiCGE3h33rvIwoAEsa2o3BVi5fRiKW8u7MwBFjab/Uz
	HcsTkr5Pc7EsaRG2Y4U3iLf8mbREnTzc37mFCkl3fFlIxghB+DTzZEicAYfpPX5k1XsRcwQ
	QcZkmMwOk+Hgw5OKzSGd5yQ5uWIXechpvtEXYOKtbeOH+TjZc7FLZHs8y33vnFCUNZZntzS
	SOS3eBGrbDhwQ5dDS1mUgPd0Enas0HmWKswsCwiWvZiPc2Hd/JCzpJpYN4+gj94QY/vXwjA
	wJ3x1v1rxtNp26Nf87eY5IUOF6VyGi+MWsvs1YvN2aPL/mYtoA1lVzPlcz6ovXLQWc9lVRl
	7Rs+PbJ81thoazXQlrNliciVS9UfHaH1E5jmf5iESXgESd0vOTYBYJXXj7knz4ALgJVrYcT
	xZWdWdP7/6pi8kXUBVxUEORW5dP/GCqpSy8y5bYbZXYDfLw24OFqUcSY4eubin5n3Ze+GRL
	oKGaX25Pz85
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 7.2.7-rc1-gb4c9ab9b68c7 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Sep 18 07:06:00 CST 2026
Linux version 7.2.7-rc1-gb4c9ab9b68c7 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Sep 18 07:24:55 CST 2026
Linux version 7.2.7-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Fri Sep 18 07:42:35 CST 2026
Linux version 7.2.7-rc1-gb4c9ab9b68c7 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Sep 18 06:40:08 CST 2026


