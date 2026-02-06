Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E5F13DDAE
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770341035; cv=none; b=VeITdZrGlubw9Qy6MSnLFT7XirUam5YF47/C8rUw4jJqUfXZOEFb4+e/FEy2zlT13sHPbJl/ONZn3sfUZnLfWzW6IU2cc79fEikl6V7guwQpQPWx+gGTrYGp/l38LrdQ8xDzepd7V4ef1OrGrEpTBwfONXeNOHi2Aw3b8nt3uoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770341035; c=relaxed/simple;
	bh=7RD/x6FqfnxcxfqW4eMUOAfVxOZZkBoxnsZeuPSn/6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdIh9ozF2rqTW6dO9aCqlRzgsk4j6vARYDPMoqVIVCVf3tDJTRrYmbW3BA03UlTVGDf2h3c6USGZSLE20398/RWrOVfsSw+5D40kI0l2HI5+FC5x9MH7KLzw0rOaN+R6+CU+BlmQhUZZOICi8j9sVSJaXqR0zJnNCYBk2Vo8Uz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=SypAKb96; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="SypAKb96"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8A85A20B7165; Thu,  5 Feb 2026 17:23:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8A85A20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770341035;
	bh=7RD/x6FqfnxcxfqW4eMUOAfVxOZZkBoxnsZeuPSn/6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SypAKb96HtgI94EVLXxxd1EllXJsfrmLC9E+UTqfe84DTU5qJ3/s37UBI+7cjLPLq
	 nfbF6gs89KGC4HT7Mr1vflmPEAT/usfXFuev0q406X9Ds5CuoWugZzWQ4rfHMDDoUv
	 ykDTDiJUvn8uNwvnrNxhtOLT/CDrmVwA3LizrssQ=
From: Hardik Garg <hargar@linux.microsoft.com>
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Date: Thu,  5 Feb 2026 17:23:54 -0800
Message-ID: <20260206012354.960611-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.18.9-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
