Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AFF33A70E
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 07:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784272305; cv=none; b=G4lDJrRDoOE3MWiqxosbHeJ7OnxwR54yTShpHOwt6+b/WvTO25RLvlUFQdW/WW7GXzpk3Amg0DZTFto7OxCez//wE41HZZSCbD/RHOrg+C2Mj6ZWsxoEKhs+6XHKINKl+DEwBmJxwBeHIY+tb6Wh8XAEoTFd+lxy2u9pYzx/iV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784272305; c=relaxed/simple;
	bh=zdYEFdYh5Vi5p0/dHgLRHxYa1qzgURg7xqg7EQy4tLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TuuRJA1FYRV/y7n4MjN2ucdLnAO4w4w08Pm9XQFl1lUWuHXqMZgF8/pYxRcvamji69uTyjYQwh9KSNvkurjcs3GxUX2pslB+mETfuimyt5Sfq12qA0QXrpp6EXhX5tiXZANDBfhsuSjf7SEvQUmhgtxcnj5oegjjCI6nzlWVGHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=rzx6KkfV; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="rzx6KkfV"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id A269E1FC90;
	Fri, 17 Jul 2026 09:11:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784272301;
	bh=vMFc0iOErG2mFY0W6+KC9yd275wehQJaR1fY2C6U4PA=; h=From:To:Subject;
	b=rzx6KkfVCcHeiQQmfbGtDb6yoWc96Nbz5Z1YU93uwxeXInl+fiMn1KCLVPau0fO3z
	 i3z5Ex/0XtlI1EDwCUiKUuaiN4f0gYtVqKCdoGJ1lcY5AqG65H4dAXq6apiBFu/7j0
	 7zTxfFhxSAyXLVu/rhGvw1Sg8Ulck1RWsg96ipDIzILL+YZ6nsnuSnl5dkdOqFSdNQ
	 13GR4i5tqCEA3BWcOprnU5g5/oMCb2Hhilbm2CXLH+zqN6id4Yy/V5cl3M3SGxLAqx
	 i7/6A+9gXU755btz01kgGfFLGVrjtagRKqOUsnJmlOGzi9ItKhgeENxQdo1H3f+bzc
	 OE6xIWE8jXbPg==
Date: Fri, 17 Jul 2026 09:11:36 +0200
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
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
Message-ID: <20260717071136.GA373902@francesco-nb>
References: <20260716133033.287196923@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>

On Thu, Jul 16, 2026 at 03:28:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
