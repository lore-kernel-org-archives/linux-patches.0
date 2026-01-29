Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010011.outbound.protection.outlook.com [52.101.193.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B89D327C18
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 09:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769680158; cv=fail; b=hOzUg2BvFYZhbz5n+hbELyPY6UNqxdhMiP8zZ4804P+AV5k8YtfVQVuVyMYn1cAR0BvBs3a6TZYx2kD8bmOHbk7RBNusqBReFYAZOilJAwsm55JBc6nxJIBl9A11GBIN5K9wEYTBo2VTIkL9SEm/ti2enw5p+VY8RgXYe584Wkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769680158; c=relaxed/simple;
	bh=SpGGi3DT8ztMdnugd+QMOAZUNJW1u/v0yWjlsdUYSh4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XyfMqdMQCol8mdiz/Hhor7RJEa/4tt+GyAlfHdg8vDJ97f1qtIdkjoIZv9D0DbSH9SytldPzDFJ7PuAZa76NEBLuWA5pfvRAv7HzBadQEGMkeguaBnyKFgHm/vTEim3oxhx+hGttdOzsh8Vzmc/lx89gr8RgJizhScPfVFW4AoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YmFIp6pi; arc=fail smtp.client-ip=52.101.193.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YmFIp6pi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZL9JXQGsYsk04AMLzMA0VAqEmJ3ib/V+3Zvy0zKHpSVbj/6NmQeZn+CjqqIU7M9246pub6ujiOw1mNnQOGV8i4r/GS/kEzV1noBfeAx/npVNL5zdSKNYN2RivIbEtM9OtsU1z9EveTXMj0H6dIHx51EJgSmCvHZk37mwNlq1PfScyMiWjnuDa2ugHeQC6bLxlq+LW4b3uiRZO3MO0PiAwyla6xD1ATDZvXksPM2s3O5M3JQ5D7na7yR6/MsSNXJ/VmkU9kAP8/r6wz2FqH6lPHbT/6myEg8Vv/0Qg2TTFOHsmF+tGYqH7L394QeiS28G/QJoXDqPl2L3jPIe5o6f9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY017yGuS+ML/q2bUkEMx8685lyr8uR7uLNTmEZcPic=;
 b=aYT6tcwDueIEtLp9uUsmJV+/zG4TxWS53NuDQXxKsHM5U39XkiNmXBt4cHtrP5Ongg18UEMUvBYIKEvE7GoJm2/vxOl04J0t8dHhFBvIJ7EMIfqCtF9NjvjnrFh1cqxggR7MyKvD0npVcFbG5nhS8J419BC46usGjoFVzvmXCHh/XIq9sQAtDSYeBKx7URrIbxvHBZYWnU12fJ0Yjnj148vYGHZWwlmdf+ISCoa/XWIuaPlclls0b7IzMKyU5seVABYVSctGbkQAGO7z6GVtimKI2+x459MaVMk/T4qJZMBqoRSFhzmylTQVIcsDwIUSsah6CPB9hbGyuwLIzAtxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY017yGuS+ML/q2bUkEMx8685lyr8uR7uLNTmEZcPic=;
 b=YmFIp6piLcNyOREpZCb3YNRcm5heHAr77HY8nqoQR0p8gP4rRfuf9xBwXHKaktoY3j4w7BntGiCVz6V0WquENT2EIemWNrYjW6YIxTTYB1XIJ5vi/hOAJOeMs99fkdbmuwA5mgGqewnlcHGwgwy13YXRAOw4wajn5W5KD47Lis4ZMfV6vDmliPpn4/395wsNxrrAL92F7tyFoF68fxhjj9s5u70nc/isF+2NZ7RKQa1Im/3s1k9eYwM1yMrNElvDpYwYQykhFaIasukrOD+19kiNjDZvUAWEYnVQtSPNo2Et+O9QmYky39GRNBIH6I38iumMe6sKSHTk7Ay3kZSOSQ==
Received: from BY3PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:217::16)
 by SN7PR12MB6932.namprd12.prod.outlook.com (2603:10b6:806:260::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 09:49:09 +0000
Received: from SJ5PEPF000001D4.namprd05.prod.outlook.com
 (2603:10b6:a03:217:cafe::57) by BY3PR04CA0011.outlook.office365.com
 (2603:10b6:a03:217::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Thu,
 29 Jan 2026 09:49:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D4.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 09:49:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:48:54 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 29 Jan
 2026 01:48:54 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 29 Jan 2026 01:48:53 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <700d60df-cfe4-486c-ace7-a40b5f4e77f5@rnnvmail201.nvidia.com>
Date: Thu, 29 Jan 2026 01:48:53 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D4:EE_|SN7PR12MB6932:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f94cde1-0353-4d29-87cb-08de5f1ba5fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTFrN0FMRGNWT3NFdDBVcDBsbm0rVnFXRGN2TFRJVjZlZzJSMFlTZCsxdEZR?=
 =?utf-8?B?aTkzbjBVVjE5K0NCeFowM1FjbFZGdVRoYitLR3pUM3Y1dUpXWVpvRHNxVG9i?=
 =?utf-8?B?THhDSXNzeFY4M2h3YVNpRStZVnRtSzFtWVZ5elVqajI5bXh6UG5SdGswWTcv?=
 =?utf-8?B?UlhuZjVLb0Q1OWlRcWplZ3drUFp0SGEzTGJSQ3VDTHNka1dhMnBQejNSQUJB?=
 =?utf-8?B?SmFJVDhBYXl4YXZFUFpieWJGZDF4Vkw3WmtzMkpIalM2bm5VUkkvUzVIeVJj?=
 =?utf-8?B?KzBCaFJpQ2dLVjdCMTdhZWdpNGFoMmxhYWtSSFJxa211WWQ3TDdTVC9UWkV0?=
 =?utf-8?B?OWQyM1FWZjJnTUFVaDNhT0Z0cWE1NXdtYUFkQXBxVDcvaGIyL2QxanF5WG9L?=
 =?utf-8?B?VnhFSEVaR1FpeVAvcGpmVFExY1dScUFqSFZpVlMvRS9HczUzUUFpMW1NUlZh?=
 =?utf-8?B?ellDOXVEaUJMSmFjc2VtQTJNRE9XSGRyNUt6R0llaFB5b2t0K3N0dHRld2Fa?=
 =?utf-8?B?V1Y2ZE8xNkJFOERUSG8zb0RlL1NHWTNNd0kwT3FVSjlpZHRmSTFlb3QrQWNE?=
 =?utf-8?B?bVJ4VTdKa1NqVUYrR3F3SkdDRURTTHZ4b1ZBZGd2NmpBYlYyNnJINFV6ZXYz?=
 =?utf-8?B?K2N1T0lESUltUXhFYUFhSlFiS25UL05OT2J5RS9qbTkwMkdtTmsyT1Mxczd3?=
 =?utf-8?B?d3dqSmJUSmFmMkNRMFQ3dzdCYVJqRTBIYjRpbStxa0ZNVHdkZDVrbEF6SmJJ?=
 =?utf-8?B?K0xtTmZmVUJIeXdnU2dndGVGMWl3emxPd09VeUJSYTVQai9NR1laV0QzSm9s?=
 =?utf-8?B?UmxwWWNnQlI2QmhzMTNIREl3Z29HZVozV3Y1cXRRSW1zMHV1dDVwZjFsUTk5?=
 =?utf-8?B?OHJFajVqQjdKUEJaSHcxRndqc1lqQUdYejVXTDBXQWhDempvbGR2T1RUVjZG?=
 =?utf-8?B?UVhneS9QSGRJandMK2Y5ZnJ3MU15eUZlRUFsNVdON0JRNFdGS21DVEZPMGZ0?=
 =?utf-8?B?YmVVUlE2RGV3elJpR2VleWozZnNDMU84WkNiNG0zMjVXWmcvSjBUb3RrczFJ?=
 =?utf-8?B?ZE1kV3V2YVZWUzF3U2lLaGhMNC9idjlCRUY4YVo1QmlTK0o2Vzlwd2x5RmRw?=
 =?utf-8?B?Yml1em5hSndaL09WREQ1ZFBlTTBqR01mN0V3VmhsQ3NJbk9keHVjdEYxeUZG?=
 =?utf-8?B?R1JsQ1NHQTcwWER0NTJ3emZrVTNtcnBkUExhKzc3eHZJMGJXWitQVDMyZzdy?=
 =?utf-8?B?aUFocWlnOHVMYUlBSjl0c01SeWxWMGl4R3JaY1pWeDA4WjYwQURQQTJyc09J?=
 =?utf-8?B?UFZUc3lGQTVQVlRTMWN4eG5YYTN6Qk83VXRiTDlwQkxocFRlYmRyUk1ObXAw?=
 =?utf-8?B?emxheGFXaVFJOVV5aUVSdkxueHBwekxTNW5KeFI3UWFZSEtubGgxV1hNT1di?=
 =?utf-8?B?Zlp0bUFMYmpBbTFKc1VLZkJXV1NIZGIxUDJpU0hwZExBTlptMUtwMGlNLzNZ?=
 =?utf-8?B?cExKUEZ4WnVNeE1uRnJJNzFZU2cxaitFUDB1ZDBxeHB4UG5aY2lSTmJNWEx4?=
 =?utf-8?B?eXlHa2xXWGIvRWhXaXY5cmx1SDBXTGYyNVppZGtNTWN0TjU3N1VrR2lnVVpi?=
 =?utf-8?B?QnlVdDFQVWc1cVdrWHV5MSs5eDRIeCtmczhpTGJoNDRDMDBvYndQYzIrUjJ4?=
 =?utf-8?B?SHVQZnFUV0lxUnBCQU1qSkgyc3RoS1ZRN2d4aGRsMXR6b0M4WTB6b3FTWnFX?=
 =?utf-8?B?RElhYTUydHZaU3k3VXkxQmpjbkd5aE43WjFGNkg3V2Q3dDJUaXBNemoyY3Nt?=
 =?utf-8?B?cnVjeGNsLzNpWTErdy9ST05LRlg3ZDRGaDUvMGMzTkFPdHF3UlUycXZHSXJy?=
 =?utf-8?B?U05nbzR6MWJHc3VqRWc3K2JmdVFnTktBcHByeEc2SjRhZ254WE03b0xISUxl?=
 =?utf-8?B?Qm9GSFo4NU1tU2FpeUlSbW9XT2paUHA1NHFqZ0VPYXRWenJadHRQL2JPWHpS?=
 =?utf-8?B?L1BzZmMzbGQ5ZG5nd1dZSUxmQkVyL1NtVnV0KzB6VlhrbDVZR3YwUzJPcFZn?=
 =?utf-8?B?MTZTRHJvUHdrRytES091a0puYnVjc25DbCtOSjVVMmMxQ3lRR3hwbTVWVWRv?=
 =?utf-8?B?SVVjd1RTWU1vZ2xwbndYMGRWZ240ZlJaSlFYcnZlVkZLSVZ0VzFBMlAxNEll?=
 =?utf-8?B?OElSS21jZENGbXRUZVYxYWlBVldlK1g5OUdueHdLVGs5blRKbGNHOU1ZOHZt?=
 =?utf-8?B?NzdYcVNLU0QzaWdBbGJRRlRDUHBBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 09:49:08.5386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f94cde1-0353-4d29-87cb-08de5f1ba5fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6932

On Wed, 28 Jan 2026 16:19:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.122-rc1.gz
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
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.122-rc1-g0ca0b0d44403
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
