Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE93E8831
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 01:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708651451; cv=none; b=bOhilS/puRVVfO8GF8csBugpjf4Yj6M6nApZw01gjz9J9B61DR27mXoLoFoGwfacclDX/c1tCBqJOZJipmQ+DgwxHMXRAse9SW9EwFGDRA7GQkBOpsetWIFXULpQB0si3ru4/GQkLI4KkUyZdtPSLJU6xBSNEUEs8tALjKw5mnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708651451; c=relaxed/simple;
	bh=3MoPtN7JdaxGrimtYMrgEPgi6niLas8bkHJNecu7m94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcOhpxXUtDpFrdmZ/KzN7PuIo+w3Y7awSaKdpq4JaHr9QqeMG/n0VA1vjMMCbMgGqDWh/LpTz5BZv3hnFCLUiNmSbPxEArdKAlwtrKkO7fdoLCE70QefauoECwlaZAsh1Try1aJ6VeYR7mFa8nzgCOQTm7wo3zXJ2lXgNJ8K1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=OPr1Edoe; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="OPr1Edoe"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 8246620B74C0; Thu, 22 Feb 2024 17:24:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8246620B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1708651449;
	bh=IHL5IE7P6nMLQjvh3bPnO4sgebkrF8EU19ixUt77GEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPr1EdoeQPR6R682wreO50KgIQqYLPhJmb4QJrpugQu9CgB+0NT5wEaFfI5eJcb3D
	 HO3FkJi6MJMlIUrg5Ri9g6X2RnnXK22cb/KvDfEpdqBGzyJZGpbnvIeuKVehmWSA3z
	 1iWm+luRA159JgG0ZUoBuemeSfB1BPODif61WRl0=
Date: Thu, 22 Feb 2024 17:24:09 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/338] 6.6.18-rc2 review
Message-ID: <20240223012409.GB20295@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240221125953.770767246@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221125953.770767246@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Feb 21, 2024 at 02:01:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
