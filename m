Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE91C2333
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837687; cv=fail; b=qf+luPfviw9ojfzDwRkFApadaNhMi707RmoHn5daeoV6HqngHhaQCirRwf1Ipm0nyZBgTE+VBRzcunTB8UM9GEz8a8LsykFdPRZeoa4UKQeq1OEfdTWwTl8LVy0bTefl3+s56WbyV4RSN7x3BW+P2gaTV9oMW41Iqxtx86L6Afg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837687; c=relaxed/simple;
	bh=ZR2JgVXpyYQmlSAuyWRABS3v+riOdV6hYkD3aHUQsao=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=AS6mUH6xFdB/vz8MNEjUkaQcSwPmc3kDplae5zcgHeHTAevI1xjkhzx1vDFyHpDBR1pp4D/AtTowRRttJr4CioytgDWnfW2ZrkoMJv6paxS768t8EPqw/Ljtr+7BcSFFYLvYQSf8SJOJ/4/qRF5Sy239lnCcyESdBYKzKhUw70o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R5IgnS21; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R5IgnS21"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q9KZb5Z4NkQUHZ4Jois8fvXI+3k2DijOpYAFRiX1WMNZ66fNpv+zA1HxcNlVl+QX/xs5uyi9pQ/n+/EYYDarJm/4PNDsIz4C3W0xTqKHS4aSvlteWnIhA8pApUq++m9RVfO/R/hqHJSBGNqmgVuasWgzz2ssbkIpw/RkJ2UnRX3l0QvBfIoGVAiAdMPIB09Pg/8ifIWAuUg7eLyb05N0BgjgFCQ+hNpi6M+ihWDninpphOQIwYJ3QFUsVos3tH0AMjcthCr+UgAoph/xtUOAdcyxZmtDjov348Tz16I7NS8SK/gP7sdFxAcvXyjJiNYAP+k4mrbU0ct81+skaA29zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95Gi1egnCb23Ln3Shz2cRaNJQDqWywNy4aimkT+qnjE=;
 b=T/chScbpeZ8Q+oCtqKKyn2JDH0jQ7zPIkVFvqLDbK/uMOb7oUVeOxKUUAE6zu1sguoJDCUbZPiekOXkNKFQgjbxunftEIY9IsSJlL+JJCTzc/8D1bxM3hVrBaWCn/RRcD/w8AdkCpF2fXi6+lBkcUvrDlS+8JgMn6Yi/b9AR52gwsnethCmSv2UvcyPjT1PRsQiBmOnMJBu18YwMRh3CwYqj7zIuL2Px96rWjLl7cK3Y2awXbhAJn/oAwI8DcLtaevhXubnmFhTmVHxE5dVtHsWZnFjAnNaqm0f+YEjWf9o3Q9HH40NeBtoc5+LYXyw6maWYm0dKzD/pgy6iYyz3QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95Gi1egnCb23Ln3Shz2cRaNJQDqWywNy4aimkT+qnjE=;
 b=R5IgnS21/U6FnykpgwUWF7ZLCoJdNKwAPQqFmv0XgneY/BdH/gjsiZnT4cht4F7Qqw6WQNA/YM7Y43cG+1upOF9RKVH1mm/lECKCwNnG3ssr03h4Nt7HYj3pQZXMgG/wAinr0n1Mwe9Oq5MMSFJE56CmzGuD+i3pCGfbYYdtE65tSaa9vtOQ3JPsG1VvSyERO/WXjnCMOvESiTjqXKMKR+ksVAe6JUITvCmyi5mPY+H/EwVmZn27LXerHfOOUDUbPMMkGq2US4faJEDun1jBcNnA3I9IawSoy18I0al+buJvAOh2z951TCUE2/tcrVt5T7ixnf4xTaJSnTkPoAg0hg==
Received: from DM6PR10CA0007.namprd10.prod.outlook.com (2603:10b6:5:60::20) by
 SA1PR12MB7223.namprd12.prod.outlook.com (2603:10b6:806:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 16 Aug
 2024 19:47:56 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:5:60:cafe::c4) by DM6PR10CA0007.outlook.office365.com
 (2603:10b6:5:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Fri, 16 Aug 2024 19:47:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 19:47:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:47:50 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 Aug 2024 12:47:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:47:49 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6b7d32e5-b60e-4b18-aaaf-a827da7807db@drhqmail203.nvidia.com>
Date: Fri, 16 Aug 2024 12:47:49 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|SA1PR12MB7223:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d87a3b-da26-423e-d1a4-08dcbe2c52d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkR1Umx1TmFtQ0Mzd1JYLzZJUDJGUW54SHdwa3pMU1prbU9VdkRJVzRkTHNH?=
 =?utf-8?B?dzAxNUlYT25JcXlRc3lwemJYbCtSK0pqTVJYMXNyQk5CRVprUUE1TGYvWExZ?=
 =?utf-8?B?WVdMbGVXeERwN1Bsejd5VXh6ekNTc3podmdMNDRtVnh1UitTTmhVWlNiUnlF?=
 =?utf-8?B?cVZ5VGREYUpDcWdYVVpNUXZyK2N0UHphTm4rSTZ5aDRwQlExT1FOemo3MlNV?=
 =?utf-8?B?YnJHem96cjg5ZVNkZGRDTzNKZW1KYVM0VE9oTnZhdTVZNDdPenMybUtkbCs1?=
 =?utf-8?B?VS9JYXlUS2orTXBoNmtSOHpmK0d1TytGUFZxZHA2M0ZGSUlqWnBNVGJHWlgv?=
 =?utf-8?B?TEdUQ0RVNnl4N21YYkltallBVUEwWS9POFdVMS92cDdOOWk0cW5kL3RvTUNk?=
 =?utf-8?B?cjRuNS91ekgwL1hlSE84Z2VlcVJwbkhwdFJFcktPRWhoMCtvc1grNjd0NFA0?=
 =?utf-8?B?Ny8wOGh4RnZWanBpYVprRC9MYzNhS25YUmlqOW9oQXkxU1NHYnNpYXpFSk1K?=
 =?utf-8?B?T0Y2RHFxVUZWdkdPRitzSVBYZE1hMHQzK2hrQWRKL1lPS2RTWllmWDhUbDNk?=
 =?utf-8?B?Sld3TngwUEJNaDhxa3ZVUmorbk0rUzNXREFEdXZybGc2YjBseHpnMDU2ODRi?=
 =?utf-8?B?TXJuWlZyVm5yYjVjU3hUUDBINXNlR2J0Snl6NDU5YnNseXlOWlkzUk9BbDhO?=
 =?utf-8?B?NzNWUjlPcWpMdWpxb0V2d1lmTDNZQVBpeS9LUFk3cVJYei9jU25WcHA3VWZU?=
 =?utf-8?B?eVIzMG53UlFjOVhoVkZpMjNFaHYxTU5tR3IreWZ0SDFGNkVFdHBjOHdVeUU2?=
 =?utf-8?B?VFovWEFoVmQ4MDQ4dmdCNWxIMzlzWkFCZVpNM1FVMWMybFR0ZXhlelptN2sv?=
 =?utf-8?B?a1BRR1FqN0dnZ2N4dS92ZHhPUm1ueFN4Qzd6NmZxVG02WmlNUThHUXI4Qjk2?=
 =?utf-8?B?b2c4TlJySGpuWW1Wa0RaNWlLZEF4U1M1dTg3RU9qVjhmSzR3RUEydFMySnNa?=
 =?utf-8?B?cG4wbHpiTW4wcFR2SEpIOExMQnp3YlFxa0VqeWVpcS9NeDR5WDBwUlVtNzNN?=
 =?utf-8?B?MEtxSG1FbUZldmhTS01uTDBKbHlTb2k3UktBNHhjdFdLek5JY00wZG55eHdI?=
 =?utf-8?B?TGZVdVZFNzJFNTNlTUlueWU1dzA1c1BJNm9UdnVsaElGdzhuREkwQUYzbzBS?=
 =?utf-8?B?NHVuYnR4TUNDTGZOSmRiNWpUK0N1MUlBTU54TktCaEEwSVhEVkxWWVZWLzA3?=
 =?utf-8?B?eTY2dmRGUElFa2syZUlWZEtueVJ5UWRKVDVKVjJPeXVFM0wvQjQrNnpFR21N?=
 =?utf-8?B?WVNqWE9pQ1ZpR1FtcE5rVldkRStKZ3c4U3AyNWhpemhPMnhUMVdpRjIxeWhu?=
 =?utf-8?B?MlhrM3pwZFJlM1BQUHFGN2JhWHQ0UlIwS3A2MCtrbnFPYXliYkp5SVdNWXhC?=
 =?utf-8?B?RURscHlPbDZTSGFacU9SL3V4REM2NE1XaDBZR2lESFAxc211RGpuK1NqYzM3?=
 =?utf-8?B?WEVDQ0l1SmM3dnh5OFlKL3Y3M1VmUkkvdk55TS8xcW1xbC9MZGRGangyNGU0?=
 =?utf-8?B?Um1aRnIyd3lhR0hsOERzYVI5R1RqRGNyZWsvMVI5VGozekhIMXZFUDNpWHJQ?=
 =?utf-8?B?TzRvbmJQZkxwc2RFZ3hybEJvMTZ6VjdEZTYxRnY2bncwbXg3WXF1aUtqTzhs?=
 =?utf-8?B?QSs2MXdtMEg4ODFMdTV1NWx6NUhKZzh5V1Rld1hBaEFDQitJMDRnTGlyUG5t?=
 =?utf-8?B?Qy8vaC90aURnT2k0UDhMalphVE52VnFGdDNVT3BYMUg3SEJjckZaY3UxdVB1?=
 =?utf-8?B?ejJhdEExZDYyK0lBOE1DNHEzRTZtMFA5VHQ2SzRpYTFqejEwVjY5cmpiZFZ5?=
 =?utf-8?B?d3BoQ0prRWNxZTNYVjRqanBxaFhzTWxQRERyTmdZV1g1WFFoakltTUdJUVM5?=
 =?utf-8?Q?ZRdi0XrLok+wpcSE5PftBzmDNUt9k6my?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:47:55.5879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d87a3b-da26-423e-d1a4-08dcbe2c52d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7223

On Thu, 15 Aug 2024 15:25:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.47-rc1-gd13cce3d7c6e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
