Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA936EB7C
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542603; cv=fail; b=evB/x1k/sVZFJoNk7NLsPYPMkB4PZWJAbJS9CUX2S5NdYSq24VBY+yTN2oPFFSLPuxcagMhN/UEeuBuZMUFnYwoJHm+wiaGicTgbRC4acEsbMNvckgIwBc6qfv7z4DBFXln1GZfapH1jBqv+DC6vXfyPv/vsyGj3dUpB5FaiBTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542603; c=relaxed/simple;
	bh=3/XaHOjcCbR70MxOTfESV4KDm9ImgJEE5Khxhl1f2gA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PYtH+eVZZRPzlYVuEh8q7jfvw1vQmQTuaedstw3B/SqJrd5/e06AQHaymwqQJEMW3WjGN6ONLurK3nMaGTr3EfS9DoOVSOgDP1Lx2EuG5lN7J0HWXZMfsah0D6WitI3iYvUu77ke+QClgmeOaZXw3nEaYJmjckNw2ICnXIomDXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WbJLIm78; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WbJLIm78"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BhYLCtlHuCjl2xeW3r8HNOBs4DWG3IA2REwixOvN1lHyMiYsOYG7fJEfeEtiWBxkKGIn+hehaRHNZno6w8wDm/ZsUF4ljDrluDq+XXEyo66F5dYCD3e5BvXlDP1lqx1GR6GneCx+sSogVE5sSS69dLiNQNEAN7y+xTlfmJVyJJVtIvA367D2s9vFD7NflwgnUlrrX1fvdH8luByiyHnPcQzORk2ZDNu+ZVLuNioQesdDHMTMGRnR6/gP5EBDHAmGGK1SeeWsoxVxbbwxmNEIrXRdIC597ZqzF1DJe7NQ7+1/CS2zEL/SxamyyMFL0gXwUfYPvTDfASQ9DK2RJ69RYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IYsB0PoVpLImkjORKsrJavn0jeiB3VDf91C3IRtY/0=;
 b=iSvv1szYlqIRDPoeK17Gseo70EJzobN71XVVPgRiXwh7K2JRDgOK8iHEfjNgm1vCGb0HRJREriXzZyUtWxvZTE+MXA+CtCgilOBuoeDswV8HT+nnlR/x7zwYeFv1Ql5Y1593wJXHYDyvii5Sud1Z0cNPyg5l0tHkWreGlooE4RWat5auv2rFdPFhnl2P+UkdRGDS9A80rLXni9RR3oWxK4fqlpDYwnMkYARVBEsKzuNCdfvjoE4d8eC1SYNnhdA/dI0drTuTUGVzgX6PeCrx9D1JEqay//s/26YDM63A2h4djxQGI+o8fD7APHFo6q+34M1fZI2JfllWFVCvhF+DfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IYsB0PoVpLImkjORKsrJavn0jeiB3VDf91C3IRtY/0=;
 b=WbJLIm78ImXMGMiMTmCLefsJYSjgypaibZ7X8/Zj2Yma1c/44St++FJfdq7obys5gER04whrPZ2xnY8+9XL4eP5GCF4J38L+klEP4zagnyrMrr29/mMju+H97m/Cc0q9BE6ionOF6WM5ApaE29Hd5cdovDI5rRLKIWPhOHjxaN61axp+Jq1p7eEb0/q/AVEiq8uLXhXBcVHgEeZAIJaKfd8vDw6K0IWmk1V6VmUEzxbEV4Vc11pUUTlxJkELqKa512atskt2D9fudl7e/ntLDfZdIaDd7LbIRDPd9VIBx5aYvPp3CS6etgarN0qemW2USfZpq5ek4mbEHFbeWhfagA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 17:23:17 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%4]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 17:23:17 +0000
Message-ID: <20f8ae22-1503-4652-94c0-05f3e694a35a@nvidia.com>
Date: Wed, 18 Dec 2024 17:23:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20241217170533.329523616@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::20) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: 19f3697b-9678-4acf-d2cf-08dd1f88a94e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVRvc0k1Vm9ZWk4zNHkrUjJTSVRrMnVYdHdYNFd1MmNuOHRIdEJJZFBWbXR3?=
 =?utf-8?B?VzdaMXNxVmw5YlNlM2lFZzBoWHg1R2JCQmxOZXRkSVFTUHdiM1VWVVUvcWxC?=
 =?utf-8?B?QkdlM3ErZGN1NTVaOVVURVJkQjhyRW5vTkIzR1BqQlBvcW9TczNaZ0M1ZVRm?=
 =?utf-8?B?bEtRVU1sUXpTNnhRL0d2VDgrejJBZ0dsbEw2YUFic0g1USttQ0FDcklTSnRa?=
 =?utf-8?B?bC9PZEw1YXlYSWo3NHZXU2ZUVE42VjloNVF5bFhYVFhaUlpxRTZGWVdTSkZ4?=
 =?utf-8?B?Y1ZYREswOHZtQ3Npbm5BbDRkZEdRdDQ2ekFLRWpDSkJFeWVGcjRXeHNWVWti?=
 =?utf-8?B?UnQ2WWkrajAzNDRhWGpWeThwOWg0U1UyUERwck5TOC96UmZLa3FGbkZKTlI2?=
 =?utf-8?B?ZzBDMnpjSEx3TDNQb1FyaUpibDhWTDd0Wm4yN1FUNXYyYXgzTU5ENGl0K1lE?=
 =?utf-8?B?WUJsR3pScmNhQ1l0eGV5MS9YUjgzdS9YT0VhUTlKOEZTUHNhcm1heUJZZXFF?=
 =?utf-8?B?emJvQ2FDalpGT2R1WHNyT1pxTFVNZWNzdllVMW5vNno3d0pKTVhoK3RFaXhK?=
 =?utf-8?B?S050L3BsNi9FcjBlU1VkYWNSeXg4K285ZklMZU9kb05IM0FSdExuNU1Obkxm?=
 =?utf-8?B?MnpGZTg0ZGhxNFhrNFNDWTJXOGROT3YvVzBPcnloTS9QbmpuZDlaOFd6WjRy?=
 =?utf-8?B?aW5ieXBTSmplbGZqSGJhcTJYZTk5cnFZYkh1Yk0vYkZYQ05ZWE9nV1E3dytB?=
 =?utf-8?B?K3lFVUpVZkh5MWxMM1NWcDlPVE9vOGFWck0weExkNXRGMkwwU05HYUtxUDlE?=
 =?utf-8?B?VndqTU0xcHVmaGx2TGNnTzE0M0VwQm8vUThCOWpoTDdvL3pBdkphVHJ4Q1hi?=
 =?utf-8?B?OXJveHpQKytlckhQUGtpS3JiODQvdkF2ZWlXb1Y5V1JrbHFPWkVVcVJkVE0x?=
 =?utf-8?B?TWhjK2x3OUp3R2JuR1NrRWhDWXhKMTdFQVp6T3RINmg2UjR1VmlpbENRcFB2?=
 =?utf-8?B?dW15QU1EeXU1cGt0SFdGNnFJcEZiQTduS3FjSWVJN0VRdFdFRFMxbHI5UlpQ?=
 =?utf-8?B?bWk3WmF6Z01KbDN4S04wcVp6bVpSK1FBcDU3Mys0MkM1RUF2aFozcWpoMGxG?=
 =?utf-8?B?dDBIcU5ZL3c4M0RSZm4zZkxPcWk3YTlIbTBBd0xvcDZOR3R2bW1xL3oyWVVu?=
 =?utf-8?B?a1R1R3RHWnR0VTQ4WFlSakFvTzc5OHp6anZNdVdHUjlrcGVGRHVMaHlMZjRq?=
 =?utf-8?B?ajFzdUdZOVgzTHhZQ0hMdW9IT3BRMFFnSTl6WGxRM2NTaVNhY1JQem9XMFNN?=
 =?utf-8?B?bGhEOG1iaUFmTWlLTzFpUWYwNUpDU1pYY00xV2lNeHRjYVI5MWpkck9oR1Bk?=
 =?utf-8?B?OFRQZFJCaUM3WjJSdUFLRHZ1M0tEM3hocDBDTG15QWZyOVdLdkdQZHVNYlZY?=
 =?utf-8?B?cUZtUE9uTHI2ejdBMG1UNXh0dSszZC9PMUJQSGFDc3VLbzBWNWxOY29QVEZU?=
 =?utf-8?B?NkxjSVRVUHZyZGsvQnQ0SWJxWjhUeW02RTVRNVJFRG81cVVSa0NxV1lpYWg4?=
 =?utf-8?B?VjgwRzdwbXo4MXFMS3pyWG5lQW9SdmZOeG03ZkpPTlRVZ04zVEVSc3BqN2lZ?=
 =?utf-8?B?TTFzVTlIbGZIeHVHMUZSZlhaZEhqYmV1SGJzOUg3VnZsWm9aYWc0YTBaV0NI?=
 =?utf-8?B?RXo3N3RXT1Y5bmlEMG5TRHhVRlh6TDNWQkEwQUZwbFFzOXdKOXREamwrTWty?=
 =?utf-8?B?OG9vYXNFSzhTWW45ZUd1U3RCT2xxZUNqeGVReUNpaGs2Q3lkUzdYWHVKWDFE?=
 =?utf-8?B?VDN2NFo4N1ltNitKdTdsRXdzRWMrbmdtQ1gwZDd5alRVQnJodHJuVEgrM0JB?=
 =?utf-8?Q?QfdMBttrcDgpD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHJTUjk3VE15VC9laW1uT29YRmRJTVlmWlo0aGN3SEwzS09GLzNVbXFsTHAw?=
 =?utf-8?B?Q0FLMXE4Qzd0eTNGb0Y0R3lKTGlPTTVzMFk3emNTZG93aElNemV3L1FmZkpP?=
 =?utf-8?B?NnJaYzNESWRldFIvTXNqelYwS0IyaThOMGdrbEd6cUpQTW5mY0JQa2xPcnBP?=
 =?utf-8?B?Q0phazlkbVFlMkkwOVF3SFhXblJlVnB4aUt0Qmo1VUllME9uV2R3ZkxPOGVL?=
 =?utf-8?B?R2dGVnAxS3JDUGdvbHc2MU01VTVna0JjcUZnMGlqN0FnOW81M3dDTU1OTlhX?=
 =?utf-8?B?RU1NNFlmSGJhOWpPcXJvUVJrZ1l6czdVcXJVOFVKR2VZZW5rZTN4OVBxcyti?=
 =?utf-8?B?NytaRmR4azRrWURBQi80VDQ5U1hQdldLYWR3Y24wT0R3NWJPQktXUTVpd1E3?=
 =?utf-8?B?RU1PNmwxM2MwNnI2WEdkbnpuUTB3VmdIK3ZwZXdtbElIYlJmbmVscDhBeE5P?=
 =?utf-8?B?TE16RnhaRTlENlMxUlpPZFVvVzZ1aEJ1K1dOZzEyamZ6L2V3NWpxaWd1dzBw?=
 =?utf-8?B?TVFoUWVEWHIweXFlMkxNK3c3SE4xTFBERGQrUUhoQzZTcnpSMzVNNkFtbldx?=
 =?utf-8?B?d3FGYWFKUTRjTmRoeFBtSVkwOUJqNlh4cldBSUI0Tmk2SGc3MVdtZnh5NmRP?=
 =?utf-8?B?d1FzYmVoUDZvK1o1UUxtejNCNnRjdzhnM0h5ZHBGMDBqNStmcldsNC8xODdr?=
 =?utf-8?B?Z0RDczF2UU1pQWU2L0hHV0s3anV3bUJwWjBsK0ZsaWdneW95ZFplQkxCRTBH?=
 =?utf-8?B?Zkc4V01IMHBLNUJrQ01ralArQWlnWkhKTVVuUGlwUmJweGJKL3VOS0hFSWxy?=
 =?utf-8?B?SVZFeFVXUmw5U1ppZ21ZZ0UwRDhkRktFVTdaajhzSWMxSjJXZ1Zvaldic29W?=
 =?utf-8?B?VTEwZklMTEVJSjREdW5jaU9WRFZ0RXdUK3JESFVnam1YSndxODFBRWpCcGFN?=
 =?utf-8?B?L0NNUE9yMEt4MXdlV2ZyNTl4WXNjbUVBeGcrcWRraWd0UzZTL2JlZ3RqSWVG?=
 =?utf-8?B?R0xyUkRDcCs5L0lOU0dkaFcyenV1Y1dlK3hSamZDSmk0ektuK3lBSTFwZkR3?=
 =?utf-8?B?YVRBM1JBQ3NReURUZXVIMDBQblNVOW5CdWZmNXBsTldKKzNqTWFDWVQyTjAw?=
 =?utf-8?B?R2tLL1lDeVN4YkNibS9sbDNjdGNIQ2VuYW03bndDcEpXZ1ZwempXd0hiOWxr?=
 =?utf-8?B?RFVXKzFWMVJUaUNIS2Z0LzFBT1FMSHovcEpJZm1oWFVCVEYydmF2NmxGTEhY?=
 =?utf-8?B?TVNYM1dTMEVaNUg2L3BaNzJpRnF4SUZRTklmNG1UeE1RbWtIekxsQm9kVlZ2?=
 =?utf-8?B?UjZBWlhQaEhyekNWZGd6UkYra2JIR004L25neXEyVnZza3R6Q292aXFnQTZF?=
 =?utf-8?B?cXBibUxrbFh3T1NabWpDbEFEVG5iOE5PM1BaYlAyZDYyVGxrTmhXN0M2TXZ5?=
 =?utf-8?B?ekYzMkxJMzl5cmpXSnVzY3dxUWplc081YitKVldmZzdJVUJ5eTRTR1N2d0My?=
 =?utf-8?B?Q0VrWU50MmNxdzZMWGVrdU01S214WjQ1c2tGTEVLV3oya1VQcXBMVmdWUTZy?=
 =?utf-8?B?bWh1MFVScWZ4a0ErUUdpOER2RTZxc3l3UDlReWhBVFpUM1c3a09DUmI1VmJU?=
 =?utf-8?B?TEFtTHRWMjBZWjI0UlE5SUI0eXU3N3N1ZHNZYTd3Q3Y3YWhRdEQ2dFROUHlX?=
 =?utf-8?B?eVp1UTV3cGVXREk1cjFhdUl1S1JUb0NERHdoZC9Lbk8rZHlTb2o0UjBUZlRL?=
 =?utf-8?B?Z21ZY2NXeXFrVlg1U0xkT1VPSkIzZ0M3SS9tK2V3R3JwWUhPQXh3K2FuanFk?=
 =?utf-8?B?Y01BUWsxWE04TXZiVDRLS1NOakFIcStnV3VIOUtiN1ZrQ09QOXBVTXpvSTg5?=
 =?utf-8?B?SnVmdjdqa2dYWUcxTVZSWXcyOGNFcWw3Yys0d1VnMGJ3MFpoQ3dTb0E3OTg0?=
 =?utf-8?B?QVpta29jV1JyeS9jMXRMQlE1d002ajZYOUVLSEMwclpQZkxjOERtQ1VOMFR0?=
 =?utf-8?B?c1d3VVl6dEl1cXZUd2FqL3pGTjNHNWdtdXB3ZDN3MURoWjhFdk8xUk9xVlU0?=
 =?utf-8?B?VUhQcktVZFU5anBJUGNqWStlcnl3cTZxTUF2ZU9rN0Zoc01ISms4N2FtUld4?=
 =?utf-8?B?WldMeDcyZEtUZkx1Yy9iMDNDYnJIZ0l3UkJBcDF3TGd1WWJiOHEzS205VXNI?=
 =?utf-8?B?eTFPcEZDUGE4TXVzV05vMjcrQWhkc0ltQWVQWWVhcCtvMUZTeDgyVzBxRDBI?=
 =?utf-8?B?cEpmQm4xTzFwa0s0Q3lpVVhlVTZBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f3697b-9678-4acf-d2cf-08dd1f88a94e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:23:17.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MV9pKzJDHAjxf3mvCyFuzNxPpdYfBqbJ2+cLqMcDnA8zV7z9aY6PiOdcNeUsaAZOcWHzeCTkrb2U0PsQ3bqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314


On 17/12/2024 17:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


No new regressions for Tegra ...

Test results for stable-v6.6:
     10 builds:	10 pass, 0 fail
     26 boots:	26 pass, 0 fail
     116 tests:	112 pass, 4 fail

Linux version:	6.6.67-rc1-g584b6d5f2ac7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh
                 tegra186-p2771-0000: tegra-audio-dmic-capture.sh
                 tegra194-p2972-0000: boot.py
                 tegra194-p2972-0000: pm-system-suspend.sh

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic

