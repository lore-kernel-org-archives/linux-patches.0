Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AB1556B85;
	Thu, 17 Sep 2026 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653392; cv=none; b=KIvseWvQu8SHRSBA46oH2yqzvHyUvDPCt/SgXEvnuiQxFy2ydriSQf3iS3w319DNGTc4AtehjX/QCHnCG/KKQjwLi9Laxk+Hso1JaCErikpeGjXW4unCk1HIRRFEobu9rPSv3O/+8fFI6KFePoK8wurGLruvWXKwk/H99hva3mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653392; c=relaxed/simple;
	bh=cGE2EkalOjii1hGk7CCGEF4bxsitAjnoF4GCjMn4NIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxP0ZuwgkBe3oxIxhdUqSBd6vicN61acYWjzd80TQqpcMK8Gab0A5dl226cLZ+BgZSRWnWGiuFdyY/gQ2AFsnaijmWC/IRemqyIHN30FqOC79VLOWDhOvU6IMtskeJHZVeiTtpW3NjYOj02nQB2FlzG459f9QJ6PqvdkxGA9iRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O7QaN8q/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O7QaN8q/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DEA61476;
	Thu, 17 Sep 2026 06:56:19 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FDD73F7B4;
	Thu, 17 Sep 2026 06:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789653383; bh=cGE2EkalOjii1hGk7CCGEF4bxsitAjnoF4GCjMn4NIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O7QaN8q/Mp6bfa0AwDVKGRPBV4gcPWlP4+59EpoUDwCxhGUnlQlmBkXOXkCcd0cwL
	 UncUueYSTPHhmqDFRIKpZ2gbeAHG/ywbMPlOCeKtVAiawqgZIGoToK7dYkhWKXZVUu
	 aOAxtL2+YJNombE8jY84/F4dqALrCg6F87cXUPkU=
Date: Thu, 17 Sep 2026 14:56:18 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <aqvxgq2VR8XX-u04@J2N7QTR9R3>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <aquxuBnh6pdxu4-8@J2N7QTR9R3>
 <20260917131601.GY3968357@nvidia.com>
 <aqvuyse0hmNCGJqt@willie-the-truck>
 <20260917134753.GD3968357@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917134753.GD3968357@nvidia.com>

On Thu, Sep 17, 2026 at 10:47:53AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 17, 2026 at 02:44:42PM +0100, Will Deacon wrote:
> 
> > If we can do that without churning the driver (looks like we can), then
> > it's probably worth it, but I wouldn't be keen on churning existing code
> > for things like this.
> 
> Okay, I will churn this series then..

Thanks, and sorry that this feedback was last-minute.

Mark.
