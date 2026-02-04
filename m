Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DF039C636
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770248566; cv=none; b=MtlUXTZk4ofr6xWb3XiRLkNbwv2iqXIZ3g/y/bEiYbyR1toBikh2ETz96cykeA7SWr02cBPmDb4FeRbJuHgiT2KX6j1tJqU82FKePNu4HKmLC2XIIGP4uhOA9Ub6t9/9M5SxUHRIuBGp87duBvz5kXZj2rqFPsedjl4jBdOj8Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770248566; c=relaxed/simple;
	bh=Qwazp5Cs4dVAaK0qgQlMepUlLhPieSj1I4Vq/fplswQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaAKlTjQvNtSlf9vAfQgU4Sg4zLrUyPwG6lTuZNsCX/0ia1wGrAnvft+MtpYPFUidPPCuy5Fir0+HLofwnJzNz6uc2xu2TXbDFgXtbZdUe7dhHDlU4BigwQK68H0+8s/UyYGVN1Uhtko55MiI3qeX2kjvq2oTA6JQFumkdFnIfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=vrgt/Ny1; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="vrgt/Ny1"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 34AAA14C2D6;
	Thu,  5 Feb 2026 00:42:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1770248557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0olO9sdR7JDrd6zGdsxOW/+16C/AiHUzSiECz9CkJCY=;
	b=vrgt/Ny17qM0KixSktv1bcYgGcx23+h9qT+UFHy72dk3pLCLmzn09kPGFjmVHEFl4BNtuy
	65Es0LDQSaEsU1YgORDjD/dvyuHHrEej4z/0dECroFQ8nWB4McKaTIWOe9WulkYRA6q+2M
	aArUeGHA551y3nHuWmbA/2W0jBA7GI0SIBr4e2IYlMg80cFAwK3DQjiEFheeIfya/oxvch
	3YQHIC0F8/TbjNTH03enMLqZYV7hfV4YBI9xno4NLhfZCYiIXPUVWoxwtshDGaAtG+2RVv
	Gd/CCHJewfTb5zUtELC0MHxiyq5Q8T1LDbAkuV+6yYZ5gRe2PhurnZlKFE14/A==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 960cdf1f;
	Wed, 4 Feb 2026 23:42:30 +0000 (UTC)
Date: Thu, 5 Feb 2026 08:42:15 +0900
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
Subject: Re: [PATCH 5.10 000/161] 5.10.249-rc1 review
Message-ID: <aYPZV4pbnNGPrqqA@codewreck.org>
References: <20260204143851.755002596@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Feb 04, 2026 at 03:37:43PM +0100:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested be6be3cfdcdb ("Linux 5.10.249-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
