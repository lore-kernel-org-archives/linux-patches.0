Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B40D186E58;
	Thu, 12 Sep 2024 07:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126458; cv=none; b=VYN2MOGXAUMveFeaGi+ZZSstJYF9zd7nKozjXz1ZWBoEhAu7HN8nH1m2sK+1mDokeofrOSXkcMQ64DF21d0PQdbGyEdt24wM733ArF8//IIS46IQi5MR60okU/I6zaaQ0hVE0CireS3d9o8lwv4pi0O0qRmizxbQrLLF0VTXw5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126458; c=relaxed/simple;
	bh=nYbkOKHYRFOZ+w2JM97HqI9IeKhZ1OUF0sxHdxDDa1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccklkLhQv6Yi1xCSjzG17uZi8LsNlnpoEs8CP3Gkq3soPxPQ1WuyWk5OyOHQatVovvEjkjVkeU8lUFB8Wd7LaGUDIs6RFkPHOm8u/xIKIOVzohPnWkKzSDtl/UaFRzv/svQVJH1DYWLmfUbeEwwZo7NqzMYq3JxSHt1gIV+odM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhmUi3f6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhmUi3f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD27C4CEC3;
	Thu, 12 Sep 2024 07:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726126457;
	bh=nYbkOKHYRFOZ+w2JM97HqI9IeKhZ1OUF0sxHdxDDa1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zhmUi3f6KWPUYQ7nTxi0599w7TVQqdSEJOMy7rB/danc/C9HjvsNB3ZTwWvr5cUi5
	 GAuFRObjPY4XV0pdsLY1nFs0/Ha62kukd6Dm2AKKyuvmXkPAFGIeIk/5OEbLpTtdMS
	 3aSPNOKnQ955nBMEfBmAv7lFS8k994cyTY69Ft/E=
Date: Thu, 12 Sep 2024 09:34:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
Message-ID: <2024091214-relearn-emboss-75d0@gregkh>
References: <20240910092608.225137854@linuxfoundation.org>
 <69a511a3-af84-4123-a837-0ed1e5f62161@drhqmail202.nvidia.com>
 <10b0ef8b-7fd8-40f0-8d48-b44610502eb2@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b0ef8b-7fd8-40f0-8d48-b44610502eb2@nvidia.com>

On Thu, Sep 12, 2024 at 08:24:38AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 12/09/2024 08:19, Jon Hunter wrote:
> > On Tue, 10 Sep 2024 11:29:47 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.51 release.
> > > There are 269 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.6:
> >      10 builds:	7 pass, 3 fail
> >      20 boots:	20 pass, 0 fail
> >      98 tests:	98 pass, 0 fail
> > 
> > Linux version:	6.6.51-rc1-g415df4b6a669
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Builds failed:	arm+multi_v7
> 
> 
> This is the same build issue I reported for 5.15.y and introduced by ...
> 
> Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
>     clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL
> 
> Looks like we still need to drop this from 6.6.y and 6.10.y.

Ok, will drop it from those branches as well, thanks!

greg k-h
