Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BD26CE2D
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759583396; cv=fail; b=bJ3Df/EtYMnsa7r/b7WVZCuZjuETX1TMCNvT7vd+j78zb5s0glRGy+Zz14Agnb0B3w+1i4c7MDLqfw8KRjvPkxZYYoPU+i1Mbvj4NHl7taHi0rHKlBa29HWLpwWmeVcBEqIgyyvjBTED/Uyf797nLXguHajpdjcjdSvi/7Db0+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759583396; c=relaxed/simple;
	bh=hS9TTv/ThO7grY1UcHojDKcjWoTFrVVKaYzjlEYW7hA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UEI9e+2jKXJTMj2jpXiZV7RQjJUnKDqdPMjk6tbGQtPJyQoWZcnHT/WBbD+1aAa2cuaUvOIMXpHFYRHQLlQbZGzzcfFnaGzRwaY3BffquWLaungc3v92dlnHPMZOc4et7OHLyH68AWDSPI+DE2cxVJ2BrBOudtStLH5wQh5IslM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qA1Di1BS; arc=fail smtp.client-ip=40.93.201.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qA1Di1BS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yICr6rXvgFQSJe0l6E1D+6FW4Qwg7Zn4mHKT4qOl4t4tRcZa4+GE7Sq/+ccfGTtrTE2ZVNFRgAw38W4xmohMRLxb7GzRmmjQ1PkP3poM5JhzrxeRTzT8GuJwYHf/X4uRPC8/dNRiJmssEIvDoqzGR1CHhTLs76GHF1rxFgvjDxpIA1W0+jBhfPCNCwujZHIX62ZZaL/d9lwLstIZJtmTimhAgmzG8bbGIITYKfGgLiY2UapIg+KNq/gZt50nzKztJY7VfNohHm8FjTy+YrIlMp5bcpM7Sp21RgdT3E1YPj/E1BMmSXDFHKm2DZJhM6J97rgq44A/Plks4l2YPdwVhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQCS4Uc9bh/xMpNDiopngMShjMlqK9Qk/r3G7vaxcJg=;
 b=E8ToA4/p1ie7qAsFbA69mYWAu+8CPpg+j83aFqk27DXUA+cBHZyI51hYJx5QNEsVOKmCkIm6bpnZnrf9ZKD39s9owGGgNhQ4x4yxCUwbdGLi+eNR1sB/RmBIcEtQI4aLP2amkeN50xeUM9VP56HClu3u+YjneU9MxqCMjF8PSGwKfa/zNLTjGFkDDK2+fowQVYZqYDjxy+rU/8miHWYZ8shn1xhKF6gSRM1JoJYFQq7SiWkv63+4DlkOyCAvMVC2kw0FaHeScBcw92ZMEsHmu5t6ZtpslDFdesbepWcMGC2a+a+6uiK2x6ApGbpaLb6yOIMbqnJBZT66/RP7J+bMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQCS4Uc9bh/xMpNDiopngMShjMlqK9Qk/r3G7vaxcJg=;
 b=qA1Di1BSGe/9fZEcS1sejD+LlM2G0EjHXO3zwrdXPL/KNKnyCEhpkMGhpTTfgZ0r+v2yQ8nK3tMDt3k32ryiCTjVFQRsMNwKP2ZMysGQxsD4QDf1mNbf4WMpacQnQeqwfOV7q2zv+BrfbkpwOj4tFPGkCnlofGEgPjOmIrpTPSsQEGzngKLGkhJK6hFjIwFjMw9+BX0tk4LZfCqE9juIJAhDZeC2p7kPf+AC1K2vOIL6Rea3A5v0OhjEA2EfSwNox6TyPsfbF1u2+2mpwq9AOLCamNqiP/NA+QWDx+CboA2SV04g4VJif2rPCI29NGoFgGYGT4xoDSNdeP0iii5bYA==
Received: from BN9PR03CA0187.namprd03.prod.outlook.com (2603:10b6:408:f9::12)
 by IA1PR12MB6433.namprd12.prod.outlook.com (2603:10b6:208:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Sat, 4 Oct
 2025 13:09:47 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:408:f9:cafe::f0) by BN9PR03CA0187.outlook.office365.com
 (2603:10b6:408:f9::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.16 via Frontend Transport; Sat,
 4 Oct 2025 13:09:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Sat, 4 Oct 2025 13:09:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 4 Oct
 2025 06:09:44 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 4 Oct
 2025 06:09:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 4 Oct 2025 06:09:43 -0700
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
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <be0f2c58-3b18-4db5-9c1d-eaa1ec9955f4@rnnvmail205.nvidia.com>
Date: Sat, 4 Oct 2025 06:09:43 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|IA1PR12MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 18824e32-8260-45bb-05a9-08de03474b62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDB4dHVFR1YvbDFvQm1qYWhxSWFST2VzWVhaMms2cDYyZEQ4M3pGUXJGY25I?=
 =?utf-8?B?YzZkaDVocmx0SG1rREtDVGp0Vm40QkN2Ymg0NXlxdGNmcTlxb2ozV3pjckpw?=
 =?utf-8?B?SG1RUERvMTg0a3VtOFh5OG85d0R0SDFyUmU4dzduSDVGY3k5VGRuN2dqNUFo?=
 =?utf-8?B?MDJodTdFQmhCUkxvTWF6S0c1bzd1TytsZnJTMTNEQ3NEWm42cTRkclBFMWtX?=
 =?utf-8?B?QSsrcFh3MW1VRENuOUp5SWlZMkN3SmZGajJHdTZJd1l6eVNERnFiZWZwWndl?=
 =?utf-8?B?NVJmMGNpcGh0T2h5R2dXOFRmMmFjempvN2wwL1ZjNUNMOTZwTDVTaUFRcGVJ?=
 =?utf-8?B?Ly9OWkdwQTdOWUZVZkZlOVduUkZDQnFVMkVQK05YYVZDNXROaC94WUgwUkk2?=
 =?utf-8?B?cmZxdDQ0eVpLYWZlTHgxbUppaHBQVWEzQ0ZMQXo5aEpnRTB6ZVhpRGlUb2cw?=
 =?utf-8?B?WmFDMTVXM1Nxb3oxY0pSVlZkMHhaZS9PM3lZYXJwc3FSZzBHQk5yNURKR2ta?=
 =?utf-8?B?UFRPbFBadHR6ZUxyTHJCOVFIdktqb1JXaVlsNldBZmFhaDNEc0hFUWVVVkk3?=
 =?utf-8?B?dUQ1V0d4SWIxWkY2eS9PRlc2b0cwWDVxRkFwVlM1dHlmbXBBc2lzWFoyWk1P?=
 =?utf-8?B?K1NMSVlHSW9aRHpLNk51YTQ4V09sV1EyYjZ5S2pDYjIwV1BsWCtCUHQ5aTRz?=
 =?utf-8?B?dGxVZVh4NjA4ZXl0RHJwRHF1WUwxL1d0QW0zM0VwdDM0SWRTMmdZTlovUG1r?=
 =?utf-8?B?dmVGQUgxL1dDaVMvOXJqeVRISUh3K3hJZnY5YzJxK1YwNUxzYm9vMVNvQzV3?=
 =?utf-8?B?TUxWcklRS3VORGQ2SzJ1OUhiRm9LUEFuME00L1UwQXpsWEVHVTdoR0RoMVRv?=
 =?utf-8?B?RXVqT1p1NFp3UTJSeTI5QW5hR3dtcE14emxzQjVRSVc4SE1Dc0QwKzRDTVNz?=
 =?utf-8?B?V0JLbzBWTjdxdkUySTZrU0lTTCtDTDg2WlFHZUpKTkdRTk5sd3g0azNGRGdq?=
 =?utf-8?B?WVZWT3J2TlY0VHZ6SFFRYUZxcUVzZzVDM2tkV1hXKzd4WFF3ZzU2eWVGNkIy?=
 =?utf-8?B?UDJFRjhQQzY4ZVpXK1Vhbk5xNTJKTGFCRjlJS0txTkZRZVFsbXhTb0oxZ2NB?=
 =?utf-8?B?blF5alRvTTZ2cTlGU3BsdzE1YWtrMUtDdWxTVCt0Ymt2dFBGNU8zV1k4UDY4?=
 =?utf-8?B?VEpET2w3bW1YeXFpVThaZ0JhSHNkL0tMNXFEU3R1aEcxQlZYUU45YWNES2VW?=
 =?utf-8?B?Y0wwVUxOUFh5ckREV0JDbFozWHhPUmJNaU5CWGw3VVJGRjNxOE8yWHc1ZGM2?=
 =?utf-8?B?WFAyYkJIdjhlY0FPVkRwRHJKUVhPZnJpWGlhc0FoUU5vWmpVN25Bdm9TV3RC?=
 =?utf-8?B?OWVSSDVHajhGcTRnRCtKSDhWV09rSjI1T2hINk9JWnNkTXhHcTVSaTZlbnd3?=
 =?utf-8?B?WlpoMjNoa09xZHR2UklpL1g0Z2xTelFYbjhoZGxIOVd5REFUaGVxeGd5N0xz?=
 =?utf-8?B?YlVGVnEzVWpuQkhoWnRxVDRIRzJaRm5OdVJ5ZnFndS8vcFJ5c3BIMU9MQUkv?=
 =?utf-8?B?dnJnTXIzR2U4ZVMxakpUTDdUeVMxRUprcEEvdVdscUtURFhjc280b3oxYmhJ?=
 =?utf-8?B?dEZ4RHVVVnk4bWRlR0F1K2FPeUwrVDluYlNNWXJVSWpEazhXeGs4bVBNMWQ1?=
 =?utf-8?B?Tkg5bHRnSWRMNEtYSVJNOXBVZE1RRDFwcGRKeTdUVTZOOHJRMzJKUjBweE9Y?=
 =?utf-8?B?SUpGU29weW92S3FlYUdoVWVMdnNvL0ZqSWNtN2R2L1h3Z0QyZUpDbkZXcXhv?=
 =?utf-8?B?MEFpYlNJRFpJL3FiSU1qVFZzS3pzVzRaOHBTZ1pwQVhrOWhQcW9BaXdMVTdQ?=
 =?utf-8?B?czhhYkFEZWVoRlpOaEpSZVVtY09kaVF4WXFiemVVLzFwdHRYR3VUUm1MTXRx?=
 =?utf-8?B?eFFOSDJzZjgyMlVWOStPaU9OaDVZS2MwTVIybmpjMkNkTWNyVmx4d2kxVHR5?=
 =?utf-8?B?SGpaa0tDY2pBTHJPcVN1VXllMTlOY1NyNElBcWZTZW5RRXlNUGx3eU9qRHdi?=
 =?utf-8?B?NWMyUnZ1bzU4NUxCMSs4RWtTaGR0MThnNEdzT3FYTlJmZCtKNUppWWdnNGF6?=
 =?utf-8?Q?CC7c=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 13:09:47.3726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18824e32-8260-45bb-05a9-08de03474b62
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6433

On Fri, 03 Oct 2025 18:05:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.1-rc1-ge7da5b86b53d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
