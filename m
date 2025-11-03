Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE6184540
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762152200; cv=none; b=pVjnTtX884Lun4/7v6bh4+uJm3b9DbuE0xKJjeoSVpoZPvxXgGMkvAnR/yJ6EGPciMItrHWwRp5D75hEEvkHhbNWZC8dQpLgirz9BlX5mnQ9vsjS8wnSvdmuqeNG6+o2YnTNIJXOEgirF1ldNHs8uYHqiLi5u/48zx7LcDLWbUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762152200; c=relaxed/simple;
	bh=4+2jNttfGJTUArM3tzL5Y2lmRNiEYuzuOIQmI+CPwVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXXHymnOUMdnJNXcNH5u6iGc1g7iF47cOEH3kfzYXpW5pg39bR6cnlXLb/S1nmfsMimLOB+SvK1P5BsVwGc+eWj9wQBYf4WDs8CwyhIGWjaqIMROLAikHEJ001rtWxlcHLjJbRE5udK/XyD/iCPKnY4LYmJpd/8Jio1+sFlVaIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SXLhEqru; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXLhEqru"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-295c64cb951so79845ad.0
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 22:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762152199; x=1762756999; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxS6TWyQqtdZLWaYvGIMM/0/SSg5nejyyCdpsoAJAw4=;
        b=SXLhEqruuH1+Fm7S1gprZ7EUNn43TFgKl5JBnj1w5PDIr3JUHgV69LqfxJQGWb/PSZ
         zwzj0GxKoEQgxcE7HFZ00rxMV/5aGbzUy8z3ix+WU3pLhrn0I0kKMMHXtcCwyBYQKVDX
         rpJb+7g8zsMphgS26ChhtddRdGJ8hWqpv1RrO/Xuz2BdAt4OUHiaBvftUDl/zJgyxO7j
         sAiXHZ7XUfVu6ib2o7lnyykQJzYAfI7yYo5NLfjBQSQUiI0a1hP5YLpO6zcQL859CANA
         fDlJEc00DfA00Yh3zhjpi7hlm3a5D7GZNOfW5ady3jG/QV2kR3SjCZleELFnfwOPmIVY
         EzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762152199; x=1762756999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxS6TWyQqtdZLWaYvGIMM/0/SSg5nejyyCdpsoAJAw4=;
        b=MqRTBKzCdTeDRlHuOtCkwx8Af8zwgPfr+jhkoXmTRNH0oRuHniig76WlE7hRsrHTp+
         Tj0T9xH6XTmz2eA3jwriss5/xmbLyVfCGXPQB09fxoVLJG9PSH1pfvplCNQTzAth+2Ev
         2EnlcdnmRGNCuZ237ssLQ586+K/zP73ncFqR5LYojmlMikMdbjCFTI5WK1upSq5DMf/z
         M8prGjkIT/WT8ZaxxuuSptDkdUYaFh6piH5MZh13EWgHhLykDkQWXhfYx7qi9yvxlffY
         BcVERGpmnfJ3+EtmnGekFeHVBMUlEbsNY3NaI+y/wCiKywPh7H/x8Pr6Igi+Q1j1h4hs
         YgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc0XNcQ35QfCvJ5LeQOds+3eMXjTeWn5rgnCF2baSBYjp8mU346s7lHvcc347G4aMJvuMiixLk@lists.linux.dev
X-Gm-Message-State: AOJu0YwoDMJpZ4YUZUpjGD3ZpEPDEN0SdZAjBH7xFho1jpYjY51MSSe5
	CrHusYOkI8TIhk1+/qq+bVwSEUTW9x72+e4rdntG1PWyfKoWLu34VAzY0ipR7Qf+Pg==
X-Gm-Gg: ASbGncuPdUMegD7ZuCJmk3furFZ4mLLEcJQdFOfy2lQFu8sYItztePFO6kokQLNvUol
	C7BIyFIc3dA+60lwoafGvqnL4Lh8uo/TPYMaBEpNL2mknzg0B8JI208rowoupghaglPIUWdZZlC
	1uV9ODIFii6mtv/lZIZ7ztocnrBcjUCTIpxOsiuaHnNBXE5sDX62DzBac4I/M+kK12Q2W0vLq0b
	T6CfRzzbY3VzTqEGDmIGkkP3tKuLb4S73uSMZcOcgKFTNxTET7gNYeZNlxmUq08cmCQpQY1pn5c
	TE8xEHwRfFqTYAgXvginPayzBk/F14GyPww+6ARfOnvaXnsQfysT1sdnWUeaXgoz/IHOqrqB9yQ
	KK6NpvYu/SjUYw02UPPMUIiwLUMquzGQ9RQt+TmfuMNFmHZiUffmgkR6KjzcMgn0dA8XCA2yutd
	VysRSM7fq5CAlet+duxE86qn1F7AWsex0eMU8k2JOVeKzOU/32
X-Google-Smtp-Source: AGHT+IEazENwFhX4zlZOAPlLrsglGHn3aC4ae1C3vchxLK4wgltvDYn1olscExUoutjpE7Up5ejKXA==
X-Received: by 2002:a17:903:2f81:b0:295:5405:46be with SMTP id d9443c01a7336-295562f73a8mr5347545ad.1.1762152198351;
        Sun, 02 Nov 2025 22:43:18 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2954d5ee092sm80708835ad.62.2025.11.02.22.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:43:17 -0800 (PST)
Date: Mon, 3 Nov 2025 06:43:07 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 05/22] vfio/pci: Fill in the missing get_region_info ops
Message-ID: <aQhO-5Ka4b8Mcwxf@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <5-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:19PM -0300, Jason Gunthorpe wrote:
> Now that every variant driver provides a get_region_info op remove the
> ioctl based dispatch from vfio_pci_core_ioctl().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  drivers/vfio/pci/mlx5/main.c                   | 1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c            | 1 +
>  drivers/vfio/pci/pds/vfio_dev.c                | 1 +
>  drivers/vfio/pci/qat/main.c                    | 1 +
>  drivers/vfio/pci/vfio_pci.c                    | 1 +
>  drivers/vfio/pci/vfio_pci_core.c               | 2 --
>  drivers/vfio/pci/virtio/main.c                 | 2 ++
>  8 files changed, 8 insertions(+), 2 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
