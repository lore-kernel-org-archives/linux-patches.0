Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E55194A75;
	Sat, 15 Feb 2025 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739613059; cv=none; b=fD+/hnFv4GHN4mo5HWFTJbKjwAAp05ipIyNH6vV/au9datTVchul4FC0Ge95mhSf/EFS7+YDQcFfexc1Tb5Teq1DVT1rWtO8wBNJ+k9tmallXyKQrBGMU7wKMQhY9KIb3Muc4Gz8d4f2z1p/yhSXVHXJ0LyIlS1j51pTKqhNYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739613059; c=relaxed/simple;
	bh=MYtye3mXOSgmjNVwAdiLAWnVTAT6ccam/tc+AZHY5DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYCG7bAn1zStKKBgBQeOD1rh3HlC/afcjh0n1iQeRGklQg+IKh3QApLnPfF5w2vIoOUaqFuQBMFw3Jaco21xTkGehgv4Evd/KcCBXQLLIBZ82fj0A8DeIU0YRqPtqlMSmPC59ffAxxl4YAhWzZ7t0ftrb8cq4/PTVy8DH6kUnFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HZn57gNs; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HZn57gNs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739613057; x=1771149057;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MYtye3mXOSgmjNVwAdiLAWnVTAT6ccam/tc+AZHY5DU=;
  b=HZn57gNsQtn06a0haQdzAuFtqZhobhpWGh6XiRpmGXK3QA4wm1CMPmq9
   2gNgp5x5lpZRza1uIKTo6vOlrVGfgR0QsDsLZZFOCEdtuCuE65XhRkcP8
   1DaIPYwQa/v+SYyNc/KOMu/cDTZQMSAUSn61xT+EqfylVNwnj6d5CkDCO
   IYR2WBsvmrNcAhqZK55NeqTxE28vscLRcAO6YhBVPxpr4e0UZFjcybX34
   ArOxQa7MUjCQj2A2WmMZmBv1PwpAxS/34oysCXHDn5ovzC7Lv1pZbkU8D
   acq2ub7Y7cyDf5Mf5kbb4TRCSotXA1KYdVwcozvNGS5kQVvnc2nxzrDJS
   w==;
X-CSE-ConnectionGUID: hJUH5py1RhSWcFWyM9Co8g==
X-CSE-MsgGUID: zD20xP6BTZiO07hkGMS7pA==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="62830886"
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="62830886"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:50:56 -0800
X-CSE-ConnectionGUID: Wx9nhBKeSyWUiDCwEGa+UA==
X-CSE-MsgGUID: tBrnDxKzSJ2qq/G5C/lSng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,288,1732608000"; 
   d="scan'208";a="113858921"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 01:50:48 -0800
Message-ID: <d66e555b-8054-4f73-8077-201b51139773@linux.intel.com>
Date: Sat, 15 Feb 2025 17:47:51 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/23] iommu/pages: Remove iommu_alloc_pages_node()
To: Jason Gunthorpe <jgg@nvidia.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, David Woodhouse <dwmw2@infradead.org>,
 Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Robin Murphy
 <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <23-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <23-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/25 01:07, Jason Gunthorpe wrote:
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index dd980808998da9..1036ed0d899472 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -493,14 +493,13 @@ struct q_inval {
>   
>   /* Page Request Queue depth */
>   #define PRQ_ORDER	4
> -#define PRQ_RING_MASK	((0x1000 << PRQ_ORDER) - 0x20)
> -#define PRQ_DEPTH	((0x1000 << PRQ_ORDER) >> 5)
> +#define PRQ_SIZE	(SZ_4K << PRQ_ORDER)
> +#define PRQ_RING_MASK	(PRQ_SIZE - 0x20)
> +#define PRQ_DEPTH	(PRQ_SIZE >> 5)
>   
>   struct dmar_pci_notify_info;
>   
>   #ifdef CONFIG_IRQ_REMAP
> -/* 1MB - maximum possible interrupt remapping table size */

Can we keep this line of comment,

and move it ...

> -#define INTR_REMAP_PAGE_ORDER	8
>   #define INTR_REMAP_TABLE_REG_SIZE	0xf
>   #define INTR_REMAP_TABLE_REG_SIZE_MASK  0xf
>   
> diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
> index d6b796f8f100cd..735e26498ee9f2 100644
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -538,11 +538,10 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
>   	if (!ir_table)
>   		return -ENOMEM;
>   
> -	ir_table_base = iommu_alloc_pages_node(iommu->node, GFP_KERNEL,
> -					       INTR_REMAP_PAGE_ORDER);
> +	ir_table_base =

... here?

> +		iommu_alloc_pages_node_sz(iommu->node, GFP_KERNEL, SZ_1M);
>   	if (!ir_table_base) {
> -		pr_err("IR%d: failed to allocate pages of order %d\n",
> -		       iommu->seq_id, INTR_REMAP_PAGE_ORDER);
> +		pr_err("IR%d: failed to allocate 1M of pages\n", iommu->seq_id);
>   		goto out_free_table;
>   	}

Thanks,
baolu
