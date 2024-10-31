Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6348142E67
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 06:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730356109; cv=none; b=YgSSR8MPYPD0oLjf9QW7WpdMmA9jK1VdlA57/KYoTL2m6fndg3c8A16Q2uz6MIaEEaVjTdQX3LL3AUZW3QL7AP2cqFt5Acw+ZxMJgvFtVsiWr4JFv6XIZqmrNNLY3O/hMs2QiafCplk5K8oobJrrY17/qRg41YBf2InH7GBEupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730356109; c=relaxed/simple;
	bh=MKqc+jnQFmyBLCFxWGJ3NUD1kakYxp1Ft7jvVu1cUio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pyvBYGkibTgNOK/vo0FgyxqvsPLGG4jy35xALdy9ZF2luJgwZEF40X0H0XJDGSUcazYoFCiM8MjDg+yAVcTK4g1ArD1IJ+tK/DKwK+7Z77/q6o5kl1vn1JJFmaNiL1ZecGNrHl7U+KHqdqxRoLwa+wCK1GkFttLiwwwlx6So40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qS3enax4; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qS3enax4"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f53973fdso523854e87.1
        for <patches@lists.linux.dev>; Wed, 30 Oct 2024 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730356104; x=1730960904; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0A+2k/ULHhbtDsFz6ukwr2SikYuSBp3Zz6My29BV53I=;
        b=qS3enax4IcxyxW2OWOJcD7ykC4KLGL8qzdlSbmXORM/jm8ye1F9hReArMcXeLnop3t
         RuAPVrVI5Wt6iMAs3m+sVShx2tkHURX2SPSSsHte5dJo00J7rvjsQR7Yf8q/3oYqf++A
         rth+F1qq5Pc1PvX2WnXLTSdRyrZ4WmdhU8KJStI9ISrf6ErmfY2JSICdFU3O9XPund72
         Nj3YLjt6i8By8lf4NFFugnynebgt2/qt494Onp2D+W4lFD4EomzB/9YcgNJnsnwlzc1y
         K6MlwjiT0EXNf4HbG81b97XYXvA2CLwgEWjqpL6/ykD7y+HBdc7f8gNqTbNdZ/a5uP51
         rGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730356104; x=1730960904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0A+2k/ULHhbtDsFz6ukwr2SikYuSBp3Zz6My29BV53I=;
        b=WqBGwaJfF7UZ3MYE0wQ/vkDsIjY8LkXHaFQDb6sYK0fogPtdXL3Vzn1wFEg44/YqEv
         4K5roUxrpVgGyplYmGwYScY9Zn2gX6VcZ2A3l+AVGpVbRCSTOHtSP0/WaNm9sS2mKc59
         MuF6BnIou7/956TxgylsIGnZ44A7TbQEAG12e4regHPFgbyR7xf7FgCC7Q76JY6YYdaA
         pbsUju0Hmn7CiG7xvXA3VhlY78tb+IORQSvyAtZKGdc9ouvyJo0AlrnkcdJNIfDbTAWI
         1OUcj4vS9GNgtbeb7hq6hXddA1JsbaaprzkjDaENU/nWF++8zLnjLIeJ+8KuBsEwm4+u
         7MaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxLR/iUKNoTnE8f7wdebZQJe/lw0i9rDkRLjgm7OG65Dl5Cj47ZIxWf5fgBh99OgxiCT+aaVCn@lists.linux.dev
X-Gm-Message-State: AOJu0YzLOLeqIu2K2OyfnqcOdlmL18xWs3huT8sldzl4Qsb1UCDSodl/
	FIn2oU7O1kKHQ32dADHNQAH2ZXkMnqGgekpKx0yH7aGo4PkhoDVSS0YTlDwaT/hXT4kBmhzslHR
	bp8mfUw+x7NjWwBXOzXXJB8f1Q1e5OlnBoQH6SA==
X-Google-Smtp-Source: AGHT+IFS7cpOzSPiFnYyQueXqV7l2SMv8NBdQwLcqFAZDqrWEol+iOoyDA3s2GJBPsOCBe+TjxRn94cV+pCmUA4hIqQ=
X-Received: by 2002:a05:6512:2243:b0:539:8ee8:749e with SMTP id
 2adb3069b0e04-53c7bbc136cmr376123e87.3.1730356103938; Wed, 30 Oct 2024
 23:28:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1730313494.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1730313494.git.nicolinc@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 31 Oct 2024 14:28:12 +0800
Message-ID: <CABQgh9GYOgBJwRhvsWpPwS4vgDzCvXCAUxc8DQy8ObHAOvpbRQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/10] iommufd: Add vIOMMU infrastructure (Part-2: vDEVICE)
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, will@kernel.org, robin.murphy@arm.com, 
	dwmw2@infradead.org, shuah@kernel.org, iommu@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, baolu.lu@linux.intel.com, 
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org, 
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com, smostafa@google.com, 
	yi.l.liu@intel.com, aik@amd.com, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Oct 2024 at 05:36, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> Following the previous vIOMMU series, this adds another vDEVICE structure,
> representing the association from an iommufd_device to an iommufd_viommu.
> This gives the whole architecture a new "v" layer:
>   _______________________________________________________________________
>  |                      iommufd (with vIOMMU/vDEVICE)                    |
>  |                        _____________      _____________               |
>  |                       |             |    |             |              |
>  |      |----------------|    vIOMMU   |<---|   vDEVICE   |<------|      |
>  |      |                |             |    |_____________|       |      |
>  |      |     ______     |             |     _____________     ___|____  |
>  |      |    |      |    |             |    |             |   |        | |
>  |      |    | IOAS |<---|(HWPT_PAGING)|<---| HWPT_NESTED |<--| DEVICE | |
>  |      |    |______|    |_____________|    |_____________|   |________| |
>  |______|________|______________|__________________|_______________|_____|
>         |        |              |                  |               |
>   ______v_____   |        ______v_____       ______v_____       ___v__
>  |   struct   |  |  PFN  |  (paging)  |     |  (nested)  |     |struct|
>  |iommu_device|  |------>|iommu_domain|<----|iommu_domain|<----|device|
>  |____________|   storage|____________|     |____________|     |______|
>
> This vDEVICE object is used to collect and store all vIOMMU-related device
> information/attributes in a VM. As an initial series for vDEVICE, add only
> the virt_id to the vDEVICE, which is a vIOMMU specific device ID in a VM:
> e.g. vSID of ARM SMMUv3, vDeviceID of AMD IOMMU, and vRID of Intel VT-d to
> a Context Table. This virt_id helps IOMMU drivers to link the vID to a pID
> of the device against the physical IOMMU instance. This is essential for a
> vIOMMU-based invalidation, where the request contains a device's vID for a
> device cache flush, e.g. ATC invalidation.
>
> Therefore, with this vDEVICE object, support a vIOMMU-based invalidation,
> by reusing IOMMUFD_CMD_HWPT_INVALIDATE for a vIOMMU object to flush cache
> with a given driver data.
>
> As for the implementation of the series, add driver support in ARM SMMUv3
> for a real world use case.
>
> This series is on Github:
> https://github.com/nicolinc/iommufd/commits/iommufd_viommu_p2-v6
> (QEMU branch for testing will be provided in Jason's nesting series)

Thanks Nico

I tested on aarch64, functions are OK.

But with some hacks
https://github.com/Linaro/linux-kernel-uadk/commit/22f47d6f3a34a0867a187473bd5ba0e0ee3395d4

Thanks
