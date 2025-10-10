Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010017.outbound.protection.outlook.com [52.101.193.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5D51400C
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760116525; cv=fail; b=k7RG4r7glzajQhUsZ2VdOI3R0MSry1Fk+3HpEBfej4YW4hQGz+JhmLJ3c6RtVaHS9CiUj1M2Tc5yIIDh0mO4PMbEQHZhHECgwz8RJiZb2Z8kiQMvo90B1ju/hpn6GmnWcrohzoGR7PbwCRO+hPIo5d+FbdTA8hwkCjEcx8hJoIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760116525; c=relaxed/simple;
	bh=S2QnxXb8S8ODCGc0Vi13YVaJXR0RerztJnbAGCj/oV4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=KTUjqnJ4R81chTCZ6eVyx8u2MDxXXXXTIiQtWfnZGXQM/SQhoUDyZngv5hQ/QNqa8t4hBiX+PZW45Ofa6+EVY3xf2xfj0GcsvePIy32q9xxDrh71pBk7ub4ocqBY9YZHei8VJN/KAXQhHCDq6Tm+lDBh7rlKzGsbEgn15cJ9Nt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y5nP4GVl; arc=fail smtp.client-ip=52.101.193.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y5nP4GVl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOfQLNpCIqBTEqYt/YCLW+xbcec0vYPQObny1M/5SxdITPsM0eDWf2Q+6KI5mZ+OqQ4TIeZGqTRUgGKvBKiQJsRiEDbJD18FHvwkQfaRBhpO/tDUft0t3wGcPamLt12nTBxuHFi1pszNMKrg3MOA7pVrz73/rN+c3giwr9fL/Re1NExc/BZdMg7lgs47mJ6SVjRwcD6Xi3JOUAhzApGX73bQMGt7FomXmaQaKX7WXsqI49ZFpqx28YcTNYth1Z8xSGjtehLQ7Sj2rvT1E7rDpJbaSElj5wrq2wyKEj+s0Gxs8koQSXSqyxB+7NPrp/1dtx+QBVkesIz+l+y8j7yHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vg+3NQk9cHKi579PzzDUAzZVbgTCLlYunPvybrqF1C8=;
 b=MnmMMqoF3mdnhKdqkdif4/DhCWYoGDMm3R0i7Mj0mgYFMX4AD4n2Oh3iGk6+WiNDiBabZTaiXvDk5s90PO3sw30EmNhItUMwUOhzN4v7+6op8ewK5vjh+V6ps5XsqwxtriO4UO7vFaSclT882wjaMOl1AXeFa4NAhaWeqtVha0/JCyiTE2YwSa3RWHwpBnKXj6bJgDNtlNGItywvkTDOnyPgTVR+Kva3n9PoTj56KGPXA0RdFClVUU0wzYwDtrNiZsBzAZmcdZOLOFMq/Lt1ZKNnV1uDOdwm4xFOCLOOe9OBS2zHF58rCC9PdBDZe35lQXMoeJ/aOkOSJlpv3s3G2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vg+3NQk9cHKi579PzzDUAzZVbgTCLlYunPvybrqF1C8=;
 b=Y5nP4GVlNSP1FHPqUsG1J9HpbPrpYrPp0jyijMBmm90XFvZBQ16aaMZY/UyvpaenhgCWs6j0w1OYADZ1qSe9qN0jt+bExJDyH4WwemUfMq0AJ7yRdT6UBycs1urcVBe9O7c2KYb8w1DZawVDr6odY2f8beEdHNL+ODANWmWK3iH18VEh2HLPZV1uhO8nwvg9P4+uBKvChhXSq6eXnS20Aj5KHQInG+cvz+sQfCqhYhmt+1AByxQ/EwtkP7hBVEoF4RVNTQX8sX9COLJw258BMAux6BtYsgMdwcrTUSKWYYIAm1XjqVCDG5V705wmlykXt961gwevwc+WIX8OE5OgKQ==
Received: from CYXPR03CA0079.namprd03.prod.outlook.com (2603:10b6:930:d3::22)
 by DS0PR12MB8248.namprd12.prod.outlook.com (2603:10b6:8:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 17:15:15 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:930:d3:cafe::40) by CYXPR03CA0079.outlook.office365.com
 (2603:10b6:930:d3::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Fri,
 10 Oct 2025 17:15:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Fri, 10 Oct 2025 17:15:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Fri, 10 Oct
 2025 10:14:59 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 10 Oct
 2025 10:14:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 10 Oct 2025 10:14:58 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b718a124-c7b1-412c-a281-231b8b900667@rnnvmail201.nvidia.com>
Date: Fri, 10 Oct 2025 10:14:58 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|DS0PR12MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: 58e68657-5736-4da8-3e50-08de08209481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qlpkb3JSSmtyMWtha2lZeW5NMFRUS2k4KzZ5dkNQNkJvbGhpS1RXcnNIeEpV?=
 =?utf-8?B?TjZ5aHJRWWpsNkVRdkNoaTVTS002aFNESGkwaXNCZXRiNEJKYWdaeUxZRWVQ?=
 =?utf-8?B?RjQ1KzRZVUF6UklJc2tOcDhmQ2kva04zWHBQSXpjbDZQb3dMM3duUXEyWTEv?=
 =?utf-8?B?emJqa0huNjMrTDlRWEg4OVphTFN3Z0p4Z1Rhenl2cDdMRDJ5a0Fub2ZobFYy?=
 =?utf-8?B?dzZjcGVybjFXUDJjeVloWGgxL3RSRzE3TFM5alhnMTlwRy9yU0VoY1RtSVF4?=
 =?utf-8?B?K2YxMEN1Zk13WVRkS1d6TzJROFc1Rk8vWUI5TktBSW4yaGxQTlhPUDNja2dV?=
 =?utf-8?B?VnlPZkQ0NjVkSkdmd202ajRiU2FRRHFCeHNSU0d1QktQOFdNUE5Md3Rxd2lE?=
 =?utf-8?B?WUtJY2Qwbm4rcHFBazNNdTV4blV1aHIxMUZldjRIWWFXM3BXaTZ6ZnJuZS9l?=
 =?utf-8?B?QjZra0RKUFJUQUhnb0hxYU9nL082ampCeXhFNjhxQXRWd1UwWUxyMVplWWEv?=
 =?utf-8?B?aHI4WUR6UW9pV3hGRFVLRTlpRXA5Skc5RXpjSGh1TjJnam0zK3hXeUE5c0x4?=
 =?utf-8?B?c09LMjEzQlNjM25mYmpBZ0QxeURPMUhIRUxlcjN0eDMzOEVUZlVxK3VGYjND?=
 =?utf-8?B?d3V1TW01RlVIeTcrNTdDQkxvNG5qVFR5VDFFWUpXRG5yaUZvMERqRWxGN3l0?=
 =?utf-8?B?ZnozcDdWc1hEVDAxaGduTUdOR0hJaUMxN1A5cHZGODB3UmkxZ2lZUDg0VUNp?=
 =?utf-8?B?Sk5SRFA3VklYOS9SMWdLTlV2aldyTW1xVnhUZ1gzOTk1SjZyWXIrUUxvNlZi?=
 =?utf-8?B?TzdDM01yUFVZbURpbXNDWDlmKzF2MnV3eTluK0E0eWpFOGYvVDg4OHhqaHFu?=
 =?utf-8?B?TmNvc0tVdW9QVG5jM2FKMko3UzRMSzJ3eW9pVmVsczQrWFhySUlTWGFpQjlV?=
 =?utf-8?B?UjArbklYR1BBZ0h1SDNvb1ZlNHpuWUY3Y0g2VmMwQ2NHZ29qQkQrM200bHJ1?=
 =?utf-8?B?M0xSTThOVXh2Q3drRHk0SERjcURGTDJ5bXh5NXhCSFNGNzliS1lsRUI1SXlL?=
 =?utf-8?B?SDdITHpoc3RidlU3QVBBeGErSmk3MncrZkdJNWhwTjZ3UkFtZXM0MTVJS01Z?=
 =?utf-8?B?S1RZTVBLT2VDV2ZqRk1qYlFoZ0ViMGtqOEtEdXhnTC9yZ1pDbDFuYXp2TmZy?=
 =?utf-8?B?SURoVzdncFgzUWQzQmNmbUdjTy9HcjlzakkyWFU0ZmZTOUhpeEwvakFhQnVK?=
 =?utf-8?B?YVE3TC9aV1gyTEg2enc4SVl0UXhxcG5nWVpZZEFSOW5OU24xa2hhNU5ENlVl?=
 =?utf-8?B?THhwSmJabzFIT1VENzErU1RBYXRxUnBEK01OQlZvSitBNjY0Z1lrTEZQOXU5?=
 =?utf-8?B?aW5FcEdZQUV0VHB5RGhzdUZ6QnNJb1Jtc1VKM0YzSEVENEF0clIwSnhKTFRy?=
 =?utf-8?B?Z1Y4SDhCUWVmTVJoN3JCMjU1T1FWUjk5VjBxUTNqeXRLYmwrL0d0cStFZ0Vs?=
 =?utf-8?B?S1lZeXlYaERzREtibG5hcEZSNWszLzVJaFZBMFVRVWlWQlY5dWhTeU1aeGx5?=
 =?utf-8?B?QVpzQ0F3MTd1SnpIMmJFRHV5VHIxYThROXZhbTFnMnlHRHMrQUpwWUJYUHNH?=
 =?utf-8?B?Z1JtTDJuTWwxdWxNYnBraldNNlJodHNYdmkvVzU1VzJDMXlVanNWblYvYUNW?=
 =?utf-8?B?cjZnd3Y3UFROL2U2ZXJjZkdWb0I4bDg4RGlKYjhaWWJDRkI4OGs5OWtzcisy?=
 =?utf-8?B?b09PUjFZYkdOdWdja2ptVVNkMVRLNWtJeVdva3g2SFVydUZnZndJZTdiK0Jl?=
 =?utf-8?B?bGFZYm5hQm5ZZ25YdTNDZU9uNVUwbXc3WGxqdEQvT0tSMnY0RmlIV1FOb2Zo?=
 =?utf-8?B?V1E3Z3F0SncxSTY3NU4xZzZkT1AvK2RITUUvYjN1TUVwOUZGZzQxZGRBTjUx?=
 =?utf-8?B?MWplRS8vWGpIOWVUSG5VdGZ3Z2U5c2xTeFVSUTJMTDBvYUZJQ0VRemhjRzdV?=
 =?utf-8?B?eEhkbzYyU3FEYkZDMkRWOC9KZnFCdGthN1pDb3VER3FaOWQrTVBTbkRPMFNo?=
 =?utf-8?B?eXdNdzlMNmMrYzNGN2NJTk0rb3RrTEprRnVpSE9CZzM2eWZvQm1ld25XbFlS?=
 =?utf-8?Q?ykNk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 17:15:15.5616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e68657-5736-4da8-3e50-08de08209481
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8248

On Fri, 10 Oct 2025 15:16:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.111-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.111-rc1-g65af00078567
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
