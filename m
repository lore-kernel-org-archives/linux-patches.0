Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63528126C18;
	Sat, 15 Feb 2025 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739605557; cv=none; b=Jha49vrooigpaYPoWMr+ba4Xeo95bG8oa62leh9zWXhfo1d4QoJyUGu+y5LENqg0S2jEQkyaLaILCYdl9zz/3JLhKARv4sW+p76jvjuBz2s3Y9qokBUIztWig9Qq1wmu/3OVW/NaQJqSQoXIbQk60a8usLItD7TxbXZ79QYGsDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739605557; c=relaxed/simple;
	bh=qlq0mYc6i5WWBc/Lorm9EOv7T5OYfse3LTvwazBQoyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuIec9yGPA38sOSW/VN0jF8AISPZRwyE3edeCiadyePEq/lmKOe2imViuZmLrMas1bcQHdUpWVBYJsc1ENhc/VSu64WVpSLx8mob1cC07/s1GbuaTLO/05lRvz2YRfZ0EaVK0LYqERTp/lL95ZsNe9Swfo0jKKLmEOWQOGs9uHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aey1bzAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aey1bzAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1CEC4CEDF;
	Sat, 15 Feb 2025 07:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739605556;
	bh=qlq0mYc6i5WWBc/Lorm9EOv7T5OYfse3LTvwazBQoyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aey1bzAXGrHx2AIo538Fs1z79XV5sWeMSRSEd7R1MxQBPITlLalOo6LlN1gUlU5B5
	 6abSdP2RXHPv8sKsaSvNoRjbyYuR0H+Nm5EOEhbmfVHePLtSaD6jWhciCM1QcGY7fI
	 +6gyzzps3yY202O1VGX+FZsGA1EKNRjksgYg15qQ=
Date: Sat, 15 Feb 2025 08:45:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
Message-ID: <2025021540-attic-limelight-0fb3@gregkh>
References: <20250214133845.788244691@linuxfoundation.org>
 <57e42fbb-9372-4618-bbed-71da01326ffe@rnnvmail203.nvidia.com>
 <bcf76664-e77c-44b3-b78f-bcefc7aa3fc1@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf76664-e77c-44b3-b78f-bcefc7aa3fc1@nvidia.com>

On Fri, Feb 14, 2025 at 09:12:39PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/02/2025 21:11, Jon Hunter wrote:
> > On Fri, 14 Feb 2025 14:58:41 +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.12.14 release.
> > > There are 419 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 16 Feb 2025 13:37:21 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc2.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.12:
> >      10 builds:	10 pass, 0 fail
> >      26 boots:	26 pass, 0 fail
> >      116 tests:	107 pass, 9 fail
> > 
> > Linux version:	6.12.14-rc2-ga58d06766300
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
> >                  tegra20-ventana, tegra210-p2371-2180,
> >                  tegra210-p3450-0000, tegra30-cardhu-a04
> > 
> > Test failures:	tegra124-jetson-tk1: cpu-hotplug
> >                  tegra124-jetson-tk1: pm-system-suspend.sh
> >                  tegra186-p2771-0000: cpu-hotplug
> >                  tegra20-ventana: cpu-hotplug
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p3450-0000: cpu-hotplug
> > 
> 
> 
> Bisect is pointing to this commit ...
> 
> # first bad commit: [3efd1a4cc13eccc1ae02b0511aec5bc74a168b74] sched/deadline: Correctly account for allocated bandwidth during hotplug

Thanks, let me go delete that from both 6.12 and 6.13 queues.

greg k-h
