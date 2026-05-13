Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BCA4C9008
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778689987; cv=none; b=PKzmzq5JjmCtUztcSz00wgMx7p9A0g2RQfKmtCF1NFt3g0RBrrBtmsyqMKBJY3/UkjG3iPrUuWp+sFZVf44E7WN7vT+yAO/yCh71bNCuTbzdVdPnaZeDQBOkvrUv1TMvEVRhzDhYohOwfs4S8z3sLWKGBkbpWIliumxHWgeNPfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778689987; c=relaxed/simple;
	bh=U5Kuz70QEO8JeRgxdQNiCHjSIXGmXUdHdcBBicOilso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9ipkqawl1aWEnTJcPKUujqiT81tAgAf4MNkBqPKCk6V3lHlijbXhF3GxN3bcSutO/cwfpQGuQmCVKjx/PIab5iYCvPeoTeOc6mIjcyZvZ4ZeSSMxIpS37ZakG2wG9y6m5TaVWt4q14P1LhyGipNhVJXkCgKErfwH6wtOctM1qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mUeqZJni; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mUeqZJni"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so5865ad.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778689984; x=1779294784; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPH9gxZhv9eNRRFpkdtU8/gFnPfL9onDepZYNNx2xcE=;
        b=mUeqZJnigzTsTBfiSE8b1ZqLIJUMK1Jur1UIVbLAXwcyOXeXX2kl2R2TX4cxX9rgVJ
         YZf6lqb9+sF4rM9pKwxxXrhAqQNFCsxB7SZxjNvYaMXMkIJwhQnmn3jD9cLJ4DstYBOA
         nE6i1G7Zql85vKVO1dIwsJzcSo1qKHyEU3FsQpj8xEQIAdBSXDzzx+alFxUN4CVqMnrO
         JGQ00q74/zMkX2JOJNfHqrOXbXZiLbVK6Gtxye3IKExXnHc6BIx/FKpvypbaPWw9zoG6
         5HdaMonYcK0m/+CmjN1mqAU2UspUzJeEHu4gCupVTfBQd1KWqxrSNtsxGKtmDyaAEqIl
         tRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778689984; x=1779294784;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rPH9gxZhv9eNRRFpkdtU8/gFnPfL9onDepZYNNx2xcE=;
        b=QY7AsRZT+UJx4pp7XE/NB6bLwwcZQSokEbUg8/3iuAeT936rTi0BPUsi9huzA+eJ4N
         BFxXz0PLz9zMJ2YSQtoE/S29e5IpsJyWUqK3KIBHcwLw/9AUTxHyecSAXtucUQ4z3TVq
         CtP3tTU+8TtYg7JwusC45x+3ntj6IlH25PLbg/2YBhRR7w83ghF6edoTUSh8Gw7tX4Kj
         QDpq88wJDZqgAG2LCb3H2VV6XNvW3nZzFRAW1yUVUIpgE03aBjBQ5YBdyL5bv3e9DeeE
         2ZkAjCrruPDpJDqz0FCvQf13Y1vuWy7I7TBL1W7szSXtSnw4kyH0ydnojl2zSYWAbA1o
         qlHA==
X-Forwarded-Encrypted: i=1; AFNElJ/ZckL1G7j4iAc+Ckpf1TPhaSf7rRiacnkruHI4SG8GzN6tRxVGIdz9tlHrQ25VYtvgjweZ7tcx@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+TsWr6irfR1x6stvmcer65gVdyV8b4de4HAw6dOktNDOQu7Vk
	F8ICG48u+jxmPNZipf7fVDoQFt0Vcsk+3SvCi6bol4dro8w48m1oRMJ5norJQWlKhw==
X-Gm-Gg: Acq92OFrhhi5DdU6B4KlgE+IaPEjDVZ3kshJPi1TufxCP9EG2r3NdSpbFg2MmfPXWxV
	2uoyqYC0XOURC/5NAbQ60yJYzNn4aqYBMpbzG9iltrzI6Gs+JehAw+R2LXqxMeIb8y73dLa/qmY
	CJZhvsVh8+7KQ3KgzFclmSjsp9nnwraRiQFNtr8CfSoczvbaQ9ULDksAKn3Dzvq0V13ZTSlF9qV
	wzPSLvSg3CMo81gYHrrUG9k+KWjLN6ctBW9eqD/Jf5Z/K29HT74S+1TOBTDpF/4MmuKbmyMiPGu
	55kvPq8dX1emyiPmZ9PFM9sfBANK7TNIOADJLx57/Z0aZcIGUPK9zLf1V+8hUCeDTvC0OJx8wjW
	IWi9vbszTdpZVf+jDHfn+w6HG2NlBDVNbJ4EMckh9PxN6QctvM2q0iOZEUqXHHAgaSv/L5NV6+d
	KuneT40jopSKeuz524PvpcTVzprdo44ExsVSh6/H4XVmPOeX6GHNVirn627IAlPEIxinIQlA==
X-Received: by 2002:a17:903:2a90:b0:2ba:3b89:c3a5 with SMTP id d9443c01a7336-2bd267913fcmr3711475ad.12.1778689983184;
        Wed, 13 May 2026 09:33:03 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2700dsm175960195ad.2.2026.05.13.09.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 09:33:02 -0700 (PDT)
Date: Wed, 13 May 2026 16:32:59 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Josua Mayer <josua@solid-run.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 1/5] iommu: Fix loss of errno on map failure for
 classic ops
Message-ID: <agSnspdMHD8Y0F-8@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:13PM -0300, Jason Gunthorpe wrote:
>A typo, likely from a rebase, inverted the condition and caused
>errors to be lost. Fix it to be "if (ret)".
>
>This was breaking iommu_create_device_direct_mappings() on drivers
>that don't use iommupt and don't fully set up their domain in
>alloc_pages() (i.e., SMMUv2). In this case the first call of
>iommu_create_device_direct_mappings() should fail due to the
>incompletely initialized domain. Since it wrongly returns success,
>the second call to iommu_create_device_direct_mappings() doesn't
>happen and IOMMU_RESV_DIRECT is never set up.
>
>Cc: stable@vger.kernel.org
>Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
>Reported-by: Josua Mayer <josua@solid-run.com>
>Closes: https://lore.kernel.org/all/321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com/
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/iommu.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>index 61c12ba782066a..6e53cfad5dc001 100644
>--- a/drivers/iommu/iommu.c
>+++ b/drivers/iommu/iommu.c
>@@ -2669,7 +2669,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> 		return 0;
> 	}
> 	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
>-	if (!ret)
>+	if (ret)
> 		return ret;
>
> 	trace_map(iova, paddr, size);
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
