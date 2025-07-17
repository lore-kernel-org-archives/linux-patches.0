Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435DB25A2BF;
	Thu, 17 Jul 2025 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752746512; cv=none; b=jzykCcXgnNI2JaK8FS1XytjTWgvuRwLKX+Mq8F9p104uQKKQvdKim28LrWu2hMAEHXdVNxUAbizU1DZcmuPgQbRD+O/RK/HXrPVCfXtQd1+kSDX6Mi9YM1FSHb08veGA8pVBgcHD9SAQTYXubygdQj1pglkaVbqAbQr22j69Vxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752746512; c=relaxed/simple;
	bh=sVoKi6hLlgnCt8S0NS3zNChb95ppDfaGtAOfDAQ9IrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fXagF4jJA4quCDT5G9sEYS6s6pSuBRgS7uwihBw4kAGuCNN6varaDEnnaEJT7Q0tZoHZvwPDU3yfL/e/r1j9TESVkP8KNUZd2haH1FXNukBHCEaCAWJR61PDF2uotowI8M80cXQ6ipvghsK3WjUrfMdQb9eYpCA1plKxgoeIisQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qemyD5wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qemyD5wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7981BC4CEE3;
	Thu, 17 Jul 2025 10:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752746511;
	bh=sVoKi6hLlgnCt8S0NS3zNChb95ppDfaGtAOfDAQ9IrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qemyD5wTsmfEMDWoG/Lq0SFFFtgJZSFG/heMJg/P0vkYInatJS9sJXtxIOGIODwhY
	 GCo18PIEEZvFQ0diPs2svO9MFaYMV2jdqqHB4MYkvo71Q3qFfpbJb26vc5s5ue141R
	 SDeyzNcKmpovaAACUFTuZX3gYAKcKRG79l7aaH6SRY4tvU8gZSi6fEC2bURMM5wxwU
	 jB/EHIUcz2hr9h0Spa/ljqj7Rkf4UMtbhPFWAxy6hb5A0pR2rxb/hEURzqDryK9inA
	 I/gvYllQBQwcRoxut5DZcMxTzGdisMA//jzDAXwbQ5w+oY8TD3vin/ONPpkHaMekzZ
	 3DWO41a0Awv2Q==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Date: Thu, 17 Jul 2025 11:01:29 +0100
Message-Id: <175274393941.244938.6986955662855715479.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 09 Jun 2025 20:58:05 -0300, Jason Gunthorpe wrote:
> The AMD IOMMU documentation seems pretty clear that the V2 table follows
> the normal CPU expectation of sign extension. This is shown in
> 
>   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
> 
> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
> would have three regions in the page table: lower, non-canonical, upper.
> 
> [...]

Applied to iommu (amd/amd-vi), thanks!

[1/1] iommu/amd: Fix geometry.aperture_end for V2 tables
      https://git.kernel.org/iommu/c/8637afa79cfa

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
