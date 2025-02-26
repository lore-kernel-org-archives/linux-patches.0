Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC27269B0E;
	Wed, 26 Feb 2025 06:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740553193; cv=none; b=HvSEr0vMvQ4+h3LwBAbBqLGIM2z+IKexIEce2Vie1rZkKo9TXtqibgkyR4PZA/Gz83kSZumLk8lm2VMrtd0Tau69/RMHfT4ng8GQjGoqXx7ldV0W0kyOtEI+ESuHtf1J7CGQ+YvpTqfG2h+Bq+rX5ERfw2f4yyKry5Wati95WOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740553193; c=relaxed/simple;
	bh=qpSxoD9rlSgkQH/htkteQeAZ4TqZJLdpOv+rX9TDkNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ek+SC5/iIAO1dv9VsYcb6/VLr7lfqfzaHyYHopSyVYPe1eqMlhdn04U65emQ1DQ5U0kKCSPMLyyx/Phf3jcwjrdV3MWp8rQKIETgVtpIYPXP8QLpYzjtCi5Um5rCS4xObS6IcdLLjnKOw0mn2Li21BoRJJeZDoLI99YW0ywqB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eKrBksxE; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eKrBksxE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740553192; x=1772089192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qpSxoD9rlSgkQH/htkteQeAZ4TqZJLdpOv+rX9TDkNo=;
  b=eKrBksxETGmj1EewkXS89AmkxqkegYLPwOPxZLOazAsfjFolAvbxyqGQ
   S/+kcjbRK1U+qIwacgNfKP+rlG3PitcOQpG1jCXF5F2ClNEfS5cNKDC2v
   6CyDh25dL5h8cykjvJmOQY49h9Yx/V4mJcPqXleX+3ZEQidaQBN69MIFg
   pRYNYsDdqRt9HpgigblRIYajaGS/K8FKzLgYCLCYTwp417QMSTe8sm3cO
   fL2iAOAOAofvUFzcbEcZCtP45pl4ZPXJPPVo+UDvis4LhwiozW7aqEzUs
   eQ9zhmOUKezMpK0FUKxkJ3u4eS0BHZD1BiVFpZ8D4r+R4NGm1K5qLkrCx
   A==;
X-CSE-ConnectionGUID: 3DcwKSTyQy+iXi0o3uoF9Q==
X-CSE-MsgGUID: kuwj/r8IQhmKTsdPgiLrAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11356"; a="51596072"
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="51596072"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:59:51 -0800
X-CSE-ConnectionGUID: gU9ME5xMS/Sg/5K4xpwzVw==
X-CSE-MsgGUID: pqpzR+GkRgCwrPW8n3kWtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,316,1732608000"; 
   d="scan'208";a="116621933"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2025 22:59:43 -0800
Message-ID: <6d9ceeb5-581e-48e8-a5cc-100a9699a9e8@linux.intel.com>
Date: Wed, 26 Feb 2025 14:56:29 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/23] iommu/pages: Formalize the freelist API
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
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel <jroedel@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>
References: <9-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 03:39, Jason Gunthorpe wrote:
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 38c65e92ecd091..e414951c0af83f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -326,6 +326,18 @@ typedef unsigned int ioasid_t;
>   /* Read but do not clear any dirty bits */
>   #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
>   
> +/*
> + * Pages allocated through iommu_alloc_pages_node() can be placed on this list
> + * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
> + * can be used this way!
> + */
> +struct iommu_pages_list {
> +	struct list_head pages;
> +};
> +
> +#define IOMMU_PAGES_LIST_INIT(name) \
> +	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
> +
>   #ifdef CONFIG_IOMMU_API

Any reason why the above cannot be placed in the iommu-pages.h header
file? My understanding is that iommu-pages is only for the iommu drivers
and should not be accessible for external subsystems.

Thanks,
baolu
