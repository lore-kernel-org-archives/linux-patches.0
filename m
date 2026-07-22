Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361672D47F4
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784697402; cv=none; b=eWKtz+QTPwQVgVtHGv7TjpGKcfK+yFGliGuoe/8bj9Yuyha6o1MyeLLx9HnbvJHr0xC05k08hLbJA4KlX06b2G5EnkGQ8wSmP73nRcJIJtn5CGXUgPsZrrEyd1l27kzmlS6Az0xfagiHqr2oL8JKKxgaDsaeuSE33yOAD5bkF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784697402; c=relaxed/simple;
	bh=FGVIf+M198VfA9At375RMsJYdCMgJDR2lbKp7dxyjRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PHZlYqhMpr11R53kKwrsrQaS3Sa3V0qCIT3WVoMFW6ls22rPp1L3ojaZo3T+V7Pmg1Z29jHdMzrpLsPrRLTEq2jwmoDYlniuFOvjqPsx8ODt2MXspoNt+biF5/erABPvvSqoJYv0dGjLbi4PvoQQINEPOigcXMO46thQdEnW/xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=fhUbFYER; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="fhUbFYER"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784697374;
	bh=fI193x9yw+gdoeqTCnB/MAYReQ2LXHHVaLN+wSRTZMM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=fhUbFYERHLcs4O3ncaoYqAzNUOtGarSARUtmI5gTDaU29YUnVPcfgOjJuHnk+d6m2
	 MxPissKomPSLCFCFSRLwBIT890tU1lHwddm9s+Y/rKwTuCCInm1I1P1CNpGq+/hEZM
	 B/Zz5hjvz3OLw/tlFQauHGZBPTtnJvjZAzytauvk=
X-QQ-mid: zesmtpgz5t1784697368t1b4d149f
X-QQ-Originating-IP: 1RFbBQW3fJlGdDmOYn/Av6Aty4SW7JrF0nUCYV/3nAA=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 22 Jul 2026 13:16:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16351367105393022820
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
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
Date: Wed, 22 Jul 2026 13:15:53 +0800
Message-Id: <20260722051552.814757-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MZj8uWqgIL1NF7UdOtuBGkAzM1eCReDuUZQ3zFWrFRhvCynqLY11WLf0
	+EORWwA8msKg1vM3fMmCYWQyIihYGOzW5WCTuNa6YAXn9ITo3j8U3sJ6J324rfqIf6/hphH
	Tl9v4BGNU0g1PeO8bkzrCOqzZsiVsOV5VceqZifgS/xD2o/MiJx93mINjogo80Mo/zPoGHo
	r/D663IA2+1oLYCrZlPOgrcUUCxwHhfNnWA+iYNvk6XRPwuNXLWkbVmVfNsNUrsOe76yOSP
	BzuJp85jZ1I0bALfCkUE5BMfxPDo9DHvDd14wvntmgKYOEWpUKZMq7o5wvIj1A9C2k3z+e2
	QTswd0QUnRDN0dTUGhkw5sLaxvL9UCE8Y43csfSlzhLYagRst3nWnkVFb39WIeTvIh8RnA6
	GsnybvplBbpZEkL3msfQVqMWmU3O+xQne17WWSLF7mMna9HwJzTCYKOWPBbhvw1KhSaNGdW
	I34cS74R2VaDMkp/6v/T/og9FSrrEGFUF+xx1z7pFXfGVNipQZ0FV3SywCLwW4SJgVDFVOs
	vhMHe0OhS0KhcDsEfmjOH4qO3qK+lYH9/nqSFIH3yobrYvhlOcKIvXU/4GN6jSB5mXUELxP
	EkGqQ3gxgjLSZjgnj/i/HzX0ox68/dZ+igS0gNkyLS0OIT96UjwCvl+CsSz/nByA0IHFvD1
	e1+tD/Cz2rvZYlPHKVGEzFzYUTXIUf7vkGnd6hyJI0bBO1o9QqfLEkvvyKNOqfb56J9Cyev
	pDNTcSJJM6xRfxMuJy4K2GoR8SoEHtDvatJXB3bTxNzhV+Lg3DIFSaTpUQ56H6o/T4qUolr
	eb3mV6uQsoSddjYX58E/9PkHchXZCyH6O/UONOKf4hz1GGAYm7hFp4RblJwsZb4UzzKhT6o
	g933YWka5++buFWP2hX+zFhyLQOQ3vkP4cNw4wxJtqdjvQpVJyQuVZCqQi3lUDq4zcd5A9c
	bREM+iDpNlytfdpLJxPgpN5Foms3Dx0norYk5DpJedo4sfvOe0cQudpdW5YQUftbghzhOo+
	sIMJkrIQoNyl7MpYfBEUVPhnxeb/Hn9jZ6uL121G6Lq7C2QaJsX3G63crs2Y+GTOLmodAmC
	vm/msPqtK/X+5PgSgqwPlPQ5PUkV8upPQ==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Hi, so surprise here cycle has 1600+ patches :)

by the way, I see the lore maillist webui are fold when i see >999 sub mail:
	2026-07-21 15:18 ` [PATCH 6.18 0999/1611] afs: Fix error code in afs_extract_vl_addrs() Greg Kroah-Hartman
	-> here dissappered.
	Reply instructions:


Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed Jul 22 12:14:33 CST 2026
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Wed Jul 22 12:32:34 CST 2026
Linux version 6.18.40-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.40-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Wed Jul 22 12:50:26 CST 2026
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc1-g3c61aa5a7357 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Jul 22 11:53:08 CST 2026

