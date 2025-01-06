Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BD8C8DF;
	Mon,  6 Jan 2025 14:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736175265; cv=fail; b=a2/6RGkwDCywGTjaVoNB8fXk5Bc80zRgH1dYeJDy488Dz+YPhB7FRJ/Em4dZ8VowMGjfX5Dl6H3S0nlGFe+uFDpMVRK0D83lt9njqi0ccc2LVVzbHWvEdYsgS++i2YSO/OnoI7OsetA6uDuGBDNWCX7eYmQgX0Bw50irZUnFVpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736175265; c=relaxed/simple;
	bh=eZx774ErpvSW3MIZuyiSX/THLXru9TJq0M/fGedRhM0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g5usdVa6EN4gZI5heQ8E9BFI/JpEDTfOy5KTrZhOWwJ2V6/enyVLkZgSwQcrq9M9ex1OZhG9IpDhi4UNhhWW1HS3pxT5bHRawuWcDc0N9OajDMBlnGKLMOfyV3LDzCU/80ARWhVTEx9om7KyNqUxCOspb4wgUI7e1H7hkOmsAto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bv8ivUr3; arc=fail smtp.client-ip=40.107.223.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bv8ivUr3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEO2cMwJw0IcYDGmm0A9Gju/yD8JtkX2GMY6zTnTxHEjXXvzlN9kSRAIWdtfGIQPmkXnWmJeVWuA6NWbxkZ8sDm5ydjXF0F4OPSy+tHId7QRsHH0lg75F3E/CZgFeYwGN+TEkPyTBo6tjsnFmggzl/fdiuBzRMC+itDkO7f5ZB6U5dc9JdglYATnXmiugpe9pBbk/gkNx635fs2V6II0xSGBdtjA3O1CXbtnjhYpV0ssMuDwso6AUDU0FsK5rhKUXO2w+HQrJGQtc3BkisGiNXuL5xutb2QeUIgpsSF+YRinnzrDG2R2PKOuP6csRrsJKTXXruTs/3W+ayHJC2hSRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khQd5/3sWWPSWBzAN4q8yf1QYaeoQC73JK2EmZBrrCU=;
 b=ZZz0LY9Dlu/KxxKLrmZnMx6qytUoUaBnYsl8CB/80u6YcSWzZNInSO7rsx674a2JDoakVnx0LMmp1+QcaGP4jkZPAFCeQejgpN1Eo0U6EILhZ3+PgsT1f8skHsaOCwoiBH9GfbQLgBNsJF+ybqwvV3mWJmpRHPxVx7O0KVPUppuJ89Dr8MxOMZb/ruU1RIJnoEX31InCwxT9Ch3THsKMj8OECZeo741lBbS+jeQ8lOC90hK3XLI75qumgn1ca6UB31DnGsmC/WhUr6NyTDjKlO4czkyPPe3OD3GOIg0CCyKJfKr4iXBdcrDmdOkRpRsRb+QyBVrEpzw1I7XCi3MGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khQd5/3sWWPSWBzAN4q8yf1QYaeoQC73JK2EmZBrrCU=;
 b=bv8ivUr3cptI9NhEoKwEwxXPVdZlChOMj6Uf+1KfvySON8NEOVlApPNkNw6sAYw1uOB/gb8epX5KTBAat8+Zir84J7jMetgb/rBiA/eczUK6Qai3b6FC8fLhnETAL06kMwwqS5OstUWbzoPY5YkVAdCYvVc9xFL0Kz/9ZamYROA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB6424.namprd12.prod.outlook.com (2603:10b6:8:be::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.15; Mon, 6 Jan 2025 14:54:16 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 14:54:16 +0000
Message-ID: <0147190e-613a-4fb3-9761-b04d26586752@amd.com>
Date: Mon, 6 Jan 2025 20:24:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] iommu/amd: Remove type argument from
 do_iommu_domain_alloc() and related
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <4-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <4-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::19) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: a3366dac-f4f8-4b6b-070c-08dd2e61fdf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3pDZkFlVmllU1B5cDI1dzA4MWk3dHNIbXBXZ0VEaTErRnBWdW8zVkNQY1VR?=
 =?utf-8?B?K25ZNU5Wamt5TkN3UTdlUUwyKzdUMGRYMVAvY3hXdEU0czdWbUFDNEw4eWtY?=
 =?utf-8?B?T2wvUVZkRHRoVUFVcktLZ3BUVXVDbmMrdDVkVjlhUW1oenRSRk9qZi90c1Nx?=
 =?utf-8?B?WWZjTG93emIzL1NZZGZ1bUx1L0VOVjhWRUNNQlFZNlVEVFV2WmNxK3JNWWpt?=
 =?utf-8?B?U1lQUlE2MktUUHB2ME02NlNxeTJDMi8rUUtZbkpMK21DUzRXVGFKL3YyYTc0?=
 =?utf-8?B?bkY1NXdZdVlvc25SdUF3aEQ3dXYvK01WRkpMdEZoQ0xWS2FCOE0yUjVVNHFw?=
 =?utf-8?B?RHB5QnE2dFk4cjlQR3NyVUF5ZmZkeXc1UWZzVkYrOHBtZkNkZGMrRmtyQnpN?=
 =?utf-8?B?a201MjJZTkdJWHMrcE52VlVXNDhkMEljZUlNTUN0WExJVXBqU0J6WmtBZEdY?=
 =?utf-8?B?TEd5R3pnMW55Y3Q5STA1UWdTRVpUMXNmbklaTGcrTk51ME1Sc2RteTY0aFlD?=
 =?utf-8?B?bmQxQ25UdXZTWDAwZU5Na284RHRxVnZzU0pMcWN4Q2kzR25McFcvQ1dQRnFk?=
 =?utf-8?B?OWlud1pZdUl5ZmduKytMUzdhcW1aMXd1OUU3R3N0ZnVSUlYranluQlJhbXZu?=
 =?utf-8?B?S2NGWnNyZVQxeVBlK1ZrTHNqQWFoQ21OUW14MjJKZERQWlp1M0JBYklNbm5j?=
 =?utf-8?B?dXRHWGpsRzJMODRQLzZBcjgrZjl0a1hyRUhMTWpaMnNZaUY3dnhJMnFNU0FQ?=
 =?utf-8?B?M1lXRDhoMnFZUmV0cTN3a0pieWE4ektyWExUSGlFcnpiMjViS2hHWEtkb1FP?=
 =?utf-8?B?N0hjY3RsTWtyNHZWTHJyWm83Vkp4dU1vK1ZhNWdZUk5kc09rVVNHb3pmRU94?=
 =?utf-8?B?allNNGdSZVFnMlR1SHptRzRUSHpIRHZrdWVWbHR0N3FYQTliaUtVaWlsRDVI?=
 =?utf-8?B?eWo0WmlGVzhYdHdBUW03K2tZS2dGSk9QRE0vNDRxbHZFWHc5M0pCK2hxTExP?=
 =?utf-8?B?RWxzUmVsZlJJQjBwT2cralp0K3FKZFIzUGdhUG16TzVpTU9ZSlFiOG4wMWV5?=
 =?utf-8?B?UW4ydXhnamFJVlR4ZisyWWk0WWtYY2IvdlRmZERNRDNTeXRObFp2RmZqOU1T?=
 =?utf-8?B?ZlZBNE1VQ1RKVnhvRGZnY0o1T1lBRXRoUEMyZ204Tlh0cCs1QkNNdGEvVjZY?=
 =?utf-8?B?WDJXYkN2OFNreVV0MDZGTEI3MW1XUk1Cd0VCeUlFWFhZcDNTV1JhT0wxbWxm?=
 =?utf-8?B?MjZQR0ZNa3UrcURjM0NqaUpJaFJwbmlWa2RHQ0hzVWdYMUhEWDVDcE0wQ082?=
 =?utf-8?B?NjNreDl5OCtwb0ZzQmpDanNyVTdxOGl5ZzVWcU5PNkdka0FhY0pzMVJsOUZF?=
 =?utf-8?B?WUNQTENheGczUS9lbGFVeWExSDBFNVZqTXh6am43QVJDaUVUNkJLSzl2RGFK?=
 =?utf-8?B?anRyVTdQRkZzL2VKbThkKzFURmNsSzhaQW5Vb1dxd0FWUXBEOGhVVzNjTWZv?=
 =?utf-8?B?ZEtCNVp5VkR6eEloR0hINjkvTmI1TzJKS3pScVFxQ2tWbzVNTFBCWDNkNEVu?=
 =?utf-8?B?NGc5ek5ZMm1LTWVpWXpMVy91eE1aT05hMmJtTDNaWC9BdGJCTzV4dGZ4TVlq?=
 =?utf-8?B?V3A0dzd2a3U0NklzYWY2U2dIWUg1UHp1Z0ZqRWx1TkVzZVBVdzJ1OFgzSHNH?=
 =?utf-8?B?Y2VXQzJuU01UcFpCTnFUSUwwT2U3MlU3OTQ4UWtyQ3VEYXIvbktYVFJ0VDRC?=
 =?utf-8?B?bXpURjRxS0RhcXdsME5IOXpyQzB4U2UwY3ozam1JSGVGTW1Rdy82OFdlSHlR?=
 =?utf-8?B?WWFnSHJrR2ZIMW05WHZ4cUk2NmNWdlFQZlBJcGc5YWtFN3BTZkRDNGhPTTJy?=
 =?utf-8?Q?1jMdJN/OWYAjG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dm9yaHpxSkFZSmprRjRqYVdnV3drSWJTaFptYm9nTlRuZERvWllOSG8rbmtK?=
 =?utf-8?B?ekQxNXBLT0dDOGJaUmR5Z2prM2F0SjVGbCtCYldQRFk2UGZQRExmc2ozYk56?=
 =?utf-8?B?azhKYzR0cEMxMWJZaDRvZ0p6VHdSN0tvSEIrUjFXRFFuRHVWdFF1RzFjcEsy?=
 =?utf-8?B?aWJQS0FzaFhFYWFqZi82RjZVd2RPQmxFR1dtMGVKcXEzdlNLUU5iRlZaaHBW?=
 =?utf-8?B?SkpGVFBnZW5vZXl0ZjNpSUJOS1ZXY0VkaXF4Vzk2bEN0V3BpTndnaDJqQlRW?=
 =?utf-8?B?Q1NxRTJrWnYrZWIwYXk0eVQrZjdZdFdwSDlMR0cyb2Nyc01TRzBBdFVvVTM2?=
 =?utf-8?B?NFFhbFBqSFBQYVdOWTVBTFp0UWI3ZTduNDZsL1BZSWxKWkorbFBYeURwcG9V?=
 =?utf-8?B?Zm8wamE4VG5XaW5FU1BOb0RJVHI2K0VnMmNZWEZWL2xROHM4T2diQVBUd1Jn?=
 =?utf-8?B?ZTdvTGlEUHNTTEIzOGtPV21DeUdNQTRodjg5azhFcFNaZkhjeXZFUXY5RWlS?=
 =?utf-8?B?NVg5b05rTGREallXcXdQSDdmbDJJallsMlc2Qm9DM0pKVXFoSS9Gc25uOHVn?=
 =?utf-8?B?M2hrRWRqZjVSL3RiK1BVYk1tUTBwWldnb09yV3pOaEZUdGdaOFFLdGkzUnA5?=
 =?utf-8?B?OEdYN09lMHRTSlhCUk00dmNIYnFDUWQyVVdGRWFwR0VNSlp2aWt1eGZ2aG1C?=
 =?utf-8?B?SnpMRGlrUTlzNXMybXdwSlBhNHNzUXlsSEtuM0FQT21Ka0FMY3BDTXBDbk5o?=
 =?utf-8?B?aUszR2hyWkk3ZloxNkRlRTEzckZxUGxJUFFvaFBYTHJWQnZQVUlBTGFVVzdw?=
 =?utf-8?B?aXJ6R1NZZVNKOEdMZ3kvaFdQaTdJQllTc0JxNjgrRStHWVFWaXlkcUk4andy?=
 =?utf-8?B?NDNLdzdneUNZZThXZDN0RzlQc3ViSUI4N2wzclZQNXptMzVJRVNLTzJUelpo?=
 =?utf-8?B?eS8zRi9xVS93TGhoMU0rclA4SFVXaWxsOElLaTJ4WmQ5b2IrR00xVTRCLysz?=
 =?utf-8?B?dUhxSGY0WVdtZFkrZHNsTVo3NGFHOHE4ZXg4VDJqQzEwM0JmT1JtU3BoT1RS?=
 =?utf-8?B?bTc1M1FkMEZXNW1lRGtjWDU4ZkRIY2JLQ01JKzlkSURNblN2NG5aUFdXSTJi?=
 =?utf-8?B?Tm95MFZqcE5jR25uTHZTVHYxK0JXV1R1cDF2cVMvTGZZMkZMV3BEOXUxWTBC?=
 =?utf-8?B?SEhoOUlrNTFGNkE2Tm5xaUNvZmk0Q00xNVhZeVJQUGtDeWJEOUNaVVpnMS9Y?=
 =?utf-8?B?OUxDVjJ3UTk0c211QzZyMGpGK21SUk00TE1salM4WXppaVN6aTZ0N1dwc2I0?=
 =?utf-8?B?U1RjRGw1R3lvVU1hQzZjSUJwS1VwL3lBL2R5d2dwVXFUMHR5akZ4dlJJeDQx?=
 =?utf-8?B?UGlQK0FMd2FkWTl2d2VVclpqaERrdWdLUzNYQVYxbFpuajIwNzluTStOMmRQ?=
 =?utf-8?B?YU02Snl4cFVzTDlaL2JhWjlVVGRtQVJyOTk4NkxJNXIvOUJncTJaRVBYN2pU?=
 =?utf-8?B?ZE0vSXFvdTJHUTkrSytjdGVTYVcwTURzOWxISW41UWZRUHYzMEFJaldmSWJr?=
 =?utf-8?B?eWI2b2lpSFlSZUtjNnVhWUJpMXJMTEFuQUpmU1R3dDA0VVg4WWl6amFsdEQw?=
 =?utf-8?B?MHQ4ckIzRHNuSTZLL1I0dnRXNXIxdTZUK1F2c3puaXowME9qODVlOUhWVVNP?=
 =?utf-8?B?bzBUTkJBeDBhZTVIRVRFVWpEdEhGRDNOa2s2VXI4SDdwUCs0dlJMVVBKRm1z?=
 =?utf-8?B?aHVBT2thdTNjVGwvVzY0U01EdjRBUnliVy9rTG5nOHBrMkxFYkRtck8zb0Vq?=
 =?utf-8?B?ZmZhT1Z0bU9uckpVMDJ2MTJ2WVNnNEVNend3YS9naUk5dDY5eFNaVTR6d080?=
 =?utf-8?B?dVgxOHZmajczMUxBdmVwb2ZJQUNJZWdHSVVoRnBuSndpbE15K08vdmtVSGtt?=
 =?utf-8?B?YTFoV1VzRDZkNDRpR2tIODlsTkh4ZGZJanJRMTBMQ1F0R2doUis0T0x5UEdS?=
 =?utf-8?B?eGtlRkhNU1RoT0wzQVNMbk1LYzhkUWd2QS9YOUYvQ25INmpXYkdBcS91RDZT?=
 =?utf-8?B?blBJcWxoVWFIZ2dNMGd4bFo4emZwbUs5K1kvYkZGdStWekk5VmZlcjhJSGxx?=
 =?utf-8?Q?iM9O1y2AIJRmQBUIjeitQXpv4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3366dac-f4f8-4b6b-070c-08dd2e61fdf1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 14:54:16.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z63mp1Gkv/XPDTDjAMMRqVsoRmvxFVtXDGwxsAhO97YZ9Jw4AGDQELIsDY36/rIn/C66x/wCiFi113G+ObJk0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424

Hi Jason,


On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> do_iommu_domain_alloc() is only called from
> amd_iommu_domain_alloc_paging_flags() so type is always
> IOMMU_DOMAIN_UNMANAGED. Remove type and all the dead conditionals checking
> it.
> 
> The caller of protection_domain_alloc() should set the type, fix the miss
> in the SVA code.


Minor nit, If you are respining then add description saying
IOMMU_DOMAIN_IDENTITY check in do_iommu_domain_alloc() is not required as we
have global idenity domain support and hence removing that check.

Otherwise patch looks fine.


> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant



