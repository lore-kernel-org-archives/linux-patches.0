Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D3F12CDA9
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707994966; cv=fail; b=Ac5sALqtcukxtpbbjNOv6PI+q2gqAR0DNZmsNn92O2h+vvyWMXvqsvhIB8bEm1UCRXGUuW+kVu/K+auc0Y8ssGhuJIMbEqcbBObJ9B8Q1XI6dmQF5larbEjgAs0LrPtBTf5hy1uQS0FNjVRDED8gKR4Ye0z/beHTcoNjxSM+h4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707994966; c=relaxed/simple;
	bh=8mXxiCaVvELt80y3xpfHOk2dtFCGuT9YAwPXcccnQtE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JfFhRgDKDHFCxJC5yr43oQmnVn5Gmphy9RkDiaGd82mlxUj8ohckYk9Pcc3kEmrVUwkNx5H3KKgDslc6GCKPI6r2EAdKbv85nTBJBxEiMfSAWKffcCCIMxswqc50T/PPyOqFP3/HR71RO3xnOdgEcIAK2JCLdV9IfBWhGmRexmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eFr66VwZ; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eFr66VwZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixskjsIdFot9Xiqwe1mgdbY4WC+OsZpvDfGERW9Vos0LtuRMWJQa5+Zit8OvdnuZLtd9nmLS97ZBvq8JgyTLwn0091X6Dn/qV/w+VQD/j+X19deF6rZStgPDW1Jb8NKga27bxEzWnnf5lnPKeJhEgqdbiPlBnaKZJfGYZq1kEZmYxtWIDOXZ2uVAdEsyuSGXRgSI3+2PwR26H4bcpuOs91vDxW7BDKmjHvBQZlkfr16yQO33VnUPHgm845BedROyQmMivkYoCsugrGE9SIGfG23JH0PaTeiILEyEIydjjFHcm2HIHCqhJhNIE4bBDJB+DeBAzxzZ9o7qOg7MuoY3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxE+LQBIIZvyvFSto58/WXSG8D9WRcV9U7LWrTOThnE=;
 b=HT/EYaIkdMqZ45fzCHtja2izG0w4LZ6cB3IU7CvfXYs5H4nK8ObHjCNwiFlIcIa5dWne23D958K4g4ix2kq+ekutZl3upM1PHRLy6TQzOuMM+5desyoJmPIGwdvuvfYPJyxiD7cMe/KgfscqodYFJGBd61A4KEY7fZy+vskEh/OJN/9xYz1sH+sEJIvbQNXPHILt+4LEaOucoFkQegph8EYYZdlS/3Pps+5RfoqlmP9Tg76la66fMoH9nOon2NLDmcNybiIQiGO0uPyrCjY0kIVBYpd2Cow/owtL3/Uzk5M1+rZpfPcGK22tlnZHDwYOTg2QWGwqEZoqY3JW5ve6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxE+LQBIIZvyvFSto58/WXSG8D9WRcV9U7LWrTOThnE=;
 b=eFr66VwZu0cYi2x1nxeUqz3aZ1DXnnmK8z3vmOqnIwqkY8LJxpspCr0s2V0eN6qvhwr0dhRv9Etyy+pS2vRvarC0sORQMXemin8SLruBjgZzAERaodKb0JvraGs4uhLw/de3RBbhOhisdmd3zNPs4E7tEpAXi4K+ogGtjUl5bG167XW2QrDRs4OIG6w4/1+7FrXcUhZaBR0qMofblY06HOQMMN4Sxd0OM/4zwhQbtNmxsbgDgVNK2xp+fJfsEk8D5/YV5BnT79y/u5zHFhzpp8j8xOVjWL7kAl0G9mXEXjky/cN00huX9f3V0b5ztL9LqBhIqZ3ybXkjK6o8nk48Ug==
Received: from SJ0PR03CA0389.namprd03.prod.outlook.com (2603:10b6:a03:3a1::34)
 by SN7PR12MB7108.namprd12.prod.outlook.com (2603:10b6:806:2a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 11:02:39 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::3a) by SJ0PR03CA0389.outlook.office365.com
 (2603:10b6:a03:3a1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 11:02:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:02:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 15 Feb
 2024 03:02:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 15 Feb
 2024 03:02:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 15 Feb 2024 03:02:26 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/65] 6.1.78-rc2 review
In-Reply-To: <20240214142941.551330912@linuxfoundation.org>
References: <20240214142941.551330912@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <95d9f352-a5eb-41bc-9103-b6ea2a074176@rnnvmail205.nvidia.com>
Date: Thu, 15 Feb 2024 03:02:26 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|SN7PR12MB7108:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e2464e-b839-474c-54be-08dc2e159ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ASBLR01XPNf5EchPiPpro7oZLF7I4rrLnRidNQo9FszNYOJ3YlJFBaKU4pKHvXVb9Jh5zOXAmhf5ZcXrwfo7osGDmlSPNYpSNAETrKvn28sJ+/sE83oESjHF3a3yPqlPDyOgV9qoZX46dz5eXISwn+bBlsNzNUhcpQW1veatffVYrj9f3oqQSx8ympCtyoLf7jlJTMwc/Y2JfObMmkEmFd/y2JqhH6sVc+n00mCC7as8L8X6+1iF5yBarjrcc40gQFJrgD8D5N0zdmafL4S2Rrk4eghRHpR/G94X4XMKsR8DtkNOOEph/XxGeBGm8DQgAdM3XuKK3P8SNzXrhd9M+rXun0d6ujSLaaEpYLAWpLJjPzvrEh4eUSozJ75ODJXzdv5aVpR0aD88AsZrgY9y4I8Ml9zgIUHZ0vYp1G/u/2ytRGqK7Pfa/ypu0GXxxeoapld8/vT6O4YIkrK2x2rhlPEgxrWuklSzJU2/WXfhGKgrHgdvNoOHPBKKSbtKtwoKiY1GVyvERdZUHo//6v7cS897lpR+0BJE/KsWNbpioBRnY5NI1wM9EhBEWN6nQe54CM/5Pxy40PcjwXiG6/cSz6Jw9xBQJv+tBryvVz9/qK5W9nHNLBzUl35YaSCbc4I79zDQqKpM1SM/7rHKeSpB44flWs+sYOMJZMjAYenkByEPdbPjQOUCX/Xnyi3sPbiyAFSnCTJUvdxAyLBYW7hl6w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(64100799003)(1800799012)(186009)(82310400011)(451199024)(36860700004)(40470700004)(46966006)(5660300002)(7416002)(8676002)(70206006)(70586007)(4326008)(8936002)(6916009)(2906002)(31696002)(26005)(426003)(82740400003)(336012)(7636003)(356005)(86362001)(316002)(54906003)(966005)(478600001)(31686004)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:02:39.2104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e2464e-b839-474c-54be-08dc2e159ff2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7108

On Wed, 14 Feb 2024 15:30:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Feb 2024 14:28:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.78-rc2-gea6a03790c42
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
