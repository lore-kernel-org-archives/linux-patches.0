Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E2139BFF1
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281125; cv=none; b=XAHQAsW79F4DQUr7ITxMzNmBQeojhTR2PX+kWVNgGFpoj0l9u2bP46dwd6BrCULD/QSjwaArLJk/iMSclglvPp9uYRbjI27fNhbL31dJ1QtfNVowUGUKQdQloK9Lq7KLYJq2A4Is+4kxcMVYO417iCANSlaXTBPESeHvu6kZzio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281125; c=relaxed/simple;
	bh=r1BQkXIkWbZ3bCnsg8ygvimx8DmAW7XJnXxTFcZjgFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DXRkMVcQuagTnioWj4LTQBA7l8j+KnWoTawXQ+dTjxPJv8AJH1NhYRtdtEpXSwx0M2ofP5eZbjSvMz0uSbnXcYxwyeUFGKp5NYSplzZSYqdEp/+qfokudBWeRMKnF7xXG0mMH5CvaJ8itybyTbDoUa5J/6ryltoIC10egd87fpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=gubhBpSm; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="gubhBpSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790281101;
	bh=r1BQkXIkWbZ3bCnsg8ygvimx8DmAW7XJnXxTFcZjgFo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=gubhBpSmFGshha+hw+HmFWTbz7D1Wi6WPAcl/Vu5qmtkJzT8ryOr1ft3d8LJ596+a
	 /s2TgC9M2sAtzbtwFKPiH+dvaLnxWDSRXd38zyOTy4F0llcIHEggruPOWUiZ8c6cWG
	 gRCMkN2db15wtOKTUv+P8wCD7mFXRpp7vZY8LLb0=
X-QQ-mid: zesmtpgz5t1790281095td59f0c58
X-QQ-Originating-IP: LOpzy+JBLjrjInbJlE4q/fOwYlppRkC7Zpa7dMAFM/Y=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 25 Sep 2026 04:18:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11562080722939994202
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
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
Date: Fri, 25 Sep 2026 04:18:07 +0800
Message-Id: <20260924201807.962404-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NAtipnnbTPeaFr8tkhSlM4a0iQfED8DgOHUDmJ8AdwYyFCNGmWbZkVWJ
	xL2GCrfK9H3ScI69pL1v5ocqCpMDiSUzSPaiSd1MLK0mJiMrfrddSvLL+iD1iu/PXBnPmTB
	s39QLhW7jdUKT0rZQdKb/8+0610jVoF9mmj5JmR3ifzMmypC9/dL1ZRVW9CFpX3LRfPF57n
	+VxlibYUgGybFatQl5VsW29NAJa05xL6ioWyPtFrgbgILGQepP08R/ckNggHf87QI7PLCYx
	/143ROv7N6S+haWnY2H7TZ5ZTvatqtDVaYkGn2FlWem4IA962LbSz70DuvZQApzzB1yyCD+
	lkjxdLi1VT11ZWZ+vrxwzrxcIqA82KqVbLB+wzoZv0U0WTtOdplhpHT+0scBH1ueZDXlbBG
	VzQKYeJNeldgFOzGJKV/hM2Bvy/sAItl1ZEusOtcj3kmEPpy6b5SrtPxiA7zMigjU2aocSJ
	SL27xB6yEIrAhZoIws0W4dvfMrVo17EYvUJu2iHrOuKNd3eNPm0JiGTWIQyVHSct2rq6XHm
	3Rx5QlU5bD8ZjTptteZez5SYqDuKIn10BPU/a0cMc2FaTg9jBRBdi33qYoNRef0xlBmX30N
	a7uaGijQZma4xukWsEQbPYuM9zzN/RU8QH8x/tgrj6YWv+VwYUd1m7bpWj/N3KmPc2SlTWW
	cgnrl/viCOMvqeyeADH34Rh8Q2oO6OJ+S9A9S/CQUoRrPdzuRDsD0nPIHJv9BeXdWKE51TZ
	V+h3DE2l3rBZNl+eHCdGtoFmLjEt35IsE6Z1p1Xyq3dF4QGnCrtgkvUdKsGYvm8gGjMOrdy
	qdzRNv5hpUh3WjQCAlT8cdAdZ97mRhTlNyxNwMqmGwdgReR/btc/1nKHbz3SoVQBJfwGciF
	ZwPrN7ClTVBbbaX5cGXTSfgh+JXV6ZpN3JtEQqG4fST71mQOOjNkkMcki9jbOLAqx3whYJG
	7+vtD+edzFxBLP7ji7JfWBvJFj9D0ATp4WKSRD3ksKoYpCoQqZXE2tlNQuXwxQyUgcp4jVE
	tsfNYAqO+FSeIFnKEuss+C/YTDptEgy/XG28n2H1mEeTqP+TwPvKWICOi1H0XAyYZTeUc4S
	od4fDd4p6HB
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

Build tested in our x86 config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan
