Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02olkn2092.outbound.protection.outlook.com [40.92.49.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B62183088
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.49.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728459643; cv=fail; b=AqIB515lHYTzCbanFzeon69+Tls+EJlTT54F77Aj+YILxvYsph5+iUuojE6bMB92oDsT3C7GeHY5UORr21ikC7txhe8xPpbEClJsGb6D56X7RCmO932LnLlu5axJ4FSWuGqfiZf/J/10zcQoHQvNPhy85QOS6fTEglPemjgVlwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728459643; c=relaxed/simple;
	bh=b5rC7O1ewtiAGfZVrlb2vsgtcKcxnk+ezHqi32bpWSE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iea25P0AO340kFx15H3f1SsF0aMKanVqDJmRLzp55H/ZWy3Q3IioL74p48eqktTJgaUWkcbCHvn6r/VOj63S6TYds4d1kNt61RH+7KJqwQfnGcmN8I26KQ1MBxXFke3D3lNvZIsqOaS3GrdCBJbmuUQ3LQYrN9+QpI7rbLqytmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=mg5RqaTQ; arc=fail smtp.client-ip=40.92.49.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="mg5RqaTQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQv7nx/+rNHTuXSpC/u4zFAN0i30VtdjvIpqlvkWIWlG0Q7sYwzCX/S9hoPphitp8Rqnfry9zVXOnt2wd9pHfBdSQgezG/DX54KwYk+EIVxPaqH088nblWvsOe8q30nXE3qrAZwKBkTdWszUHqbAKrWSWhjbmGMIswMpfXUCstATkmOiBq5t+YTzpYNlBBhtSiezt52L15M6XtyylFEd+Vj7Hek805jwF3JOrc9QSoa8bKiOM7OLVM4mUkJnVgz9A8Qp8g9spHNVZ8ZAfWsrXnJxLqvk4R2R5SUDqDuDKljiSUlz9QNwS7lsCagOSg4dfvnA2o3qWb+UldPRjI7myw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEZLj4SwXmV4ZPKSIHZZA+9ReRNX1Dxq4vQPIgbrT98=;
 b=qR5fVd+Dou+l/MzEpS89kK3OaEuBcpSYnMXtdQgA+/JQppF9X4IFyBL+RcYuWnKL/MnwiZ+jx2p8MtP53J3NLFGtvUtttZYR8BohtpQSB/FGyzkmviIsMwYVL/v6pDd2ycrFFDPQkB7D4QWb+veKsMgtYNMiX3d/CCse3dKKjsG9xOdX7o6UWUFP3HUb8mvvaoSf75DiKJ/hv23OK59c9/o9AtPDgGgdZGvEAzty9Hbtt3/2aNTdb/ghPS6TBAve6cWeld/x1GBRcVEvlGtXUuf8KU0rnLlLPJg3PAiiUXig/bnHxWOJql06sAI8Pe4+cmB/Clv+bZfyfDwowZW8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEZLj4SwXmV4ZPKSIHZZA+9ReRNX1Dxq4vQPIgbrT98=;
 b=mg5RqaTQoH5j56zK0H65d+YgEa40DWKTGyMP1yIJ/JhpnL+6ke/raHaR9yZvmJ3sOBOeAqhv5e+dmh16pKOx2MxE/lm/PrEZvyp0pFG9kMfQTE+TE8Rl8COjFu186VquYtAiNb2oiAeqKuyVx2duJvwmyZ1ii0jWbUFZem8qDsjLeVyjMTzyf5rZ0QolhMbAK4Cy2ZY2GxsmnHq2PZAcd7vdtk8jhAnBk1mmrufYcU0LJ1GBPdm+1napp61NluysgTwtPBrnXU1zyzx8JfabzD7YExlh0GSR2krCLJOOSEQEpogaQY1U6qbsPp4Z+WMmDeMZO3ML9o0NwjFX+BXcJA==
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e0::21)
 by GVXP190MB2074.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:153::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 07:40:37 +0000
Received: from AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb]) by AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 ([fe80::5307:a61:337b:f3fb%4]) with mapi id 15.20.8026.020; Wed, 9 Oct 2024
 07:40:37 +0000
Message-ID:
 <AS8P190MB1285560871C9638582378B8CEC7F2@AS8P190MB1285.EURP190.PROD.OUTLOOK.COM>
Date: Wed, 9 Oct 2024 00:40:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 141/482] ALSA: usb-audio: Support multiple control
 interfaces
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
 Sasha Levin <sashal@kernel.org>
References: <20241008115648.280954295@linuxfoundation.org>
 <20241008115653.852742957@linuxfoundation.org>
From: Karol Kosik <k.kosik@outlook.com>
In-Reply-To: <20241008115653.852742957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:907:1::22) To AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e0::21)
X-Microsoft-Original-Message-ID:
 <2e22d60f-f209-4f15-8e02-3d89eca7d91c@outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P190MB1285:EE_|GVXP190MB2074:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dbec3e3-5d63-4f03-5e0d-08dce835aaad
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799006|461199028|7092599003|15080799006|5072599009|19110799003|6090799003|3412199025|440099028;
X-Microsoft-Antispam-Message-Info:
	5GeKghx7A9mBAVprdX6EU+FEvbtzLBVbYa/LG7G1C0sXhThbpPiQDOzbpxxI7A/LTinVhA/k4zPKdQYQQ3Hv9DakhQYZlnYn2O/mA2mnKUx7hdpz92IlcMGkiE8I9+6c9mdEetpqojtudqX+fq7pNFdPcOS6efgIJqNIR1EjZ/3EMJKSxwR7YkXB7a96bOKEvrrf4NU7reQoaERkHQO+vSE4RnDNjBBGuuvwAA4wi4iwJ4E3zV5dd6xEpj3oUzdn+xiCVn1LB8nkFB+S8pSG3+Lk4PFturVxEzH/MCCO72xHi84fiCSmQLyqMEIzNI78eCtL0qeMA8I9CDzbIS8bRVkYeXC3DfvxhlP6vnX9fHW3atcYJbbyv2Mef35YKjiIeZ5B3M99iswUdKyst4605L5kuO8At2qi7UhxAupTKVgrUtFOL/DPlm3DxaQyJr3c2vfVCa0kd7e/6JhDw1QY3Ab3BTkW3+1LEvebxuX6RfoUjz4vHMyCwZ/goUm2bpDGZpJmhBzQr7UxupjB5NIRQH8iLiqdhZNHBerCu/p+3frI2S4KGaD+nvt96Vb7+ElsW7ago+Wj2iRSbQoTJO7MvqqICLS2wjaMvfMBISVrq6gfLXpB4zokZX7NZZNUTAfxrazQ9QEK+sIKKApUCK9BVxGMj/8yRHtO/icHzsxVrAxjGSqZr69CulXJ7azGYqZARYw/y5bR3U4USyzJpEkDa0SnuyN2MR6OMXwYFKObMkdd6SOxyRulwSabCnIkEDEZzu7g9skbK9Fq1nT8Kraz0w==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGtEM3RwU29DbndVR1VmdlBrWnRvcFAzVnRvNHR4UXJuMkJNaVgzU1Boci9R?=
 =?utf-8?B?Tm00eWRKQTJtcUJGRktid1RxNWRrdTloNnA1L2dTanVic3k4T1lVbk1KUFZk?=
 =?utf-8?B?ZkNLZDNoVlFkTUFsQzdIM25YSjl6cXZTWkpNYkpoSFBXeFBUcldIdWpvRE9K?=
 =?utf-8?B?aXRSUnIvQ2lxb0doOFFFVmJPWjRWRkUybUE0ZkRoeFdEUzZ5VlYxRUphWUlI?=
 =?utf-8?B?N04vQzZyRUp6OWFWR21uTVUzNy9wcklUTGpGelVMVXAxaGp0b29oZWYyZDJt?=
 =?utf-8?B?ODVZQ3Nab29JdzVQYWtjazh1MGpFWVUrOFR2NEVWVFFMRmFYeXQzaGxRWU13?=
 =?utf-8?B?ZDVQUC90dWNub09vVUNyVEpvZnJFM0hBYS9hNzk0d3ExTmExY1owV2lzSEFm?=
 =?utf-8?B?dmF3NDV4VEtxNVVoME5XMlV2cDc3dlMvS21pTzRGMldUbUdXK2xDMDNRVjdv?=
 =?utf-8?B?TVNTTGRheEZ0Snc2dlVLYVR2bTVPWUU5aDlyZFY4VUZlUUhIY3pJMmowcXlF?=
 =?utf-8?B?M2JkUTFEZFVLbjQ4NGlQQk0vMmk3emJMU1JpamwvTjgrRGpqWG40RGpacXh3?=
 =?utf-8?B?Qnl4WldGQzYrZUlLNXRaTUhDNmdTTU43cW9iMk1Md2tiNks3TFYyL0MxMVBY?=
 =?utf-8?B?SXpSWi9xY2FEMmZrQzc1blpxbGl3Ui9DRU44aGFvakcyRXRMK3VEdXhsYVkv?=
 =?utf-8?B?Nk5WOFdVZjkvRExTYkhTUTVBcnI4anoxbXdzR3BvTk5EejVvQktLTTg0M3Mz?=
 =?utf-8?B?VHc3SnBUam1CTGZXR1Q3aDN0NTZSL2IzaFFRc1QzOHBzQTVQOHZmN3g5T3Y1?=
 =?utf-8?B?NUNldW5Gd3E4Q2c3N0pTRDlEbXpJZksrcTVyYTFaQzF2d25rMXhLem9XNXB2?=
 =?utf-8?B?T0svWkhvVTVnQmxjK3lWbGtXQWZpYmoxOExxYnNNRWZXUW9BUnRMandXY21n?=
 =?utf-8?B?SjRDdzNSNjhPQlVjVGJSS016cHNmNng4K2NicHhXUzNFV2pyR2Z3aFBuUTBG?=
 =?utf-8?B?bWg0QzlOaVY0V0hBUkdhMGMxa29HbnJDeEZRdFEyUjJiTjVLRTFWM0p0S1BH?=
 =?utf-8?B?dFZwaXdGK0pKNE4zalVOMkhSZjRiS3dJS041ejNSS2ZTQWNWYnBwV3pFRVo2?=
 =?utf-8?B?Q2tPSkRVTnJyYjZQOXByNG9vMExaZUtJcEFRaUhrN1lwdHFyeDZTS1JkK28w?=
 =?utf-8?B?NjdINEpvS2dURkdUWklHWnFIbXN0cnErZGNueEpIOUZ4L0hiY3poZXdERDd6?=
 =?utf-8?B?bTRjb0ExRDJ1YXlsNmlZUk1LUFkwZ0RDTEJyT2VDZThUY1M1MDA2S2RFTFNn?=
 =?utf-8?B?WFdyd3VNQ1c3dkZ3K1gySGNKVjJLUjlJTkJYSktjL0FPMHFEaE9EMFFycmlk?=
 =?utf-8?B?cnMyd3ZTbHUxVEVVL1RuV0VRNkpwNW45YVFjUWloTktLUnRtYmw4V0E3Qm01?=
 =?utf-8?B?TlFjcDdsT0Npc05kZXp3VlF5dDdKcHQ0NFRXK1BoTTliMCthVzBNMGRwT0pP?=
 =?utf-8?B?ZUxFbmFuVkpMLzdjb1gzVTZrbmR5VjlMbUo5YXE0VjNUNVdNcXJqL09CNDJP?=
 =?utf-8?B?RzNaNDltTlk1UXEvMkcwMjBBUWlBK2FVZzkxY0haSjhLQnM5MzBub0xXLzNj?=
 =?utf-8?B?MG03WXJTS3N2a1NrMkhXaGJwL3p3N21zQjVRNW54YVUrWkdySnBUUzY5LzQy?=
 =?utf-8?B?dkx5QzlXT2tiVnNxM3lKbzRGaGpzOTBOR3JnMHpkMElFNzB4SDJxbmFGYjkz?=
 =?utf-8?Q?d68vwB8yzbUydsb0oA=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbec3e3-5d63-4f03-5e0d-08dce835aaad
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1285.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 07:40:37.8320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXP190MB2074



On 10/8/24 05:03, Greg Kroah-Hartman wrote:
> 6.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Karol Kosik <k.kosik@outlook.com>
> 
> [ Upstream commit 6aa8700150f7dc62f60b4cf5b1624e2e3d9ed78e ]
> 
> Registering Numark Party Mix II fails with error 'bogus bTerminalLink 1'.
> The problem stems from the driver not being able to find input/output
> terminals required to configure audio streaming. The information about
> those terminals is stored in AudioControl Interface. Numark device
> contains 2 AudioControl Interfaces and the driver checks only one of them.

Please postpone (or skip) merging my patch to 6.10 due to regression.

I'm sorry for the disruption caused by this commit. Fix for this problem will be sent
for review shortly, after I re-run all tests, and I aim to get it into 6.12-rc3.

Regards,
Karol Kosik

