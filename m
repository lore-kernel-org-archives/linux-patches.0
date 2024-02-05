Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4391A4D5AA
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172587; cv=none; b=q+vL3gRbs3bFaXpHgU/iRhkyvMqsXFzxNl0tvUJ0uTw6pGIuROrccb5c6kaLKxKdpJ18BuEBB2eJlCfTWJGK3HjkWXfACjSIsXjNh0ATM4X0Vjx2OxaChJaYtB8QQcW96GmavweFku+j0b2ogWcoRc1v8+Ba2N/HQc/+ZZRlEr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172587; c=relaxed/simple;
	bh=EqQ9MenzjCrFTlHTtt0bcFYKQybhQjUuz9ueBRPlcMU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6N9XMm6KZfzb2jRsPYB16/L1gIuURuTaAvpcse1xbURV6W6ClNbOWpT9AcUKdCbKgyobIXFLT8Qefq56kEE1yKu5uXA00PG/SmYT+61CahH8rnyF/mMB3p5qOThoz3DAvwu9TOUtNsBal4KGlocOODVyMQkFI0m0HjS9NnBfgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OoiXAxuy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OoiXAxuy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5+sRNSSKmOzqMPOlpF55UvsCPipUMWShM7Hzevo2EA=;
	b=OoiXAxuykxMShsE3e9D5x5sOWc+psHYpogwN5D0TPmfWn/FXXz1S9NPLxhRCDqLXOdPJIg
	Sy+4Bf2XiF0N12nGENUBbnA/h0hIGSyBHUyzz+Njht7xijO/NXwXXpfaRe1ZSzlEM6Meax
	4egV1g7te1ATip/6zIaWWD8SzwS8BpY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-xIsQ-ij5NTKo9lsImuliJg-1; Mon, 05 Feb 2024 17:36:23 -0500
X-MC-Unique: xIsQ-ij5NTKo9lsImuliJg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bbb3de4dcbso583183139f.1
        for <patches@lists.linux.dev>; Mon, 05 Feb 2024 14:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172582; x=1707777382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5+sRNSSKmOzqMPOlpF55UvsCPipUMWShM7Hzevo2EA=;
        b=naN7HCj1QrK3CX9zqOuD4qi4zJWs71GrM6Qn+ukg1uWmcLOv2eT0wOOs8Yb3kaPBHD
         w+wMUWqf8jFPKoL25Pw8kpG7LLl78xASbefo63tPKRbRczQMxoAt+oldeM3dMAude1SY
         xx7YZevdZkskNiJgBVsL1JLkl453YIE0HoNYuvDg78ozW4aTJVgNJrN5UVq2rVmQftIk
         KFJl1oxGtsOcVe+1BCT3Meg+4DQROEJJkHYosbYjVXKSJozqevpHpQVCVIZV/+oKlixr
         0J1WnArkA64EJocqSOEaADuGI3fhlWafeTsFjdawK1ouGyfr73NmQOy5x6dPV0iS/yaB
         0hJQ==
X-Gm-Message-State: AOJu0Yx/A/Z/qSAhQYveYivajZpAGLoixF797IWARcfxaTGp8kATpTBC
	mwpbjvQalWslb7DUKvxLUo9u29XVihshR8MvBO/JT7TG6P7Co6VERmwIM86011aeievWS7BE1mv
	4swOz0xV/Vh3XJfRaVWH4D3me77X8A1QeKL9vF9d4oZ1hqi8PylSU7rQ=
X-Received: by 2002:a5d:9ed5:0:b0:7c3:eda5:f418 with SMTP id a21-20020a5d9ed5000000b007c3eda5f418mr344370ioe.14.1707172582319;
        Mon, 05 Feb 2024 14:36:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5U6k02BKkprA4o5OQRn+FJZMOQRMF0m1ybF8f+k4uAvd6hCGcrIjSdFZFC9usmZJWumiCCw==
X-Received: by 2002:a5d:9ed5:0:b0:7c3:eda5:f418 with SMTP id a21-20020a5d9ed5000000b007c3eda5f418mr344350ioe.14.1707172581994;
        Mon, 05 Feb 2024 14:36:21 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXGvJ2rExnLiSMqoPJCwTunOmYd+ODfGHJNEKxV2xhiAP3Rj0ZWrTgIC0Vxq+hjhi6+dqSlFllpvMlFAehMa+dHTANDCY7RR7b6pz19AXvxwJKuBxWGM2A9eOW1GL8EhGqKk8MO5dCXmVdWB4gQsUKk57V3aYCg6PPfCdEEPbQy689ftwI8CuhvcwAuFRxg5ccnLfjvYzd3vmVBDRKs1I+txlkQtU6SnNQpEFX/mAjuoywyChrwRzx7ew7biFU1I0cN4OScrqJhoIl7V1GritLLoAQQAmEofTQbvjWXeeYinnIAawGLgZ6LMlE4hJB5deztemhV8A==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:20 -0800 (PST)
Date: Mon, 5 Feb 2024 15:35:42 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240205153542.0883e2ff.alex.williamson@redhat.com>
In-Reply-To: <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
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

On Thu,  1 Feb 2024 20:57:09 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have
> flows that can be shared.
> 
> For INTx, MSI, and MSI-X interrupt management to share the
> same enable/disable flow the interrupt specific enable and
> disable functions should have the same signatures.
> 
> Let vfio_intx_enable() and vfio_msi_enable() use the same
> parameters by passing "start" and "count" to these functions
> instead of letting the (what will eventually be) common code
> interpret these values.
> 
> Providing "start" and "count" to vfio_intx_enable()
> enables the INTx specific check of these parameters to move into
> the INTx specific vfio_intx_enable(). Similarly, providing "start"
> and "count" to vfio_msi_enable() enables the MSI/MSI-X specific
> code to initialize number of vectors needed.
> 
> The shared MSI/MSI-X code needs the interrupt index. Provide
> the interrupt index (clearly marked as unused) to the INTx code
> to use the same signatures.
> 
> With interrupt type specific code using the same parameters it
> is possible to have common code that calls the enable/disable
> code for different interrupt types.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 37065623d286..9217fea3f636 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -257,13 +257,18 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>  	return ret;
>  }
>  
> -static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
> +static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
> +			    unsigned int start, unsigned int count,
> +			    unsigned int __always_unused index)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
>  	if (!vdev->pdev->irq)
>  		return -ENODEV;
>  
> @@ -332,7 +337,8 @@ static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
>  	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
>  }
>  
> -static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
> +static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
> +			      unsigned int __always_unused index)
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  
> @@ -358,17 +364,20 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> -static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
> +static int vfio_msi_enable(struct vfio_pci_core_device *vdev,
> +			   unsigned int start, unsigned int count,
>  			   unsigned int index)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	unsigned int flag;
> -	int ret;
> +	int ret, nvec;
>  	u16 cmd;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> +	nvec = start + count;
> +
>  	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
>  
>  	/* return the number of supported vectors if we can't get all: */
> @@ -701,11 +710,11 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  	unsigned int i;
>  
>  	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> -		vfio_intx_disable(vdev);
> +		vfio_intx_disable(vdev, index);
>  		return 0;
>  	}
>  
> -	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
> +	if (!(is_intx(vdev) || is_irq_none(vdev)))
>  		return -EINVAL;
>  
>  	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  		if (is_intx(vdev))
>  			return vfio_irq_set_block(vdev, start, count, fds, index);
>  
> -		ret = vfio_intx_enable(vdev);
> +		ret = vfio_intx_enable(vdev, start, count, index);

Please trace what happens when a user calls SET_IRQS to setup a trigger
eventfd with start = 0, count = 1, followed by any other combination of
start and count values once is_intx() is true.  vfio_intx_enable()
cannot be the only place we bounds check the user, all of the INTx
callbacks should be an error or nop if vector != 0.  Thanks,

Alex

>  		if (ret)
>  			return ret;
>  
>  		ret = vfio_irq_set_block(vdev, start, count, fds, index);
>  		if (ret)
> -			vfio_intx_disable(vdev);
> +			vfio_intx_disable(vdev, index);
>  
>  		return ret;
>  	}
> @@ -771,7 +780,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  			return vfio_irq_set_block(vdev, start, count,
>  						  fds, index);
>  
> -		ret = vfio_msi_enable(vdev, start + count, index);
> +		ret = vfio_msi_enable(vdev, start, count, index);
>  		if (ret)
>  			return ret;
>  

