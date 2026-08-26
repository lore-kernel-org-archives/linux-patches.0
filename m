Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561A53A1A54
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787725770; cv=none; b=OilrLyhVomLjiEEDrH56tsXpm9pp+9btmpcmv3bORitcEzSSErv4lXbFViFpKNHtC99wrkGsG7yzzUB/oUJuC93tVQu9p1s20Wf6ln7dL8yxjHS4O7VazLvAzf+mIDKRRmnob4+eBHRZjDSu08S++2j6YHs6zJd0O1u1IO4wzMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787725770; c=relaxed/simple;
	bh=rduQIQtvQwDLTdDQ+JwQ85tY0UbTkgGXy25pnHlp6P0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=acgpHiTTL2fYy9Ntezk/U2ZkfvgJReKcqkn4aohj4pxuB33Jxpufps2QmcRtE/q1m8AJU/zA8jfzRK1tw1Ozhv0iitlJR3nmLSNkrHE6X/LfW6fvN2EMmAPH/x6whZNcVxajjkbf8i3oZ1iz2V4jiPPyC49nuqc+5rhkyyQsLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EW/G0nSY; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EW/G0nSY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787725741;
	bh=nZ52V/4hrbXmKL6vG4/anwEYkU3wbzOwhItwjLfEKA0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=EW/G0nSY59VGaGHW03sVjrqP7MiX8TcwZpbHAVkdRbK33xQuZWd/e2zUSkNTum4du
	 pUWU8/GvTcAmYVb7zPRNNBhAE9UiOzwxbwN+ZyZ+MBaaedYBQt8d09A5vNOb6DQCW9
	 3NXdEpJIdnP4Wm3Z6Gy7A4nSjrrb74lq5dIG0LaQ=
X-QQ-mid: esmtpsz21t1787725735t14dbb824
X-QQ-Originating-IP: YnMjEjlN+3LUn8+JP9mUVdA7nWq3pks7Ue8JIDNd2mE=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 26 Aug 2026 14:28:52 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15196249662024483300
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
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Date: Wed, 26 Aug 2026 14:28:49 +0800
Message-Id: <20260826062849.2879740-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Me1nIDG8HcxtaaPhxOsADfAssh8EHuvOjci4Uxb1RDQz1j3boGKiI/bV
	CV/6iP5dabqulgdSgOhMPZTsVNsXB7LFbFPMF54XH/R4qJPkenAPphw9qwTZKD0KI6+NvZ0
	Fq7jK2ho4oEYDp0NwgrdCApdMhNK4Lrwg/9RyHUNsQrOHu6UzQpLB1SpMALqV9roatXXOfh
	X2y0sySfPOzyq7zSsTlC+PgFt8YpaUxKPRTc0zkyQFrErqtr9odM6SLYURQDH5t+ld64qG8
	VKJrxHnB+3N1j7YzaZ6dfauSVwrbENcIG3G1DutuGChpZImNZ1XwbUbF0W+qS8mcZh3Hu5l
	iggDHiLskgB7tcHacBw2YzoG2eGXFmvTZUaO/eFJq1OtdKABJ8MHIp/CROl5t3+6V5rJGZA
	6HA0XDygxcjVeBt3yTWGuhgPiNPIZWSR/dmMyNnNfAQ/n8CaFl5hOSf5rWa5Ckdc6LFp8aB
	wzqBXwrboNtB5rsQ8Ilz7X712oc6Mctqz6rKae/L+McxSV5w4J1eBfe+FZNu1LITJ0LKNPr
	2uIbTz+iYrgzlv1D3acOeHcA9H0yRx4uR6Hgx4NR7LgoslMd46x/FfFHX13NQn9elBvXYTc
	KuyDCfbhPw56GfdhuaZJz7fEvIFhF39Wxmi4pYjhINaxxJlojPkmPSFBmdXfGQR+j2DL7nY
	hMP6oYeuejTxDcOGfq0XEaQ6XONHc3ba0iyIN5MpFNsT5fDWENrMuKSboQhPOJgy8ue3kZT
	NElSzlWBjhqxnnm9e5Lbr1BN+MavG33EXwNJmnH+hSoZprNcgvTrqPp2r7X+mRs/4zPkRtL
	cicsy+IJOel6vhW6v2arDrbUvB4bzc6kR1ZnBNz3N3sNqLeiQb+VFHAbBmFP++luhsvsfQs
	klD4f8h+rPRgDYAR1dFMA4sdLQmY8IFv2eD7t0qcQwYSq+Q1jnOwSwJPEtxoiIdIuviKk/H
	HeAawDu+kclrwLg4Wv9Tt09LvmDKa6yEmcj6LM4svtijwzOMBvuWvCcgkhpNP7TnIZRdj1U
	kG9WsAUky8fS8b6DN5AIYBAu3IeNSvF17a3Ye3AaZUXvTsFhxEVvSCThegKo0CLznx9W0Do
	w==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed Aug 26 10:57:27 CST 2026
Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Wed Aug 26 11:15:45 CST 2026
Linux version 6.18.47-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.47-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Wed Aug 26 11:32:37 CST 2026
Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.47-rc1-g20dd49b80cb4 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Aug 26 10:36:48 CST 2026

BRs
Wentao Guan

