Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53D52BEFE7
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697330; cv=none; b=AA5egNZ1rwmUJTapobqA+0/5UuzfjAqUyVGWFo+uvNEuuisFzkU9pgyGXCnH7c9FJJv55TIrCSSZvvTRNKuoSe8qPKEKgcCgXFHIrnny6Z7Xu0s/En3Lab4fF5HYSgE4YXSasz03y+rsghQAoTJ1QJCL0cuIiUyLmIMjDstb7/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697330; c=relaxed/simple;
	bh=AF9kFzEx7JejyTGZ8cnFBshOG6vP/fcO1Ng7rP/PM4E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdLeEOqW6E/lqNtaZ6rv7gGaUEZxhi+jGxW/y8Wok6hy8MY9mnJ2ATNp7DRSFIl3dSE5MFMaLVIMiwMVhqrNjs5OFjTIOFr/B6Iq6wgmEUNdIJm9S6NaSMcY6UYzkGI2YSfytBc2Wsqw+U1h4+8iiD0dspcCgKXCOGcLI2wgcbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I97mKK7A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I97mKK7A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYUlY8l27h/7HElLqMB3FsB5tNtQEv7BQSPs3aGZGIM=;
	b=I97mKK7A89LHUhHbbIY6eE9d93bLn/Sk1L5G/J+V6M1PYkTavTv0RqICkogAMfidIN7yEc
	ICaW5xJJtxWXJ7inBx6UvjiK7N/6zCRvWVRMJpFvg2jUHBndUuhLkjbA2iVJEOMSWEyVBR
	Ek3ponoImZzZCJdWMjZlO6hIee5KK/M=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-XqG5z7QeNqGWP8LWL4j3SQ-1; Wed, 16 Jul 2025 16:22:06 -0400
X-MC-Unique: XqG5z7QeNqGWP8LWL4j3SQ-1
X-Mimecast-MFC-AGG-ID: XqG5z7QeNqGWP8LWL4j3SQ_1752697326
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87a17c254bfso5490939f.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 13:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697325; x=1753302125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYUlY8l27h/7HElLqMB3FsB5tNtQEv7BQSPs3aGZGIM=;
        b=mlmZoe959tU5lDwC3rU6QJWIAsXk9qxE9HQnVoNvdveZ0eKXvtFOaFrIy89VSqjl/M
         m4SdVG8ETLxypgpxP2IY+KRHB7GQTBOOzC10cJD/ttDjdZdQSjXRPEUqqO5nC3bq3UHe
         KtXL0IhpkXW+Jec5TR7wfbF8Ng/ps6xRLzVfe78mbRkboBcCa+51FPQyT2g2vsbUauCB
         Z0RCEzWI4bki5Clx0T6laYOlmoIZd43qEhYTjPN8FJxXigV3KM3nDIEQ48J9W2bUPFpc
         E97QDUOnRSuLi8haUPQsggiAZ4QHMNvMfpTE3WL0Kjq5xQu8pXuIjIYIJC3Pgsodk1+V
         N1rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqB6OgB2KPjeU5rRaKuvH890flfAbdgu7Z76YIhFL70MlnhJHLdtlcXZx2IGWxLJNAlLutosoI@lists.linux.dev
X-Gm-Message-State: AOJu0YxMSqpfPsDflXChWAb0MFPYXISz4Ffww4PwYA0xlt9tKl2wBMlO
	vZm4Nc78U6aj7J1pPwVtWExgrDwFGOAgIwK6TqX0ei7IT4MtYsANkYbldY/ZFmsBDtbxFxG1S51
	Gja29XAKyJYFwjaHI6pPphks3FZ89HXeTBUL9GxOxyAI5Vcal9gkTEwFZDQw=
X-Gm-Gg: ASbGncsYX/+TpYhg6d8sNBO1URGGX2/QQu0RDkyXtMZzo/i6gHN8DYJMNOt6kb6G6cZ
	/5BahuioO2DUIoQF7P0MD4hc2cwwKzELk1zYgLOW95u3TJLlyOxPIul0GIde3f2bTQ3xSRVDet6
	3+BCBqy44FJB+ifxWic+JePcM8Gu6zT4gXg5SZLUm7XvdxDsA0cKFqnZdv3ZmczNo0kqR2Ksjms
	3I0lqpQL1onWFNJfIb3XC80v6Idql1enk3Hw6qlAA6kq8NdHRVf4gugXQlslDb6SSU1QIq8qOjI
	4Z/69ZR3R1UDt870vvuIHm+qr2qRTJI1ZTNGUkb/Ank=
X-Received: by 2002:a05:6602:6c0d:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-879c0794acbmr176029839f.0.1752697325456;
        Wed, 16 Jul 2025 13:22:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkHzND1GOZhUtrnweS8iLLorG8xWwJULGu3yKJfmGb1M9f2dylTV50f8jGTHeKpBnM155xlA==
X-Received: by 2002:a05:6602:6c0d:b0:85d:9793:e0d8 with SMTP id ca18e2360f4ac-879c0794acbmr176028939f.0.1752697325018;
        Wed, 16 Jul 2025 13:22:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569c534esm3205560173.92.2025.07.16.13.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:22:04 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:22:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Brett Creeley
 <brett.creeley@amd.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, Longfang Liu
 <liulongfang@huawei.com>, qat-linux@intel.com, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, virtualization@lists.linux.dev, Xin
 Zeng <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>,
 patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250716142203.677d4a5d.alex.williamson@redhat.com>
In-Reply-To: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
References: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bytDmrZbAwDC8ITckMiYaAdgjzQMqFVTfwlont-8jbg_1752697326
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 13:08:25 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the group
> FD, something like:
> 
>   "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> 
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
> 
> Since we no longer have a device name in the cdev path, pass the token
> directly through VFIO_DEVICE_BIND_IOMMUFD using an optional field
> indicated by VFIO_DEVICE_BIND_FLAG_TOKEN.
> 
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
>  drivers/vfio/pci/mlx5/main.c                  |  1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
>  drivers/vfio/pci/pds/vfio_dev.c               |  1 +
>  drivers/vfio/pci/qat/main.c                   |  1 +
>  drivers/vfio/pci/vfio_pci.c                   |  1 +
>  drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
>  drivers/vfio/pci/virtio/main.c                |  3 ++
>  include/linux/vfio.h                          |  4 ++
>  include/linux/vfio_pci_core.h                 |  2 +
>  include/uapi/linux/vfio.h                     | 12 +++++-
>  12 files changed, 76 insertions(+), 12 deletions(-)

Applied to vfio next branch for v6.17 with discussed fix.  Thanks,

Alex

