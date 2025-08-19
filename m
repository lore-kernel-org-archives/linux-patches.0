Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456651DEFE0;
	Tue, 19 Aug 2025 02:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569530; cv=none; b=WLG/mpeBKsDpfG6N0xDqI6a4H/DisYyNEY4RjBbSwbZxxRGdgXHQqKOB8EVJsIoxHKSr2uR3Ag5Xg9cwvI+zQTjxgGtHT9mf4eH4/A1Kf4NKbX9KUPnVgGaNlause2XkBmpmULkfqrJX9r+0OkzitK4Mv8F0U9CWGhYqeTiNOIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569530; c=relaxed/simple;
	bh=CtWl+kAaj28FCmgEJf0e3j5MDGUJeH2tJY2k2qK3kWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1dMgzsdrb+gJT5nWFBGl5q9eqDmkkdogp/8S3Z8lMAElXK2kv6X3mhccqy9lyIA2Y9WaVVsE85/SSYDG7/2HwzO8KW8Gujt+ZV1LXeq9psJuQr+jVc0+oMb9dfFIWUo/5AxtzRJ6DYlPJOW7woV6A2yXoQ4AMMIVBHQEuuDWT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IxW9xmaS; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IxW9xmaS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755569530; x=1787105530;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CtWl+kAaj28FCmgEJf0e3j5MDGUJeH2tJY2k2qK3kWg=;
  b=IxW9xmaSePXg34ehqcLg4bmj4xvZmW2TAbbaxfsoqqocHJdRWc1vJzaP
   ZendHHAjdY2BLv6H7ivWHDSwuXFTlG89D9371syIPY89795VgO8sO+v03
   zcfSZxGrrWMs4bHgKzFEC4dHyCPomfLtyFIP/rZL54Qh+yACq2bMdPy0V
   jIBMeu5C2VtSmIeZsOH30AAJDtGUGIGAyGlfL6o280Rq8YZHCmR6xARq7
   uW2aYMnVBpKkFa5EE83eYs3hyEm9i1UZm8CeCeP6UZGP+XavaD7PRbxk9
   89Ac5kz3h5rDdXhBRIS4Ym2yHCR57QNe3p4dmqWLzcvCpvtyXUbTeRk4a
   Q==;
X-CSE-ConnectionGUID: IVsfpQjPRkq2bSjNu4e+GA==
X-CSE-MsgGUID: BT+dW3ZqTyeRoPEOza5ajQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="61637218"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="61637218"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 19:12:09 -0700
X-CSE-ConnectionGUID: BCj/97QQTnKrxK+MekdAiQ==
X-CSE-MsgGUID: TE75bEPQTWKJ1Q+sONEmGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="171944207"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 19:12:03 -0700
Message-ID: <ba8c8e60-5907-49d2-88ff-b9c6ab994d2f@linux.intel.com>
Date: Tue, 19 Aug 2025 10:09:49 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] iommu: Add iommu_get_domain_for_dev_locked()
 helper
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, robin.murphy@arm.com,
 joro@8bytes.org, bhelgaas@google.com, will@kernel.org,
 robin.clark@oss.qualcomm.com, yong.wu@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, thierry.reding@gmail.com,
 vdumpa@nvidia.com, jonathanh@nvidia.com, rafael@kernel.org, lenb@kernel.org,
 kevin.tian@intel.com, yi.l.liu@intel.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org, etzhao1900@gmail.com
References: <cover.1754952762.git.nicolinc@nvidia.com>
 <a69557026b7e2353bae67104bbe6a88f0682305e.1754952762.git.nicolinc@nvidia.com>
 <aeb04f91-ffce-4092-8dbc-17d116cd7c7e@linux.intel.com>
 <20250818144051.GP802098@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250818144051.GP802098@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 22:40, Jason Gunthorpe wrote:
> On Fri, Aug 15, 2025 at 01:28:02PM +0800, Baolu Lu wrote:
> 
>> Given that iommu_group->mutex is transparent to the iommu driver, how
>> about
> It is not actually transparent, alot of drivers are implicitly
> assuming that the core single threads their struct device for alot of
> the ops callbacks and we exposed the lockdep test to the drivers to
> help the document this.

Fair enough. It's the role of iommu_group_mutex_assert().

Thanks,
baolu
