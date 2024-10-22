Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A271C8FA2
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619797; cv=fail; b=RhUBFdxfdJGJcFIoRuuxRhNaFYHa889EdflHpj7+HAXF52r6o7dTnsmNiW6MKUHLyWlj9+45rDGBDoneGI8EM8ujeEtnIxpXKXPKNyO5mA9hpKqjDLKcOy048IjtQL36BwkkIIw1KbucnwIhSstZr3pgGNw+RhLMsok2nA8/zDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619797; c=relaxed/simple;
	bh=kHh1cw+Y8ejZapwsxkeeUkDs28ZvE4UXcB1KsDJbYiI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=YzAayPdam6SolwveLiMqrWpIKnrnzAZSOEvuYdWyGZkaI6kre0U2nlNFwUYvvLoFmjpYGUH6wcOvfVSHQLl1X3MTuX3V8ITdul/y5Ucl0FGSli4Wwas6dv1IFvv75sxQz+vhUyuUnsxOqmwm2ox5TbYLREI0SfMiRGD5IZGsD68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EN8+w534; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EN8+w534"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvxzpoP+TMmvjDtPRLgQwsKSiYrpoHLIbRVaXmuxXj8EcHqaE22wWPWipIl+bmGxKfRqnDdI88OSq2wrP2fEt1198PHC29BdQ5vFUR3lWr83xCDG75JtssRBDQQqPsK86v5EBzSw1MAF2be/WNkAA7CkQulY0HJr/IU8V7AiWkb9FkbQcV51qsoAqjdtsdHJWSxNZ0S+o6AFDWr8fyYfQQHqFGcExuHHp36tOQWFHBpwsiHrZsI2qEa46wC1Cbl8JeM+Jsn+LdK4EEVC7rK4znDWvjOEf5Jw03yQ6l9pznXWUt2wa3hPJn7crMS40PtMq9w3rkBihMOwQmK5Ultc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SU2QxV/TJqXZGrRHJw3D/IDYmiUB62s1wIcb/d6l5d0=;
 b=N2cJuKOkrVyeRrNKhbpfFdezR4E6QoWrxp00UxXA3c4ODb9H+8OyfptuhEfDsUoqisLGaIGZ8Q/GCq4T4Hqgd6mnQK8FbN3mt2BNecv3X6kOEX6oOLpBpK2y6neXkoK86/KKes4LJEyKWN7D0O/X9tLrECeZ66UoTu3y92Xrm79+/y4qsvbnmBioQcRaz1+diQR88QkNbxjOT3Ul5focyupRgKvMZ5Im7/7Ir9OOsJDNx5SiyrPMpItqDHWtCHTBD9WtpwSO+u/7oIm1XLToxJ2zzs+b/oOvKU64LGs35CjOXWLcDQseDGM2FfaCuTACfm1P3oBUNo4jkyaJjAkbhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SU2QxV/TJqXZGrRHJw3D/IDYmiUB62s1wIcb/d6l5d0=;
 b=EN8+w534v/DH4pv0rcebd9W9yp5FAm/TAxEdetwhhLRHvdzEX4lFx3GZCthBwawfz8bsLT+c9y3vFdoaJVwzNAXRzDKkYM9nq9QLUtBGwDw5ge0Who94yMG9dv2az9JE5RXG11aORYsiuE/rUAvPBGjLOeGKXe43Nfl93hmqFZRlMxWKtF2vLD4M2pQdyP8FZFUrusrstzS7QRaxg3vskZaV6DiRiOVHbNZMpOMgYD7MF9c5Waa1xMrb2bpTza/4sUxgvw8yY7WqFgXirnII15e7mokoTcyGo1UIXh+vKar6QMK3nbWosKdYdkbiapkqxqobZguo9ycaTR8ekUnm/Q==
Received: from CH5P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::20)
 by SJ2PR12MB7962.namprd12.prod.outlook.com (2603:10b6:a03:4c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 17:56:31 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::82) by CH5P221CA0004.outlook.office365.com
 (2603:10b6:610:1f2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16 via Frontend
 Transport; Tue, 22 Oct 2024 17:56:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 17:56:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:12 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 22 Oct 2024 10:56:11 -0700
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
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ee0afe9c-3c05-4d79-a0e7-38d00fe30fcd@rnnvmail203.nvidia.com>
Date: Tue, 22 Oct 2024 10:56:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|SJ2PR12MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 180a982c-fb7d-454c-be78-08dcf2c2dc35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFRyaHovZ2RGZWFtZStES2NDZTNxRmsvdS9ZTytBWmFUN1QzdFplSjEwRUVW?=
 =?utf-8?B?ZGc5cWtTcUJ0R09sNCtHL1krb3dTUXFXaS9CRDdvK2ZsaWFyY2FpOGJJcVNW?=
 =?utf-8?B?bmRWbDlscGNOMDUzZlJjYjkwWVFtQUdVZnE0S2lqN1lQM2dQUGlNamluMk5R?=
 =?utf-8?B?UGJKOEdlZHVSZmZrWHpjejJ3WTVqRUE4YzRWV3k2dnVHTXU2Wm1OdTJiTEkz?=
 =?utf-8?B?UnJQQlZZTnY5OVJWNTR5UENXM25SQjFpd3ltRndYajZtdDlnRHNNdGg4L1R0?=
 =?utf-8?B?cUFGdUhHV3kraHNFbXdTNVZoNmx2YURWZVVDWGh0RWtYZjdjUEdteHJWL01y?=
 =?utf-8?B?aEVuVThrQWM1YUFoVmpuMVA0YVJiY0FKVS9GQUY1RkxaS2x1MFFxVEkxeFZP?=
 =?utf-8?B?T2RjcHBTWTB5RVExWmNCVE5TTjJSOVc3RWRScDVZdjY3ajNhV0p5TjFzNFZX?=
 =?utf-8?B?WWREdERZanY1VjFHV2cyZEQwemhvZWt6OHBkYzFDcnRTNTlXSWpkWk1rbGMr?=
 =?utf-8?B?ZWxobzF3UitnSE9kekxIYm53TXdIS29OMVFUajJIOFpQejVIeXNRZXZBenFJ?=
 =?utf-8?B?U2tRMlVGUTN6UDJJMTRWdmhLTUs1NFJBT0d0M2xVTkRwR2FpclRiTFBUOTZa?=
 =?utf-8?B?alFzK0NvRTBIUFdxOUwvdkZrbVduVlpJdHl1SUJ0UVFCaVpZUkZLdmVYRjRY?=
 =?utf-8?B?NDVRb08xWDZKS2g0NHlNSFJZVFhVTjZ6Wk05bHNqWXJFVW1PTVpUdkFJS1A3?=
 =?utf-8?B?WmtkWUtCdTB2dXY0ZXU5T1RBdXhpcmdLMVJROUJ6NW5pM3NDTk9DUzQ4TXlQ?=
 =?utf-8?B?Z1BoWi9RRGt0N2pCYzlrVUk4OC96aEJ5dTc4aHN2L3BPM1J6czJVQ3pwbEp4?=
 =?utf-8?B?SDV4K3VLTmZzcy9rQkk4Y1BLMkRBL3RDWUxieWxkdWdUM0prOUQ5VUIyTklp?=
 =?utf-8?B?TjhsMXdVMDdqaVBGVjFnVlY1Nkk2Y0gyYjVDWG5vVnRDbmpaNFVBQjd6c1hR?=
 =?utf-8?B?RWNCeDVUcHlTd0czZHZLQWlrNGVySkd2REJzeVY0VXk2eHlVbWU3S3Fsekgw?=
 =?utf-8?B?NXI3WXA1RzJVMEhNRFROY2xaTVNKalEvNHBxbXJhYXdEZEpDaXJzZG5aeGZ0?=
 =?utf-8?B?M0dKSGg3VStsZkdLZVRxZjJsR3BTdUpoV0JJRWhDdVlHYjhFMjB2cDMwcVo0?=
 =?utf-8?B?alhTRzNiSVhuV3hoUWlXMS9zSG1scDU0Qk41Y3BLZFNlWTV5NTBHc1g1N20x?=
 =?utf-8?B?N3czZjF0WlN0Tm56SnlRWnI2OUx1UVBKUCtpUzdwOE5zWGNxeVV4NVo4VHF4?=
 =?utf-8?B?akxTbk92dmRVQm9WQ0hMZkhBVjgxYXpoNXM4aUlZcmU5NC9talpTMUJnWWwr?=
 =?utf-8?B?TUQxMllFOURtSDRvQWI0SU1lbUFiUDZjVHllRVY5cXRwTFdpdVNVaWZseWJC?=
 =?utf-8?B?U3pLcjZhVDFCT281NG5XUEoxNDF6UDhrNFhDdEF2ZXBudVB2eVk4MVliakJq?=
 =?utf-8?B?Yy83c05zejQ3YVlReGh2WHdadWs4Y1k3bjUzc0RiZXdkekd3UnNnVmlKVEgx?=
 =?utf-8?B?c1doZFBSSGk1bXhwcENpR2hkSStjOE1pWVFTM2ttN0F3aytnUDJlaDNXQzli?=
 =?utf-8?B?ZU5BbU8wN3hIOHByUE1ZOHlaTUZvYzFEQ0k3dGFMbFUvaTdqaWpScVdJQUMx?=
 =?utf-8?B?TEFrWG5qQS92RktUcTJBZjJNcEkzK3REcWlndXM0RllHRUxvMUtQUjFxNUhw?=
 =?utf-8?B?S1NPTWJ6ZzVYRDE1SVNsdHdnVnd4QU1qVnAwbnJXVmlOZllVK1JqQmppdTFk?=
 =?utf-8?B?RVA5R1RISWZpSHVmcVQzc3RNSFVGQnpsY1UrZWdnVWFYVERaSlRINy9IcDRn?=
 =?utf-8?B?SkUvY3ZsN3JkOUZmSnBYT0NDZnJIV1IzamhpamsveXVlMGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:56:31.0135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 180a982c-fb7d-454c-be78-08dcf2c2dc35
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7962

On Mon, 21 Oct 2024 12:24:41 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.169-rc1-g4d74f086d8cf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
