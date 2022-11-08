Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AD18BE7
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667924216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p5p89W65tKxr9Ao8LDl3gmgK/47xRxjOCn5ZSMcy3Do=;
	b=O7zTLwPb2u2GZh79gdR9HdItIXfOhr9a9BybizAu6VRvjbRMkDw8OU3YiNO7I4pjb4c29c
	BciW+GGQjrFm3v6N8MVC4PaHSuX2r8258IDAGwoGj3dG2nL09/i7klxWS6O9keCY2EDPRz
	PW67v8IBFqZZDi89B3M2oDmG1CyqwIY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-sq2iUS5JPY2IzCRTypBWTw-1; Tue, 08 Nov 2022 11:16:55 -0500
X-MC-Unique: sq2iUS5JPY2IzCRTypBWTw-1
Received: by mail-il1-f199.google.com with SMTP id z19-20020a056e02089300b002fffe186ac4so11348491ils.8
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 08:16:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5p89W65tKxr9Ao8LDl3gmgK/47xRxjOCn5ZSMcy3Do=;
        b=2NMH7R0ZHU2aUuGBXA3dP/8sZKTURQpOLZeJkkQjgxZo5CM76Uv2OEOjqfV7i5fZNh
         05Js2YNtlRNRyTbsybEkAB/2w5oQJbsbQdol73BbHPxEZ3eGdomZ3DJEzzkpNkCW0QfM
         rQV+MKyqjsegMFnzCbHLU1csNnZTgRHubuFzAthzNQmCTk9GXHUgkvlthZcGE/cuH6An
         ZhA465eMFaAwl/zILRHYQBH3luKgWgWWL4MwEPB7d7EY/jMEiiciuou/sXaPPxgyqlGJ
         dL6L/3mxnd7j8aXk8zbVcGnjntJhUUL2zFZ4ZgVXpJMCzcn4leO1bKoqijYiniiDYDn3
         JEpQ==
X-Gm-Message-State: ACrzQf3GZfET5uZ5K0yr+SJ4pWFDJz9STyicwZLw8ZByGEk0mL/wGh9W
	C1mzHXOLL/YxSIXt/SdGifQfhI3kxi7TA5azxxxf9Muh7oBkh00OV3qKFm1EnTQegbdFQzLDFtb
	rtiAMqEd36g9n+LyiVw==
X-Received: by 2002:a05:6e02:692:b0:2ff:d820:4a76 with SMTP id o18-20020a056e02069200b002ffd8204a76mr767968ils.192.1667924214200;
        Tue, 08 Nov 2022 08:16:54 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5a1xjZhAsUKFSNOY6Xa7hPCWuwVTO/eI6FvqdWrjVoXdjH/JpL01qwzhkf+qbfqLJZxVdEHA==
X-Received: by 2002:a05:6e02:692:b0:2ff:d820:4a76 with SMTP id o18-20020a056e02069200b002ffd8204a76mr767962ils.192.1667924213931;
        Tue, 08 Nov 2022 08:16:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m25-20020a02a159000000b00371caa7ef7csm3919253jah.2.2022.11.08.08.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 08:16:53 -0800 (PST)
Date: Tue, 8 Nov 2022 09:16:51 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kevin Tian
 <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jason Gunthorpe
 <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 6.0 003/197] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Message-ID: <20221108091651.716e3124.alex.williamson@redhat.com>
In-Reply-To: <20221108133354.938359604@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
	<20221108133354.938359604@linuxfoundation.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  8 Nov 2022 14:37:21 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> [ Upstream commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]
> 
> When converting to directly create the vfio_device the mdev driver has to
> put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> vfio_unregister_group_dev() in the remove.
> 
> This was missed for gvt, add it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e3cd58946477..dacd57732dbe 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1595,6 +1595,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
>  	intel_gvt_destroy_vgpu(vgpu);
>  }
>  

Nak, the v6.0 backport for this also needs to call
vfio_uninit_group_dev().  kvmgt had missed both calls, but at the time
of f423fa1bc9fe this latter missing call had already been replaced by
vfio_put_device() in a5ddd2a99a7a, where cb9ff3f3b84c had implemented a
device release function with this call.  The correct backport should be:

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index e3cd58946477..2404d856f764 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1595,6 +1595,8 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
+	vfio_unregister_group_dev(&vgpu->vfio_device);
+	vfio_uninit_group_dev(&vgpu->vfio_device);
 	intel_gvt_destroy_vgpu(vgpu);
 }
 
Kevin, Yi, please confirm.  Thanks,

Alex

