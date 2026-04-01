Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012029.outbound.protection.outlook.com [52.101.43.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACC137F745
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035173; cv=fail; b=uqDseFAaP9x8y4spn3zsefsA0xvvsEm4mK8k/TWoomnwmxRNgyZe6dYaZAnmg0YqabdIg4Z4NMV6sZvknelw7JBRiAR85oQmSBd7VLjYGYovVDGXshIftOXNcIYM1ekfUONAr4dMvVeC5/7HzZsUR89+etO7mven4QjWGiGTCfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035173; c=relaxed/simple;
	bh=C/nPwtZwMFbgc//TuiXvv8DCfH6RgQDcI993nOx0PyY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IRwet9RAUL5Z1KnLzwVTpaztNpwun8Fyi+0ojhJZuJOUM5n1LQt4TPeP8jUpFu4wftMe38qFO3D0bssrzeyaKpaogvQdYjVu9GkYojaSXWC8QyJN6PFAFvOTzkYTJRzsjfmqF64BsXJ8VNrl6FZ5KHiGoib+oCeCUT/pGypaHFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tTRIvM79; arc=fail smtp.client-ip=52.101.43.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tTRIvM79"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aM20ABrfd96TxzIHf4jWnHhd5lvYIXl3bKQNc9dnzM8pR0lK5UrdPlqQCmC0VEWSwaRrtB0k0tWKTfbKZmYBsGo4CuETLm38J3VjBfvLKwFj50hi9ISC+2CaCUUKMg0rcrpsl9Lr/eN87hY59pNvzOYzjKZZL7A2rTPaFnk6xEqeXA+npw7cUwjypewWRhxBIZk4Cbydhhjiet3zAgsltYso1kU0X444i/CbXkOMzhu75EZBWy7wenQgvr2PE5fYGkLV27SsnbX9JgfmQepd/oGPopR2w13iEwGW+b6SgZfvSzyDTnZeec0WU4hayFo3D1pvf+TjQFUWtOXwHVniEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyhcDHgc/6KrtouS8MeXOnNUyY4zFzE7Hlq9PeNdboM=;
 b=AwTeHnTD4qmb9LRafNQrwObI8nRZQVUOy1ZKuMSbljS6GV9YgpznI7LuendKPPAUClbQIxUGLcTPpmVFTsje96U+gh/f4F/XbBN55GYFAVeTtKLoDGkE/zW0Leefz3qaoR0C6VJF4CjHKozYfzT0UD4DR+zSYiBcQL5sxRVJaTOKv6xddgUjKfQgK4Jpr1X5laCer5ZHnO+JDeSA+ie9mzaksUEuSE4WmV0ssRKvx8ta79uzDpAaY+56HcqHpNrXlmpKQ61gFyUA6ginAD4r5tCCV37Ycikhi3S6bR9p0NpPC4hRuG/lMO2edgQxyTB+W6uVamZOTUeo+UZT8aWgBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyhcDHgc/6KrtouS8MeXOnNUyY4zFzE7Hlq9PeNdboM=;
 b=tTRIvM79GMI+nQs2gkl8EsHgJRd3u3ELdTgwQEKd5s3WRgnF99n3Ba/6AWEAcNKNeY1JPacM1zpLW99ByMZiK9uhFBZvW3WE8BwGrVl71G0qFeIDDC+NkMbc0Ed1yxbGjzoGdPvy9061ectCi6xHbzcQohN8AVKw+JlXZsBl3fzhLXKDmg2paL4kYSj5YVzhxQiY7sll26buR7DIu5YUpapGs97t6g23SqMy85cqqf9C7z2NGCxnnbpvhcHgFr8PO/bDrA5tttsHBiVV/t2L5KjJZZnzuzf4v87qQaUhTB3waSNjt3iFZKQBNeI/vfVqbRcuopXW066CRIIRKyzHKQ==
Received: from SA9PR03CA0014.namprd03.prod.outlook.com (2603:10b6:806:20::19)
 by LV8PR12MB9232.namprd12.prod.outlook.com (2603:10b6:408:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 09:19:28 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:20:cafe::df) by SA9PR03CA0014.outlook.office365.com
 (2603:10b6:806:20::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.30 via Frontend Transport; Wed,
 1 Apr 2026 09:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 1 Apr 2026 09:19:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Apr
 2026 02:19:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Apr
 2026 02:19:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Apr 2026 02:19:11 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7fe4cca5-60f5-4fef-a5a6-4963148baae4@rnnvmail204.nvidia.com>
Date: Wed, 1 Apr 2026 02:19:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|LV8PR12MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: 497e2708-e065-4270-244b-08de8fcfc689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|13003099007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mWkUHzYV55rLAGXAwJdGvyA6sXXap3qxTdYDEZ44L53DTPHtbsabCIxk+EsWMS7cnFGN5/qHTNDSIuQT7Uodre3wMBDS2+h+ehJcfyUYRJm+UgBGH7ueRqOivP/0lxB5VmlyMcf+6ea7XVMVNSU7bWtQ6s5FF1Y4sR1iSopUk16iY8oxX9L2HSUe+nozrHRuqa/EkK0zcgtEdelmWVSjeR16V6kpjqciZxBOBV/F6VPtNSsS+YCfoAvwuDrjDqwTuxjpatd3zqpVh2ZZziWQ4P8XVBLEcdMoxCsLr27bpUGRa0c+AQLeCTjNSUODAxjExR4ni+iiopuHnn8A5QqgBDWVSMRi4OAuqLp3gOQzFY89Get0Js1DCrJlFBeK7qR7f16+IIszeZvAM7R6esm9B3Pdfn1hCb7YS8Jdvcd2cDA1AVA2i623Pxqip0Ms9pIt87AqOyrfHOt81kdy6cRPLKZ7Q6jcfQWT7V/pnSWuM0zD8u/AOc4fxC1Cv7OIGiFXl+GaqV/+YFjzabda27Zz9iV+GHG3hlRqnvhB5vuChpMOT+f3NMQAO4ENiV4tfziMpPiRiVAMhpJBpo34geEWG9vsftyI7OfINQqiH9B4xDKOfnVEq7WoGiVQxWtZZoxKRrizvVqDVqmGJdf2w+WkE7+3p7cIezQ/6+uo+MRDNTRf/7s42bILglp3gNlIcL57fkSHPbnDsS+zu1wdiW4hjw7m4P9VrUAQjnHR8sxO3A1bBZQZlTANSqccLi4lbiMDZI1dDXtPjX8krR40PwhhRg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(13003099007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HlVPJ3MTk4JnsBdT5oohC3GxgKcRpDW7jUsx7IgaJQznu+PLXrymjZxjTJJf/qWUXn8cZP0tsRH9gdnRAziUYT83F63EU6HM281VcucrvZSREboZzTpPfORBdkskvYwKqnv6M2i5W+eFQfnR37q21/I/rfEksT3kbvOrhydgH3uzFcK55kzrCUlepU3aWGBTM5aV+1y3D2DlDD1Wj0glF0WhsAUweDm1g0ZeR871lqPuggs/BO/K72yj9PEnbsdoO6YuVQ9qZkG8v4MfPNwdSlcfjWTWkZs03HGcGYX159ZAOue+yr+SnVyGBMpiZAiscoYnfojMWZj9VaEWOuyfFCSM9fpJtuhl1bNaxhcdogdSYs6x7ADdanwvdL4gTSmXk4SttMIcoUoY8nsJxpMaL+5hpFTp/SAUhnEzPXpsbq2gU0LilObi2ict+4AO/CeW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:19:28.3693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 497e2708-e065-4270-244b-08de8fcfc689
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9232

On Tue, 31 Mar 2026 18:19:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.12.80-rc1-g77487557237f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
