Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473525A33C
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744188684; cv=fail; b=Pr9C1XabHm0bRqiYVoUUX6+KmX4eM0WaUZbfYGsd9yInqmp9TIdjfI4mYJ3IkEbgntysbwFT7x0CSXK+a2v56a/wKYZOmcZuI+/F8XRhN95ZxRQsW2s6pGqPyQeY2QNxRH1IIvJRYTVPxq4RXXmWE4M9/9QgDM4fASesPudbMzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744188684; c=relaxed/simple;
	bh=HPQ/WTWbMgeYbrAIZNOeeknFKsRbs7n/YpUuSdrnKb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Juo3uDUO/JXQLc1rJ4RUiF31V3yoblB058IJth3ePMqroJ5zHDb8HOUTl7zmVDk7rNgG5hzhT5uXWdPbQDGmNCw8rE0axwP5bKwEMvpjSZGjGH0CMJD8benvdy1uHkdQqdYXv+ESwIc8kYDHjnn/NRLT//QqqM1Xbnt4RizFgP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oqy1qMJz; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oqy1qMJz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APw3N8rdvLvEVHL6FYBnTGazGYDpsb2jA8fBVgaOTuOA9xmYRQ2byfslrkGtRaI/lpMqYRuJI+IS9GJhTlS9jb2o0ybPm2d85KHu8rnC2OOW7Ifl8ahqq1hOvfHKgqxC7cfPncAZCkEn5BxrIbsTGBAVZAzzdQEr8GlxMTdoFjq7xdawFUmYi/bkorjU0odxrJYgTRtre+ow+MrImX02nhz0FHsfeCET6BZoCZlzArngDP5j6FQoLA1QmIPY+jaVwlHUKh2Nm++y/J4susHrsMdT5y6LwQBQHBOJqBPHvz0n+Tsfl7O8x1is5WrVZL6XNFZqFI+Cj4bJPKQNB5PeOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDedHdi7k9Vyf/QW45zrFOFQ/OUFUdCtuT1keGH6mTQ=;
 b=esoxrpG/UYnDSY/WHemlPw9VPtB+c75DmwHpVom5NAvGzk216xwuiCqhJITc2HL56j8oV0PvMNY4vIPU6LjpyDSErL8C1/jTZs8u8OB67kUDflkvVuDES9cTAXT+qEE0f8L3HRepXsN9oFeVaCJ/NNGtIIgiVwC+9jkFPCrfueA4hxRNyYlzMk64ngD208wBf1RTbQObwcnPy3662uatnQz3+6cjjGMVYAnJgpmhsKpAi8NhostBhKvsby1kx5p4RyS5M/A9CeJrkDNxeoLZeZK28Ub8D/5ynsF7MtK+MUfvUQZGsk/QX4nuV9otd6ET5x2PdoxrykS7as2a8GapgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDedHdi7k9Vyf/QW45zrFOFQ/OUFUdCtuT1keGH6mTQ=;
 b=oqy1qMJzj2oLzFi6PQgOWdMHmAFslaz6vAgOy80b1f6LuDriQJAAi/SaZvpaYu92/BhzXr7TE2kUKpHc7DdL4PEf9uwckgsKzdgPHCUtlgxFlGhE7pBr3GdwwzWAu2DqGzuDtSVCHGBu4xva0K3AKaIZjK/Q4vaBf910gNoJUFP9dEJnhGnHpVfoWPWPXk9yzho/caILSmhgrpYg27mjkoY1BNWL4bRslIQ95xv/cfKqJvuGu9kbIUfFsNir0zpQ6FJXtKEhKP8W1JDPBSX4yY5pzD7f55D3ATKbr6qBqrnr7mmeXGCd9L36lV4a5KGxGxBENiUakmjzKrIymJuGPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DM6PR12MB4075.namprd12.prod.outlook.com (2603:10b6:5:21d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Wed, 9 Apr
 2025 08:51:18 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 08:51:18 +0000
Message-ID: <48363ab0-7685-4cb6-acc9-723b96fa8bb9@nvidia.com>
Date: Wed, 9 Apr 2025 09:51:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250408195232.204375459@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0476.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::32) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DM6PR12MB4075:EE_
X-MS-Office365-Filtering-Correlation-Id: d3496005-ef10-4dd4-4259-08dd7743b1ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXh2bWZqaWFQOXNGdURCNjFDbVBaK2ZOVFhoc3d6blRDcGdSVDRWdFArVmxH?=
 =?utf-8?B?REp5QnZnbnZvTlZHWkNIQi8yMVZ5b0RFQlVueW1venZnOHVMa0FqMWtHbDlD?=
 =?utf-8?B?LzF1L0hHNlpUZFlQWVFGb3FwMVRTdDI4bkh5Yk5DSzliYk5HamdjTHp2OGhV?=
 =?utf-8?B?T2g4cWNEQ2c1bjdNTG5vUmg2cEdwZjZSQ1dxY0pkNmtQeUZnaDU3WXpkTG1D?=
 =?utf-8?B?Sks3VFlrR3o1U1VGeWNJSzdQK0ZhdFpwUmRPUWxMYXJUWjd2cWV0dE1rNkQr?=
 =?utf-8?B?MUxDKzEwTmtPMWoyVldtOFpyaHlEeHBEY3huTHVWTXYwVU03bTh5RXd6Zys5?=
 =?utf-8?B?SjVnMWNFQmtrek5oUXZRQ2pJMitwN2hTWW96R0hNMnlQRXBXZktkUGlRc1p1?=
 =?utf-8?B?bHRmNXpMRDVTcXJKVFBPYUZuMmtEeXV2ZE1EbUtyNERXbE9IbmRmTzJSZWdl?=
 =?utf-8?B?ZE1rUGtLVElNSmxhb0ZrelY0NUpvcW4yNHcxcFlSMEFsU1M1cnlzTTgvTzcv?=
 =?utf-8?B?VXdzb3NZLzMrTHMyeWRvMng4eVZOMGIvYm14WkIxTE9rYVAyNUNNWkpMWXF0?=
 =?utf-8?B?S0RiRzBFamgrZVJKOCtMREs0eXk2VWRwVEZYWm5DcVdCWWlKQXlGeHhhWVNy?=
 =?utf-8?B?aUhHWDBMRU5tYTgydlZSWDV0WFFxL2lVbHNieFlmYVFWYWl2TUpxVE1vVnhh?=
 =?utf-8?B?MFFTSUhzdi90djRRb2QxL0hFSHBJOW54VEF4MXplMEJ4MHd0YU9UUGF6bTJm?=
 =?utf-8?B?RitKa1hET3B3WkkvZWJrOTduM2tvdVR0UitSa0VEU3QzcXZLWVBZQmdMb0dX?=
 =?utf-8?B?dGdydzluSCtiZi9LSzZaL1VJSGRmSjRET0JpTlpPWVViS3ZmK0Z1ckxobmIz?=
 =?utf-8?B?VVhVaVFHaHBTeWlHRmJJRmRUY1E1L0lYYjQ4aVI4ekJRckdqaTRJZ2czMGdt?=
 =?utf-8?B?RjdtZC9iV1h0Tkx0dzdaa0R4VFVXdWdSRnBIT0s5N2twOGovWGFpckZmUlZs?=
 =?utf-8?B?VzQ0a3FITjVLTTVmbFIyQjg5eWU5VmJTc2tneERLTEgwZEc2SFIvTmxkekxl?=
 =?utf-8?B?azdKdTh1ZFdMbDRHc1VQZzVsL3FCVTVhNmhtdlBzeEZSTU14RVpzTWxYWnlm?=
 =?utf-8?B?SkZpY3RuVFZ1cjhjSUg4b25iK3RPbWpiOWk4NGc3S0tRTW5jZXVCdjVUdUZ1?=
 =?utf-8?B?eUZyRUxtM0d0Q1dIeTRXV3ZacEkvUjZvWjNVdjQrSWprdW4zbWZHR20zS2c3?=
 =?utf-8?B?alpSRTNDVWUvSnJieFRMeDg5VkFUcHI4Ly9lNG13L3FOV2gwMitSOWNEWUVZ?=
 =?utf-8?B?QTRlSGJVMys0Qm12enpXcFZtMm5Mb2VvdXlPWUwrNlVqTmZYaFZjQ04xcXB2?=
 =?utf-8?B?S3pSbHdpQkxjUXV2c1dISXo4dVlQbkxtWVFTTi9wWCtKVU12ZTNUYStneTc2?=
 =?utf-8?B?NW1LdG9tekFkSFNzTThlRDJkWUNFZVlBSXpBQ3JML0ovS1dUc0lrTmowZ1Mv?=
 =?utf-8?B?bnBoa0R0R09JQWRwQnZIenpxOHNQMnUzS0ErcHpCeWVCSGVNTkc5aTNWcXcz?=
 =?utf-8?B?YWpzZDNWWWFpT2toQjZsOU1Vd2xveW1qcWxtYkUyL01zd0ZCZFZ2b212eGlQ?=
 =?utf-8?B?b2pOVVo0elk3RzZxY2tweTdEcWVoQlBjRzllTHB6cnlDV3QxRTdnWUZ2Yndv?=
 =?utf-8?B?cERhTm4vYzRHWUc0eEpsa2RHMFpjeE5NcDdZUFo4YXBUd2N1TU5qRHJJSlFh?=
 =?utf-8?B?QlFscmlSWUlhRWVva1FMZVdtMVVSM0JWVjJIazc2V2prZnNzM1VNeEJBaHFl?=
 =?utf-8?B?aU5WeHorbW5yckZWaW90QWVWQlBrV1RLZlkraXNGT1NkbmJvQ2Z0L29OM3VB?=
 =?utf-8?Q?UkG7U5HhEBhoD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkxsNVlFSnoya1pFS01QUHNKR1lrcjBvZDhncTNxM2JsZUxEcjAwUXV5QSty?=
 =?utf-8?B?QlZMTXI3U2RkQUUzUVFDT1dDTVNqaytBY0FHTTJCMzJBS2dxNmpTYXc5Q09k?=
 =?utf-8?B?TEpnTm1iRHhDcGFvRm0vSDhCSG9hNkxKM3JNVVRmZmNsVUxsVkRMQXB0UEFo?=
 =?utf-8?B?MXg5b29RcUl0ZkpkaFZRSGNZVmZxK2pTV3hUcysrc3ZoTG9wM2NmSk1XL091?=
 =?utf-8?B?VEI5QzNMdkd4UitQb3Joa001S1hiQXd1NEFiS3VQbTgxbjdEUU1kNjJzMFh1?=
 =?utf-8?B?RC9qMElXS3ljb2VmVU16TzNlMXpkYXZEMFF3enM1YkxJVjdRUWRudFNVSjJW?=
 =?utf-8?B?Qm9QaklGTnFtT2xJeDdvZk93RGFHV3FmOVJlUTNOaUFzWFpjV0VxQkh0RjZv?=
 =?utf-8?B?QUR0eW9hVS9KKzRkbUVNRXBBckIvVWkranNSNFJBRHUra2JNWG9lUmtGa25z?=
 =?utf-8?B?bGtHWVhWK0MzcU9CNis5Wis1c2I5R2ZGMHlBei9DWFZGWUgvVmd4amNQT25j?=
 =?utf-8?B?KzZNNUtwM0VnT200c2t4RUE1SHVHbFVKUWplMU9zblNwRTFPVTZpYWtmNFRL?=
 =?utf-8?B?NzNSUy9oTDdvaTQvdTIrTTIvUllqZjM0VFN1UWd6cWRCM3FhVWoxUlAvWVph?=
 =?utf-8?B?OWZPWHcyZTJocGJoekFEak1SL2RRd2ZKZmJMZ0xFTDVpR0hEbk9lalRGRFhv?=
 =?utf-8?B?MGh3TE1EL0trTU14SEM3cFgyS21FUTI3SFhTK05aQUZQZVV2WEdRekd4a3cv?=
 =?utf-8?B?azNHKzVBc1hFak9PMmtBdmgvdVRWdG45K1RlQVRZSG9yak1FSFdNZ2NUUmFa?=
 =?utf-8?B?cFV4LzZEQXF2MmZyN3Bzdm14Y0R4aWVNclJsR3hQVEQxaWNhdTZhR05kMXcv?=
 =?utf-8?B?TmNwclR1dzV4YTc2NFdMMFN0aXB5alBaa0dzMVJnMVdSdWs1ZWJ5aW5BYUxM?=
 =?utf-8?B?MDNxSXNjQnRLY0lOTG5ZRGJuZUFuTU41WVNaODJCWHd5bUFXWE9zWkorSkI5?=
 =?utf-8?B?TnJ6blFPUGRkdUVrbmtPZzRxMzg4UHNGcTdudVRCMjZZSWFvS2M4RnozTC9l?=
 =?utf-8?B?RlJ5S29ReFpWVXRjc05qdUdDaHhDT2pScFlRM1psdGxZU3loSEJ3TWZmNTZ4?=
 =?utf-8?B?dmdlNVlBRzhTeHJ5RlRkcTBqVklJemFJQzNFdHlBSjBLSFpvanJza0tiVzh0?=
 =?utf-8?B?NGNDQUQ3ZVF3TlFzUHBKZGJLZXJSRjVWczZHa3RRL0M2Ry8xYldKb3o0Tyt2?=
 =?utf-8?B?SVQvbXFMUGRqK1hINDdrNVJnSmFHR0NTS1RaSGxFSmxrRmpKVUJDUjZ6VWla?=
 =?utf-8?B?ODVVcUJMc2lxSFJybmJZbkh3bzNUZ0NhZW5HenNyRUptMTIwbXBtbHEvUThX?=
 =?utf-8?B?RXU2TDNCdmVUTkZCb0haR0xZa3NKQ2RoaUxzUWJVYTMvK2dickdtbUZtRHFy?=
 =?utf-8?B?WXJBa2ZIQ2cwaTVuTkNra2dnUlVVa0VFVnVObk5VaTZRbmtqWlorM2RLekUy?=
 =?utf-8?B?Q3JYelJyZGx2aWltaWhObGovTFFneXVvWWVkRzM3UDdYZXIvTGRXZy9MVzA2?=
 =?utf-8?B?dWlyZWJHZ09BZzQxdHZQdzFKSCsxWjFoMlRDNEtpWlFIbTRNVWtrcmtwQ3RU?=
 =?utf-8?B?NGpuQTBpRFNnU1VpUFZ5MFFDY0d3Y3VIL0ovQXNaOXlsUzFJY3BvdVhKODQ5?=
 =?utf-8?B?d08yYVZUWlh1Z25BeW51cG16YjdXdi92YjFsNlN3YXpHRVNORVJmZnA2ZVVm?=
 =?utf-8?B?Sld2QTUzb3JEUmdiWXc5a1J1WDZjZkhnbUp4TE93cGNCMlVhcEttWDd0SWha?=
 =?utf-8?B?NFlKVVNhZWZydVRNRDFlNnMzV0R0SFUvNHBTNVY2Z0lvVXhqVnZocVhQRVhX?=
 =?utf-8?B?S2I2aVg2UFdKSXBYWFFNR1JnQjY0TS9pMGRzL3RFcmViSU4yQWZtSHdSWHBo?=
 =?utf-8?B?UEdENm8yQk42OG41K3JZZ1N3U1EwUTZSNmNrSmxKbG8vaXlGYXduTHpmdXdN?=
 =?utf-8?B?bkRKMkZuN3B1aU5Ed3Mzd0NXeklOMjlPODZYZWRZMVhCWjRyYXRSUXBKU1pa?=
 =?utf-8?B?L0JhOXV2MnV0VS83Q1R5ZlVmS1dZb2dlT215RUl4S2JUUDBGeW43Yk1jVTFj?=
 =?utf-8?B?L294WFNTai9oYW9aUWdnWjN4UUx0Wm9VTHVLYzdscGI0aFdUT215SWVMUGtl?=
 =?utf-8?B?eWc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3496005-ef10-4dd4-4259-08dd7743b1ae
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:51:18.5106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SfYXqnB6J8EMETdDHwCabGYnLrc1jbyNRZ4uvawjfKfXj0BsLxmzcll8F3ZE1jzRDWrxpjNMDF+lfdSoQ7vtGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4075


On 08/04/2025 20:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 728 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 19:51:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.14:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     116 tests:	115 pass, 1 fail

Linux version:	6.14.2-rc3-g5bf098994f3a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>


FYI ... I have asked Russell King about pushing the necessary fixes to 
stable to fix the above test. Russell would like them to have a couple 
more weeks testing in mainline first, but has no objections. So I will 
wait on this and keep you posted.

Jon

-- 
nvpublic

