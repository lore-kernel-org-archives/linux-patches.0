Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5818BC0F
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125893; cv=fail; b=jEUCUBYIYABzyN0AZEWI0O1ml6LGhxtmSDTh0mdk1glBEwdCzweimiEhSTBgST9ZQOUhzF3/58H0haFhfwThn2ObOsFhqZSYhdmyyWHXAycCj6r5o5YgGhLE789gEUDwhjYq4QXfa8SBlKES5bvGltPj+ExLhkxG1lZ6yV8NVTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125893; c=relaxed/simple;
	bh=hHqJISV3ctzQlltDyYSBg8dRVvTSEvwK1dLynxvsUFw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=skZ+19i9mwrkQIHbXLe9gE5bX20Nn6FAEZRzjaghYTVrHS8zY2bUVoBxQC4F/PKXyz5Fumw5Rn8Bt85C4UyKBk7NfSKH6torfganTpUafIMc51pNtax7bWRrs75tmaYsedh5e9gPHdgW2mFH3RC7Bv5A7rDI/d5O2FnwyzHrHgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VqQ/F8vm; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VqQ/F8vm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qb/ZRxx2YDemDt53XYiGySgGNl+1OUNtlc6lEkAAw9hOGLABdHFRCm6NO24adwhrxlw5b4EkHDVuxs2T1uSEadDhq9uWMCFf7bVC4oXm0CBptS99GkbvLLR77Yl/jrLM4z8AOuvoQkKgQiOxAP3V+lyUDXmIEtuTOtpIdXExvX1M6/NSOFo/hBqbPuaoIBdiXzIbGeXoWlvVwEuSyMF+3T4vr1ZAFouuJ6nMJy9OLMXB6z49Lr/MrFmJrvqLnZSfXDj2wssiGy//5H3gA3VZHbEu/mnKuyuKzcycrkPwcqVO3R5wUnbnJAvqy+tQdGT8qsHkVqp/3+h8giHO5ZG4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7xw8fBIuju9ZSomfZfrrUH1I68HvBtexRxOJWhTsxY=;
 b=gabKOZqxYo+1CJfiINGLSP1D/ObILi40Usjt9W1zdiolKDsMXUTrS1hxD7r53PW9LgFS1eak+PYZZz10fMIa020yu7+FnlHUI20VspdMCC7ZRWDOf+uhl20/Shi/Bil/SiW0NR9liarftl6vikfMHFOfoCQ19DjnaVwgLJ1P3zdl9dgjQprKR3rBnzh80q5qz7KrVdwsuKVAdgyWYcfx6032gKEoIx+XdciGBNNhuD2kbl5x3swJuV6KE2IItnlchAk4NMBrpQm8ZUtnhm4zTPFNIt/MGHmcuA5HdMavzSywT+rlMC4GBYKA99/gk4lrrjqpUIUbbkJcAsZq5Egybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7xw8fBIuju9ZSomfZfrrUH1I68HvBtexRxOJWhTsxY=;
 b=VqQ/F8vm1PhEo3SkOVXsO5a7VOrR5mFxCUiaUdwAGaR3B7+qCNTiSvLyBlAglCRZwypTFEpTbPOzdNFF0yJ2E4KlXt8tNVs0MJzPWFM7wvZyxJrwlxft0n8Ls3wmgYWG9hKPlZ2jG8B2jL40VBgDWZIzTjszO7oOZ92ceOJRe8CTVnwtSQJ5ywGhwFvjArLlzzXRuQknNkhRqsOfXFfMx6NmUxI5jaBTq5iW+TVIPv49JJoLZU9FkasOuT5TWPeo14G6kJoOrB+uxoENiT5WKRCbEe8+GQM9vIxBrHk41N3ckXGAFqmD210ZBnAJdLff1zn0D+ASLzK6f5bBdRmNAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5447.namprd12.prod.outlook.com (2603:10b6:8:36::7) by
 SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7939.24; Thu, 12 Sep 2024 07:24:46 +0000
Received: from DM8PR12MB5447.namprd12.prod.outlook.com
 ([fe80::5f8:82ee:7da9:219b]) by DM8PR12MB5447.namprd12.prod.outlook.com
 ([fe80::5f8:82ee:7da9:219b%4]) with mapi id 15.20.7962.017; Thu, 12 Sep 2024
 07:24:45 +0000
Message-ID: <10b0ef8b-7fd8-40f0-8d48-b44610502eb2@nvidia.com>
Date: Thu, 12 Sep 2024 08:24:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20240910092608.225137854@linuxfoundation.org>
 <69a511a3-af84-4123-a837-0ed1e5f62161@drhqmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <69a511a3-af84-4123-a837-0ed1e5f62161@drhqmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0276.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::11) To DM8PR12MB5447.namprd12.prod.outlook.com
 (2603:10b6:8:36::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5447:EE_|SA1PR12MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: d279a94b-19c0-43a9-ab64-08dcd2fbf9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SERoaHhvLy9MV244SDl0TVMzSldJaFpnRG14U3RrcVVGN2J6R2UrUGJKZjdX?=
 =?utf-8?B?WW16UGRpTS93aEtqUjJwVWdseWgxUm5zNzQ3ZVgyWnZ0V1FNejVncDl3SGFt?=
 =?utf-8?B?eW9SQmFHMGhETEY3d3ZTb3hhNXJkdXJoc3dndFV5MFZPRGswc2QzMUFPYjVT?=
 =?utf-8?B?b0xXbmJRaDY4cVRjRlgxNERhbzJTUkQ5YVNON2c3YUFBc2VNTlFKeWtzVHhR?=
 =?utf-8?B?QjlqdzBJRm5MUldRNUJ0eEhwZWQ1WHlQU2lxbURMNFduRWVseG14TWhibVNO?=
 =?utf-8?B?M3JBck5xMmdwOWc4ZjRpMmpiQks1bVZsbWxNYStxc3VPc0gvS05tY3lkYnQ1?=
 =?utf-8?B?MmtQdHFrbUQvL25WRGF2Ykg1bGxEUG50ekpIZTJpdGFWdUxxa2M1USsrTXha?=
 =?utf-8?B?OWJKMitLYkVpbUExWEhaMHJ0eE4xaWNmS2p1QnZhOGQwQ2J4ZmgvMStvNUtB?=
 =?utf-8?B?OUpGOXZ3YWhVOVZ5Rm1PcXFDNVRmZkpHT2sxMGUrS1M4U01ZbzJLWHpLSDBC?=
 =?utf-8?B?dVdjUDBGRVVMdHlFRFE0ZXJ5TTEwSHU5TitBVHM2NVpyN2ZmRWZJby83ZWtq?=
 =?utf-8?B?d2NiOGprcmJ4aVVkYzZ0ZG5raENRd3Q1Tk1zbE1kVC9TbmtNd0p6eTRGeFZx?=
 =?utf-8?B?d1RrM3JaaGNkZ0JEVlVnRWgvWTk4aUE4ZnVickNJdUVpY25GWFNyN2p6dER6?=
 =?utf-8?B?ek9qL3IxVElIQU15WHFGelR5alcyTEZrcG1RZDd1MHY0aWJwT20zUSszOHp0?=
 =?utf-8?B?ZzZqdzQ5ZGw3aUpzdEZrS3A4VkZBRllKK0hEeFFKaXhoRFljYnVMQzQ2WThG?=
 =?utf-8?B?eFRoY2ZqYW1DMHZXWEd1YjdXSnlsbHcyTGF4TkxjN1lWb1IvR2p3dmY0ODNh?=
 =?utf-8?B?bGpmL3dQOHE1NzBidFE2d1dkbThmK0ErblpldHlXd0RPcFB1WkhaT1B2S2NR?=
 =?utf-8?B?RkNIRkVLWTBvcTh2aGZacnd2dGxGNEM3OVptZFBWS3plN09FOGRhaGlDb3ox?=
 =?utf-8?B?MFpaUzBCaU8wdG8xbzlzQVgrVE0xNXVtNjdWeS9nL2F1S0NkWVdMUC8vb2Jj?=
 =?utf-8?B?citPSTRxQnQvbEh1MWVuUDFOcEc5M2g1bW85bURyaUgxZVFTZ05ycnd4NW9U?=
 =?utf-8?B?d3BaSU5SRWZLS2RRVFdON1Qyd080aE1VL1lyUjBYMCs5OGtUdnlseUYwNS9E?=
 =?utf-8?B?YlFNWGhFOGNsZlZxM2o5YTlWdjVyeFhVQjF1aUdUY1FHM0gvSGpLbU1nRlZm?=
 =?utf-8?B?aWYvb0dQS25OUUJCcXVnMmIva0NsNzdFNGdLYnNCYVBaWGkvVjNPVURvNDAv?=
 =?utf-8?B?c1c0YlNLSFZFa3JPWTJKYWE0WDlhbGxCdktKWFNKcUkvWmRuTVEzRjZDRWFl?=
 =?utf-8?B?VUYvc1pIbHlJWHo2VnU5bHYzaFNGc1ZEeUlTWER0MWdkdDIybkhlc3N0RGlx?=
 =?utf-8?B?K2VFc3ZhR2lpc2wydjRhSUlGUHF5ejFTbkZIMUV2NWNjNDRQaUNZOVJnQk9v?=
 =?utf-8?B?MTgrMGNYbUVZWDcvWXh1ai80K2RIYzhFa1BhUnhrZ2NCN3V1aWVjMkx0NUlk?=
 =?utf-8?B?UlNCTzJXOXdQMk9rVk93YWMzZW5Uc3NoUEVYK0Y4K3hiL3ZHeVNVUnlDR0d2?=
 =?utf-8?B?cjVFR2x4QlVXVE5CSWF3ejNoU3FGbWJKZmVkQlg4ZFk3cWhhTEpCUnR5aUZQ?=
 =?utf-8?B?RHl3VmJleFpkYmQvaG5OUlFCWmlzM1pEcXV4M1BGaXg2OXp5azNPTkRqdklP?=
 =?utf-8?B?elJtUHAwWU56ak9nY2hvaFBVK2w0OXNoek1sVURLbENtdHN2aVpDazZ2MjVk?=
 =?utf-8?Q?3qBWy+TdHKgPLAHB3OGhVIlehqGuxIr80AoKQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzl1Zkd5Tk5YTjBqZXVwSjFEZEZGc1FrK0VOMU0raDAvd0RtVTdpUGZrak8y?=
 =?utf-8?B?dkJEZENrK2VqWTVSOFE2bjdXd0hhcVN1c0FSVXZKempldHN2U2NoK2s5VXYx?=
 =?utf-8?B?RXFoSnFRcEFTb2l5SjJ5cDV0WEtsZlRNMGE2OGdFaWhvNlRvUXRCMmFjdTUr?=
 =?utf-8?B?L0JjQVcwT2ZFdnVoaDQrTTFXQWVIQWxZNDNtalVJYy9FQm5LSTUwekdKY3hS?=
 =?utf-8?B?ZFhLcm9CZlkzTVZsTlA2U0FtV1VLOStYWXNqNC9wVm03alVGT2xNMC9WdTNH?=
 =?utf-8?B?dnl5aCtEQytndW1zU3JROEEvN2MydjRpZEdKM0E3NHdRdkpwa3drQjlIZG81?=
 =?utf-8?B?N0RGVDAyaVNRWE1yOHp1aFFPNURhZ1dHaVdwVTZCTDRvckx1QVUyOERDM2RJ?=
 =?utf-8?B?Yk9KalpzVThtZTJzTzRKelUwd243WlNyZjM2RG00WUVlVDhobVozbCtoREFW?=
 =?utf-8?B?NE5ZNVFrNEFvek5BMmY4dkpYTVlDRGJkeUNKTUg0WmhLbCtYOHdKNFlybDhP?=
 =?utf-8?B?eTVWQ2c5VUNBMEh4YnAzMmk1ODRkdXJRKzg2OEhPTytyZmxycW9MdDdKQ1dz?=
 =?utf-8?B?K254bEFybTR5MFlURXpXMlhzN0dENkZWYWVpREYzMWUxM0o2a3JIbDhGSHJB?=
 =?utf-8?B?Z3FCa0gzOHN1K0tRb1p2cG5FNSsyUlNwemNtOWFwWmFuenN4SFByK24xc2FB?=
 =?utf-8?B?d0dkSUE1QTBENjdUWTlWbkIvSHhwUnBqYXVoZmRsRmdZUmhnejY1UG1EaGsw?=
 =?utf-8?B?UGRKN1g2OHhpbVpUMmJib2UxS2J1OU5lV2FYcHNSWjMrWDgrT29ZcHZUNFNO?=
 =?utf-8?B?ejBJbXZZRWlNSzFBd1hrN1A2dlkzVU9HOFNvb1l3Q3FZMHZNT1NPYWJJTDFG?=
 =?utf-8?B?a3pIYm10YWxxMUVzaHpoQnJiaGZMV09Rb0tsWEpDSWRxMlQza01WM1A4V1ha?=
 =?utf-8?B?WmlWZnArWTRwdHB2SndKcjhSc1NBUGpuekxUNkJhMXl5WVI5bVMxYk9UV1Er?=
 =?utf-8?B?K1QzQ0p4c2k1TjdrY0ZzQUFzOGxHd2FvRWw5ZFRIdExpTmFBclA2T3pXOWFn?=
 =?utf-8?B?Q25Nc0M3OUtVSVZ4akw5NmlwaXk1aVVickhnMjRTM2ZHMFlGVitQMXhMbUhz?=
 =?utf-8?B?KzRpS1NVbGVaRTVZeTcvU1J1V0tqaTh5aEEvTGVRakNuWktWL04yMVA5YzM1?=
 =?utf-8?B?MGJxTnYyQ0h3eVorNEw3aENTY0E1TjhFTlEvMDdmU1d1Q0FuemNIeWwwaEtk?=
 =?utf-8?B?L2YzQVZvVGI5NUJia2NmTEE2MDJ0aWRhTWxvR2U0TjdhZDNuUVZkNVhtMkt1?=
 =?utf-8?B?VjVYSGl5elE3OVJma1VLYThoNC83RFRiOXNrVkZoMFEybm8xNmlDVW0zbWZQ?=
 =?utf-8?B?bTlaR3I0RXcreEpmaERFUmh3R2dkUEtKRHRNNlE1c0RrZVZmejJXL1JvL3Zq?=
 =?utf-8?B?YjdDc09LT05MSFZhVGpWK1V6TEhBMDk3WWhuMnJYdmJLLzZPek5PV0MyOEQw?=
 =?utf-8?B?UExjb1Fxc25NMTF1TUZqMEU3eHp3RTBpcG0rMnhSQWxmVU04Q0VZRHhsRGxZ?=
 =?utf-8?B?empycEtYZ1lGSkdHQ0pJTzU3alpyc3FKU2ZVMitpZThtbGRJbXRvV29wek9u?=
 =?utf-8?B?clJYb3JvcnlrdnExaUhEaGhkVW9QMlRTcXZEK1JydmtxNE1sTUFPZGV1NFdF?=
 =?utf-8?B?ZDE2a3UrZ0tGVVQvZ1E3OUtodUVpN3dja3gwK3ZiUklGcklKM2E2UXY3bG1s?=
 =?utf-8?B?d1Z1T0pKMUlVUWJ1QXBjUFBRdC9UUW96OTFCTFJ5SUlzQVEyL1I5Y2lVZzNl?=
 =?utf-8?B?RmcvWUUwbGdDRWIwZDF5d0w0dmxKV2F0SWltYkRyQWEzUTlCdnV5S3Q4NlZq?=
 =?utf-8?B?OENiTUVtYUV5cDdJSXY1WDlXVkd2RmdrYWhKZjhjRjZ4Y0JHdlpadW5mT0t1?=
 =?utf-8?B?K0ZhajhHWnJ4NTJ5Sk9EeHRvZEpNaTdCQTQvS2xFaU9WYXRxcmMycUxHOE9x?=
 =?utf-8?B?elA4NjdEYWpsWmRsdDZTNEljR0JqQVNkSjZRUTJSbWdGTlhrZ3ZyZGh3bm5q?=
 =?utf-8?B?UlRXdXlNdWlJY0RpYVFDclQyRDlWUU1xUjNiOU1VMUc4eGZ5cXBvRkh3WGp2?=
 =?utf-8?B?YVZlWThqV2xEVW1VVnlEUGIwZlJwTS95ZXkrK28wY3VJcUdRU0NUd29RSGcx?=
 =?utf-8?Q?zf1HMZ3P0CGmPnph+4tI9AyiTBDsQJoCE4sA+aWX2JQF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d279a94b-19c0-43a9-ab64-08dcd2fbf9b8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:24:45.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2QWunEIvHvR/WhYUB/FdQVBX8LWbPVj4Eh+Ehg/LdRcduEAOOitVEWIti82kQPJspE2U83xs4Uao29LJsWO7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8599

Hi Greg,

On 12/09/2024 08:19, Jon Hunter wrote:
> On Tue, 10 Sep 2024 11:29:47 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.51 release.
>> There are 269 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
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
>      10 builds:	7 pass, 3 fail
>      20 boots:	20 pass, 0 fail
>      98 tests:	98 pass, 0 fail
> 
> Linux version:	6.6.51-rc1-g415df4b6a669
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Builds failed:	arm+multi_v7


This is the same build issue I reported for 5.15.y and introduced by ...

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
     clk: qcom: clk-alpha-pll: Update set_rate for Zonda PLL

Looks like we still need to drop this from 6.6.y and 6.10.y.

Cheers
Jon

-- 
nvpublic
