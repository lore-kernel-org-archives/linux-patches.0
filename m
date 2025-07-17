Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3442F8C56;
	Thu, 17 Jul 2025 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752767436; cv=fail; b=daGXojiNbLPOj0tjAfUEnogjKN7ZTrpJyw6DGnQCc9nAYIaFhPaTLe8W9ShOZXEAXRwYtMfezim4OeiLds1pfShMVkVcuPjD3AvSKZmpLEHSRdmPSsdfcDe3Md6y7VV52ixp07PIXN+FpPVJjU4DzZDgdliBz+SrQKa8lxpo5hI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752767436; c=relaxed/simple;
	bh=yTfo9tA2WYc2x6okdKcgwe51coyrW2KeNY9gQHQFVoI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kUB4AglLo5TNqHBCzkSfa4t+3Tbmil/b7kgbqxKPKn7s1p2IlADQoc6J4tsUrZkg66u5yX5ZtAKDEcrydOkM/6/9LOgtGZRI5v1AWPjn64gyFvDPJN/+ln5zOLeb0OYzDMs/YrYmoz2e0NkIovh4DZkkr3cwu/3JOBc/ehmxMfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zdXvcTHS; arc=fail smtp.client-ip=40.107.220.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zdXvcTHS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/HmLl3Gz3FJvcg/x+GaBLZYPr14hlbjzRt4cMrJSSS/ULToa8Y+y0iX/c648ViYkkDCHYkzmGQLpVf3KMCVJlxyzIOZKM8FE1ktu6fn+8e14notnNmCYfT0k4jLNGKGNGDHIiTPzrwnuqdFiQqwkowRk8ehmCE0IMuNygWEIboqk/w7yAx3xMcUeVCbZUygCZaEjscV94x7hK/stw07SUXpRC2wXrxYeBwimT/shKLNGUVPIry7H/Z7twAJ+Ikrlt9cDyvnhhunaD8C97q4iY/UDEvYcx9PDhXHOPscui0bnnQeoH4b/NkpY0RJQKYoVbR4ho0DoK3AlVg0SDIfsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDASb57XLxegEUj57xmF+WK1UUg6vBsC7kHxhLdRWjU=;
 b=Jf+ZAz9YyrefLZ52OnSI+QivHyRmtmWBIAas7htT4djya7cdprOlfgay8+5P0xIWas2Qykm7BcMqQ0ob7jQqWJgDm1TlNOuPaE6f9u01FBDJF94U84pf0yysuJxDo95n+Vi8ewVlK6wuc/SVNWr1Rj4HMMPyztkAQQgX/XB+4gJnmFEndB9lLY3xaAStt++FM6A6UXS21rf0Je7cmUYhagUoYvMK5bbyFg36Txg1RyPi+bWHkY0tAlwb36WHMCrEjgw2C4MpFG4FY74Z3KQy02QYXeQIFB/G5KrvPS97km11/KeyK/aqZg0ls8d1ECfRSnTngw+G+3PBOBwEUOU5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDASb57XLxegEUj57xmF+WK1UUg6vBsC7kHxhLdRWjU=;
 b=zdXvcTHSKA7/GNB3lTxGxkffPrRdEH4Ap42MVr+nja8YWkehy5H1YKEck9RmbuTAqzr4HBv5KWO9ArFu1pZ5kuVHi8K2+6KMiZ60UX0MYiC7JkXGA2noskw0GIjRqPaqFpUdB4UKWm+Emhx8RbUbXPYb0B1H5jU5gt5/9UmCxfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.39; Thu, 17 Jul 2025 15:50:32 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 15:50:31 +0000
Message-ID: <f8496358-443c-4a16-aa05-5e3e166b1fc1@amd.com>
Date: Thu, 17 Jul 2025 21:20:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <jroedel@suse.de>,
 Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
 Stable@vger.kernel.org, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Ankit.Soni@amd.com
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
 <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
 <20250716124929.GA2138968@nvidia.com> <aHjKjDunWlpF_aSx@willie-the-truck>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <aHjKjDunWlpF_aSx@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:279::11) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 4842e1f6-7da3-4fc6-2444-08ddc549a912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlNzQUc2dXdGZHlmMzFQcVFKbmtEdDhCemFNZzUvaDYxbUQvUWhkNGpnK1Vp?=
 =?utf-8?B?SXkrK1JpNFNicmVydXRLNmcwQndpQmt3K1dTaFdTS2wrSCtFcjlUN2Z0L3Y0?=
 =?utf-8?B?Y3Nlanhib0UxMVVPNE91SFdUQjBicVJFS0pUV1BPV3puRXhrQnhkNDBCK1Vz?=
 =?utf-8?B?RUsvOHF2SXdkb0xDRURqa3NocFE0OThiUjdHNzJnakNHOEJ5WWZqZnV0WG4z?=
 =?utf-8?B?c1FvQTN0MDNVNmpBeUtqTnZpTlRtUDZKbDZQczdubHVSY3lqaWtmMVg0dlhX?=
 =?utf-8?B?QSs1WjErK0FLQXRQMThGY1dIYXJ3NGpxakhPSGFMYjVndjRJNGUzcEJ1S1JN?=
 =?utf-8?B?NkhSNUs5dXRuUktuRkFGYkxXWGh0bzhJTjdZZUVjTDRlTFZoeStlWXpnRWtP?=
 =?utf-8?B?SVhBRUtwU3RPYUVIaXVGQTNxNkdDWEdmb0pIcm51STFNZkgvdFhxUWNaWW9H?=
 =?utf-8?B?Mk9qY2swVGhKM1lRcWtwelEyUG9tZHpZYjcyM29lL1F0Z1ZNT2dhNjh2WEIx?=
 =?utf-8?B?bjR4b1JubkRnZmNnandLZjZtWnh5d3FHNmNDaElGc1RxbkFGS2lJOWJHVUlF?=
 =?utf-8?B?N05zeUR0Yk16UU05UDhWUWJjZXBxNTRGbS90WldCRjBkN2M3TkJIWkJkMWhn?=
 =?utf-8?B?MlR4VGZvR1VMUVBtN3c0dzdsbEIrSGIzOStMazd4M050Wm5PTXBuTVZ5S2ZP?=
 =?utf-8?B?YkM1Vm5NcCtFdldoaW5WME9PeHBGMzArdWNSM1ZBZUl4RzMreUsyZzhtOEl0?=
 =?utf-8?B?eVlCZWVHSFVRUTFrYXVJR2plcFpObnZOWG9jM29EWUpNa2N4cUgxYjZBNDBt?=
 =?utf-8?B?M2ZRa0xlVUQvU0dJaFN1cW9OSS94N0psazJHSjJHR1lDZnFSWk96MXpZaFUy?=
 =?utf-8?B?N3BpNTllWWxaVW50WnNiRDR2eXRidjI5RExicm8zUzE3cUo4Wk56U1hzZThz?=
 =?utf-8?B?dWJxYTRSMlVQOEVGSkRWK1IrNkdUZHpJSXVnMUZpdGU4WTN4L01tK0xxVHM2?=
 =?utf-8?B?NmxNS1BRYUdqUUdUdGhXZloxb1o0WWZwaEVJSHZmSC9hQ0pWQ0pPbExZUy9O?=
 =?utf-8?B?QlgwUFdYeWRCVmdsb3VIREptbGpYWFZEUDd2QU11YUtUZ05NdXFIUm1kdVFo?=
 =?utf-8?B?WGhjMXRKTVJnOEJXZUNKRGlRVkNxYTJsYlp2N2U4SS9IN1lwUGN3c05YNHc0?=
 =?utf-8?B?UTF6c1R1Z25SdzNyazFPMHlUOE1Lb2ZRNmdMc2pGRHBqMDBFNW5ZVUpWYllK?=
 =?utf-8?B?RE9VVUF0ckhMMWFTOUxJSitYdFVRcjlsNXF1RjM0SC9hZEVtME8rMEZXeXdh?=
 =?utf-8?B?M0RRdE94WjFvUUJuTm9sTGVPUEtDN0hwZWNITzZrU3dLcEIySHl3dUFsWjNp?=
 =?utf-8?B?aXFEMlB2VUdDcnhDM0tMTmcvOWU2NWVSNmM2NTlveUs1MjhmNjdjTlZaWlpw?=
 =?utf-8?B?cW9aTk12cGpWRXM0T3V3QnM2Skd2YnRyQXE2WGQ5OXAwdGJBbnRBOVBhamVG?=
 =?utf-8?B?dEE4ZmdDTEZGZUNyWGJ3b0dESlNzbnNOZjJLcHhpSVdONUpFUzhaWE4zSlh3?=
 =?utf-8?B?LzE1cU56Vy8rY0xnclZWOXU3amNZQ3FrQ1VDQldwTFVuRldQTUQ4VmNBYUY3?=
 =?utf-8?B?KzhWbjMrc2VZdHNnVnBkSjNHaUYwU0xod0JRK3JscEkyaXZGMGgwUEhKLytv?=
 =?utf-8?B?bUM3T25QRXkyckRFYkRYMDIxTlpZOVM2b1dnYi9hQit1Y0FJQ1VoZGd0am5Q?=
 =?utf-8?B?dGlyUGxoZlNPR01mTXdzS3BGNzhTVlZqMDRNK1JSQTVwQXVjRWxqZVVET3li?=
 =?utf-8?B?VGtCdlBsT1NvSHBWc1ZTM1dhTG8yVklONDErK2poR0FuWWxWNkcrMkwxZkNQ?=
 =?utf-8?B?MldBZzBUQVIyc09tZ2sycjBtaktIcDhiWFYrWkliZzcxTTBWbUg2RS92TVk2?=
 =?utf-8?Q?89TZmRhK2NA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXBWL2JNOTlIWEFmZWFGcUlDK1hpOTk4RGovS2lYTEZ2bmt6ZEZ1K1MrTktr?=
 =?utf-8?B?RzZ4M2VBbGtzTEZwMklWV0wyVVVPbklZNytXTXlhZkkwakJDdVRpb3l4SVhr?=
 =?utf-8?B?SmFvRE82YmUraU9WUmVET3hybDRORzVUQmlyMElwdjU1eVB1SUJvM0kySEJu?=
 =?utf-8?B?bnk0WHNOdGJ6VXhPZG92WDhOMUVBSzZQaGRxQm96R2FSYlZxNjhBL3hzLzhU?=
 =?utf-8?B?bEpWdEhVR0pZeFJzOXptYnFlZnVtTnZGN25lSWFORFhHcUFpSXR3V3BlQXdI?=
 =?utf-8?B?NlhZUXRHWjVieHU1SnI1cVpJWW5EUDdOalFvblU0MkY1UlorbFFPbXV5M3Ev?=
 =?utf-8?B?S09JT3pHSVg0aXRSTElOZmsrYmdwM1VGbExISDRacTRYQm1lUEoxZVdRclh5?=
 =?utf-8?B?VUFjbHFZU3lFY3E5YVpvbGpRRE1YQnhkc1lxOUVMM2NmSXhDK0lkbVNRWXgz?=
 =?utf-8?B?bFJpTUdsOG1VZ0JyTUROV2tDN21WU1R5NUF3REtIbnhiaDFuVzhTNDhMRVJF?=
 =?utf-8?B?Q25FWW54YkRRTDNkS0lsNTExa213WCtuTmVBZXluM0k1M2dZR2swTkVYaUsr?=
 =?utf-8?B?cnBRVzVVNFJGaE5aV2dEdytpWmNER2dCVnhuMVMvenFndy93UU9yWU9ZWDNM?=
 =?utf-8?B?QjVKbmtFd2N1VXZwTmZ5M2gzckE2WGZwendCaGJvTllsUVZWcTlkMzFnQlNz?=
 =?utf-8?B?V2V6VGtGSjV6NmtjbVdLR0FaTnl1Z2oyVUx5a1NrZTF6Qy9qYjNxRHZmTmJC?=
 =?utf-8?B?Rmc3SDR4MytuM3FsZUJRRVZqOUJ3UU1MaElUK0xDTlRYNEpCekFJM3oyTkpm?=
 =?utf-8?B?TmlYN3lOV1RvZUxHQXNSTFJVZ2ljeENvcld3bzJKLzVOQ2cwcG0yRERFZHlY?=
 =?utf-8?B?ZVBvR0VwVWJ5QzF5TFBkamphZnR3aDNSQVVLYUFoVU9DUjVsTVJNeVl2VDMr?=
 =?utf-8?B?Rm9nVzVkeEtROW1EU21pYnhXR3c2L0hvSitrNFA3bTFteGhNazlEUlpnV3lZ?=
 =?utf-8?B?VU9Lck9nbTlXemNiQ0ovM2tiVVVRNXU2Z3ZrVW52N2pzTE5ZdVhtdTgyNHhG?=
 =?utf-8?B?MVRzTko0eVFRTml3bnQyenRWU2IvYW1TWnI0VloxQlRLSDViWnhYc2N3L01m?=
 =?utf-8?B?WXpUUDdLQjlraVoydVdjdjdlN2dmcFQ3dDBPSGFQL2ErL1RyOEhyczNCVUZm?=
 =?utf-8?B?b0FpR3RTcDN3NlUxcnNJWThKcUFCZ0d3Yk5UaGVOeFpBV3crK3RVNmpzVDJW?=
 =?utf-8?B?R2w0ZEJ0c1lzdDJpOGtWWVZtdGZsNlgrSGcwdUNCZXFXcU8wS01JSEt1a3VI?=
 =?utf-8?B?bnZrOHVJRHdYNVErL1pNb0phU2dIbXlrcWV4ZjM2Z2xMSmR3dXNDdHhmS1lv?=
 =?utf-8?B?amgybk0wcXBKR2VOdyttSC9lQUNSTzhMR0RjNk0vRGR3M0NNTVcycTlDSUl0?=
 =?utf-8?B?dmxMYzA0SWRDc2VFenJQMlJVdkxYUDVXYlBNZGRPZHRyelVkM1FzVFc0YXRm?=
 =?utf-8?B?VW9UQzRlclJTNXlQYnVoSmswcDM5K1hVWmlEZzk4WUlKVVY0V29zdFc5ckVO?=
 =?utf-8?B?aXRycE9IS3d6NytuQmtLK29ySDBiNVpoQWRNQXA5cXJjUjdOVDZMOUsxeDkv?=
 =?utf-8?B?QzRpMytzREwwTElQRmVONzd1d0tRM3NKQnlyUHU4SC90NVVuWVREVjZPcWZK?=
 =?utf-8?B?M25VZ3dVZE0zMUQ3NnVWTXJ0NlFFN2lLc1UrRll1M3QzZ2t2Mjh0R2xJdUNH?=
 =?utf-8?B?aGpvcGtJbDIwbTBEOVNSTzdCQmJtMUdpcjU4YzVzNHN3ck8wUFBuSFl0SDlB?=
 =?utf-8?B?SE04aitLQmZiYlJiK0wwMWZUblgyNDF1UkRyYURtQVN3VGw3UjdMdnBkMjZp?=
 =?utf-8?B?NytNMUJxcFA3N2pESDFEc1dQY051R0kvNXVvbGZFRXhPKzg4OTYxYWV5SjFK?=
 =?utf-8?B?UU16WkZHaU1ZWklGZjdlMk9kUStsQi9uTHR3S2Z3RHlNV1F2cVRlcDNlWDNy?=
 =?utf-8?B?VUZ6VU9FUm1va3ZDMXJqVmppMXpnOEFWT2l3S1BneE81SjltcUoraXVadVdT?=
 =?utf-8?B?ZVhYMTNDMHlQVHZqeUlwOGphNnJvbk5HR2JwT2tVV0pnWGJoQU1rMm5ZeHN4?=
 =?utf-8?Q?dFIe7w441ORwZeJJWoYwgBQff?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4842e1f6-7da3-4fc6-2444-08ddc549a912
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 15:50:31.8442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8w4b6qTN2hpehfXFcBGDe9kZATi5bp49nu+dPRYL0OIcEnEQG+vzqSTDIdEItEgrlgJz3YB3aFxYIGEGbB3Wmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730

Hi Will,


On 7/17/2025 3:33 PM, Will Deacon wrote:
> Hi Jason, Vasant,
> 
> On Wed, Jul 16, 2025 at 09:49:29AM -0300, Jason Gunthorpe wrote:
>> On Thu, Jun 12, 2025 at 10:54:00AM +0530, Vasant Hegde wrote:
>>>> Adjust dma_max_address() to remove the top VA bit. It now returns:
>>>>
>>>> 5 Level:
>>>>   Before 0x1ffffffffffffff
>>>>   After  0x0ffffffffffffff
>>>> 4 Level:
>>>>   Before 0xffffffffffff
>>>>   After  0x7fffffffffff
>>>>
>>>> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
>>>> Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
>>
>> Will, can you pick this up please? It seems to have been overlooked
> 
> Thanks, I had missed this one (I only trawled the list for the two weeks
> prior to Joerg going on holiday).
> 
> I'll pick it up, but please now that the preceding:
> 
> 	if (pgtable == PD_MODE_V1)
> 
> part now returns:
> 
> 	PM_LEVEL_SIZE(amd_iommu_hpt_level);
> 
> instead of:
> 
> 	~0ULL;

Right. Now it checks for supported level instead of assuming 64bit. This is correct.

> 
> thanks to 025d1371cc8c ("iommu/amd: Add efr[HATS] max v1 page table
> level"). I'm assuming that's fine because this change is about v2, but I
> just wanted to highlight it in case there's a potential issue.

Thanks. I did verify the tree and it looks good.


-Vasant

