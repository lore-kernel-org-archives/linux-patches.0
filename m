Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707AA25524C
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 06:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024416; cv=none; b=qxTGVtW0+fvad0BvlYPtgzPgxSLHS/06Vz/9eUB4DyKKFidH8kpTvaw3hGRv7u9PnKwVQAUHWY2YmJ1lsAfIjf0ieK1dKOBlJm/UzhMqdum1L6p2X9ovwoX0oTNEpLx5gHjwM75aztrjh506JGrzGQ8q+GU0wMdKWzj7y5AcckY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024416; c=relaxed/simple;
	bh=NWhwJw0PlNE4OKoOEQIDjgmBC50MfPtZs2HawxtzRik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=td9GJHUsoHOWf40PLw/FE+LqNNRuSNQm7Gii7mJ305x8cPWiqB55BIgM7ua5xv8w1lLuBrWUTHgh3mpGR5gF9H8JPjborYrH0qE/icOHpIsoH9bnglw+EV2W2r/uqAitJw8PysoU3UozM+xyE2EhvirU8ogfZ56qfsvj3ef3SHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=DVLO9+KA; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="DVLO9+KA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1775024390;
	bh=HZnzMfZvpqSSmoFTeNf3IjcL+zaPTTuEapnfCvVT6XA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=DVLO9+KAsmNUECF8tNGt15tJUrbgBiODjPs+CJMe7GwaEI+qdFRzl6eG/UBcAsezy
	 BFvXL47xwCGOWUju8oDqZs8/80asTj/1tdNCuIuzcmdnhxEEgZX14nt6LqAuOU61g2
	 E3W87Dh3appaEhclzI+MEpdLshikSDc/8ahX36B0=
X-QQ-mid: zesmtpip4t1775024383t4c81510f
X-QQ-Originating-IP: yYbonnb46PhHlXMaW2ne9Fw/sDTCKMfpUejnFRcrh7I=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 01 Apr 2026 14:19:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6316390435373589281
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
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Date: Wed,  1 Apr 2026 14:17:55 +0800
Message-Id: <20260401061754.237709-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N2bAIxLK0elnKdbMRogHz0kITFZDCukTAkSI03DeruhIqbGZU2JjqNWy
	A6r6xUu8R1MkFEW3UPxNsYVHlqW4lc7u72TPX6HeDDLgdLnzS/tBMrEiIF0SjW3HmlKbQ2e
	OpFpWrJbmmNcU6gvld2sPie8wxMoimhBFk0SUcGhhHMtW9hGX4oeA3yer6xA/zUShat59TZ
	+Zpf6VyYgtVylG5nul4n7ez0Fhbg7i7Q5RkC1AutNsnDll/1iNp9ecYJQ0c1HuGwHumwo4U
	+BiPKm0yaF8y+OBca/vcS9hc2lk94Qb6qe8KFfZ2KYXNkyJZP/6FhUT//GZGFX6fS1XSDES
	VpkFSsT7BavDmEXJIU34j2wrFGJA2X39SP/gENkV14HxmNikNhohMyk33C/c0XBP6B+legh
	P1GXvklV4cf/A+i5wFLqLOBGBa8+YTt7sYdz2xfcXWpav7MG+NSi38OCRODhHMBAtgr7ZRx
	rdUHnWGJLb2dTELY4wyy331Nxv8/6jjexeg02Te00I7Ez8FUFz3qrCyf9I7sGeQdVH3OKvT
	AOwzlYeD0KfjmCMwWttkNJ+mtus8CLQwnJ2yLuup6WGFWonTAaAz3aqDqOt2QG1X4jYIdqI
	LahCquUM4jCqYX2iAFSD/NLBXOdTbvJ4tcB7IkPrYKZ4eu0j/n9LihtiDB0RD6gsV+Kwzps
	uAqHY+a4ErpBsTa4VEpcqRF0fgF6GBGFk113BJzs6yqo0zdXgjxUOwoRq7KWfnbSixZ7yeV
	loVgH8s0TO8cq9iL4wH4eGk7Onk27tBZxsQnhcl8AicCa4FSia6wSs/zcUe6q50ptRbfgpf
	28l3Qx7LAap/cKYE6Jqwp1C1ujwofZ4++Q7S8bfIND1CvU5Ns7Hu3KtFtJazTF6L/uZCLzU
	9s7BWzjzyXzbaxWt9Hots5tz/kFhn1s2CisGGwfcmKDI83TjhWEZjPWcaec0Aci8vYpt4Hg
	RRT0nWKqH2o1jKohiRa3Oi0t+arRwtOuuqGQT+1MN8VQnSSX+r+CfP1a0jBvx5ezWiD8zLd
	id9LwwEikSlwP9XlTAgJxlsnSicTuM+fAyL/9pE2fFXqTWw6u6XwR/Li55+dcOWCVUIUvSC
	agS5cyc79eP
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/decbc7d88fbf68488a7d90e46f6d3e59

Log:
strings vmlinux-* | grep "Linux version 6.18.21-rc1"
Linux version 6.18.21-rc1-g489a397a6e94 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.21-rc1-g489a397a6e94 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed Apr  1 11:29:04 CST 2026
Linux version 6.18.21-rc1-loong64-desktop-hwe-g489a397a6e94 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.21-rc1-loong64-desktop-hwe-g489a397a6e94 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Wed Apr  1 11:58:15 CST 2026
Linux version 6.18.21-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.21-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Wed Apr  1 14:00:26 CST 2026
Linux version 6.18.21-rc1-g489a397a6e94 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.21-rc1-g489a397a6e94 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed Apr  1 10:56:53 CST 2026

