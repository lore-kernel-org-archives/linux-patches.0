Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08CD246BB4
	for <patches@lists.linux.dev>; Thu, 10 Jul 2025 11:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145779; cv=none; b=BDkY+3Z+m0lavuMbcdNAe9eovWqfAVdbZVcDxXUfw9cm9148B5yKWCYvX4GbGiPlmkGzf9gqNGNhyT+6V1d+qEDG1rQ0y2SZEcsze5sfU3fek+4rtWGoIkWwztBierUPM3EwsMRiUtynAcXALGImfhQnu0dDZuz1mR6Fk/2hoKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145779; c=relaxed/simple;
	bh=0jzrMYG/Zqi4a1LCUXgB/nVmLmrbFykZy+3KzRBvXgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3DiWjaPOPvhPFKeG4RhgTQFcJWd75QrfQ4xYJgjYE99uRFa8cYewN60cDEJ30X0nSGJqJ+XPlcM7IDf8LMR1DIY0ZCiMPIGFHWHzNojYA7l3vs/NLhn9KelCtDgMSx4+VW9AikldK+h4uy8xyb2dM/DfYs2vTvz9Dz9LL+OwCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vpz6Jr4e; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vpz6Jr4e"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-237f18108d2so167815ad.0
        for <patches@lists.linux.dev>; Thu, 10 Jul 2025 04:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752145777; x=1752750577; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5JO/Qlx6QEcthLvC0sGmt+qm/PZ0F4XLP2KPhYGX+AQ=;
        b=Vpz6Jr4e8l9jhHBmW2EFmiAS36yxxbgrARGoPX1QF9qrNAOMd7GyQhgmSlLpdR9dCS
         Bpoapheb+RhKLIaEWrlc5oW3d9ZlwX/pGIqoy9iIpGF3bDqVxVIY8W7MUeI72JZOit73
         cngykRuJUpU5z4/6+NSs6G+DV4YJj2kThVo1sNwR6K0ihVx6+rvUjNPvM38GY3qgErds
         N31s12b+l5V9u8deH5VsXrhHjaOszgMRMkeeB8KdHHAzokzKT4qWbBevAh5mL2W0TR0e
         XEdtOPZnXFscEviw7p6BGRPu9h2IELs4RX1YOTkiVwJ9pbCYu+/qIxIkw2Sg5mMsle5T
         aJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752145777; x=1752750577;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5JO/Qlx6QEcthLvC0sGmt+qm/PZ0F4XLP2KPhYGX+AQ=;
        b=pbJrAnD3LCUh28tjtwYcaDUBo6LVkpYQw/0zJnPU4F95a0h0aZC4CLRX9N2N0XwTvM
         IZYURr6wKBEGP7pZRzQDH/Bg22CPTbEJXfKRVZPzSSudcmMJGTRDWPqscuKRKtQxgj/e
         By+IWyD6LJEHkyfKdrHZLlvJMSSrV84GEdHc9K3tx19MUnNOJC59yRythKshWBhrJ2cN
         RRCyLsZU6JFZCJu0xTeSRq5TNYecZa3Rntis9v8Dq56MGY8LbUuVDVg1nTQjWNRhjvvJ
         GU9xo5aZcCKqvQcphDniHjtRhDhFeqnJBglCZRs2za0NRSBCNthW+ZWbpXCMS0Gr7IpE
         aE7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxxFE4RU7G1eXgbKTTb87G/8vRqCOmEfihEE/YMNb+v35ahdAQXVopTKogy3wnx5c/nSVH5TkD@lists.linux.dev
X-Gm-Message-State: AOJu0Yzr8zY3Q5+8Su51+pJG2zki1+jNx17dSiKvXhHb+i+sKOiPECui
	qPHFDPpa8Qu7758y6gHOse0Q9yQGtffysuX56cSY/LK7Q4Cd7exJH8rXmlGjoXtGjQ==
X-Gm-Gg: ASbGncvGTnpLp7sfzp2nKmoLG6T+XEBaOY3Ha35pxIW7XWslribCiUOlx9z7XD1/CxJ
	Ug0RE8eMDnL+KMz+ydKdOtFPX1Rvmt7PW05BumaP3SgsYzG1DFO+aZBX+k1kO0Jdxqx29CNGLXL
	JemvYCG6zJPU4TuNp09L7ZrAXf1Oli5R7U7jgxbz3RjruHN9GdnfHqesk3duI4fr25BSUA09wgM
	M2N2IVaYNHF43Am5mFqboyNhiqexiYn9zKaSTXZMrYXuYWC7hqcIVYqehyJ96zJryH/5M4S+U5i
	+FNvhXdNwIE2y6/rFlzSxSJgfhqjLhCRT/X9djNqFz7xkAt5qu7GwuRd9oZoMNiXeaXSPy12u+S
	CQrV0unrI2XWrAsRoT5yM
X-Google-Smtp-Source: AGHT+IFn1YIIoN9D12OH+6EFBum3x9hdmg0bQvNt4lFk/nH2gQNwHagVfZTJ5ra5fh+Eufg2l4KArw==
X-Received: by 2002:a17:903:120b:b0:237:e45b:4f45 with SMTP id d9443c01a7336-23de4314a3cmr2237805ad.1.1752145776361;
        Thu, 10 Jul 2025 04:09:36 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3007e53fsm4845325a91.19.2025.07.10.04.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 04:09:35 -0700 (PDT)
Date: Thu, 10 Jul 2025 11:09:26 +0000
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
Subject: Re: [PATCH v9 22/29] iommufd/selftest: Update hw_info coverage for
 an input data_type
Message-ID: <aG-fZv39ci6yip3z@google.com>
References: <cover.1752126748.git.nicolinc@nvidia.com>
 <f01a1e50cd7366f217cbf192ad0b2b79e0eb89f0.1752126748.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f01a1e50cd7366f217cbf192ad0b2b79e0eb89f0.1752126748.git.nicolinc@nvidia.com>

On Wed, Jul 09, 2025 at 10:59:14PM -0700, Nicolin Chen wrote:
> Test both IOMMU_HW_INFO_TYPE_DEFAULT and IOMMU_HW_INFO_TYPE_SELFTEST, and
> add a negative test for an unsupported type.
> 
> Also drop the unused mask in test_cmd_get_hw_capabilities() as checkpatch
> is complaining.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Note: I see a couple of warnings while building the selftests on Jason's
tree, but these seem unrelated to this series:

make -C tools/testing/selftests TARGETS=iommu
make: Entering directory '/usr/local/google/home/praan/master/iommufd/iommufd/tools/testing/selftests'
  CC       iommufd
In file included from iommufd.c:12:
In function ‘_test_ioctl_ioas_map_file’,
    inlined from ‘iommufd_mock_domain_all_aligns’ at iommufd.c:1789:5,
    inlined from ‘wrapper_iommufd_mock_domain_all_aligns’ at iommufd.c:1757:1:
iommufd_utils.h:679:36: warning: ‘mfd’ may be used uninitialized [-Wmaybe-uninitialized]
  679 |         struct iommu_ioas_map_file cmd = {
      |                                    ^~~
iommufd.c: In function ‘wrapper_iommufd_mock_domain_all_aligns’:
iommufd.c:1766:13: note: ‘mfd’ was declared here
 1766 |         int mfd;
      |             ^~~
In function ‘_test_ioctl_ioas_map_file’,
    inlined from ‘iommufd_mock_domain_all_aligns_copy’ at iommufd.c:1843:5,
    inlined from ‘wrapper_iommufd_mock_domain_all_aligns_copy’ at iommufd.c:1809:1:
iommufd_utils.h:679:36: warning: ‘mfd’ may be used uninitialized [-Wmaybe-uninitialized]
  679 |         struct iommu_ioas_map_file cmd = {
      |                                    ^~~
iommufd.c: In function ‘wrapper_iommufd_mock_domain_all_aligns_copy’:
iommufd.c:1818:13: note: ‘mfd’ was declared here
 1818 |         int mfd;
      |             ^~~
In file included from iommufd_utils.h:11:
In function ‘_test_cmd_get_hw_info’,
    inlined from ‘iommufd_ioas_get_hw_info’ at iommufd.c:792:3,
    inlined from ‘wrapper_iommufd_ioas_get_hw_info’ at iommufd.c:752:1:
iommufd_utils.h:812:37: warning: array subscript ‘struct iommu_test_hw_info[0]’ is partly outside array bounds of ‘struct iommu_test_hw_info_buffer_smaller[1]’ [-Warray-bounds=]
  812 |                         assert(!info->flags);
      |                                 ~~~~^~~~~~~
iommufd.c: In function ‘wrapper_iommufd_ioas_get_hw_info’:
iommufd.c:761:11: note: object ‘buffer_smaller’ of size 4
  761 |         } buffer_smaller;
      |           ^~~~~~~~~~~~~~
  CC       iommufd_fail_nth
make: Leaving directory '/usr/local/google/home/praan/master/iommufd/iommufd/tools/testing/selftests'

> ---
>  tools/testing/selftests/iommu/iommufd_utils.h | 33 +++++++++++--------
>  tools/testing/selftests/iommu/iommufd.c       | 32 +++++++++++++-----
>  .../selftests/iommu/iommufd_fail_nth.c        |  4 +--
>  3 files changed, 46 insertions(+), 23 deletions(-)
>

[...]

> -- 
> 2.43.0
> 

Thanks,
Praan
