Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD43384;
	Tue,  9 Apr 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712667308; cv=none; b=pEpN4fJyGsD0V+g46HelZTI4YXcESH8RTM+44D0X9qWVl1NNfdqAIJXN3J1e5VBcZaExHEDIQ7Sd/aFUkOVXcUhSWtl1LChpU67VnQt8p7vCmrdJ4oF6SosTE0KGGaesU5Y8f4p8nCLdkRtdTEnsp9/0baoWlcG5pbPQWs2D5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712667308; c=relaxed/simple;
	bh=buB17AEIHw4RKpCZSUmtgyTvF/xyD0a0CGkVGXfyPc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTSFAdDn3sjqsZTh3hS8xjPDWqlJq8xYzBaPAslW/9brsefbTEQYthLuK+4Y7E+ta1TSslRE/kakHXo5AUMwxs67Ic5uBA45lurW3dLEZOk/WVR4m0ZgaNPyn0rW80BhfQnS3i+pRYXV/gZxBPClyhv3OcJy45T6ltEuZwrpbfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCktcI/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCktcI/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97067C433F1;
	Tue,  9 Apr 2024 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712667307;
	bh=buB17AEIHw4RKpCZSUmtgyTvF/xyD0a0CGkVGXfyPc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCktcI/BVRTkZcsyFuo1AwSGJ3iM1uFSgBAkVbf1sWmBikl5VWTvQQGMUoGrXKopN
	 /xFcRQfk/Twc4dEiQpFF8Qa8nQ7acIcXAE0n0mcLgxZAwPMeDZ2lrYN4V5cqa9hwZ7
	 HzKXA8SvEfYM7D11Aic1x8UztrFxcRJsxSYQTecNgRpY1JvYS8+Ixpn4s2oUtkYKEI
	 iiw657mQGbNZKMfqNRH3lqG0yz3WHOh6clGyvaiaeDo1VDzoOvPxUyO3HkZubjEG3S
	 JjA+9sqHIamJv530gUAzvKAxUoVO0VMZaJi4gY2FPGkZGkUtrMit8bJv9aHyfzVHt4
	 NA95QCQ1d0daA==
From: Will Deacon <will@kernel.org>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 00/29] Update SMMUv3 to the modern iommu API (part 2/3)
Date: Tue,  9 Apr 2024 13:54:59 +0100
Message-Id: <171266271384.1465008.12517206202208996339.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 27 Mar 2024 15:07:46 -0300, Jason Gunthorpe wrote:
> Continuing the work of part 1 this focuses on the CD, PASID and SVA
> components:
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
> [...]

In the interests of making a dent (albeit a tiny one!) in this series
while review is ongoing, I've picked up 3-5 as they look ready to go.

Applied 3-5 to will (for-joerg/arm-smmu/updates), thanks!

[03/29] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
        https://git.kernel.org/will/c/fdc69d39e77f
[04/29] iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
        https://git.kernel.org/will/c/86e5ca098dd9
[05/29] iommu/arm-smmu-v3: Add a type for the CD entry
        https://git.kernel.org/will/c/e8e4398d53f9

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
