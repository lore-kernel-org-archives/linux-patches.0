Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA0E285C98;
	Sat, 10 Jan 2026 09:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768038679; cv=none; b=QfLoVOj6Pa62cewaN6aqHuklzzVv5XvdbMiAxdm6LBkH5jfBwVE9FS/23lHHvxhW2GnUj4mGmcixQ18LxGOwSqknRM6r+WMQX3vgDVj6D6l4qqf5EKCcZ5YpBH1iy9VqqcZaVBPIxh1oXu+sbyubsLJGKT2ZqQ3AZ80Kxx0tEkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768038679; c=relaxed/simple;
	bh=9OyWKMYDe148U9X26qJNDCTreFJSbiafj02DwpRaC9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFYVNDNc/QukpWxAj7kjCtGnXyHLJixRqCXbpBLKWeJrC057ee1CLAk2tG9tyhey86qRWpOe7f2uIwqyW3EoNYGOOwG4/RQaUGNVptUB4Fcsj16Ai3n9LVGvVmd+BgO/9nbfNUtXooGXmCxcGELtYQEYPjvQAsrqrW4W+xOOs5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=0/YIWTHv; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="0/YIWTHv"
Received: from 8bytes.org (p200300f6af1d9600dfc71246d978d903.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:dfc7:1246:d978:d903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 096FB5ED0B;
	Sat, 10 Jan 2026 10:51:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768038677;
	bh=9OyWKMYDe148U9X26qJNDCTreFJSbiafj02DwpRaC9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0/YIWTHvvFJJoFOEwEAVf02+QLOKfF7QlvUohsNwoFunliS1JF2HV+TPuFx0JVKUO
	 /es3xZ+qHJu2gbptuKDHXbJtSle+tdBLZgfTGAnYR4yJOo1/u3bhBM7kxD1HTdpXCD
	 sY8qBSuiRdDyzC+3cmo4Sv/dBN7ewZxLDPOHP91Tl1StGpBhAD8mrl7dRC9EX8xKTO
	 +kaXLu9UsciHiOYGuD64D11SceJpHP1m+zSOyN8IMhd0Hnplfhr5rKiVaJ4bSyJ2Sn
	 pGB2mEp4vGKWg3RM80Sg5VnsMcyhOEVJw6iRnmNsYUdFqYJpK0sn1EhsvX11bVVZS6
	 xnjo5bwoC9jAQ==
Date: Sat, 10 Jan 2026 10:51:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Tian, Kevin" <kevin.tian@intel.com>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	kernel test robot <lkp@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH rc] iommupt: Make pt_feature() always_inline
Message-ID: <yor3hkhdde4erqwddzfzxg7leslnbob6ajyv6u3uypvgrhjlpg@p5kijkus7dx2>
References: <0-v1-3a1ecb955351+244-iommupt_noswbit_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-3a1ecb955351+244-iommupt_noswbit_jgg@nvidia.com>

On Fri, Jan 09, 2026 at 10:29:52AM -0400, Jason Gunthorpe wrote:
> gcc 8.5 on powerpc does not automatically inline these functions even
> though they evaluate to constants in key cases. Since the constant
> propagation is essential for some code elimination and built-time checks
> this causes a build failure:
> 
>  ERROR: modpost: "__pt_no_sw_bit" [drivers/iommu/generic_pt/fmt/iommu_amdv1.ko] undefined!
> 
> Caused by this:
> 
> 	if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
> 	    !pt_test_sw_bit_acquire(&pts,
> 				    SW_BIT_CACHE_FLUSH_DONE))
> 		flush_writes_item(&pts);
> 
> Where pts_feature() evaluates to a constant false. Mark them as
> __always_inline to force it to evaluate to a constant and trigger the code
> elimination.
> 
> Fixes: 7c5b184db714 ("genpt: Generic Page Table base API")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202512230720.9y9DtWIo-lkp@intel.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/pt_defs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied for -rc, thanks.
