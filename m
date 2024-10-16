Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522EE207A00
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729080122; cv=fail; b=L687wUez8gVRtbyMFSDiCI36AM1v++YNsMo4iaJ4RdDBG2LJatRqoaYIRC4NaxVqoQE3FjhMt17YeBu7shJeHDQRo0uio2RUXCxYa1Y6ltcAoeamQFsQEr5OdiOMSFKF3tZ2K6I+xsDhdiYWxfULbIBNnykyAgqdEGyv8MVBL94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729080122; c=relaxed/simple;
	bh=1gIhMro5FX2ynjfBANrnZPReu6PKnHysa+3zjCKNWA8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FxzErrXJSsoCmSdChKiUWNcEI8ndq3RtENaFJawr4ZHMOmvg8SbksSQUCr1CCUza5asNgXgqE648l1AFj5/btdbItgm1yBC3BcHJFZCyD06ID1CA2H78IhUf6BDabl8s5e1+q+NUROgj6lmOqY2i4fMoqoZGNr+oTJGAmP9UmhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cbmh1NgI; arc=fail smtp.client-ip=40.107.94.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cbmh1NgI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WG25dM0h1os/vWp3mtNjnxMrqyas5aE23Q4mb8/F6Nqtd8jBRypjovfT0DYU6K8+xw2OwUOf0bA/qygxYc0ZwweYJQkxU5UUBBSi128RzLK6UEPwCoTJCePzjhPeJA5yNSWmA/AiE8vkfyi8cxOaPwClM7Jeco1xIUHLZ1rWHZpOtePjQpl/fA53HhjoyZFb5hFm/ncUbn1/LA0kFdMEnpjG/K14tfuRMgU+WRFc3d7g20zXxO20umTpQiDcajAEHL1Lftp4wH32C2cHef6KoT9FzCxT55yGbzs+LQCmtS3xH5MW8pdRdlcqnTR8aejbMdGG+19N0afRZgwY2qsKRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDkLZItEG/FpQu9r2x+tgo7/0OYq0lrxVa6RiU5/xwo=;
 b=XJP5UHZngnKYcP5AdQc/+iehZ5Zp/GliGmVvFBwXkRHjAz6eP+Q17s1R0A8raDOW1bjcMmZBKeq6ZCDgEw5FFbb/keTvP26MxeKXPA/KT2P3oVAhzkIr+k1lcezHJP6Az54dNEYo4nlMwfkNN4c8ANUNz8Z4VUZqHcZLEFhQWv29ikSPEaueiya6vOFniOF4UKKiy3Jb6xvZkNto+J4cvzhWObYgbozuEh3EQ+JT4oxrie0SoFuA/5I7TQumQrz5jPtrRCaBjmzDAxMf64EK8tkGl016QnKFvhu3XGsu46E6cbNTm7fg359C/hzF65OnmiE/ccW/hmUEDK2sGOqnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDkLZItEG/FpQu9r2x+tgo7/0OYq0lrxVa6RiU5/xwo=;
 b=cbmh1NgIgUVjh+q8mpHXImgyGyDC/dOEqh6i9VxQXIyEntwhrlC7SuRjAQEK5Ar4bOfiWjh9Z1Pgg3PfcrO1JK9CdMQk+dsAMHBekNMlWybGZ0MZW5nLIJTOSAqcZZZs3a8U4nV5+cKrIBQ5+wZflym/cskzZ+s5z4woBcIFGfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13)
 by PH7PR12MB8037.namprd12.prod.outlook.com (2603:10b6:510:27d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Wed, 16 Oct
 2024 12:01:54 +0000
Received: from SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ec7a:dd71:9d6c:3062]) by SJ0PR12MB5673.namprd12.prod.outlook.com
 ([fe80::ec7a:dd71:9d6c:3062%6]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 12:01:54 +0000
Message-ID: <50cea54b-dac0-4f41-b7d5-1c7e71010597@amd.com>
Date: Wed, 16 Oct 2024 14:01:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 076/214] drm/amdgpu: nuke the VM PD/PT shadow
 handling
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, Sasha Levin <sashal@kernel.org>
References: <20241014141044.974962104@linuxfoundation.org>
 <20241014141047.955176387@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20241014141047.955176387@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::10) To SJ0PR12MB5673.namprd12.prod.outlook.com
 (2603:10b6:a03:42b::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5673:EE_|PH7PR12MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: ffafaa66-595a-4d17-0c8b-08dcedda5378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0Jib3NaaUVreVdlM21FdnFlRXM4TEhQRzlvOTU2M0tVR00xejVKN1RzeFNr?=
 =?utf-8?B?eGpiakUyOHZhejJhUW1EOS9xaWs2VHo0N0FrR1VodWhsNEtsMVpoa1drQlBr?=
 =?utf-8?B?WUVERlVKZDFzY1ZVSEdMQ2NBWEdocmE5UFY5eUNaaFFJS1NXWGlMdGF5N2xC?=
 =?utf-8?B?QlBtaDhDWFJtblpkQmdhK0piOU5YRUpLczVubWsyUWdHS3ZVd01jY1NCOGZZ?=
 =?utf-8?B?TEplUGk0V3BoMVpzZU9JbXZERStQeWxFVE95RGtjK0FmOG1jWHUvZkRhOVlj?=
 =?utf-8?B?NHdnWml4TjloT0lUa21hWDRHUnpaZGxSVExTRW9hd2xKSXhUL3c4ck5Xc3FG?=
 =?utf-8?B?d3I5Yjkva1dnNjlndmgvT3JRSjVpa0s1TThwSUxoUk5pL0hYakNHSWdRZHp0?=
 =?utf-8?B?QmE0Y2hHZFZkS25zQ1l6aS9pbUVGTzA2YVI4VTBvZ3I1ME1tYjI4UHZYVUNO?=
 =?utf-8?B?aUt5d1lnOXVjdzJDemI2cDhMaEpRY3dEVGZUTnNuOXE1Mm14cHZ5eEFWQW1p?=
 =?utf-8?B?bng1b29MUDVHRDQ3ODE0bUdLdllSOVlaKzR0QlNUMXIraVdtZ2xndDFSWURH?=
 =?utf-8?B?dEZLaE5rek1sbUhOLzV4bzZsRlhWV1MzeDlndzg1akFTTW8xSndHM1I4Znp5?=
 =?utf-8?B?M1pSRmJVL3VKcW80RTd6a2ZvaGlCWDl1Zy9oMlFkK2ZhRTk0RnE0OUdFN3Nt?=
 =?utf-8?B?elFkTnRSWnN2dGFlVmpaRTRSaFVNa2hMdHlNVVNuYUVIZy9WejFuYjVaNmxQ?=
 =?utf-8?B?WDlWM0dEaG13L2NLNXZxbFEwQkI1TXBzWGthbkZJVnE1U0JiaXd5cEI0UW05?=
 =?utf-8?B?RlFoLzR0YWE5eFVNMW1QUlJ6L25TVjZrN0hjSXp1OUJSNFY5eVBIR2FPZy80?=
 =?utf-8?B?bEtuS1RWN0RhQWNLSnJCRm12YXJFa1B6Mk1mdmluNVVYYXJhaWpRaTNrdjUz?=
 =?utf-8?B?YkJ3Z21VNytxd1BmRnVqMlEzK3djQUVCbXhUbEJKbXI2V2loVDVQR2w4dGJP?=
 =?utf-8?B?bWlyK2lpS1luYytFMUpLblBESGY5V3hpSzFOelF0NmZDampaZjZrenIvckNT?=
 =?utf-8?B?QnZDRGlvRVhYMzRic1pTVnl4NEJ2K0VPajV1YkN0QzJSQ0hTRkY4clFYUERJ?=
 =?utf-8?B?a3NLcmpmUW5oT3VUcnVLUkhZSHlrVUxmenREWGdJOHlKZ09SbVFDbEhmbHlw?=
 =?utf-8?B?Vk9FU1RuNHhveFBlcEJHWUhhY2tSR3cvZXNoS2dySURlZHYwQTRnLzFLM2ZP?=
 =?utf-8?B?MHIyZWNuMllYS09xUyttNHhiNlhJcFVJeVlBNmF5MHd0MEF5QzhGaG1yS0N4?=
 =?utf-8?B?SXhlMmJsb0tkNWVhZUZPcVd0UVFLTEtLbnhNL2UvR3hhcW1GQXp3OSs3ckNS?=
 =?utf-8?B?M0ZJV3pETjV4TWMrbmZoVUMzNkJpZnQ4U3lDUVpQRlkvSnBWaUkzMk1qWjRK?=
 =?utf-8?B?NlBjTTZubzdmVDRGRVFiMUJIN2tqckVxKzlLbTEvaENQOWVUZW5vS3RoOUdx?=
 =?utf-8?B?cmMzWDFrZ1pHa0pJb3Rpa1gwdjJyOExMTXBIVHdZQlpockpuaFVHRlA0b3Qw?=
 =?utf-8?B?T2pLZlRQK3VEZ1lPOWFROUJ3Y2ZLdXVCNUd5Ri9HcFlIK0d5aUZBbkJuclh6?=
 =?utf-8?B?N0NmcGtkODYzVFhNMzEvcTI4MnMyOTN4RDZ3eDF1SEg2aEtQSW1PMnJWNUlF?=
 =?utf-8?B?ZGNzNi81QmZDOVQvT1VEOU4rZzQ2cE5IV1JHWmpzV3owOTBCaG44MHpRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5673.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2NKNXR5aW5iczFOSGRJaVUwbGxEelFlVUJoZU9kckJKVXJGaGkyYjg5dlRO?=
 =?utf-8?B?TC9uTXZGNm9qbVlCZmNOeXRNMmkvTGdCelNRYXd0Y2lPRmQ3dE5FL040b1Nm?=
 =?utf-8?B?Y2VScmNxaVlRL3Y0bnlxOHlYY1l2MG1jc0h1UVJSOXhtNDFpcmd4b29KbGV1?=
 =?utf-8?B?RUtxa0kvZ1VySFF0VnBwaDFqZ3l3KzNXVDJFaC9SSHh2dUZTZmR1bElVQVlk?=
 =?utf-8?B?T3g5NVdMZk1UYVR6ekVjaXMzRmM5TmpacDJFWlBxYUM4MjNwdU5wZ1hML2Vk?=
 =?utf-8?B?ODJlbjV2UWFGWHpDQVhWQTMxSVpIdnQ2eUdDcFdtM1BSNnNCdk1iQ0daWkli?=
 =?utf-8?B?YWNPSlMwRE96Wkw2WTJMUHJJeGNKQncrUzdHVDg3MUxudFc4YTl2UmFVWDkr?=
 =?utf-8?B?OG10N2Z0cW9URTZrM25wRytIRnFieTJUbGZ5RTF2U1FBWnRwY3QydDFJRUgz?=
 =?utf-8?B?L1FZbHNaM2w0dE9rY2NKT25jR3BON1BlaHg4ZXZ6eFBWTGVITnA2MGt4bzA5?=
 =?utf-8?B?VzlJOGlmeXlGTU5xbEZMa0tFNm9Cc2Vmd1Z5cE1oZW5ya1RwVm1FenVNa2Zs?=
 =?utf-8?B?TE1Ld21FTTBmMWl0cFN3WmRFQW5pc2lWRW9rQkxLdUUwb096WnV1ekR4UXBj?=
 =?utf-8?B?dVg4aGNwWXR6aGxhZE1vRVYxam9pemJuUUJDSW5wVi9wQUNPQndDbExucVY2?=
 =?utf-8?B?VVRRZFNGc0psd3ZaN2ZUQmE4S0ZDeHhSUDhjbEhieW9FMklESld6TzlUeUhR?=
 =?utf-8?B?VkEreWI4eUplV29ZeHNZZ0V3WXpRWWN5TnZKbmNLNlFONEgxb0xvYktycVM1?=
 =?utf-8?B?QnNjd3kzdHBtL3RXd2VTRnd6NUZ1Z1d6bXlTME9DQm1PbVRnVlFWR01aSTZI?=
 =?utf-8?B?K0drWVZ0S1BsajI1aXBFZWkwOXA3aUJCMGo2N0tXNElrUitPV2daam5sbXdU?=
 =?utf-8?B?SWZ1U3dPMHUyVGc0N1F3aU5jNU5ZTjd4NWdhdE9BRk5oSHJpTFE3VzROTDZ4?=
 =?utf-8?B?S2kzTkVnd3loRDZ6S3JHdU90NzRiZjAxTzZrRnRnSU5NV29EcGtMME1vTS9r?=
 =?utf-8?B?QVUvcUdXMm1tTDExVy84ZUorTjJQWTd4SElNYWovcmpSRVA5dENYN09Oak0x?=
 =?utf-8?B?cG0ycTdDU25BTndiZXQ0QTM4Y1pDNk9TWDFudkZYRWIwaWMvSEhBdGdjYWQw?=
 =?utf-8?B?REZsZHNFYjQrUXlCa0N6ZUU4NkYzK2hKajhPNGk4a2RFdUJVWnIxTitlK0Nk?=
 =?utf-8?B?aitWaE5YWjYzZHRTMVhNeWYzUEdmT0dsSFRHYSs2UzdkbGJMTnhFckt0WjJE?=
 =?utf-8?B?YTljWHBYVy9tU0o1bDlxMFNmenpjd1N1VlRZTm1yRk9VT00rMDhMVlhybTRP?=
 =?utf-8?B?aEx5RkFrNElkVnFNeFJ4eUl1WEtEcmw3N1ZhOXNCTW5SSmxVZHV1RVd5Rlc4?=
 =?utf-8?B?azh5WVdhcG0vYTRyUGs4aTV2dkFiRHI3NXFPQzh1c2ttOTUxTGVIN2ZWWCth?=
 =?utf-8?B?SGJEYnU1ZW9FcUsrM09CeEt5WWJQMjZaSFVwWk03UUI4dlBGcVpMbUdFek5E?=
 =?utf-8?B?bjdmenp0U2ljQ2hLK3hFRENoOWZuRkNYdnJmR3A3TmhDUW9lUllUZmYybTdr?=
 =?utf-8?B?aGVjSmZsRk0yUG5tR3JTdFBGcFR4M0kzRnJCT3IzRjc4SjVEMHI2UkcyZlFj?=
 =?utf-8?B?aGZSZUJxQ1RCZjBRU1NKa2Ryeks3dm5lSEJJUjMxK1ZRSEFISElrOHNPNUFV?=
 =?utf-8?B?Tk4xV0tndzR6dk9WZzhaUU1SU1gwV2c5dzNnMExxNE5PcERMUGNJbjVUaVF1?=
 =?utf-8?B?dDl5WFV3SWtMRmVPcEM5b3paWGJmYlRFMlF6OVIrNnlCMk1WdkhqYzM0dGhH?=
 =?utf-8?B?dmEwbDY4dlExV2QvYVRMNHF2TEdoaUp2K3o5YTZyVGNRa201OGhCdHJYdzM4?=
 =?utf-8?B?L1RtRXc3bWlLdU92MW81SXhyYVZ0a0JoZ0dPaUI4RjM0d2tWbm9WY0xpT3lF?=
 =?utf-8?B?UmRWbVpHK1dLWmEvQWd1RjNQL0ZhN05zRUJReVBDK0VJYWNENDVwaHJ6SEhQ?=
 =?utf-8?B?amczYUpPOStPUDV1dnIxU3d4dDBMelFlaTJaRlJKbkxTdXNxVGxEVnQ2Y1Rr?=
 =?utf-8?Q?n2q8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffafaa66-595a-4d17-0c8b-08dcedda5378
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5673.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 12:01:54.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cbu8nxsjuZm94GHQK68Ixwveyet1X2R7zZjCXmQzLArISSyuzUQsQ3BknE2tZXKF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8037

Hey Greg & Sasha,

I've pointed out before that this patch here shouldn't be backported.

The patch just removes an unused feature on the current development 
kernel, but I can't guarantee that this feature is unused on older kernels.

Please don't backport this!

Regards,
Christian.

Am 14.10.24 um 16:18 schrieb Greg Kroah-Hartman:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Christian König <christian.koenig@amd.com>
>
> [ Upstream commit 7181faaa4703705939580abffaf9cb5d6b50dbb7 ]
>
> This was only used as workaround for recovering the page tables after
> VRAM was lost and is no longer necessary after the function
> amdgpu_vm_bo_reset_state_machine() started to do the same.
>
> Compute never used shadows either, so the only proplematic case left is
> SVM and that is most likely not recoverable in any way when VRAM is
> lost.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> Acked-by: Lijo Lazar <lijo.lazar@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu.h         |  4 -
>   drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  | 87 +--------------------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  | 67 +---------------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_object.h  | 21 -----
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c      | 17 ----
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c   | 56 +------------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 19 +----
>   7 files changed, 6 insertions(+), 265 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> index 137a88b8de453..a1b2bf3db55b8 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
> @@ -1091,10 +1091,6 @@ struct amdgpu_device {
>   
>   	struct amdgpu_virt	virt;
>   
> -	/* link all shadow bo */
> -	struct list_head                shadow_list;
> -	struct mutex                    shadow_list_lock;
> -
>   	/* record hw reset is performed */
>   	bool has_hw_reset;
>   	u8				reset_magic[AMDGPU_RESET_MAGIC_NUM];
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> index bcacf2e35eba0..dfd468729d52b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
> @@ -4073,9 +4073,6 @@ int amdgpu_device_init(struct amdgpu_device *adev,
>   	spin_lock_init(&adev->mm_stats.lock);
>   	spin_lock_init(&adev->wb.lock);
>   
> -	INIT_LIST_HEAD(&adev->shadow_list);
> -	mutex_init(&adev->shadow_list_lock);
> -
>   	INIT_LIST_HEAD(&adev->reset_list);
>   
>   	INIT_LIST_HEAD(&adev->ras_list);
> @@ -4980,80 +4977,6 @@ static int amdgpu_device_ip_post_soft_reset(struct amdgpu_device *adev)
>   	return 0;
>   }
>   
> -/**
> - * amdgpu_device_recover_vram - Recover some VRAM contents
> - *
> - * @adev: amdgpu_device pointer
> - *
> - * Restores the contents of VRAM buffers from the shadows in GTT.  Used to
> - * restore things like GPUVM page tables after a GPU reset where
> - * the contents of VRAM might be lost.
> - *
> - * Returns:
> - * 0 on success, negative error code on failure.
> - */
> -static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
> -{
> -	struct dma_fence *fence = NULL, *next = NULL;
> -	struct amdgpu_bo *shadow;
> -	struct amdgpu_bo_vm *vmbo;
> -	long r = 1, tmo;
> -
> -	if (amdgpu_sriov_runtime(adev))
> -		tmo = msecs_to_jiffies(8000);
> -	else
> -		tmo = msecs_to_jiffies(100);
> -
> -	dev_info(adev->dev, "recover vram bo from shadow start\n");
> -	mutex_lock(&adev->shadow_list_lock);
> -	list_for_each_entry(vmbo, &adev->shadow_list, shadow_list) {
> -		/* If vm is compute context or adev is APU, shadow will be NULL */
> -		if (!vmbo->shadow)
> -			continue;
> -		shadow = vmbo->shadow;
> -
> -		/* No need to recover an evicted BO */
> -		if (!shadow->tbo.resource ||
> -		    shadow->tbo.resource->mem_type != TTM_PL_TT ||
> -		    shadow->tbo.resource->start == AMDGPU_BO_INVALID_OFFSET ||
> -		    shadow->parent->tbo.resource->mem_type != TTM_PL_VRAM)
> -			continue;
> -
> -		r = amdgpu_bo_restore_shadow(shadow, &next);
> -		if (r)
> -			break;
> -
> -		if (fence) {
> -			tmo = dma_fence_wait_timeout(fence, false, tmo);
> -			dma_fence_put(fence);
> -			fence = next;
> -			if (tmo == 0) {
> -				r = -ETIMEDOUT;
> -				break;
> -			} else if (tmo < 0) {
> -				r = tmo;
> -				break;
> -			}
> -		} else {
> -			fence = next;
> -		}
> -	}
> -	mutex_unlock(&adev->shadow_list_lock);
> -
> -	if (fence)
> -		tmo = dma_fence_wait_timeout(fence, false, tmo);
> -	dma_fence_put(fence);
> -
> -	if (r < 0 || tmo <= 0) {
> -		dev_err(adev->dev, "recover vram bo from shadow failed, r is %ld, tmo is %ld\n", r, tmo);
> -		return -EIO;
> -	}
> -
> -	dev_info(adev->dev, "recover vram bo from shadow done\n");
> -	return 0;
> -}
> -
> -
>   /**
>    * amdgpu_device_reset_sriov - reset ASIC for SR-IOV vf
>    *
> @@ -5116,12 +5039,8 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
>   	if (r)
>   		return r;
>   
> -	if (adev->virt.gim_feature & AMDGIM_FEATURE_GIM_FLR_VRAMLOST) {
> +	if (adev->virt.gim_feature & AMDGIM_FEATURE_GIM_FLR_VRAMLOST)
>   		amdgpu_inc_vram_lost(adev);
> -		r = amdgpu_device_recover_vram(adev);
> -	}
> -	if (r)
> -		return r;
>   
>   	/* need to be called during full access so we can't do it later like
>   	 * bare-metal does.
> @@ -5541,9 +5460,7 @@ int amdgpu_do_asic_reset(struct list_head *device_list_handle,
>   			}
>   		}
>   
> -		if (!r)
> -			r = amdgpu_device_recover_vram(tmp_adev);
> -		else
> +		if (r)
>   			tmp_adev->asic_reset_res = r;
>   	}
>   
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> index e32161f6b67a3..a987f671b1d53 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
> @@ -77,24 +77,6 @@ static void amdgpu_bo_user_destroy(struct ttm_buffer_object *tbo)
>   	amdgpu_bo_destroy(tbo);
>   }
>   
> -static void amdgpu_bo_vm_destroy(struct ttm_buffer_object *tbo)
> -{
> -	struct amdgpu_device *adev = amdgpu_ttm_adev(tbo->bdev);
> -	struct amdgpu_bo *shadow_bo = ttm_to_amdgpu_bo(tbo), *bo;
> -	struct amdgpu_bo_vm *vmbo;
> -
> -	bo = shadow_bo->parent;
> -	vmbo = to_amdgpu_bo_vm(bo);
> -	/* in case amdgpu_device_recover_vram got NULL of bo->parent */
> -	if (!list_empty(&vmbo->shadow_list)) {
> -		mutex_lock(&adev->shadow_list_lock);
> -		list_del_init(&vmbo->shadow_list);
> -		mutex_unlock(&adev->shadow_list_lock);
> -	}
> -
> -	amdgpu_bo_destroy(tbo);
> -}
> -
>   /**
>    * amdgpu_bo_is_amdgpu_bo - check if the buffer object is an &amdgpu_bo
>    * @bo: buffer object to be checked
> @@ -108,8 +90,7 @@ static void amdgpu_bo_vm_destroy(struct ttm_buffer_object *tbo)
>   bool amdgpu_bo_is_amdgpu_bo(struct ttm_buffer_object *bo)
>   {
>   	if (bo->destroy == &amdgpu_bo_destroy ||
> -	    bo->destroy == &amdgpu_bo_user_destroy ||
> -	    bo->destroy == &amdgpu_bo_vm_destroy)
> +	    bo->destroy == &amdgpu_bo_user_destroy)
>   		return true;
>   
>   	return false;
> @@ -722,52 +703,6 @@ int amdgpu_bo_create_vm(struct amdgpu_device *adev,
>   	return r;
>   }
>   
> -/**
> - * amdgpu_bo_add_to_shadow_list - add a BO to the shadow list
> - *
> - * @vmbo: BO that will be inserted into the shadow list
> - *
> - * Insert a BO to the shadow list.
> - */
> -void amdgpu_bo_add_to_shadow_list(struct amdgpu_bo_vm *vmbo)
> -{
> -	struct amdgpu_device *adev = amdgpu_ttm_adev(vmbo->bo.tbo.bdev);
> -
> -	mutex_lock(&adev->shadow_list_lock);
> -	list_add_tail(&vmbo->shadow_list, &adev->shadow_list);
> -	vmbo->shadow->parent = amdgpu_bo_ref(&vmbo->bo);
> -	vmbo->shadow->tbo.destroy = &amdgpu_bo_vm_destroy;
> -	mutex_unlock(&adev->shadow_list_lock);
> -}
> -
> -/**
> - * amdgpu_bo_restore_shadow - restore an &amdgpu_bo shadow
> - *
> - * @shadow: &amdgpu_bo shadow to be restored
> - * @fence: dma_fence associated with the operation
> - *
> - * Copies a buffer object's shadow content back to the object.
> - * This is used for recovering a buffer from its shadow in case of a gpu
> - * reset where vram context may be lost.
> - *
> - * Returns:
> - * 0 for success or a negative error code on failure.
> - */
> -int amdgpu_bo_restore_shadow(struct amdgpu_bo *shadow, struct dma_fence **fence)
> -
> -{
> -	struct amdgpu_device *adev = amdgpu_ttm_adev(shadow->tbo.bdev);
> -	struct amdgpu_ring *ring = adev->mman.buffer_funcs_ring;
> -	uint64_t shadow_addr, parent_addr;
> -
> -	shadow_addr = amdgpu_bo_gpu_offset(shadow);
> -	parent_addr = amdgpu_bo_gpu_offset(shadow->parent);
> -
> -	return amdgpu_copy_buffer(ring, shadow_addr, parent_addr,
> -				  amdgpu_bo_size(shadow), NULL, fence,
> -				  true, false, 0);
> -}
> -
>   /**
>    * amdgpu_bo_kmap - map an &amdgpu_bo buffer object
>    * @bo: &amdgpu_bo buffer object to be mapped
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
> index bc42ccbde659a..a4fa1f296daec 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
> @@ -130,8 +130,6 @@ struct amdgpu_bo_user {
>   
>   struct amdgpu_bo_vm {
>   	struct amdgpu_bo		bo;
> -	struct amdgpu_bo		*shadow;
> -	struct list_head		shadow_list;
>   	struct amdgpu_vm_bo_base        entries[];
>   };
>   
> @@ -269,22 +267,6 @@ static inline bool amdgpu_bo_encrypted(struct amdgpu_bo *bo)
>   	return bo->flags & AMDGPU_GEM_CREATE_ENCRYPTED;
>   }
>   
> -/**
> - * amdgpu_bo_shadowed - check if the BO is shadowed
> - *
> - * @bo: BO to be tested.
> - *
> - * Returns:
> - * NULL if not shadowed or else return a BO pointer.
> - */
> -static inline struct amdgpu_bo *amdgpu_bo_shadowed(struct amdgpu_bo *bo)
> -{
> -	if (bo->tbo.type == ttm_bo_type_kernel)
> -		return to_amdgpu_bo_vm(bo)->shadow;
> -
> -	return NULL;
> -}
> -
>   bool amdgpu_bo_is_amdgpu_bo(struct ttm_buffer_object *bo);
>   void amdgpu_bo_placement_from_domain(struct amdgpu_bo *abo, u32 domain);
>   
> @@ -343,9 +325,6 @@ u64 amdgpu_bo_gpu_offset(struct amdgpu_bo *bo);
>   u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo);
>   void amdgpu_bo_get_memory(struct amdgpu_bo *bo,
>   			  struct amdgpu_mem_stats *stats);
> -void amdgpu_bo_add_to_shadow_list(struct amdgpu_bo_vm *vmbo);
> -int amdgpu_bo_restore_shadow(struct amdgpu_bo *shadow,
> -			     struct dma_fence **fence);
>   uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
>   					    uint32_t domain);
>   
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> index 119eebeb16b7f..03c32f5cbd319 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
> @@ -465,7 +465,6 @@ int amdgpu_vm_validate(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   {
>   	uint64_t new_vm_generation = amdgpu_vm_generation(adev, vm);
>   	struct amdgpu_vm_bo_base *bo_base;
> -	struct amdgpu_bo *shadow;
>   	struct amdgpu_bo *bo;
>   	int r;
>   
> @@ -486,16 +485,10 @@ int amdgpu_vm_validate(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   		spin_unlock(&vm->status_lock);
>   
>   		bo = bo_base->bo;
> -		shadow = amdgpu_bo_shadowed(bo);
>   
>   		r = validate(param, bo);
>   		if (r)
>   			return r;
> -		if (shadow) {
> -			r = validate(param, shadow);
> -			if (r)
> -				return r;
> -		}
>   
>   		if (bo->tbo.type != ttm_bo_type_kernel) {
>   			amdgpu_vm_bo_moved(bo_base);
> @@ -2125,10 +2118,6 @@ void amdgpu_vm_bo_invalidate(struct amdgpu_device *adev,
>   {
>   	struct amdgpu_vm_bo_base *bo_base;
>   
> -	/* shadow bo doesn't have bo base, its validation needs its parent */
> -	if (bo->parent && (amdgpu_bo_shadowed(bo->parent) == bo))
> -		bo = bo->parent;
> -
>   	for (bo_base = bo->vm_bo; bo_base; bo_base = bo_base->next) {
>   		struct amdgpu_vm *vm = bo_base->vm;
>   
> @@ -2456,7 +2445,6 @@ int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   	root_bo = amdgpu_bo_ref(&root->bo);
>   	r = amdgpu_bo_reserve(root_bo, true);
>   	if (r) {
> -		amdgpu_bo_unref(&root->shadow);
>   		amdgpu_bo_unref(&root_bo);
>   		goto error_free_delayed;
>   	}
> @@ -2548,11 +2536,6 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm)
>   	vm->last_update = dma_fence_get_stub();
>   	vm->is_compute_context = true;
>   
> -	/* Free the shadow bo for compute VM */
> -	amdgpu_bo_unref(&to_amdgpu_bo_vm(vm->root.bo)->shadow);
> -
> -	goto unreserve_bo;
> -
>   unreserve_bo:
>   	amdgpu_bo_unreserve(vm->root.bo);
>   	return r;
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
> index e39d6e7643bfb..c8e0b8cfd3363 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
> @@ -383,14 +383,6 @@ int amdgpu_vm_pt_clear(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   	if (r)
>   		return r;
>   
> -	if (vmbo->shadow) {
> -		struct amdgpu_bo *shadow = vmbo->shadow;
> -
> -		r = ttm_bo_validate(&shadow->tbo, &shadow->placement, &ctx);
> -		if (r)
> -			return r;
> -	}
> -
>   	if (!drm_dev_enter(adev_to_drm(adev), &idx))
>   		return -ENODEV;
>   
> @@ -448,10 +440,7 @@ int amdgpu_vm_pt_create(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   			int32_t xcp_id)
>   {
>   	struct amdgpu_bo_param bp;
> -	struct amdgpu_bo *bo;
> -	struct dma_resv *resv;
>   	unsigned int num_entries;
> -	int r;
>   
>   	memset(&bp, 0, sizeof(bp));
>   
> @@ -484,42 +473,7 @@ int amdgpu_vm_pt_create(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   	if (vm->root.bo)
>   		bp.resv = vm->root.bo->tbo.base.resv;
>   
> -	r = amdgpu_bo_create_vm(adev, &bp, vmbo);
> -	if (r)
> -		return r;
> -
> -	bo = &(*vmbo)->bo;
> -	if (vm->is_compute_context || (adev->flags & AMD_IS_APU)) {
> -		(*vmbo)->shadow = NULL;
> -		return 0;
> -	}
> -
> -	if (!bp.resv)
> -		WARN_ON(dma_resv_lock(bo->tbo.base.resv,
> -				      NULL));
> -	resv = bp.resv;
> -	memset(&bp, 0, sizeof(bp));
> -	bp.size = amdgpu_vm_pt_size(adev, level);
> -	bp.domain = AMDGPU_GEM_DOMAIN_GTT;
> -	bp.flags = AMDGPU_GEM_CREATE_CPU_GTT_USWC;
> -	bp.type = ttm_bo_type_kernel;
> -	bp.resv = bo->tbo.base.resv;
> -	bp.bo_ptr_size = sizeof(struct amdgpu_bo);
> -	bp.xcp_id_plus1 = xcp_id + 1;
> -
> -	r = amdgpu_bo_create(adev, &bp, &(*vmbo)->shadow);
> -
> -	if (!resv)
> -		dma_resv_unlock(bo->tbo.base.resv);
> -
> -	if (r) {
> -		amdgpu_bo_unref(&bo);
> -		return r;
> -	}
> -
> -	amdgpu_bo_add_to_shadow_list(*vmbo);
> -
> -	return 0;
> +	return amdgpu_bo_create_vm(adev, &bp, vmbo);
>   }
>   
>   /**
> @@ -569,7 +523,6 @@ static int amdgpu_vm_pt_alloc(struct amdgpu_device *adev,
>   	return 0;
>   
>   error_free_pt:
> -	amdgpu_bo_unref(&pt->shadow);
>   	amdgpu_bo_unref(&pt_bo);
>   	return r;
>   }
> @@ -581,17 +534,10 @@ static int amdgpu_vm_pt_alloc(struct amdgpu_device *adev,
>    */
>   static void amdgpu_vm_pt_free(struct amdgpu_vm_bo_base *entry)
>   {
> -	struct amdgpu_bo *shadow;
> -
>   	if (!entry->bo)
>   		return;
>   
>   	entry->bo->vm_bo = NULL;
> -	shadow = amdgpu_bo_shadowed(entry->bo);
> -	if (shadow) {
> -		ttm_bo_set_bulk_move(&shadow->tbo, NULL);
> -		amdgpu_bo_unref(&shadow);
> -	}
>   	ttm_bo_set_bulk_move(&entry->bo->tbo, NULL);
>   
>   	spin_lock(&entry->vm->status_lock);
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> index 9b748d7058b5c..390432a22ddd5 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
> @@ -35,16 +35,7 @@
>    */
>   static int amdgpu_vm_sdma_map_table(struct amdgpu_bo_vm *table)
>   {
> -	int r;
> -
> -	r = amdgpu_ttm_alloc_gart(&table->bo.tbo);
> -	if (r)
> -		return r;
> -
> -	if (table->shadow)
> -		r = amdgpu_ttm_alloc_gart(&table->shadow->tbo);
> -
> -	return r;
> +	return amdgpu_ttm_alloc_gart(&table->bo.tbo);
>   }
>   
>   /* Allocate a new job for @count PTE updates */
> @@ -273,17 +264,13 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
>   
>   		if (!p->pages_addr) {
>   			/* set page commands needed */
> -			if (vmbo->shadow)
> -				amdgpu_vm_sdma_set_ptes(p, vmbo->shadow, pe, addr,
> -							count, incr, flags);
>   			amdgpu_vm_sdma_set_ptes(p, bo, pe, addr, count,
>   						incr, flags);
>   			return 0;
>   		}
>   
>   		/* copy commands needed */
> -		ndw -= p->adev->vm_manager.vm_pte_funcs->copy_pte_num_dw *
> -			(vmbo->shadow ? 2 : 1);
> +		ndw -= p->adev->vm_manager.vm_pte_funcs->copy_pte_num_dw;
>   
>   		/* for padding */
>   		ndw -= 7;
> @@ -298,8 +285,6 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
>   			pte[i] |= flags;
>   		}
>   
> -		if (vmbo->shadow)
> -			amdgpu_vm_sdma_copy_ptes(p, vmbo->shadow, pe, nptes);
>   		amdgpu_vm_sdma_copy_ptes(p, bo, pe, nptes);
>   
>   		pe += nptes * 8;

