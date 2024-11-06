Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EB220409E;
	Wed,  6 Nov 2024 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730908413; cv=none; b=kSyCUcVflnhyYbueATjDVXBfz0wkc8X759tomlUnNhlqKBviI96rDzB4sHDZ2iGf0rw9nlxzTy0kmXcGuZVMJpoEgn7co4Ax9dSXrLaSrSCOAheoz+CXBe/Hwo3OOvs2bTEglquHPmszohkHuqG4mqgpjwRrWCKPLexOcoQktvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730908413; c=relaxed/simple;
	bh=Eg7TVMu0q5lzDUTXHhoiurM6aMX5DshN2Hm+8U2txNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eej4AeMEMsscQdjR4OETbbUz3gjspJnm8yPrbLfq4xzwhUFbPE99Qgd0yXt4UiiDkXPYjCPyDEtK69HLgKUsoX04a/H2szRzgHKdDnJh1+mjzK77hR+RXV4DF7vVB9gsraxWViymR3TEHvQ5X7KRVtbrzsTdxlrc5sFKiA1BAAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xy+3mwjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xy+3mwjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DDAC4CECD;
	Wed,  6 Nov 2024 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730908413;
	bh=Eg7TVMu0q5lzDUTXHhoiurM6aMX5DshN2Hm+8U2txNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy+3mwjAla+PCpUgJIAWjVJvAxy/sWMdntHcLHXg4t4MBCLlQUKPUTdEBJ9xKed5t
	 Ks2GXpv5XKfiadr4Px/0LuF5VWyVKBfOsYc55xuB2UVnQ620qanS0fhmo/LFzJ/8L4
	 ZUmueb01LhGr9wKA1zJu2JaXIa9WP97ov5IJ+kWHmFDQluN2YatgrwxJKSZ99SGlQJ
	 BufjhA3pihT4TISQ93n9mihnSxXrXjGOWSakfKuTtraNBX2kDuNhnNz75plYmxWW5a
	 ogtXlWD70w7ub8mCGvZLUkmq0i9nvHF7OKPnuAcugmbyV6wxbomkjh+mh/hSmS8ga0
	 BovKWFWogz5Rg==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org,
	Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 0/3] Remove split on unmap behavior
Date: Wed,  6 Nov 2024 15:53:23 +0000
Message-Id: <173090505900.4167208.10850898110820689849.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>
References: <0-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 05 Nov 2024 14:14:23 -0400, Jason Gunthorpe wrote:
> This is the result of the discussion on removing split. We agreed that
> split is not required, and no application should ask for anything that
> would not unmap a full large IOPTE.
> 
> Instead of split the two ARM drivers will now WARN_ON and return 0. This
> is in contrast to what several other drivers do of removing the whole
> IOPTE and returning 0.
> 
> [...]

Applied to iommu (arm/smmu), thanks!

[1/3] iommu/io-pgtable-arm: Remove split on unmap behavior
      https://git.kernel.org/iommu/c/33729a5fc0ca
[2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap behavior
      https://git.kernel.org/iommu/c/fd50651636fb
[3/3] iommu: Add a kdoc to iommu_unmap()
      https://git.kernel.org/iommu/c/6ac7dffe7cca

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
