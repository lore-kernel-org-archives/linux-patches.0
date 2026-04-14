Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010054.outbound.protection.outlook.com [52.101.61.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CBF38642A
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153268; cv=fail; b=kCAjwaseyhyUrPAi1NopArDxfYNnqtsRH4CluZd4/pEy2U0BrgYBVDuuYfWLEq/7Om8RkQ4js59ohGK6C+aftEvKhaP5GLpRg5riEHjICUcLGSRmAYSkIFVtangl9ROf19rXnDBZ5wyAIQEXqOwVRK/mTpj3ZlpDhMjTYKN/FHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153268; c=relaxed/simple;
	bh=xGKP6X5xUOi/F4dwcl+LG5JSy7tFD1c+EBilTS/O57M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=eyNsvnrutiy2MCSMPlXNy6XKGrbTHsdtzkWy8wUSES975lxgdC8u10hapbAvXTQv2sovvLNvbHk0mrEb9Ok+IFKfNnE4khatGT7dGQbXehTtBL+o3G6ADm63pgbRwVyHDl0aXgXBuQ2dmF1hoYufNp1BBkiJakcWBvmfBOlZohs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hRjqmu7f; arc=fail smtp.client-ip=52.101.61.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hRjqmu7f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIR7kUPxaDtG6ibYHHOeEvJxB7Db1GzulOwd5x2vAkL78WxAqO3wwOCkn6SUJ7t6M/S3HrRqqLZJ42teGWvsjPLQViQsGibP+rg44A9At8MGKY3MtEnDRxyAjBn1Gf321VRjJS5JgzFw/nC/T9uBgPeNvLGV9ZWnzolkbOwfbUt0yfqqokXq/BrMQxH+iWbh2pCMTztr55/H9vhZRXKIqe8/G4jL5AGziBWPV45Mxf/i7LOXr7mqJ+h4URFZLa0cdpdd3CoTct/sF0UIcr/+3HX0qW184PHFtqamDfRq8y2djziPrAlDW2Jb0h+yaz7uP60F4t+9jCVsgZBPfjrJ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6PU246ABsuG7zl9EsUkhWVn3BoFHmQhwUvJ5k6P0Mo=;
 b=tbLi+WBXxHGnnoxYzre6oSP7MY3w1e7x4doEOlNqwZc6e2mUNi+QjrsjPnWgHpJvQfmfKow9V62gOqW2lRnSa6wYQzTS8vtpgRIeLuxua+E7oPnH1FbDjvnEQI32qdlkK0PJq1qG8DSb/lVushELyJ1KFBUn/0US9V0F+SVHcNFPQ5atLn67LdeiE0FsQzto1QaoDsOfJIRrQK/JACFHuZ8F89MEhxEmXb55eU1Hy75yZz14Qb3ri5QenWfsCXihqHQNdEi6YCDiA9QMkEA6zZQ7pzkRC4ymF1wek4wKBvUOVEuUM0NkENtfCrkXcOzk4QT5d0Il0l8ew5omEd4wrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6PU246ABsuG7zl9EsUkhWVn3BoFHmQhwUvJ5k6P0Mo=;
 b=hRjqmu7f6zHbknkqIk+ELu2k9YohQq94XGMvYlfImGdG3182b/8rCT+LLYJz5eDqYzNX6faxJArzP0gJ0btE2IoGeEEEtjt1SIHxOFGB+SnjzXKf2XqujK4L+B+pl3V9KN+w0WjSGw/zDuhI1tI2mwnP6CjkwvIbCt7xNWQmabEDZ8T2hXChksB5PXDxUauol0GCX9aQqV/5hOGHL264MPYT7Rm5MalOl2aLc5ay3HCKLYnBCX69CiedsA0wamg9bc/vVpZr1BAE8Ypo5ALzb1ySWrbnSv+bG1R1HOehWzn5r6uZa04KAR7IhFVTrtGGVBdPIkFEghU9h4gHq1AYBg==
Received: from SJ0PR03CA0390.namprd03.prod.outlook.com (2603:10b6:a03:3a1::35)
 by SA1PR12MB8119.namprd12.prod.outlook.com (2603:10b6:806:337::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Tue, 14 Apr
 2026 07:54:21 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::a3) by SJ0PR03CA0390.outlook.office365.com
 (2603:10b6:a03:3a1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Tue,
 14 Apr 2026 07:54:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 07:54:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:54:10 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 14 Apr 2026 00:54:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Apr 2026 00:54:10 -0700
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
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3d05a748-b4cd-4ac9-91cd-efdf83dfe5a2@drhqmail203.nvidia.com>
Date: Tue, 14 Apr 2026 00:54:10 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|SA1PR12MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b26f7c-e90c-43d1-4376-08de99fb0994
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+Kf9mUm+p89UZM8XSvR+eQZbUS3zSXG8aKkvLl87a84KdNNtYRDXTSB3S8jj3FK5dnP6EHCA1tLw5W3Xj5VxOU/HNAcryHhmeONkA9yAOtdh1HVABokptptXvFXX1ZawxXx5ulk8/YuDS5qyfMiaN4WPOYXikMSvqSarDnL1xVkKUTy61TmSfecLVJ8I0S96rL6S8vlLeOERoaVCxZ7SM1YGxHjzRdAa7Be8SepRioflVpxTW7VG7F8uplm5cZwo0BCfBECBeWZxwB8LsNjvAnB1GI/QDn/HDf7kq1TzJUmAqhCJsyS4aTDxYSgmP0tzh4FTMQDi7+lP+HPSGnkJRWy9iCE1f8h4CW6xAfuKLGPNtfMDc4fDy2uwTMxuk5K7N4vLNplnws88Kvg9SiJU41HfOXTh5M5RwlVF/cbQC4k/7NwXH1ODqOOPhWOCYntG+rw3W+qE6mBMfZsyJYQ8uka8fhyZegwEK1J4XW5FSgTW0U1o6gV+fjWZ0imZZI+RQyH+XolVh/RQ7favzW9UhlpDjB4wMvQltavvep6Dd8rnrJgAo9Pq7kE4WuTPaST3qEYnSxG4mOl3YEsKCNs2qQJ/SBiSP5Z0aYp2YSGGMcI9q5E+hBNV0khzWZsDx9TxPx0aTgJ9ez9UL7ciCPKdnV65IIy8HmuLaNPgLGQ/SRP4otaf4yTcIIFFNdsigSs1hJQkm+5WfTb//7JS1JYE9/QUQ8c4vp/xuMXlfAyOWg+9NaZhnmGZUcts7JMfMq5JMPRZgdn5Eui1WIjRXpJVtw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sZFXXg49E/QucJ7r7bvkGLlZl2Pp2XPNS63klv2jiHkv3PDJVWTrqO2+cWjGVeegt/ipFiuX+20AuQ0tkCZ2jJ4c/7QH6zpuaohBCrsUwUpTeqKeQSpcbvkM8JMsWrlP0XXegD9ggYjqJkEFdHnCx7N5lb2D8rH/nek5Cyo9xOxL0VqUZe9KggXM44ScYh6QToI5C6kdP+KQ2R0UbL5uup2GLlC7zJohlbl0ZuvUeULVmxfif5trcXgFWdkO/6KI0jdSZSFY4rlC5PREtl6K/PggnYdqDajg/i7Oux02HPKycOzLSKY4Gx8sXaSz5hcEtXemgO9rECqCpO8M1+ReAvHCgBkvIjHQFfsaLmN0a+XmFDk2HXZcYg5J3amVO2Ds2ttXLBtPyymh9ZF1pxYGm+ul6MYBQXxiPki3iq2a3CHK5TOQovwaQZY/PRxPhvbM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 07:54:20.9542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b26f7c-e90c-43d1-4376-08de99fb0994
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8119

On Mon, 13 Apr 2026 17:59:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
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
    140 tests:	140 pass, 0 fail

Linux version:	6.18.23-rc1-gc600baa82c20
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
