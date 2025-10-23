Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575AC244691;
	Thu, 23 Oct 2025 04:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195259; cv=none; b=SG0CsvM2S3tB69qIKhW1CqvC3huhz+nGDEJSt4Br08TI+yGRsNAMJ/65a+bWaXMz3yqpSeXj0n7KDnT6EIziu91z0Pvy0yj1Bivn2nNa8CplCMYzVCIaf8FKyWmmW5Xu/UAexakKZjwB43Q7bCYeWWv8xD8YCWwyxZq40uh9XGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195259; c=relaxed/simple;
	bh=o/X8ig17zbEWg83ccAFqusXE4QA15fbF7lAl6rfU1tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9O+oTbK+yoIo6hhSAzZweIETerTyn4rO1C/E4VkimM+jNAv9JdYchUKgE4w3J6fxDOarmkytfY3EMkYqSfehubIgQfdFiEKF03Kuod4fmKTpF+YTDKURp6Voa9VAJ3rnhAT6LT3PrYho3Yt96NNlfUfAgpwJNarjohhGwywulI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lb5bJHft; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lb5bJHft"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761195258; x=1792731258;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=o/X8ig17zbEWg83ccAFqusXE4QA15fbF7lAl6rfU1tQ=;
  b=lb5bJHftNACaS/fDK6hVC/UxAHVCl6sxOkXPluINE+cY+ksHTy0HGKzA
   uG4Q0yI1s2xT/YTFTV5Yi/HoiLVuRGHViK320zGTxGbxkl1jRAvSgsm3q
   LdoAQUocSdVVcHrL7oQSsjjY9d3zZq1dlN52/FZWJ+Vj/tEPlTA3cs6yn
   Vwe3ZokTjimFahtxCQuHFWufi3VsOitgktQISALa0wpWKE9kpJ7yHeLQB
   OUrlmCIfcJi9q5y7MMj+lE5kMRWOLyqBggxlsTn58ZslHEFOTgpR97swC
   /YfwnZQL8JKfeI5KGB1lXtB4mQ4clt9FvAhNl2Z6cZYGJcXmvztuYemXR
   Q==;
X-CSE-ConnectionGUID: /nYH2Y2YR+GwTuSPHdhCFw==
X-CSE-MsgGUID: tObFgwH7QkmC8UYjieexkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74473295"
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="74473295"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:54:15 -0700
X-CSE-ConnectionGUID: HMCARIInQHW636C3OauOVA==
X-CSE-MsgGUID: LmNg6KDHRqKFY/2EChkiAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,248,1754982000"; 
   d="scan'208";a="214985320"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 21:54:06 -0700
Message-ID: <47b5dfbe-dda7-419d-9032-d61bda44eb9f@linux.intel.com>
Date: Thu, 23 Oct 2025 12:50:13 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] iommu: Do not revert set_domain for the last gdev
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
 <276875013de662fe50f3fdd9e9a5bfbc0f12602e.1761017765.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <276875013de662fe50f3fdd9e9a5bfbc0f12602e.1761017765.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 10:21, Nicolin Chen wrote:
> The last gdev is the device that failed the __iommu_device_set_domain().
> So, it doesn't need to be reverted, given it's attached to group->domain
> already.
> 
> This is not a problem currently, since it's a simply re-attach. However,
> the core will need to pass in the old domain to __iommu_device_set_domain
> so the old domain pointers would be inconsistent between a failed device
> and all its prior succeeded devices, as all the prior devices need to be
> reverted.
> 
> Avoid the re-attach for the last gdev, by breaking before the revert.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
