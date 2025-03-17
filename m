Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161D2451F0
	for <patches@lists.linux.dev>; Mon, 17 Mar 2025 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742223307; cv=fail; b=KA025qMZn9nKrnXLACCEWzy+cc9Ag2JvQbOEZ5IWNRbrqhwITr/QpRfgtWDreH2iPC+/6wWgN1dt2r9VIlkBpgYAGVwrtKpxYdhXy3dusC4Rwc31iMeTv2A3Xtx9NGbDVbpuOOZVBjQrmL6zaUB1cO5iHlpNrAk2z3PNELa/Sp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742223307; c=relaxed/simple;
	bh=9OW95KOnCkb/6W9VOCKM5PDwSrQvVIjdLod5/3ctiVM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JeJNEZ2r+mvr+yJ0Zu5uOOsy2xrE8LVuq82CXifj4ZyTIsZYVRBhHFkG60rygQScGVNx42RZEhB6kVcRhJJV1ydIW1n1A8aZbg95xMIxSGhBrJil6prLUxDqlZrdF7CrLJ9GSurGVLPUWE5+iO1llBGWvara9MprfS6WGF71ato=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xmLihGxs; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xmLihGxs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUM4q3uPrY+uem4lRM1386A2lVJP5dYktiA/3dIQIabyRHJKD3xePBU9cbQX492skcf7/aownbCN/EEarlc9qgCoKaX+NDCrGtGhouH+KvsaiIXqONBiJg0Wl4Fhy+HAU4uyJh98jS7lh8g557Z44ykadZcxR+ftKhklk/IEoQfpCGyv7ILbAP1rYul9aladwn1fyNzQvbAA1EabvGKQUnnR7P2Q66lMUAfp9WKjMXPooDD20wHyaEs5HYXCx9H9PdhoZ6UhT32JnLqMKMTva+U2ivgG6Z6v7KkSyHHUlmxHbv/uqXOmvdBcPUX9v9oY+UIflGd+8oMXSefnLjm7iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UY0cFrHCybx5mwMDU8SfY7lfikLXeyim83RC9g+hXo=;
 b=ajgANIc6Db11PoepTZqvBZa6TduBGZ48Ftx/7phHc7R5Pjxnwsj2nl/wj4XgCLn9u1fGDxcZgwBk0c4JZI2mdr+Q5x2mf8lOPJE7Mc0RYOKbHqGnLYakHx87OeLVZF379LxTfjvJQd8wg5ENtdE+NG10AeTN0MTGgDVL9CiUetUqhxIsqQ1KXeKplwntgHi05XWkw8SRbT8Zff71ABMSmS3YJEmSBM0MNY7omSBeBeCqFxdseDVpJ/T4z1u0l64RQdfw+EYZTgXpak+uXCVVpISY3atU8cM+yIUvGeLmqDjfK3UkV4olwM1lXAONwWnv23hj9SjMxYNME0xB4F4gMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UY0cFrHCybx5mwMDU8SfY7lfikLXeyim83RC9g+hXo=;
 b=xmLihGxs0cdXizZhPqtyBc19EOGPkDl4+Wepl3mcOLR7E5wp8ACyngxVaAfvPl1n+dPf6cB5sekimZMZKFUCUlR3Fd0VBB2yw2kngxR+exXyARvRKyNZUWNtI98XkcTv9tXy9zb31RqGze1kLT6tuV+rfMlxuuNYSqNBapyhGIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MN6PR12MB8568.namprd12.prod.outlook.com (2603:10b6:208:471::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 14:55:02 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 14:55:02 +0000
Message-ID: <d4263bf7-9bd1-447f-976c-69fd96d3f204@amd.com>
Date: Mon, 17 Mar 2025 09:54:59 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH] x86/resctrl: Refactor to make adding extra MBM events
 easy
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>,
 Drew Fustini <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20250314202609.5753-1-tony.luck@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250314202609.5753-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MN6PR12MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: bb93192f-b8f5-4ee9-5224-08dd6563b229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2d3bnZLbGxvS3pNenRLRVByNkR2bXB5UkIzL0xvTUIzVGx0c25XNnVxWTdH?=
 =?utf-8?B?ZVEwTFhoYjRwWk1lVzd3OGc0R0EyNjZuL21uQnMwN0FmTCtDODRHS2VnMklM?=
 =?utf-8?B?bWVtMGFtSTBwaFZRdlkvWXdFQW1iL1dHNnIxZ21UL2NZYm1id085RENJNi9m?=
 =?utf-8?B?b0llYm5pM0VjMWduV2NiUWw0SzlrWnhlOE5QQmlCdGVENFFYR3p4cEc1SFRy?=
 =?utf-8?B?L2s5bmNjKzY3RHRjL3M1OVJCMWUwRStzR2lPS2o1R2YxcVdwQ1dWbWw4L3ZV?=
 =?utf-8?B?a2lubDZJN0Q2MnpjRUI3T1p4VFduVWptRHQ2dVk0TTFlWFdXR0YyUGVpL3lh?=
 =?utf-8?B?QUdUWS9QWWlZR3g0OWZ1M1M5M0h6elZyZDJuMFdBYzJ0R0VyKzRFTjA4bktN?=
 =?utf-8?B?Y01JMjY2c3RIeGxkdTV2RXR1MXlia2ZPVkNxb2NqbGliSDVBRk1raDREaXhn?=
 =?utf-8?B?S3RHYnE2dXNtSjR6OEYxajhidW5ncmxrYnFTZFdXbHQyVXJXeDFxWXZqY09J?=
 =?utf-8?B?anMvZkI1bkxKMnZOcTZQUVIxZXc4ekxPU2FVc3d3RHVqQUZuYWpTNzA0cXlE?=
 =?utf-8?B?QkJoWVkvVDNSUkpGSFQxaWlOL1RFN1Z5SW5uOGIyT0kyRW9qK1RtWklkNHZP?=
 =?utf-8?B?eVliY08zeWR6TWRMY1FYbEcrb3RlMWhjcWlIMGpJZmpvL3ZQWm5SZG5icUs5?=
 =?utf-8?B?OEUyYmEvdGdab0J6NmFtaElGc3U1ZVdzSlBSeWVMaFlPWDVxMFViUlh4cUov?=
 =?utf-8?B?MENiN3lHT2NDclZrc2hzeGJoU3VlbWVBRld4OXdpOGhUU2ZTc3JYVklMQU55?=
 =?utf-8?B?c0JMYitmbFA3U3BMUHFwU2Y3UjkvWDRsNkcrclhqalowekxWajFwSzRCVFVD?=
 =?utf-8?B?VjdHZlFNUkl6OXVtQ015dVRScDJzU0dYTmh1eXBMYVljeFhzdnk1ZWFYR2dL?=
 =?utf-8?B?b0lPRHFjRXQ0K1d2dS9TSGx0VXkxVVV5MlZ2YzNxbFJSaGxxdnpzT1hxQzBl?=
 =?utf-8?B?V1ZkczBteENOV1RCUzhhbTdsUVdFaTk2ZGtFQW9IWmxkbVBJbnlJUmlDWExh?=
 =?utf-8?B?YVhUUnplNjJWNm1mQklNR2xNSktWM3ZUblI3YWtDOHFvaHlwK0RnUW5rc0pq?=
 =?utf-8?B?bGozY0h3YkwxR054R1RnUzRITUhKMThtUzQ1SnZhbGNmTjJTclpzbSt1bFZm?=
 =?utf-8?B?RCtUQkx2MFdJVU1CRXF6dStrMGZHdXJYRm9nTitQbkI1Ti8rdmRPUFFYZzVO?=
 =?utf-8?B?bWRLY0ZwT1ZLMC95N1gwYTdUS0kyK3JSSWZnbFRvQllibW9HSnhCL2hRRUNn?=
 =?utf-8?B?SHFEcXlwZzB5U29iTEQ4TGdrK0NxSk5zTlRRa0tuZUN4N2Q2WUpxTHdvOXVP?=
 =?utf-8?B?d1Myb1NLb3A5dkdCc2J1a2tVWDhKbEpscVpCUnFVaUdpUmtjRmxwT2c4Z0dQ?=
 =?utf-8?B?WEJrZU8yTU5peU1rWXd0YnZudkJ3aW1sNjArOGpEKzkrMVJibCtHNjdrTE9a?=
 =?utf-8?B?Rjd2bUFXSkpWQ3pQVXJ6d0E4RHlTMzdIdmIxdFF1bU1TWjBLN085UVpSVDR0?=
 =?utf-8?B?SWNTU1pGSTRteDlibVhJRWNEQis4UDcxeHMvNHZKcTFTZlJiS3RCRjdITFAx?=
 =?utf-8?B?Z2JPK25YbmpjUXlRZ1lWOGpIOUhXYmhRdlA3U1l3WVNVcTliUXExc090bi9s?=
 =?utf-8?B?cWdoL2ExQlNsUk5LMThRWmc1ZTM4NXBDcTJiRlpzRWN3OVRoUWxSK25BRGlu?=
 =?utf-8?B?NjVXOTU3V3N3ZW5NZEJkOUdnc0xSbS9EMDBTRkZiM0Z5RFVhVTZwenUvQnpS?=
 =?utf-8?B?NDFhSy94bnJxQTlYaU9hUC9PaHgvZHFoMTg0WW9ESTB3Y1JGQXdUZXpubXFT?=
 =?utf-8?Q?9ZsS82iSdwIAj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1M1ZXBkU3RvbUZhOXJndjV6MlVNL1ZKVkhTQmtaTlFobXJXdkNkTVlvc3Z4?=
 =?utf-8?B?MU95UDVzSkNwdkl2N0hhbm1KY3l0aTNIK25RK05ocm1OaG9EZUFrS3BFOVNV?=
 =?utf-8?B?dVFRN1ZjeTUyYlU3aTNFYXlGSWxQRFdXUkpxM0pzZE9TaS9CV0gwTzJ5ZkNN?=
 =?utf-8?B?elBMQ2V1ZXRaRjZaZHpTNGQ3MUU5Z2ZvMjgrbytpemIvdzdyUXhScUJybUVt?=
 =?utf-8?B?aC9Lc0ZZN3d6aExpdmhpS3N0Z2ViTng3RHZReDFYVmxaaENUZHdoT1M3dGFG?=
 =?utf-8?B?Rm8rdmRjelMzRVQwYlllbE83WHh3QjdMQStYYXpXOWhlMm1LUkY0UTZxQk1X?=
 =?utf-8?B?eWJaNzZBTHZvWlpMT2lkZDNMZDBoUTFHREw5T1ZmbVRDNmdYYllMMHNDRmZJ?=
 =?utf-8?B?QzluS2s5cGFqeW50NEFvWWJpQVlCZWszZG1INTcwRVEwWUpYNHhsRjJ3NW9O?=
 =?utf-8?B?dmQvVkM3SVNzUk5qeWxZbnRhMFlsZXZFd3MwOXNscHl1bkJqdVY4SGhSNG50?=
 =?utf-8?B?bEY0TGNzNXlaL3hUZmZOSlpSbmdhT3FoenZVTTVhM0FwRStoQWZwUTFGdjVE?=
 =?utf-8?B?YWZkWDBKc0RDT1JOdUltcmpjTFpZT0NsVkNEM2VzS0xBY2RDNjc1WEJmZG1K?=
 =?utf-8?B?VmxjcVh0Ym9UeFpmdTJ6R1BweTN4UFJOVlhQRkF0TnZZYmlkTS9ja1dBQlo4?=
 =?utf-8?B?ZnBmWktWbkVIVSsyWUlYWjlrQjNmWlh0ZWRxK3lNYjUySDliUStNWmtoUk5l?=
 =?utf-8?B?aVNQUGkwRFQ0Sy9oeTUxMGRPajlDUTZxQlhwUmo3WlRjandSdXN4WUJySmJk?=
 =?utf-8?B?VnhuTkRGdWNrdzBRd0ZJWnFYakVndTBjaWphbUltaytyUmMreFhzVHB4R2hM?=
 =?utf-8?B?TU5XT05YUVJ6WkgyanJHVUhWUFpzRWFIeDA4UjVJVmc1ekdOSXVibmZUMTRN?=
 =?utf-8?B?YU0xNGg2a1hFSTcrclg0WnI2TXBzODhMdzhFSFFrK3NIN01ZVlhiVjJxRStj?=
 =?utf-8?B?Wllka1lNYi8vYzNWSjZncW1PSDd4QnYxZ2VjTFRQVlV2SlpPMFF6cDFHSEd3?=
 =?utf-8?B?S1ZNb09mUjMwNWFFYWp0cjRrakoxSERDN0VLVzlSRFovT0VuRTUvQ3pKOWN2?=
 =?utf-8?B?bEFwa3AxMHhicmR6TlB2cEhIWk9ScmVtKzBsbTRhbWNUak82a24zblBGbWdW?=
 =?utf-8?B?cjFpcTBJeEtHb0N4YS9Bb2UwS2ZqOXZZZDd5ZThpUFE2K1BjT2pqMkliakh1?=
 =?utf-8?B?YjVYa0tLL1NQZ1VtbWE0TEhVM0NjRmcwZUlNbkFSdW94WElFV1VmTkZkLzVx?=
 =?utf-8?B?b0F5c0xqQTliSHg3SHFoN0hsVFc4OFZqZExjRFBRK2ROSHlFTytTbW1vblBh?=
 =?utf-8?B?NWR3ME1DdjNwdWlUcVVnT2hDRDJIRG80eHpNTllwSm84ckhHUWlaUUtqNjJh?=
 =?utf-8?B?a1VRREJSTWlieENVY3BIZUhtYktJR05RU0Jkd3BsWWpYS1N4VkFodUpyVVhQ?=
 =?utf-8?B?YlZQeDQ0QnVoVmwrcVp2enpTSEZDQVVZbU9FeksrNHBLa0RnQVdiN2FaaEpq?=
 =?utf-8?B?QThxMXhSR21JbnFvSkRvdWU1cy90aThCQmNNeTYvRWlCZmdJYjhnM1VSNGtU?=
 =?utf-8?B?bExwaGFLZ0pJNlF6ZkpkNXpYdll3RU0zaHFGMzQwNExJbkxHWGw1bVRKWElY?=
 =?utf-8?B?MEJPckJYN3UyOUsrczAwNTB2TWVZY1BXWFBFbVd2VkxydVYzQ056UkJaQm9Y?=
 =?utf-8?B?aXpyZllhTkphU2JyR1FNZDJOYzVnc3RxWEN6MmtJYUpBVEFxVnZSa3dmb3FO?=
 =?utf-8?B?dldQRjRqL3lPeGxyVWx2dFFBREZMMmVZQlVqcUNteGRSOWdSWnFKa2R1KzQ0?=
 =?utf-8?B?VVBWREk1VG91aXEvZkllMGExekV6bWVYNEZ3Y3JDV1BCcnNiOHZ6VGEwRms3?=
 =?utf-8?B?UVlGUTZSbytYQlpBd01nb05kVC9CV0NxeVhXZFI1bHE1V0hIVDUvVnU3WXpM?=
 =?utf-8?B?b2txNk5DVUMyS1BJTzRCOVJoa0NhQ2xoRkFCam1FN3cybDVFTWlSd1VBTm5L?=
 =?utf-8?B?SnZReUp4a2d2UjlDYTQ1Nld6R0xxQzdlcVlrUmF3dEN0czhqT3lIZFhiSjVE?=
 =?utf-8?Q?nlvk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb93192f-b8f5-4ee9-5224-08dd6563b229
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 14:55:02.2831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hy6+q614MONslaVJ8CB0iznvvsnoT/WUPUW5Bik4ZTZpfxVAKUOmEZEzTS+k5nw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8568

Hi Tony,

On 3/14/25 15:26, Tony Luck wrote:
> Preamble
> --------
> I wrote this to play with some experimental MBM-like events
> that may or may not ever see the light of day. I'm amused that
> this refactor reduced the number of lines of code by enough
> that the patch to support the new events basically just got
> back to parity with current code size.
> 
> While the resulting code looks cleaner that the original, I'm
> not sure there is much motivation to apply this change at the
> moment. Just posting for casual reading and to archive it in
> case I do need it someday.
> 
> Based on TIP x86/cache.
> 
> Commit message
> --------------
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
> 
> There are two MBM events and resctrl coded with a lot of
> 	if (local)
> 		do one thing
> 	if (total)
> 		do a different thing
> 
> Simplify the code by coding for many events using loops on
> which are enabled.
> 
> Rename resctrl_is_mbm_event() to resctrl_arch_is_mbm_event()
> and move to <asm/resctrl.h> as it gets used by core.c
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                   |   6 +-
>  include/linux/resctrl_types.h             |   2 +
>  arch/x86/include/asm/resctrl.h            |   8 +-
>  arch/x86/kernel/cpu/resctrl/internal.h    |   8 +-
>  arch/x86/kernel/cpu/resctrl/core.c        |  34 ++++---
>  arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  41 ++-------
>  arch/x86/kernel/cpu/resctrl/monitor.c     | 104 +++++++++++-----------
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  42 ++++-----
>  8 files changed, 108 insertions(+), 137 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 880351ca3dfc..aaec3083db46 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -147,8 +147,7 @@ struct rdt_ctrl_domain {
>   * @hdr:		common header for different domain types
>   * @ci:			cache info for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> - * @mbm_total:		saved state for MBM total bandwidth
> - * @mbm_local:		saved state for MBM local bandwidth
> + * @mbm_states:		saved state for each QOS MBM event
>   * @mbm_over:		worker to periodically read MBM h/w counters
>   * @cqm_limbo:		worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -158,8 +157,7 @@ struct rdt_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	struct cacheinfo		*ci;
>  	unsigned long			*rmid_busy_llc;
> -	struct mbm_state		*mbm_total;
> -	struct mbm_state		*mbm_local;
> +	struct mbm_state		*mbm_states[QOS_L3_NUM_EVENTS];
>  	struct delayed_work		mbm_over;
>  	struct delayed_work		cqm_limbo;
>  	int				mbm_work_cpu;
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index f26450b3326b..ecca6f419a1d 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -51,4 +51,6 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  };
>  
> +#define QOS_L3_NUM_EVENTS (QOS_L3_MBM_LOCAL_EVENT_ID + 1)
> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 011bf67a1866..25fb4121afa5 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -42,7 +42,7 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>  
>  extern bool rdt_alloc_capable;
>  extern bool rdt_mon_capable;
> -extern unsigned int rdt_mon_features;
> +extern unsigned long rdt_mon_features;
>  
>  DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
>  DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
> @@ -97,6 +97,12 @@ static inline bool resctrl_arch_is_mbm_local_enabled(void)
>  	return (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID));
>  }
>  
> +static inline bool resctrl_arch_is_mbm_event(int e)
> +{
> +	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> +		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> +}
> +
>  /*
>   * __resctrl_sched_in() - Writes the task's CLOSid/RMID to IA32_PQR_MSR
>   *
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index c44c5b496355..ffba9ac73be1 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -333,15 +333,13 @@ struct rdt_hw_ctrl_domain {
>   * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
>   *			      a resource for a monitor function
>   * @d_resctrl:	Properties exposed to the resctrl file system
> - * @arch_mbm_total:	arch private state for MBM total bandwidth
> - * @arch_mbm_local:	arch private state for MBM local bandwidth
> + * @arch_mbm_states: arch private state for each MBM event
>   *
>   * Members of this structure are accessed via helpers that provide abstraction.
>   */
>  struct rdt_hw_mon_domain {
>  	struct rdt_mon_domain		d_resctrl;
> -	struct arch_mbm_state		*arch_mbm_total;
> -	struct arch_mbm_state		*arch_mbm_local;
> +	struct arch_mbm_state		*arch_mbm_states[QOS_L3_NUM_EVENTS];
>  };
>  
>  static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)
> @@ -504,6 +502,8 @@ void resctrl_file_fflags_init(const char *config, unsigned long fflags);
>  void rdt_staged_configs_clear(void);
>  bool closid_allocated(unsigned int closid);
>  int resctrl_find_cleanest_closid(void);
> +int rdt_lookup_evtid_by_name(char *name);
> +char *rdt_event_name(enum resctrl_event_id evt);
>  
>  #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
>  int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index cf29681d01e0..695c9742212a 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -383,8 +383,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
>  
>  static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
>  {
> -	kfree(hw_dom->arch_mbm_total);
> -	kfree(hw_dom->arch_mbm_local);
> +	for (int i = 0; i < QOS_L3_NUM_EVENTS; i++)
> +		kfree(hw_dom->arch_mbm_states[i]);
>  	kfree(hw_dom);
>  }
>  
> @@ -418,25 +418,23 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
>   */
>  static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
>  {
> -	size_t tsize;
> -
> -	if (resctrl_arch_is_mbm_total_enabled()) {
> -		tsize = sizeof(*hw_dom->arch_mbm_total);
> -		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
> -		if (!hw_dom->arch_mbm_total)
> -			return -ENOMEM;
> -	}
> -	if (resctrl_arch_is_mbm_local_enabled()) {
> -		tsize = sizeof(*hw_dom->arch_mbm_local);
> -		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
> -		if (!hw_dom->arch_mbm_local) {
> -			kfree(hw_dom->arch_mbm_total);
> -			hw_dom->arch_mbm_total = NULL;
> -			return -ENOMEM;
> -		}
> +	size_t tsize = sizeof(struct arch_mbm_state);
> +	int evt;
> +
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
> +		if (!resctrl_arch_is_mbm_event(evt))
> +			continue;
> +		hw_dom->arch_mbm_states[evt] = kcalloc(num_rmid, tsize, GFP_KERNEL);
> +		if (!hw_dom->arch_mbm_states[evt])
> +			goto cleanup;
>  	}
>  
>  	return 0;
> +cleanup:
> +	for (evt = 0; evt < QOS_L3_NUM_EVENTS; evt++)
> +		kfree(hw_dom->arch_mbm_states[evt]);
> +
> +	return -ENOMEM;
>  }
>  
>  static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 0a0ac5f6112e..be0652361949 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -545,56 +545,29 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
>  	}
>  	rdt_last_cmd_clear();
>  
> -	if (!strcmp(buf, "mbm_local_bytes")) {
> -		if (resctrl_arch_is_mbm_local_enabled())
> -			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
> -		else
> -			ret = -EINVAL;
> -	} else if (!strcmp(buf, "mbm_total_bytes")) {
> -		if (resctrl_arch_is_mbm_total_enabled())
> -			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
> -		else
> -			ret = -EINVAL;
> -	} else {
> -		ret = -EINVAL;
> -	}
> -
> -	if (ret)
> +	ret = rdt_lookup_evtid_by_name(buf);
> +	if (ret < 0)
>  		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
> +	else
> +		rdtgrp->mba_mbps_event = ret;
>  
>  	rdtgroup_kn_unlock(of->kn);
>  
> -	return ret ?: nbytes;
> +	return ret < 0 ? ret : nbytes;
>  }
>  
>  int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
>  				 struct seq_file *s, void *v)
>  {
>  	struct rdtgroup *rdtgrp;
> -	int ret = 0;
>  
>  	rdtgrp = rdtgroup_kn_lock_live(of->kn);
>  
> -	if (rdtgrp) {
> -		switch (rdtgrp->mba_mbps_event) {
> -		case QOS_L3_MBM_LOCAL_EVENT_ID:
> -			seq_puts(s, "mbm_local_bytes\n");
> -			break;
> -		case QOS_L3_MBM_TOTAL_EVENT_ID:
> -			seq_puts(s, "mbm_total_bytes\n");
> -			break;
> -		default:
> -			pr_warn_once("Bad event %d\n", rdtgrp->mba_mbps_event);
> -			ret = -EINVAL;
> -			break;
> -		}
> -	} else {
> -		ret = -ENOENT;
> -	}
> +	seq_printf(s, "%s\n", rdt_event_name(rdtgrp->mba_mbps_event));
>  
>  	rdtgroup_kn_unlock(of->kn);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index a93ed7d2a160..4f355d3ec2d3 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -84,7 +84,7 @@ bool rdt_mon_capable;
>  /*
>   * Global to indicate which monitoring events are enabled.
>   */
> -unsigned int rdt_mon_features;
> +unsigned long rdt_mon_features;
>  
>  /*
>   * This is the threshold cache occupancy in bytes at which we will consider an
> @@ -253,19 +253,11 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
>  						 u32 rmid,
>  						 enum resctrl_event_id eventid)
>  {
> -	switch (eventid) {
> -	case QOS_L3_OCCUP_EVENT_ID:
> -		return NULL;
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_total[rmid];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_local[rmid];
> -	}
> +	struct arch_mbm_state *state;
>  
> -	/* Never expect to get here */
> -	WARN_ON_ONCE(1);
> +	state = hw_dom->arch_mbm_states[eventid];
>  
> -	return NULL;
> +	return state ? &state[rmid] : NULL;
>  }
>  
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> @@ -294,14 +286,14 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>  void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
>  {
>  	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> +	int evt;
>  
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		memset(hw_dom->arch_mbm_total, 0,
> -		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
> -
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		memset(hw_dom->arch_mbm_local, 0,
> -		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
> +		if (!hw_dom->arch_mbm_states[evt])
> +			continue;
> +		memset(hw_dom->arch_mbm_states[evt], 0,
> +		       sizeof(struct arch_mbm_state) * r->num_rmid);
> +	}
>  }
>  
>  static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
> @@ -579,15 +571,11 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  				       u32 rmid, enum resctrl_event_id evtid)
>  {
>  	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	struct mbm_state *states;
>  
> -	switch (evtid) {
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &d->mbm_total[idx];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &d->mbm_local[idx];
> -	default:
> -		return NULL;
> -	}
> +	states = d->mbm_states[evtid];
> +
> +	return states ? &states[idx] : NULL;
>  }
>  
>  static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
> @@ -864,15 +852,14 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
>  static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
>  		       u32 closid, u32 rmid)
>  {
> +	int evt;
> +
>  	/*
>  	 * This is protected from concurrent reads from user as both
>  	 * the user and overflow handler hold the global mutex.
>  	 */
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
> -
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
> +		mbm_update_one_event(r, d, closid, rmid, evt);

You need a check resctrl_arch_is_mbm_event() here.

Will that be reason for your hang issue?


>  }
>  
>  /*
> @@ -1075,20 +1062,37 @@ static void dom_data_exit(struct rdt_resource *r)
>  	mutex_unlock(&rdtgroup_mutex);
>  }
>  
> -static struct mon_evt llc_occupancy_event = {
> -	.name		= "llc_occupancy",
> -	.evtid		= QOS_L3_OCCUP_EVENT_ID,
> +static struct mon_evt all_events[] = {

There is one empty event here. You may need to make that clear.

> +	[QOS_L3_OCCUP_EVENT_ID] = {
> +		.name		= "llc_occupancy",
> +		.evtid		= QOS_L3_OCCUP_EVENT_ID,
> +	},
> +	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
> +		.name		= "mbm_total_bytes",
> +		.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
> +	},
> +	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
> +		.name		= "mbm_local_bytes",
> +		.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
> +	},
>  };
>  
> -static struct mon_evt mbm_total_event = {
> -	.name		= "mbm_total_bytes",
> -	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
> -};
> +int rdt_lookup_evtid_by_name(char *name)
> +{
> +	int evt;
>  
> -static struct mon_evt mbm_local_event = {
> -	.name		= "mbm_local_bytes",
> -	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
> -};
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
> +		if (!strcmp(name, all_events[evt].name))
> +			return evt;
> +	return -EINVAL;
> +}
> +
> +char *rdt_event_name(enum resctrl_event_id evt)
> +{
> +	if (!(rdt_mon_features & BIT(evt)))
> +		return NULL;
> +	return all_events[evt].name;
> +}
>  
>  /*
>   * Initialize the event list for the resource.
> @@ -1099,14 +1103,12 @@ static struct mon_evt mbm_local_event = {
>   */
>  static void l3_mon_evt_init(struct rdt_resource *r)
>  {
> +	int evt;
> +
>  	INIT_LIST_HEAD(&r->evt_list);
>  
> -	if (resctrl_arch_is_llc_occupancy_enabled())
> -		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_total_enabled())
> -		list_add_tail(&mbm_total_event.list, &r->evt_list);
> -	if (resctrl_arch_is_mbm_local_enabled())
> -		list_add_tail(&mbm_local_event.list, &r->evt_list);
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
> +		list_add_tail(&all_events[evt].list, &r->evt_list);
>  }
>  
>  /*
> @@ -1219,12 +1221,12 @@ int __init resctrl_mon_resource_init(void)
>  	l3_mon_evt_init(r);
>  
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> -		mbm_total_event.configurable = true;
> +		all_events[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_total_bytes_config",
>  					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>  	}
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> -		mbm_local_event.configurable = true;
> +		all_events[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
>  		resctrl_file_fflags_init("mbm_local_bytes_config",
>  					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>  	}
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index c6274d40b217..3d46551f39f6 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -123,12 +123,6 @@ static bool resctrl_is_mbm_enabled(void)
>  		resctrl_arch_is_mbm_local_enabled());
>  }
>  
> -static bool resctrl_is_mbm_event(int e)
> -{
> -	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> -		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> -}
> -
>  /*
>   * Trivial allocator for CLOSIDs. Since h/w only supports a small number,
>   * we can keep a bitmap of free CLOSIDs in a single integer.
> @@ -3168,7 +3162,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>  		if (ret)
>  			return ret;
>  
> -		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> +		if (!do_sum && resctrl_arch_is_mbm_event(mevt->evtid))
>  			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
>  	}
>  
> @@ -4100,8 +4094,8 @@ static void __init rdtgroup_setup_default(void)
>  static void domain_destroy_mon_state(struct rdt_mon_domain *d)
>  {
>  	bitmap_free(d->rmid_busy_llc);
> -	kfree(d->mbm_total);
> -	kfree(d->mbm_local);
> +	for (int i = 0; i < QOS_L3_NUM_EVENTS; i++)
> +		kfree(d->mbm_states[i]);
>  }
>  
>  void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
> @@ -4162,31 +4156,29 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	size_t tsize;
> +	int evt;
>  
>  	if (resctrl_arch_is_llc_occupancy_enabled()) {
>  		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
>  		if (!d->rmid_busy_llc)
>  			return -ENOMEM;
>  	}
> -	if (resctrl_arch_is_mbm_total_enabled()) {
> -		tsize = sizeof(*d->mbm_total);
> -		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_total) {
> -			bitmap_free(d->rmid_busy_llc);
> -			return -ENOMEM;
> -		}
> -	}
> -	if (resctrl_arch_is_mbm_local_enabled()) {
> -		tsize = sizeof(*d->mbm_local);
> -		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
> -		if (!d->mbm_local) {
> -			bitmap_free(d->rmid_busy_llc);
> -			kfree(d->mbm_total);
> -			return -ENOMEM;
> -		}
> +
> +	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
> +		if (!resctrl_arch_is_mbm_event(evt))
> +			continue;
> +		d->mbm_states[evt] = kcalloc(idx_limit, tsize, GFP_KERNEL);
> +		if (!d->mbm_states[evt])
> +			goto cleanup;
>  	}
>  
>  	return 0;
> +cleanup:
> +	bitmap_free(d->rmid_busy_llc);
> +	for (evt = 0; evt < QOS_L3_NUM_EVENTS; evt++)
> +		kfree(d->mbm_states[evt]);
> +
> +	return -ENOMEM;
>  }
>  
>  int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)

-- 
Thanks
Babu Moger
