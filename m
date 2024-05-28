Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAED73445
	for <patches@lists.linux.dev>; Tue, 28 May 2024 12:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898513; cv=fail; b=XqpcKJYoiEMWCrHZSdbyhIKjxruDcEUe76Q6WiYodw6rCqsS+mP9g8zOkujIcHn3XXe/RlvI5i26vwZj/Ahq748wnh1j1ttURnL2YfpEGp6pPWqWIxz/0qZTeLZXpoZdMUlkSAatsNCn0d1BWuGBkMVmZQcSds1no5rKP9QgULo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898513; c=relaxed/simple;
	bh=kCnW8JLN7j2VfDklj4i19teNJELyU61vl1xK99TRt2A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dpsVlvyIACt9DYFjMJaBosFjheXADWF7jLW024/WU/zhV4fXvvsQRHphqzMsiwxU+IROTV2HColcMIkndwhqMNQ+rvmirpfhLRCxA/I4l22wLAiTifupYCe6D2urm1uUxJcn89mTpNVAzOpOMqSQ19fzd0Vlu4Mt16Ixa+EzW9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YZ8WJl3E; arc=fail smtp.client-ip=40.107.243.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YZ8WJl3E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbPiCwwKx0UJhDWNNy6Bp28RzI9RaMfwXudm8gSZAcW0UPy4eUE/kk9/5GDfGIg7mRVdovkW0a4ZCQNGRXkJFFrfJU8uZJTdJm/5oNzsXcxj3SZwYum20E19+bZJ39Y8xEGbkCcdvMlqXuUcVZpiOysB0BPDeaw7Dr+X0GxDOfzSW0+Xx2pdqi7zJQ1+4CWMpDXC3ZGNCUc9ScdP0B/FzufVUgRy+nJSQfVnt1XYf5TeCrnaAd3XBx5bp1AoiLerwNQo+2CqQ1OHZ+zTOfXZqgDNZrw9cLbZqPvUXbozMxhOmvTLwWeGY8K186uI/kzBNroMiIdlDAwa15yv4cD22w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8yLTYFbM0XLTiCshO0BZ98UjyiQxZiBh6QEkfzg794=;
 b=aMAy5q256zLxGSdB14pdRkQ8BrQMGIUusb5IiC5qhnTnpb59+J6CmRmOTg+6oYbceBbSSDF0P7JtV3ZL1g4+/mXwy8NAtVoK92zDiFsw0w6d797xCOj3M84DXPP+LWUO31DFOxZ6FNM/8izLxTCVix6xiu4Dr0hrqlT4zFdqnMNCG6cmY/GC4iWrOA3tEm7vB9vddDq01DHs7HV3IjqXQjHxamdroY5bD0sAKX6aqkHfSAbNuxlmorVnPm0PyDrR4UnZ8dDXNkMPTFhfXPWQf9ftpbLvAILBMU1KDE+kDavCAXMJ8R4FG1J9e6VNyKLDViUoHcTovWFOqZ/XUiy/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8yLTYFbM0XLTiCshO0BZ98UjyiQxZiBh6QEkfzg794=;
 b=YZ8WJl3EIeLCb7tNcnJCa6qOj9nZotKlbQz6b8/4h78gTT1pE55SBT/HN3wpd5uj9xl4m0cWpNTYuFsr3mcs4xpI3Xx5otdhai2sKDhmh1goNBXG5ZIP3t7xPa74vauRjgZ8EhsdUNmLQXQYMkRAmonG2Jr4IIdeXCuDNY5DQaA14QS4Q8b8YYAt0IzlPsNnf1wOLjmn6EW/wQCSTscR7hNAI8s+JYeX+Fb6wrPDduVx0p1D0FfvRNsZmVYKdxGN1d/QX6FlThF0vGLcc8sQuQiXAlY0ORR8aQXgOhUkfreDaZkb8gibGsrs2w2rOez+m7qiBPLJsvn7W7LvqXXqkg==
Received: from MW2PR2101CA0021.namprd21.prod.outlook.com (2603:10b6:302:1::34)
 by PH7PR12MB8593.namprd12.prod.outlook.com (2603:10b6:510:1b1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.27; Tue, 28 May
 2024 12:15:08 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:302:1:cafe::93) by MW2PR2101CA0021.outlook.office365.com
 (2603:10b6:302:1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.15 via Frontend
 Transport; Tue, 28 May 2024 12:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7656.0 via Frontend Transport; Tue, 28 May 2024 12:15:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 28 May
 2024 05:14:41 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 28 May
 2024 05:14:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 28 May 2024 05:14:40 -0700
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
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <51630f61-e5b2-464d-a867-d550328f93fa@rnnvmail202.nvidia.com>
Date: Tue, 28 May 2024 05:14:40 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|PH7PR12MB8593:EE_
X-MS-Office365-Filtering-Correlation-Id: d1a4c5ec-3d53-4cb4-ac0a-08dc7f0fd0b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nm5adlk1NmhzYkMwUUlaQVJGUENRT2lFb0R3blRaOVR3Q0VWalo1TDgvaUN5?=
 =?utf-8?B?NVYweVdyYk55cWlScTcvcldSTnBOZUQ2SitIV3A2Vm9PdEVQWndRNU9NRjgw?=
 =?utf-8?B?T0dwMTJVY1RQdGRuZGxMUGFuUjFVVGlMamVCR0RBYjdtVlBSbHhtUDQwVW9m?=
 =?utf-8?B?LzVVN1JMUVI1a2ZDTUhrMjdYYXlBYnJpVG1mMFlYRHZ6bHZ3eVExVFo5c0g4?=
 =?utf-8?B?V1FXRFBzMnBLZGJ0LytLS2VKS09wODh1Mk0vU3NYWWs4NWJrY01HdWZHd1Y0?=
 =?utf-8?B?clhVSjBNNWpYQk1XZXo3NUxRN1Zrc1pLUmorUGVCRWd0alRRSlNRNGRTN3lE?=
 =?utf-8?B?cUo3VS9QbkMyWUhUbnJzS0NjTTE1UEFqOUxrQngyS0xOTkhydmlRS2l5em5C?=
 =?utf-8?B?cktpZ3F2YlBWaHBKYmJVTWd6NGVOMERqZE1vQ0lKZlZhU3RqMnNWampJcUNE?=
 =?utf-8?B?SHY2SWVvTUdKRTU0eDdDYWtMS1BWS0dHakk3ZVBzY3hUa3NERWRkOFl4UDA1?=
 =?utf-8?B?NGxmNXdESEtSeWVlanMzaXpJcEZjQ25LQnlXeTN3dTR3U3JMK3UxOHpaVC9Q?=
 =?utf-8?B?M2h2amNpajh5U2x5T0pwanc1TGRiQUZlazY3SXYrQU5FTzE0eStqOUZMWE80?=
 =?utf-8?B?QVEyams0SDlyUEFtZUh0dmhJQStWSHYwTVNKZUxtNk80eTU0MHpDVXQyd2gv?=
 =?utf-8?B?ZTd4N3V2a0hBR2VtNHArKzY3UE5HWThSb2plRnF5dFdFK3ZVenpSbHNlOVhH?=
 =?utf-8?B?empEbm5tZ2djVVVjRjZaWGJ3YjVvazJ1Y3IwM3FXcTJFY1hhdWFmYk5UNjZ4?=
 =?utf-8?B?WVZ0TVVEQUxmVWpHMFNSNDlGVlF2TnhxWHQyR2NEUUxLL0twenp3SVlPRDBO?=
 =?utf-8?B?YkNSZjJNbXBHQi9uQjdWWlJ3bDNDQnN3aUJCVWJpSjRCN1dRYVR5VW10UTBR?=
 =?utf-8?B?WkZFampUT3JtOEVWS3gweDVEWG1CRGhOMEZTVVo1WEVGeWpuMjRGcXZILzQ0?=
 =?utf-8?B?cnZVTjI4WWFJbllNNjF3UEhtRnQ4SHltazBRRkhWdW5CcjhIUEZqZXowOWQx?=
 =?utf-8?B?WkxoMWlRWnJFbGkvMEluRFdmQVJNRnc0OCs3a0xNUHZqYVpqZEJLOXB6MGJq?=
 =?utf-8?B?Y2JLWkc4SkY2dUM4c0pRUVlwWFFLem1QYzBnOGloMVpRQUM1U0FTcHRVN3hr?=
 =?utf-8?B?WUU4amU0WGl4cW5Kd1VnTHFyYjY2NldmeDVQNWtpTXJwT1VsclMyVmU4MTFy?=
 =?utf-8?B?RDhlYWRaeGxmckUxNEdtUUxxSGwvdW10b2lESEo0THNkTDljSzVXY3VyV0cy?=
 =?utf-8?B?dm01RGVyR25hY1E2NjVqbEhPdlZNVVB5R3RqcEZ1MG1ITS9GYmRDbkI5UjAw?=
 =?utf-8?B?SFF6OHdVR002QmRYVGRjTitNUzhPWm9jY3IwM2NScC81VW1TeStZQk1MeXRP?=
 =?utf-8?B?WmtIZ1dRZXJRRkE4U3p0dGtuNlE4UzFpMG50dkt5TmxDTHllOWQ1TkVSbUE4?=
 =?utf-8?B?K0NDMkRGWjM4K3FwQSt1WkdpL2oxWXJOeHducHhFM1F3SmNtUmJDK1ArSnlU?=
 =?utf-8?B?Q0tFdnZYSmJTRUdjVi9SMUFDMTczZEFqbzduWkUzYWFraGtpbWFkSVNUTnFO?=
 =?utf-8?B?aTFXWVUwcXdyb1VwbkVVOUtrU2w3R3ZQbG85WjlQaDZMclRwT1N1NVkvanFx?=
 =?utf-8?B?V2RSb0JnWkUwa1V0azZmVTkzcjhLZW9lSTkySkFNVkVIc1JCM0kyK2NIUUpH?=
 =?utf-8?B?c2hHb0k5bjVjZWJaWEhZZyt0d1BHdHBRSm5Ma1BaZkZhQ2s0K0U4eThaUzhl?=
 =?utf-8?B?Wm1IUGNZcGNqQ1UyVFN0UkFEYklnekpqQVpVWVZtblhZVEIyMXNINjc3cmgx?=
 =?utf-8?Q?Hgan+aS2JjGAt?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 12:15:08.1830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a4c5ec-3d53-4cb4-ac0a-08dc7f0fd0b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8593

On Mon, 27 May 2024 20:50:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.3-rc1-gc1009266618d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
