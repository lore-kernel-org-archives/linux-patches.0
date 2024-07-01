Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD2E166306
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719843853; cv=fail; b=M3ALQz52ajaGLmistOOymHMoDGK0j203IPgS/zcdn6iry8/eBczLpVf/HOYJN9KnnYXP2pQ7eRjLKlEv0e1ohid6pZn+gUy+fjTpEAUdQ5OU78awEhVJXh/3S4YdXiB3wMOsCZXSxk9/g8pcWojCiLyZo2ff0AQcn/A9AfNtpbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719843853; c=relaxed/simple;
	bh=/5dWNTBTy4u+z+6uJ8Wl+bVE9Cg7ds9h43c9Gmko1EE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AIaK+rzloy5A+P9JfcnIqjHQbBW1OSl9XmNEWkao7YtoU3881YrnOPgBadcTU90sQRGOECY+kuLMOS5E24WKh49ilvBPKFNmxB6Kl84OhzbXVCCxCIvCWvjaoSm6BYKb/FDk37gxOSsDwdZ2uvNrDB7ThZ/jfd9uySor+bMgVHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=29OHvwmJ; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="29OHvwmJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuaFFDr6PMEDs8JgwPH29EDFpjjIZMwdNGdXD9/JrzDHSxkg69HowopUN5cW2gV6qVjqBC1ECDaiB0DbP6RL1uKhXb9jrQdIgoS+C3iTVh3ndEpOMGLFgm1Yl2OdCbYQrP1f2wy0OLh+QwTbUktrNXwdGtcImjM9/mjT6l9jSdlqGWhF+IfEhgkjByRcGY7prtAwxFXzE9RK0ABBRd8bAuUE/p+rVI+OFQSF31SGPqnd8AtHS4hRmFQhkeLNEYUQeeuLJhcNDMTnSN7OCETNAYQqxAReH1SWcd7YP9Iw6H0JDiX4HKPFa4qfG+AdDTNuaXDi+zYgIhDVsrYkkgIdfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjTVz7L+Zg5lc0T2bWOfUEsOGUjPEeYRH+iOFafCoNQ=;
 b=EDpvI06OR3WR48gRm8WPBuYCgpSeK+X/ztU3Yl+Fly/lX7pixOiCGCRAA7lr2eXOaGk30wrBSi32AM+0Fpta7Vd116/nXiVztfujv/ZRWRMsmuVDT9HIy07wPk1Mcf0ks66/p+nPGVuLaJatZHSDXtLtVJvETQoNFSSmPzCf7XYHVXJju06+JNsmiG658LmaIMmYBmwObc0C8FbAR13sPBGayu6RwZjdr5B1nsRJt2p2OGxIS4hfdwopASuvhmi1aVFBYqUoOV0IXzZW2vfqCQQNo8my006OnZ5ZEVOwbfff8RSiKV4O9/1eEz/SdyFWwHyoo1soJVZOzZnIcblZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjTVz7L+Zg5lc0T2bWOfUEsOGUjPEeYRH+iOFafCoNQ=;
 b=29OHvwmJBkiv9mtMC+yuy+qTzcwjIVf8l6CCxLxsFEjNg7qO7p8K/D6yKUQtHL5nL6kxkbRcoawqak+Gq1hQvCqlTS3KF+BKRNxxzQNLqUBlzOSVYiJXvg0QaSJfvk/RFzS1BwAb5+qZx66A2QWZd6REuWK4tPDn6Z9yoC1gOcI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH0PR12MB7093.namprd12.prod.outlook.com (2603:10b6:510:21d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Mon, 1 Jul
 2024 14:24:06 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7698.017; Mon, 1 Jul 2024
 14:24:05 +0000
Message-ID: <0221f994-ff09-499a-8e01-376211a10df5@amd.com>
Date: Mon, 1 Jul 2024 09:24:02 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v23 00/19] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
 "bp@alien8.de" <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240628215619.76401-1-tony.luck@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0162.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::17) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH0PR12MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: ab91bba3-ed52-4558-f165-08dc99d97663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWR0K1h5MmRBOTlHMEVQdW9HN0IwbXdubVdUWCs3R29kZ1RpeHFFb0lSOG5q?=
 =?utf-8?B?Zmw3VXVKYjIwL1NTTnB3LzlOSURSeVlrMjFCZXNqdTE5MmZWN3cydkNJM295?=
 =?utf-8?B?SGV0czNZMitDNU9vNHhiNk1ZTVlUNVFuNU91b2hSQThiRTY1SW8wMk9CTTZE?=
 =?utf-8?B?OG1TNUQ2SkE2NVIxSGhzQmE1NTlQcHlVS2ZxRmVrbzBxUmpLZ1krY2RpR3B0?=
 =?utf-8?B?LzZwckJlYXB2WDV4YUJLZFlkZWFSNzlsOHBvcHl1MzBIY21tYmdYZWFqVXFJ?=
 =?utf-8?B?VFlJa1pBYmYxTzdycUw2aFcyaFVFbS9qc1VkUFdIL3hhdVRSbGdXbTZNQnU0?=
 =?utf-8?B?eWZzeldoQ3BUc3NTOXk4MVpjYWNEeDYvN25pVnlQUkQ2TVhLdFpBbDI5RVI4?=
 =?utf-8?B?NjM5UHFWdXZNYXhneGM0ZllNdmdwMEFJME11SG9NOG5mQVNiN0NFWjhIOSt4?=
 =?utf-8?B?b0liRjd1bzNVTW9vZGp3YTJxQlErTGpDSVZ5UlFjRjNvOUVUYWxCMjhZR3E4?=
 =?utf-8?B?QzVxaUgwOXR4eThrNFZKeWNXQUx4cFpKcFYyVFFBdTBSWnhkZGNuRUxDcEdB?=
 =?utf-8?B?V0RKNFliM0ZFOUwrRHlTYjM1VHY2bUx4Y1FjTC83RVgrRXlaRXdrYUk1Mldi?=
 =?utf-8?B?Um1WSFpjUVV5cHVxNVhRNmRTcDl6RHhtUkphYTlCM2tPRmN4bnBOUnU3dHpV?=
 =?utf-8?B?WGZwVC9KRlRuM3Rpb0VuaFpjRVcvRjNNbjQ0WElRVmQ2ZVZISnp1TGUrMWt3?=
 =?utf-8?B?Z2wxV1h3UVh6SEVrU29Db01rY0lUdU56YmNJQmxoV29Fc3RpdEJqRGZWY2cy?=
 =?utf-8?B?bFE1WHBJRVM4SHpnR245ejlIeXU5Vzk2dzJxRVloV2xTaGtUeXFKNlJrc2xH?=
 =?utf-8?B?SDJFUlZPQWI0MXlmUVZkYVVjb3hKTHkvYzh1b09zZXNCUFkzaXlvb1NkZ1pH?=
 =?utf-8?B?M3dVd3JjRUxuWFQzV2lzNC9vY3JMdzdQR1lWVTlvYk9mRFFFWXpjOS84MnJS?=
 =?utf-8?B?cGIyVU54aXRERjl4Ny9zRXJ1R21nTUlFK0ZUMys3N3Q5SERIaFpTMWhiWWRk?=
 =?utf-8?B?RGF0dlY4M3pWa1NqZzVDQVN1dmUyeElkVDN2WE8xRU1HUVJITElYb1FLeEJw?=
 =?utf-8?B?cVRRMTJDL1h5U2YxQ1ZsMGxFdWwvb3crZ0VjT01RNXk1QXZHVUg0blBUYTQz?=
 =?utf-8?B?N3laTnBPZFFNYzlRM1ZOSTRlSTZtYUxkS2svdXFiSVhZcFQ2aUNoSlQ4K1B6?=
 =?utf-8?B?NjRUa3IwS1BuSnhQWDN0RVFqdWRQbzN6cGJCdCs1UkJBVXNqR2dDOGludW9o?=
 =?utf-8?B?Z3dzUzEwMHdhUHhreC9TamtRWERsZ2tuNmZGajVLYVV2N1E2T29MUytCa05K?=
 =?utf-8?B?dEdtNEJEbHlXUEFxOHI3VjgxbFowL2NWZWxWSWJnMGpYVzVuQytQVisvc1gw?=
 =?utf-8?B?VkZ0WndNR2F1UWQrMDVwNFphUThMNEhYcHJ6RzE5OEYralQxc2R5VXFHQ1cx?=
 =?utf-8?B?K1ZMQ2FIT3k5Z2dLUVA3WG0wQlBoV3dXaWtaYVpjYWNCWHlaWkRITmxNQjIr?=
 =?utf-8?B?K3dlR3Zud2lDaFlRNTNkNk1ja09RSm41RjJIUFh0d2JpbzB5ejh6WGxjTFht?=
 =?utf-8?B?TlhmUTVmajBBODBsVVYzQWtKanlBcUpDZzd0V0JJSkVKT1FDdTJka1g1bzBS?=
 =?utf-8?B?SjFmRHJlV1ZRR1A0Z1ZPdm94SnBNMW9wQUEzVDdxekxXUlp1T1hBY1RQbjhO?=
 =?utf-8?Q?9ARsgxPS359go1JTjs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGFVUGRVV0JvelFJSmJlWWN5Z0ZlaXl5OWQ2bENPU2sxK1VSbmUvZVNRNEhl?=
 =?utf-8?B?bmVGeE5rOUl4UWU5RDU4TjFCRE1GaWkrRzA1Z3VRTnNCazZvNE9pYk9ZTWw0?=
 =?utf-8?B?VlQydEZNckU5REtvbXNKOXZPMk0vTkRxRlJtUytDTjB5S2xKUmpRb0UwV2Vs?=
 =?utf-8?B?Y0xSckU3OEowbDB2Z1ZrMTBkelRSZVF0dE9Ma0hGTUNhZDEzWTd0ekVqMFdm?=
 =?utf-8?B?M2d6SlVKblhJWEtJTDdlRGRBS1dwMmdJZXV4NFhzZmpMeU9laXN6Y1JvWWli?=
 =?utf-8?B?OGpOcVVXemlMTzRCdXY5NU1jRSsvQzR1bHhUNUx0aktWNHZKdFNpTGtjUzhL?=
 =?utf-8?B?VFN6RU01MGNWYU5mM1hOdmJlWFNiQUp1b1ZiZ1QvQmV6dWZFUXN0dUZnUm5J?=
 =?utf-8?B?dGU4ZnVVdGpiSEJXY1VnUUd5WlF1MWxoKzNwVFVZODg5WjEzdjFRcHNub0Y3?=
 =?utf-8?B?Q3FZcEZyRkhhQ240Y3NkelUxbXpUR3ZVSnpDUnRLWmVqMC9PQk0zLytJRUo3?=
 =?utf-8?B?SThIemJNYUNDNlljRUdpZndlZzZNMGRlN3UzNmw2dHBPTkdVcHJLZ2VCa2V1?=
 =?utf-8?B?cGNWTDZ2Y2gxc0NEQk8yY0k2cTZWVC9aTzFOZ2k5alVtVnorWHE3blEwQ0g5?=
 =?utf-8?B?SmdVNnpDbzYxR0lZZGU2OUw1dTNmUUhwQW9aSXV3RzNsS1p1US9RRS9aNncy?=
 =?utf-8?B?VnlmNkFseUJPVXJ0UEhXTlJSNTNHcTBwTCs4Y3pJVTlPUkNSeHhHeE1MemFK?=
 =?utf-8?B?Z25WWnA4Sk53TU50eko1cGs3Mmo2ZFA0SlJYcitTZFRENm5adjZabDc5QkFp?=
 =?utf-8?B?aTZ4bHRna0F3TkkxcE1tY3FRekdhRWJSWlgzckRnT21BQ0svZUFoNnhxV0JE?=
 =?utf-8?B?RlF5MVI1dzhwNUhHSE43UTZZY01QKzFhdHgvK0NWUGMyQ05ERExNL1Vqalg1?=
 =?utf-8?B?Z2tLVnQ3Y2VjUzZSTkJOaFJnMk5oaEVJMWNNM1VQVzJGVTFVWGQ4b3p3Ynpj?=
 =?utf-8?B?S3lyVE5WT1RTR2NENkJxSXdBNjI2TXlhQ1BlU1B6VHFJTWVCd204UW9UWDNO?=
 =?utf-8?B?NElJcnVZNHp5cEhtMEljWmtFdmFISW9hUXdFYnRtbW5LcTNOM1I3bnVGZDJF?=
 =?utf-8?B?eCs2RzF2Zm50YWJKM3F1VkJ2U0dwUzBKQitZajVCSWJIeEprdjUyb0I5czdW?=
 =?utf-8?B?bDB1dUEvNUNNQ2k3L1dCSWtobEczVU53TGlOK0IvY1N1elhXTFF3YmQ4dDZ4?=
 =?utf-8?B?SzlYclphUmExNVJpV285SFFMbmNwYzFrOEJPejJhUmZOSWY1MUxjL0xtT0R2?=
 =?utf-8?B?VFp1enNUN25RUlQraFA0N2VRUVhSSXlTbVc1VXBUYXJBNENWcTRlQzVIWjJj?=
 =?utf-8?B?TEVWZ3hzWE1IQURFaFFYVkpRclJieEdpbDFzZ04xUzVKam5WQWhZeWdJbjUz?=
 =?utf-8?B?SGxQMDdiREx2bzNpU2JSOHRoekhYQWo1bGlkWGMyL3dLQmZmZ3FHdm1nUjY2?=
 =?utf-8?B?ZkgrbkFnN0lPOUcwMW5HeDA2OVBHY2tPd1RvWHJiampiNnlueWdDOStBOTVT?=
 =?utf-8?B?dHhUNStlaVhjcDhPZWZUU21GYVJqTXJLQk5xVlJVdmlJdmJLSUI3UGg3VldG?=
 =?utf-8?B?cXlqVDJwN0FaMmNPOGlNUUhxV0pvVEdxOHVPNXZHUmg3Z05ZVlJjTGtwQTZa?=
 =?utf-8?B?TnRUa1BrMnlHd3czWTNaWmdLbmRkREVUamJVdzZPUkp3ZFIzYUU5SERZL2Nt?=
 =?utf-8?B?OWtYUlR2SUg2RWEweVN4eGZ1cEk3YldqUjVqamtQYTJqanlCT2lQWWkrbzI0?=
 =?utf-8?B?cGUvMGlzMDhjeEkwMERiMFJ2bTBuVjVCVFdMYlc0dVJGOXlDV1JjakpWTnBx?=
 =?utf-8?B?YlNOVUMrZGVYWWV6WGt1QVNwOU5zVG9KTHZKMGFkdXRjMWY1ZGJiQitqWVJJ?=
 =?utf-8?B?N0Z0emNycXBqTkdNMXYwblpWR3RkeHdtNWpUd3Nzdi95L3lybWdVR3pXdWNZ?=
 =?utf-8?B?dlo5SzBnMmNCS2htN0pKS0Exbk5xOXhTb0JMcE9nbDFtZ1dJaUozWmJ4Tlhz?=
 =?utf-8?B?ZnduYmJaWVhrS2lDS0d4UXJUeitjSjRRa0IrZGQrbVJkQ0xjd3dmYlh3U2h1?=
 =?utf-8?Q?f+mg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab91bba3-ed52-4558-f165-08dc99d97663
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 14:24:05.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kLNvYHdHSiyNFIA1BHCwipveVl0uxYe/2oKZiQ2hTqrZe3iMygGFEdiZhnlqyE6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7093

Tested the series on AMD systems and ran few basic tests. Everything looks
good.  Thanks.

Tested-by: Babu Moger <babu.moger@amd.com>


On 6/28/24 16:56, Tony Luck wrote:
> This series based on top of tip x86/cache commit f385f0246394
> ("x86/resctrl: Replace open coded cacheinfo searches")
> 
> The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
> that share an L3 cache into two or more sets. This plays havoc with the
> Resource Director Technology (RDT) monitoring features.  Prior to this
> patch Intel has advised that SNC and RDT are incompatible.
> 
> Some of these CPUs support an MSR that can partition the RMID counters
> in the same way. This allows monitoring features to be used. Legacy
> monitoring files provide the sum of counters from each SNC node for
> backwards compatibility. Additional  files per SNC node provide details
> per node.
> 
> Memory bandwidth allocation features continue to operate at
> the scope of the L3 cache.
> 
> L3 cache occupancy and allocation operate on the portion of
> L3 cache available for each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> Changes since v21: https://lore.kernel.org/all/20240627203856.66628-1-tony.luck@intel.com/
> 
> No net code changes (final version v23 == v22)
> 
> * Patch 9 split into two (9 & 10 in this series) Added Reinette's Reviewed-by tag to both.
> * Added Reinette's Reviewed-by tag to parts 15 & 16 (were 14, 15 in v22)
> 
> Tony Luck (19):
>   x86/resctrl: Prepare for new domain scope
>   x86/resctrl: Prepare to split rdt_domain structure
>   x86/resctrl: Prepare for different scope for control/monitor
>     operations
>   x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
>   x86/resctrl: Add node-scope to the options for feature scope
>   x86/resctrl: Introduce snc_nodes_per_l3_cache
>   x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster
>     (SNC) systems
>   x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
>   x86/resctrl: Add a new field to struct rmid_read for summation of
>     domains
>   x86/resctrl: Initialize on-stack struct rmid_read instances
>   x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
>   x86/resctrl: Allocate a new field in union mon_data_bits
>   x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
>   x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC)
>     mode
>   x86/resctrl: Fill out rmid_read structure for smp_call*() to read a
>     counter
>   x86/resctrl: Make __mon_event_count() handle sum domains
>   x86/resctrl: Enable shared RMID mode on Sub-NUMA Cluster (SNC) systems
>   x86/resctrl: Sub-NUMA Cluster (SNC) detection
>   x86/resctrl: Update documentation with Sub-NUMA cluster changes
> 
>  Documentation/arch/x86/resctrl.rst        |  27 ++
>  include/linux/resctrl.h                   |  88 ++++--
>  arch/x86/include/asm/msr-index.h          |   1 +
>  arch/x86/kernel/cpu/resctrl/internal.h    | 108 +++++---
>  arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  89 +++---
>  arch/x86/kernel/cpu/resctrl/monitor.c     | 256 +++++++++++++++---
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 281 ++++++++++++-------
>  9 files changed, 865 insertions(+), 324 deletions(-)
> 
> 
> base-commit: f385f024639431bec3e70c33cdbc9563894b3ee5

-- 
Thanks
Babu Moger
