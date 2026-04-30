Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B07237CD34;
	Thu, 30 Apr 2026 03:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519572; cv=none; b=GPURpYR7R6ufM5FnKgAuFOHY7NgByHGhIyA2uRwwNE3ktXpZXZRryQ36moxTcNR97u0O6z4rrj+bJ90Br7uVFMLwQRGdhfKPGPs3KMV6q/5RvFNCxvns5Zdfi69TaiyUZ4rkqste2UG7mtPBowoVsfUMq67xib0IX0UJb+VprPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519572; c=relaxed/simple;
	bh=YfC1QZZ/UU6y93F8yKnC0I+PiZBznMVQxb/ENiqO8b8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uFdsQtept1AlQsT642gljeCsUVOLN5bXbS25DCuw4wMqaKCHyriubc54LjaKplN5CkjLgUnmR5euot6H2YzccNGalrkb1dlTDEH5pD8FuxPXAOAw5/1y1RU8DiyHLhtRbf7jztx6S+t55Ma6cVQ/ZeQq8QP3Ot+92mJDLgEqpeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwbKJYTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwbKJYTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22F8C2BCB8;
	Thu, 30 Apr 2026 03:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519571;
	bh=YfC1QZZ/UU6y93F8yKnC0I+PiZBznMVQxb/ENiqO8b8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uwbKJYTRnPuHgHvmKVgiZN5bsbZmlaIPFFlBoSY4hQQVZt2jEssn+r90LgoJKtfVh
	 KYwquO77vUHjYWVQseqKU/ZfPgsvJjnuLok91FGW3PAAStr4I8xkw75ZrLomu6rkW8
	 ZG0ICIO9l8v8ED7E7mUYB4z1+rfgqGIIa92KGoNojnIg6dlrwbekebnofjiZ40Ux6s
	 byVyqhPJXTDD9DZLw0KyoTnPGOpkYrUM3wXgQywkg3pYdcAeUceTsrtQaMdEfovI/R
	 dM3t1lhgAWs7oL8wzCHEhHxEKE0R1jWI7QqtVJQw2jbsuZ15B2PXSOITwn/RMBSQuE
	 6mc9GOTRHcSTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDDC3809A07;
	Thu, 30 Apr 2026 03:25:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] Convert riscv to use the generic iommu page table
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751952688.2274119.13814163549347100067.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:26 +0000
References: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-riscv@lists.infradead.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 iommu@lists.linux.dev, joro@8bytes.org, palmer@dabbelt.com, pjw@kernel.org,
 robin.murphy@arm.com, tjeznach@rivosinc.com, will@kernel.org,
 lihangjing@bytedance.com, luxu.kernel@bytedance.com, patches@lists.linux.dev,
 xieyongji@bytedance.com

Hello:

This series was applied to riscv/linux.git (fixes)
by Joerg Roedel <joerg.roedel@amd.com>:

On Tue,  4 Nov 2025 15:00:39 -0400 you wrote:
> [ It looks like the precursor series will be merged, along with VTD. If
> someone from riscv can test and review this it can likely go this cycle
> too. I couldn't even slightly test it. ]
> 
> This is a fairly straightforward conversion of the RISC-V iommu driver to
> use the generic iommu page table code.
> 
> [...]

Here is the summary with links:
  - [1/5] iommupt: Add the RISC-V page table format
    (no matching commit)
  - [2/5] iommu/riscv: Disable SADE
    https://git.kernel.org/riscv/c/e93e4a6363b8
  - [3/5] iommu/riscv: Use the generic iommu page table
    (no matching commit)
  - [4/5] iommu/riscv: Enable SVNAPOT support for contiguous ptes
    (no matching commit)
  - [5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


