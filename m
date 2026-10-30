Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.254.200.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348948;
	b=LeMFjBjSPXLX0Eb7Fy9I+QmGLWxBvWB3884XvF88389JyghJMh9Spf3iTGONyCPlcSNc
	 gIuIL5TprMRzus/7ZXIwMjPeM0VO18kFEyEWOLnCU9xHEiqYmOnQ66uvp+vXlvzMJzj0j
	 zcEKKiSbSeEXnvmnfFdJ+8ztqtgdSkPCHPXn6y/AACB0BuKVe8CRzRas0GutwCMHM0fc7
	 MCqbYxqv8V2w3d8T3tIsNx3og/NWxhvvII+iR5gOr+mvgtU5wZ7Md8EkCDEQIz+CH0wHg
	 5Otj0LxLbT8MZuzXXVBoAHq7C9mn1dgE/dJNaFENludbz3fFySODLXp0CaWz7ByS3JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348948;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=S6icTSJoX+H0mkq2r9K7dhGu04auJXQZtSzWsa6ywM8=;
	b=4f+IgKXby/zwqMIKMXU8zHksCBGe2rWsLLTlbI0pn9gtCBdeNAula5g1Yc/k3UHX3/3R
	 1ZtcudNdFchVivd0462SJxMk2H2Ww/hFrIU/rp04D3dfqFgUFIBccgsm1AEHKj/8gBllT
	 YFsc7fhkwCZadFpS98mBcxMMKpoRdGcLGrsn6Ugpb2vIVwcspraLyN1bUepp124DoEgKX
	 GI+gmAWZTMwYIxYwOdQlZIajDO/IQTrWIl8S6NM4pDirLRwbDx61BPJkMFdOvjRi9LtDz
	 WqSXDcY27jLGFzRPREeMIGa21dFupvK/kOPOxlOx8jFW5KdD3oinYIYovHMOI2xUfMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b="ky/Io1pL";
	arc=none smtp.remote-ip=54.254.200.128
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA6B606A31A
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 08:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAA6B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=ky/Io1pL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1793348927;
	bh=S6icTSJoX+H0mkq2r9K7dhGu04auJXQZtSzWsa6ywM8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ky/Io1pLlYQjG/bMGQm8P+xiYQB6o3xeqYa+xzQdV1Q/O0eFmbIEx8iOd23+3NMP8
	 Q8MTyM6xFFyFboeU7oybSlBGzO+aNYTXw3vt9GmI+MY8ypb+d21UjnQI294yV6CXgs
	 P+NFBVhQjCmTQh/e6qN7NuUbF+bUX8k4ORi0k3gU=
X-QQ-mid: esmtpsz19t1793348921t836fef7b
X-QQ-Originating-IP: 3z9nJH5sjaTFKjVPNzs2/PxgNbOo2hmbalbccp788xI=
Received: from localhost.localdomain ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 30 Oct 2026 16:28:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14936512090500505238
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
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
Date: Fri, 30 Oct 2026 16:28:35 +0800
Message-Id: <20261030082835.297423-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OOYO4i1Nbl+HBmiIRd/geZimNjXs4x7eTz6yCFrazXApJ+KY4RnLqGoa
	pfqRYN66B/09/B5hQ3dZs56IgbRVkVMeG8vNmPA8r5MnOt0KjBdhEAGy6KEFcTArjdEydGm
	Sq/drt07yjR+N0aeWtY9fdbuPOXlzSMGvs4TQwoyo/AHlapYyd/MqsGTL8iwH1/CtPTwV/z
	poReiA81wzIitwwAOkT9+l1Tk3X/cA+gyPShMmGvzXRoITh4NwNnwEzHANOXBC+XoFuCDal
	bG67AcvRdn4T63hkLRhDJsudRwM3e7gOq4wGM4xVepheF/QCFhYGvuVdx788CGvjTWZXf5b
	i/4WGRoqz6Mn4XRTxKFAUXcnmTNxgEuYIVNPrU2CJfClbQh3TzIxGLyVW7l6DzFCJDeDjaC
	3FuXdC/fgyrMv1IA5+FET2CWgILQfKjxqb0/0ML32uj4lXMTxURilxTJL/h+NbM35TarfbZ
	z8MlMFp20li1dq7IIhjvWMyDQSMECfVsLRpn4AG5MY3B6XKbAKdjkmHQWBFn4lmbm+jZSxm
	hBaZcvTllkoYaTzdPt7mbgwTyUnovbT4Z+ev3K7ugWLhqrhZQtXIivKLW0XIDQKjTId5+QN
	GHhRFYNZCDwP/0wHcqyu0Qo0mPrbkxs8i8TK0kXOZ1oSEUVlzIjnM+/dMDKovq4uVMFbk+V
	ty6Nyp4NjrzBj3Zhpp37e51r049cYvDBPes/Wy5wEp7WkbLvySU7GjtOWbR8TZF7btqwv93
	pPO+BQ85Sa34IUF2Jts61TWQf5iN9JUbJkgJY5qZnpu5BXQpJptoVYAFFuEYQez1+/pYcJi
	xoHSK4FyT63nMav46ygFIdXbFSAERi1A+pMwj/UiTmdmQipdu4alhQE/LkJaAWFfnj6rDCW
	9bcmY0cEOJTn3mJm4/+MpWKk0RcTi/0kDYDdQUQCwAPZR35zbgrG0+SEMeIcJBPnvYToSZD
	S6VGPm07pQ7ULCNO/kjxx5h6wFDqDRjpmNwwOMh3cNdi1K+7NAg61tafwh5o685cHjaMaLF
	t7P3r85/XAILbhwW3/koPzN2373AC9B1SLEudvLQHS8oFtZZ3KBowzl3q/NnmxdJE5LE+pr
	SRJQvqaGkAaNADujyWGQJN8SpmryrNkXIfiXRtePm4TYw99K0ixOqHRvIinzgUYeg==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.161-rc1-arm64-desktop-hwe-gb6e2b2f6f7e1 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Fri Oct 30 12:05:39 CST 2026
Linux version 6.6.161-rc1-loong64-desktop-hwe-gb6e2b2f6f7e1 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Fri Oct 30 12:26:10 CST 2026
Linux version 6.6.161-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Fri Oct 30 12:45:00 CST 2026
Linux version 6.6.161-rc1-amd64-desktop-hwe-gb6e2b2f6f7e1 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Oct 30 11:47:08 CST 2026

