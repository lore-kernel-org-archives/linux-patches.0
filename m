Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F601F934
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 23:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BjMg2ldX"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 85BE220ACEE5; Wed,  3 Jan 2024 15:35:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 85BE220ACEE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704324930;
	bh=1C1AW6/XZVDp8rpc10Ul2I6b6XVlEoyKHUbERHZgaGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BjMg2ldXDfXoJ/d30jQgiRODZZVZ7PqJjYWQJPmgnoUs6j3EO/ubDgkeFL76m/L7+
	 EtnXVItunFG/gWUBoEZ/xGZQknwHcZYA/GP/uk5Ihv0Vlk+fKBJimFxYpl/cTN4SG8
	 RKe92/BIOCZKAwNHVg5vW8IO5SIrIHvjkt9zk8f8=
Date: Wed, 3 Jan 2024 15:35:30 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Message-ID: <20240103233530.GA858@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240103164834.970234661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jan 03, 2024 at 05:55:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>  
