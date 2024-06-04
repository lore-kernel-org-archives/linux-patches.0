Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2D38396
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717518139; cv=none; b=ODDqCyXDH/dOnEU5Zu6IQ4HZwKmjfYoWARoAn/IQzJUlsqnlW61t9bbUQPjYZP6Jq10s/MW2g2chqdL4bnboQfmHFbEm6i0snqgLvW420ateDbd6J6sEEJm/FG8/N1oBTCkgVN2TkIe8kzosaX2ZkRY1F0nBqYG6rmBIrCYmCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717518139; c=relaxed/simple;
	bh=OJ36AuwpQLqkzU+IdAeCvginO1HJqjJkAx1SAuyFiwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tq42Sm2f3or20hHKxfknOmvE14Qy0MO2V38tqwsg2pqbJl0JUIG+zlduIWzF23KpdAQz9pxSHGZLGWJ2/k4i//1skiC0kF1hfpHEkxcJSfEx2UU6ROMeHJfpP8+l7pzTbIa2Co8u0/nyYFoU9oLIxs6U34d4uhMwOoHbcTEdtFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j9P8ksHY; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j9P8ksHY"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42152bb7b81so79545e9.0
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 09:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717518135; x=1718122935; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=69kRpuWxh68+JQDUzakiT+9vSzXmOCgYFNcr5dAKA5M=;
        b=j9P8ksHYNmktqOLIq6LQLOO7KFWlWNECDBxrbFIgqCQ7enF5EHn6SdwdO2azVADwnv
         Px6C8fc+bOdfvuIFkeSAn/6WEDpww0K6dSbdwoFdGg2B0Yyuck+dSQeHV6USOmYwyEkd
         TVoOQOBSkfDfpoUOA1TIrgeu3SqslE5B8lTbsLyw61/8P0B5X1Kbagkrf8/dqF4vULsQ
         dRpmNsypVPKLQ+LoOv8pk12nVwIF4V9O6Jly5SXlQsk9nsnsel/YCjUXIMcZRW6DScyx
         DB795jiR0cBCffvcwTD/MAN4GpoeUowE/xcX1aytnbAKsaKBiJpL2JHngvdxXxtBLYAa
         OHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717518135; x=1718122935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69kRpuWxh68+JQDUzakiT+9vSzXmOCgYFNcr5dAKA5M=;
        b=KlSq4996QfN6ZJEnb9vXRz4t0MAH/HJGBHu6i7xe1+hAHFJwp5tEP+6l9wPmujhJWr
         9DWK7PB4SmuBcCbvQD4H8ZjK57swwKDrZnraCs+CndiAjp/ba2fMjSfU2KTwEtc9qPAU
         mWTXws9pq+7stUvUamGyOyvtyeBOl4u3uOPp+qnYzvC+2y4Ij38lXWdVCkS8qSWC5lS5
         ClDyTIwpvMCx76YB+GiZ/K72EM75hTru2GMLT6pJRKfTCF/mZocVZPtNm/5+EtQOvFlj
         X3gm+nhsFKPrbKBFfKmafgh4cwzmL3I1HoWAxK1Sjkn/QRafhLkPes5zmY1dQjqCi4sj
         LQag==
X-Forwarded-Encrypted: i=1; AJvYcCWX7NFNrGxUFMPF5QpYcMNGFmRBI6MgGc5beSWa2iCG1TrfZEryN6Urwjgcvl+IimkApOv+a0PYAS2tkWQRNiPVWFn+2DRyPA==
X-Gm-Message-State: AOJu0Yx7EtxhrzTijeaazlpTlswMvVL/RYwmbtel3sEwnQVo0HLtfiRy
	6Li/5TCD2j5bxPJU6fkIQtut45F3mvUOYm0p75372yo3MkYJiY7hUfNMpUR+Ow==
X-Google-Smtp-Source: AGHT+IFHEt2e3Pj1nYGPA3j0RWpr3Krfpq7OpnL3UxZ5y5n1w2lAF8qBJKCqPcvPTCGtPLzRttnNNA==
X-Received: by 2002:a7b:ca46:0:b0:41b:8715:1158 with SMTP id 5b1f17b1804b1-4214947b20amr2926995e9.6.1717518135213;
        Tue, 04 Jun 2024 09:22:15 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd062fe2csm12068058f8f.69.2024.06.04.09.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:22:14 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:22:11 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 7/7] iommu/arm-smmu-v3: Use the new rb tree helpers
Message-ID: <Zl8_M0_Vc6-_h7WH@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <7-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:33PM -0300, Jason Gunthorpe wrote:
> Since v5.12 the rbtree has gained some simplifying helpers aimed at making
> rb tree users write less convoluted boiler plate code. Instead the caller
> provides a single comparison function and the helpers generate the prior
> open-coded stuff.
> 
> Update smmu->streams to use rb_find_add() and rb_find().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>

> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 68 ++++++++++-----------
>  1 file changed, 31 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 7a6c9aac4cd450..25bae0b05a488c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1667,26 +1667,37 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
>  	return 0;
>  }
>  
> +static int arm_smmu_streams_cmp_key(const void *lhs, const struct rb_node *rhs)
> +{
> +	struct arm_smmu_stream *stream_rhs =
> +		rb_entry(rhs, struct arm_smmu_stream, node);
> +	const u32 *sid_lhs = lhs;
> +
> +	if (*sid_lhs < stream_rhs->id)
> +		return -1;
> +	if (*sid_lhs > stream_rhs->id)
> +		return 1;
> +	return 0;
> +}
> +
> +static int arm_smmu_streams_cmp_node(struct rb_node *lhs,
> +				     const struct rb_node *rhs)
> +{
> +	return arm_smmu_streams_cmp_key(
> +		&rb_entry(lhs, struct arm_smmu_stream, node)->id, rhs);
> +}
> +
>  static struct arm_smmu_master *
>  arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
>  {
>  	struct rb_node *node;
> -	struct arm_smmu_stream *stream;
>  
>  	lockdep_assert_held(&smmu->streams_mutex);
>  
> -	node = smmu->streams.rb_node;
> -	while (node) {
> -		stream = rb_entry(node, struct arm_smmu_stream, node);
> -		if (stream->id < sid)
> -			node = node->rb_right;
> -		else if (stream->id > sid)
> -			node = node->rb_left;
> -		else
> -			return stream->master;
> -	}
> -
> -	return NULL;
> +	node = rb_find(&sid, &smmu->streams, arm_smmu_streams_cmp_key);
> +	if (!node)
> +		return NULL;
> +	return rb_entry(node, struct arm_smmu_stream, node)->master;
>  }
>  
>  /* IRQ and event handlers */
> @@ -2795,8 +2806,6 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>  {
>  	int i;
>  	int ret = 0;
> -	struct arm_smmu_stream *new_stream, *cur_stream;
> -	struct rb_node **new_node, *parent_node = NULL;
>  	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
>  
>  	master->streams = kcalloc(fwspec->num_ids, sizeof(*master->streams),
> @@ -2807,9 +2816,9 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>  
>  	mutex_lock(&smmu->streams_mutex);
>  	for (i = 0; i < fwspec->num_ids; i++) {
> +		struct arm_smmu_stream *new_stream = &master->streams[i];
>  		u32 sid = fwspec->ids[i];
>  
> -		new_stream = &master->streams[i];
>  		new_stream->id = sid;
>  		new_stream->master = master;
>  
> @@ -2818,28 +2827,13 @@ static int arm_smmu_insert_master(struct arm_smmu_device *smmu,
>  			break;
>  
>  		/* Insert into SID tree */
> -		new_node = &(smmu->streams.rb_node);
> -		while (*new_node) {
> -			cur_stream = rb_entry(*new_node, struct arm_smmu_stream,
> -					      node);
> -			parent_node = *new_node;
> -			if (cur_stream->id > new_stream->id) {
> -				new_node = &((*new_node)->rb_left);
> -			} else if (cur_stream->id < new_stream->id) {
> -				new_node = &((*new_node)->rb_right);
> -			} else {
> -				dev_warn(master->dev,
> -					 "stream %u already in tree\n",
> -					 cur_stream->id);
> -				ret = -EINVAL;
> -				break;
> -			}
> -		}
> -		if (ret)
> +		if (rb_find_add(&new_stream->node, &smmu->streams,
> +				arm_smmu_streams_cmp_node)) {
> +			dev_warn(master->dev, "stream %u already in tree\n",
> +				 sid);
> +			ret = -EINVAL;
>  			break;
> -
> -		rb_link_node(&new_stream->node, parent_node, new_node);
> -		rb_insert_color(&new_stream->node, &smmu->streams);
> +		}
>  	}
>  
>  	if (ret) {
> -- 
> 2.45.2
> 
