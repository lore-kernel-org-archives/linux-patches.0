Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78EF221FA5
	for <patches@lists.linux.dev>; Thu,  8 May 2025 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746706994; cv=fail; b=Ho5+8KDsrIERBKZj2gcVSpjKMnZez/aTnMKBHB86RS5EEg/vK48JoW0PXRWRjDBAhHYeXOYayD6HpRg/7WrVQqE1Zkac56sts+LJgRxbRUkilmEfw+6tHf8IDMCP1gT3XVVMTQwjoIrWHUR+vdP6L2MiRZbLoCL7h3SG40F4+e0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746706994; c=relaxed/simple;
	bh=WhFt6MJuDIGOgII0ZeVuSoIF9Ax3V3nVY/CTi0LLJpw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pTX2t7uprI8ZGqnaGF77d+Jlbhmxnc0Ka+B+F27Dx7QKqnHp70Qc8/EdLVp5QNAG9AMbS9D4GPU7+8dHsbPmWKwuTvEg4enx7Q6RnB9nfGNx4XgMHWB/B0ptAMg6c+b9R4OKVh6DoTOh23WX4LEqvCL3Gi/oKkvJSozdoMAxQzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gdN/c9JO; arc=fail smtp.client-ip=40.107.101.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gdN/c9JO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7N1/gVjA/xMeFlRFSWN8R1oeT6Gif0Pf6gw0WNtWjHvhdKaDF4RgEZ/WeIZIHYVPLTiq6zsstbj+ydg2UPthCxcltCXwyQQeK5rLZrFhc3I8BnmxIgiEZcw+GRfNweKUVYQigu8e+jKvpvH/vne9Xc7naD2pvW334k2Cu/VuxkV1qgkK9A43kMU0wTLwGHtbzWFMXhTxNtyKNN/XQ9KqCUgkofwLgLTZpMmD77ztf/k32bSKk+w1dnbesc7da1vKeoQ48rI3gPfmqE4jP+0xitoNR0WzYUUJCvJnxUlGzKpxSEJrNIJxrxS4xJ7qo1bESdyfJa/bG7HFtsNJoTChg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiWRbu463iSEp3ZI1tXXHj2YbEZK2U1EYPZoq7nJusg=;
 b=UO7TY0OC5UZVi7UR/oMBX4DkZPZM6If2xymslusttr9ZL8LlAahl3aOOY0e7GAN9v8Bk7FXjA80L5VI4dfzTIEJVJn0M6YtDS5xHJ2Axmty9oABwn/2xOFd+lePvM/mY2vT6db+Y/L8YcN8mW1xHRLjDFm3SmzqteR7Ny5etARyDLQEx3lx0uZfH8onKnvcAASDGIBY6eSKuYVoRK9TOxeODsFVwatbgI5U2QA/wmX2eFWSC74/738BXlJxG4XCBMb1fPRqXOEqd2yxRmJE5cAQFucRpdXZPYqkHFEoAh9RTfgekA/NScdkaPWjTjDP/95TSj+6JC9yib5wCTuRWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiWRbu463iSEp3ZI1tXXHj2YbEZK2U1EYPZoq7nJusg=;
 b=gdN/c9JOQ1OhHwqPf4TNCGORib6NgVEib6u6uOybkbVoUCajlv8RtISjfuxN0lKwsrJTyp2/guoDenYDiUmDqPrc+jfC1YQ/93FxHhrsvU4RFFdV/DGJZ+KEmAsasoYVVSU0eSdJp8cPPPlbqCpyJOxcMuzDBLLicDXlpDLyutGVQ0T2vNHzdjYkYKVzf1ShLsS7RTf1kBKgI+qJfOaon7Bac0eSkzjXm0w5nHb/rpWnfi58nR2friOkZw+BZYU7kgpWwozF6W09Q/dYVefjWzNbolxyixxm48m3m3v1olZ0cBBK5Q8JOE9uXLv43Z9v4ZgI4zRxUrvAOQs8KDXy9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by LV8PR12MB9359.namprd12.prod.outlook.com (2603:10b6:408:1fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Thu, 8 May
 2025 12:23:01 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 12:23:01 +0000
Message-ID: <110497da-a81c-44dd-913b-1ab7f1f2aa07@nvidia.com>
Date: Thu, 8 May 2025 13:22:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250507183759.048732653@linuxfoundation.org>
 <843c2ffe-6653-4975-a818-03d4bb9e5be6@nvidia.com>
 <2025050855-lustrous-perch-ad8d@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2025050855-lustrous-perch-ad8d@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::7) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|LV8PR12MB9359:EE_
X-MS-Office365-Filtering-Correlation-Id: eee99db3-d074-4830-a345-08dd8e2b1345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUpZTkYzMEZkRllNTzNqU09HSzFQMVNQdndoSzNnQXluTTZvaTVOUWNiM0li?=
 =?utf-8?B?bHh4ZXUwVnc1TnVONHE5SGNVQkI1L3lpTU1kY2ZqQnI2K0UxOHdEYlZ3TWdy?=
 =?utf-8?B?clptL05hQ1JLVmY5Y3ZZVnh6QjVvS3ZlSitWMzRrWUNFbVhHTm8xcHpXOVkx?=
 =?utf-8?B?amFWM1JiVUlFUnlNaWozZ29peFNtSXdhR2M3RjhONjdtNmFSakFOc1dFbmhi?=
 =?utf-8?B?OUQ3M0J4NmJkN2dLa01aWlJsQ3JXNE16d0Ywelh5c21xY0RsVWpOemhoQnFB?=
 =?utf-8?B?dWRCMysvZ2RnamZvN2UyQk5MWUE5ZEhxVURiaW5Xd3EyQy8xY2pzR092c0hR?=
 =?utf-8?B?Y3pOS0tFdFBBOEUramtoait3SmlUVStseXJ0RFl0cHBoamZPL3EvK1RFY3VY?=
 =?utf-8?B?b3BJNCtaNFMvaHpnZFM3TUQwei9BLzlOT0NjUWxLdVU2ZE9YcXd3SlZpNXhV?=
 =?utf-8?B?TTEwSUIrNGlxS25XNGxvcVh1WEZpeXhscTBNQVdDbVA3V3YyU3NvaEU2cVV6?=
 =?utf-8?B?cDJUVkdLNmthZC9aMU1GWWhhY2Z0OXhaOVZFY2FsWnhGakE0a2JZd21xTEht?=
 =?utf-8?B?V3N1b2p6Ukg4L1MzV1llVjlsdFRCNmZCb0ZOcVJyOVlXRGdCU3E4dG1nbFVE?=
 =?utf-8?B?NUpRdVYxckwrbEkxMmRuay8xRllCVUQ4dFo2WUQvSWFWZFJINkY0N0dld3Jy?=
 =?utf-8?B?aTZVYWlYdVJVcVpOMzVscHBwbHlFS2JFL0FmejBPNHUyd1crQnBwNnIySnBo?=
 =?utf-8?B?NVpDQ0RLR3BNQnFsVnJCTnJrclhxMC9wVjRGbjBWeW52SUdUUkJPRGNJYzRI?=
 =?utf-8?B?NDU3VFgyZnlSaVd1SEJWOGtvazVmd1NNc0tJL3hwV05GK2x6dlZQcy9ldWNR?=
 =?utf-8?B?L0hMMU1vSy9FclA5a1lUQ2NlMHVKTU91Y05oUjc2VXViSW1BNit6YXc1R2VT?=
 =?utf-8?B?M3hibW1vSHFqZEN5ZDJYMWlQVVp4dzUxZGZ5ME5aSU5yaElrcTVCNm4xc2sr?=
 =?utf-8?B?bm5CM25XSlFrNlZ5Y1dEUmFGM2dqakNDcjB1RkhZN0prTENtSjFpTzIzdjJO?=
 =?utf-8?B?Y1NDQ1I5YUpWaEJFS3VmSTVjS2dEZXVXVlVXQWxHUGVCV0M0eE8xUWcvUmpi?=
 =?utf-8?B?VGZLQ21HcEx5WS9HOXR0Q2pHYkFwK1FQUDhrWG5QWXMvNTd0VDVSTWkzUzNp?=
 =?utf-8?B?ajM1UkQvVHRTTXp6bkhKdHhoRk9mN05HQWhIZzJ5Y3lXbUJ4bDE2eVIzUmxm?=
 =?utf-8?B?ZW4yZU42QzZMV3VJQzJadms0a2tZaWlxc1dmekFFSUhsOE9TSTVubVA1Tm1X?=
 =?utf-8?B?eVR0OHhMTy9IalZoOXlwYnRwdW1UckNlMGRWYmg4ckcyUm9rTlAyWUt6Mng4?=
 =?utf-8?B?SUVGRTRYMmZlVHhXdk10Z0VtNitQWnFUSzA5QXhYclJzVWF1eGV1ZEhNYVEx?=
 =?utf-8?B?eW9PL2k5OURaWFFGV01DY3lUL2p5SnFkSExsdExGbU9USDEveXB3Zm9UVFMv?=
 =?utf-8?B?QmsrQnV4dkhTNlk3MmQwL2FqZThFbC9ObUFkRzFHK2VmMGJJdFlRREQvWjVM?=
 =?utf-8?B?amJXZzc2UVN5S3NING9zMzNGUm1ZcytYOHVaMzB0TkNib1ZqK291L3F1cnNH?=
 =?utf-8?B?eXk5RjZvYndvTks5aXJESXNmM2p0SHNydGpDZDZydjNBeTRqbERGSjJEdzJS?=
 =?utf-8?B?cytIRmFtbklsWGpLbm9kV3JoYlhmM0pDQ2g5dVlTaUZVdTB2bzJGTGJRcFcw?=
 =?utf-8?B?bXRNTlRZQk1iUW15cWFvUHlCQjA3dk9LaFVURHlzUmh1cEduQWxBU1VRNFdC?=
 =?utf-8?B?UUh0VTl1L2ZCM1hDNjZsNGxoV1ZMUWZHYVJERTNxd2FtYnJtY0FIZVplSkxQ?=
 =?utf-8?B?TWFQUm1lb0p3eVZMSmVER1FoOVVvMUZMQlhrQlU1VzFPZ2YvQTY5ZDU5Q2lR?=
 =?utf-8?Q?RuWepmP0j/Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3MzbEZLeDJuVG9GYzk3UW50ZnJTcGtaeUxrdWVoS1NpNFM0QnNQZTQ4ZDlM?=
 =?utf-8?B?UWM4MXV0cjg1ckM0U24xWXV5Z2kyZFJIN0hTZDRGRk9jVzdnVmtGOTZIT2RE?=
 =?utf-8?B?bEpRaVNiK0NqbkxGTGhzS1p0dnhydG0xQlM3SUt3OWp3QVNhZEVIdi91cjRt?=
 =?utf-8?B?SHlLVWNrVHluMlFHU2NBSk9wM3JrWmJSL3EyODAvaUp0bForRk1lSlhVckto?=
 =?utf-8?B?ZEQ4THRtYllhMUFxY1ZJdFF2NXFjUitVNzNLQWlIT2dGby8yZU9vb3BoNU1n?=
 =?utf-8?B?cFd4MnpXalBZa281UVhxWFQ1WjlEbkFaaHFaM1NiMGpEc3F5eTJSZ0NmbW9x?=
 =?utf-8?B?ZzFsNFpSdUJpTmMyZ1piQnlkeTJIL0ZQa2M3ZEJkUUh0djBBU2l3ckp5Ky9P?=
 =?utf-8?B?dUU4VWpJZWFWMXlkazlHcXVlakl3TnpWYUEzUEFHOTd3S25LSzU1Mk9xS0lx?=
 =?utf-8?B?eWdYVjVxc0IyRFBQNnpUVlBvQnV3MTJoMndWd0puSkRqTkhWeHdOSEZnMGdw?=
 =?utf-8?B?K3VFckd4NjE0ZmpqRnAxTnI1K2h4MkhwN3c2QXlkZU45MTZVOENFOVVLdHZH?=
 =?utf-8?B?b3d0bW1yTUdheUI4QnZtc2lMeG5COW9aRG83T1lqRzlMZ1ZIdkV2RS9nL0Jl?=
 =?utf-8?B?MXUrb3NNTXhabUtqWVBvajlkOGtjS0tvdDdaempRZ3VCeXZwbzljaVRnK3NG?=
 =?utf-8?B?S2tUNWh3SDNOU05mdEVjcGRTTk5MYUxiKzZIQmFLMUE3aXJsUy9OUjlpL1Yw?=
 =?utf-8?B?YjB0QXFEYkdaSFVlSGsrUWxSSjJodURET1ZFdkdwNWlZb3VCcFVGSFNTSDQ3?=
 =?utf-8?B?NDRrbUNKR0Rkbzkza2R5YVZHNzlZc09vSnJuYm9KU1ZiWTh1ZFNJTTJvS3ow?=
 =?utf-8?B?U2JkMW9oOWo4NmxjZlVPMWdiaDJscGV1dnZ1RXIzUVVOczFzZEpKWWQ5bWFU?=
 =?utf-8?B?bkFMRXJLU3NGa0dOeFprVUx3aUlLL3ZnSXpBMmY4NWJNcWpGUW9tak9FR1NR?=
 =?utf-8?B?bC9xNzVzRnAxTWN3ajBpdllBMkpycklQZ0FJUG5ENGlrSjdyVVRWandTOUNR?=
 =?utf-8?B?Y0JKZUpFV1FrOEVJekYwR3hKa0dLOHQ4SmhBTEwwaERZNGdyQWxkSTZzM0lF?=
 =?utf-8?B?K1FtdERzc1Q2SnMxZFU0TGJ4a1ZWTklCNnVmTjZDdmtxL2lyMktJMWlTUnNh?=
 =?utf-8?B?MWJ4NzgyQzNObE5JU3d3Y1JmMUduVXlYTitiNy9HL1VRU1NRQWt6N24rQ0ZG?=
 =?utf-8?B?Z0VDWlh3bVZsajJtOVAyZ1d5Ykl3dlM0WnZvaTU2QW5ueW5adGxuS1hibCty?=
 =?utf-8?B?V3JCWGNWNUpTckVOeXdYY1pqbU90RDRhd0Z1cFZvZFNnV1ozTUNQMXpGeHlq?=
 =?utf-8?B?bEZSMDVabWtzSW5EQnhmRisvUWhpUkZUT0daOGFNOVR2eDhscU0xUGZxVmhV?=
 =?utf-8?B?N0dhUmVuQWRwd21MNEdVRkxXQWEwZUkwR0IzQitmT1RIN1lmVnZWdEFJNGpL?=
 =?utf-8?B?VmhERW5USm5nNjMreGtJKzRCamhGWmFBM1RBTGFBQkxtUmZFRWlsbmtDTmt2?=
 =?utf-8?B?YkR4Rm83VGQxcm9ya2JhSUZ5bGxSeG9GTmpIcEg1MkxOYzRnRWFHUEs0RjBt?=
 =?utf-8?B?UCs0aWdielZUUHpMc1lPK2NHQ0xzdEYrM1FkcC9wVkZ2TElNaHJjR3h4L3g1?=
 =?utf-8?B?Yy9Yait0K0VOMUZiZTNrWUVTNDRubExCdEdwSzc1VDByN3Y1MTdReVRwaXhQ?=
 =?utf-8?B?cXJ0TTQ5a25NRzNVdVViaTFYd3Qrd3VnTHVhcW1nc2VnRGUrZUdGeHN2cnYr?=
 =?utf-8?B?bDJ6bjZodmNXRE9ndUE4T1ZIZHVoOG1JZkZGalI3T2k4VWNVZGoxYnhTWXZa?=
 =?utf-8?B?RkN4ektUcGZ5YUlWaUtzaXhhcmwycHF6Z2JqM1N6M3hOa0dvay9MTWx2Z05J?=
 =?utf-8?B?bVBVQUZlYzJIbEFnb2Nrd01waHRjMy9Jd1VIUDJFbzgxc05vdzJBOTRrYUdL?=
 =?utf-8?B?eHcxa3VPa2lUNUJGRE9YWmVSWTdqZHhpa0tTNGVPaXZmNUdBcmpVd1NQZWVI?=
 =?utf-8?B?RlZaTzg3d3V3L2M4N0RDZXRvM1c0dzlpMHRkQUxVd2ViQld2dC9NRjllNFpm?=
 =?utf-8?B?Z05SUW1wbEZVcFZ6TnVwUEhObndQZmpPTitWVUgwM1cxRWtJTGpmU1krVEdK?=
 =?utf-8?B?YlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee99db3-d074-4830-a345-08dd8e2b1345
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 12:23:01.5758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgdChJEgZF77r6X5WBv/w6FsZPXNK0mW6Wx2BjbIgvbXJU0AaGk7TiK/dEu1oUMYPhN8mjFY3luvuit346nkZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9359


On 08/05/2025 12:23, Greg Kroah-Hartman wrote:
> On Thu, May 08, 2025 at 10:44:45AM +0100, Jon Hunter wrote:
>> Hi Greg,
>>
>> On 07/05/2025 19:39, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.182 release.
>>> There are 55 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc1.gz
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
>>> Stephan Gerhold <stephan.gerhold@linaro.org>
>>>       serial: msm: Configure correct working mode before starting earlycon
>>
>> The above commit is breaking the build for ARM64 and I am seeing
>> the following build error ...
>>
>> drivers/tty/serial/msm_serial.c: In function ‘msm_serial_early_console_setup_dm’:
>> drivers/tty/serial/msm_serial.c:1737:34: error: ‘MSM_UART_CR_CMD_RESET_RX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_RX’?
>>   1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
>>        |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
>>        |                                  UART_CR_CMD_RESET_RX
>> drivers/tty/serial/msm_serial.c:1737:34: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/tty/serial/msm_serial.c:1737:60: error: ‘MSM_UART_CR’ undeclared (first use in this function); did you mean ‘UART_CR’?
>>   1737 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_RX, MSM_UART_CR);
>>        |                                                            ^~~~~~~~~~~
>>        |                                                            UART_CR
>> drivers/tty/serial/msm_serial.c:1738:34: error: ‘MSM_UART_CR_CMD_RESET_TX’ undeclared (first use in this function); did you mean ‘UART_CR_CMD_RESET_TX’?
>>   1738 |         msm_write(&device->port, MSM_UART_CR_CMD_RESET_TX, MSM_UART_CR);
>>        |                                  ^~~~~~~~~~~~~~~~~~~~~~~~
>>        |                                  UART_CR_CMD_RESET_TX
>>    CC      drivers/ata/libata-transport.o
>> drivers/tty/serial/msm_serial.c:1739:34: error: ‘MSM_UART_CR_TX_ENABLE’ undeclared (first use in this function); did you mean ‘UART_CR_TX_ENABLE’?
>>   1739 |         msm_write(&device->port, MSM_UART_CR_TX_ENABLE, MSM_UART_CR);
>>        |                                  ^~~~~~~~~~~~~~~~~~~~~
>>        |                                  UART_CR_TX_ENABLE
>>
>>
>> After reverting this, the build is passing again.
> 
> Thanks, commit is now dropped.  Odd it didn't show up on my arm64
> allmodconfig builds :(

I saw this just building the stock ARM64 defconfig.

Jon

-- 
nvpublic

