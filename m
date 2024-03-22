Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA13604BD
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129739; cv=none; b=plUpdVnZJ9/arApSezh1lZhpH9ywaGMK8LyDQrkPPED6INMwNT6TFSDHnL9NzsLSXuU2aI3PQLFVtebncrlIW1H3x5smOnj/CIFNAa9xcvNZxTkLXGL5zP2xUMtPDmSYq8GWoqhLLZLfrDtIkezNpGW73SvDUjwTmms8LDOxKuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129739; c=relaxed/simple;
	bh=r+4PuloVCi8RDOAoyLYF9VmfzCqPgx10kp/bvJjIT/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkDvAdj2FgT0epdgYdzYmo17DMA1NQm0pU842J9uuOUpl+vjupPLwbf8a5j7cskKStNcmdOnI/WqEnzSQDtrKlhbP/EVok0YZkIA8K+k5SGNOrokROE4syVa3s6GMnvtJn81Uhm4F03PJIT9oGn8meJrNVCG0sjloITSj6cusxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uyo/gwlZ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uyo/gwlZ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso7805e9.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 10:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711129736; x=1711734536; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mzqp/6dLgjMqKDQyf3mrQct0p3T2914IUgA3ZIQhwEo=;
        b=uyo/gwlZ+Gnh/pAeOd7xnbka/IeM9WNbURPgG0ybEGZkaxsE4kd5Nu2/bLawsU7VSt
         G6urUY/bITaEFPN6977GP2wBgrCL4S8h+bUdYwi1Lo2DRTmZ0u6hJNSADjh3mqD4dEzo
         mn8bY1bHFcxmg2z5RzIDGahTP3uRu3YA/yYMoBS1XjA50YlsOXw5592QVp/srKU5cqbz
         +UHaiolZJtLHOPHSgM0DPhbt35RCpvZNkR6wwyUMxbCGnt+AWbly7mAX4uMMY2NsEYtg
         HcfvZrgfJgj9NhjBwcqVL73ygGb52snPy68hI4gnO9yUdHXt7lcNNF1zpO4IUchC8YLS
         jY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711129736; x=1711734536;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mzqp/6dLgjMqKDQyf3mrQct0p3T2914IUgA3ZIQhwEo=;
        b=RQaw8bmsJKTaSeHLS7Q6bD+ttGC5X6sJn+A1UTzSZlJUmNTlMGINot7/8sbsdoljvw
         n84DaZsjH78aQHQZU64kqxzNBXe0cF3jHel2mgswKjrgMdsWKs/2VBqZyLKUVjxpdwil
         pjO2QfGXtG90hIBEfWitwPohRVUkQXEGFvlZWjUCJ4t5EhO2QeRak2hmsbgdwtW1qBQn
         Xcx6IrC/dJk3MXbKnfwsNEnOvYwRMlwL/guGMScTvkkFcT6LB/o1QvAe9/OFWk/v9A79
         vi6iMycw61XKN/U0JfeyhdOcM7SoTMy4kMTaTxgfonsaQgSd0V1QUAwkku8uuztaGomw
         cYKw==
X-Forwarded-Encrypted: i=1; AJvYcCXLCmo5Ogus3CFquN32PDCrBWU1JrqlBHFG+R4XizGxzc89/5YY1D9eukK98LuHzaZgtgLuwnHTGgVI8eunUxpWmHH4JgrQ5Q==
X-Gm-Message-State: AOJu0YzLCbIBIhvW+4885BfCSGlnQrJ59ZAtvaR2kI6kveKmo+6q/Gzu
	NDtpXQeOVmzB6g3V6aB8S1BSOys2lpLCCo1zVg28MQ/WkRbz8c/rKuIL8OekAw==
X-Google-Smtp-Source: AGHT+IGHu63FaJns9JaXXBeuHGQZAWu5RyrwAL0IsGUibXz84z8HGlng2x1LsE39qLp74E9EsXarBg==
X-Received: by 2002:a7b:c40a:0:b0:414:11:ec14 with SMTP id k10-20020a7bc40a000000b004140011ec14mr534253wmi.6.1711129736458;
        Fri, 22 Mar 2024 10:48:56 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id d1-20020a05600c34c100b004147dd0915dsm152246wmq.21.2024.03.22.10.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 10:48:55 -0700 (PDT)
Date: Fri, 22 Mar 2024 17:48:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 01/27] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <Zf3EhA5ZBNwF2XOr@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:49PM -0400, Jason Gunthorpe wrote:
> The SVA code is wired to assume that the SVA is programmed onto the
> mm->pasid. The current core code always does this, so it is fine.
> 
> Add a check for clarity.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 2610e82c0ecd0d..347c2fdd865c1a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>  	int ret = 0;
>  	struct mm_struct *mm = domain->mm;
>  
> +	if (mm_get_enqcmd_pasid(mm) != id)
> +		return -EINVAL;
> +
I am not sure if that is needed, the only caller in the tree is the IOMMU code
and it does the right thing, as that check is removed later anyway, I don’t
think this patch adds much.

>  	mutex_lock(&sva_lock);
>  	ret = __arm_smmu_sva_bind(dev, id, mm);
>  	mutex_unlock(&sva_lock);
> -- 
> 2.43.2

Thanks,
Mostafa
