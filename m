Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4923595A
	for <patches@lists.linux.dev>; Mon, 16 Jun 2025 21:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110317; cv=none; b=mELIBJWdV/FWs0x+qdx5WQmoIla+new/dYT0cxJytkbiAbHR+fGFTdlkUxQ8JksF7yE8dSceF7d5ZCcZd1wn/q0ob0QtRNiMHbVHaFDZ9j7k00MmIOr/Sm5m//jFqW6mZvsxKyfdiCjk/YVFEjEDOPupK+OAnSazlneMwksqfwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110317; c=relaxed/simple;
	bh=ue0zZGnlayFFocKO6DHpjurxQEhp5y8cZT9f9F34YpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWTEhZHLv30+/i8kkcNn0JIoF1waLN8dZWRSoA79xLE6ZreyjlNcq26UqVTvFfyhvMW6zvSfJNiN+xDOJ90VOUE2FAHxJAFwdqlDV7C6n64aM7Lwv/a5sEi2G0bDhoQK5DT9OM1EdQPMaVdtUtjdJroGsl55kkWQ/zn3Ux6/Dig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ziS4kUSo; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ziS4kUSo"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2348ac8e0b4so26225ad.1
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 14:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750110316; x=1750715116; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PkxtSh5lJN8oDluqdUpIdBWts0li7o6KCp4HMQP+7eU=;
        b=ziS4kUSoEOCzZhZW5Yy3B4YOYWa+J7hhw+EXghANMe5sH/9gc8sTEqZvvIhJGZolS1
         9JLWzKRIc/S+QiX2Z2JtQxI796cmhpTZg74aQ0ui+DBY79smYj6BEpXjtCGoD8xFPCzf
         HPZ6P8zeAx4tJFrI6qSJ3ERP6Lqfq4qQ2LBpx6tuy4PLp0tTs/TKzNVzG7Dpp5idbODs
         zEZfAP49+kOZycziiM80aHeGvo84QEFqwfFSDhM2GDwvs5QqTHxjy/XWhzOinAiFyYmU
         PES7/ReQpz8HlvOpd7ejPleLv9pHXanOrdb8b6wFD19/67wkW6hKTrjvBM+x+dEwBUdA
         LDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750110316; x=1750715116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkxtSh5lJN8oDluqdUpIdBWts0li7o6KCp4HMQP+7eU=;
        b=gBXXYl2kowxWG5v/2J6GwBoPcCPOrNV0jAv9FxM47GBBCZ/eM9B2ycoE+eUUwwJpi2
         pXCr2kpOwrSY/o4vA3qOhcTlrj8uh0nHbAEubBpciAfS8oX+gj0vv4LkngsMURbpUETk
         EVJtWoO3WKP5VL8oAPdHVbys9sZ7R/6XfOzBS3PtQpbjcspuFkt82dafR3U0SU9l3Oju
         hd7pKPVMzENt5rWxPtRmSW6QjFQ9eMyouik2e47jo8eWBR98v9NiEYD+gDqCV5CAoXZf
         sOBrpg9azTSWzlXFotKn+wePawCxmuZ6sj5pyqfqHvEfraL6Mm2bxnhPcoa3cIUXEzeH
         hxOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/36TiBsqbhjnizMYXzkZg2qnqlSnGea+4CSumPxpGMsYGWxVmKYUDvhzx3YVlc00DxqKAOog9@lists.linux.dev
X-Gm-Message-State: AOJu0YzuzlRuPBbQWTAlwpjymtY5rLnXBjml5lIMKfwMdE1fiM2fhmZY
	PAue5k2+nHzN+HZt1/s8POPBbYStfHYtNw3m6C8Gwjj0pPwTfeIf5aHqD0cXOFZxWA==
X-Gm-Gg: ASbGnct6khoGqtsx/NHm1YMM+tgHmA8Pvfh2uoZApuHppKau7jdyMKdGDn1KKQf1sW3
	/JDqSDhFl19J3X+twlrY1BPZRxoGard90orQ2yVa1XwWWrxUX1aAABnPjMD0JTWC+2JS4BSBPLi
	O0MH5GT4I3yhUKiSJot72PEskuBp6L/WXocXtua+xYcYuTWSKS2rnHaU9CjZkRppt3j2aGkKQsL
	gyMGce/6oImCyLaVdMp+iYMyyQfOvccfvxlFBDRxjw+Dx/Eo1oLQZCmHv6eKtTeUBhNDWNTSs+E
	b9k1TdKd2HGDfGD/HHtbM2MaIKZ6x8+XWQotJ1V0PrVsoqqWY8SB2y0sLVaGfkpfK566rN+5EhT
	c1xddzlxTHBRHBT6U9vvf
X-Google-Smtp-Source: AGHT+IHrQDyvVnwCf9csPzPlw1hS7k+ZaNmE2pdHcui8ltcFiMTENAodaPPmibhzeNqADUXMrthyDA==
X-Received: by 2002:a17:903:1a27:b0:234:bf4:98ba with SMTP id d9443c01a7336-2366c5bf768mr6063095ad.6.1750110315130;
        Mon, 16 Jun 2025 14:45:15 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d1ceesm7328258b3a.161.2025.06.16.14.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 14:45:14 -0700 (PDT)
Date: Mon, 16 Jun 2025 21:45:06 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 03/14] iommufd: Use enum iommu_viommu_type for type in
 struct iommufd_viommu
Message-ID: <aFCQYqHostKg0YVt@google.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <6c6ba5c0cd381594f17ae74355872d78d7a022c0.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c6ba5c0cd381594f17ae74355872d78d7a022c0.1749882255.git.nicolinc@nvidia.com>

On Fri, Jun 13, 2025 at 11:35:15PM -0700, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.

Super nit: Typo: s/init/int

> 
> The viommu_alloc iommu op will be deprecated, so don't change that.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommufd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 498c9a768506..ac98e49e44fe 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -101,7 +101,7 @@ struct iommufd_viommu {
>  	struct list_head veventqs;
>  	struct rw_semaphore veventqs_rwsem;
>  
> -	unsigned int type;
> +	enum iommu_viommu_type type;
>  };

Reviewed-by: Pranjal Shrivastava <praan@google.com>

>  
>  /**
> -- 
> 2.43.0
> 
