Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C7F1EF1D
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 22:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172584; cv=none; b=eu+mh/ScZX7l9+KB6heVCO5lKwAc25QciaTzMUMOIEXtTnNmtibcbVJoZXV0nzzBwcsdx3FsUee5TKPuq9UEXgd+dzOMbV+L+yIMFwmUPw/NGiJWPzY+WASSMcPpx4ep9S+zo4sUo4tQ+1cPPpZbYAD9gAokMlnb4o2GxHoPkx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172584; c=relaxed/simple;
	bh=6JYagHXucKlYsOfkuiAxIPDNGFx7tF1xUhXMyUU4rMA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbhHY7ViI3fffmsZmW8bPmrUz6mSrAk/oEp85Zw7lYhhgT6Vgb4FlV6a6YWi7sYsrHZdfBvxmsnevY+OW/peRE/pilvsNqdGZIUx9SxB7Qwi9YBUOrcffwCtN4LCZmSfLn4+fy2QRdf1/PvdlkflclOH4CB5sMSWeQ6J1tDn8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hOETlp2h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOETlp2h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCym5d923wld6vPREpAl+FehvI78rNNZCzX1noGHDH4=;
	b=hOETlp2hfGs3GES6pKWS8H7RdPlou2E/JDN2trqemTn2yWxKm88mS5mM40HhOZyMnul2lW
	AdenPcm+s5iiPy5nd9qFT/FPXuX6RJPy2Fqf0YnW/oaSt4e5dtLx0BhiDGOjBsxNnDHzot
	gJ4VgaShrKTH705avQyndU75JlEV5KA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-olfZXozRMVCnhwUHHvK3Fg-1; Mon, 05 Feb 2024 17:36:19 -0500
X-MC-Unique: olfZXozRMVCnhwUHHvK3Fg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bf36117dfbso649202639f.3
        for <patches@lists.linux.dev>; Mon, 05 Feb 2024 14:36:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172578; x=1707777378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCym5d923wld6vPREpAl+FehvI78rNNZCzX1noGHDH4=;
        b=v6lxATxdjrCc+Qs46eurSPBn9qg18PZpf5cEq59SGBQjVFyiCA+F944YsJXvL8HQmV
         NDB6EICyep2Ic+aTXh5walSdPhGm2bUmtGtv9PuF6FRdyU/Rd6uzKkDzF0CdNmhdSEFN
         P7xArDUz8ASk4yb3/pYJfBGI37FD/0wVuBrAaTepJ1o8aBei08plxDsjGIr3ynH3FeV0
         SlfO4oWJykxibfzkWBHLdItxe+5N8BPOI8K9XmUMuphU2LvSo2BPlR5YW/cKFLaxag1h
         elmHLUv8fMWXW+eh5gYu6ur5AJAji40eW7jTumw0UkWwPRJQ/3Xbc5MH+PFVJ0wqnU8F
         jIsQ==
X-Gm-Message-State: AOJu0YxLtNbMY0iPcGqDvNUvFPCDjcCDd1P6h1lHkwYi04o3jdxQJDa4
	kzUsFU9R6rL9YbSKmUJrbFPZJctVR1hmNXeKdUJi3y4ExAV5DeTOiP6IxaQoFr6OYNvwG7XGdKo
	ztojC1moC0BGAFEf6qukuYr6tqVtY1YGl2ULXReD0oVYNbhG50Xl73ZA=
X-Received: by 2002:a6b:7f07:0:b0:7bf:43ad:21fd with SMTP id l7-20020a6b7f07000000b007bf43ad21fdmr1209906ioq.6.1707172578228;
        Mon, 05 Feb 2024 14:36:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHsZIwpeJmX5wltmo8bIJUYiKJXCkn2m4BRBUWMIcpK2JxVH5ZBr29yltiYvtI9nmV8wwwaHg==
X-Received: by 2002:a6b:7f07:0:b0:7bf:43ad:21fd with SMTP id l7-20020a6b7f07000000b007bf43ad21fdmr1209897ioq.6.1707172577877;
        Mon, 05 Feb 2024 14:36:17 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU593A73UFQGGLvs1DwDL0axmGCz5389jvfk7tN7BWwlbTyBW8ilY+F92ulx9r3NWV6yKaRdLmwAVmAtQN1tcq+My42jjwkZxiKloCraJDJjo3vdb5s6SLcL8XC6HSO2a40y6YESYQ16qKd3Gufk6nDyZ2e91XAETsu9ZlTD2ddvKg2+gdlCi7W3HPbI6zODrvcmiLwS4ZpVH2NulBcESlh1ktBVpm7wxhmw7yc4vXsmgRJ1tzNuA5aSQNJ7r7wiwsx+D9+g7AmljP4S3fgbyQrtQjh4BU/H6zRGLKvte+bmWZJ5wxLFYV1ZKIBwsl64KSxaKwwgw==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:16 -0800 (PST)
Date: Mon, 5 Feb 2024 15:35:51 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 17/17] vfio/pci: Remove duplicate interrupt management
 flow
Message-ID: <20240205153551.429d9d76.alex.williamson@redhat.com>
In-Reply-To: <6ec901daffab4170d9740c7d066becd079925d53.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<6ec901daffab4170d9740c7d066becd079925d53.1706849424.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
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

On Thu,  1 Feb 2024 20:57:11 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> vfio_pci_set_intx_trigger() and vfio_pci_set_trigger() have the
> same flow that calls interrupt type (INTx, MSI, MSI-X) specific
> functions.
> 
> Create callbacks for the interrupt type specific code that
> can be called by the shared code so that only one of these functions
> are needed. Rename the final generic function shared by all
> interrupt types vfio_pci_set_trigger().
> 
> Relocate the "IOCTL support" marker to correctly mark the
> now generic code.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 104 ++++++++++--------------------
>  1 file changed, 35 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index daa84a317f40..a5b337cfae60 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -32,6 +32,12 @@ struct vfio_pci_irq_ctx {
>  };
>  
>  struct vfio_pci_intr_ops {
> +	int (*enable)(struct vfio_pci_core_device *vdev, unsigned int start,
> +		      unsigned int count, unsigned int index);
> +	void (*disable)(struct vfio_pci_core_device *vdev,
> +			unsigned int index);
> +	void (*send_eventfd)(struct vfio_pci_core_device *vdev,
> +			     struct vfio_pci_irq_ctx *ctx);
>  	int (*request_interrupt)(struct vfio_pci_core_device *vdev,
>  				 struct vfio_pci_irq_ctx *ctx,
>  				 unsigned int vector, unsigned int index);
> @@ -356,6 +362,12 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
>  /*
>   * MSI/MSI-X
>   */
> +static void vfio_send_msi_eventfd(struct vfio_pci_core_device *vdev,
> +				  struct vfio_pci_irq_ctx *ctx)
> +{
> +	eventfd_signal(ctx->trigger);
> +}
> +
>  static irqreturn_t vfio_msihandler(int irq, void *arg)
>  {
>  	struct eventfd_ctx *trigger = arg;
> @@ -544,13 +556,22 @@ static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
>  	irq_bypass_unregister_producer(&ctx->producer);
>  }
>  
> +/*
> + * IOCTL support
> + */
>  static struct vfio_pci_intr_ops intr_ops[] = {
>  	[VFIO_PCI_INTX_IRQ_INDEX] = {
> +		.enable = vfio_intx_enable,
> +		.disable = vfio_intx_disable,
> +		.send_eventfd = vfio_send_intx_eventfd_ctx,
>  		.request_interrupt = vfio_intx_request_interrupt,
>  		.free_interrupt = vfio_intx_free_interrupt,
>  		.device_name = vfio_intx_device_name,
>  	},
>  	[VFIO_PCI_MSI_IRQ_INDEX] = {
> +		.enable = vfio_msi_enable,
> +		.disable = vfio_msi_disable,
> +		.send_eventfd = vfio_send_msi_eventfd,
>  		.request_interrupt = vfio_msi_request_interrupt,
>  		.free_interrupt = vfio_msi_free_interrupt,
>  		.device_name = vfio_msi_device_name,
> @@ -558,6 +579,9 @@ static struct vfio_pci_intr_ops intr_ops[] = {
>  		.unregister_producer = vfio_msi_unregister_producer,
>  	},
>  	[VFIO_PCI_MSIX_IRQ_INDEX] = {
> +		.enable = vfio_msi_enable,
> +		.disable = vfio_msi_disable,
> +		.send_eventfd = vfio_send_msi_eventfd,
>  		.request_interrupt = vfio_msi_request_interrupt,
>  		.free_interrupt = vfio_msi_free_interrupt,
>  		.device_name = vfio_msi_device_name,
> @@ -646,9 +670,6 @@ static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> -/*
> - * IOCTL support
> - */
>  static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
>  				    unsigned int index, unsigned int start,
>  				    unsigned int count, uint32_t flags,
> @@ -701,71 +722,16 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
>  	return 0;
>  }
>  
> -static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
> -				     unsigned int index, unsigned int start,
> -				     unsigned int count, uint32_t flags,
> -				     void *data)
> -{
> -	struct vfio_pci_irq_ctx *ctx;
> -	unsigned int i;
> -
> -	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> -		vfio_intx_disable(vdev, index);
> -		return 0;
> -	}
> -
> -	if (!(is_intx(vdev) || is_irq_none(vdev)))
> -		return -EINVAL;
> -
> -	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> -		int32_t *fds = data;
> -		int ret;
> -
> -		if (is_intx(vdev))
> -			return vfio_irq_set_block(vdev, start, count, fds, index);
> -
> -		ret = vfio_intx_enable(vdev, start, count, index);
> -		if (ret)
> -			return ret;
> -
> -		ret = vfio_irq_set_block(vdev, start, count, fds, index);
> -		if (ret)
> -			vfio_intx_disable(vdev, index);
> -
> -		return ret;
> -	}
> -
> -	if (!is_intx(vdev))
> -		return -EINVAL;
> -
> -	/* temporary */
> -	for (i = start; i < start + count; i++) {
> -		ctx = vfio_irq_ctx_get(vdev, i);
> -		if (!ctx || !ctx->trigger)
> -			continue;
> -		if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -			vfio_send_intx_eventfd_ctx(vdev, ctx);
> -		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> -			uint8_t *bools = data;
> -
> -			if (bools[i - start])
> -				vfio_send_intx_eventfd_ctx(vdev, ctx);
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
> -				    unsigned int index, unsigned int start,
> -				    unsigned int count, uint32_t flags,
> -				    void *data)
> +static int vfio_pci_set_trigger(struct vfio_pci_core_device *vdev,
> +				unsigned int index, unsigned int start,
> +				unsigned int count, uint32_t flags,
> +				void *data)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  	unsigned int i;
>  
>  	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> -		vfio_msi_disable(vdev, index);
> +		intr_ops[index].disable(vdev, index);
>  		return 0;
>  	}
>  
> @@ -780,13 +746,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  			return vfio_irq_set_block(vdev, start, count,
>  						  fds, index);
>  
> -		ret = vfio_msi_enable(vdev, start, count, index);
> +		ret = intr_ops[index].enable(vdev, start, count, index);
>  		if (ret)
>  			return ret;
>  
>  		ret = vfio_irq_set_block(vdev, start, count, fds, index);
>  		if (ret)
> -			vfio_msi_disable(vdev, index);
> +			intr_ops[index].disable(vdev, index);
>  
>  		return ret;
>  	}
> @@ -799,11 +765,11 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  		if (!ctx || !ctx->trigger)
>  			continue;
>  		if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -			eventfd_signal(ctx->trigger);
> +			intr_ops[index].send_eventfd(vdev, ctx);
>  		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>  			uint8_t *bools = data;

Nit, an opportunity to add the missing new line between variable
declaration and code here.  Thanks,

Alex

>  			if (bools[i - start])
> -				eventfd_signal(ctx->trigger);
> +				intr_ops[index].send_eventfd(vdev, ctx);
>  		}
>  	}
>  	return 0;
> @@ -912,7 +878,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			func = vfio_pci_set_intx_unmask;
>  			break;
>  		case VFIO_IRQ_SET_ACTION_TRIGGER:
> -			func = vfio_pci_set_intx_trigger;
> +			func = vfio_pci_set_trigger;
>  			break;
>  		}
>  		break;
> @@ -924,7 +890,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  			/* XXX Need masking support exported */
>  			break;
>  		case VFIO_IRQ_SET_ACTION_TRIGGER:
> -			func = vfio_pci_set_msi_trigger;
> +			func = vfio_pci_set_trigger;
>  			break;
>  		}
>  		break;

