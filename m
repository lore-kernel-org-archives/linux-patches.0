Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6DD44A708
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 20:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790886895; cv=none; b=Io7zIvUJd2iHWRTQFiNpaYuD4X93ZT4a2LiT1C6OcHZfaaYQhLYy4aWNIGgKHVarLBlYjPOEe+eqM27RoaXV23O9s51qklT5qcLXANnsQT1Xya87pj5qNwzXf608oBwwFNWHWfxTms0p8ZbLTNskyw3s+ZA+7PcIDHnHKm2bpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790886895; c=relaxed/simple;
	bh=IA4tjS6ZENLiaImBarBx3h3yZpuAPV6OweONZoyZtok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mNOYtl46cUKnhhC6IhUky9e5XnprRBkZNQKW0AQR3QTG/qcNfGGJtMVcElkF5nkrtZV9vWaZRTch8mOslZaReq78dxt8y+5Wimmpuo/e+rtcDVpAp7ujw6cRhkazeQpBrPtWadPzxvWiGYZ5esY/NcSEkuCicIXYON79gaWAXJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=J0v2ndMb; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="J0v2ndMb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790886866;
	bh=ouNIVKiaTJjOPW0o5N855FTdf6G8RVwMIXnVCtSoOsA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=J0v2ndMb54F3TdP0OzxzpbX4ClfTUTj6ItYHaVS1/ZPUf24puyClyXNdB7xQ8Moi5
	 /cH1+aVGJIWXOnvW9kGX3B6qEKzrKQLEOrAWd4OJz9hJXRtIxvbBdhpLSWn/6ff0ML
	 DGOIkP1BclgEcZv9OWvK9Yk2FsWsqg8ikPOYff5w=
X-QQ-mid: esmtpgz15t1790886861t51ce9723
X-QQ-Originating-IP: kTgOArV73S5mqYk44EEgIxWB0J0Boa6Mz2HaF4G8qtU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 02 Oct 2026 04:34:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1020183408094145813
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
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
Date: Fri,  2 Oct 2026 04:34:11 +0800
Message-Id: <20261001203411.465279-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MZj8uWqgIL1NALHlvm1e+HBe8xxLxQ5wYXxkAB/Dhdc33txTpCmOq/NN
	dDM7CgvZiJRslHZ3P2lZgVkBItzY2JCrMNoF+jofCDNdq5AeNkD0zG0NJ7V3/D0yDi5JzZx
	84lDfHOgT8l1FAZni28hlsf0AYOqzDch/JgJNfRIjZMwJV1BGUR7HPX+B2/P+h3nkp82wkT
	5VRZWvDpJHBRxMbwueLHQG5YQKWvwnOpkDDpSm2mlomJ4yeeRL7TPx8GP2QIbarvjfjhuw6
	7f+06JOmszdWapmIaFv+VMFeCepugZSqGZs0nd7MA1wzd0xWXoamIZew1IKClIFpO30zG4J
	E2FdT2wRyH+3s0I6KbyNNi26aG3Qrn/6EYKLMnGoTs30PAmm6dKeNoPzvaMJcXz1+PcEJng
	GbpSU2h6Ip6col9eemQACUHCz9rpP6wvE2QGMecArbblgaGspEKDSiCfLMqbH+jTFC8eiW9
	xCvvGzQLlPBxToAcbU3YthWoph4q5C+whbs87MocONgs97wMAyMfYqPe9hTUbbgFluI6Wie
	7zEjdHn7Cd9bTVOEuQ0nfduL4uZE3bYxqvFQAFDO3f4HqvqdkZspLE2Zx14RqZhu6L9Rzjp
	nWfmQnMpkDI1Y4lisx4bLGppfbxwS8qLIoPfo6nCyErV1pu7KdGUMEiovjRWOhIRXLSjJqu
	9SqVucBfEp4tFxzuQYINYBjRdcbK/Pbmsds967s11LPbv/cEUPAjyUj9+vShxoQ2qzU/sUG
	1EOlcNqWUvyJBAf/I4JwKRid0I9lv4qnJ49DfxT1d7PvDe/hxtoZ37DfGOs1NvlgSicfJEN
	xjQcY4y3PzX2/VKOET++MtXUts4K+Vix+5+Z6yY4dvVG4NBDZBEjvQp78SmmIrN2fBDtTTp
	48voNFB6YmVn/Vllpz44J5hM8e8mLww3ZkPzf7FCc1FaSqJidJ4S0s34QzFv+eL7MrAmS6Z
	4C57c4onJ+OHvf7BOUcYigAysUffyr9MwrpjqKqYYNwxboOcmJuw3X+EygDK/OwasVa7EvD
	QkVlcwF05EcYq8dv84rH6CBUDMV3I1HTaLFkXdXRCExWs6ME16HG/g01WT/N8=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv64 config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

log:
Linux version 6.18.55-rc1-gad4aa0f0db99 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Oct  2 03:09:51 CST 2026
Linux version 6.18.55-rc1-gad4aa0f0db99 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT_DYNAMIC Fri Oct  2 03:30:35 CST 2026
Linux version 6.18.55-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #5 SMP PREEMPT Fri Oct  2 03:49:50 CST 2026
Linux version 6.18.55-rc1-gad4aa0f0db99 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Oct  2 02:47:53 CST 2026

