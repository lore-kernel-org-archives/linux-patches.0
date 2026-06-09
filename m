Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83A3B19A9
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781024620; cv=none; b=Tt0RM4jjyMpm5bGi0qWn94XB2jD1dFJd8g/56RU1Rwgj18QSEy7FDSOyRorW+GM5+LsGgaaTAkoW01GpIznTwiKzqDh5LjBmmrRrwJSAQkNx0gpVPkrEriuhAOCnkTNcRYSq7klrPvfeSnmqJWGf7KbiGVSwKIxuxz1fAT+dbog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781024620; c=relaxed/simple;
	bh=S+ORIibTBKQ0pFdjGliKCIE3wa/sE73a0IDa+NYkQBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qz7LTlQDKa1JqB8vffZ5LJadr0oF9uu8CVJW1LcVxsqydzBHezpd0ra9SnjjgDB0smwLBSdlvXjc/xe4mbf9aWzzzwjN4yKhJYeBqpciU7mF8D84r4TNygJuSqqKFetzQH+t023M3vjhlvKlrnvnKVmQiCVcdrnMl7ZgemfRLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cRAKbirO; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cRAKbirO"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2bf2911f93cso460355ad.1
        for <patches@lists.linux.dev>; Tue, 09 Jun 2026 10:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781024619; x=1781629419; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2CN/F+xLRpEvDTUPWxMr6FI2U9i+V7+WZC6JlOTISM=;
        b=cRAKbirOblT/a2V9ipsycFxgWBWGFzRCCXF395Et5rLrYGG9sejIuGXE2ofTCJ05ha
         W3vSq102fT2pBWdp7gqC6b4iaoKKe2yilyEmunxeMUDay28lz4w5Cbq4ViSucnAlyrgh
         hM7hMmX2DriCEDNg09y8qfXv8uEgK+vCN4cl6tgASMxVjKG69XuU2tRqTL62k1xFkPkd
         eEysYAZYCAjXl2N6xaitXnfW/C0PHc52a4Wp7e13P6QXaMfWkxTSX3ufare4ZuZYEPA8
         vmGrVhTEfD0oIb2VonTlivIhChfBEZ87hT6z0VJub9TPpjBiTCrB/4MWaJX45b6Za5J4
         7aTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781024619; x=1781629419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2CN/F+xLRpEvDTUPWxMr6FI2U9i+V7+WZC6JlOTISM=;
        b=ODsBCqavNpKm8eUQqXVLahwwKS8ybg5HCY5Qjekn4xd2IOv6fJfK3RPE4QsIx4eqXu
         mBW5Jz0RO0KDBw+QPQf0yqCsyGkg7cWOT4I5etq6MCIvFlI8G+7mcxAf/TJcjpFZW0UE
         ioFHIouJ2G6syFOZfaV5S4Zmoygyn0hjzN+UDrf01zu6atLnrUluYk2piMUbU11ZDmTw
         xsaGzz5Wnhd2DDSm0V+vzH9JhbtNLODhjICRg5QABJA5pxU03SGtGhiGfVZgCUSNXiMx
         r6RzdL1yz+KgvuKGZ4j/yM9xbdkiUB5xxnSBik6rf+LyTRh/SE/F99QXgnvwA0DjIBcO
         zKPw==
X-Forwarded-Encrypted: i=1; AFNElJ8gLpL1uaeZBq9Ouqq4evZ5Lv52R4+yJRvtofODFVB3gafPNigOmaFCi/GP1m04pJGXhnxv8RVx@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3G1pzrU83DrZtoJIIANoxSrbiDPRY80+8N0/W8RwQLyO7u23K
	xn5keufB287ghXn8UZULlU7LNemrkWgLnrgiBJZugCpiZyIigI0t76+nlcczAphdPw==
X-Gm-Gg: Acq92OFZmT6Bbu5QWhRuh8vpGExpxLIFHg/6I8l4An0ljYTga6K1js9qy+1DUQwGv0U
	32HRO8j1dFXT5PW/k0bebx+yRerwjNhTnkplaj4W1MxIY0WBprai5FjvvCuNddYLId1yaeVHG/7
	0kX+5sWkmgoCf3g1V59uKsONwzZjlIk9ya9mR+2vCto7KrsoWi86XXKJcmrnoxowyIxRtd1BFYw
	kv7wIWNvFc+HDUzBFEvgtMZmyZhminH8AoqBain3zo3sQkGev8yht9twI34ty7n2T8VdAi1ZHZX
	r6y0Zjb+VuYIy5zLJV8syttRzxyLq1sl7bLxck8LKrx3YL4ivGd0NCGtxl6PfLHFwPcNDCQx8MY
	2TY2b+hJMDKP/uGeK0SLZvjgu7gyNFKljdj/H2j2bEeRz+Z7ww4rg06xR7i159mmayiDlDMVQe4
	XE2RRGtr09KVPGENm7cX6abORbhEVtZsWCsQmRpPiUGOlZAKC7owVA+GTBxgehrsS5WyluRhUpz
	o8h83YYbQxwx3j3WDXJIx3WkIidYw==
X-Received: by 2002:a17:903:3d10:b0:2bd:6dad:3dfa with SMTP id d9443c01a7336-2c1eb9443abmr8784635ad.24.1781024618140;
        Tue, 09 Jun 2026 10:03:38 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c86151154a8sm10528937a12.22.2026.06.09.10.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 10:03:37 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:03:34 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leonro@nvidia.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Mark Lord <mlord@pobox.com>, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH rc] iommu/dma: Do not try to iommu_map a 0 length region
 in swiotlb
Message-ID: <aihHRieLr9oEaNEK@google.com>
References: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>

On Mon, Jun 08, 2026 at 03:10:04PM -0300, Jason Gunthorpe wrote:
>iommu_dma_iova_link_swiotlb() processes a mapping that is unaligned in three
>parts, the head, middle and trailer. If the middle is empty because there
>are no aligned pages it will call down to iommu_map() with a 0 size
>which the iommupt implementation will fail as illegal.
>
>It then tries to do an error unwind and starts from the wrong spot
>corrupting the mapping so the eventual destruction triggers a WARN_ON.
>
>Check for 0 length and avoid mapping and use offset not 0 as the starting
>point to unlink.
>
>This is frequently triggered by using some kinds of thunderbolt NVMe
>drives that trigger forced SWIOTLB for unaligned memory. NVMe seems to
>pass in oddly aligned buffers for the passthrough commands from smartctl
>that hit this condition.
>
>Cc: stable@vger.kernel.org
>Fixes: 433a76207dcf ("dma-mapping: Implement link/unlink ranges API")
>Reported-by: Mark Lord <mlord@pobox.com>
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/dma-iommu.c | 19 +++++++++++++------
> 1 file changed, 13 insertions(+), 6 deletions(-)
>
>This was discovered because iommupt errors on mapping length=0 instead of
>making it a NOP, so it is an became an issue since commit d6c65b0fd621
>("iommupt: Avoid rewalking during map") making it a regression this merge
>window.
>
>diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
>index 54d96e847f161b..381b60d9e7ceaf 100644
>--- a/drivers/iommu/dma-iommu.c
>+++ b/drivers/iommu/dma-iommu.c
>@@ -1918,12 +1918,18 @@ static int iommu_dma_iova_link_swiotlb(struct device *dev,
> 			return 0;
> 	}
>
>+	/*
>+	 * After removing the partial head and tail, there may be no aligned
>+	 * middle left to map.  The tail still gets bounced below.
>+	 */
> 	size -= iova_end_pad;
>-	error = __dma_iova_link(dev, addr + mapped, phys + mapped, size, dir,
>-			attrs);
>-	if (error)
>-		goto out_unmap;
>-	mapped += size;
>+	if (size) {
>+		error = __dma_iova_link(dev, addr + mapped, phys + mapped,
>+				size, dir, attrs);
>+		if (error)
>+			goto out_unmap;
>+		mapped += size;
>+	}
>
> 	if (iova_end_pad) {
> 		error = iommu_dma_iova_bounce_and_link(dev, addr + mapped,
>@@ -1936,7 +1942,8 @@ static int iommu_dma_iova_link_swiotlb(struct device *dev,
> 	return 0;
>
> out_unmap:
>-	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
>+	if (mapped)
>+		dma_iova_unlink(dev, state, offset, mapped, dir, attrs);
> 	return error;
> }
>
>
>base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
>-- 
>2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
