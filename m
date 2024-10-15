Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1314409
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 05:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728970313; cv=fail; b=YbRChNdhTVF7BBUsNSskUDdD3W8ph9aRpJZ4nXrfdtqXvzqyyF3T0BLxGEHfrSpgGPxCrrhxV10TEk3v27Vf0EsfaJtbKs9+1+xSNLFnVJKqkjilKEN8IziT6QeOd9E65rmdp5fx/bEfwo3K7R2+iG5sX3xG/yu2xSoUNDvleg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728970313; c=relaxed/simple;
	bh=/0Voxdk22wRvJ93t51CmJ2UiMGqm+Z+YJ3cdoiuMoAw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=maK+Hyi7K/pAsdowu4pNrqHugblG/UC1O6K8KaGwwLj6dBGW16u66p7u7reoinAw79pY3jQrZXob39SpZiLw5uB4zzlJjWe0nEK2h/UxDcNt/FrLz4O0B+wQDzyJpDbaygT5lJ9q4NJXXsKX74SaUHRxfbHJBVr8zetQoA9NKi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ri3CAR7V; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ri3CAR7V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJNFOPCXqwOyvybjjRNCOIlAcq4XFmzqbMZ/nQAWrxa/rjRNrqAsAh+6A16dUqh+hAoTo8vjjaZxp5+ChGBGxg2yQpfdFkL1wHT0/wnRn1DTjtt4dp104Z7fDsJCBOXgSAXPOfVKFlELeg0gmtyHZ9yDIq5zcydcdETV9oyGXCbGFpJYKD+HZN+5eHUdJxObO3YokzI7QGqVWAz7YkuSmO+Pn/OovvCJ9Pce8BF5oVPVbGohOAd0cs1i8X8o1O/5mjXNM6t8/veoZHs7cvbNB9xTIT4doxeUoXaeMUho5vc49ivI0oUTM22tn6lRRc97aYZwVlO2Bd4cRR2hnPrEnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2xRYtxw++2RzqYzoUcK+J2vOolJLfmtoTaU8hPXnV8=;
 b=W/aYlL0kWctobSBcC+KWievKD93s5BrX52SbFoTRAjs4gcstxf8FHpeIElZqvAt7wTHg6uhIpbXYmn8yWMzbOiqJ2RaJKN8wI8s34iGPBpUUEuKlfiHFKFrwBDGy5zZyNbNw7jlX3fKAAZjRCM7zzfHjtJ7dSCHorKmPgNdcbSHBSRTABSmoGp4riK3KMR9hA9GQpTjbFNt95iwaf6H6Yf01U/MURoFznD5dlgaAoNHCkNl5QkMnciC6/C0Zq65ZsuABXqAarCqdcg568YGbIx3ouuB0BpcYhYxE07mYZJ5pE9nAVBDA6xqxuRvY6iq29+mWVFUimfv755noiCvV3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2xRYtxw++2RzqYzoUcK+J2vOolJLfmtoTaU8hPXnV8=;
 b=Ri3CAR7VzchbaYuLgGKW0E/3AqwFtdR9VCTiUTGmpD3Ui6XfgYR78q1i1/so3bkxjwZ7eoRUxYsB/T+QUq/Twl400z7aSDMkvueHt3nI+NY/H4eR88jDtsAsD62+eITnH8ZxNdyspLhSpSVfbfLhK9f9JdLSQM/gifh/plKYc7zadrE8fWcTb7fPfw1nryT2jHKT4QgrRqCBoru+Zq1CprP/HbShc3t3WWSZ0G9wCWIA4jkEczplSX0jF49koeth7FrBMQxdu5A4/jpiD6yOuNqS9cmPBhQqeK+G38NnGAnW2uJ+XJjZFs57htFWXBU3z2leJmhs6eqFBSI+HC8uHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17; Tue, 15 Oct
 2024 05:31:46 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 05:31:45 +0000
Message-ID: <3ab1938a-6f6a-4664-9991-d196e684974d@nvidia.com>
Date: Tue, 15 Oct 2024 06:31:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20241014141217.941104064@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::18) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DM6PR12MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: d98175c8-6726-45d8-ecdc-08dcecdaa8b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjN5NkxIVTkxbFVVMm9vdm5wais0NHJwaHBISWN1MGg5cnVqa0tFMXp5SVV4?=
 =?utf-8?B?VEgzTVdCNGpuR3hPWDRCa0pDYm1ETDVzUlNhRlg4VlVWeE5xTHlwZHA4Z2Yx?=
 =?utf-8?B?NHVRMmpGU0JHT0ZBblpUTmVPZjlaWUNhUUlYNXhYWndHM3NrVjA2NDRYbE5p?=
 =?utf-8?B?MHRlZzgyWWRpdFIxNUx0T0dKQjduVFFrWW5veUJHZzVZZk1qMnRDcG84OWZo?=
 =?utf-8?B?cWpWTDFFSHptWE9xNVJNaXk1MlV4Z1hLMzc5eVR0cWhxcndoTG1DN0MwNmVD?=
 =?utf-8?B?VC9lY2tlZUQzZmNLTVphTUlLNGJYeitxU0twT0JyRTQ4M3BodGQ3MXljMmxl?=
 =?utf-8?B?djdCUll3ZlN1emM4L2wzVXMySjdBV3dObUJFbW9xb3JCVFFKREdlVkEyOXJm?=
 =?utf-8?B?VFVzVllEaGNVeTN2cmxJRDZzYjVWRndoa01Ld0dVYXNSaTdlc29OdDQ3ZkVG?=
 =?utf-8?B?U3E1bmpsQ2hVaDFDeEIrcmY1ZmdkcXBodFBWakFya05Bdzhqb1cxKzlnTDA1?=
 =?utf-8?B?a1diSnFSUWFqK095MGE0b0xqYm42NVUyZFpOUVdBSlVxakE1aG9GcUpMQm1a?=
 =?utf-8?B?UG1DNHJ5RUtBaFJXU3ZiTmZlMExNbjJxSXUxckpQaS81UXdvcXFRdXdVTE10?=
 =?utf-8?B?Q1p0L2Q2c2tkcTlXR3NqaDQ1SWdzSkVrS0VIVFo5WXhaQWRocFpFSG5MRzRn?=
 =?utf-8?B?QWJxaDNNTjN1MVBYRVVCUmw4YjJXOHphL2pWWVpHNDYxNjZHYnRTNk1kRWZU?=
 =?utf-8?B?cjVwM3NyUS9PY1NkbTkrZW81SW9TeVB1Rm8xVG0xcnV3bEJpaFBDMkFEdDNL?=
 =?utf-8?B?OG1XYmp4WFhyREJTV0JTZW4wd2NydEFLazZhNzJmVG9XMzlrNWVUa0xIR1ZJ?=
 =?utf-8?B?Ym05SGFMUjVjbGJHdElUYXRvUUFySXZER0FtYmRCN0RxVHhGWUlCb2RvLzRN?=
 =?utf-8?B?clhrWXRlVCtJUSsyUmVydWRyMlZyUkFtWW0vMTNwL2p5OXJWUjV4YXhVTkt4?=
 =?utf-8?B?Z1phV28yTm1uSk8yOGFFTWhlVW9IbkxBbFZlWkVPUVdkSldUVXJpUitSVnJT?=
 =?utf-8?B?N3J5Y29NTGxWbjBraVloRGNpZUdEM0pFeFNBL0dZbjF1OWNBMDZJYlhtWmpx?=
 =?utf-8?B?VFJIdVIrTWtUN0ZEQVlKZmlNbGIwNDEySDJXVHB1WUFUQ0F5UHQyQnJ3N0I2?=
 =?utf-8?B?QzRSWVFQMzVxNFdBdnp3REo1YXlSaFM4RU53aXd5WEpDWVFKK0dTSDFuK3Ix?=
 =?utf-8?B?OXZ5cUhSaTV0SWdpbUZQSENXejN6Q2lmZ0tmeG02aEFFZU93WVZZWTIzenE4?=
 =?utf-8?B?MmZRbmtaL1AxbTJFT0ZsbGRHSERycmlRQ0xQbDBja0pJL2FxM3BseTAvNHE5?=
 =?utf-8?B?U0QzdmdZR0hJNEVqOE1xNElEQ2VxY2lvaWt5Z01NYnJPSXdYdU9MWmZPcTlu?=
 =?utf-8?B?ZUduZUhKcjlOTDNyREIzQVBwZmgyeXlrSnhPdytwRzFzNlZCTXRrTytudkNH?=
 =?utf-8?B?ME1EdUUrY0o1azJTSUE1MHV6NEUvQ2E4WmlhaTZQUGxJWkJNQXZ4eTZBZElD?=
 =?utf-8?B?NC9BczJ3QlJPVkR6U2p3bDdBRTJSNmxURTJUQWRHWllCaFJCbWl5Qnh2UmZP?=
 =?utf-8?B?UDdNT3EzQzJJa00zQlI1Z3ZscHRIcjFES0V4ckJ4WVlOaVJoekZxa3VKQVdP?=
 =?utf-8?B?TWROcFVEdHV0NGgybmdxWGJGbHgzNk16ODVyNWZHWWMycm5PVWNIZitRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ak1LUkZPWGFNQThKaUY2NDNYUjZMMEtSdCtaWXJZR3dobjlOd1JTUFFCTWRT?=
 =?utf-8?B?NXYxQnhIWlRHTUtOZUJuMmNxbzJLNDNKekc3b2JqeUNGeU9UNEdUcnBkUzVs?=
 =?utf-8?B?cHE4cnpJYmdzS01HU1V2ZWtDUFVubWdJSHRONC9yVzBNb0g0Yzk3NERxRnhW?=
 =?utf-8?B?UmZKb3hoTGUvOE1JVGxYbVNEOWllOGozL1diRklJeVlwbGlKalNUTG4rZ0JF?=
 =?utf-8?B?QzRqcGIxbnhqRlZpVUU2Y1p1ck1uSXIxbEdUK2xUMkhOOFRPeU81UWNrb0Na?=
 =?utf-8?B?QTdwTzdKY0hsN09LRURRK3FOaEVQU3pTaEhoWE9QR3hwNXliWFJoS2lQVlA3?=
 =?utf-8?B?K1MvMWFONWQxdjVWdnBMdjN6MVhhUlZ6UHllU2ZxLzhYOGxrc2h0eDF1L2Qx?=
 =?utf-8?B?eVdibVlqRXo3ZGJ0TUJRTGhOTFovWVI3OUU2d2l2RC9GcmdaUTVsbUVaYTla?=
 =?utf-8?B?elFqVVBZb0tMRlpVdHI3ZTdHajlUMTNud2RWbkc5c0hWZUNIYkNrN05mM2Jr?=
 =?utf-8?B?a0lrbkhWdlgrcGRCMm0wSW1BT1dFSjhPSHhtSnJsVGljaEZ6S0diOWdXOVls?=
 =?utf-8?B?MFRBYkdPcytzYWpoNUVSN3ZVUFhPMnNRVmFQK2VTUkt6TDRMdFNLWXA1QjRV?=
 =?utf-8?B?V1FjVU45OUp3OWdnOGlPUmJhTkVDM0I4MFVLMlFDcjQ3Qmo2eEhYb3hCaGJC?=
 =?utf-8?B?am1rbnBTU29QSHExeUdMaW5SM2RSWkFnMmxrM21kS2hDQXJhZ3FkTmMwaXdl?=
 =?utf-8?B?TTZJZkRjQjlDZHVjUFE2dU5zNG5TdUpZTmFMM01ZNUNWVkovNCtmWnNKalov?=
 =?utf-8?B?OGd2RVpuTmRsSHQ0T3VyWmUxYzZyNzFuUTNvb0w1bGRXNzFxclZEWFpDN1RY?=
 =?utf-8?B?WmpkKytyUTJBWTc1R1ZmNjVrN2g0MVFyeUg5d08rY01VZk9DZlRQMisrSWRJ?=
 =?utf-8?B?TU4vamFRdVFyd2xjbytPLzV1NnJSZmZSZTJkM0I5cnJOVTB0VktMSGJ2U0I1?=
 =?utf-8?B?WXFZNGNIOVVLeFZvNWNqM2hqVG1kcTZJY1BnRVhuSVdqMHFQT1FVRmJGSU8x?=
 =?utf-8?B?WStjbmFoeElxakUxZGU1eWtvQlVDaTFZVjBYLy8rLzNQVVZEQ1BUbXZGektQ?=
 =?utf-8?B?MGZITnBkVzNBM3dBWTRSUkhNZVAyY1JsMDJiSzF1U2RoUzB0TzlRKzhoSjNZ?=
 =?utf-8?B?aHk4RmFZc3kyYWd3RWo0QjU5RDR4VFJNVVJSc0dGbTJXdEREWllPV29BTnht?=
 =?utf-8?B?Sno2M1JQV0VwRzdTam0yWkVsU21xMlpTU2oyOEtDOXNuQy9HaVJ1cXVVY0kx?=
 =?utf-8?B?dUR0Y082QkRod3l4QVFPVFplWDYwZ0NsR1JSek80ZzByNG9lZ1FEN0J4cWNE?=
 =?utf-8?B?TDRqQjNHajBWa2htSGNsRGZEcWdTdkFtbU1rQkpJTFZCajJ4RGVuN0lwZW5x?=
 =?utf-8?B?ajJDN2JUcHhxSzV1YjhZdGx6blVxeVVmdGN1bjEyd0djSjlHVFJHaGxaQUJh?=
 =?utf-8?B?TDhEMHBLWGZoRWVQcDZpU2ROUTU1OStpUkNVd2hITHlVWERRbHJ4cEs2Yk5S?=
 =?utf-8?B?UVlsWFd3WFE4eE9JZkVWZzk2T0RpdEpRUEptaWsxTkJLaXhGalJVa2NQMTVZ?=
 =?utf-8?B?bFh1S1ZQNXhIY2FXZUU4QzFQRUVBZTF1QU9MOFJIUDB4NWk5RzQ5QWdlZ0Fn?=
 =?utf-8?B?WnRITXdQOGcrajRsbWxldEc3M2VMdWJrRG5GWCtpclhXUjF5VzNJNkpWOG51?=
 =?utf-8?B?SVBwMjhlU0hIclJYbENhK3ZrZ0xtTnNBdlc1bU56UlczRE5HNVBTYVZ4U1hY?=
 =?utf-8?B?M1Q3SnVMZmQ5U3JHOHNScVVBYjV3TjcwZlFuSUVQUnFYNWd2Y29Dcm1wU1NR?=
 =?utf-8?B?WklxVklRZUFUWFp4U3RqbCs2eElOSWpCZkR6TXcvU3ZwNGxJdW5kWWpxVzlQ?=
 =?utf-8?B?bEp5cWIvQStwSEdFcjBNb1R0Z0ZZTkNPVUhvdEVvcmU2U1k5aFppc05wcVZ2?=
 =?utf-8?B?VjRacnFJNUwra2hEMmlybmRrR09nUzhLdHU0ZUlqZExpL3pmdytFRG1TZEEv?=
 =?utf-8?B?RjVvckhLZnZEQjlNbnJpMWt5K053SlFRNjBua2puelFvL1Blc3JvOTVQNER1?=
 =?utf-8?Q?Mstc4gmVN8JgE/V29i57V+c4d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98175c8-6726-45d8-ecdc-08dcecdaa8b9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 05:31:45.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IenaS0JTzXrrY5lQF1l+aexADbbWc1XlM5PUFH0BWUF2997F4MiuKhOOuQ5Q9IkgvOY4CLdyteSSLGwD1TL3zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353

Hi Greg,

On 14/10/2024 15:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Oleksij Rempel <linux@rempel-privat.de>
>      clk: imx6ul: add ethernet refclock mux support


I am seeing the following build issue for ARM multi_v7_defconfig and
bisect is point to the commit ...

drivers/clk/imx/clk-imx6ul.c: In function ‘imx6ul_clocks_init’:
drivers/clk/imx/clk-imx6ul.c:487:34: error: implicit declaration of function ‘imx_obtain_fixed_of_clock’; did you mean ‘imx_obtain_fixed_clock’? [-Werror=implicit-function-declaration]
   hws[IMX6UL_CLK_ENET1_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~
                                   imx_obtain_fixed_clock
drivers/clk/imx/clk-imx6ul.c:487:32: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
   hws[IMX6UL_CLK_ENET1_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
                                 ^
drivers/clk/imx/clk-imx6ul.c:489:34: error: implicit declaration of function ‘imx_clk_gpr_mux’; did you mean ‘imx_clk_hw_mux’? [-Werror=implicit-function-declaration]
   hws[IMX6UL_CLK_ENET1_REF_SEL] = imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
                                   ^~~~~~~~~~~~~~~
                                   imx_clk_hw_mux
drivers/clk/imx/clk-imx6ul.c:489:32: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
   hws[IMX6UL_CLK_ENET1_REF_SEL] = imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
                                 ^
drivers/clk/imx/clk-imx6ul.c:492:32: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
   hws[IMX6UL_CLK_ENET2_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet2_ref_pad", 0);
                                 ^
drivers/clk/imx/clk-imx6ul.c:494:32: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
   hws[IMX6UL_CLK_ENET2_REF_SEL] = imx_clk_gpr_mux("enet2_ref_sel", "fsl,imx6ul-iomuxc-gpr",


Jon

-- 
nvpublic
