Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28B6364CD
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 03:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718855065; cv=none; b=uxZrjVLpFiKz4bSwjUq35lvD2uKr138l8Om2p5ohfaUjyMN2NbmpQmVhdMIeKZIIXCEg0sINQwS2VEnz0clfkU7gbj/0tsAGmiBoekpCcMZCDmhav2DHLjWW1PCiT9mxWO05fTaxUzX6+vHjtEbRY/TH+fYeEvHTPAhVhsFiYg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718855065; c=relaxed/simple;
	bh=9gees/28Vu7mgwbTbdKohRsqE52TZ9tMVHzwIx12+l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGWPoNJLlAJ2iX82rVpEXtD71VcTtTgSBT3TRBYWlrizvZBtIat9hMF8fiBQTzw5TQFlTf8SuXrHawlNLy0SaQyIrtNUaQtka2cU8HWopDeL3Hcx8iGinjKtzAUiYwGZD+dO96oNBiwshB5Qy17cDw833ekK0Us2QsQVBjjTVd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eRJ/9hl9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eRJ/9hl9"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 6E86620B7004; Wed, 19 Jun 2024 20:44:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E86620B7004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1718855064;
	bh=y7y18XH1rZAr/kp15qzpLBujWTjaFApSVLHk/H8VxaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eRJ/9hl9Zj5TLRsjnb3v4ai1rcoLK8Pfebix309tbGSWe5PD9MKQ3ASWVp/T247NY
	 wp09QGGZyr+3UvUf8RwhKZQWHD/fF6CCmksO6BjgmJHP5mOAoKz2tTvUSCYQVEufSd
	 yLx1heZYcAhSLnmPPidsUWr+393IgAZt5Qh4VIN0=
Date: Wed, 19 Jun 2024 20:44:24 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
Message-ID: <20240620034424.GC2251@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240619125606.345939659@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jun 19, 2024 at 02:52:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
