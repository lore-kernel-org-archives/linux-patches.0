Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C82A156652
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 19:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718306247; cv=fail; b=Nuy4aUSX0N1c3+RAR8dgK0+4cheI9OjylMw4XwflpXASTyH6TiJThgJGKrZMNyhwMsGDj0f6fGwFsQfcQZ8oppB5TLFtBouEPIM+y568C7iJMvyDA5HqIU41ju2hOwmXIW0UVNLEqeDH8A4UE6glACAXbI3aWdIsoWoZ+Gcw2b8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718306247; c=relaxed/simple;
	bh=PlQ41cffiv7q9F47NkdMQ4VXZ6fIb3JGclMDO8g3tj4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Duvdsxcs2DGKGK5RgW8p7BeKYZYiS3iFUe5PrNeUq9oS5NSza0m68rlFejlbGvehTwTs1TsUzm+PXzb+zCd7FMOTMBVLziek+J/myQ9y8quFUt+XLFUm9WHhdlMpjLz+jsIpDCpzJ0CjH4KV16wHrzomUCCKba5IYcb1tf2CKvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NI7NqP3R; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NI7NqP3R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOHkCEZbybSB5unDtCIvNbCalnODbmk5eMF9/dP78j1bU4hsIOxEqRS2/oDOcIpHF3vPxuODiiyrQJjBeG1PL/5Uq7Ku85Yv6oyk0q792GPlQeWH0bFrnrKc3LcZqgYaJVlV9F9UBAxPoPCRvlgZ7DxbouGpmLXaU4vUHjIcYsJP7ttlNUshY5WJgGTycHpTQSJlO4XW6x15yWiFqwirNvCI49S5ss13wnvvyWHrmb63KdXMxtZNUKhWvecCBO1WjDC6oN/ltXEFf88RbN/VLCDE8OdydVfQD6rr6CaGN0xRIZWxzNzBDTIq0oUXPEkBWMJlq+D7mMyo6aIoT0Amjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKlhrwB9LTPaB9Jlmx1krYc90Vhog2dd4S8YKotenbY=;
 b=R8/EXEPCVs1V10202qaevcaY3wR3Zd5GMV2vbvbbHjTmwTWH2g2HX05BIcXJIC60cEn7V8sxOfOtfbaDyY/Me/Npuzt88SQWHUuLN2gzzilnIRHaI+MX+Dqr0fpp6FnPXp1lWi1QSE5Sr4/C4WRl0IEOF4W4D3hXQjPOuk/qJ8RzcWQiSe1EpeEaqeALImfvgXnFCGxBM349m+vw9VwUkZ09XhxxGqrZgxtC6HBCVJ4QWjRQyhbrrM7Xmr6VxD5Q8/eOsa14aakJoIM53nGFm38B15bwxeH66jY/YaVeS1jRUZ1agRUV/oJPfp8Z1G8FIYLzDd0YplrbkGwPjAn3dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKlhrwB9LTPaB9Jlmx1krYc90Vhog2dd4S8YKotenbY=;
 b=NI7NqP3RndxgJIM8PaY8YNEgYYSjt66bAPWQDss2E4Fl/7rIsxm7E1ijqm4JNMj+1jK++roo+OYLLEhWTJZwO5bYmvYwKcWExL3ct6uPWV/Ubv2r6w2x2vykvWzK9f4cyu06OIJQ26zEyNQMw+ySpapRqbQunGnzGjmMY/TVnio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Thu, 13 Jun
 2024 19:17:22 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7633.037; Thu, 13 Jun 2024
 19:17:22 +0000
Message-ID: <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
Date: Thu, 13 Jun 2024 14:17:18 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240610183528.349198-1-tony.luck@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0009.namprd18.prod.outlook.com
 (2603:10b6:806:f3::17) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 417682df-75f0-48f5-6ceb-08dc8bdd731d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|7416009|1800799019|366011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MENOMXMzMUxmMEVPL2svVnlPdXFyS2RDSDJGbDlSOGxvMENUK1lIRElLV2ow?=
 =?utf-8?B?dnZ2U05XMG9vWFZteno3elVKRnBwQURqQi9zNVAzcCtvekdyYnJqZFVFdk5O?=
 =?utf-8?B?OVlIWTlqSFF6aTk2YXd1TUlMaWNkMjYxZ2RPdkpWWWdZN1drcGs2ZzJUNUNF?=
 =?utf-8?B?Q0NxZmlRUS9hRnBhbnIrbThNeHphY3FxRS9FaFRZdElObWUzQVllRUZvV21K?=
 =?utf-8?B?QlJuRGJFOW9acGlsMm9zbi9QT1NtMzUzN3M2S2x5VWJUOUQ0ZDlZSlIrYUlq?=
 =?utf-8?B?bjhVM0ZQaFhrVmQ0U0dlaHpxZEhjUVZrcyttNVdBbUFVQkdPMkI1UUlOWENv?=
 =?utf-8?B?SjdZS09DczUrVnhTeXJDUnNocHk0UURuKzdMVTJscW50SFlJOCtnZml1aEp6?=
 =?utf-8?B?MzNBOTN3bW1samFIM2U2SVFEUjI5cmkvNWcxbjBCTVpZcTdPZXVuSEJNdm5z?=
 =?utf-8?B?di8wS0k2U2Ixb3hzYWlCSTdvQ2txOUZvMVRsZ2FNWnpMbVBXVmJWbTNKd0ZZ?=
 =?utf-8?B?dlhrU2VUOUVWWWptbmV3ZjFvOXZjdEJLQkhtSHpFZXNqL0gzMGZxUmphcWZU?=
 =?utf-8?B?aFZ4dEhPSDdDWUlKUmh0T1lGMHNJWjJCNTVGL1RWWktVbEJjNEtHa1E1N2Jp?=
 =?utf-8?B?QU1tS0djekJnVVFiN0Z2eW9RaW5ENHFmQ2wyWUpaOVB3cldvMnFvWGZBcmNq?=
 =?utf-8?B?WDI0N3dsNTBrYnRBR2J1OWRISFNHUy9PK2huQ0FybS9zWUZKODN5U2dxaFJr?=
 =?utf-8?B?YnpDbDVZYlFGalhDSG1uN0VtUytUWHVFMzE5NUJNMWZKVmhYNlFYYUlySk9y?=
 =?utf-8?B?WUVJclpoSytzSDZJOHV1Wkx3ZFVVRHgxUjVVZWhRN1E2T0k5RTdIbW04bU1M?=
 =?utf-8?B?SG5yK3NPd1B5WW44UXV4djRzb2tYeG53c3Q2TG5pL2NXNXR0WlliQVg3WmFM?=
 =?utf-8?B?bDNBMWlUdGIwMjFud1RXZ2Ztd2xFUU5nSWM5bHVpcU5FR3lhMTZTQVArU2Fu?=
 =?utf-8?B?MW8rYS9jVzNYTm5yL1ZqZ0w0ZnFVWWhPQjZzcmVFWmY0aWJXRHFXWnBzaEU5?=
 =?utf-8?B?dmJVVFVwZ0FwZFdqTXlZeXJ3WldtWXdRTFk3b2xBd0N4ZUVWUFE3QW52WUE3?=
 =?utf-8?B?YkpvakZMSEI0MS8wcnRaVEY5ZmtRK2lMU1BsZGVUaDFuZE1URlhIVmt0RnVB?=
 =?utf-8?B?R0p2WmNPRVBjMnV6a0phTEFMTkNOclFkaDQvNTZCYmttRmIvOXN6b0l2Z2s2?=
 =?utf-8?B?b0k5ZVZGaUNXaUJscEozR3JoN1dIUWJvQ2FhcERXeWlxV2ZRbXRBTGVkdzdH?=
 =?utf-8?B?bHJBN2RNS2E5a0F0TXVYUEx1c2ZpT216VVgyOU92T0prTitoak1QTkJGU3di?=
 =?utf-8?B?VUtLV3FoN1JqT1FHeUhUVDlwTS9MNGxwTG5ma2FWMEFraXFFMVlmeTl1UC9t?=
 =?utf-8?B?QVVSS2FwdUtub3dNMi9oYTcrL2Rxck9ROW4yZktMSjhLcGlCckw2T0NaejM0?=
 =?utf-8?B?bzYxY3BTTFQ4T0p1QnBsYzhlM05EZHhBTlF2Zk8wajB4VXZwNmFnL3dKSHcz?=
 =?utf-8?B?blZhK0dzTUMrb1FtRkFWditGWFBrLzFtN2tBYTRrUFlRM0k5aU9GdVZLT3hs?=
 =?utf-8?B?Z1Z0K1Zxa1RTU1JCaHl1UVRCRmVPZk1UUFNXSFVzVDJTbndhY3NhUkx0WUJC?=
 =?utf-8?B?ZzhVdFg1bEN5MXZzUHBhb2RNV1BSVVZMdUdJbVdlZXlhaEc2bTlXNzBrWk1x?=
 =?utf-8?Q?DnmEneK6mDPqzS37gUgmrwD0CfgyVW6H60rjoaN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(7416009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWtqS0NtN0Z2NXBrRjE4MEJNT09OY2Y1c0x4Tlc4RnNuTW9aNnQ0VnBsSVBj?=
 =?utf-8?B?Q24xa0lkaFJiUDRkcGMvS3FFajJLMkV0YXRxQ0NaNWVsZmJhbUViZmFmOTFH?=
 =?utf-8?B?UHM3MlVFb0FYbVZLZUxqZ0k3b2puRS9yZjdWU3A3THVtSXJ4cWx2Ukowb0dO?=
 =?utf-8?B?RmwvaUswK2lqUGFPUG00THYyYzR3OG9SM2E0cTZ3MlFMdS9XOUc1TEQ2dWFZ?=
 =?utf-8?B?NDRZTVU1RzJ5OWQ5YjFqdGtSMzlCOGJXelFpZWtyUzRVcTAvSWZldHYwTDBh?=
 =?utf-8?B?WW1qK1ExNkpFOUJCUlFORzU0eGFZQXRrWXJEWjZwL2JPdWxrM3NLZ1pNZGdE?=
 =?utf-8?B?NzJla1JQNE1kMkZ0L2xLWnJnSG9VTXJCM0l2dmxBVE9CY0pSVkpFTXFuNW1Y?=
 =?utf-8?B?aTBHcDNrMHlHTSt3U0g0VCtxUUlSdkxuQ0duU3NpRjhQSENzckkyanB3NmRT?=
 =?utf-8?B?bDRmL1EvZFdVNWNEd2FQYUdWT1EzMzIwMTIxMkNIZ2o3SmVBdjg1RVU1emY0?=
 =?utf-8?B?amEwbjFMbThVeTFjVkxScEhzbHRjWGNKS3k5OWRlQnJNZlFSZUtoVW4yUHBE?=
 =?utf-8?B?bUFrRCtoOFF3bjVOMjJCQVhyK0szYlphcDc5ck5mMmlleXBOclZJcU5OeHQ5?=
 =?utf-8?B?QzJKbHdkM1NoMlhqSkVVV2VXMHJxamlKSk55M0dqdXlIRXUzdTYyYWRIMFh0?=
 =?utf-8?B?ZklUV3prQSt1Rmwrem5uWTBtc2d6TFlZQ0hUZWdGNVcxa0h5WFNjaTk0Snly?=
 =?utf-8?B?Z2ZMT2M2LzIydkpmNzRocW9WVkF6TmFQd2duOHJqS2VjRHMwcFJxWDZnYys4?=
 =?utf-8?B?Z2NxbnNxekt5Tlk2UzN3RVc5UmVHZHR2dlMvdnNyOVdkUzFocDYxVm9iaGF5?=
 =?utf-8?B?ZE5QaG43TzRNQUMzakZHVzJ5WXlHWitGa1ppRzZCRk1qNEs2Y1pUaE5BcG4w?=
 =?utf-8?B?TW5VOW5vdTc0YzVxeXV3b3phaUw5SG5qOXpOVklwenBodGV2ZG9ycC93blFw?=
 =?utf-8?B?anBZaHJzbmJGb3JCMVBXSEIzTzVMaVlZL1Q5cTBCbmNjdStwVDFqOU5TYmZr?=
 =?utf-8?B?Ky9FbEJTeG9TUjAyaUlYejVwVEVoZ0R6QkVHMkFZK2x2VU9lUGZjdzNFaFFa?=
 =?utf-8?B?N3NuQ1l3TjJBalkzdWZDOXR0Qk5NTFk1bWVoVVcvblAzaTVackFpM2x3YXFM?=
 =?utf-8?B?VlFEQ0l3V05wMEJDTTZBMHpDRHdZQzZLU0xmcUVXbTE5YTQ0cVp5WUhOTXpw?=
 =?utf-8?B?NjUwakJKUXpicjRDMmlPT0Jha2h4YjNqSGQ3SEdPNnUzd2NmK1pzQmJJcEpT?=
 =?utf-8?B?S0hDdWRKV0ZnNTJMclRrNWE2T2tzaGxrZDFZOGozNXltdzVGdWpDYTBEY3E4?=
 =?utf-8?B?NnB5NVNQak9SUUJOQUc3ZVJlRXJWd0czejRIcDhUb0NVSDhycHdHUFZMZjND?=
 =?utf-8?B?cmJ2cEIxVVJqVGwzRzE1a1pxSG5yRk9yUVlNbDlib3I2WWo5eWRLaysra3VC?=
 =?utf-8?B?UVRobkF2ZG5YWHhSTjRFTUVBZzBGYVhKRlhBSTY1N3Z6L1puNWpnOUptUFY4?=
 =?utf-8?B?N0lvVTB3blp1LzhseWtVdjVQWW9EdkdCQzlEVjhVaHFEazg2aHZHM2Z5NTdy?=
 =?utf-8?B?RkdjZWlIWVJUVTlFR2EvK0tscXR3U2pkcjZCQ2pxVjZ0Nm1WZGRNVUpFdDlw?=
 =?utf-8?B?RkNQdUhsZTBzSTBSVkd2RWFsTkd4STRybDBMd0hwTTdZM2doTkpiN1VDYlVR?=
 =?utf-8?B?UGFrcjl5OVFsWU1ZMUhObzNWMCs4N0k5WmY1L25iS2tVS2Njd1RuenJRbUNy?=
 =?utf-8?B?eDJOMUg3WTZEbmI5MWFBTGFFcUtUWjZSTG4xQk5MRGliWlVrS3Q4Q2ZMeXJu?=
 =?utf-8?B?KzJ3WEJOQlFaWHgwNVBrKzZQdHhVWEN6cUJ0UE55K3IzOUtaQUk5ZzJpWEpD?=
 =?utf-8?B?ZTVxTHlSWk9zWFNqM1U2L1VZYnNKNUxtcVQrTFVBOWxYUW9zbXkyUTRIRXRz?=
 =?utf-8?B?U0JjK0lRMENNV21IYm56TGNjVzduM3hmeGhYemorT2RoZko5SU9jWU5sUlJ6?=
 =?utf-8?B?KzkzZC9CNVRqSE9IZDZ4dUFxdmNhV0h0L3BPM2VyeEpqbGFaUDBoOVloUDJY?=
 =?utf-8?Q?fV7A=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417682df-75f0-48f5-6ceb-08dc8bdd731d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 19:17:21.9613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dJT/eDVCGAw46y9XlKLf19xnouc/PclzKXKLEuUoD278rzvCB6ec+4nkAu6lj3w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

Hi Reinette,

I may be little bit out of sync here. Also, sorry to come back late in the
series.

Looking at the series again, I see this approach adds lots of code.
Look at this structure.


@@ -187,10 +196,12 @@ struct rdt_resource {
 	bool			alloc_capable;
 	bool			mon_capable;
 	int			num_rmid;
-	enum resctrl_scope	scope;
+	enum resctrl_scope	ctrl_scope;
+	enum resctrl_scope	mon_scope;
 	struct resctrl_cache	cache;
 	struct resctrl_membw	membw;
-	struct list_head	domains;
+	struct list_head	ctrl_domains;
+	struct list_head	mon_domains;
 	char			*name;
 	int			data_width;
 	u32			default_ctrl;

There are two scope fields.
There are two domains fields.

These are very confusing and very hard to maintain. Also, I am not sure if
these fields are useful for anything other than SNC feature. This approach
adds quite a bit of code for no specific advantage.

Why don't we just split the RDT_RESOURCE_L3 resource
into separate resources, one for control, one for monitoring.
We already have "control" only resources (MBA, SMBA, L2). Lets create new
"monitor" only resource. I feel it will be much cleaner approach.

Tony has already tried that approach and showed that it is much simpler.

v15-RFC :
https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/

What do you think?

Thanks
Babu


On 6/10/24 13:35, Tony Luck wrote:
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
> Changes since v19: https://lore.kernel.org/all/20240528222006.58283-1-tony.luck@intel.com/
> 
> 1-4:	Refactor on top of <linux/cacheinfo.h> change.
> 	Nothing functional.
> 
> 5:	No change
> 
> 6:	Updated commit message with note about RMID Sharing mode.
> 	Renamed __rmid_read() to __rmid_read_phys() and performed
> 	translation from logical RMID to physical RMID at callsites.
> 	Updated comment for __rmid_read_phys() with explanation of
> 	logical/physical RMIDs. Consistently use "SNC node" avoid
> 	SNC domain. Add specifics for non-SNC mode.
> 	Joined split line on __rmid_read() definition (even with the
> 	added "_phys" to its name still fits on one line.
> 
> 7:	No change
> 
> 8:	get_cpu_cacheinfo_level() moved to <linux/cacheinfo.h>
> 	currently in tip x86/cache
> 	no other changes
> 
> 9:	Dropped the "sumdomains" field from struct rmid_read (a NULL
> 	domain field now indicates that summing is needed).
> 	Fix kerneldoc comments for struct rmid_read.
> 	Updated commit comments with more "why" than "what".
> 
> 10:	No change
> 
> 11:	Fix commit comments per suggestions
> 	1) Added some "why it is OK to take a bit from evtid"
> 	2) s/The stolen bit is given to/Give the bit to/
> 	3) Don't use "l3_cache_id" (which looks like a variable)
> 
> 12:	Fix commit message.
> 	s/kernfs_find_and_get_ns()/kernfs_find_and_get()/
> 	Add kernfs_put() to drop hold from kernfs_find_and_get()
> 	Drop useless "/* create the directory */" comment.
> 
> 13:	Add kernfs_put() to drop hold from kernfs_find_and_get() [two places]
> 
> 14:	Add cpumask parameter to mon_event_read() so SNC decsions are
> 	all in rdtgroup_mondata_show() instead of spread between functions.
> 	Add comments in rdtgroup_mondata_show() to explain the sum vs. no-sum
> 	cases.
> 	Moved the mon_event_read() call into both arms of the if-else
> 	instead of "d = NULL; goto got_cacheinfo;"
> 
> 15:	New (replaces 15-17). Make __mon_event_read() do the sum across
> 	domains (at filesystem level). Move the CPU/domain sanity check out
> 	of resctrl_arch_rmid_read() and into __mon_event_read()
> 	with separate scope tests for single domain vs. sum over
> 	domains.
> 
> 16:	[Was 18] Update commit message with details about MSR 0xCA0, what changes
> 	when bit 0 is cleared, and why this is necessary.
> 	Dropped "Add an architecture specific hook" language from
> 	commit message.
> 
> 17:	[Was 19] Drop "and enabling" from shortlog (enabling done by
> 	previous commit).
> 	Added checks that cpumask_weight() isn't returning zero (to keep
> 	static checkers from warning of possible divide by zero).
> 
> 18:	[Was 20] Fix some "Sub-NUMA" references to say "Sub-NUMA Cluster"
> 	Added document section on effect of SNC mode on MBA and L3 CAT.
> 
> Tony Luck (18):
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
>   x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
>   x86/resctrl: Allocate a new field in union mon_data_bits
>   x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
>   x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC)
>     mode
>   x86/resctrl: Fill out rmid_read structure for smp_call*() to read a
>     counter
>   x86/resctrl: Make __mon_event_count() handle sum domains
>   x86/resctrl: Enable RMID shared RMID mode on Sub-NUMA Cluster (SNC)
>     systems
>   x86/resctrl: Sub-NUMA Cluster (SNC) detection
>   x86/resctrl: Update documentation with Sub-NUMA cluster changes
> 
>  Documentation/arch/x86/resctrl.rst        |  27 ++
>  include/linux/resctrl.h                   |  87 ++++--
>  arch/x86/include/asm/msr-index.h          |   1 +
>  arch/x86/kernel/cpu/resctrl/internal.h    |  93 +++++--
>  arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  85 +++---
>  arch/x86/kernel/cpu/resctrl/monitor.c     | 242 ++++++++++++++---
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 272 ++++++++++++-------
>  9 files changed, 835 insertions(+), 311 deletions(-)
> 
> 
> base-commit: f385f024639431bec3e70c33cdbc9563894b3ee5

-- 
Thanks
Babu Moger
