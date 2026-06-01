Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E6399340
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 10:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780311111; cv=none; b=m4ncZ+7lPAJ8LIuwI02oomlvTT0Wnk6LbqLFrqNaPfUjyyvBRkoqRADIvxFREM1ISujoHMKT9F9BKM5oA2U8sjjYRrPfLIgH0OY14mxbcDbLuIz9h7IwGWNyLirKcXQmaYvQTyTszMDCQZDJ14HZZp4smetEA+oTZse9nu3J2kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780311111; c=relaxed/simple;
	bh=g44Vp41crQLgBV+gRSrG5kPJBSc86/jzdoF8/r4a9aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNcf7kHUBXjSya6O4ShtfpMw8dKj7FEztuGR4+WU2VNkcKnZeAf5q2fSn4673v/S0myCPy3E9rsza+WY06ngmzrUyVtX/nCuKjRfEJU/Q3q03acZzY4UGFT7mZLet3Q6OzjMnTEEtWmAzTVCkMfzSEkAnkWFxkV3lGcsAwVZUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=GfumuQwI; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="GfumuQwI"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id AAB0A1F83E;
	Mon,  1 Jun 2026 12:51:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1780311099;
	bh=Fg0tOnXDP6T8KyebYHsfQ0MjODltjccWbijJ3O9GbG8=; h=From:To:Subject;
	b=GfumuQwIjmQ69J+OnQxOVbytjWGN9cDTQGXDe4YRI6Xhz5nRcZxSsjhEu1v6Pg1Le
	 jn4BIk7wrdYm2cPKYp+hfgOWCCp1ng9ycTltwh7n27uPAbV4psfFPsmL7Wf8ZLwvPj
	 1JMozpi5qO84VKlPIGwIfBpfOit8Asd5Y7NcGZzU3KfkED4cc0DX6DoesBAh0E80qW
	 V/lDRais13ycH58eD3nR/NkPMa5cRpsHLkMfFEyCKZg4HpbdGYTORxg0bgEA/c2OM2
	 Y4rzQmnzN1YT3ueigOcxus+jaKd0kCtDMZ5jC29a9bw1AyH6MH6s77QHaAkzQd3DNh
	 HlYbQ58B6xnEg==
Date: Mon, 1 Jun 2026 12:51:34 +0200
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
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
Message-ID: <20260601105121.GA68974@francesco-nb>
References: <20260530160300.485627683@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>

On Sat, May 30, 2026 at 05:52:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

