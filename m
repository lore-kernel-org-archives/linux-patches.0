Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108763002D8
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 09:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768557389; cv=none; b=ocHXn6dPTXBu5nVYw4URdWGr3PzF4QuZkDfIWlikbapM6KPR6g0x5OGSBW6A3KV0X1MjwngUL+P4fDJB0Wy5mqYs400caLgj5FlHakFLmPpYSR6x4zdnVlFlXpCSzE+a5lcggSkmyNenwFrp+yhfdnEZYT/MusorNDrJ8REn+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768557389; c=relaxed/simple;
	bh=Ru4YdOPMO8JyIG8IViDsqj4oxY/u5ieUjSozqnjzb6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieBymjfpjrc8lZii/xiIAgBvTW0fa9ivWRKu89xevuEcbb6MV1zz/ai3lR8UTbIY/hFMVJRxMwpsu4mfKdKGKAYlRbfWxKuyQSKVVovmB60TX9HCQNfQO6/AsUI5D/6jCv9+hqCzcX9ddBSEpeJuouZxoq2ZlLUx+dIYtuZLUa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=L4VVUbHu; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="L4VVUbHu"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id E182514C2D6;
	Fri, 16 Jan 2026 10:46:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1768556771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E15582Kek6/U065vrWnxPSqHjUfFxA7RE8GHQYV+DJE=;
	b=L4VVUbHuth4ZnIxWu/uOmY+h+pgyHDusjSLYAgFptihagOdCEdr3TGBLx3J9tsJoUiD/tt
	heAjsztYmXysYwWWU1LKwld7p7wC5TxEDJLb53aQ48GXdjn28t2IO9Qnu1woxzCx1p3tKX
	vtH7DLGBaImtU1tIfVn1ljXzX/EPtLw0PoTdgB6K/K1awOYtVm+sMMCPD/t6U8LDWV9TKr
	3mihEUCh3IHsUfuco81fZ1nPC9lmxi/9XbOSQgNsJbPWnan905g0Duus8kJLhX8yF8Nvhb
	gRr/x5ZhuQ47g6gGQSnxjS4VdV4Jzja8X+peD43VYF90kAsMIDyoTTlx31ARtw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id eddc0139;
	Fri, 16 Jan 2026 09:46:04 +0000 (UTC)
Date: Fri, 16 Jan 2026 18:45:49 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
Message-ID: <aWoIzc0qXSMz1Vu0@codewreck.org>
References: <20260115164230.864985076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jan 15, 2026 at 05:43:21PM +0100:
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.


Tested 48eff3b1f60c ("Linux 5.10.248-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
