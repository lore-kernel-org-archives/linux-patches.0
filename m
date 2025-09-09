Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D02BE653
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757390945; cv=none; b=jNY4LIZpHpbIo2dk0/2I/i0uGrGPOVlT3lMfTUKaS0zMRqKhi5zBHSEkj4FYNysK6p2JdklyR6jIv1QB1l5+Wy+fARjltj/3u7aEEvy1BedceepSxsHpyC6ifwR59HGdmy4W5X4GrzX4VFqannEWxQMuAyiHBlBV7oVSjKad0PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757390945; c=relaxed/simple;
	bh=iWU6y9sGVKEcalUqGLIVzjnIR1x3e9JlkirRrAFMQa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yp5idLiq4jk1PlKBqpFCs+vic8irmh6/tfSznP2JY+0Pr+wDNHGm51YOlgPXLtO9dD8FNyXczg9hrq0pZbeXDRgWjUCFHBvifImHHsmwO0wgCjU+NrRO4tiGmQEBnGsurgS0MbtWCs4dRrFSr+GSntCiCrCJcGa422ISfCCtQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edqRiIEb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edqRiIEb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757390942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mzU2hNnt1jVRFRPaX11xMsuYrOPsVzkQojp04wjwX3U=;
	b=edqRiIEbc8Fs6MWuRKkeCmlYTqUB632M1xM6Iwh/LnYIfp8RK03Iq7pvSQ6Ew4EyLVVgjF
	fqUpAuzyf2QtaTo6LuStbeQGQskKlvunPEOkSaXQz6Vk0rtDM6UaBuXD9iMDX1rRUV2VD+
	2ffhVjcNEseO280aC2y/A9E+biwMyoA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-J9enZ1j4OvuuJ96hnN3viQ-1; Tue, 09 Sep 2025 00:09:00 -0400
X-MC-Unique: J9enZ1j4OvuuJ96hnN3viQ-1
X-Mimecast-MFC-AGG-ID: J9enZ1j4OvuuJ96hnN3viQ_1757390940
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-80b27b09051so1216213085a.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 21:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757390940; x=1757995740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzU2hNnt1jVRFRPaX11xMsuYrOPsVzkQojp04wjwX3U=;
        b=ntSDdISTdm8BlLw3vVwjWZq7JvOrdrIvaQjmnjvQsxNJNPX9p4b+2dy/CSghO01VKW
         OeYVxVHJViWXlMZnPZuY2Li7dh9CG4YroACDnrm01jk+FSGzywjEGfMlY24pbGQKmOUQ
         BMfYrmH7WOQaZLp5qQJgtgcky+mlKIrPPtuuC7Gk5/R7LBfEIhnZvJljEnYY3xsDz/Ju
         C8dJNi2hyoMwgLnwHWVJ0fpBkHMIthl2xDgGfOaQibIEWLXbQxWaNaUqZRhYIhnRtm+c
         ezMoeEcm1jrLj8S1lL9D5XZPEoIkI9Tf+RrbfDu2kg3OWkrC2rnVDTYk/hQGwtrgqECB
         Dgrw==
X-Forwarded-Encrypted: i=1; AJvYcCUrEPR5iUsfrxsd0mSTsqHjV15/5twusVLgRz/ociNcwjZcVz+HZjHOnAg0Ct/MgeqV4EpK7qCa@lists.linux.dev
X-Gm-Message-State: AOJu0YxnUFhm4h5Cq8mDONbafHv+JqF5Y+oeFbRUK0FyQS4u2A6rcSII
	Xy8khAy4ovBZn+368tPotJ4mjFxb8mvzlX5Ijo6UAyL4o8goBOObXFxlxzWt9zC04XSmIrzTLTd
	GvzoYtvH3vVaQOIcou7Ss1BcKaNwY/x5rNtt1hOmrT1dE9A641bhOaQ8RhXM=
X-Gm-Gg: ASbGncsYu+zjhrLKtHCM99XJesCP5/LwVQEiv0wWn/b5lDTg6O3/0iR7XrBcNbVxBkJ
	gceZH7to7v9oE8V4NPIoXK+aZ56dHtORQgi6vKWS8NouMPuvlj3eeQGaHkKCCgbQ+cX0K6h+WTu
	cAw5HPPvkjn4rULKGJX+IeQF9xWP12N/jn7M7a3FQUa1Dmzsv7AUuGwOnBOUFIK9ZInae2vorOT
	6yxwLgDUHt6SrKS4ZAtbTtAk5fBlXzpfywOqytmA4jIY8ZsUsJ4ZMpN2oRgTL5nT+QFYvxuuCA2
	ajLBRGurosgLkUkkGMQrfDUjbWTxfHrjCL2WzH1n
X-Received: by 2002:a05:620a:2588:b0:80b:c6fe:d020 with SMTP id af79cd13be357-813c31ed847mr999901285a.81.1757390940344;
        Mon, 08 Sep 2025 21:09:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFp0lJqEawClZhPCZAPzI3y6p7bipMTBTSQzkm1P0k4tseTDGuIBLxBMAl/wmkP4doTA2xMIA==
X-Received: by 2002:a05:620a:2588:b0:80b:c6fe:d020 with SMTP id af79cd13be357-813c31ed847mr999894985a.81.1757390938798;
        Mon, 08 Sep 2025 21:08:58 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5f9f65e9sm56912485a.64.2025.09.08.21.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 21:08:58 -0700 (PDT)
Message-ID: <2820eb21-9bd7-4832-bd88-31553cfd909d@redhat.com>
Date: Tue, 9 Sep 2025 00:08:56 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] PCI: Move REQ_ACS_FLAGS into pci_regs.h as
 PCI_ACS_ISOLATED
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <1-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <1-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NQmqxAdqVSielrrt-FyP9nGcvhtsUrEtn7qIGNeh7ko_1757390940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Jason,
Hi.


On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> The next patch wants to use this constant, share it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c         | 16 +++-------------
>   include/uapi/linux/pci_regs.h | 10 ++++++++++
>   2 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 060ebe330ee163..2a47ddb01799c1 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1408,16 +1408,6 @@ EXPORT_SYMBOL_GPL(iommu_group_id);
>   static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
>   					       unsigned long *devfns);
>   
> -/*
> - * To consider a PCI device isolated, we require ACS to support Source
> - * Validation, Request Redirection, Completer Redirection, and Upstream
> - * Forwarding.  This effectively means that devices cannot spoof their
> - * requester ID, requests and completions cannot be redirected, and all
> - * transactions are forwarded upstream, even as it passes through a
> - * bridge where the target device is downstream.
> - */
> -#define REQ_ACS_FLAGS   (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
> -
>   /*
>    * For multifunction devices which are not isolated from each other, find
>    * all the other non-isolated functions and look for existing groups.  For
> @@ -1430,13 +1420,13 @@ static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
>   	struct pci_dev *tmp = NULL;
>   	struct iommu_group *group;
>   
> -	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
> +	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
>   		return NULL;
>   
>   	for_each_pci_dev(tmp) {
>   		if (tmp == pdev || tmp->bus != pdev->bus ||
>   		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
> -		    pci_acs_enabled(tmp, REQ_ACS_FLAGS))
> +		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
>   			continue;
>   
>   		group = get_pci_alias_group(tmp, devfns);
> @@ -1580,7 +1570,7 @@ struct iommu_group *pci_device_group(struct device *dev)
>   		if (!bus->self)
>   			continue;
>   
> -		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
> +		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
>   			break;
>   
>   		pdev = bus->self;
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index f5b17745de607d..6095e7d7d4cc48 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1009,6 +1009,16 @@
>   #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
>   #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>   
> +/*
> + * To consider a PCI device isolated, we require ACS to support Source
> + * Validation, Request Redirection, Completer Redirection, and Upstream
> + * Forwarding.  This effectively means that devices cannot spoof their
> + * requester ID, requests and completions cannot be redirected, and all
> + * transactions are forwarded upstream, even as it passes through a
> + * bridge where the target device is downstream.
> + */
> +#define PCI_ACS_ISOLATED (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
> +
>   /* SATA capability */
>   #define PCI_SATA_REGS		4	/* SATA REGs specifier */
>   #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
like the move & rename...

Reviewed-by: Donald Dutile <ddutile@redhat.com>

