Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF919E804;
	Mon,  9 Dec 2024 23:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733785577; cv=none; b=V7hA3w8IiaG+w2DocCP9/oHv8LSNtTo9Jwc4XWrd014x3EKGg82IX/a+8ngBr2XOur1CnmifqPF7UXI+oX+pybRw69GSb63koEeG76sLZ31MkEL4fBHC7Tte2M6nyS9ER1TuEwSFJEAHlDoUaEiAg7LJIucUUpae5Fv+o1lp5aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733785577; c=relaxed/simple;
	bh=nI45IWdza/lGjrHUHY+hfOBTFUpcPsRRCggpavDqgIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlB2zZXYb9zODB+P0y251Ma+EKJUhH+XGAJJg4rS5BDfb8Kae3jOqTDheNMuBGX9jmHWHtRd+WjvkhZpThhHg4SC1Y3y827G153hErMLwu0bZGS/MLfa4GuObWNXDFjD5HFyLtLoYwvuc5nu2SM+KJAcVH4c7Z8W+d4vfjGy0FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrF4o+vE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrF4o+vE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C540CC4CED1;
	Mon,  9 Dec 2024 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733785577;
	bh=nI45IWdza/lGjrHUHY+hfOBTFUpcPsRRCggpavDqgIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GrF4o+vEfaeGYNO2bHvI3IV6KLYEVodBGu7kt0gaxLLo8lHuQWNiEhP6LEuebe1H/
	 4yAxSbiV0j9ZvAhDNOz+YfyCxTS2AGJFKF6nSFuL2EH6B+Giq7hlIh3uidLs4zQlBT
	 8HiP/jIPx0efODD/6duYQmppKOwjZG0GwVs3g84zbO4m4gtSmwU/c7NuurCecC8I/R
	 PkklROAUDh8/qqAy1jMAwoze0jZnmiZM+YXou9dNpzl6EehN3hJYsiAYgMayKLKlgA
	 AFUVEeeYZyvnW4kb3YY3x6jZ80w90Ue/z+AapUypQO19wEoESSEdGkzBjz6EmwXP8J
	 ZwDwTPuDUSnmA==
Date: Mon, 9 Dec 2024 23:06:12 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] iommu/arm-smmu-v3: Remove domain_alloc_paging()
Message-ID: <20241209230611.GA13790@willie-the-truck>
References: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
 <3-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Dec 05, 2024 at 11:43:29AM -0400, Jason Gunthorpe wrote:
> arm_smmu_domain_alloc_paging_flags() with a flags = 0 now does the same
> thing as arm_smmu_domain_alloc_paging(), remove
> arm_smmu_domain_alloc_paging().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 ---------------------
>  1 file changed, 31 deletions(-)

Ha! I was reviewing the previous patch and about to reply asking why we
couldn't just implement arm_smmu_domain_alloc_paging() as a wrapper
around arm_smmu_domain_alloc_paging() with flags of 0.

Good thing I read ahead :)

Will
