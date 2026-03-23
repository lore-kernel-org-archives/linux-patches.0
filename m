Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89C036DA10
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259493; cv=fail; b=q6B2shjH3Kt8+JfAfpe0O+0E6uhDhM2aEl418Ji/fH5eVTwh2UQICZteSH8MYMbK/zA3Yka0SXvbj6x3Sh9iV9pCXMHCuhPvvNoUVChzlPQQoW39NIdgG+L0pk8CWwoDkk8HTy61LYJPpWLYbrZ4H1yVmcY/BSabb5u1KUqoSBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259493; c=relaxed/simple;
	bh=gX5nmCdvH8pItKAPTef5ySitj4TA+Vx5JM6F5g9wAnA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P1R/gRrxhyO758Tp6wqoG0jQA3H0p2eZjCRXVFw6GPQAbtGjkhiOKlb4m4ZC43diLhh/FWEdNDqckfnBjBaPojp5Eti6JeK0H4PUiCE5hyn0U5Jg7PHTROveZObobKUDrTE4g5DR4Ak1V4sQ9QJ+VyNzC0nfg5Gk5o/M+Y34I90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DQShAzJI; arc=fail smtp.client-ip=52.101.193.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DQShAzJI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxDMDMDLU1PQ4mShiasJKVUR3Waim5A2nK+DLOiQso/jQaqa7bqfeZm3BXPxGsTRmTVRNi2mNcajuCDV1ogGoTpS2tUqwpjRrQhOs/clLRn1k4bYsIQBZL9trbmrMCpciTtAWUqqEWR2z5WoqoCcujohvm07yS4VtyS182wZ30UXbLmeW4ogB2NKp4K5vQruywfBhIlT+0e3CceyfThOIpXayNvDuc1+qZJDTUD1VBji2gVSaGjSNLSpcCUJbfeYH7lzvambL+eUXAjsGqpn873bvEGfI3Jp+GKs5gq3js2e4vIoTGBwCrvZfPQbl3jd7fLfJCQAGq/pxaKQ5nRD+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsOIB6Hrk9hv6cIyFcYnys7fege7d1tUY9/a+sKq6cA=;
 b=Nze1y+3/5kzCrfyfisR4FdbXcvqN36ZD+LlGsexAR0uhV66hoh+n4YnmKo6Zd+ADUKJJ904d0OYUj1QgHA6b71Rk7OsMP6uEs9TdVzgcUt923s04COOlsC8AsguE5tH1zo6aLNccplgez15umeamwnZLguH0smxyiUnfwiqd05i/XmMZ57jtXADcaATIGau+MRJttN1wTCR6ZM0jMbJN4ghoCCH53cKvmwN+a+bbA0hbi1HP5QEV4hnVZFX/gFcSFRjFZABMH4zLACKPE91OpbrV16jFqO17CrmzpVaiIA+TfwxiUrmy1FIOT9c7RpoEUd1d8y203n7iQaZ7oIEK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsOIB6Hrk9hv6cIyFcYnys7fege7d1tUY9/a+sKq6cA=;
 b=DQShAzJIbZFv3wQi7W3xWpPnKrPiapMHgxA0yonbT1Vl1J/r3VOlIy2iM6ztVIDk97xV/inLgLHd+7tkBRPlgPGMYwn1w5mudjCJ7SwgRL/iVyFaz8ltmvQi0dqDAsbz9+pVhJ53GRx+6jJo4k7or8qnM/sHehUeWPlsXDwPUTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by IA0PR12MB7722.namprd12.prod.outlook.com (2603:10b6:208:432::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:51:28 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 09:51:28 +0000
Message-ID: <f2d125ce-8cb9-4ae8-8f55-0b5a78e66f83@amd.com>
Date: Mon, 23 Mar 2026 10:51:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1.y] drm/amdgpu: Fix potential out-of-bounds access in
 'amdgpu_discovery_reg_base_init()'
To: Li hongliang <1468888505@139.com>, gregkh@linuxfoundation.org,
 srinivasan.shanmugam@amd.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 alexander.deucher@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, sashal@kernel.org, guchun.chen@amd.com,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20260323071052.4068410-1-1468888505@139.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260323071052.4068410-1-1468888505@139.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::16) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|IA0PR12MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d730819-b7bc-42d0-6298-08de88c1c128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z/HbBU33daof8t9o/IiqIYDJm/GaTckIP7Pq8X6EHQGKjNRo6rwiU5eLSm3Wbbtp7WrJshcXy0nGHG/BKB2AKS6T3PXW7olUMANqYiJ+SqUVikn3IqTwqTLg5E9ygCMufagOoYwKF5QcOzod2ktdeXGVRyvReOonpCA7wjHlbOTqAERqiUkmPbiEK+uFhQkPxBdG9OseGg56Eul25vnDhJcaIiB8wmQnsah7ZdMzzgy4Usx48XETY+5hxFyZ+XwUcTb+9FaeUK28aau2v3stvpTTgei5/SsvLBHf7NiLb3C3bo20mm3II3d1E3oi6ppYj+pvTs13HHh1Gn4ovnuFhdG+Ushl7BHz/QfzgeIi0CnptyWMvq9/JIFtm2fsen+hKmGAoeQ2F0w/cHodEH9fnb8DitynPIV643sn950XZQYw8PN8nLMC5HG8A9ST6l2+SdkKH3Aid4SpOUQuQDskKGrCbuSqEXIzO//nUqlbKDktlLuzd0IRncdRvXWZdurCtkHA0DlANsSzEjycwahElxmuqCfCwnsSy+yeIXYgIXvFF+ocw6EVwW3R8HmZL/wBsVKWuDAqwkpre9kBPMiVzCZcPMmvyE9to7I/PyrptyZzN2OvG+6CbWii2hCxfMxauVdJAUieidCW6q0CYh7WcIXYnEwSGtxjuwG+/doZ72O1JXJ2Uvh8yX8r69qfGpNxl681OIzk1DDAdb+NP4JmF4op0ZBHkdsuTdbjMN32zlM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjJWWG9halA4OEpaTHV6VVV5dU51cEpuVmxsaGNJZmNUaDhuSWdpR2poK3Bv?=
 =?utf-8?B?alRBZEJDM3FPL1hPWEJQN3pOUHA2NlRxMnhFN3FpRGZzbFcwMFEreEhvZXZR?=
 =?utf-8?B?SmQ0dHJMeGpPRVRUL25FZVAxTDB6eXZiM05pcnJ3SHV1dW9TSEtCUHcrbHg0?=
 =?utf-8?B?OGtlZ0xtS1RUMDJmVnUzeXRwR2h2QmZQWHBTRGlMMmVURWRtM21PS2dMa0Qv?=
 =?utf-8?B?OG4valJRamtqbllxclpIK0ZzQVJMMk5VT0FQeFp5ZENtTXVnQkxqMEp5WHhT?=
 =?utf-8?B?Ym9wTVpGTFVxcUVoekhqaGU4ZmpQNHNuOUdzNjFUaDY5K0hSVHNkTGExa0Ru?=
 =?utf-8?B?MUtaTU1jYVgyNmZSNU1LaG51ODVzcnJwMXoxNWtMdUVUQTVmaDhPUmNxdEh5?=
 =?utf-8?B?VlVkbjVURWRWOTZUMHhRRm4weHA3ci82VEt2elljTk01NUMyNzdIUG84UEJM?=
 =?utf-8?B?ci9uWllUYy9MZllPSTFERnZSK01WMUhSdUlTcE1FNC9rR0doZjBsdmNBSUNq?=
 =?utf-8?B?YjBqZ2xyeEVZVUUyYzEwSTBMY2tua042M3gxcStlSTByWXN1RWFUZHdvOGlL?=
 =?utf-8?B?d1c4SEhWVWVRd2djR1dSQU1WRzdEVysyZG9YRUR4YmN1NWYrVEZVV2tDL1hE?=
 =?utf-8?B?eXJzQndEWVlLaEFnYmswYXE4aTdNVXVyZ3NqUDNaUHJhVTIrYVlrWFNDem53?=
 =?utf-8?B?L3hOS24vK3dvdk9DckkyalZIaGZDbTg1R0xPYXdtQ05KMHlhVWgzVG9FMFlq?=
 =?utf-8?B?UnkvRi80aFVaQlp3d0E2VGx5RkQvT0Nhb0l6UnJMbXZGVFZKeGZHS0hRSXlh?=
 =?utf-8?B?ekU4ME5UNlpkRUliYmc3c3E4WEMrcG56Q1BTRWFSdkcveWpaN1hSRjZQYmg0?=
 =?utf-8?B?RFh1c0pEZlo0Zm9EYUs5UU9TT2VtZUZ3TUc3bFlZVWpsdVBpNStrQXNHdnk0?=
 =?utf-8?B?T0FwWkdkL2xiK0F6b2g4aC83cEE4MHRXdG9Ra01aelNTekhGVDZONk1ZdUVw?=
 =?utf-8?B?N1BlK1lsN0VWTGZNc2pOMGloMUhGaUpxR1dneVVNcnB6a3VDNk54bXZVNzk2?=
 =?utf-8?B?aC9iZk9lLzVlOXZ0WDVRZXF4YXUrbDVjL01KSXJjUHdyWDVBcWt5TG9Ncnhv?=
 =?utf-8?B?RkVhZ1p0K1NVYTlKVGU5VzcxdzRSSW9qNlZSNGhUeC9rWnIyTUliV0VnZll4?=
 =?utf-8?B?S0dZeFd3RXF3dis0bGdtd0h0NVVDUXdCaXhseHlYdW1WRUcxMVYrR3BkemdD?=
 =?utf-8?B?ZHRWWk1UTnNSbm5ZUDJ6elpqS2ZLVnFXWGRLMXJERkx5TitoZGNaQUpPaEN2?=
 =?utf-8?B?anpoZTV4eFE2YWgrakd0NldtcnhvZXl2Q2gzRHFLbndTRDBYdmVLS1EveUJY?=
 =?utf-8?B?K0FQMDh4aUVQZEcwazZKWVZHVW9waTNFcHUrRDBuM0NhYnlUM3RDbWpvRTNu?=
 =?utf-8?B?OFY5QXpTaTZWMjcvWjNJZDhtRjlJcjY1TGd0UE9EclZZcWZpU0llcDBtNTZJ?=
 =?utf-8?B?Yklqc3VxMWdGOWsvRmpnNWZlMThwNHVBOVNDaEEvSWVUckt5cWxGRjU1cllH?=
 =?utf-8?B?dEFUOFIxaDJ5K29CRUhuMkJ6aW1BbXdIRFROVStjdUg2SXNMNDMyeHNvY3ZO?=
 =?utf-8?B?ZEV1Wi9oWXA4WDJwZlhjajZRNlEwYVRETDB6Qzl5bkNycEJKYzRTRG9IMmor?=
 =?utf-8?B?YTk5aEdKSmVSZjg2NXhyN2dJSW5mRFJzdlc3WVdpcUpGL0VmOVhCTTBDQnR1?=
 =?utf-8?B?Yi90RFQxRFdDWjFrWHJaVU5NTGVHRVUzSjJtbFV4UE56QTJFa09uVmg1ZVRu?=
 =?utf-8?B?azZjcUtzU1Y0bXpVeUtTV0EzK2tiUldlNk56T1hUSmEvUTNIZ2lqY0hpZlZQ?=
 =?utf-8?B?VHNwR2swTnc2MTRpeXRZaW5uSi9nMW9QZHFNTUlacys2QS9ZOW9RcnpnU2hW?=
 =?utf-8?B?QmNFYlAzZk1xMDRBUmxQOWtnT1QxZGpITnNqZ0pMaFNPaVlUa3ZlVDZXcnZt?=
 =?utf-8?B?MkJPR2dWRHBGV0ZoK29lZEp3U3NVRm5COURHR2xtWWpTWG8xRnhXL1k4WDVI?=
 =?utf-8?B?cWRUWGl6U2pSV24xYnJUOHBGa1NnV3RHYkF6YnpGSmErUmpYSWhnYitvSVpG?=
 =?utf-8?B?eVV4ZFAyNHlCZnB5WFpUNVgrMlE2SEhNMzRFODVVdndYSVF6ZnpZa0FXSWVm?=
 =?utf-8?B?bmRLbE82YjBXK1VpeUx2aTRxNEIwcUJCTkxEQXZmdE5sUVIrM25wcitpc3dv?=
 =?utf-8?B?UzdldmU5aURrVUQwenEwNTlCb28wMG01QWNLWnY1M29EcjZNc2ZtMGdaZ04z?=
 =?utf-8?Q?XK2vZBMarvueGo8Hel?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d730819-b7bc-42d0-6298-08de88c1c128
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:51:28.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POuUeZwUm2FnoReSyBRh3qj3ajzi0IjdXEg0W/nX4e2S98fecZlvLmg5LfZ2gKLd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7722

Hi Li,

On 3/23/26 08:10, Li hongliang wrote:
> From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> 
> [ Upstream commit cdb637d339572398821204a1142d8d615668f1e9 ]
> 
> The issue arises when the array 'adev->vcn.vcn_config' is accessed
> before checking if the index 'adev->vcn.num_vcn_inst' is within the
> bounds of the array.
> 
> The fix involves moving the bounds check before the array access. This
> ensures that 'adev->vcn.num_vcn_inst' is within the bounds of the array
> before it is used as an index.
> 
> Fixes the below:
> drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1289 amdgpu_discovery_reg_base_init() error: testing array offset 'adev->vcn.num_vcn_inst' after use.

well this patch only fixed a compiler warning and has not much practical value otherwise.

Why are you sending this for inclusion into the 6.1 kernel?

Regards,
Christian.

> 
> Fixes: a0ccc717c4ab ("drm/amdgpu/discovery: validate VCN and SDMA instances")
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> [ Minor conflict resolved. ]
> Signed-off-by: Li hongliang <1468888505@139.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> index 9b1c4d5be61f..a1e006d238cf 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> @@ -1128,15 +1128,15 @@ static int amdgpu_discovery_reg_base_init(struct amdgpu_device *adev)
>  				 *     0b10 : encode is disabled
>  				 *     0b01 : decode is disabled
>  				 */
> -				adev->vcn.vcn_config[adev->vcn.num_vcn_inst] =
> -					ip->revision & 0xc0;
> -				ip->revision &= ~0xc0;
> -				if (adev->vcn.num_vcn_inst < AMDGPU_MAX_VCN_INSTANCES)
> +				if (adev->vcn.num_vcn_inst < AMDGPU_MAX_VCN_INSTANCES) {
> +					adev->vcn.vcn_config[adev->vcn.num_vcn_inst] =
> +						ip->revision & 0xc0;
>  					adev->vcn.num_vcn_inst++;
> -				else
> +				} else
>  					dev_err(adev->dev, "Too many VCN instances: %d vs %d\n",
>  						adev->vcn.num_vcn_inst + 1,
>  						AMDGPU_MAX_VCN_INSTANCES);
> +				ip->revision &= ~0xc0;
>  			}
>  			if (le16_to_cpu(ip->hw_id) == SDMA0_HWID ||
>  			    le16_to_cpu(ip->hw_id) == SDMA1_HWID ||

