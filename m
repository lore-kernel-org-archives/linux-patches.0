Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3EF17B4FE
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027927; cv=none; b=px5tOk/HKsWQ+Lx4SiB3DojVG5zm6fPQMPNumDqmRgq2aLYHGu71pQ/V0WfcZbqw9khum35KU8+lsXgoXzv3015CkEs2rHMVOgryhVeNTRB0RcH+g2t3pOLEiDp4YUHIUeVqPsH7QyofaPZNRoM2NEbW15a65rNeO5VNwmSBuW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027927; c=relaxed/simple;
	bh=xe58BYhlQRY4+ZFWvGAOSgxsDrq6xhXzCU2KaknhUmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKC9eVSm65C982ZuTQQGS5CUV+JGnDu5//PeS/TOxNTI6rKNk0pNQe3MB8oAeDLL2KCCZ8xnPYPag9G8Qwyw6qnnX3/7denLkmyf2uM4/oAGokJLDN5w/PIcUiX09lu5jkClF0jGiz6+jQ6TUH34pOkT7rm4y10t+1xWib3bYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dboGfA+A; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dboGfA+A"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5FFCB20B7004; Wed,  3 Jul 2024 10:32:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5FFCB20B7004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1720027925;
	bh=abcwbKHqrkUhEli7DCG/Z05b6pUY4QS8Za7h2POXosw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dboGfA+AdK2mU1MihQIAAsx0M7igx3NlWGJrA4MfUXvGlHjNblpJU6Kf2jaysCyAK
	 xaSwBD9NT+Y0nKUQF+Juz5YLJBucHFlHMHUdJet6ca7g7O2p3jQfa/lW4BKQkW4w83
	 E/7TEHgOA/+L9hbFeBrrFlaxlokjmOYVCfQFGFzk=
Date: Wed, 3 Jul 2024 10:32:05 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Message-ID: <20240703173205.GC11716@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240702170243.963426416@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 02, 2024 at 07:00:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
