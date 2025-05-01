Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FB121324E
	for <patches@lists.linux.dev>; Thu,  1 May 2025 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097676; cv=fail; b=pHGVfvrcZ7HkE8yFVqlr0Q+wCX+n5UfV2ryNKgYvSJzYFsLyC9T9FIS7imSquo1sdKzJHpc+pWGy/e9OaEmdWW1442vYCmhQXmCa5BAZ0W7gZYh3olzSFdhVqH0wpi+t1nbrvJgoi+//1MBGEjCy+EnzCxoSqCtzM/BbieqW6/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097676; c=relaxed/simple;
	bh=8Cz3UwIxT+cuBGg4ZHGB6Id2Mu0EIa70AAM9NidKeg4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GGHyzNrNgHusq69D3D48mJX2K87Vz0WojMygIZdlpszcE8g9qyAxdRhGKTiBjoxWB2pv572aXXO8U9/OcyQ9VuCCX4jyFNI6vtF0pXWATKrUSLTjzQbtKZ+BJQCw530kwlzagrtlMzGXYTRTIgoXPtJ90Y7ehp4taWj05y/4K/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kH3mufg2; arc=fail smtp.client-ip=40.107.236.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kH3mufg2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcz2sl+QZRRLY/Gz8XDhg8zaMd1yNmLnz7Wc/PT/aTCmJZ+Q+invozs9nIJIt3ss34WMaYDTjzgOlWUUjVSLu3aKmmJnVblz3TVOH6zLFaE1IrDg34aL+3wGjFUEzpGj07M6yZdiFNWeRnDeajfR0WPEIjb50Xxnv80fxkfplP8qpiTo0gdr/7glEc9Vw79sss+iR/0e2WKEDsyeVgP3n278HPMWfXOrFzK8DpxxASCQZVMyrabXPLH6/d0WIMUxPZl8kKDFnmtiKQJ6JG1dYYuqP1oJ+Ias+Vrkde7CR9cdozMBLM99SCqVd557SSOY+SWw09vrDb4CaZp3whQ96A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hu3pceAocVi8E+MWOcUPFZ1qYkMzzHckVbpKasCTw5k=;
 b=slyAivpFRpxIQTIOeW4wwcm+VLhv60+dDhANd9kNhhzyGnE6lQ4Wv0K/HO/ROwwzcV2SKeYGqh8R+HSlPMGrTwystzckYn9pLahOAreoDAJ7nQgAppFKsgU055VAZIHIuD5r3MiLhbLkRKaXLJBUVXx3UHe4aU0fPKdNQNHNngeJ7UEujU2rsPmqn++QRmlwDUBr0Jm5VIHlDM94Jk1QScgneWrhLhm4ZMQo9n5zfUIJo3Myv0hFAV2YbM3ShN4o69PCXyEzO0ckV3TrE2/byRjvWjcCK0zaEB0ujLZ0O4O3wOmh0K5zG0UxJHRP8l3/pyRQ1lxKqdYMFqMf9vmg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu3pceAocVi8E+MWOcUPFZ1qYkMzzHckVbpKasCTw5k=;
 b=kH3mufg2m3IW6vviJq8QN3cFSArNk1Pp3V/QfxYHMa+HLaBRnymBE790wq9nGtT8j1TTH8hAAaYXP5zmnmjPrDAkP3NIsEtftqAXrwe0I2Npl7tkSPUXAswpXy/tSivQpsCn/kKKKyDBY0vGfDLAVm2bJknuBgx/iPN17vJvjCJUSrtFACG2TaiP+lp5Cc9ck5Fiyd9ozV1v9T91S2HMn/Ef5Ls/nZ9C9ytZtTQ/LFtKHs9V4mzltFleqgcG+/XUokcNuNfzsj+QkaVgB2ILsKER+zPJSgUh1A7Rzl9C2es0MAtQwoN+cp2xn/Pkha9hp9HsEogZtr4KnP25pfSVjw==
Received: from MW4PR04CA0109.namprd04.prod.outlook.com (2603:10b6:303:83::24)
 by CH3PR12MB7620.namprd12.prod.outlook.com (2603:10b6:610:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Thu, 1 May
 2025 11:07:50 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:303:83:cafe::33) by MW4PR04CA0109.outlook.office365.com
 (2603:10b6:303:83::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.42 via Frontend Transport; Thu,
 1 May 2025 11:07:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Thu, 1 May 2025 11:07:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 1 May 2025
 04:07:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 1 May
 2025 04:07:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 1 May 2025 04:07:41 -0700
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
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
References: <20250501081437.703410892@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <45145a98-153f-417e-acc0-aebddd2e7fcb@rnnvmail202.nvidia.com>
Date: Thu, 1 May 2025 04:07:41 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|CH3PR12MB7620:EE_
X-MS-Office365-Filtering-Correlation-Id: b710f065-40fe-43cd-acf4-08dd88a06941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RW1rd1Zvc1c2dkdOanluRjllUmc2YU1sTDFBWFlONlVnaWxRc0s5bEFxNEhX?=
 =?utf-8?B?bnJSWmR0SEJmZ2hnNlVPN1hnUkVTRUNUOHRUSnFPRVEvV25sV1ovOVhjd2s3?=
 =?utf-8?B?YlQremErUFVLbVA0ODVYWGtxa3RDWCtoeWlLWmUzR1RsV0FwOVB0MG9yYXhn?=
 =?utf-8?B?dDZneWwzRk5IRkNoZG54YzFRRTQxQlRVbThhZlBKRU11V2k3K0JpbnM3U2dI?=
 =?utf-8?B?cVUzSFJxeTA1dmduTzVnMGUwdmJiZTFmOUhwd05IRTU1SlpOM3JjSkRuZVJo?=
 =?utf-8?B?RHhpTjJLdjk5aDhKeC8yUENoaGJtWFJtcXBLaEN5ZC9XbEJhdjdzaUFYWGZY?=
 =?utf-8?B?RHlrdGdZUTltRzZzVGdMeGlwai80Q2UxQXFBVG9xWTdXeGJlSFU5SzJSYW8x?=
 =?utf-8?B?aUxySytmUUtaTE9UUUt1cG1xTzEyWWVBeDdZbU1iSkhCWThaRm42bzhZemR6?=
 =?utf-8?B?VWhvOG1XNXhXaHI3Tk41UkNQK2lXY3VhWCtocGc4Z3UvSnM0OTZNV2lUTGJV?=
 =?utf-8?B?Sk9vTnk5elB1YTNkN2M3clNPZEZjaWVwR3FtZ2Z6OVFxOEdZejAydXRJdEt6?=
 =?utf-8?B?Q1ovRWNTd091UUVHWTBhZmZuZFJielQwdjRBazFtWEVVaFhJUGpQam1xUW53?=
 =?utf-8?B?NnpxN0YzWEZWYXcyWlBrcDVZbTBPdHRJTXFkaCtHc0RiT2FkOStjUEN2TU1h?=
 =?utf-8?B?cEhyK0dVdnBERmo1MHprY1BFQUkwZGFVRmxZaFl0dGxrbXRVS1MveEtZVnZG?=
 =?utf-8?B?RVRHL1JuZ1JCVHhvVUtEWEJVNytpanh4N0F6ajIvcjFXeVhYS3dWRmNqRW55?=
 =?utf-8?B?Q2lQSTFPdmRLL3Y0SFpwQ0JMYUlwT3RGWXRUMVVpVGpJdHRqcE8yNXlmbi91?=
 =?utf-8?B?UWVRNWxrK01BR1RERWU2aXpTc01UZnJpYStmK1E4ZnRMakZZcmlPS1BFZFhK?=
 =?utf-8?B?T0E0TFRzcTByeTV1L01KQVdGSWZ4Z3RkbTJKNlRLbVlOb0JuWjVTc3p4Ny9L?=
 =?utf-8?B?R2g2MGFFZlJBVG43NEhURmdNSWQrZlQybW41RkFrdE9NMEQ3WGg0KzlCOGdN?=
 =?utf-8?B?LzhUT0lTb0lOeWR5L3IxTXNBeXR2TnJORGUrazBMVm1CUjI3bkNxaWxRZW41?=
 =?utf-8?B?dFhjVGtBTE5oMmFiSnZkajQ1eVg2YzlrQ0xMcGNGWVZzNDd2NTNYMEhyekdm?=
 =?utf-8?B?a0wyQ1NRV2V3RW10NEJ3SlBuOElqVXQ4S3FlcGRnQm00VjRBUWdRejVXellu?=
 =?utf-8?B?QUp2NGFKdW8wTnlGcTdXMjk3Q0FKa2VOdXBielpMdjhYeXRISkp3ZmZ4Zmcy?=
 =?utf-8?B?STVIZURGemtlS3AvME80T1lNR1FXVmlOSExYckJiTWt2TDB5OUxaVDZQUDJk?=
 =?utf-8?B?eUNMT01kbkc5OUZwRHJ4Snp1QnBrTDlnZlNKRVlwR0MrQmE0VnBjRE0zRlBi?=
 =?utf-8?B?ejFnSGFiMGhzQ2YrbmNEOUFMd0tCR1lDTTJLOHloanhUMUpXSUhiU1M4Ny9X?=
 =?utf-8?B?dkZ5TmVnNFZ3ZnRRM2tyVjhGZ25VVk01bGRWc2tvSDZpMEEwaGtkY0hraXFv?=
 =?utf-8?B?cHFBallsbHp6blJmNU0yR3JuMktmOGJ1bzBvMmJYbHVmclN5V2ZrMkJ4MHpX?=
 =?utf-8?B?bmFEeThYeUIyNFpnc2tYbjBCOHRCd3JnVTBlMEMxd3RpUjBQczYvNk1lV1Jm?=
 =?utf-8?B?RnAwVlNONzJzRzVDWHREUlREMEtrcmVjVVYweTBibGlCZWdsVlJDTGFZVnds?=
 =?utf-8?B?RzVoL05pTVMzOExyM3Nxb2IxaVBJYkJCQk5xWHlVdythSFZhdVVIRXlCSE94?=
 =?utf-8?B?ZHdPWVNWVVFuMkdNVDJjeTdwQnhlOWliTXRkVU8rUDE1L01odEFYTzNpOU1C?=
 =?utf-8?B?amNKdXJ3VHBSOXg1NjR4ZGlqVW1QY1cwaU16NDB1ckU4K0tvaGNmS29HdXNO?=
 =?utf-8?B?VW9zNVc0L2tLVmxOMUk5dFM5WVBxMXh3Vk5naEhhaGdDbjVzRFVrV0ZsWXNS?=
 =?utf-8?B?Z09NVllLSnFGeUxpU0RETHZ4UFBiRm5aS3JJOHZVNlJkeThDbmxFZlo3Zmww?=
 =?utf-8?B?cDhkM1ByTU1PRzNCMUk0QUhuYU1uQ1hldDZRdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 11:07:49.8164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b710f065-40fe-43cd-acf4-08dd88a06941
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7620

On Thu, 01 May 2025 10:18:13 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:13:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc2.gz
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

Linux version:	6.6.89-rc2-gda7333f263c3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
