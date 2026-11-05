Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793841196;
	b=1n7to/wEFFfyk3WF+LvH6MzSCAfkgjILMq+e8Cv0RHfAEjTVOfLhamgSajvSaY2Fu5Wh
	 /QGdDiGqxmp0Q0ez79GjmfwQP47xnWitAFLtnG3UtHt+KgCZfN7Oe+HWfkvkmbDupwNbK
	 9nuyyyC5qHtjPPZvCWp2Oy/Xv73Gs4BvzCBZxEGYSLCVGm4g8j3t0MjdJ7rF/kdFOw669
	 UgjfDMz4cbcpM3Ck6vKRuDES4oUe6ycaMoWYOOAx3GQW7nWOG/BPVeKriCOBFdiqBXcck
	 tieIhTLCpf5TA1a0NNm/zu0IPr1w46hm70vd0GuXqTO2mvq+8d30tkGsV+9ngZXUD5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793841196;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=TyFvSUTyjkoHJH/xQeMvHXtCfqi5ncDEReaRkf6yS+k=;
	b=nYwZ86Z0REOFX1osghhGAntzgLe6XVfyKCGcJhfVC7RIVTZBn+uY/j2SwiRV/UbnHWAf
	 w3CVnwmbxyoGLK5t6uPSOVRRJMMThdJTQ8Nn8LvUcy0KClUGeegJVkwtPOYu611aWoNzS
	 meBoqvaskFsgRR2Tn4oMwqYrlsSz0b3VG7jZNfdGCcjnXKT0uKcV9EIFBUm5t/S79Jyn3
	 C6bRt3FWsEyEw3IOsW29ROz5HH6NeDsj2/+Cw50LA4Ty627x2Pixg1zIRm5E/4lUgwMvS
	 tKYpqIHsCdzwXZZKDg9r7vlXmFhfG/XtqBnyfMaOpf+gltCa82c2fDyQJEbvzR6sZZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="hA1H/Doc";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.11
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35926606A31B;
	Thu,  5 Nov 2026 01:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35926606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hA1H/Doc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrGu3+yrZT6FB56m4vHvG6ajRhJB/9RrEFrHPuM/mT1MW5/8wAaNevW38K40AwPTpziMYesXZUoKvOuG23mXfQD4NSiLHjMqw1H5h42D4ngsrluEUDfQ9lZBHT1cQFLLS2W5WHrJCkLUPepBtL8ZTxzfXFMXfc8rlpnz4gYAz5t/NXLTFbvhGdZ3SmFqqDTRnE3e2VS93xdPZPt2dOV86wPP+omDtmzsZqoqOK8B3BxkSmpG1YjkHbKp0pg80g/qSDSg70rmdrdzBU/HxIuLiRpBG0/fegSXrpp4bomaAoP/DZi9hcEf46M7wsOavpkDL5cQhnxhSjZYt2g8/7lv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyFvSUTyjkoHJH/xQeMvHXtCfqi5ncDEReaRkf6yS+k=;
 b=tJcy0ensnmGDX351a8gA6eZ/xaaavphgELnAew5duh5P5zHGLNurZ5tZIqimxvMUHQKJJfsKsQ2mPtyrfnT4DX0VZCjV136kCos9UqrBtRMmGTz0Cwb1W78npMk0tkP0xsNd/IyIDDqZTvGn9smjhekMSyrsCJHtGvaZZYnS2CelrELJOwS5bYfueO2vQ/1tkvRzqy6OVLlUkJ1QIHsxlprQtG8AujZLpnbp61/uLmW7NL8Fz2TjKWOIQ12c9yw8cnLm3/ZGPGtpznbZRLzLYkELWmJWInAVOiEbQssF15LMYhoKuaVOY731dLIY/BTP32QWF2II3plCgKCYwygamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyFvSUTyjkoHJH/xQeMvHXtCfqi5ncDEReaRkf6yS+k=;
 b=hA1H/DocKiXIN0SOT184JZAoA+EbjjuWQi+r1a4re/sxiKTfOUKRlZ2MKqfCbRBY3GCzhXDc3xDblYNd6ZSokvrg+LyUqhFs1TsQFKhid8NxIoWZK97Elrtx1ElFs9grnPuNM44CYVythTO8dACZ/IEqHRIIePL5iVDPj+iFTnOVxRXFqu7/69EqqFb9mgzhhX0W3CvRQXpacLvID1ACnCZaqtqcTtwIlzHzurl/EpfaA6H3uq2MN41VoNRYtrmx73EIQz9GxnDdL/VbhddTQqY9QjeWcrX9Znq+IYRJ96DO26ZLf7zxk9rQ/FxfhihYgySeBn44qJznobzKshIOmg==
Received: from BN9PR03CA0302.namprd03.prod.outlook.com (2603:10b6:408:112::7)
 by SN7PR12MB6671.namprd12.prod.outlook.com (2603:10b6:806:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 01:13:09 +0000
Received: from BN6PEPF00000070.namprd03.prod.outlook.com
 (2603:10b6:408:112:cafe::98) by BN9PR03CA0302.outlook.office365.com
 (2603:10b6:408:112::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 01:13:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN6PEPF00000070.mail.protection.outlook.com (10.167.248.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Thu, 5 Nov 2026 01:13:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 17:12:53 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 17:12:52 -0800
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 17:12:49 -0800
Date: Wed, 4 Nov 2026 17:12:46 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, <lenb@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <etzhao1900@gmail.com>, Danny Gonzalez
	<digonzal@google.com>
Subject: Re: [PATCH v8 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <auvYDgFO3IZiUV9r@nvidia.com>
References: <auvHyrZmMXLTFyz9@nvidia.com>
 <20261105001333.GA1478880@bhelgaas>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261105001333.GA1478880@bhelgaas>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000070:EE_|SN7PR12MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 3013f8e3-1783-491c-45a2-08df3ad9f471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|7416014|261022075727099003|261022105027099003|261021121427099003|261021135927099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|4143699003|11063799006|56012099006|10067099003|260925021311599003|260925021911599003|18002099003|22082099003|261009223027099003|6133799003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	z3RG96APyyZDlab9qghSLri/DYcHjaoqCqeAMLzvzk3T1op0oSY1H9q8gsmvQTz7002Y3uvQLb3ncef4G8NlUMY6Nt2ncnwkBJV0615JdWoEw5GigtEx9JpNUJU7wveOFkNi/r2nTv5a+Ry+F+7pX8yTvwXJvXhhbH95KhrlCJcUdo5oYpMr/w5z3JwnCcyeYo+K00KHbJnRKv80xWYstYIqIqzHb0DS4toVomVVf8uWLfkaeCEc/B3Y/tT/Nze3QGPzjlxm8CT7BKCmcAW2NtVb9La4rxm54s+3M4RnNL8yyF+bnSRE3Af+hMGaVb04lYT4xCKJegwVvo7Q7cutS++/UCos8r9D0W/V99bP2OXIqtVZhRZf+ZfaPNKW6xVaZJg8rO/2Z+V4CN+6KEIkePkpGFX3MzAVq1s//l3UugU5XDMpn8ng5quztZzi71rFIPl/01YTb9v0NRSj45FGVZhbegpBKi/tqUaBzKWjx3nHGbL+P8/H3FALlqrE6czRdn7SL/ngapnJxvmM8dhKzZI2LUeBXxtIqiX3k+cD2jFI/oVcdntmVLeVTJ5pxN7Rne3N6Oa2hRKFb2qqE/QwXR13gAcvfyhhwY0Ta5TO/Vih1F8W40x5pQJb0PxuuiHoYbDFloc+KoCGciCMLFCxTIhpG7XGIv++xNGnThosNdokN1ZZdSYvP77jiwv/JT9t32TsKGDB/I/c6ovYZgxIbQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(7416014)(261022075727099003)(261022105027099003)(261021121427099003)(261021135927099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(4143699003)(11063799006)(56012099006)(10067099003)(260925021311599003)(260925021911599003)(18002099003)(22082099003)(261009223027099003)(6133799003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lvx8WWDsdT/k+dpo7nnJdrK2wXlEU3lWWwgafbJ6Q0H0sNXWy8RC4HI1ufac2VuX11IjqY+aMdN2IbfyUJV8Y2OH6WaIAmUSzbNF9Z0WFw98OVppGj9dyy8vdDj+rmeH8h6e06eegfmtO4nhfmQD1F/lHljR1u5zcktXhEpGIii0oZBwgwtX/jzz/8m9qodsygKnry7mbQJZqTlqpkAaNqmiMGThLfkF0m9lWo4HNMMS86E2erR7Zwh7ryLV8cdEYhjdWnR/1AkH675AXqT2LmGHZGISMA5y95tkfLykAq4945ZA1O1LAYxj+fR5wPVD6m/AP8yCy2UnaKoZ6jMBGOhPGXVnvBgycmZ3Pre0f9drcadShh9pjc3mdHbnktv+jiTodyDw7YZJRyAmv/kOz6ewsOmwtnabyes0T195rBjY/tXD3qCH3/wos+wDQZdd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 01:13:09.1514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3013f8e3-1783-491c-45a2-08df3ad9f471
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000070.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6671

On Wed, Nov 04, 2026 at 06:13:33PM -0600, Bjorn Helgaas wrote:
> On Wed, Nov 04, 2026 at 04:03:22PM -0800, Nicolin Chen wrote:
> > On Wed, Nov 04, 2026 at 05:55:00PM -0600, Bjorn Helgaas wrote:
> > > On Mon, Dec 15, 2025 at 01:42:20PM -0800, Nicolin Chen wrote:
> > > > @@ -4885,10 +4919,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
> > > >  		return -ENOTTY;
> > > >  	}
> > > >  
> > > > +	rc = pci_dev_reset_iommu_prepare(dev);
> > > > +	if (rc) {
> > > > +		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
> > > > +		return rc;
> > > > +	}
> > > 
> > > Unlike the other reset functions, this one calls
> > > pci_dev_reset_iommu_prepare() even when probe==true, i.e., we don't
> > > want to actually perform the reset, we just want to know whether the
> > > reset method might work.
> > > 
> > > It's at least unnecessary to call pci_dev_reset_iommu_prepare() and
> > > pci_dev_reset_iommu_done() in that case, and maybe even problematic
> > > because the pci_init_reset_methods() probe happens from
> > > pci_init_capabilities(), which is pretty early during PCI enumeration
> > > of the device.
> > > 
> > > I know this has already been merged as f5b16b802174 ("PCI: Suspend
> > > iommu function prior to resetting a device"), and I'm not sure whether
> > > we should do anything about it.  I wonder if we should just skip the
> > > prepare/done when probe==true?
> > 
> > I've posted a fix for a few times actually. The latest one was
> > posted yesterday after a split:
> > https://lore.kernel.org/linux-iommu/c66d5221a8e4356316d4f614c8584a80dc9d71b6.1793729707.git.nicolinc@nvidia.com/
> 
> Well, that's embarrassing ;)
> 
> I acked the PCI patches there on the assumption that they'll go via
> the IOMMU tree since the interesting bits are there.

Thanks! The acks are in time.

Nicolin
