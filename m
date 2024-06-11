Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F8C29CEB
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 04:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718078480; cv=none; b=GxLG2HZUEFJKP99//ePGX+23L+BXXt0PsvWzkGWOIKpK8cOMQC6shI2OUjYR0h3zEEuPGuK/d/vzXGIBYJcP9bvUDCIGN0YyVZ585eXJrekvk3kmdMZ7QkwxMJ9KM2bpa+fkiQXau6rJcZYAFXdFKJw0JeBe4Gu8mCsy2btW45c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718078480; c=relaxed/simple;
	bh=AaSqMjoj60S762OcIgcMXnZBI+qekvUltYclCZlyiKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjGLZ6XaDWzu64/a4v5tclEfm2aspTovaFkx9Mb1OaWXHYgg0Bz1G1PdJUP3xs+xKSLxwZAJHVbh9eLGt/lP5jsNOFAUFmpz2e5W4dQJ3Cf8TxKRpz4xEAYWLZNixDEJ4mEr111bMTwXn5IDYQkerBfj3XbMgFaKs4WyVCW/jGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Mzl44dRZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Mzl44dRZ"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id EC86C20693F6; Mon, 10 Jun 2024 21:01:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC86C20693F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1718078478;
	bh=agBjvK32Gx0wJAK/k9baMYQn9JLj0aO6IJt0m2mxHxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mzl44dRZnsNljAYtxiqgeLRPA+sxZYTLx5imrlR6usxLc4J3xXwETvJIhkDxaQFrL
	 xRqzTaM/7pBWgZdc/8fQMmxFOaejesNmL9nsh3bbwejrVSB7u7pGunBRIN2MWzdpL+
	 s3/aPd8+etdG45BfsN1I1/VDFUdpPlHzgjDlUbn8=
Date: Mon, 10 Jun 2024 21:01:18 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <20240611040118.GB27792@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240609113903.732882729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sun, Jun 09, 2024 at 01:41:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
