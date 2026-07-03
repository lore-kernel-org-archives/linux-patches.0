Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5DE36A370
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783064449; cv=none; b=HUhDhAYTxyZ3jZAWLir/RW3SM/cLQMAWdeTrgITd0d0gh+CF+MnOyxgLmVseSypUATAP2icUNNfsTf2EH14X59X8tgbqKmfg8yUWMtTdo6HdXYF1JcewU5NQ667rDCsHxAC+XH/3vr6veuvRonwrOf2VO4hSSDt1ahfn2LIehKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783064449; c=relaxed/simple;
	bh=anre907y3anbzl1WB+NaEEFlz2prJWhsJfz0vWEo2+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILntO43OkszeoBpqis/BSitU/d338yTTQ/A6gCNdQtSlw2UCg03BaQK6LCGT0JH4JEAba99byHTxgQ3y1NIAtuToPYNQzUA4/H6LpN38Q0cLZiHg+wKW80c7J6ZEAtBQI9X2h/zxbBqAbO2lgr/ZyKd27RGMxDGZn2ZQAh64m4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=YerS7p85; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="YerS7p85"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 6E7711FF57;
	Fri,  3 Jul 2026 09:40:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1783064446;
	bh=lBWzn2CLQk1Tuc57BZ2ycuNNOxegoX9B0hhclUQbyQk=; h=From:To:Subject;
	b=YerS7p856vG/0MI5VDvnUaksj3LIxmuDNjK+oL5qieeVhP6GyLBCsfX9C3KRMnyDi
	 WDu298eTS5nEBqFByltPaXW2yoV0oAJfaCa6NlolbIKo/DVvo1ipAzp7Xp2OsDAKEm
	 F4wOvcFbs/jOxAQMtJeX6xO1wWSPnAxc1XEUDNwEYkLhFQiqZtXLn3cgL7vtZ6dOfm
	 l2OY53UASwlFm76Tfon+qIqrKpzXrOo7rY+LtF8qSdM6fp4QYTTERDmk8BL9xH92J+
	 RIfjGl481hkEnVpfhXaFLVFf4Etk5RwcNSczNoPq2CVNwHYDzE1Tfbd6kiFdPmA4Vg
	 XtIsttxQW9T9Q==
Date: Fri, 3 Jul 2026 09:40:43 +0200
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
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Message-ID: <20260703074043.GB305710@francesco-nb>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

