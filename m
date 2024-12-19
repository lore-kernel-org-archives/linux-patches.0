Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C68A1ACECE;
	Thu, 19 Dec 2024 19:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637657; cv=none; b=kMkFvmGzIS9KUqOfHctTFkmGMo+GgkI0eqPxulHFni0VG/P0ljylkWMxHuAWYz9CZR3a2JNczF/dqreYHoXW9JKKf2jSbItDhZZMDpxfUHkgT233kK4BLW/cpLrcBAV0fDh/bA+D4Sozfe6yhTDVd5LaZKGEyFevAzM2Zkn4iEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637657; c=relaxed/simple;
	bh=n6fXX5iTrXVlOQZyCTM9uWLSoLQaF9F51R34lpyH96Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oePasAhxTZU17XXaZXLVifeuj3tX8GDmZRJ+I6EfV6OXdhrJu2ME7ApZKnCXBu8v+Nw7FXkFjbnxC0sRxha2yQZPpiJOAHtQc+QGcOgZHr9woGiLniTqKw1rf062g0stE2f+JwMamUPzJvSbHpGxTAbYd2QDvwygHkRkh5lIko4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGFpgnCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGFpgnCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D3AC4CED0;
	Thu, 19 Dec 2024 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637657;
	bh=n6fXX5iTrXVlOQZyCTM9uWLSoLQaF9F51R34lpyH96Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGFpgnCPFV7xeFXDkuH5D9jtMK39U2xQ1OoO/jq379E59s0SlR8UymO3id8whAqVH
	 Fu+e48vSHmm2lCQkSHrEMRpMIGgubREiyVja0/AuBvlsAe4UZRnKtXeFwI0T1JGZPf
	 8QaHNtKYwdkbVG541n76EQK9iioqPxS/boTgEv0gDNNtOX8cuuyodTrIJGDhJ/F99g
	 ZZWW31sS8J9RDdBIhXODoie6Wx9ZvHOLei+Owc2N18hteqlA96GK18XlbskH9K8T0h
	 HBZ0tDWwwtf7qDIE0CH21/HQ3euzIMDCFZFEnIWmfdnE6JlKGfvZ1KSmgJ7j335fnl
	 t8n+A9U0R4Q7Q==
From: Will Deacon <will@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	robin.murphy@arm.com,
	joro@8bytes.org,
	thierry.reding@gmail.com,
	vdumpa@nvidia.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	ikalinowski@nvidia.com,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding
Date: Thu, 19 Dec 2024 19:47:11 +0000
Message-Id: <173462305169.3912600.1369814969067145717.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241219051421.1850267-1-nicolinc@nvidia.com>
References: <20241219051421.1850267-1-nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 18 Dec 2024 21:14:21 -0800, Nicolin Chen wrote:
> The hardware limitation "max=19" actually comes from SMMU Command Queue.
> So, it'd be more natural for tegra241-cmdqv driver to read it out rather
> than hardcoding it itself.
> 
> This is not an issue yet for a kernel on a baremetal system, but a guest
> kernel setting the queue base/size in form of IPA/gPA might result in a
> noncontiguous queue in the physical address space, if underlying physical
> pages backing up the guest RAM aren't contiguous entirely: e.g. 2MB-page
> backed guest RAM cannot guarantee a contiguous queue if it is 8MB (capped
> to VCMDQ_LOG2SIZE_MAX=19). This might lead to command errors when HW does
> linear-read from a noncontiguous queue memory.
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/tegra241-cmdqv: Read SMMU IDR1.CMDQS instead of hardcoding
      https://git.kernel.org/will/c/e94dc6ddda8d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
