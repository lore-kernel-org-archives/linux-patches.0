Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F9246788
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 07:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715845; cv=none; b=OcoAtODKc67juZayqVZHk67x+ykgryeBiapCMbyPfso95YsGTTxYWCI1cWS13QShLsu+ONbJXF5z4MtL7aziG9gHeByjpshWKYzlEB/WS6ue8kF2MLsIHHR/47f8sqPe/pLqYMPXeYgnluRzrUdqJ2od7drWnB3aGaqkblFYXGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715845; c=relaxed/simple;
	bh=2AbXGEropJ1FK9sttlez8I6vO8EmC62kKsePA/4GnuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ODUEnbE0FrR2fhymRl6RT1Uc/nz+CswYDQ1VukZdsHDw5zk7ZloQAe+23SbS5OXiB0Vlicd8CFEZqVvgBLiXEETGTaazDb6mUIPH/e27MCaes0T/i/DpN1FJ8ZkSl5Jot2v123wn5Kjvg2q2vHtDsnPWqjv507RynbpWx/0Th94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=BbXNN0L9; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="BbXNN0L9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789715830;
	bh=2AbXGEropJ1FK9sttlez8I6vO8EmC62kKsePA/4GnuM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=BbXNN0L9+ReoIIZG8T5PVdCa45F8pH0kcjh8u5Id8/OEPV5ozeS1blXQ+zRQDSZ93
	 ZCjYfr6vSCdJM0LnUgEyBaSlIHoaCKH1GSzjD6hllYMgAw15jwtDFLqoTQC/Sakz0+
	 1FELmU4CF2U4+wsEuFTwCEb/J4rLqByOD0uF9maI=
X-QQ-mid: zesmtpsz7t1789715824t3852a7dc
X-QQ-Originating-IP: EFvozvUxYboS5Cyg/5DIkor+h1w8leEM04n1VxFF5A0=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 18 Sep 2026 15:17:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10064841184218593118
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
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
Date: Fri, 18 Sep 2026 15:16:57 +0800
Message-Id: <20260918071656.60841-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NjZvhLDkUWIWkQMuETxr0jSIxI9F7jingtXSRCZr9u8NyAti4mgNghSq
	BSCirneek1bHN3K1e0mF5qh+32ePNnvNrD3WVoGxx2A8g35igAQ8A6qLqIurZiGyHO/XHx0
	NG5vkIjBwMaY/WqnG5IGHh3spQw/1NHtXKBm5DU6WzYl6KLnj7W3inFHULJl30I4oWJS/9Y
	dfCCzBbuQuimoDk0iaRYeCvxbqS60DcGBCLq1X/y7nCSkYxQSbI1rA88TOQJtOZiiqqcQfK
	1rFgaBZmFzaD5hkUIzpG1jRkLtzj8Vz64rvpYMUfn0wRhuQ79O3qsz4IpyPpTF9RK03MA5b
	kS5sdRgKTAFCjVwwxKunUADkoLTjPkET5/MFQPY/BR3sSYWhFwHVwkcXlkR3hlJu/SRzg0c
	WXZCCogrkcsuy+PdkENVWpkZ1ABbvc1zkmgcgHqehmqB0+FcEVpwVrjBV1Q4l7LYwtU7Rey
	hVTX67SmQfbys/RHyGvbbu1TbfQS2j+lMq1DHbYJ0+EtrB9QY67j0gqOfqhWgt0nq5zbT/5
	qOybGA8GCGX34CuKUMTzDzTABVJSWI6MfdAkH0T7aF5wv/BM+tCDzucqjwc28LV/KpcUZVJ
	4Cy4dMp2rIKH5P/8UahGkQF8QNu+YYL7KKC43Sh8QOU3NzoJfGw7OlB/o5fwv9pI9+txNgL
	W8Nig2Ks6/djPd0DcSAvxdKB21j042c9G7jooL1yvKfCjCJ4ExnQi71lti6Oe/5XbzLZZgY
	pbe3/m1Hosd+ZqKnlkiEBw03GZSmICIvQW7MB8DdKBAOxqlel5xn5AQWoeet6GiGrPf0uJd
	nuw+MaoLcfnZftblIXbWJ1PhjUuNowYp41nWeiHKYFMccpv5F4mOVLvh0D7+TT/kLVICY6u
	7GkWIsAOfDXZ5ytVphJcovfDIzaq24sYIMFj0y/H1Cmy+Kky7Rk5Dj6Ikq/cYwyDl67CxQA
	xlUxtsN1mETrEkHAVUmw/HsE+vPIoRMaBKPUGQ3i1dbydvZ5ZaYdOhi9Z2qpUB8DrKx8lkI
	sJIBNOt/QZgMhi6C8bu4SA7lRwbUpB++FRZkYvS+nBzqHwitjS/zYOmCzB5Qt2wU/Xw25zV
	bCwwBxG5nQqeXoW9Xr7q4mGmK3aCRMhdkylsI63f41IumlaHHVrkH82w9dZCB8Uy7RMgLtp
	Hywq8STV93isXcEiRHZGYrObZy3TAh9fN1pm
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.53-rc1-g644a9858f3fc (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Sep 18 05:42:43 CST 2026
Linux version 6.18.53-rc1-g644a9858f3fc (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Sep 18 06:00:26 CST 2026
Linux version 6.18.53-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Fri Sep 18 06:17:35 CST 2026
Linux version 6.18.53-rc1-g644a9858f3fc (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Sep 18 05:18:12 CST 2026


