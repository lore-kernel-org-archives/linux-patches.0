Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09F73DEACD
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 23:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776210927; cv=none; b=lLAab62dGvMoOjKinDFUAa+3Gh9QKVuTseG4TcHRiyjpfId+LZxF8wKil0dBTFGL5LIr9+X1aFxWJpu+oYCwC9ItYisNc0T3AIMW2GtNiOb+gP8xS2d2nxOa6drtd2VjETY56WKKqhOVgHl49Fe8IGYzCN4vJ55hjBeNq2qckb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776210927; c=relaxed/simple;
	bh=bXthyTyPD8HJXtbc7b/60AdsnLfDVgyQtpflPFJn5cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIpaurIIaYDH/xjSWT8d/nb5Yr1LauLTraoJD8G+vN3+1+y8egM1WPdX0RIncNuyk0xhFQFgsvGKEg0rR21i5U1NgnJMIglhY5jVt15uZvwRKVRFfvNrgHnqdSLlAd7hcWiaCnqhbZt86qHPUNEtZQRaQyme93LyEEytnA3cGhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qof3BvMt; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qof3BvMt"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1270f10a774so51939c88.1
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 16:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776210925; x=1776815725; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpRjTKGiJT3SKKirJS2q6w9bl1zmBk9WenXtcrivl20=;
        b=Qof3BvMt36SZhH10IELpye1kI66flYCDPJVZLJp1sV5L5LMlIRH0uFd0WePoUkTf0h
         JL2mLZ/3uMMnMI3HN0GD2eZwqna1FIPUOniZHeRORMEUbl2W+GXbPW03MZsYE5/Ufp82
         NG+opXxhyhENb2gN6Ke+uRJdf33ZVxWS0vkqv3jRZrZP2Kg64ozawEcsy1KETVedIUuK
         kHu1H+LQixqS5VPfBTt/DkLBQheV2hkLQcftnNDAP6YfuyFznLtSJtjcc1An4BOuR0y9
         82c7D7NGvFA/FeAXwJ/7FvCBXb/efEclDXm2KadR7imo/T+DB9s1a0r/53pIJaWyrG7+
         t1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776210925; x=1776815725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpRjTKGiJT3SKKirJS2q6w9bl1zmBk9WenXtcrivl20=;
        b=nO1I67YNNEnhd+scAjjKGbhXcC+2a4mq5ZVtRuFIcPObh56U133AigPbDzeN3RidpK
         h5zviQnChIGvW/I94SoA0cyvCById4m8g/T3dIWecMsne3sr5cGXXrgi2P8AYDxfvox+
         YQPfl+8R+/wB8dilQet3hCSxEhXB1+C/lJ9u2EgzKPrSQUoTL0yydDKxaeTDtpFr0RB2
         z27YXjc1O6/CJDf6CZ/MOwKyLnuDw7pQGyF9WS4G+CQWBWdkcI/YUNePY9kPuO8sk110
         HsdBaYi4LE3Wz+KPeH4sckeS7POddTwu65ZIvU8QLK2uJ5+yEFlPJX8KjDrCKG0OpmuK
         XM4w==
X-Forwarded-Encrypted: i=1; AFNElJ+vbHwCb61sFzAODYSk9rVC/mQ3RMv8Ww3Wtf7VOqRTTASc98L/kXb73RpNZBIhxoVo4JplpTji@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8qBrbSESby2XLBPdn6byOz/ejWfnF7a9CyfpDXTTbSs2Nk+Dw
	RbRnb4Z9wiNB3r7BMESermHaJVCf+5dpfbCQ36WLcCyUo6+tfWdGob/qL9kwd7SE9g==
X-Gm-Gg: AeBDiesfq/yl/m/Aze+45UoSTWwhi9wveJd0rbb6Dx3KqmvbTf1V+hT+L67rYgWlCv+
	YQJq3AJQ/JuaHNn6iTN6Jl+17aJlBljunqSrwiYxmxg/jBzXjGGCSPPhncyepym9TpJMH+n9AqL
	NOE+volw/2rYsTeCHemFTCoGHjUe8GYo6VO7yvcwGxXF0YKTDWNcZU1j8vSM3DFwJFqoobRP8cQ
	Km7kplpBifUQdRAQFKPlqZ+QmwuzzRkQJenGcOmQs0CRB5FtMalS3CrrbNxVwnKPu0YTStUTZiL
	EP/BGx7B0gJQwBrFq0hsfz2WARqIWRXeujIw0SpzMfsBDVHusYaaovY0gDtqqhLliWGUEXBahZ9
	vQuNHF6kwQp0gug+1LONzb1t5z+49euv20wsJIv+lNOhLgxJ2k8UKV8gqxEUmB8LHI7E0fUE520
	MUtah+mn1dUxq3k4gEibEIgYrNpw7WKcxg68shtHnh/zXsVrIS9YpRgCnd8etyaKCGTjbyUkAxQ
	dHo7czRcvk=
X-Received: by 2002:a05:7022:ec07:b0:120:5719:624e with SMTP id a92af1059eb24-12c5cf56253mr22645c88.21.1776210924021;
        Tue, 14 Apr 2026 16:55:24 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c345b6208sm22430017c88.8.2026.04.14.16.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 16:55:23 -0700 (PDT)
Date: Tue, 14 Apr 2026 23:55:19 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	patches@lists.linux.dev, robin.murphy@arm.com, suravee.suthikulpanit@amd.com, 
	wei.w.wang@hotmail.com, will@kernel.org, kpsingh@kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH v1 1/1] iommu/amd: Don't split flush for
 amd_iommu_domain_flush_all()
Message-ID: <ad7TzkuA1VC26vkk@google.com>
References: <20260414210626.2097722-1-wnliu@google.com>
 <20260414210626.2097722-2-wnliu@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260414210626.2097722-2-wnliu@google.com>

On Tue, Apr 14, 2026 at 09:06:26PM +0000, Weinan Liu wrote:
>We have observed multiple full invalidations occurring during device
>detach when we are done using the vfio-device.
>
>blocked_domain_attach_device()
>  -> detach_device()
>    -> amd_iommu_domain_flush_all()
>      -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)
>
>      	while (size != 0) {
>
>          -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
>            -> domain_flush_pages_v1()
>              -> build_inv_iommu_pages()
>                -> build_inv_address()
>
>         }
>
>build_inv_address() will trigger a full invalidation  if the chunk
>size > (1 << 51). Consequently, the guest will issue multiple full
>invalidations for a single call to  amd_iommu_domain_flush_all()
>
>Without this patch, we will see 10 time instead of 1 time full
>invalidations for every amd_iommu_domain_flush_all().
>
>Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
>
>Suggested-by: Josef Bacik <josef@toxicpanda.com>
>Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>Signed-off-by: Weinan Liu <wnliu@google.com>
>---
> drivers/iommu/amd/iommu.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>index 760d5f4623b5..bcec8721d228 100644
>--- a/drivers/iommu/amd/iommu.c
>+++ b/drivers/iommu/amd/iommu.c
>@@ -1769,7 +1769,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> {
> 	lockdep_assert_held(&domain->lock);
>
>-	if (likely(!amd_iommu_np_cache)) {
>+	if (likely(!amd_iommu_np_cache) ||
>+		size == CMD_INV_IOMMU_ALL_PAGES_ADDRESS) {
> 		__domain_flush_pages(domain, address, size);
>
> 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
>-- 
>2.54.0.rc0.605.g598a273b03-goog
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
