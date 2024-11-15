Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958021BCA19
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687605; cv=fail; b=JLVZqRYPz5eh7X2BOLeU9+DdXgylH0eQ/3MKeHZJQhljktUFYl+BS4MVnfhivF3aP0kpHZU7CL8wJA8OuwrkliWAqa+0OAsEBVUFLvfcD53pVWlLSh5S1lKzdCk2jVisD3l0rII8mO/upd+H8kDzwT5wtELnU2dXr+LHnsNE2G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687605; c=relaxed/simple;
	bh=EmrrSi3EIAWFZMZNVZINd+McxXa9KZmrPyinFVJ3DlE=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e167GK9PosEjNF6rr2TXT4RQhcZNqlibWczQXZDR8iTQh6APwvfzkd1FHPWW85EnYh+7jwN4at2xNul8Gnmja8U/US8o3mfaVrEE2WZdq3tsDDoTKaicvw4cL8fL/a/Nj9sxEQZg+IV2IsHBWYV/6M3gzb1xzM5ySZVw/1eHe+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OLdlDzQg; arc=fail smtp.client-ip=40.107.93.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OLdlDzQg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4mnS3TU0WodGWEVOMnNNlF47+Uav1mBis9Jm8Q1aavA7LI1N+YPBewVIKxK0WqQMUB44SCv7p03G1o5J1EWjyhRlrRuyedF30la7Xp8cOZ64/XPH2H2yJu412qeyXJ6UDvhz6IixMTtesXEVeJZdYBwVW8os0W/+1tHgATS7ZmbKOejQQvMHk7pQwaEezMbgSmQjLmp18vys+G1UPo6SWM0roE/4spKvY/bIPZehQOFH7ShSPamEoZgDwLh75i5evw1oLHVnMZeIvssPAivLThzU/Ni4VVppqf0vmNZQ6OJud5BXh7fdQnt1mq1V/Kr1QyEIHaLy3Z8iPWhroUE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge1aOkRDgZn8oEZ4bu7PYdQqJi/zlDQT3FFW/a2iNSE=;
 b=RUaQ8v5RttAuF/fjEv03I0dEO7eZlBxJ+6uLq2b+SUEEgXZdLPgYeiiF4UL0/7jmogn97HPmtqZGnAj1ITFel9Z53dcb83sCBTFm6DFzs0LNZ/yVVAv0e38qXRwkLppHhiPYbqFRn6rApN56g/pu88kRXU5vibbPGvS6cqPPZHhGhPq9oljTeEiOHfLNkelmPc0+AgQa5arr1EfztTdbPibDrXZPJrIZU+L7JxlxmBvup2D5KSedVOhmcDPc157EsJuQVGp1fyK9Tt/o3DBiItaFgIRGMLEw4gwjpcDVL6doolFWOULp6uwlwIGMGYQqbB5BE8IUd0M23VzLaUWqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ge1aOkRDgZn8oEZ4bu7PYdQqJi/zlDQT3FFW/a2iNSE=;
 b=OLdlDzQgPmv+QsWoZlZZTEjxUvuBYNk9vSA/lrkt2wAapBVQbgZZVIzbueRgFQd4BcQhbKJ1r+fbJ2792zTVgix9Mh8Ky9P4v6PHg3ICI4ytMZmqh8PMtU/vUAFAuZngTkWHIi2cZcVeR5MOrFMT+uAaEolYcDch/2qkNoBGTSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 16:19:59 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:19:59 +0000
Message-ID: <3d66b98a-2715-b17c-9485-c819a7bb0182@amd.com>
Date: Fri, 15 Nov 2024 10:19:55 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: "Moger, Babu" <bmoger@amd.com>
Subject: Re: [PATCH v9 1/9] x86/resctrl: Introduce resctrl_file_fflags_init()
 to initialize fflags
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
 <20241114001712.80315-2-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241114001712.80315-2-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:f2::16) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA1PR12MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: eeed76f7-0498-422e-1342-08dd059159da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGFjZ0IxZ3drY3J1NFVmbENkUXVrYjJVaEw0NVgvaWVYTnEwZSs3eFh3bjdX?=
 =?utf-8?B?cGxudVU2L2twRHozR0JtZXVSalNZZmorNmtLdUdYWXlUUW1sZzhJZm94a3hK?=
 =?utf-8?B?R05SMnFudzhsK1RFM1kwUU56MnNyM0Z5UFg2RWVMN0dWY1ZrS0lKYlR5VnFT?=
 =?utf-8?B?VlBFaXpGQzR6eTFQYnljZUhqK295TzBlNFErYld6N1Q1QzRVTWMzQVlEWTBp?=
 =?utf-8?B?SDNIYTFJOEhleGtaVGh5NzU4YjlJZDJJYSsxZGQydHVwQ3ZNWlN0SEpYRzh3?=
 =?utf-8?B?RjJrUXpDbDNBTnpBNjl6QWx3YllWOWsxN0gzbzNrSWphN0dKK3k2RGRUTFhn?=
 =?utf-8?B?UHlSRFRsMThBYURzM0dvSDc2REJpY1duaTFkMzc2Um9YbTZESWRwRkRuR0RF?=
 =?utf-8?B?Q3JWTHVQbjBNbi9KeU1GcU9oaUNaUTZLUlozNVVvek16ZENYakVLUG1vUkpJ?=
 =?utf-8?B?R2tEbE1KbTlsNitZRVVqZUg0eUdqZHBJdmdQSERVQkU5cjZPbzBoMVBGQnhF?=
 =?utf-8?B?VkRVem9oRmJUL0p4eE1ncG9GbnlNNktjaTFZdThiUXh0SW1CRUJzSnFGWnJJ?=
 =?utf-8?B?UzMwL2RUTWUrY1g5TklpVitVb1Z6OTR1UVR2anl0dDgySmg3SVdzeWd4ZEVO?=
 =?utf-8?B?MW5MNmtoMjVSd1RZRFNMMWZsdW56aGxTVUR4OU9MSlgrYkF2aVdxZFVOVzd3?=
 =?utf-8?B?eTBXMW10UFBwQ1FiODJtaUI4MUJZZStBWkVMZXlPWGwrOE9WYkdqaHlPZHUy?=
 =?utf-8?B?RHdsaVAyOThvc2VrQjlXalZHTW5KU2NPU20yU1RFWWw0SjdRWEFYL055Z1Bn?=
 =?utf-8?B?VXNkdFJ5SGQzakllS05INVZSN2lUQUY3cFpUdzU0ZmErclQ3MWJwYm9DRGpU?=
 =?utf-8?B?YnNCTWl4TUpJMUNOdk0veUFWSGdRVSs2WE1GOEh4ckU3OFhGTEN4ZzdjWmJr?=
 =?utf-8?B?dFBGU0dPaVYvTndESU9TYWpUbkZySTY2elZKTjBLQkZmNE5VSFE0SldXNDMx?=
 =?utf-8?B?dGQ1RGJkcUtGV0FtdjYzUnhiNUc2M0ZDMFJKZFprR1ZUakZ5bXJBYm9ZOXN6?=
 =?utf-8?B?cERPS1I5ak5tRW0zTm1GeU80cVl3ck5rWWhraENNbzZvbzNPSThyS2tTbFFK?=
 =?utf-8?B?TUdIdFd6ZTA5b3hEM3AwdVdYQWtkSnVXQmNJRmRlVFBya1JORlhHejNGN1gy?=
 =?utf-8?B?ME42aHkySXNwUzEyL1JBeXdSSDlPQ20vRFI5TEFtSDBWdUwybzNhTkMvcXZz?=
 =?utf-8?B?d3R5Tk5WVlJOblBDdUYwdmZ2OTJXbmxYZnFzbXd2N2pTNmtsVVBhS3BzQXRI?=
 =?utf-8?B?WVJxUGp5M0J4eVovV0JVUk8vcDhGbXM3WHFIQ0U3T1o4MHRNRDFtRzRDTjJV?=
 =?utf-8?B?amIycXlzbktIeVpzWHJPRFhiL3A3Uk9PS3h0UTIzQS9ZSmNTS3MzMmxqcG5u?=
 =?utf-8?B?dVhBbTBHcndaUGJFaTRTcTAwQUZTRTRPTWZBNGFZTStTMjZON3lJUXU3S3BW?=
 =?utf-8?B?TU91SUczcGJhRUNxeE14Uy9DaWVPL3ltKy9PaWFIYkUyVjZLaHE1QUg5QWdo?=
 =?utf-8?B?UmYxenV4K28wQTl1aVdIajdwdVhoSEpZSDBnQktLUEd3YjhWVjRGc21DUmlS?=
 =?utf-8?B?ZGVpSzkwUUpYcEw4UEU2QkRUMldPbVVVYzFqSGxlejJaWHJyTHJmZ0lQeUJ0?=
 =?utf-8?B?YTZXYTRCZEF5ZFFYN0JNUDJ1c2VLNWNqMDJxUUtYd3luOWdsN1RGM0tNNUZE?=
 =?utf-8?Q?nLwVOMxYy8J/6PSKyO/qw71IXIpa7GEyp/mQI+O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnRjVldjYXpIamVaTGFZNDRRdmg2Qy9BVVZwcUdwVjN6Nll4bDNrQnBNTUdt?=
 =?utf-8?B?Zk5WMFNwNUc2cWN0cUZ0UEJ1eTByeTR5bC94Q3ZFMVBhNnJvTHNZWmRFMldx?=
 =?utf-8?B?NVQwd0dmakhyVFVQMzl1QjJDWFNEelBtM1BNM3JJTGJsZVlvQU1Vb1I3THVj?=
 =?utf-8?B?Mi9qZm9PeWVtRlBTQ0ZNYU5SOWdJblFPR2tLMjZnMmNQazdOZG9TUXh3UGhO?=
 =?utf-8?B?MjJhSDlpNmpTS3FRTlduRVQxQ3pGL25wWkVoT2lVeUdESjczZTNUK1ZFZXJX?=
 =?utf-8?B?VXRaS0xiYUtybnB3cnVUdEFUSzIvU0lvdW95RFhmL2JLSXRxN0t2WkFqVXJE?=
 =?utf-8?B?djhzQnN3NWdCRFFFTnd2Rnl2UlJURkJYMjdPY2YvTDNrK1F6YSt1VG81S3VO?=
 =?utf-8?B?bmVXdmQ1UEF3M3F3alViZS9zRXBmdGVmeWE1RGY5TnlkUlprcXYvZmRDdUh0?=
 =?utf-8?B?NHJFSHFjd1dIYWZxRzJGcVlicUpUM2tLRzFmUHZkOVVqYkZpWTJhS014Q0tt?=
 =?utf-8?B?Q1JVblBWaExRSzYyc3l5d3NTZ0FUYjQ5YzcrN3V3aUNsY0xHb1ZVeVE4L0F5?=
 =?utf-8?B?alpwVzhIdkFyQnIzUnlwbnpOcU1mbVhUZGxPUWdha2ZUTXdlNUgvTlRpdkgw?=
 =?utf-8?B?S1ExOHgxb2FSV1g3NVhXTTh4Q3hER2NoUUI4dFdwVGpteisxM3NBN241Rmgw?=
 =?utf-8?B?ZDdxQk5QbExOaENLM2FRK0F6QUpSaTNHSGJmVER1Ky95OU5zZlUzVVZHTzQ0?=
 =?utf-8?B?RlRFZ2lUZVZBeHRVZDVrQjN2OHFCL0R4bFpEQ0JTL0V6azV2Wk9UNWpUa1Ns?=
 =?utf-8?B?aGtRSHIvOG1Ud2VFbmlSaEl0N2pVT2YwWVhmdTg5ZHJpNi9nNGJ6cE9BV05k?=
 =?utf-8?B?RXh5bCtCQjNmRHcvbHRvSmJvQlJHd3R4RWw2R1pvaS9hNlNicWlaNVZTazhX?=
 =?utf-8?B?bnN5NEFRRVpZZSs4OTQ4MVMydkRMODh4VUFjcmlSQll3QUdERCsrTnhZSWRk?=
 =?utf-8?B?NTgvRlZqUWFGR0llbFFhTVBiTXIycDJuUTZGQklKV21FZmJndEhrNmZhR2xP?=
 =?utf-8?B?NGt6bWo5VWlYNUpaNjRiTDNuV2hpVzVxOE9MaWkyajVXV1RVYTNFL1phVlVD?=
 =?utf-8?B?TWU0UnRKYWJreCtIZ2RLelVTeWhDUmNmbis1bGFqYTgramllTUVSWFdGRHl0?=
 =?utf-8?B?VkZKU1ZPWmpCV2pmS1lCRjR2QXFqdnh1cFlxSGNTWkY1clluSUtVN1VyZVVv?=
 =?utf-8?B?bFRpM1FUNE4zRUZiSnR4MjJOdkkwOWoxZ2ovRWZybmg5UUtGeEp5T0tad2xM?=
 =?utf-8?B?a09TeGdxRHNVL1hpQUhSMmFacW1SbzB6MXR0QlJWWS9qd0xXM3dLQXpQY2k0?=
 =?utf-8?B?b0JPSXNPVkRHRURzRWk5N3UwUjdWVmVwRFB4NnZHcHhzZnZxdXV0YjRaSFVL?=
 =?utf-8?B?QTlxQkRsTlN5N2JhVnc1SDJEcEF5OC9leWpyTWRqbVVuLzAxR2pUZUE2SEpG?=
 =?utf-8?B?Vlh5Z29tNlY4endQUUZZVjhpcFE2VDFyLzl3OVA0ejE0cGpuMXRpSFVNSkFl?=
 =?utf-8?B?aUxpa2VCS3RtVWovYzM4OTBxM2V5a0NoK2EzSzZ4cDdzR3MrdGtvTXBucEpa?=
 =?utf-8?B?UFJzYXE2UGVxUnVzMHRKUDFyV2xXYkpFK2tiV01JNndUTiswRWtNM1g2NFZB?=
 =?utf-8?B?VWFkSUVZSmVLdzUvZ1ZOMUNIWHE5SzdrVEhNekdWUExrc09yU0lJSlJuREJ0?=
 =?utf-8?B?R1lXdmdFTGxlY2pBbUp2Qm1Sb3NpK05iNWdKb2ZZeDAvd3NvSkJCQk9OMDY5?=
 =?utf-8?B?T3JEWkZzYnBnbkRYaitlajhJUHl5VXg2TDc5WmdHTFVuOXZWZk5xd0VybXkv?=
 =?utf-8?B?R0xHMjYweU9NeEV2VGFZejB4bUJuNXBoWlp5MytId3dDRGlnUGh0cHgxV2Y5?=
 =?utf-8?B?enp4WEM5SUhYa0RtWkROYnh5OUMrOUVXRm5xWXBzUTFkSWpZRHgvZkFJQzlX?=
 =?utf-8?B?RUtNak1Pb3p4bkwzZVRZU0FRY3pkd3Zqa0pielpvTWNxTnlJL0NtTUhsMlNG?=
 =?utf-8?B?N0tndE5wQ1BrTG9Gekw3TFNvU1c5OFBzcWpoVHd5Rnp4cHlDaWp2UGFSTGNJ?=
 =?utf-8?Q?byyk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeed76f7-0498-422e-1342-08dd059159da
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 16:19:59.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkKb6/c8Bc/JwC4860dLgpgY/ZTl7qiWBM5Bbnk5ploglsDgWMjGczIUWyvF2k6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258

Tony, Looks good. Thanks

On 11/13/2024 6:17 PM, Tony Luck wrote:
> From: Babu Moger <babu.moger@amd.com>
> 
> thread_throttle_mode_init() and mbm_config_rftype_init() both initialize
> fflags for resctrl files.
> 
> Adding new files will involve adding another function to initialize
> the fflags. This can be simplified by adding a new function
> resctrl_file_fflags_init() and passing the file name and flags
> to be initialized.
> 
> Consolidate fflags initialization into resctrl_file_fflags_init() and
> remove thread_throttle_mode_init() and mbm_config_rftype_init().
> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h |  3 +--
>   arch/x86/kernel/cpu/resctrl/core.c     |  4 +++-
>   arch/x86/kernel/cpu/resctrl/monitor.c  |  6 ++++--
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 15 ++-------------
>   4 files changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 955999aecfca..faaff9d64102 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -647,8 +647,7 @@ void cqm_handle_limbo(struct work_struct *work);
>   bool has_busy_rmid(struct rdt_mon_domain *d);
>   void __check_limbo(struct rdt_mon_domain *d, bool force_free);
>   void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
> -void __init thread_throttle_mode_init(void);
> -void __init mbm_config_rftype_init(const char *config);
> +void resctrl_file_fflags_init(const char *config, unsigned long fflags);
>   void rdt_staged_configs_clear(void);
>   bool closid_allocated(unsigned int closid);
>   int resctrl_find_cleanest_closid(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index b681c2e07dbf..f3ee5859b69d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -234,7 +234,9 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
>   		r->membw.throttle_mode = THREAD_THROTTLE_PER_THREAD;
>   	else
>   		r->membw.throttle_mode = THREAD_THROTTLE_MAX;
> -	thread_throttle_mode_init();
> +
> +	resctrl_file_fflags_init("thread_throttle_mode",
> +				 RFTYPE_CTRL_INFO | RFTYPE_RES_MB);
>   
>   	r->alloc_capable = true;
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 851b561850e0..7ef1a293cc13 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -1223,11 +1223,13 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   
>   		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
>   			mbm_total_event.configurable = true;
> -			mbm_config_rftype_init("mbm_total_bytes_config");
> +			resctrl_file_fflags_init("mbm_total_bytes_config",
> +						 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>   		}
>   		if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
>   			mbm_local_event.configurable = true;
> -			mbm_config_rftype_init("mbm_local_bytes_config");
> +			resctrl_file_fflags_init("mbm_local_bytes_config",
> +						 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>   		}
>   	}
>   
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index d7163b764c62..2b198ef95e1e 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2020,24 +2020,13 @@ static struct rftype *rdtgroup_get_rftype_by_name(const char *name)
>   	return NULL;
>   }
>   
> -void __init thread_throttle_mode_init(void)
> -{
> -	struct rftype *rft;
> -
> -	rft = rdtgroup_get_rftype_by_name("thread_throttle_mode");
> -	if (!rft)
> -		return;
> -
> -	rft->fflags = RFTYPE_CTRL_INFO | RFTYPE_RES_MB;
> -}
> -
> -void __init mbm_config_rftype_init(const char *config)
> +void resctrl_file_fflags_init(const char *config, unsigned long fflags)
>   {
>   	struct rftype *rft;
>   
>   	rft = rdtgroup_get_rftype_by_name(config);
>   	if (rft)
> -		rft->fflags = RFTYPE_MON_INFO | RFTYPE_RES_CACHE;
> +		rft->fflags = fflags;
>   }
>   
>   /**

-- 
- Babu Moger
