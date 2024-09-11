Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381FE2F860;
	Wed, 11 Sep 2024 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059806; cv=none; b=JDyQihsyx8SFHyxRGLicbnBgbuyDHBHfbGSE/bdejO+LFx4N6VAKqlJmafS+klmZoea2NXZir0ePe8rq/4YYVzPooXfS4MbbcEr7V/i6iuDzJoPzBD13/thPf4O7fkP0eSih8H95FICoUd77dXevdGSkpL2EmE9rBcu+ECUnCDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059806; c=relaxed/simple;
	bh=2pCs1t6UJrwp6f9PYdU/Sx+jCvACRP7QBjm89RH4+ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oo5ng2+GI7VeJE+irfhNrr4XrKh6fMv20FFBPLjM0jvfEliQETsHgqAXJy7c8jGzg5HWEosRh5E+kKgacD3qfn7YIheinHKmDQz0fvDDgrc3ohgtRkapC/UOxu/YThUsWpQei2Pn60lBoSW64LvX5iJOrZS1IWshdBxt4N6Op/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2ruDyVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2ruDyVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658AEC4CEC5;
	Wed, 11 Sep 2024 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726059806;
	bh=2pCs1t6UJrwp6f9PYdU/Sx+jCvACRP7QBjm89RH4+ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J2ruDyVu1GUpuyOMUMAgWqaEM6YQN2wn5w/tDqF3SWoQjjZQnun0b5WT4KMzbmc4p
	 qdwp+n766msXhmWZxunu7LpC1kGLR0xzPXTVKrGY+lB+X7qhUhP/T5wLLX6t02o9t3
	 d8x6inRDWHrJCEe5IM3WksvsMXHMaSXl6HHgZvSM=
Date: Wed, 11 Sep 2024 15:03:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
Message-ID: <2024091116-anemia-tweezers-2fab@gregkh>
References: <20240901160809.752718937@linuxfoundation.org>
 <092aa55c-0538-41e5-8ed0-d0a96b06f32e@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <092aa55c-0538-41e5-8ed0-d0a96b06f32e@roeck-us.net>

On Thu, Sep 05, 2024 at 10:52:05AM -0700, Guenter Roeck wrote:
> On 9/1/24 09:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.283 release.
> > There are 134 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> > 
> [ ... ]
> 
> > Helge Deller <deller@gmx.de>
> >      parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367
> > 
> 
> irq_enter_rcu() does not exist in v5.4.y and v4.19.y, resulting in the following
> build errors in v4.19.y and v5.4.y.
> 
> Building parisc:allnoconfig ... failed
> --------------
> Error log:
> arch/parisc/kernel/irq.c: In function 'do_cpu_irq_mask':
> arch/parisc/kernel/irq.c:523:9: error: implicit declaration of function 'irq_enter_rcu'; did you mean 'irq_enter'? [-Werror=implicit-function-declaration]
>   523 |         irq_enter_rcu();
>       |         ^~~~~~~~~~~~~
>       |         irq_enter
> arch/parisc/kernel/irq.c:558:9: error: implicit declaration of function 'irq_exit_rcu'; did you mean 'irq_exit'? [-Werror=implicit-function-declaration]
>   558 |         irq_exit_rcu();
>       |         ^~~~~~~~~~~~
>       |         irq_exit
> 

Now fixed, sorry for the delay.

greg k-h
