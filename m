Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1113451CF;
	Thu, 30 Apr 2026 03:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519553; cv=none; b=Q3WEMGN2VEA9RYn4rXxxAVvhxhfBeD7zbhUyn5M++8j7I7eMKC/rHWjP/P0YugalCOCi98wvvifUM8GzkuatZgUDGkm4ZzbXrAPBmLOglLZ4C1EElh6PjgP6cSsnlaPtgMjk1A3ZqnLFGFXreXOnaqBAIbVkG1EwsVLuCRJt30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519553; c=relaxed/simple;
	bh=UFNQ+eqES3FdywXU8kIe7qagA+tevwyPVBu3bpMtz3Q=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RLl8Xs/og+x9cvLjqYU0qZcDPF76PfiBFv3LcQha694g4qaNFnC2bsbb/Lmh4PKCID8DsFL9KZeBM40i/54/3fPZHF+nWxv9yVYY2AS1ffOQ81RbP5Zxyc/tH5egsBe5Eklas+9ywVvK6nBqb8L+PgphZ2lmwHVsKoiXVGpOhpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+qPrlwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+qPrlwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEE6C2BCC7;
	Thu, 30 Apr 2026 03:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519552;
	bh=UFNQ+eqES3FdywXU8kIe7qagA+tevwyPVBu3bpMtz3Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=g+qPrlwnaTfz03fVQHOfWhV2wGp5L+rATgExj6wfLoBx2agS+DrxKeWND9xYvDG0w
	 WVfntITuxkw1gLnTLRorfRxJazpVcTpqq3Ei3kc0ke7jQDxXkJ1q0I8wkfd4kvF+Y9
	 VH6PvGhXWRf2t1NmWxuVIbtgP3d/iypZx3spWQkibuEhqQNo+a9A4lblnDHar1U+2a
	 uYCacUVEhknqyxYY0gC4Xaua0C6IPTHQvwp33RJpXw/hlfa4jTUawBS7ATARqaA061
	 /7EpEN8Qd8GmDiRGfPX3fZ/BFkdquyx7Dy1ijqyufgQEwZOFBvHwJWH9P6P1nyKQsQ
	 SNC8aXKCgt3oQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FC983809A07;
	Thu, 30 Apr 2026 03:25:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/6] Convert riscv to use the generic iommu page table
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751950779.2274119.4057431786381222118.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:07 +0000
References: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-riscv@lists.infradead.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 iommu@lists.linux.dev, joro@8bytes.org, palmer@dabbelt.com, pjw@kernel.org,
 robin.murphy@arm.com, will@kernel.org, ajones@ventanamicro.com,
 jroedel@suse.de, lihangjing@bytedance.com, luxu.kernel@bytedance.com,
 patches@lists.linux.dev, tjeznach@rivosinc.com, vincent.chen@sifive.com,
 xieyongji@bytedance.com

Hello:

This series was applied to riscv/linux.git (fixes)
by Joerg Roedel <joerg.roedel@amd.com>:

On Fri, 27 Feb 2026 11:25:35 -0400 you wrote:
> This is a fairly straightforward conversion of the RISC-V iommu driver to
> use the now merged generic iommu page table code.
> 
> It brings support for SVNAPOT which is a 64K contiguous page. Otherwise it
> should not change the behavior.
> 
> The series disables SADE as the dirty tracking support is not implemented
> in the driver and should be done somewhat differently. The generic code
> gets further along though this does not include the format implementation
> of read and clear dirty.
> 
> [...]

Here is the summary with links:
  - [v4,1/6] iommupt: Add the RISC-V page table format
    https://git.kernel.org/riscv/c/e71e00127110
  - [v4,2/6] iommu/riscv: Disable SADE
    https://git.kernel.org/riscv/c/e93e4a6363b8
  - [v4,3/6] iommu/riscv: Use the generic iommu page table
    https://git.kernel.org/riscv/c/e5ef32191a87
  - [v4,4/6] iommu/riscv: Enable SVNAPOT support for contiguous ptes
    https://git.kernel.org/riscv/c/69541898b71a
  - [v4,5/6] iommu/riscv: Add missing GENERIC_MSI_IRQ
    https://git.kernel.org/riscv/c/c70d20b25ca3
  - [v4,6/6] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
    https://git.kernel.org/riscv/c/7cd0c655f02f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


