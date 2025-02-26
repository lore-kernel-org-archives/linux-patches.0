Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC09454;
	Wed, 26 Feb 2025 12:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573102; cv=none; b=BdReNrtExM/p0990T/eyrP+KtCtwklAqRN0W2mmQs8bh61hl4OHSfGmF1ekUj/e331ImXoKGLCa84c1df8+VUZQUUQhUiou+lTDMVwzP/MA6IcY8wzh6UzKHRVhPGpaOO8947dIAujWpysbgMypBqOFlnSV27KgyAP4cLp0glNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573102; c=relaxed/simple;
	bh=afc2o7ByS+Aq4HwtiZsVeJaJLJlUP9V4slrBeXFjQn8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eDEetHYFX14F4wu+aNz5BU5GfQ4gWOt9Yrl9KjwYNEfgTCWHTOmabC1PSbrNg5XtcqMosrBQRkaUX/kX8zncPW1w+jLKOXQLCKCoe3tdDPlIi+QzJRJUI7eQqyfwpU63+fMEHPxade0DERe+tLCvflShwuZuTV5nTlUnGmeWtC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8r4/QwL; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8r4/QwL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740573101; x=1772109101;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=afc2o7ByS+Aq4HwtiZsVeJaJLJlUP9V4slrBeXFjQn8=;
  b=R8r4/QwL0MfUo5FYxYCI4qcXqDIwykUhJ5kT8bbiA8X1Rsanf/Q0cM2m
   pV9/Q0xnEL64KR8KOynEebBzYKaIvgpHIg3d4M/ytDLgn8g/FsvutiADY
   MuRwXSBFUkVnOHB9CRIwpvL7HSWbuwDVy9kYTZqUkZd3iq8LjMAIwYmTt
   7T0TJeHu0ivE5i/7MyvRuUKxaao79YLj0BM0rRghSrHRse2/mhtBXRWzW
   ri+OHzihf/Q5WeAozwY9NN+lgUDY82A2s5lb7TSsCbS/Zw0cVkYpN8ikz
   xuGyvogImOxBjRJjTcuTWPYdCLLOs67ufRqkBGoMGowl3XcePOJDqnPLv
   g==;
X-CSE-ConnectionGUID: 0Qr+qX4YSJW/2wc3bKyAxg==
X-CSE-MsgGUID: CIT2iEl1T5qheZmpwRdrhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41431975"
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="41431975"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:30:18 -0800
X-CSE-ConnectionGUID: +jUAibbHQkiSW9UiaTJzYw==
X-CSE-MsgGUID: JhiilTP7RRS5yHYOUzdzYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,317,1732608000"; 
   d="scan'208";a="117310467"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.105]) ([10.124.240.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 04:30:10 -0800
Message-ID: <a339ee09-4b12-4c05-a39d-7af5deb9ffaf@linux.intel.com>
Date: Wed, 26 Feb 2025 20:30:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Bagas Sanjaya <bagasdotme@gmail.com>,
 Joerg Roedel <jroedel@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 patches@lists.linux.dev, David Rientjes <rientjes@google.com>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 23/23] iommu/pages: Remove iommu_alloc_pages_node()
To: Jason Gunthorpe <jgg@nvidia.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
 asahi@lists.linux.dev, David Woodhouse <dwmw2@infradead.org>,
 Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
 linux-tegra@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
 Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Robin Murphy
 <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Sven Peter <sven@svenpeter.dev>, Thierry Reding <thierry.reding@gmail.com>,
 Tomasz Jeznach <tjeznach@rivosinc.com>, Krishna Reddy <vdumpa@nvidia.com>,
 Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>
References: <23-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <23-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/2/26 3:39, Jason Gunthorpe wrote:
> Intel is the only thing that uses this now, convert to the size versions,
> trying to avoid PAGE_SHIFT.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
