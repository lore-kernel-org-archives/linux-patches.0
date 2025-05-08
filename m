Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3769528153C
	for <patches@lists.linux.dev>; Thu,  8 May 2025 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746726124; cv=fail; b=X8NVO64rphW896rLOoUsd7DLLkD9Fqrp6OcDn3mNTjilKw5ZRqRl3x6yYqX3lZLpF+97Hys5F24l5hJRaOtRdyVM8sSljrtXo4bA9zazK6eh70/yAHaYm6ErVCrxQNPHKT2cBRb22qOMkkawzPLHnaAZ3HNvPvp0Y/3S5Lq7oFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746726124; c=relaxed/simple;
	bh=6qubscmoSf1MgxTMV0FDN1A3D/CcAabiLf477ifuJZw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RJWuyOjxIMy2WXTWiZ73E3eAETOTbzioEgwRXjD9DlxVDrBZ0iRqhaZOLFqnToTfF0fGa7+GSDoH0fdfF5sStpAOAquoT6Do/3EsRgxLH2fuai6esfIHZT7kyQ3MREMQiq45oDlK8Q3BJ8DjfDf93JYHwDz2a0qnvaMjVF2tNeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t10keYG6; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t10keYG6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MjEDik8Gf+tsJtq/0n5kpJ/o6ufI79mTD7qBhau6d4qo4XYSsMJBs4ch0ZFRwqUjf9HjhDdFDeVJEUPzXjGc0oZm8rGAccL1cWpQDDh26fVFQYiTDezjHAIXmSxqudITmTRcR7YMWekvHwHo/Cbn9aRor1dnZ2kwQ7Wbcmjyg0Tp0HRTelycQtnR8bE2NgxFWcvlfvWql5QbslRiIS2kCmq+HaI9bVZwcW1afKMUC/rtvPm8O0AOWeo89L59cfeAqIGNgiI2oWLb5AKoJlC/4hdAFxICMdl6ssFFjReb6RoeBBmDCpEDNETrrjz4/UnHy6F53Y6pLA3KNUyZoe4/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prEoUjrojpDsm+qUDLKkW9O+0I+7nzGBvyZwlcPKBaw=;
 b=qlAPwlRy6soHtNyxDVk28umbyVaeFdHm7FfCTO5blgwFMQ2orsBSnJu020MOC7tVnTxUk4dEitQNVu8rmZnYd/qhcf8azFTG3gpyVvVvuyQ5mCJxJ1tfohXOHQwpHqK1LxziYfu8OaJIzSwd1jxh51azS9YPrzcMLM3OTUxTZpUVRl7ig+xpPRFA87h8kBbBel9C3u6d9ZIg2iwJQwOcaIoKUIcLl6N6P9zPfj7Pes5OW7x+jcYYItY7CU9GyRGAU3Eezlt5kMKNNtFR9SBKSZ7blrQR5/VoykfIKM869PBfhHL5uT1CmjfTEynxN6wIJNKYP8+RwuF4DprBQJkfHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prEoUjrojpDsm+qUDLKkW9O+0I+7nzGBvyZwlcPKBaw=;
 b=t10keYG6ndM48WgJ+dXHi+uHVC14RVR9LlsMIUura3z4dWBaCDIh6G/fztkoWwYPjlftnA8bK+hQQUC/8Wy8FcSANysV/YrnH5PNZbdrRFrWi8l/JGYHqCgxYjnU4vkl1zirt9DPprNGc0s938HjLggyBdBIXmjhVL/IzcntlM8skYyA9SjP3zXGn8YI7/Ny/oDcXzqidZQ+WXTrI/XGUOZ9/pOWrbuIXWPE6Tywtmz3ftVYcaEjwGXrWqO/BKO5JS0XjitDE9AEtup9yjq0YNQoZrOpoL5qLOGD/j7a3r7JHQfH3BTI+HZ6J5/iIKDYc6O+qmITMpjYBKJV2movhA==
Received: from MW4PR03CA0317.namprd03.prod.outlook.com (2603:10b6:303:dd::22)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Thu, 8 May
 2025 17:41:52 +0000
Received: from CO1PEPF000044FB.namprd21.prod.outlook.com
 (2603:10b6:303:dd:cafe::10) by MW4PR03CA0317.outlook.office365.com
 (2603:10b6:303:dd::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.26 via Frontend Transport; Thu,
 8 May 2025 17:41:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044FB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.3 via Frontend Transport; Thu, 8 May 2025 17:41:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 10:41:38 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 10:41:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 10:41:38 -0700
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
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
References: <20250508112618.875786933@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <54f1b0a3-7035-44d5-9ba2-694d91d26a36@drhqmail203.nvidia.com>
Date: Thu, 8 May 2025 10:41:38 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FB:EE_|MW6PR12MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f469cd1-5418-4f31-0fae-08dd8e579df7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmJyQUYrZGVta0V6bUFoUlVDVU5SUzBnNDRJM2FjVWl4WlEyN0ZVUUhJWDYy?=
 =?utf-8?B?K0RBZlBmc1I5V2NNVTM2R1p1WVhCUjMxRDNySUwzMnMzUnJyVlh6VzExUjBZ?=
 =?utf-8?B?dEo0QlFXQkllVVZ1a1ZRMlF3amRuUUdHNjNCdzFEcVhxcHBVWXY2RGo3RWhz?=
 =?utf-8?B?RldpbDY0eEN0R2xvK01PKzdoV1pXSmNKTFFTelBaMXFSSmczdXNJL2I3c0RG?=
 =?utf-8?B?ckZ2cUY1OWFBUUVWNmtWaG9zOVVKZkFNS0lCVUk5N3hCTTEwd1VCblgyUEdm?=
 =?utf-8?B?RjQ5YWdSUHVKSXljMUJUT0dxeEFLL3RlZE13WjFXWmpCdTRrT1B3dm1IQjVT?=
 =?utf-8?B?clduRnpBTHBVbkdTOFh6blRCM1BWbzBidXlZajY5ZFJWdG5sOTZxMFE1aElv?=
 =?utf-8?B?VHV1WjBrQnpBcWFuRTQ2MC9URFNnRTNGN2xWcE9kTzZNV2xTcmNvQzFFbXMy?=
 =?utf-8?B?Mm5JbkVrOE16YTNRUmd1eEpVQytBUEszSmduYmpSNUU3clJEdzY2ZGhRVmtn?=
 =?utf-8?B?ZzFCcUk3ZDNSUndrNnVGT1lMSGxmeTNTV05BZ0RsMVA1eWpKM09GUG9SQlB2?=
 =?utf-8?B?ekVVYmxoMVdpbUVIcGVuN3I2Q3FVbkh2MmFEbDZBUHp0NWZZTEdTU2UvU2ll?=
 =?utf-8?B?LzBjb0oxSlBjTk4wVit2UE9sY2JBOXUxSlNCUTczVkIzMHZCYVBuZkppTWd4?=
 =?utf-8?B?bktRd2FRTkpYK1lPVVYwWWdHYXNLcG9CL0xpSEtxMng5TjdpT2dVcFZJVzlH?=
 =?utf-8?B?RCsxakljT0xFalduNDZmdVh4ajNPZjBOeld6cnlSeHV6VS9YR2NvNGx3Z2JT?=
 =?utf-8?B?OTZQSlExekgyQ3BabWNsUU9SYUk5NUlLNlA3Z1MzSnFkeTZCd1FBRzFXeDRh?=
 =?utf-8?B?V2M2VnNVa3o3VkNuNUgwcmVhYnFVcGlmRzN3V1EvajNUaFhGUEo1MWRwa1Fq?=
 =?utf-8?B?Myt1OXV6MWRUOE1kSU9MM01nd0tkYkVEL0xPakc1dGw0SmhxVm5KSnZNaGdO?=
 =?utf-8?B?UW5ZZm84Y1h2QWMybE1kV2Nna2xCNHUwWldpYXVWNDlpVVlwcldMdFBmaW9w?=
 =?utf-8?B?WHgvbVY1UmN6a0cvTHovMWprVjdrQXpDbG9wRE91SHAxei8xVnozMXA4QlNm?=
 =?utf-8?B?RjFXNDMxc2JJcmVtUEgvN0JJVzZkK2hONlY1U3ZVRXRJeWxwWnUzbGFLVTVU?=
 =?utf-8?B?YWZTWmRKU1dUb1lZbXVYSENVKzFKdUxWOThybHNEYzBTZ3VsaUhvTnJTdGsy?=
 =?utf-8?B?Q0IwMjViNzZ0YzBOL096NnJXZ2cySzBEZFhiSU9tMGo5TEdVNnhGYXJvNElo?=
 =?utf-8?B?dUdzbzZiTUNmdG91NENLN3hDK3lRVWtXS1RodFZmakxteTJOK2pkclJDV3dX?=
 =?utf-8?B?eDZpMzZEM3JnWkRkcXlpSXgzK3VVTTVCd0V4THdiMFFQRjB5NWQvdEJnVGdk?=
 =?utf-8?B?eHlZTHpGb1RNRWpQQ1J6RVJCTThrd2xsOHJzZ2ViSkFWSVk3bXJ2Z0FLOWtO?=
 =?utf-8?B?c2dtT2ppKzRNTTdlWWtQNFBWbnBzWWxuZmZmclMwWVUydjkxTllWRTM4dGRh?=
 =?utf-8?B?U1J1enJKaEsycUs2WXJzcWIwVlE3cDRqYnQwUkhHaTZKK3VDVGlnSXNNUVFK?=
 =?utf-8?B?RzVSTGcwU1p0V05MMHgvSjJyWUpXZitqbThtLzl5b1FSdFBuU2hoR2l1c2wz?=
 =?utf-8?B?WEN6RHJtS3RhTVFka016MXFoMTUzVVZyc290MUQ2WGxENXBySlF6Zm5SbG8v?=
 =?utf-8?B?UnA2dlQ2SmxjbDV2R0U0c21MMTE0M1ZoRHZkQmNZTGJyK28zMUpVeUlqdUlm?=
 =?utf-8?B?VW5keDJaYldvNFNoNXhtOUNNV3Fwbzgyb1RjdEpkUURhM0FMOFNFcEhBV2w1?=
 =?utf-8?B?ZXkzNHNtc3QwVVdicmNKb3VtOXV5TFNEUUY0SzlEMmUzSTFGU3NlY1NUUmJ2?=
 =?utf-8?B?Kytsb3dKRGpQcXdxb2l2TCtJVzBidXZrYkNHb3piZ1liN0VpTmhWMzZWSkhD?=
 =?utf-8?B?djJ3Q3JMNXIxMk9hNjkrVEptLytVcmNFb29Ec3RnT1JIdFMzVzFFZ2pUaDQ2?=
 =?utf-8?B?OUNQNDZnWHpncGM3S0ZQREtvekZtcWFlS3hkZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 17:41:51.8984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f469cd1-5418-4f31-0fae-08dd8e579df7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898

On Thu, 08 May 2025 13:30:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc2.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.6.90-rc2-ga7b3b5860e08
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
