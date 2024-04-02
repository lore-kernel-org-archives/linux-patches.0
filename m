Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22882E55F
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 00:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712016883; cv=none; b=urhndG2ErG40/XxDftBfINIJaPlSo+hTgrmEqMR/gwZTDxEpnbFYZj3Y1UhiU2mz7AC0u2xsZwjrRCM/QhXvxr4HK1xSK9rHLwxxRLxzXD4CSqh8kz4DLPQ7tmTHdtENr0U7amcoIRsDxHz8Kto/d4ZKItJPrsnuTOhzOEIhpGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712016883; c=relaxed/simple;
	bh=75z6RW/x3iv8sUl4WoaZA2ZmCKVdAJYUNP/KYpqDC4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XC9YPBGFCd4W9+0jBgs1OvvYJucPe8KKHRE55JbgJrN/dI3Y0MMKZoanLJ6DyOoRCxcCpx+j3eGP9IUqSpDCh23HpnOCCchSIM9e98fchJwzi8ByMum1BE0gxeuDO9VU4BH0m3rt/B4dfCBG1nxcNvOrfYVPjxq/xGAlCwI7Tpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ll8/xyCK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ll8/xyCK"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id A32BA2098E10; Mon,  1 Apr 2024 17:14:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A32BA2098E10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712016881;
	bh=Y8KWaFCMc3oqrut7Loa5lNopzeBg8rASISYbJgbRU4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ll8/xyCKXbHPOw0pGGThPIACR4rQmlQwTl06fhn7x32AjrfTZCZjnylq7L3u/qpwC
	 QbJoREB2M1PYiREUMKoLYEhhVXMoIdXuZgbuC0zjJOs8IjI9ujuTPtfqn8YZ2xco19
	 ToX0zFKwYD1Blz+69yCtGM+5lmlURQTqwwRfv1rM=
Date: Mon, 1 Apr 2024 17:14:41 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/272] 6.1.84-rc1 review
Message-ID: <20240402001441.GA5026@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240401152530.237785232@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Apr 01, 2024 at 05:43:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.84 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
