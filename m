Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811BA378D72
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 08:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821886; cv=fail; b=ic3ebz3cHxVFcWFMu6c4534QeWF3ci3/CM4vRw/qzu5SIIYT/3QGXWZdwD/EIqPC5hv38tNhpCSjYJhsOaBzi/OGcA9BA6W2oYLum1xYzH8nWU/ApJT7UP1UXtZvVEwifMu6GE4T+xILLf0GV6ukmwQ5PIVk88XfZ61Tvy81D1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821886; c=relaxed/simple;
	bh=VMWD9vw0Emh2GkLSsHJqsi7N3mJ+giCCni2/u7LEd8s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BjiWfjqxPSkCJdWXcOUGF3hjcttzWBNUwf8iK6VWA3Jc7AkPxENVXUtfqiLtzUZURBd3UdYDziGf5ItJV9NW9VD7JROq2yvUywNwwFYc/d7gMMWLAMkyZiQyZuhAO34wZUqW/pRfdgiCIQ67ywiGdi6cWY3FhiOX6vvM4Uy9yKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NHUy0bL3; arc=fail smtp.client-ip=40.93.196.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NHUy0bL3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoKUTgsHC7g3P3HkQ/xWxFnezrlUzKtyzCezmnLOq7XBP+h5YqqZyY7FB+EvY+p5inRzrAtVvak96tL80047aWXiDhScpZJNSTftsozffAsLasBLzfe3pddMcDXMIkEN/ah8X6crZzXzgVCkQuGoU4CRiRrgyBGZP8YM4eZ+X39EOkpGszD4dsgV/+1OTCPFRMC8Leg2HyV/Su67TPkPr6spwNTG0ft5u1f2evVUHIRdWdzdTbVyqZak/veaO7fIqzdxNuGFNWpbtsnE4ibvgaceZqLOAJ+rJL1e254DSil0kY99jiH7ZWEx9X3OELcFYJcMg3oALo1snchODl35cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmGhADuHgYJ+ACxgs5kuTclCiVbnrw8uCqps73uIrTo=;
 b=DXZXrOkryujkMYqnsd5Ct35ZUm7ZsKoFXdKOVmWsazw/cXFgzeQqPU0T03ocygcRSqRHrHXcORWxKczeFGcuo8ga8GxqgZ9G+Mx2GpAuOH8t0nwZ2KyfBFpiOncpKZvx+tBJaO8RRyi9sv/l3UmQSx5/OJc87CZDWVAdYFkzgUcd2ZPbmQQu/HUNcUPG+OWfQuf2ljDcoZO7uNrQuQGlx2BIzJlXqNV7WdlMPpyuorQcw7w67CU/gLFCmE+vroDvwx0AJVMhJxggZRkhyD4p6UWcRIg70viLSHwoTJqw+PogQzCleN9JvkBcXxmIEQis6YyQDPEZYEMmmvlBrOdt7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmGhADuHgYJ+ACxgs5kuTclCiVbnrw8uCqps73uIrTo=;
 b=NHUy0bL3QGab9iORDC0phtqrCv3AuMCpb4rADmKB9qPwQX4j30abF3VTDTCxkpAb3TyGALDu9Cs+tJ9cufRb28XJxG5NiawGrBuXTuDEHyyZlKRoaGGfHKz9jjPQ/kVakjwLAZh7yGGurDukAJpcefyTj246PRx8RtkIdLbbShAoluUBXEGDHpgN/nJAO6LwBrj9GeH5gpDRWV82zujyLnlFgPCP6KIblQWrRCs2WlH2aFLULir08OIZ/LRQxuRM4wT5yoiuJIS9R8jwEIkTufCFXUpEFTnwT1uJdGZJl7DYZN7amKKqhlwubQyR2BM4qDWjuhPGQB/VFJFu8Vj9uw==
Received: from SJ0PR05CA0097.namprd05.prod.outlook.com (2603:10b6:a03:334::12)
 by LV3PR12MB9118.namprd12.prod.outlook.com (2603:10b6:408:1a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:17:57 +0000
Received: from SJ1PEPF00002322.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::f5) by SJ0PR05CA0097.outlook.office365.com
 (2603:10b6:a03:334::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Wed,
 18 Mar 2026 08:17:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002322.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Wed, 18 Mar 2026 08:17:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 01:17:45 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 01:17:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Mar 2026 01:17:45 -0700
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
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <66c55ce2-fcac-4c9f-8714-a881e8807336@rnnvmail203.nvidia.com>
Date: Wed, 18 Mar 2026 01:17:45 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002322:EE_|LV3PR12MB9118:EE_
X-MS-Office365-Filtering-Correlation-Id: c774ed8f-6c7e-4ca8-ca24-08de84c6dc6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	c8GNnxC1MjW4BQhnCv0tQ+IZrOGQkXEgi0XhYjlXbVmAwTbQ3bdEGZQ7PJTuPnta5Z1q4iHJPTLxBFayGejAOPaXtHasijQKY5PxiJ0uoEdOruARNUEq1gDXdK9B/dYFo/hUp1fsEeCnQ9KLsmjLDef+g6Zy72DCJyn1FicAmAIHNHgi6WqunETYxtMKESem5bZq7QZetf0q8Gt78//hrrylQPFTHENigs5Ir4sPu2772DG38lbus0Zqo7f2tCMjAtznp8i2ad2ALbbX9s8INjCekt8KBiNbldEA2jLfSraAfcMnsMCFaP0THm9CIvS42QkW5V3iMhiC4CRVxyywCGxE1Kw8dE8rPxXBmmPxlqcwkwhuEsOy6scGMDtMuo5OSiQItw6xUwy+oPzM2/l0y05PTiw1iy7m0ROSow6ODXE6Fce61HZedxBcGvVjKwO7NGGgAOtJLJLgOmT0ZL9Pe/83ITZxp465xaazJNex2EIhuHlU6fe2o/ZAY/Cwc/NMfnIrpRwFIhf37pexIUmYfBgzJ5PgQ9Z9b2QNYSv/EcJkNx2SAEPY7e8K5fwUPJwoatrqNvao9wzN004YZpBNOrSmIVkGvVAR2CZNDQoMA0mHHQgP4te14Ftuu5rark0OnabtusAP+WBJ2tSb722nd4S7JhHIJ1SiMPkHJplaRAg+aRCjzZ1KJ6WFe243SiilkaH5IjBaKK7++UFd9fR7jj0jfIZe9xh2iVbEiB/GbaiJMOcKnRRLKcvgD81gF/VUMqlcO6WHPRAxuvNgfGGgHw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LtybTUIG9xxGH0373DKPU0tbNFUYrocA84hCjxy6MVr8YRub+Hc7nY1GIWsYbR5YZiz7L34fnYZoVtqRWM5zrtAlvmThLZ07iMeIQN+0FcOlbJKo3vHcFryoyWlDhxhAGWlzBATDqJzi1eIYh0zTbD299uW/aPAEm51e1QAcaeRuJptOIu0aHpsBXRVvq/Kq1RH0yQsW+eeoo+hiCQoPYvSO5HrLIkdaZBN+a1bO9ZD5FXbgkP6FvWmwTRcw0l3eh5+nMT7bi3Cws1cMVlxCPFfpjUTSxrzocGA2HiXZOj4IuXUu5GXy1cvn1yO5w/x7+d9nQKp7AE7lP1sAjbIyxdTz+/4+bmTRlLcj2mIqxAGa8ly4jvS/aR+Wdaol2QEuItuTlOhafuKA6juhEnQcjETsR57jZg9GUvokxPndu/r05nSq1SWxyMHi9B67u6j2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 08:17:56.9470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c774ed8f-6c7e-4ca8-ca24-08de84c6dc6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002322.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9118

On Tue, 17 Mar 2026 17:30:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 333 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.19-rc1-g1bd1cbd8a3ff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
