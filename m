Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD84DB665;
	Tue, 10 Dec 2024 00:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733789860; cv=none; b=eo+t73Lp6/s3pfkBr+Kc/IrzTFSB6z+6fh6N7JfWv9oCB2GJLverY13HnOFBdVKkx9vcr92wY71XphGIJrIV3rx321nSYYCE3ZGigXCZSbHMd9r6D4SPdHgyVkQUv/uf51SKJhm2KceiZGQ3pFfUjhASnPdwUwUrYSZY/OJtEkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733789860; c=relaxed/simple;
	bh=NP473M91KfDU5hAbkVpyFF0JS9tQapuKfRqfLoOzGtA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ob7BR6Piy4cXwOXJYEFHeUHyekdtrs7EaUehPk3imZ5NbtA6PXSC1WfMMdmSHrE+h15mZO9cMg9Kv+IAnuvqWjfVWh0KU/aJPqM9lvnmXGDwo0vYM+xtOI/5fwXk7cSr8ul2n8ipFSdYXt4CYXNI36fNQrkvDI22oVD9L2MTb1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDVfORut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDVfORut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F623C4CEE0;
	Tue, 10 Dec 2024 00:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733789860;
	bh=NP473M91KfDU5hAbkVpyFF0JS9tQapuKfRqfLoOzGtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDVfORutvSU532Nrnz9oMLZZaXBASMmecU6EPI6cu2iXUWjbffC2s3iSrc0eA3ikK
	 t6IB70kecdz6wQE2MX2hAcBXkc4O7J45203xCTKOyVzXVgiThv41/QYWP2D/H8qQru
	 SP7JbB1IrEWZ/5GD4mbwNpF1lrAiLkINqaFEe1BKUq7gYqT5JvhjfRg9cNUZP1gfSN
	 yEPYpidYlxkzYCHbFvZn7pd7v5gp2Q85jVNTATtmZCceilAjiA8tY5frxs6aP87wNA
	 sSIneVYRs52/17P0h6txb97tvz8tWYr3ck0KDQAmwi/ErsP8fc1WlJEqw7gFuB6wbX
	 3a5YcFMbi6Wxw==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH] iommu/arm-smmuv3: Update comments about ATS and bypass
Date: Tue, 10 Dec 2024 00:17:27 +0000
Message-Id: <173378410349.4185561.4875058023954953472.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v1-f27174f44f39+27a33-smmuv3_ats_note_jgg@nvidia.com>
References: <0-v1-f27174f44f39+27a33-smmuv3_ats_note_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Dec 2024 11:40:15 -0400, Jason Gunthorpe wrote:
> The SMMUv3 spec has a note that BYPASS and ATS don't work together under
> the STE EATS field definition. However there is another section "13.6.4
> Full ATS skipping stage 1" that explains under certain conditions BYPASS
> and ATS do work together if the STE is using S1DSS to select BYPASS and
> the CD table has the possibility for a substream.
> 
> When these comments were written the understanding was that all forms of
> BYPASS just didn't work and this was to be a future problem to solve.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/arm-smmuv3: Update comments about ATS and bypass
      https://git.kernel.org/will/c/9b640ae7fbba

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
