Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9557634DB7C
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777806; cv=fail; b=cF2aDJd/8EEX9VpU8B8+AYHWfWVKEX/+yl2fIPzg88PZ/yKWa98BJYeqldGqgN7JGFUipbR46/N0qNMKs+S7CUqDBJ66kQ8K8wQZ9GmwDuDVGonxGkwsy8ih8g4CWAdY5Km6Pr1ZSAvKRUiUaoMEF1iW3kIknvi7k7erMStpCzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777806; c=relaxed/simple;
	bh=4TUoJk3yV52w4DF0yYvFmVupvmKFAASbhR8NyZqOpZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qz0DYA8faec/Vz36q//EvDD3jjMCPr4eXePy4rGi92pXtqw8kNyGt6XS04x3/F9Wx9oW6wjmIMxhSorq782ODrR/nawEUYz9wbp4Rrod57+AwTQYnVMBvlqGa+og+zvc9/Sxz+O3RTvse2mYkocE3bC9OZMnzvHi/7HXXRWxefM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ej7l4xz5; arc=fail smtp.client-ip=40.93.194.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ej7l4xz5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSZNUHuls8CvElOHnX8psWwuZtViUkcOezO6szKJLlDebYQ+4XxwNA+eN9Dpkut/22xdURi462Iu9wwb6bPsOqpk7vQLzcHiHCFWbEuouEgYCaErwKICsG2A97pxgtetRWY1y0KFukD0paT3KweUzEolkwgGD5t76s7Q6BeK5gUBbd/AcMMI7wAY1gQ+lxq5TCJGgI+6Fmo7hS5a2b/IfBpPPPAFoR99z4o5IM/M2EH0rmBskjxg0QF4+nGRtAbu7SWZcG1onNssYLWtJ0Oe35KCq79gBNQndhmZWlWXgg0POrvdTa3T+O0/0RXt4/R0+mR2n4ujPleNgRMqRH9wcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCD2MmdoNqKvT7z11hcLy+b0Zr9nqc4J7GoBO4rC7cM=;
 b=aTAKeNHwciA6yOIOM1C4q7N7tG7/iNKHnZAfhcjw94dlFwBpp6iiDKBaUQGhnCI9NoLdH/8VRpEZWJgO72XAB3P80qxWT1RJVDowoVqFUliT8AZxdecRShWoN7MWldG3Xc/ORhUCmoL8wsX3ik40zcJUBcuDwLQ+jsyjXhTa/NJdpJMShyMOlYNT4fuBNKMtJlgxMDFzOmXMk4MLT5Te/DtwvSdqU+ir0sqoqW0LGX2pKM35ACHcf58cHhhuTwpEdQQ2SNzSEZF9Jcz5uVaabPK8hO9R/Al7lz+mDBmDNlJZpejpLip1GNl1g3cHBD4snKcz6KRGsC8ODm7fDnEkmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCD2MmdoNqKvT7z11hcLy+b0Zr9nqc4J7GoBO4rC7cM=;
 b=ej7l4xz5AqTyD6xjSvwKl+90g6ZHRiTqdZ3YZxpUetBX+zRknCALjesLWY4GgWZ0LooZRWjRXjMwhc1LL8kzIgGStLY/kuFqNM6zXbDTKrnu6yObcNXBMdA5R15/yfPvFV1XzzccyS1SaYYw24htIemhBGGNqCBfh0F/n3yY2EA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 16:03:15 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 16:03:15 +0000
Message-ID: <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
Date: Wed, 3 Dec 2025 17:03:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Prike Liang <Prike.Liang@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251203152351.182356193@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::20) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS0PR12MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: 665ca3a6-cad9-45ca-5119-08de32857750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUZlZEhHV0ZxNkNqVDJpditEVGpLNlBoQjBGSTN0Y3BzS3dRZVhXWHVQQUlo?=
 =?utf-8?B?amlINGlianZHSVVJa05qZ0lXUmlENlBhT1ppWUhJL1pOK1ZjQnNEd285M29p?=
 =?utf-8?B?dk5OenQ1bkVhTUtaWERBTHdjbWJyZ3V4NlFxNnhVUkRpTGhYUmoybUluTm5k?=
 =?utf-8?B?U2pRSU9jNDVYWkRQaU9Eb2FKWHM3QjJYdjAvRDNKbjVCSndkWFFiTDNyckJV?=
 =?utf-8?B?ajBnQktiMU1Jb3Fha25PMFB5aWlTd1BXbmlMcmpvYk5KNFJmNVlWY25lRThv?=
 =?utf-8?B?ZTN4V2s0ekpLYSs3MDBUT3l4U3BIQm5oUlJXYTF5anorVkovUEo5VThuZTVx?=
 =?utf-8?B?Nzk5QW9ycVk2Z2U0ZE84V1dkQXdTOUg3Y09DRGVWSkg1NWc0UjZjd2pnZWwv?=
 =?utf-8?B?d1IxcGdOWk5hNFEvRldXVkFLdW9ScmlXdDhlYVQ0NUxBeFNFaTFiOHdGUGNa?=
 =?utf-8?B?bUY1SGdZYkN6YUYrNUFPb29OMVNKUTYrSW9sK3BPZDZISm9SbzhqUkMweUc1?=
 =?utf-8?B?ZXJpWkJBREl3VzIxbnFoMUN3NmZvbkNtd1NMZWd3a2JzQVdYT2FhRFFjc3g4?=
 =?utf-8?B?bzFCbENjOFBSV2xOMnZWQjh1UHNDbmNzc1NjQ2ljejBCQmRWM1lLTWdDTkVx?=
 =?utf-8?B?RlJJYW44dVVLOEpEUkx3eEZkTitsY1NpQ2J2bHZOMVZYLzV0RlAyb3VNZ1or?=
 =?utf-8?B?WVEzVzkyZm9rR25oOWM5L1BLQVJvRElQbkdETXMrdU14WlpFUTJyeDhOcmwx?=
 =?utf-8?B?OHRONjVndS9mTnY3N0xHOXZWWjRhSjBScnpNWW94TnhNQlhVSTZzZTdwYTNX?=
 =?utf-8?B?VXNMV1h2NmxZSTMzcjE1V2ZrK294R1VzK1ZGNDJzUGNhZ0h2eGlJTTlqQUxu?=
 =?utf-8?B?eitCZkl3UDcxNmtKWDZUUHd2UWtsSFNmajRoelhOeXpSSU9WNTNqbk0vTkN3?=
 =?utf-8?B?cGpOVHpXc1JHMGNSblBhNENEWEJSa0tNQTgrTVQvd05qY0RKekNoNVQyZmZu?=
 =?utf-8?B?N2dGeDhHaFdqSzlveWtPNERYQTRTOWVNeHJWaG1qbURWSVE4YnJXK2dUUnQw?=
 =?utf-8?B?aE1TcUVMeU5helRLR205RDJKQlQvWkZSOWJQNHBXRnA4a2d3NXlGa0FIM3Z2?=
 =?utf-8?B?YUxsR0QvQURFSFl3UTdsUnRLM0laRmVVcjlVV3Z2enQvZXhKekIwcDdGWW11?=
 =?utf-8?B?aVpldWpoV2lNeXR3VHJxS3hTYVB5ZjdrVEJ6QmxSYzFCc2NyR2VaT0J6aXo5?=
 =?utf-8?B?QWVhMTg0d3hXQmZuMFRKaE5MNzJFSzlXMXI0OS83Q2c2Zy9zeVBibVByZ3FX?=
 =?utf-8?B?YVlhWm5DNHJpQVFJV1BvYWI1THNvTDVrN2E4L0tEQzZNaFlXKzZEalJkQlVQ?=
 =?utf-8?B?T1BCdWhFdlFQUk1hWUdGU0c4UFVMcEw2ZmpEOHd4SEp6NmRxeW5Xc2xKYjEx?=
 =?utf-8?B?SkE2WW9QYUJzRUpnd3VISVdobjNGeHBtVkNsb3lubGNEUm90TXFTRWJHZDA3?=
 =?utf-8?B?VTJKYXhRWGpERmVSd1pOdVVnenZTZzdZSUtLL0QweWpMOER4M09tZDFNcHEz?=
 =?utf-8?B?MWVUU3dvUzZxeUhMY09JdXB4Z09hdGdRaTlJRzBNT1VsS2dyZnBpTWl6SmRV?=
 =?utf-8?B?OWRMWUpGZUpSVDJ6V2tNcmpsQnBmb3U0SjY5UG9QenJtVkk0Z1EvaldTRzhn?=
 =?utf-8?B?QnNLRE1jTGdpcDV0UFRUc0xtaU55MFczblR2bTV3K1BJRFRseWZobko4cTJy?=
 =?utf-8?B?cUVpem9aVVVrR2NQZ0dzaS9xdE5BQU1jNmVXeVY3MHJiV0p0L0xqY2Uyd2F0?=
 =?utf-8?B?MVgyMS9LeDZKamxReUZhcnlBbFIxdFVmRWFJVDZJaHUxWEhhYjlUVnd4dUkz?=
 =?utf-8?B?cEl2RkpzL2xaODBJYk1xV2RXSnZqbnlNblNhSlF5TnBReXo1Q05lSnZEYjBt?=
 =?utf-8?Q?lexDufmI7xDqGqQEZlH2D77FJfPa4qt3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?encvR0tJV1Nha01qeGdMVWFHblU3cFNJcDRsRzlGYklYVFJKQUpPZCs1RnFD?=
 =?utf-8?B?YzFzaGlXZlF3aUk1ejEvaFYvRG9Vb2FxY0pBUGFXUXpKdGIwNG9tVVJ0RTdh?=
 =?utf-8?B?Sm51cFF3RE1GK3hJaU8wV2duMTd2SGVSTk1aWDQydWtxMkgvQzNjQjNrbkd2?=
 =?utf-8?B?TEpMcHFmeUoyMFZlNGtqSGZIQUFpTWdKaGFiTmlUYjdRV1Nqam1RL24xckgv?=
 =?utf-8?B?dWlaY2lrbHpacDZzdUJieTNmUTBxVEJEanhCQkJTa0MvQ1duY2toUFdpdTdt?=
 =?utf-8?B?eDBxa0M1ZkNFUDdyWjE1eVpMb0NxT3pURS9IR2VpVTYyRUNXRTR6UENLRlFQ?=
 =?utf-8?B?cm5yeDh1R0VmNDBuQ094SE5SaWtjbyszM1gwNGxNZ1ZMenhtWm1oUnZzcGYx?=
 =?utf-8?B?MUUzQ2xSVUNhUUNIUmlZdkhCZ1Q4V21BR3lWcWxKMHhvR1k2bi82UnB4TkZu?=
 =?utf-8?B?QVVkZERqdTJwd3gzcTVLM09MSG10c2RKN1hGSWRZbk9PRmJ2bWI3cXJZVW1k?=
 =?utf-8?B?bUNzYU1yRWNOUURMbUlXSEJhZU1KQmowWXovTzlwNkxzV1ZhajhRcTZOM3Jv?=
 =?utf-8?B?UmlqdHZHeWVId1BtTzB2MHRjSDVacWNackgvMHk2R2VKdmZTSnJEdTMybENE?=
 =?utf-8?B?eXR3QWVMRmJvbnZBbDZGb2ZTZnd2ZFlYVmp5eTQxK0U3R1VibGJyZ0ExZWlN?=
 =?utf-8?B?MUpKNkErUU1TYVlrTWZYL0hNc24vQUhsUzJ2VkJ2TkpHZWdacExxNVRKZVpY?=
 =?utf-8?B?UEZCVGtEcU9OUkxsZHVmU2dLSVFscGVuWFlSTitYQldja0NPOHFBMWFUeDlu?=
 =?utf-8?B?M0VTditoblZrQlliRmNhSXNFZkRKdEp3SjU1MmcxRmpHM05zUmRVdEY3YjZU?=
 =?utf-8?B?ZEtxTlpFQmtpZVk0YVoyWEpBMGhiZVZtTFVpSzFjaUVXUEdKN0psQUpVWjg5?=
 =?utf-8?B?M3pJVlhTM3YxQW91cDRpRU91UXdLN1R3MjNNdVVFSDhKUkMzTlh3WjdNSFpu?=
 =?utf-8?B?bUp4NXVIYnJTL2pVSDhhL1BGdkg2SjRla3MxRUxLLzkrUUwyR3UzeElZeU13?=
 =?utf-8?B?ZFh2Sk8vQUJoNUNyYWxrR1dPQzRlWXQ5Smc3Z2s5bjdkaytXenE5bldxcHJ5?=
 =?utf-8?B?RHhIK3VnQzg3N3I2czlYc3BQb0htTUdSNmlDakVKdUU5MktNd2lHN2dPalZq?=
 =?utf-8?B?a0ZqaEZkQ29hK2VkbWREK0haSVZNTEkyYzVJelZRanoxb1B4QmhzUkhaVmJ4?=
 =?utf-8?B?TWgxL3psNG9Nc3NucnNhbkhUWG9xZGtyV0FYeUh4a2RuN0xaV3pydjN5NWQ1?=
 =?utf-8?B?YWdLQ3Q5WUlJU3FMWnMwNTl2WnRMb25LWVl5b0hmOHNURm8ySGVENk9yUU1H?=
 =?utf-8?B?ZnBIek9BRmtFZDFwTFN4dmZnQ2lHV2VsQUM1b3R2Q2NRVXdkamI1UU01YmpG?=
 =?utf-8?B?VlBoc3pvZ0pzZ0FMSnVSNklnM2w2QnpsSlpVWHI3R0NveXIydkNBbDFhYjBD?=
 =?utf-8?B?ODBZUGNqQlRaVUx4WCtKaWRkZm1ONXZnbEJKWk0xWTFtYzZmL1ZXQkF1RFJx?=
 =?utf-8?B?cE0rL3FQODAxeDhUVEtlZ2ZCL3FGVFRTR2tUSGdieEZ5NDh4NThMdHNLVE5Q?=
 =?utf-8?B?L0lhMVgvbmZGTENFZW9VRlRGUHk5azdSM3RNLzRFWThNS285TE42ci80eW9D?=
 =?utf-8?B?YThvVWJnL3NGUnlmdW8wNnF5cEM2WFl4V3B6MlBheFNFT29DVTVSZ3FKSFJp?=
 =?utf-8?B?NGk2QmhWa1dYYlhuNXNpc3VVRk1zcVBkNjFxd1psZDJuaGxqM1BGVklzSFJl?=
 =?utf-8?B?RzMvb2VFOUFpQ0d4a2NFQ241YU5nWmFaS1FFU21wTkpWSnRFRll0aTRMMHl5?=
 =?utf-8?B?dFFjUWEyTCs0UktqQ1B3cVZYOThySXV4NXZ1WitObXNNbDBweUpYL0VxQ3RE?=
 =?utf-8?B?ZkdlVWlVUGkyMDNtQkorQlpSRkU4Rkt0Y0hWQ3UzcjVjcitHVTdBMmpaYkhi?=
 =?utf-8?B?OTl5ZlRmK3haRGIweWxPeVNTNVp2SmZqb3RZcGxVSzRwK1NxSVNDcTVpNHUw?=
 =?utf-8?B?MGM1MlV4Tkt0OGtxNGtsWlNSODBvNjhUMXNsTndNS0RBUG1HT0czNnJ0YmNt?=
 =?utf-8?Q?W2L6qQJswTQIpuHINi1aSiXh5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665ca3a6-cad9-45ca-5119-08de32857750
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 16:03:14.9531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nu7Xq7BpFlBM+gq/vk7spKkkmzCQ7k1psKdMKP1ZqqOJkIcDDeL21da6nuNTYIKC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876

Oh, wait a second, that one should clearly *not* be backported!

@Alex or do we have userqueue support working on 6.17? I don't think so.

Regards,
Christian.

On 12/3/25 16:28, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Prike Liang <Prike.Liang@amd.com>
> 
> commit b4a7f4e7ad2b120a94f3111f92a11520052c762d upstream.
> 
> Ensure the userq TLB flush is emitted only after
> the VM update finishes and the PT BOs have been
> annotated with bookkeeping fences.
> 
> Suggested-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Reviewed-by: Christian König <christian.koenig@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit f3854e04b708d73276c4488231a8bd66d30b4671)
> Cc: stable@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> @@ -1056,7 +1056,7 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
>  	}
>  
>  	/* Prepare a TLB flush fence to be attached to PTs */
> -	if (!params->unlocked && vm->is_compute_context) {
> +	if (!params->unlocked) {
>  		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
>  
>  		/* Makes sure no PD/PT is freed before the flush */
> 
> 

