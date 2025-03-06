Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1785253358
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280699; cv=none; b=U8KZ/cOq126hJERjj2PeIER9o8qz3BjNMLz+O7tCxia/J7RnMarPEAZbFUehz1O6BBXsg/3574CGu1OUdgXZDl9ZNjPYrMFbDu5E5ycKh6EWN5k3hvmlZHn2MNw1fcblZorzesS8Q0scy6P2uwnVNaQ1YHI8pjUYbI841sGbQJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280699; c=relaxed/simple;
	bh=xT5fC436rlT5s9cECIzNlb+mxQkfxjrSoVh828pIQl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=GehDcIUvmyYrKAMEbGtPj0hivBcwPtdpf2xs/7YBctBEeKcQ8eE1vWT7i8c9sogjiPnx0Afu2CEi/5CaVipktdBk+f3oUSLvR0dBLBsuFhNw+0BSG7WEAuvADIolMtMWlhLh/qQTuW6/wgM5ErQkTwAfAlHsD+BIVZJwZvO/kc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=QZ2taD0F; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QZ2taD0F"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6A2C6208A7B8; Thu,  6 Mar 2025 09:04:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6A2C6208A7B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741280697;
	bh=Yl30IzYepq/NK4mikLSFBzxAFDxddkZkNEjc+Gr5dGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ2taD0FlJQQjjH7uGB+Nl71b/TP4XJwD17ml2THeCivg92qXaC+bO1ig/a2LUoDE
	 zQQuJMFGtXnPN8Iy82Rv94/IwIM6TOAW984h6FoRSER7jJT+68166IQAIuwNm5r3bN
	 qFI5vONSpcyD0Us3nIJ0vc3ycGxhSxUaAuSwfCoo=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
Date: Thu,  6 Mar 2025 09:04:57 -0800
Message-Id: <1741280697-6611-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.81-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318071  16713718  4644864  48676653  2e6bf2d  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34688815  13844910  970368  49504093  2f35f5d  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
