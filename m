Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B43C1DC9B4
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929598; cv=fail; b=szog67incTC2m22svX932YDl6E4wRR+Y3rfDzjEH+yEJAxiAz4gF5Eg8e8TgcpvKeHaVs7dd6kNhqNrUVpapQJ8HetmreFgQ9St+/qUGVvvIZCXIzemgfANURt5pUYjdPhvyoMmOvpNVX1WwI5L+zwomKT1UnB49S8kc4e/nDJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929598; c=relaxed/simple;
	bh=X9OvqBcAs0MFcKVCcA8/u6A8cUHCXM+5bI6ik+HxQcI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NafcQ5lyL7MeVdzxyNuniKCQh+ZE97dPAnSRYFfRxEWr5yOkNmphCED97A3ajVS5GNRbkopmApJUTLuKVAIsFArnOBA9pXfKYunvLHRzKbkQfdlSIvfmP6zcdPskEK8Yhhhee6z4yb3b+mIUW0wp0XPCT0UwnF/0sJ+ATeZA4eE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lU/mIcHv; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lU/mIcHv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aYzgks4JmoFTEXBSa91XpuVLJuXiK6q6A1p+WfHQ5tOA/2QxqVV4osKNExB0GBdu6tEwu4hZONEOnDb2gBLuUMpBytry0Y8oGFR5mTCQsbdWZpo2cV/HEgZdwpRhrUsgUH+6//HT9KY9rtrwksrKNM6gCxqobvZ1NX7U38dDesOvS5UBSAkDVPoN/ejkgguA6Ht05wNQRDdAg0Z6LaleSglmnPc6i51elb3FoTRKsTBO8LPf0eRRkEgSmu+lvVfbhiLsqAxA5baE5qSyMyhVV9nrIdADqHSZvxftPL56yDCKkl5LWL/oWlBYONe8PMnewylEtFRAhpHfaZv98SClNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2irXCpClc0p4teoCybEt92tAHQIsrgsN7DcaXQg+IQA=;
 b=Pk9nbNOAyFxG4ZBzhixa38PIsvekPDepmNTcSDbXyDXT3+iqXxPwPDkdc/1Qqwabzc48d40aR3opibZFudHG97oAUNnoipLThP9jVAoRe04T4BTv0R7gPxriT4ToS10wCXHt4w9kDy5TIcH8ydx9ovYdjYTIy/OxzfL+B3fXwJQLPB9/zQElg7HVVQDhglPyBkECjg0JHdrJlwDPDmI+vAPEKNyd17GYYoeYsCVDJ1GOJq+cwYKVnQtqaN0r91vJLIx8MXAZX2lmQp0leBsRrH2cSLvE5e17k6DHjWPrmE71gAg8HEfTe3XoACBIC7U7eh4jdFggbibP6eURGX7wvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2irXCpClc0p4teoCybEt92tAHQIsrgsN7DcaXQg+IQA=;
 b=lU/mIcHvTjv0dCbNJZ7zB9VdFaljvhoe5CyAqFO3MYDC84QK+J18tbns19VsyV2JmomqU8d0nZkGLcdz7ln0zUEHlsyh2+4ZBYPtwp1xQfl+TZRqTE0cga1PVvJ97n/lBiN0hoKu8ADfuhrszhXZGE0lyiQQtNnG9E0XT2mSY/rM3XMOUQCtK/EVzxPPmVWYJUBS8eYJdAH4+XZCGu0LKQhTRwq/ruT7sOIYs1uQOkrWNsxKaZKsjEAlLuXRCR0i1j1GWUYCw/y5isf2eKmGFu9cyYzZhGMNvWDO4aH0Ob2soWMpHrTc4fyefSB7cGNG3UH+XkHSRXsDR5ysgdEP6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by IA1PR12MB6234.namprd12.prod.outlook.com (2603:10b6:208:3e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Fri, 7 Feb
 2025 11:59:53 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8422.012; Fri, 7 Feb 2025
 11:59:53 +0000
Message-ID: <1be7e233-94f9-47e9-8f79-47ad5a4571da@nvidia.com>
Date: Fri, 7 Feb 2025 11:59:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250206155234.095034647@linuxfoundation.org>
 <7275e41e-7afe-4d39-9e90-eae81b0eb77a@rnnvmail204.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <7275e41e-7afe-4d39-9e90-eae81b0eb77a@rnnvmail204.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::7) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|IA1PR12MB6234:EE_
X-MS-Office365-Filtering-Correlation-Id: d1692af2-30aa-4d12-d845-08dd476eee5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akFYQmtuTkZzZTh2bi9zV0VkKy9hanpMRDBvd2UwVmIrd2NYZnNQRzI1RVVn?=
 =?utf-8?B?QjV6anAydDV1TmRnR21ndVZvdkJxYVpkR3h5c1NHSnRTTFRHRHBIN2UyWTAy?=
 =?utf-8?B?UkJTN0NRcUtmYmpWQkhGcEpwOTd2NlZ6ZUpiVHNmTHFrakFFRVJyQkZhekVS?=
 =?utf-8?B?ZXM3dDlWMmxCU1YrdHY3dzBHY0ZkajhUVnk0cXlNMkRmNFpTcXZMSzZnU2w4?=
 =?utf-8?B?YytjclZFY0hISGNPYjZhN2hZcjk1U25xZmEzMnhyZVVJcDhnVWFwWW40SXM5?=
 =?utf-8?B?VDl1LzI5c1hmekUwRXZaU20vNXdPQTdyUVdrT0lCakFxUmMzclJXeG1zeC93?=
 =?utf-8?B?THZqVmNid2NVR00rcGc1N2JBdHJuOVJGOHFGRWZEZVl0U21vdm5ncHRBdFpS?=
 =?utf-8?B?VytMRmNtbHdTUk9pTnVVSllyTmtoYjNqbU1JRkdRTCt1OHNHUnRBUVQwLzEx?=
 =?utf-8?B?NGlmdGpEUnhKU1QxVko3NkNVTkY4T01Cb29iVUt2S0c1dUtaVXdXNGdsdzF5?=
 =?utf-8?B?QTFqZ21oQk1RZ2VKalNvZHV0SU5mRGhUMFFMNDNYeHBIdlA1RHRXcWJnb0Nz?=
 =?utf-8?B?U1FvZnF5TDI1b0dvekpUeXpMeFdFSnZBa25GdE1mRlhYd2M5QnV2b0wwWGpv?=
 =?utf-8?B?ZFh3OXhWd09NYzNCR2tpRGFDeEkwMi9rZ2tLUUpnLzlUU0ZaK2dCR2RCc0t3?=
 =?utf-8?B?aUgwb2lweUd1WGh1QlZ3Ny9QbUIyR3pGMy9iOVVuUzczRkRLUE93MFY5NlFp?=
 =?utf-8?B?aXpwVldlc1I4NTFwZ2o0VGhsc1lwRDlldlEzclV3NnR3YjlxNG82Mi9iNWdx?=
 =?utf-8?B?bFZrOWRjUytPSkx4bjRISDZhWFhIN1V5M0ZYZzV5UUg3Ym1vYytHRXBNTzkv?=
 =?utf-8?B?cVQ4UWpOOFhrdktKT1BUVWxrazBveE9CVHI0OVdiWDRUQ1lPbmRQUVVBanNR?=
 =?utf-8?B?N3JmOUlwbFFReTNPZnFFNkZLZzJyQzFpMU1HbDZjcW5nd1hhSkEvc1o5N2NK?=
 =?utf-8?B?L1Y2cEhWcFMvemJCMC9nQmJNcytjUThXQnFqd0UxcndHZUtNTTF3N2hCeHBx?=
 =?utf-8?B?dkVWcjVKYXpvUnRKMGxZbmFvbHVWTXVGRXNwWkttc2toWFhkTDh5ZUo4amJK?=
 =?utf-8?B?dFR0dGNlSmhNT2YwODRvUDk1RVlkbWRYRFlsRWxEMjFvNmZTKytNODZVcnFq?=
 =?utf-8?B?THA5UldIU0NFY0NGeW1WSmNkdjhqUzBBVno1bzM1SVZ2WmRNZFhKRHVzZDJk?=
 =?utf-8?B?MVAybkM3RWxBT0JCOE1NOTJPQWhUK2V2RG8welRZQlBPeVRrR3pFMzVLRU5O?=
 =?utf-8?B?NE9TUU1ZcnFNSlMxdmpkT2JoOGlDb3huMnUwM3IxTm4vbWdpcW1NSFhSNnht?=
 =?utf-8?B?Wk9yc0NBWFp4cndyQ0EyTXhFR2JyVmtLSmZVUTduWmdWMjQxTjVCUTNQSDFC?=
 =?utf-8?B?ZW5JWU5WOVIzQU90OGw0OEFlMjNWWnVFYXFZdHFZUlB3Qy9kaHlUWkZSdjVQ?=
 =?utf-8?B?OXdESmxieW1icGJodzh5ZkNoZURnZ0pDdXAxMFNkZUVUVTE1bVA5T0VnaDUz?=
 =?utf-8?B?ZjNleGg5WncyUEJ3dDFtTVQ5SmhEems1NWMxWmZlcmw0b0hKbS9xaGRuem1L?=
 =?utf-8?B?eUNSeDVGMjhvRWRRMm16cFFZdktRRTBUYmlmWXB0bDhLTStrdlhvUzJSc3NJ?=
 =?utf-8?B?MThNQkNKYTJwTnRBSlR1MzBKZStGRU12UTJUbEJwV1lHMVZJTThwbTJSNkpK?=
 =?utf-8?B?RnRoMkhMUW44Z2ZBYkhBRzgzSHNlZmFpVGtFd3FNYUlsM1RMelk2c1lWMXBF?=
 =?utf-8?B?WVU5QVpZS09aY1F5ZXFYcXhBQ1lkVUxoMlhvOVRwVTRKRVhFTkNQZ1RpWDdW?=
 =?utf-8?Q?P9YmsrpjDGFoX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUQvOVhNMGhGUmpEQXRPaUZJa0s3YkQreEsrbjNoS0R2M0dReHhQTWxmdWp1?=
 =?utf-8?B?S3JxYkt6V3pQU3doSCttTy9SM2g2YktUVkl5citSb2pWZU5IeHBjeVNOSWhq?=
 =?utf-8?B?VVZuNGlyOUJNb0EwaWZsbmYzQzE1d3FlY0dqbk5LbVZhOHFJTkhIQWNHNmVI?=
 =?utf-8?B?N2VrV0RYeWJabm85T09Fckt5ZDM4UEhSOTRFN3RES2c0S2JERjNGLzNxcFkv?=
 =?utf-8?B?ZDAwb0J5NWFLNENSODY5NXVtZDJCa2ZyWG1PSk9hbW1rMWV6b055WExheWl0?=
 =?utf-8?B?QmFLdEVUbUtMQXVkeW9WMkNvaVdpb1VRSWoxc0lQNVRPSzQwRU9LMzRoRlg5?=
 =?utf-8?B?VUFGdjhCbVF6ZWN5ZmRZVEprS3ozaHM4TzQ5c1BtR2NUbDE5cFRHV1FhT3BX?=
 =?utf-8?B?Q1NWa0NXTFd6NXNpSG1QUGYzTVNlSzc2V0g3UG8zNUhXMnFjVktlZmJacS9k?=
 =?utf-8?B?NUp4KzVST0VJN250NXJRdUlhejMvY1RpSnl2WVlnU25MNDBtUklVTWpmcG9o?=
 =?utf-8?B?SU41MnM0SHlnQ0pXMCtvditrajhkMjlQMzNxUUxnVW5WeVFlVDZiTTRXczMv?=
 =?utf-8?B?TFpGUGZvTkZaREpMb1h6OVR0ODFuVmEwN2dNZnp5bmdsekVlV3hLMkV6TjRx?=
 =?utf-8?B?WlozQnZrc1lQWXpiTWhKYUZ2dXpxakh3WFRsUkM3QURTUTFxY0IwUVBVcTVt?=
 =?utf-8?B?K3RJRVg2U0R6MjZxM1hCREx4dk96bFlMak9WQXBRUjBaY2p6cmVocit1cmpz?=
 =?utf-8?B?bzUwTmh2cUpUbURXOUVNQ1RUTVJCaWFCYVhkSXljOHRaVlNVUkhGS2poc0Vi?=
 =?utf-8?B?ZFpKVTJ6MDh4UXUxcUxEczhTdDIyLzVTdHJqZnNTZWJXVTU1cEhsejcrZ1Z5?=
 =?utf-8?B?NTJqY0tITnU0MFlTWTkxY0loM3I2cE04alpmTzFTYmZnaElzSTBoblFuUHV2?=
 =?utf-8?B?VzZFMzVWbGRPNVE1VTUxZTFWTWU0R0VNL2VPUTkwczRpLzI1RDQ2UkVFKzE4?=
 =?utf-8?B?ZE5mQmZEa2xxZkQxMmxMaUcraFZYSVRxQm4vZnBzVkZjZXM4WHJVdGJieGVG?=
 =?utf-8?B?RDJScmpNOGNBOUNwZm9URmFUQUpmQllLYjNOR3loRGNQOVFJcVQ5OW9FdFRi?=
 =?utf-8?B?Z1NQbjJVRnIzVVZoNVE5ajdjZFdZMW9OUkRkQm9tT09GQ0tQTGFVVDVPQXJh?=
 =?utf-8?B?ZC9Vam1Dbkt4aXpSYUdYeFBFUDVtUHgxY24zSXRkWHZISGJUVjlSd1F2dXU3?=
 =?utf-8?B?bDd0UHZkOENMN29qTGI4U090WnFIYXpIYXF6T1piZFE1LzlWWnlJU3pwSmdT?=
 =?utf-8?B?RHd6NXRPYjlRbG9qT0p3Wjk5UFlEODdSOXRnVzF3eEwzaXpXTFAyZUgweHg4?=
 =?utf-8?B?L0RtOVR2MnF0Y0RuamJFZWNjMGFEbHNXMnpJSUUzVXV0NnlkVWRuV0tUMWZw?=
 =?utf-8?B?cW9TbjRCLzlWbFZJS0xLZkJWcDZVdXhJU1FXWnNmcUFra1JFTitwNUIwWVNy?=
 =?utf-8?B?RHY2Mk92Skp6a2dOdGxTYU5hUkYxUnhBR080OTIzN095My83aHJtRHFleUN6?=
 =?utf-8?B?ZTJOQ3p1aytOU09aMzNvbTZXK2Z2Q0RKZzdadU9ZMkpJczJsa05hY3ZqTFVm?=
 =?utf-8?B?bEQydHBEaUlXdGhHTlV4dnl3V1BhcXJaTFBISVRYWkthbnA2NjJPK1U5VkVP?=
 =?utf-8?B?N0FqS2ppSXY0RzZwZFIvSitMR2NUZXVsVkpRK1JQK2VsbjdSVENsbEJHUVJJ?=
 =?utf-8?B?ZXhaZmFIRWtwdzdteGE4SEFQRFp5UTVkY1VLU29yS3NNUUFPQ2ZmTTY4M2Qx?=
 =?utf-8?B?Y21qQlR4Ym0xdmNUNGJLc2FwcmUwWThHakFKRzdyZ2NLc1ZDZlJZZ2NlS3Fr?=
 =?utf-8?B?V2hmUk9udXY3TnZQM0lGaU5NNSt3NlUwMVM1VFdqN2tyRjFCSjJ5SWFrYlI4?=
 =?utf-8?B?cmpZdTVoZVhieTFLWldEL1dVdXpHYnFkZWdNbzl4VmZFM1hjam5BWEZFREts?=
 =?utf-8?B?dlpLZjlsY001MHFpOGFTL2QvTmVBKy9GZ3lQa29kZURiS1lZRjRWZUdNVmlW?=
 =?utf-8?B?Yzh2THRDRG1pK04yZXNNWTBVeGxXcGxFdi9xeFo0S0V2d1NkZHpENCtScXBO?=
 =?utf-8?B?cUZFQ2VrUTU5TndjQ3FuUUpmOStaK3Byd2VoMU1OaStCelIwV2tpMkRHOFFl?=
 =?utf-8?B?dmFRby9lR0dzN2VXRjhmUVlBWkJlZmdMb2VqVG5FYWFoZ0JKc2RTY1d6ZEl0?=
 =?utf-8?B?RHlIcjNIU0lKUm5vZWpnWEY3aHpRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1692af2-30aa-4d12-d845-08dd476eee5e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 11:59:53.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZKh03OrsH98W7v5X2GIlkYQ3OuE2n5mY8OVxXKUfMCvbdVEHLco7GqNcY0v0iBwnUEXpXJe3sOettRJ1o3R0hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6234


On 07/02/2025 11:55, Jon Hunter wrote:
> On Thu, 06 Feb 2025 17:06:18 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.76 release.
>> There are 389 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.6:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      116 tests:	114 pass, 2 fail
> 
> Linux version:	6.6.76-rc2-ge5534ef3ba23
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
>                  tegra194-p2972-0000: pm-system-suspend.sh

Ignore this report. The latest is the correct one. All is passing. Sorry 
for the noise!

Jon

-- 
nvpublic

