Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B588F13635C
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 12:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749473426; cv=fail; b=BW2pA06T3L40eFC+ArzZ13HLX3nAFtLlYavuXS9YnHvu0oY9gcXuL165LINwR37k/HytRfcgZzkWOP3MY3qmO1C7mJRd/EzW1ZMu9ioTXZMaD/IxlpuUluSiQLhUKNt8hC6LbEf8ZCdvtAHUlTn1JdOBcGad3tjAMp/YQyQtPok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749473426; c=relaxed/simple;
	bh=6XmSr7yWqDWQ4l8+PuCl0Xv5P8it8lb9nT4lKwjdc/M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=fFb7sgoJSwCwNTwmC241DRxj/2dj7WaW213VOm6WW7yLGEzD8nMwir23uRikfwYOh7YAM7107xCi780aAo+3iIh0La4MnIM7NQZcx2jSKDOIIRYDquxClVG42X866iU5zYLHNW6Iqd70lhO09CgUVpibI5+M9LEHzD3kxvsEK+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZM4XT3d2; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZM4XT3d2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mYZpfgcV0qad3FKxR0qdS666Hw4ZQdGXNEaQ3hFeIjTdkexsyg4cvjiaS9nxkokwqIZei/Z5CYhpstUYlDXW20oPTpR24C4KobfySZzE6q+R/zYKrShA2bJdM21hduhzq6GasVUF9ZeqtWCxFaZ4I+cufWjCp+OV2SHOsIfBsk0nWfm2bb5K9lMonI7/Fc5KOQvGU5pw2qMGhUvMKyyqAQobgGW9CHZp0C1/QEBKiNeUvTglvJC/oun6BSn4KiWYnAmCvJhUUCZPVC1QXpFF5dMAMy/PB/SnORE+uLHY3D/LFodzf/jNP2c5HqvcNymOwvbqw54qkrPuyg6O0YKXzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqGUXXrKHhfnpSx+ngoFzQsfC+4iao4nxChfNNkxlac=;
 b=gKcvlngZgGI1Ba72bu+K5Q4w6uU6bCl3JOW6vf+yldF2U/lzPK6rIb2v+OtONLFZzpHWK4pPzs+i/wzWsuJdm1DKEbuVx2ObrJIMdqFAmjMhjcxLEBc7OX0Vki6ciMcgV7ZkYQVbL9l+EG8QV7UeV00vPul8fW9LNg8RykSyDtmpoMzgmntAdcOTyK6mqzcwvuUhETu4G6gBv+vYqdd3HHqTqLFKbdB2EHV1d4hC2Dipma7LNrkLLAeKfMM1WAstPG+LCfuBs9ESw/0ATPPj7yFl+c6f5Di0DlN99TL+z41y/18DtBpiy9ZV58a81ViBa25qnBT9iwQ/zUfJeWES5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqGUXXrKHhfnpSx+ngoFzQsfC+4iao4nxChfNNkxlac=;
 b=ZM4XT3d2IRLcLU6yNo1VyQtPk5mxWE8A9qyeUqG6KJFHoB4SnyHhcj2c1OODBE+04xfO5Omt5i3f1gtARzeFFO2x9uEANfJ5CjEQSoHiFwbo6wC65BtQDT4ZJoG9tIzgDqPm5uQsTFZNJxSWE3/yZBwGBch0s+H5QJMIj2OlfHSvOOX8K/qsT53wg7PX3hPZkbyAgXUeq0PBdS/+eqWKxeIE7+Hi5NzvT8yP0YuE5heJwqXWlK6nmn/K/UazbvS0rgQ7CKfOEy8iA2YKePldGvTFFwOKi722CKy2GCot+UZb9cj+gck3x+m8rCoABHMbR1nkf5yK6y/NHtIfYDMzYQ==
Received: from CH0PR03CA0418.namprd03.prod.outlook.com (2603:10b6:610:11b::19)
 by MW4PR12MB7141.namprd12.prod.outlook.com (2603:10b6:303:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 12:50:17 +0000
Received: from CH2PEPF00000144.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::48) by CH0PR03CA0418.outlook.office365.com
 (2603:10b6:610:11b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 9 Jun 2025 12:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000144.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 12:50:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 05:50:05 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 05:50:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 05:50:04 -0700
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
Subject: Re: [PATCH 6.14 00/24] 6.14.11-rc1 review
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <054bc082-8738-47e9-bf35-ed759010f361@rnnvmail201.nvidia.com>
Date: Mon, 9 Jun 2025 05:50:04 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000144:EE_|MW4PR12MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dee5b7e-631f-4bb1-b11e-08dda7542fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZW5mN1AxbFl3L0I3ckgwSDE5ZXc1aitBekpsUGZUTlVjeVlvUmNKOUNvQmha?=
 =?utf-8?B?ZklIOTg4R2hHQXJPbE5zaE1oVXdhQUp0TU5Rb3JzaVRJaFpkKzd0dDJ0a2VP?=
 =?utf-8?B?eE8ybnNxR0ZPZlBLVjN3Y2dqTlZCNC9FMHg4MjF6YWY1OUFndW4vaGRXY1JB?=
 =?utf-8?B?Vk9iczF6dGhsc0Y1UkkvZjIrT3VjRHh5UDVBOTNiQ2Q0UWFvdkl6QUYwcmtl?=
 =?utf-8?B?M2Z4TFozMHB4MEJHdGpZSjVheU8rVU9lRW1va1Bpdzk1UnNDRXJiQUZFOEdk?=
 =?utf-8?B?czNnWWxGLy9GU1c5WnlNTUUwK3ZnQ0ptMW5SSzZGTTZKZm9lK1NxZTRTOWcz?=
 =?utf-8?B?MnlaS0JOVEVwUEpHbkkwZksraUNmSUEyQ0IvaEJDcjRBYjVWWUV4eWx6Ym5j?=
 =?utf-8?B?U2tmWi9GeGZka0IzUm80VjNVZ2ZMTWxwcGF6VWVJUEdKMmxyWnRCRDBmQWpU?=
 =?utf-8?B?bS9Vc0NXNDNVcnZNT2NnZWpmc1NCdjZqUGJ5Y3VpQjM3Q1k1U0w3ekhmV2R4?=
 =?utf-8?B?YzNEcjRQUVVpN05VQnd3dlJUdFdkUFlIVmFmT0c4dzN5YzRhbGVOS2QvaVBC?=
 =?utf-8?B?RjBXdFF0NmpqamZXZDNkZitkTGtBMklZd291RU03aXFGU0IrZzVPOG5HdWZ1?=
 =?utf-8?B?Qk1ZMGE3VkZmcXN2ZGwzYm9hZC9mYjlYNjlMcXpDb2ZLVVI4VWRjeURhMVlt?=
 =?utf-8?B?ck9hdyszTkRZWUtocm1DWkNaa2I1S1ducVo4alVxNkxsRVBDc0hhVC9VVHdk?=
 =?utf-8?B?S3gyOHBnMi9RTkErSTVnQjRTd1MxNTlBMHRyTlJYR084VzVOWnFZVmpwSHVk?=
 =?utf-8?B?bXp0Z2ZsTVJHZElMWnZqOWpoUmkxbFc2akc3QmlHQ202clhvQS93UU5hcDVH?=
 =?utf-8?B?bWMrUkhZdEcvMzB5NjJ5bFZ4QUxFVC8rSk5mcXRLR3huNVVLYURsNWFQcm5G?=
 =?utf-8?B?Zm5mejMzOGMxWTFCSUpGamVVMzMwK3pWVlJDdWR1cFBNbHlac3FqK215b0Fy?=
 =?utf-8?B?bGZEdHpXV0NnNVVLdXd3Tk41OGlMODIwbHhpOWxWV1Bxc0JXM2hhZ2VIMkNU?=
 =?utf-8?B?Z0JZekJTR1FOS1l1Vjd2U3phQmZUNmNRcmpKbENxWDVYaWNuRm03TWlOSFgw?=
 =?utf-8?B?RGtBd2g0TGRWaTV5enBZSnczN3RDc01xWHlKck1kRWpuSHE5R0FITGV1RW5O?=
 =?utf-8?B?TWhXTnVFd3JPSFpFRXBON1FIeGNxTEwwUWJKNDZnTW1vVjVuZ0xIZDdXYjVZ?=
 =?utf-8?B?NTNOOVFBUjdCNkU0eGp5YmxWdXY3OVZtSldpYzNlVGZzM0U1VEwrYzVxZVIz?=
 =?utf-8?B?clJhcUxPd2NodkJMeUpSMUZLUnp2eVVIT2k2OWtnekI1d1IxNWFsUS80dFB3?=
 =?utf-8?B?NTZTYjAxNDdNS2lzWldidlN3V3NRYW5tOG5MTFVKYVNGcVdINkNILzRLek1p?=
 =?utf-8?B?OHZQdW53UGtCWHNBcUZoaDA4MVlhYzJRR3o5ZEU1ZWxqV3U1UVF0UkQ5dkhL?=
 =?utf-8?B?ZlhzVW9YSGhPeWF0TGhKSTNuaHl1a2hyNHRCampUcElDMk9SOGpVYXRRMVM4?=
 =?utf-8?B?bldsMVYyclduUUpzNWRDeEVqdkVpczVVUUorS3RMSzRDN21CZ09JSTVtWmw2?=
 =?utf-8?B?cUhRY2IyYVk5UlVsV241YnFKM1U3cHVmRW9qb3ZLRDVBalBaemV5amdIc00y?=
 =?utf-8?B?MWdBemJXWnhheENaYXh2YnlBRmljYjZMNWJPTXNZYWNEVXc3M1hCdEdoZXo5?=
 =?utf-8?B?NFA2eHc0OVBXREZSN2RYc013bUpXYUQrTlNwZHVvT1FnQVFUdDN1N0J0a2ZF?=
 =?utf-8?B?UHZ5V0YwMUtSWFhJUnBWTW9hTjlxMW9ZQ2VpTUZCZTc2Zksyam9GK00xelNw?=
 =?utf-8?B?eXJBZE5vUHMvQTRoay9GMkRvQlppalNDWk5YdHZ1WFFzTjZPcmFXanJjcFI1?=
 =?utf-8?B?Z1U3TDZDcUFkVU9TQ0RBRDVHbE14N1pkOEROU2YxYUZiTDZuWldISHVobURv?=
 =?utf-8?B?aTh0QUc4MVJrT0pSdktPN2FoOERXK3U0Q1paTFkxbGovSXcwSFl6SDRhd2F0?=
 =?utf-8?B?eG9BNVprRWR0RDBhVWhFK0d2MXAzMWhDUFl0QT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 12:50:17.6372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dee5b7e-631f-4bb1-b11e-08dda7542fd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000144.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7141

On Sat, 07 Jun 2025 12:07:40 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.11 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.11-rc1-g1927b72132da
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
