Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995723E0C6D
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457265; cv=fail; b=S9eZu/BJNqtdBQTpoPpgiGxeYzY5+zS+/E3oqTOQwkKZqOVe1lV9Z/RwdwWfVhIqk+FcF2vOFQo5rL22tLhn0zFn6Vxy9W5tsEQxHTtjw0+H+c7eaQLoDHjeWN53iY04K8zF8QUSPKUQKEXIR80OLNP40zKQElfemuU4KFCz/M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457265; c=relaxed/simple;
	bh=OoImRE47ikWnyqkVHiptFZYIylFMHir0CktV+AtIdpU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=C/RTUkSmLfZN2B1tZ8Z74+hhOavPkN48sbFAGLUUyDnCl+mJ5dsJDtKCI9os5ZyQnGf4w6XcAzaV9KrMVaMQP8Gnc1EbaUtyxOHTqOJ0vaI2/KnXWOlVdtbCxhnazXgodQiwWxPa6xP7snO91Ou0sSnL+W+Eo6oJbIk141Xwaas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QB/ouqLw; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QB/ouqLw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KydnIKsfQ4Ty7GEZDiw3dV2pLpRApSjjGVu9BHYmdIVewQyulB+RbhwAz5IUpMKWHvvzZRST7qEdG6I3hUNzRTpA3jdqaic4sym1qMfgGRr74xNCDGNMAEDa8Z5Wsvdbs0gU/8CyDbyXUb6VKKLUPfRBdFe4+1ifDzh6rWv9DZByxF+5QdeFrb020Am0i6APfV6BfWZ3cWCbvUwZbRmNMv13/T/blrqRqvuv/EBoj6ggLLFHo/U4zkUQ4ZbjyHQ8X8BuVwFuhYSXz317bNQ7o92P7xA7LEmjZiTNpj109xjrhkgJnI5ESHeIK1F3p/b4sp1xsYRCZtRghxqoa3bPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UjqvCTntxk9D0/xasdBnxVMkrlqUowXqlnHyzLpEvo=;
 b=HPv700kuefMaMhLVKaiBrqb4mAb9bLW5ph5atuL97ztDkyAQMH2oMs53+7kscQuCD/95rd2CPDsQqiYCqgvqPIliRxWPmAxps98KLKClqvVhlE96qoFUDaAJKyOh8QjKCvyX9sUhN7IzXr0h/ddymx1cVb/TGs6TL0G7T5BoKQ1XtVzQQ+zb6MqSd+3wAcoxdoBJtXPGioNSZ+65/TTRoeP9vkHbOo46KEOrj8AVD8CSXSkVbc5Pggz8UnXq0VTIXmVuHlPG3c5btBPbKBLhxmDXIgA2XC2DkItkd9RgmjPpSfFUbFlzRs/AUp8CND/3Q0VWf6RPIx0T6lYzHglTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UjqvCTntxk9D0/xasdBnxVMkrlqUowXqlnHyzLpEvo=;
 b=QB/ouqLwmq2bh9fx11KbFnF4MCisMxm2bFgaDFYUgVe/yEBRaxvL+K8sJoXMF8+vl+JG+BjFhTGWmIKnhnAgOE7r5fpK07yOZGyqQp5SDWT4OfWHAibVi4zRIISWol0B1aqzADJVrDo1XWG/zK++JpS5PO6f0P+dscF37FrussbDQ9rSpFlVNBU6oLmlnFbrLS4OQquoNN1vBiSIZHyxl8+Px9ASg/2X66UwXReh5DeOAfxse9acecRRFeRJmx0MILFO5xyOHbEPFoyLAZAgCozJPcMGcu3zJIL/IXUViZ5JZysWVV8aFhZIiN+DPQKbloLHmEjENvSgv4YUd7wd2g==
Received: from SA0PR11CA0190.namprd11.prod.outlook.com (2603:10b6:806:1bc::15)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 13:14:17 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:1bc:cafe::6d) by SA0PR11CA0190.outlook.office365.com
 (2603:10b6:806:1bc::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.19 via Frontend Transport; Mon,
 2 Mar 2026 13:14:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 13:14:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:57 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 05:13:54 -0800
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
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
References: <20260228173244.1509663-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fc9a575c-e91d-4887-8708-901a3b73bf7e@rnnvmail205.nvidia.com>
Date: Mon, 2 Mar 2026 05:13:54 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|SN7PR12MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 878603d8-958c-48df-e34b-08de785d9b81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	mbq34zaWZjL6+F1k3QwYDGaT2DtKjrZ/bOD9lRHxHh6CVT88st8jRoqAkivoaUo/hJoz915V2YdjynFWQy3Z5BqLOpb2D7X0VONMGxfdbuV3xAzjCdKg6Vo6i6IGF+C2NIjtHUkPFQSPqkqmcUmo0v8lZYx5tPKvV4JsP22XIZrFMTbpEvxKOrW7SgrLdotb4YMgUj0zDvzK2AWYAfTQMOgkHuteAF+2rYWLb3bVwtHDQCnPOuF+G3cVTaKROwA55oQfwChlDM5xvOtxLvH7CGVXZymdLyO+a4jx0i8QthSrfNKQM7gg/2CbcWBcJEZkwFBOJ9uiJfHMH4dc5f0sUjYqxEis2PI2vrQk2+Y29nhGP59JtPAEexnu2eTeetNq1/2fer97/2fUFg6S8Ngw7qo2BkI/V24yEuJg5lwb5vNYP2fJgcBe+/rFKtdN/j3NS+o+yzP8S6lTx1USttC0ShrIcpERX6L8ViXHsMr2l+56R/b7NEHoV8M+dYeD+MABc71747a/kdRrwvtJzSgFf0EgRX8aAgXGCJWIeVnPlvq6hvEHf5B5iPZAT/ZVbebZh/G+IEKvmDRfiU3bmOlHydd1KeNjFmHsJVTOigDce9LKDbE9XYocnM2HS6veaaSBZiilC6B+op+jUOD5U9X1TUyA2FpydfLGztpaYaKQAQ7anbkp7dmg8XZgTtx+mcqS/xQhZbfhrshnzNTCKaYpejNs/KEpDpnWP51q04NcgUsjeKtcYGoGIF7pnqpg7Z1FYfiW7wqjjzUwd+hbRJyJK2np0YujvnQQBifvNVUjVNjwOkWKXFfXDdzaKGPFlZt1AgqxayrBSr3O2iYy3FG8Sw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	59yozmMMwaKBd6YzE20poJM2el+sagaeDQakICpXPDpxXgoZ5p4iDM0JYbuma8h1O0sJQB5qeipfucbCdZgC4laKQ4CVPyJYlDyMJF69yp7K519jda6f7KWI3JNv9C2eXhKyQdxrc13abRFqec/XcTDgpd3S4kivIo0D3Qgx9pfo0EDHT+7Dizwj2MJIMglWbCv89APXRISToWJxuya0OV/KZrSaukWu/2NqGvAhnKKK7gJewhpfu5Qw4JtvWHnGBIsqCM5EmTbCAkY+6W0smmVRshxJj+dPzulB1L84SQiP2XOdu24auY0TA6TGff6Xr/TfHXKx99o+LzbunySAQVFNtj4d9Cq1qSLgzr3YGVV3aTqqLbIBqVDqV6vOlav0ZUhC1f1ZVx+iRs/c2+Bact+d9U0TubfyD5Lad102rktpP6eJzPbna/Hp673eFrwI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:14:16.7917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 878603d8-958c-48df-e34b-08de785d9b81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786

On Sat, 28 Feb 2026 12:18:33 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.19:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.6-rc1-gbf28ec292fb6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
