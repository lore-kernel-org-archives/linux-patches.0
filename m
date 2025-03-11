Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ACD235BF3
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687919; cv=fail; b=Cpt77keMMy11Mbj9rS13nCg4Hkexn2Qtz6r9z1HIXvkXLJ3FuT8JGJLmyJoqwhcXDAyGU4qfu3PyKswNRLLBb6yqYvkcPS55nyv6FCcVX1hPJcMW46rxQbJg/z1pRHPu165KM+LdfeP84vpp0UA+0ZvzbH0sqEgf2Rx9jqa1lZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687919; c=relaxed/simple;
	bh=CIJSq1gtg9iacBPDz+zh5W/njrBxK7skb30O4bW6ze4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fo/E+3IGTFaa1CsYbsIqL1NVBIeRF+v3X0oQvgzg/tI0PlqsiidkNYvJnMMvUuOML2FTeCaxeqtTsbag4Q8y3KbQksZ62/LtUfxo8NZTKkFtGnAA+d/z69xtRWdRgWoIJIGydQ9Irng39J+EQlNUg4GjtS3zOld7DOIqxdEfrig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y74rpTBl; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y74rpTBl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqCySFNYPEhhZqraKGmByg5PY8QtnLdJx1j/vF0u514hP8HRz2BcduJA9HJqDy/eCzbSKL1yeknN3L319Tt5JHN0sigO40kVcPHujIzJME/Oi6p2Rlz0gj+93QoU8kLKS+BOxtr7Agl4ZYy+Kk+QZsUM5nn9KHQUmYT/92IedgmQXonDArnIhwerk1pplDJcoB72JEyknchGpaQkCOR5cKN1lN/1fmnBqEGg7vq1M8x+UPTqBgo5gfCbo+llR8NQpFbXEm2WpYPs4+K19NmAT1DthLRrek8EvwYR/48jBK6bb97BMeESFeJ/TDJRCKRosx6mWsYfuEnImRVSuwCr+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ5LkLN2t7aHZX8yiclY2/akbv1YkxB5V9WvAqbDNAE=;
 b=adKP4kVLwICZ9lozW1yM5qNNZo80E+Z4/C45QRteUBDDju4IXa9oa8wCALgry2EszbC6WeXBx4lEeTFm/c9uCgQ4Gq3vknUqw8U7/oGv6lcmxXtUroTW3S7VtJSHpwKV2qcpBqJte0DIlREZMVJcftRSdFHzcvwbLM+pfbAoAQtgfKc5aIvxhdpGe2f8ezV+khAvI6AFl9fQZyDjWEAjWYGH3ui0qXpKm4HwvGAtdbH7FQp4bg/NyBheM/YO6N3gciDUWPz7zjdeM1hzTmGFL/ewvCOP+7zDFsxjGVyWuBJzehHHIVIEy+gUxb52XAdNeSrEg2N0cBjjUv5MBykYuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ5LkLN2t7aHZX8yiclY2/akbv1YkxB5V9WvAqbDNAE=;
 b=Y74rpTBlZ7AIMoyiP9Nmc4rN8b+9riYK1KnR/h3F0Voj7waERUShABtU6a1lVbR40tjO3o0vxdVRsDK5I5wr91e55JbIMp1ykwOX14cO7r0FXhWaAZ+0ZECYjdFF6jmQQpX5BdPGezqPcQSWUXQaalhGlDZB0uzUzxD1nKCGAqqO5FJMbcl7/AMw1J4ZZibckAh+PcgZxea+A/431oyzQj10So7fM7/MvVSdOCvY+3gz+hJrFSW+IgwHE7VTbUUK9PFVjgXjCMlNS4uGZ9t4LeQmuI43rObBuk64LyLCPAaok2wnkFNIjJSALm0ZMP/sZ+9iaqeBAdCBobyAFc3glg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CH0PR12MB8486.namprd12.prod.outlook.com (2603:10b6:610:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 10:11:55 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 10:11:55 +0000
Message-ID: <07b8296d-ad04-4499-9c76-e57464331737@nvidia.com>
Date: Tue, 11 Mar 2025 10:11:48 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250310170545.553361750@linuxfoundation.org>
 <65b397b4-d3f9-4b20-9702-7a4131369f50@rnnvmail205.nvidia.com>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <65b397b4-d3f9-4b20-9702-7a4131369f50@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0042.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::30)
 To SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CH0PR12MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: 200da797-ff34-4e09-f136-08dd60852655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1ZoQi8wQ3JDSCtIS1lMUGpxSkNtU2NPekRIOVd3c0N2ekV2NHNRbEhzVGdQ?=
 =?utf-8?B?c2lSbEQzZnFpSTNvK1BlY3p3by9mdEF2TE5obzEvUU9WaTZDWXVJNE00QWhS?=
 =?utf-8?B?d2pWQnlDd3Uyc1BHaTRvc2w4anVGQzJTYTBTNllCdU1tNnpxUzgxbmxaYTFH?=
 =?utf-8?B?bGhPc2FLQWNIYUk5U0EzRHRya0psQld1b1ZKb0RDMTZUVFdrNCtiWkUyUll3?=
 =?utf-8?B?V1ZST1pDRDl4RzI0ZzljdlRZb2ZWZSsySEdqZkozdXl6NVBXTlUvMnowQVVK?=
 =?utf-8?B?YjhESnp1QUJSWW9yWkhkcTZUT2duN0RSbGFqRUl4ZzBEbzRDRTNVSTF0R0ND?=
 =?utf-8?B?WjF2bHl4WDFYMFpKR24wNVlTS1N2aVdBN1BBM0o0VUJsMTRocURMc2xxOHFj?=
 =?utf-8?B?L0RSeWJBbmplSU83TW93K25FR0NyRVRTK2NLc1B2QVpEdWxKcW1jem0zbzdT?=
 =?utf-8?B?c2thVkx4d2FGemVFeWN2UWZzU2ZHRndpZjBYVlFMb2p1TnlMS1FwVXpRci82?=
 =?utf-8?B?NUdvM0ZuT0hiMkpYT0xOVmlud0FtcnQrS2dBcnBUOXhaM3Y2R3RVcGpvWG1i?=
 =?utf-8?B?UDhrR05lcU4vYVhQUXlUNzMrak1pSDRCUnRpTWtDb3o0dDV6TFVCZHdxSVVZ?=
 =?utf-8?B?VkRuRUF1aXYzQmh6MmFMdHdObk1ZZERWbG5rY1B4aEdTMEdKTXdEWFFoSU16?=
 =?utf-8?B?SHpnR0RGVFh5MlAwNnlSOE1vSmlkZnBvVDhzVi9BekxJbjlhUVdlem5wbmtB?=
 =?utf-8?B?Sy9McUtHNDNJd0FFY2ZNSTdnN2dhV2Z6ODRVSFJ5L1JMWXlKQkdOMFYwMnRR?=
 =?utf-8?B?NjFwaTEzY3YrL3BPaC9MY2F0WkVOdVN4czdhdzE0ZkVsRWFONnI3UmU3V3Ba?=
 =?utf-8?B?M2l6dFhFbHRhdDBZYmxlR1pQV2ZaSmJ5WXlGUXJRVWs4QlNJUTJSREdjNUM0?=
 =?utf-8?B?WXBKMEtnM0kwT1FiV3ZWWnAzOVFYdURLaUdsK0RFV2daaWZqNkhuZ0pYbDBt?=
 =?utf-8?B?VzU3QnlGaDRxTTFMZmFrOXZLTTVaVUJlVE1sdjFJRFlHVHRObmphMXFZMmZE?=
 =?utf-8?B?eitMeWVvVjhuRm9vNk1mbWVWMGRKeEFScThVUVoxT2JRcUJWSjdDSklsb1J4?=
 =?utf-8?B?OGJxMnZPNnZ4MzdLL01Ga3pTZE81bjcyeXdXd0t5VTNwWFlnN2k5REcwM1ox?=
 =?utf-8?B?UUQ0MElrWWZReTJGK3RLVmxqNEdRZXVuS3lralBlMkRhQWw5eFpGT1Y5OGxB?=
 =?utf-8?B?RHVNeFRWRHlHd2VQVWRQWGk4dXVXbDJRbUk1NGhOOWp1RDFvc1N4ODZXaENz?=
 =?utf-8?B?T01FRVpXV1NTblhMMUpxZDl1dTRnVDA1SHMwUkowaUJEbmhiRVRLTU5sTUdR?=
 =?utf-8?B?VDdRMEtPcFl5cWpNM0Zuc28rak4wYmlKMW9LbDFCY29tb0gvM3dFSThLUnpE?=
 =?utf-8?B?ZVpvalpTUWd3TmVHTEpJYkF6ZFkxaVhvUUZFa1hDT1ZYbURyNWozQ1BrNlVQ?=
 =?utf-8?B?WWNoeGVGVnl2NVZmSUR0ZmdpSVl2N2RZZHJKZkN6cERxSTlPaHQrVXpucmh4?=
 =?utf-8?B?S3Y3TVNmcFE1WDlHWEEvRTlqTGV3Nng1Z3VUbVdUMTJ4VFBGMk42WmJaQ1lm?=
 =?utf-8?B?NG5kT082T1padys2OVkzRkxNR3VGdHpNSVJBUUUwYk1CR1FYZGQvSGNjNHhJ?=
 =?utf-8?B?VWhFUjlUSUM4ajZrN3M2QUZ5N1dRcTlmSDNJTFdBSENWdEtCRGFiWksyeUFq?=
 =?utf-8?B?amU0aTF1enc5c3VGc2FjNXhPaGV6bDQxK2xyS2pUb01SN3B2dDdGbDBtekJs?=
 =?utf-8?B?RnRqQmV3RkM5Z2JLdlNZSEFEMXhZWXllMjVWSTdxWTVXR3FMZTU3RjFKUUFV?=
 =?utf-8?Q?j+4UymsgDFn4f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0JXQWEvTkNicjZ1MVp4Q0RPVy84WDB2U0ZteXZjKysrY0NNVUVOZ1hlWFVV?=
 =?utf-8?B?RWNVU3JyTTFoQ2Z0TUZFUm45Tjk5UmxDU0NzVEI3TXBDOG9ZS2dmV2V4SWc0?=
 =?utf-8?B?L1c3OVVhMHhmY1h0cFo1V3M3MTFJSElOTVlzWmhzZHhMK3dyZU42S1hud2dw?=
 =?utf-8?B?N3N6cHBWMWJKTW9JWlVsck9RbkI0WDlKdTZLR0o1WTM5UjR3cENCMllZS3d5?=
 =?utf-8?B?OGRxQ3c1WmZCOVloY0Q5cURsNGZOTVc3S2FOcGJCUHlpOGdzc1VNSkVHQ1BN?=
 =?utf-8?B?S1hXbFlJblh3aS95ai8waGkzK1N4UmdldTIxK21ib1VqemhBZm5xM3lqQjho?=
 =?utf-8?B?WEk3Y3grSXRkb0Iva2wyR2lBT3pPNjNmTTA5ZWRIWERVSEpQakQvNkxNVFlz?=
 =?utf-8?B?OStFYVViendIa1l5cjBOS2hwaE9qQ3cwbmVHVks5Vy9vaFcwbWlFTlNQUGNl?=
 =?utf-8?B?L3dNSndLOG9HdEI4TFE5RnBxcE16K3pKR1ZyWlNaOHVqYlFIWU1HSmFWb0s1?=
 =?utf-8?B?eVNTODNidlpMbThxaHBkeU1JYm1UN0MxWFpTR3VrWGgrcnVkRXZqNm1nVXRK?=
 =?utf-8?B?ME8vQUlUK2xGLzJEYmVCc2ZHazNaZEtMY1p0bHpXUk5xVkFvRVpkWnNRd1pC?=
 =?utf-8?B?UFRoeEpMSnd0NnJLdkk0MFlpN2ZUMDBIT1Z0SU5zT2F4Q3VsVlpaY0VFbStB?=
 =?utf-8?B?aUhaMDR6TSs5b1dNYk1PS2IvZklhQlZzQWJGemVUSzBRMzZya1FjaXJhc0hZ?=
 =?utf-8?B?UWliemdSeE9hUm8zaXJvelFTcmVLYTlQR0wrQ0UwZVY1MzI5WExrQ2Nsc3RF?=
 =?utf-8?B?cytIb1ZGdVZreFlLNFlFdEM1aWFCSHNqU05pSmhjeXQ3UTlLRVFVL3d5M3FR?=
 =?utf-8?B?WEhSWEdINnhGeDJ4VFh6dk8vb0ROeDBTTWdPaUxIQ1RmK1pEbkZ4YTlxaEZy?=
 =?utf-8?B?dFU0MTRlQmc0My9PbUpDS1ZOOFFPbUFGc1lqclVwZjZTT1lNQnIrNC9tZExF?=
 =?utf-8?B?eE8vUklEeFVVc2xRUDhuSWkxM2pMRjBlS1ZaMUdnSzlXalRvZEtGQyswNlg1?=
 =?utf-8?B?UFFwVnF3VmR2QlpqbjJCMlVCMEg1MkZRaUpaazFZZzA1VG43TXNGUjdCMkxP?=
 =?utf-8?B?QlJ1MTVMeGF3MHVpNWN3aTFDdzJ0R1JMVENxL3hxSFpnREx1SXpGQk9IUjlD?=
 =?utf-8?B?QjNUSE1OdGRJQkJYZ015V201b0IvWXFoZGNEQTZ5M0w3OEU3VFo4UjRlaE5S?=
 =?utf-8?B?UTNXM1VNQTlPWW5zcFV4b0NoUzFXYllGT3MvN3dIcEg0Y0NWMEU2MnFOaGhh?=
 =?utf-8?B?Um5VOVlyc2NPbThsY1BQcHlvL2RVMVhveE95QW5TT1Q0SUxYditIakVYV05H?=
 =?utf-8?B?Q2xENS94eWhja01jdEFjK0ZlZS9aRlpQTFc4Mlk1T0RCVVFNaVdUTzd4TC83?=
 =?utf-8?B?eW1aS01wWkh5RTVqTHlKc0hQcjYxYUUyL0FraDhkd2FqeEtYNERTR2dPeWZi?=
 =?utf-8?B?WmpNeXVIUmQ2Q0wxcXFKWi9PYTdMNU0xUnlrZDlJTzJvdktZSGxmSzc3T3Z4?=
 =?utf-8?B?UUNReXdEN0RQK3Nic0VLbFQvdmsrR05ONUttaGE1UHVlVFJId3ZQc2lxWlVI?=
 =?utf-8?B?ckgzV2xUTWxyZ0FQWUorOTdzNFArYWsvYlA2WDcvbDNEdlNka3JCMFFsYmM1?=
 =?utf-8?B?S2FKblBkdDZzVDc2M2RnTzNreUFIZU9hVkg0bzFTMW9EVEVrUFpaQlVFdEo4?=
 =?utf-8?B?TVA4aVMxMWVwTmFoYm1tdWphNGwvUjBnZjd0ZW9RZ2ZWREFjKzhLRWFqQXpl?=
 =?utf-8?B?V1JmWjl3M3hrOEx4ZnM1RkY1cWJaNGZ5dFkzSzlrZ1BSTE9QS09OdnZaVjlT?=
 =?utf-8?B?RmV5dk1jaDVrM2NtMDJWenhobXZQWDUwQ0FpTTNyYUVLcUloSDBJS1dYS0Yx?=
 =?utf-8?B?QjY3cTlOZG9yWXN5YmkzK2EyUzhCZUt1V3l4aUZtUmRNaTBreGozdUpHM3RK?=
 =?utf-8?B?eHdmL1FEQm5qcENaeWVENWpQdjNTL2ZEMFNCM2RIQldpcG5WTXltS2MwUUdy?=
 =?utf-8?B?RTJmcFlpdEZuM05SaFNsM0dKYzZJdnJrR3VhNFFJWGtSY0xyWk13WGdEZFIw?=
 =?utf-8?Q?iibUocgnweAb3TKasnBEnWPBT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200da797-ff34-4e09-f136-08dd60852655
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 10:11:54.9360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOPw6aVrLTkAAJBDqA1Vgz6E9VLUX3nbCkNWLWu7SJhZX+Lt+MiiB7SWrTcOyyzvQeYM74x37RkTNaEj24Dxig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8486

Hi Greg,

On 11/03/2025 10:02, Jon Hunter wrote:
> On Mon, 10 Mar 2025 17:57:26 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.179 release.
>> There are 620 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.15:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      101 tests:	100 pass, 1 fail
> 
> Linux version:	5.15.179-rc1-gcfe01cd80d85
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py


With this update I am seeing the following kernel warnings for Tegra ...

  WARNING KERN gpio gpiochip0: (max77620-gpio): not an immutable chip, 
please consider fixing it!
  WARNING KERN gpio gpiochip1: (tegra194-gpio): not an immutable chip, 
please consider fixing it!
  WARNING KERN gpio gpiochip2: (tegra194-gpio-aon): not an immutable
chip, please consider fixing it!

The above warning comes from commit 6c846d026d49 ("gpio: Don't fiddle 
with irqchips marked as immutable") and to fix this for Tegra I believe 
that we need commits bba00555ede7 ("gpio: tegra186: Make the irqchip 
immutable") and 7f42aa7b008c ("gpio: max77620: Make the irqchip 
immutable"). There are other similar patches in the original series that 
I am guessing would be needed too.

Thanks
Jon

-- 
nvpublic

