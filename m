Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011045.outbound.protection.outlook.com [52.101.62.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A9B3164DF
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447513; cv=fail; b=houiHwjSdYrrjvCOYwKe1+qflYHrlQjUqgCz1n7BEcd/OgWuQxHwp/jgQzkxuI+z+7LM0KoqnWDqEP7uULg5uvIcMk2NIf/uWZeX4xY1maO0g7SZjbowrpu3ta/hlhxzjwTImmPKJ+fz5nCDAkcxJcWWBS7CETP9GA3QMRDtKV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447513; c=relaxed/simple;
	bh=/vqk+fdDXYCKiwoxi0umf4stss7/n+MaXnH+CMFXyWQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fDDoLuyvB1PmDhbi4cNOKz/vvAhHRGXKLctclDOhva3TNUO0JCfx+PtTdUc3pz6H0E6teuk8Eo2CRYdD3a7GXdTsOYgjLJ2BXt2mLPsHDiQTfZ1mnmXg3xDzdX60bX4DOw7Zz64OdpfGgnQdyaehUK4FLuCg9vqsHfAhn5IW87M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DyaXA2hU; arc=fail smtp.client-ip=52.101.62.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DyaXA2hU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psTqMPHSLAGYn5zgZz+9EYcoEan5//nmnLasMOGWyMFHKb6OkPEsFmCPnNz2nqUD2RS3n9tXzjaae972Suy+jzogmJFqVCNIvo9j0EzDkk7ODbk0GT/QyIJkPlH7ARXa2nekchQ6Ef9PRaKysme/X5H8Zs/RLD43ukN4fiHAEqnTl5yP4mPJ/qzVJ9gZan2HueegSEmMuFPWzSFvfCZsTEDwMpHy9Fe3yH2rvDEKWUWOxJayRPTjF5bC8ISt7jSs0mpsZDJVSQFdNYQiUsHox36G4rWR9Wwwteh0phD1dSz/IB0vg8TANvyW+ITQZ3hoLKR9D9K73ZpbbBrNHIE5jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0gvHIDRMmjyxywgHvoR3YWDhl9WBmbiN7SVMsciGpM=;
 b=bH3MJDV+CYpS7JhAmFFjWxLiMy0IntKkLb3iFwwsv0ya+uSO8AEVQjadxkD1656n1Ap03/Azrw1/oWfpMowNK62Gs4DY+BzGOA6LaUodwClA6hrqUVeGfzeYusQDd2nP+dCi76palMXHLB4GC1udJox2jUIngWNDVI2wDeX2gk1OSrzjtAQuBv+6dsdSp1Hl0loohwx7bMCepVx4Q7Vv8Ixad5Dvaa8Nn8pBOJXpLjjpjnx6S02pzOsxuPePyQ89AtAogD73dr1sanZLD+TDCUCZ6myMiayxwHN0KhWmX29Xmq8vmX/vVZL2OZgCR7LxkEOdAyuXzOviNJGhFs9HZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0gvHIDRMmjyxywgHvoR3YWDhl9WBmbiN7SVMsciGpM=;
 b=DyaXA2hULvW6/OxWZKo4ERlofANtCMhNbJu3i/t5i4xv2z7nqq0LQfiNdWj5EizBxYZliTPQ/ESOrGynI/yS4y1bnFvwt4DHeEAhUxU3heLSvWIZ0i/IocOgrc5JHiqEY5DJAlrXriNMuJmbtLs/HSGvIi4oijFZiaXx+fTDTdgJuxtlynThdHyxxcA/ml5/TG+pvSEN4HY9pyF2LIeOoow5VGQtIp3R64GN/9SnZyGPpDcbboMPJXHKTOnP5N3UBhlXPjQOP8UX9rMVF3aafG6JlSN5GNqBgjFCHwRoLNIMuLgqt+d9REOqHv3QPsTJRpxjpoVq7A/X2EVlK+6Adw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by BN7PPF8FCE094C0.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 13:11:41 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 13:11:40 +0000
Message-ID: <046f08cb-0610-48c9-af24-4804367df177@nvidia.com>
Date: Tue, 14 Oct 2025 14:11:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20251013144314.549284796@linuxfoundation.org>
 <4ad822af-297a-4de0-b676-6963760a8384@rnnvmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <4ad822af-297a-4de0-b676-6963760a8384@rnnvmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::20) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|BN7PPF8FCE094C0:EE_
X-MS-Office365-Filtering-Correlation-Id: f60faa16-d974-496f-92f6-08de0b23364a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXJlVVg2TjhZbFFsSE0rdmxuMVAraTdmZ0Z0c1VPb2VMV2d4d2c3YUNCT0pn?=
 =?utf-8?B?aTVvMUQwZ09qZkR5bThnMU5oQ3VDSEVXLzVranVUTHBJVnAwRk4zSHV0SHJl?=
 =?utf-8?B?RVA3S2dEWEhoamRFMXU3aEd2aFB5enAxS2N0N0NnM0lMczRCYXowMnhQVlMx?=
 =?utf-8?B?MEFPQTVyTXhVRzM0aWlsMWJmemNUaXVlS01IYkdhUlQyUmQwd3lDTU1DV3ll?=
 =?utf-8?B?ZEs3R1FjUDlEZFpXR3BqWU9iemNxUE9EVmI4NFByQi9Vb0pPWlJBUlZaRkV2?=
 =?utf-8?B?RCtpVlg4aEdZVDA3REpOcXNpcmNSaFRXMTNPOEh2NWFjUlVDckRkL3Nzb3NH?=
 =?utf-8?B?cmRHbTVmdTkxNWFEa1pMaWRVemFLdzFkckNLQjRKRzFieWJGZ1ZsbndHM0dt?=
 =?utf-8?B?dFVpWUtkbjlFTzNMMzlIczZBa2cvcUNrZ1daTEs3N2Y1VXhOMzNHZzFMd0pP?=
 =?utf-8?B?VW96aGRzeGVObGd0WlFOS09ZUmtXNzA4OXZyYnR6RXdqaEswL0dzcGczcmlW?=
 =?utf-8?B?dnRvYTc0YUw1U0RmOTJxeHJ4SkE2L0I4bm5ud1M1dDMzSy9TV2cwMC8zNGdE?=
 =?utf-8?B?ZzB0WGMvZ1FnMjVETkFjd3NWV1BhNXExenFoKzFoK0JTa0NwMWM5NXZnRFJi?=
 =?utf-8?B?OTRWYnQvd3J6SlpIbG92TjE0Tk1kVGZWeUMyOVk3RUFoMVJrWHNZUWV4bUNQ?=
 =?utf-8?B?Wi9KbjdROExQVUVDcmNBa3ViVmJiVmo5cGZ0OFU1VG1zbHUvbGxhNjQvVTRn?=
 =?utf-8?B?SmpPdjBiTUhKWG5TcktheWErdlVBclRuQ1VnN2J3Rnp0TkQxQm01aHlDcjQy?=
 =?utf-8?B?TUJaYlNTd1ptZ0VtVXJINW5tRGFKb3BIeEhlV3c0andYeVdrMlo5MDk4UFhh?=
 =?utf-8?B?ZFNwU0RVQ3ZzT3p5VEMvMEZMVFRmNFVHc3hmSkc4S2ZtQXR0RFRzVTVvaDI0?=
 =?utf-8?B?dHcvQ0lacHl1enBaclB3ZUVlOW5yVkpURVF6S2c1QmhCb0dTL2hWL1hvZDRa?=
 =?utf-8?B?UlhZYjRrRGlXYkFFenJJeFg4ZDlLWm9TOWJKZGYxbVdNTlF6ZzAwM3pnNkpy?=
 =?utf-8?B?K0JIZFJ5T1ZJUGtWWlZBTXJLZnBVS1BSRG1jUW9JTWV5b2gxTmdxS2NOODc3?=
 =?utf-8?B?VnBtSWt3dDFOUFlEN3o2MHZ0Yk4wb0FxWjlyK3U4Nmw2bFlLaXRzV05xSlA5?=
 =?utf-8?B?MXlpQ2R0VXlsSFdPTmFiTStEVlQyTkRnZlRQa0FDMW0vMzhQSmx3YzJkdmE3?=
 =?utf-8?B?UjhqU0J1RzVxd2xhZ3FYNnlGcHE3ZVVZSDlTSDJCeFM1ZEhxYmlwZHBKWURP?=
 =?utf-8?B?TTFvRFZ1Q1RWY3FoZnFNUDFOMEg0cC85bXQ0dXJ4aHEyRjFlYUhTYmNWTGll?=
 =?utf-8?B?ajdPeFBBbG5QNTE5RDdCNk9hNFJoa2JVckw0dGM2YkxxR2Z2ejhwQUFTbVN5?=
 =?utf-8?B?OWtmUHRPZGpwalRPY3B5RUhLVVNncHpSd1MxZnArbGdDeGdybnBCNlVKVTJK?=
 =?utf-8?B?S29pcGJtc0JXS054Y0dRN0cyMkhoS0RqM1RDN3V4Z2JiMmJld3hYWnNiVFpC?=
 =?utf-8?B?di9TdlJKK1d0a1owU09YZE1YRHNKMHpUVURKUWpPek9JbFZnbncyYjh4NVRq?=
 =?utf-8?B?TW9tUjU3dkk5S2FiTUh2cGlMMStYb054RHU3SEdUTXlTdjdTQ2JUVGRyZFlU?=
 =?utf-8?B?aHhrU3ViejNBODRzVDM4VnpwT3k1SFcvWlZTZWJ3RklRcnNSYnQrckdXUWsx?=
 =?utf-8?B?eE90cmZTNmgrSWVmZjNJNEk0VlhySktJc2daUVpJSnZqZkZHRmVKRU8zVzJ2?=
 =?utf-8?B?SldwTE0rRGZBUnhVUnd1Z3U1aVBWTzZMVytjdWlQQy9GVHR1OEtJc2JkT25L?=
 =?utf-8?B?OTJueU5DVHdvaStGNTVUc1ExSWFOSHAyT00rZ003Y0JGZWlPdU9LcFlrak9r?=
 =?utf-8?B?UlVyZE1JVjZ5UHQyOStPTHJWMTJOREMvRUNjZ3lxdDI5SzIxWFpCb3dScVlj?=
 =?utf-8?B?QlhuMGtudjh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHZIcVArSiswTUtZbHo1WjBVcXBqWnpFcytVTWYxTXhhT2lXaXN3Mm5xS1hG?=
 =?utf-8?B?UHI1Yk8vVTBMWmVHU3YxNDhQRTVISUNaaXVTZFE2MFo4UDl4d1liOVRFSEQz?=
 =?utf-8?B?czlJS3pjK3g5UzMwTGJyTFBBc1JmNjJKS0FuUjdQK1JNTzdZdjhPSnBsbnFK?=
 =?utf-8?B?TnRXN1pjSnA2cTU2dUt6UERKU2NQTVZZMklaQTV3MWNrdS83d0tNMVBDWWYy?=
 =?utf-8?B?RkJtVDlreDAvYWIzd3BaNlVTaVJXaEJLaEowaHhaTlEwNDlNMUphdnE0M2hT?=
 =?utf-8?B?NFc1OVhqTlV4RnlaL29LSU1TL2R2YTN1bHJBWWE1ekZCQ2FRVzVqN1cvS3B3?=
 =?utf-8?B?SFg2ajZFaFIzdGtseEtPT0d6M1hNY3RlVElvVHg0bHlsd1lPZVJVZ2o2L210?=
 =?utf-8?B?Z1ZNN1ZJak1tTW9OT2MwUW52MTNtQXZERE8zdW04T29lWXY4NkR3TTZRU2c4?=
 =?utf-8?B?d3RMM3Nyb0hWMmQydFBTTzR5LzN2OFZrekR1SHZTb2V5WUZYWUdWa1dkOHpG?=
 =?utf-8?B?K241UCtzY3dWQWd1aFZqR1FpbnBaMFRhZm9qaWhqd3FNUGt5QjF1a3J6STFO?=
 =?utf-8?B?YVlnWk5uL2NtZFowdWRSMVlWM2xNSGhhbVl3WWFsbDVCOW1FN0xNS0g2Rkx1?=
 =?utf-8?B?Q05VWDZ6Y3JQMnlMbFlwVGRwQVRJR28wRk1BL1NIbVhoYWp6UjRGVG9hL0tI?=
 =?utf-8?B?WUkrc3E5U2xNNVJiRzBtd2tNV2VHa0FiRCt3L0I4cWZidy9Rdm5jNWFZcXVC?=
 =?utf-8?B?cFhwbXNxMmlIS0RWQ3JqTGVZT25pQUVMOW54VTJuRmtNWkhaRUJpaUdudy9v?=
 =?utf-8?B?WllKOHFNTyt3L1VzVTlhN25vTUhWcU9pbzBDRkpwaUw5N0JpcTh4RlZMUk1m?=
 =?utf-8?B?bkJ1YXE4bW9CVGw3K0MzdEhVaTVxcDJRMFhUdzRYUkptMlpxblNWcC9sc0lo?=
 =?utf-8?B?OFN3OTR3a0pvdENJYWZPS0ovY3lNOWhxRGpCTytqczhrT3RiTXZ6dUowOTZi?=
 =?utf-8?B?bEcwVENhWnlJeWl4MGlHNkZwaHZKNjkzalR4UG5RZkFEU3FjYnhqYVkyVkJh?=
 =?utf-8?B?cEdmQkExem82bC9ja044OXZaSklvdkZKQTBkNzdQdnZRY21xQjFFSmRRSWtI?=
 =?utf-8?B?Z1Z1MUJ2MGc3Z2FvaGpMNlZWRksxT0gyQVZ3K2cvUWtBay96SzEvMllLR2NQ?=
 =?utf-8?B?ck9ZRGJUOVhDc2F1akVaeXRialZid0g0RmVIbzFkS21LNFVvNm5UT3Roc2xE?=
 =?utf-8?B?NUE0Q1R0ZnlrS3Ivc1ZEZFFBYnBxd2plUThQdURHNHc3cDdwaUZGTmJsSkJu?=
 =?utf-8?B?SHRsOGt0NnpvcjBDU0NTOGRHenpjWE5FUlVOR2pCVDVsczVBNGFkMWNLekhK?=
 =?utf-8?B?cGkzY3F6eGVRZmF5QUN6eldNNlJzTEh2ajZYZUttVFN1bGUwUk10U0JydEJ0?=
 =?utf-8?B?Z3Rrd0dleDZGWStNam1jNjVJaFpMYnU1Z0crUk5jUzdHdC9WQSthU01jYVI5?=
 =?utf-8?B?dGpVUzZPUldHT3Uwbk5ubU5GSUdZRUVybFU5Skh3NUIrNGREWC9ZeFRza2Js?=
 =?utf-8?B?akNLdUlHdzd4MVB2bS8zQVR1c3ZpNW1lTUIrSVJxMWhYSExwQUFwSFpvNXRL?=
 =?utf-8?B?bFVSVDg0aTF5ODg4V0JJcVJyeHp0Wm82aHpzT0JrOXBKc1VtOU9wNjhTMEc1?=
 =?utf-8?B?dGRqTVc1YW1rVDF1NDN4MmdveHpJVzFPSE1yMFlaWk5ETW44RXpGenc4aG1J?=
 =?utf-8?B?V1A0TUFFbmZvMERLS0dLR2VqTEJXUlBJZFF3L2dra1BJQTRJMzFsTm9BRHNx?=
 =?utf-8?B?Q3ZwTTZNOXMycUdhd0djUlk3by8rNGZRL1U4Q2VlVDZjdDFBZ2diczdqTUVJ?=
 =?utf-8?B?cWpuR0lOWnFwS0NvQnpxRnBvWUw5RWxQSjBITStFZ2p0T0NEUHZqUXR1VjhN?=
 =?utf-8?B?aFZObE5zWGYzVHdTWWsyUjhINHdPVWxMYnJVTzNWUE9wdittRkh0OUY3TStC?=
 =?utf-8?B?VWF2ckdHTzdmL0lhZEhHQ1cvclJDS0NUOUdqRjM1em9vaG9WdDVTUmpvVitD?=
 =?utf-8?B?aEptbjFrdm5QM0JGdzZSRGduMFoxVmFncjF1M0FZWE9LM1U3Q2RxMVh0TVRH?=
 =?utf-8?Q?wgOyyBzykfudX6IPN6+s4vRmU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60faa16-d974-496f-92f6-08de0b23364a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:11:39.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1SiQVMwr43sfSaACOr3Jtq6KxFpyaBWH3HASBOU2dvogdAfRfGVzxhHgE7p6+/CReIbr095ChzpKtQXEJ/c8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF8FCE094C0

Hi Greg,

On 14/10/2025 14:09, Jon Hunter wrote:
> On Mon, 13 Oct 2025 16:42:53 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.156 release.
>> There are 196 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      119 tests:	118 pass, 1 fail
> 
> Linux version:	6.1.156-rc1-gb9f52894e35f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


A new kernel warning is observed for this update which is ...

  ERR KERN Early cacheinfo failed, ret = -22

Bisect is pointing to this commit ...

# first bad commit: [988121168f4a3211c7f5e561c24bb0bbe8504565] 
arch_topology: Build cacheinfo from primary CPU

Jon

-- 
nvpublic

