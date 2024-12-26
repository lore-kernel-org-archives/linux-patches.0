Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91E12BCF5
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735241153; cv=none; b=o2S4XnwhIj/n63MrLOsxg+HxvKfWHWlePOHhuxL6HWi/OU7Oguz6VO+mkqcomn3sh4J6nqRdsoX02ZR6/wWqUp98mL5ZCqVEpxpGCYVaU2b4hdh9uxS8jab+wqKNhylgSp+TBF+SEbo6cfgAr/BBvRMQY5zcH+U9ZzVHukX01eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735241153; c=relaxed/simple;
	bh=cy1FTu3yw3/LRkw4CAp4YrnfbKzoM4XTyEp7i/p5Ozs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=osh1CTXfM3dn0KQ74BOHnxxr36yo40Bd5Uh/JoM8hUky3mBGrp3oviyOlHD7QE6Fr3kHwQZNWC4bBPjs6GndgN6BKGBT+Jp64HHRwlOX32LPGFcMFLRHcuRhhCi8H+ocTxTKtE9+2l+NhCyquJEejNdYxW70Px6FWUmMI1WO1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HYwtVFmZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HYwtVFmZ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0F8D4203EC22; Thu, 26 Dec 2024 11:25:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0F8D4203EC22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1735241151;
	bh=cy1FTu3yw3/LRkw4CAp4YrnfbKzoM4XTyEp7i/p5Ozs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYwtVFmZW+CXABs/yHvabozgOPuH0ZUIuY9ol2rfHIQ54Ut4s8wWH6M86nMvDPRUh
	 Tjh80VwnLZFNYX5rO2CLEYOOmZ9Dn6RG6wtYcoWmJjl7cUZ645yCp2Bhbd/tBl4x0o
	 r9K1F6Aq2vqZkAvvzt5tbzeoD1OF5bLQ0nEHQ+BQ=
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
Subject: Re: [PATCH 6.1] 6.1.122-rc1 review
Date: Thu, 26 Dec 2024 11:25:51 -0800
Message-Id: <1735241151-21119-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.1.122-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
