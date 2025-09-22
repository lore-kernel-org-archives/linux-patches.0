Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FD32ED14E;
	Mon, 22 Sep 2025 02:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758507318; cv=none; b=DTWV1a82ZCDA12rHIT9dGjvhkFzLyibRaYvZ6hv5qTU0ldGRJAWodpWfVICNIeeGHFzQW45noJJtEtcgM8XFj77ly0I0Yo8zZej7OJ4Ug+5BeaXSU8L4ElKSTLhcgC0r8t0nBcLoa2ib9lenTA6FmNPP+Yu29M+8veP/XeTP1gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758507318; c=relaxed/simple;
	bh=fL/f9GCY4PNtyWFGNG+WiRGSw0k8XnBnFC1Y3+Hg0ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPkRV4hNvaNhF/z+ytTI166751ryAT4YzvEs1102ghrBuo+ST+79tKw//hzdSgTGN6LWc04Q6o0bfrKSdSyI9pncWSY98mQUm8Ae/Jq5MS3+zVpTwygYNLsLBMCpTYBWyBHCTYb7JKGHRoOpu5n+ofok1K3F6uCGmz1Uoejq5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z3XfLEoI; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z3XfLEoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758507317; x=1790043317;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fL/f9GCY4PNtyWFGNG+WiRGSw0k8XnBnFC1Y3+Hg0ho=;
  b=Z3XfLEoIQZbIgSgVesrwEacuh9GI3HYeTC9cfhG1hXkZJFDB5A6ApBxS
   2w+bDIl+aARKDtzCWxHWaEoGO/9ybHCQE/f9+AO8nsMOx5+bjadivxUOj
   J/2b+gtdnI5kZofM8/xuGEAVPSmqsLkz3lRIgtGrjIN+hQJYczhrR8K1+
   w2XgTTWB6CrIJEMnpghqVa7EPQCWDCbW8c4OjuhfnnA1H83DMz/msLFkC
   tQKWbDN/UyAPmPST3vRM91D0HUAX5YP8zz95aAd9e6woN5ox0Rg7oxJe/
   gp5MOmnsq9YFj/9y+w13baaOpoX+EdlTwTl359O34e4LVcBOuPC2/e2ai
   Q==;
X-CSE-ConnectionGUID: 5HNZoC+GTcy0rZVDPiAAeg==
X-CSE-MsgGUID: 2Vi45XwpTsC6ak+8UnQDBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="48343514"
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="48343514"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:15:16 -0700
X-CSE-ConnectionGUID: h+kku1w5T/qkegOTrjAXuw==
X-CSE-MsgGUID: pZJP/p6ISp6JRWbFIdiIqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,283,1751266800"; 
   d="scan'208";a="180776450"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:15:14 -0700
Message-ID: <79da2a28-3c05-4afa-90d8-dfc664f101b1@linux.intel.com>
Date: Mon, 22 Sep 2025 10:12:15 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to
 the page table
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/25 01:26, Jason Gunthorpe wrote:
> @@ -195,6 +218,10 @@ static void record_dirty(struct pt_state *pts,
>   				dirty_len);
>   
>   	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
> +		/*
> +		 * No write log required because DMA incoherence and atomic
> +		 * dirty tracking bits can't work together
> +		 */

Could you elaborate a bit on this comment? Is this a hardware or
software requirement? Are there any software checks or enforcement in
the subsystem?

>   		pt_entry_set_write_clean(pts);
>   		iommu_iotlb_gather_add_range(dirty->dirty->gather,
>   					     pts->range->va, dirty_len);

Thanks,
baolu
