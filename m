Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232D1171D2;
	Tue, 10 Dec 2024 00:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733789858; cv=none; b=fUovr8clbpEJLRmomD+PXXWjULYgTf2fscPwCLCOxrUasNW0EqL1i2p/x5JUVdW7NhsH5LLlaRfQ/SHtS+NT3lbr4yr5IhXs/iKZ5srnlHNjLwGt4swB4AglSvyZ1AAnl32xXol+wC4BcCXdsExAGZ0TVGNc9Wcymy1Ky4M+RK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733789858; c=relaxed/simple;
	bh=lSFohh6EEzkapzsoFRJjsaUOUmAfNgO9Vcd4zWYdiWA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGFEDhCkZlHDXwJVEN8c3Dvpp1+uJSEH3Tzc6MHgnDzWLgdBU0EbkhlQ/+c8HbiWQjPUwmSbdeI//zYSskuY4npVCKJGsmUbPQwyrlkH3aVLt0WyHgksEe2reiQrHPWJObMm8q+7hASk8001xZGDbvzNrBsKsC8EP8K/EZz8SFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSip9Vr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSip9Vr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F7AC4CED1;
	Tue, 10 Dec 2024 00:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733789857;
	bh=lSFohh6EEzkapzsoFRJjsaUOUmAfNgO9Vcd4zWYdiWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSip9Vr5cEcHTGp8skeF2R+vmYNJK0fOli0FGaS4B4/2jFR6uUr9Ar9oxFRhhZ0XG
	 h7DnSPZBbPEir7yU6wi5F3gVaxCUUvuih9pgU9oRcvvUm5cdokOwAANoKfuy8TVehD
	 AtwBSYcG7WMUJXdTCLIQg9htAFXdzsZSg5dSDfMo8ZD9k7Hf0mPWfh8YRrwbPGRs5c
	 1hZl1fhmqQ51axqxuoDdqEsMThQLf08L6MqtIDYXVHUttOqY5qyCFbRhymWXVl85y4
	 70Zsm1C0qR+F7Aifyte5ixGte4GNOMas6cWVojmJDdxDitrNCUekC9WsMclLz8RTsK
	 YLXjPWZfcXKAw==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/3] iommu/arm-smmuv3: Update domain_alloc_paging_flags()
Date: Tue, 10 Dec 2024 00:17:26 +0000
Message-Id: <173378567932.4189360.5507988351679593105.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
References: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Dec 2024 11:43:26 -0400, Jason Gunthorpe wrote:
> The last cycle saw the removal of the NULL device during domain allocation
> and the introduction of domain_alloc_paging_flags(). Update smmuv3 to this
> new design.
> 
> Jason Gunthorpe (3):
>   iommu/arm-smmu-v3: Remove arm_smmu_domain_finalise() during attach
>   iommu/arm-smmu-v3: Make domain_alloc_paging_flags() directly determine
>     the S1/S2
>   iommu/arm-smmu-v3: Remove domain_alloc_paging()
> 
> [...]

Applied to arm64 (for-joerg/arm-smmu/updates), thanks!

[1/3] iommu/arm-smmu-v3: Remove arm_smmu_domain_finalise() during attach
      https://git.kernel.org/arm64/c/48e7b8e284e5
[2/3] iommu/arm-smmu-v3: Make domain_alloc_paging_flags() directly determine the S1/S2
      https://git.kernel.org/arm64/c/bb857c5c0150
[3/3] iommu/arm-smmu-v3: Remove domain_alloc_paging()
      https://git.kernel.org/arm64/c/cdfb9840fcc6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
