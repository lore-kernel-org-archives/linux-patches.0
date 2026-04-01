Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA3836402F;
	Wed,  1 Apr 2026 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775061219; cv=none; b=NT9he56NkFxgZjJGC5PIghEUj7b5PG+zLf/lb+3W1Z6rYvT/R4NCbCv3M+LaEAu/jk6hqwmiAvvJ3jv6G2eVHs7fL4QZUj5jZhtxNeqjgacvUlqD8AYLNAaMNnO9IN9uo0O8WmupS4rEUoJ/b/9CXrvDmiN9AAzQliBkU/p63kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775061219; c=relaxed/simple;
	bh=bbGQgXq3CFYt+VX0sV+aCx31FLqKgRb0Qy92VqwuNGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipcV9V1UMiYkZ3LQV/jH1s0jGUcyxAFhyxR/Is+OvfHy5luZxSLi3dzKrTJ8Ptyw5uv7AwO9Lbspldl8JF+UWZGnQvlMwXQQM9zUIB5Am946xZZjmSz0riToLU/DR+dW4NxvKK7qSI9ZUMZopNoSDDk7egHhv+yhKBL4O+4NmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GwWe2F6B; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GwWe2F6B"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66E2E1D6F;
	Wed,  1 Apr 2026 09:33:30 -0700 (PDT)
Received: from [10.57.77.192] (unknown [10.57.77.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD4483F7D8;
	Wed,  1 Apr 2026 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775061216; bh=bbGQgXq3CFYt+VX0sV+aCx31FLqKgRb0Qy92VqwuNGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GwWe2F6BfmTxsuY29owznO9HTvvEW56dJwVfyzV+5uN0GBcLYF7hpaKkCZDOcPPBz
	 TEcBqhEj+P8QyYRv1a/8cQy7DGKWuggpAfXXgXY+enYSwr4zFfe3AYZpwJmO6CKo0b
	 fnsDhTf4cmHiD1S89CGVZJpbWm2Pb2eppj60v/Lw=
Message-ID: <ee2c2044-e329-4cdd-ac35-9365824d3677@arm.com>
Date: Wed, 1 Apr 2026 17:33:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
To: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
 Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
 Janne Grunau <j@jannau.net>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
 Matthias Brugger <matthias.bgg@gmail.com>, Neal Gompa <neal@gompa.dev>,
 Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Sven Peter <sven@kernel.org>, virtualization@lists.linux.dev,
 Chen-Yu Tsai <wens@kernel.org>, Will Deacon <will@kernel.org>,
 Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Jon Hunter <jonathanh@nvidia.com>,
 patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>,
 stable@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-03-31 8:56 pm, Jason Gunthorpe wrote:
> The fixed commit assumed that the gather would always be populated if
> an iotlb_sync was required.
> 
> arm-smmu-v3, amd, VT-d, riscv, s390, mtk all use information from the
> gather during their iotlb_sync() and this approach works for them.
> 
> However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio,
> apple-dart all ignore the gather during their iotlb_sync(). They
> mostly issue a full flush.
> 
> Unfortunately the latter set of drivers often don't bother to add
> anything to the gather since they don't intend on using it. Since the
> core code now blocks gathers that were never filled, this caused those
> drivers to stop getting their iotlb_sync() calls and breaks them.
> 
> Since it is impossible to tell the difference between gathers that are
> empty because there is nothing to do and gathers that are empty
> because they are not used, fill in the gathers for the missing cases.
> 
> io-pgtable might have intended to allow the driver to choose between
> gather or immediate flush because it passed gather to
> ops->tlb_add_page(), however no driver does anything with it.

Apart from arm-smmu-v3...

> mtk uses io-pgtable-arm-v7s but added the range to the gather in the
> unmap callback. Move this into the io-pgtable-arm unmap itself. That
> will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
> ipmmu-vmsa).

io-pgtable-arm-v7s != io-pgtable-arm. You're *breaking* MTK (and failing
to fix the other v7s user, which is MSM).

> arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
> already have the gather population because SMMUv3 requires it, so it
> becomes consistent.

Huh? arm-smmu-v3 invokes iommu_iotlb_gather_add_page() itself, because
arm-smmu-v3 uses gathers; arm-smmu does not. io-pgtable-arm has nothing
to do with it. Invoking add range before add_page will end up defeating
the iommu_iotlb_gather_is_disjoint() check and making SMMUv3
overinvalidate between disjoint ranges.

I guess now I remember why we weren't validating gathers in core code
before :(

However, if it is for the sake of a core code check, why not just make
the core code robust itself?

Thanks,
Robin.

----->8-----
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 35db51780954..9ca23f89a279 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2714,6 +2714,10 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
  		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
  			 iova, unmapped_page);
  
+		/* If the driver itself isn't using the gather, mark it used */
+		if (iotlb_gather->end <= iotlb_gather->start)
+			iommu_iotlb_gather_add_range(&iotlb_gather, iova, unmapped_page);
+
  		iova += unmapped_page;
  		unmapped += unmapped_page;
  	}

