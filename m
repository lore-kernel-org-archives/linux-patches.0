Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39AA28A3ED
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 21:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751061004; cv=fail; b=bFAYs2FI4GmIo9+7Cqijt5ifoOL3hptjlx13UwQH1gR78U4VtxvMnRiM6PaiHidxNUBPnURkSrsLmUsCT3cJI9Mm9fgpRmPMxk4mPt/HZHbKpFBORd5cUsUF1q5qVa7hfYvI7g2dcj8lshx4xZ1MGGX6VilsVzos2cEVoUFJDkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751061004; c=relaxed/simple;
	bh=Kgbq82WwtsCJXc5tiSOiJgyJUzUhqIWCrQnB3Fr+VEs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oVUSxoeK6ZtPqT1wd6v9TUbRHTihOJ8Xfzx4O7BjjecyD/ceqxSZ0yQV0UJPq3RvAnh2dZXhSrCfwkTFcIzM/QZZm5DZVsZp1S/F8VloZBHgQtqv88plP0g/EWnTGPpgw9wkxz++VuJjTl9AxOLnRGdiczIOQZcwdWgsTbjeCy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hm1BFxPu; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hm1BFxPu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hm0Bp5xxIwHq0a457WqYMtV1jcXvsO99gA7jZwleaSp30XQYfoMVkAeMTKXreOCHRynE+4xAKH6xXhesKtvn8Jtep9+BvmxXXciRySB2v2lBbUCz9G+kh1ntBQMV2XmrZsZDPlO5nk5KTKtqV9c5b10Yv8vFaa141/0RFjY7NIh57yntc4zZqIz+ICtFc7UnSg5iSyuBH3g9QicwgAcJ7nkBHjYFFTxDlX1C2kXPljjDY5B84Oe5EpYWEaaA578zK/N4U1b/0TxlQKZEUtx/IFUHYSqSfTAzxXv5ZGshf3C9turddR/gLT2uqD8MehT1n5jBPtDYATtR9gdbgERVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wGYaIRTNkA6ljyVcWZoRkLBMpyULm4ijt7aJsKtSdbM=;
 b=tI27z4/Mw8q9VmQAsKwnRuUeKbDw+biLb/K6JrZljVmnd4povUkWoJNnCdXxhVVfm7qbMlnmwINtmYB0LhctMKbgw7HkvM/9BfR4w9NcQHA0dv503oklZgeBy0NRbkroZYvcdlvQ42Kw5CmWOaBMDm4xV5c71JbVzOfE3H2psgdgOSXny/gOUbz7q3prpSERxaJsPPn53hZMh9UiN8GlFRJy/wXKkiok5aV4k5vKt0d3v0fnO54jluGgkKbA53R7aJhP4w0iTi283pIP28FlMi8NWeESU0gdzjk45G/iu85FrbQwzwK/dVWvJYG6WNMn8jLmmou9yisAnEpE1DfTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wGYaIRTNkA6ljyVcWZoRkLBMpyULm4ijt7aJsKtSdbM=;
 b=hm1BFxPuHiY8YOQylUiYwtjC7CwNtgg1fKQd7SLDphcO74um8c/KtRXBd79nffzP7AWxRoNK7UHokMv+76Y3o8rGKrHoJ8H2RIWiTiCUUfF2oCGaxCVIm0vwu41llq/dSjPRvoesYvBJLiwAC4gcN06pg2NzhWl2uYx3OgN7hWhmGOKK5/s31L5YIU4WiWrqXx6bx/X79BlUDM6+cCtvA96M4JHlbs3ClZ6dyuu3QEScg6Lj6BAMsjcLVOs05yvF2/dP+5wb6f+83M23gc7x8I3ADNgAn6oC5eyjo0yda9fb+/RcTwO45yZJpYeRdV1p7Ej87IXnd+HDINL1Z5ZI2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 CH3PR12MB9100.namprd12.prod.outlook.com (2603:10b6:610:1a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Fri, 27 Jun
 2025 21:49:59 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8835.027; Fri, 27 Jun 2025
 21:49:59 +0000
Message-ID: <e93f23fb-b38e-4f6d-a801-dca5cc182b1b@nvidia.com>
Date: Fri, 27 Jun 2025 14:49:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/30] x86,fs/resctrl: Support binary fixed point event
 counters
To: Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>,
 Dave Martin <Dave.Martin@arm.com>,
 Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
 Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-15-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250626164941.106341-15-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|CH3PR12MB9100:EE_
X-MS-Office365-Filtering-Correlation-Id: ddaaacf9-9196-4d7f-a037-08ddb5c49009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVRGY1VBeTRnNGlUY2d4WWpnYXFJbUR6VWlJelVZVzZFellmTnQ0NnpvK2Rx?=
 =?utf-8?B?RmdnVkV4OFFlYnVWSDljeUNWOTNvSktjZmRQVGlQVXd0WCtCRlNWdnR4ZXV5?=
 =?utf-8?B?U3RHc2F0MTN4RDBxcklrZFYzekd2Y1pIcUN2TzdIZGFiY0c0YXdEN3VjME95?=
 =?utf-8?B?UFgya3RjVUhhU2ZFa1FYRG13L3o5Y3dPQnN6N24vZTdQQzJaRDMzajU0OWhz?=
 =?utf-8?B?ckRLR2MxWm5aNjZ1dlQ2aG92N3NDSVZRVElBbzg4akxQMEVsYUFNWGVFMi9h?=
 =?utf-8?B?SnVFSlZUWEN3US8yRjRtVFI2Z1liYVUyb0s5aDdkVW52c2doYVJSekhUWnNs?=
 =?utf-8?B?clJ2OUZqb3JHSnpEYXdzQm9xR1o3Njc1K2dOZHlPcGJORjhISFROMXhSTTFs?=
 =?utf-8?B?aVBXTWEvUjd1ZzE5cXFubDlPdEJZT3J4c0RPMy9qczQyUnFtSFFQMVpPTTM0?=
 =?utf-8?B?T3VESVIrYU9RQmV5SFJod0FjRjAwTGJPVGp6K1pUUDlvRGx0VnRhYmh2ME1j?=
 =?utf-8?B?UHc2RTFhNXpDVklhSktzSEJ4WXE1TnJOSWJmVjdpTlZwajk2azNaMzRBRkQ5?=
 =?utf-8?B?bHJJbkRQRGFETjBjaDBCVE5FcFdtamdXMDdwYmluNVpIbUtvbmxpTTZIaEtz?=
 =?utf-8?B?ZFJPY29mTEVnSkVPY1F4bTQwT3gydFd4QlBDcXVxSC8rQlpLSGdCc1FVOG04?=
 =?utf-8?B?MU1rbDdWSjBWNlEycFlmS2d5Z09Cd1NtaVBrb2MveUVWNUhJQzdLaXVFL2JS?=
 =?utf-8?B?Kyt6bExjVEEwdVlWL1ljdGZNVnFsTVVSdzR0L1BwTitZcUhZZ2cyQ1hSc1V4?=
 =?utf-8?B?cnNUMnJFK0MrT2N6dzU5Uk1CbVF0VGNFNWdkVHZFaEVGR3RUbzdUTHlIRXVk?=
 =?utf-8?B?TzQ3N3ZPY1F2ZlJMMzlMd2Z4VWJBdGx1UmVHYzM3ejdoQTNPalBmbUtiNkNh?=
 =?utf-8?B?Sk9Zb3BQQU5mMi9oTDY3QlhMYkRBR2lacWpBc1Q5YkxIR3hzbWxhdm96cTJF?=
 =?utf-8?B?WGxSZVBIQ3dOa3FWYlNXaFRkTEJaTHpjbFhSVmhHZit5aGZubEVrdDJTb1c4?=
 =?utf-8?B?V0dsdmNEUWxCZE5nZ0l4bVJod1I4ejhmQ3lPOG9TcUdOR2NCZ2NhcFd1L1lY?=
 =?utf-8?B?YjJweWFjT3h5RWJDc1FCU0xGa2dhNXRrSnBjU1JMcm9JWDk3ZmY5YmlBWE03?=
 =?utf-8?B?Sm05dXBoeFpUbFhuRitpc3BzTE4rYW9ZVlVoVHdiYW9nL1ZMazZWQ1VsN0li?=
 =?utf-8?B?NVhqZlRMSnlHT01JYjlOczZkU0hpZUVrT1JWTlpqOG45amZIMG5ubVJmNXRo?=
 =?utf-8?B?ZTRBR0t5UnExcFl1Sm9pZWkzdEhweXluclovWXBieUVuOEJTS1Y4ZGlaMnZh?=
 =?utf-8?B?OUdsSmtCSnRlaEJrd3VLdzR4bE1iQXp2M29IeXJUWmpPMHd6c3RNSExVVkxL?=
 =?utf-8?B?KzVjWmx2VWpuOTB0ZEVENlQrY2hiVWN5a1Y4L0RWdFd3a0dHU1VHSWE4MkRS?=
 =?utf-8?B?ek5SaW56Tkd0UXozS0VQbDcxQTNSUVRtWUZiYkp0ZzVKQmxhcGFwWDVqYUlO?=
 =?utf-8?B?b0R3SjV2bm9MaTBJaGQxN0ZhYjYwWTk0K29ScVJ1MVI5Y1plUHdWRTJlYitX?=
 =?utf-8?B?S1dXdm0wdm44eWNkTGlERUhxYlpCZDhYTjdOVXg5RktJMlJOZnpFOFBwSnA5?=
 =?utf-8?B?TFAraVBCRHlacGdHeXhGbHZlenlyZUh3d0d4alVEa3NEK2RDTk1GV0ZTTGFa?=
 =?utf-8?B?ZTRhME8xbmxWRm8rbWplK1ZjUklaNW1sd1V2YWd4K0pMbTF3MXF4TUx3cmdy?=
 =?utf-8?B?eVdibThyeXRVUXBDMFhmMkMzSTluaHFIekZEeklxMjU5OHREN1B1c3NOWnNT?=
 =?utf-8?B?V0ZjZU4vNTVNQXZSYWp6Smpsdnk0emlUajVRR3BxUFZtVVlSSzZBcW5qS21k?=
 =?utf-8?B?RTV5c2FLZnM4VnRqNkx0RU95Y2hXc1BOYmJGSVl4Zk9hU2x6cDdBUjIyVlZW?=
 =?utf-8?B?c3I4UENjdnNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHpWOGx1N3ZzeEhaMTRKbmQvNENWc1Z5aVBqRFVuZTg1dDBiRmVvS1Qvdk1M?=
 =?utf-8?B?Qlc5c3ZoMkJsTmZZU2loOG9SMDk4QUNYVEZ1VG5hcDNxVFlhcHlOY09HM0cv?=
 =?utf-8?B?TmdwK1ZJY1pnM0xZSUZzUUlPL0FXL29tZ054S0dudDNKTVIxamZxL01rbFF3?=
 =?utf-8?B?Q3J4TU1hZlZHMFQrMmxsZU1DR2FBSXk2QU9PV1JWMk9PS3EwZ240VlovbjFh?=
 =?utf-8?B?QVpyZ0lYRTJMQVppOFpWeUtnZ2ptUEVvZWhzeXZoQTdqeFYxdjBzeGR6NHF5?=
 =?utf-8?B?NytXZFY2azNsRmx6QXduZFJCYTRpUmx6aEJrQjZBQkpqbWpUOWNBRnpkRjBC?=
 =?utf-8?B?cU10WDIxZW45UTFGaVFoRVJiVHh1UFdHM3NxWnZIQk1lRWlHemE3eGtIVSs0?=
 =?utf-8?B?ZURIdU5aSEIvWi9JeklndDIxSXZqclU4TGtIUTdITGNHSkxaR0ZUTzRPbVhI?=
 =?utf-8?B?ZVIrNEFmZ3R3ZkZJc2lzeFU0RGNWV1lLR0tvM21RdExyUEIzeFE3SXNsb1ZX?=
 =?utf-8?B?a3V1SXhXVzFkRW9RSmlmYmFZZlRFanBSa1g5cWNZNDZuL0lLbGU2ZlNkUEFJ?=
 =?utf-8?B?aEhXdUpxY1hXRnI1WUtTOHh2S25va3Q1ZytNanV0dVd3YWpQUlhIY1dIWGd3?=
 =?utf-8?B?bW5PR0ZBSVpRSGZZcmhtUHMwUjVrVU1QWWN0UmNRdnlTMVFuMyt5dXhpaElk?=
 =?utf-8?B?THlrcHAwelo0d2VRcncwcEhUVU1rMWFmb3dudnYvWWRpajJrcCt1TGhDKzln?=
 =?utf-8?B?MUZlcWlxdVFMaTdBRlhXYWoyb2ZoNDIzNlRVU2s3UmFkMDNzcXFubVdFcXlL?=
 =?utf-8?B?NU9vKzhpMVdUcm9qMStGQzF5YUFBOVlzR1JQUU5VWU9tYkFKdTYzbUpkaGdh?=
 =?utf-8?B?Mjk5MXMvcUQ4WmtveGVwaXNnSTd3WExlTzB0V1p5TVNtL3B5blliMEE2d0ts?=
 =?utf-8?B?NWpURUtDeFJzVkZaVFk2V1NxT3hybWhNUkRpRGlBbDd4RUZreGdTMmMySVhy?=
 =?utf-8?B?SGd0aGl2ZkRnYWlUWlgzZnA2ZDJNK3dZR3ZyY0FzeEJpbmpYSlBRZlA1Y0dm?=
 =?utf-8?B?Tm81Qm5neHp1UzVlcnFMNWRpejk2VTdob0RxNjc1cDRzbS9tKzliNjM4dm5F?=
 =?utf-8?B?UDBGdVlvL0g1RW4rR2JKdTh4MlpsM1c1T3NCU3krN1pDYjdOR2MrSTJFY2VO?=
 =?utf-8?B?NEJ2bHc5NkdDaVl1TUhWaDNZR256VUY2T1RXYmMxRmNkMlFhRytwZ2JGMWhF?=
 =?utf-8?B?U09pd0ZUWE5oZ2YyYW95aktpd0w2bFZpbW1iUUJaOUVoOHZ3Q0RUM3F6Sm13?=
 =?utf-8?B?b0tzeCsxQmR1dnh0ckNWVkM3ZTN6NE5FdXUxTDRmdkorS0ptVDN5eGQ5OWVD?=
 =?utf-8?B?TG9ob29vS0JVNEp2WTJsREREQVc4ckR5UGthdzJkWFRjeHk1WVJ1cjVLcGpp?=
 =?utf-8?B?S0tHcy9McGdOWXoxM2w4TFlkTktDeXpEVlFQSmxQT044cnNXcC9Fb1dobkd5?=
 =?utf-8?B?MXlwQU1qQ24yTExOMjB0SWdVUWRqbzlla3FiOFFucUxxNWtDenM2aGkvT2Fn?=
 =?utf-8?B?cm1BL3FLUTJNejBGdTcrWDhBLzE0bzBSeWQ1d0hxQzdsVzN6cWthSGxQQXI2?=
 =?utf-8?B?WStLNnY5MHBCVEtzZE5GYm5RY3JpamNTMi9jT0RQclp1SnQ5KzhNWDEyUGRV?=
 =?utf-8?B?K0FWaXNETFJOUytSMUZZM3M2WnE2cjFodm1VNUxSSDJaZkd5aVpWRXZiUDRj?=
 =?utf-8?B?YjVIRHFpUWwyK21aR2xIN0puT0labHhvaXc1MEVPK2laTXl0MXh1WE5RSkVx?=
 =?utf-8?B?T285bmhQejRCaUw5Z3RBdHBrOUFCYVhmUVUxaFpKeWNGb2JVUDY0VlpoNEJ5?=
 =?utf-8?B?Z1FwdVovTmRhdDhaNHB2UFpjdHhaSzgvVmk5UGFqVlhZTEYzNmpkcGkrZjFk?=
 =?utf-8?B?cEhCSnlQeStoTFRMcC9UWVRCRFN1NDNEZUFmWEg0dmtDUU13c3R3ZDUra3do?=
 =?utf-8?B?MEd0dllVSjM3aE1vYkRPNXZ4WUk3dXFEZEpJZitGSXJTZ0dYS0N4alBTclI5?=
 =?utf-8?B?czVtWk9pQzFXNWo1eDdsOWlweDBnUjZLNzFvRmx0WElGc0FrTDMvR0FGMWpk?=
 =?utf-8?Q?7U4EnZTmvGk1t0GqicN9uUp3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaaacf9-9196-4d7f-a037-08ddb5c49009
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 21:49:59.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5kU/S+bghRXpDvv51w01mMc/odwrXfclQmMw66juTWWPdtio8i0TJNZTfJpnh/Tq3TV+k7tlILytq4p7wjs6cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9100

Hi, Tony,

On 6/26/25 09:49, Tony Luck wrote:
> Resctrl was written with the assumption that all monitor events can be
> displayed as unsigned decimal integers.
>
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
>
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.  The file system will
> only allow architecture to use floating point format on events that it
> marked with mon_evt::is_floating_point.
>
> Fixed point values are displayed with values rounded to an appropriate
> number of decimal places for the precision of the number of binary places
> provided. In general one extra decimal place is added for every three
> additional binary places. There are some exceptions for low precision
> binary values where exact representation is possible:
>
>    1 binary place is 0.0 or 0.5.			=> 1 decimal place
>    2 binary places is 0.0. 0.25, 0.5, 0.75	=> 2 decimal places

nit. s/0.0./0.0,/

[SNIP]

Thanks.

-Fenghua

