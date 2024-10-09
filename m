Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D811A0BCF
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486695; cv=fail; b=obdembGnHeW+Kz5hDcXYgxtkc+jPTkNU+JxTb/k+fLHL5yiBLOQPhfkxy47z9aSr7W+datdAcQIgtm/8tbU8MlkEGqTpkkTWG7B/uWfro5iUiZQMLi1vVa7ySb9rsaL5zvAMxxk2zXnhHjITpNhgF0VvMRrMiE79bZSt7ooFuig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486695; c=relaxed/simple;
	bh=B0bfRFgZ8n9bbqtaVZigvRrQ8nBVAfqv+rZiS6eGbl0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F3vMqQ4g8Oiz9w1YejjOAku7/2KxGhZR1JjlczhidP5XZJrmwf14TwtppMsBj99knevBPoqww9874KcHCoBQ/lsKl2sqkDLdOPiZJ/IBAAoBDmP322sF+694vqg80KHQ2J5QHsPNTemlDkGn2GtHvslr5FqwB/AxztHFnqTiPUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QC6kRl8s; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QC6kRl8s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qA5LkUgfKjlIekL6fJ5qo9wg3mQ6OOZQBoKa6TCzcq/01O5EGvMQtc3INhlvXdRHFgf/tgfNY8RclMLFmL09rPbAtEZpkYw24xD/ubS0ZYXyT2dOp8mw7Wsy5hF2u0ry2hglekeQtJ60EVXvKcL2Frg+EZnFCIuX+dzyANQzuZmAYPrJvLqg54KHyN8a9m75sIInsYpxAyKYrxTsQrbM6/oebbQPLhlbEUGz/wGH6/um67T5lkonSz5QWwQEbDEBNK3/RnUqbCXjiOO44HGr5q31gJMUiH4wf6EfAMiEOuEZAL3Pg6akwmsc4xood1lRUx0jnPZEuGJBRHkq9h3ayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fm0r2Uy/S2Kb3L/LBDFJ6VsCf9ZjtryweaCo95ww1vg=;
 b=dH/2CAXwlyw6Npj+E9tRJaH7Zgm1DIwyzeuZU2aAJ8f2K5WH22Encg/MKW4henTtK8DSmTyIhRpa1rcf5Mi3kDKBkZXhTVXSDFoNfDuirkNteONi8XcLg4SOPiWC/p72fONixZUUswqdZNnv/RTFvYhhVb+l1Dbr5YZtAwbFEb7hLTNUoPdQOcmP0pKWKCM0z9O3IK8QfqzO9sMZvY/IzF7WzMvLF1nYWTy/ecIYIPwK9cWWVvbvB64jEKnwscEN5ncIqhbE8DKsiQPBJojNtsXoS7OHEUt3VPU7pIkEF0fjA3vwu2ESts1ag6hI9JMo62n3fzzJGQhGNsvhLvlMug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fm0r2Uy/S2Kb3L/LBDFJ6VsCf9ZjtryweaCo95ww1vg=;
 b=QC6kRl8s1cIXWreOeGyMEOT8upgLSupAh8A5AQDqQYhyi4C/RmwPxL7sIjB5exFaCJbq6X2hPaVbY7JVTWWoM1TeE31XGtCTUkOznirsTACXnLa5hWcCNmmVKLGEAk+7fm+d+vMDQO5ALa4Px6NzysIxU8guCXDs529zeXwPrK4SnavmnLfKTqbo3dldBlf8qKVW1awoGKnn1bJlQlUcAQMQLcMorB6F9SIrkONW405MxJDlNjG7+e3VQo5jARvPDgeziekGuGQIPkUk1grcGJFDE6p0nxvWZxPaCWbMpIKP7iarqlCTPmQbUbAUVeh97xg4uHnDuDs8A6hyVtsBug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 15:11:26 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 15:11:26 +0000
Message-ID: <b222ca24-0d69-4893-b669-02a071e529bf@nvidia.com>
Date: Wed, 9 Oct 2024 16:11:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241008115702.214071228@linuxfoundation.org>
 <526e573e-c352-484b-9b24-1f83abc93f8b@rnnvmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <526e573e-c352-484b-9b24-1f83abc93f8b@rnnvmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::20) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: ffcfeefb-60b4-488d-efa9-08dce874a509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3VSS3ZRZnRreUtOV0FGSVJ1dFhjN2NxQzdub2dkaCtvZDNZaHhWWW9iRXJ0?=
 =?utf-8?B?c3NKdzJpeWV5ckpBK0s1eTZ6R1laMHh0UW5lVGxmZzNYNHFSMmJpczRRRHBE?=
 =?utf-8?B?a1lGK3B3TDJPSGl0OEEySWlpd0oyQlh2TGZPWnRnVVNjTGlyTGhxSFhpdkV1?=
 =?utf-8?B?WDVlZi9VZy9MbHRuQit0c3NnY2dpbFdoSHQzbE40SlBaWHVtS3pjVFVQZkdj?=
 =?utf-8?B?clExY3B2a0J4N1JDUmphSDNITUdkWEpDaEdhcm1BdEpSQVV2ZlQxOTAwcEht?=
 =?utf-8?B?VER3Yi93dzBmL2hjTFR2dm42SXZmWThoM1BXS3J1eE5mdmROTERzMUg0Z2pL?=
 =?utf-8?B?YXkyYnJ6eVVHNm5HRVNiRkxwMXhIc0pYdWtzaWlGSUpMaXBnanVoeEtOQnhn?=
 =?utf-8?B?Y3VSeU5JVFNqYmlvWDhZcFNQTGZEU3JVZm1Edjh1VURQSkQ1QUFOT0dvZGpn?=
 =?utf-8?B?SmZlMHZYeGt1T0N3MmdHVEtHSS9oWGR2b1hVOC90UVNJNjRJcmtVb3dLcUNQ?=
 =?utf-8?B?cVdwMktxWnJvQ1hTQnUvRWZEVTl4K1ZHN29UOFZtb0tyc1p1VnA3UVNqMDJk?=
 =?utf-8?B?a3JmUWV5ZWtIdHNZVnJ4czE2UHhDMFlVdXZWTnkwMW5xNU5xSGlTV2xBMzFu?=
 =?utf-8?B?QWo3ellEdUFHbk4wSytkeERDUUd1MmpiVUc1ZTZ5MHExZW9sd1htQkZTVHVO?=
 =?utf-8?B?MnA4cHBmNG00cHRiN0lUV1V3QjNVekNhL0N0bk42ckg1aUVOUGhJbEhqc2t0?=
 =?utf-8?B?M0NKOWhXcnMvajM3eEdXSmM0NkNoeGxmYkYzRkxpMlNoNlVSREk2bER6dFdu?=
 =?utf-8?B?dmcraVJxYThmUDBCaU1lUWx1V0F5dUZ6M3RuQmJlUy9VbUl0cHJtdVNORUp0?=
 =?utf-8?B?V0tjeVpuN0VJbDYrL1hXd2RzNmJRNTZ0MVNPcUdnQ3RMcGNTdytNa3FMZ25R?=
 =?utf-8?B?UHpHZ280RDdORDdyU2dNL3ZEZENHMXZjTXBhZGZobnJ5dUZrKy9IaEMyZWdx?=
 =?utf-8?B?RXJXanc2dWE3Y3ZaNU56WU1XUVV2cUFWUDZCNnNianpOT1A0Y3B4Y2Z3Z2Ev?=
 =?utf-8?B?Wkw5Tk1CMFpXRm1mTDAzbytXaXJseXM1TXFsc3R6YXNueUExeHRDK0NRNTcw?=
 =?utf-8?B?SVlBVWpBb2s5aXRXY3JUMjRubUVsZGY0YjdFMXRxSWp5TE9vQWk0STcwRFlE?=
 =?utf-8?B?dm4xRkxueXVnY0pCU1NQc0loUXFQSkp4SWg5TFFlRmxBb0tUaUt0OS91eFFX?=
 =?utf-8?B?bzlDME5EeEFTT0o5cjFSK2FxbnYzZE9jN3RQZExoYVpMa2RGcjBHaTlhb29y?=
 =?utf-8?B?QkxacVZaZ3Q0OS9VaVpjTFF1L1JqQlFtWWhRcjNsVXVmUUJCRW55SGN4UUh1?=
 =?utf-8?B?NXp4Q24xRUlod01JMHcyTmdqdHJ1VG9tRUpGWkJCNHJRMmlPOXhXalgwZ3Bi?=
 =?utf-8?B?ckVvVTRvT0dWWEVQVDRFRng0Qnk0TFFTelhSdGUvUE4zL2xlMHpMbTRLQ3Ur?=
 =?utf-8?B?aTFRbkhvRzV0YVlNb3RzdURnMFZQUHN0TDFhcEsrL3BGbVhpa3ExdXQwc2hu?=
 =?utf-8?B?SG1YRXl3bUliV01aNC9iV01lMVBMNzJ3cU1ETis1L0xaNU1FOTNiM2ZZTFVJ?=
 =?utf-8?B?SVhhd0hJYzR4TjBSdHNkU2ZwdEt6M3U2YjZNL0twUTMzZ3VINzVySVJaRkY0?=
 =?utf-8?B?V3pLdDV6WUZjVWppeEhsNjc1ZXJQR3VRRzJIdWdBcTRBNkZhaWdXRjFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEl5TW5JQkVJdU5uMERVUnJDRUlIN3NYWjlWSmIzL3hiT0dSTnNsUlZic3dK?=
 =?utf-8?B?SXJ0MXRlczgzb3RPSGJXVkhYRFUraDlqUk1aWmhqb1U5d3lnZ2s1YzUzcDZ2?=
 =?utf-8?B?bTd3cW1lc1NzWW4zQUFjc1FMRE9WZm9COTF1bURMVjVlcUtXeUVBelljNStE?=
 =?utf-8?B?dlpKM3VFRzU1R3c2MDYzVkJtUkRZQkxsc1Rpd3JWQ1huUlBtK1FqSjh1UDRo?=
 =?utf-8?B?b2g1WkU4c3VSWm9RUWlWUzhwWDQwK2x1Z3AzUThOU1ZxMi9WMGhZc21wMUVq?=
 =?utf-8?B?RzFnRUt5TGVyQjJEc0lPdjhhNmYveTFIbStzQ2UxOXBTajlzVlFtTjBseTEz?=
 =?utf-8?B?cVFHN3VEM2JUcXMrZUgyWnpRRjZvMzFTZWRONHNWaHVJcFpIK254cFNOREth?=
 =?utf-8?B?S0RWZmR4RExUYzZ4WktxMU5PaVBrdUMzL05Cc1JmLzFDUTNwVE5uVE1WdE5U?=
 =?utf-8?B?SUFXdUpPTGx4MnNBT3RsVnZTSFRzdWwwUkRSN2VxNy9rMlNvenRjQU5VSkRq?=
 =?utf-8?B?QnlQWDV5eFhZaDd6QlNQY1F6aW1nbk9xNmJXTTRGQ3dBbzFnVjEzZ2toRWQ1?=
 =?utf-8?B?dGFWalU3ZEFxUUwvc1gzdk12TE5TbHcwTTB6WVo1K0xISmpLbEZTNUF0ZFpY?=
 =?utf-8?B?bHYzSVBlUkptY2N5SFh2VDBtazBSSXladHhmbEk3dWNmMUQ0Y1FjRk4zemhZ?=
 =?utf-8?B?TTlPQmxCOG9Mb0g1RGoxdlNQc3k5QW53SHVWMDJLOGYvdDJWRmthWFNPai9C?=
 =?utf-8?B?R2picWRoTVd3S3YrbmxrMGZGNktMdzJ1WXdEZWlpVDZqRUZRUkRsckgrcEc3?=
 =?utf-8?B?ZDR3L0FNUTlsYmJHaHMvYUJXVEJDMHVhYU1hUHhQU2RIWkxHSjEyRXlaK0Vs?=
 =?utf-8?B?WUtaYlhmMW1pVXlSYmRzUkxDbVloNlg3VlRJTmZQcVZiRE5DWUROSzUrZ3Zj?=
 =?utf-8?B?YkxQRWRwWkc3aXVJM1NJU2ZhSWJMUU90UVZ3WVdVOU1ndUQxNzZlWHRuamwy?=
 =?utf-8?B?UWJ2cHJCbTVTbFZVbkxiQlFvNmlVSHNHZjFUREtoZ2ZjSU5XdnE3bmpGQkQw?=
 =?utf-8?B?Y2g1TDFoQmVxTXVVUGpDZ1VvMkwwVDNMUXk3Y0w2YSsxY25nOEtLMjRSa2Jw?=
 =?utf-8?B?bzNZTkZGUUhCNEt5SzRVcnYzMEdKZERHMG9laS96bmIzTy9OTkNuUnhUNkVU?=
 =?utf-8?B?ZmpGRXpld2NBcW5BN1pzajN0Z3BOTEI1Qkx5WUJ0azh4K0RyUVFSbG1ONWpR?=
 =?utf-8?B?a0tXS1ZNQXZDQ21adTNzYURKQjJyS2FoWEdMTCs0VnlNa1QwQWRyQWo3bVQ2?=
 =?utf-8?B?a0UwNjJCL09JV2R6blFMSENMbHRMUEdMU2FkaWFKaUdJeUplb2x3T2pHUStL?=
 =?utf-8?B?SVBUNlpOZkxuckthRkozalpOM2hLNnBDQ3UrVDNtRHlSVytxKzhEMkMvcmxT?=
 =?utf-8?B?NjZQS2Fqc0FUUlV5Umk4WUNFemJiWVFKc0hVeGNZRU16SndtZmFBOWVzQ1hw?=
 =?utf-8?B?dkVWa1JVNERQckxCcER0K1UzQkh0cVVXc3d0UmlWbDZGQndqdFA5Z2JWc1hS?=
 =?utf-8?B?cFMyYTR0MWRaTzM3Uzk4eEQ1Q2hHQ0xSeDM4Ynk2b2tvb3hKdmtHaHV4WlRa?=
 =?utf-8?B?SnAyVExaNEg5dnhCd1dLV01xNUd1K2paYi9CdVZpZnBYRzZ2UVlFekhqdEhw?=
 =?utf-8?B?VDBteU5sVUtSV2xLWGJkRHllYmNDK1RjUjVmK2JGNFFpaGRaZ2ZNSndtY1Zs?=
 =?utf-8?B?WHRLV3FJRUQrd3owejEzUnBISmRWdi9aRkNxTkEyaTVDU2Vyc1E2UWN0dlBv?=
 =?utf-8?B?YlFqenVPMGlkUThJOE96blBnR1B1aEJTYlFwL3ZOazJSZUVzSHRlemZJK0Rm?=
 =?utf-8?B?OEdRL2l2ajRUaCtwSCtGUHRIOFFxVXcrYmZmbjRZSzZHbTdIRDBVL2w1bjBO?=
 =?utf-8?B?K0U4SWdCejVPQ1Mvc0xlakIxN3ZSRWhXM0NsemFXNDJqT040TGwzUGMxWXk1?=
 =?utf-8?B?ZHdEclJ3b3l0NDdLUGpuYWJYQlhpczNiTnRjdHFNdFZZeTk0QUI3bzIwZjFT?=
 =?utf-8?B?bWczMDRxb2RDVVUzZitvb2NNSDVFL0pBK052ZUVNbGs5MkJ3aHlwcHpjWFo4?=
 =?utf-8?B?SkZ0bldwazJaR1RnOHdibU01M2I4RTNFd1NVcDlkZXhPU0RkaXRXdWUrN2Fa?=
 =?utf-8?Q?AZtrNAEoUyJ2io3C50KeJnrrqnDMMc8kGme8W4uIpDrZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffcfeefb-60b4-488d-efa9-08dce874a509
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 15:11:26.5003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovHnsAMhCCPY8pUNA3VCVhKz5RcRjhGwTvJ3u2zfnI29qnUJt7+pNHoeSJ2XPYF2OZZiF7RBF5CfwS5YoR040A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Hi Greg,

On 09/10/2024 15:59, Jon Hunter wrote:
> On Tue, 08 Oct 2024 14:00:30 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.11.3 release.
>> There are 558 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.11:
>      10 builds:	10 pass, 0 fail
>      26 boots:	26 pass, 0 fail
>      116 tests:	115 pass, 1 fail
> 
> Linux version:	6.11.3-rc1-gdd3578144a91
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


The above is a new kernel warning introduced by ...

Michal Koutný <mkoutny@suse.com>
     cgroup: Disallow mounting v1 hierarchies without controller implementation


Interestingly the commit message for the above actually states ...

"Wrap implementation into a helper function, leverage legacy_files to
  detect compiled out controllers. The effect is that mounts on v1 would
  fail and produce a message like:
    [ 1543.999081] cgroup: Unknown subsys name 'memory'"

The above is the exact warning we see ...

boot: logs: [       8.673272] ERR KERN cgroup: Unknown subsys name 'memory'


So although this appears deliberate, I don't see this on mainline/next.

Jon

-- 
nvpublic
