Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECBB1EF36C
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 08:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764835659; cv=fail; b=lor9XwSVFn2gl2HHtL+qUextKPkIRwA1kDwycigYB2FgddmmP2Ows0VpnuZvBLwCpg/MjQyuIedni0bCsAwWlqjBnVUWpBmqt+xf0lg1RBulNOop91fpQmPcwLvVwhdUkavUuQDeAkH24QSJn959RVstZqVDAY2T6p/EBDjGXsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764835659; c=relaxed/simple;
	bh=bpJepj1CaJ8itAlsK+WR5X6I7QQH9PUTvHdts0D62l8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Efaogv1PpW1R8x6LeZaizygpxQdGJuoe/7bRQJRgZNpODegrse7SOrP64a2i+K1Dpc3JEKcpAEK2t8NxmZ1DUBgPlsjyVE3NOSUWB2sMKqe7uuOANgtOdAvQYKXXwPNjveZQWtBsPTm1BrpGqVwgtgtUJVGjVbE3V5EMUpAMRko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u2FxjBB0; arc=fail smtp.client-ip=52.101.46.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u2FxjBB0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlIQwpVOilVmHqhZ8D/8sajt7a09YEJ6utJE4X01jJiltiGHpN9CyrazdLCnB64DyDCiqqSLtWArZyYP5Yreg0DeUefFk9OiL/9I3z8iZ5Yx+sv//4r6PH7rmgGDpCnp7rBOD7qIAzbwBLSks0k5ZCqSdxGfmZYLOSq3nHljgbvi4VHPXEY1GH75S8gfvF8GaTetmzmk0p3/H8m8i6hz83NAuIzLKFIgxqIX4Fws3LIx7ZvEty5gMt3HRH1brxpLnQ+c9itoO2bFUxWUKmeQjrggEz4izfWrJ7v2hnl46e2FfCYasFs4aTCBaqOAZOgWEUisCLyOvLJC3j5oRp16zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKsrJYEz+ANaUcp6aOCbxuH5+8R06ucVqqfPA2ILsdc=;
 b=UYLOc22QqgxxswhmU9oxnLCANjnARdPaGWU522SDp2/kZapxGHOTvv+KIUxRtDrPqePNZkTOFpJV9CYzgtL4mkbhPErEcGRRUXVqOjWSsndzTRw+actvo3ZXS2cObGIzQCwvHDnhWH2T21IIPZlN9PSaekokVoI3ORc6OmBF44J8L7B+rlVdzNCYkM/U5W08GuHbBcLM9fD7qwIGSyUwL4hFOxfFcpkq7DRVcjR7TtWABEPzbshGHOUD8GbCJx1ZbMD2ua1WoLSBYGxS739eZiMQWrgMpr+NlWdeaBMKE2CVNIhygFM9NPjk5bSpKv+ZxX8FN/JE3GSk+aBwjIDuaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKsrJYEz+ANaUcp6aOCbxuH5+8R06ucVqqfPA2ILsdc=;
 b=u2FxjBB0TboyW86vw6T6slWCgPKhIk37w/wxOhGIL8oXcbsbtmvsT97qAY9lS94UVpnsnIo7P/z2tkiEXxe3rm7ewGnZ+vCBc2Chty4nyHSSsBbhQKnkZ4XLraulpvQvhqy+u9dFY4ctvyV9tQTOq+Cd2nQ03O30tqwpx2Bi5EA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA4PR12MB9785.namprd12.prod.outlook.com (2603:10b6:208:55b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 08:07:36 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9388.003; Thu, 4 Dec 2025
 08:07:36 +0000
Message-ID: <0db8813c-f740-4890-8e29-f23ab232c393@amd.com>
Date: Thu, 4 Dec 2025 09:07:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Prike Liang <Prike.Liang@amd.com>, Alex Deucher <alexander.deucher@amd.com>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
 <2025120333-earpiece-dragonfly-457d@gregkh>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <2025120333-earpiece-dragonfly-457d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0390.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::15) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA4PR12MB9785:EE_
X-MS-Office365-Filtering-Correlation-Id: 698bb50b-1dd0-450a-26f0-08de330c2f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUFaODJ1M1ppUm5rVkJhTktTbzZKTWdVaVRzWHMvY3ZxMnNyaUVwaHMrcWw2?=
 =?utf-8?B?N2RvZFdVUHl0WlZxcENaL2V2dlJJS0FNQ2MrQ3BpNU5WZE5UUTFNSzhSRXhh?=
 =?utf-8?B?ZlYrRGYvdzR3eTAzVVpiSHJraFZaL3VoTWxIMXBGRmdQamtvdjkxUmNRVGpx?=
 =?utf-8?B?RGdDRzFoQ3M3Sk16ZnllTStzOTBPclN4Q21qSDlEcyttM2wxaGt4VGtiNVpl?=
 =?utf-8?B?Mk5sbUhwUVNDT1duMDlGY3F0cDFHSklVY01uWElyeFBUZTYzbUlGTlluOXk1?=
 =?utf-8?B?YWl3amFLRGNwZ0twM2MvQWl5eXZ3SFBHVjRqNk5UbEkxSVJhajVIMjhzanR4?=
 =?utf-8?B?SE53RlVoVmpCQVZ0L2ZUSkRCTTJjTGUxMlJjenVmUldRR3JIUndzYVRZOWVP?=
 =?utf-8?B?T3ZBcERORzdYMEVJMFNTUnkrYUtLS00raExvWitySDNPcEgwVDMzWXRwbzA1?=
 =?utf-8?B?b2tTaVB4V3VBQ0hncy9HMlczaVQxYnlzUnJUWTlJTEdpNW1WaktmNEo3cG1o?=
 =?utf-8?B?enFMb0RrU1JzVWo0QXVvYkUvZDhTRzk0WGl2c2p6emVRSVoxbkhab3JGVFNC?=
 =?utf-8?B?NXhBR3Yxa3NTWUl4bFYxZnlTMEp0K0k1QVkxTmNiSWJHK3FpeVR5NEJOVm5S?=
 =?utf-8?B?SW5tR0RFbmN1WFFHUnV4SlFMamhvejVQemp6d2F0LzBwTlNKYlhpMy8rMGRZ?=
 =?utf-8?B?WVh4M0ROZTNpUk9iRDk0WVI4VGdSZ2NNSnorMjNzTHVaUWRxYXgweXVFbUlh?=
 =?utf-8?B?aWVRR0xOdUo3OTB1RThJcFJyaktMYzh5TzZ6TWR2ODE5Q08va3VJT2hsSDZU?=
 =?utf-8?B?clU2M2xHNzN4dmhxZGN3QWk3cTZ4UmYyUkhkKzlwOTUzT2l1Z1B2MVgwY3lk?=
 =?utf-8?B?Ylk1ZFJPNFlKZmZEdjhCUGdrWkRDT0xFd2hzcEw2QkczdWNGMWZFaUZ0SENP?=
 =?utf-8?B?YWc1a1NRRlZETjJVY045NVhLbFl0dWVZd1dSbXVNYmpiTkwxNmJFcVJzaTlS?=
 =?utf-8?B?S0k1K29VcDJiQThMSHU0YTJUZUgrZU5NTExNRnNUZ2pyTkFodjdZOStiMlJS?=
 =?utf-8?B?c0NuWkVxWWF2dFFnNC9UVlQ0QWFTZ2lFY2RTZGcxcmZaSkZVNy9tcDFRM0Vh?=
 =?utf-8?B?cVpBRVZNQ3BiVEhqbS9DQit3S1FsYStmZ01oRzVXNFdKQk5OUE9yUlNES2RZ?=
 =?utf-8?B?UThydFlRb1BIVGtmR0ozOGcxM0k0NHVJQXlwSkNQdnZZNG1ZNks0RjBqODM5?=
 =?utf-8?B?THZDUGMwZS9mYmUwdzU4UmhTMEswRDdVUkgwT28xTXdNZiszQksyS3REdG8z?=
 =?utf-8?B?SzlSWGJENTljdmZkWkxQaDB2dTIyUGZHT3R6dzJiZFVFQ0M3NlhUa0ZaemlK?=
 =?utf-8?B?QnVsajNJYkd2cE9zYUtlYk4rWFhGZWJpTjR5bVplYVFLRGRGTmM0OGVyNndy?=
 =?utf-8?B?b3o2aDllck9hbStuTFh4NkRacHE5WGpBN3ZqTEhkWUhDMnJoeG9Dendjc0dk?=
 =?utf-8?B?eElYcEx1bHE1OWplUHJpODV0L2c2aUxUZEZiblpGRmZmazUxeDFhck90Y1lk?=
 =?utf-8?B?SXVOZGRJWXYzMFpidncvczlaNkhVREVzS3BkekkyS29MQ25UZDBYRW5nL0R3?=
 =?utf-8?B?S29DdVF4dDYralZ2L094Q0RKRXVuM2hZTG9ldWNVaTU2aVhrRzh0bThrWThh?=
 =?utf-8?B?aHlFOVBpL1dBdGtGdndBRllGYzM1OStQajlhU2orTDg3MmVFOVFYVTZoOVps?=
 =?utf-8?B?cVp4OW1pTFdTMWJHYzZYRkNkb21DYzk3SkNWQ09mYmlXRm1BM1ZSZEo4MENH?=
 =?utf-8?B?dlZCdFN0Q2wzZ0xZYjRhRVE0MXdxdnBtRjZIbmNjYWlCSmpJZS94S1ZNWXBw?=
 =?utf-8?B?eTVNc1JBM1RVZHVSU00raXFQdk1Kd1NZd3dxMWNPQVR3Z1A5alVzOWFBbWhG?=
 =?utf-8?Q?TWq4CwVIy5pPJj31F6fNB3s5eNYcFmHO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTcyb2FPWmtuNWJaV0FFWm5HNmRCL0lRMElMZUdGOVVBSnBjYk1MdGpUb3N5?=
 =?utf-8?B?SStZRk4yNVhKeU9jTm91SDk0OCtiaGFYVDF1YklwOHhpRzRBdVYxRjY3bzhq?=
 =?utf-8?B?NFpxMU0wTXBMMVk1SEg3SWw4WjlyV29MekV0V2ZxK3RDNWh5N0RXd3FZdEQ5?=
 =?utf-8?B?Wk8yUCs1ek9hWFlHRXNXS2R3SGdSU1gvVFdtTlEwd0dpcElMcDhoTXhPWnFz?=
 =?utf-8?B?NHlYL2p3M3RnWXB4Rjd0VmVvWWhGVHUzV1R5VUNRbmNINDc2R2lXSDkwbFpN?=
 =?utf-8?B?VGI4djhJbW9qdnZNTytXNkxndU4ySmZhdVRhVVpJR3k2WnlTRUJ6WlBIK1l5?=
 =?utf-8?B?NC94RlZPcjlpUyt4QTgyZ1BFZVF5UDJsL1VNMlNPTEl6cmRZQkxIdldzQUti?=
 =?utf-8?B?SGRGZm50ZkpIdUR6d1FoOEJFenlSWGFFS2cyU1hUenRXWDJOS2VTdFJ4NDZl?=
 =?utf-8?B?clFNMUx3dGFFS0FwRXFuRmhwL01SZHJsNy9pUXJPTTcvN1EyZ3d4UXA3T0kz?=
 =?utf-8?B?RjgyTi9Sb3FSMVZ1M1NUeDQrd1ZnTWtHRVZ1Z1Q3TTFKbXBRT3h6ZSthZHNz?=
 =?utf-8?B?MzZ4ZVZ0RDhHay9RTUtRU0hkODNvRi91ZklJQXcyYTZxTjRPNlROL1RhcGtS?=
 =?utf-8?B?QXUrZ3lDWVJyOWcxaGZlc3dDKzlEdkJQNG9zZXRyTDc5NzQ5SmI3MDZ4alNM?=
 =?utf-8?B?MEVqR2VMYUZ6RFJZU0JsQzdWdmRhVGxJSmtRazVHSlF3SUFUcnp4ZkJWZ1hS?=
 =?utf-8?B?S240VGJwQVdpcmF5WlZuMHRyb0xRQnkxNVZNNWNaTXJHUloyN25wWUU4TER1?=
 =?utf-8?B?eTdnV2NvY3ZwbC91Wno5Qi9IVis1SkErTDRxa0tCSmlZK29HcjlxS20xVm1H?=
 =?utf-8?B?c1R5SGNmRktSRFZsdlk1OFpmcFFWZXBPVFUvNmNNUnZPSmxhWHU3dEQybVMz?=
 =?utf-8?B?Z1ViODd0bms3RUxHblVuNXlKazRncWhGQVNJWnVDSDltM0phZEV5Q1RqQWpr?=
 =?utf-8?B?a3d5VVdpaGpudEVSbUIvaFpOMytVZE1sL2NKZFlRa1U5c2k1UkFibGZBZkNw?=
 =?utf-8?B?VDhhWFNyd2MyTDZlVDh1VlJNbzdxVXRuYndicmNTOWlNS2pDVm9KWHZEK1Ey?=
 =?utf-8?B?dzhZaUQ4VzVmUXArYmFmdzZJQjBRRWV3dzJUYUZtc1ExaDFaZlhJcW9yekMv?=
 =?utf-8?B?YTgzUDdHTzUwVHdkSUJaSWlWZEtuSGwrdGZNUzJmbEQ0aEltSldpWHNSVzF0?=
 =?utf-8?B?UkZLQVA4SXpndXFic2dYb0NJRFJQcWZFNkx2S3MxVUEwZTdKNk9rbFFuNmlq?=
 =?utf-8?B?Mkg1a1JadEo5N1V5OHJGQkM3eHRsZktOQmIxOUZCQmttdzFYWGtIV2RwUnh6?=
 =?utf-8?B?bUhJRHJZcmNyWHZ0djAyNzBXSkthN0MxWVhZWk9CQ1EzdloyWHlUeFdKODlt?=
 =?utf-8?B?NlVmb3Y1dktpQzNJRjZZZWVBRmNFQURmN1g3SnFZT2pxRVVWMDV5cXF4UGxr?=
 =?utf-8?B?eGMrdTV0YkNPSDljZG9DWklQNittL1paaHViUFNnQjJlbGVHM2t5Q3g0QUpi?=
 =?utf-8?B?djhHcGlKR3dMQWxUZDBINUIxZExpRXNNYnNzbG5qNytnRi9KajB1UlVlQ1VM?=
 =?utf-8?B?ZVYvWE5jRDZDNXNtNEkvQUNzVFk0MXYzcVVSb2wrT0lxdVNxcHkwNnRxc1po?=
 =?utf-8?B?Zmg3WTBNZFpCT3prNTNYa0RxWEgwRSs0eDhiYTdraVhTZWk1dXN6TDU3ZTlr?=
 =?utf-8?B?N2xuQTlkbDRtYktGK1VQZlVIYkxTYVFyalpYME92ZmRINko0akNIajQ0dFRN?=
 =?utf-8?B?bFBuTmhCckR5UDhxbW0yT3JDUFBCZ0pkQ1ZYdXo0b1c2Rzg2d3dLOG1ZNkNk?=
 =?utf-8?B?eDd3Y21JaGNPOVRTT2JyK0E1enl1dUZLMWtBamdaWUwyU3lCQ013a3JRbjJK?=
 =?utf-8?B?OWNyZ0d4ZTJBOW43MGZtdy9ZVC9hK3piQTV1dE50T3pWVmFSblhIWnF2Z1J4?=
 =?utf-8?B?TTMyWmN4TEVtOUxBWXcrVExPc2lTaC92bzEzTEhVdlZJU2FpLzlHUU5xRXhG?=
 =?utf-8?B?Z3lwVDM2ajlSVTNrMmNrK1o1R0d5OFliR2lzQ2JGZGpQOWM5OUtrV2JndUpi?=
 =?utf-8?Q?mzFLCEXXRnzze2FUCkHUXPfR0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698bb50b-1dd0-450a-26f0-08de330c2f19
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 08:07:35.9032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XMp3m0qDgRlZ3ekFafP73JAwgAkB8s6I6+qO6cPjv2eLFOyvs3jr1yRWu3OWeYk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9785

On 12/3/25 17:24, Greg Kroah-Hartman wrote:
> On Wed, Dec 03, 2025 at 05:03:11PM +0100, Christian König wrote:
>> Oh, wait a second, that one should clearly *not* be backported!
> 
> Why not, it was explictly asked to be backported:
> 
>>> Cc: stable@vger.kernel.org
> 
> Did someone add this incorrectly?

Yes, most likely.

The patch should be backported to 6.17, but not older kernels.

Regards,
Christian.

> 
> confused,
> 
> greg k-h

