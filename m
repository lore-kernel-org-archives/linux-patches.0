Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8759296D29
	for <patches@lists.linux.dev>; Mon, 28 Apr 2025 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745866976; cv=none; b=Pm0xDYOwYxm9LSTX5g9AVwoQ7gI6DMz2FynI5j5rDu5071f+Q4kzXXyoEYZhzkVXAJ0nJMaKuZM2oydFsIMDa2NGkkhqlEceIfqvzg7Xch0QYyKcGxbZFqzjQdsFzZHxJQrCJWcsYSxUa85WdjD1pSRnRntbmPMEXCc8pKF9fSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745866976; c=relaxed/simple;
	bh=81G08v+RqUNeKeO9J3EQnr/p4nVDb1PF8OFcGNlg19g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9gSM0HcrEnEY80PlC+zPb/JNYgCfzYPqBvaaxMhFeKznhhRlR5WhVXuao7AtRk4K9iJGTXeMqPSvMgrV6qAGOU9pLCB9dQ4T1caImeS4LLr9G+plueUP1uAOgsoA7izSfnMXJs7k/q/PkQnnzIdecJRv3sQHf7LVBjpCtAYZDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oTkaU6Xi; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTkaU6Xi"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2263428c8baso25065ad.1
        for <patches@lists.linux.dev>; Mon, 28 Apr 2025 12:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745866974; x=1746471774; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYyPt2jR26wCNvi6PxzFs+Tv2/OybZasQ+Gm5GQ685c=;
        b=oTkaU6Xiii7ftP0hSrSXP1PClfARPtnIQXjOV/OLhzt4fyuRbXzRFIiil3lSJ3KlMw
         0FXv1mDYXBqhp02ZnKtARmD/7A3FJG/2Wqr+f6N3kESUlu9yFsNEdpPwFBPoA3ClsNtn
         9qOEz4RiIvf4ZRxqjsqH32AbvV9CgxzBZCXQVax//Xj5c+woIRK6IDWedqdcz9IYYX5H
         ftWsOMUQBD7sZCxOwE4h9Nesjg2LN8sUguBn642VQkANDrrU03uzTZPZWdbhdUnTmtAk
         gG9h785Gn3NlNhUTbvbwQKfRcEIPNmXJVXR3yE+GgyTuqf2WHIzOmrphfZSwP52IbVA7
         zOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745866974; x=1746471774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYyPt2jR26wCNvi6PxzFs+Tv2/OybZasQ+Gm5GQ685c=;
        b=lz7fOsAdbv1bTa34WJToOEKjEuxGqDH8J4CjNw9ksDfKzCSNPkKprFrGlkyyE1Wbn0
         nlfGGVgZIMu8gmG4UFsj9f7IfFKqYUs20tzys6PvpJPmy3F+IEz7jk89t8ozuOBnOLuI
         XPbaoEg+0dhGeKji5jjSXFHOIkXe/INo0fkppKkiU9zc42ssgab23hu0bXudyLqeokdP
         30u+E37GllE8TwxUK89Ftq23GjjbV0TIUsGT+E/2NVzQvZ7O/3bdhSsXOu6DND70YDyA
         sljIbW4zXOSpQHL8IquHLr4kgqINJP5YTjww5xlqmj9XcDVzIw1+PKq3B1NXw3A83Iso
         mJnw==
X-Forwarded-Encrypted: i=1; AJvYcCWHVmKM05L2zEr/uyndckHy2BkWpa+i93CjzwljlO6BNhckU2R/GdMK5ch1OOasaA2UTs4qIRic@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7jMkDpwTgnatxocz0Ya+RQx0YWLp7U74bpDrgA9+Hf/EvNl2T
	mdCpXlJZAnzTk5DghRyB1aCOKESP2WRARIXtzWbozvI8ZOyxCB0eRM76OlwHXg==
X-Gm-Gg: ASbGncs8xbKgRVFbiGQyCVoXYc6hLd8weefznqGleSRrZES/nESt8RETinxY/8Qe6Tv
	2QZnNmpvZLJ6tKYJJDsWjRUDYl2S9R53XItWQBaoqn5yZbPVnwSY9kIy2Sh6wJfFKKb+P0lHqKo
	7GtwKMnRBHDB324/geDdfIuBPEBXILFIWgQrVufMp2JB/2BdR4prUqR/ODfgYTyDbpQpCehIkas
	8n8VYTkfA1LENRo/8nGy+DY1N3BpGSDZvRk1J2wgo4ZNWHsJme6Nil1rle4YTIKxMGhyAKOMcjl
	iYlo/DGW4NCMS7+TEEw9+obCf5yhfg8KzfI5XkryRjxEY+6KyvBm31TMVA2XoHYz8W8euF6J
X-Google-Smtp-Source: AGHT+IEJGsiJDrtJlEO2nY+Xes9iIUQJtfbQGQMK+W7yiK5m4Ms2rwNKriCBn3CEAxNgqNLQt8mwbw==
X-Received: by 2002:a17:903:32cc:b0:21f:3f5c:d24c with SMTP id d9443c01a7336-22de6bc7c32mr473905ad.0.1745866973500;
        Mon, 28 Apr 2025 12:02:53 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309eef7cc58sm9392543a91.0.2025.04.28.12.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 12:02:52 -0700 (PDT)
Date: Mon, 28 Apr 2025 19:02:42 +0000
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
Subject: Re: [PATCH v2 07/22] iommufd/selftest: Add covearge for viommu data
Message-ID: <aA_Q0o74AySmRM2G@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <acb47bf56f1b03df9f6fca26f511529354be3caa.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb47bf56f1b03df9f6fca26f511529354be3caa.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:02PM -0700, Nicolin Chen wrote:
> Extend the existing test_cmd/err_viommu_alloc helpers to accept optional
> user data. And add a TEST_F for a loopback test.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> ---
>  tools/testing/selftests/iommu/iommufd_utils.h | 21 +++++++++-----
>  tools/testing/selftests/iommu/iommufd.c       | 29 +++++++++++++++----
>  .../selftests/iommu/iommufd_fail_nth.c        |  5 ++--
>  3 files changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
> index 72f6636e5d90..a5d4cbd089ba 100644
> --- a/tools/testing/selftests/iommu/iommufd_utils.h
> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> @@ -897,7 +897,8 @@ static int _test_cmd_trigger_iopf(int fd, __u32 device_id, __u32 pasid,
>  					    pasid, fault_fd))
>  
>  static int _test_cmd_viommu_alloc(int fd, __u32 device_id, __u32 hwpt_id,
> -				  __u32 type, __u32 flags, __u32 *viommu_id)
> +				  __u32 flags, __u32 type, void *data,
> +				  __u32 data_len, __u32 *viommu_id)
>  {
>  	struct iommu_viommu_alloc cmd = {
>  		.size = sizeof(cmd),
> @@ -905,6 +906,8 @@ static int _test_cmd_viommu_alloc(int fd, __u32 device_id, __u32 hwpt_id,
>  		.type = type,
>  		.dev_id = device_id,
>  		.hwpt_id = hwpt_id,
> +		.data_uptr = (uint64_t)data,
> +		.data_len = data_len,
>  	};
>  	int ret;
>  
> @@ -916,13 +919,15 @@ static int _test_cmd_viommu_alloc(int fd, __u32 device_id, __u32 hwpt_id,
>  	return 0;
>  }
>  
> -#define test_cmd_viommu_alloc(device_id, hwpt_id, type, viommu_id)        \
> -	ASSERT_EQ(0, _test_cmd_viommu_alloc(self->fd, device_id, hwpt_id, \
> -					    type, 0, viommu_id))
> -#define test_err_viommu_alloc(_errno, device_id, hwpt_id, type, viommu_id) \
> -	EXPECT_ERRNO(_errno,                                               \
> -		     _test_cmd_viommu_alloc(self->fd, device_id, hwpt_id,  \
> -					    type, 0, viommu_id))
> +#define test_cmd_viommu_alloc(device_id, hwpt_id, type, data, data_len,      \
> +			      viommu_id)                                     \
> +	ASSERT_EQ(0, _test_cmd_viommu_alloc(self->fd, device_id, hwpt_id, 0, \
> +					    type, data, data_len, viommu_id))
> +#define test_err_viommu_alloc(_errno, device_id, hwpt_id, type, data,        \
> +			      data_len, viommu_id)                           \
> +	EXPECT_ERRNO(_errno,                                                 \
> +		     _test_cmd_viommu_alloc(self->fd, device_id, hwpt_id, 0, \
> +					    type, data, data_len, viommu_id))
>  
>  static int _test_cmd_vdevice_alloc(int fd, __u32 viommu_id, __u32 idev_id,
>  				   __u64 virt_id, __u32 *vdev_id)
> diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
> index 1a8e85afe9aa..8ebbb7fda02d 100644
> --- a/tools/testing/selftests/iommu/iommufd.c
> +++ b/tools/testing/selftests/iommu/iommufd.c
> @@ -2688,7 +2688,7 @@ FIXTURE_SETUP(iommufd_viommu)
>  
>  		/* Allocate a vIOMMU taking refcount of the parent hwpt */
>  		test_cmd_viommu_alloc(self->device_id, self->hwpt_id,
> -				      IOMMU_VIOMMU_TYPE_SELFTEST,
> +				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
>  				      &self->viommu_id);
>  
>  		/* Allocate a regular nested hwpt */
> @@ -2727,24 +2727,27 @@ TEST_F(iommufd_viommu, viommu_negative_tests)
>  	if (self->device_id) {
>  		/* Negative test -- invalid hwpt (hwpt_id=0) */
>  		test_err_viommu_alloc(ENOENT, device_id, 0,
> -				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL);
> +				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
> +				      NULL);
>  
>  		/* Negative test -- not a nesting parent hwpt */
>  		test_cmd_hwpt_alloc(device_id, ioas_id, 0, &hwpt_id);
>  		test_err_viommu_alloc(EINVAL, device_id, hwpt_id,
> -				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL);
> +				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
> +				      NULL);
>  		test_ioctl_destroy(hwpt_id);
>  
>  		/* Negative test -- unsupported viommu type */
>  		test_err_viommu_alloc(EOPNOTSUPP, device_id, self->hwpt_id,
> -				      0xdead, NULL);
> +				      0xdead, NULL, 0, NULL);
>  		EXPECT_ERRNO(EBUSY,
>  			     _test_ioctl_destroy(self->fd, self->hwpt_id));
>  		EXPECT_ERRNO(EBUSY,
>  			     _test_ioctl_destroy(self->fd, self->viommu_id));
>  	} else {
>  		test_err_viommu_alloc(ENOENT, self->device_id, self->hwpt_id,
> -				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL);
> +				      IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
> +				      NULL);
>  	}
>  }
>  
> @@ -2791,6 +2794,20 @@ TEST_F(iommufd_viommu, viommu_alloc_nested_iopf)
>  	}
>  }
>  
> +TEST_F(iommufd_viommu, viommu_alloc_with_data)
> +{
> +	struct iommu_viommu_selftest data = {
> +		.in_data = 0xbeef,
> +	};
> +
> +	if (self->device_id) {
> +		test_cmd_viommu_alloc(self->device_id, self->hwpt_id,
> +				      IOMMU_VIOMMU_TYPE_SELFTEST, &data,
> +				      sizeof(data), &self->viommu_id);
> +		assert(data.out_data == data.in_data);
> +	}
> +}
> +
>  TEST_F(iommufd_viommu, vdevice_alloc)
>  {
>  	uint32_t viommu_id = self->viommu_id;
> @@ -3105,7 +3122,7 @@ TEST_F(iommufd_device_pasid, pasid_attach)
>  
>  	/* Allocate a regular nested hwpt based on viommu */
>  	test_cmd_viommu_alloc(self->device_id, parent_hwpt_id,
> -			      IOMMU_VIOMMU_TYPE_SELFTEST,
> +			      IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
>  			      &viommu_id);
>  	test_cmd_hwpt_alloc_nested(self->device_id, viommu_id,
>  				   IOMMU_HWPT_ALLOC_PASID,
> diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> index e11ec4b121fc..f7ccf1822108 100644
> --- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
> +++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> @@ -688,8 +688,9 @@ TEST_FAIL_NTH(basic_fail_nth, device)
>  				 IOMMU_HWPT_DATA_NONE, 0, 0))
>  		return -1;
>  
> -	if (_test_cmd_viommu_alloc(self->fd, idev_id, hwpt_id,
> -				   IOMMU_VIOMMU_TYPE_SELFTEST, 0, &viommu_id))
> +	if (_test_cmd_viommu_alloc(self->fd, idev_id, hwpt_id, 0,
> +				   IOMMU_VIOMMU_TYPE_SELFTEST, NULL, 0,
> +				   &viommu_id))
>  		return -1;
>  
>  	if (_test_cmd_vdevice_alloc(self->fd, viommu_id, idev_id, 0, &vdev_id))
> -- 
> 2.43.0
> 
