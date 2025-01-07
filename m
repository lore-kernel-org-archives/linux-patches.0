Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F96EA95C
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 20:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736283545; cv=none; b=kuyy3zdj8KjqT3K1jl8NLtGYkYAPeEfSIRU8xMGrAgHQnhAvksneDT4aBeEXiX159zC1AEZWqxXcvHWRC38NeyeGBtc5XeNaYzA5j/72QbnupH4++EfGnG5u5vq3pIBWXl6AydoJqRqBf2uKVIT2z21v0Q4iQ6edIPoin/OwYj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736283545; c=relaxed/simple;
	bh=qSI6dd4aIpU3sV87VgzVzLlPxKdASDlZNl51nncdwwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=JbOuXQEujstT59FbI2ITMgYK3ivUpaqqQTJiqwATaPW0U0faQzY7P3pXuQo4SpLVcl8OrY5wXw8/X+Ldj9H70qdkUFegilD8OPRq6BgO7vWtVI8ssbVfMofWytDDG2JlxW3wYgkO90FlLlF72y/PJjFUqtFd3JVVEqXPZBaa/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TNdFAd/s; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TNdFAd/s"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id ABB61206ADF6; Tue,  7 Jan 2025 12:59:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ABB61206ADF6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1736283543;
	bh=qSI6dd4aIpU3sV87VgzVzLlPxKdASDlZNl51nncdwwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNdFAd/sSWW2MyFoKVItp9vKQj22LauvcU5Yqa32b6QnaaTgZMJXaFsgrKz+Ggct9
	 diGRWH4Xp3huwisXzfsOoEOnKgmp0IqAWWQvTkq2I7285EejrBj+HBUGGSPzOPgvhu
	 IGTAMlg6+dw6Td17iNcfBXU5AuYdd0JJb/0Oresk=
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
Subject: Re: [PATCH 6.1] 6.1.124-rc1 review
Date: Tue,  7 Jan 2025 12:59:03 -0800
Message-Id: <1736283543-4698-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.1.124-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
