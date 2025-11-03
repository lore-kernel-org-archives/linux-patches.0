Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334EF28E5
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165554; cv=none; b=FiNkYswer8HMLNXRfv1jvrcVv0cQ2seM0z7kU27ITv7G5Ycmtw6xQ3/oxpYLOsMMT9UQ3Wu9FOmw/mSS6vbCVKnhQZ1YWdekuSHEo4TPDKRdVVGoqGk0qKCB/FMasgj9uHE737/2E30J5j+EY+qyH8LfTKF1QiBCTe+JbNgL1KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165554; c=relaxed/simple;
	bh=xb3/uOBbnH/5IyfGrBW3QoHg6qdVt4MgJ44IyIy3YbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeCQi9ofoALxRaP4AhbjvgaiZG2qTusFhnMk2zapNPhLXH1K1gOoRd/AjkSsDhi+6zBVs8qPJbO4QcXHvL76ev082gsZAH4Bj+HtVwjLb4+uqLpQ+0zTTcCtM8pzOvBOneyEJHVFGTK+80rRlN1Gdr4GIZ1wJdsQjGWLarOldIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pn7kEZFp; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pn7kEZFp"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2959197b68eso230475ad.1
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165551; x=1762770351; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gv2e9ygsp9GWwcHVuU/GyMuAUbYvn3xLnsbOpkJhe98=;
        b=Pn7kEZFpTk4Ic/Kd8UZqkPk5eoANiTXlBKgmKMklQTzmU77LrzJ9I64gMhMcndyjf9
         JkOiqJ4flPQoMX9FpWe/gWCANTE7wby1trNDW39+DMnmSUuJW1peiutyvVJJfxbbKtxC
         xWTIt7KPka9nwJYFpcmdMY6icbKM1cQJP5Y/NHMEYYL5gBtVvGqo7bqaq8rJiEMJqOnk
         z/rvsshF8b7KjjRGM96cSjoRm8Ow1rI8FgIDYIZ7GgSnaY14B3MvkQVkzqJ7O7R/aJc7
         OjKMc68fP8QaazBNjRQLMxOU1wm5DZk3HnJSrc4EX9QYcY6IF//C/iL843annMiM8JvO
         e6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165551; x=1762770351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gv2e9ygsp9GWwcHVuU/GyMuAUbYvn3xLnsbOpkJhe98=;
        b=gstdMSGc/MISPuq1BPTi+FqyHfoclZ1pwo6ZaeBH+DabsDYtVHumZSOH5UD/5JUJYc
         RVF70n1n4+U9+ft0fDimyFNEFoPjBczKUfWXHDqDjW2k44iH3G45RYUkcigq/tEk1S7o
         2LyC3IEKefxeCDY4NBEkhnmc0EzPYfFOmpJ/siNRaMpvrysdQgCNPwxZ1oCOjAa8xi9/
         qsXvCH04Tv1OGGz2ZOs9zC+lRMK2fUet/WntL/uzg2KYqIUBnh6OcjvHml7mdEJFYf6R
         tKNMhExWyRLmyqPtfY3MzYJP/hCj1LWt5VadLcCB1rHORVREH0z3QKiy2Cw8NXaO/sEG
         1ePw==
X-Forwarded-Encrypted: i=1; AJvYcCV/o3aQRuudijNw39RK17YHZMe7OAc8aB1h6mYi815ayAc4dx+pkQZisA7qXZCEcfUfyoswAfEX@lists.linux.dev
X-Gm-Message-State: AOJu0YwZIl3K3cphC3SWsFN4SRA5b7TeJi2m1QvDD/dfJX0oq1019U31
	Jtaul3/Egn5jbGAqzG/Ttw7CY9xZKZzQbUcn+wB7bYq5YvSXQ4Lenp/oIGcy1zHmoQ==
X-Gm-Gg: ASbGncvLr12tPdQb1X0L6R0Es7Kg4YV8VZeBL98G5qd/6Jvb2Rg4jKlloWvCtWochID
	JCcYKpf7zarwoNT+larfOJ2rhUaPIkxgSrWva52oPj79nvqm47+EQDksTIXFzp4FVFu2qGveXkN
	PFIXeVnYnoLnlYJrq6OIknGR72qCfGzE9zgZwi6f7+lc4SRTdJ6TEoGtkCE0zJQGSr5BnS6NrHK
	msKZSQroDQaCDa6XX+w8M76HUEhmXvGNKdHaJdyrB1bLp8lIj6q0BKqbj8784HyzJidh0ewZ16F
	Uld5wx5gdAFf5i4XNgVl5k9c2CT1gGBbl45yb5pbf7KK3kJZzw7S8CqMLbxAdgxz8B55WcjvD5Q
	SVLL+cNojFLVzUJToLG/GvmeMDtOIDKbGeh5sbcbe7dWIIL6NdyAFfrw4TJZsGwC97rNZcM7vDf
	XUQumgzJnGV+mhZCzCdrv364BnXCaaXIelk1r7VA==
X-Google-Smtp-Source: AGHT+IGWMvk41x0fPTVw6ZYdCrfpoxx7g/UVoBFTBuqaFXqto2Ol7yP/kHVO5kf2HNRBirU7N6KCng==
X-Received: by 2002:a17:903:41c8:b0:294:ecba:c8e with SMTP id d9443c01a7336-2955658e7b9mr5841305ad.3.1762165550799;
        Mon, 03 Nov 2025 02:25:50 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b9b8f2b5403sm3684424a12.17.2025.11.03.02.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:25:50 -0800 (PST)
Date: Mon, 3 Nov 2025 10:25:40 +0000
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
Subject: Re: [PATCH 19/22] vfio/pci: Convert all PCI drivers to
 get_region_info_caps
Message-ID: <aQiDJDdJGigjtkeU@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <19-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:33PM -0300, Jason Gunthorpe wrote:
> Since the core function signature changes it has to flow up to all
> drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  30 ++---
>  drivers/vfio/pci/mlx5/main.c                  |   2 +-
>  drivers/vfio/pci/nvgrace-gpu/main.c           |  51 ++-------
>  drivers/vfio/pci/pds/vfio_dev.c               |   2 +-
>  drivers/vfio/pci/qat/main.c                   |   2 +-
>  drivers/vfio/pci/vfio_pci.c                   |   2 +-
>  drivers/vfio/pci/vfio_pci_core.c              | 103 +++++++-----------
>  drivers/vfio/pci/virtio/common.h              |   3 +-
>  drivers/vfio/pci/virtio/legacy_io.c           |  26 ++---
>  drivers/vfio/pci/virtio/main.c                |   6 +-
>  include/linux/vfio_pci_core.h                 |   3 +-
>  11 files changed, 80 insertions(+), 150 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
