Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66628153803
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734104031; cv=none; b=tJVHHOS0+ipWsecJ1Jjx0DTTiOjWS/c3KJ8lbHBMIIuPcKiJ/MCi6YMS9h09ZpuWWkY8OCz0k1lmElwryGIJW3kZQVEPKwWdSYsIF6gwWg5Sq/U3KLKmGaQFzskV9WvEyK91zMVNk46PfaKSjS0RydSjFaZj3D2Cr3fr2UeiGIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734104031; c=relaxed/simple;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Bx8gyxQp/OPQZMw9/yy9Pd70NMc7oFQErnxsr2VaQwk2PPFtTuzdpfkyWitQY8+lPr1qLVEpT9OBaCnm8mpTvkXGcJUSD1GYDH0TxGgeB9fvsjBocJEQgGJq2RgrJCkK5k7kneErD7s6jVAcoWSgTU2adI8U8lW5/NqQ0TJSCYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RV7EoQTE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RV7EoQTE"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C4C9A20BCAEA; Fri, 13 Dec 2024 07:33:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4C9A20BCAEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734104028;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV7EoQTEA8djDTWFw8RTKiB+JXTH7/oJVK5wCr2mjiUVqZ8vBceKogk2ZdY/lNmCL
	 b3kY6IkzZyggTTTWX1juYxaBtGydWyrdIH5rwgDmfSS1Xa1tZCjk+pwnxfLEsKBTUM
	 sI/aH6svXFQ5+YmBb9dJSFOpuqcNhyByMkmX7iWY=
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
Subject: Re: [PATCH 6.6] 6.6.66-rc1 review
Date: Fri, 13 Dec 2024 07:33:48 -0800
Message-Id: <1734104028-23150-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
