Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047AB12FB18;
	Fri, 19 Apr 2024 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713540798; cv=none; b=Ucq3lxtEu4UXz501nvHsvob5aPMvy1RAkTk04uSDl2QT16UKxO96oAwT32IvL1fRnkKMdRVsHCN8mWQkBc5E5KEE493lYiY6szhRxO5jvilbBnR+UuFgsHMjN0IO+ppyOwW/qQrSaT++qIZ9GkpHw4RvO5mqzHclRx9MpYS3Qqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713540798; c=relaxed/simple;
	bh=UV8lA/6deS6AcWH+mFYHvm9RlFdafVavLYUZyrTrMKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7rNlF4WQf2S0rnfMhj/PlgMy+0b0kB4RzivORUTjQifyg9WlupoAgut5N4NkDng5xPvSYGwg8ItXWR0omGaPlFVbEoP7s6KT6ZSv1klB/gjXs1qwtbJ8LZxOHYbHWUwo+LXTncCQw0CfhEEM7FD2eK6uiZbcUCNjfX8HzoeNws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJTkAnlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJTkAnlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38DAC072AA;
	Fri, 19 Apr 2024 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713540797;
	bh=UV8lA/6deS6AcWH+mFYHvm9RlFdafVavLYUZyrTrMKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJTkAnlOwMNMHGlD9vrrDMv+5lzJul4g+9r3kauhakLufOpNXA+cshK2GsBCC5csW
	 l37A7LLev00EyOtX+vfKHSs6DxylyeEGom2oCrtlULK8A5Sk0pYZwCMKDOxbcvYlxf
	 zr4s3YLZQCpuXMvBGXkWAOwkNGnmvQ0r7a2d19D76DGMLV0HJ2C6MiDj4MUWWFV4D8
	 46m0zPm3HICtwza759S+MtjqDB1JGud8z9Qzt4Pkd8mRiK5LR6tD9Qt7SFNTCFQmN2
	 Qre/8RTL1IlAACc7+l2Hx6A87xsF/70JiGgVxv4076ozGoNuKkKnzWFiEX0uRimG5s
	 Oqnxdz83bVeqg==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu: Convert to domain_alloc_paging()
Date: Fri, 19 Apr 2024 16:32:59 +0100
Message-Id: <171345075861.300380.113926608276493245.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v1-3632c65678e0+2f1-smmu_alloc_paging_jgg@nvidia.com>
References: <0-v1-3632c65678e0+2f1-smmu_alloc_paging_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 11 Apr 2024 14:12:11 -0300, Jason Gunthorpe wrote:
> Now that the BLOCKED and IDENTITY behaviors are managed with their own
> domains change to the domain_alloc_paging() op.
> 
> The check for using_legacy_binding is now redundant,
> arm_smmu_def_domain_type() always returns IOMMU_DOMAIN_IDENTITY for this
> mode, so the core code will never attempt to create a DMA domain in the
> first place.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/arm-smmu: Convert to domain_alloc_paging()
      https://git.kernel.org/will/c/d75d7dc26f29

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
