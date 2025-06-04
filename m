Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DFB1F4262
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749064051; cv=none; b=H80DyLZMnQqrx/jan8pt1tyoVXI4PlVqm+VFwotGAN21E88KTchFJnZJLrd7y9GarEQVbnSiRBlY2QBXsLdy1kR77udn8gl2YvLCQFoUNhugLtDsuDnvTOhYHycIdvxCj12aNaIm+Gzseh/Ps8QuPCo9lHsY/jSHHwU7r8ohCkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749064051; c=relaxed/simple;
	bh=xuR+iSiEc9fgmg6eICgOrNs8j588oMDceBJUZM6KnSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UiPaudI8SR2whC5wBPwzTKmyt3I3hzCEsWUp6GvNXFXxbxn0TqDe1FTvF6cEzaut53k3c0rW/4m9FEdVScaGl9LqYsJ/qE67zcDoOaXWpUhlVjesM5JLjqOrKgBFn2ttnkoTy0jNXRzy3dBlI5K7dNlyL1iqQWjtK2iPhR94VIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GIjpyX5o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GIjpyX5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749064048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDcwOgJcnxKoI9Ga21N4ZTVJAG6d9pqMLjrmq7B0SZQ=;
	b=GIjpyX5ofLOUwjxqp4AZ8iNmJg3xO/xCiXFqtNTKblmmXNwBSMzE8BBKHQn5zeRyyz9ZFn
	PirDJMqPT2kEmkAaSzn7gcEdIKUFhUpMidWZiC8XU0MpVIp8rr1sU8sEzL+Er18zEyjUqc
	JBuoKT/McsbRdXJHRtic+bL4IH5e2Dc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-j3gG4gwEMp6TG_SB9QRdkw-1; Wed, 04 Jun 2025 15:07:25 -0400
X-MC-Unique: j3gG4gwEMp6TG_SB9QRdkw-1
X-Mimecast-MFC-AGG-ID: j3gG4gwEMp6TG_SB9QRdkw_1749064045
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7d09bc05b77so30512685a.1
        for <patches@lists.linux.dev>; Wed, 04 Jun 2025 12:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749064045; x=1749668845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDcwOgJcnxKoI9Ga21N4ZTVJAG6d9pqMLjrmq7B0SZQ=;
        b=G6QikN43+UEiA22ch+qp1D3UD/NvkXPL68HGRDi4XjxJVWZX/41c++wPmDrY+78LP7
         2FIlBSfXPEH+26A+/bQ0MOJIjVzEYGIMyuNtbXPRLPA81CBNJwLV+dQUBkBtoCad4mro
         nKoHgo651/Tz3cwqX6Jc+Xtz6ttTWn8UOXRU1YXuUM2Pvgs4gcL1xrAVEgE2jmAKHfHN
         MC1wRWd4pyPqaWvYZIDQOWOysCmNp9uAYESJy5MpIdu0N38/rLkI2XvUe4pIy3JXCnIg
         3vkYLAkvQsqysQM4Wjjs3kyd86y+Rfgzmk58FaQ94Xcr4LJ/42zCEcvrY639q3PlRn6B
         pZ9w==
X-Forwarded-Encrypted: i=1; AJvYcCV45aF8GXdtztcc79SWiJBeVapjK65uIoSnu7siKVHOLj7/fRUZME1JB5KKpdIuDOH89QkBNmW/@lists.linux.dev
X-Gm-Message-State: AOJu0YwVdXYk8n8kD/U0UKhOXKUEfZnZrGV8JodszqHodibk+Bl5JYyC
	DVTuuIqQ0iGDONlRCZMz8DqlCNce9ZXUwFFOJATmbDhJZAHH8AZAm/0teCJTbE+UN9TNx7jAcmd
	mjDDFz0Di8VQuMDJdEwLheJnBtKz2p6KMxftLuK7yGkZUTUMHL2PymN1d+qA=
X-Gm-Gg: ASbGncviSAe1q+JUhKbh/lY1fxkimt+JEDzB75wBwHCZfvgL1sucyc7Tm9lCscG1INk
	H8yHkd3F0lUbGUvVTO5C1jaioUXczSPGfG66ap9c8A/eOiGkacylSooCsX6eatB9pedX9AuSOtf
	aQqdt/ESeaZ//IChhvIQgyIjv3uZbePXF7aQdZrBLjD9M/j+cK9FRXyz7Lte88rPY5hiZ4gHMLA
	JckLaUQgvymQuLdtlevCHHzh42M8B0khRO1zU17Pfjc/Pe6o6OGRaKTfP5YIlUpRPyWxpLuD1rz
	9IF4zzvfhPJe1UB5MV+zy6vTkgNlArQY+CGC+aMpcOsYHi3N+LA=
X-Received: by 2002:a05:620a:318c:b0:7d0:a511:3fab with SMTP id af79cd13be357-7d21988b7ebmr626684185a.21.1749064044752;
        Wed, 04 Jun 2025 12:07:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq/1wCy12sAvReQmIFAcfWv0YoxgYU7pWp9MBMGwc4L5cCHAlpE29zQqh42VKwrN6fkfeIpQ==
X-Received: by 2002:a05:620a:318c:b0:7d0:a511:3fab with SMTP id af79cd13be357-7d21988b7ebmr626677985a.21.1749064044133;
        Wed, 04 Jun 2025 12:07:24 -0700 (PDT)
Received: from localhost (ip70-163-223-251.ph.ph.cox.net. [70.163.223.251])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d09a1a76cdsm1079620985a.97.2025.06.04.12.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 12:07:23 -0700 (PDT)
Date: Wed, 4 Jun 2025 12:07:22 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Thierry Reding <thierry.reding@gmail.com>, Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>, 
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>, Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/terga: Fix incorrect size calculation
Message-ID: <iwix6xmwcg3bcenfdu7t3vp5dc4c6nu5orzytb5tu5abkorsro@5hoo7b5p6zwv>
References: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nkcgyGnxGWm2KNWolPdxmHWDJKX1ZSfQ6IenCNkhDgQ_1749064045
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2025 at 04:14:45PM -0300, Jason Gunthorpe wrote:
> This driver uses a mixture of ways to get the size of a PTE,
> tegra_smmu_set_pde() did it as sizeof(*pd) which became wrong when pd
> switched to a struct tegra_pd.
> 
> Switch pd back to a u32* in tegra_smmu_set_pde() so the sizeof(*pd)
> returns 4.
> 
> Fixes: 50568f87d1e2 ("iommu/terga: Do not use struct page as the handle for as->pd memory")
> Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> Closes: https://lore.kernel.org/all/62e7f7fe-6200-4e4f-ad42-d58ad272baa6@tecnico.ulisboa.pt/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/tegra-smmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 61897d50162dd7..e58fe9d8b9e77e 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -559,11 +559,11 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
>  {
>  	unsigned int pd_index = iova_pd_index(iova);
>  	struct tegra_smmu *smmu = as->smmu;
> -	struct tegra_pd *pd = as->pd;
> +	u32 *pd = &as->pd->val[pd_index];
>  	unsigned long offset = pd_index * sizeof(*pd);
>  
>  	/* Set the page directory entry first */
> -	pd->val[pd_index] = value;
> +	*pd = value;
>  
>  	/* The flush the page directory entry from caches */
>  	dma_sync_single_range_for_device(smmu->dev, as->pd_dma, offset,
> 
> base-commit: 7d4dfa6140f75b67f8eff3ae6ebc9937be94c4d3
> -- 
> 2.43.0
> 

The tiniest of nits with the typo in the summary of terga vs tegra,
but other than that.

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

