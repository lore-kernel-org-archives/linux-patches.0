Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6BA364032
	for <patches@lists.linux.dev>; Wed, 13 May 2026 03:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643608; cv=none; b=dgaksC8PXsEva6kwd/zJz6KfhIDjdcijDwrdSeq/4MA2bwLlK7Rhiuz8q3WVaP4iBinaDFjNc/RAlUZ2KOHvsUOjunWx10k18GsUUSg+n+MUhRGwJnrlIUWMvlQBjiTDhAH/ZPW8KuHhQtnZGJluyEJaqEw8UCw80gU8Dt6ZaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643608; c=relaxed/simple;
	bh=mYxry/8NBjbBPI6AAMjDjnDoWTMjb61vT3uF53inUPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL+Z5Hc/4RnN6etPMtkcUEnrGkYGqkozpwiJDc18hHHOQlghzCKS+jZL8nnDGvtjp3M4Hu7kT8Emt10xo+UN1PEpheW9WTYryHzuQCW1w923vNIDfJrRPZb6FygWv1DleFT4y2bxTBSkZy76lAYmsrvOLFGfdD+e7+s4MhHWwOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=QyMkzAKO; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="QyMkzAKO"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id BA64914C2D6;
	Wed, 13 May 2026 05:30:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1778643039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RaX8xh4VNH0xv6nK3ud1AlAhJ1EYOpgGBtILxaGFe8M=;
	b=QyMkzAKOwbyATEbsWQzDP2OnMDTJv8naVkvE9C2hQQw1Dj8hEhXBn7nkIJbFEuHT+2VRpV
	6hsNZAIcgUxECC87TDWZgZ6AWCHbpSt6FKd/Ca30jLey1GF4Dtck2Vb31ShAUPkmq1Bpp1
	Y/9HWA/N+FGA4VruDusUxxClcLZlnVVx0el+0bIR65nWzE2b8j9bZZFd0M+dH9PildyWBE
	n8nlsD4cEeCh661DDnzymgV6tCzlLaYZqMwdXIT6EPkhjtO38M4Z5nLSr1VLdGY7pFQ8zg
	nL1UR7JNNbdoUu1Qa7Ti0EYXqKVfv74xMhwZK117A3IOsJl7j7zl3FOD1C5raA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e9158659;
	Wed, 13 May 2026 03:30:32 +0000 (UTC)
Date: Wed, 13 May 2026 12:30:16 +0900
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
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
Message-ID: <agPwSNdA0B-eZdJW@codewreck.org>
References: <20260512173932.810559588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>

Tested 12d177f80a13 ("Linux 6.12.88-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
