Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED5E12FF86;
	Wed,  1 May 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714580451; cv=none; b=tDPxXX9mSpZd7/Cy2NVzA/vo6xc6mM16NQcxxCMmCo6+79plXheEbAPFXoz3m1xSlMmpm1Rj5iFt16Ti9wFYfIjatldnHumQpuTBqcVS7VqaJzWb0daBQ3Vk4+3XXxzCEW5FPThoKFXXiaz5YydoVVXbZdYYOPJuJCPNW+lm/BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714580451; c=relaxed/simple;
	bh=ZlN0D8RAa1eZsrJuv9lZAei8y/f3hGPt88SymFQqb3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RkQsuXiDjX/TXgH8hYRLptH2wrmuGczRZhSF2nEViwecEXQurpdOSGnxJr72GfF6CUb8omSyae/DexMEdmPm/JfOlZPo/ByRowV9TV2J0JLqbb5j+3VrLSjlwLBXXkHoJPY+XS7CawF+Nh2YPQCB5YoGzxh3bmsT2BgGIFyYFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkRs1mE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkRs1mE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13377C072AA;
	Wed,  1 May 2024 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714580451;
	bh=ZlN0D8RAa1eZsrJuv9lZAei8y/f3hGPt88SymFQqb3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkRs1mE8t7J/SiZob6avFJsKF0cjbJE8n9E5SYHnkIt4PYCIXVGDJ+jW8KVm5W+72
	 5IBd8QUooHQxiKnZtDNbJIEXxuTnrxaVipiR0Ix1IY9OfzwCX1EDRIg52hQ9r6Oyq+
	 cv4GIYPtJxkbz1oUY6cAa6SVvDKqyDQVdytW/28JQZNKUusLEv5qw2xCOT2Wkmban9
	 G969gKxSBgwlzipOsahdfGfU6aZZ5w52VhXQECjKGAmgpZ3ls/rtG62QghfRU5dGSN
	 RoVVmu1J+2CPxFgQ8B5DZexQSpi2zVzRzjUHUb3VNsVCLu47XWNmDuHM/5ZtAa0uYL
	 +3a1gxWMVTxCw==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v9 0/9] Make the SMMUv3 CD logic match the new STE design (part 2a/3)
Date: Wed,  1 May 2024 17:20:29 +0100
Message-Id: <171456087391.35017.3249073955778510141.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 30 Apr 2024 14:21:32 -0300, Jason Gunthorpe wrote:
> This is split out from the larger part two which aimes to rework the PASID
> related code.
> 
> No new functionality is introduced in theses commits, it just reorganizes
> the CD logic to follow the same design of the new STE logic using make
> functions and a single programming flow without leaking details to
> callers.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/9] iommu/arm-smmu-v3: Add an ops indirection to the STE code
	https://git.kernel.org/will/c/de31c3555412
[2/9] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
	https://git.kernel.org/will/c/78a5fbe8395b
[3/9] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
	https://git.kernel.org/will/c/e9d1e4ff74b9
[4/9] iommu/arm-smmu-v3: Consolidate clearing a CD table entry
	https://git.kernel.org/will/c/af8f0b83ea2b
[5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
	https://git.kernel.org/will/c/b2f4c0fcf094
[6/9] iommu/arm-smmu-v3: Allocate the CD table entry in advance
	https://git.kernel.org/will/c/13abe4faac43
[7/9] iommu/arm-smmu-v3: Move the CD generation for SVA into a function
	https://git.kernel.org/will/c/7b87c93c8b86
[8/9] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
	https://git.kernel.org/will/c/04905c17f648
[9/9] iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry
	https://git.kernel.org/will/c/56e1a4cc2588

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
