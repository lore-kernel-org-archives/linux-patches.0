Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A737B3FD
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791956682; cv=none; b=dQVqj7yNoXLqwXAkBPYplqZozlGzQ7bPJHLYF4bD2YrYwPriHIH4Lg6uuZ2Sy06nn/b/lP69I/FxPcrpaxG+o+94A8i29eHrOv+d5TwpYeviOQ8lkIY6EWWS5YFkcckw+gE1ni1+UUywXsEaucj04Jl/3JZ3p4XZL2X3RYE/6jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791956682; c=relaxed/simple;
	bh=heWpzQqvBVGU82Yz174oBmscC8H0jUS7+X9SkkbbirQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIFzNNnxC/JU6FZIfDA2S06Eu1REC4yv3YkmB8yKYa/9PS1kjpuQRAHm4LUo/YvvgUKMoNeEYVq3XMqfM0AuaVfPa/oZ7LhuOIZ0hvhHKi5UvAYUxA4dTmxgfQM/m8xwUlS0Uux0WCcXWDkw1/lpR4IZjKSJeKsSaCWRXGO4Huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=J9f6vMpa; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="J9f6vMpa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1791956653;
	bh=nYNbuYDcorJRISriCvwRL7UvKeCbKyVCU4parzj9WZI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=J9f6vMpaKnCMW5Aapkh2RMgLr7X7W6GJ0BqzEQ5N6U2hOh5RPceUFo7rJNRZnUQbf
	 Ai+Wl3zBFZ0fapUwskewFW7QDkWGFERfjig2/4k2wJeg0sXYQ96AMZFT2zfAkR3Ew0
	 GNPZ+eBhCNeGEEW2fzSSOUTpt5M5xa20cgkRiTW0=
X-QQ-mid: zesmtpip3t1791956647t1430a70e
X-QQ-Originating-IP: Q+V//eZXL1jo7H+ERbHDy0fyDgUkskzDbCdSiFF0V5k=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 14 Oct 2026 13:44:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13114247789848424888
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
Subject: Re:  [PATCH 6.18 000/621] 6.18.57-rc1 review
Date: Wed, 14 Oct 2026 13:43:55 +0800
Message-Id: <20261014054354.4048552-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NDiTMgVNbn1gxbTIOrXqa50RLn7v5VEX2hD0VNLa++6FVNYN8W2U4Ucp
	sfQBm2HydRqPjP2a53Op9LQ2amkAPogAFJYdBH2YTBmU3zkiZ5XjyabAwqNgdepqLTBzUoL
	9Uqt3KwpLDxHElGMRyv3J9cOZoXIulIoTrbm/74POIiUzoMHT3Y7FNMjnqoVBT4lfK0CNFO
	qp+Lr50q1JgX1/Q+f7feskQWl/9ensc5zdNgH1hzWfJn3i9LJkWqJcvw+Bw2Kutg0PDfLQp
	MrXjPPQWvuxhyao+o5Db1r5eLfZbzC5oC1Sa63VNKUsOuiILG4fyP2g0iJTqu1Q/bkM1W16
	7CI6GxbZVtd3i05YsNbbuQN/5MPH7xtqNJwkw0EHdXZPEg4OGcuZ8Kt/vNdGM+IrPY2L2Ew
	Sr5RtXI5rA3opQ9i9fsVM23ok/8CA3xwt17E4BJzHU95AMIUWc7jXLaZakvt0bGdlAC+6fm
	DViooKRl/MYawHepzc5fsNbSvgeTndMnJ/AasrkpRbHdOFMzZ6WjcLMWTsFEuG/9WOb52mv
	NWjewL2aR8ReCbWUhlP1pVFoZ/lMiByOL3hxKHPMISmn5pDEaKXeVMWKXOksPtVLDxcgAQv
	BPNN6K6ftVkblGcO/JcSlbr42NlZuIXR0nqJNIC6t+4hGkq3YrJZsVZgNllcW8uMQt8DDhI
	2tXjbIOuFz3Tgk9W/siqMUyPbaqq9H9iLlNf8grTH/g0aM8fhogOGWBrtwMO7ylyzYLyJ8x
	P+Yl/fzHl40ulORXh/UlbgfLtL66hqhumXSwz7g612xw4w6vylm4m+DxrNkEigoDuBhESkw
	/c3ujvlKO96BthxzOXj+GS5oadvb2dO0h6bpAIVzHdALNXDMnhW7b2b06QB4lW4r4+yqGTH
	fYA9nxNvZ2zBoO8KB/oh6xeBmOZtuZSzSwbislD3I+RUHvtwolF5UMKQfUN3Xs1W2hOPxm4
	VAJY+wMPrSh97sh8BQXmkmFbV5RBRF9C1LVAYl5EhrnEluXviC4MiU6dX8hPIWsUjTkDbeQ
	9z/xfvL1Glhb3xchzMquT6kOe1LiXW/2uZczaHVYHBVv1tqFBbTASjfFNRdJU=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

I met the same riscv 'RISCV_ISA_EXT_H' build issue others had reported.

Best Regards
Wentao Guan

Log:
arch/riscv/kernel/cpufeature.c: In function ‘riscv_clear_hypervisor_csr’:
arch/riscv/kernel/cpufeature.c:1140:43: error: ‘RISCV_ISA_EXT_H’ undeclared (first use in this function); did you mean ‘RISCV_ISA_EXT_h’?
 1140 |         if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_H))
      |                                           ^~~~~~~~~~~~~~~
      |                                           RISCV_ISA_EXT_h
arch/riscv/kernel/cpufeature.c:1140:43: note: each undeclared identifier is reported only once for each function it appears in
  CC      arch/riscv/kernel/acpi.o
  CC      arch/riscv/kernel/pi/cmdline_early.o
  CC      arch/riscv/kernel/acpi_numa.o

