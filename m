Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2069.outbound.protection.outlook.com [40.107.212.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274BF15A848
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687672; cv=fail; b=irNJEnkohDq8ifor7DmwYWjsiEp5UyCTCfCZGr2NHkk3+b8AmRlDQJQ7pMfg4hiGM86WLtXcdfxxuvnjE2hDIHgkcXmdeaZol+nLCdP7vwogBxY3MAXszc1LNH/uNWLhQ+ds4tCp1H+UJMIg5Ooa4d7frM2hogXC8xsgcF4auxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687672; c=relaxed/simple;
	bh=Ef5A276d0OZ8xGvXhtfp8h0oIypS2Z0bizkXqsvXHkw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tYP6BkE9y2UkWI8eKDThxuzwG6rgUFtF6ehaWUsXokPQvewzCVQDOF1SPELqyHTtoHnwrP2SA22pDjKeWhk0zCcpVgBrz6+yXfzeCOtx9EHV0LYQXsiGxRARYr7BRjZAfOJXJOJPAITQGOsxr7iphU+eoX3MJXgw0xnWZbysfKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Idgr1O7g; arc=fail smtp.client-ip=40.107.212.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Idgr1O7g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKRq8uJa8aVG73J9SOcVz+xv+ydH76ubvWMbE0v1WN1YINNrN9FILhWE2aXYaqWEZ/1RcQPWPI5gO18gMlt3feCyPmbxGZcyCabaNHEv1SuCZR9vVS6S+ElUk9RLxfLIf9kLjgSWQ+dYE1BlJjVW6d/A6KJiSR3N1+OUG4FOkVzRhVo2AKxV4UvQuQdXRwuey3BaanN5r8s4fRwAO6R5l/t+/kQVRNgLMfNFDRFDLfuetmxlOFtq4ENFonsFBqsPrtcDwDl8Hc6UH/ATYEvVHgX9wiNSo4pKIuhop76bckJaK7nF9TPCjjeU9xSPNwLVKpAv/0ii/jiPxpnp8nY+8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rj+813ZeLY8F2JmTJ/6xfwd1fuKQML4QqCL/VyldBJ0=;
 b=RkhVNnXuBRCOeei3ZSEbdr6zr0mcbCRLXROHxuamVa9HAFYVl2TWEqpWJ6XzlTFm0cIX6ont7tPI5YOefEUQeYqX7uFyHVaHMSfaPxihn57+KF1kivDs9GIyaa78YnsVBbMpkP6aVfM4ShaJSJiNfSC0C3ekEjYiEdJnQYhFUm/djJTxvafk0L5VrZBbuUdvrsNwnD3c4mwjbeDlQPbUlumpUht1G4bBbveMVPNYIF7bo3EyOMoDu5nhqbWR49DkNc+20wwoBCJniE2zr/ecA/guWVdaXCeaijXkogkcKrRflq9A9UxzPjPie9pY9MrKhvZl/mqOq0jQsrUAEpDcqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rj+813ZeLY8F2JmTJ/6xfwd1fuKQML4QqCL/VyldBJ0=;
 b=Idgr1O7gy+qDYmv8Oh3nyRp42sUzbWfxA9iWfzy23OgQffB4Fat5C49XYdDzKolufneDup+iUUHI7aN7rYa3p+RhvigU9sQrU1gdeyeuq8eCwx2iNhmV7E0hADUJyV3td2eW0dua+Jojn2vVXLbBM9PBhFh1NcU5heY1k94UPB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA1PR12MB8309.namprd12.prod.outlook.com (2603:10b6:208:3fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 16:21:06 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:21:05 +0000
Message-ID: <b4b31f4f-7f09-4ee3-9373-6ffe5ea859a6@amd.com>
Date: Fri, 15 Nov 2024 10:21:01 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: "Moger, Babu" <bmoger@amd.com>
Subject: Re: [PATCH v9 3/9] x86/resctrl: Modify update_mba_bw() to use per
 ctrl_mon group event
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
 <20241114001712.80315-4-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-4-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0025.namprd21.prod.outlook.com
 (2603:10b6:805:106::35) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA1PR12MB8309:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be8a754-348c-4ad4-b959-08dd0591812f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjgzdkRSRXp3Q1hRdlJIa2hmNkluL2VpY1lSVUtRQzVrT2toWVNieWRnbUJo?=
 =?utf-8?B?MU1yb3lsc1JRSEFxdVhIUzJTbXJPREhUYkFQQlFjY0hteVVCWUhRZ2VaQWNN?=
 =?utf-8?B?dXpnY3d0TEJ4UlN3Mmx6Vko3VWNCd1Q2RndYZ3VYRkFNakx5cTZlTHZEb0M2?=
 =?utf-8?B?aTVSSzljZXRnV1YvQ2w3TWdjNEJKbTlsZ3A3dHk4NHR5YTBKVHp4ZjRpaWlu?=
 =?utf-8?B?QnpyeC93ZnFnRGVJN1JWVnAzT3lxMVA2QldjYkhaaG43SW1SMzlnOHd4a3c0?=
 =?utf-8?B?N1h6Y3JkRTcweVVOOEhqWkFqYlh6UjBIZ1g1UG9DdlYydnpwMFRaK0Z5Y0F4?=
 =?utf-8?B?eWNGRHFBTGZjYmErMHc3UUcyekVrb1VlK3BSRURiRVRiY2Yya0MwOUJrN3Zw?=
 =?utf-8?B?dHhXZlpaZjFYL0hyYU5pTk8vRCtKdmpQVlhIWUlOZ1BydHhWd25Jc0djbVlL?=
 =?utf-8?B?VzFaeWtlRWQ0NUppN1FJNllFTXN5SmtuR0xtQkcvNGF6ZCsxbitWMU5sSjJO?=
 =?utf-8?B?Q2xnQ2J3Q1UxYmc5OEZPZWpLL2haZ2RZUVhqMTJEOW5UZ2xQMUxBRFNseldW?=
 =?utf-8?B?bXZlYitKaGNCKysyTldvSCtwUEdmakNuRjc2YzZOMW9lUC8vNVFyZSthbzBj?=
 =?utf-8?B?bWRDQ1VUMmNNdmI1UCtkckkrVDllTis0QmJoTVQwelFmNFhmckg0eXVQTUVv?=
 =?utf-8?B?SVVDS3Awc1RmelZRMlUxWVRZOVErMERidU52V2tNbEpWNUhuZHA2M2QySy9N?=
 =?utf-8?B?a0NGVU5aQVBHVzhDVXNhZWlCU0NNQlRsWjlyYjkybWJ1VnoyZGs1bWJySWFO?=
 =?utf-8?B?aVVnbDZJWGdsYk9wdkQ4VC9OZlAzRC93Y1RQc29tTjBFR1VwUUwyajJNMEoz?=
 =?utf-8?B?a0hFZngrTjUrNGN6VDRqY2N4U0IvcGtJc0Vzam1tanpLdXV1ODJvNUJtK2RR?=
 =?utf-8?B?VjdnUGhHRWlvV0N0cFNvejNhelhudTROREVtVDd6NEE4OWxGVkR6SDAvQjY2?=
 =?utf-8?B?UjMyMWw4NUNoK1JjWFNWYzc3UWQzNEZYUEtVdjUvRHZXbDBEMkFTckF1eGlm?=
 =?utf-8?B?RDBhdEQ0T1pSeWM2bnRaNkM1SnpkQTNMVVNGamt3QnFGdWVlLzBXdmdNWnVk?=
 =?utf-8?B?RmZmUFc1bWpuQ3FqRzF1RkpXaGR4N29TYmtsVlA1bC9sajZiNUZqZFZyeWVC?=
 =?utf-8?B?VUJRekJXQ1hHTzhwL1RhWkE4Ykt5WjNSbi9kczFwek1aQ05WbGg1QWUrcVg2?=
 =?utf-8?B?TkVESjQyRVZjckcvZCtza2VRb080UEEwRFR4WG5LV3JQNTlnNXJycnRWdldC?=
 =?utf-8?B?V25VOXZOdU5OSVZWcVIzeno3ODVrYVd5YWY1U3RaL0ZaQ3hZWXV5UUtnQ3k1?=
 =?utf-8?B?cXVGRzJLNkwwbGhGMUZKR1I5Q1BlZ0hQU2N0dzVLeFB2RXhHYkFwaTZSSjVV?=
 =?utf-8?B?SEVXcXBXVklZNXQxbUdLNmZGOTZpTGJPZi8wOUdneFdzOStwOG41WjVwTFdw?=
 =?utf-8?B?SmNYcGRqKzhjUWJ5QURHZGxINGR5WXd1NEJ6NkdlRENNOThoN3pPNGJsOEkz?=
 =?utf-8?B?TFJ1VUlTRkkxbGg1eFpEc3N0eEpXdDRDcXhLd0JIZVM4ZndhT0V5SXZUL1o5?=
 =?utf-8?B?VWhMRFM3VDBVclZhNjQwMUdiZ01uWkhndGdyZ2dRbWhNMDdDWlg2L1RjUU41?=
 =?utf-8?B?eVMwRDZzNFNIb3J4bERLTXpZd1hOS0xQY1hkV0w3NEpObkdKN1N4YjJFdG5U?=
 =?utf-8?Q?mGW760CW8khTxVTSSM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWRJb2gydG82VHduWS9HclFSWWZnMVVWc3czeWFnRmR3NUV1QmRhdHU0Q1BO?=
 =?utf-8?B?eERFZzdKenRaU3k5eGRhT1BXelZTOHFQS293WG00VE1aOW1PQTB3K3B4NEhY?=
 =?utf-8?B?K0FHay82U2dLUTA4UjFjMi9qaGhOWU5nM3cyai9YQ0VJajJkMVR0WmQybkF2?=
 =?utf-8?B?Y3JwUnNBRjA0ckplL0pielp3RmtOeEF0cndKdytPTU5uWnIyNDgyVVJxTnRu?=
 =?utf-8?B?Z2x5NUtDUGJOR0RQKzN6WUt2RHNMZmc3SmcxZFdHL3lKVlM0TTdUOEZiZXhv?=
 =?utf-8?B?MGtnODI3OU82MmQ4MzhKQ0Y5YkdUSUpWOVA1SVI5ZEZtNWRGUk9ZaUhVUE1w?=
 =?utf-8?B?UmxIdEdrU0hZbUZ1bUU0WFZjR3FCb3A3ZUNjVHZPRGJDQUxYQmcwcFU4OVVX?=
 =?utf-8?B?eVFOZ0J5M1RNRVVSU3c3b0tLaDhJZzQyRitWZ0xxUEhlY1ZnQUhzRjdmQW1u?=
 =?utf-8?B?ak8xYWRCcmZxclVaaXZaUGhXTEY4K0tRV25lSnlFYTJDUGI0VDd6cXBONk1O?=
 =?utf-8?B?MCswak82TDJCalpzL1psL0o1WG1adWMzYnFweFJVUTgyVXl3NTJtOEZVS1BS?=
 =?utf-8?B?enpxM0krQ0RWbjFOQ0RzbmRHRUZXZ0txM3diUjhwYklYOWJJWWhjVnlNNnhK?=
 =?utf-8?B?WjY4SzNjOExGaFZ0THVQN3dOdWt1bG83RE5JSnZ0VVQ0V1BQeUhEUEgwTGhz?=
 =?utf-8?B?Q3VIOVhlTTlVWFdFazIwbGE4VVZXVDNvVHprNnRhM200SkNCZ1NUalV0M1hZ?=
 =?utf-8?B?cE1vOVdITXVnYWFUZzdWcEcySzYxQ3owcXBrZ2o4bEthQnIrbUN4SVNsVXdK?=
 =?utf-8?B?NlpxRFZXT2JGS2xueFZuWXNUSDVzSEVJaVB1alowaFg2SWVJd081L211UVlM?=
 =?utf-8?B?WXd2dzVGd0hVc2t4R3RwdTU4MUlTTGZMT2lWREZ5RmZlb3BXaWdZanV0MU8r?=
 =?utf-8?B?ZVpSMndDVzk1RCtJTFJPMEJtT1FCeEpvcUNDV2xOVWVxYXlVSEF3Snd0cXJh?=
 =?utf-8?B?bTdVZ2NKa1hmU3lTZ2hGbDVDaGtXNjlBV2wrV3lnUEI0eE0yUG1hei9QN1k4?=
 =?utf-8?B?a2xZU2g5N0dYdjdiRG92aGwvTndYaGI1QmJVdlB5dUl2R0FTanA5L2lSZTEy?=
 =?utf-8?B?dGhDL0JMRXpvVHFQZ25MOU9DM1loQ0V2b2kzQTNld1dIZTZIdUVSYWsrVDFC?=
 =?utf-8?B?NVRhMkhBODdCSmFWTzFRZnpiNmRXYUc5azlYdzlIQzMrcWRrT252a1hvMGNH?=
 =?utf-8?B?TW5KNkNhSUhXdWU1TU43dW1iRU5NNXJqeXpaeFM0dzRGS1E4Zi9HUitPNmZy?=
 =?utf-8?B?aWVHSGdQRzY0aERIanRxTVRDV1dhV1dUWjFyamxRZEFlVkpKUTRzT2t3bnp2?=
 =?utf-8?B?S2xOMjBxUElYYUlIaFBOS1Z6UEwzeFV0YUFLekhmbG93a1JSSG1rOUpEU2Nt?=
 =?utf-8?B?YnpDNVBlQ2NFWXo3VFU1K0pPNkpUbGtybkNxeEdWTUZLTGpZdHZLWEtqOE5X?=
 =?utf-8?B?cjk1bWFleEwwMDJ1WFVOalJyeGtwVmk5Qk9RdDJoMmQ5ZlZlZmNvRFZSM0Rj?=
 =?utf-8?B?N3p4dXM3ckdRWEkxcU0rTkpsOGkvVnlLS2FVU21XSGVLY2xoVUlPMFF4aXp2?=
 =?utf-8?B?eG9nSVRta1BtQzJodlpzd0lMcUhac2ErdFhrcFk4NkZSTVZwUzBCdEFwbDZB?=
 =?utf-8?B?ZmU4cmd1SEk4eEVoQUtIbDBQQ2RMdFltWWhvSk4xeFFhSEV1L25MS25CaVpW?=
 =?utf-8?B?VzFxRytoNk9hejdqaFlGT296aEFadEFhaHZzT2ZXTEhmSE92RzRXL1pVTXA0?=
 =?utf-8?B?bWswMU5VMThqY21vbDBZMFdta0p2T3ZNMGVkMUhaTGEwZEd5OXFUOEY3bXhN?=
 =?utf-8?B?Z0RlMTJUNmEvWUZ4N3NjcDBTZnlHMWJ5dlVyV3AxTzdBZCswcDJzM0JmeEpa?=
 =?utf-8?B?V3NlK3VLOGNGNkpLYU54U3FKQlZrVFBLNzh3aTI0SG1jOS9UWG1uTHpCaG5M?=
 =?utf-8?B?TE5zSVo4ZmwvTUltUEJkSCtHbmpZbXBoVmJmZmhEVWxsb1F5UUNoQVVvZm9N?=
 =?utf-8?B?aUxmbzdjWVNqSkhpUVVidGIvclRoRmNiZmhiTkgrRktPdndJeFlyNENFaGxH?=
 =?utf-8?Q?dvQs=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be8a754-348c-4ad4-b959-08dd0591812f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:21:05.3547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b18tmyotV/aLriLlchnEfbGWXqdnoauD5rrRNHq8nvgaQ/WAAlcAAXuTVz5ZbPSp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8309

Hi Tony,

On 11/13/2024 6:17 PM, Tony Luck wrote:
> Instead of hard-coding the memory bandwidth local event as the
> input to the mba_sc feedback look, use the event that the user
> configured for each ctrl_mon group.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 7ef1a293cc13..2176e355e864 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -752,20 +752,31 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>   	u32 closid, rmid, cur_msr_val, new_msr_val;
>   	struct mbm_state *pmbm_data, *cmbm_data;
>   	struct rdt_ctrl_domain *dom_mba;
> +	enum resctrl_event_id evt_id;
>   	struct rdt_resource *r_mba;
> -	u32 cur_bw, user_bw, idx;
>   	struct list_head *head;
>   	struct rdtgroup *entry;
> +	u32 cur_bw, user_bw;
>   
> -	if (!is_mbm_local_enabled())
> +	if (!is_mbm_enabled())
>   		return;
>   
>   	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> +	evt_id = rgrp->mba_mbps_event;
> +
> +	if (WARN_ON_ONCE(!is_mbm_event(evt_id)))
> +		return;

I feel this check is enough.

> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_LOCAL_EVENT_ID && !is_mbm_local_enabled()))
> +		return;
> +	if (WARN_ON_ONCE(evt_id == QOS_L3_MBM_TOTAL_EVENT_ID && !is_mbm_total_enabled()))
> +		return;

These two checks are not necessary.  You are already validating it while 
initializing(in patch 7).

> +
>   
>   	closid = rgrp->closid;
>   	rmid = rgrp->mon.rmid;
> -	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> -	pmbm_data = &dom_mbm->mbm_local[idx];
> +	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
> +	if (WARN_ON_ONCE(!pmbm_data))
> +		return;
>   
>   	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
>   	if (!dom_mba) {
> @@ -784,7 +795,9 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>   	 */
>   	head = &rgrp->mon.crdtgrp_list;
>   	list_for_each_entry(entry, head, mon.crdtgrp_list) {
> -		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
> +		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
> +		if (WARN_ON_ONCE(!cmbm_data))
> +			return;
>   		cur_bw += cmbm_data->prev_bw;
>   	}
>   

-- 
- Babu Moger
