Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71323A992
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526329; cv=fail; b=btCLHHBv4uMY7f6KUr7f7w9t7HDysoabqbFMlr4TMcrWuhMVpyzKEQEYROrYFKgeIIxwnEKEDeuLUOzvdosEdoYYtJEvM06StLsB6ut0UWs0x0CMNjNOU0ae2tHjn9RIxgl36EcZoE4ErF3a3yG70HrQeG5zOmSpeeLCiKxHQLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526329; c=relaxed/simple;
	bh=2AXb5BMCy9mQu8GgP+5JNRqPsLdcj73BbL9b7/iLVKk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RzPB6k1v7Aq5VmqLLkoSiEM1+mN/vfStXx5pEPOIGlpqoclL9+/XI2zmYdHJjkIaDT+E5G8QeGudLBGc+1ysOWt86wfA8PhigQ5bcWrU2BlB9zDDpTIKG0VXtJQ2aPgQnhSH66+P0pLLGmSPvi0fWpN9CnGMN0jarz6xDQhNxd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WOQ/T/ba; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WOQ/T/ba"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHJTQCjovWIeLxpMM1QAXeTIpV9tGP3FMI95y/p+FOriLDl/15HtWEVFi2XjVO5C5pLG2pFMkqywVuVuO/MGvwv8KO/RtfyrSQHlOb6f8daiS9z8emNI1Vy0vCyhDExFQyB+DSUbFLaJpc4iJ5slgI2RFF1AQoeMHNrLNGwz1PL3iJLHiS6aFp8+x+wL0VcyHXZhoS/hKOt50AeXykOrB1cZ7jVt0CKTsnyYUGA4BVKR9ZAqD0VECkptN6VIiW7imqt3z4svlhTWqJxhtdsWoniB3NB0hPIbqqfrndbMUU23GW/dDohpQ9+0D1nQ2dn8k31is765+AyQlVJ3Hr34kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gg9Xkhy50s7TECyP3/s2mmfiP1uzwF8e4bZsfF5mrHI=;
 b=FRNbhbLjAsTnwn85uwjLI25Pqk5UuvrO86U7JRw3U5uAdNNH3UOevJwHuhlNdKOFnys3bM526oZY2S9UmfA3GB7FY6xUwQZoMUuT4bFmmqIuobubQAtfVBhYcPkk/3Jo5V2ucy6lmz72WOv6bEgqQaNYLFVgJt4TYycKw46BAbpLtAn9Mmi8m8tUgh+0xxg8G9JFC5UTjUTTgG7ailIx0RJk3TOYM+fnWVXqEctqCu0GCWe78DlVk12PrXhDbh9o7tojHpJSTNThjwl8UYjtJm0WEBdhH9ZLXDaSzJl9emTnpux87Gne3rCLRe05MNhGMCGrK52ZlFO6Av5AWABvyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg9Xkhy50s7TECyP3/s2mmfiP1uzwF8e4bZsfF5mrHI=;
 b=WOQ/T/baW8FEDnrurZ2Q1OG/4/O6tkr7BjgNkFm6pgwyKPdsVlJAIqRGYrsk+BHCBuqbNGNWyuTkJXWpZL00dL34AhyhpvdlcXO/69vQAFXUm+4xFy7pO0xWC5pL3JEtIE442vs2q8u1iD6cnpnq1HWwzbE1nn45A7qvD+68gciPKOnR5E1F7lD0d4ueibER43v3TVAyV44j7ANMq32HYA0QrmPdxc8q/9KUz3WGY9tMsZCQyXkfJ2T10cIl/3EXwOGGX6HwQJs0otRi/26+99V7mnmd6ZkOygGwI3aq6Vey/bff++VNdjR8/QmMkVHEqFtF9gGPIvfKh9aDBNiblQ==
Received: from BLAPR05CA0023.namprd05.prod.outlook.com (2603:10b6:208:36e::25)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 09:45:22 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:36e:cafe::4a) by BLAPR05CA0023.outlook.office365.com
 (2603:10b6:208:36e::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.8 via Frontend Transport; Fri,
 14 Feb 2025 09:45:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Fri, 14 Feb 2025 09:45:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Feb
 2025 01:45:06 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 14 Feb
 2025 01:45:05 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 14 Feb 2025 01:45:05 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1c41db30-25c8-4340-b006-4dc51ad3087f@rnnvmail201.nvidia.com>
Date: Fri, 14 Feb 2025 01:45:05 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: c085d696-e586-473f-96f1-08dd4cdc4b88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWJuODh4djExaS9DV2pJVXM2NzZ0aE45U2F5NFNzc00xUGFOalRRNzdLV3Zn?=
 =?utf-8?B?d1M0cFpJRHlIblg0Q3dXeU9jUzBoS2UwRHRTOFk3eEhaZE5yUTJNZDJyZVZr?=
 =?utf-8?B?TjJIWTN1bG1WSVpUWGtSK0tMNGZTdk9weUZBeHVRYmE1ZmpSL0tQRytVeldu?=
 =?utf-8?B?MDZhNFBrcmFrSU5ENGRnbTBqWUtlTUJaZ1pDdEQrQVRIT2VCcXlDMGp6Z1Vh?=
 =?utf-8?B?d1psWFZXUTVWTXpBZmZtVlhJNEZhVUVzZXNSYldYNjNUa3ZXS3l5NURlQmVP?=
 =?utf-8?B?dFEwNHhFRXQ4dzNxQ0xTUW5mRVdVcDgxbjBMVWZuOXQ5amVhb1VxbjV0WnZ1?=
 =?utf-8?B?amFQQ1lHSXJ3U2c1eWdBcm9tVmcrVHJYb284STdweWZZS3U4VTNabytadTJ5?=
 =?utf-8?B?aUVzZXJTNUFtZGIwcHFvOHR2eDRMZ2ZTaDlBZG5KM0lIeERURUFpRDJ2YVhi?=
 =?utf-8?B?cVFaN0xIUzZtM2wwbnpORG1peFQ4S3RXMTV5RFVsS0Jac3N1aHp0c3FoR0VB?=
 =?utf-8?B?M281SEVSdm5EalFwNFRFQ3VmdHliQjRGR2pqZWZkVFNWZFY2UWtRTVZWOFNS?=
 =?utf-8?B?TENtSDFtYktCNXlEK21ETHdkVUhVb0EyV2x0b2tmbnU5NDZ6WnhyNGt4UVBj?=
 =?utf-8?B?SzNGb1p4Qm9kSDFzNjhpQjhGdE1aNFpqa1FtVkJrZzNQM0lIYm5lSkdDNG9v?=
 =?utf-8?B?SmdHUG9jTFRzWjFiWnJad0UzL1k1MjBvN3k0L1dnd1NqenhtMjhzbU9DRk5u?=
 =?utf-8?B?b0dGWHFZNVZvbUxLdWwxbTlNUGNmWURzNjl2bDZaRGJ4ekhSUVpBaUMyTGto?=
 =?utf-8?B?Szk2ajR3ckFIaG50Z29rMUdLUCtIV2tzUG1XT0o3cFJ3VGhlOW1HcllGeDhu?=
 =?utf-8?B?eWpqM1hNYUxTbFE1MUhYTVY0TmhYdW5jRkQ4ZnFISFh4bktNKy9MZmk2MjNl?=
 =?utf-8?B?U1lYZ1FsV3Jrcnl2ZmdHSHNRR0V3VWRHWkltcTJvV0duaWZSK2dmZEg0aVAr?=
 =?utf-8?B?UUxWMUVQYy85c21ZcTVsMmxUcnNBOTVldnEvaFNEcThId21Ib25UR2Raekto?=
 =?utf-8?B?Y01NTTZPcGxaOHBjZ1hQaGVYb0ZYOFpwMVpwdFVhUk5IRGZDQXkrZG4zNnAw?=
 =?utf-8?B?emcxcms2KzJqWEhKUDRXU1BDNmI2ZkpoSGtUVmpYRmIrUUhuVU1zZC9sUGs4?=
 =?utf-8?B?VzJQMzRYY0VDWCt6MkNiL2ZPbUNubXQ3MTJUR25PaXVoS2RnY2U3OTljcGxr?=
 =?utf-8?B?WU9JWXdvTjQ4SDhvK0NMeTBXbEVMNHd0UjdvZDdlU3ZhbHpHRUdsU1Y4SzVu?=
 =?utf-8?B?bkw1RWdzZzFLR21id0YxaU04blNxcHUycGFiQlFzY2wvNCs1bHBoRm5hQ2o4?=
 =?utf-8?B?cU1xeXNUMTgrV2R3MVlrUit0RXB4MVZtYzNBN1ZvS3UwM1luc2FQSHJReS9K?=
 =?utf-8?B?L1pQL0c4NjlPdW5ZcjI0S0FFbTBreEhUeUZoL2htN085WWFlVkVoaU1QT2l1?=
 =?utf-8?B?anB0K2dMaHQ5U0JTM080b3FsOVN6ejhENzNpVnZYOURDZENWUUdpU2lRWmoz?=
 =?utf-8?B?c0thY1JwZjd1QWVLRkdtUEt1OU1BZzJQU3NVYWZrUkxoWkVtZ0V4bXBoNHBZ?=
 =?utf-8?B?OGsrT3FPZS94YjVvR3pUL3lRVEFBcmNNeFdsQXkvNGloanMyNzdNa2dJUHBH?=
 =?utf-8?B?cWIva1ZPTUdabFFTL3pNa0pvMVhMQWtjQUo5Q0JSOXNrSUFZcWNDTHN5MEJl?=
 =?utf-8?B?cWc5TjdCSFZLTFJWc2hsdER0UzE0VXRQZUJGVEs0UlRkcjA3WlAzaUtHckpO?=
 =?utf-8?B?UTEwZU82S0NBR1JzQ0dNWjR1Skc3MzFCM2xablZjTThRZCtrTTRNTW0ybUVo?=
 =?utf-8?B?bGtKS0FhdzQzeFBSNGRBaUVKTCtJTDZ6SnRMcGxQN1oyQUlNdnh3NmpjbXJT?=
 =?utf-8?B?a3AzVEdnTUQvc1dKa3pvY1diYTFwVHVGOUNOZjFyczJRV0NCV3BIY3hvVWQv?=
 =?utf-8?Q?EHlyT9Hpy99/VrrL1apSfb6YU9ELXk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:45:19.8362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c085d696-e586-473f-96f1-08dd4cdc4b88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148

On Thu, 13 Feb 2025 15:26:12 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.78-rc1.gz
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

Linux version:	6.6.78-rc1-ge4f2e2ad0f5f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
