Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70B2E7369
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 19:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203273; cv=none; b=tPg5uAEORWAnsZgzm0lUeOg1RP72f/67ew8IXBks2Pn5NBQIDSMhK7Gv34Xow81yOLbiDuN5efGgKL1B9FkY5Otd2UCIGEu1i7uhvGBtefXYodZNZGHEN+ddoBaTvxPvlG9zG3BfhHP5gr0UBS3uO2bxOXXQXiTxvbmI95qcod4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203273; c=relaxed/simple;
	bh=O/OvX2JNj/PMLwb6Dl3P1RdjxL2cow2pKxyZ0z+Cp4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W4wc8YXQwH1aoS1Rlj22EwFjgeA57AKMfRMenKTAkjAY0mtgZpjQijGf9s0FKdkBVHDv93D9JNws6Jo/EaCAtygp1wIjtu3wqeKZt3naodmhPFNdnpLsIf9eYf2GvAfuAFkEypIfFvNcfXyf5pmTdwQXXazeiltSDtaY1eS3ysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=A4VSd6w7; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="A4VSd6w7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788203244;
	bh=4v5YqYy2bS2ns0Ll6WPVVeRfEriqH7bIUiTlWEzjnYQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=A4VSd6w7mA0v30fpXDcXD4y+d17H+9FcjgcXiBa3KZT8W8aPF7i+B3wr4rcD2EYc1
	 iV+FWLgjFDy3fyMzm4PRBdlXaa5fgyOJIZZGugc1ZO0ipSDqDiazQw6pXcL5JsW6qR
	 SjzHHDLFhDSYGYj7k/sFLZR+Oqyz/3sAcvesvXbk=
X-QQ-mid: esmtpsz16t1788203238tbfcbbdb1
X-QQ-Originating-IP: si/9pfdW12dT98S78z4TeK+EbcNEtA7KSwJddDE1Two=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 01 Sep 2026 03:07:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16190420279150086281
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
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
Date: Tue,  1 Sep 2026 03:07:12 +0800
Message-Id: <20260831190712.722297-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MXigUJMenSZJUQ5RoZAtfFjZ+MtI7KIqcHGhFGvYZka5lnC2RAwrf01r
	50svXwYszjnv2pUMmpiVnix/08WzkSEJ5+haLHwWr7nDfTnZ9SVrV4ivpQRlAK+bKI/qxWg
	ZSk8+kKAlBoOz/epXiU+tJwcoWGzPx3p6IrHGAwIeruu8rlXEs+PJu9iSyQm6SRtO7LHys1
	bFVV0K/DJUvSrdReqpcOEZfwOoRiwOIg4/0wqRxjy5OWwDM/jm/0zqKAQd2I2nm82sDJ4Fb
	84yKU+JvQM51mixSw4otkltnXgOCkHs0Aymf5xJhr8hEsFFW5vEa+vADCFdh8hyiAO6D/T1
	t8Gvt0G8OrIfebSxE/dMSTyNI1PBUuJvCtA2ffcHIC3Y5K3hNWqCUoD3blY+9ySjnoqA02f
	z+Lr6wLnWrVFxek7aWxnh9l4y4jBSczPenKbT/Di3WJxLIRg7SyNmiuNE3INojyIrd7hL6B
	fh4OGNBsnCC9wrwNw6o4SEofzEBkn3pTnjIDqClYANdrcsM0QEs0n1ZDn4mIMq4agWQ4uol
	hIR7rm7vd7nlBr14VBuPCR4/ukAK5TvlcJSOV1zhhH/SsfRUGp/FH0hOFSCORsPPwUcF4Q2
	f11LL+5fJe+KlZPHoWmmUIzjqHr2pJkQqPOk4WUulDD11UDdtgq98Nn1HglZ6ogR+jMlIrs
	V2TqgviYD5bKIkOSAYBbYetgbAuPpRifbjpFdGdaeyjCaRaHTv0lED0dy7mgjo7yooh4uOj
	JfHWg0Dw0ToQBzm5JdrnlMwCZnwBiyIFr/GcVBHoeEsNqY8I2sRtZpxaWTwUj95pzCn4lEh
	SB7qvpG7dfkPzHj8WzmfHe5o7QFFitaKo5QSOiseMzY4lRcXnHTjca3Hpy+xDUTXYanM/yr
	V7Tt9o6NeKsjWSYD7BKjPWvWVRKBUF5kkse7M28NmFAlSc8sSKjl9DV6ziJU/KmBvtVzkrZ
	xFkBoLMC4XCv4Lv84YlfW3CocBQACfvbeV8WqbOYittqcBsvlVNRau+yYXSO/nOjU/CZUs1
	bCCQzWMMJiy+pyYdkuTl8AmD6KEnzOKfv/m4Awij1zvblSbOvbfbitldCYipDoUCuujrSnd
	hkgzlkQqkm5uc3b7G7ac8w=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.156-rc1-arm64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.156-rc1-arm64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Tue Sep  1 01:40:37 CST 2026
Linux version 6.6.156-rc1-loong64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.6.156-rc1-loong64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Tue Sep  1 01:56:17 CST 2026
Linux version 6.6.156-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP 
Linux version 6.6.156-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Tue Sep  1 02:11:55 CST 2026
Linux version 6.6.156-rc1-amd64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.6.156-rc1-amd64-desktop-hwe-g658884b4c6d2 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Sep  1 01:25:21 CST 2026


