Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44538D3F4
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 08:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787042678; cv=none; b=lNjx0HLqmx3WzoiamQuBsH+pQnnwK/yleXYnQumYvIGxwHtY16zQzEvc2pOQkRsfLKTs1RMgiPJSQd4pM8DpN12VTBhYU/1pQc82vAicrFKHa1MJDHLQuqzaV3jZDLOM+gvxtap4jb2+K3rav9ZVGwl3fmzlF/eU3R+nLc1hm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787042678; c=relaxed/simple;
	bh=KAuBAo6iWRRTQjIxttzlh0wDvC0AxW5qbbMgnHbTHYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1J9y212dqSGtYWxz6O1f0Q8KOO0fCtJhppFDjEF1vIJysVYQ3wDGv0k3yd49aECzUtsk/E/K29X1O2WYqUuTUEoulweOFStxlZxSUhbuW1E+vNPrxoINiTwqlevdqE+5YfpagJmuKpbRdGu62J3kyPzmCgjlJhGESMCy4ab33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=LAF/ZZiv; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="LAF/ZZiv"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 8072D1F947;
	Tue, 18 Aug 2026 10:44:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1787042665;
	bh=/e73eaTIi7TTVReuWeD/6+Vg4n7GB7D1lo6JM7pV8nk=; h=From:To:Subject;
	b=LAF/ZZive/MFJUSiZPNpDt6vMlF7ArjRMm4x4xjdbH6AfisqYVrO3iwkrRXgXYRI8
	 qyPY006yxL1NZIydaUaiLzcEPKH9pKIB7e6b1MNPI3sAPCM3v6+DOXciSEms++UUJB
	 R45He/hu6Yq3fqRc+jAJqIhV0gyyRwPne6pMnTl5JtEWKW8PaBfKMAFnZD71DM+W3S
	 tjOGGp1FOWDyLaZlb/JWK3nFgRpgmHMrivuUwjsfNXjpMkFBAGBARCixcKD56E1eej
	 Uh+jBtw2sC24wNJeVuDYoVhtW+Y4OkTaGJFTIk57NnOCYG1bS+44y0iHXiH/FcNGHC
	 25NPeWPnrR2Kg==
Date: Tue, 18 Aug 2026 10:44:20 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
Message-ID: <20260818084420.GA119228@francesco-nb>
References: <20260817132535.394764707@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>

On Mon, Aug 17, 2026 at 03:31:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
