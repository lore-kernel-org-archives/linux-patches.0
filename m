Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4C53AB
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678893112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DK3e3VadmbNCfN+0npCh9b/W73NPmz18eg1ti6Jir7U=;
	b=dzaiwPK0+SAJeyH0uWfX810iUCQPnLJ0Q2OkGcXNVX7NcDpKTht/3vbb9dYMfvL4KmDzK+
	npi0Y7kJu9D2p7EQCIJLDt6r6W1NdBb7NUxRcsu9t7V+UkmMZQMgaOuwigLV9/EQKlU/Em
	57iQwsFxm5lXj2DJf4wqMtvi9xOrOxE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-IgBDPMh5MJSgzTTFdOTMLg-1; Wed, 15 Mar 2023 11:11:50 -0400
X-MC-Unique: IgBDPMh5MJSgzTTFdOTMLg-1
Received: by mail-wm1-f71.google.com with SMTP id l18-20020a05600c4f1200b003ed35ab903aso713052wmq.6
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 08:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK3e3VadmbNCfN+0npCh9b/W73NPmz18eg1ti6Jir7U=;
        b=iet2CLJGu57iacCRJxyrFsqPxNfshAxNi54uUtNpN4Apo4AVeMXGS1ZecE0V5HIQj8
         eCf/n5aV2u+1otmFxccRKiXxu7Y8EGDeDmAs7Jeb38y/Z8+G2ilkAI5pZachgo8U7iPo
         LLiraj2FZHrwkWF6c4jSiTa1WYJz7OuIExjxax3lpJQEFsto0yY4b9untlAkdk5+dF11
         jEfW+ncjEuuuky2Pphlml+qH0+P1fPgsqVN7kN+yGPfLRyEqG2C7V0K6b4KhQimmBAIb
         kYjgobywYjepI+5z7OsJ4wkqZS2IxfVHATpuTfIvi2m0diMsctYxSg+wZWTj1J6rk8Vy
         uV2g==
X-Gm-Message-State: AO0yUKW1lkTcs1e2LTx393vMa7eQaedD9GZLcJaTlXrdZ2GUPNaomZYl
	zvRiIwBW9eYWQ4mE2RNNwT4ZPOXM5YJZwLjPSB4x5pF3V9t7NzW0OxbF0If+MxUhphR0FokVZ0O
	D0aNgCT/H5qR/O3ypUQ==
X-Received: by 2002:a05:600c:470b:b0:3ed:38e7:af59 with SMTP id v11-20020a05600c470b00b003ed38e7af59mr1340336wmo.39.1678893108598;
        Wed, 15 Mar 2023 08:11:48 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ieiqa3g1hPZthzvW//9SdDnRzr0SjYKDwS0RWfuLGTPvzEI2FBmYmKYSobu9hCwEijTOYDA==
X-Received: by 2002:a05:600c:470b:b0:3ed:38e7:af59 with SMTP id v11-20020a05600c470b00b003ed38e7af59mr1340314wmo.39.1678893108284;
        Wed, 15 Mar 2023 08:11:48 -0700 (PDT)
Received: from redhat.com ([2.52.155.131])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm2157086wmi.43.2023.03.15.08.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:11:47 -0700 (PDT)
Date: Wed, 15 Mar 2023 11:11:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alvaro Karsz <alvaro.karsz@solid-run.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 132/141] PCI: Avoid FLR for SolidRun SNET DPU rev 1
Message-ID: <20230315111104-mutt-send-email-mst@kernel.org>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.996651796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230315115743.996651796@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2023 at 01:13:55PM +0100, Greg Kroah-Hartman wrote:
> From: Alvaro Karsz <alvaro.karsz@solid-run.com>
> 
> [ Upstream commit d089d69cc1f824936eeaa4fa172f8fa1a0949eaa ]
> 
> This patch fixes a FLR bug on the SNET DPU rev 1 by setting the
> PCI_DEV_FLAGS_NO_FLR_RESET flag.
> 
> As there is a quirk to avoid FLR (quirk_no_flr), I added a new quirk
> to check the rev ID before calling to quirk_no_flr.
> 
> Without this patch, a SNET DPU rev 1 may hang when FLR is applied.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Message-Id: <20230110165638.123745-3-alvaro.karsz@solid-run.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is ony needed if the SNET driver is included but
isn't it all just for 6.3?


> ---
>  drivers/pci/quirks.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 494fa46f57671..44cab813bf951 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5366,6 +5366,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
>  
> +/* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
> +static void quirk_no_flr_snet(struct pci_dev *dev)
> +{
> +	if (dev->revision == 0x1)
> +		quirk_no_flr(dev);
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLIDRUN, 0x1000, quirk_no_flr_snet);
> +
>  static void quirk_no_ext_tags(struct pci_dev *pdev)
>  {
>  	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
> -- 
> 2.39.2
> 
> 

