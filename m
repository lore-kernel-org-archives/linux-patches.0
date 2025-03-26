Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925511F5433
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 17:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743011055; cv=none; b=b2rs93dns/4JVmThKVqQLBb5lSJOSlh7V+FVDix1G6Eed+ekbKMM7RXRM72eldOjTSzAYK9C7i6VAf1m8NOJoSUsFgRyLsaKbapo3lnZ/z8+Rj9tgGK582IrEln1jda95/9Sv/oSkeE7PfZyGA+nc+/yMei076B+5h9+EJeCw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743011055; c=relaxed/simple;
	bh=c1Wbi75LGrSeGt/aV3kfRa3hRUD3htYxVSNPBoaB634=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Y51HAv7prCcHCTvNmR9IhjDJP5Z2ysjIZAMxPdR6Yn5mSfng0hA6itGNjKXeUFT7W0RVRQ6zTXqnRTe6WATz2JPyugHdSy4Yi0o3Qv4aGGLjJujlf2EQdgwumqyDweB/bi8Q5PNVQ6OenfUAbaaIHgA5unENKM4ukf9TrYnkME4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=M9WGQumN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="M9WGQumN"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 15F8E203657D; Wed, 26 Mar 2025 10:44:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 15F8E203657D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1743011054;
	bh=7ON7Lx5WziLX9EyB39yTlXH5hwR0+Sud+i4xgixsKG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9WGQumNi47gap5ynxpBiSPoi9A7h59COPaUozisoG3pNa4ayhAqz+N47V5iFaPFo
	 jhZxBd7KpvZXyPcKivd+8FE1wkvQTCUtBAAH4qL/jZtK3JJ7Xud1Do44o91RaQWCc2
	 jtaWEF4StgNIuxFV2cGAPjuuyumn9cwZzW79iyRI=
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
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
Date: Wed, 26 Mar 2025 10:44:14 -0700
Message-Id: <1743011054-4428-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
References: <20250326154546.724728617@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.21-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27757173  17715502  6393856  51866531  3176ba3  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36395528  14996573  1052816  52444917  3203ef5  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
