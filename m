Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD7CFC19;
	Sun,  9 Jun 2024 11:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717931807; cv=none; b=OSXLE/dEcdjoMe4c3ufTBZkHpTS8DRPcrPd3L2DRtMq5HyVKasGeI1oi6MdrlqY344jm52na+FZizWaPRghrWHqthQt0JUt8mULPptzAA65QPqanpx1TsLkDi21GVIIiYRaHzKpCegjIOsavWVnetMD9C85x4Mg/jmEGMUQVJ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717931807; c=relaxed/simple;
	bh=VIgqAzLxQsYvHKlEzX96+807lQ8/RCG6XretGBT644o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVuC+c2jf8iMH19JMTMtfbkISRMLa0kuMKdH7bqPwFK90HvVfSnmLmxNmOUsUCL5qKS/BEBlcP/PetXV6k7Ds2EkQ3nU/ygKofPGKGzNxBqDihfV9TYhlwgXHzUwcFMCPNga908/W5VVQX/R0ek2UWRVeH6S27KKmQaaCKcmJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rawXpDSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rawXpDSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7563C2BD10;
	Sun,  9 Jun 2024 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717931806;
	bh=VIgqAzLxQsYvHKlEzX96+807lQ8/RCG6XretGBT644o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rawXpDShBMO25pW6UDdI7TICZcnx+ZvvrvdX+TbJI4vueHjTE6/OKiglwIbQJwple
	 Hvrez3bTJQskBx7Tzi0S0RFCNvD5AffVh+6wtLYcO7nN5Riww1aXd8lrplSuknC1ia
	 VkWTC207VKn7lH6TEVyqiAin4pE12M9QrOuqIuKg=
Date: Sun, 9 Jun 2024 13:16:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Message-ID: <2024060937-unlighted-foyer-1794@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240607152504.4D97.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607152504.4D97.409509F4@e16-tech.com>

On Fri, Jun 07, 2024 at 03:25:06PM +0800, Wang Yugui wrote:
> Hi,
> 
> > This is the start of the stable review cycle for the 6.6.33 release.
> > There are 744 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> 
> To build the 6.6.33-rc1 successfully on x86_64, we need the following 2 patches.
> 
> 8a55c1e2c9e1 perf util: Add a function for replacing characters in a string
> f6ff1c760431 perf evlist: Add perf_evlist__go_system_wide() helper

Both now queued up, thanks!

greg k-h
