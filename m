Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25745C18;
	Wed, 11 Sep 2024 09:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047821; cv=fail; b=aS9N/QxaoYH9hEnwpGidinnr/lgS2R52DRzy751I7prWDZZC3e/laWgqHQfmtBveRyCSVP/77fgnQeHmKcmSZS1/rnAaWjGbMXDISk4C8A3pBU/OMNAvvgZPVafQ3lxzyeKB6KwA5znyT+Q7aEZWHivyUgc3CxBhAzAa2G9pyTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047821; c=relaxed/simple;
	bh=jIa4v95QAMjJY71Lx8Z/Pj3Cz4O1ln6I599wN/HCeWU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KAo7yO49Ls4TIOwQqmBOfpXgIqLEu08AK0X2hhX5OuMDTMGzn+glNoDKsAS1OoY/eeGwrCzVowWlaX1I9qgPsE8lE0MRepOw1iG77E2HPLPBGWnjl/vvCJ12vZwrwV1B8zHP9A733hkMQM69T8hcEvUwXvxKNDxwxREbXxcaN34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4nqaPWZ1; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4nqaPWZ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhCGm2S21n7zDXSrQgMhLTruA+MT5J7gmEo1LExwJp/oxK1ZZ7rXjsOSOqiaCOzpH1ZQk+vL71641nA4psibdodoPLWCjnEawSp+bYirGby+PFH0pWybcaW4id7lJq+AOUe6kKiBDHPH8rtTnurCvhVMlaNbEgJ/FkcVeoFsN1L3RWyFcApcF6loE5Ny+Sytb6VX7LiYK8WOEwkXJ19DYuFcd6GsyNkqMoAKE/volw//SPI6pySF7aGaOp3DVTbo8afhhTZjgBd8kdX1X49Wsk5kPj8GCH5YRa7WzKADx+bCLyvnXh8c+AHQ6OnlVg2mgwbP1xnESwCdb7+/YNVXEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5fgnwSPCjhneciyu4hv1Rbb+FAQiKjsHP93Fjoh6wQ=;
 b=akq/pOnMZRjFg/WtZeldsckGS4pcTh2HQYPnnE/b0kbXwzyPxMXVLGBt9XYBvK4t9bzksao66RIcYPX4YA3rRKa4ulfK2s07O16Ova88rJAxLn5uJoCS+HGL4p7EI5wGfsSDrTqSc3Pt1UVTa/3hiKegYC6nN0ZN1GCHT05g/w/FlJgDtNXz8knQhkqUMJXBsNYG50YN4Aml30Otl7P9nOEMQddWOkn78VDYbBDqmmCHRKyHr1HICLdeUgVPKFG60QP3a5TT2RA3iSnFfAnBABdzox4eLlRlcaGgpjkgTBaRqNjgx+qLsspKpDcB3kAdyhz/C4uKhNYtQ7IeNvCz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5fgnwSPCjhneciyu4hv1Rbb+FAQiKjsHP93Fjoh6wQ=;
 b=4nqaPWZ10oTge5O5XhKrhaZRVz6xjDWCray+4YpdfNk4Id1wHXrSVxwmFKGjtphJwZ8h13oGJXgttZflBHQjnrbd5iUTvvMyluokHQdNcy0G4QZnlsw2fDp727VnwcCe56b8z+ANonPsS6M8Yc7XOQG/dKK8aKEn6SC63ayRe6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 LV2PR12MB5800.namprd12.prod.outlook.com (2603:10b6:408:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Wed, 11 Sep
 2024 09:43:37 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7962.016; Wed, 11 Sep 2024
 09:43:37 +0000
Message-ID: <fccc18c5-592a-4d2c-9f6a-953c22d31cf1@amd.com>
Date: Wed, 11 Sep 2024 15:13:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu/amd: Fix argument order in
 amd_iommu_dev_flush_pasid_all()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Eliav Bar-ilan <eliavb@nvidia.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <0-v1-fc6bc37d8208+250b-amd_pasid_flush_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-fc6bc37d8208+250b-amd_pasid_flush_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|LV2PR12MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fbe9b34-bac6-4ae7-ede2-08dcd24635b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkplcVVKVkV4dS9Mb0o2aVRLWUFibC9WN3BLaDd3VWZwZXh0ZnJoaFRSK2pN?=
 =?utf-8?B?djBmYjNxL3N2YWpmZ2lEWC9Bdi9wM3NjKzFobUY4cUd0VHptSFlSQjNHUTB4?=
 =?utf-8?B?WmdkNXYxLzRqaXBjKy9NZzB2ak45QWFWSkg2TE5OSU1mSEo4ZC90OXlvc09D?=
 =?utf-8?B?dUxSQzlZdDlTcUsyNlphZGFKMVZxSTNacEQ2Y3laVTVLQVloQ1MwTmg4UXBw?=
 =?utf-8?B?akJQMm1YTVhrMEdGU0JWSFFtOGNmTWowWUpBU1RSeG03RjY4NDl2K3pudG96?=
 =?utf-8?B?aWlhWFdNR2pwS29qendTTVp1UHB6RUhIMGIxV1hhNTZHNnBLS3B1MmJDVmNo?=
 =?utf-8?B?SDM1UnprcktQeGNCd29oS3BRSnVYK3ZaQU5kREZiSXB5RFZPWW14NkVQeWFV?=
 =?utf-8?B?S3Nza0Z5ZFZqLzJLcHhsUnlvVmJhbGh5Y05pOW1LcFpZRzhqcy9Xb3lIMWdM?=
 =?utf-8?B?anZndDFsVVVpbDd6VHVBdVdZU0QxNlozV0ZYQTB6NDMzNXdkNmRyYXdwUkNh?=
 =?utf-8?B?cTFRa2JFWUJQZ1dsNTlZZXB3RFo0WjQxcXhZVnU3RmZPN0cxRGFvU2kvdU1I?=
 =?utf-8?B?bWpQT3dodFUxUDJWVnAzNE1acmFBTWxQeHM2cG9RTFAySlhFaEFTRzJxUXB2?=
 =?utf-8?B?cFZBK2thUTFiT28wZlpIcGQrRHFxSWUvNjlMUUNVNVZ0a2YxU1BjL20yNUtE?=
 =?utf-8?B?N0p1cjRMZUJ2czJManJKd3ppWkd0NkZOUTRMNEhWVXltNEE0cHA5VGQzUFBv?=
 =?utf-8?B?cVRqSHVuMENlWk02RUlzL0hOanhHb09Cb3lnbXdvUk1yblBjc3VnbmpqekVZ?=
 =?utf-8?B?cmQ0ZGdQU1laYjgzbzRzcXRJMlk1WDFaNTRMN0RQZHZ5QWVhT1BXUXBXNHg4?=
 =?utf-8?B?Y25OTyttOXh5c1pldFArNGV6akJEUmdzTkNXd1g1UVFJUEUrb2ZtbEo3c09o?=
 =?utf-8?B?RWtBR1JlblpCV1NEL3FaWVhYMTgreWJnZTdIeENxODBZZkVraW5PMHZuNmtv?=
 =?utf-8?B?Ri9CL0pPTm1YNDBMTTBka2lBNlAvZ2J5QWxDMnFFcUhZc1hLVytFWmFYcGRF?=
 =?utf-8?B?Mml5bTNVemVVSzdJaFVxKzhVQ05IaUJiS2R6bUFEcmtxVGdqWVlyaVArajZz?=
 =?utf-8?B?MVVBQjU5QnVZdG9qUnBiSDVicnFNMzNEcW1zWk1BV1JFbUloRDhXUFdaMkFt?=
 =?utf-8?B?OFlYYTMrZTU1SkEzb3JHdlFqWW1GOTBPQTZqaFJQNHZ1dGVidW5GTWw4YWp1?=
 =?utf-8?B?ZFZKMjJsTjFaOFJrTWhsYUNxcG00VElyNGtFb0xJQnhXWCt1L0JCOC8zYTdK?=
 =?utf-8?B?MUJMTnRlQkpOWTFObmkzL2dFODMxQzRIMk1TSDEvZlNaeGVsc21Tek1RbU94?=
 =?utf-8?B?RXRwVGhCc1orYXpMbHF6WDZxdFAvSWhVRFQ2Mkg3cVhxVStqL1RCY1luUFpE?=
 =?utf-8?B?SWJsYVNyaXNDYVZKbmsvendsSFprYkYweGlVUXYxZ2szbVZHUWs5bzRYRE5p?=
 =?utf-8?B?RlpKY2N0SXR2bmlBTURVWU14TWRMaG0yY1VDTGI1d2I2UU1HaDVBNU9uT2I0?=
 =?utf-8?B?UjhFbDhCVkhBb1RzL1h1NDltd0I5Vm5wbmhBTmJraDVxYW1rQ1FGSXVzRDNR?=
 =?utf-8?B?MjZRVm5Nbkxrak5YSW9adCtnc2NqelZOV3RhVU1BRDVkaTAyNzQ5YmsvQXhF?=
 =?utf-8?B?UXhEOE5lVmpra3g0OE5jbWVuNkUzcG5ERG5DbURKeG9SRld1dTZlQTIzeU1Q?=
 =?utf-8?B?YmZONzdkTGtBdFYwcVRONFZHdk5KWTc3TkNHOE9KalhjRW40ZGUyZU9FOE41?=
 =?utf-8?B?SHpnRkxwdUkzYUVndDc2QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3NmMFROQTBNM3dsdFQrVStJbDIzWjhXM2lTVWFpZGYxSy91S0hGenQ2MnNi?=
 =?utf-8?B?a2pYelBSRSsrbFBFbWdkQVZiakJFQXVVblVnMlVVMGhQU2ErLzVWdG5LY1Nm?=
 =?utf-8?B?bjFMT0dlcFZFclNRVHlMZHNYZUQyam1ZSk5yRm94M05ZU0trQWJXa3p1MXVy?=
 =?utf-8?B?YjZJUVRnS01vUExRT2ZyTHNZcStMbFhMME4vcUFsQm9xQUowa01iSWVHdFN4?=
 =?utf-8?B?RGhodnJFZWltWVdiUVJpT28xTGJVL0d3bEtLZ0hKdjdSd3lqVUx1UzI3WlBC?=
 =?utf-8?B?WFdpTU9YK1FIQkh2RFFmTk5nOERDemRXMTRQZzc4cDZ2blNpcHhBOVhwRTVX?=
 =?utf-8?B?MmdaTGJiOTNlUXRaRTY1YXNyb0w5OE9wR09xK3JYZGFVTnhpcjExejIwMWp0?=
 =?utf-8?B?R0ZPejl3c28xeDFIV1FvUzlyYzFhWHI3aU5Ubk92OHYvMWNzWmF3NjRJTUgv?=
 =?utf-8?B?NGZjejZJYnJMYkdWZXg2d3ZoQVlxMFBWeTVyYld0Y0FRbVA3SUc3NlNab2s5?=
 =?utf-8?B?M1hVVUM4R2RXc3ZCUDc1ZVV3eGt1ckpMSUsvc2NJbFNxRGxZb1BPSURTM2FW?=
 =?utf-8?B?YWNZeUo0MGF6dHg0Mkh0WVFaN2RiakRmVnFad3ZqUGtxT1BhaFQ2SUdQUEd1?=
 =?utf-8?B?Y2VwZUg3ZHZKMlZsQ05LQ0o2c2hBYTlRejI4VHhjYWJaeXRvMkFpU2oxdXM3?=
 =?utf-8?B?MzN3TTFYRi83bTROSGRqZHYvNDZvZzFPUjlmZ1AzUk43M1NYUVJXeUtHVDhY?=
 =?utf-8?B?a3JXaUxDRFBBYnBuSy9SQXpXMzNSdzZzRDVGcTlzQTZ1S21QUG8wVFhtSm5P?=
 =?utf-8?B?eUlwSkNEYVRsSHV4cG5QMXNkQ2xiWU94QUNmd3NyM0R6NXlhWFpvcUIzT1ha?=
 =?utf-8?B?czByazg3U1lsamcrNUEvNUhZVUFrZVZ5ZWhFZHQwbk40T1NXNnNZRFQzbWVW?=
 =?utf-8?B?WUt1dGl3WWFPTy84aFRwWUlRamxBN1d0Y3ZYL2NaU2pxNm9seUdCRWN2QXhZ?=
 =?utf-8?B?UDZjcFlVYmlvTEFnYUlISE84TWRKTWYxRmU2bDdzZys0WEJ1dnJYVnBvOUZi?=
 =?utf-8?B?dXcwSnJkOVBuNGdodmVCcEM1cjErUGxpS25adlBraFdmOVo0c2JSbGk2Q0Vz?=
 =?utf-8?B?Qjlkb3djWkhJVE1nZ1htU1dsQVc0WklPNGhqWVVIQjJJekVBMFBjZGJvTEY3?=
 =?utf-8?B?OEdvZVZXdlpnWFVLeEZIRDkrSHpuMnRGdHUrSUl0eEQrNVJKb3F4TXVqZEx3?=
 =?utf-8?B?Z01mQXExQ1RQSXlYR3ZpL2lrZDF1dU9hNEdxZVFqZy90ZTBjYWFvZkxFT3M0?=
 =?utf-8?B?VERWWUFFajdQYkJpRzQ4RThrc0twVDIxQitFcmNsMjF6WVV0K2dRZWIrVFgr?=
 =?utf-8?B?VWIwMC8yazdPNFkxYUM5MzVvdm9LVGFZbENGelhLUDhIVmQzeWFMY2Q4SEdJ?=
 =?utf-8?B?ZE9YTVlMZGxaVVo1NStWeHkvc25nbnFJckdEc0Y5TFdsZHhId2hPRVBpWmJY?=
 =?utf-8?B?YVN4UlZqTG9sVmN6S3RqemMveFdMRU01ME9PV2s5VHZsZ0kxdC9uQzhHR1hw?=
 =?utf-8?B?aGF6TEdISkgzRWc1VC9MWmxXRHRiYWE3ZEJnM0NVRkpqVXc1ZnVPWU9lVlNk?=
 =?utf-8?B?d21KR1JORFh6emkzS3JRYkpRN1ZRUUVvdEpXcGtNcEh2S2J5OFJzQXQ1cXRS?=
 =?utf-8?B?NmVOZnRJeFRKMER1bDFyQ3BpVFloNWVCdE96RGFEZjZRbUd0N1Z5cDNGZW1i?=
 =?utf-8?B?QmtVdDRiMDNTYnduUzhHdUpRbGg0Q1pwVUFXYVRjOHB1TEtRcEtCcWVzN0JB?=
 =?utf-8?B?dWtNRDRQTythRFlIVWlJTmtEcmZhclRMWWdHQ2llZy9kUTNnYnJwcG4zcGJt?=
 =?utf-8?B?UGwrbTY3Vlc2WGlzZzlnUkdMYis0aHJqSWN2T1pSOFoycUcvb2JHcWl6VVFP?=
 =?utf-8?B?bWt0K2dHS3lSKzVVeHM3UkM5MmgxUWR4U2VJOEdXODgrdFZOamJtUmJqVTd6?=
 =?utf-8?B?VXpBK0puTEhDNTNMYkw4STRUc2ZSR1JyT1FaaHYwSUR3VzRGMmZkV3p6TlJF?=
 =?utf-8?B?Znp2cWlDMzNHTGdmR1JhV0hEQWhTRkRtSkY5emRHcTFUblZvRnZlWXRmUjBD?=
 =?utf-8?Q?GothXWMF2j0/zrSPvT0TypDKv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbe9b34-bac6-4ae7-ede2-08dcd24635b4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 09:43:37.3429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKG8JOwvMt04nFrLedx/Ijc3cRHp8P+ab/LYQI3LZpomLacbCIpsTtXGYkVo2U4zFDFAB8lxWtfTdi85ifKlFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5800



On 9/11/2024 1:14 AM, Jason Gunthorpe wrote:
> From: Eliav Bar-ilan <eliavb@nvidia.com>
> 
> An incorrect argument order calling amd_iommu_dev_flush_pasid_pages()
> causes improper flushing of the IOMMU, leaving the old value of GCR3 from
> a previous process attached to the same PASID.
> 
> The function has the signature:
> 
> void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> 				     ioasid_t pasid, u64 address, size_t size)
> 
> Correct the argument order.
> 
> Cc: stable@vger.kernel.org
> Fixes: 474bf01ed9f0 ("iommu/amd: Add support for device based TLB invalidation")
> Signed-off-by: Eliav Bar-ilan <eliavb@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for fixing. I missed to pass param's in right order after rearranging
function params.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

> ---
>  drivers/iommu/amd/iommu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> This was discovered while testing SVA, but I suppose it is probably a bigger issue.
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index b19e8c0f48fa25..6bc4030a6ba8ed 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1552,8 +1552,8 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
>  void amd_iommu_dev_flush_pasid_all(struct iommu_dev_data *dev_data,
>  				   ioasid_t pasid)
>  {
> -	amd_iommu_dev_flush_pasid_pages(dev_data, 0,
> -					CMD_INV_IOMMU_ALL_PAGES_ADDRESS, pasid);
> +	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
> +					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
>  }
>  
>  void amd_iommu_domain_flush_complete(struct protection_domain *domain)
> 
> base-commit: cf2840f59119f41de3d9641a8b18a5da1b2cf6bf
