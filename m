Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A798A1EEE6;
	Mon, 16 Jun 2025 03:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044359; cv=none; b=X7uSHoU7V1E0/ULeBSMwexQ5qgkLRhzu6TdYzqp/4rCxHNavPCIAjnLyzHV6UGt3cYh4ll5UhNvw+FoSeypnqVQlc4fOoiNHwEPgdqHCXHL/J537PCHDvA8FCYy83hOXISPlhi0wH6AHneY8QD4h9Jf+WH3ly4X9OCwJW3ze5og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044359; c=relaxed/simple;
	bh=ShGXHWtQJnGfuAnsYBv4PVasiGw/1AVnM6GQMo/0N0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrbatHf8KwsO8DRZPNvSeV0rST0s/zemqIvVaQnpvizvzO6qtsT2U3m59UJw5C7uPN8TH4J4g4QxsGd2RjuNohZppXuE6jIaj3nlbThlStN1fbowsxZM8gR24EIddXeWOa5h5n5lSLt7vGJwiNTk2o0mBpkuqbrF0JhvwZ4eRgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JHBD48id; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JHBD48id"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044358; x=1781580358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ShGXHWtQJnGfuAnsYBv4PVasiGw/1AVnM6GQMo/0N0I=;
  b=JHBD48idomxGV7FpYil/P6MXB+Q9o0bTPYKyrFWNWSgBM9CqS5zt9X2T
   S/mcg3kYXluxyep1elmqOF1D3Iz3zJPdg0i5K45IcWXEvEZ3Rqt7xsVir
   /jAb8fV/8zJF4dCZzGlkypyKGBWMw/2dMx0FTcP/Ch11/wLsoJkLBkCx/
   YO0yJHNGl//zUtPQUNGDyQ+P8fsKk9JuDkk/v4eocTWuigsHH5NzFiudO
   0kpz2MX8NVID1lqRem9bhxkxBNIzFigP0YMa1Xw78Zzy72Z0I3roIbD5j
   OmdS2SRSF6qBZrtpBWfu5CVx7KumMdHTbtYzpF7dovZTz5/Xl3VWnXBHK
   g==;
X-CSE-ConnectionGUID: WgHrBPWZR365RckGfRucUw==
X-CSE-MsgGUID: +UlKJH9jRL+wIuZIeHY4gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="62449459"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="62449459"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:25:58 -0700
X-CSE-ConnectionGUID: pmS7pV1yRJqPkZEn6XMIxQ==
X-CSE-MsgGUID: QYOKb70KSYSku4PXGZsZGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148205623"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:25:55 -0700
Message-ID: <a84cb244-deb8-4bc7-8220-504add900b88@linux.intel.com>
Date: Mon, 16 Jun 2025 11:24:55 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/14] iommufd: Use enum iommu_veventq_type for type in
 struct iommufd_veventq
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <208a260c100a00667d3799feaad1260745f96c6b.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <208a260c100a00667d3799feaad1260745f96c6b.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
