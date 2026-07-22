Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA8A35FF5B
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 02:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784687567; cv=none; b=MjLsuyT1xVS1oTxHJxyheQQVSLfzEhpWbBStENv+DSDxAtRneMMu7C5q3CP+MYfc8xmwbGdaXm2Wke+kPNcA0VKSYsT2pQYXoTMnYm67rXNzMhd7C2+OkQ85wDA6MXEsDJtLrki3wIIHPn+QjjAlB6pVHrrM2hFKDAUsjhMRAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784687567; c=relaxed/simple;
	bh=qCrJKT1ci3lEnYRYRzat94/hZm4bPLRwXk0G9e/ki1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoSOssPXGHjjlef0CcpG9SJecKiSZv6KXQutWfA2o9C3MHVyNBFhAiUmkCN1xckbe1oKNkQRLL4iykqNAiWyub3DUSuMTkU3Rj0/BkC9fxfpCUYdYq+5NTpvFCxweP2RphAmqRNWDCOus6b43O5yAunkQ67NwoRUlXlWi6/YqT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=Gmrnob4q; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="Gmrnob4q"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 7070D14C2D6;
	Wed, 22 Jul 2026 04:32:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784687563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BaSQVtcWCKrTwJ4AlvpXSNjQ/l41HlANjlpENbMgND0=;
	b=Gmrnob4qYSS9Sc6FSQlkFQoqlYw1Jejq3aLH1eV5PXB8e/Bxc48uwwLl7M44G7QIdsvpiM
	kirDOjgzSdxhgYwwwDS9YEoBlbWqSx9ITP0Eiuond5jzCQ7OJXHRTuuDK6J1zZZMQkhzSk
	8RSMjsKWv1/UBtlwe2kLLq/x7UyG1Kyf1rPDA5VyXVmf2kgHeDXJrMSf6w73Kv/j86XOHL
	uZA8GjuDAsQCZGasJ1lCuaNv77ppO/jemmd+Su5WQSnfD9p6IzwWPRqAdYibTFwVjGtX/M
	T05prW4bStePziiLvzvqAB7/sw/alH8zW9e6MSNxdwgVa2ySoETGQwAOnh1lrQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 33df741f;
	Wed, 22 Jul 2026 02:32:36 +0000 (UTC)
Date: Wed, 22 Jul 2026 11:32:21 +0900
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
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
Message-ID: <amArtcs6q5YqtsgC@codewreck.org>
References: <20260721152446.065700225@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Jul 21, 2026 at 05:07:23PM +0200:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 160123ebe781 ("Linux 6.12.97-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
