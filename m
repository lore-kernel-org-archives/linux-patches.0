Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF61C168CF;
	Mon, 11 Dec 2023 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o951Ph+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EDDC433C7;
	Mon, 11 Dec 2023 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702318535;
	bh=QrMJ9Vv7yAyhkvVCuIw3AcS5ZtY5Zo9TvtZGKmhgUVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o951Ph+ILqUngQX2fnHwoJHxd5ECE8ZuIqtPvkdlFu7lMEMHH3yP9gv4Yc6I82Gfw
	 L8DLyDDtcXAWd3HWFixv/XM00ypDCxaA9o1Jo35NMAuMRsswxTrWO91cBVvPFTjxbK
	 vvd8P9GY3F5NMEwCbb5v7BhFmMAiTJ+iHdoSbA2rcvp8NXkQ4gXIM/0MWpLEvF6x8Z
	 Vb2/eBKBMTHOrFSkzAPx6ZVm/qld4hBkqRyQyCE/Qjpy84fByihe3AKf6+L2tc3i5k
	 A+m0zvoCTfBbvSTGFjxek24e7hq6wjznBvygjXKyslKPheoOSZjRsndJfbUPYT9vDN
	 INUhGo8WnShHw==
Date: Mon, 11 Dec 2023 18:15:30 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <20231211181529.GA26462@willie-the-truck>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <20231211180324.GA3012960@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211180324.GA3012960@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Dec 11, 2023 at 02:03:24PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 05, 2023 at 03:14:32PM -0400, Jason Gunthorpe wrote:
> > All parts are on github:
> > 
> >  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> > 
> > v3:
> >  - Use some local variables in arm_smmu_get_step_for_sid() for clarity
> >  - White space and spelling changes
> >  - Commit message updates
> >  - Keep master->domain_head initialized to avoid a list_del corruption
> > v2: https://lore.kernel.org/r/0-v2-de8b10590bf5+400-smmuv3_newapi_p1_jgg@nvidia.com
> >  - Rebased on v6.7-rc1
> >  - Improve the comment for arm_smmu_write_entry_step()
> >  - Fix the botched memcmp
> >  - Document the spec justification for the SHCFG exclusion in used
> >  - Include STRTAB_STE_1_SHCFG for STRTAB_STE_0_CFG_S2_TRANS in used
> >  - WARN_ON for unknown STEs in used
> >  - Fix error unwind in arm_smmu_attach_dev()
> >  - Whitespace, spelling, and checkpatch related items
> > v1: https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com
> 
> This hasn't changed significantly in the last three months, so I feel
> done now. I think Eric may still have a formal Tested-by for his
> Fujitsu system to record the run he did.
> 
> Will, we are waiting for you to say something so we can shift review
> and testing focus to part 2, ideally in January. Many people are
> waiting for this.

I'm sorry that you're waiting for me, but I'm snowed under with other
changes and the arm64 tree is my priority at the moment. This series _is_ on
my list and I appreciate that you've got some review, however the fact that
you seem to be lacking any comments from the usual SMMU folks such as Robin
and Jean-Philippe does make me worry about this series to the point that I'm
not prepared just to pick it up without a thorough look.

It sucks, but I don't know what else to tell you.

Will
