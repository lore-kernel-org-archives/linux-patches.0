Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A473D216E37;
	Thu,  9 Jan 2025 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736423533; cv=none; b=aYz/dmb+uHljZtGtseOP+LAOaiID4tjS0LdPWtyanz8v0fdQLu1fL9tqvD3of89+Zpf9DTmr9Ja6FCLcAtH5eoT/CpYizLxheiJg2j+/b3WMYQ+RJ9XzQq1KR2eYaQPdVTLL4dU4Nnqk3nWWQ+58nHqIIN9O1F996aNEV8abeFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736423533; c=relaxed/simple;
	bh=0DvHvOPi1C1b3WK6668/5sCuJZUQ3zKOQdp26gkSGms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tG1uR1lvh6/Wj3NxDP15wAIP5OEU9odaVNqQftJQWOH+1Dltb1CIrZkwxlg9d4nTbnMmPAt9q2C+hKXCwBmAhs/n8RpuorUfrUZJYrIZVLILYB4OsbWg06DvD+NbPdqijObzn+KEzKZhzzIg4Gm92QPeX7MYjcYI+R5qzOnY1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxIwI0oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxIwI0oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B76C4CED2;
	Thu,  9 Jan 2025 11:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736423532;
	bh=0DvHvOPi1C1b3WK6668/5sCuJZUQ3zKOQdp26gkSGms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IxIwI0oAHmucpK57bdS/lLW8V/7ZbfZ8+FhXmGy2npLeB9WG6VSOT+0WXXZbse1Kg
	 5KsxdI0LEYyBG9g6CmOgLiPzLT3eQ66Gl4AZ86p8TOEZi3h9vvkBoekcrn/kMbNMYP
	 4+Bz/JLSz2yewsmosmQrTyBRgCONnjCivQZX4RkI=
Date: Thu, 9 Jan 2025 12:52:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Message-ID: <2025010954-durable-everyday-fc8b@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <CA+G9fYtn+9qbWA7DvmO7t6TvyTy40cpvKufz+4J06x_nPvnNXA@mail.gmail.com>
 <Z30lxAIp9x5dhC5Y@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30lxAIp9x5dhC5Y@kernel.org>

On Tue, Jan 07, 2025 at 03:01:56PM +0200, Mike Rapoport wrote:
> On Tue, Jan 07, 2025 at 03:54:43PM +0530, Naresh Kamboju wrote:
> > On Mon, 6 Jan 2025 at 20:53, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.70 release.
> > > There are 222 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > As others have reported, boot warnings on x86 have been noticed
> > 
> > memblock: make memblock_set_node() also warn about use of MAX_NUMNODES
> > [ Upstream commit e0eec24e2e199873f43df99ec39773ad3af2bff7 ]
> 
> There's 8043832e2a12 ("memblock: use numa_valid_node() helper to check for
> invalid node ID") that fixes it

Thanks.  I'll drop the offending commit for now and then add this, and
the fix, back in for the next round of -rc releases to get testing on
it.

greg k-h
