Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2D3148D4
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 20:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050198; cv=fail; b=pT5d2S8rhQB2KUO6MH9u6BLLvbWqCJOEQSNdWHR5LS4hLnHJqoBGFUQmCdqW3RmHXVwW8d4qwHlFG1PSVzc99EubZzIMcx/fNMlLohTeyjFNCQoIpsF4V2AeHT2WlVxaDn9Vl29a5VbRWFURoWfnjiST0sRRlto+AKwEArKdGj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050198; c=relaxed/simple;
	bh=bSyWv6AYrIpFm2VGOqPn9wPVSK7MH1+Sa1uEmAEmcpk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bjcE56tcBBZVuV+dGzdyXfiUxqqwgC7XB1j+mku0L523azCZUxaRM/uR7/UEHHhWstDl7deKmhaULeM+Tt408sN4pMh49kTUIU+GqJ3bSMq0YveRoDVpz0yDn4qL0GlF06syjGE2LnK8oVdBnDrfX975PbXucbnUJ4K/zFaRfC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zu3agvVX; arc=fail smtp.client-ip=52.101.48.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zu3agvVX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fp8d6g6IVWl75fA4zqU+ENdGfYacDx4wi3jA+appT6RYBo8vRMZliPVjFAhq2vJSdwWNOsA9zIsPlcrD/pjLVPGUT0T9K1DfBPWBeoMuIoCQQGEho4C+q06v5lWyqR5pA8AWuSwWcL0/NN0e7R/ToJ4jDg7eQvzs6BawnpJ8zxMUFWoVtOqGduafvN+APTcXTMiAqLokWON7moLWOBVF4xDvkAs96CyRJZaTFgIViUnbkysSmQ46QNUkIhM4PlEIKlejCPr4mr8aJAXssQrVNNvRJJ2ZuLpbw3LsV6bfR397QAm7HPGCp7hyCc1dYrWOoSETBZTNRSbTANdSzq8mnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdu1UG3hYomUHkilmICOWCOclec3T94/UOS8w/8pJD0=;
 b=R/W073kIMu+20VWZIrXuJs8KmMYqz0eaDPvhL64QZLaBXVDpxbIYMKRmDcakz0cdFMG9NP78bV+EhNUcgWG8IfCmlX+bs0z7AqEjUXzAYwstSBQZRooRunifjresETWmGtWGVi9QStANc3zCacwpQtXK7/MuDB4jDrk6R2gtmNbVWJnUlNqPOtsRfBUeUAs8V3CVoSkHcJ//AixzJM0x6mm9DzJXAh4mrM/rfE014Peu1oECdRtuIE0T+lLtqgKz2swQGDDA6II3Q0TPtEUSYjbx4IIox6R2RLAM2xeqmGIRsM0YLaM3s5ixycKH+GEANLmbnTxIz4PcOjtVg0Er7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdu1UG3hYomUHkilmICOWCOclec3T94/UOS8w/8pJD0=;
 b=Zu3agvVXqu+exlVAPXMhra0GTOt8VJselZe1EIBI2rgbjQZpxY27YQn+dVru/GI1Ssdb0lXeUorJNyvYVjEUZACDKVByWWvr4jr/CfSeXjitoQlrtkyRCbmhg52u0ZbD9E8Dvei+wo8hDxWY2VZoBqpINYT0HDywqJyGsu3w9TXkD4SaIwQjFsOddD6gdGKL8PI+kHJgqueIweF+ifs6gKStQkvpM/F8G7qoRHeugbKctEFZz8aTMz09aw9KdheqRkaDeK1KYVBAhpE8ZzkxhVCkHofd3Vw0IjLqXxcPMx3+b2VFQEW32/6RWWUw05c9xNrztP2TS8wbBDgsEAFwIQ==
Received: from SJ0PR05CA0025.namprd05.prod.outlook.com (2603:10b6:a03:33b::30)
 by CY5PR12MB9054.namprd12.prod.outlook.com (2603:10b6:930:36::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 20:09:52 +0000
Received: from CO1PEPF00012E80.namprd03.prod.outlook.com
 (2603:10b6:a03:33b:cafe::ca) by SJ0PR05CA0025.outlook.office365.com
 (2603:10b6:a03:33b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Wed,
 25 Feb 2026 20:09:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E80.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 20:09:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 12:09:29 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 12:09:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 25 Feb 2026 12:09:28 -0800
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
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
References: <20260225151847.709818960@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ad23082c-43e5-4314-b5c8-9973b99d7560@rnnvmail201.nvidia.com>
Date: Wed, 25 Feb 2026 12:09:28 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E80:EE_|CY5PR12MB9054:EE_
X-MS-Office365-Filtering-Correlation-Id: 01cbc226-7c71-4049-a5b6-08de74a9d611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	du1dclI/PE8FZwtiyAhAemati4uE0tvDechlAYSSyCwDYnI37kQxSLbQaSU+RDJTrxEwWEaeO+8RVGHcGk8dE1H7ajwG1mWhJILOjqFq2zglfhHrX/iQKjRM8Bt/X6x4CROL6ZjX/aBuaoKjfU+Ll/2kJZK6wHl68uaXCAOl/nDuEAjcY1hlZFiKSr6ftzzBQ5gYGuRqq7rvKgfEBrrVJngL3tOY+XnFBl+TpDB63pwSSfxM4fM4cT0E+5JH0yp9qlpa2EF76Ol/LytHt4uHyh96jQ+iQzEb0FHNrb1pKZRkiqrfYI+bvuPOc8mDAcwcdTt5x1Nxkz+u8uJ/kxgpm6u2UzNTdbJy2XAGXnylvBUSkZcfxeO8uWA1HzpD3w3JD5YQyfqPI3nDPzcpjwjCNdQioaBr3EfJH4HXVlBVUf1ypnzU138F+RNHrp8Tx6iLGg3nYyBVT13hzAQRKlno5AuHApjQquj5OrXkcGU0aP/1CHHRdfcGcanhtOIrGUUqJJPGz5DW4nAmVSm3veTTTr/n5dgrm4/qMovpFiHy+wCvjOpIK3IvXNBPLI7ty5UkhDIP1sr9v0RWsl/Fmb5Mb5HnBFmrGETP456oBnOQlZmfu0MWYs7SitqUTFXAZoxAjki0/unGXkDBs64ccVXcVIDfJQnjm3Kro8zvAeg3Xu8Adh5jufQGGMSLFuGgYHaBao29mgs03k1lDfVi8mVfAqGcBXujARZY1gIxx3h6okGTmbX/2lO1Q2b3vT9oPF7U7XhcfsQIDtof6Mf+Mg9CrbvKiC/AOR1ML8/hhF3YcifiCH8W2FKpkhWgV9TRy9Zco4qh/dLUFnEE5j1ZriAhsQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yLXVH1CMkRj38BqsuZ6RZbs0pw5LYYSnIf/N3oL+iQQoS4EKLkDfrcRp7X+XelZiJdNRRAaiTJttu7UMtMIQztV+w5hUKgIwEFCyg1DWRs41f6EG3vFGsUs1omn3OTqX8ZHqNilg0v+tTDgq4KAaVTLklybQccBoK7XwFWYNGEBc2JKYjmIJ8Xnw+2Y3SRzjrtmpp9RdRQAyeMlipknwAg+nx29PbMsINfPHql/rbSaNPC8gWX8l/P0pKTV9ATi+o5V4Ids/ZJgipHCOr32HfLszv4jObdpwvFNTeU1NliXUg9gBxd21sNB/h5OKgru/4DXEFLDO7HEIAAvk17oP3OkMQmDwjsIvWXDK2eh1wxjt8l3kEdVvECIXb6Iu06U6u3v9qHzMPYF5SVJ5Wewqj1+375lO5yr2VH1kEe4Qm0lYok+QZT6sJge9GtYobkFk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:09:52.2027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01cbc226-7c71-4049-a5b6-08de74a9d611
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E80.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9054

On Wed, 25 Feb 2026 07:51:50 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.14-rc2-gc807dd8cc630
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
