Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65C9158520;
	Mon, 16 Jun 2025 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750055232; cv=none; b=ivCbRKEASrHV9ilTPOGzLS56DJxXMyM9g+7C+LDIv1q4iktMWWT+yQvgvmxodLpNu467PwpoANAruW3O3gRky5ydgqbLNRxnDbxzSADSXx63UmLB23bPI0JC0llYCLWCXMurWc14h8+eYtldbk0MJx8wArPmOtk2d0bGQQgldMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750055232; c=relaxed/simple;
	bh=guthJV8X5Sn3QS48dFxzVUYchT/ptlQNDvr7/P3ystE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BsJIyVL8TDnNsJDM7dNH9cUyexoR4+tCl9qUSufKM34pR183S2VDqexqzsbJnHZhkR5fvzbzRl5T74lPm3tvzWqX0mIYGwed8DDoY5A/1xzkQbUmX+KOwHBv34WWGtQCmE0IknUYT0iDRPlLq7s7jAzuz2nDlQyxhnoekBJEFwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K5dXqaE9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K5dXqaE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750055231; x=1781591231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=guthJV8X5Sn3QS48dFxzVUYchT/ptlQNDvr7/P3ystE=;
  b=K5dXqaE962XWgFPw+wlzrnBzVwqJGvkQ4tg+xT+96tR3QqGTTC2cw0vg
   0aO/xb1+pplrEMaat/Wj4Hu/E5ZYZWKmPqPVjfVaXjCmLwK8WBDybk1Xk
   yRw+F+2NdPS1CWHhQveTtYzFpC02GV/NuIGFy2GrYt4EPDunO6QR5qfPT
   4cIvdN8lGBzzLERNllMbL9lXawjbTzDJvAPsB/fQ2s26vypxGbcKP0gBt
   6JeT5mimSIpXMfHc7LSiE13MagOvfMLmizAuapCZWMz2Ll+AX6z24WtQp
   ATCDmh6NaA/jAB4DUHFqSaQJYCUQY9P5TZw/ExsyiW5lX/+EtnJVXNZ+C
   w==;
X-CSE-ConnectionGUID: gXak1TetRPa5YISvpkQZ3Q==
X-CSE-MsgGUID: xl88WnUGQ26Kh0iuq6zGBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="69632518"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="69632518"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 23:27:10 -0700
X-CSE-ConnectionGUID: ZURGS4SzT3Cu91PvtlrvWg==
X-CSE-MsgGUID: ZI6oSjeARV23YgzKHmA7PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148841810"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 23:27:03 -0700
Message-ID: <ee1b9096-4687-49ad-815d-efe3dda5d31a@linux.intel.com>
Date: Mon, 16 Jun 2025 14:26:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/25] iommufd/viommu: Add driver-defined vDEVICE
 support
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
 thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
 shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
 peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
 praan@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev, mochs@nvidia.com,
 alok.a.tiwari@oracle.com, vasant.hegde@amd.com, dwmw2@infradead.org
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <937d515032be07af36c06a4adb662ee2f7693c75.1749884998.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <937d515032be07af36c06a4adb662ee2f7693c75.1749884998.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 15:14, Nicolin Chen wrote:
> NVIDIA VCMDQ driver will have a driver-defined vDEVICE structure and do
> some HW configurations with that.
> 
> To allow IOMMU drivers to define their own vDEVICE structures, move the
> struct iommufd_vdevice to the public header and provide a pair of viommu
> ops, similar to get_viommu_size and viommu_init.
> 
> Doing this, however, creates a new window between the vDEVICE allocation
> and its driver-level initialization, during which an abort could happen
> but it can't invoke a driver destroy function from the struct viommu_ops
> since the driver structure isn't initialized yet. vIOMMU object doesn't
> have this problem, since its destroy op is set via the viommu_ops by the
> driver viommu_init function. Thus, vDEVICE should do something similar:
> add a destroy function pointer inside the struct iommufd_vdevice instead
> of the struct iommufd_viommu_ops.
> 
> Note that there is unlikely a use case for a type dependent vDEVICE, so
> a static vdevice_size is probably enough for the near term instead of a
> get_vdevice_size function op.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
