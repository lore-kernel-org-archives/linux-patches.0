Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD41DFE3;
	Tue,  2 Jul 2024 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719945852; cv=none; b=l4WOm5z2UxSiDH3ybeGkFVqbA8mOEloVlVGL45wzodN+LogH/A4aW+LXapdjzW6VXJ1jsVUlj0X/p4WvZcq3CmqzhrTvqjYMs7PjPKRMPRXoJ+ZQdlVbvC0oVCwXX7bY6pM1FhuDhQwlzlxb1J17SQnCo16Z85nMgAOIxTRaGDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719945852; c=relaxed/simple;
	bh=/5GZtjF9qjU9eTXWrxSuMBTVrsE4ll/KrD9Z9X6VDz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtI/NCsA4Dg3+2jyx8FFc3k4O2eSXw5nd2q9KYWilXjWnXvzfdMOaRvrt/Yty/069yUKecYq73ymVSJ/NU7b9mLeiQIN4k5hZbGJB7gyhnDWwreFZTo9g21ivQ4NySxeDNgCoIQnKaC4mSAPEZHEysz4hpmgYAbMl/i0+xajW38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhzCE5AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhzCE5AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34951C4AF07;
	Tue,  2 Jul 2024 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719945852;
	bh=/5GZtjF9qjU9eTXWrxSuMBTVrsE4ll/KrD9Z9X6VDz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhzCE5AT7CiEk8Ikh5UY3pkckHkfh83GzYET38iMbJYEcaF3zqmHufHNsmr8yuMvv
	 TGV/M4avPXDFG23aDKO80VrTB5KtmbM+ZIVj3B7IBbyfBRzespAHVzsYo/CNxBnW2Y
	 67x9p1TgUxNwxg1BiWiI2BCQR1J10p1Psk8kTUsZi1p71vTm/xtI0R4V5La63i0YSv
	 5neQiruD3Y4EfNW6pgsa4WgftdlCGwK0dHO25uGPbm4L5q3KfEweKFcFvaRgErxetr
	 uKGEYIg7wzH0cboXf42mVIORtAtBauhWXsW1CZpOAzjVkgwxEBCinf31SmEOVfZ7jb
	 5lXe19W75OyYg==
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
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 00/14] Update SMMUv3 to the modern iommu API (part 2b/3)
Date: Tue,  2 Jul 2024 19:43:58 +0100
Message-Id: <171993119078.3391106.2602141691668707805.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Jun 2024 09:37:31 -0300, Jason Gunthorpe wrote:
> Continuing the work of part 1 and 2a this part focuses on the PASID and
> SVA code bringing these functional improvements:
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
        https://git.kernel.org/will/c/678d79b98028
[02/14] iommu/arm-smmu-v3: Start building a generic PASID layer
        https://git.kernel.org/will/c/85f2fb6ef413
[03/14] iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
        https://git.kernel.org/will/c/ad10dce61303
[04/14] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
        https://git.kernel.org/will/c/7497f4211f4f
[05/14] iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
        https://git.kernel.org/will/c/64efb3def3a5
[06/14] iommu/arm-smmu-v3: Do not use master->sva_enable to restrict attaches
        https://git.kernel.org/will/c/be7c90de39fd
[07/14] iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*() interface
        https://git.kernel.org/will/c/1d5f34f0002f
[08/14] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
        https://git.kernel.org/will/c/d7b2d2ba1b84
[09/14] iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
        https://git.kernel.org/will/c/49db2ed23c52
[10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
        https://git.kernel.org/will/c/d38c28dbefee
[11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is used
        https://git.kernel.org/will/c/ce26ea9e6e12
[12/14] iommu/arm-smmu-v3: Test the STE S1DSS functionality
        https://git.kernel.org/will/c/3b5302cbb06a
[13/14] iommu/arm-smmu-v3: Allow a PASID to be set when RID is IDENTITY/BLOCKED
        https://git.kernel.org/will/c/8ee9175c2582
[14/14] iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
        https://git.kernel.org/will/c/f3b273b7c7e4

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
