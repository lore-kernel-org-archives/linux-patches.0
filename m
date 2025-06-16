Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C732EAD13;
	Mon, 16 Jun 2025 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750074879; cv=none; b=VWdjSpwBvbMEgTuQ7RBTGd8eu1oxBMWIWf1zD3wfWjQjogaHWB2Ec9Wzk2d+oBZcklPWL028wF4rrlxcFFz+1sgVmeFWB+AnZ1Az79yRKSh6C1rDgqNsuC8pB/NC5952KNR0HnMhkf/I09VtIKBIj4OCAG35N/qMxE1ik1cWfbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750074879; c=relaxed/simple;
	bh=a4308r24XGn+BMFT+GUDp6JTrDSZTiUE/F3YsroUvUM=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ou5xmJMU3kOmoLaNeBePW361mONUW4+hD4B7eRb3bDr1lMfHgwjntOxRWSNg2iQr2FuWjPW8BWCRvjgOjoKihLqtADPxKoH52Gdoyht+E7+hAnSGbEuAeiDKmx7AVtv7JKaT2JklFuFlfrBRefaDU8Y5W43O9S881YuJogI4t/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OvFALluX; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OvFALluX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750074877; x=1781610877;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a4308r24XGn+BMFT+GUDp6JTrDSZTiUE/F3YsroUvUM=;
  b=OvFALluXY74XtZfuUhCD9WAXAz3hIwLKvVxZzHQ58bDvvKotiWeeh3GH
   kflTWzMMnFa2ae4l/FyTFLDHC9BDBU6nh/DxUXMDRaMDLCSS0g5FEUebL
   uAqnqignoETvrCikSu2yCx+kIs/Q0Dv+8YgMx2bNaxkMx7KXuITLfXuyq
   SM5d1PXWUemqP+a3VR7iFTGRqGGTb2BnWuSs0rAYbscLJtymMdHPa3X6q
   gUvLDbtXm4MWURwtUbSU2+Ig7uQlHM9ZfCqZ7hKneRGlCsERL895058oq
   kxFkTUt6kEJ1NsK+ubobtaLSFyzniy6EIja5G3QCjHs3bkqhrDhGOs56z
   A==;
X-CSE-ConnectionGUID: B57spLAzSa+ZLZi5SVfmxw==
X-CSE-MsgGUID: z+CImYhRSt2x45LX+WbsmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="51323399"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="51323399"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 04:54:35 -0700
X-CSE-ConnectionGUID: IYbJH8q2SSmGyMvltH3CVA==
X-CSE-MsgGUID: VG9tbGEyRFWbq9Pf22lypw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="148824406"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.243.252]) ([10.124.243.252])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 04:54:29 -0700
Message-ID: <78d05dff-f396-4214-a7fc-f0c674144aef@linux.intel.com>
Date: Mon, 16 Jun 2025 19:54:26 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, bagasdotme@gmail.com, robin.murphy@arm.com,
 joro@8bytes.org, thierry.reding@gmail.com, vdumpa@nvidia.com,
 jonathanh@nvidia.com, shuah@kernel.org, jsnitsel@redhat.com,
 nathan@kernel.org, peterz@infradead.org, yi.l.liu@intel.com,
 mshavit@google.com, praan@google.com, zhangzekun11@huawei.com,
 iommu@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-tegra@vger.kernel.org, linux-kselftest@vger.kernel.org,
 patches@lists.linux.dev, mochs@nvidia.com, alok.a.tiwari@oracle.com,
 vasant.hegde@amd.com, dwmw2@infradead.org
Subject: Re: [PATCH v6 17/25] iommufd: Allow an input data_type via
 iommu_hw_info
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <8e1d8432fb7e11f0ed514bc96690ece1f5e47fdd.1749884998.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8e1d8432fb7e11f0ed514bc96690ece1f5e47fdd.1749884998.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/2025 3:14 PM, Nicolin Chen wrote:
> The iommu_hw_info can output via the out_data_type field the vendor data
> type from a driver, but this only allows driver to report one data type.
> 
> Now, with SMMUv3 having a Tegra241 CMDQV implementation, it has two sets
> of types and data structs to report.
> 
> One way to support that is to use the same type field bidirectionally.
> 
> Reuse the same field by adding an "in_data_type", allowing user space to
> request for a specific type and to get the corresponding data.
> 
> For backward compatibility, since the ioctl handler has never checked an
> input value, add an IOMMU_HW_INFO_FLAG_INPUT_TYPE to switch between the
> old output-only field and the new bidirectional field.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
