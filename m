Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F62E26982C
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436290; cv=none; b=Eyo/UP0L2j3rN0BekSjmgKpo7e68K6FEDNpP86EubaT0qR1imZfXgJ3XYG0mmpaMdHJYZp009HBNwDDa8Fb27jO/sRnrm3XxBVRMSwwowge5/2DDxzfCK09iQiIRr4cA5UNE1yl3Nmv5MsHQQ62QAfdvKHTGMOskJiib2ux0IsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436290; c=relaxed/simple;
	bh=14U/T5CDfFQBbjc+4MwhJE6d2SYq6zfh05h6CPrqy2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mwKiLuniPEtEihbZ+qogQFO7N2zpGpxp4p/TlQKy6TBz5CtGixpwa4lYoAChVPpzlo0E03jeNVtgXQo86VVWOZ6gxKltEs5wfgTjcnRRyJbFal4fKLrNdlIcT7iLbN5+g4AqD8Awp77J+T4VAAlx87XJegd/5FLWCV1KNUupuhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WZ2xScEN; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WZ2xScEN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785436230;
	bh=th7LJWZSpsd6B+qQpkYvjkDiRrQbU6L51wG7MiGDNUY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WZ2xScEN5ygG3xEFEcZc94Pu0DVDj2lYt79arOLpQNw6N1c0JyfkhdD3oNtDGTaJq
	 KNS26Ftj3LxOCIQanW5IzLkyIcBFreHkxGEpkNchKFKb8OMXeF1tQ3Q7+/0LS6I2Lh
	 zBwsVhY6WCkYobkVeRU26YxDIS0sK1D6vUsStV88=
X-QQ-mid: zesmtpsz9t1785436224tcc7b0bd6
X-QQ-Originating-IP: 8aUgBakKAMx5kEOulCskQsyLArlaixHKH4zed1el6zY=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 31 Jul 2026 02:30:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1922670836029614318
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
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Date: Fri, 31 Jul 2026 02:30:05 +0800
Message-Id: <20260730183004.395732-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NK7tgqXAwNNBiO2yutXDbQkZR7ztkA64Y+guVa1rZaUNXUcffnZUwGID
	Y6Ix21cJwn+NBfd6a1waL8hoZsOXRPokZngs5cFy1Bu0nC8hAliBPnK1eBtna3lGsPxi7ku
	PLO4+32kgRNcCEhHXTweGO4l67SBIUG1z5yndcdmhkhiCB1A0ZNGq/iieC8piKElJqIAPY1
	ZAeNR1Sl+pr4S3d893ejHBnE4vzuPskmhoVdGNd95qqFKcJjCgcKUun51dGEENih6bak9yL
	Eo2cJbM6oWmVOQVUjd/L4kuWjAclq0hLtpElDshLmyu8i1xjCOTRRQGh8K3P5s9vNpvqJUo
	dvsUAA2UvePwXsMJT5OIU4odxyJn6TuI9FjCae70Ld7YqHkAOqD/Pqw+5bp18MKO0AL+69B
	orsrRMZKlMfUeheaKqqJQAv4fkRfDPydr8CklliRn7wYDWGRlbRme3d0lmz6J9ZD8Jwm5fW
	BQkE1X96oSE2/PDJQYnVXTNfrbWgGkydzNndoCFIKjpLLDHiu+5UkvtEJjzbaM40EEld4wQ
	0KW02lkmyGqXVdMD4CkPuqskenaf111gHmUUmBd40K3EW/z77lL6ukw+Tbo+j2JDWD8wYSc
	CmxXDArSLVV9kHdHURMb74eZ3ZHlpUBeKLrFuggmCitkGO6dgljkh/Oh5vSxHTR0eJ15PIV
	VJDK2o7H3sXQCNzoQvTTDe26zGrOCl+RKvxHeASqmQ193Tmp62ImL8vtZ42NYZTWDFKuu3+
	50fhixnTDkFz40aUV+5IaZWs6c0h7zOhtRvWXTW77y4sNFXIgTza3dWEfHP74b1xaYoH7Fy
	4GRxxjYbHI6uD+wZMYJDMk9L84DONmOTkk1dwwGbNsIdyXS9LAJgEMCP1xrCxhO+iodahNx
	2VXobkw2Rb/aYPY7uUyZ3B80HekDr2TpcfhNyi56lruHAw7ALkA8CSNKorXx5UpAszUOVrZ
	ozmIHLSOrmzSiCUCJ80ljLx2WzMvrtbFgqeAK+Zj5x/hYWRZB5UwwJkRLxw/Dgt+9emcimT
	kfIKSaLBEnuRV6taH/7jRuYtlcNr+6Ig7HxBA2Y1HKBQhFnKYcOj8RBflQohn48CeYL5jBi
	srGOzr34I7rWDArT4lV/LDvvaDyAJnlRg==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Hello,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Fri Jul 31 01:39:13 CST 2026
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Fri Jul 31 01:57:34 CST 2026
Linux version 6.18.42-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.42-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Fri Jul 31 02:14:48 CST 2026
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.42-rc1-gd0792856e095 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jul 31 01:18:17 CST 2026

