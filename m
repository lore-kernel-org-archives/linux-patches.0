Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABB2199920;
	Sun,  4 Oct 2026 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791121422; cv=none; b=tW/bkI/jOsarJeWnz/SIzcljk6m4+UrXnI8O874Q8sfPuxvnqgpaGcdyhTzjPEf2HiMk9gaBB/CvDOSlsEyDhvQC9nSPNXxNBGcmYeTNaq82IuXN3CjvM2RILGOiUDMe5IGrgP9Hk3Hs8jtoG5X/O/AWX2TZ3c9CQ2WdFME1AY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791121422; c=relaxed/simple;
	bh=pnM8FL0ybhA47wliAPvpkvg/bQFuT8QP5JjHEhOeIRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pc6c72LGclIyX+W0vU2D6bMD/WYEIhSzlwiu4Ez6cln656d2BsgtByQpi7IqPnJ043rW+vY6bADt9Q/qsP1KMl+gODnz29N9jA9sivV8eaM78XkhIFl/jPS4iEqpwWe7ikxcM3GisOg6vHuCZZ/5J4qroR5Ex5r9utx3pjDevJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBhKWZwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBhKWZwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237B1F000FF;
	Sun,  4 Oct 2026 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791121421;
	bh=cart4aroCADpkmuYa0nf9U9evT/n9aZirEJ8Fg6h6N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RBhKWZwQoqVRPgABpKUBw2m1iBnKwBRS8e4lwcs4mZ0ezvhFPwQ/qiagGCgYoJlvd
	 jbPda7CHLgMQ9E0vt7Vz2PdBNP4zJ9xX+fjK3oAwJoYrB80I5MskYqFVKT1KrS5YG/
	 LtktnVLfp6tIjGjVdaWULRbMUwRMH5uLhISHJPjVSMynmYWaOg2eOVU7gLrjhhUDRc
	 oJeeraSRS1XQm3CstRdRDNMNrwEg32d9UZ99oWf2QmecCF/nloSpdoj8kdQ/XUtjb9
	 5O7P6PZaup8SxVxeiK8b0YPlbbd+4RDjB87WoDT/AWpMhS7OdhQZxZuGmCjT4PcgI4
	 j0J/6E/EoFkMg==
Date: Sun, 4 Oct 2026 14:43:33 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v8 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <asJYBfMe_qf5Nbn-@willie-the-truck>
References: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
 <8-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>

On Fri, Oct 02, 2026 at 10:23:27PM -0300, Jason Gunthorpe wrote:
>  /*
> - * Generate up to two range TLBI command payloads covering [iova, iova+size).
> - * Sets use_full_inv if the range is too large to represent.
> + * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
> + * invalidate all levels.
> + */
> +static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
> +					 u8 tgsz_lg2)
> +{
> +	int ttl;
> +
> +	if (leaf_bitmap) {
> +		/* If TTL is used then only leaves at the TTL are invalidated */
> +		if (!is_power_of_2(leaf_bitmap))
> +			return 0;
> +
> +		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
> +		if (table_bitmap) {
> +			int table_ttl =
> +				arm_smmu_bitmap_to_level(table_bitmap) + 1;
> +
> +			/*
> +			 * A range invalidation with !leaf_only clears out all
> +			 * table levels above the leaf level ttl only.
> +			 */
> +			if (table_ttl > ttl)
> +				return 0;
> +		}
> +	} else if (table_bitmap) {
> +		/*
> +		 * Table-only invalidation. Spec says:
> +		 *  For operations with Leaf=0, invalidation of cached Table
> +		 *  descriptors for the address and scope additionally occurs at
> +		 *  levels between the start of the walk and the level before
> +		 *  the last level given by TTL.
> +		 * Choose a TTL hint that covers the only target table
> +		 * descriptor levels.
> +		 */
> +		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
> +
> +		/*
> +		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
> +		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
> +		 * since we don't know what instance this will be applied to
> +		 * yet.
> +		 */
> +		if (tgsz_lg2 == 14 && ttl == 1)
> +			return 0;
> +	} else {
> +		/* Both bitmaps zero is not allowed */
> +		WARN_ON(true);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Assumes the page table is formed properly and does not trigger the
> +	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
> +	 *
> +	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
> +	 * 0 cannot be hinted because ttl=0 means no-hint.
> +	 */

nit: This isn't strictly true for the non-range invalidation operations, so
I think it would be handy to have a big note saying that this function only
works for range invalidation or even stick "range" in the function name
somewhere.

> @@ -2917,12 +2998,17 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>  				  size_t granule, void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = cookie;
> +	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
>  	struct arm_smmu_tlbi tlbi = {
>  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> -		.iova = iova,
> -		.size = size,
> -		.iopte_size = 1 << smmu_domain->tgsz_lg2,
> +		.start = iova,
> +		.last = iova + size - 1,
>  	};
> +	u8 table_levels =
> +		BIT(arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size)));
> +
> +	tlbi.table_levels_bitmap = table_levels;
> +	tlbi.leaf_levels_bitmap = table_levels - 1;

I'm having a tough time understanding this part. Specifically, I'm trying
to work out what happens if we end up doing a non-leaf invalidation at the
PGD (1GiB) level with leaves at the PTE (4KiB) level. In that case, don't
we need to have table_levels describing both PGD and PMD levels so that
the TTL describes the 4k leaf entries?

Will
