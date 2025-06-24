Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64E81335BA
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750748590; cv=none; b=Bix+pSkRjFIraBBBjJuwdwBUJwgBixqPhKqMMB6x63jrEd8lWqKLD7/CCA8dO3MudT082XI4z09RKE6hJbJfeHvR+gkXWw+MRwVOqZwrbReKmlKSxdw34k8bFQQAmeMZOr9RZv+DN2XlQBmZ37uUiEmVcPO6gLOIA/6vqd5JwYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750748590; c=relaxed/simple;
	bh=XOD1QPRKZMAXGA5MaZaHtwrD+CxKUTaDpa/4tHaEFoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNiA36QowFOQPgXsmPDLdRFEbKxcLonQoM/+JYwzqwB7nc9vKiDQSmvBaET6bcz94Xr5s1xBF8MnzuJIaK7YDSmxkOInDn7/xtjL/NwLZ6YnVeJom8qp5M2br6K3XABcwzgMRO8OH1S3aVZHC0uR7D/JfYSGwKl4iZndjkCpuic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=yBONtD2M; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="yBONtD2M"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id B76BD14C2D3;
	Tue, 24 Jun 2025 09:02:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1750748580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cp+L8jxaNWQ/VZWl/gG/gGy4pfGeCsfwYLw/hzTr0s4=;
	b=yBONtD2MqCr2UZsn+GD7EgMSDf7AVZG9j81sywJhaKCU4GMLeQTJoUnQvf33TZz+BFtdYp
	bLB7ulGAqfV2UaVYuqf8ZylbkKCV8NDEYZ46dkaU5c9RCSBT02lP7+jMrNC52guvbk5UZ9
	xHkU+iL8P912cWtahighLbcC7YPLd6RGQ1G1A3j1UM7RkiZm7KR2XthxunNgkH7J1r6O0Q
	rBuKqn4A3NhyhPPaeAZEsmXJvf4ycVKkffIUNwy2mtc54E1Hs5DI3JjqaLUtPKXGpXJLf3
	/aZqGJl+YKPczSppDJs08SCeonYcrFesOrCvy2eoOZAwVZyT2iTvS1BweLzWzQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e75e798f;
	Tue, 24 Jun 2025 07:02:54 +0000 (UTC)
Date: Tue, 24 Jun 2025 16:02:39 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/355] 5.10.239-rc1 review
Message-ID: <aFpNj5SrxHFBU14c@codewreck.org>
References: <20250623130626.716971725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Jun 23, 2025 at 03:03:21PM +0200:
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Aside of the build problem on arm64 (and a resume bug on our end that
seems to have gotten more likely, but does not look caused by this
update) this looks good to me:

Tested 7b5e3f5b0ebc ("Linux 5.10.239-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
