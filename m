Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A51D6BB
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 05:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394018; cv=none; b=M8w18g0Rz0KH38MxHkKmAW3SLp+o7HlBJFedyKNsKy7svoMzwBJmG8zw/z59cE/uDNlnhUr4o0cowas5RS2HObSe9/mPFXzu7W0btrUeCnPsGKDhTepw+1/bZWfwhghMwyfYNVogvp6wblbiEuqDkQeV9SyDAEZpy6RL4dvCwPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394018; c=relaxed/simple;
	bh=1oxzIB+Bq27heH7UqJ7HD5sfAeymQ9opp8zaJLFAIQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhjBfIrGfjbYakiGGVrWGb47sW9N241CbuNqOuO4aviEQ3yRfpy1ng+OSaWq/V6Fk1UdyQqXNxWrHHzF8X7DsKCTgy8LbRXLjwjU3FYztR7kdyxtB8Whaxe7w429txPq88fQYo+8sXpnBlCQIY9K/QWPdzQLpcmqlhxPmJTlAd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fs17Gb0e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fs17Gb0e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757394016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D6iQxBUowgZS1gNMSIU064JFfiN2wIaCl+0CSNLdzGc=;
	b=Fs17Gb0efYgv9xtY2buqxJ9RQu6AunN0CCuObGxayPoo1XCb+jzdGJKxdWPM41zv5guYHf
	m5VxVbweedjyYQItFoPllxPrqf0hJglPPVZWUZrXyrQJ9TAG89Xwz28fAW1akII+B23QtD
	QQQ+BpI9zcFk9zBI8KB/PitNxC2ZRy0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-5CvGmO7dO_Cvm8ZLBVEqAQ-1; Tue, 09 Sep 2025 01:00:12 -0400
X-MC-Unique: 5CvGmO7dO_Cvm8ZLBVEqAQ-1
X-Mimecast-MFC-AGG-ID: 5CvGmO7dO_Cvm8ZLBVEqAQ_1757394012
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-70d7c7e972eso113299506d6.3
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 22:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757394012; x=1757998812;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D6iQxBUowgZS1gNMSIU064JFfiN2wIaCl+0CSNLdzGc=;
        b=svQM5SziN5Z4Pu90OgsfS3FBVxKqZMKW/pCmEfQYbFcIwaXfpD1A5OLQRbbYb6E8Sc
         LTqIi4hhM2QJFVfVeyfGydbxlV0HzSb4RiTxgXpGC3D2VK31jaAVVIQkknQRkT5WEFPx
         A3tfWqRhXkXxbx/oq69GGaOHxqD/q9pIDx87wtQPl3dcz45OJN1SQrv2eh7PTRYauww8
         4jw3yFndxPZWDGTpCMd73k4HFCOoFLv9LlHAFPLJRKoBeWvFUqlwPY/BrctGzti5bXA8
         YxAvFz5r77tBfbQaEFMxvSTKcO5BGyTenIMrK5WC7Xq6POMMXbf9+zlhC6ZBmNTsklxC
         cbAw==
X-Forwarded-Encrypted: i=1; AJvYcCVlk1eIPRc4y4v4jPTZzD/AClTPZ30QHK3zqT8vYo69pCi1Pa4ce3NOeOkU3RIBohKBmeoaqWQp@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8uTtHGDvMSunvfZwhP/4aW5L4bykuqC1+DvsAMIpY9AJU1q44
	Tgau8c90ZTaSxfi0TLxMdUas6B8CME2SYLrE/J4XcvoxUsA9Lnp6hWMXfSpwIbP+xPGm7NwoejL
	O1rNIILeWDFjBM1Gxfs1x35VAEUJDk+2hJzBVeoEwsn5n1hN467LyEK8Yt4M=
X-Gm-Gg: ASbGnctT1bie35Xg1uWVFe/hjXlNfF4Ri0BzxXylezNCtwJvp7Nu1xImL0650/t0ed9
	nYkXhNAxu66NGEJHNzcjJIHvNCX1LvfrO56nKPOpffxpPn6ez6XcbIuur3wjm+TwaEs17oWsKMu
	vqKprL9r3mykLqvf5QaOvrZktFsNLANgheWU8CziYbQNt8emKE5Wwkph+KIOhU0XaoFhywAKYq9
	G4GvjD+5w2xUhWz3SkJatB14E0PvYrusTXLm5ao9+/ZI3LiP9LGur3PHxxsw0cJ9/gxneyoB9C8
	T/OfoUh6mx3y0IRkIpBC8yMtVRWD5x003pMHFUSo
X-Received: by 2002:a05:6214:20a1:b0:749:a12b:2d58 with SMTP id 6a1803df08f44-749a12b2f2cmr61920016d6.60.1757394012308;
        Mon, 08 Sep 2025 22:00:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbhlr0VwTq4d+7yg1kvRuLY1QCWsGq5tYaJVVe3wMI23DU+9UPnzZF9LjoX5cUPqjAsHKB1w==
X-Received: by 2002:a05:6214:20a1:b0:749:a12b:2d58 with SMTP id 6a1803df08f44-749a12b2f2cmr61919636d6.60.1757394011771;
        Mon, 08 Sep 2025 22:00:11 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-725dda254d4sm118146646d6.8.2025.09.08.22.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 22:00:11 -0700 (PDT)
Message-ID: <9487fde9-ec40-4383-aafe-7ae0811830f5@redhat.com>
Date: Tue, 9 Sep 2025 01:00:08 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] iommu: Validate that pci_for_each_dma_alias()
 matches the groups
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <7-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pPfiu_4FS5D4pizHPXXbj1GvUogcbr8M--gPEqQWhko_1757394012
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> Directly check that the devices touched by pci_for_each_dma_alias() match
> the groups that were built by pci_device_group(). This helps validate that
Do they have to match, as in equal, or be included ?

> pci_for_each_dma_alias() and pci_bus_isolated() are consistent.
> 
> This should eventually be hidden behind a debug kconfig, but for now it is
> good to get feedback from more diverse systems if there are any problems.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 76 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index fc3c71b243a850..2bd43a5a9ad8d8 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1627,7 +1627,7 @@ static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
>    *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
>    *     that bus becomes a single group.
>    */
> -struct iommu_group *pci_device_group(struct device *dev)
> +static struct iommu_group *__pci_device_group(struct device *dev)
>   {
>   	struct pci_dev *pdev = to_pci_dev(dev);
>   	struct iommu_group *group;
> @@ -1734,6 +1734,80 @@ struct iommu_group *pci_device_group(struct device *dev)
>   	WARN_ON(true);
>   	return ERR_PTR(-EINVAL);
>   }
> +
> +struct check_group_aliases_data {
> +	struct pci_dev *pdev;
> +	struct iommu_group *group;
> +};
> +
> +static void pci_check_group(const struct check_group_aliases_data *data,
> +			    u16 alias, struct pci_dev *pdev)
> +{
> +	struct iommu_group *group;
> +
> +	group = iommu_group_get(&pdev->dev);
> +	if (!group)
> +		return;
> +
> +	if (group != data->group)
> +		dev_err(&data->pdev->dev,
> +			"During group construction alias processing needed dev %s alias %x to have the same group but %u != %u\n",
> +			pci_name(pdev), alias, data->group->id, group->id);
> +	iommu_group_put(group);
> +}
> +
> +static int pci_check_group_aliases(struct pci_dev *pdev, u16 alias,
> +				   void *opaque)
> +{
> +	const struct check_group_aliases_data *data = opaque;
> +
> +	/*
> +	 * Sometimes when a PCIe-PCI bridge is performing transactions on behalf
> +	 * of its subordinate bus it uses devfn=0 on the subordinate bus as the
> +	 * alias. This means that 0 will alias with all devfns on the
> +	 * subordinate bus and so we expect to see those in the same group. pdev
> +	 * in this case is the bridge itself and pdev->bus is the primary bus of
> +	 * the bridge.
> +	 */
> +	if (pdev->bus->number != PCI_BUS_NUM(alias)) {
> +		struct pci_dev *piter = NULL;
> +
> +		for_each_pci_dev(piter) {
> +			if (pci_domain_nr(pdev->bus) ==
> +				    pci_domain_nr(piter->bus) &&
> +			    PCI_BUS_NUM(alias) == pdev->bus->number)
> +				pci_check_group(data, alias, piter);
> +		}
> +	} else {
> +		pci_check_group(data, alias, pdev);
> +	}
> +
> +	return 0;
> +}
> +
> +struct iommu_group *pci_device_group(struct device *dev)
> +{
> +	struct check_group_aliases_data data = {
> +		.pdev = to_pci_dev(dev),
> +	};
> +	struct iommu_group *group;
> +
> +	if (!IS_ENABLED(CONFIG_PCI))
> +		return ERR_PTR(-EINVAL);
> +
> +	group = __pci_device_group(dev);
> +	if (IS_ERR(group))
> +		return group;
> +
> +	/*
> +	 * The IOMMU driver should use pci_for_each_dma_alias() to figure out
> +	 * what RIDs to program and the core requires all the RIDs to fall
> +	 * within the same group. Validate that everything worked properly.
> +	 */
> +	data.group = group;
> +	pci_for_each_dma_alias(data.pdev, pci_check_group_aliases, &data);
> +	return group;
> +}
>   EXPORT_SYMBOL_GPL(pci_device_group);
>   
>   /* Get the IOMMU group for device on fsl-mc bus */

