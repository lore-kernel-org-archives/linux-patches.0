Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491E814D70E;
	Fri, 28 Mar 2025 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172960; cv=none; b=OkNJhKLWiQrUGjF5YW9CKutpw8trJpVuGcxv0Fd/j4pYZWIl9HdQrU78478kVLr1xi5U4Xvgkv2kKXcS5Mjg5BxMuxQfgzhmfp68FQAFiu4/TyyhWPrWeqjlqM2hykWqMJwd1DwjdIM2lK7wFFIwCGSneTV9kATNrYkydb6CZ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172960; c=relaxed/simple;
	bh=e7fsmDM0gpw4+gau67YrnXDylZqj3oaiJ1shUQMBpYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=As7vYPMrCTWdxbMMz45g7E3ZotpGHoEJXGc6POCKE4MbOAYeAkRJ8Dv45ZChnppnVYZjQGupqTzorKxBJT6MgFs1yiD7jjLvkfG9SOIJWf5Ecb1cibaw9xw12qECIhbEPSZTkw1+KTzW+GC39zaGdBsVz85IGfCIWcy6qF9jX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjEyHrhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjEyHrhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAADC4CEE4;
	Fri, 28 Mar 2025 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743172959;
	bh=e7fsmDM0gpw4+gau67YrnXDylZqj3oaiJ1shUQMBpYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XjEyHrhysVXKclrswweVfQt9j3syNkw+OS4yzAxzZ7rQ2IeIGQgTz8LFjcCYY8Kpa
	 1OGdDw0lQV6V1WjCXLnVSq2/ROWtae5+dPu1AkNjWvDZfDXpN16usZ/y4tGRPZ1vW7
	 EA1jYWYRYYsHU4oBrlx5ZQF1sDzxC3aJa4+VKye0=
Date: Fri, 28 Mar 2025 15:42:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
Message-ID: <2025032823-finalize-abnormal-d56a@gregkh>
References: <20250326154346.820929475@linuxfoundation.org>
 <2ee0a8e7-8945-48e2-9c11-28710708f029@drhqmail202.nvidia.com>
 <ec98dab7-1445-4b90-a48d-29b22fed6010@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec98dab7-1445-4b90-a48d-29b22fed6010@nvidia.com>

On Fri, Mar 28, 2025 at 02:26:19PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 27/03/2025 14:32, Jon Hunter wrote:
> > On Wed, 26 Mar 2025 11:44:35 -0400, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.85 release.
> > > There are 76 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 28 Mar 2025 15:43:33 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc2.gz
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
> >      10 builds:	10 pass, 0 fail
> >      28 boots:	28 pass, 0 fail
> >      116 tests:	109 pass, 7 fail
> > 
> > Linux version:	6.6.85-rc2-g0bf29b955eac
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: cpu-hotplug
> >                  tegra186-p2771-0000: pm-system-suspend.sh
> >                  tegra194-p2972-0000: pm-system-suspend.sh
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p3450-0000: cpu-hotplug
> 
> 
> Just to confirm, this is the same issue seen with 6.1.y.

Ugh, I missed that.  I'll go drop that on 6.6.y and push out a new -rc
for there...
