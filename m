Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812B814F9FF;
	Thu,  6 Mar 2025 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741270914; cv=none; b=ZyxApWuA9pR3z6nyxvd9gcizDsSyRx/CLs2mtEX44PVQbBVpu8GZesyFPZPHxe1MiGhBbicqO8hshq9wc7lu5iLPo74Wt+5YTgnmEJPDfyQtI6mSZHjsL4PvZp7wCLqEadtZ3O0jlEYJ061UB4LWqY9h2GXZVb/N4Y0YtM0tadQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741270914; c=relaxed/simple;
	bh=Kzc/ygPsjY1/bPfRsL3Kq65wiUi8OocHgccR3G6HMQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbVxDf8UicHAlyzMDrX2THdPp90t8w4mHNmzsPjj/S/8t2pOADrjLyYXdBV9y39hv8RtF7DgUfBq42fg+d6OOZzHUC/S/fMs2OutF0IM98RursFbLtLTRdl26txr40Q0sSM3qKAZoMvwSLeGCv0LUZ697EiPU00clKG+sdSfapw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm0R0ylv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm0R0ylv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F024C4CEE0;
	Thu,  6 Mar 2025 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741270914;
	bh=Kzc/ygPsjY1/bPfRsL3Kq65wiUi8OocHgccR3G6HMQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sm0R0ylv7yUZU9AtFADWIIKoZJbpxq7G+TSkVzyaLn8hjL32g0iBPyPembLh5dZyw
	 MnN+UAp8liptkUjrrhDWwRZDeNraKcapsGFmmRjT9flPNSALmQQ+PFeuVIArVpafOM
	 dvh67a5sq0VtRT9/Nv8lvGYM/QEvuMZGBbGiDdkc=
Date: Thu, 6 Mar 2025 15:21:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
Message-ID: <2025030634-legume-sinister-61c0@gregkh>
References: <20250305174505.268725418@linuxfoundation.org>
 <8433c362-1909-4a2e-b41f-c0f5677286d2@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8433c362-1909-4a2e-b41f-c0f5677286d2@sirena.org.uk>

On Wed, Mar 05, 2025 at 08:12:59PM +0000, Mark Brown wrote:
> On Wed, Mar 05, 2025 at 06:47:16PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.6 release.
> > There are 157 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> The arm64 defconfig build is broken (KernelCI reported this initially):
> 
> /build/stage/linux/arch/arm64/mm/hugetlbpage.c: In function ‘huge_ptep_get_and_clear’:
> /build/stage/linux/arch/arm64/mm/hugetlbpage.c:397:35: error: ‘sz’ undeclared (first use in this function); did you mean ‘s8’?
>   397 |         ncontig = num_contig_ptes(sz, &pgsize);
>       |                                   ^~
>       |                                   s8
> /build/stage/linux/arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is reported only once for each function it appears in
> 
> The same issue affects 6.12.


Thanks, I've now dropped the offending patch and will push out some -rc2
releases soon.

greg k-h
