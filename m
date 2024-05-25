Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AF810E6
	for <patches@lists.linux.dev>; Sat, 25 May 2024 00:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716598722; cv=none; b=TyE5WrCLt1l9P7ToPMFhmW8XUIWAzgmm32YFpHOyFch6O7FQTjXHMwnzPPdVPEuGDTiD/0WMknUT6WxD0U1KYVMIXVbnv1IF+Ot7OOWS4kJJuuKVi2V+H5udQs74vaQdoVCFZeLfLo4eMkAcTg5XoJbxT0+74Y/RBPyzzLJXzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716598722; c=relaxed/simple;
	bh=TAVYFG/7qC4PaAyxrKjPduiuv3yzep1/HvrskECTPe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8PkNrtPuzTSWlSJFeDmV/OdavOsS0sA42V7DZz8gFzOTl0secoOgqDHvws4yZ8VOA7NcpPp6ABO4DSUygjPFQqZa4cWvV80KOVEHSmfjc7PquUb8nXvSR7KWYGtClmli++CLq9udYIxFucFfN+aKr/Ub1TfySsnzT2v8xMKBxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=I9bOaOXI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="I9bOaOXI"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id A06BB2067B4F; Fri, 24 May 2024 17:58:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A06BB2067B4F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1716598720;
	bh=kZ+0BfgRet+9C4+ZUOYzdcnkQSyXXnCVhK0fpJBHWjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I9bOaOXII6DfZU4l+Fsu56dcOiQW+a0Kp+4PnY0Q1K6ob7y2yl66EZl+9JE6SFwIu
	 k7A0lOM0Li3UEUfWk/+EgpaCs3hTXICn79LMEnnVqOrebFse+pnHyYZL/+JQQxIQoC
	 4FbSK+MOg8UI9Msj8DSqXhnxn5juoK01sRO7fu1M=
Date: Fri, 24 May 2024 17:58:40 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Message-ID: <20240525005840.GA22512@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240523130327.956341021@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, May 23, 2024 at 03:12:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
