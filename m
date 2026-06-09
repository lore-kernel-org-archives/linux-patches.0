Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64C3B775A
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 20:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781036788; cv=none; b=SLfyEALRjS6AUOY6zvlSlomfOFQcessCqF2w3daMvoqaB++HSrArO2pedGH4fhO2/jtn802KkgI761MGiKNu4tClDMxwmVt06MJrnF2DXtfFLW/oepU+35eEFo357OdcnM7xtTXZ8T/GlLANhaauFkly2d9QFshGI5ApAKQfY38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781036788; c=relaxed/simple;
	bh=LpJw5/rR2o/yiUMFjEdd7DjoRvMJ/o5BY/vX0A5fvVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=MhsAnjw87OmVi0DugsCsPLHHXHqnSz+RI8go7lno6hK/nZMihMf4Jh7he7KH5Xa8iHjZGYR75sb7JOqHG/oPBp7elwDerWq3BpkHMt5gAR/znOb8Q4P/xzDxPvOu/1/rAWN5tFLCjxVMj+3EzGFJWFYWTi/GWNz9miSZqtY3F6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OdMJeTZx; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OdMJeTZx"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260609202624euoutp02fc3af1dd14d429bfe8535a537c4c491c~3g4TXR_Qz0280102801euoutp02K
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 20:26:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260609202624euoutp02fc3af1dd14d429bfe8535a537c4c491c~3g4TXR_Qz0280102801euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1781036784;
	bh=57bbvLEAqcBhGE8t67ZvZajQ3mKi7qJur7Og6R467TI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=OdMJeTZxDv2kDWMqxEnZy1IVY+qbiCiN3huzI7tnYXA0SDzHXHPz+m0MngV0QyL/O
	 +7NXZRoHGYly3KjWLRlrgEoIyZZ2xffgx88P7FR05far+qsaYJSPhyneY2JG7v7Jtr
	 l01Rt2Qq8ObgULm5P0Or4wflv+ihp/wc1wPzPfZg=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260609202623eucas1p2c778d0a0de063740109d0e23aa94be57~3g4SvX7Ps0695906959eucas1p2-;
	Tue,  9 Jun 2026 20:26:23 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260609202622eusmtip2010977d9f71c2e150648808310a6047a~3g4SCJQ9i1572815728eusmtip2I;
	Tue,  9 Jun 2026 20:26:22 +0000 (GMT)
Message-ID: <574ad256-8004-45f6-a226-ad2c74be5060@samsung.com>
Date: Tue, 9 Jun 2026 22:26:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH rc] iommu/dma: Do not try to iommu_map a 0 length region
 in swiotlb
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, "Joerg Roedel
 (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Leon
	Romanovsky <leonro@nvidia.com>, Luis Chamberlain <mcgrof@kernel.org>, Mark
	Lord <mlord@pobox.com>, patches@lists.linux.dev, stable@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260609202623eucas1p2c778d0a0de063740109d0e23aa94be57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260608181015eucas1p241dfd8c16072125dc760072a080d4cd2
X-EPHeader: CA
X-CMS-RootMailID: 20260608181015eucas1p241dfd8c16072125dc760072a080d4cd2
References: <CGME20260608181015eucas1p241dfd8c16072125dc760072a080d4cd2@eucas1p2.samsung.com>
	<0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>

On 08.06.2026 20:10, Jason Gunthorpe wrote:
> iommu_dma_iova_link_swiotlb() processes a mapping that is unaligned in three
> parts, the head, middle and trailer. If the middle is empty because there
> are no aligned pages it will call down to iommu_map() with a 0 size
> which the iommupt implementation will fail as illegal.
>
> It then tries to do an error unwind and starts from the wrong spot
> corrupting the mapping so the eventual destruction triggers a WARN_ON.
>
> Check for 0 length and avoid mapping and use offset not 0 as the starting
> point to unlink.
>
> This is frequently triggered by using some kinds of thunderbolt NVMe
> drives that trigger forced SWIOTLB for unaligned memory. NVMe seems to
> pass in oddly aligned buffers for the passthrough commands from smartctl
> that hit this condition.
>
> Cc: stable@vger.kernel.org
> Fixes: 433a76207dcf ("dma-mapping: Implement link/unlink ranges API")
> Reported-by: Mark Lord <mlord@pobox.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Applied to dma-mapping-fixes, thanks!


> ---
>  drivers/iommu/dma-iommu.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> This was discovered because iommupt errors on mapping length=0 instead of
> making it a NOP, so it is an became an issue since commit d6c65b0fd621
> ("iommupt: Avoid rewalking during map") making it a regression this merge
> window.
>
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 54d96e847f161b..381b60d9e7ceaf 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1918,12 +1918,18 @@ static int iommu_dma_iova_link_swiotlb(struct device *dev,
>  			return 0;
>  	}
>  
> +	/*
> +	 * After removing the partial head and tail, there may be no aligned
> +	 * middle left to map.  The tail still gets bounced below.
> +	 */
>  	size -= iova_end_pad;
> -	error = __dma_iova_link(dev, addr + mapped, phys + mapped, size, dir,
> -			attrs);
> -	if (error)
> -		goto out_unmap;
> -	mapped += size;
> +	if (size) {
> +		error = __dma_iova_link(dev, addr + mapped, phys + mapped,
> +				size, dir, attrs);
> +		if (error)
> +			goto out_unmap;
> +		mapped += size;
> +	}
>  
>  	if (iova_end_pad) {
>  		error = iommu_dma_iova_bounce_and_link(dev, addr + mapped,
> @@ -1936,7 +1942,8 @@ static int iommu_dma_iova_link_swiotlb(struct device *dev,
>  	return 0;
>  
>  out_unmap:
> -	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
> +	if (mapped)
> +		dma_iova_unlink(dev, state, offset, mapped, dir, attrs);
>  	return error;
>  }
>  
>
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

