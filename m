Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4E8D52A
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382478; cv=fail; b=b6SrJwrrFDSN/UXX+4M9wloqao4eVVMlAo3dCxdY2TiqFGdJ6brpqOJ/Dcr9wWVr8f2zn+0CVYU+//0BngTtuDa1aAnGoOcoG8RHvpfK1NvcrjGJ0XaKJw51LO4Qg+KPdGVLVwgh3JrgJ/J+CmfuKKnmRppIqKteVLpXAScfbWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382478; c=relaxed/simple;
	bh=l4ejjmUF4ABaTPjJVWQ3Y0JMuMUTR5Rha7TgJqMGQbM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BpX0HCvoEI7wVIOx9HUZsrIRVGZKdspOTfluumX1DaPtuHqOxHMeuV5Q0Cv6qaL8G9UMNvJUGpGgwMgyfsLBm3hElnC7h0ZNDs6Upp8rnGI7MYGVc/eprvQdqK9b4QExBA+0PLsMiqI7PriNL/jYyBA9NBFt1e5wMVxuor+b8RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zbN5fKtA; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zbN5fKtA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiKBIkhIyVPZvb2Ik0OOcyuoGrwJeYVbWdP0INU1H7yfVon4N2V4yv0esRCsQImKQ3ghdQg/pSgHQFdXUXNbgiq8v8ZeLqpkmlw6NGEkBH1Ct7KvsaYCow9S13crR1MzgXEhDV2wU6fJxNa/eck0sf5tJ3+EPAMVjDN4ZHUQ/JnOaMurbt9UV0crACSzoll6pPOFMRsUukCNCKdF9NbkSIoHIPbtL/ujr6ECqsleyUWxMzAGYZpKYOc4zMu6vdF2VrntXGD/3G4CS/s2OGxlZ18nE5GyN6a/GOETHgfQ2jNJsAzxM5mckndCNfeJrEDFk7QGzLbcTx9D82pLBYbJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqno2spJGD7EH3ZOGaQpkIx1jhFKf59PBuInIdIiWCY=;
 b=J9cGWu0bzod86KlD0YDMZVzlF3NRQuF6/7tKA1C8mQJ2mmR2KsTrJvrG/E4o/N/aJvRLLuVKiPuLD08+rF5xkrt7SRozt2jDljhq/77lugVSxi4PGXOMSBfX9u4g4tVnz8VzaZDwiWZetex/4mlLzGQIxANuU0HKYQM7ZeIHwNPdn+kqX9Xs7LV0wc4IaTPNtX0buYCJyxliNzvbnqKYJR1ekSYtNf/Qn0aUo6JxMb9/OFzlfjIq2TLswghvBRtZUjgElr5CXDnpb2ztYnmmQdegkDEsHL9iHPBsIVB1H2HVUihXqd9EdfDaF9ZC9xjVfPXCnFP52rmKawUuZDp6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqno2spJGD7EH3ZOGaQpkIx1jhFKf59PBuInIdIiWCY=;
 b=zbN5fKtA8crEHjUS8ildrkwHPg9W7RIp9EFikhc91f9nsLRt5Gkvpw6BWBIIRiQHoNbx672AoEnuAyIMqtSFW4cXaWRXISmgYXJ4xhxZpy+9AaruL5E7cvogk8R3AeLg1Aa710uXQHlTeztxa/UaEjwQ5X4U+dXcwxk20dCrpj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SJ2PR12MB8136.namprd12.prod.outlook.com (2603:10b6:a03:4f8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 16:27:51 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%5]) with mapi id 15.20.7633.037; Fri, 14 Jun 2024
 16:27:51 +0000
Message-ID: <e17d3a79-9c07-44cd-b0ea-2d0545680342@amd.com>
Date: Fri, 14 Jun 2024 11:27:48 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v20 00/18] Add support for Sub-NUMA cluster (SNC) systems
To: Reinette Chatre <reinette.chatre@intel.com>,
 Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240610183528.349198-1-tony.luck@intel.com>
 <658d9869-ef22-48a7-876a-5bbba4f134ff@amd.com>
 <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <bc52a051-4296-48ac-9a83-29139855553f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::24) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SJ2PR12MB8136:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d82d7cb-3085-4dcf-586b-08dc8c8eef7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUl2TEZGdmU1YktTNzlYcDRmU0ZwN0JJMUg4emJNd3RtYS9qZzMrVm9sU3F3?=
 =?utf-8?B?NEZ5VzNJYW91elhQVmFyZWRNbWxUL0NWdFJCS1hNckJlYllVbXlPVzVKZU9x?=
 =?utf-8?B?Vm42MXhzLzc2cExGTlFZbW4vMUh0ZDJtM2JwanBmQWswQXF0bTg4UWxVY3lZ?=
 =?utf-8?B?WGVlYjRZUkdWdUNNQmJCLzNyMTF4ekx0RFpEQ1lhcGZkQVlwU2RhRDBxVm9R?=
 =?utf-8?B?RlVZZlkzVmZtQ0pKUkwvN3BESXc0M0NRU3R1dktVVFRGYk9jank1S0FTSmNI?=
 =?utf-8?B?cmRzMzA3UmNvTmRua0RHWWgvVk4wdXlFNWNLd0Q4V0RBWmZ4MFFHMjFsTG5K?=
 =?utf-8?B?b2czU1hMdXFrUFM4QXFOZmNjSytjWURvV3RhQlF6OWc2L0VHOVZ5K2dIdzlN?=
 =?utf-8?B?MmtHd1B1NjNTM1lMWmUwdGtON25MdEsyYnhTYmt2QnNndGV3WG94c1VDRVpI?=
 =?utf-8?B?TjBPQmpOYmxabVN5MFhscTNsckRNNzJSUzlDTzRXblNOT044RTN0STBjZ2Z3?=
 =?utf-8?B?djdmTWhpcFdSYlV2L1BFRWtGTkRkbXM1L1hQb0Q4cFdYNkVUMzcyK1A5RlJv?=
 =?utf-8?B?Q1NXaWpvc2xOK0FsZWZUOFVwcFgyUFY3enFFS2RocEEvdUYrRGUzWlZ6b3dq?=
 =?utf-8?B?R2RHZXNDcW1oMndSeFYwa21nTUlDL1VrU2llb1JVM1UwTVFqT1pneXpOcktx?=
 =?utf-8?B?UXVOVy9HUzIvdDQvZ0VrbUFjbjQ2UCt0SzRJMmVXOVZaK3VwMDVtR0NiQXlK?=
 =?utf-8?B?bXBkVG9EVnhCVU1rdDZ1U3VZR0V2cXBPQUM5dlBxcDVGN2EzT2FzTEtIdDFW?=
 =?utf-8?B?M0dCbkczVmJuNEpVcWF4UWlxSGNINWkyNzlqamV5SHNSVHd4Uzl5aTFWMjA2?=
 =?utf-8?B?ZHpWZUowNDE0Z1VHT1BvbHJFRjYyREVPcXdrcHdkWjlCUitJTXA1SVphN2VT?=
 =?utf-8?B?eE9vVDRHZUUrQ2lDdHFFa3M2VFh0ek9YLzRVUmw3MGxGenNTK1ByOCtpOGtK?=
 =?utf-8?B?Nm9vRGVtejVkQ0wvaFhyZlBSTG1BZmU3TGtITkF0Q3JCdDNHK3NCWXdIdS9C?=
 =?utf-8?B?QWFZeTBuRmdITkJiUllyRVhHNFY4U0ZYTWMzaVVOYnZXM1NvcXNwNndHVkxO?=
 =?utf-8?B?MlF4bUJYaWJtQ2FoMWxndDcwNHNRakpPcVJ3cHZnRE1FQnFiYS84MXZuWXRS?=
 =?utf-8?B?YUlWdnRmOGY5aHlOSmJsNjBUczhCd1N6N2hncFZWMmdqdUtJaEcyRkVsMElq?=
 =?utf-8?B?UDFBcHRQdDhWMWN3UEZyVGkyRmxsKzcwOS8xYktlK29uQUJvMWVwMHhxbWVx?=
 =?utf-8?B?VXJlVFcxeXFiQ0J4V0VIcE56ZmdrZ001TDhVWVFwR2lvMzRPWkZGQzVLOXMr?=
 =?utf-8?B?M2dkSFlIS3VKb1A3WUQ3TW42eC92S1dMblJIaW9ZT0xlTFdtRXVtRzlVNEVu?=
 =?utf-8?B?a213TzByOXYxNUxSL0VabUtkSzRuQmcxa1VSeXk5UUt5T20vUWZEU2NQY2xm?=
 =?utf-8?B?ZkdjRkY3djlmUUZOVnFmNmplQTFIRVprczJXODk2SXpaaHEvNjZTRlZ0UTEx?=
 =?utf-8?B?Q3B0K0Y2Z285Vi9HUmV4eDJja0tVQzRRRmVaQ2VXRTV5MkZIcTlKUHZORXVR?=
 =?utf-8?B?YVhQRzY2TFdDVzBObkZlT3dvTGw2OWNQcjBhelJWWS9pbjBueW9vWHZiNXRk?=
 =?utf-8?B?cVRHbWd2TzhqNXlrM1JWS1dPQUtBRU4yaHM5WDhVa3JLandMa1hGKzdXNjRT?=
 =?utf-8?Q?Vb4gZWNFMurV/qdKjOaxp15/ndCwM4haXkfBePw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(7416011)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enZCNHFLMkdCbUNVN0ZmOExld3FCaVIrODRhcmx3dGwrbUdXNnA0WFpGdVdy?=
 =?utf-8?B?YVlJeVZkc2piWWhEb3hoRDlGdFRFWHJKaGI1YS9peVJwa2hkSHNjMmNZL2xW?=
 =?utf-8?B?VHBJRjBZdHBJL0Ezckp6MzVKczlDdzhTZGhMTEVJM2cyS2VBbDdHajBmZzNv?=
 =?utf-8?B?M0k1MVB1VCtmN2w1cVJYVmFwbHN6VzdMS0FPZS9nMEE5akZMbnR3M3ZSNW1P?=
 =?utf-8?B?WkpqL0hOaGZjZTNCZzBWUVdCdFlwQ3o1Nk5tWXh2QmtSclBsRkxEK3dKMTA5?=
 =?utf-8?B?M1VhTjF0KzZHT1M1TDNmeVdDWDF5UXFLUVd2SFZmcGx1TFl2V3lJbUVhMDhO?=
 =?utf-8?B?ei85dzJUUHdvdkpQVmlEcE5lVFgwY2kzYVJkSzhNdEkxZVRzeS9qbFhyOG55?=
 =?utf-8?B?YmFTblFWNnllcGpaYXcyV29Lc1F2R3RaWTdKZ0Y3RzN0MFZrdG9jZlVDcnBx?=
 =?utf-8?B?OE5zTzRhZUxUWTZMUFBXcnFUZjcyOCt6OTE4L0RUNHRjSDVkbDNXR0g3OVFp?=
 =?utf-8?B?OWQ0VityME1uQmRTTjd5QXB1YTF4Mmo0SXZwN2NRUnl4TERWTzBpeHZBT2E4?=
 =?utf-8?B?WFlMN0NweUFZUXFuemRrV2ZuRlY5RUxtTXZBNTkxZTZtbXllajAzcG9pMk1W?=
 =?utf-8?B?QTNMQUsyVkN2RDRKQ2NibDZzTGR4TFBXRk1tejZORlplUTdKNE5IZzM5dEpQ?=
 =?utf-8?B?YUo0WVhyNHo2U250ZVoxTnNPSzV5UHArS3hZZnB3RzE1Y2xlN2JGcXoxL0gy?=
 =?utf-8?B?TVRTWUJ6U2tjMzBNS084ZnFJSnRaR25nWkpLRk8xazhCdWRHUmdkTCtlNkIx?=
 =?utf-8?B?Y0FhbHB0T3ZjNWdraFZ5dGJkR1dYRjNCTGpMUklPS0lKcFJjb2VWVWRNUEgr?=
 =?utf-8?B?TGpKM0FYY1dJd2pqd3c2ZFBoT1hDeXlWa25tNHJLU1R1TC9IYlUvRzlTZHpC?=
 =?utf-8?B?N1pIWUEzaDNKb3pJTUszOWdnSnVhUE80RmtybHBZWU5majJ3ZE11S1JXcmlE?=
 =?utf-8?B?aHdaNFR3Nm9mTHdPNlh2WmxPdlVtYThZdmlXOHJQQWJZeTB6UStJbkVXVUU2?=
 =?utf-8?B?NGU1T3ByaVZ2eGZVYlhnMldNRzdNOGxBRUl1QjNWa21GS2l4QU5PS2pTamdF?=
 =?utf-8?B?amMyeXFkWUhzWEpKem91cDNPOFhlWlFKZ1NGYkFNdEZSWGJhNldlVElaQVJ1?=
 =?utf-8?B?Y1pvSi9XV29XaDNKWHVKS1NXUkpIYy82Z3Z2MjY2bkRITGE4TGdQdVdET0RT?=
 =?utf-8?B?WFNvejV6TEVOU2VLdG5EZmlJc0VEU2JVTGR5d0NJQng2ZVlwTVdHNFpIYmVx?=
 =?utf-8?B?M3VEbHA5R3E4SHRvZEhsRUxaS1dWVkRuUVZyVkFZVjBvOVZ6RE8wK0ZYV1BD?=
 =?utf-8?B?d01RVmdxcXRkcEdLQk9Ubzl6d0xFL25IUkhYcXpaZGlpSWo4alQ4R1BIOUxM?=
 =?utf-8?B?ZlUwMXQ4b3hMUHJRZk13MFpqR0Z3T0QzMm5vRlZLZlFkNWVwYkM5Y2l5eTNu?=
 =?utf-8?B?bXN0Y1JkYzd1UzhwRHo2bGpoUTllUVVLakRIcWlFOEticWFCcjJyYlVKSmFi?=
 =?utf-8?B?YXZYS0RJSVJXNFlaK2RzbXBGVEZUbm53OVZVMTNmSllHbHo5ajZGRnRMSUNr?=
 =?utf-8?B?T0YwbzEwQ3NJOXc5V1NvR3FZQ1g2b2NzOFlZaXF3OHI4N1ZWUTZGMy8wazA2?=
 =?utf-8?B?dHBxcWx0dm9NakhIWnlHeWRpN0tZdXlKeDB4bENsU05yaHBGM0hYckx4Ukh4?=
 =?utf-8?B?NzZvR05yR1R0N0ZKNkdwdCsrc2JReUlaQVIvTWFDc2lRcjVpRTZYR3ZaOE1P?=
 =?utf-8?B?bmJVWkREZGt1SUFQZitpYzlTOWx0Vm5MQzgzUWVPQzBiMXVrSWgyT2hlWGs3?=
 =?utf-8?B?NTdPbzdRaGxQMXRQY0hTTlNrVkNnZkhwSmFmNlB6cHF3NW1Lb1V4M1c1OVd4?=
 =?utf-8?B?NS9NNlAzREJ2b3ZTYVlDY0MzNnVXSFdIbDAybVhWeU9vbVhjUkF4TzhTVmZM?=
 =?utf-8?B?c2JxeWdVdUVUOFN5Uy8zSStGZXdNNlo0K2FYWTJWbU0wY2U0NHcwVmFXTFk2?=
 =?utf-8?B?ZWFWYlY5Z3ZHZ2xkVG8wRnVaaXYzeW42dUtFeCtPOXNhTHhtZlUyaXZSU0x0?=
 =?utf-8?Q?D1S4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d82d7cb-3085-4dcf-586b-08dc8c8eef7c
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 16:27:51.3227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODb3W6d4Iw5xkgGvZMMpLAPoTkSwy1Xz4bcUnVPESRsMf5hFPsx2c5P1so2Xy+1s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8136

Hi Reinette,

On 6/13/24 15:32, Reinette Chatre wrote:
> Hi Babu,
> 
> On 6/13/24 12:17 PM, Moger, Babu wrote:
>> I may be little bit out of sync here. Also, sorry to come back late in the
>> series.
>>
>> Looking at the series again, I see this approach adds lots of code.
>> Look at this structure.
>>
>>
>> @@ -187,10 +196,12 @@ struct rdt_resource {
>>       bool            alloc_capable;
>>       bool            mon_capable;
>>       int            num_rmid;
>> -    enum resctrl_scope    scope;
>> +    enum resctrl_scope    ctrl_scope;
>> +    enum resctrl_scope    mon_scope;
>>       struct resctrl_cache    cache;
>>       struct resctrl_membw    membw;
>> -    struct list_head    domains;
>> +    struct list_head    ctrl_domains;
>> +    struct list_head    mon_domains;
>>       char            *name;
>>       int            data_width;
>>       u32            default_ctrl;
>>
>> There are two scope fields.
>> There are two domains fields.
>>
>> These are very confusing and very hard to maintain. Also, I am not sure if
>> these fields are useful for anything other than SNC feature. This approach
>> adds quite a bit of code for no specific advantage.
>>
>> Why don't we just split the RDT_RESOURCE_L3 resource
>> into separate resources, one for control, one for monitoring.
>> We already have "control" only resources (MBA, SMBA, L2). Lets create new
>> "monitor" only resource. I feel it will be much cleaner approach.
>>
>> Tony has already tried that approach and showed that it is much simpler.
>>
>> v15-RFC :
>> https://lore.kernel.org/lkml/20240130222034.37181-1-tony.luck@intel.com/
>>
>> What do you think?
>>
> 
> Some highlights of my thoughts in response to that series, but the whole
> thread
> may be of interest to you:
> https://lore.kernel.org/lkml/78c88c6d-2e8d-42d1-a6f2-1c5ac38fb258@intel.com/
> https://lore.kernel.org/lkml/59944211-d34a-4ba3-a1de-095822c0b3f0@intel.com/
> 

Went through the thread, in summary:

The main concerns are related to duplication of code and data structures.

The solutions are

a) Split the domains.
This is what this series is doing now. This creates members like
ctrl_scope, mon_scope, ctrl_domains etc.. These fields are added to all
the resources (MBA, SMBA and L2). Then there is additional domain header.


b) Split the resource.
  Split RDT_RESOURCE_L3 into two, one for "monitor" and one for "control".
  There will be one domain structure for "monitor" and  one for "control"

Both these approaches have code and data duplication. So, there is no
difference that way.

But complexity wise, approach (a) adds quite bit of complexity. Doesn't it?

For me, solution (b) looks simple and easy. Eventually, we may have to
restructure these data structures anyways. I feel it is the right direction.

-- 
Thanks
Babu Moger
