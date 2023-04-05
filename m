Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2427FD524
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 23:47:11 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id B3420210DEF1; Wed,  5 Apr 2023 16:47:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3420210DEF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1680738430;
	bh=yNAS5erRHhc/EFovP6vHaxgN265p2mfiB1fFyCTB5Ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8wtK9UPGKsH/hQJPEblp8Q6kuursJLm1edttlRDGEHQKBvD9GGnufAYR3CfXxm2j
	 2oMf29rR+yni6ErUPADLi/D+JxmFvZ9qU37T5InL8qmMhswYu0CKJS1AAgJCglkCTp
	 mZ22BaHALA/7hjZldRK4mkGR6lXf38c10Eo+8sDY=
Date: Wed, 5 Apr 2023 16:47:10 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <20230405234710.GB5053@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230405100309.298748790@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
