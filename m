Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E990914BF8B;
	Wed, 13 Nov 2024 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731466612; cv=none; b=HPFEhVC8g9VlKGtghMfaATOqiSFX2gfPHu2gMb4H3/Z9o/S3NLvrewCLr3VMM7J38ulM/txgTJTC/HTS9OyXtfnW5FCyTRcIzJhdVMV3X635myUfZgP3NhSRrnbQEDG09POv4ZPeJzFLNX1Uvs+baj+VuSZyF13SxXP6opWv3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731466612; c=relaxed/simple;
	bh=ceSuWOSaH+psoiQRK0fCAi9iXALt92xZBLKjvgklJjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hpN/qkh1h7XXD4CZELIu1VowdPZZug5pQ7RwrMLzcromUtjsrmfpDfMso7cDeBlbeY2lwdzl9I0p4YbkwAPe0btTlE7iqAU2IVdisUiXVjyB3exPSSOWDJNBfrgYcu8G2CMKOW1JUqc1ff5qN7KTqiUznOs1im0QpjJJECEN9r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=czUnEgHC; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czUnEgHC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731466611; x=1763002611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ceSuWOSaH+psoiQRK0fCAi9iXALt92xZBLKjvgklJjw=;
  b=czUnEgHCXTeV6tkankaeuY/QZQL4PnLzw861PUUDIOGRfQi4l5Kss/jE
   tUGWrSBRgST9A386pRP4oZSVF5Ri+mv6HB5OjQlDl8xAM4lOSCc5jZWcv
   SFzKTlA2SYI+YiUalC5XtllVHZIhcPKKSCe192cd9fvUUNikRNDPJCiaF
   6A2d+G2cIG2wQp99RkzXu+IB9T8dFx/QzA65ajZhT+1DlDBP9XV3Ea0sC
   H7L8ym8tSKfNezlEBMDpa2SyiTh5Klf/f5SFlDbh7Kl0fmkGsRjFymhNa
   TDmKU6I5nqNTtG6L4N6WUvnpRfMBJ/NfpCdUjQNEKpqJU6YHvl/1A5jN0
   Q==;
X-CSE-ConnectionGUID: 7qUhu0duShicIXszDKJ4bg==
X-CSE-MsgGUID: Eixpbz7KTsWMaaDvpiw4PQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31442143"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31442143"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 18:56:49 -0800
X-CSE-ConnectionGUID: g2GulBb6RSSg5ikrECfKxg==
X-CSE-MsgGUID: Oj2A52ANTnmNTqlZZd4sgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87703179"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 18:56:43 -0800
Message-ID: <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
Date: Wed, 13 Nov 2024 10:55:41 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Jason Gunthorpe <jgg@nvidia.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Donald Dutile <ddutile@redhat.com>, Eric Auger <eric.auger@redhat.com>,
 Hanjun Guo <guohanjun@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>,
 Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Mostafa Saleh <smostafa@google.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241113012359.GB35230@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/24 09:23, Jason Gunthorpe wrote:
>> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
>> https://github.com/Linaro/qemu/tree/6.12-wip
>>
>> Still need this hack
>> https://github.com/Linaro/linux-kernel-uadk/commit/ 
>> eaa194d954112cad4da7852e29343e546baf8683
>>
>> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
>> which you have patchset before.
> Yes, I have a more complete version of that here someplace. Need some
> help on vt-d but hope to get that done next cycle.

Can you please elaborate this a bit more? Are you talking about below
change

+	ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
+	if (ret)
+		return ret;

in iommufd_fault_iopf_enable()?

I have no idea about why SVA is affected when enabling iopf.

--
baolu
