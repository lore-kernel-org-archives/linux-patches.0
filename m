Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAF13C3BE0
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547167; cv=fail; b=kajMYqzeQJw4OMNpHLEw0XQLyh9oR9AiV4/qP53/UW0wMwPOR5PT1zV99a7ZQ34nZytQucWFATK0FrR+GMsNI9MF9pmg2GqvKfXoLCPe/ODculH2PsSID9pRoqJRUUfhNM4DxveSBavL44gQ9FuI0nGAx3dcAYwkE7kSTp+Rnnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547167; c=relaxed/simple;
	bh=GyeXdaZCUhXYooJzkXzvhd1zEaq+MHQwcPiY4wisSg8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sDCOIjfRjZ8+xg9MRaE/GlbzxDLB5QODS3RBQZRjch+B2OnrgQjmMEPsVzABuZ21JBPkwyRv8M0CqItkubuQoQI5sMqVpz8G+10GXSXkayyZHx0jPotQLS1NpFOA8Pi34xjd3bTsD9hGm3i/Pji3Hlyl4/OhdF04kOOUl9gH9C4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e9N0nWGi; arc=fail smtp.client-ip=40.107.200.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e9N0nWGi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hqLOVPVrb4nyw6Ve2ctp7gS3EquKr9ic/XC0djPLyOL7Cf7X+8H/5vQIjEfP7QOddaEiz3KjY9m0KVlevRTYb6TUOycG/h7yzDMSyMFiIbs845BvozuEzcE57+D7HzPr4rOKIVsX7jjxkh82T1OZKzOl54YF2miZOtv3BEGhXiF4IS26KFEykwmCn3HeK2U1VIins+mbIgaRZl0J07A3fuu8aB3i9CtB39aNN02H6osgSj2iealFLHU3REiSo63eL58TJg2FMA4wSnCXSrONzo9NkpPMXLGybDeKiDhyJ2xAurgW6CaP6IC1mlD8d6HQ5L6MHNFbsxGWG93XxBDoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j38HwmBymuHgGmuz2YPbQkSadBggcZo60xZsfi5f/Rc=;
 b=oTTYvcQ6pfmP64RvDleVr44SAXw0f0GlW2mXoGN9nRUgkGgeZE9wZrI5q4t30WB6X6QCypBghDTchZxLO09ZcEwG65gUCOSKm1rsqRB5jZb9PQ7NGn4OuDByHDVx8+jC7BXjIreb9GamFM1EreAQ/+IvipamK0IMy6FJNxOOCuPPC0SOYbtZVPssOnmhEBWzJNBI1Rop4QpK3bNbJlsfWxyzT3uD23sK1PEhufEGhKFME7X4VsgTEk+WTZXT6gFc3SS7Rc0eqYS7AWHY3OwFFlO4tKyZh1ANJyMQ4da+qUWl2GInmzC4bJth+dDoTOkxbVbVD2rSRoG6QFZsxn3ceA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j38HwmBymuHgGmuz2YPbQkSadBggcZo60xZsfi5f/Rc=;
 b=e9N0nWGiCq8oAEyGy0sYsYb9eLiraMIUGbrjvAVctBiatJ2eHKaLyzu+bz45ZxZf8+SFfug9xATlm/jOzwuxEW6AU51E3la9dEr0en3XyEnpzDUmBwW8+1NB9rPQp/l0nSukfU7AKX96H0UzY9Qsur7LHw1vnXtjulTvsjN1f+Fg9O+3SxROJEKH0WsOPVRhtFoocK8Ld40f9uzkmP0QfqM65ysA5Ahqalyg1gwhGDU6wPpkEC/RtSgEXC7fQKxovQdAPF6Msh5KgAyvLc4s3mOzbiq+AMhMPDsgZAAXbO8lcqro22UtcACGysMK2TC05n+q7YCJhkdPlcu536EsBQ==
Received: from DS2PEPF00004566.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::508) by DS0PR12MB7745.namprd12.prod.outlook.com
 (2603:10b6:8:13c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 14:12:32 +0000
Received: from DS2PEPF000061C2.namprd02.prod.outlook.com
 (2603:10b6:f:fc00::215) by DS2PEPF00004566.outlook.office365.com
 (2603:10b6:f:fc00::508) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.3 via Frontend Transport; Tue, 3
 Mar 2026 14:12:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C2.mail.protection.outlook.com (10.167.23.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:28 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:17 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 3 Mar 2026 06:12:17 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:17 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
References: <20260302160943.2522184-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d2d58051-1a56-4992-9798-417b2fe526f0@drhqmail203.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:17 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C2:EE_|DS0PR12MB7745:EE_
X-MS-Office365-Filtering-Correlation-Id: f44fdedb-a83d-4515-4a3a-08de792ee72d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	LxloSCoGgLsDw5kaB/NANjjJVsEYi9lasEjWxOS6YKeIHIdQwoTjF5vwz3u6qFGSqKeLZMOCQL8SDFkroLlxzNaxv7YQZkp6Sb9NBn6fGZog6bm7aZj4E8T9jSqXd4lrN1dCsVHMN6mefkVgINS9uEh4ckGH5vOUnr0DltdYSuUqpCKALaySQYuqiBTXPw6BC0LYPLbDkO2D2KScDKR1BqwDclYIbSII/10fRQ0H70nCJSLoQ+5kyO7ox7r5CWwaAPG4ULDDg2i4ksWIvgj0EOAygGNMX2MSYfp0JH8UcnqBh2rLim2oDlhlPcLzB8JgFRqCmT85Pe8d6wJN9OrrXqi6UGr985eJcyL29LfCvvRKOGDGq8biwqZetoawyS/KnHxG15tpzVAbEgFzvR0CfZ1TqpMkm57F7mtrnKki8leUPF/xZxxYujuoxyBo6ER0l9cDMlXHz7+z7D/I2JHmsKvtuO/2RM5RUeDeyQqZBAGBWMDJzJ3bjqR0xCPhuMsfd/PQ1wy7qs1zICyU567OichcdAR+vaMH3gKVITv8iXnk5joyVtzwZYHTnztKy2oryX6id2P/rJ7crjyiHlgb/I1fTxGyZW+uYVY88W8fA5o7rTByODxnCLB0fgo/EJydFE3da/e3SHqsItTusI2HMneeLv6kI0lUOvsZagj2/7LwhIhpH9GAdeji6LG7oKS0b7vqFPFOh80d3rhFgXgPqbJw7sNFzB/AKVG5qCivKydS7VPU++NXw8DfsKPQJBNwHI+iymJKj/GFASSWcf0wU7rGLVM1VRIHKaPvt4wSF3xLIWn1mLHlIM+zmMrcm3DgomiOc2BSfqRaw5DvgnB2Sg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oUC9Xxw/5MYCOdDCxVMXrQemt+AVlNEZI4VkYtNgW2e+h4Io0Uq0rOEYpdDw8cg4HL60+w3c+QNgx8AlaiX/ok+mt+5eXAjcd9+zxsERGjmcjz+hXnuG9VXDinMJjXENFD6MUEC2r4MBOQongyfXmtlodzLcBU0YFRe0Q2MqSpTWMM+E4WrsVOnB+CfFpQ9ALZWetYpMMv6dOajMdh4iCf8xAHkl2H/e1Ue+axfJRmMTKuQnXC3ar1ExCJXWaI2pdff3dR/ScMIdvvSdbkbxBg+O4iOKsd3VNcxMmN8g6q+wSZafj8DBTGFaVnABcTe4BS8gvuj4I+dIlmi9nkVf+thhm1D2o7VfY34skTAGLTEp7I0ei3SoPTIbqzGNVsdYpImU+5lqVRLPj/s67fA/jllGHIAxAG+QDPCfYBqf9vFvSc5xuzBf7hutLFXOvrim
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:28.6129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f44fdedb-a83d-4515-4a3a-08de792ee72d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7745

On Mon, 02 Mar 2026 11:09:43 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    132 tests:	132 pass, 0 fail

Linux version:	6.1.165-rc2-g57e92ee8bab0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
