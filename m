Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4C82F4316
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660996; cv=fail; b=rlNMhfMOf2ajVA/4zBYZehbz9jtndF6N12uNHVEQt/uiqX6utn1eOHe2My407E8z558zi2TGmA7aYtyam2NlVG/ZqXQKz6sBysOWIixBBHa2dmdtoTJUYlD97RPRFQX0wTe6EZ9hSa/OuAnJqkGDPNOf8GppKmmybImRBbt22FE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660996; c=relaxed/simple;
	bh=dzzNUYJEfmXMV4nhZm2IuXxcCOdktmiv5ytbl0YytLI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=QKfs5RCkVLFiaRUVCeq9cePbqOZ3A2ow3natzLV7v1uznzyPL2PWwFz0qV5wnmydKNsRbUT33XJEiMV/A8xU3Nj7VEHyOKW2KhYKLkh4dvqaQ+H48/Rf2Jd0IZnwo01rRnw/a1ReLC5JCrzed1866hsloyd4rls+qFt+gL2Lgks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JaoGbZH1; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JaoGbZH1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgdOB9n23NLfKgf7AxsN52bdK4CKGEdoUvX33kpbZLXV9bcXaeVT3EJRQVM1oTrdCN+QIBnKDHAhGXfGozkG00CIyHLbkevMLr/g8AbdwFDIYKAt+oj50jjsvh9kW+38UUoc+3fl+Rt3OHS63sZAQbtdmjls1+D9F4aYVNuDxLRN/Aaey53tm9j5/81iVsZALMERK1IAJzSY6qsyoezicfwm7Lcjx2Sp1Wv1LPGisEaDxLADrC/1XPnrq2bB/tRA3he8/z3DwYH6jvVc9gkp5nBrwtSV/98Dr0bxB2OOz5yPhSzWRaAZR8WYF86mpO8LEQ9VR9fFIKQnSR/IQX7Maw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9Z24lAWFfAufPOh+jo8jczqercyWeWPrxnDBzQqJT8=;
 b=CfkzWXnz+f2KPh3Z/YpDzJlRehWzx3qZfx4+QgKIQm7E70skJhRF+yI6C8S4dHPA5KAkOMw8u3fRLmRWtGZA5VjnlKnE+f8DOsCUmCooztQ/jlSqccS78Zqc8Ye2seO5la2FgWrPbEcgPz12HNEQyF4L1NPyztldDKHFKH6tGRJStVL0E/jA9gJJMmT3w0sPNlazbCzGHGc2O90boo8qijtZNjU6OklsTwqh33ShOUJvvHWJHaxm+e0U6goBf0i0/0XC57KkpzZSVBYBzd3WPeTOJkh7XMtTjvUbNXumh7nGzCMwVbpvHR/e7ZtR/SFSrAM8W2EjHIFxe0bxNd+sJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9Z24lAWFfAufPOh+jo8jczqercyWeWPrxnDBzQqJT8=;
 b=JaoGbZH1tfnSH2oPAOa1MZa4ksujG7HhbEpgGgfWJ5lZO5PUpTX9joMCO3WlwaXSzTy0X8GqWu5+Gh7zGRfuSB+uY46RJ0IKVN6lbr4Ajtf2DO6o8GoRwv6wkfzGUDFj8I5WGpRb1tw8XCx4bm5COtKboxY+1PHME0ImHVcFemnkvfFQsFQ7WXHu0UILIGB6YFCK0XX3cAd4B/FmbVfYb5xng92B7PA+xPLAV1a1XW/Xvzd4B23/t5bSrSZy92iu9IHTYX3tBqMV5pO/CqeLKJ8mrALV83/36N5JmCFnB0oR7rKZXio8FUQ3rkhA/+ZfzZdEi0GbVihSlvCwNixIew==
Received: from CH0P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::35)
 by LV3PR12MB9438.namprd12.prod.outlook.com (2603:10b6:408:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.26; Wed, 16 Jul
 2025 10:16:29 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::a1) by CH0P220CA0015.outlook.office365.com
 (2603:10b6:610:ef::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Wed,
 16 Jul 2025 10:16:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:16:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:16:16 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:16:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:16:15 -0700
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
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
References: <20250715163544.327647627@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b334eafe-0598-4210-beee-384def0f2388@rnnvmail202.nvidia.com>
Date: Wed, 16 Jul 2025 03:16:15 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|LV3PR12MB9438:EE_
X-MS-Office365-Filtering-Correlation-Id: dd546bb9-9c21-4d45-97c8-08ddc451d4a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVNVZ1JoZlR0amJCb0N0UlZXeDBkSEJuT3VNNjlxdElJV0g0UVMzTUgxVktu?=
 =?utf-8?B?TlZ4VFhVSkNpQ1dsK2M5TERIQkE4Z1AxWWZiREpZWU5IOTRVK3JST1hzbmo4?=
 =?utf-8?B?QklqNDdWQ0dmbmM1azBQSFlTVnF2S3ltcDE1MGx1eW84MTc3STBPd1ZoM2Ja?=
 =?utf-8?B?bmJHaTFvTTk5RjVUWFY0OGZEVWFsaldySG1OVmNzL2ptSDR0ZklhK3B6RVIx?=
 =?utf-8?B?bHYxa1Y1MHV6U25JTTVOTExJOTBua3lja2FLRWtQb3dMSHhjTmx2ZVZ5RTl4?=
 =?utf-8?B?bUYxTm5mVFZsSHhJeEZOaUlzTk9HV1FGc2xTcERaRUJkVVRoWkRBcmxyWEdT?=
 =?utf-8?B?NWxPOGFxOHdFN0JJai9PSmhhSHJqYkNFME9qNTZLczNVYzg1ZFQvTGtKaWVX?=
 =?utf-8?B?VFdMYktqRHl1Z3duQkVMVm9oY3FtZWRwNE1SZXVpSGdFRUFVeWh1YllYUnhT?=
 =?utf-8?B?MnRoV1pnQkNhaEZIdUg1alJCMkQxU2NpZkp1Qmx4d2NmV05MbWtzOWhoVVpy?=
 =?utf-8?B?TzJNY01KUHFlQUhobkcxc3pJWE02M0Vma1gwTkc5cDcveE1kbm5GdW1HOXZx?=
 =?utf-8?B?Nk5xVlE1dG50bzAwMVU4eThjTWFwOEo0ak9mWHJhdEIxODZSSGF6SEgxNS9V?=
 =?utf-8?B?NUZRTVhKSVd2WDArRDJOZmRZeGZORUIwTzE3VE1sb2xPQ2h0d2tRbWhJbjRw?=
 =?utf-8?B?SzdoMVhaQW52c0xXbHVHUGFZS2U0cXhzSUpsc3dHL0Fhd0FzL29Najk1cTRJ?=
 =?utf-8?B?ZjZWZ0l5SDZ1aXQ3aGRnVUFWSlg0M01PcXFIbjNtOUJGQTEvbVFrWnc3N1c5?=
 =?utf-8?B?MTArSXN2YkNaQlRHMjk3WmRneHZ2TUk5VlBjS1lHYUZhQVUxVG5mS3lobkpq?=
 =?utf-8?B?R1pyVWJ0SUNnVmxSdC82K2s2VllEeFpJZ0RmODZ5OUZvWUczSzd0c0k3L2s1?=
 =?utf-8?B?a0pJZ05uUU11RWtzUUEvMEVCRVkvYXppekltcXJ2ZVZpeWxtQVB5RFFtLzRI?=
 =?utf-8?B?dGhJaUUvcTMwMkNmWkMzR3BJN0YwWHdKVytsRERTUDR2dGRjZUJVMFZpelF0?=
 =?utf-8?B?aXRkRGZ0VStnZHlLblpGemdjWmVvbWR1K21iTHpqd2Iwa01PeGRoaWRZU3Q1?=
 =?utf-8?B?YjdVNDVzMGRyREhwejZZTVZvUjVEMXlXUTJGUVRhNVhqeStJV21zYVpPK0pW?=
 =?utf-8?B?OElZbzVLc1Zya1BKdnJGUk5ET1pTdUJ0QktLM2hmRnFzY1NEZDJZb0dsV0NX?=
 =?utf-8?B?d0ZMaVM2ZmMrcGFxeGNGV2lYUVd4MXdlZ25MaDJDZUtDY0FBZ09DTkZhTzU5?=
 =?utf-8?B?RURaYnBmNkF5SEkwczk4ZkxqOCtLRWprOURMdFZhNGgrQkVwSzhrVzVzNHkw?=
 =?utf-8?B?dk5YeXdhcnFPL2Q5aHJBQlZxd0RwOHJZOTc2VTdkSllJdjFvc1R0Y0liU3o4?=
 =?utf-8?B?aEZFM0ZBQXpYdTc3NEdaTDRrdUVNUDhkd05RMkV5QlNHakRUM1ZWZVZMa0Rw?=
 =?utf-8?B?SjRHQ2dvQWo2azNHWWdtYlByQnBBZkI1OXNDK2daS3BQdUVQVTgxMVV1dWYy?=
 =?utf-8?B?aXFVQi95N01KamJCUk5hOFZMTmtLL3owZU9nU0h5S1I1Z0duTVR2WHE5Qm5q?=
 =?utf-8?B?c0RBTXlSVUFJcXRVaEVtb1hhRll4VjExY0ZHTElMQVIyVnZUUm5VWDJnN3Zr?=
 =?utf-8?B?UzQ4djFkRmptQ1ExZjc2dW9mUmY0TjdjcG51Y1dETG80d0NsOVdGM0RvTExO?=
 =?utf-8?B?czZmdDMraHZuWk5ZbG4rYU5KSkVKYlh5R2RUTGlCOHNwOXAyS1hka0pqa09V?=
 =?utf-8?B?SHFpNW5vV2NIUEcvcG5WaUQ4cm5UOVVWbTRKdkMxRys1UkYwdS9CdzNRUkJs?=
 =?utf-8?B?YVBsMHREenpyTmNMTy9CU0N0NnRrdUk4TDlwSDdNT3VtbmV3QStiVmRINkZ3?=
 =?utf-8?B?YnlxNmh0UUV3QUdIdkxaODNoQXFZNHp3dTE0eEMzQ1lVMm8vZXFneWl0L05L?=
 =?utf-8?B?L2VONnJxeG5JTURTU0FzemJtMnF4Z3hmSHlpVVdNRUtXYTExMCtkL3h0Y0cx?=
 =?utf-8?B?ZFIxbHpBNUpuYmpwYUpOZlBpOU5qMkZ6Z3VWQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:16:29.4306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd546bb9-9c21-4d45-97c8-08ddc451d4a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9438

On Tue, 15 Jul 2025 18:37:19 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.39-rc2-gd50d16f00292
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
