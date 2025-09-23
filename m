Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011017.outbound.protection.outlook.com [40.107.208.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE92F324B03
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633055; cv=fail; b=r6TuZ6eS/CD2+BQK4P7VR48he6RlG614kOqHRzc7/XmyEJaUfCojSm4y1LAD5F6FCmhCrIVApR5dd+BNcxGeMjxR7cLUTx6YttfHgsICyNiCA7ndz3LcstHb1kDLS9aGJHfzj/175eIZyHWY8brdNCtrPSEFMTo5yk0XJMPSezg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633055; c=relaxed/simple;
	bh=RFaEejpXMpvGz7t44geY8JHAocWIxi8KLjN1UuF/ZM4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Fb030tev4v/TnBgx3fJaIXvA0hJLvW1LJd5cTPY8vwTuHKjP5d8iUIuFCP2TqN1fslpIoe+0TAzFTfPGcZxNXK1pbY+ZAJwgj/GWKCI7jKB+A5Et0k1Leubmn7v6ZQNvT+1Kzpz0a3ewCOm+82n9tYrPUvbZjL4Tubf0QK+4f5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=poLnJDW1; arc=fail smtp.client-ip=40.107.208.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="poLnJDW1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPwtdVdn7auRdNecD3mVz4VaUuIA/yuLisTX5qF1Gkxq2jYerFllEdWh+JtzYMgDmdfpAPplACXgE6gH5bN4KCXuGC6nI+mxCNRKI2nErLzErUmgh9jbx8rp3xZ9ZJ9laEOtnPjsxEXfPl5aGxgUoudUn4ERypvcabgl215yvglah1HaaVH/hTTDz+phZE79B2A7L1dxJn9agEyLaUc3lXJHMMiMJmlhM0nbv53Zjca6NX39CODXGrNfjibj9WHnUT5niu84h490VQOdJmRlb/27Jqtv+h2r+RiiKHUr9Rn4oXDJx2pYBndMTf79cOH0n/M5EgQkyJdpW83TnnGceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQbF4jdvoUtxS9mb5KBbevmZGQ5ejOrAmitzZG8YGZs=;
 b=EKInNEkvgVMMGIlDzUd+O1HLZnMAxYmrYDhtgT5KHeIXJIjbqrqnd9NSXgYdss90xMaLgZEcHwa4fnz99l2eMIv5GHBU898HndCLNUuYbVfsUlWrdlSUkLmwPLMbim7XqVnQ8W558edHTe2kBxDDFFm23DSO1Gh1b9/C/+pNSzXsedR5/Q3JKs6AFQBD//0uY4rClKaxBlupXI7D5+CFJK+ljOqnsWHsQS39BJb7Jw7lRUrHGO70up8/PYZHg5YziCXcAp4Bg8Gjs1CKFrfg8w5/VsCE09yZcfGDuKdQoR+cVRCI7DvYSgPvrY1DkGnP9sZVT3pfSw5cPBvYXVTSOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQbF4jdvoUtxS9mb5KBbevmZGQ5ejOrAmitzZG8YGZs=;
 b=poLnJDW1PoVoBVH12XnW026gt5x9wD0NpYNpHHOItug/GZ92Y+JBwpeDLfg5c8fb7JAgvd1wf81eLmcp6uWzWaHf2wBugHAyAZ0BblIbOqhvN1ODkkPsyQ8hxQhzu+ZXh4rSeKVl0M6oyxzVQRRHcMIqxM726rIYeS9qOB2IC0GW2P73sAF4/di32N5Ptk2UzaALvZAnKWWyZE3EWVNBKbwNtm0BGLXKcDXXi8RmawxTNpciOupIvhUZE4ChzypqPA9krPg2NFHhczZ3F3vOc1R+YOiG3iAUy5oysJcI8XkgZ8ES5TRZk5nPnzGDek2BqrCpJCit6fp4KBUqRHHkcw==
Received: from BYAPR07CA0097.namprd07.prod.outlook.com (2603:10b6:a03:12b::38)
 by MN2PR12MB4470.namprd12.prod.outlook.com (2603:10b6:208:260::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 13:10:45 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:a03:12b:cafe::38) by BYAPR07CA0097.outlook.office365.com
 (2603:10b6:a03:12b::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 13:10:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 13:10:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 23 Sep
 2025 06:10:25 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 23 Sep
 2025 06:10:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 23 Sep 2025 06:10:24 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <53994722-be30-4129-9ec2-d1e2103e8730@rnnvmail203.nvidia.com>
Date: Tue, 23 Sep 2025 06:10:24 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|MN2PR12MB4470:EE_
X-MS-Office365-Filtering-Correlation-Id: b743ad70-ffb7-4acb-9344-08ddfaa29b4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3ZySXVoa05FU3VZMTkwTStBMUExZEZDT01zaUdiaEQwMGlEeG43SW5iRzhi?=
 =?utf-8?B?cU1sbFJCMW9ndDkvTkdMcTYrb3o1Q296ZDhyTVhNYTBJQUhWYVpORE9qZTEy?=
 =?utf-8?B?S2F3TDNNMFh6YnBNczhYM3A5aFovQjBZOE9DQ09IN1FCSkNFNnpmUE5ObWxE?=
 =?utf-8?B?T29wNTROYTRTQ3RaTDhLVTJXVDFHc09wOWpId2llQmlpTmN2eUJmVmJSTG5y?=
 =?utf-8?B?NGpRaHNiVVNiSHVRNEp0V2RVdFJZSnh2SHl6cUZPOHlFQkIvUkMrVEt6QnFo?=
 =?utf-8?B?RkQraEtESmtORVJvNXhRM3lSM0R5aVBvd1JzSHhZajJlR3Mwbk01TCtFZy9B?=
 =?utf-8?B?aUxlZFBDNWQ0SE1obmpkdnFwM08zVHJMLzRUZVBMMFNJK1Jna1c5ZG1ROC9E?=
 =?utf-8?B?SHl4Uk1UYzNRNHdDTnA5a1liQUE0d1h2N0FhV0s1UXlGd001UlhtSkJSTDN4?=
 =?utf-8?B?THRHbHJnbXpPZklFejBhejkxcHF1YnNmTmlJa3RCRFpKazNDemRNTkZjdmhj?=
 =?utf-8?B?SDlhYmdVcGpXUXJ0VlBXNURQMThCUmdyRmxEdWt2elkwVG9sRzJGOWoyRytY?=
 =?utf-8?B?cnhpcGhRYWRrOUl5bWk5RVV0NDc2QUtOSTY1MXBZZ0ZLSUlMYzJ5bFpCeTh0?=
 =?utf-8?B?TE8zbW9PbHpTajdxcXpBaFc2UEI2QVg5aGxZdkdib1lMUnd1YmNlOWZPSm5h?=
 =?utf-8?B?THhNcG1wMkxKd3NSWGlSbUl0UWxRNmcxajRURHdKSS9ZWnM5MDc1MncxYjd4?=
 =?utf-8?B?dVFxZXN3VlByMEdNQWRGd2FvUmhSR1p2OExkZ0NXcThIck9ONmNoUXoyRWRz?=
 =?utf-8?B?QWRwYlJLV1FaUEd0OGFsY3BwbkJ1OXhqZFQyTitRWlZuV3QrRVZuWW5VMXpW?=
 =?utf-8?B?VWprU2F5aFE3N2J1cHM3ZlVWWTgybDVFUGp5WjV6dThHeEk4ZmJ0MVVqcis4?=
 =?utf-8?B?b0JFaXhEZFh2NTJjZzBiMTRXblc1RTdkUnlXMyt4MzVKSG9zQnpWMDJUNk8y?=
 =?utf-8?B?dlFFcDNrK21CMzN2a0QwSjZObEV1ZDhPOSszUk9mc0dQQ1RWLzJ6NEdCNVlQ?=
 =?utf-8?B?Tk9EUmNtUy9aWk5CcHVNbThtQ2Q2QVk1cjM1RitvTG5KQUZ6L3RGRUhHR3Bn?=
 =?utf-8?B?elRXcTlva1c5emZzcVIrVWZlNDBoWUlQMW1ZdTU1QndJaUFHWTJZOHRlTmds?=
 =?utf-8?B?cjlRdGNmZkhMcWhidm85KzhKc3RSb3BrL21ua2xWb1M2NTl4b3hxNmN1ZG94?=
 =?utf-8?B?OVdPMEQvZUNCYTNNWFpVWUVYd1lPblJ6TTNYdnZLYUVqUEtGb0hhdjVWNkNG?=
 =?utf-8?B?TTNJT25RT2JNck5HQlg1aXVZbHdwcG9oeWowWDFPY3lWWVJTZHNoTE13TmtQ?=
 =?utf-8?B?U24xeVg3MGRIRExDWTBJY2VzSlZjeXRCUDhHaG84d1NwNjhkZXhrQ29QU2Rm?=
 =?utf-8?B?cTYvL0xGdExBQ3FVM1JzS2ZVMFZZWmpXcXdLUUpYR1JRSUlQSk9WVGZESERW?=
 =?utf-8?B?Q2o1VnJyOFl1NTNscENRbVlmMncwLy9iUUdIVjVMcWJXaDdOc1R2NzBrSGdI?=
 =?utf-8?B?VTdUbWFra2JvRUZ6OXgxamxtblZ6VnAyUlhCRzJqWjlCMnR1U2JNOGZRSUs4?=
 =?utf-8?B?dmsxam1zRnhWOVd1cmNZR290NmlORVAwZHpvUTBvOHVtcFIyN2JZbjJraEFM?=
 =?utf-8?B?aStlQlFybzd3bDlrZGxnemhtUGpOMFBuMlZ3bGtYcUEvZ1hCNmRKbjlsQ1dK?=
 =?utf-8?B?OUJ6dTNQTnNnNThQQzFFQWIzSWlJTTZ3UEFqNzVJSEV4K0owUy9XZmxqalRl?=
 =?utf-8?B?YjZCdEFuWlU0cEZ6YmVqdjYzZlZTSmhCeWtjOENUOVdGOU5ZRnNRWHd3c0M0?=
 =?utf-8?B?RmZIMDlPbkxsaUNKejBMRVVVMWNkSGt2WVVHTm5HdW5tZlhvaXhlSENLODNp?=
 =?utf-8?B?c1dSd0FtQlo3UDgzSjNuYndFR1FhV3RnRWU5NCt1b0lGTGFxRHRnSUkrYXZi?=
 =?utf-8?B?Sm9zbjFlSHU1Mk9KbzFqNHJJbjJqMXFDVk1hSmF2Nm8xN3YvTEcwLytwVWE5?=
 =?utf-8?B?TmVGMDc4b1hTQ0NxUDlKWUtmc3hZb0F0Y2RKZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 13:10:45.1989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b743ad70-ffb7-4acb-9344-08ddfaa29b4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4470

On Mon, 22 Sep 2025 21:29:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
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

Linux version:	6.6.108-rc1-g6bd7f2a12b28
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
