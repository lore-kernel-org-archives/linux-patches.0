Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2078.outbound.protection.outlook.com [40.107.100.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A462C1EB3D;
	Wed, 28 Aug 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724853064; cv=fail; b=TnrFYvKJgDJAmyHALwzSrH6KcOKMk7U8y1OQFFnysoz3rs2iSJoa37rlSxLzPPSU222P3qMYFlEpGI7913MFgC/z9o5hwxdDaBcMfbvaBLCcysRvoC4MmXSaRbZBkrnNXuNkNr63AYS89hJnfaCWg+H/0LWUs32XRiNvmLuosu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724853064; c=relaxed/simple;
	bh=UNHRBnpqfgXDo7dqIg/X0f7MFkeIFbl7vrNnyvz4r5I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d1IcCD/2tOH8ErhQ4wcyh5ma1jaYFPznAtK9LTxMjY0y85IP/r4gO037d9e3geyngQ7GIHOIxoDTX/hofLH0EcNlVrIq5qwwarSvk+ZmD3CB8RJV+7zHJKvxrBmc5J3M9TpZYyyA+VHbKqNQkW1br+p2RX4hjEYAaPCa4syDY4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3HwU2O0n; arc=fail smtp.client-ip=40.107.100.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3HwU2O0n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SiBSRnrBaydHG4e91NyCbuIHZuyFyLWseEd65m9vSvk9EV00Wgul8iYxmdQ7lTo38yhfDLwkCQ34w8zcsn0SvVppCf4RoBFrnTPHjcJbXkeWXmuM2W1WmLaKMYEZwCU/PgnTYpSiJ2ycfsN6j9rvfbmrDkGMTLnzPLXvKyyQcKTonoNJQpwnTedE87QEjzdtLd3uXBRN48AuLBSXHUbrrvpUMZOoFakiwmPaistOnWX0r897kB2MoUAjA323GGNmEXLwQbl6qrzyF+REc3LUuUQSeD0N7qzYYo0tiMxfOLhRkqa6DULb8FJ09lrxDqE5Nyj+U56fM5vEjJb0AXjWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X980+lHJp7VvDYSpbgv2i7nWWDQV95d/9DRqQxjXGaw=;
 b=gbt6mHFNfHU6QFdMP86xFPsYj4i3rXfVXKSe6K67w/qQMpexf6yFPVgprHKe5EyT/JbEXQGLQ0xneGj3WvRESlgl1Kr3Jzpqlxd/+yFIg/XRMuLpDtdcf+tJmCPt27ActMBzT9OuaP4q9FrWC/58EwkA+sXqc9YeGwMQzHDenPfK6oNF8YgcDGHCS9opgfHKMZI9GrtD+IEKnK4qL2BJYrsvhx7Qn3hARN5CkgKS8Pes2tEYN6YmuQ6W1jtIspDiZQ0Fzg18v8KEpZEpenEOZ+0GOvmh460UeVVTLeaxJXzKiCuCys+/S5pr2MLRFVE3e4HR2mL+0chO4b8lep+UgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X980+lHJp7VvDYSpbgv2i7nWWDQV95d/9DRqQxjXGaw=;
 b=3HwU2O0np5JhIbVH+z9QzuHc3MN54piNS/ODWkgARzOLXY/I0mMnKVUvHGrK69wOmOtHBBUCwvs+atHutE7HcuGmnyKcjkRTqVIPXf9nJiswrWwPVX1E2BZlA5OSxzyWru2W3cdJeUvtaR7yXYc0pyh1IoIx0GHuBiX8a9uhi8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BY1PR12MB8448.namprd12.prod.outlook.com (2603:10b6:a03:534::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 13:50:59 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 13:50:59 +0000
Message-ID: <e9c76953-5fed-4233-92d4-825c84706d83@amd.com>
Date: Wed, 28 Aug 2024 19:20:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] iommu/amd: Correct the reported page sizes from the
 V1 table
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>, Joerg Roedel <jroedel@suse.de>,
 patches@lists.linux.dev
References: <13-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <13-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BY1PR12MB8448:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cfafb1-1ec7-4cd0-5931-08dcc7687261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTZtYTFkYzVuWDBXMlBvVGdML0c1VUdxc2ZqanQ0b2c3T1hKSmlIUG1MMUxh?=
 =?utf-8?B?Y0hjQzZkVHFZSHM0d1N6RWFBRmxFRGtMZnZhWHZhZU9FYXphMHVmcnliRk92?=
 =?utf-8?B?NXhVU0hkZ3kwMjJld0VlRlpQYnpQY1hFU1FWK0czQTdGTjBvZUdYMFUvZDdL?=
 =?utf-8?B?RS9wK3RLK1J6VG9PYU1vaE5YZmFPUWZLdzdveEZxeWFBVERzVUhRSFlZdis2?=
 =?utf-8?B?ZmpRemRjYVV3NTduM0ZKbUJuTGFFQi9LaGhKQ09QWndUeWwyTGtEUFZWK3ZO?=
 =?utf-8?B?b3RuRTljRWZMblltS3JsSUczWDRuM1VtdC9MazBveWlkZTQ5SVIySzRaazZs?=
 =?utf-8?B?QUk0bXZoNmVDOWRrbU5IbWZZaHVTQVVWR3d2dUNDbk1kMU5Vam1MMi94SXRS?=
 =?utf-8?B?VVBmN1FBL1VaaTFITHVuWXQwdCtFN0ltWkZBUXZkVUFnREsyZ1J0UkQvNG9X?=
 =?utf-8?B?S3V2b2JsbWs4Q2IycittZU9GSlhEREVOQ2I1bmtqcjU3YmxGVzBRTmpyZ2tx?=
 =?utf-8?B?cjg4UDFsbE80RHpBM2pJREE4U0RCdjJJRVNOVDBOUE5ieVM3NWdCU3NZS25z?=
 =?utf-8?B?UEE3ZnMyYmZCVWdOVGllRUhaS2VydU5mOVA1VVY1R1NpR2xmc05oZml0bytS?=
 =?utf-8?B?UDNkNWFuakJZVG9VaVd6L3B1V2dDYmkvYWlYMWlhSFFaMW1nZjc2TGlMaFJE?=
 =?utf-8?B?Ry9lZFJXa0tmZDcrYmM2Y1Z4MnhBTUJQVzBya3puWC84T0FJVXgyMnl3ci9P?=
 =?utf-8?B?ZStoRWVMUzJBNkUxUFNUNEFQM3ZPQTJpQlgxRHcvWGdHbHBQekNiQmhnZGNw?=
 =?utf-8?B?T0VFNm9YVk1NTVFPbDNaWUd6dEhvWlZkYTVMb09PWFN2VXgrVkRRUjdBQ1RG?=
 =?utf-8?B?bEs1NGNCQ3ZIMDd6U056RUZCRzdIalVpTlpUeWVFSWV1dTA5Ujd5N2E2UGI2?=
 =?utf-8?B?aXE4S3N1NVdXRDhEK0pLU2s4L01SLzg4MHgvYWV0MFZrbnQyN0JDNDBEQUtV?=
 =?utf-8?B?Z1BPRmRxUjZYRDRLVjh4NzVFeitNZFJxdFg5V0lJRjlzbmJoelZ0YzZ5VERY?=
 =?utf-8?B?a0w0dDRKRmtLTkFQWWVpbksrdW16SC80TmtFWDV0d0lLWmtWZzR4NmhUYVd1?=
 =?utf-8?B?YzBvZ3lrMjQ2cXV2Y241VmFQOUMwenFCMnBSRE5SNDdFNDFrMFVsZ2JtNzdG?=
 =?utf-8?B?Y3V0WVFtZWZiZ2pZS2YxTXh6OGQrVlcwbFptVU9kd21DcjhuZFZXUWtXZU8r?=
 =?utf-8?B?YWRuM08vY2R1TjhDUnFJSURHZDk2bVpvbmdKZ2lBemhpMnZpMGMxRFRPcXFk?=
 =?utf-8?B?RHJPeWtLaWx5MTZuNUh2TVhiVlpLU2lDcUgyQks0SmJsOTRwcDZETjBiZkMx?=
 =?utf-8?B?TEtvU0xGYmdWMDkrdE51WWhqQm9Fd0lrSmEyODZQWjFPVVRpK2ZSYnpBTzR5?=
 =?utf-8?B?U2tlQ1JPbjE5Vnh1a2tzY0tDcFJUb1NjMzZlQkZmZ1VSZHo2d2JUNjFZcmVK?=
 =?utf-8?B?TElzK3NyU0t3UGtZUmxQRDFMK1E1TFpscXpNYVZLOGVPaTZ6dXFWbUIwazJI?=
 =?utf-8?B?S2U0QUZaUXFvK2preXdydFJKaFpDeU5Da2paK1BVMkp0ZG9NaUJjWHNEYXpr?=
 =?utf-8?B?VTFjZXJxak1UZkVuRDdqMWl2NTdjNFJFNWhkV0E4cHI5WU5LcFF0dHlVYTda?=
 =?utf-8?B?K0Y2SnZHZzhSVCttME5ZM1h1Y2VvNU94dUp6RERaRUFFYS9RL3NURzRWLzJr?=
 =?utf-8?B?UUZrRWxhMlNNMkRJMWxGYjd1Q1NYTW5ZUDhtYkFkMWRoV1ZXN3dnQzNqVzdS?=
 =?utf-8?B?OGt5Y3lGUU02bi95ekhaZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTFCcU12SWlqWWVFSFVXSVBVNFM1cjhPL1VvRjN6VGthenozSm1MKzZvMkNj?=
 =?utf-8?B?enErV3pZUjJFVXBwWW9Dd1dJUXZiODFVOFpUeGRWOWxWZC9wNkRqMGo5eWdX?=
 =?utf-8?B?T3ZpZmdxTGRSM2dqWVVJc05QS2hjQTVLMFdySlR0Sy9zMVJiV0czTk12N0VT?=
 =?utf-8?B?K3U1b050dEVPREpKbm5KSUhBOEY2VGdnNVNpQUNBQmlmaWpVS3g2TjVmb25u?=
 =?utf-8?B?anQ5YUZyQUNEcG1NTHZUOTFqZHA5VXplYU4yVUsrSFFGdis5TFpJdnFjUHVU?=
 =?utf-8?B?S3VoOHpZajE5VklFTjZ4c01tRFhMSUMyNkJtYVlwb1dLQ1E4OC9ucnhyUEh2?=
 =?utf-8?B?bkVBTjdFK0RkVnQ4aTd2U2FuWVpMSGJ4SUpla3ZTeWxnN2M3N0NTbTlwRWsz?=
 =?utf-8?B?UTlNMGNGZFQxM3lYbDlWL0ZEMWQ3eUsvQVM4WFJ0SXFJbFFIQjlEdnMxY0hm?=
 =?utf-8?B?QnRLdlBONWpnMkNDd3RWbjN1UVdQeHdvNUMvaEI2ZVVDNzVpVHkreHNHSyti?=
 =?utf-8?B?VlVBS2l3SGREV2F4L3hRTEhwTXNSMlZnemY3djh1RWd3U29HTWVaTmFMT2hx?=
 =?utf-8?B?TmNiaFdvTjVEK1dwWUdsYjNBRnZGQlVqOTJ1K1FneFR5SkdxK3dJRzY4Vk5K?=
 =?utf-8?B?SWpTazM4bXpIQlZMV21lUFcyZkFjOVhSVlZjWkNsdE5DTmRmcHR4TUs3b2gw?=
 =?utf-8?B?NGFxM00zcnFzL3JoU2pHLzRramw5ZEVNR1BKQmR5c0lqdUpPdmd3dWNWUVdi?=
 =?utf-8?B?TTBTdVZHZ0VQYkNmS1JoZmswcTlibm1lcEdVbHQ3eWIzYTBMcTNuSkpJQnZH?=
 =?utf-8?B?V0J1TTlFMG9Pbk81cVFSTGFrOHpQMHBDemNXN1dCbU9OeTlnNlhQeXloTTNP?=
 =?utf-8?B?UDFnS1N0Zkk2ZnAzdFFwdjlIaHpNdlcvUmNTMnFUMGQwUDlMZ29renhEc2tt?=
 =?utf-8?B?NmVWYytneUZ2NWw5VHhUazBkNktKZ3N5ZG9TeU5VbmZPVHlxUXliYW5yeC9H?=
 =?utf-8?B?eWhNaGo3Tlk1K09ZU2JCZ0crYkFWQnVXbnpodVZ6a0RsVGFYTkRiU21jY3Ri?=
 =?utf-8?B?V0YwTFJXbUF4Nmh5SUFzYUt3RjhRakI4RHhONEFrQjA2VWhCR05vSjZkRENT?=
 =?utf-8?B?Zll4YTAyRkdtaFhPNW42UUpReTZRbm1yK2IvZDh1WTh0UHVyT3liSmpOS2dR?=
 =?utf-8?B?Z3YwaGk4N0pOSU0vQ00yTUpuUG11QmJramhVUG8xZHdlMUNOcjhyN2RTVHZC?=
 =?utf-8?B?MHBTR1hHS01wTlpiQkdlUmJHYUNTaEFtVGM1L3JHZzM5QWVwZ3B5Z1JFWU00?=
 =?utf-8?B?c3BtV09EMHBjM3phekVDVkdySlFYRFE0Y3dCSjhNRC95TE96V00zYVdaVjV5?=
 =?utf-8?B?Q1BxUWZyZVhRWnlhallMVURuVkVKK0FvS3ovTGlXenhsWDNTbENMeDFyM3hV?=
 =?utf-8?B?eHNaRnVEQWhIVUdSM25IS3lRdTc1WHQvZFFyV2Y5cTBsM3ppZHpiaG5DY1dX?=
 =?utf-8?B?YVpSZlBlQ1FoVzgxR0tZK1cxakV5SmJmdFpLZFg3MGlPTHdLMlN3ZDl6K1Jl?=
 =?utf-8?B?eUtxWFVoaTFlT3liTUJHWU8xS1gwQmF0V1RpRlNnRU9VNGJ1ZG9qN3V6bFpD?=
 =?utf-8?B?c1dibUJkOFZ0MTVlbmk5L0VsMVNiQzY0RW5CeWdjVTNPaWFiS2MzaTRleTJh?=
 =?utf-8?B?T3RXajZ0MkJyVEtTR3ozZG0ydWdTbFVhbWhJQ3d4VnN1SjZrOGx5TW8zUm8z?=
 =?utf-8?B?NnZkV3BwTjh4Skh6OWpEQmZhNDRjUFRPV3hRRzRab0VrOGpycFg0TEU5V1hX?=
 =?utf-8?B?S05NTzFpendsakZSTU1CYnpwNDgrVUpqM2lBYVVISDhYUDB2dlZpUktrMnVq?=
 =?utf-8?B?ek1JbWg4TVAzd0tlR0IweGdSbnBnbHpNZVdyREo2aXFtS0pzRFRkblU5VThp?=
 =?utf-8?B?Y0dqZXdTRUIwc2QzQWJ2TEhlVllaZjJrZnRMQ05MQmRhdUllNWJ1WVJQczhN?=
 =?utf-8?B?RHZTZzdXT0M4RFdISTB0blJyU3ZYTW83UDBVOGdqREQxank5SWdMZS9lV2pq?=
 =?utf-8?B?RVdjK2ZUOTFSYm80RGdnZHR3UWVPRklKZVJWTVYrOURRVUJROWpCcXhZME1p?=
 =?utf-8?Q?GaSvZFpvpdjBf3jIBpZk1t0z6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cfafb1-1ec7-4cd0-5931-08dcc7687261
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 13:50:59.2435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lQ7Yn2eaiQVkBBfMyTDI5c6+UsE/wdgCg2tjXvwCEw48tIgGiT+PKDgEca/i72TGXCmCpQCjmoAnVYR1CxNuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8448



On 8/21/2024 11:07 PM, Jason Gunthorpe wrote:
> The HW only has 52 bits of physical address support, the supported page
> sizes should not have bits set beyond this. Further the spec says that the
> 6th level does not support any "default page size for translation entries"
> meaning leafs in the 6th level are not allowed too.
> 
> Rework the definition to use GENMASK to build the range of supported pages
> from the top of physical to 4k.
> 
> Nothing ever uses such large pages, so this is a cosmetic/documentation
> improvement only.
> 
> Reported-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant
