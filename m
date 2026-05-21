Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D9232AAC6
	for <patches@lists.linux.dev>; Thu, 21 May 2026 05:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779340644; cv=none; b=EfJ5s8mGidzTTTFPCVpqwEXvhA0yFdOPaJPynvxxw1I/iPJplK38CXJTQLimXxz5Mj/HrIM24vTNmOErGmKnWPL3Zj9E1eC+ApjdLjxIo3/tXIpZZpXuh/n1GX3gTW7LPIg1kozGTr32NxM9V+CbsDkx4zcpPbJ4LLAw7LDI/vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779340644; c=relaxed/simple;
	bh=KWypq1wuWNfbjetIGHZ2YvJVN2wGEZn1av2yZzj9wZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aB4mpZ9TrbKzMjghb9pmf7MT3jkVYqN5ammJF5yum2a0b9xOW5bDGftn3THPA18z3FW+ZZL3tTiFBxlacAkE97I2Ipw2qKQGqo3kAZdJdGYCpo/poxOVjlRiCC9ykRkhHO0wwFFr8vD6uST2v+K1DMl9DQGGVsRq1pmV1YavdTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=PAaIZt5X; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="PAaIZt5X"
Received: from francesco-nb (93-38-208-55.ip72.fastwebnet.it [93.38.208.55])
	by mail11.truemail.it (Postfix) with ESMTPA id D916325BEB;
	Thu, 21 May 2026 07:17:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1779340641;
	bh=DwcnHoMkD13GrbOEpK6d3ihXGUmmXhx1JERPoKzcSHQ=; h=From:To:Subject;
	b=PAaIZt5XienBWURRwcwBnUPBNMWF7o+i21o94xq+73j9lEQvaXOCDDXjg9ElKubgC
	 dK3I+lKGavka5mzYHZkWf4uCcI/HWA+zCA/HBo8UWM2wct8npxYdBaAFF/JbuRd6oB
	 UbDMKFjuEROcbzhoPr9s/11896pOYx04OHnpJ1T8pU3n/cfY5laB+2105/7GdogGdS
	 9ByLcKDOMLVgw2v4fq/M5hfbmG0HYJuYspBhbmWrZxhGZTTa+D/+L7FxLkaMmFA9ar
	 +u0YjbbOeKah6xo2SIK3BBIeGgZAf8TGf0gnnzCWwqyfUV7hFTbCkvOeJxrgi0BiXX
	 JcSk5cBnfceAg==
Date: Thu, 21 May 2026 07:17:18 +0200
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
Subject: Re: [PATCH 6.12 000/666] 6.12.91-rc1 review
Message-ID: <20260521051718.GB6866@francesco-nb>
References: <20260520162111.222830634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>

On Wed, May 20, 2026 at 06:13:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.91 release.
> There are 666 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

