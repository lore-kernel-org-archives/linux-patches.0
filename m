Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F70B226191;
	Thu, 19 Dec 2024 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734624345; cv=none; b=nEaHgebSxRgyQYHx+CaRedIEY+kYnIC4tu1TFpbUu0XFYdNmtLsb7muReDp2EzPbCLO1x+CSg+MsIYOySXj6PHBGkXhX3FPxzzcx3lIsnHIZUaifSRHs/SSh9U8keV2cMYXp3g+t6bdptz3DK86q7lPyAmDUodLGfd9gpXlb+30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734624345; c=relaxed/simple;
	bh=4UQH8/Slhc008shJtUjPjQuPpii5HVsJGrfuPKQxLjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nf/dLUNh2waf9NUmy0+fd7wY6yV9zYBRSVjqOg3G/gqeMbfmUnecXF9QnnF/fyaWutaE439+oUSp8VOw2zs7DQIqfu/59flWu1I5FgPuqb6kZLedxED4TxXscVqv2R5psF05GIQjZ6Nh2UzHS64sRjrvUu44vU6Vt+UpM9a6D3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/cYLihE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/cYLihE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611FCC4CECE;
	Thu, 19 Dec 2024 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734624344;
	bh=4UQH8/Slhc008shJtUjPjQuPpii5HVsJGrfuPKQxLjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/cYLihESqvI7HKWPUK4g/AfIB1yKz1RRdti+ENkaMvLsD7hAQAK89FUk76hMvhyS
	 3tBepWSkv8BuLNb6pOaNSTAMPd8bwUyYWmYK9KbZ9V0CPTYtfCce7KdhzQefyGQetI
	 XAGloGDMn4TUTNNaXJo6LSjHfb4zCHaitDNpOUDM=
Date: Thu, 19 Dec 2024 17:05:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
Message-ID: <2024121931-create-thesaurus-725b@gregkh>
References: <20241217170533.329523616@linuxfoundation.org>
 <b2c40d56-9ee1-484c-bfbf-d1c4a45594a1@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2c40d56-9ee1-484c-bfbf-d1c4a45594a1@oracle.com>

On Wed, Dec 18, 2024 at 11:19:48AM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 17/12/24 22:36, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.67 release.
> > There are 109 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> > Anything received after that time might be too late.
> 
> This below commit is causing perf build failure, could you please drop this:
> 
> > James Clark <james.clark@linaro.org>
> >     libperf: evlist: Fix --cpu argument on hybrid platform
> 
> evlist.c: In function '__perf_evlist__propagate_maps':
> evlist.c:55:21: error: implicit declaration of function
> 'perf_cpu_map__is_empty'; did you mean 'perf_cpu_map__empty'?
> [-Werror=implicit-function-declaration]
>    55 |                 if (perf_cpu_map__is_empty(evsel->cpus)) {
>       |                     ^~~~~~~~~~~~~~~~~~~~~~
>       |                     perf_cpu_map__empty
> 

offending ncommit should now be dropped, thanks.

greg k-h
