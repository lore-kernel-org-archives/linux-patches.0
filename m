Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDCE4D9FB
	for <patches@lists.linux.dev>; Sun,  1 Sep 2024 21:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725226325; cv=none; b=IwwI/8UMYOXJeTZKh3K/fl3O6spB4AJarJBSfHmX6SYWU/uc1SwG77rnY+A0rrItqyv4MhIAf2EGqCAPcjiPNdovDUekdRPDAgpGUPUfzU2toecnvtoofAPG4F6HmFrRTIS0cTIxjunzxolyL//WlUXSsFFlyfV95aUlovVUiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725226325; c=relaxed/simple;
	bh=hAKxii2AHA4r0SKAFo3pvPOxzOVgeBfKCGIQJSUYPXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uldzt4/ojBcuNsZNpECv7wNZqgDjpaMD5HPn0YnGFo4fKMzzEzwi3HoU3rNRHJtyxR5PB8MPppMwXCEO6b76QDS3IojUNZupxxYV+8iAMzm7NMgU4I0AhTcI2HEbr1ATUzbe26HMTdQYlqyX3npJIEEZXgcH6myY5rL65c0aqWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=l90DbWeJ; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="l90DbWeJ"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 452F114C1E1;
	Sun,  1 Sep 2024 23:31:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1725226312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IjF8kFSC1OaoOTtQg6ZwHQDUnXTJvG+nyTqgCngUekA=;
	b=l90DbWeJ0eSih6v7OKDYJeda3OTeGVgfxuPJZRrmAa2xtWUjyjAH4eceGrjcJNg+V/Qubh
	O6Uuskt4Je8JiudgTu1SAdW97eUZzPoPFpBBITz+mLgvCLUq76aN30n3ANOF5i2b0babl2
	wXtdylEN2mxJhNut5rxX4+pJS5LWIZMj6KfVYei0Erc7zpebX9LSDVk7ElQaEHdB5hcID6
	FzEBwdJGLVqkBtRiz6f/J1SDYirCOz9lhfMO6fCNPxY2mmrr0lNKPoMcMsebqPBnN4jrSU
	K/TdWmcXG4oXJ+I69it8kbF3Mjg1KErbmw3vgEucOnszsmUFh3wsPpdeetR1gA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f91a7026;
	Sun, 1 Sep 2024 21:31:45 +0000 (UTC)
Date: Mon, 2 Sep 2024 06:31:30 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/151] 5.10.225-rc1 review
Message-ID: <ZtTdMijfnu0mqanS@codewreck.org>
References: <20240901160814.090297276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sun, Sep 01, 2024 at 06:16:00PM +0200:
> This is the start of the stable review cycle for the 5.10.225 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.225-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested ee485d4aa099 ("Linux 5.10.225-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
