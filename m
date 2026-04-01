Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012061.outbound.protection.outlook.com [52.103.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABEA2E2850;
	Wed,  1 Apr 2026 06:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025216; cv=fail; b=bjSW5su1TWVHAWxRC7nykUjsvDu/8ElNWypxArWYJsJ68whaW1FenQiW/UCzioX8mfWPug4hdJyUsBi9McD7IBelWMU6HbyTtWeMupaN2J8WYFIXrm4HOJIxSNH+ixM/I+DMSTG1s+ZAvpy/EqPh6IK1pbwsjfs+NkBR2Uitd28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025216; c=relaxed/simple;
	bh=a5HTZYRHFYMnlaCh4jlFFiW02a0aM2t5Xxesb4m02Ew=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qRU5pvL/MAom7FRkD6SRghw6aPzE0Kd/Fhq6Lqg3epPllPdAatrgfQk6ProBQmGXzzwCpz9pnj1d9JArQGpl3YX6Fglg4WjuQeKNrBMizuR/Wk4/wHGe5GyXVhCEbPAHxipoa3ZxdnnpS4swicyzbfxANfKvXncZLtHVAD+2Ltc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=hbskU08t; arc=fail smtp.client-ip=52.103.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="hbskU08t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+QiCOIroS6meLj3PgNQTRV01081Y0BWDegRayUrqUOFNGYw5J3IINVEeDjLJEPL3tuCNdL5unpnvWs9EEbja69PHPmNEtmoUmBOzQ0L97z92gUH07mXNAdInVpwD/ks/nv1bg/S4rs4plqg1lFU5TULojyusERKKdyX0KxlgsycZYjFWpylJEir5twcRZ0t6hTJeBVGUahxZELe+dMAtsK4QJof/PfkI7K/rtH06HUeO2KGdUscnAgfpTT87WZt3hSDDwVY1H3pBnnqrpy7GOeBqrHK5mu0xYNU+0TIBsaf6T8OOM8LMp9XlbnfW2k+zYbmMJfd14ruKjdoa1FGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2gMqLCLe1t4tcW4InnJ/J2JUIltLSlSfguZWL4HQkw=;
 b=RAVFnU7cXNcvhrgOuwwosbCkHr03YmcYVsft+U4cvhqeRKPPYE3JxANYOgpHgsmMCihJhnTwKz44UYEQtqLY2b1S8CpQoDbIzBp9nKYGRFpu1eJCvqiiQm+oaKAJtUTHVb2k9N41Q7REQl+SaDN8WgKNnHEQNN7WFDTa7eJKn14404KSWMlU+mcb/NBuBbRQYMR13lX+DqUMR4DZtqrPp0A0cHvpGjFCVqVC6zN712OMTQlD0O70yK2z16245X10jRxO08SeKW8+Hdu3B6XMalro+9gwmTZURDNYdcPr/zEu6PkWDM1AksIPfFLXAmJFysCxCDYF5PLQ0+1t1K8vtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2gMqLCLe1t4tcW4InnJ/J2JUIltLSlSfguZWL4HQkw=;
 b=hbskU08t3sV8qGAGUO6PVQ0qHmjTIh/qnDucr74VDCRvzHN8ym5oSvFUSePEljpG+vEWU9MQ47jxFY0+hj9N0Uzuu0JJ6AF/a7WoiAHTUnvIXVSqMEu4RmEbNLA0J558UdIRAsK92TKzBuCXr9DOxew3aQTCPU13OlzT0pMaAiJtonWHU6dLnXDE15yeoDj2FbpG/6BmOPnaHU5cNX567KBl0zlIwvslkEqLG+bbfoKjzRXN6bCzbXRW4lGe/c1kUVzZdzdcNSDm7rwytThc6V0UfIjxHQi62Vv6L5n+NEz5ioBt4rhdBO79JRjVmvf/kZ3Sj4RjnqZPfyEJE+53VQ==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by SEZPR01MB4447.apcprd01.prod.exchangelabs.com
 (2603:1096:101:43::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.21; Wed, 1 Apr
 2026 06:33:31 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 06:33:31 +0000
Message-ID:
 <SI2PR01MB439371EFE74BE6392774FEB1DC50A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Wed, 1 Apr 2026 14:33:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] iommu/amd: Have amd_iommu_domain_flush_pages() use
 last
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <3-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <3-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0046.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:3::9)
 To SI2PR01MB4393.apcprd01.prod.exchangelabs.com (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <4650777c-90c9-4ba6-8785-9ddc8df65c6d@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|SEZPR01MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: a9222121-fc54-480e-6679-08de8fb896dc
X-MS-Exchange-SLBlob-MailProps:
	ScCmN3RHayGKAlIIivN7fIKgPET+ZtPoXCUEP7eaYpZiDyjKfiKRxHjJwex8y+IHSigwg13avay8LfLYmgk3eSrqVNOccLQIBNQRzWeBReg1OHjxM3a4ZNl/3tq0pzc3Yj50k1tljNAu5St+M+r8LQaMB2VjTY/4vqFLJxk9qNsqRV21HmUCitPe/4rfdFGgAMT7vwqOga+Dy22MsIdl7G+AcroYs9y9ZCPYJDgm6cFF9CcW6RWdf/NnN9w82vJg6MQQ5mL2uALQhqj8HvvMCk4MCy6Nofco8x4FXTU03nS0DjxSG8NGlEtW3WmP8rV+ioxtFWRmRF3h473GKrJuDlaQU9eftnpZuiTEho+8waZ3RQxJO4BaMJ4T6QJvfEhK0at+1oALy9F7KpS5nuOSHUMzbTbevQcEAj39iDK3CB/e37eqoedzzbafG5R/YCNZsoQuwCB+poa9l8XUig7BBkpB8Oj7lHPbSYkD9Znq+S/fYkt+0o5DSfMuKN5hByJoM2mcQawtsD31HfLq4QxbgsoOSIHHQ91YeO4/DKeZWGw5Q1FArS+KfkrlwgoSyT3a5197XGZvPuyDsMLo+qbJyguuyByNe7u68dwP3gDRCeFA7rIe/NgIUsqvoo/O+WQRdaImOVoAnKFmIHggjYL/BoGz6g5c+ju7wm0J/jRA4TWd84fECLbBhYIAsGoSLr9UxrJYA1V0J5k4ef213B5pFFOK7porBhZbZjMrbYyYkHI=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|37011999003|12121999013|8060799015|19110799012|7042599007|15080799012|461199028|41001999006|23021999003|51005399006|6090799003|5072599009|26121999003|440099028|3412199025|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG5pcWJqRVljcU5rMnFDM212anV3YUQ2V0FJa0Q2UGpIV3d3NWl4WnM2ektw?=
 =?utf-8?B?ZXE5UVo1UXdNY3B3L01IUklGRzV4VTAvL3BqbUQydFBmUFJKR0Vhb2ZKaTMx?=
 =?utf-8?B?VjhsMmU5QzVnM2RpM2hTMHZqZ3BseUd2TXovR3FjTW82azhlWTN1bk8wMHIv?=
 =?utf-8?B?WE9wVml6RUp1TGNtUzRKK2tocGhENUliZTlLYWZ0dmZDQzQyK3ZFSjd6eUhX?=
 =?utf-8?B?Z0JhM2FQZTdkWVMzYmlma00vTEhlQU93bXlGUEZReVpoWW5oRlBNek93Q1JM?=
 =?utf-8?B?S25VTm1FMkc0VUpIc29TeTB0M0MxYjBSYUIwZHY5eE9lZG5jQkp6L2R6QmY4?=
 =?utf-8?B?Sy9ab0lPdGpFYU94bDBuVWZSR3FQYkxHK2d1T21wbkVGUjR3U0tFeGF6VWRj?=
 =?utf-8?B?QUdiTDlVRjI3ZUQxWEM3U3g0azBBdkVRc2lrclVONkw2bUYrNzlFN0c4VW94?=
 =?utf-8?B?TzBIZFFuWXFVZCsza1EwM2tIQm0rc3dnUEdKc00zaE5HTjJWaXBEZXpiU0Q5?=
 =?utf-8?B?MXlabUJjZnF0aU1mVldWek1wWnhmQUZra1JXNXM1Vm1CMmtwZU8yc1dNTFVE?=
 =?utf-8?B?OHptbGxSWHg1UDFmSXlLaEt6YVZkdUpRaEN4U005SjdhK1F6NnJrSFdaTXhi?=
 =?utf-8?B?N0xuVUV5TGRMdjlVMkcrRGxpdXdJU0txY3pVTkcySWVEeXo0OXp2RGJpY2Fw?=
 =?utf-8?B?L0N6ekZhN3lRZTBuQTVGMHErMG1ON2pQd1poMTVZc1ZjTktVWk5hM094TEEy?=
 =?utf-8?B?U3BLTzA3SlI3NFF6OEtoODI4cDRWbUhZamllelY4MVI2ZTVFdmZNREIwOVVF?=
 =?utf-8?B?NCtlTWZmZU1wZHNkQWFMMmExRzRRS0k0RUZWVmxLcVVUZ3ozUTFDTE9yckZZ?=
 =?utf-8?B?NVhzZHcxZWtFWGRsQzVWNkVKTzk5em1ERmxWSExPMDJnK1Vxd0tCWUJTWC9Q?=
 =?utf-8?B?NWsxcFdrbVlEL2Jnek9vaDdLYU5BWUdCcFlxVy9qTG51K3R3QVo1ZXJob21Y?=
 =?utf-8?B?UkdsMGJPWGRZNFB3ai9QMjFEd3hBU2ZkOWxMMUNoWTVHczdPUGwyS01NM1Nx?=
 =?utf-8?B?TnlPOXNpbkh1Q0RYQWM3U1N2a1Q3a1JITjVqbnYvNWZGZmxsSXBuci9sb285?=
 =?utf-8?B?WUtIUmJsUlowTlhhS1FpNndybmlPeUx2SHc5ckFLQVBwNDFEVEZHNXJlUHRP?=
 =?utf-8?B?SnhHMENWTEFWSmEwaExRdFZYRVpTLytLMmxxcS9NRHlWdWVOKy9OWkVMY2Iy?=
 =?utf-8?B?NFJnQU9LdEl0dkZxUnIyWm52dnpzc1pyWXora3lndnBmZTlQQTJudUF2VGlu?=
 =?utf-8?B?L1JjbkdrSm5mVTBrdXVQMDZrMjV1YTNjVnc4T0VWSjdRN2Z5U0puUDRselZy?=
 =?utf-8?B?WGFROG50eEFZdUMvUnJyWUlKek1zTTNDR1E1b2xvYXNPbUFESUtJVXp3dzJJ?=
 =?utf-8?B?UGZwNVh1ZWhHTHJiOHl6OHNkZ0ZWUm9hVUNtMXZ3PT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MExDYmNndHpOTHZoOFRDd3pPKytUR1RlY1NzVUVBelZVTHpuTEdETG9EWDZI?=
 =?utf-8?B?UE1hS2ZoME81Q2k1WTR4Yzg1Sk1TeitENGg4Yk40U0dnS2VBVE1yRGZaTVg0?=
 =?utf-8?B?S2JFQUE1SnVPalVPM0U3TFF2N3Nnc3d0TFEzWWFaTmlzQnVTOTNod3lKbDVR?=
 =?utf-8?B?Zi9hMGpHbHBwL1pUWk5qeFNWNk0yKzhHK2c3YVFsbERSYWFmYjg2MzFOTXo0?=
 =?utf-8?B?MktvWUxUbUIzUFhGWkk2K2hWNFVZR1ZmcW1HNnN4SWtHSDROVjBEQllqOG9F?=
 =?utf-8?B?RjJVcGFyVWttQTZkRiswNUdoWThsWGk5cmUxRHE3dE9XSitxSW91SkFCbC9W?=
 =?utf-8?B?RUdWWWxtTDhyUTRhL1owRjZQYzVSNjliR1lna05NNWg3OTBGWWtWeENJbG0v?=
 =?utf-8?B?M0tpeEJZdGVKdHlGdG5qRDdHL0lxbjZMbEwyVERMQ3hXRldmSmdqSjZ0akg4?=
 =?utf-8?B?cUJjL2xQeHMrc1BMUE5jdk5ZVmdOV0FhZXZqL0pQZDE2OHF4R2xsNXZmTHJQ?=
 =?utf-8?B?UzBhMHI2b1BOYmV5R1MrUzZvZGFrK2cyRG0xeGV3L3crZ2RqVlVDUENJeEt4?=
 =?utf-8?B?b2p4WTFXckJhellxQ1pOcitGeEtXTXB0aHZCMkpmZXh5blI4cE1VNld6Q1FH?=
 =?utf-8?B?cXRJbWdaWStYQkEwVHJNN2JiSGd0NTg0eERFUEFsV2pLdXRmTDVWVStzTXBM?=
 =?utf-8?B?N0xDZ0Nzc01zR1lxbnNxNXAzTlpvV1VmTEtseUJDcFczdE1vS3lpcElwRXY1?=
 =?utf-8?B?ZGhiUnpWOU5EU01WMVZ4YlJRcllBYnAvT0lJUTFzdDAvU1JuSkVpUEJVcEhN?=
 =?utf-8?B?S2NPTERpMEtYWUlzaFFCMjJUUTdGbEJydHFqRVVPR0hxNndVQ3QvWlFjNE11?=
 =?utf-8?B?a3lJV2czSmtrNm9WWFZVRUdXZW5CUzVkcC9LK3dEZlZQSkdCeFJSOExMWkJP?=
 =?utf-8?B?dDdnTUlLa1JGSkhTQVBtZGZONURUQy9yVEE0RTZqSC9pV09KWWxyOUlLN0VL?=
 =?utf-8?B?REIySHA4ZUR0aGltaFFEV0hxbXFyVnNoVytXM0UyNTRLcE10ZjNIb1hyRDFS?=
 =?utf-8?B?Y2hpVU1kcy9jNnBuYXJ0Y3NPblk1MmNmVHBGVWp1ZDdGTFhGMVl1N3RSWnVS?=
 =?utf-8?B?ZmRiZzIwUmhJbVhGaG0rWEdSVVFxL0N3WWpEbDNrdjUya3ZzM08yNmlSTHZz?=
 =?utf-8?B?WUptaGFkRERUMXdzWUYyT3FjM1E5dXloVTZJekVhakxMU0pXRXVic3V4UEFo?=
 =?utf-8?B?STJQcUxMeFgwMGpmZGk3cjY4aTZnRTlNeUxaeC9SaTA5U1lIT20wQzI4M0JN?=
 =?utf-8?B?Sm5DSUxkN2VpRmdRWlNjZ1ZGdGdjUmF6dWdDQm0rRmRLQ3NOaWlDV2EwaUVJ?=
 =?utf-8?B?Mit4YkEvcnVkbzJTTXV4bTZNZkd0VEtxdlg2NkJBQXRtM1R2RnJ0RHhBU1N2?=
 =?utf-8?B?Q1ZjK1ZjeU5WYUpId2VWL045WWlESnRmaXF2aFRWMmY0c2lFQ3Qwb1F2MVo3?=
 =?utf-8?B?NUxCd2VValRoM01oVnF0NTIzNFd6L3ZmczZIaXZnZnNOTWlZNXJSaVgvWDUw?=
 =?utf-8?B?WC9HcXFkb1dXTWI4clA3Uy9TbHRUUEZ3SjJzQjZ6U2o3OTNEdWJYc2pUTjRp?=
 =?utf-8?B?UjRIb2xKV0lUR0hTWEZpaEM4ZmhiemNrNGxHUFcwY0NPOFRIMHVBWjM2N1lZ?=
 =?utf-8?B?cEc5NGVSSWZCMGM0ZDZPZ2dMZHdsZEVESW5nb3hYOHdUZGRBOWNCeVpvUGU3?=
 =?utf-8?B?UnpXcXM4MVkxZUl1ZHl2WUYrblVBaUpibU54SlUrSTF4SDNvTU1ITUxkWkt6?=
 =?utf-8?B?UkE4Qk5DOGNOTkpucmxPZS9DZ2NpeDh3V0U1TWJQanZqd3lVcUtJSjRwMkc3?=
 =?utf-8?Q?gFZaFB4iTds/U?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a9222121-fc54-480e-6679-08de8fb896dc
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 06:33:31.1049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB4447

On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> Finish clearing out the size/last/end switching by converting
> amd_iommu_domain_flush_pages() to use last-based logic.
> 
> This algorithm is simpler than the previous. Ultimately all this wants
> to do is select powers of two that are aligned to address and not
> longer than the distance to last.
> 
> The new version is fully safe for size = U64_MAX and last = U64_MAX.
> 
> Finally, the gather can be passed through natively without risking an
> overflow in (gather->end - gather->start + 1).
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/amd_iommu.h |  2 +-
>   drivers/iommu/amd/iommu.c     | 44 +++++++++++++----------------------
>   2 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index ef4ebecb003494..67d4daaaf6f0ce 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
>    */
>   void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> -				  u64 address, size_t size);
> +				  u64 address, u64 last);
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
>   				     ioasid_t pasid, u64 address, u64 last);
>   
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index caab941b531bfe..a3773a145af811 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1762,12 +1762,13 @@ static void __domain_flush_pages(struct protection_domain *domain,
>   }
>   
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
> -				  u64 address, size_t size)
> +				  u64 address, u64 last)
>   {
>   	lockdep_assert_held(&domain->lock);
>   
> -	if (likely(!amd_iommu_np_cache)) {
> -		__domain_flush_pages(domain, address, address + size - 1);
> +	if (likely(!amd_iommu_np_cache) ||
> +	    unlikely(address == 0 && last == U64_MAX)) {
> +		__domain_flush_pages(domain, address, last);
>   
>   		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
>   		domain_flush_complete(domain);
> @@ -1785,28 +1786,17 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   	 * between the natural alignment of the address that we flush and the
>   	 * greatest naturally aligned region that fits in the range.
>   	 */
> -	while (size != 0) {
> -		int addr_alignment = __ffs(address);
> -		int size_alignment = __fls(size);
> -		int min_alignment;
> -		size_t flush_size;
> +	while (address <= last) {
> +		unsigned int sz_lg2 = ilog2(last - address + 1);
> +		u64 flush_last;
>   
> -		/*
> -		 * size is always non-zero, but address might be zero, causing
> -		 * addr_alignment to be negative. As the casting of the
> -		 * argument in __ffs(address) to long might trim the high bits
> -		 * of the address on x86-32, cast to long when doing the check.
> -		 */
> -		if (likely((unsigned long)address != 0))
> -			min_alignment = min(addr_alignment, size_alignment);
> -		else
> -			min_alignment = size_alignment;
> +		if (likely(address))
> +			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
>   
> -		flush_size = 1ul << min_alignment;
> -
> -		__domain_flush_pages(domain, address, address + flush_size - 1);
> -		address += flush_size;
> -		size -= flush_size;
> +		flush_last = address + (1ULL << sz_lg2) - 1;
> +		__domain_flush_pages(domain, address, flush_last);
> +		if (check_add_overflow(flush_last, 1, &address))
> +			break;
>   	}
>   
>   	/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
> @@ -1816,8 +1806,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   /* Flush the whole IO/TLB for a given protection domain - including PDE */
>   static void amd_iommu_domain_flush_all(struct protection_domain *domain)
>   {
> -	amd_iommu_domain_flush_pages(domain, 0,
> -				     CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
> +	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
>   }
>   
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> @@ -2617,7 +2606,7 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
>   		return 0;
>   
>   	spin_lock_irqsave(&domain->lock, flags);
> -	amd_iommu_domain_flush_pages(domain, iova, size);
> +	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
>   	spin_unlock_irqrestore(&domain->lock, flags);
>   	return 0;
>   }
> @@ -2639,8 +2628,7 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
>   	unsigned long flags;
>   
>   	spin_lock_irqsave(&dom->lock, flags);
> -	amd_iommu_domain_flush_pages(dom, gather->start,
> -				     gather->end - gather->start + 1);
> +	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
>   	spin_unlock_irqrestore(&dom->lock, flags);
>   	iommu_put_pages_list(&gather->freelist);
>   }

Looks good to me.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
