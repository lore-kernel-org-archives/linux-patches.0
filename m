Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4B92882D6;
	Mon, 16 Jun 2025 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044472; cv=none; b=F3FLARRXEtozVXihdj1NcG3zgT0QEc6Kfg7n8AORpOMM22a705t85rl+sz+bZlraWVH8K/Khv21LwXRksJZ2HpY2QxOTOHr4XKcdryW883hl37OTyhB1jQQ3a6F4X9kWJd2GSoyQeMRbLm37stJch7bEyJBIbOs3y06D9S1zpro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044472; c=relaxed/simple;
	bh=TlV55p7OgqzS+AWh4h3XVQ+nE9CHnltiO69/D4Lbz4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2oc2x6e4YzFxZxEZSBGqk/OZ0EK8l9AhHjbau4Z8YE/D3Uj5SAyxww4dup1Km1sJVXANS0fjRYAh5bazWoR+Uc7wXbzGx7s/NmMmFYq/hJ07SelakiTCpTYlfftA9qYPl1A3qtzz3t/bjXMYT91Gtr4CyPP/3Jr1DNrZ1Hzwx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I7QchXcH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I7QchXcH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044472; x=1781580472;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TlV55p7OgqzS+AWh4h3XVQ+nE9CHnltiO69/D4Lbz4Q=;
  b=I7QchXcHG6kEu44Osmk3+1DVy7C1Fqww10/9Z+bHzLgV1IMiF9kDTkm1
   I9+wEzZJrlAhIVpYR2ls3mvZkiViGP+mkmoemubIFAL7VFqGY1yrBiIIS
   KuN3AXqiIKVi4VZZSnYHfo5A/1vhuWl07uHK2oeXFQuyYsBQcTDODtULa
   GVhuxI6x2jQu280CIlN3bOZwqkaLBJtsGEpTowHiRqt+5MEUumGUAjsWH
   CbLMClIhDVEFTrQUK2ItJCWivGTO/+rdH7Z77csQzm6hz3HQgr+SaI2aT
   icSwf3ULN72xY6k6IUUNU4lf3lakAgWl/XUVoD0A4yngPKsXgXtVDJFOu
   g==;
X-CSE-ConnectionGUID: yKqvShsbQre4OHk6abudKg==
X-CSE-MsgGUID: sI5J5I7qRjOYWBcM2BM/yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52269804"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="52269804"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:27:51 -0700
X-CSE-ConnectionGUID: hno7wtDNSX+T+IoxOBED1Q==
X-CSE-MsgGUID: b9Xltt6LRP63ykeBftQHHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="149262520"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:27:47 -0700
Message-ID: <ca17f684-b95f-4eb5-8371-243d72048e38@linux.intel.com>
Date: Mon, 16 Jun 2025 11:26:48 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] iommufd: Move _iommufd_object_alloc out of
 driver.c
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <79e630c7b911930cf36e3c8a775a04e66c528d65.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <79e630c7b911930cf36e3c8a775a04e66c528d65.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> Now, all driver structures will be allocated by the core, i.e. no longer a
> need of driver calling _iommufd_object_alloc. Thus, move it back.
> 
> Before:
>     text	   data	    bss	    dec	    hex	filename
>     3024	    180	      0	   3204	    c84	drivers/iommu/iommufd/driver.o
>     9074	    610	     64	   9748	   2614	drivers/iommu/iommufd/main.o
> After:
>     text	   data	    bss	    dec	    hex	filename
>     2665	    164	      0	   2829	    b0d	drivers/iommu/iommufd/driver.o
>     9410	    618	     64	  10092	   276c	drivers/iommu/iommufd/main.o
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
