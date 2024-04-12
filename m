Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A1F15217E
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 22:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712960559; cv=none; b=cq3z93XqOO0dUXWgt8sAEo1HYO/C0c1WAYWGXnhkYyf05TSoeGH8ZgE7IP0x00ZFdT9ENQXKpx2LF29KHhF+7f/Bu/HqXB4BGmdCoo3sYraTdziXjTZwyU2vYPJWS6qzGmvTvc7vTRVIwWiscKyHFktF+OS7u9w66HPTtsM+Kw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712960559; c=relaxed/simple;
	bh=1M+y6gLeoQPLO72sJFWCsMguWY5YIVvQhg5iVnCdj5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLouv8yTy5D2PvKmh4QUjHgDZ3398qBqdIPXDkQOriEBwhgisBddQAjGtbf8RoxFi3pxT9dz1Xa7p097cW/QN92uepQQ7nEyT6lh+hjaXj0iZTwxbruR6t4BEMHdpVGqVMulJmS/FriVTcqfj+IDAcShg7wEuftHVaxKwXS2NgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=sHIMpEO3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="sHIMpEO3"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id DA58820EBE36; Fri, 12 Apr 2024 15:22:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DA58820EBE36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712960556;
	bh=Kb789FONlm0VzcDAa25S1nl9g2pwKwpLDmu+Q9nLp2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sHIMpEO3Cb3V8BVWO5dZy9qDBydHnGh3F/r6PYrW0GYBmNGQomkBuSt+1uW8X6VuJ
	 QYgWBkG6gd2xJJEQXqWx8mjGgY749D84mF0mdsrwTnrkt7qJ6Q0IxMeExulPKEqviF
	 MHRDoRwFvNa9QeDrginNNC6MoWUIGWRol/NMsW14=
Date: Fri, 12 Apr 2024 15:22:36 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 00/57] 5.15.155-rc1 review
Message-ID: <20240412222236.GA6610@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240411095407.982258070@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Apr 11, 2024 at 11:57:08AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.155 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
