Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB0821D3E9;
	Wed,  9 Jul 2025 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752088366; cv=none; b=FApRkryTfTJ+srZBr1YH9VZlTByBVA1R0nkCM1qzmgHtP6gFJV69yUwcgvt90lH1zpFr0P39HPU1+QLizpw7JThLYLXSB6XtsGcz10FctTam5yEsMwVOKBS7E1k7TDjIM4EO5q4+F+7U1JobTZ3VOf11HLSfvxSmJu38tyJt26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752088366; c=relaxed/simple;
	bh=Ki4ivrySu7ePZcyaS1IlHL9xvLCWTSoo7PhYCuddbHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlSnCeoC299gUWZHYW68VifgyiVkfj7Hvzq1uu7VlG8ZpnxtfXQoiAG5zYC2X5TJh23Z6ReqN9JrGCfbGvZhbvodDEWm/P4U/+DpQ1VznYhBE1WlxyS0F7cacw8WIeWWHOsz1SS9cO98zCmwkjM5x6E34o9rXHwaq0vKx89oOIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT1mJSoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT1mJSoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B00C4CEEF;
	Wed,  9 Jul 2025 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752088366;
	bh=Ki4ivrySu7ePZcyaS1IlHL9xvLCWTSoo7PhYCuddbHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mT1mJSoRWlB7Khl9nr+g9L6nkLRaQ+55gxia1uhoHhdegtgOAQek3enKuKhDxRPuy
	 jz2XwALJjF2hOH0Zon16+/0xj0gMzp10uvzGJU6MG2Wf577GBdnBriLWvJL3lLFinF
	 0LmzIDSU0McnRLqQT1w/fuQ1v9Ph2NAAYYtjb/ac=
Date: Wed, 9 Jul 2025 21:12:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian Heusel <christian@heusel.eu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux@frame.work
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Message-ID: <2025070909-outmatch-malt-f9b7@gregkh>
References: <20250708162236.549307806@linuxfoundation.org>
 <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>

On Wed, Jul 09, 2025 at 07:19:32PM +0200, Christian Heusel wrote:
> On 25/07/08 06:20PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.6 release.
> > There are 178 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> > Anything received after that time might be too late.
> 
> Hey Greg,
> 
> on the Framework Desktop I'm getting a new regression / error message
> within dmesg on 6.15.6-rc1 which was not present in previous versions of
> the stable kernel series:
> 
>     $ journalctl -b-1 --dmesg | grep "PPM init"
>     Jul 09 14:48:44 arch-external kernel: ucsi_acpi USBC000:00: error -ETIMEDOUT: PPM init failed

Is this also on 6.16-rc4?

And maybe if my Framework Desktop would ever get shipped to me, I could
have debugged this ahead of time :)

Anyway, how about a 'git bisect'?

thanks,

greg k-h
