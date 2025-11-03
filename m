Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E773238C2A
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762150909; cv=none; b=Hh0BIROAM/2bjPqvVj1yoGyxE5J8GgAI4rlU3HH8GqpdA785CC8DmXLxUrcAtHCxNAdUgf9e+4Ccd7Y1KRPvUVrghuBtp7NDTHcvUXskJkyxsdfuDGV+y4WKhD7i/r40zg3Pn+fG7EgNdKfLYFjlPAF9W5nFRV4AAm8hUjrgoAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762150909; c=relaxed/simple;
	bh=q6TURu0Txeo2OJvua8KGcsnP9mDJkJtsWp5sVhFajZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQs0O7am6I9IC4loenjuehcBOn9fOqR3dTphutdnVKPVp9t2TV1slkwO4NjVyM45IbQ+nAbvfu8l8qAvG7v1PsnIsD5c+SoUzZlWN3csk4TcEqVPbUzpRUo4nEqq4MnM5WFgmdV9yQXI9eTL+vzaauXJhVt31232rPzMImg04Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jr0sTe8X; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jr0sTe8X"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-294f3105435so331695ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 22:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762150907; x=1762755707; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nWlZBJWMNR3o5R9SijDhT22MNLu42EpPET2zOzK998A=;
        b=jr0sTe8XVB7FJ006hfdIAf6TLoZhaRjOwZP77e9t4KQ0JnQCpJewZMI8WcOHqa6C2Z
         QpnUUZfLwVtpCE+uoAdrqAI8O0qduc4no9wvf2i3A1f8aiIxgbx4CJz9V/uOQi0exS9X
         +k4SflqOZO87oTEPUtDST+Q6nHWc8zdkgBKFN7o2+Cn4Y6d5de6ayhZeQnTx+isEbE/6
         80owuXZ2FWgstvs0hizocXGb1r0MrHCgtLgnPfEscazuznHGvCvL9f39/yKo8174bH/o
         FzomFGWx1VytLPPbkcKqGNMW8AKtELWfnR57C7RwZiowAGr4fGHseUs5c9o4anpQnyUE
         hChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762150907; x=1762755707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWlZBJWMNR3o5R9SijDhT22MNLu42EpPET2zOzK998A=;
        b=pCZ6tpUPohxyzmy/TFfBkpa5GUgGIEE6y+y8+C+gL1HY5Y0wtqGVksD5ikMhr3NL5o
         wGkZgOdevYJGACaHQfDm+u8RLgEXvTLYDhkkXS6ZhUlc+TLTFlChD/Br62HgbfAo6KNE
         1ujzT9FkRR5oMJxqzD8U2nFu64/fSDklqskChka7UmyLEwwRMKDMmHQSB1BjU2ioyklS
         VnPUK4qvuwJqMOb1fVCBgBdXSeTGlS5RgMhWeZE/Gpl9ESU5d/3XhjQLgpspXHxYSXOm
         R8JR6DiJxUOt+rtFw8F1O/m+d6fR6//yKX5KhMXSBKWLM6tYsJMVX5XKoK1y7ePklKnT
         iONA==
X-Forwarded-Encrypted: i=1; AJvYcCWcZgjjIWm4KM5Mb8NlLVWIjmAHnjO3AwLUAR/lJ8g75K0l+zS9MoHEegGZzrW6yLyayERSpJaf@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgq6iiZHv/lRUgRb5XKg7I27cHiWI+fknY5onYgdATEwMNgh0x
	F/Ezx8UXlEUECN/qLCCgYZQaNs6l3d6hh9F4XNQRg2FOJ18+u2LgkFHGoigLKfvXhQ==
X-Gm-Gg: ASbGncvJqaIrUD5j2vXbiGFPgMdgTpcM1a3vekfcGOw6e9WbFnGJMphsqs6hnXYooER
	UviwWwyA+nMaNrPRM+AG5tY0WZ9Sv5QgWy0GeNzHz8XxSZAX3NbBuWOUEwtclJIPb8glXzs0H2J
	J/oQhjIg9zWy9LPUlyP5qgu7jNyiz8gznwwwOo2KgX7xnBO6RShfJWaepUUihuYfXsLw1+bNMXu
	EEvvC9ZGyyBXP3s9jjnKZmrXzDDEKjVmUFqtBdBerkQ9ecIfYMBL7YyrO8r79dl8k5k3Dus5tVF
	2vj2sEVRTAqe5mz6M5LG0Wv/18CSEEYc7fGBh0BxuxP9yfSt8nsEHDEMkYUK37cwXMYTNq1T1JE
	I3bbbcnvj6/ztPa3pCaSH6hD8FpxKR8P/B3jBQy2uJTtZ0lnKKlwG0acor1FjfXJM56o1te/X3y
	J1ORG/cwHREq8e0MkL+gJmhGWrtaxiIaGNBtzIFw==
X-Google-Smtp-Source: AGHT+IGruOwIqSOkw/c0UIqbUAnBCrsgVRvu/C4si6qjv3qWziT7RTJr58fgj5zqaOcpkLKvHmo5tQ==
X-Received: by 2002:a17:902:e891:b0:290:dd42:eb5f with SMTP id d9443c01a7336-29554be37d6mr5455555ad.12.1762150907195;
        Sun, 02 Nov 2025 22:21:47 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db67cbdfsm9912363b3a.49.2025.11.02.22.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:21:46 -0800 (PST)
Date: Mon, 3 Nov 2025 06:21:36 +0000
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
Subject: Re: [PATCH 03/22] vfio/virtio: Convert to the get_region_info op
Message-ID: <aQhJ8OZiVYe06hv_@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <3-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:17PM -0300, Jason Gunthorpe wrote:
> Remove virtiovf_vfio_pci_core_ioctl() and change the signature of
> virtiovf_pci_ioctl_get_region_info().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/virtio/common.h    |  4 +---
>  drivers/vfio/pci/virtio/legacy_io.c | 20 ++++----------------
>  drivers/vfio/pci/virtio/main.c      |  3 ++-
>  3 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
> index c7d7e27af386e9..a10f2d92cb6238 100644
> --- a/drivers/vfio/pci/virtio/common.h
> +++ b/drivers/vfio/pci/virtio/common.h
> @@ -109,10 +109,8 @@ void virtiovf_migration_reset_done(struct pci_dev *pdev);
>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
