Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CC230ACF8;
	Thu,  6 Nov 2025 23:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762473113; cv=none; b=VGyQ85VNwM1t1b+J5wOIHzhEHXVao7gPtExOHsIwGol0Jt4NgHXMlEdodZV22alzOnFCk148HikabU+1p6fmmqrnbWBkPKQySc8CSrljnhUWJTBOanhSZh0ikqVuqvMeP/WiKg/SHwayheFmqVz/MgMuIIsPafiFiPbMnLIADKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762473113; c=relaxed/simple;
	bh=1r9rZlb4VCGCo7+deHV2au8qhWRkIByakZglqBor4oE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlf3f6DCiMF15fBpWSm7VqCvpqV9vNAwYVKIB9t6M8E9Al1DTbtpD/CjbrbG6uzGh+HDK9/vbOPVbjlVVUtQ0grXwivH6qAsWt/N9AQN8XoXRhz5BV5edFflp0g+6HC2PTNP0rwXDKChFNvrZ0IHdlyzNWXReV3Q0eTYw5MtHdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ADr9CPVj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ADr9CPVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=bivJn1B4YN9x+a2BQepOh/REkAwwnFwkqrC+v7zjyOk=; b=ADr9CPVjQXy2tC7P9AF9lVa8Nf
	oRjU779D0gmW4at76TGE4NhECZzw8rd95q0UHVSjH27YEfdzlNVqBdfvi3YkxuPSdOr+bmnEBD7S4
	w6W6i+MQM7cdgTbLCbz6j3TWg1tv5UqtLToxQ0NnDHnhnbrm0NylbA5a/Q1jIPZHvRdRkDBqZQKei
	K3iu0bd5SGulQAe4Omv8JTaKQN806EpnnmPG3FqATbLgmKI+DXnGBx4zjnfIQC5c4BO5PU7dsYigp
	IjHPvx8SdyMHZA1r6ayrm/H/hPFsIKXMMt2drS/Vyyc6wn2j8TYbdkfhwsqDOgPfhFUuPnLbScQVs
	9YN9gXhQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH9le-0000000GPcn-3Pjy;
	Thu, 06 Nov 2025 23:51:50 +0000
Message-ID: <ae80fd29-5799-49b3-9c7e-76225e7998bc@infradead.org>
Date: Thu, 6 Nov 2025 15:51:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommupt: Documentation fixes
To: Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-doc@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <0-v1-e93135a62eee+1e4d-iommupt_docs_jgg@nvidia.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <0-v1-e93135a62eee+1e4d-iommupt_docs_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/25 11:02 AM, Jason Gunthorpe wrote:
> Some adjustments pointed out by Randy:
> 
>  "decodes an full 64-bit" -> "decodes the full 64 bit"
> 
>  Correct the function parameter name for iova_to_phys()
> 
>  Use the recommended section heading style.
> 
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 2c8b644f3901 ("genpt: Add Documentation/ files")
> Fixes: ac7ffd8e805c ("iommupt: Add the AMD IOMMU v1 page table format")
> Fixes: e530a2c3a098 ("iommupt: Add iova_to_phys op")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/generic_pt.rst | 11 +++--------
>  drivers/iommu/generic_pt/Kconfig        |  2 +-
>  drivers/iommu/generic_pt/iommu_pt.h     |  2 +-
>  3 files changed, 5 insertions(+), 10 deletions(-)


Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
