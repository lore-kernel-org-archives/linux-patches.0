Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F59413795
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818816; cv=none; b=mUrXD+vHawW8YSfQfxbnCCzPM+DlpqXHfD/UoU0xho3aoG6J3aYrrRzW80Kngvrq5I4ACmEgyO9frctKlVmGkmr0M2codwxvLq/KIQJUZ/hrnb+x7uKluSViHPdd1UuUGWQlYuO+kDoVkTQejgRfZPfzOuLLm8KrCNthB6ZqiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818816; c=relaxed/simple;
	bh=uqk1xoacVjmi4Ixe9b9JPnSUPX497I8IQa8iv18TfME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TPqT4ApHyDKEpKa6x7ETE/gsifrXokBlwxOVvfAUl4lRgoOv6umRGc1x3MZd+DzExjnwtn8Q0NfMB9iu4PRYouztSCUczTnI2H7WJA7/htA88eOaICWe2w2bPtq/ORCti8QinR3YXQCx+rityGa875D4RvKzDwfdwV0z7GDSWac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jXdbbncX; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jXdbbncX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784818787;
	bh=17wNPly3oNuY6zxtfFj5CSsd6Xr0pdJn7WEMvwGnrRE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jXdbbncXgkehHEVsCKw/iAwld2pWOlnfrGTpY35dp75MNYrsb+vsIjMbtIplBBF6Q
	 mr35EIh+hTnCaJTCwxPWfhvFQ1kH8Hepm2+vEP2QTX6/wB8OMiT9W55HP4DrJ6u28G
	 olCj+9lDjYPtzWw9gtjkbKc7pr0IETzoW7+kVtio=
X-QQ-mid: esmtpsz10t1784818781tb975a7f7
X-QQ-Originating-IP: U5AOCNoJW3yh9brEj/U7f3QzLXuaTqr/G9A5r0BMkSc=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 22:59:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6149670487323946463
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
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Date: Thu, 23 Jul 2026 22:59:27 +0800
Message-Id: <20260723145926.1111084-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
References: <20260722142910.893804136@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Nip6yC9MT+XlJX9Xb2DFtbO2L2iT1jUeIuu1NoDiN1IQ2JuYLL5hBP24
	vT6PrH40y+JoFRU/Qhd5ZLMneCDl9ZVbVgKx0djvdhEwvZgLySEcNCoPRUHrstn3QmAgPNp
	Xz6CscT9HqSVOLMMVIqZqSu24TEyeGuFvgmt1yXx3rgHqxGySp9Ow90p/8Bvze6Vp56IAVA
	+Z3gMAi+vSdJqdu8895F6aFnnTO+C3NOc9Z7iGg2hXvIGSAoACR0GZvIpeoB1fs5y9/qoII
	Iv9kyIt+i9sFXfpyqlVT+MPDRyYAys2PURinzuGUVbdqzPSs3rxeKTTXGA12zoXe9hwg3OD
	kXOuEO/gUTSh/p7bYcEt+cxJSq9S0ovM0OnqHHletRkhJckjbIh0ASGQz45tDcngbwWOFgu
	RjWK1l8fuSt7zY2BpJ/eqH3Ym3h8/pTyGPAF2WPofPRHmCn5SsK9SY6AssAXHQUZdyrjqdA
	BImmfsuWMl7sooyNyGoL25OwCtAgQfsASWzxtymjzPDL8RAPJq5zU7xJ5N33tm90skL5bYZ
	wu9vPcgwI4ouGVL58ExJ0A29DvUxsDrCoXebNjyw1BzI0z6xDjsaTuIB+5dets6CJbRQhy6
	ifD2n8Kga2B3Fb55iPLm9WcahDa6oK3jaHPT6fvRLrd/1mYgM4VFhQ96rsM8JDJrmnMcKCI
	G21dvqpqr86ie3s4AfQLuuZsoJEu26nf9r5YdPUKqrX/lI39NDUFwZTkRUFzlIF7gG8LICb
	3RwDzJyiNXjBp4QygElBA2NGJQKbO+mJDbRyCbGI+e2+3CNQ2D6CAdQwq+QZLAs+0UOdkv5
	5EQXvcauWcIGENNBqr7nM5z68rDpDHWbxg2O4OLdvOjcCDgUxGKc0wHfo+TvX7l6L93POg3
	+swGLlEGAFqj4P152UkeL8/43TjkM+SHFCp41UmqmNCoCCWcKv3ynk34wSeGOuKVD3hq9Pa
	LGFarmc59CFJSCqyHXyKLdKUGElEKKCmyC/Fx5T/vID6wx+Z9PQmg5t2FBIjRivdTDWzfvF
	xxcfOhMyfji0z0HgyX9FUwTftOPCVBfVRzZ6PxEGu8mg5LkXa1N99EkKxhFp70iEuAXEltW
	PenKBkYQ6+JSuPVL8Pfzh0=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

Hello,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

Log:
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Thu Jul 23 22:10:19 CST 2026
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Thu Jul 23 22:27:29 CST 2026
Linux version 6.18.40-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.40-rc2+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Thu Jul 23 22:45:01 CST 2026
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.40-rc2-g472909de267e (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Thu Jul 23 21:49:31 CST 2026

