Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0D283FFB;
	Fri, 26 Jun 2026 08:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462065; cv=none; b=VNtmdKQbEGM185OKmKaAmn0iGHchDRSLhmHmbHhOb4Uii2ItAvhJTLeS71XR3hS05z5PyfnXYL+6lfRXHCR92ilzDupT4qeoLxpoQ/ensWGaoJa9CIPXc8lJGIBR41mbAPIGch8NyVK/XriQl1Zc80YcYFWIubLX1stlwpnOdbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462065; c=relaxed/simple;
	bh=8sc6cxuR3tk2T90p8ARBnlmi1Acg6LbP52gCsMdVs0M=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=p5DM5FCQuWskeEuVW1Xh4OTeWBLIOI0Hw1B9OJtafJWqj9Bb9dnwWvLnDEk5/6fCcmkjOTdMJC37bQPBmx6L30OewU4BQcdSmR2oGEco19w/hNzZRrEJgCvoU5A+CDXxf19Orsvz4LdOnGpfJUlZx3+Gu1m2MgHqp34VWVUbKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PClxCafl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PClxCafl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E41F000E9;
	Fri, 26 Jun 2026 08:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462064;
	bh=+YfZ76r2ksaV8Km/IBCLkq4BDK1sE4dAu4lNJUrn33E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=PClxCafl7uU6D140WFTcVLHSe+JnE8XVg1bEtWxqtnVqcc0egtLYo7WqqboEO4D7m
	 DeNOsV4ecE44NXMKAYEJZHFzYP96iaQGVvusNZQGekuqmDZJ02cf0KZdw62YJ7AtwH
	 T6B8jxwwgQbXcCahcJ4iYjA4RmRQ58nnNwP1SCwHLjxA6Fi6IGc9h3dN1bJStX1beh
	 e4r025iZ0taPA+LXTdOT5t9Wj6Db44RJLkJpS80I4blWQtBjw9XKRTf6gzvNlsM8VX
	 I6JM4SbMLJQ6EkiBnzKai7KtSU3j6PnouZlYJUqH0cTI+zVc40aaFkoNHEWVZxHT1J
	 TphSLdkrHIBHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8FE2B39389E8;
	Fri, 26 Jun 2026 08:20:52 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/8] Support non-leaf and range invalidation features
 in
 RISC-V
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246205139.3816447.9006141630589978031.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:20:51 +0000
References: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-riscv@lists.infradead.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 iommu@lists.linux.dev, joro@8bytes.org, palmer@dabbelt.com, pjw@kernel.org,
 robin.murphy@arm.com, tjeznach@rivosinc.com, will@kernel.org,
 andrew.jones@oss.qualcomm.com, fangyu.yu@linux.alibaba.com,
 patches@lists.linux.dev

Hello:

This series was applied to riscv/linux.git (fixes)
by Joerg Roedel <joerg.roedel@amd.com>:

On Fri,  8 May 2026 11:52:59 -0300 you wrote:
> This is part of the patch pile to get SMMUv3 moved to iommupt. From
> that perspective it introduces the PT_FEAT_DETAILED_GATHER which will
> be used by both RISC-V and SMMUv3 to generate optimized invalidation
> commands.
> 
> I don't have any RISC-V anything so this needs to be tested by someone who
> does.
> 
> [...]

Here is the summary with links:
  - [v2,1/8] iommu: Split the kdoc comment for struct iommu_iotlb_gather
    https://git.kernel.org/riscv/c/74c9d82c7e3f
  - [v2,2/8] iommupt: Add struct iommupt_pending_gather
    https://git.kernel.org/riscv/c/f0e4b7f5f875
  - [v2,3/8] iommupt: Add PT_FEAT_DETAILED_GATHER
    https://git.kernel.org/riscv/c/89792629d4b2
  - [v2,4/8] iommu/riscv: Enable PT_FEAT_DETAILED_GATHER and pass gather to iotlb_inval
    (no matching commit)
  - [v2,5/8] iommu/riscv: Compute best stride for single invalidation
    https://git.kernel.org/riscv/c/bb62adcf4513
  - [v2,6/8] iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
    https://git.kernel.org/riscv/c/e4084c6bbb42
  - [v2,7/8] iommu/riscv: Include the dword number in RISCV_IOMMU_CMD macros
    https://git.kernel.org/riscv/c/835d06ee7ef0
  - [v2,8/8] iommu/riscv: Add NAPOT range invalidation support
    https://git.kernel.org/riscv/c/082ad5ed0785

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


