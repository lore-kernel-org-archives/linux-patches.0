Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C100F17BA1
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620154; cv=none; b=AYTlt37v39l5alAbshMqVatdiSX8/fRnADG7nkdT+4sbiwwWHWniQhCcidKEgGly0rXLkv2uqF4UC0OQYJ6ELzijX34sTC5+H4358UMBmU5gumhvz7bpxgeEpxdhuTfEWKozuuhfe5zxFWFIiTSXoD8N6jBI+gDnDtulBLEy0/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620154; c=relaxed/simple;
	bh=vEmMpBK5/tPkb9KHvQ0SdOc52MTBa8ee6/BHSUyXBLo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JZw6H+rksuNLj2kZqXTtinF8Nv8fUno1LOaOzsA3nug9WViMvu8WvHDewnqdnKl2huqpXGH0USNsf+AvDTE32LMlEwCFA/NnBgeVgQboQldHsF2BI10hAOognLVXSZ57bkL8ORyhimuSi+mtvdodQpNN68m+tWOWOurpVALG1eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SyaLvmRa; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SyaLvmRa"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2cc89c59cc0so234751fac.0
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752620151; x=1753224951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oi4TdNlobhflphwjzdK68I/IBj5StICPNqn66i2gNn4=;
        b=SyaLvmRaZU7zwsmTJJfvKAvcBZ8WDVximDZo/3v4u7bovE8+1WS6N8+YNhhurm1HGB
         787CYA/qI60GnEtRFFHY8Lmg7x9N02M4lfYLXemFyi4rKbemr+5sIQvFbbG2DmArOZNI
         LQwNIbZUwiNvgekWPFAISNZwMqJi8VrqntM8YtEMz1kroYa5oMAWsgFrB0ewTbNkdsDH
         /1f9SCL0Hc/kloWhuc8NlolxbhOZEwDSEmgxoZoZeBpke2GqvcDLxoCYAm7xDlA5pGW4
         ywYuc34bmaWDKmBVhaCYLMRiv2g3+sLosZUELTame5ef7qLAVzmrPII8zYQz+JMcWXLZ
         736w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752620151; x=1753224951;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oi4TdNlobhflphwjzdK68I/IBj5StICPNqn66i2gNn4=;
        b=DXPJYuWAo7QAM53aFkLLTHEL6KvjeIQWW0brRc2f0ho3UOnosZ34pN3lNzlcyxlb0O
         XWAnaCb+VTtFVRHAsdPA6ZHZo9Zko00dsYgim+HwDmUK0SyV5gpRsI6CFSZghwyYSzOd
         MYhr9YVVE9+lVI/OFBXRoyOiyZCwEZw8PmgURyL/MhLGb+gEUWd91jQH26M7NXQNZzK7
         okQXOgUgAhf0nZhQite6jqdZIrNU2SF0bRBaOnEwlnoM1RRSFqs/qf0kN9X9fCT2+InO
         WD7lTlDdjqmCO2AVAP496r0Ql3HfriEuYyImiSfNe2i3+nzjE2O3YAeN7ClSODkxxVqe
         IRyw==
X-Forwarded-Encrypted: i=1; AJvYcCVrtLHTd436sujq9aEfj1gHT0LVBvHzOv/mzBUIiRZH0OMPDVlB66E5/UlETpT+cK++MkzMVCO6@lists.linux.dev
X-Gm-Message-State: AOJu0YzXGjsIVNkGVhB+ZOz28tzM8yl9x9wAz0mFTZT6lX+Z+mDvx02H
	VFxdSbLQoLmygokFBPju9/ZBocsc+banHkZyH5pRT1Gx2L3jCBUn/G11RLcepsKyMEY=
X-Gm-Gg: ASbGnctcn6y+r+Yp6H68qlAlYpzDw9NH9v9uwE6a9jWLYdv/cxavUZlYflFj9vzpLGm
	lFUlZNvmiSHDvcfy8msWDHcjIR5o+9DELgF0oDfYb5ynK32VU6ndplusNY8ADTAwN1xAHN/lCf9
	jwCgvfbGuh65398+GYImsM1YEs3fmf+olzPf51kWgn4kcm56M4mHrHio+J6bitJyco96KP3+d1W
	X6/ykZo14TjBCux0awOhMvdLIjgmK5EOAQ88XbTbd6liud/tRi+kdJDFGcbZhd/yi1h+OXryZta
	nfXVxSSd9mdy57XOXbt1Qq0bIJuK5cSVW5jtqgMYRu4Tl7PHEReobEerCYXUJ+kqkbTUrUraIUL
	xXohEkC6qZZaED2ZloRjWPPRdmgdIQKf+C3FxU9A=
X-Google-Smtp-Source: AGHT+IF5HaHuyKCM6E4t2p7V295FGoLcL158yabHcCEf0sSmb2eM1U+wbvg4ZE1zb1cHzfegWFEB5Q==
X-Received: by 2002:a05:6870:3288:b0:2f7:64f7:8d40 with SMTP id 586e51a60fabf-2ffb0bed7efmr740669fac.9.1752620150775;
        Tue, 15 Jul 2025 15:55:50 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:a172:6205:b5e:43cb])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ff116d22easm2976522fac.33.2025.07.15.15.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 15:55:49 -0700 (PDT)
Date: Wed, 16 Jul 2025 01:55:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>

Hi Jason,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Gunthorpe/vfio-pci-Do-vf_token-checks-for-VFIO_DEVICE_BIND_IOMMUFD/20250715-001209
base:   32b2d3a57e26804ca96d82a222667ac0fa226cb7
patch link:    https://lore.kernel.org/r/0-v3-bdd8716e85fe%2B3978a-vfio_token_jgg%40nvidia.com
patch subject: [PATCH v3] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
config: openrisc-randconfig-r071-20250715 (https://download.01.org/0day-ci/archive/20250716/202507160254.dAjYAz9h-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202507160254.dAjYAz9h-lkp@intel.com/

smatch warnings:
drivers/vfio/device_cdev.c:126 vfio_df_ioctl_bind_iommufd() warn: missing unwind goto?
drivers/vfio/device_cdev.c:170 vfio_df_ioctl_bind_iommufd() warn: inconsistent returns '&device->dev_set->lock'.

vim +126 drivers/vfio/device_cdev.c

5fcc26969a164e Yi Liu          2023-07-18   83  long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
5fcc26969a164e Yi Liu          2023-07-18   84  				struct vfio_device_bind_iommufd __user *arg)
5fcc26969a164e Yi Liu          2023-07-18   85  {
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   86  	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
5fcc26969a164e Yi Liu          2023-07-18   87  	struct vfio_device *device = df->device;
5fcc26969a164e Yi Liu          2023-07-18   88  	struct vfio_device_bind_iommufd bind;
5fcc26969a164e Yi Liu          2023-07-18   89  	unsigned long minsz;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   90  	u32 user_size;
5fcc26969a164e Yi Liu          2023-07-18   91  	int ret;
5fcc26969a164e Yi Liu          2023-07-18   92  
5fcc26969a164e Yi Liu          2023-07-18   93  	static_assert(__same_type(arg->out_devid, df->devid));
5fcc26969a164e Yi Liu          2023-07-18   94  
5fcc26969a164e Yi Liu          2023-07-18   95  	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
5fcc26969a164e Yi Liu          2023-07-18   96  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   97  	ret = get_user(user_size, &arg->argsz);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   98  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14   99  		return ret;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  100  	if (user_size < minsz)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  101  		return -EINVAL;
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  102  	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  103  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  104  		return ret;
5fcc26969a164e Yi Liu          2023-07-18  105  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  106  	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
5fcc26969a164e Yi Liu          2023-07-18  107  		return -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  108  
5fcc26969a164e Yi Liu          2023-07-18  109  	/* BIND_IOMMUFD only allowed for cdev fds */
5fcc26969a164e Yi Liu          2023-07-18  110  	if (df->group)
5fcc26969a164e Yi Liu          2023-07-18  111  		return -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  112  
5fcc26969a164e Yi Liu          2023-07-18  113  	ret = vfio_device_block_group(device);
5fcc26969a164e Yi Liu          2023-07-18  114  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  115  		return ret;
5fcc26969a164e Yi Liu          2023-07-18  116  
5fcc26969a164e Yi Liu          2023-07-18  117  	mutex_lock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  118  	/* one device cannot be bound twice */
5fcc26969a164e Yi Liu          2023-07-18  119  	if (df->access_granted) {
5fcc26969a164e Yi Liu          2023-07-18  120  		ret = -EINVAL;
5fcc26969a164e Yi Liu          2023-07-18  121  		goto out_unlock;
5fcc26969a164e Yi Liu          2023-07-18  122  	}
5fcc26969a164e Yi Liu          2023-07-18  123  
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  124  	ret = vfio_df_check_token(device, &bind);
be2e70b96c3e54 Jason Gunthorpe 2025-07-14  125  	if (ret)
be2e70b96c3e54 Jason Gunthorpe 2025-07-14 @126  		return ret;

This needs to be a goto unlock.

be2e70b96c3e54 Jason Gunthorpe 2025-07-14  127  
5fcc26969a164e Yi Liu          2023-07-18  128  	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
5fcc26969a164e Yi Liu          2023-07-18  129  	if (IS_ERR(df->iommufd)) {
5fcc26969a164e Yi Liu          2023-07-18  130  		ret = PTR_ERR(df->iommufd);
5fcc26969a164e Yi Liu          2023-07-18  131  		df->iommufd = NULL;
5fcc26969a164e Yi Liu          2023-07-18  132  		goto out_unlock;
5fcc26969a164e Yi Liu          2023-07-18  133  	}
5fcc26969a164e Yi Liu          2023-07-18  134  
5fcc26969a164e Yi Liu          2023-07-18  135  	/*
5fcc26969a164e Yi Liu          2023-07-18  136  	 * Before the device open, get the KVM pointer currently
5fcc26969a164e Yi Liu          2023-07-18  137  	 * associated with the device file (if there is) and obtain
5fcc26969a164e Yi Liu          2023-07-18  138  	 * a reference.  This reference is held until device closed.
5fcc26969a164e Yi Liu          2023-07-18  139  	 * Save the pointer in the device for use by drivers.
5fcc26969a164e Yi Liu          2023-07-18  140  	 */
5fcc26969a164e Yi Liu          2023-07-18  141  	vfio_df_get_kvm_safe(df);
5fcc26969a164e Yi Liu          2023-07-18  142  
5fcc26969a164e Yi Liu          2023-07-18  143  	ret = vfio_df_open(df);
5fcc26969a164e Yi Liu          2023-07-18  144  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  145  		goto out_put_kvm;
5fcc26969a164e Yi Liu          2023-07-18  146  
5fcc26969a164e Yi Liu          2023-07-18  147  	ret = copy_to_user(&arg->out_devid, &df->devid,
5fcc26969a164e Yi Liu          2023-07-18  148  			   sizeof(df->devid)) ? -EFAULT : 0;
5fcc26969a164e Yi Liu          2023-07-18  149  	if (ret)
5fcc26969a164e Yi Liu          2023-07-18  150  		goto out_close_device;
5fcc26969a164e Yi Liu          2023-07-18  151  
5fcc26969a164e Yi Liu          2023-07-18  152  	device->cdev_opened = true;
5fcc26969a164e Yi Liu          2023-07-18  153  	/*
5fcc26969a164e Yi Liu          2023-07-18  154  	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
5fcc26969a164e Yi Liu          2023-07-18  155  	 * read/write/mmap
5fcc26969a164e Yi Liu          2023-07-18  156  	 */
5fcc26969a164e Yi Liu          2023-07-18  157  	smp_store_release(&df->access_granted, true);
5fcc26969a164e Yi Liu          2023-07-18  158  	mutex_unlock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  159  	return 0;
5fcc26969a164e Yi Liu          2023-07-18  160  
5fcc26969a164e Yi Liu          2023-07-18  161  out_close_device:
5fcc26969a164e Yi Liu          2023-07-18  162  	vfio_df_close(df);
5fcc26969a164e Yi Liu          2023-07-18  163  out_put_kvm:
5fcc26969a164e Yi Liu          2023-07-18  164  	vfio_device_put_kvm(device);
5fcc26969a164e Yi Liu          2023-07-18  165  	iommufd_ctx_put(df->iommufd);
5fcc26969a164e Yi Liu          2023-07-18  166  	df->iommufd = NULL;
5fcc26969a164e Yi Liu          2023-07-18  167  out_unlock:
5fcc26969a164e Yi Liu          2023-07-18  168  	mutex_unlock(&device->dev_set->lock);
5fcc26969a164e Yi Liu          2023-07-18  169  	vfio_device_unblock_group(device);
5fcc26969a164e Yi Liu          2023-07-18 @170  	return ret;
5fcc26969a164e Yi Liu          2023-07-18  171  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

