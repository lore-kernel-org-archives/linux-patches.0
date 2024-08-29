Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA771B0126;
	Thu, 29 Aug 2024 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941205; cv=none; b=qwXGnVntFynI1r2QyHtdT8jtP5cLlPDcyCuA4TY18j5jscfhkO5NNLbedoPWC/vXDpn0RbcVZGnp+LahF/dQXMgC5NGoevY/nwzOU/tal1SQKt2ZQCqEuyCEF/u7ekr/iC49R8AtIuimwxYOyLltMQVZ0q8W2F1CzZCkr72dltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941205; c=relaxed/simple;
	bh=9LIHWMYk6A2f3m6rYGEUezKh0BKXqU2up9GjjGnfSaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWe0PBbF5Cq8toQjSSkA9tiIJCrhOHyLYwJV/OMwgVXUrgrOpoZQzWslkOE/cc9rSryt6A7rU0DQOeTDUo5/EnmoRTfDj5hd/I/T7DTASz2ukFcKe+5Ph0P24CJYdq/bf2zpaz5FwoWEnScGRl0vVrIoX9Qx8JBvpC3bF3xXYP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSB9dCN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSB9dCN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7E4C4CEC1;
	Thu, 29 Aug 2024 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724941205;
	bh=9LIHWMYk6A2f3m6rYGEUezKh0BKXqU2up9GjjGnfSaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSB9dCN4V0hEq/R6bCXcvzOQcaiT29JpwIyHInnCqeaVAHQLbtbbCpNpRbLzoRo1u
	 mnNf/9Ht13R3U2vsiZfTzUCv2yAPinoIOzBoGgm77zIlcA7aaih+jiLS90DRHfJqqX
	 6ox/eiwgAenXj5y56bzLJAsNxhs5aBxX+3Z+kKKg=
Date: Thu, 29 Aug 2024 16:20:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Message-ID: <2024082941-outthink-rimless-f5aa@gregkh>
References: <20240827143843.399359062@linuxfoundation.org>
 <20240828223526.7E07.409509F4@e16-tech.com>
 <a1d51ba9-a76b-4356-ad1f-6554b3253e07@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d51ba9-a76b-4356-ad1f-6554b3253e07@intel.com>

On Wed, Aug 28, 2024 at 04:45:12PM +0200, Alexander Lobakin wrote:
> From: Wang Yugui <wangyugui@e16-tech.com>
> Date: Wed, 28 Aug 2024 22:35:27 +0800
> 
> > Hi,
> > 
> >> This is the start of the stable review cycle for the 6.6.48 release.
> >> There are 341 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> >> or in the git tree and branch at:
> >> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> >> and the diffstat can be found below.
> > 
> > We need a patch
> > 	upsteam:  0a04ff09bcc39e0044190ffe9f00f998f13647c
> > 	From: Alexander Lobakin <aleksander.lobakin@intel.com>
> > 	Subject: tools: move alignment-related macros to new <linux/align.h>
> > to fix the new build error.
> > 	tools/include/linux/bitmap.h: In function 'bitmap_zero':
> > 	tools/include/linux/bitmap.h:28:29: warning: implicit declaration of
> > 	function 'ALIGN' [-Wimplicit-function-declaration]
> >  #define bitmap_size(nbits) (ALIGN(nbits, BITS_PER_LONG) / BITS_PER_BYTE)
> 
> Patch 29/341 and its dependencies 26-28 is an improvement, not a fix. Do
> we need it in the LTS kernels? I'm fine with that, just asking as
> usually LTSes only receive critical fixes :>

It's to fix a build issue due to other commits wanting to use ALIGN in
tools/

I've queued it up now, thanks!

greg k-h
