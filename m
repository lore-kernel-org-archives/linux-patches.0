Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589AF1632F0
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687642; cv=fail; b=ldphaOC9bNXnun2rjjLX5HOoij4tKFzYVDsmpX8o+PiY8vx4YS0cuR0ezYpzcGlw50WTxHl7n6msE9K+Zxx78e90HFG/y30FFjfZ9dmET+KxgVpH9JYIkNsaJzW7eIzXRcIBuf5q0qJjOramj2A7OmCO8ncWoXw5mMAUstNGyaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687642; c=relaxed/simple;
	bh=hIRkWAEUBGKv0b/sii9F0L/OeaQtBZMkA8mHiiIltI4=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=svdOoEaSWim7SZkSwKCXdL7iL03O0VjQp2aLQH0we/s8PX6hEMelURh5mpdfHTvtYAkJikEvkjOq9xqN4MNC/WbTaPEqi6T9IagpheCPQEaPkW1iI+m8UcEBsZDq8NgCDbUTArMj/HSbOgrQvnbLAK+Z78BjxnrPFZjhrYKI4Xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TwsQQhxN; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TwsQQhxN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkgnqNUKRWn5WZ0nr8usW/V0NRukjTTWQ+XBtAmL6OXJIAo/YtCJekJIAcIbLb/lJY8xoxlCQQ0k9WzRfxG0/7AkjnWrh40kOl3hUXy1dL3Fl+LIEk331azcxKHglOuRZjFpQ6iFWFLzh+1J4Ft9j+nqhnKrH6S88I0X2p/wofkWqciGL4sJnsUu/2ZoV6HVGdBXIGOOku5hgMU7M7JF9OjE4N5FHwmMqXdZt9qhJsC+eeO0qVKXNzhkfIv9hR3FBrE/PzJdo1QzP3xep9jSp6kUI07wtDuwVIVMBtbLNWGj1zBeVXydNHtuDFcHzmNfhtIEl6haGyKdJwLPWmheAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kr50/SRBtROV8q+Wr8TAkZT+sluTHiLg6kfGlBJsrEM=;
 b=hkLz2mcQQ1FjHERohuVCMxcwt4Tt+dE4TYhQuNWvvTi6OZPt1y0N7C21HVWJYaEp94qgmDoej9bYaSld4sHfnGrrSbPgHg52jc3LXLmzTOYWYz3vHoTmHaAK4YL5wkrCVtuqgBhCuk3T6ryzRmZszBNNy5Bt3DwEB4/PtU58FRSpRm4Cx35Gn/+6hx+5mO3yiNcm8Y7qEgwcq3P+lNNKvNLWAJSPJzCo4ZcbV+RBNs0LUedG/00rCtIGs6aEPy6B7/nc6FPNBqV6ENxivsdUiLjbMnNc9+IXUg/0waLk3va+JEPjcIN/BQqhsrOdq48WN97StkKA2KoX/hd8/L40Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kr50/SRBtROV8q+Wr8TAkZT+sluTHiLg6kfGlBJsrEM=;
 b=TwsQQhxNTvEJ0x8CdEIAqIqpYS3MSwVD35NWETb2nUVH1yvR6KU7NTjbb17uPs8xWGQBRH7g0nRmFxHBKuoGTnrQipoVS4RwEXXfxbp9djuT6u5IcxwZLRkWCrba65Ftn6jilJ/YOnrS+Fd+Js2LcgPmDmpUymoEq8BvIKK0knI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 16:20:37 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:20:36 +0000
Message-ID: <8b040e1a-2af8-9d9f-4697-dee96eb65b00@amd.com>
Date: Fri, 15 Nov 2024 10:20:34 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: "Moger, Babu" <bmoger@amd.com>
Subject: Re: [PATCH v9 2/9] x86/resctrl: Prepare for per-ctrl_mon group
 mba_MBps control
Reply-To: babu.moger@amd.com
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
 x86@kernel.org
Cc: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
 Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
 "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 patches@lists.linux.dev
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-3-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-3-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:806:f2::11) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA1PR12MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b645c0-7498-4816-d92c-08dd05917042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXg0N2JrbkxqZDRsaEtzVEY5SlIyYnJiLzcrSTNiTXlWZnBMOWpTY29mYktK?=
 =?utf-8?B?TlRuaGZkQVllUDdpSXNJSjl6N3g5d0U5bCtLbCt2R1hhYlZWQ1IxYmVvU0Qz?=
 =?utf-8?B?b055UVp4S2xaSjVPbVEwRmVrZzNMWHMxTmkxcy85RVR5Vk8reXhiaHpMWVl3?=
 =?utf-8?B?THBrUVJIRWJPbWY3eHZVZUwyLzFndmRBR3ZTczlzSHArTGZ4Ni92N3V2UXp2?=
 =?utf-8?B?eE43V2Urdys0ZjJFRkFOWklkekYxUXY4aVU3aVd0cTFJVE1rdWFZT3lkWGIx?=
 =?utf-8?B?cjRzYTBvN24vQkl3NSs5UUtSTUJ3d1VRL09EY2VRQkpibjZoZXc3Mm0veEVx?=
 =?utf-8?B?YmFlTElKT2EvUjZkZWZpQm1mNkExT3lnUW5GVjNVRVVYTTgwMUEyVjJKTHcx?=
 =?utf-8?B?MzNIOVdodFpqZnc0WU5ocXIxVE0rd3FUMFlJaFBENm5FNkdvK0pEc01VWVpq?=
 =?utf-8?B?dWttRzB5MU1Sb0ZoQzI3MzlSc21tS1hLZlVndzB0dW9NQzR6bWttSGJ2dGMy?=
 =?utf-8?B?L1lBalZ5Z0F4YjNKaFlIbkVGNnJjVFAxV3lNN3Y4NW9OUTZnRHVKYWlWVW44?=
 =?utf-8?B?MDZGRXNrZmc5dHVVUDdMT2d4TVBkbmI4WUsxZ0tjMVo2cjYrbkpyalpIZklw?=
 =?utf-8?B?TlluOHFGSjBGVStZYVBWN3FuL1Z1YTc3akF0UFNGVExqUEdrQk5CbFIwdndm?=
 =?utf-8?B?RjY2MmRab1VSK0J3bkVsU2JpOW9QYW9lbUtJSGExeDZGRmlLRXVNdjkwbnVV?=
 =?utf-8?B?aUVmUldRNEtLcnhEdC9LVVlWdExJNCtjbE9YaVduSzZCRTBOekw3ZmgzTEhQ?=
 =?utf-8?B?azlWclRMbzVmQXEyM3I4UnM4UnZoNXpPeVpmU2ZGMTdGQ09wNVRuWk5BbmVU?=
 =?utf-8?B?Q2NYSGl3T2FDV0tJT3VmYnpRYkQxbkhpSllRd2t0UHd0TzNyVzVFb3ZGaVlO?=
 =?utf-8?B?STJmbXN3UTVHcXM5ZHVZRG5TU0tUZ2k3aHhOZEJLU1piU09vWW9NR3NSZ1RR?=
 =?utf-8?B?czkydmY0UnV1VnlrNVhmRkpqWEcwWXgvSWY2SlYybzBSUTBNalNEQVB3K1Fl?=
 =?utf-8?B?R3hFZjFTRkRKWnhyZ2Y5RmVtbE9DZDNSRzM1K2JUbThJazd1NVJlZytjNlBI?=
 =?utf-8?B?czNCRkMwYUZzNlNPYTVuclpVMzhraG9yejdaN2lFREs4T1BmSlhXZjFPdVR6?=
 =?utf-8?B?dGF2Mm53ekdLOGw2T0dFR3BnOVcwZ2lyeFhaS0FJbGV4SXA0b0Q1VjFHclVt?=
 =?utf-8?B?UUdyTFJEUkJNUm80OWJmaHpEaHI3L1FXUjJmNndkUFh4eFNZU3l6c1gxQWEz?=
 =?utf-8?B?bHdudCt1ekhvc1IzSS9MK1NWL2dicHE1dkxKUW9UbFArZGFvZExWYm1YazBu?=
 =?utf-8?B?bGh5NkFHME91UzFVbGYwNDFzeC85T1kvS2xtWmdKYUtvbTErYVp3OHYyTmlB?=
 =?utf-8?B?K0hZYmhHZ3o5L3BLNk1ua3JGbmZPUGNmR0hLSGtaVUhiMURPcXhsWlAwcElz?=
 =?utf-8?B?cGI1NU9tMmprWU9JT1IrWXJoMFpZSmFIdWtlbUdxN3JVSENyTzUxbjBDZE50?=
 =?utf-8?B?VzNiNGNFT2xkeHRxMVBteGVsa2VYN3VoZzltR3ZTNzNNNk1SUlR1REhtWndn?=
 =?utf-8?B?M1RqM0tOUDZqdEZ2U3lLb0xPV2JlcW9rN3pkMmNiaVR3MDNBa2xnNktHOXNG?=
 =?utf-8?B?SGpnLzBKYjR3ak5VUUFmS1JSYWZJeEd3bzJ0eXl3QTFqUE5PbDYyUVhVenJn?=
 =?utf-8?Q?P5ycvzC3d9jFMld2iyXqDnHaqJgM1kFtN1QgjKk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2tVQlUwUWoyM1poSDZGdDJFV0lSZCtZQU80YUFVWk1IWS9ZYkw2OUUxWGNu?=
 =?utf-8?B?amJTK0hlY05JQ1hsQ3RnMnEvZnlmY29YcmpTRmRQdVBpL1pzWSswQU5jbkkz?=
 =?utf-8?B?NElOK0pZOTFZeTBwSjhleEtDNU8zbDNrUUJ1MGRLR1hublVvMjB1SEpNSFlz?=
 =?utf-8?B?bk9LaVloUWRrcEtPUmJDbnZkaFlhVHFUUlJEd1UrRk5LNG9MclBXRU9JTmky?=
 =?utf-8?B?ZUFGS2tKLzdORjZEb01IVHgrTi9VUi9IbGpZWHloREU1L2xxTGFYSDJ5MW5w?=
 =?utf-8?B?L3FZdjJNWlk2S1Rhb1dCSEZQbDI2NUJZYXJTTjBMa3JXQzN6S1NTbkgrT05R?=
 =?utf-8?B?Mzl4QWxzcmtiLzV0b0NySTNsb1lTckxJZUhiUzRCTzY3UVFiZE9pc2lLUEZP?=
 =?utf-8?B?dUdEdjFXVk5qaGxNRGx6b2xkMWU3T3dhQlBTazdST05RaWY1anVyRWU2VEF0?=
 =?utf-8?B?b0k4ZDljZFQ2WkN2dzhCaHg2NFJ3b0FyNERLVytQSVZBNzBLTFI1b3VvaXg1?=
 =?utf-8?B?WG9GY2lYSTYzOEpISzNlMEdTQ0lvU1FxOWgrZXdaRjNYVTl0bzZ4UnZQTy9H?=
 =?utf-8?B?anRQVnNNYS9jTk1yK3pKblVDRUdaTlBybzg1SGZ6NzVUcFBmWmsvUG4weXBD?=
 =?utf-8?B?L2VYUHVjb280VWZyWi8yRk1DSVZPNEZvWExtUmkvdUxMUWhSZ1pyN1ZBUFBp?=
 =?utf-8?B?eEY5bGdJS08zNW5XZUtEWG1jVHlvdWowNzlLalU1Um9kV0MrQmk2RnRQUkRh?=
 =?utf-8?B?bUxOaHJFa1pWR1lrc29kRUl3U2pmQTBSaFJvNllOQzNVK1hUNGN3dGRxL3lW?=
 =?utf-8?B?aG1MNXJOeitrUEYyRlNPRUhyMWJGeWw5RHRNUVNmcGJlUHdSbHArbXc5REwz?=
 =?utf-8?B?LzlqRWVlVnV4cXBaK2JwNnFHZFNEbENoRUQ0U05RMGw0QmNtNUhWZWFwSTVR?=
 =?utf-8?B?Mnk3d0x1Q0FTN2JkdkxsMis2SWhZenQrTndqM2dtZ04yeVFkeS9zakM3ZnRK?=
 =?utf-8?B?K3dRNDl0aUVHdG9Vc3hod251aGJWekJwazhaaDRRNXl1elgzRWJPOThkTzR3?=
 =?utf-8?B?UEFzUENHOVJjN05BZ3ljTTFNWDMyT295eUYrUUo2dUhvZlNBOUJmZmVQSnlw?=
 =?utf-8?B?RTI3cHFuSEJzbHJkUW1XZEtWRXYyMmJCT3YzMys1U0cyVmlzdmJTbWtmdTB0?=
 =?utf-8?B?K0l1SXpLaDUyZ3pzcG5LbGkzNng4MHdGcms4MUxueGU4TlcxNngvMTNCR05n?=
 =?utf-8?B?VVJqY0JxdUVvNmFFRERSajJiU3ZtRzQyZWJkZTZpSWNPalJ2VnhKcEhUQ29N?=
 =?utf-8?B?bkljcEFUaEVyamlURWdTSWNZSHlVU004eTRhZDRRMFBHNlJjdlhWWFNGWFZE?=
 =?utf-8?B?ZkZteitjNDdwRk9HS3dGbXppRU96dk9lYS9sMUl5NkdWSDdrQ3F5Y2o1Nmg4?=
 =?utf-8?B?Sk9wc0pEOWJYem5tdy80Uk11RlQ5OEQwY2FKbFFpSnNjbzE5N1BDcTFEZjBJ?=
 =?utf-8?B?TW9OT213cENaemZlS0ZDdG1iOXpqWkRmRUlBTVU2dmNLZXh5RVZ6VXhpeEM2?=
 =?utf-8?B?c01ONEVYQmZNcGFpSXNHNEtzbWJpT04zWXVZbm9mWC9rWkxJcVBmZThPN2pl?=
 =?utf-8?B?STJVd2JQTENDTjlhVjErbkFuQlFCTTlzMjFYd291ajU4RUY4OXNqVUVsVWF0?=
 =?utf-8?B?dFJWWEkrTGZSbVVJTGJjL3U2cUFaWlpjTkI2SmZMc1QyUkJDbm1oMUFjR3hD?=
 =?utf-8?B?Y1VQYlloSUdPS1ZXOGVvSVo0cFdINTVJVHBFTWFhTHI1SVVWaXJqN0d2S3pr?=
 =?utf-8?B?L2lwVnUxSkFzcUFzeU1EQU9qTU1tYXVsTkJSR2tsWW9jK2Z2MHpsRUNxQ1NG?=
 =?utf-8?B?eDhjaW50bFlMMDBmaXM4SUJBMmg4Ukh5MEpUN0JaNUdMOHp0QVNWL1ZGeTMw?=
 =?utf-8?B?TWNmY3ZRekhIeUN3TzRDTDVuWGQwdklhT2FyTm5iS2ZPeWF3Z3lpU251eUEz?=
 =?utf-8?B?L1lWVHhLWE1BbHN6dHVLbWE1TVdFc3Rxclh0Ukt1eHdGRk01S3lwbE1vN1RW?=
 =?utf-8?B?b1Jpdkk1SVdoQ3pjQUwzTE1LUTdKQ0lSOTMyTjdXM09rMERkMENFN1NqcjRi?=
 =?utf-8?Q?g+1c=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b645c0-7498-4816-d92c-08dd05917042
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:20:36.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HD1ke+uphSJhBE74eyH5CXT3izRc174Tf1qZfiNOCOilSgrERTaOLCA0pr3xCOL1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258

Hi Tony,

On 11/13/2024 6:17 PM, Tony Luck wrote:
> Resctrl uses local memory bandwidth event as input to the feedback
> loop when the mba_MBps mount option is used. This means that this
> mount option cannot be used on systems that only support monitoring
> of total bandwidth.
> 
> Prepare to allow users to choose the input event independently for
> each ctrl_mon group.

How about this?

Provide users with the ability to select the input event independently 
for each ctrl_mon group.


> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   include/linux/resctrl.h                | 2 ++
>   arch/x86/kernel/cpu/resctrl/internal.h | 2 ++
>   arch/x86/kernel/cpu/resctrl/core.c     | 3 +++
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 6 ++++++
>   4 files changed, 13 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d94abba1c716..fd05b937e2f4 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -49,6 +49,8 @@ enum resctrl_event_id {
>   	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>   };
>   
> +extern enum resctrl_event_id mba_mbps_default_event;
> +
>   /**
>    * struct resctrl_staged_config - parsed configuration to be applied
>    * @new_ctrl:		new ctrl value to be loaded
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index faaff9d64102..485800055a7d 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -283,6 +283,7 @@ struct pseudo_lock_region {
>    *				monitor only or ctrl_mon group
>    * @mon:			mongroup related data
>    * @mode:			mode of resource group
> + * @mba_mbps_event:		input monitoring event id when mba_sc is enabled
>    * @plr:			pseudo-locked region
>    */
>   struct rdtgroup {
> @@ -295,6 +296,7 @@ struct rdtgroup {
>   	enum rdt_group_type		type;
>   	struct mongroup			mon;
>   	enum rdtgrp_mode		mode;
> +	enum resctrl_event_id		mba_mbps_event;
>   	struct pseudo_lock_region	*plr;
>   };
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index f3ee5859b69d..94bf559966d6 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -963,6 +963,9 @@ static __init bool get_rdt_mon_resources(void)
>   	if (!rdt_mon_features)
>   		return false;
>   
> +	if (is_mbm_local_enabled())
> +		mba_mbps_default_event = QOS_L3_MBM_LOCAL_EVENT_ID;


Any reason to separate this patch and patch 8?  I feel it can be combined.


> +
>   	return !rdt_get_mon_l3_config(r);
>   }
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 2b198ef95e1e..a8022bddf9f7 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -65,6 +65,8 @@ static void rdtgroup_destroy_root(void);
>   
>   struct dentry *debugfs_resctrl;
>   
> +enum resctrl_event_id mba_mbps_default_event;
> +
>   static bool resctrl_debug;
>   
>   void rdt_last_cmd_clear(void)
> @@ -3611,6 +3613,8 @@ static int rdtgroup_mkdir_ctrl_mon(struct kernfs_node *parent_kn,
>   			rdt_last_cmd_puts("kernfs subdir error\n");
>   			goto out_del_list;
>   		}
> +		if (is_mba_sc(NULL))
> +			rdtgrp->mba_mbps_event = mba_mbps_default_event;
>   	}
>   
>   	goto out_unlock;
> @@ -3970,6 +3974,8 @@ static void __init rdtgroup_setup_default(void)
>   	rdtgroup_default.closid = RESCTRL_RESERVED_CLOSID;
>   	rdtgroup_default.mon.rmid = RESCTRL_RESERVED_RMID;
>   	rdtgroup_default.type = RDTCTRL_GROUP;
> +	if (supports_mba_mbps())
> +		rdtgroup_default.mba_mbps_event = mba_mbps_default_event;
>   	INIT_LIST_HEAD(&rdtgroup_default.mon.crdtgrp_list);
>   
>   	list_add(&rdtgroup_default.rdtgroup_list, &rdt_all_groups);

-- 
- Babu Moger
