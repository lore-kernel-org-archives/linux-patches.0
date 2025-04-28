Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438F26A0E3
	for <patches@lists.linux.dev>; Mon, 28 Apr 2025 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745862643; cv=none; b=s4nEjQWKBb+nhjySwLYymrp8zrNdW4z632eNz+xxDfNb3gLNLJPuzvhgDy9Tmqc2iwyDltWPqaoIvrZktXqT+UOaQXFOwWNqkavab5fD1rKFZxl6w9Ar3N0/brTpl9pQD/whxOBbY6AHtmUDJ7TbHzNCBXk1xrEftSbVQMnyfBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745862643; c=relaxed/simple;
	bh=OvAf2T+pBvdBVQKKD1SCkOQm7K3cKaRnrNfz9b6U1KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LeCNdtq89y3EyHCVOoIABmxPfYYMQwQ534Bn+YwBjvy9jQxbLY5jt+oBbOywtCq3R3ui0UGWSbn9GYPDNOvl9dqeFkY6YSxSRmkwplxncnO8PjL3w9zQD1G302XNApSpLM5nlseXn0FU0PBV+5pPQuIajPL6dGW9X36nammykxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JDdG1xyw; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JDdG1xyw"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2263428c8baso13015ad.1
        for <patches@lists.linux.dev>; Mon, 28 Apr 2025 10:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745862640; x=1746467440; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mEMzzefTttNVGmGGFEF+tVQHWP3i8v0cb/h12OtES4=;
        b=JDdG1xywZXxxGMl3iE/v3WW0O8wbE1s3Vz6X6zMTSMsEAz8x86G0wY0qMtUWfnQQ1+
         wxWUh94npiY6KxwfBqn9KJn+HUrR5ljG4kqE7QjtuplDXb6YYsvi3ZujhIzDhqgTUlIv
         CTMefH5aIVE9WzDea3Qnpqot4GfUKVMraRA9SiMo5zz7OL0g34130BZQxUsRcErFoDOc
         NNtI1ORFtnZocIflyEDjLshK4YW9kpBF0cLjZHq/M4qn8x5P8gjKhYULAcgBPLGa0piM
         Z+DHVykTYWDUwHF1La4+mAR75QbUNWdwRbKuwzPMqzgovKGOuft1wW1ZDt2gXPhNwnvU
         j2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745862640; x=1746467440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mEMzzefTttNVGmGGFEF+tVQHWP3i8v0cb/h12OtES4=;
        b=do/Ina8e3lVyXSr7g4Y7jgKNsfUieLseAnYZoo4k0dZclc7yH5j8H9o8hk3Fls2KUq
         XLT7YF8hDIpB6DbZ/xcCu7P2cG/q1HQnckXTroi/6Trs4/13d/ztJ0IG9hfxycNFnuVm
         l9CGi2gGY8Nj8jkXwf6xEeXdSKJ814IpB72pgX9YucKJE202nnpqFxQZqy68h2fhzyZs
         /Y7HooXTlkmJse4xj0f5VrFsnjACThcXJlCCj/OTAKQ+tI22OykPcWzu7jrbtzRQo0ca
         lvkrRkjoo6fO2DMimY+AZMnSSP4TQ7BVc6BHC7mMIQext2qPGsstpG9uDDwTFndIt3m5
         DS5g==
X-Forwarded-Encrypted: i=1; AJvYcCVnEl9wa18wW/MaX0uW9rVwGX43O1FQ6OQnTMQwDLwZC3qlwULyAhz4pp+C1x1yoWW3g37TBYXM@lists.linux.dev
X-Gm-Message-State: AOJu0YwHj2PzAW4R+K77OS4kLB5AecejUcihjLHYl1a7fEjIUldgSxa4
	fzjcgC2IrDq3Nu/orMcU8RitqNqu4kgRw4SN0AZQ2DomhAxgdeuLobdNjJEaBA==
X-Gm-Gg: ASbGncv0GgY+sZOGidAZbU+tUXmiTUDb6+9RLoZn8ZSDzCpHPu/iJc7wFCZNXwszgB/
	bjBicK3vj/51s+caWafuNmbuRuefJNx3THbk9nXWdz7sduYQS5BKVK3tZa65u2OB5lbj5QqK4iP
	5pAZyRddwKutSR++JMxp8pQ0fdce95NVXVvqUzquVA6CfmzKKbl/Ue31xT2LVQJHZmtaYo2uopX
	kKRM26AY2LjsMEKZeqLIwZh0JSy3aFD4wQNxwjXJBNiBSFMHSVHp+Hbm5f+CIli96wz0+k6tC1E
	lKKH7JX+Wh2e6bbQDrTXUVR77Rm5WQYKk8CZATjLKKYHcffgslt3DQGgKUi7w/rEhjhNK2Ix
X-Google-Smtp-Source: AGHT+IFdvGjCZd8WihYpKKAdbavzVYWBtSaBNCLX1v9EIv3lNKixiHNvn3PMdFhA2dEanqkbNONo4w==
X-Received: by 2002:a17:902:ebce:b0:229:1de5:e8c9 with SMTP id d9443c01a7336-22de6ebc37cmr33095ad.13.1745862639534;
        Mon, 28 Apr 2025 10:50:39 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4db9b02sm85788765ad.56.2025.04.28.10.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:50:39 -0700 (PDT)
Date: Mon, 28 Apr 2025 17:50:28 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 04/22] iommu: Add iommu_copy_struct_to_user helper
Message-ID: <aA-_5FQK0uZPdGVA@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <ca032e90c0241fe0653023fcb655185dba763f5f.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca032e90c0241fe0653023fcb655185dba763f5f.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:57:59PM -0700, Nicolin Chen wrote:
> Similar to the iommu_copy_struct_from_user helper receiving data from the
> user space, add an iommu_copy_struct_to_user helper to report output data
> back to the user space data pointer.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ba7add27e9a0..634ff647888d 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -562,6 +562,46 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
>  	return 0;
>  }
>  
> +/**
> + * __iommu_copy_struct_to_user - Report iommu driver specific user space data
> + * @dst_data: Pointer to a struct iommu_user_data for user space data location
> + * @src_data: Pointer to an iommu driver specific user data that is defined in
> + *            include/uapi/linux/iommufd.h
> + * @data_type: The data type of the @dst_data. Must match with @src_data.type
								   ^
Nit: Must match with @dst_data type.

> + * @data_len: Length of current user data structure, i.e. sizeof(struct _src)
> + * @min_len: Initial length of user data structure for backward compatibility.
> + *           This should be offsetofend using the last member in the user data
> + *           struct that was initially added to include/uapi/linux/iommufd.h
> + */
> +static inline int
> +__iommu_copy_struct_to_user(const struct iommu_user_data *dst_data,
> +			    void *src_data, unsigned int data_type,
> +			    size_t data_len, size_t min_len)
> +{
> +	if (WARN_ON(!dst_data || !src_data))
> +		return -EINVAL;
> +	if (dst_data->type != data_type)
> +		return -EINVAL;
> +	if (dst_data->len < min_len || data_len < dst_data->len)
> +		return -EINVAL;
> +	return copy_struct_to_user(dst_data->uptr, dst_data->len, src_data,
> +				   data_len, NULL);
> +}
> +
> +/**
> + * iommu_copy_struct_to_user - Report iommu driver specific user space data
> + * @user_data: Pointer to a struct iommu_user_data for user space data location
> + * @ksrc: Pointer to an iommu driver specific user data that is defined in
> + *        include/uapi/linux/iommufd.h
> + * @data_type: The data type of the @ksrc. Must match with @user_data->type
> + * @min_last: The last member of the data structure @ksrc points in the initial
> + *            version.
> + * Return 0 for success, otherwise -error.
> + */
> +#define iommu_copy_struct_to_user(user_data, ksrc, data_type, min_last)        \
> +	__iommu_copy_struct_to_user(user_data, ksrc, data_type, sizeof(*ksrc), \
> +				    offsetofend(typeof(*ksrc), min_last))
> +
>  /**
>   * struct iommu_ops - iommu ops and capabilities
>   * @capable: check capability

With the above nit.
Reviewed-by: Pranjal Shrivastava <praan@google.com>

> -- 
> 2.43.0
> 
