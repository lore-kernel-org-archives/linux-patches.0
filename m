Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9FE15CD79;
	Mon,  6 Jan 2025 02:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736131852; cv=none; b=I1khJJuRr/mkQxXyHpRKSfL9c3t3KMnSD+gak3w0Ybm+PxSP3pNrMK9XQZEbcxbWzM/YsN+plyiPDysBG3C/59g2KY3XriH9Qd2qS84kPic9TaKgTnRzQNYNqmd2poL7mt7G7tVl9VYppnV1x9FWO0LgXX6585SD4ag5LaWYM6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736131852; c=relaxed/simple;
	bh=JFtPzvb18FfE+wL5jWUzNx+kpfpVZKFUa+nvYsaeaAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7iQKSE+CRHkASbyXZ5Yw0XBgvnzEtwazQZN+bGMmQmfzMYz+SW5lGhvu1FL0YA3u2hs3IIpJpBDgooODlnQY2FNUrbwicdNlQAvC9Bj7vNI3dY7xQh6nNqTXQcgRVorWwW4SBMx700onbo5uQZ6CDSNBjF8UqmMITJy4O0beXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IxRCI/Zs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IxRCI/Zs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736131850; x=1767667850;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JFtPzvb18FfE+wL5jWUzNx+kpfpVZKFUa+nvYsaeaAw=;
  b=IxRCI/Zs77e5imkem2qxbkAzfk+SYETWIVSoGtWEQtkd7g2zvMZDD0iP
   siXRSXONAZRTNXOtnAosB/hKp8z7J2qQWBvmH5M8mgmV0iJF09iRecDba
   swK6QigxnnIye2P/9XdifTio0MdSssGqDr8duRKs2eyBi6SbinNpOMArs
   epXkprBNajMCOlTJgVJM97T7qXgZYeptahi/LXzEMYeFZtz7iLByvyp8c
   Gbv/g9qKGtk+AnewpUb9Bx/bVA24VNL2q1JviKDrmSFIlCQU8N7KyORZL
   Zf7ZX8Sx3QA8soveDh3uxIIuTRBlls7gUKW1zeTBeyaDtk6vlipOYttWx
   w==;
X-CSE-ConnectionGUID: yy2d1CLfRmuMR48Zs9RFFw==
X-CSE-MsgGUID: ykZNvvC9Qfq3fdrJqHtt6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="53690651"
X-IronPort-AV: E=Sophos;i="6.12,292,1728975600"; 
   d="scan'208";a="53690651"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:50:50 -0800
X-CSE-ConnectionGUID: zi8f8q+4SN614nlesVQy+g==
X-CSE-MsgGUID: Mn2+SyAnSRikRE+VWQNAVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="125600038"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:50:26 -0800
Message-ID: <59c4f1e6-1ea8-4110-aeee-7b7bf06cbaf1@linux.intel.com>
Date: Mon, 6 Jan 2025 10:48:21 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/14] iommufd/fault: Add an iommufd_fault_init()
 helper
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
 <f01c9eb88608f349a31756eb975e24d300796759.1735933254.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <f01c9eb88608f349a31756eb975e24d300796759.1735933254.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/25 03:43, Nicolin Chen wrote:
> The infrastructure of a fault object will be shared with a new vEVENTQ
> object in a following change. Add a helper for a vEVENTQ allocator to
> call it too.
> 
> Reorder the iommufd_ctx_get and refcount_inc, to keep them symmetrical
> with the iommufd_fault_fops_release().
> 
> Since the new vEVENTQ doesn't need "response", leave the xa_init_flags
> in its original location.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommufd/fault.c | 48 ++++++++++++++++++++---------------
>   1 file changed, 28 insertions(+), 20 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
