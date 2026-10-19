Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010008.outbound.protection.outlook.com [52.101.201.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A875492E35
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 10:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792405188; cv=fail; b=f+0MqOBMl4EV2D/A5T/PbbgTw+XMG7uKfrIHnPrQeV8Ygm+wTzDZLOU1IwVKGUgg508UhhazyzSm7VNdc5cbQPY67OH5LVoEc3joc9VtefYmmhXiCrVTZ6bv3lRKLibjgfnxLcWqOz7HcWsG2lKtKRBqAlHx3OAm7Sjvic0T1Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792405188; c=relaxed/simple;
	bh=KtpLEAMedcDmqmo+1AI61z2tOlLrb49gDM6h++lOXJc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aezppeyrhtJaSCYbwyZYIuZgv/qvBhD+l/rA1oAQBYCndbJZQ4HEKxFSyzqZGOzLkyxdnBZtnodjGoy6gDOiHXV5F6nFUOxkqub7Ark8/En8noRUhaXp5qFA8M3tgYpdqjAC+LGWSWziAOKPCy5aoO3zDmMpFhNIr632YipLoRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gDWtb6Op; arc=fail smtp.client-ip=52.101.201.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gDWtb6Op"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Epmxl7TYZmqsFSM7YB3tZC3iy9KgTVdFWt1tj/2pvABX7vSKGacxAk60tkN3US5Xkhnk75/ULgy33Q2rU8Hqxs8POfkYByxG/Qz7WDEgefStP0W0uxMgTHt6FzbTRU98aoXmE9Gzb3UHa3nbd89XE/ONk0rkx/2Y0cgEcusTqp7Gl6sHlNcdmN4xdQQk/Z7Gt2plkFYZd22VdQiTGt0phbwmTmIOEJhljGjYvltg13bU+Smru1NAbxj8QVCfL/A7uXKuX48AE9Hqb0GCyaIdJUkowitByAOm/k8WPUZ+XoOWpCSe7QCu36HPnalgHQD3Xmo0cEK3QwacABb9QLAIdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vc6Jm7+Aeccmg1mqNeB3ioH7q7Qrpp/NGeJrCwZ2Pso=;
 b=I30VM5BogyBczMdleF+6dZS6sV8QXyrfBLLUhA0RMfgaGtx+9F29Va5JranhJhp3+JSxEloBF0/zA4EfgJ5xTDWUbwl86VRRDZOTi9muH3EAfbVp2U4pMnLH67EiOKP8EjI+Ce+BiFm4AO4ceej4IL0/X40NabaWSJ8wQzZPigy1Yo6hUfx4Rs9Nvrq4ZyQT6PsmSzz0YQ/+iU31Htdt7FOz5/4IiBH/MAUugJ45ZSwze+h8loLc33ZA1UgFpdwScqcXa9nIoExCHLtzQBCgaK4Wm4LLwUZkKMLuZcDXHMxvj2kCz6Jn3jP17CaKFsxOM/AHGIjB4z7qhBfHYBNg7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc6Jm7+Aeccmg1mqNeB3ioH7q7Qrpp/NGeJrCwZ2Pso=;
 b=gDWtb6OpaGSUBx9RyFxot/cLtGwn1XGZd4gNJL7wbmaamXUE4jdgItjpuc5UkWbRti5bqN/NaapmxLmiWIA+IJaHWMjw9614H9kzew1qBZu/5zheVUtdksABdTuWyQAtsD1CvXYe3EXAZU1DCHmIY9ANMauyrRSk1J31wDSNj8nYcJiTnPrE9PJ5QiVRYg8oKRsCyv0zVUbvTZ6rek00N11IbLVzW6ed2XG5j122vKdEfMkgRUrWYKAe7piV/zeRI8vAQIGOP6dBJSZpc6dZo3NZelsdVwc+f1f6BI9aUZP4gqgOuZPxhtMI78ajfEK4/aPlbZoGflWOhKFHZkp+lg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by CY5PR12MB6276.namprd12.prod.outlook.com (2603:10b6:930:f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 10:18:14 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 10:18:14 +0000
Message-ID: <8e765406-3ba3-47d7-bba6-e15a2cb56857@nvidia.com>
Date: Mon, 19 Oct 2026 11:18:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20261017160431.119607952@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::17) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|CY5PR12MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df24943-25d2-4aaf-101e-08df2dca48d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10070799003|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	J2V7O0EURw/Gz6t1zXWFSI70/Hj3dwIGG6QxVBQ9qSnvKCM5ymXaPDGdRdKS4LG7oXf7Mf/zMf3FvJpU2tCX2brU+LijtObE9Sg35+8DC+Att53rnrCQx3LAkatKTZTRef5jlGI2wHYvL9irtaWlVc9wQ5ck1aXUWMbGM/+C79PlpcSyDUPchY4jD7SSYe02Ct5/z5pRZoBy3daB5xcW2hrlk+QuBc7uSBnxHJMuLWh556wJSYY6mt8zZrksE+Q300dky1GZyTEaXYV9G8IY2iDA17yiFfh3EQqP7MAlgNpc242WsAyQaMg6edIzoCRjuaPdUows2MOyLowwwnocsiiYF3YB2oPLIIysRab1uDWY/BZ+ICyI2HBIpGoppTslYG0uX6h8MbYXXe07wGm70prjQFgMWdt8z8AoljMJ2Zro0urokilQ0/371g5rKAskugIPS7bUuqDFP5HZxob7CMEhyiVAAQ/f1MYk5L6Y6tcRaNrSmsVG4mWxlxl5hB/tdqhymu7yIo5SrvjbGIN/WWsvg0Oe+BlKI9toN1KAkNjcwTHZXQ9UnFcm5v/GuaiVhiqfjHozEP/Wn2iWbEdLk4E9ExGYpezmZtTvdfvCpkwLA4Et2ITu3tBw9OOARgmXSz8iR+qcI4aB2yGUDBG27X/aCWvAZxNBL1ZvDaaV7nU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10070799003)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWxPdnlwWitMTEpXc1JwR0dVQllzTFZXUGJzUlhSRHhRMjFhZEE4Zm1SaTBW?=
 =?utf-8?B?UFBmSzJFSlhEYStkNU4vcWhBK2F0QzZFQkN6clZDUnNrMWVKeEtzb1hucUor?=
 =?utf-8?B?WGl4TXJMYXc4ZmNJY3VXOUZlblV6U3d3SEsrK2lxTm11RldXOFljZlNZa0Fj?=
 =?utf-8?B?dHR1SHVOaDRZV2tIYWkvaWNXblEzSnUyUmZqU2p4WTNlbGJVNDExblhvWlMy?=
 =?utf-8?B?NWZFRzBPR3BoV1g0aWNscmE0bW5qYm9abjZsMUQ2cHBBc1p3REYzVlhFanVk?=
 =?utf-8?B?ZmJTSDhUWlYrazBPd0F0WVZnMW5kYUUyY0h4eHhodEpxQjhzbnpkOU5Yd095?=
 =?utf-8?B?dXBqTkordDNoMzBHN0lYaXNyM1VvR0tKanQ2dmh0TDFzTmNWWUJ4VmVrSGlL?=
 =?utf-8?B?b0lRNlZ4bFJ3MGdPVm9RcEVLY3haZDRsM2o4OUhuNS9NeWszU0xqMyttbGF2?=
 =?utf-8?B?Zi9IbG1CSW1kZVYrM3ZEMXFXMkpQQ1czTmRhVWdwZnMyUE1kRkFYVFZXcmVM?=
 =?utf-8?B?dHVwOU1zK1JsOVpEampVZDFUZlAzYlJMcXJxaEJDYWNTZWM1ajdoeFVaWjA5?=
 =?utf-8?B?T2d6TGJBQWI5Q0ZMSjR5VHBZQmV1MGwxTmI3QnpHRElHYWw5eDI5ZjJhU1M5?=
 =?utf-8?B?TkdmODg1R2V2YmZIRmRBdVQ5M2NpL01rTDgvT0VOdWcwQ1Q1MEdRVHFDUjFB?=
 =?utf-8?B?SXBIckpKeTY5dElxb2E1U241R0xaRDY2WE9saTNRTWQyS2JKRVdsSHgvdmlW?=
 =?utf-8?B?a2xaeHFSRy91UTMvOUxvQ3JEYWFzaUZuc3FXZWgrNjJqY29yVlV2ZUV1ZHlQ?=
 =?utf-8?B?R2I0bFBBTlVSbmxzZ2Y4MEhWdFVXRmFVV2Q1d0NLVUxqVVdlaUlUK05nbUE4?=
 =?utf-8?B?MTd3QzR4bmMydWhza1VzK0ptUElnRTRPV3hBZExBaENxVWU5WHBDUGsvN3A2?=
 =?utf-8?B?QU0rOUJ3NHpJSEx6Z2VZZ1F2c2VHVU9GL0xGWEkrZGFCSzk4V0ZKOHc3MFNR?=
 =?utf-8?B?NmVnODBGd1h1NDhWTnVOdExkZUdxdHY1QjhQeDNrTXFIYmo1c3hHc01vWVZL?=
 =?utf-8?B?clF6NUxqZGdPc09GWFV5VHpBdnBPK1RRMytrSjlOM1NWRmRmNlpzT01xUkd2?=
 =?utf-8?B?NGJ0WmVHYkJjaysrQk1Fc2NFTldyMHJRQUJKM2dWMDkrSGVYNDI1Y1hhbDU0?=
 =?utf-8?B?V29tUHNPd05MQlZPK2RSOHBMY3ZIcml4SkZpWkhoMkswVVVXWU4yVUxrMEp5?=
 =?utf-8?B?aWJrS2Z1dUVHdm11MTFnMmsyb3BMMzRmb0FHL2xBZjkvSjlOUlR1VGZBRHFQ?=
 =?utf-8?B?SXFveUFZYmxGQ1JYYVdRYUF2Vm5CNjBQVDE3djI4ejYxQ3JzVTBUVytYS1d1?=
 =?utf-8?B?bmRmWGhhaUsxclBUdmtaRXlPWXhvOWxXYzVBT1NobFR5YjdpU2dYLyt0Nldi?=
 =?utf-8?B?STNWak5PNjkyUmRqT1pQNEwzbXJWVk9OMzNmVjkrYzNnSHg3TG5OL0QwTHIv?=
 =?utf-8?B?cXd6OTZ1cTlqRDRPb3paRnBOS2ZJcitpdUI4QnVsSkVpL0EyRTRlVGt4MVdG?=
 =?utf-8?B?Q2NtS3N1RnlxS250V0FxSHR3djREUkFRT0JHR0RKc0dzcGlaTVBKUUtWNnNZ?=
 =?utf-8?B?ZG5qNnltbUFkK2hmd0ZsZUs1cjBPSGlsbXZmNWtpeStsQmNXRlVFVThWM1JL?=
 =?utf-8?B?TDlUV0Z5Tk5mcC84Rkgrb0U0NWN0Nkh1WkxnbERIUCs0QlRxNy9DRmppa1dC?=
 =?utf-8?B?eDQ4ajVFNngyT0xpK2JvRWdjbFV3T2Y1ZTNxZlk5YUpHbkExNjNBY1hqaGNr?=
 =?utf-8?B?bFB4cVJ1OXlwREZjYWZUdFN2bDF5U1cxblJ0akg0K0g3Q0F4WW9XSmM5ZXhv?=
 =?utf-8?B?WmlIU0FQQkJ6NlJWYm04Q3orUmluWS9pT2pMRlBhd3Z2M0VYZzA2Slk3Z3Rn?=
 =?utf-8?B?UVhQVUF6SVljZWdGOG8zT0ZzdmZiNWo2M1hFekUrT0dxUGRObjdPd1dHOFV4?=
 =?utf-8?B?Y016ekpLQVQrSm5DVUIrSzFEUmtNcWZVa1Z6N2Z5WUJXa3U5YXBVMWZRekxW?=
 =?utf-8?B?RjFLdlk2YzkveXByTkI1ZzEvUkhpK1hSNkF6SWs5M0t3dVB4QXd4WnYvUnBX?=
 =?utf-8?B?bEZLay9lcTRQYnIvRGJGc1ZkNUg0MEJvOWxkNW8zU1pZYW1NaFh4OC8rZVVw?=
 =?utf-8?B?VlF4K2xXVUtnWUJxSmN6YjBCZGtIcEtLemExL0tNS1N4YzA5VmNYbktiMnEv?=
 =?utf-8?B?Vk5XcUxHeEVUcEh0b1pXY0t1UFZEMC9rQkU4Zy9EbDZaSkJJcXgvYjk3OTFa?=
 =?utf-8?B?ME9LOE9vMGtxV3JIbi8vMi9vL2tGM3FZREdZY09Xam5XNTh0ZWN4eTU0WU9C?=
 =?utf-8?Q?l8vUlyQI0ZfrPUfexFvvTNYRlYFiqTwykSuT4TC5zsYCz?=
X-MS-Exchange-AntiSpam-MessageData-1: ZNdmOYZkSMJoOA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df24943-25d2-4aaf-101e-08df2dca48d1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 10:18:13.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bl+xooj/J60mPY0Qwm/Lu4v6oHce/SnkKUmcIgPIVkSeMBM+EGPTUBLmUKCHZnKkEST1Bp8Til1fAmfR80qpCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6276

Hi Greg, Sasha,

On 17/10/2026 16:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 16:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

 
> Pei Xiao <xiaopei01@kylinos.cn>
>     mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition


The above commit is causing the following build failure for ARM with the
multi_v7_defconfig:

drivers/mmc/host/atmel-mci.c: In function ‘atmci_remove’:                 
drivers/mmc/host/atmel-mci.c:2661:31: error: ‘struct atmel_mci’ has no member named ‘bh_work’                                                                                                    
 2661 |         cancel_work_sync(&host->bh_work);
      |                               ^~
make[6]: *** [scripts/Makefile.build:243: drivers/mmc/host/atmel-mci.o] Error 1        


Jon

-- 
nvpublic

