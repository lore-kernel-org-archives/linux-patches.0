Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8214FFC18
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459176; cv=none; b=KvmpedRj5F069Nr8FSowPHbfpDlhmdonVos9vdvv74qgku21rT0bmjSQ82ruiX8Hl98XSS7s0hjscrxs5II4H1sfYDW1xzwOgZ2d4EO3pH6BLCguEWa8QKkdQIIbqMhjDZfaCBDWNpY+50RyT7/mlcBh8mcbSt9AcU88uP2YawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459176; c=relaxed/simple;
	bh=i6++wE0nJcsEJNTURHFwm9uOlQcbLqb3ZPmL8c3OkKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFae93aQcqcRxrVMfnmHrdAjNzyj4/TIvuMqrTTFvxG+zRO4rGK0D81QVsMcFUrkF4qjHDe9puBGpWxCHkVTCN4COI3avBsG2X0W8Dcow1CjTwCM1v6MZB6RYXvbRtVVNduMEhDY8S+51Qtxo5cC0MyKTL73d5cBiHA2vIK6U34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lpZLNEtJ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lpZLNEtJ"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 0F94220B7009; Wed, 26 Jun 2024 20:32:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0F94220B7009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1719459175;
	bh=pATsx52MKLGtp/jP76d+irvB+9pqjK29oqzNFhbgVuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lpZLNEtJtyoOPSXx6CmeYJ2hlYAilbyYGUM6S7iGw4krNuc8ey9GtfXdBaOpmLNrg
	 8U5AmOQNorI0v9YJqQELDyTb5heq3sCyLUBQLPeDiZ+jBH2xEFAKGLFf4Z8AYkfhkH
	 V4VnUmiC4YlqRB33ms1Kw5tB2MGBUC/sKi+RsCXI=
Date: Wed, 26 Jun 2024 20:32:55 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
Message-ID: <20240627033254.GA6902@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240625085525.931079317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jun 25, 2024 at 11:32:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
