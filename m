Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243681D47AD
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741799853; cv=none; b=KtqbI1oNWzdi+EtPSP6RaHxJ5TY2hb0ZmhvgvOkE/bH88OCNU1aMwau5I63UM/rHBVI6jU3lwC29uJwSkSA/fPjRqtXbBonaEd3BTDR0lNnP7EgQE8eMjv1+I5M053yEPGbis+AO7fWOiRE28N2E5GPgTJKdzoAqidXxIUfltuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741799853; c=relaxed/simple;
	bh=qPsHWFyqEKIv9C11r5J/nl26DIxHsGDpoTFqRwxczi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Dp7aM6/ZFvJ/kh+pSwR6+d1Z7QehI585wg/6oJG78IP3RS+QCTPfuQz5kbjvQm0nQdgFzVb0KQQK+dYj0fkbZd+3/4CcN8G2tsyCaDEUw7C8olqRYYTYumbP18fR2WI3A2TDfbZ/3w2b8r17N/XPL4b94/NiaIf+ClUpjB+15aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gsB6f/8T; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gsB6f/8T"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id AFC3C210B151; Wed, 12 Mar 2025 10:17:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AFC3C210B151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741799851;
	bh=LYlF1jZQQZSUdbTS3gcYHxVRCWCvMJzs/Wm15lswkrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsB6f/8TwMv4kt0cYyQU1zW5ppEYbpys13XWTSyjG0rg1O9vR8emfPa43sc+D1Lqd
	 YZbYK9G8Hgj7ECyZsMr5HkPg+Z/N88HzI7zZzN8tB5d0YdKnjlWuhsfVpz3JYU5MKB
	 9dvCPxrFpHnwwdcDP6FpvvnS041aDIQb9ZAJeRO8=
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
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
Date: Wed, 12 Mar 2025 10:17:31 -0700
Message-Id: <1741799851-16836-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.19-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27756160  17713706  6397952  51867818  31770aa  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36399457  14996921  1052816  52449194  3204faa  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
