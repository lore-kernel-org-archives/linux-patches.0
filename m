Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4FF1D9A54
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776169976; cv=none; b=Kzur8lXXf8e3lGXyFChu6kGfrshhbKkd+YM9aG2wIH3Ur6npZOto7Uk9Oam43MHBLg0tbj2vbET5wUYadqcFWILbbBpT2TnVwLbanynEz3vP7L7jTcyiZNx/ZG8U+uR0Q9r6r43dAqmKo+NcOgobebK4qSjIoFtLAeq6bnv7TPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776169976; c=relaxed/simple;
	bh=70CHZuxqvSoEN/DpXT5hqJ4dw1WphbNR+ns2KFol+qA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMHyuzLSCiV7NFPewfhSNj5Gb4LaIBjwhakPpLx1SogtPK88Dm4/K8y98eo52nwhUdNpMAaQmFksHNf6+iCjhTzmkSWa0488rcQabbOznsktE6K9nyqHpBleY2ROmScg9d0aZaJOiP1Q5BgLMUmcpyoUBAKAdPa23eXPJR5raHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=F+ithf52; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="F+ithf52"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 0B4361FAC3;
	Tue, 14 Apr 2026 14:32:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1776169973;
	bh=nO5zlGw/3Qf2uNpDUhNMbY/vuauI2Ub6iNZUAWT6aIc=; h=From:To:Subject;
	b=F+ithf52OVE3GQKjYnW0AG5t3IDdtqqhPDnyGa9K7qtppsLXxe1K4VdTcq13r/Trl
	 xlr1RD65TSCjE/cXyWz/zXs8dDsD5OgCCHpIxQfldtV6CWKu78p8BDDVJFUz2m5V8r
	 hjgEp1mwZqTmelxYjLRQ71pBRwZS03IFHtopcu76RGCjFrLL+S5v5TA0if5KYGjwT0
	 KpscXWzBnW2HCM1wkg5flG2NuCguOrrIXHllXhqbzCIMq9xkNL9cagMLo45NUdO7Rs
	 aQ/5TBLRLK670GFmYYGPc40R5o/AUo7YHKZCckyvDodNt5fhSvpnrBD91ClOf5Eq8b
	 07EoBHekG1w+Q==
Date: Tue, 14 Apr 2026 14:32:48 +0200
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
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Message-ID: <20260414123248.GA89083@francesco-nb>
References: <20260413155728.181580293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>

On Mon, Apr 13, 2026 at 05:59:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

