Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793265630;
	b=iHtx5o3NNpP35rNn1t6viFcldUaE5nfeHtJJ0l5maiPnNIj68unA1mTJl5g61ako9bi3
	 jzwhBOCeucr/NrVkTwsAVwvQnCFho7+MfNhOdIlHAR/ZS31LNQLdAm6KVXK8UEDByWCXi
	 zjhpfUC3xJBUHPi2cR6ErMuXpkwp549Gvl6d9SWo0MRVIV9gQzhvkefFIuDH+CYQH644q
	 NRHHae9zz2Jyg4+5BIUo20DrCukWNAe6Ms0b3ZgudMTknnYAVCSnpl0UqRrtUV86h9hwS
	 o28gxs2KDJowp/DHhj/cirnjrhmfQ+MMF0VKyATU+OzG2cmcD0lIqcVjpYE0rPIX/eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793265630;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=hSSHckiP3MA8HyhGdwTljIsGuCQYdGee9x9CnEq+2kc=;
	b=bl4L8/QgnyQpQGCmMUW+ZVi8XLYldPLYI3WfJRmtnxnSy+YGiRjJIqYz2I8GJoXQ9UOH
	 hXpfH6JAr7/0R/q3qUqY4wgFMuU43KH9aA+ddDoZd7GyTvulSoZ0GxbUpa8MshkjLEcha
	 uoCn0RYRTIEvfgFdbgdt35OuPhA6nOnyF2KpmrZEWITw0ZxSW/yoW6IkM3IYBPDBqHZu6
	 1Jic3az3Nwr6DLIGT3q/8GOORx9VtEr1HDcG+cLJ+kEktO4aM4LRCwdyOIPSfGwMfy/Le
	 nXaxMPh8i6RmwmD6NpjreoIQs/LOBni/GPU9AlHIHxw1tcfbnIyqWV5hLb1BAWPPNGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=SnXzLZIm;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8946606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 09:20:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8946606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=SnXzLZIm
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id A723214C2D6;
	Thu, 29 Oct 2026 10:20:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1793265625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hSSHckiP3MA8HyhGdwTljIsGuCQYdGee9x9CnEq+2kc=;
	b=SnXzLZImQqN+E5KmMINbDXvL/oJTdd+GesYuXj/vZsKi65fs08pg0/wlXGp50QtnkKS6Ay
	VIq85tth8y5UdyrRewdEfPqAqNE7VfIyiEcBTkvk8GhkZc1BLFqVa5DMmHN1/o5IjPyjWC
	XlNxtSDIeNwwbUF4psbCILNNNhvsD0T+Dar5YtcupjOL3rOchgbxXIv2RbB9ugP8E0ntPT
	GT+Pjpa5V5nrNwHnuEoFgWuVE5OdjnGgcdigaWvxGWZt/ckABFCHyuODn/kV6TvbY5wODC
	Qgklg/1P41FYYM8M4DEv1PrLNZRtw5IR1SWC5vH6Db0D0ueM3bBBdpi4VVZlMQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id cc75f923;
	Thu, 29 Oct 2026 09:20:17 +0000 (UTC)
Date: Thu, 29 Oct 2026 18:20:02 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Message-ID: <auMPwqvPslViDOgu@codewreck.org>
References: <20261028165947.349197979@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Oct 28, 2026 at 05:56:43PM +0100:
> This is the start of the stable review cycle for the 6.12.115 release.
> There are 247 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested adc8e434cf08 ("Linux 6.12.115-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinett
