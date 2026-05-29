Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6AE390989
	for <patches@lists.linux.dev>; Fri, 29 May 2026 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077368; cv=none; b=JHwtFsWkfnkCaMTi9WPjYG8PzhHGvb8ZVUlTGRlUONRfWL0yR1jUPyVOtjEtMAtsbf0YCfccr5qtKF9H2M1PRpJGqw9w2CwUumFrkHIV35FyMOiPCsB5OChJGwSBiKlJE9zDdS+PA/tFa/VSRlJJA/1pQMSxGi/OBlScvpyO/yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077368; c=relaxed/simple;
	bh=vm6Q0S4YiiKH57VVKy1Ac0D68zpw0soutwjtY13VWfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PlwTnUVY5dqSnivnV+pzq7uizlnwrtblBjT8J2/JHko9HWVd4ETyWYmpZxUn7M7Mnei0F/ICbB/kll3+fuJL/iVRTJAFcvbK8Lm0MAgxRcS3O2zMZjCF8tMn/x5l+K1nYGdaR2VmkIZPSm38d+yC1Jcia1Lvh5kisZEYIM82dJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=h4oJGSV+; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="h4oJGSV+"
Received: from mail01.disroot.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id F143426F0D;
	Fri, 29 May 2026 19:47:48 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id 1XfauoxPqr5W; Fri, 29 May 2026 19:47:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1780076868; bh=vm6Q0S4YiiKH57VVKy1Ac0D68zpw0soutwjtY13VWfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4oJGSV+2PgRlFdbzV1ULDeJVL/lqL+Km7CRWBdBd5kcbZJ+O75J5pc8zfVHRJhJq
	 MybCKuQCx1yMB4R1W3k8ON1Tkk6+93JsNHlPzElkB8k2yRMkyu99NRaXVzNnzG31bI
	 OdtspWH3Vs8ki4SXCEtrS8bEUumpwzT2wngqz+AsK7BnTnzuReoSZvrhLZE2WcnbBV
	 MfVoNI7FCQUg2sUZ3/IdlWv+P1LSdcquMpZgNrFb/8VOurr2yafq/tf4OttpL1Qv+W
	 27M7dC0Xm9UqazMHyRKeLwv6RpP3q8OqIkajSWpL7Bi3tG8fMm+4W2JGuBe7gzDxTB
	 1PsxwU44ih+MQ==
From: Masoud Aghasi <maghasi@disroot.org>
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
	Masoud Aghasi <maghasi@disroot.org>
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
Date: Fri, 29 May 2026 18:44:17 +0100
Message-ID: <20260529174419.351793-1-maghasi@disroot.org>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tested kernel 7.0.11‑rc1 on the following setups:

1. QEMU VM, Arch Linux x86_64
   Booted successfully. No regressions, panics or oops observed.

2. Raspberry Pi 4B (4 GB), Raspberry Pi OS Lite 64‑bit
   Booted successfully. Observed a null‑pointer dereference oops
   in journalctl, which also occurs in the previous stable kernel
   (v7.0.10). So no regressions observed.

Details:

$ uname -a
Linux testrpi 7.0.11-rc1-v8+ #1 SMP PREEMPT Fri May 29 13:18:21 BST 2026 aarch64 GNU/Linux

$ sudo journalctl -b | grep -iE "error|warn|fail|oops|panic"
May 29 11:35:10 testrpi rpi-resize-swap-file[369]: mkswap: /var/swap: warning: wiping old swap signature.
May 29 11:35:11 testrpi kernel: Internal error: Oops: 0000000096000005 [#1]  SMP
May 29 11:35:22 testrpi bluetoothd[542]: Failed to set mode: Failed (0x03)
May 29 11:35:25 testrpi NetworkManager[561]: <info>  [1780050925.4153] failed to open /run/network/ifstate
May 29 11:35:31 testrpi cloud-init[525]: 2026-05-29 10:35:31,802 - modules.py[WARNING]: Could not find module named cc_netplan_nm_patch (searched ['cc_netplan_nm_patch', 'cloudinit.config.cc_netplan_nm_patch'])

Tested-by: Masoud Aghasi <maghasi@disroot.org>

Best regards
