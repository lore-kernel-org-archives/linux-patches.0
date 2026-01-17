Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7920ED;
	Sat, 17 Jan 2026 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768662030; cv=none; b=VFcUphJaduIco7pAYQor5b8jC3xawvojS4A/odxo6ON7FYTZeUQlUmXMqIRcodL/gMz13v5KXYH8awXHqUhCQsZjdcywe0b1ei233E7rZ7Bx2Y5TCZKwRUVeJu9+ZVnr5WXbGdYHnefNkxGB+QF0JfDA3W9QOAhNnG6JfUTmixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768662030; c=relaxed/simple;
	bh=Q+kPkjPwwqafWwEPRcVEYeQON8thNU801cp2imcEeWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/AinN4acrYHuHPn/eoNF2UPtvVcfCq5M7eI4KIVdurjH7OZqAX2Hgoj1je3Vq8atsfccWtW0ZrAAwXkKBHo/Uh/ygXG/vwV4noMWLrX4Hyoc/9wi6geKREUsI24uXI6um999D8+FTGacy2vQDliOVjzKksDpSsLM5px5bM+Of8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqqx5Inp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqqx5Inp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F67C4CEF7;
	Sat, 17 Jan 2026 15:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768662030;
	bh=Q+kPkjPwwqafWwEPRcVEYeQON8thNU801cp2imcEeWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aqqx5InplTMZR1lz5vI3vCdIATQTDCNd8hwpxDzwJm6ndrkX9EsQPmpJ0KAhGgv0V
	 RoA8Bz7bLp7a9t3kkM0Gh3QUO2IhKb+wT/F7Dap+Fzb6a/IN4dv/4JcbsH7VgE3+JP
	 qhUD/H1j2sdaPxMDipfZ4lmlqNkvx2qb4zvk0EuA=
Date: Sat, 17 Jan 2026 16:00:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
Message-ID: <2026011710-grinch-busboy-dda1@gregkh>
References: <20260116111040.672107150@linuxfoundation.org>
 <2aaa124e-4322-43cc-b155-2011b94b449c@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2aaa124e-4322-43cc-b155-2011b94b449c@w6rz.net>

On Fri, Jan 16, 2026 at 10:36:37PM -0800, Ron Economos wrote:
> On 1/16/26 03:13, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.198 release.
> > There are 551 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Jan 2026 11:09:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> My HiFive Unmatched target (which has a Cadence Ethernet controller) fails to start the network interface with the following messages:
> 
> [  121.778662] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
> [  122.373760] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
> [  122.383421] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
> [  122.389481] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
> [  122.610641] macb 10090000.ethernet end0: inconsistent Rx descriptor chain
> 
> Reverting commit "net: macb: Relocate mog_init_rings() callback from
> macb_mac_link_up() to macb_open()" f934e5d7caad6ae0a081352e91cbd7f0284ad9b3
> solves the issue.

Thanks for the info, I'll go drop this from 5.15.y and 5.10.y as well.

greg k-h
