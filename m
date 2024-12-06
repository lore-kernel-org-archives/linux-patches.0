Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405901DF99A
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733481578; cv=fail; b=abqccD1JMesq3/cwiZvcmsQ1N1/xjd5Vz8nHE7gyW22794sehrNOhLEwQl8APssulWHf5aBlrNaw09INAHLRHYXu+kqYyr5h9KiM4od757vw/CLZCAWX5YbOI1QoyM0Ukud8iZD4wiIhkM29q0wtcI3hEyPEypBj8We9epiNfIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733481578; c=relaxed/simple;
	bh=6bYKmxCNrec+gE5VZMODIlJopxBIIJ4bECyJw0acyII=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pa38Osuj4cQbtiC/ZxkRKdUrOrUpkohRMWzRjJdQ8Ft0s1celub9oAPShU8Kwx2LrZAIRiQOyp77RcvpN5egsetOPuex3QCydGQDWXjtQTiP+3y9tANTPKNBhBV4IshHN+j8HiwFPDZ3BwfIHb/y76MOIu7nV+/l9kyR+3p0viI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhHLp0No; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhHLp0No"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzUPiiR6+FeqCQuMoYLOq2G8ZNLyzXiNiz23/GoNQRWyrYt+umyT0jBUXZjsSHoMaV6wwHx1WRtljdmYMnr5QINnts3kvOc4sSnuAyyoyv+vFnN4f3ftufV4QMnZFC5F1P0PvqwXA1XGdNCbzUiWu90mPsJomX0dpRjedjxIanRc26VFFnMi7vZcuaNl0qXEBmsD0Xxh3v11aQeMqrNqx/raKu87pfHTZmd7eCEc66bTB7PG1Rn6SN12eQkokeuov9gVGy4BpYjQA9ilvHcVZ83m2QDN3q8cDRxqJkgwRytnWG7Je46GAKR+bT86++R1TbevlN0SG52unxgaWSq1kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RniU4QHFrLTAcRKqRRPuchVJ10S4tA1QMksiyun1ZMI=;
 b=F3jGdZiDjlc9cDrRhK0453aKgQaRCapQYcQBP0bDZUu9YknxuxFIXHPtgMcrI23RVWEviE3vlfu1EvDULGic/cF2CMBYDogCO+n8z0fLdRP79k5/A9slUK1fxphpuMQ0nIscPf9ohF2HUqxwYegIF+i7i+v/Gw0U/7l1R8S3bzgefmhVcab3FBxrJoJPgqKkOOek+byXrPOUuA58AOnxLa4DtL9XczjR7nqHTGjWvZxUGPJh5fWIgIhI43jEkN9wxt+MX2obzFkkTIh3kc20yTCAR3x96iFwWMDhB30sZK3rXvII1RDdzbB0rB8vMepO5TRsh7/2WA2oldn7TEHYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RniU4QHFrLTAcRKqRRPuchVJ10S4tA1QMksiyun1ZMI=;
 b=rhHLp0NoCJtfknnacR2z9iB9XkRnEqBXz3f63GFfUbJ6vON9lALNcJ6foUY+DrhvjTkYF1VnqjSfYEzQCAxpupKCNJfW5oD1lq+DimzphjBYm/VuctZjdqC3k58mdrqAgOrdkundSvYAEeJikTSAtVnOd9kRNwUrZmbpEVDXhT+Mp5bfed0fK6gPIcW/fDDZbRydOj/yneYsOWrIMKEblQyZD/tWO3ycYJyzcJIbFcvzeYfHr7s2hoFTVneryN1JjqaDS9FcQk95fuNa47q6Z7XYwZ+PiLygImRelnQ63KSM+OmxVqxnpJaMMCr6shCObBK+68/adhuQpOtpb3B+7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Fri, 6 Dec
 2024 10:39:31 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%2]) with mapi id 15.20.8207.017; Fri, 6 Dec 2024
 10:39:31 +0000
Message-ID: <b4807a3c-dd53-48d6-a923-d2ce4cecccf5@nvidia.com>
Date: Fri, 6 Dec 2024 10:39:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241203141923.524658091@linuxfoundation.org>
 <71fc98de-2f61-4530-8c03-dcd7fa3bf470@rnnvmail204.nvidia.com>
 <5a174c4b-fa2b-4180-af6b-ae50d76fef4d@nvidia.com>
 <2024120623-chloride-harvest-91fe@gregkh>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2024120623-chloride-harvest-91fe@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0664.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::8) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: d051b376-a94a-4322-b678-08dd15e2449e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTJSYmFxeGphM1dHTFFvOHFWeHZITUQ1UkR1Uk1sbEdxTG9WeGk4SFZpZ1pr?=
 =?utf-8?B?enE1SHpwdERrRjdIWlhVRmZ0UHlhc0dKMTZubUcrN3VkNGJnUmZWY0RNQjRn?=
 =?utf-8?B?djkzc2MyU011dGsxWmNkY0pDeHlSMmp3Q0gyVktBdEp3S1E1NEhqVHhQbkhU?=
 =?utf-8?B?OE5ZKzgrSzdCZjZqNms4NmUxQ21zc3hZcDdaQ2lDdDB4ZGJaZU51cnVZUkNP?=
 =?utf-8?B?OEFwVjgwRmZVa0VkVGFnSjRqQlJUOW1JNnV3d0VnbllsL1lqdzVWQW9aV0do?=
 =?utf-8?B?ZmxDb2Z4b3VxZ011WUl2c3k5aDFUbVpWbW5XcjZDKy9YSVNVVmgwRnZDOWp0?=
 =?utf-8?B?OTNrVTM0T1RZRjlXN1RNa0UvQTBydHM3SDRsaFJGbjM3ME9HaVdEcWpDQ2xw?=
 =?utf-8?B?WjNjNnFMQ3R3ejFrYTU4eWdCSnlmR1pORlBSdStZL21pODE1ZlJMRkwxRDNH?=
 =?utf-8?B?RVdBdkhDbGhDZ3VOYzM2aEN3OThoMVdiMURycHhJNXNoRDNBdkJXWUp0eFpT?=
 =?utf-8?B?bzR2eVZYVW42R3VhRU9MMWVGNHJGQzMyTzcvUjVwcXltVjR6bmFXQktXMWl1?=
 =?utf-8?B?dVZSYmVUdzNOVENUMm5uRVhNdFc5S0hTZlB5Y0JBWUdQWVpMWnRDczdkSzdV?=
 =?utf-8?B?a2hmR2hRaGV2WEtCLzI2OWZTaFFyMm9idkNyOUsweDAyYStMM2tURjVCc3Rv?=
 =?utf-8?B?RnpTenlaakN2WTh5RER6S2RBK29DVjlRbWRhM1UyTVhOWHZDMkRjU0lpTlda?=
 =?utf-8?B?dlQxWG5XaTRUek42WDB6RHdnQUFBRld1b2dydjZyTkJGbFpPeDlxZXlDS3Vj?=
 =?utf-8?B?VGgrNEl2dXhYd2RHQ1Y2azA4cGxaZFhWbkVXVnN1M1U3UkpSZkJRM0RZK0Za?=
 =?utf-8?B?eTZYSnFSZnNMRjJmUDVPdTVyOEpMOHJRQkFTWGM4MFJBYjREcXhLZzVFNWhT?=
 =?utf-8?B?Qk90dVpObjI4aVdULzdDQVY4SzVuOFhTeXEzS1VaNzgzWkYrQlpRZFV0RzF3?=
 =?utf-8?B?MEdlbWVrZTZUY1pvL29BbVFHT21BZW91YTYzWkNmN2VteXk2NURqai9zempx?=
 =?utf-8?B?VEJlYmdlS0NrNmRhWnNQaUl6SnRrZ2tnVjUva0pHS3gzeEJFalVueldiQVZI?=
 =?utf-8?B?YTlFZ3A1cnBwYzdOdU12VE56alZiNlRzc2xyTHN6T0tTL1FMeEEwOEpnN1FX?=
 =?utf-8?B?MUJLOXFhZDJRYnJTRTZIRmpCNWVPaGJGeUN4cEFGSlgyTHREbk1WUlpCNkJX?=
 =?utf-8?B?TjBZTThHZFdQdVc2YUJWMW54cVpBeThQa1JIbEt0VjNURW41eVlNMGhvcCtw?=
 =?utf-8?B?ZStQOUVWUUJjalMwM09PZW4vNlprSXRHeCtnbkpvRFZGbFZZblpQOWQ3ejRR?=
 =?utf-8?B?Q1NCMzBhNUgwMThGVlBhdGxZSGUvZFpqV254MXl3Z2hZa3REaEF3V2J2clJM?=
 =?utf-8?B?V2JEVXlhWkRyUFpjVUkxU0xUNTVIM0tiR1I0YmVES3JiVHNHN1NFb3RsN1p2?=
 =?utf-8?B?Qk4wTFVBalRibmwzVnJ3MitOM2dmQzRtaGR4RzV0cmg0a0xpdTFQd3NhM29v?=
 =?utf-8?B?R1duUm1tcEdXK20yeGZkeGFUNHBjMXd1SVIvSTd1ZnNUekJ1cGhjRlEweFlQ?=
 =?utf-8?B?NEJ3alpnVnpjTzFTQm5NbWY4MkJPL25ncVlTVmxmb0VQRVliZFpQNzROSXhT?=
 =?utf-8?B?U1pWZXhKUURqYkcyNytTbndPMlc0K0xQS3BJZU40TE5VaTcwSytvb1NWbFYw?=
 =?utf-8?B?Sk94RWxnTFRMWnBqRnhyb25jbUNCY0VSVkpQc3NFVHlRdlNDWHlHVEZLME1m?=
 =?utf-8?Q?qd+6mksYGt+eKDrJ5Gs5HXmjz75TV0IPoOS64=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnF2VnpNaTExQVZ0RGVCVG9EU1cxYTl1OHBrV0VKUStCd3QxbGF6blBndWl1?=
 =?utf-8?B?MnluSVRaTTFrTnNUTkd4Q05oZkpMRjVxYWxVdFpvV0JkVDhlTlFmS1BKZVND?=
 =?utf-8?B?cXIrTzVhcXFnNTVLdVpSbTlUS09TcldZNHJqQmlVc25qTVAyYVZla0J5dk9C?=
 =?utf-8?B?UlVpNHRpOVFsV2VkSXU1VXhzM2h4alkxY1RDSG82WkgxeExZQjlUWlVKUHB3?=
 =?utf-8?B?cGk3TWpmMEdXSisvRmVqbzdZeG1scTFiRTZFUzFsM1dzOHRBV3VUakFMRnJG?=
 =?utf-8?B?NUhIbDlhdDZ3OGxjdXFzUmVUK3ljTy84c3BOOVZqR0IwZnZScFlMWElmR3pN?=
 =?utf-8?B?ZGRKVm4rUmVYSFVoWWl4UmhSemtyYzVFc3psV0hoS2N3MU9ZaWJrcmI0VGhu?=
 =?utf-8?B?M1V2cFZodk5PM2Nvc1UwRXNEMlpwcU93ZDRCNzh5Nksya21UNmdLWUIyamlN?=
 =?utf-8?B?UEhtM1RnOVAybjRpQ2d4Z1lnTm1ubFIvaUNzUjVjVXJUZXNFVHI2TVdtWmtu?=
 =?utf-8?B?MmIxOEpnVnBwZGZyMlh6RkdtWjZ1OGZDY1B1NDNtY1A0NHhWSktoR25xOFVJ?=
 =?utf-8?B?TDkrZ1hHVUlzRnJXOXpoeDJGbzZDeE1NUWh0WDJTUTF6K000RWhuL3d1U0ls?=
 =?utf-8?B?NWlsSGgwWmxuUDJIRHYxZm9mUkhtQklZUmFia0lGdDZqZDBjRWZNeFV4YmFO?=
 =?utf-8?B?SE8zV090ZUZQajlLWk1iZDVSc1NxWTc1dGoyQitsbXZ2TFZhdzJEMHNzcmh2?=
 =?utf-8?B?QUF1Z3J3M3Y1Nytia05lODhZNmxLbmhYOFJ1YXNNSVRFM2tGcm9hY1B4azRW?=
 =?utf-8?B?K09CREdydExUbUZNY3lqcS9lVHNKUFp0M0lOMHpFQXVneHFzbG5DZXp5eUV6?=
 =?utf-8?B?akdBVUpySE95cWZZN2d1aFNYdUlLV2k4ei9WZm51Y3J0MHJUMXpQSDQzNVd1?=
 =?utf-8?B?VldxdU80Zm9mWmVsNUVpdlhmekZjY1lJdFRTcWFJRmVEQ0Vpb29GL0dGcWEw?=
 =?utf-8?B?YndqUm1ubG16aHY2b2tXRkN2VVd3SDNRVGUvVDdPOXo2Wm1FdjlQZ1NXOHVv?=
 =?utf-8?B?ZTNIOEM2RzdpU0dGc3NQaVl6ZUFyMzlDb202NmQ4aCtIeUJGbGVyMDdhN2ln?=
 =?utf-8?B?TkxxWjFPaHUvM1ZOMnoraXkzZWV0d1RjVUltQmpLMHk0TklNWlpVZ2hzZk9V?=
 =?utf-8?B?cnAvemZXeDUzYmxRVXJMeURoL0EzVWEzd0cxVnoxV0duNDV2dXpKTjROa1VC?=
 =?utf-8?B?a0pyWkl0QVhSR1VkWC9QQ3lmdHBqcXBxWWFLQWZnSkpHSzdUY3I3cDU2SlAr?=
 =?utf-8?B?V3dFVTBRQ2UvcGRGWUwvTHc4TjBFN2JhT1VuUDhNZXlreWh6V0Zid09OSU5o?=
 =?utf-8?B?d3Y4T1M0c1FrMm0yZkNZdFZhZFdLY05LRDZKQ0JSYksvcll0U1pxQkNxb0Zy?=
 =?utf-8?B?R3IrRmQxQUdiOWZhdWJuVWlnT2dUVlQ1SkMvUlRYODg4dm1oMVc5cWlnMGk5?=
 =?utf-8?B?NW4wTDQzS3BZeHNTU3RSaDY5L3BhNTZwMFoveUd4ZS94QjBMNFg2NVE3VkVj?=
 =?utf-8?B?MWJwK2p2c0M2eHpmMGVsM0xtV1ZtNGdiZmc4SWxMb1F3UGpNWUxoR0RwdG9W?=
 =?utf-8?B?WWk5anZKM21hM0VJcC9udjJhNTQzU1REbjlubGFyUGtWek9mMHNHVXNlSGUz?=
 =?utf-8?B?V0xhS1ZMT1FOZHJNbmhaRWZ4alBoTXlGODJ0Z0NvZWloTDNvWkFuNkY1QWhS?=
 =?utf-8?B?c01MeGZ4N2tyTDFrd01PUDdHY2ZUUVVkTlduMk0zYVRNVE40N3J2MFZ5UlA2?=
 =?utf-8?B?YWVJKzF3S09tNUtscVN2THhzSjV1eU0yRXVXdW1zYzIzS21NazJvOVFuZGhu?=
 =?utf-8?B?N215MUFPTVg4dHFtQWJkK05kWHBhN2dDQkl4a3QyeFU2VE50dng0VTRzV3lz?=
 =?utf-8?B?VVhyQWQ3YVZCQzdUazkwdy96ZWc0Yk9vMUxxeE8ra0tiUUFGNGJJY2tzOFpO?=
 =?utf-8?B?SDMvc0k3alhvM2M4K0VvaDIzV2RLcDNnNkE3T1daTDZydlpML3hxd2NOS0Na?=
 =?utf-8?B?ZlV5eitGMk8yOGtQZHJ3RVJ1QTA5STlIbFJSY3FuUisvV3hJYlBoZkhvbXhF?=
 =?utf-8?B?VWN1RENUVUtrSGRPamc1Z3JRZjJiTnllVnA3THowcWpmTk85WEFSRzZUK2d4?=
 =?utf-8?B?Z0VIZlVKV3VRVzlGYU1ZZmE1QTg3dkt0TXdIVFo0bFM1NG0zM1EveUluWUtH?=
 =?utf-8?B?RmZhRWliOUVubjJYRHdVdDNKQjNnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d051b376-a94a-4322-b678-08dd15e2449e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 10:39:31.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgFTXjuQVUe+RSTk8ezc656X/LdanGwkeTBw4jh8oKtVh59GGw9MCSFjliMm0Ix9Y0jewLBEMKSIXwvl8jSPjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793


On 06/12/2024 06:07, Greg Kroah-Hartman wrote:
> On Thu, Dec 05, 2024 at 02:40:28PM +0000, Jon Hunter wrote:
>>
>> On 05/12/2024 14:38, Jon Hunter wrote:
>>> On Tue, 03 Dec 2024 15:30:29 +0100, Greg Kroah-Hartman wrote:
>>>> ------------------
>>>> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
>>>> is end-of-life.  It's been 6 years, everyone should have moved off of it
>>>> by now.
>>>> ------------------
>>>>
>>>> This is the start of the stable review cycle for the 4.19.325 release.
>>>> There are 138 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
>>>> or in the git tree and branch at:
>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Failures detected for Tegra ...
>>>
>>> Test results for stable-v4.19:
>>>       10 builds:	6 pass, 4 fail
>>>       12 boots:	12 pass, 0 fail
>>>       21 tests:	21 pass, 0 fail
>>>
>>> Linux version:	4.19.325-rc1-g1efbea5bef00
>>> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>>                   tegra194-p2972-0000, tegra20-ventana,
>>>                   tegra210-p2371-2180, tegra30-cardhu-a04
>>>
>>> Builds failed:	aarch64+defconfig+jetson, arm+multi_v7
>>
>>
>> This is the same build failure as reported here:
>>
>> https://lore.kernel.org/stable/Z09KXnGlTJZBpA90@duo.ucw.cz/
> 
> Great, hopefully I fixed that up in the real release :)
> 
> thanks for testing this kernel all these years!


Yes all looking good now! Thanks for maintaining it, I am sure we are 
both happy to have one less kernel!

Jon

-- 
nvpublic

