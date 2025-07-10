Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E623B631
	for <patches@lists.linux.dev>; Thu, 10 Jul 2025 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752147388; cv=none; b=UH05m67t5MlA6j4odMvCBvE+46Agh4tYw4l2EGlk8io/yg/reNIloiyKXr9R+mS2TvluX3NxwHbaSKLQ0nbyGaciT0XfneTsjvdmTjeXRxyYMkmX5PKLxmju0jdBTQ69lw4EFn0Fta9dhIMuaPsoh1jefIZ28u3YhYisdnMoqJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752147388; c=relaxed/simple;
	bh=UrVre70QQpxPX3cK8KkrQ8iIxZBZksB7bi1biJ1kzFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmRc7XnjTBocd/4YLCn/wSfY/ad6IuxAF5YmthYwjqFE3fAMwn8aITcfvqo0BWG1Xe+A3C4u6PfLv9CzcwEyxZ/AZlXvugNc0ekAvvjR4dvqJ7vKn2blo+nM/geCN9qYJ0zbrSxRclQkj3H1GUXI5H6AetQHbExxz4lzdO6Qev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kDUxV92k; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kDUxV92k"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-237f18108d2so171515ad.0
        for <patches@lists.linux.dev>; Thu, 10 Jul 2025 04:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752147384; x=1752752184; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NllAQfNayY8cb5iLzosXwdI782jVJrwH9mu2C3D5sw0=;
        b=kDUxV92kB4IfA0yN/wlAGn+NAA7N2PBRi1VoI92/dahIHIuTs77H0mJtM9Q5/KStKq
         uwa2SnJsLmt1ax5K1XSS1G0vD8+KWIJ+cB/X1gzOaxFAklNuHSja+2ISotRXj5i4qxTJ
         B8wpheBKY5fyoigtJzvRZxcwh9SDAkVip9Sksfn5K4BsOz4t3G8/FfZ6KWcnLPo8VDrG
         7U5DztG9Ohszs/4H2FgqGEqueARxom0IObeMEpgi5iI/sB+w8eF3UQhP6MfSTnKk7R+f
         eCAh+Xh3pMPiakw3W3U0vVRuFiaj0IDUmwrkUjQFIIKorhxpBmOntM5VmgwTbekh3oU/
         ALug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752147384; x=1752752184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NllAQfNayY8cb5iLzosXwdI782jVJrwH9mu2C3D5sw0=;
        b=mEHi0dfcohQVMHP/gwKdusGdXhc1kELO4lQyyxtj/RCm5Wc9yLenmb78haocvpHG5f
         4B/XbN7WAVVFiWs8mFQMW5prBJLIlTJKbhOlZffx0PSiUoDEevY7wq8Iu7Q8rLae12h7
         U/o6eDBjIx68aMha1K8euw5Nplc+rZ6IH4vxDNRKZnDMent58WNjRdUrxmG1Pfz/+KE1
         lZ1QaL8q5T6h7fCY2CkzmXH7c1YoFeoJOYyuy4nuklkYQ4PmJVwGR1kBQBYC/wTopwUR
         DI5wCzuaqgciUvs41bPKzzUqL8XQqOAOKIGPRTzZFZiA6nfcN6sLjCbB9lWGZ1CT0YmM
         SrSA==
X-Forwarded-Encrypted: i=1; AJvYcCVqIRt8OBDszkUlsp30fH0IVGHRIWT+beo0n7tnpbdJBKk2u9ywB2MaUVQAxywr1nl680mtDjLe@lists.linux.dev
X-Gm-Message-State: AOJu0YxhWalLxC/IdjaIadxvA/rFupo9CRNwwlS4M4uTz2+67kDj7xYk
	rYwz5IHAceQHp30C0C5EoLxk78smftI7kL4yIvZBVrGrUeDdml7U7OnSgYyCsJM7Qg==
X-Gm-Gg: ASbGncvLfxxfBdHDC5yGKliE9xHpqAX0Wir1cyM2ZKloJzqD8UMLWbrA6pWPFXQ5V9f
	zUu9L3y2HEBDpun7utIQcwpC0Qhlm3U880CXMZXBO3hQA336/CA+C4Q5VrrNQj5GdpwoMZMRMpK
	I08qYFWn/OXqS7RDrgXzWdtWON2p7Lysu7MLGHILT8Z6/PIxHTALVCzG8ST0YKPjIpkACkeMt9Q
	M/vbAHiWsW9aP9vuis9+piR4KPP7qC/r76gr78ipn2mViGuGv2LEmIKa4q0/g6xyStuip6L1fmg
	rI+MxI55O1tDOdUK6IGC20wYk6QhP9eC8ocs//2JFbzK/qpMfta0LWa+5h9MdpYFuViIsJYt7N4
	ZJqyWl3VVyMgb6Onhgouu
X-Google-Smtp-Source: AGHT+IFWWBrqFVRqrzk0Fwyab1Mld4BviLi8cbgIh+j6R1xSHmEyatBRaGWIq1+8HV4NnwrugSgVcw==
X-Received: by 2002:a17:903:3ba5:b0:215:9ab0:402 with SMTP id d9443c01a7336-23de38137a5mr2696735ad.18.1752147384158;
        Thu, 10 Jul 2025 04:36:24 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9e07793sm1937009b3a.69.2025.07.10.04.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 04:36:23 -0700 (PDT)
Date: Thu, 10 Jul 2025 11:36:15 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net,
	bagasdotme@gmail.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, thierry.reding@gmail.com, vdumpa@nvidia.com,
	jonathanh@nvidia.com, shuah@kernel.org, jsnitsel@redhat.com,
	nathan@kernel.org, peterz@infradead.org, yi.l.liu@intel.com,
	mshavit@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v9 16/29] iommufd/selftest: Add coverage for
 IOMMUFD_CMD_HW_QUEUE_ALLOC
Message-ID: <aG-lr9nUhwff4GuJ@google.com>
References: <cover.1752126748.git.nicolinc@nvidia.com>
 <e8a194d187d7ef445f43e4a3c04fb39472050afd.1752126748.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8a194d187d7ef445f43e4a3c04fb39472050afd.1752126748.git.nicolinc@nvidia.com>

On Wed, Jul 09, 2025 at 10:59:08PM -0700, Nicolin Chen wrote:
> Some simple tests for IOMMUFD_CMD_HW_QUEUE_ALLOC infrastructure covering
> the new iommufd_hw_queue_depend/undepend() helpers.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> ---
>  drivers/iommu/iommufd/iommufd_test.h          |  3 +
>  tools/testing/selftests/iommu/iommufd_utils.h | 31 ++++++
>  drivers/iommu/iommufd/selftest.c              | 97 +++++++++++++++++++
>  tools/testing/selftests/iommu/iommufd.c       | 59 +++++++++++
>  .../selftests/iommu/iommufd_fail_nth.c        |  6 ++
>  5 files changed, 196 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
> index fbf9ecb35a13..51cd744a354f 100644
> --- a/drivers/iommu/iommufd/iommufd_test.h
> +++ b/drivers/iommu/iommufd/iommufd_test.h
> @@ -265,4 +265,7 @@ struct iommu_viommu_event_selftest {
>  	__u32 virt_id;
>  };
>  
> +#define IOMMU_HW_QUEUE_TYPE_SELFTEST 0xdeadbeef
> +#define IOMMU_TEST_HW_QUEUE_MAX 2
> +
>  #endif
> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
> index a5d4cbd089ba..9a556f99d992 100644
> --- a/tools/testing/selftests/iommu/iommufd_utils.h
> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> @@ -956,6 +956,37 @@ static int _test_cmd_vdevice_alloc(int fd, __u32 viommu_id, __u32 idev_id,
>  		     _test_cmd_vdevice_alloc(self->fd, viommu_id, idev_id,   \
>  					     virt_id, vdev_id))
>  
> +static int _test_cmd_hw_queue_alloc(int fd, __u32 viommu_id, __u32 type,
> +				    __u32 idx, __u64 base_addr, __u64 length,
> +				    __u32 *hw_queue_id)
> +{
> +	struct iommu_hw_queue_alloc cmd = {
> +		.size = sizeof(cmd),
> +		.viommu_id = viommu_id,
> +		.type = type,
> +		.index = idx,
> +		.nesting_parent_iova = base_addr,
> +		.length = length,
> +	};
> +	int ret;
> +
> +	ret = ioctl(fd, IOMMU_HW_QUEUE_ALLOC, &cmd);
> +	if (ret)
> +		return ret;
> +	if (hw_queue_id)
> +		*hw_queue_id = cmd.out_hw_queue_id;
> +	return 0;
> +}
> +
> +#define test_cmd_hw_queue_alloc(viommu_id, type, idx, base_addr, len, out_qid) \
> +	ASSERT_EQ(0, _test_cmd_hw_queue_alloc(self->fd, viommu_id, type, idx,  \
> +					      base_addr, len, out_qid))
> +#define test_err_hw_queue_alloc(_errno, viommu_id, type, idx, base_addr, len, \
> +				out_qid)                                      \
> +	EXPECT_ERRNO(_errno,                                                  \
> +		     _test_cmd_hw_queue_alloc(self->fd, viommu_id, type, idx, \
> +					      base_addr, len, out_qid))
> +
>  static int _test_cmd_veventq_alloc(int fd, __u32 viommu_id, __u32 type,
>  				   __u32 *veventq_id, __u32 *veventq_fd)
>  {
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 38066dfeb2e7..2189e9b119ee 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -150,6 +150,8 @@ to_mock_nested(struct iommu_domain *domain)
>  struct mock_viommu {
>  	struct iommufd_viommu core;
>  	struct mock_iommu_domain *s2_parent;
> +	struct mock_hw_queue *hw_queue[IOMMU_TEST_HW_QUEUE_MAX];
> +	struct mutex queue_mutex;
>  };
>  
>  static inline struct mock_viommu *to_mock_viommu(struct iommufd_viommu *viommu)
> @@ -157,6 +159,19 @@ static inline struct mock_viommu *to_mock_viommu(struct iommufd_viommu *viommu)
>  	return container_of(viommu, struct mock_viommu, core);
>  }
>  
> +struct mock_hw_queue {
> +	struct iommufd_hw_queue core;
> +	struct mock_viommu *mock_viommu;
> +	struct mock_hw_queue *prev;
> +	u16 index;
> +};
> +
> +static inline struct mock_hw_queue *
> +to_mock_hw_queue(struct iommufd_hw_queue *hw_queue)
> +{
> +	return container_of(hw_queue, struct mock_hw_queue, core);
> +}
> +
>  enum selftest_obj_type {
>  	TYPE_IDEV,
>  };
> @@ -670,9 +685,11 @@ static void mock_viommu_destroy(struct iommufd_viommu *viommu)
>  {
>  	struct mock_iommu_device *mock_iommu = container_of(
>  		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
> +	struct mock_viommu *mock_viommu = to_mock_viommu(viommu);
>  
>  	if (refcount_dec_and_test(&mock_iommu->users))
>  		complete(&mock_iommu->complete);
> +	mutex_destroy(&mock_viommu->queue_mutex);
>  
>  	/* iommufd core frees mock_viommu and viommu */
>  }
> @@ -764,10 +781,86 @@ static int mock_viommu_cache_invalidate(struct iommufd_viommu *viommu,
>  	return rc;
>  }
>  
> +static size_t mock_viommu_get_hw_queue_size(struct iommufd_viommu *viommu,
> +					    enum iommu_hw_queue_type queue_type)
> +{
> +	if (queue_type != IOMMU_HW_QUEUE_TYPE_SELFTEST)
> +		return 0;
> +	return HW_QUEUE_STRUCT_SIZE(struct mock_hw_queue, core);
> +}
> +
> +static void mock_hw_queue_destroy(struct iommufd_hw_queue *hw_queue)
> +{
> +	struct mock_hw_queue *mock_hw_queue = to_mock_hw_queue(hw_queue);
> +	struct mock_viommu *mock_viommu = mock_hw_queue->mock_viommu;
> +
> +	mutex_lock(&mock_viommu->queue_mutex);
> +	mock_viommu->hw_queue[mock_hw_queue->index] = NULL;
> +	if (mock_hw_queue->prev)
> +		iommufd_hw_queue_undepend(mock_hw_queue, mock_hw_queue->prev,
> +					  core);
> +	mutex_unlock(&mock_viommu->queue_mutex);
> +}
> +
> +/* Test iommufd_hw_queue_depend/undepend() */
> +static int mock_hw_queue_init_phys(struct iommufd_hw_queue *hw_queue, u32 index,
> +				   phys_addr_t base_addr_pa)
> +{
> +	struct mock_viommu *mock_viommu = to_mock_viommu(hw_queue->viommu);
> +	struct mock_hw_queue *mock_hw_queue = to_mock_hw_queue(hw_queue);
> +	struct mock_hw_queue *prev = NULL;
> +	int rc = 0;
> +
> +	if (index >= IOMMU_TEST_HW_QUEUE_MAX)
> +		return -EINVAL;
> +
> +	mutex_lock(&mock_viommu->queue_mutex);
> +
> +	if (mock_viommu->hw_queue[index]) {
> +		rc = -EEXIST;
> +		goto unlock;
> +	}
> +
> +	if (index) {
> +		prev = mock_viommu->hw_queue[index - 1];
> +		if (!prev) {
> +			rc = -EIO;
> +			goto unlock;
> +		}
> +	}
> +
> +	/*
> +	 * Test to catch a kernel bug if the core converted the physical address
> +	 * incorrectly. Let mock_domain_iova_to_phys() WARN_ON if it fails.
> +	 */
> +	if (base_addr_pa != iommu_iova_to_phys(&mock_viommu->s2_parent->domain,
> +					       hw_queue->base_addr)) {
> +		rc = -EFAULT;
> +		goto unlock;
> +	}
> +
> +	if (prev) {
> +		rc = iommufd_hw_queue_depend(mock_hw_queue, prev, core);
> +		if (rc)
> +			goto unlock;
> +	}
> +
> +	mock_hw_queue->prev = prev;
> +	mock_hw_queue->mock_viommu = mock_viommu;
> +	mock_viommu->hw_queue[index] = mock_hw_queue;
> +
> +	hw_queue->destroy = &mock_hw_queue_destroy;
> +unlock:
> +	mutex_unlock(&mock_viommu->queue_mutex);
> +	return rc;
> +}
> +
>  static struct iommufd_viommu_ops mock_viommu_ops = {
>  	.destroy = mock_viommu_destroy,
>  	.alloc_domain_nested = mock_viommu_alloc_domain_nested,
>  	.cache_invalidate = mock_viommu_cache_invalidate,
> +	.get_hw_queue_size = mock_viommu_get_hw_queue_size,
> +	.hw_queue_init_phys = mock_hw_queue_init_phys,
>  };
>  
>  static size_t mock_get_viommu_size(struct device *dev,
> @@ -784,6 +877,7 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
>  {
>  	struct mock_iommu_device *mock_iommu = container_of(
>  		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
> +	struct mock_viommu *mock_viommu = to_mock_viommu(viommu);
>  	struct iommu_viommu_selftest data;
>  	int rc;
>  
> @@ -801,6 +895,9 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
>  	}
>  
>  	refcount_inc(&mock_iommu->users);
> +	mutex_init(&mock_viommu->queue_mutex);
> +	mock_viommu->s2_parent = to_mock_domain(parent_domain);
> +
>  	viommu->ops = &mock_viommu_ops;
>  	return 0;
>  }
> diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
> index a9dfcce5e1b2..73426de77675 100644
> --- a/tools/testing/selftests/iommu/iommufd.c
> +++ b/tools/testing/selftests/iommu/iommufd.c
> @@ -3032,6 +3032,65 @@ TEST_F(iommufd_viommu, vdevice_cache)
>  	}
>  }
>  
> +TEST_F(iommufd_viommu, hw_queue)
> +{
> +	__u64 iova = MOCK_APERTURE_START, iova2;
> +	uint32_t viommu_id = self->viommu_id;
> +	uint32_t hw_queue_id[2];
> +
> +	if (!viommu_id)
> +		SKIP(return, "Skipping test for variant no_viommu");
> +
> +	/* Fail IOMMU_HW_QUEUE_TYPE_DEFAULT */
> +	test_err_hw_queue_alloc(EOPNOTSUPP, viommu_id,
> +				IOMMU_HW_QUEUE_TYPE_DEFAULT, 0, iova, PAGE_SIZE,
> +				&hw_queue_id[0]);
> +	/* Fail queue addr and length */
> +	test_err_hw_queue_alloc(EINVAL, viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST,
> +				0, iova, 0, &hw_queue_id[0]);
> +	test_err_hw_queue_alloc(EOVERFLOW, viommu_id,
> +				IOMMU_HW_QUEUE_TYPE_SELFTEST, 0, ~(uint64_t)0,
> +				PAGE_SIZE, &hw_queue_id[0]);
> +	/* Fail missing iova */
> +	test_err_hw_queue_alloc(ENOENT, viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST,
> +				0, iova, PAGE_SIZE, &hw_queue_id[0]);
> +
> +	/* Map iova */
> +	test_ioctl_ioas_map(buffer, PAGE_SIZE, &iova);
> +	test_ioctl_ioas_map(buffer + PAGE_SIZE, PAGE_SIZE, &iova2);
> +
> +	/* Fail index=1 and =MAX; must start from index=0 */
> +	test_err_hw_queue_alloc(EIO, viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST, 1,
> +				iova, PAGE_SIZE, &hw_queue_id[0]);
> +	test_err_hw_queue_alloc(EINVAL, viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST,
> +				IOMMU_TEST_HW_QUEUE_MAX, iova, PAGE_SIZE,
> +				&hw_queue_id[0]);
> +
> +	/* Allocate index=0, declare ownership of the iova */
> +	test_cmd_hw_queue_alloc(viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST, 0,
> +				iova, PAGE_SIZE, &hw_queue_id[0]);
> +	/* Fail duplicated index */
> +	test_err_hw_queue_alloc(EEXIST, viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST,
> +				0, iova, PAGE_SIZE, &hw_queue_id[0]);
> +	/* Fail unmap, due to iova ownership */
> +	test_err_ioctl_ioas_unmap(EBUSY, iova, PAGE_SIZE);
> +	/* The 2nd page is not pinned, so it can be unmmap */
> +	test_ioctl_ioas_unmap(iova2, PAGE_SIZE);
> +
> +	/* Allocate index=1, with an unaligned case */
> +	test_cmd_hw_queue_alloc(viommu_id, IOMMU_HW_QUEUE_TYPE_SELFTEST, 1,
> +				iova + PAGE_SIZE / 2, PAGE_SIZE / 2,
> +				&hw_queue_id[1]);
> +	/* Fail to destroy, due to dependency */
> +	EXPECT_ERRNO(EBUSY, _test_ioctl_destroy(self->fd, hw_queue_id[0]));
> +
> +	/* Destroy in descending order */
> +	test_ioctl_destroy(hw_queue_id[1]);
> +	test_ioctl_destroy(hw_queue_id[0]);
> +	/* Now it can unmap the first page */
> +	test_ioctl_ioas_unmap(iova, PAGE_SIZE);
> +}
> +
>  FIXTURE(iommufd_device_pasid)
>  {
>  	int fd;
> diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> index f7ccf1822108..41c685bbd252 100644
> --- a/tools/testing/selftests/iommu/iommufd_fail_nth.c
> +++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> @@ -634,6 +634,7 @@ TEST_FAIL_NTH(basic_fail_nth, device)
>  	uint32_t idev_id;
>  	uint32_t hwpt_id;
>  	uint32_t viommu_id;
> +	uint32_t hw_queue_id;
>  	uint32_t vdev_id;
>  	__u64 iova;
>  
> @@ -696,6 +697,11 @@ TEST_FAIL_NTH(basic_fail_nth, device)
>  	if (_test_cmd_vdevice_alloc(self->fd, viommu_id, idev_id, 0, &vdev_id))
>  		return -1;
>  
> +	if (_test_cmd_hw_queue_alloc(self->fd, viommu_id,
> +				     IOMMU_HW_QUEUE_TYPE_SELFTEST, 0, iova,
> +				     PAGE_SIZE, &hw_queue_id))
> +		return -1;
> +
>  	if (_test_ioctl_fault_alloc(self->fd, &fault_id, &fault_fd))
>  		return -1;
>  	close(fault_fd);
> -- 
> 2.43.0
> 
