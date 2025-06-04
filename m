Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F81DC9BB
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 10:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032419; cv=fail; b=DkIW7adnafDoSn+igvjDkINl1EzxQvXcV8lMjo7slqIe8+u65DgTzqRE6mPRpWPSR4FGLhl6M9smsJtoQbTko3iXPtUHoXEJ9N8vhSIYzt0CHatDTdiWAkTzDYlqsRVu59abRTDNcjnORXtwuhaGFeG9A4NFWmZH9HrkdpfArNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032419; c=relaxed/simple;
	bh=xT/bbjcu3icyVWffFjsuN6r9HOSr4ogSe+/gUIRst88=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YyrWwMHAcxPfgCYU4MqpLcEzCl+iGh+i25HeBdjkDiQ1atcRHbGTlMQbAtVoGEh7dDmZDawbRztp+F+WATvgZK95JBJFK7PX1+wLoX8F76GeucAelTnL0fK32jHFR7Mrj2/s25qNoT8iZjKN/UpqxrZH2hFiQe6hPcs2h/L4LhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cGL3BA8a; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cGL3BA8a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F66PRTMcuRvXzv72Nc5FTaswhcd8qKbcqa07x1VGBPIA/O8Mma528U+2jlOpnl6ALGXg6oGyJ05PmTm+8YrX7LDRATH5hPchQWbKEivGvEUV6H1cAQaBNatrws5TJEsm74IEEVc7GHcRV2kIjTILjmp6Vrp/MmD7JsxdMTekJw0rjqIT99S3c7GtzXLhpDbwQLt/ounlFJ8nUARmZzuh7hH5Z/CpHPUhrlXhUV4p9G7Cl++j4yPW9qFEh5jeEbNhSzviBRS7hsghZ3Got1sWmxCE/wtec8BSB7jRKYAlr+3NuYkSKd8JIkVPy+GNxxAAuCwD+XYZShkryNmKe8qHMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5HyNJPrgm16dkQNvqUTBqGFykgrYCwO2xzlyOnD/6o=;
 b=AKhBiNx3CHrSznKhygf6BPYS0Jium9sRE4nxTCgJ9y0DTgq0Km4LcO4ZCtKjJYCqLQuRrfysUwiUC4xU/MvTpvyV000MrEFx+Rl2gtU21R6unsD2fRZcyuXh+0JAzWJ2oo0DTB0OYh4cyVxTrSrQ7vHKqesAzUc0ou/Ha3b8BX357O2bNzsfhcgiAOBS9WhVgTC1BpkL4jNz0fqofNK6piZTCrjnoV2VA8zdBQ0MA3U+4Umrh7vB23GZ3togznLEFFIBt9Yi8jBOj2eRujd2AJMuRQS3N6epQ0mnUOYC9WGUCEGkgbh5cLxwadiEo7DMEBImd3mN/Qkyv5MXDWgqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5HyNJPrgm16dkQNvqUTBqGFykgrYCwO2xzlyOnD/6o=;
 b=cGL3BA8a/Up/RbbMNF1bk8Xbz+PwCe/3f2EpgCqGA0ni9ENYRmxW3lDq4YT4Jg4U6CHNNW7B2bEPzTFF14Kd7EOf6ZYZAoKACxNOm+1dVYE6Ztvdnzf659MQyFbqJ8KYD4TxCGb2qKhfMOOVA1bTQT+LoRBBBvxSH+JKL7/x3xOpCq7M6ULOVl2oK4BE2ZnBRaAMV2c2h1+ca1CWwWGuEV0pAq7ZKCIl9IEeo1c5HlsQnyu7rfyjTG8iI2qtABfm8DnclpU9vLWZbQHPiD11itINK+QY8e9Asr1152VN5dhGYaSFvfpvzDFL4v9u8Rv1dvy87a/GegDyR7vrjB0FAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB6416.namprd12.prod.outlook.com (2603:10b6:8:cb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Wed, 4 Jun 2025 10:20:13 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 10:20:13 +0000
Message-ID: <fb1252b4-cc2e-4227-94be-9015ea8f3d1b@nvidia.com>
Date: Wed, 4 Jun 2025 11:20:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250602134238.271281478@linuxfoundation.org>
 <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
 <2025060446-chewer-dill-080e@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2025060446-chewer-dill-080e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::6) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB6416:EE_
X-MS-Office365-Filtering-Correlation-Id: 669b1423-15d6-44d8-1def-08dda351647c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjFoWk54dTFsa24wTGRIREdYYm5zTUpaZ1ZOWUZZK1NsWXJRcUxSYmxtaERX?=
 =?utf-8?B?YUpZSDllY1NobzlzNGYxbUEzRVdxdGY1MFVHbjFTVmlhRlRiOG1aUUVNbEhv?=
 =?utf-8?B?aWdQamJkOG1oeEJ4T2p0STlKMy9UOTA5Q1YxL3g3Rlo1OWt3OGY5QXFDWHI1?=
 =?utf-8?B?N09SQTNpMW1kcXdPQ3FwODRFNXRaWHY1RFBBSzJpeGVWOHh0VHBXd1NFK0tD?=
 =?utf-8?B?RDVXT2w3Qy9Tcy9MazFxZnFRbzE1dFRtcGRWeVYvUFMvZ2gwVFN4VzJieXNJ?=
 =?utf-8?B?bjF6VENoNVFiVDB4RUtvcXplcFB0eDVZa2xocHoxTXE2NXZOTjVteWhKL0Ev?=
 =?utf-8?B?anJHM0hPMThPcFhhaHBVSEVYQW16elprdzZmVVZQZ1h6MEswSHhVRS8zd01l?=
 =?utf-8?B?R3p0VU4zL1RvNXREVHoyRDFXaU0yZWx5R0haKzhZTFdNc0Joam13YU1wSnoz?=
 =?utf-8?B?QXZBUVpqOFRsazczcXA5M0gxOGduS1J4S3lROWlzejc3dlNvMVBqeVRNeTNI?=
 =?utf-8?B?WUhQT09waGkya1FSMHpMckkwdWlBWklRVGg4cGN3RU5OSkpISWtDangwZ0Zp?=
 =?utf-8?B?SEpLMTVKNndkZUhINkhhUXgzaTJxOURQdlhZandybmpRRWRiYmNxTHZrbm9Q?=
 =?utf-8?B?NDl3bkRQUU53SnhaeEQxYzFnNlBZOUpEY3BpTTBMaHI4YlROaGhCak1SZjl1?=
 =?utf-8?B?MWFwcHM3YnN4aG1SRE03Y1JMM2tPZmRMT1MySnk5d0R0dzJSQ3k2Y2JuSVlV?=
 =?utf-8?B?V0lJcjkyak9PQXdNSloyOWxyYnNrNC9jZitORW1PUGw1MnY4K2IzZGF3T0Nt?=
 =?utf-8?B?azZhRHI3M1l2RTdvaG1QaUJiTTJuQmQ3VW82ZjBEZW9hd09DOUlXcW9PK1FY?=
 =?utf-8?B?N0o1M2s1cGVhTG9VZmZyckdYZ0hoN0cyelozd2c3aVFTb3BtMitPWGxXUkpn?=
 =?utf-8?B?d1VZZ3B0RzZ0Z240aVlwS1lvbjJzaDBYY3lCUUU3R1Q0TGw1aGh2b1huS3Fq?=
 =?utf-8?B?eGtDMkR0bkVEOFpIM0tUSWZPMDkyZmhKV25sREhwKzgxd3dMdmo2TWtEV0ph?=
 =?utf-8?B?bHljWXBGcHkwUHJFeXQ3N3pxZUxobzc1SVk1cGhHQzZOL0JtdU94WUtPYXpp?=
 =?utf-8?B?NlZxNm1UY05yS1dCei94Y1JxY2tsOEJtUTV6TDVkYnpWUXNNbUk1M3Z2NGg5?=
 =?utf-8?B?eVBLYkgwZVlqakZxbmF6cnorN1cyWm9mQXNPQllUMVA0OFlhKzVBU2xDT3Jl?=
 =?utf-8?B?Mm42djBJbkJObUhLQ3d0SG1IeUdBVWRrZWEvZjcwZzRLSk1EZFBwZklNT05w?=
 =?utf-8?B?TmNna1hIcUFPMHo1S1hvV1RQbHJDb2pWQ3YzRnNzaGtFWVUrNWYzRlE4R3c4?=
 =?utf-8?B?VTdITkpkZGZuZ0lEa04xVmlxL2lvZzl4SGQ0SFdKK3J2ZDBRVU5FUURpSVFU?=
 =?utf-8?B?WFRnanQvekUxVG9EaXJ4NzFQS2w4Z3BidjhYM2I3bm5vVVdranl6SDRoci9a?=
 =?utf-8?B?S0VFaVFaakdJWE5FTU5UZDJSblMwSTJVdEZLbHFRdHljd20xQ1JZTmRlaHRw?=
 =?utf-8?B?MXNSdCtlaHFnbldNK01BZysyODdCS041MGZYdERtSTJ1T2pBKzN0dzNsVFFw?=
 =?utf-8?B?U3FFQUIyM1I5amR0bnpYZVF0NjNyNEN3ODAwOWNXZnJZUXZIN1BvdkhiVHZE?=
 =?utf-8?B?TVJubzE3SzdWRll4Wk05WDlVRjkyU0xEUFdyUjNDTFRZUkNwcDJTMGNMOS9m?=
 =?utf-8?B?QmczRndFQnVRMXZlVlFlNlpFOFY4RDN6ZWh6dnlnM2lPbG91WGlBaEREME1w?=
 =?utf-8?B?VE0rTDVBeEo3bDlyOVRSOTJpTkxiZXdEYi9mZU5OVVlHNlRhejUwems3YlZ6?=
 =?utf-8?B?UWE1aUNUb1pWRldBVVI4SUcySG5sdFdNQi9tTzdUdzQxZ0k3V0ZYTkFkYkRk?=
 =?utf-8?Q?/nxLLrLvn9c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enlscVVXRlFVeDBMZ2RaeUR0eG9leEI3dHo0ZEdhQUpJaEVTRGFhbkhKY1ZN?=
 =?utf-8?B?VDFBbEhiVk9OUXJraDFES1h4Y3U0a3QrZWNkS2I2OEIrU3dDa1ZrVTFKbmNo?=
 =?utf-8?B?Q3JGQUtNc3F4UnRha0xmYWZNR3BjZWQyL2NvVzVSTnNtSE50U3hSS0lDMTli?=
 =?utf-8?B?dVd4S0wrRjRTTWxqTU0rQUY4dXlYazFQbEVuUEdjOHhxdU9hZmJuS0o5cHlW?=
 =?utf-8?B?NUcxSm5EbHlJN3lSVXJjWUNiYXVnT3h6SlVyZVFWRWpsN0o4T2o2VFk4Q2V0?=
 =?utf-8?B?aXN2ZVJzaFVSWk41MXF3YklDd2d4ZTVRYUhJUHpMa0ZadUNHdS92K2lpaFEr?=
 =?utf-8?B?dC9LdVNmd2I5ZlJCaGZGZ2dxYitzNURtSTdqZWpHdnNWRTF4M2VYM0MxanR6?=
 =?utf-8?B?dkh6M2hhWW40NW1OVGp6c095RE5HeThFNWQzOUFFNGdzaDZ4OVMxMkxGbi9N?=
 =?utf-8?B?SXBmMDNsU3QvRlFKSEZuTWI1d2lFYmdNRUhTeGNNS0FHS0gxZ24zeE95cnF5?=
 =?utf-8?B?WUc0eGtNdXIzY0EyV3pkc0Ywc3pJRlRQOUhSUFFqblZqaXZ4Y2JxdFZXN010?=
 =?utf-8?B?TFYyWEVMeXlSTjRwdVFOSVdpUXRkelVaMWhCcEMyL2pFMlQzOVFCSjY1ZXR6?=
 =?utf-8?B?bVFuK3huSFEzZDYwQzhteGVYZjBmaG9wLzcvenFSMXR1MmJtbjBmRW0rSks0?=
 =?utf-8?B?d3N0RkZMTnBWa3dNRHNWcjRPYmRjWW1nVElBL0lsR3N1dERnS1ozTklqR2tw?=
 =?utf-8?B?MkdwTk9BU1pjaDFvaUJRcXRhUzRjT1pXWXNpcjJnYWtiMjdNakcvMDRUNHRp?=
 =?utf-8?B?LzA0blVJWFMrUkhuVUw1U1RIQzRudFVoUWo5VVRmSzNER0JlYmJ3Y3p0c1pZ?=
 =?utf-8?B?WFZmODdLd3NzV0d0NmdwMUtmN2N5MzlFcXphaEhXUzhhQy9YQUV5TlhuS2pU?=
 =?utf-8?B?ZTlLNiszd2NTbHo0QklRNzlNRm9nNnErbkROdk9OY04vVk5lNERJbllDV3Za?=
 =?utf-8?B?YUdGNFhXUVJ4UUtOUnlJc25BUU5mbkFUSndITUNjNDBVSUlYRnVrVHMxeGJW?=
 =?utf-8?B?MHQwcWVIeFhONjBNNkVNT1dzTVozNHp6WkxGZFVwN1hHbFBLTVJBZ1R1U01W?=
 =?utf-8?B?MzdUTlNkMGprMmp4U3ZWM2tOcFJhTUxxTmxqTHpTa3pvYVovRTZJWlZ6MXpx?=
 =?utf-8?B?ck12Y3FkV2xsWER2S0RyNDVsaTRoU3VKZFZaR0xuMllJYUNsdVlmSEpPS0U0?=
 =?utf-8?B?Q2RJWjJXajlOenk2RU1XT0hZRVVEdHVZOVAwbFlBNVA5SURpU3JGdFFrbldQ?=
 =?utf-8?B?MTRESnpNMDE4TDA3WGZodGlLWFpXdnlsc0tlUVd1UG1sV2ovTW5QdW5zWVVF?=
 =?utf-8?B?UGxHa1NtOGRPby9kV3ZsMU5qZ3l2bkhpSHNqblRzTFRkbVQ3TDIrQ0JIVnd3?=
 =?utf-8?B?OEZPYmgyNTlrQklnVnU5dXA4cGRRU0JNV1gzQ0h3Z0c5QkNONzY1ckszelVY?=
 =?utf-8?B?SXo2Znl1Q1hrTjJoaGRXUjlqVWR0WExGc1ZTdnZWYk9hdTVmcEE0VHd6WkRa?=
 =?utf-8?B?RzkyWTQ0c3phcjBtSXdoYUo3K2x3SmxVQy93LzJOV1E0Qks4Tk44aEo1VnIx?=
 =?utf-8?B?bG9NQlpYTnk5YmZFWFBWakRhTEYzSjZhZjk4ek5ualhBdGV6N2IyOUFianFM?=
 =?utf-8?B?YXRuWXlFL1RMakpnYkJHbGlDSmUvUC84anc5SGJ4L2pxZ0k4L0dIc2tlNDdS?=
 =?utf-8?B?TFBDWXhUc25TTE9ZcFgyZlpFN3VQdVJHL2lKUms5T0ExOERpRkxxeS8vNjU3?=
 =?utf-8?B?cHc4SHdzeUxhVTgrbGIxTUIvZGJSekZtWkxlTkd5N0NiamdyOExWa25jdWUz?=
 =?utf-8?B?MVpYN1k1L3puOFIwRGtGZWJXWXZPOWNQZERJQWg4VXVDUnI4OGt2clhMRkRr?=
 =?utf-8?B?SGpuMWxpd01SWWdJVlpoTWgzc0pVdmhqc1pSdjRPYVFacEVZclR2ak45WXFu?=
 =?utf-8?B?QzdnbENpSk5JS0UySjYwVGs0MGFlWEZjZGdkWEx0c3RUNXVHbDY2NTF2NEFB?=
 =?utf-8?B?QW1ucG10U0FZQk1oYzNSUUx6RkhqUUZvdVlFM1FWdUVLK2hrQThRV0F3elZw?=
 =?utf-8?B?REt5U1NzMWZNQWNUTTZVVk9zVVF5SjFDdjdOY0FPeTZCUEdRdzJKSjZMZkNt?=
 =?utf-8?B?R05OUE9OT0kzUzNROXZ6QXgwT1ZhMFJYcGpTVmJLaVJrMzVUZzdmaFBkUU0r?=
 =?utf-8?B?b0pDNE5Jb2J5bGZXMkZSajhkQmtnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669b1423-15d6-44d8-1def-08dda351647c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 10:20:13.2439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfdEhXackMga7JFjLwMOKnypm8Xq+fSdnTZ8QDLIskbsUqSw/jfysRZJnUhjoXql+7kQi8F2aOCPnpKf6Bx7Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6416


On 04/06/2025 10:58, Greg Kroah-Hartman wrote:
> On Wed, Jun 04, 2025 at 02:41:11AM -0700, Jon Hunter wrote:
>> On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.32 release.
>>> There are 55 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.12:
>>      10 builds:	10 pass, 0 fail
>>      28 boots:	28 pass, 0 fail
>>      116 tests:	115 pass, 1 fail
>>
>> Linux version:	6.12.32-rc1-gce2ebbe0294c
>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>                  tegra210-p2371-2180, tegra210-p3450-0000,
>>                  tegra30-cardhu-a04
>>
>> Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
> 
> Any hints as to what is causing the failure?


Yes, I had just responded to my initial email reporting the failure with 
the details when you sent this.

Cheers
Jon

-- 
nvpublic

