Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6932626D5A6;
	Fri, 28 Feb 2025 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740753114; cv=fail; b=XiweVTx307sZlUCQjwRtILx6cTL0avf19pMFCZ/X0U1OhBf2uK9y2ClUacnB3u0H3QQoLKRbWqEXJLY14uos9TsW8nIaXruvgL85Q9Ef5gC+lHRNOHPLH9sAwaP4uFTKSEfxZ9RoBnJEcNWDI/xWKVrPHEbtoBMJvYgutoZvXiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740753114; c=relaxed/simple;
	bh=LDKqRbLzcpEVxx17/VVj6cU0wOH3sPDSWxSsyEPP80I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XQYBUI50oZm22fPD+4gnf5ynUfK7sdt27hWHuOyC47FiWn1HtzJ8LnYoRv+zKBXTCTi8/ROFjrVUyNbKVRj+ZlzDodoKR4h3dkDxjjtzqdNIAxPGURvnSkq+oqDT9pISB/n0gfJ8JiLjtA9aTWXk7aXQ9vJIV4R9b+3FA8NLRxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rW4OHy+4; arc=fail smtp.client-ip=40.107.95.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rW4OHy+4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuEewIkZeHaYG95WiZNhQWB4MWsgOt+m6UlU1Kmcv34vktnJ2n3f20IHDSbYT2AzTd/v0haP48+we3LaE4rG35Jve6920aal3CZDFUuANvcUbXvLJ4chU86QW+h4iUtIAMafskRelz5sIAVjPhnmBMD75b6bXHhjBjARDUictGc0On7VNF1VARK8gOMs8QviLfNz/6GyV/xXLZLeA4CB7+hcOuLA+lUTHbIX6InVuXT4Lk07rmQa0MygwkGJfqfWnx5obgKAeJIGvMXgqZfRceHxQqruhom1MBiX+S+EBdfDP8Ncv4OH83JmPQ6ZG8n/5hyclj77UC0UdHFZySrrcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgPgYKByoKk9Rkmt/2K1Tpz2DySxvA01Bn9irOZp/jc=;
 b=N7hijTsPY9A1niKReS3o8i3owIcSSDp8CB2yjbLSsgLoRJiCVNhNvAJIZB4QLgYh05ctLBD9DD+nZGltNgN+GT+7zc/k7tN8yAo4wmxpn5ftKd1QWCKkjQ6EUrFLZxYiPHSgWtSbQVYWbgNSfmxniaYIVgp6hAckm11MYnz3pEwvPtNVisHtHa8wcbCZhGOdhKdVTjstxuEyce5G6/K6TDbF4Cfn2yjQONDHBe8Nd/ScWF4yWiRtPFQS/b1tdtFyiGXdxSQW0cLoqhSd96dyruwMl9gCJ/2Y18cD/s2comcJos7t1mOuyAz/h3agcplVB3ZZfc+OpzZthNeVgySgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgPgYKByoKk9Rkmt/2K1Tpz2DySxvA01Bn9irOZp/jc=;
 b=rW4OHy+4k59V5+QfkgM50QQ07Hkq+9bSs0OSmrSViSqz6Sp7yvcUePmf0medS3nmPILVZqsY9pe/k+KxS2Y/qSTQnAn76aJRdsuP/lLf40Aw14EFkBpJcjWPGCSAzawdzzgU+wDIWlkJqUjkeIisq1C3I1Wrz5PH5FcAc11xvzp+vCwfy1woOD1mLDaIhuyOrzVTv5WoFLyHzuI1+eCXAe4p5sSH4VaarrMSoNdW77/lSNufCSh7GNkXovqpstKwGgEES1P+r1OFhpTuMjnGek/EjRWJiw8vAkoGL7YiU/7tJs+9Ok3ANIJZr72Bgz7FQZZLi2QzROrWhHts/WxNfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 14:31:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 14:31:46 +0000
Date: Fri, 28 Feb 2025 10:31:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 2/5] iommu: Add domain_alloc_identity()
Message-ID: <20250228143145.GS39591@nvidia.com>
References: <2-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
 <3e8c4615-7f46-44a3-91fd-74da59c5b13d@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8c4615-7f46-44a3-91fd-74da59c5b13d@linux.intel.com>
X-ClientProxiedBy: BN0PR04CA0146.namprd04.prod.outlook.com
 (2603:10b6:408:ed::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: 1353e52a-4218-418e-ad3b-08dd5804a109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FU6KaoRTQGoqu3X88YFYv53scUQ2ba9QRdI4z2zaV3j50mGH9flsZCDsvpSw?=
 =?us-ascii?Q?MnzcEhlUOTFwrHMS43+cy4RMiiCJHExdJOlI+yfPsZWl9D8ODP6vyEMVb1+y?=
 =?us-ascii?Q?3ll9XvzKv7HRBM66MhRidrvtmN33JXpENZzpPJ37AJQjybeDzp04opOOTUXE?=
 =?us-ascii?Q?M9W4C6cKyKlXyVi65svOqq8jRAE7vakrfT+untQqhRP6Q9DX8P1Yzc2Gv138?=
 =?us-ascii?Q?SQqh3VBBja+5m6ol8TlVnri4sDNpDvMX55tkyvKXFctjwSOdZVSjyTcRiROi?=
 =?us-ascii?Q?sBescPVARgW2+HVF0hno0+4olIGBOo/IGhaymdj0y4kbQZfUiCqXpx9A3SWf?=
 =?us-ascii?Q?qQ2Aeuakafaz7cfTZNt8+w5czDJIIwYpb+urzoMPOrXOT3abR658uEQjPIBo?=
 =?us-ascii?Q?RCOl/ADIE0WQTmYy8434w3Knvjrsc5zq+mUAUlW4AQJUEAM602hj881fkg3G?=
 =?us-ascii?Q?BgdrCZZhJ4Sef0Jzda330d6Cd7gC0ywIhv3vkp7SzBtwRCEh8E8y8wmGgcM1?=
 =?us-ascii?Q?B2oVhqq/3kTzedCFMXVtFZa8HihNVqjXlMS4v3k1qcb0GPD51wWvRyAO975l?=
 =?us-ascii?Q?DrL7EKDvZ1DtGAzahRcxWIDkfGguLABMbTpgYVu42db8LC84zQsRmCbo+Sf9?=
 =?us-ascii?Q?CnQIEWVznsQBj0gOXcVnPtgGyYJBhnjYm4+RBey5dwYlkCMJPCbrpiafGu2w?=
 =?us-ascii?Q?KviWdrsRRGzmqRUh7NQtEje3uhEVOd2nHcuEpeBBDOvWdAEGVbSGsv2Y46bA?=
 =?us-ascii?Q?WsCrdu4Kcb9aRgSDztGYfK3JlR/i8+Z7dcrIe1moZmVeI8s6A8CcXBriYUSo?=
 =?us-ascii?Q?s7YkwfgH4wIH86MeybP8kiJhBhmOrV3p1Ks0MqD4ALg/IjcXV+XbQkal5tNx?=
 =?us-ascii?Q?QTechmEL5q3TdYW7hG5DqKZbGnpHFjW5JLmg1tQf+JXZqMuorNgo3rxjXHaq?=
 =?us-ascii?Q?dYlIvBhI9tBNWjY32qP3xyNomonAtHsZFzKxLlwwVGFqZuN3o/OPENI837f4?=
 =?us-ascii?Q?eAWMbwc8CnYU5S+W6gMoCLCO/ycHpcjf/Pu8zDZ7/HnMuxR/M/s/CTt1xy7f?=
 =?us-ascii?Q?rUyX6RjxcRL3keRsDVaVqGVpTlD/5zQk+zCohJeGkgSBANcIdvVYxm+2K5rM?=
 =?us-ascii?Q?KkrgDRR7V3UzGo9WQEPdlvEoeYVtlR4AIndafRJBYjI6KNbPOeUNKB6/9Fd/?=
 =?us-ascii?Q?EvGbyt9PCcNyhuUlecp/s/JwicT2XR/26nZUJpQV03rI/XF/euc97Sut0P+z?=
 =?us-ascii?Q?I0I7VXTNfB4HFezqaVfVDNWyVNlxEQzfbrfZSjxvZ4QZhbWaXCfMWDUAxnib?=
 =?us-ascii?Q?YIAxKpEaalLTUvlzjOUARDUSY9M4/DS1zSPK7AqZxdWEccewNsvaZOIh5Ywq?=
 =?us-ascii?Q?QHeYIeQOhjfjiHZqHmMxwIQ/0IqL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a09UTguL6NiRxWhSaFTNLZlm11keMuVtqR+5pzDEC8Ktpaa6dgxAVonEBHEp?=
 =?us-ascii?Q?zn41E25R2Ki5gj7eP/hBO0Pi6xsJCqICsMZ42/OlqRqB5Hs7AqCxvdjzKyAf?=
 =?us-ascii?Q?9IKFpgpAvKK2oJWP9oPrgQxIrSOQrMI9WkOVs6+UEmCti0Afbxia20k41FKn?=
 =?us-ascii?Q?H4X4VCOZyxZ97XFV/G+8NCUH5E2o3ABeoE62s0obvGTfTVDjHynW3UX+SoBj?=
 =?us-ascii?Q?Tds2oAXg9qm8bpvzeEYDELEAiSs4zA1IqPylWzH2pVjwEYDlslZot/JbrxHX?=
 =?us-ascii?Q?DyuNazy2dkMuMWyq+u6Ak4cHyHjjWoR/yvF+lWnq5i7rNqFn+7GcflQYRkIL?=
 =?us-ascii?Q?pWB7uM7pHQet1Lya3Vtdn6D6CbzYsEiPVTI+iedFU43FGy21K0c3WMhAWcvb?=
 =?us-ascii?Q?ccdiCai9awSURQbZb5gDagzYU+Igu1F5L188Qr88vQbKhfku+clEYMb7/alO?=
 =?us-ascii?Q?Xt9P1Fr71bwAWofZg4pckOXq32Yae36Femqs13iKuo+xUbP7ln4gpOtUXeCO?=
 =?us-ascii?Q?yGIseVubiWz5XX0jEww7MXYn32OSmIo/nxP7JZeyTSIOIc+T/CNrPbT+/UjK?=
 =?us-ascii?Q?ojyXD/kWVmiczXPjymrGOtc0ggjojaPRAfpaxO48sBdQweDV9XDK2DVTtt/k?=
 =?us-ascii?Q?aOclex0F9LsmyyVBb7xYD3ksttpmAY50hAa8l8DaVvpN6SZRF/5vIaEKXULk?=
 =?us-ascii?Q?jr2fahETZO+jLANqU66G/qVrGDYbDXUcZRa5eYqVuNwOBABGALRKvtevgnvK?=
 =?us-ascii?Q?374zGyLutiB0+UaZ8R7UWFpxHvz6O/13ef+FG4C9KlrlN7zuTB2t6lCNUbAg?=
 =?us-ascii?Q?qqAtXZrjrBynPIHtlcHWCVeoUz75rXx3X20Z6BgX5q7TfT0YjDRGMDlM/pkV?=
 =?us-ascii?Q?rE7tciqxCPULQ0/NA6nkXT+i+2WYmZ2Xid1qdtSwZi/gfhCT1H0HkvaWnRS1?=
 =?us-ascii?Q?93l3c7E/8wLOtXKOJ5fuJtreHdpW2YU2LU+2lD9/nVwpgJTBSyBT1zS5VkS4?=
 =?us-ascii?Q?GcUZSE++nBgo9SZY4cboE/fMvsg0+n0Df6Xp1briclNCUwtHwe/ao4kr+DSN?=
 =?us-ascii?Q?l6FjWL8ttYTjzNcrU8hjidJ//nC+ysaBwlWbi53sikPLhKNmVYskcj5DNRg8?=
 =?us-ascii?Q?S68+eNifQBPOCRo0NsUggrcXsGiEWrxlOSW9caDr+pdtT7T3YX1MaoF/2VNW?=
 =?us-ascii?Q?kBw2IF88/0V/oFhZsCHX+i7fwTRYPxbUWu4ERQCUxpCK5QzyL2lUtIPX5bt+?=
 =?us-ascii?Q?TJ4amTFR5RovdzlyxwMNYyb8+7ebOeQrG3FTC9Jufg3KTXd9Cd3lYEL4URCl?=
 =?us-ascii?Q?WxJ0wS9upeeCeeL2wYTH9+AHAHOvs3SEP/9niEE9kTiUQzS05a4xBarOfZgu?=
 =?us-ascii?Q?nlkGim8V4iHXOojEHPG86nLHkmGmDxK+t1s/N5o2jP3q5uimlp49JBbURxLL?=
 =?us-ascii?Q?dryAIWqgz2klIgQh+ZtHWFA5jxL83OOW7Gl/4V7VSNcQ1zaXTdSSkoUvvmm9?=
 =?us-ascii?Q?9lcqSLa+VaQWhS2B00XkkB50Gr/soBCSN6W0RIa4TPs/V8imFQ+MORUp7ThK?=
 =?us-ascii?Q?KEY5XSn8fTUUDdXUhftN2ewNANiMcWnfuYXb04Df?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1353e52a-4218-418e-ad3b-08dd5804a109
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 14:31:46.3086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fqYmYmWgHEts16GkU0r/PbMXl7LC307MLIe5ERIfKNsjATjJTXuIg9Pm0G6gTQdz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532

On Fri, Feb 28, 2025 at 09:59:53AM +0800, Baolu Lu wrote:

> This seems to be a paging domain with identity mappings for some
> specific ranges. 

Sometimes it's the global static too

> So perhaps naming the callback as domain_alloc_paging_identity, or
> domain_alloc_paging_static?

s390 and dart are looking like they will use this function to
conditionally support identity with the static domain, so I think we
should not add paging to the name

Jason
