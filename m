Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1873264D;
	Fri, 16 Aug 2024 08:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723797757; cv=none; b=LP2qiJ1UlgXK0PLsvdzoZT3ISOVpclCYfNHjrZW+MhmlRq+N0Z8cxOB9wk3DErgLRIMKnW+pZWr7Xq+VQxdHUWhmuOr7zB3pZjTD9v0S1qmbrd/XVg3YuuIJXaLy3zL0cDK6WGI2NuAQHWP62AHqA1Dmu/dj/Sv4/63q2RjyxRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723797757; c=relaxed/simple;
	bh=6NDIDdB8PZfIYQxi9ute8BoA2vwt/rOC3YPrs9mp8BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ya2vx86qY0ZtqcdpIMf7z5QKjVclp1EDBTJeIucZvmietcdybeERGvJjBi2YN+vJBN+n1jEE4iLGdjr4yq/73ehc6tOv8twZnP4/UsQT94dNqeTBEt9DFj1hNr9VkhLfSgcuERubYCduoJAE0en1m/ygVuRLL38R3lVtPv1uJ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjJabqEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjJabqEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC63C32782;
	Fri, 16 Aug 2024 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723797756;
	bh=6NDIDdB8PZfIYQxi9ute8BoA2vwt/rOC3YPrs9mp8BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TjJabqEqwjd55SrH84RAMrNWyxiQB3ryGPJIkfEAXQYkj7HnG4L5qJXizZnS6Bxr+
	 OouHrUvMUOqnw75dWkE17GiksLxYQ7LORG8Zs5n19JuvbH6qdO8rKznKXQCsdEsDsl
	 0pvwxRiEO/KEL7qdKutoMiV1eA/4hFO+SqR12fq8=
Date: Fri, 16 Aug 2024 10:42:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/263] 6.10.5-rc1 review
Message-ID: <2024081644-tipoff-oboe-d72e@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <8852e518-3867-4802-adea-0c0ee68d1010@roeck-us.net>
 <2024081616-gents-snowcap-0e5f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024081616-gents-snowcap-0e5f@gregkh>

On Fri, Aug 16, 2024 at 10:38:08AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2024 at 07:21:00AM -0700, Guenter Roeck wrote:
> > On 8/12/24 09:00, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.10.5 release.
> > > There are 263 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > I see various allmodconfig build failures on v6.10.5.
> > 
> > Example from arm:
> > 
> > Building arm:allmodconfig ... failed
> > --------------
> > Error log:
> > drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1581:13: error: 'is_dsc_common_config_possible' defined but not used [-Werror=unused-function]
> >  1581 | static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
> >       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_mst_types.c:1569:21: error: 'kbps_from_pbn' defined but not used [-Werror=unused-function]
> >  1569 | static unsigned int kbps_from_pbn(unsigned int pbn)
> > 
> > The functions are built and used conditionally in mainline, behind CONFIG_DRM_AMD_DC_FP.
> > The conditional is missing in v6.10.5 (and v6.10.6-rc1).
> 
> Odd that other allmodconfig builds passed :(
> 
> I'll dig up where that conditional showed up, thanks for letting us
> know....
> 
> Ah, looks like it showed up in 00c391102abc ("drm/amd/display: Add misc
> DC changes for DCN401"), gotta love "fix a bunch of things" type of
> commits...

And that commit is crazy, and no way will it backport, so I'll just go
do this "by hand".  People who approved that commit need to revisit how
to create changes properly...

greg k-h
