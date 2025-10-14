Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1C2DF6F9
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 08:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760430103; cv=none; b=eD1ZaZ5j2LPQjJyRVYdgHvMOtOgzyIYlgJaRuDaf57Zvkz1HcTXdyDPiM/iCD6c/Vngz6vzR+3oDKkDz5cHudjlJb4XKvu5BmDCovf3q5vHj8phTZ5cqzQWvKSkM58qJ4y1DwwbWKOJazEVxH1e1z+4H2nWHoyp2bvlOTmJ0yRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760430103; c=relaxed/simple;
	bh=xM1b7uAmoF+0lTnL/RCcsm8ctZUMQXSO9CBQC+NaSjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MkDPpjpG78f5kZq1vN+9Fwl3uMY/DDjyE2LL+OXpS1pQoaVPPZTInAEsXEIAT3w23OEBbKaXB+UEwZ820cvl1aAhPcnvD+XUpZBSHKm4JRRUbOIwyQVOWKOuSMSoHLHxs5h9zU5Mn89nU2ZyLVuts1BUaixmyZfmPa+C76MMDQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=KfMuj1rT; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="KfMuj1rT"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1760429591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDb7M2A0GHjC5njeUDg6qmznaomzQlc2fE+GVJnsmGY=;
	b=KfMuj1rTh0YUPvJW3hSfwocNkxsBnDyQN2NKer6kuLNOS4UdcoVxWPGRLcaTcDPE6rp6GY
	h5YoXx8f0PaEmDBg==
Message-ID: <8e6e42b3-46c8-4f36-ab52-8b058b2471e1@hardfalcon.net>
Date: Tue, 14 Oct 2025 10:13:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144411.274874080@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-10-13 16:37] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.


Kernel 6.17.3-rc1 compiles fine for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7, and the resulting kernel boots and runs without any discernible issues on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and on a Zen 2 VM and a bunch of Kaby Lake VMs.

Tested-by: Pascal Ernster <git@hardfalcon.net>
