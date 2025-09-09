Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5541D6BB
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 05:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394079; cv=none; b=B+sD/LHckNwqK5Z2WrcInjr0AKAY41+P2zXXqEE/PnEHkXTBzvJNu5G1Sq1lJULp/XSKrRnazE8jg05YXjrWupBJwr84l86IxhHt2JUddjgGhyJcF2yTCNNRyYEpiPoe2wsKdnZXGSdjBFQMZ1+bbh/zEq9AI2MkH2Oi1LSnHBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394079; c=relaxed/simple;
	bh=MyQD77cAjsx3koLkQL4dZ/lIFxkKOLlM485XRyjXANQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s02vyy6G7zvNftP/asS1jGhBLsuhaCfVXPzyEMKjxo/Rgv1tqp2T1bK+u3MGsHuI67Yvd08j2w8cBSX1/HXvlNKUwXYtMXapKLIgK8InbzOydg61/y9kSqKBPZT02uNOTrxewLqvOecKCTsFIZtkID1Z3ejB6GKYHhcSy5zbD+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X7cH+R9O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X7cH+R9O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wmM7ymHL/oEefvbkHXDJF00eQsWO67ZJ3ZKRSeokg8I=;
	b=X7cH+R9OICPkSnYm/0sdjx9RaWAYSC2uwtSXgFd8Nx9KEt09LWZL4abSquBkPqsaYQ7CtF
	AzIeP69rvwwA7C8RQl4mThcSNCcgs/au9YPUgxvrSrXtz+R2AwbvkyyG6RTC1/oRR2evBd
	5/WDHYEK6Ucdxyc75QHIwOx+NmvWSWQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-bdAaIMx0PhCaEJwzlAdtrQ-1; Tue, 09 Sep 2025 01:01:14 -0400
X-MC-Unique: bdAaIMx0PhCaEJwzlAdtrQ-1
X-Mimecast-MFC-AGG-ID: bdAaIMx0PhCaEJwzlAdtrQ_1757394074
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-7585b6deccaso1654146d6.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 22:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394073; x=1757998873;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmM7ymHL/oEefvbkHXDJF00eQsWO67ZJ3ZKRSeokg8I=;
        b=PTtqJIfEO+0TUZQbuO22KemEd4jODqyv8mczpufp4sdLWIoIF/cRx0MhPdbO+wnm2M
         4puB048ObqRy9LIbPFTapnk3+tx3O4LQs0crIEO7gKavkF9Dx3yVCQavIlhgm+HrohmP
         GEAES0PYbuTxbR+3ijbUok8zBdmtM6zUwE1ltxrQjfI1pCuKWg7muspLTRpG3ND85xEW
         Eq90GdyXZR1sTKPs/3RXJjyycCCB8fy979eQ2PTI9QRRn47nmD9/nmTVUKeF2Xea7sJ5
         SRoIln3cQZmnGgqBpmohE0hC1bBfV4fzUh38qt/AyFKuAJXIo0O8LsRSTTlxI8GhSsbN
         Cntg==
X-Forwarded-Encrypted: i=1; AJvYcCUUAZk2aLJ4AtGn1MqZocaWy5amPo5k0MMYNlKGv66yLoloM9O/twv3Xr2UXFIvvzkw/NrIB6Np@lists.linux.dev
X-Gm-Message-State: AOJu0Ywg3jK4kpjanAMrKgCEGbp5QZcakvWgs1QyX1FnoMe5xmDaXMuI
	V5h5v0GStGhdA2FIdZ5m4CG78nbt2ZnVXD0KvLvkgUyo3P8IA3PldqEQzRgKargJ1rZY8ES+zQs
	qpfyvVZNYgURAMYprNX0ItpkwRu9vTDVn6XoxeUVJOJsGgQDcyZVb5GOHS+8=
X-Gm-Gg: ASbGncsIavxgilGC16jE54q7PsxsIKXLGOg8Dm7UuDlwTg9zI/YWgvIn/5qNlBzI/3G
	AMeDwmZOLDpyai8tGv2AfGjpXVkHnU0oPEXB47DaE8p3gOzgNudPBhHl+QzOwA9lmne89oSfoLK
	mlVBa83KHZtqjZv8sWj5QHXEpeciEimpRrG6owfJBhX2QSTA+LbB6J/mUEUgFGfClIENXjtzXBu
	TbnBjYThc4u5SDKb9mJtcxTBvb/YeJ4FqvQQbiOJexxuSGIYqMewmTGxJ+vAKzp4j/NuaPmgDCt
	GRu3ieSwfvxc2RuJS9qS5YZC+6ldktZTXdUELN3m
X-Received: by 2002:a05:6214:202e:b0:731:736a:bcd6 with SMTP id 6a1803df08f44-739492cd6a4mr90308086d6.65.1757394073580;
        Mon, 08 Sep 2025 22:01:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6LxTQIHgJ7KqLHWn9G0D2H5GjVpooVfL9ooFPQZ8Rx2Wu55/VAB6FIJdzOrsfvnjVbX7qXg==
X-Received: by 2002:a05:6214:202e:b0:731:736a:bcd6 with SMTP id 6a1803df08f44-739492cd6a4mr90307796d6.65.1757394073070;
        Mon, 08 Sep 2025 22:01:13 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:01:12 -0700 (PDT)
Message-ID: <17c3072e-0c9e-48da-b236-2fefe8ebc823@redhat.com>
Date: Tue, 9 Sep 2025 01:01:11 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] PCI: Add the ACS Enhanced Capability definitions
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <8-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <8-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: chr_WWS_zucWHGjMglxUEO4E74X_Yaje8gm9soxN9Hw_1757394074
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> This brings the definitions up to PCI Express revision 5.0:
> 
>   * ACS I/O Request Blocking Enable
>   * ACS DSP Memory Target Access Control
>   * ACS USP Memory Target Access Control
>   * ACS Unclaimed Request Redirect
> 
> Support for this entire grouping is advertised by the ACS Enhanced
> Capability bit.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/uapi/linux/pci_regs.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 6095e7d7d4cc48..54621e6e83572e 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1005,8 +1005,16 @@
>   #define  PCI_ACS_UF		0x0010	/* Upstream Forwarding */
>   #define  PCI_ACS_EC		0x0020	/* P2P Egress Control */
>   #define  PCI_ACS_DT		0x0040	/* Direct Translated P2P */
> +#define  PCI_ACS_ENHANCED	0x0080  /* IORB, DSP_MT_xx, USP_MT_XX. Capability only */
> +#define  PCI_ACS_EGRESS_CTL_SZ	GENMASK(15, 8) /* Egress Control Vector Size */
>   #define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
>   #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
> +#define  PCI_ACS_IORB		0x0080  /* I/O Request Blocking */
> +#define  PCI_ACS_DSP_MT_RB	0x0100  /* DSP Memory Target Access Control Request Blocking */
> +#define  PCI_ACS_DSP_MT_RR	0x0200  /* DSP Memory Target Access Control Request Redirect */
> +#define  PCI_ACS_USP_MT_RB	0x0400  /* USP Memory Target Access Control Request Blocking */
> +#define  PCI_ACS_USP_MT_RR	0x0800  /* USP Memory Target Access Control Request Redirect */
> +#define  PCI_ACS_UNCLAIMED_RR	0x1000  /* Unclaimed Request Redirect Control */
>   #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
>   
>   /*

Reviewed-by: Donald Dutile <ddutile@redhat.com>

