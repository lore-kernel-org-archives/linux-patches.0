Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF0712B73
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394118; cv=none; b=J45XjthZgl2/TbWpWCtd3TFvytAI6GeeZYRwUxotfeLydcZBmvNcZiZunksiTLsyBIffqVNrE+KUaCsEMkG3Bmn7gwGT0OdOolYPmZHrj8VBA+Y36fzRsyncEni1ZmoH4pueg/oouGaAUvl1VTFyZ6SB5Vdi1qz+ULjluQtZI9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394118; c=relaxed/simple;
	bh=NiKPZa3aBzZRfwyLL0FvfveRyRXeMsNqVb7bIOVeJNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xkyb/dTO00hE3Gj7uklVCF9EFKULUQsDnSOM5vYN9Mk4kfCmefIBxpN7UXXf+A5i/H9vrB2saoUxCBsZtMjcDkBVQXy4qwR1RGk6J+Bfuh6KhmP/wVMQYdezqi//TBcw1fKYkQWk5/28B0InpEAxodHDxTd9k6n25ewQ+CiZhig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fyy2kasE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyy2kasE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+TqcpyoKZ7yURjs6FmHv6hYqw5SgT/JL8ZK31pPvug=;
	b=fyy2kasENmI9bd0jzcHlr3E3YpmJkI53mF+b4O+iPTKQEw90bZF+KbRs8y5JFxk0raOeYJ
	OuiI64tiRcHdEzWjadEsAF8hPm5sxx/hB5jUqS082RYyRZwSnvS2rmbojLHbwXNaBhFJJA
	8OR/elfno9GcH2G+V3+Yl2bm5mh+4Pk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-lgy3_YnFOYebIT62Mfgb9Q-1; Tue, 09 Sep 2025 01:01:54 -0400
X-MC-Unique: lgy3_YnFOYebIT62Mfgb9Q-1
X-Mimecast-MFC-AGG-ID: lgy3_YnFOYebIT62Mfgb9Q_1757394114
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b5f4e4fe41so140321981cf.2
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 22:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394114; x=1757998914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+TqcpyoKZ7yURjs6FmHv6hYqw5SgT/JL8ZK31pPvug=;
        b=DtHy4duJaw1ibj+d13rK9F+i0y1EDL+VR302+9/+eEnIw0zGgeGxoUVSL3uXvlkOf6
         FfA5lWAgAFlbqo2B1gDxzpMMDNsbpJqOURCHmHefUps5RLnLcKkvPzUyO+qQ6IRGhdfN
         7B1dGA6zTOQpE7sLjVHE4CFgYTwCJm3eVk7ypTWaWQHM9dFKMyfJ5bNcxgK27sb40c98
         RomfI0tbOr2ZyPuyYHtvKzugbCTAGd99jsbOkIpfEtn0riO2m66mLgnYTZcz4dxirXmd
         mBzxRvjACa67yH/50pXQP4VLWUkoL2P0HVo5X8GVEknN3Ot368PgohkFdkbimefnk4p/
         lCSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHyWX7Hl4Onb1D8g/bTNr37kVnTLjBWqg4ael0ooGLKl1If043i0jy3cWUNUKyHgA4VwPcGkKy@lists.linux.dev
X-Gm-Message-State: AOJu0YwitdyceZNcNfLOoD6IFqJMyN6RoDTdj3s87oKM/vsktb/LvMB8
	JTxyazq2pVEy7F/rDhFii1RMQAxKHgLlw4t36Pg6vLwD3kneYdtt8cO3Qa9v0spm2YLmHPuJs/G
	HRQ41edpYODmoJnWhIUlJJm58Fq0Hess/hwH7dFzDOpJbk+gidbXFGV008TQ=
X-Gm-Gg: ASbGncs+2txYttaWmBWoXtpUhnaqTKhJmjUnBs5UbAY+/c/5bGhxvJzSycXoemnhsXY
	wpD41KDvac4SGGkBoPRE9pKpa0MMZsF5WGoXSyu6SFHB9UQzcibdLFoo5fmMH+wCAtelKwOv6cK
	zHM7Jvs1tqNx6XjkBjoXPDsSlECl24NJJwmWatF78R4ikVuUaCNN84Fvzb2xWR4A2NaP9px9RQC
	sVgDriOv/0KOacTAdqmMls1miLfgMr60t5C1FBqfPwwSO+iD7NqkRG/7oeohQmZavaFa1OYlA+E
	3L5oz+RtIMOC+7ApZhqhGpDpq83kB/TlvH0/K4xp
X-Received: by 2002:a05:622a:64c:b0:4b4:9813:932 with SMTP id d75a77b69052e-4b5f83b14fbmr113691831cf.31.1757394114303;
        Mon, 08 Sep 2025 22:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9lKeUdKCImFfFawS74qNPwOaMOZGonu9+t68RyfZKwbK9+6tmYOsPkeWUWvoy490OBnp4gg==
X-Received: by 2002:a05:622a:64c:b0:4b4:9813:932 with SMTP id d75a77b69052e-4b5f83b14fbmr113691521cf.31.1757394113901;
        Mon, 08 Sep 2025 22:01:53 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:01:53 -0700 (PDT)
Message-ID: <7c47fa78-9b0d-4383-817b-01a1a53311d8@redhat.com>
Date: Tue, 9 Sep 2025 01:01:52 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/11] PCI: Enable ACS Enhanced bits for enable_acs and
 config_acs
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <9-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <9-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EY7I-C5k-am5S7060dVcaWNpnS8NB_8sSnAdEmSDLLQ_1757394114
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> The ACS Enhanced bits are intended to address a lack of precision in the
> spec about what ACS P2P Request Redirect is supposed to do. While Linux
> has long assumed that PCI_ACS_RR would cover MMIO BARs located in the root
> port and PCIe Switch ports, the spec took the position that it is
> implementation specific.
> 
> To get the behavior Linux has long assumed it should be setting:
> 
>    PCI_ACS_RR | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAMED_RR
> 
> Follow this guidance in enable_acs and set the additional bits if ACS
> Enhanced is supported.
> 
> Allow config_acs to control these bits if the device has ACS Enhanced.
> 
> The spec permits the HW to wire the bits, so after setting them
> pci_acs_flags_enabled() does do a pci_read_config_word() to read the
> actual value in effect.
> 
> Note that currently Linux sets these bits to 0, so any new HW that comes
> supporting ACS Enhanced will end up with historical Linux disabling these
> functions. Devices wanting to be compatible with old Linux will need to
> wire the ctrl bits to follow ACS_RR. Devices that implement ACS Enhanced
> and support the ctrl=0 behavior will break PASID SVA support and VFIO
> isolation when ACS_RR is enabled.
> 
> Due to the above I strongly encourage backporting this change otherwise
> old kernels may have issues with new generations of PCI switches.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/pci/pci.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b0f4d98036cddd..983f71211f0055 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -957,6 +957,7 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
>   			     const char *p, const u16 acs_mask, const u16 acs_flags)
>   {
>   	u16 flags = acs_flags;
> +	u16 supported_flags;
>   	u16 mask = acs_mask;
>   	char *delimit;
>   	int ret = 0;
> @@ -1001,8 +1002,14 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
>   			}
>   		}
>   
> -		if (mask & ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR |
> -			    PCI_ACS_UF | PCI_ACS_EC | PCI_ACS_DT)) {
> +		supported_flags = PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				  PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_EC |
> +				  PCI_ACS_DT;
> +		if (caps->cap & PCI_ACS_ENHANCED)
> +			supported_flags |= PCI_ACS_USP_MT_RR |
> +					   PCI_ACS_DSP_MT_RR |
> +					   PCI_ACS_UNCLAIMED_RR;
> +		if (mask & ~supported_flags) {
>   			pci_err(dev, "Invalid ACS flags specified\n");
>   			return;
>   		}
> @@ -1062,6 +1069,14 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
>   	/* Upstream Forwarding */
>   	caps->ctrl |= (caps->cap & PCI_ACS_UF);
>   
> +	/*
> +	 * USP/DSP Memory Target Access Control and Unclaimed Request Redirect
> +	 */
> +	if (caps->cap & PCI_ACS_ENHANCED) {
> +		caps->ctrl |= PCI_ACS_USP_MT_RR | PCI_ACS_DSP_MT_RR |
> +			      PCI_ACS_UNCLAIMED_RR;
> +	}
> +
>   	/* Enable Translation Blocking for external devices and noats */
>   	if (pci_ats_disabled() || dev->external_facing || dev->untrusted)
>   		caps->ctrl |= (caps->cap & PCI_ACS_TB);

Reviewed-by: Donald Dutile <ddutile@redhat.com>

