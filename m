Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14DC386C0D
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934476; cv=none; b=eb7o3uh42OAp0dzuHIF8JPObErRbt3tvpv4iV0mGrqV1bJIlkxM97QYHBtlDvnohkBsBdep3LoCe/iWg0voyuiveXdo68C2KVQACPHZnO0m+go5QQGUS/yxKuPpxmv5N6/IZUB3n22DOz2XdTrVY9BnXiQtA6SvkSNlNQ23qHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934476; c=relaxed/simple;
	bh=RzOqRkn/R0QNDsfK7K++CoXWWR3SbKNw/NPdyEFB+4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHN8EbXOnQzlB4IeD137NpdbAFuqhYMUKb07h9996gPP6nskQFnkq7oPE0Sw+WtxITcNE4dfUzY/2OTCEf/jgncROQwKaVN8lzJ34wrMqWTa4zBusBVuhau8Zw9np17zHyVIcw3K6MG48FxmVhR0cMC9Dvhj1PIFYKgqO2K0QWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yj+Rkhar; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yj+Rkhar"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b45cb89f7eso31282955ad.0
        for <patches@lists.linux.dev>; Mon, 04 May 2026 15:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934473; x=1778539273; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5BrO7xosGb8uYxA7cSQfYj/uPUPleoSCzn2z5rA8SqU=;
        b=Yj+Rkharxh0lw883ITFUZF2vHIziLSH4ntoxXowboUKof5kgmfpSuEl4Izvy63aflm
         8+Q4ttZhfKh7qpoLwuI2e/RvPtjnOLxmDSuefUpRDkUYDXPEIkgHWib7oq8JJoeFU+2v
         FMKNPR2V1QpSul81ee7ATaB2eFizyKTviEgg90FSWt4MPwnZAd54pENaUDnzw2S1wWdO
         cLxvNozkRWITEY56RkOPi6B3pCT4EvYSGiaP61BF/QyBUI4Vr1ZEVH2Osk/5JFPHDCnC
         nL59G1dae+6+6DbM0ebbM/P70MK/ItFRoPMDfztmW3mVJW0y2GKl6ZvRZ2QdqdfkyCG7
         0ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934473; x=1778539273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5BrO7xosGb8uYxA7cSQfYj/uPUPleoSCzn2z5rA8SqU=;
        b=iQKZLBAk0k7LHgj16xzG1IoifVXxuakbgoQ/n5cUoOlzKx+zeGClyRgPZA1Dlteo3U
         S7QD4cPbF1RonKgMW16ZmByqJqD6TiqSdbsvhbcSeKpFhNAcMMWXnN05e9ytWwHPenLN
         VMisaT8NxVAzX3qii2OQxFa+w1LA7C5zY4PDvxA60E2cU+kXtZtabAWbj1483FjQvyi6
         i7wpjl4BpiWw4r2Am/OeviDWwMasl4zyMrHG0iSMudAApltxJPgIEW4cYhG2/wDCemKT
         CZ5f2a+HahFMeCqYhz5clMYio5/taAx7PAm6ERGoY5vJp3qi+lTpI6bVHZedSU8O7XzX
         EABA==
X-Forwarded-Encrypted: i=1; AFNElJ+oPgoyNyHL1mfGAKdduzaAmtMP40rqT3kds1//JrZykuwRweXFklVLE+MFbbijDuBjpxQxJ2Ds@lists.linux.dev
X-Gm-Message-State: AOJu0YwTlSqxya7RXUhK8vA9UMDj2DSjhDODLjQYI3DtuIXcVjP6yUNv
	u8+609F10KRnP8ztM5xkbM8kGGmR+Iwd8ewvbWPjSjv0hCyWHpO2KZMEXZjYfBvRlQ==
X-Gm-Gg: AeBDieuJJNx00RiJYxjMPX0/YLFwifIgXWncKy35SOKDZfC7qTqM0qxyGtgKtYyeOCh
	CvVH14nPl8BdkDp78h2a24rSWKMgo+1UzfZIm2Nhs1laVv4UuIeukS2IY0XflAk0udwaooOIezr
	MqZiMQo0s+DMt4d3nbE/ntli0ocgkcUPIKoMDMLtRNtg8dtCW7v6CG8AmHYMCzT6RIdSFSWf42Z
	szbWosNdOcIWc/AH8oL9zcIYo1Rh50BszOErjxqNqwUUzZaVpMozJS7RmPxQC5IUPwn2msIZXVO
	Pt2o7Gu90NNNud7li3/Fwt88aM1iZBR5JP029GwbX2l6RrRjLDbxm/uzB95GANVBV9Yvv+x5gS7
	KxeF0xMeIVQp1iM43kf73vI+8ZkIeCr83OvWMarHek+RpLDv6BNDl/umkElwnIV3aljjKiZCPcv
	tBM70ILPiNsDCgewDTMTUGRdCng5vrBho1GCyBOS9YbruzsJ7798Geuzs5OAuP2HsGXrBlkNHjT
	rqL+kvQF/G5656s
X-Received: by 2002:a17:902:e547:b0:2ae:6259:5aff with SMTP id d9443c01a7336-2ba535ae6c3mr4752285ad.6.1777934472389;
        Mon, 04 May 2026 15:41:12 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7ee38sm111789655ad.16.2026.05.04.15.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 15:41:11 -0700 (PDT)
Date: Mon, 4 May 2026 22:41:08 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 10/11] vfio: selftests: Add mlx5 driver - data path and
 memcpy ops
Message-ID: <afkghFm9Vo-SfF5c@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <10-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>

On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:

> @@ -1368,6 +1716,11 @@ static void mlx5st_init(struct vfio_pci_device *device)
>  	mlx5st_alloc_pd(dev);
>  	mlx5st_create_mkey(dev);
>  
> +	mlx5st_setup_datapath(dev);
> +
> +	device->driver.max_memcpy_size = 1 << 20;
> +	device->driver.max_memcpy_count = SQ_WQE_CNT - 1;

What are these limits a function of? e.g. Is the 1MB size a hardware
limit? Can we change SQ_WQE_CNT in the future to increase max count?

I'm interested in this because for Live Update testing we've found it
valuable to keep the device busy for several minutes so that it can do
DMA continuously throughout the Live Update.

> +
>  	dev_dbg(device, "mlx5 driver initialized\n");
>  }
