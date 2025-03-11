Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD41253F2D;
	Tue, 11 Mar 2025 11:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741691576; cv=none; b=bIuglpbQDOsUBPqvGU8d3/lYu27A1qvrYXAEP8/YnJvocpyGZdmv0H7G7hpWFjR2TFsNxBSlZU5SrtMLhfk0BPi9M8fCA+7v6qfw51EJS8Qy+Lwbuiqr1C0feHGYQgOIsCDuPzvw4IJp2ZJEYTGZt/XrU5MxLkLoH5iDoz4mD5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741691576; c=relaxed/simple;
	bh=jDLLN1t9mGvmDd7/tVVldiT8g8qW1ayloljLmPeRd9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxtMTWOntejsXU2WFb66lSR000Yzy/J69cNIYUNn6vqOcCnOKP/0hD16qdpRnFAGEzMQagnLqKd7Knyqksd/ASbAMtZVF2V6Zf72vkBDyjYBz1eI2VMRb80fK4KcQdTebcv7J4D3WrLqcymKnvJXfTegvtsOqBCq8gPomi62IjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HInScGlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HInScGlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA8DC4CEE9;
	Tue, 11 Mar 2025 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741691576;
	bh=jDLLN1t9mGvmDd7/tVVldiT8g8qW1ayloljLmPeRd9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HInScGlt7pN5cATJjdHsmqdzi97bvvyxN0OH8dStbVwrocv9k5dXSdsfH5aYrGgXT
	 9CO5g9wnrczKTJaIxyecqCuE1b17fAYUoeyBgxtYvkVUt4fZfiIM9ydvzELQ/ft9+Z
	 OYzUK1EgNgxcpQW1J6tPStLPmbxB4F7wChpnK6uA=
Date: Tue, 11 Mar 2025 12:12:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: Jon Hunter <jonathanh@nvidia.com>, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
Message-ID: <2025031138-disprove-walmart-d238@gregkh>
References: <20250310170545.553361750@linuxfoundation.org>
 <65b397b4-d3f9-4b20-9702-7a4131369f50@rnnvmail205.nvidia.com>
 <07b8296d-ad04-4499-9c76-e57464331737@nvidia.com>
 <a97e013b-67cd-4db6-bb65-ba0319a4f38c@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a97e013b-67cd-4db6-bb65-ba0319a4f38c@w6rz.net>

On Tue, Mar 11, 2025 at 03:38:51AM -0700, Ron Economos wrote:
> On 3/11/25 03:11, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 11/03/2025 10:02, Jon Hunter wrote:
> > > On Mon, 10 Mar 2025 17:57:26 +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.179 release.
> > > > There are 620 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz
> > > > 
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > linux-5.15.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Failures detected for Tegra ...
> > > 
> > > Test results for stable-v5.15:
> > >      10 builds:    10 pass, 0 fail
> > >      28 boots:    28 pass, 0 fail
> > >      101 tests:    100 pass, 1 fail
> > > 
> > > Linux version:    5.15.179-rc1-gcfe01cd80d85
> > > Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
> > >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> > >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> > >                  tegra210-p2371-2180, tegra210-p3450-0000,
> > >                  tegra30-cardhu-a04
> > > 
> > > Test failures:    tegra194-p2972-0000: boot.py
> > 
> > 
> > With this update I am seeing the following kernel warnings for Tegra ...
> > 
> >  WARNING KERN gpio gpiochip0: (max77620-gpio): not an immutable chip,
> > please consider fixing it!
> >  WARNING KERN gpio gpiochip1: (tegra194-gpio): not an immutable chip,
> > please consider fixing it!
> >  WARNING KERN gpio gpiochip2: (tegra194-gpio-aon): not an immutable
> > chip, please consider fixing it!
> > 
> > The above warning comes from commit 6c846d026d49 ("gpio: Don't fiddle
> > with irqchips marked as immutable") and to fix this for Tegra I believe
> > that we need commits bba00555ede7 ("gpio: tegra186: Make the irqchip
> > immutable") and 7f42aa7b008c ("gpio: max77620: Make the irqchip
> > immutable"). There are other similar patches in the original series that
> > I am guessing would be needed too.
> > 
> > Thanks
> > Jon
> 
> Also seeing this on RISC-V.
> 
> [    0.281617] gpio gpiochip0: (10060000.gpio): not an immutable chip,
> please consider fixing it!

Ugh, I think I know what that is, a patch slipped back in again, let me
go dig...
