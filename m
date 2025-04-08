Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576E222B8AC;
	Tue,  8 Apr 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125778; cv=none; b=BdCerFtipTiUZhhjGAiNF8VIIqb74oq9BnHLGPhl99INsmgVVjsyGrprgYfO7xpbo10Q1N5sGOYAZhWbJ9op1xKnqpKBbS5O+/vcJTRO1NaTtdwWuKr01Yv6B3mqdP3fzxXBNMfvXP6A0Juf403ZnIeuS0XxEs9WxhS41uD8zEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125778; c=relaxed/simple;
	bh=E5cENsqRstExmfqwbKUIbbQXiSoHM4TtwUmMndbmO/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hyPS9XSzjzQrDWgndACkjvMnT3Cy+VzAuxmMgiMCoki7Mom2hgDEunFRbskJ6j8ckWyourAlEZV9aiUn22A3BKACvMUsDAqnF8zFKPGzp4xfjj1cWOxtrDt0iQvs1kEqhpM4iZ9ZuLxyC8a/AcjfvsvRSxZQl63899wWiyqPAmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBBGy3GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBBGy3GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D81C4CEEA;
	Tue,  8 Apr 2025 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125777;
	bh=E5cENsqRstExmfqwbKUIbbQXiSoHM4TtwUmMndbmO/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YBBGy3GCXzaPGH/fwvI6u+4YmRupzhZnfEcuL2udNECV51l4yzdnAJ6iJP2/k/E49
	 H1lMZdL9mJvE9D/F4IZsFa3rf+COizGCd1HUCtzL7WMM1KweNVAfE2LLZCM4oEo9r2
	 bEGWTXkoC9BvHMOuk7DC/cJpHRYDCl5jJZkiqIak=
Date: Tue, 8 Apr 2025 17:21:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <2025040809-carded-friend-c2c1@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <0e5aaddf-d149-40e0-8604-b3975f3998bb@sirena.org.uk>
 <2025040811-irate-cold-152e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025040811-irate-cold-152e@gregkh>

On Tue, Apr 08, 2025 at 05:20:26PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 08, 2025 at 03:59:40PM +0100, Mark Brown wrote:
> > On Tue, Apr 08, 2025 at 12:38:17PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.14.2 release.
> > > There are 731 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > This fails to build an arm multi_v7_defconfig for me:
> > 
> > arm-linux-gnueabihf-ld: kernel/sched/build_utility.o: in function `partition_sched_domains_locked':
> > /build/stage/linux/kernel/sched/topology.c:2794:(.text+0x8dd0): undefined reference to `dl_rebuild_rd_accounting'
> 
> Is this a dependancy issue, the function is there in the tree.  Let me
> dig....

Looks like we need commit 34929a070b7f ("include/{topology,cpuset}: Move
dl_rebuild_rd_accounting to cpuset.h"), I'll go add that now, thanks.

greg k-h
