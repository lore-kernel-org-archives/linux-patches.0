Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023D31F4190;
	Thu, 24 Apr 2025 07:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745481398; cv=fail; b=B+Vh9ayd9qwuaFUq8no070LywFEGkklacT8Kf8Z2J61tM8awaGwwUtm+MZ8fY0HCnX6lfFteotKbzgpPyJtdA3OMSFZjzlBdbaqdGt+TkFzpJVz/wsr4GXgDgRkuAw/VwBzvIWYInaWI1U0qguvyWpSniMZ66SDcmvj/4zBSKeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745481398; c=relaxed/simple;
	bh=F90vW1e8mAuM4iUaMgngmcdeiL+Ip63dh1TG2KOtnWY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C4T/+8wJThWjURE8w61OTrAzBH/xKb41BvfLYu9h8OcQzD//3dTOQArVA1wI21pcmiUd500kY1h69jmGliPwIFsmO5lktBtuT/9nSB6NQ1DaTycv1DjpaXpHuGKIPiGLYfmo1iI31FOjrEWGDIv/rXL+HyddTDF2rD9BnIorfoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qHzj+G8J; arc=fail smtp.client-ip=40.107.92.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qHzj+G8J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zA5gKBU0JvVrl6b/iu7VBWZ1hK6t7yiejOD6EXPHChLoi0eMw425lEEEj+obr5P1iZryRiAzFP84u4Ign7jOAqL+NaekrskgzHJPJrFVYuEWFyC4cknUj9Kq729wQEDSkmNsnWHUUc3F89HytCJmsrjLvQba4bOlEdCpuPLjDri4gMQq/TrkB4EAQE4CvlDourbtpmWp5O0eXV2nPubnLiKr25EKsmocnrJebEwJYbeEWX3lvJD9ULzuNi9mg3OuP0gkwh74eA8CbjT6fsoIMXxaOE0W+sxe7fNsLeQC6wkkZEbTbkYT8UnheDBTT0T2zmAXXEQnlgFpZj/4Dife5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVQGcNzVUEkGO3dJV4yVqWkhhyRUGFaED9hav7WQ3h8=;
 b=dxsH3EcSXbdoMdlOJLN4lptpeFGHtiM5YYu0ZmgHFxPlZlBH0Ucuazjgyshtz9C6llLCXx/wFS4wLh8MVRUrXxIeGkaj2YF4ulz8NlLl8/OEix6Nm25Vicl/mOKT3x1rB6HyfVk9D+P/wIhNB7adc4WWH0QJ4h1mI7deWNB6Xr2SmSEXtGRyYS0O3EI6Csdt6/H6f+hezgFj+lTAjKwNgURizdrKYB9Ir9jxxROJJLku/pnbhDq1olcQySYtWM6qUvmXGaNwhFIxscr2uhQwLoXYdrlwlh24BLeD+XN58YSkay3rqO8mp+POJm9Wjen3N1wRAU9msqFdVBK9+/5kfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVQGcNzVUEkGO3dJV4yVqWkhhyRUGFaED9hav7WQ3h8=;
 b=qHzj+G8JeT6BbKL2VWvqwTpLulSWIC1Y6d2lWfCWbRmSV4XBjFE3er21Y/1DaDRLx8FR7RpXkViRJN1qbNWRfe0ZHTxS+rsFZC6QYN93FheQag3/jKeWzuHRGJvU2bplPW1jcqJDgrtZE4PxwU/UGu35iXUeDxxzsHEGpwGZPI8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB6720.namprd12.prod.outlook.com (2603:10b6:510:1b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.34; Thu, 24 Apr
 2025 07:56:30 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 07:56:30 +0000
Message-ID: <d5a653df-9b43-4f13-8b1b-c3268c356592@amd.com>
Date: Thu, 24 Apr 2025 13:26:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-6925ece6b623+296-amdv2_geo_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0242.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::8) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB6720:EE_
X-MS-Office365-Filtering-Correlation-Id: fa231845-c810-48a0-acc7-08dd830585dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0ZZdTl4dWprdEFHYnhzZ2VrWG5rNWI1aWVacER2Zk1qUjRwRCtxU2taUXdZ?=
 =?utf-8?B?dHlKdHBxWnJmRkt2c2tDSXUwSWlaSDRRMlpTd2NWU3VHQ0Z0Z2JhVDMyYWhp?=
 =?utf-8?B?RDdaRHdSaDl3YTI0ODNNQjlFaHBLcy9ZMTRZTlg0Y0tSOU5RM3lvMDIrQm1T?=
 =?utf-8?B?S2xOdDJpK0trM2ZaTjJJZEVnaWJteVFtSjI1dlp2bUplb2lwTTJYeDNNQVNZ?=
 =?utf-8?B?NU9qanN2aHA5eStnalRJME02a3pIZThBOGUzcW5EUVQrQnUzb1F3UVY3cCtG?=
 =?utf-8?B?ZXpEenNpaGR1NGtHbkZFZHNacGxmQ1NEWUZIdVpabmhlNHJ5Qm9VOC9la0Zo?=
 =?utf-8?B?ZFY0bzJYbUxWMHFnN2xLaGNJRWpPblMvbFh1Rmh2ZWlURXg4MjJ0UkFLYUkw?=
 =?utf-8?B?MkJkcmhVYTI4aE9iTUxEMEJJT3MzM2FrR0ZoY1czM0J0L2ducFlIdzAyOUl0?=
 =?utf-8?B?WDVTTTFucEJqZU52ZWVnSVl6ekNTTkRHWXloQzJKd1F3RmJzWlcwMXVPb3R6?=
 =?utf-8?B?L01MM0ovVmtQbldLQmk4bXhWcGRaK2w5VmVDcGl1aUVWd0U2d0xvMzJ3bGZZ?=
 =?utf-8?B?TkgxQlFnS3RoRzcrL0lWalMybEVHYVgvbjRjaGF6cllRNEJTS0JhL0V0R3NW?=
 =?utf-8?B?MVFZaGtoYmFpWlMvWE9sa0NFL01DSGlPWEpPNXhONmgwaUxlbmZnUE5OMyty?=
 =?utf-8?B?RXlobTQ4RFpTSjZ3VkpMSHVMTnFsdFpKOWROcVZqbXMwTWpPNUd6WUQzMEYv?=
 =?utf-8?B?VUgzNDU5QmR5dzZQMnJlejhZVmU5TUtWMGVxQjRRaEdjeGdveWRQa2h2STdw?=
 =?utf-8?B?WkRJRENMa3ZCL29BckhYaUhJWXZQUGluclNYS0dhZ0NFakt0ZzZXRUcxUGZX?=
 =?utf-8?B?N3U3NU5lbUs1bTl2UitsWWRvSTNVQmRaS1IzNGZFd1VVeks5N05wQnl3OTJI?=
 =?utf-8?B?QXVyajlPSnZQYjhjYUcrbGhqM0tjbStHN1lKM1NkdHUzdk1tejE5NXNmS2gw?=
 =?utf-8?B?bUZhcU1lWHRjTDFQRlNhSERJRmQrV3pvQVZBZlR6MDRXZk11TW5DNkhwR2tR?=
 =?utf-8?B?c1dUd0RobVo2b0pKTEtHZE5JNFAyN1ltT3dicVRJMkJ1cGsyRFUvdWpxUzJm?=
 =?utf-8?B?ZDEvMS9nd0puSWZJTEJFa0FvclZBTWFXZGVDei85aVVRWjNLWWZuSGlkQ0h4?=
 =?utf-8?B?TS85OHhlNkVJamFzSm9xQVR5VTRWdzhPRnViSzNTKythNk9tUk5ZY1RHTWZ3?=
 =?utf-8?B?c29IQVNqRVFOSFRBZUlnWGI4YzFLMENkYlJMUHRoeXdBRjlyQXphVkw2bCtu?=
 =?utf-8?B?Nkd4d00zUzBPa0RuWHNiZEt4cVdUYXJyTDR2dWRqV1h1VmxvbHIyWGhwMlhj?=
 =?utf-8?B?bWZHbnFRSExTbVl0dGpjeFZka2c2aDQ0bU00TS9EMXQwZjgzaFpCMGRRS0FK?=
 =?utf-8?B?YkhrOWdNcEZmK0NXd2Zad1IxZHlWZnBDQ2tDUUVORERveFR5ZnNyRVU3MUND?=
 =?utf-8?B?dkY0czl0N2FUZ0M5clRKRFhKSzZVcWIxaTBrRWxTNVJkNEVPdk5wUUowMERz?=
 =?utf-8?B?RXlvYmVkemZ3bWhPbU5iRFY0cDBVN3FqRmJDTG03REtXSXdTQzU1N093UE5W?=
 =?utf-8?B?SzRWTGxKTlBZZWg1U0o1bmxxY1JnRmpGQ1BvYy9tRmRYNE1YTUZKOEtXOG5t?=
 =?utf-8?B?OG1uNTRGZ2Z1dlR2NlUwcVk1QTZjTzVxS3Q5Z3N1NjVkNys3Ym1QUkQvRmkw?=
 =?utf-8?B?OXVNT3JWSXBpOVRxZis4WVU0YWlHbUFLL0JSTGxGdjd2UVREcDBLOHQzSzdV?=
 =?utf-8?B?K0I0c1lNVS9DNDJYTURaSGY2cTNzT2VoZkJ5Z2dQNytZakQzNmlPRnBHL1dK?=
 =?utf-8?B?aGh6OCs3c0ZvM1p5VGpOTlhVKzRjdkR6aHU4dUdwamJQb1JKMzl5RURhb1ZT?=
 =?utf-8?Q?XoVMkeiQOho=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGNQcmFSdU1ENC9WbEt6cHZkQ1RXN0RkL3hZOE9LWmxLZEUzZU9HZmozRkdr?=
 =?utf-8?B?N2xzMmRpVjQvK05vemVPYjc2bnk2am5vMXlDMG9RVjhOajlpdm41QmZCWVpL?=
 =?utf-8?B?MTg5dEZra1dnQ080eDNaSk1WSWlrQktxMy85Y0dwcmc5TVhpOVlzVGZGWjli?=
 =?utf-8?B?U3ZxYzg2OHBxTHZDVUxEbTVMdU1ocWUrOWZNRDQ1bHBnV05WTldXT2IzcnRT?=
 =?utf-8?B?em16SC9Wd1Bkd2V2aGtlb2tyb3lkYXI4a0owVjJsUm5zd0NDSWg0emRybkNl?=
 =?utf-8?B?by95czlQMUFzM0UySTJkeXlHZ1hESVdMczBoOS9NZ092N0pwTWVKWXNaS3F5?=
 =?utf-8?B?NDNueGUyK3UySlBtWTZlL3RYZ2toSnBtempHMm1wUFkydVpObGk4QWtjbzJV?=
 =?utf-8?B?R252ejJEUE92NEpJSHIvcGw1eERDSVNxRTB1R3JBMjd3YXlFNWxCWXpseDh4?=
 =?utf-8?B?YmlVRjRweURDRWlaMFVQc255TWREMEJ6b0c2a05nb2hJa2lwZWZKQzFFTGpu?=
 =?utf-8?B?OXQxek1tRmtmcFVJWVd2b0J4S09NclVHMm5rK2tucG03aXdzT0tiekhaNk55?=
 =?utf-8?B?RnFGZzVhNjdCdFQ2N1NuRUVxSitEN0l6dmhMWlVja2NkNEp3S3ZNdDk3SHhY?=
 =?utf-8?B?TEY5dWdQc0RNNkoxMmpRalF6b1ZreFoxNlliUnZtNzBXRiszVXhjbkxBa1U0?=
 =?utf-8?B?cFVyRGhtdndTRjFLMmRiZVpPNG9kY0FOeDlDNzhJMFM1Z255bmhBSUlYdVpz?=
 =?utf-8?B?Q3BGM2tBdERtc1ErcWtXdVdwWjNRSkFRRm05WWVkSks2RUpzcUpIcWZFeVpH?=
 =?utf-8?B?TXkzaUQySldnY0t1dzFBcWJjODhiUWVRdFpFOXBRZFlZVVBWd1d0aHdtQmdT?=
 =?utf-8?B?Umt3MlNMS05LZ1BUdEoyQlZUcGtoc2ZiWE93QnkxczVhVW1IZmJNeVpNTDhK?=
 =?utf-8?B?STFjZFZyOXhwNzF1TytUb3VBS3RxNXZBSXV1ZVJ4UHNVUGlyOHB3Zi9uV200?=
 =?utf-8?B?SjZYcHpLdFZwb2dZZjBmazBrS3ZxVjdER01ON1dtS0tiOVdreHNrN2w0aWxZ?=
 =?utf-8?B?ZHJkVlA4ZWc0Zzk3c1dBMnVnWXk4d3lTSEVKSnNXNHZTVkEzVkRxaU5wM21F?=
 =?utf-8?B?QjhZdHMxdTNXU3R4TDArOEpIaXV2V2plSU5zT0RhOHc4Z0M1N0VRNVB6R2Qv?=
 =?utf-8?B?c3kyQUFveElJUHRMcDNhNnlDUWdYVjhrOVBuZVJvdkduak02WnI0YjhmRGJY?=
 =?utf-8?B?ZXY1TDVFaXIzdU11b0gxR0R4ZTNVaXlCT1E5REJpT04rRUxzL2VJT1pSN01Z?=
 =?utf-8?B?OTlpODhacFIydW5Xazl3cS9mOENURzZPdWFvVmovclJoQ2NLRHpLMzhrWFR5?=
 =?utf-8?B?TUl1Z0hKWFkwMkZzY3VhZEdHLy9Jc1IwYTJvNyt1QXl1dEVZalFPcjhsRnMw?=
 =?utf-8?B?MHl6dk9rOWhaWEJKWFQzekxJbkVZZVh6R3BWREJ1V0Z2aEZ6WksvZFQwNTFD?=
 =?utf-8?B?TFNtRnZYcU5ZQTRlM0lWdUQ0L3lWMnNQTzczM0pQeE1ERlhkT1JCQ0toQ3ZN?=
 =?utf-8?B?QUJUVDFTcXVXemkxVzlNV1NPdFU0VnRUOFY1K1BBWSt6WHpKcUFaallEZFR2?=
 =?utf-8?B?Ymo3blBDM05ZZHdUU2ZETnJSZlB0SXQ5Qjhwc1pIdTl4NE90NVFwajRhSnRX?=
 =?utf-8?B?R3NKTGNOMzhVUmh3dG9CTnhmVUpWdnc3b3U3R2NmZmcwS3BUMUFDSDVSdm13?=
 =?utf-8?B?RHB2djEvV0ZsSzYxek9FNTlOWkRyenl3Tkcxc0xXWG94NlNrcFo3aUpMTDZx?=
 =?utf-8?B?cUFRdFlZSWthMmQwd1pidXNoT2t2SEY1d25VMUJvdEVNNk1qckovQko3MCtT?=
 =?utf-8?B?TkZUS0ZkYUd4dGJyR2piclNNNnp3NXRuWWVsdk5SN01CWDhGbEMwajJGenNn?=
 =?utf-8?B?T3Z4cTFPVmI2eXI5bU1SRHpsOWM4WGd2cnJuSy9OZ0x1YUE3eDBFcXBQRFdy?=
 =?utf-8?B?d0xQV3BkZlBSUUZmY3BHVU5MYnFGSzEwTDNmZGlUbEVLakZXbjFlQVYvckJk?=
 =?utf-8?B?SnMyUmxUbktoMlB4ajF3U3NscGFmKzRQRjdyd1gwUjFzaExGaWZtckdNRTdl?=
 =?utf-8?Q?b19vun9hdxI0vRAaMF5RtbMet?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa231845-c810-48a0-acc7-08dd830585dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 07:56:30.4107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYoRquaVh/dHO4TbDqux5/BlO6Wm+CI+et/Zi9o5chaGUpgELpkudrrGPGo/hoXOG7xYce7zk7c5hzp3StfYsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6720

Hi Jason,

On 4/17/2025 9:51 PM, Jason Gunthorpe wrote:
> The AMD IOMMU documentation seems pretty clear that the V2 table follows
> the normal CPU expectation of sign extension. This is shown in
> 
>   Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
> 
> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
> would have three regions in the page table: lower, non-canonical, upper.
> 
> The manual describes that the V1 table does not sign extend in section
> 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
> 
> The iommu domain geometry does not directly support sign extended page
> tables. The driver should report only one of the lower/upper spaces. Solve
> this by removing the top VA bit from the geometry to use only the lower
> space.
> 
> Adjust dma_max_address() to do this. It now returns:
> 
> 5 Level:
>   Before 0x1ffffffffffffff
>   After  0x0ffffffffffffff
> 4 Level:
>   Before 0xffffffffffff
>   After  0x7fffffffffff
> 
> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/iommu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> AMD folks: I'm just reading the documentation, it would be good to confirm
> this understanding. I'm a bit surprised nobody hit this, but given the domain
> aperture was wildly wrong up till 2023 maybe it never gets exercised
> carefully.

We have tested this with 4 and 5 level w/ some bench marks as well as w/
forcedac=1. It works fine. My understanding is IOMMU uses bit 56/47 as well for
address translation. Its fine for both DMA translation as well as PASID mode.

I have checked with MM folks. They are saying sign bit is notional thing and is
not reserved as such.

I can cross check with HW architects and request them to make it clear in
specification.

-Vasant




> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index dea0fed7abb044..10af3e9d9ea54e 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2495,8 +2495,14 @@ static inline u64 dma_max_address(enum protection_domain_mode pgtable)
>  	if (pgtable == PD_MODE_V1)
>  		return ~0ULL;
>  
> -	/* V2 with 4/5 level page table */
> -	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
> +	/*
> +	 * V2 with 4/5 level page table. Note that "2.2.6.5 AMD64 4-Kbyte Page
> +	 * Translation" shows that the V2 table sign extends the top of the
> +	 * address space creating a reserved region in the middle of the
> +	 * translation, just like the CPU does. Due to this we can only use half
> +	 * of the IOVA.
> +	 */
> +	return ((1ULL << (PM_LEVEL_SHIFT(amd_iommu_gpt_level) - 1)) - 1);
>  }
>  
>  static bool amd_iommu_hd_support(struct amd_iommu *iommu)
> 
> base-commit: 47aadfbd64cdf1f19c83e85ff4ffa9c024619ad6

