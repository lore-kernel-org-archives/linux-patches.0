Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C475E74BED;
	Thu, 17 Apr 2025 14:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899935; cv=none; b=JZG3r/ux3vKQFjpUILNNWUgTXg21GPkrePJZ6b/fM9yJz/GJ4HPazc9t005KvaFzzSuQSgfRS8qkEQCGynAFsn96uHBBOgpa53q4aHyCe/rylqPw0rAg8xmUha2QEB9952aNq/JNAHo335Rea6f4NZvQzW8FiPzS7jbg2cVgipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899935; c=relaxed/simple;
	bh=/HJPLJW7CBCK1J9D/Tt5sZhelJYUDsDIjSLUZbWv1OE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMAmpL19lJ0uYNbNAdSjf8ah3jglHC7zM8ZOHNxNkFoH4G9j++8QuP2SrocplVKsEijf8Uub/mA3tCWTZxfEL4HNFXg3+Ylhn9uHZ82GHwZrlJxJFDl/ptOqn6Vhrl2DVJhgv3aHP/rW9NfXSCi3BtNNHzz0OZzP2QAWeUs80Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=EuElz7+Q; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="EuElz7+Q"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id E900D485FD;
	Thu, 17 Apr 2025 16:25:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1744899931;
	bh=/HJPLJW7CBCK1J9D/Tt5sZhelJYUDsDIjSLUZbWv1OE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EuElz7+Qx317T37R6Xk86MhTtQwxCkmp7UHTFVuhPJMl9k8WUHkrpkhEHjiIIU05a
	 HAzRnmkgmL+RUvIuZioUKw7Vlp9fZaCDnvU3iA4vVdaEZsHSVM/0fMzv6HIRkOKA1H
	 chS5VzHsAK7xJzIE/CfhOd0QMQq1TCQw4LQUF9XGapf525Y1ufDPhOH9Vvq34bzNc5
	 NoIPQRHmnCzb7eL4G8h21D64hMj6oM4CkSXYLdrD78OqxWTP5I/Jl8OmL36GnsK76B
	 +iNsSxMcEukAqjZx3Ur+ZnLAflFKwuDuR6GXgtRCL8p4ZN1N1sjzsv0I5KMogrNGV2
	 EkNWoKRqfm8Eg==
Date: Thu, 17 Apr 2025 16:25:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/23] iommu: Further abstract iommu-pages
Message-ID: <aAEPWXaBocqgsvbR@8bytes.org>
References: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>

> Jason Gunthorpe (23):
>   iommu/terga: Do not use struct page as the handle for as->pd memory
>   iommu/tegra: Do not use struct page as the handle for pts
>   iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
>   iommu/pages: Make iommu_put_pages_list() work with high order
>     allocations
>   iommu/pages: Remove the order argument to iommu_free_pages()
>   iommu/pages: Remove iommu_free_page()
>   iommu/pages: De-inline the substantial functions
>   iommu/pages: Formalize the freelist API
>   iommu/riscv: Convert to use struct iommu_pages_list
>   iommu/amd: Convert to use struct iommu_pages_list
>   iommu: Change iommu_iotlb_gather to use iommu_page_list
>   iommu/pages: Remove iommu_put_pages_list_old and the _Generic
>   iommu/pages: Move from struct page to struct ioptdesc and folio
>   iommu/pages: Move the __GFP_HIGHMEM checks into the common code
>   iommu/pages: Allow sub page sizes to be passed into the allocator
>   iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()
>   iommu/amd: Use roundup_pow_two() instead of get_order()
>   iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
>   iommu: Update various drivers to pass in lg2sz instead of order to
>     iommu pages
>   iommu/pages: Remove iommu_alloc_page/pages()
>   iommu/pages: Remove iommu_alloc_page_node()
>   iommu/amd: Use iommu_alloc_pages_node_sz() for the IRT
>   iommu/vtd: Remove iommu_alloc_pages_node()

Applied to the new iommu-pages branch. I think this has the potential to
become a conflict nightmare, let's see how it goes in this cycle.

 	Joerg

