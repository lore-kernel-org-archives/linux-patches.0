Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E5359A80;
	Thu, 30 Apr 2026 03:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519550; cv=none; b=J7rdoTRuXf/2Ikpfi8MFnIFVJ45NnNouAququuDu+fLAsOTxPZOd/gDrennj2F/+axssi4dYuF76Bg1ANe4bzUrKDUBwFpk8SMXS2HrPgjFjVLVdCbS1HWXKN+WFwi0Q1vA3nH/cmkcsGscw99Xw0swJm+/XaUhe1xKAQ7aQ3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519550; c=relaxed/simple;
	bh=bf9N1lmqNBRR4cIVIcMxpRMRBVYaYxFxFZFFSaNWAbo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RYZfmctHtekOwmPJJRk8illoRswCJvLwfXPElbXq5hYChOVgI0Xm0AMHyUa7epm55R9Vbk65ecfUhUfrOzvKWOWfRI9dna92vv8qAFX87Bq1lcGW7hWnS9pycJoX0gfGPnuVTD0JQcOo0QqUk8yGmCIVR/pOm196ClVz6zDIW2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQg9tw19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQg9tw19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227AC2BCC6;
	Thu, 30 Apr 2026 03:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519550;
	bh=bf9N1lmqNBRR4cIVIcMxpRMRBVYaYxFxFZFFSaNWAbo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sQg9tw19l26pKIEAaTWTTrMrVng1y8CfhjVkuxiL/K8qDP/2sWlnpq1Q2MwIv88DY
	 lRX+ec3eDXDHDGtsvrU0OmCpk2dKd6zzLsnNeve7SjamJ1zLcSI2H6inxNWVd4nA9e
	 FTogk1HoPUVrHXi5P9gJNdfFgCZr/PxAlezY/CYGu3vvQ3GT308ccyX3/mVX7GIlfK
	 iy5Jsym+EFDKXgoOnT2OWLTEyC4n6opnRobjCbRMLqYJPS0Ug4VY9gUcH8SsAROvnG
	 37yoqS0fi+Aiis7mglxA0RWdpjKwpnBvvDfbrJNnX5yL8Lr+xqW+r8U7Hc4vjk3UK6
	 ygR+y8wx1Z4LQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD2F3809A07;
	Thu, 30 Apr 2026 03:25:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iommu/riscv: Remove overflows on the invalidation path
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751950479.2274119.1171635926750026675.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:04 +0000
References: <0-v1-0f76ffba5af6+11540-iommupt_inv_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-0f76ffba5af6+11540-iommupt_inv_riscv_jgg@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-riscv@lists.infradead.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 iommu@lists.linux.dev, joro@8bytes.org, palmer@dabbelt.com, pjw@kernel.org,
 robin.murphy@arm.com, will@kernel.org, baolu.lu@linux.intel.com,
 jroedel@suse.de, palmer@rivosinc.com, patches@lists.linux.dev,
 tjeznach@rivosinc.com, zong.li@sifive.com

Hello:

This patch was applied to riscv/linux.git (fixes)
by Joerg Roedel <joerg.roedel@amd.com>:

On Fri, 27 Mar 2026 12:22:10 -0300 you wrote:
> Since RISC-V supports a sign extended page table it should support
> a gather->end of ULONG_MAX, but if this happens it will infinite loop
> because of the overflow.
> 
> Also avoid overflow computing the length by moving the +1 to the other
> side of the <
> 
> [...]

Here is the summary with links:
  - iommu/riscv: Remove overflows on the invalidation path
    https://git.kernel.org/riscv/c/40a13b499579

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


