Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13422264A3
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751904371; cv=none; b=q36pP32Ng+NVUARiB6FG1VmtLvopZT8CmWXSj3xInyD5z6ITQF17gsd2FioOt+jDTC1UTZBjqD3XsDZzlrQOyLJZLnVV9XGLorYmU7+2F/FPr6CCFkzxWqImiWPn04dY4Up766QQ205uFj9Q/4HBbVU943MbPHKt+2VHu6TZtYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751904371; c=relaxed/simple;
	bh=A3pseN+cWjBhNJbptOxyEiyi3xCPHOMrgZ1hDobGS/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=deCphyiCpjegtlayBppcH/hPDgdtODtjhgWY2IJHIdEQLPpO2xrbLMIIj2KFMGL8ZrhOlyEXo29jtefgkPQ3iQJka3u//M72nU8KXTn0Pb2r2PIpGGJo9C2v/rWs4spE67BnbKKHW4e1xzAsHMCbqrANbEz1p4TBzETdjeW0gmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 876631BCB
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 09:05:56 -0700 (PDT)
Received: from e110455-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B95193F694
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 09:06:08 -0700 (PDT)
Date: Mon, 7 Jul 2025 17:05:58 +0100
From: Liviu Dudau <liviu.dudau@arm.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
Message-ID: <aGvwZn_EZNnwtxpZ@e110455-lin.cambridge.arm.com>
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
 <20241101134005.GA109739@nvidia.com>
 <20241104113237.GA11481@willie-the-truck>
 <CAE2F3rDcq-BQYM1yYq6RNSYSOovdoyRcbYw8Jy+BXCHLkrWN3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE2F3rDcq-BQYM1yYq6RNSYSOovdoyRcbYw8Jy+BXCHLkrWN3g@mail.gmail.com>

On Sat, Jul 05, 2025 at 01:12:09PM -0700, Daniel Mentz wrote:
> With the removal of arm_lpae_split_blk_unmap, I believe the following
> macros are now unused. Is there any interest in removing those as
> well? If so, I can draft a patch.
> 
> #define ARM_LPAE_PTE_ATTR_LO_MASK (((arm_lpae_iopte)0x3ff) << 2)
> /* Ignore the contiguous bit for block splitting */
> #define ARM_LPAE_PTE_ATTR_HI_MASK (ARM_LPAE_PTE_XN | ARM_LPAE_PTE_DBM)
> #define ARM_LPAE_PTE_ATTR_MASK (ARM_LPAE_PTE_ATTR_LO_MASK | \
> ARM_LPAE_PTE_ATTR_HI_MASK)
> #define iopte_prot(pte) ((pte) & ARM_LPAE_PTE_ATTR_MASK)

Yes, I think these can be removed as I cannot find any users.

Thanks for offering to clean it up!

Best regards,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯
