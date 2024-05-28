Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78613C3F4
	for <patches@lists.linux.dev>; Tue, 28 May 2024 09:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716887063; cv=fail; b=pH/j+BjThHhrRRDTQ79agKcv/omxI+COIDSmK9Y9VTTMbJpOhnTD+qzF2SQ+L7EJlHaXoTNB582EDVgsJMbVpaYwgeRrnMlNiIS9Ss82FF02YmSEAJQkLj+Y+ZFX/o2YCg17n3mW1+YG6t0zg0YrASyajuqOWgReFZKSi6tYaLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716887063; c=relaxed/simple;
	bh=U/6t4EdUyernz40SwKm49isfuohvYIC9KZyy5Jend0o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p43vmUgX4D2jqNYfW48J35Q8ZT2VEqdU2qubdflYkY1W9TsY3efhdB8Vm5FXUHbiqX0ZGVnR4ZJu7tQluQmyqqM9owWYyGtbrUjw72oskKH5j4V+SW6W1+jVTibbNRvOBY+sVBAryLlfSOmWmDdgYQL39/JpVB7UWVkdW2jVruk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B58nwL9w; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B58nwL9w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRWMzXuqvwdrQBA3lL+yemMr3fpto5NFP7WntoAT23ls8OqNSw+THKuZmfVP6YFyfIvUgrojzd37L1qyVMIUR8GeFF/86LxKUIy1iLvXljEZkwVR2stvPG0O+YZcHauzPOqUfe+Ruq85bqIP3NSoGNYMmKByiYFi2Vw3Bo3vy19+bGt4ByfGza+/4jJqySQBQUsHSDl2W2IzTBWJAkr+rok19LNb73rv5OvYdXbTL3cu8IE/Q0ziRYXsLvd1UM+z9zuHWlATKOnKLovfrmnyExmjnLOjoOWUVXY/LEM00+OsofGcTrq8JDVJhbkLdheihscjRLmLyLk7GhsAXtDChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NqjO0O75gWJHXT+MegF4rNTrxPmt+QzlOPsyLpvSjE=;
 b=nkggd4Y/0fh1Aq2P0c2EHQu3MKgLJF4En0VHkedmWoi39gcFyG+HLSIoHlZixjOPaaisFzBIEqQTpr/WYsCPXOOT8jEjAclNdavpz3R9QWa7jIsa7oBjuYzNvzNaw3As0Wy1QtjUfH0UDbVhXHLM2vQGhXk6Xy7U8qr/oeTrnxeXPKCi2aISjHLLzmehf+SLNKA+JBNIqHNvScpqnFyFGZS7gvEtgGS7Bo+E7UwJj4qX5cisj7fNvHthR6n4bRTfxwAyoHiYn9s5FIklACbzhffxb1J5hL84RhIxd6KjlPSe0WTolTjOFkfhf+Z+8UvHKLtvn7xtxD3nkSTKbHodsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NqjO0O75gWJHXT+MegF4rNTrxPmt+QzlOPsyLpvSjE=;
 b=B58nwL9w+hJP8ps/o3A7HV7p1uGIOYg48pgVppiOM6TVhnkKIju0ZLmnpiUJ1M6ILqgc8IW4q+MRV47XLA+6RtPvBBB46o75QNFfPPhG4eUOFYcau0lJb/WdxyMSGs1llr/5NpHuFCSdGkhLSaZOK8A0TTCz5Q88Hxg5WIuYa90VKuvsr/4Wi3X3TIQlFIcpilydF62pYZaQPEGKqthdm5qxIkJMVH6AM6t2L01vbsRr9OVeTMChEmQYviNbuM6TiPb8MKMPeWltnCk4HacFK2f0VjOLhgxCETj0d7kycrchkRrmRRbOsmgUc7++evSwV+XM1qJmMB27c15HWPkZ6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 09:04:16 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7587.035; Tue, 28 May 2024
 09:04:15 +0000
Message-ID: <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
Date: Tue, 28 May 2024 10:04:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Chuck Lever III <chuck.lever@oracle.com>, NeilBrown <neilb@suse.de>,
 Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
 <2024052541-likeness-banjo-e147@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2024052541-likeness-banjo-e147@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0390.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::18) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 08e6054a-dae0-4b80-940c-08dc7ef5264f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUs1Z2RSWjZwZDFjWm5JWDkvNWI5V3N6ZzZRMXhGN1A5MHVweUJPQ2dZN3Jt?=
 =?utf-8?B?dStxOVFEenQ1UmRZdFptNUhKWmowZmRmb2VtMmFjSHJpZ1VweWorbmw4NENF?=
 =?utf-8?B?NzhPaW13TkpsZ2QwUXNiNmw3VWZENWlZQ2FTeXhQRDR5eGRtZHJ0c3N4WFFP?=
 =?utf-8?B?Z3B2U1BoUm5FVEo3N0gyM3lXTnRjN3lYWVZxQUpBZWZZUGVRRDhTamZFZ2h2?=
 =?utf-8?B?Vi9pYlI0RU84N2ZDUVNvY1NZYjM3Ym92bFl0andCV3VOMGVHUGZidEU0dnI2?=
 =?utf-8?B?VlUvTkt5RVYvU2J0N1FtN1E3ZzRjUmpzQ1A4RTZYRWltNjQrdTJHSDQ3RUlV?=
 =?utf-8?B?c3I3WXM1NVF4VHFuMW5DeGVOdG45dDlHQVNCZWdQa2ZyUzFtSGtjMFdublVw?=
 =?utf-8?B?bGQzQVliYXdoblR4dUFMZm1ENTV2bExCeFZHb3htVnJ6WUxCYityWDI0WXdz?=
 =?utf-8?B?eEdqaGxUblArVFNrMHpFdUJadzhQRDRxY0pzUUZzSy8ycnNHUktZekRWOHUx?=
 =?utf-8?B?K3IwUEwvR0V2RDVoWkgyUGJmWXMrc29sazl3T005Z2ZXdFJDRG1OVVgvbm9D?=
 =?utf-8?B?RjRlVkdYUVErODNveE5RejcwNEUrRCtEVGJ0aHhDSmxpOEhraXk4SWJMUmx0?=
 =?utf-8?B?NDl0S2NYNlFNakdKeGRLZk4yWFlPTk5sWU1rLzYxcG1xQUxlMDNualN0czhM?=
 =?utf-8?B?RER2ZzJHN3o2VEo4akhES3JRWXVIUlJYN29sRGprTjR5MGJFMVlXK0E5cGsr?=
 =?utf-8?B?VGNiREYwL3dvQlhPTUIvTGdQOExWdGhXSGowcnlWUlk5LzRnTHBSNDNvNE14?=
 =?utf-8?B?TFV2ekJlV2NCb0I0cDBObG9TQmVoT1dGVjRSNUJWTXhwN0I2K1B4WEpjM2tn?=
 =?utf-8?B?RVU1Q0xPTFJ2alpja1Nxb1d6aGJRSk91Wm9YOG80M2ZLT3VDbWZUL1JrWFlh?=
 =?utf-8?B?Z2F5UXpmYzBzc25vb2FWWkxZNmF2TXdpemc5bUUvQ2RLZk5ia2cwWVdPQ01E?=
 =?utf-8?B?WTJVYmtoL3oxWTZZWEN3Nk8yT3BXQWlKRk1mUC94Ukw4d01raTdiSmhPcis5?=
 =?utf-8?B?VDd2M1hITjVpZmt2elB3WFU5MnpRWVA1ZTlqdVJzdWJwdWZmK0R1cDNKRnYv?=
 =?utf-8?B?bUQ4VFJaaUpoK0xZaUdhaDNUWU5ETGNtZG9YUFpVL0hiUkhmWnZGS1lWVUhs?=
 =?utf-8?B?ZUkyUng2VGlyVHpHaXlFK0tydFRtSVZYQ1VoQjhwcHJkVGtHMFI4bkNyOEo0?=
 =?utf-8?B?aW8zOThCTXIwU3hvcGk5SXcrUFdjVDhNVitXZ0pMM0t2emFrNUptaDJQZ2p6?=
 =?utf-8?B?LzFoeWxVejVJMDZsOENpUnZQZEdWdVNDcmtaLzBYbjNUOGR0VElJWFpQUHhs?=
 =?utf-8?B?OEdFcUgxbzBaVTBBWkR1blEyOGxJVXpPamdWTjBCN1VOZm1XMlVKWERUakpS?=
 =?utf-8?B?SkhMbnFEWlBEeDBoLzRhSFAvalE2UU9aTmVVekM0ak9sOHNkc2t3TnEyd2py?=
 =?utf-8?B?aWwzRm5RU0crYUhveVpyVU9ESUpiYXNMZTB0eU9MajUrYlRFSCtZTG1wc0Rl?=
 =?utf-8?B?Y2tIcW1sdEQyZlNEZkd6RnkvcVQ5cGFWU0E0eFBaOGt2eUtiYWtQcy9hckls?=
 =?utf-8?B?ek5sOUdBNWltRGhEMkswTlNEVzRNVzVIMFRld0NReVFEdUJhSkUyRHpoVG0w?=
 =?utf-8?B?NmFMYU85SithakJheE9iTTFlUzliMFBhVTdLQTA2dWQvU284R01jeFp0L09l?=
 =?utf-8?Q?ZiCXDmNI6Qr9kwmjX8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bE05TGx4OVdWajdGUXQ0dStXMzJRNEhnZnF2OXlmcUd6aDM1cllUU1FmZnF1?=
 =?utf-8?B?aHd6amQ3OCtzVG1pNzQvb3N5VUxlbzBvRGZZTVhqNDRKYithQnBISmdIalNx?=
 =?utf-8?B?dWtuM1pEL1BUM1BjZ2ZiUE1GaU9IbEZvZVdrQ1R2UUYvV1hCVmppQmRVRWZU?=
 =?utf-8?B?alVSQmVLU2V1Y3ZLYVpuS2EwVm5odWFOZ1hJTmgwYWRERkJyK2l3YTl1UVpv?=
 =?utf-8?B?YUJIUW1jTEJvVW0zZ3ZPZWtZZno0QlBpUDZsdFVQd2NWOVgybkZGWndaK2NS?=
 =?utf-8?B?bzdUb3gzdWErUHBweHNNWUduYTM3QzNQR3VQcUh0UDY3VTZlS2E1S1JFUmsw?=
 =?utf-8?B?MnFPZ2RGQ2poaEZ5aE5wUnNoYUpOUmpmNkUrL0lYaUhIWEJFZjVKUGJSdlVi?=
 =?utf-8?B?WjR1dWhvenBWSHFabkdrQ1JaWHh6TVc4cUtzYkFiVCsyLzhjSG5oaVZHU2F3?=
 =?utf-8?B?MHFkeEJBSGxQVXVVWnpxbTlkMTdWS1RLdzVXS0l2V3BiZXRFNG9Hck1lczdK?=
 =?utf-8?B?VHZHYUpPbXYzRXBqMkd5NWg2QW9wdGdZSHU0OU1VT1VCdEtnQmJ2bUxEcmg3?=
 =?utf-8?B?K3RiemhvUFlQNUhFK0k5Yk5vR2psaHBJQkV5TTJBV3A2b2l4alZoQUUwSzQ4?=
 =?utf-8?B?dTY0ZmpVN21XeXBjOVNjZ2l0c0xHaHg3V05CbVlGVE5BMlNoSXNtb2V5c0FL?=
 =?utf-8?B?cXFjcUJNZkRhZEVKS1JjK1BWMnVCbFVJWWU0bmlPYXQzeFBZR004MGdVMndD?=
 =?utf-8?B?L1U1Qmtvd2lmR2dmS3I1VnRoSUJzZ1Z2eXltb2tjSXI0dTR4U0F2TTg0NzlK?=
 =?utf-8?B?TTArVk9PNXV4ajVzMms1VW13K3hFdEZlUkJwMXA2UTVvc09oWWIrYVFpZnNS?=
 =?utf-8?B?VEtwTVVRUHkrZUNwYVFEWTBMZEtwQ2toUWk0VEZnSXhhTWhaak41YXo1TnNy?=
 =?utf-8?B?TE9GZjFFUTNsTU9UMHlBS2JpYXZRYUlDa1pXWUEyTWgxZjAxVmhVdGRDaDkw?=
 =?utf-8?B?RWkvZmtBSmFEYk5MUm9NZXZ4Wjc4MWFvTGxYTVJKSUtwNmpFcHYyTWNDR3Bn?=
 =?utf-8?B?STJEc2dhd3FJZjlnZUdwMjRiam9aWWNMbHBzUHRucXBPdFhUNGx3TkdXS01D?=
 =?utf-8?B?bkVHanlOZk1pVGJSb0tIbmUwZkdhT0xSZ0liMUJzSnlpVThnSTd6eDd0N0I1?=
 =?utf-8?B?V1hlOG5MZTdON2JpcmJKckpPMzIrejNaWmxzd3NZVm5NREZzQWNMb05nQmdu?=
 =?utf-8?B?eHNIMVlzVUJHdEE4cVN2akVFek1IQi9Qa25hc3JydGdPUytSWGUxRzZqOXN2?=
 =?utf-8?B?VXhSWWttN1ZGaGhlVHF6eU8wclIvaE9MSDhvZlY0eVRVZTFYcG1IcGE0NC94?=
 =?utf-8?B?RU5TeHYzWml6bHNZcmE1Rjh5dVc2QTlueUx3Rk4rVHRFZ1I3bmFFb3lIcXZ5?=
 =?utf-8?B?dUVObGNzTXJkL3pjMnZUa1l3amZoajRCWGJGNnpuRm5vMFRTc0kwcXlzWklq?=
 =?utf-8?B?bmc2UXBzdXQ4eFRTTjNrZ3NUT0JmMXNQY0hUQTVobVpBMEszRkFTN08xNkNC?=
 =?utf-8?B?V0FTSks2U2wybDExR1VBT0lsd2g2WFJHeUJFalpyL2habEdBWkJENXFzUEw1?=
 =?utf-8?B?VnpOcEJlT0NyNmVEYkN1NHI0T2VoWUVjSTlyb2Uvc2hSUjBYSFFjLy9VdFJs?=
 =?utf-8?B?cWpla1o0bGJHWjFWZG9vUER1b2t1WlIxTC9wM2pqbTMzYXJQNHk1Z2EvdGpw?=
 =?utf-8?B?UkxjNHgzc0VITW1ydUViVTB4cFFTbFkvRnNSdmZGKzJoc1NwMzhBVEdWeUxC?=
 =?utf-8?B?OFFwSHJWM2ZYekRXbGxPNUZWTTJQeFhjVW9sRWJTa3FPQjltcGh4cXczS2RU?=
 =?utf-8?B?cGhsdGdZOW1NVnByVGVYdkhtOTZabHRBVzJXTjZsNDJ2UkZpbFYyRittcG5K?=
 =?utf-8?B?OGVLUU81WjBRbDc4VXYwZzJQU1VzY2dLVDVYcGJzWURtWmtKYnlQY3RoNkpl?=
 =?utf-8?B?OWVQOGV2Z3BmOE5IQ200MDNIRkpYL0g4V1hKRUNOQnJoYVFHSlo2Rm9QVVJ2?=
 =?utf-8?B?MmZEbjZUV2YvaFdPSE5vVTRkTXZiVHArZjFwSkVkZ0VPaHpDUUVUeGtHUFR0?=
 =?utf-8?B?NVArVmcrL2ZuUU1qbXloRjArRkZkSXJ4b1FIOTN2T0NuRGR1amVZTlpOUUpQ?=
 =?utf-8?Q?TdqwYOD42RII3BK2XLw2hJQiri/meja4O8NKrIB9hSTg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e6054a-dae0-4b80-940c-08dc7ef5264f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 09:04:15.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiUHP1if1ZUov/mtzcuk3S/3y883MeexCKvwID1pmTqpXjY7aWUZDf5hTWq5L72CBhy0wMiEV9y6AENIuemJ2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489


On 25/05/2024 15:20, Greg Kroah-Hartman wrote:
> On Sat, May 25, 2024 at 12:13:28AM +0100, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 23/05/2024 14:12, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.160 release.
>>> There are 23 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>
>> ...
>>
>>> NeilBrown <neilb@suse.de>
>>>       nfsd: don't allow nfsd threads to be signalled.
>>
>>
>> I am seeing a suspend regression on a couple boards and bisect is pointing
>> to the above commit. Reverting this commit does fix the issue.
> 
> Ugh, that fixes the report from others.  Can you cc: everyone on that
> and figure out what is going on, as this keeps going back and forth...


Adding Chuck, Neil and Chris from the bug report here [0].

With the above applied to v5.15.y, I am seeing suspend on 2 of our 
boards fail. These boards are using NFS and on entry to suspend I am now 
seeing ...

  Freezing of tasks failed after 20.002 seconds (1 tasks refusing to
  freeze, wq_busy=0):

The boards appear to hang at that point. So may be something else missing?

Jon

[0] 
https://lore.kernel.org/lkml/b363e394-7549-4b9e-b71b-d97cd13f9607@alliedtelesis.co.nz/

-- 
nvpublic
