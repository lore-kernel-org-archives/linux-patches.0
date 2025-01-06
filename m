Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25358158DC6;
	Mon,  6 Jan 2025 02:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736131897; cv=none; b=GMEEIHJYjF50WF/fVwx0MUHpJvAMY3sEHTBKZpd6AesuwMmyYm7Oc1iz1MXHDgQVSzuvgdE1df55CPDJnYYUPvK3NwJzL0PO9yL+6zL/VYPPcVENVNsiwbHJORHqFbEvvVpfto+VketNrq261OW/qbdcI8x44lqYtqSU/mSDJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736131897; c=relaxed/simple;
	bh=p+rSGSb1fcY4Z+BFW/0sBY66DwVhq4ZBNQgOm7e3CZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/pgHZO8cQBjOAamghMAyn6vgqomTBfgE0GOERCXDWpaHoDOWlq6dooaJ05pl3dkVf6Z8LoAM/2vRcyD8mOIlQV41Idy3cg2UlJAo3CoWeqWQP9sIjsDfEeVLPi/Krm7ZToDMcafVxFj9xODMv10D+spZ46EHdc/NX48kauV9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0eA2Plp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0eA2Plp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736131896; x=1767667896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p+rSGSb1fcY4Z+BFW/0sBY66DwVhq4ZBNQgOm7e3CZw=;
  b=m0eA2PlpmlyX9CZoHEc+eM0P4aW2Y51k2CsoOV7SGDp5LoZ7QiMHwOto
   nZX/uhnq9oH7vYV1PFK3aHda42j+PnpxYFyWJs0jXbbkLpJdxi6RtmnUX
   BKiAeppDlgw+5blHglnS4PRGbBsDeDTClAGuiE2p6md/yoms84UJT0Kms
   VxdbuEyjF4i78IXMGleOnZqtv66I6z2FdptDoninyHF7Q5i6TLBl2ahtt
   p7mcFI8PywVRPjlXV/eV2Udyv/1/0r8S+2wAI3XRaefBLGSityv+bxpZx
   G694MN9stF3il0VclJwHtLWvGJVodjR7uP/lPCYjuDMYOCuMd+SS4WzrO
   A==;
X-CSE-ConnectionGUID: BoU2L3igQ3uuZXvG/28dmA==
X-CSE-MsgGUID: yIQVJZteTKuZpSr8RnUEyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="35574965"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="35574965"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:51:35 -0800
X-CSE-ConnectionGUID: rc2EfEReT5uicVtr1fh1Wg==
X-CSE-MsgGUID: FRP5fobRRRSKxYmFBPvXNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103191561"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:51:30 -0800
Message-ID: <3992ea4a-a0f9-47bd-b46b-c50e47496d53@linux.intel.com>
Date: Mon, 6 Jan 2025 10:49:24 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/14] iommufd: Abstract an iommufd_eventq from
 iommufd_fault
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: joro@8bytes.org, suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
 dwmw2@infradead.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
 mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
 smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
 patches@lists.linux.dev
References: <cover.1735933254.git.nicolinc@nvidia.com>
 <5d4bf92ce7e64a1c424f1b89d1a78f20bc6d7557.1735933254.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5d4bf92ce7e64a1c424f1b89d1a78f20bc6d7557.1735933254.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/25 03:43, Nicolin Chen wrote:
> The fault object was designed exclusively for hwpt's IO page faults (PRI).
> But its queue implementation can be reused for other purposes too, such as
> hardware IRQ and event injections to user space.
> 
> Meanwhile, a fault object holds a list of faults. So it's more accurate to
> call it a "fault queue". Combining the reusing idea above, abstract a new
> iommufd_eventq as a common structure embedded into struct iommufd_fault,
> similar to hwpt_paging holding a common hwpt.
> 
> Add a common iommufd_eventq_ops and iommufd_eventq_init to prepare for an
> IOMMUFD_OBJ_VEVENTQ (vIOMMU Event Queue).
> 
> Also, add missing xa_destroy and mutex_destroy in iommufd_fault_destroy().
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommufd/iommufd_private.h |  52 ++++++---
>   drivers/iommu/iommufd/fault.c           | 142 +++++++++++++++---------
>   drivers/iommu/iommufd/hw_pagetable.c    |   6 +-
>   3 files changed, 130 insertions(+), 70 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
