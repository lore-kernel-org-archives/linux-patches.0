Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D77E591;
	Wed, 11 Sep 2024 12:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059395; cv=none; b=lbuJ8acMaEs0zdZbPQDuQpp9+FkBP/ysXKa8wmaeiofM8IdyBr3pHDrNpTIS4szx6uC3zF40Ygpo7BSvfWBu0o9uO5TXyt4NUQTniCvDsKHktMRQyztiNGRJegG1iLlbVZ1TJcPE0VkksBBwNQGvjAxn8AbNvPQmMWVJSYSLA/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059395; c=relaxed/simple;
	bh=rxPh3TiuDCg/VOWDYfvx7s/G/sbV0y7AThSl0LWQ/Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmGgLEmGvYPk0N/6vGiZnzgBDdkRu/fRQ6aW272ygJI6SbDWmIpC+x8pDPt79MXC5goGj3aNO3L33bVnGGNIF9j/KJTvxHK1oOW7RBEc5ukSEA2HoQSCddsbno49/6kKth3tzSz3MsrxPGHkl/Rgx/qUCujZw6xEnuziYMgh/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoP0yghG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoP0yghG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32636C4CEC5;
	Wed, 11 Sep 2024 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726059394;
	bh=rxPh3TiuDCg/VOWDYfvx7s/G/sbV0y7AThSl0LWQ/Gk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KoP0yghGQ/fZhKYYXrzqL6sNvdDTHvhe6JbE+wOym7HtESAINZaZUZ1S9TDakSAbw
	 dCQbJW72amOdyI7eWizcYxAtXgCLvD/FKucl6xTsftvyYsFdtZmlw1G81pfpEAngaG
	 DRxMRm4wxLK9j+My2ZPXi/DqPFFNY3hs4z2WnRug=
Date: Wed, 11 Sep 2024 14:56:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
Message-ID: <2024091112-agile-uncooked-4678@gregkh>
References: <20240910092558.714365667@linuxfoundation.org>
 <016687c4-2cf0-4c12-a1ab-7b163aef6762@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016687c4-2cf0-4c12-a1ab-7b163aef6762@nvidia.com>

On Tue, Sep 10, 2024 at 02:08:09PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 10/09/2024 10:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.167 release.
> > There are 214 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> > Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
> >      clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL
> 
> 
> The above change is causing build issues on both mainline and now with
> stable. There is a fix in the works [0] but has not been merged yet. For
> kernels such as 5.15.y where this driver is enabled, the build fails for
> us with ...
> 
>  drivers/clk/qcom/clk-alpha-pll.o: In function `clk_zonda_pll_set_rate':
>  clk-alpha-pll.c:(.text+0x2f90): undefined reference to `__aeabi_uldivmod'
> 

I'll go drop this from all branches and just wait for the fix to be send
and then someone can send both of them to us for inclusion.

thanks,

greg k-h
