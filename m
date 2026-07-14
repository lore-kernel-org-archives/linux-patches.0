Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDE13ECBD9
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 22:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784069151; cv=fail; b=krPkE0nJByzdmfrm9nlXx+fUJWeWslmdZkAlOkvytiSaHTATJF+lyErR9/ZtVsIhNMRgKXu/d7HqWoh2MhGg5Tio5V3o5gRMLpA3cpez4CtJpY/xRfa4OLEE+fp1DVP+8MlK9O19M+MraeCnSPzXZE/eAMfI87LZOANHMHmGZo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784069151; c=relaxed/simple;
	bh=78UAuzwLg4VdU5PCkTfAyr24liYVfTwtUjqWpBJA7U4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LES5BvDvDnumWpfi4o+rRfL1ruBiEsvl3BoVvp8ICel8U23A4yYI/ItZzUsU265WNxgEtP6pTJ99dfwmy3LKZREnerasvAqY4WoWxhD/+bQw6LUbrYAqU1sQdQWiFy7LkyZZse0aGvMVlcafVWV1hb+7G1CYnyM+0OAYnpOxacc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kYmCkHGK; arc=fail smtp.client-ip=52.101.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kYmCkHGK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DOXkamfzZULbJPXZ9R7ybCP6jiJF27VSNLD0WZK98pUK/r5AfNKaXKcI39PS4qQXkzOQObRVXXJ26Rc8xN6rrcvY+z5Tvpp66iJOMTmANGN4+S7C8YyanSrQ9zwscdG3k64UquH7RZGdE87jhD1/9WtILbIi4MBQzwKS/pl0EZXWT6FbL9FUErNJ2KfQ1nmfogdbAya+i089VKYENTTwO8ui6o7c4v1JjplhzavnnUQpZYTJG9TSdi0U6oVhbXKhyYQTtXOytgThiRJtN9hLvcVxj7YyEImaO2z+vtBCZIRiV1xv0Zh6DULYKz2jwjiopD/RiExDhp2OD3q8xAxoOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoFt2P8ExjKcnjzS/85Ux19mgmbDzov+slNWXRTRClw=;
 b=FvdYDOsMwGGflguQl/10xO7IVCqJQegalPneJbzjUohThDg2AORa+O1lwHg/I09VkXigT9xlzsvg7RbbpNPDJSvubZ39bWm3BMFZHPzjCSdfXTMg/Nra3FbaWhI42QjmsxhNszF6sbzcDnvprUOCOpoC7XZ5NJ+blvN2TkS44NqTN5QCaw0J1nn42mGKHihoLWfBS5Ym0Fl2lrtRGXvEAtSCyGAtRwjCRUgVCC1ZkuGqjSdFVnPRM7gucb+gjXPkKkU7lgzs+o/5Xz2hZ1ttB78X5fxIF5tfNWg26Io9M9BGHKKv2K0DlKiBi2+diigbAFF5pAJHzNKEa/qHimiG1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoFt2P8ExjKcnjzS/85Ux19mgmbDzov+slNWXRTRClw=;
 b=kYmCkHGKyEyKfqtnfks1bh40jE+uMLqUeagOmKTdNv2/26yYHvPokd8CZVax6UVoglIfcDvynop7EOWzlHLaY7w1x91iDdR2SoWWmvyGi43aSL7cGLbzzfsht1uxop23GM/rzmuh8rmw/1vNHkAUe0J3H5o5yOy3T1M+jF3+zTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by SJ2PR12MB9138.namprd12.prod.outlook.com (2603:10b6:a03:565::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 22:45:42 +0000
Received: from BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1]) by BL1PR12MB5320.namprd12.prod.outlook.com
 ([fe80::1876:4a6d:2cf5:b8d1%5]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 22:45:42 +0000
Message-ID: <88a6f85c-254d-4efe-ab2d-2ca41b05618d@amd.com>
Date: Tue, 14 Jul 2026 17:45:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com, fustini@kernel.org,
 fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1782857711.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:610:77::31) To BL1PR12MB5320.namprd12.prod.outlook.com
 (2603:10b6:208:314::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|SJ2PR12MB9138:EE_
X-MS-Office365-Filtering-Correlation-Id: 9089456d-8e12-4ee0-4fe3-08dee1f9a223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|23010399003|18002099003|22082099003|11063799006|3023799007|56012099006|13003099007|6133799003;
X-Microsoft-Antispam-Message-Info:
	pj7+G+gSnSiojXJgHDC9Tm23kdLskEZ8YkOYsVS0R7sT1wAsSGEc6Ad4TqnRUS5oN/Rfbfz5q6oDwD7ZpIKKlRhkdjgnxA2MzSJtf0/3F3WsAOdGGVj330hfIoF+NvNvUa7y2PsD/i9WKUCQR7bdI81Kw7pChqq2P0HiX1lzBQeuYPvHI+Q91WKZUMzjQPgbzEn7vlfiHmS4Ozz6zexFplmXXlNKjnDefRwYkrRxI5aMYoGdqi2DEaVtETKdFGsCz2npsu1+jBJkZQKJ9GMHJ3Cf/gc/Cm2mFM7NXUFsFzhiglAy4TAwlGDffybROdgYwW50lPr8Vb1hVycouQ6ZgUFcyzpRkoJiiE8nzY3crYpNNuKYD6g6VnBioxHnpVAGilEgvcvfRO83mEOtPk12gW1rDHP7zxlVt9gojw4CmrErdzhUn6ckNOaUbsDww9pe3UMSy1WMrbVl1QlVbhNoi6BZ5izZZqnU2JElRNzfeIeIUgdErXZTd1Lq4IDWRKF//EWeEz6Yr3v/olXHeAoVKkxuwMAubxI3Es1Y49I+hNEmcuJ0d4LHWL0o+P1/8f6F0cBBzuZ6wSRnm0TH03pdiWsvPaDE1b+wGVOuTBvD8OL3nVobuM3bZF2ad/MGNz9k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(23010399003)(18002099003)(22082099003)(11063799006)(3023799007)(56012099006)(13003099007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STcvUTZneVNWS0JIcUlaNjhvY09YQ2JEYllMdUhGSFhTbWxkcXRMODdTVVBS?=
 =?utf-8?B?VFVoQlFEUXYzWGRTcUVkL0pUdjFydGV6NDRFNmlyenJPZlRsbnhkcmxoNTl5?=
 =?utf-8?B?M0xhQUZHaGh6U1ZMaHpYZ0hHU282RHg1T2xKYUJHN2dZRDdLeG5ZeXpqZG1I?=
 =?utf-8?B?SVdNUEE2MUt2dUVpclV1Z09uL2pwenJjN3gzZWIrdUdsY0Q0TzEyNGsxN08r?=
 =?utf-8?B?cE4vZHVMT1h3ZjVwaDlmbUt0Zm5Rek1za1lrNDlOa2E2RzZOcDZxaVV0STFq?=
 =?utf-8?B?YkNXTmZIZ015c3VSWG43bDc0dnBIWGV1WVlZdDZ0ZFNJMVhrZ1lveDlEVGwv?=
 =?utf-8?B?N21ueWR3cG5iZUthaytNc0VuUUp1a3NudzRycFpsb0FXZTd0WEV6VW9ibWpx?=
 =?utf-8?B?bjhHOXg0Y3d2cThYQnM4cXdiTWUyZ2lyRmtHN2pKTEFCcUtoTHV6cmw2V3lm?=
 =?utf-8?B?MHhpQng0bUFqTkFSVmhaQm9yckQxRGVVQnAyYk5xNmc5cHhvSUhKalhmTUxz?=
 =?utf-8?B?d00zN0hJZ3FOcFdTWnM0SWpFN0lIY2tLd3FKT2JrWERtWCttaFd4MTd5U1Av?=
 =?utf-8?B?S1oyTlFKQzFtUitoeFZOMlBudmpyam1kRTdaVFVmV3pQUzIyWkJ4THBzYzRH?=
 =?utf-8?B?NDJ4MXl2YVJWdEU4UHdCa0RzY0syR0Q0Z0k1NmpPckU4cVBLSjJJMHZBVlcz?=
 =?utf-8?B?ZWdUNFlxejNhQytWSDdIcWl3VkRKMXNnYnJ5SWh6UTB4clk3Tk1jOWhlTmo5?=
 =?utf-8?B?M0NTNy9VTVVvaStMaitCTGxTNGk2U2RSNWdma3dZUE1oUmIxYTlGd0xtN210?=
 =?utf-8?B?bTlBZGduOWRGaS9IYWhSK0UxWmdYbFM0WDZBRi94TWlEQ3F2cDlBaVRYM0pk?=
 =?utf-8?B?cWVZVE9PUkRWTSs4Nk4wdERqdzBUZTM3bHA5R0ZrSmg1ZUNmOXN4QWFiT01P?=
 =?utf-8?B?aDlmNjZtZlh3Nkt0OXRmS0Zkc0Z6VDJ0YkVxSGVqTmNWRURvUTIxaGdwNytJ?=
 =?utf-8?B?T2VaQ2o5WlNoN2h0KzFwRFBWL3RmZjJBMVliU29MRmo1TDZKY0IxNVpPZVVU?=
 =?utf-8?B?cEdBZWM5SUhKandoQVo3R3R4eVVHZy9kaFNTa0xHUVZyU3RGT0VzY0RaYjVT?=
 =?utf-8?B?OXhGbWh3UU5KTXkwOUN0MGdGRktLWGJSSWszYy9EMGlDbnNXU3ZxVmRqOTBG?=
 =?utf-8?B?cmdRMFBIOGtRSDVHOGxsajdESDkwZTJrS0cyK3lzUm9PaFduLzljZzlGaFVV?=
 =?utf-8?B?RnVmNDlyY3RRdktBdXNnUFRpVGhlSlllcmFoNGxESFBpZmJTazM1U3l0Vi9y?=
 =?utf-8?B?d1lTMCs2c203WXJCZWdRL0lHd1Qzb0tKZ0xQM2VmS1E3bURGdzZoYWJZZWs0?=
 =?utf-8?B?dzJiL2JwUERHbHl0THNpa1dha2c5MHd3dHRhK2NZR1FGZjY0MXRkeTFkSVJ1?=
 =?utf-8?B?UHV4WmlNTzA3eExwSHpFa2UvS2IyT2NrcXI3N0M4L3ljU3B3NW5HOFJpTmN4?=
 =?utf-8?B?Uk5hVklSWU1IQ1pvcXV5OTBNSGRJSnFBcEpMc0t6bUE2aWZTU1k2bStCUXJP?=
 =?utf-8?B?KzAyTXBpK2hDUWl5TFc2RUU5NzZQbVpGTXFTRGJFVTFLcnJ5QVdmM1daOVhm?=
 =?utf-8?B?Q01lOEx3THR0OVc3dFhZY0NWNmQ3Y3FKNVJkVWxHWVhZaUprZHlYMzBKL1dk?=
 =?utf-8?B?aU02c2g4WFIweG9laUQwMzVqb3dNalRCOGtsSy81ajNJK2hYNTg5bkJRZWxO?=
 =?utf-8?B?a29tQ0VvZitWSHdHQmFSNUMvSWhTYUtTcE9nUG9zcDRmaW1kWEplOC9sRlh2?=
 =?utf-8?B?RFluVXhpMzV3L3V2TWsvUFFMcThnR1pTSXNQWmZmSVUzUW8yOUVIQy9OUTVJ?=
 =?utf-8?B?bFNlTHhqV3pYaFNudkszV3hGL1J1NUd0WHZGaFB6cCtlRHBoT2t1amlnREtE?=
 =?utf-8?B?b3k3TWRWMnRNMnVoWEdrUVNkSGo4WTFVUzk0WnRKVWdSaEFBREZXczBmTUhu?=
 =?utf-8?B?Z3ZmZXlOdjNRSFRTTjZ6THRVdnBFeDREZ20rT0JkRVQ2SmdmNjloYU5nTWlK?=
 =?utf-8?B?aS9qUjNwSjhGZXpOZGFxdDVHblN2Z2ducVBiUEFPV3hWdlNVZDIwRVJWSXVr?=
 =?utf-8?B?bUh0WEVPTTQwS1JxYXc2d1l2Y25iZkxzSGxnZWNKN1UzUXFQUjZFcHkxR1J1?=
 =?utf-8?B?R2JudEpkdTdKUW16SThkdDF5S3NnYlN6MGRBcXQyNlpIK01vSzN4cG8rQXEr?=
 =?utf-8?B?OC91N2VSQ1MwbWF4MlBuZlpRRWtYWEt1U0tFODhBaUs4VnJHeXRpWkw0dWR6?=
 =?utf-8?Q?rnnT07DEyTqwg0ca9F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9089456d-8e12-4ee0-4fe3-08dee1f9a223
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5320.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 22:45:42.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rujcYuUSl1RjYSpfCjXY0bSnsAlaurLXicxoBIHBFLhJcZFT/wC3lETizPmkPERM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9138

Ran few tests on the series. Looks good.

Tested-by: Babu Moger <babu.moger@amd.com>

On 6/30/2026 11:27 PM, Reinette Chatre wrote:
> Applies on top of v7.2-rc1 + v5 of "x86,fs/resctrl: Fix long-standing issues":
>    https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
> 
> Changes since v4:
> - v4: https://lore.kernel.org/lkml/cover.1777419024.git.reinette.chatre@intel.com/
> - Rebased on top of V5 "x86,fs/resctrl: Fix long-standing issues":
>    https://lore.kernel.org/lkml/cover.1781029125.git.reinette.chatre@intel.com/
>    A significant change in that series is the addition of
>    info_kn_lock()/info_kn_unlock() helpers to the info file handlers. With
>    the addition of locking to the max_threshold_occ_write() in that series
>    it seemed appropriate to re-order the last_cmd_status handling in
>    max_threshold_occ_write() to be after the change to last_cmd_status
>    custom to contain max_threshold_occ_write() changes to one patch.
> - Add resctrl filename to new error messages to disambiguate the various
>    "Invalid input" messages. (Tony)
> - Add Tony's Reviewed-by tag to all patches.
> 
> Changes since v3:
> - v3: https://lore.kernel.org/lkml/cover.1775576382.git.reinette.chatre@intel.com/
> - Rebased on v7.1-rc1.
> - Drop "MAINTAINERS: Update resctrl entry" and "fs/resctrl: Add missing return
>    value descriptions" that can be found in v7.1-rc1.
> - Drop "fs/resctrl: Avoid "may be used uninitialized" warning" that just does unnecessary
>    work to appease compiler warning that is disabled by default. (Boris)
> - Use pr_warn() instead of WARN_ON() in "x86/resctrl: Protect against bad
>    shift".
> 
> Changes since v2:
> - v2: https://lore.kernel.org/lkml/cover.1774043709.git.reinette.chatre@intel.com/
> - Rebased on top of tip/master with pending resctrl selftest changes,
>    https://lore.kernel.org/lkml/cover.1775266384.git.reinette.chatre@intel.com/,
>    applied on top to support testing with latest kernel that has pending resctrl
>    changes merged.
> - Drop "fs/resctrl: Use stricter checks on input to cpus/cpus_list file"
>    that ended up being too strict and removed one use case. (Chris)
> - max_threshold_occ_write() switch to guard(). (Chenyu)
> - Add more detail to one return value description.
> - Add tags.
> - No opinions so far on needing to update last_cmd_status on success of all read
>    commands. At this time last_cmd_status will continue to return previous
>    failure message (if any) after a read command accessing static data succeeds.
> 
> Changes since v1:
> - v1: https://lore.kernel.org/lkml/cover.1772476561.git.reinette.chatre@intel.com/
> - To simplify tracking, include patch to MAINTAINERS submitted separately:
>    https://lore.kernel.org/lkml/4274c478922c01f9ceebc805acf991f10a95519f.1771442788.git.reinette.chatre@intel.com/
> - Follow recent upstream changes to add reference to tip tree handbook in
>    MAINTAINERS entry.
> - Use new pattern in resctrl to enable looping over all entries of an enum
>    while making adding new enum entries more clear all while avoiding warnings
>    when compiling with -Wswitch. (Ben)
> - Add another last_cmd_status enhancement that appends "[truncated]" to
>    output of info/last_cmd_status if the backing buffer overflowed.
> - Please see patch changelogs for details of changes.
> - Add tags.
> 
> Hi Everybody,
> 
> This is a collection of resctrl cleanups assembled together for convenience
> and simpler tracking. I'd be happy to split them up if it makes review and/or
> handling easier.
> 
> Summary of changes:
> 
> - Let resctrl pass stricter checks from various tools to provide a cleaner
>    baseline with the goal to promote healthier contributions:
>    - ./tools/docs/kernel-doc -Wall -v <files>
>    - Build with W=12
>    - ./scripts/coccicheck
>    - Static checkers
> 
> - Use accurate and consistent type for all uses of resource ID.
> 
> - In the unlikely scenario that resctrl picked a wrong CPU to read an event
>    from, pass the error through to user space instead of claiming to succeed
>    and returning a (wrong) result.
> 
> - Since inception of last_cmd_status feature there have been mismatches
>    between resctrl file operation failures and the contents of
>    info/last_cmd_status. This pattern keeps propagating with each new resctrl
>    feature. Establish a new baseline with a new pattern that ensures
>    info/last_cmd_status contains an accurate failure description that matches
>    the most recent resctrl file operation failure.
> 
> One potential open:
> 
> There remains an inconsistency between resctrl file operations that do/can
> _not_ fail and the contents of info/last_cmd_status. If a resctrl
> file operation fails and an informational error is printed to last_cmd_status
> then a subsequent reading of a resctrl file (specifically most of the files
> found in info/) may succeed while info/last_cmd_status may or may not return
> the error from previous failure.
> 
> Ensuring last_cmd_status is reset on every read carries the cost of taking
> rdtgroup_mutex on several more user space initiated paths and thus increase
> contention on rdtgroup_mutex. I opted to not make this change and instead
> focus this work on ensuring that last_cmd_status is accurate whenever there is
> a failure during any resctrl file operation. Please let me know if you have
> opinions in this regard.
> 
> Update v5: The addition of the info_kn_lock()/info_kn_unlock() helpers to
> info file handlers now means that rdtgroup_mutex is held every time an info
> file is opened. There is thus now less burden to reset last_cmd_status
> buffer on each info file access. Even so, since there has not been any
> opinions in this regard I opted to keep current behavior.
> 
> Any feedback is appreciated.
> 
> Regards,
> 
> Reinette
> 
> Reinette Chatre (10):
>    fs/resctrl: Use correct format specifier for printing error pointers
>    x86/resctrl: Protect against bad shift
>    fs/resctrl: Change pattern used to track number of entries in enum
>    fs/resctrl: Use accurate type for rdt_resource::rid
>    fs/resctrl: Pass error reading event through to user space
>    fs/resctrl: Use accurate and symmetric exit flows
>    fs/resctrl: Change last_cmd_status custom during input parsing
>    fs/resctrl: Add last_cmd_status support for writes to
>      max_threshold_occupancy
>    fs/resctrl: Communicate resource group deleted error via
>      last_cmd_status
>    fs/resctrl: Inform user space when status buffer overflowed
> 
>   arch/x86/kernel/cpu/resctrl/core.c |   6 +-
>   fs/resctrl/ctrlmondata.c           |  71 ++++++++++-------
>   fs/resctrl/monitor.c               |  78 ++++++++++--------
>   fs/resctrl/rdtgroup.c              | 123 +++++++++++++++++------------
>   include/linux/resctrl.h            |  11 +--
>   5 files changed, 173 insertions(+), 116 deletions(-)
> 

