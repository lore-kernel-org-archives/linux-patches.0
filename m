Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C712535DA40
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237986; cv=none; b=jl7JDNT0I52dB2h/S+NpSbbhUEam8Gr4ZYiYxydbLDr1ye7yverV8oKFwJJiwZU1mJ1ZXX7cXLyO27HGO5mLEpu3aCv1VSUHZj47Ur/sFa3Vdi44dEELLhyGzKLFTvi8u3zanwuhA+qk0T1TWkAIW0QdDbhNlsNRO1UfqV/GQhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237986; c=relaxed/simple;
	bh=EehspJWxBfgxZxcXNmhaNSb76TeoQuQnC6cupWen7fs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M06AM+pKGYkxYiIEOJtOGymTCQn/hwilxMS5dyh1ZaDLiZF+7ymsZr74k1VMGNxLT+WxM4PWyJx3cJAAL4M8ZMQDtOL80sq5NTe7BCjkqgmbi2wGEbKkTSNoRvpttEHB4oREzO5co0XmP8ehWuIcUQhsE/3xX6w4VIiFuAwisuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=kMACDoA7; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="kMACDoA7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789237960;
	bh=EehspJWxBfgxZxcXNmhaNSb76TeoQuQnC6cupWen7fs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=kMACDoA7MXi4fLkLTMUa3dByZanIlgKCnh3bD2kcdv1xEC4g6Tbbtp2iMNsLxahBm
	 cdrocxj8r3x7a3CF9/rmw6DeYWbMaB8yk4WVVVhyO6mQi+HPrZpMem4BT6nKPpgK12
	 bVzqYWJowYHrjPQlLHUFTaE36kbei7IloAL5pqfc=
X-QQ-mid: zesmtpsz9t1789237955teb9d1e36
X-QQ-Originating-IP: 2MiFuFD/tKLMHaKg2sO6/FCDBS7Mac1mwUPIvJjgmmc=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 13 Sep 2026 02:32:31 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10537202822548573077
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
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
Date: Sun, 13 Sep 2026 02:32:28 +0800
Message-Id: <20260912183228.840180-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Ob956G9wEH2TWSnm5UbP+4jMykKXAuhqZK9T/TKRAR45AaCmZ99Hd1cw
	gqF+N41baCrIgPRv8rCsBiVuFxKyH+rYIhWrBULESsLdlWbTylfCxSUG6/lmiRzWkdtrLLX
	I06LWKFcPdXcaHZDbohLPipLPupCG1KXZabP/D4PY+HsGc+nCsYbgt9D1yYDLi6MRCqJYn3
	jDe0o6YPh5GLK/zZWjUSDUpHa1ES6S5DyGpuq9Ul6Ag6Ag+bbHSxpDzP2IfwzaGhEwaithd
	HweF3zfznNAIAr9biFsv2b3jJ4PKgR1mRXIVkbqWbfP2A7Dl3Y8n+rDGrCt2ZzaUygJh9BK
	nVSDm3fvd22ZZn/AWbQmSe3GbtInQ5Mqfqcd4cQR4ysENUhqZQoHAR39eMNdCyYQewslknX
	56bL/ljyt6MAbwle2nekDo0tFiWwmvIXNpOewffRGOYMHQ1pWkcLK8b6xM5k+qUJL78BS1N
	TuFG+41J/wjVCSTUtSMWPiPbIVTEsI1nX9FV/geIF9koAQCZ/hHjbvO/q+zyNupqZUMfWbm
	N/IDn2g0sCZ522nj24pIZT4z/1ygtXD8JoL9DugddPnN1n3cS4LrY+G4PIEmFcwXRbTPhPZ
	0BmBzjxFJJXCJT7PiGgPYYMd0Ii1HGIv8XBC97G31aj9IpQwjMuQr+Ng0Flk2P+aOWcQ/nQ
	3SdribuHo7grgJri8crigh8XxveggwbT04hOw08yUaJwQYPLKkFAd99XsPWNa1eVt97a3WI
	I26Ni2BrUdHoQIsbrpVregwCtC+PaTgwGp+tkNd/JYWEgIINVFcHJQRC+KsGzcRF5QkpSsc
	KKVfHsvMLhRUy53Phc7K6NLnl706py9D8CXd6AxiCnrTAlCTwLOf+8YhNoQgUvoSmF7hs/H
	lS6S/kop/rdfteLojXEeNYSOvnA1/aohRtZ2T3ovA4gmFBCCuvbJTn5LYarnMKcDInrQgGR
	hk2uN8pT4JBbbFTaNablVlWivkwcLoblrXZgamGvGUFWJpzG8pVYeC75UTm1AHyeUY4Uszy
	sRPjt/ryUtfv3BEy0Ja4msgvdLXhnOiNe9xlxjZCExb2jrNbjHAIhtuacmfi8=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.157-rc1-arm64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.157-rc1-arm64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #34 SMP PREEMPT Sun Sep 13 01:43:27 CST 2026
Linux version 6.6.157-rc1-loong64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.157-rc1-loong64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #35 SMP PREEMPT Sun Sep 13 01:58:15 CST 2026
Linux version 6.6.157-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.157-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #36 SMP Sun Sep 13 02:14:33 CST 2026
Linux version 6.6.157-rc1-amd64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.157-rc1-amd64-desktop-hwe-gfcb8c41a77e1 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #33 SMP PREEMPT_DYNAMIC Sun Sep 13 01:22:56 CST 2026

