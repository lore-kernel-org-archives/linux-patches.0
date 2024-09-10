Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323A21A3BB8
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.9.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998266; cv=none; b=l+aEKiTATb9ZDOLH0qaM7aZ/P/K6wXkNqwCWKarF9a8BgT6Bv4d6Xxm02HeL5Rcfam3SJ857Hi0QYq58jgPUHo37YrEI+BI0drfptBQIrJfkcbnPIHHXynZoNx/w90Ng0DU6bg8gcpbWwOTqxRd13U8jXkgbX6lT7vjnjDI25yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998266; c=relaxed/simple;
	bh=qRYAyvS8Wm7naLxPmEiATvWjTA6VyuUIP3PtMk+5GKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MD9fvvuI9Vae851VTK9NmaiX27cW0lBliJiCuu3WXpo7QtgjUq6LD9s9+1QSBsbeYA46vvKYcYac8ANw56x60c/eDTQCszKpwTPwPq8vY8iFv0UQ62Uevtll0fZ2D0iz+Wh99Hasuoxiua7KujdA+mESCdclIcJcE3Tf4lHwxu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=manchmal.in-ulm.de; spf=pass smtp.mailfrom=manchmal.in-ulm.de; arc=none smtp.client-ip=217.10.9.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=manchmal.in-ulm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manchmal.in-ulm.de
Date: Tue, 10 Sep 2024 21:50:22 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
Message-ID: <1725997627@msgid.manchmal.in-ulm.de>
References: <20240910092622.245959861@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>

Greg Kroah-Hartman wrote...

> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Can confirm again this ends the issues on parisc, thanks to:

> Helge Deller <deller@gmx.de>
>     parisc: Delay write-protection until mark_rodata_ro() call

Kind regards,

    Christoph (who would like to do more -rc testing, but the time ...)

