Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCD17E
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 21:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567498; cv=fail; b=NN/VX3JB+vsPh3UZo6XdT9p09B2LVyM5Xn5DHsgQcWJPk+76cXYEt2eXV4udy5pNTaEnbmtDY3vesHpbGNe59Jp+KTFETCV67h5VY5TkkKFyR2aAWKrmKGDqVNe1koXiVRkarvrPm+q1xSLiXnKu1ZP6zxV+LhrbAPY7tv7/ExM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567498; c=relaxed/simple;
	bh=pG/gXStPiKLxMoqZRy6Ricl3/ljj2F7cAduoUHx5GQM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SYEFbyjE38gW/IhVNRLLiPokKVjHEIJBoGGWKRtPRYoIm+n7JdPcI0gQbv0bdQcge8LfnXLbxMnQWXl/Rb1oesrmLlCqhbwwT1c4adhxjJPKy5G7NRA4IDkr31dQNTepRWCbGRKSoFOiB/KVMtKOx2aNtw6dgN0hjewxouUPoos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dl6DfIIz; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dl6DfIIz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQmnHX44P18VFZVHjgh+jRQL1b600QGyS4QbzNVgaEWV0HGC93Ol19SmpIwg59wvJ4H35uS4cW1RylvNV24XTRPeia7vrCocKWOw80Muy4SQbXBQ/VZepVADfZzG01qw8SwlXO2pW7hu+kouXstL0/yV3voPMPhcFLKsREFZSWoilHzmkBnOqqUXITY1lfo0xM8IPY2gDGTkaoUTeKfI/flPF5ixVFP5UDLdnbSb4jGHfyw+l50mj23AYM5F0rVVqSPnBy/IOLvXd40VZSW2DQKDP+5+vxHMEDFBa/nIMgeuQWp1VUu8WZQhkT3biNqMVYO+8qMIgg/MSYXisTM7+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdZusqmsF9bLs1f56ppbSLq/UU4fJJVD//xUYyYFggM=;
 b=JjRvo43LQXcaYXh6P95WJCh09LsSlkbe40U0wDYmfHdSuwxwnlzgo4fVq303o5V/oKwrDlRr1z9zX+1SZU5vlCrsho4jcKNh0lESCzf0WmX9JDRcqjDOGXW4E4DmHLkyFPRpA+JzoHYS4UNJSuGpaLVW7fa0vCzJAU2b/e3JMoU7OUqxRfuunQPw85Ev6bYe2WT7sg7eEa4OW1PWWRD/sh4otL/vjIqls8xkWCi48IuAyvPvKCgVy0S7K8EC8mVuK+a+PytQLvHw6lPqrj89D8OcQViisrYsc/qAELOyA3AtHyX9tkIdyK0bP1VwVeMYCBp6EtX1du+OtxSe9FXopw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdZusqmsF9bLs1f56ppbSLq/UU4fJJVD//xUYyYFggM=;
 b=Dl6DfIIzOqD9zlilQF0X1e0GqTERNqWor0f3JO0ahxgH3y3xXKug1sMvDifEx0MstSmzRTdEeHLxRhRRCZO6eVzRLqZrGB7OV+UyGANpKa0rZNaVxTZu69CNkXuCCEKqBqvt82B/fjaq8ovWPyBq8W18G7HFmN+85MNxXxrX9Hloe/sKMpzuv4f6GAr3Wo6+ij4AMnmKwnANk7iH9k3b6DaHjIYNy3V4IzkiWFFmt6VoWn4eVjuvXQchKnPFC/1/o1XrxcQfDxX1IonwWZXzq/Qji1CgfBQ67elRyhFeMH3ZmR2rbBXlQFf7ksUcsq6C2XEs4x2AgxnReMut46Mjdg==
Received: from BN0PR04CA0128.namprd04.prod.outlook.com (2603:10b6:408:ed::13)
 by BL3PR12MB6401.namprd12.prod.outlook.com (2603:10b6:208:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 21:11:31 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::85) by BN0PR04CA0128.outlook.office365.com
 (2603:10b6:408:ed::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.16 via Frontend Transport; Fri,
 14 Feb 2025 21:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Fri, 14 Feb 2025 21:11:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Feb
 2025 13:11:09 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 14 Feb
 2025 13:11:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 14 Feb 2025 13:11:08 -0800
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
Subject: Re: [PATCH 6.12 000/419] 6.12.14-rc2 review
In-Reply-To: <20250214133845.788244691@linuxfoundation.org>
References: <20250214133845.788244691@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <57e42fbb-9372-4618-bbed-71da01326ffe@rnnvmail203.nvidia.com>
Date: Fri, 14 Feb 2025 13:11:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|BL3PR12MB6401:EE_
X-MS-Office365-Filtering-Correlation-Id: b77f295c-ac8e-4936-7a14-08dd4d3c27b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGd6NlpvR2p2ZDRwSWIrS3BzV0taRnU1NFZUWDRsWlczdm9iZlYveGNWUHBS?=
 =?utf-8?B?Z1dIZ0RKM3diMXBLaUxWWWIxMmFSZ3Y0Y1lKZmgzOUF5eTdqemtyd2NnM2VP?=
 =?utf-8?B?dHUweVdFNERod2h2bXhqbkxOdlVuRnVDTHBWQUU4aEloanBhemFKcEpyUXRE?=
 =?utf-8?B?RlZBWHJITnNGRlFxL0lxWjJHREFHak4zN1plWXllbkN2UXFObEg4YVc4d3Vy?=
 =?utf-8?B?bGdHdnNYZmJKVnBtM1JSQ1V1bE1XWVRnV2tHbXZaa0xOMDBWd0Y4am5DbklE?=
 =?utf-8?B?bG9nRTcxU1BrRTQ4NldMZkZlQVVJN2p6enl0Qlk0Y2FTd1ZUMFNnQm56U0FT?=
 =?utf-8?B?WUlheUJGQTcvM1dyOUNHcmJvbkQxbW9xbnUybWYzcE1PTmU4bnNpc25oaUNB?=
 =?utf-8?B?WGtMM1VSa2VqUVlZZUtiRW5ROW9oMk9jTWV4STNTZzVDK2RuQzA1RXl2RUhk?=
 =?utf-8?B?dysvRWlVTnJDT2tmakZWZFpWRGIyTHRNMmtYNk9KMWwzWTBCbmJJOW10VVVv?=
 =?utf-8?B?cUYzWHZ0cDFoeVJueGwrV1dTVGpyOXUwcUM1c3g5bnM2eXJQTTBoZ2RmWVdI?=
 =?utf-8?B?UktITm5nTG5uRHVXVi84TnRFYnI0cmdsK2pzeTRwT2xqWDhLck4vK1h4bzFE?=
 =?utf-8?B?NTRRblNNS25ueGVrTHNOZEp3eGRtL3loV05PQVl3ZDlsbERJTkNITHYzNU5S?=
 =?utf-8?B?TWJMWjBTK1RHS05pb3ovd2tqTFNaN0N3UFArd0NTbkFSUmhGTHNTbEIrM0t2?=
 =?utf-8?B?NitFcDhhTEcvSldHLzdVM2FiaXIvbGlFYVUwbTEvTGN6cXJONkhJK0F5ME5J?=
 =?utf-8?B?ZWNlcW02dUMzRWdZNjltME9kdUp6M1ozOEpSaWo2UG50dHNIZmFHbTZ4cHFJ?=
 =?utf-8?B?SUFtN05LV0kzSjBRT1c4R2hZRUNKL2dnQVJxK0NGWmltU2I2YTV0YUpQS3hO?=
 =?utf-8?B?NHdvNlR5SFJSN1hKenB3SzRnZlcvc2k2aEdxMlkrbWVVdWR1b1FzUmk5Q3VW?=
 =?utf-8?B?K3lnTlBCRGZ3Vkp3MU9UbHJidXVybmUwMDNidVEzdFlWTVVPNW93WXdkWm9N?=
 =?utf-8?B?d1Q4Tm9XT3lpRDhJbENMa3QzUFROU1piQWRqTDRPaXNZalJ0cFF5K1dOclhG?=
 =?utf-8?B?ZGphTTJZOHhwNnFMeVRsR3B3NEFidkV4cDlrWVprRUdlZEJsL2lyN3FYY29E?=
 =?utf-8?B?MWZCblpsWll1dFV2ZjdSMjJzNGtGL3F4SGF0RTZhZ2V0T2ZaWjZTSW5xVmdL?=
 =?utf-8?B?Y01TUGx1c2FTSUxjaWZxMXprV0tWSWYzeVRDUW9UQjJvV2hoSFNuU0ZncTV5?=
 =?utf-8?B?QXZUZEdlQUxCaG85c0xMVXBiWFpJQm1OWmg1dmlBbG5KMXFJR3ZYZDRSQ1Mw?=
 =?utf-8?B?Z0dVWWFETXQrQmU3blpFTjB2eFUxNWw3MDcyVkppOW5DNnMxNkdObnNiVHVm?=
 =?utf-8?B?em1YU0hmOHFuRG9sUHlVaGVBU1dyNHJ2b2o2cGhrU3NBRG1WT0txUGFHRWJu?=
 =?utf-8?B?VG5qZ1RmbHNKNzEzNzlmeE55VDg4UXRjVHRMc0xOY0U1S3c3MjVIVWwyeVhN?=
 =?utf-8?B?V2RJYVowZ0VIWURBVURmYjZaMStIZ0tOd1pqWEpBMFp6MXBwNXRZblpzRlgy?=
 =?utf-8?B?WnNubjFpaklKR2k2RTF2L1Vpb1NjUm1NVjZ4Ly9yQm4yZlhUYjJTdW9MYmNN?=
 =?utf-8?B?QzdGYWpMM2Y5YUdGaHFWc0tXclNRbWY3dk5SQ005YkhydXRWZENiTlovR29Q?=
 =?utf-8?B?V1VYY202cXVQU0ZrZE9pVHR4S0JFdzYvTFZLcGZwMEZxcitNaWJabG9lRHk1?=
 =?utf-8?B?NVpOaVlxbEh3WjJFSVZFYVMwcEhSWm4vNEJOZ1RIZitvR05qYmo5dVUrR01B?=
 =?utf-8?B?MVNuYjdVc29tZ2F4MVlKRmV5TjExOU5jNDFPcENHYlZ3WGdaR0FldU1GSDRU?=
 =?utf-8?B?NnlmUXNZcmpIck1lRVIwcVc2V3Y5MjRlaGNCWUIybUFjWDVmOHNFWHYyZklZ?=
 =?utf-8?Q?JNfHT/wltwtf//nBeJEIJoOSGnzRXI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 21:11:31.4093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b77f295c-ac8e-4936-7a14-08dd4d3c27b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6401

On Fri, 14 Feb 2025 14:58:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 419 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Feb 2025 13:37:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	107 pass, 9 fail

Linux version:	6.12.14-rc2-ga58d06766300
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra124-jetson-tk1: cpu-hotplug
                tegra124-jetson-tk1: pm-system-suspend.sh
                tegra186-p2771-0000: cpu-hotplug
                tegra20-ventana: cpu-hotplug
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
