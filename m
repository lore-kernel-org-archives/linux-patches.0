Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FFD242D6C;
	Thu, 23 Oct 2025 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195743; cv=none; b=g//SYy3fLKgksZhrLYYCsI0dkQtbFPD0f/mZWBTKODoYDJ2Sa9FUR15esDxgbntKEgIzPPhYoEl5J9Q1c7+FKqL5O3h2e+IZS2FLq2qTn4enKCww84r92CNvF0oSsSHNJmJ2B1eTwJOmFY+tGBQjdADwQlLCUv1XosMfSIubC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195743; c=relaxed/simple;
	bh=xnBFwakM2k1JPYwO3/Qy+Tx8eLKNZ7gwkUwwpTfHUOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VLZNxc+RkQMpKKY0Rs6WxKiVkQcsY8Rjh1sIXIzX3cmMOeqBrGzmkGAcVjFaKJFBu/XiPqFOuEXSVo4RBTGlmZvx7zPdVyTj+QbGZTPKEoCJ+QsCLQWD2JfcwTxe/YGnDx2lgoQYQba7pomZ12HBext44N3EqFnW7SgY9N60t+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O8ZYBY3i; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O8ZYBY3i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761195741; x=1792731741;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xnBFwakM2k1JPYwO3/Qy+Tx8eLKNZ7gwkUwwpTfHUOQ=;
  b=O8ZYBY3ie81lTGSPDqv+BberPS2lyhZp+9noMBmKy3lGNnH49ZnIQfDZ
   zI2DaLTS/Nu0BtYXkQcJDNDkheWFHdsAToWw2Vi/EUhC6B2wZP4pEpOaH
   MwwoQY0T03W6Mltdlz8h3OGiszlp6g6SOg+91MEzIiAbaa/hhIJ/WftHa
   qTBfeSJ5KWnPsYLewQ4akpowG2dwsHotFtdmPxX98bkrEk6kRgWecLlAC
   iipnZDDJUg5MdGsaS8iY2LQFnyQgSrhmIyY5vj4eWuFDdVYZ9pEa2oo73
   LDG6u3x1TU6r1/cr061nZnnhz/qg0w8WYcrGwTm+gCUPwRrFZIRKCi+GO
   g==;
X-CSE-ConnectionGUID: IRsPcPOGRIC2x644/cebag==
X-CSE-MsgGUID: On9gcTzYSpKzb+N7yX8pfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63248417"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="63248417"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:02:20 -0700
X-CSE-ConnectionGUID: kWA0S5r3S1ua2kzqQUzTDA==
X-CSE-MsgGUID: MuIS53hmREe4ygA3mF8heg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="214986870"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 22:02:11 -0700
Message-ID: <3a9698ac-ac50-499f-871c-ee44d7371815@linux.intel.com>
Date: Thu, 23 Oct 2025 12:58:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] iommu: Pass in old domain to attach_dev callback
 functions
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: suravee.suthikulpanit@amd.com, will@kernel.org, robin.murphy@arm.com,
 sven@kernel.org, j@jannau.net, robin.clark@oss.qualcomm.com,
 m.szyprowski@samsung.com, krzk@kernel.org, dwmw2@infradead.org,
 yong.wu@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, tjeznach@rivosinc.com,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, heiko@sntech.de,
 schnelle@linux.ibm.com, mjrosato@linux.ibm.com, orsonzhai@gmail.com,
 baolin.wang@linux.alibaba.com, wens@csie.org, jernej.skrabec@gmail.com,
 samuel@sholland.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
 jean-philippe@linaro.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-samsung-soc@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 patches@lists.linux.dev
References: <cover.1761017765.git.nicolinc@nvidia.com>
 <7f760e795097e3052da82abf410c6ee963e4c62b.1761017765.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7f760e795097e3052da82abf410c6ee963e4c62b.1761017765.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 10:21, Nicolin Chen wrote:
> The IOMMU core attaches each device to a default domain on probe(). Then,
> every new "attach" operation has a fundamental meaning of two-fold:
>   - detach from its currently attached (old) domain
>   - attach to a given new domain
> 
> Modern IOMMU drivers following this pattern usually want to clean up the
> things related to the old domain, so they call iommu_get_domain_for_dev()
> to fetch the old domain.
> 
> Pass in the old domain pointer from the core to drivers, aligning with the
> set_dev_pasid op that does so already.
> 
> Ensure all low-level attach fcuntions in the core can forward the correct
> old domain pointer. Thus, rework those functions as well.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   include/linux/iommu.h                         |  3 ++-
>   arch/powerpc/kernel/iommu.c                   |  5 ++--
>   drivers/iommu/amd/iommu.c                     | 11 ++++----
>   drivers/iommu/apple-dart.c                    |  9 ++++---
>   .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  5 ++--
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++++++++-------
>   drivers/iommu/arm/arm-smmu/arm-smmu.c         |  9 ++++---
>   drivers/iommu/arm/arm-smmu/qcom_iommu.c       | 11 ++++----
>   drivers/iommu/exynos-iommu.c                  |  8 +++---
>   drivers/iommu/fsl_pamu_domain.c               | 12 ++++-----
>   drivers/iommu/intel/iommu.c                   | 10 +++++---
>   drivers/iommu/intel/nested.c                  |  2 +-
>   drivers/iommu/iommu.c                         | 25 +++++++++++--------
>   drivers/iommu/iommufd/selftest.c              |  2 +-
>   drivers/iommu/ipmmu-vmsa.c                    | 10 ++++----
>   drivers/iommu/msm_iommu.c                     | 11 ++++----
>   drivers/iommu/mtk_iommu.c                     |  8 +++---
>   drivers/iommu/mtk_iommu_v1.c                  |  7 ++++--
>   drivers/iommu/omap-iommu.c                    | 12 ++++-----
>   drivers/iommu/riscv/iommu.c                   |  9 ++++---
>   drivers/iommu/rockchip-iommu.c                | 20 +++++++++++----
>   drivers/iommu/s390-iommu.c                    | 13 ++++++----
>   drivers/iommu/sprd-iommu.c                    |  3 ++-
>   drivers/iommu/sun50i-iommu.c                  |  8 +++---
>   drivers/iommu/tegra-smmu.c                    | 10 ++++----
>   drivers/iommu/virtio-iommu.c                  |  6 +++--
>   26 files changed, 153 insertions(+), 100 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
