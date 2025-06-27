Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB027E042
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 22:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751062559; cv=fail; b=sKMAl7UUmK+4Bomshhevb2Fee8yXR/xvg+38GNKc4m6GNOvGXnHP6sn4HXYoZOVm1HBezAmi8pR5eJB5DjJo/AfOPAL75d/rKstculJJVMgF3JeCJeqUvK5yADiRwxInquMUNTB/IBtrf2Zyk6Nw2QRhEcahfIKv532t9cw2Shc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751062559; c=relaxed/simple;
	bh=5fcSgv/PdC+RE/mihJ23Og5j9/4FSK8gpdt0EanIwns=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Se7QQ2hOWqY0IHBXb2V8WEo5DMk7T4e5fzC8qbM/E3GTNwxiZ9bZpvPb64hHnM7+rJjbLJo33AspidE8HYQEIq+YBzteGI4NIlq84wTrJc91M5PM3dKCXxSKh2YJl8GGWZ9j4i1KnbyYaqp9gOprvnBRiFjSBIjNSIPI+ungw9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kjSAnMUd; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kjSAnMUd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKCvhi7OORH6hpwre3YSUlKCG5pLSmb0515BCBiS3iNunqxgUYC9ciKAVCCRVdvNMz2QLArPOTQaNQYIpVGkEwVY4jZUzGG24BLPv2F3cFS82RAmeDrYUvM8LcUsddP+ERYCaiUoQPKryg8sYSBuZ7et9Jl4zRrtlQnZvjBu9MVj0rbE5zmnsLK+3VdBtglHTJzU+NAVbSR+M323Mqbpi6ni2CqoaYYLBCdX7lXO7J40Wr7WrUHFyKD98lzmZs35Nq8Pcetux2kruPqq4a5+K9dljSm67DN4dERwJl96z8ucCx+KlHqLZx0/U0cIFHcHFFxWaa2S+JTMlToPsJW1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fcSgv/PdC+RE/mihJ23Og5j9/4FSK8gpdt0EanIwns=;
 b=yBAxcIciNLpuz9o4f99QaOOT/LM3MX7Dnql6637ctdcb2aKt17GJ317bRcRal6af1pmzz56r8k3tKOM9ixGKhKXTY0uKuuppACDyTc037qmWPiy3Xx+tCwBJwYh/75pdyM02f/rl7hVNHGXXxvsSafzCTywRYYRPbGUQVh3OyVLRfAfbhZzrssE00kh9hAC46SoWqtI5D2Wdhnw6UfVWM/gfOUfUUss9dzySotmoHw7TG+K3QGbCZkOUlMq4sRV0uSJIpeJ4ZzWZUrVAz5+jwRar2lpSTI+OVYER3Glpcj6+aFMinbG+w/eFJ5SQep7jZ2AF7hKMcET2Kr5YWerdDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fcSgv/PdC+RE/mihJ23Og5j9/4FSK8gpdt0EanIwns=;
 b=kjSAnMUd1TyVNeO5kgEnjhDZuTehnD1BKpOlDTLrzeFwTiykWxDQVDnOSzUQ0MVZTKw/dGeGRv1F1XyD5aa2pw1azahIzjO4W6BeXpAQ/KJMuma6YBwAsFAU2nLMMMhC+eNeAYlGrgkcBPU/Buz733VOdJYe0soQrDR/idHVAEgzBszSBVc9eeuDjnkkIVFDSqh5hUE0NXy9YWfdVrUR3ajzJoF3Eas++CGfWhoqYrMpY3CzLwtqZTOYvzmJQ8lvNvpijpWmrIiFdSzKCCdxjtwDEhcXetYyeni0IWe7yJOyiBmlx2P1hyebTpAswQeso6UDAYB3/ymFwpaIXD45eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2667.namprd12.prod.outlook.com (2603:10b6:5:42::28) by
 CH1PR12MB9574.namprd12.prod.outlook.com (2603:10b6:610:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.24; Fri, 27 Jun
 2025 22:15:54 +0000
Received: from DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2]) by DM6PR12MB2667.namprd12.prod.outlook.com
 ([fe80::bd88:b883:813d:54a2%6]) with mapi id 15.20.8835.027; Fri, 27 Jun 2025
 22:15:54 +0000
Message-ID: <f93b813a-0bb0-4dec-9526-b4f13b967248@nvidia.com>
Date: Fri, 27 Jun 2025 15:15:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/30] x86,fs/resctrl: Replace architecture event
 enabled checks
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
 <20250626164941.106341-3-tony.luck@intel.com>
Content-Language: en-US
From: Fenghua Yu <fenghuay@nvidia.com>
In-Reply-To: <20250626164941.106341-3-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:510:33d::25) To DM6PR12MB2667.namprd12.prod.outlook.com
 (2603:10b6:5:42::28)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2667:EE_|CH1PR12MB9574:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f8e02f-052a-412f-88af-08ddb5c82ebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0EwdTFMVU9DQlFMb1NVOUVyR2ttSkt0VHFlZjM2L1NiNmlnMUVSUWFpQ1Nq?=
 =?utf-8?B?V3V1cVN0cUIxSWowYUh1SG1zY01LSmhKR2lQUzNFV0JlcG4xUXM4MXR5bWNS?=
 =?utf-8?B?M0FoTTlyeHVvR0h4VUhaR1E0NG9GNVhHOWFOR0EwMnNXWVRGdkNHcDNFTStt?=
 =?utf-8?B?cUJZQVJjbi91cmpQTFJSN0RtdzBhckR0WmhWQXVRUFVwOUV1ZWFOUDIzWTFj?=
 =?utf-8?B?SHJvNEQ4MGhYTEVKeGZBYTZKNG8wRkFBQlpHNVpxODBERVVabzdiVEFJTVF3?=
 =?utf-8?B?V2dnTnFqQzdoU0Q2Q2gvQk9tWEppL3hkaGoza0lkY0ZWOS93cXJMNFVRRENw?=
 =?utf-8?B?N253SzRoV2RtV21LNXdjYmtOWDQ1YXFGOUFxZVl4bmtQSW1MdTMvcCsyT1Vy?=
 =?utf-8?B?d1JIU0d6R29TbWhnVzc4ajRqN1BxOG95MFBDMmoyU2FRR2dIZVFiQjVGays5?=
 =?utf-8?B?TU1PQTlpMGdSbGxycE14NUNTdFFPM2RaSXFiSjl2WnFtL1E0U2dCc0pRc1F2?=
 =?utf-8?B?Vk9QWDVmYmhRdGpnQTJjMFFLTWVDbVhBTW84SEJRNnVNNmFRMEp4Z0Zud0Nk?=
 =?utf-8?B?Zi9RMVF6T2gvTGVpamRlcm1VaEtZczRVZWN5bUlMakkrZmZpUklNMWtKYnpB?=
 =?utf-8?B?cEhwTnVQZTFjN1dYLzZ0MkVlV2QxT1NreURlSStaL2dqVU12WE9PWVVLOVhm?=
 =?utf-8?B?SkcyK1YzNHBCV05meHRhVHJQYTdrZUh4YXRxdnNBZkx3cW83bVVtcFNlZDNV?=
 =?utf-8?B?M0tOT0VLQVAwcjZVdTEzOCtDTWJaNkU2Uk5OYnhGbWdxUlhwbS92U2J6RUs0?=
 =?utf-8?B?S3MzRE9tKzN1MExCWkRMOFJSRGpSNUk0bFp5ZVhEVTFSYVRDZHRpQ2p0bHlJ?=
 =?utf-8?B?Sm51eXdMZmlObXl6U2pVcTZNZ3RHZDU4VU03QUVZWWNVaVhITHBEcWVaV0xh?=
 =?utf-8?B?R1RqN08reWpwbjhUUklXYWZ4cjNoMjlWS0d5RUNtWDZBWVJ5R2RyYm8vTTlZ?=
 =?utf-8?B?ZXJEanpINTVsRlhobEV6MllMajdNcmtUZ0dNZWtaRVl4Tzg0TE9qVk50Qlow?=
 =?utf-8?B?dzBxUTJzd2ozalNUZ2VpYm42d3VRZjZmeWNsOWNJNjkyYzFvTVdqZnhZYzlI?=
 =?utf-8?B?Z042a3J5UEhBMXNnaGlaSDVBS3prQis0SGQ2UTh0WE1nWjRlQVFsOWpzSU1p?=
 =?utf-8?B?NlZyYTJ2Z1Q3S0U3SGhRaVZUNXoyNktJZE5Ea2NxeXN6UURqaGJsUHNQdnpj?=
 =?utf-8?B?VjNMc1FRSE1VUFNGdzZOWjRQTi81U2ZKbFM5Ti9KNmdWUlJHNUJtaVhGTEJr?=
 =?utf-8?B?QmJUSzc5Q3ZJdlRRVjVoNzlRKzlzU015Q3hIc004QWZJaUd1K3BqeG9LY3R3?=
 =?utf-8?B?RWJvR21FemRjM2RqSjk2TU1PaitVVUFrZlZEbDl5THhGNHJRdXE1UW84bFlR?=
 =?utf-8?B?ODd5bHRCYVJRcjNlamc1MlpSZ0UyNE1tT2ZGeUtMUmdmNU9haDd0MTNBT000?=
 =?utf-8?B?cnZyUjQzTHRGRkpmT0ZXbndkU1BMR295dDE3NUh6Qk1jNENyN0pFVkx3ZTlz?=
 =?utf-8?B?bi9kbkhGNytucjJQbnRWVEtRVTRNV1pRUHRoYUxPeXg2bW01aWpaOFVsSE5R?=
 =?utf-8?B?Z1NGand4K01zby84T2xsMjZaaGlZWGpaK3BKeG1iZ2MvaDM2Z3AwTnJ4QkE2?=
 =?utf-8?B?alBNUUFzeHptWFhLeTFsQWFRcnFLV2REaVJjY0E2NG1FU2sxWU43enRiRG9i?=
 =?utf-8?B?U2ZuemFZNWJBbWtqZFJZay8xLzVnTkFWVjdGYTZPblEvZnJFcjRnYXM1R1hy?=
 =?utf-8?B?RHhWWDJJNmdsbGVRWnlRc2tVSnMzRi9DTHErYWpER0l3SVR1MncwYitKWFEy?=
 =?utf-8?B?anVwdVY1NHZNYmVuUHVBU3hiNFYrRWZVZGg3cXk3WFNzUGZEYmtZYXBRc21s?=
 =?utf-8?B?UC9sY0tzOTZxN3pFZ3Q1cTBOc2MrclBLVGJQcmNHalZXNGJ6MC81cnNlbjUw?=
 =?utf-8?B?cTZjMW5nZmJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVZJUDYzaEhleWhFSkVMY0VUTlRmQlR1WUR2Wm0vMC83ek1janNkOE1CMHkx?=
 =?utf-8?B?N1VCUGtmcWpCRnVMM2JrcnY2cDhXWVhwVFNVNlZrMkorRHZiWm1mZlByUys5?=
 =?utf-8?B?L3JtVm80eDdvelArRTIwVlNKY2lpN0E0TTNCTG1laHZady81a1lOYU8ySFha?=
 =?utf-8?B?bjFzU2hMUSsyWjFZbmlsNFBrSmgzMm90WGEwYXB5MzdsMEZNaW45OHNZbktz?=
 =?utf-8?B?cGdIYkVoWmhrYlN2RjR5eUlwd01obFJkZmJOTWJZL3BaRFRDTTVGWVdiSFJo?=
 =?utf-8?B?SHF0RzNYRUNiT0ZtWkpPNll6eVNiVzloN2RoN1lIWmNiL0x2MzVwOGEzV1A1?=
 =?utf-8?B?ZUNLVHY2andQdE8yak5Bc3BtdGxzSTdJK1o4TWN4dVdxUHhsYWtjdXBFUFVm?=
 =?utf-8?B?TGJycUlyMHZoY1l6VEx0cGdkako2OVA2czROclRSVmd3bFhOMUJkS2tZd0c2?=
 =?utf-8?B?UUNhSTk2dlJKbEZDaGxON3ZiTGNXWDdreHdNT3RnK09kWHJkYWNHaGU2ZFNs?=
 =?utf-8?B?eWxVMWIwTmVsbGNRaVNyOXc1M3FsT0JIV250a2JDakhXaGFqcEw2d05YUm1I?=
 =?utf-8?B?ekNtYWw5RWVmU0taTEpIMThTbEJvUzBIUnQvKzRVRzI1SjFFTjlNeCt5OWdF?=
 =?utf-8?B?d1pzREZaUUJjZEE4NDZOQ0hUU29NVjVrY3h4cHJGOTBielkwT3FxeWplZUFS?=
 =?utf-8?B?VjRsa25ITHBTWnZSNzNHNm9uSjF0N2xtMjFlUXMxZHZTcm9RWm9WMEt1U05z?=
 =?utf-8?B?OXJqT05iOUxMSkxSUTVxc05RMkdqVzlYWCtmQVRhdmNqTW4vMktTZWlyWStD?=
 =?utf-8?B?WXRqQ3pncStZc2d2NlJLdjhZcytLcEpjV3VPZDBmbzZISUZ5QWh0OFVPbFN2?=
 =?utf-8?B?dUJ3SHMzSFJURDBBQis3eVlNRlVYTDJpZWp0VG52MTQrNklGUzB1eUxLMVk0?=
 =?utf-8?B?aytqRXlvWnhtUzNSRUNETWprVjFIOWZleWJxOFJHcWtiMHB2TEFhS29TU29H?=
 =?utf-8?B?a0VrVU15VTQ5N0l0ZVdPZ2FEV0tXZGhadmFGSnU4cWwxdkwzOG5KYVhURHZr?=
 =?utf-8?B?UldMQVlOa3BDTVVSNU41YjJoRFZTbnBOUVdQdEM0TWc3ZkxaNlZQM3ZPZVE4?=
 =?utf-8?B?RXpndzQxdHBwVTRzbStWei9yd05nUldNRFNoNDZoZXQxWFE0RG5Bb1lrbHdl?=
 =?utf-8?B?SmttVVNsNHNDVXdQVmZNbUNiVDhXZXhNbUxWVTBqVTBXd3d1ZzRCekIvSHpT?=
 =?utf-8?B?c002aU5jM1lzWnpEL2ZvSTZGeUp1bHlSSHViT1k4K3JwNEtlaG5WWlRlajVX?=
 =?utf-8?B?N0I5YWlGYjYzT0Y4bEppRS9sWjVmTHF4SXRNRlAwWTZxUnRHdkRXUElMMFZz?=
 =?utf-8?B?QXc3djhKcG5uSHpUL2tKSk1TeHZQamN1QkQzNEpPaGtXRFRSR2xVdDVtcUFo?=
 =?utf-8?B?MVJaQTdPL0Y2ajR4U2tDRjg2SkpzNmFKT0c1U2ZYSklPbFdtQUJCODlpTm4v?=
 =?utf-8?B?b29DT2tOVzBORGFhOEhjWDBsQlZPOUdHNzV2SWxpWDdUOXhwclB4d0R3Nm5J?=
 =?utf-8?B?dm9CZ0NPSDBqdkdFSjN1UmloWEdpeDJVaXAyQnFxTGtrNU1Vd21LcXl2VkFv?=
 =?utf-8?B?ODRNbjBZeTV6c3BZN1FiQjM3QkduaXB1TEdqOVVNSFFzbXVBaCtoYnRrcnJE?=
 =?utf-8?B?cVpvV3JzOVlaRUIzaVlzdU9tbXhIcHFIaWRSSmpNVVNYWE1IME1EQUtDeENZ?=
 =?utf-8?B?MW9WNGJmOHl3c2xZM3FQcEwrRzlwRW5QOFlmY0YyVDF3dzQ2dno4MFNGdUZs?=
 =?utf-8?B?VktoTVQyRStKVDhZV2J6azkxRzZPZ25GWkdJcmhxYjNsM0Izdm5zc3Ruemt0?=
 =?utf-8?B?SXRBUEhwMklnTEdpT0N5SGt2MDVuQllqVzVzanErZGVFeGQrYXVpSFdXWW5E?=
 =?utf-8?B?cEYveHNnamhWTTBOSGZYeW9xd0VIQVlPblJucWpHNGp2ZytJT3Z1bWxvd05C?=
 =?utf-8?B?MjN3a1FDczV2Wm1vZXJtK3hBT2VSSHk2cFdoSXVmV2pmd1dEQi9pYWs4NWlw?=
 =?utf-8?B?cXMyQnpHdFNSaFZza3J0MzdpZjY1aktDallQUDZzWnRHQ0pQNjVndXJrekFn?=
 =?utf-8?Q?8mP/2PpK/G4UDIu/nTPq9nGP4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f8e02f-052a-412f-88af-08ddb5c82ebe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 22:15:54.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBmhUwWAIhdu204lwJOvfrtSoV0ekx9+3gXhJFB+LHE7MuABmyy0oTa4AZ6u5d7PUUhmjaMVrZbqkNpKZGknkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9574


On 6/26/25 09:49, Tony Luck wrote:
> The resctrl file system now has complete knowledge of the status
> of every event. So there is no need for per-event function calls
> to check.
>
> Replace each of the resctrl_arch_is_{event}enabled() calls with
> resctrl_is_mon_event_enabled(QOS_{EVENT}).
>
> No functional change.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>

Thanks.

-Fenghua

[SNIP]

