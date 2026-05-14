Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492312BD58A
	for <patches@lists.linux.dev>; Thu, 14 May 2026 02:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778726324; cv=none; b=oQMT4fp4/4Pug8pYfdfKL4wrl4Cq2+19A1vxt/2Lk1llOHtVShuvO4ccUPq0Z12xA0EseLiUiFRE//LeY0mndZl2D1sJCBt0ErLzYWXh0/Y/TbxKZDIkXb8Kb/0lHedxpTdC/vXGL2IfHAYf7NS1/voN4kTpNwGZ7AF8F3prD9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778726324; c=relaxed/simple;
	bh=2mLNfb1HOpvIDrm9DQVOpQ5AkkEDfN++5jxE7gv1PH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6p1tl+0xV89s51X9vBWYwKicK3t5ANbKQmdGMRJwwJXF0S038QcH4b0gHOH5ezw82yKd27m0VHrb0oqTHZqsHRnAkbBUxeEzWoxaPRnysRIQOFLqgakd6EG/tGtBnlhwmjez4GpujZNEuu5U6zr3JpaAD2DKkfi4YVpxhmpIVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=u1DzODOy; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="u1DzODOy"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 0DBCF14C2D6;
	Thu, 14 May 2026 04:38:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1778726318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUIYZWrhQEIscq6DViIrphGG7tWDqiFTJqkPYD1d6us=;
	b=u1DzODOydwUvg15PAayRmDriRtkRRBiHbhu2e7Os4524af3NakGq1q5qb4vLwECyiC4Hji
	0FaiPO5L0q7oH5xPsCNf/dlEmMK++rvFNOqLdvIA2sB7zW1IiDJNe+UmLhkNN+lXOTTwQe
	A/xLywT31TUAiOMwg2bOqcaUavU17oNVgViQoWCFNYEU4kBoXOeAXEig0CV7ASj8elsQdY
	PZDy1WDQX/9qhUr5JTFe6ZDdcYuOqLqA11SZBEX5lm1z9LLFhq0JRTVh2/vwl5MJ+kRq4l
	Ia4M9fy3q6RVlnnagNffvxnRtLVvjfE5KT3SY4neH1GorD3RobFFLtTJ1yCSUw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id f709ff6c;
	Thu, 14 May 2026 02:38:31 +0000 (UTC)
Date: Thu, 14 May 2026 11:38:16 +0900
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
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
Message-ID: <agU1mMHEwt1PjWAm@codewreck.org>
References: <20260513153743.326058350@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, May 13, 2026 at 06:17:18PM +0200:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested 3cdde8c80e99 ("Linux 6.12.88-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
