Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330BD3CF667
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035176; cv=fail; b=Hq0zMlvb/6P64quG+YQ0ImKEG4zX/fkPTnwLnIp5F0rJqpWZC6IWE7K7ykiDx9PV+d7q+sK0W//7BemuDl9rkEowRmYgSBp3QMYrs+mLXnfjA3ZLifC0vBtspakhksO+UVCK5OGVxzUCC97L3ujXEXpJ67Fb9RSUuojhP8+UB7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035176; c=relaxed/simple;
	bh=o7lWbkxN8gsKgcYFQ8/4SNwvbycm/Q3FObhDh1X+oCY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LCrryWZWAW5B+hdJK1qgUjS3mh4DH42Bi1WaLpKbUYsUDtqVKGmo5aSFUXAbIhqh3E1Y8+dPJqSXYl71olNu2m9Bb1L0J9/pldrcRw2wLkBWyFxz9lK5bYXKQHTkJFRjUOu/0pzEgSLyF3XVjIXPFlSuJ/cuVC7tJlyueLfaG34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tLLDfBf8; arc=fail smtp.client-ip=52.101.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tLLDfBf8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Te47Gww2dB2yGz2dYX/nfQawcDyHRedlH0/MyBG2KNIJH0WASfkckfo/5Skt7T/Y54tDtaBJ+6xNCd7Kx0IkTaZbGMH5MidAsKv4UjcMcD/vQL5pK4hdCf1b3eQZQNJ5FC7Twol73Nn0FMa1BSkE8C1UJ0/g4YeLNWlUvIhWLxt8dn1J6mKjYdTZy4zdH6OqP2FS5phKh65ddEl2zZru9dSheeha4kM3Vq4BXpb7CDlG+1Tz9lDZg7FEYctzCYNzrjoxEdify2WBap8XPvmN9/Eax9dEu8CXcYZtvSu8A2zV65NiyFECmualP4tGq+nI057a3ixkT8VjktyLrDzL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAeRhaP9W9UIcXJOCBOe4cfPCCZjJ33LWTYJ3RfkrsA=;
 b=OfAuhxLnsIdfdnuA2/rX7oRo+9FY4hWs8YhoEocHEiy2lk1+Ju21DIAV83EJp8dKqDvTmN6A6SKFigcn/XNiwbxqUPt1PMwU9XqHYQ2aga6IBQzP2eNpfIf/4FJrJ9dK5caUr7JVF+PC28puX/DHTfJ/sUEN/9ToemITQDyM/xyqJ3ceSvH0asiToHfoMo3azich6hve/YGdSRfxRiKxzC6BUejcvcezeKKH/S6y5pZJHPcTLGk2ldctcTkOqaDx9jN+XP9I8cGj10iiRNQ68+1PYAyrcHHdZCapIp9tWrmcLUEJlC2LoYfjRl1/uTqZ6b3hc2eSE9MVeXBNrwljjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAeRhaP9W9UIcXJOCBOe4cfPCCZjJ33LWTYJ3RfkrsA=;
 b=tLLDfBf8Ik6Ek0nSv06dleNwUxF1bsrajSSjmx+SVhxjodWdlr9xDsocxon7eObevONZSqbbKQ9FpZp7ldiSszgu+lyr0dbf3ERZWa0m68Kss1A+rHns6hUk/sSIC6u+X8mLVu4LTtDLmLrMPNG4Wn7ywBUpsUfJr0FK64nxtZIYY1d8YuntpZsxzgtGNrmEBDPoRYw3AHUy/pqT+41weS5SSR0XmxAYgqMH1j1IWV68UCyl/W94Ft9MhedjNpSesWOGSdxeuDBgQSKi/pclDLnJs2AWB42sGfV4SDl+8d19xNqaKe5z2ZLTjQHvu4h/swr6mbHp4wYRdhcAzdQYhQ==
Received: from BLAPR05CA0039.namprd05.prod.outlook.com (2603:10b6:208:335::20)
 by DM4PR12MB8500.namprd12.prod.outlook.com (2603:10b6:8:190::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 09:19:27 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:335:cafe::8b) by BLAPR05CA0039.outlook.office365.com
 (2603:10b6:208:335::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Wed,
 1 Apr 2026 09:19:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 1 Apr 2026 09:19:26 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Apr
 2026 02:19:14 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Apr 2026 02:19:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Apr 2026 02:19:14 -0700
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
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3cca2f4d-2e8d-4354-bb0c-85ac52aab29d@drhqmail201.nvidia.com>
Date: Wed, 1 Apr 2026 02:19:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|DM4PR12MB8500:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0101fc-42e4-492b-eac6-08de8fcfc5a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|18002099003|56012099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	xh2ODx9PpeET6JyLx6ehVQ3+lm7kb9M575yLl6aJ3sN3YMY/VfhD/o1VJr1/ZfR8ofioxBcoHUgMFnnu8Rb9QdMm05SWE6s99yJTNFbJmAm/K/RZrjr485l+mrNserMQ8h7fJ874+tVAubz28pniKTEzt/VjwBJeQ2NUf7vsa8GIZmG6SzgKSoplbalmUP3nMCS+dX4pqcXW0dJN+r/MsnzOTXvnIG4UtMIzpzgYVKTHguXJeSEwc9Km6btDhrF8mWCujPL+ArfK/Mg4FoB/QYl9oGktXZCFRcurNC8L+o/x4B+cDuza2IUCLdq6jxS8FW8NT9pksg3NSmSq7pZa4HaMkAnPGyCxrBziX0jMvS+8jwQHcrQ+zW/Yk4Sqlx55GGC8DLDqKum4KetQ574PcuXABVCMQBs9Lbw7lh2WAP3AYIbHCA8emjnBJB2z/D+elW7xnCymahIEQjCd3Io5UJrEi/XRuSIc0MpEYHlxLRz0MYMASyaHe57W+oCpQDehreWbPHx8gS5I+TcuVka3RdvzrvgosEJ4HjSyNKRsTj8f5EoJJznkXmGPpxP4R7w+xOnara0huyHnht3x5FDQp4YAtDgIhrJbXHnV7W5qBS+y/ZuK85S0c/o1xnO6hWYKU0391/J8ipQ6sD2WR2BRE/ktBDD0Rusjz7S2dKbCsLi/bK1dN7+qGqiBTf/7k54ewXAtziZo60VeKn97k12L0tZXdlY74wZac+jiyVHhlgqU1TxPbCePqDENl3VYi0Sq0425f6egE6OIS7H+jOWgrg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iApoobDoLG/5q17xhkIhQadbzD6rtMwaaH/d0E1vDv4WuaCFDptgLrhijilcOCvznVWU4DkKJ3cmfdH6sgCpgx91ruUs8rwhyqoHwfylmaY4HxRQuhBxhBMY6X8zGNIaexyOAHtXAaHGDMKUbihfO+1beQv+y/LsaM3bkm/qa1Y8QJL7dG1u4RnZSY0H/5YaIn1sbsteEppL4ue/P1NLy3eXq+61Pj92RXF77Va9d4jkUFZLVFQFVYD4wv6RNdLVgQvRktEe48Du39b9kuS1xOBNQnE2riPv9k7YAfRGnzRT1L6gt9VYt/3tvxaaA+vPAugpAj+Nmb4gA7GJXXHMtrNL6YCJ0sTg2He3aUgCx3nAvEjnIgChQqVOsBVHc/rWy5uKJlFUfBmei7pZxbD13zZLw/bPkETKvR9oL0GV7+7M7hIziQu7azYIeB9xjdtO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 09:19:26.8035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0101fc-42e4-492b-eac6-08de8fcfc5a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8500

On Tue, 31 Mar 2026 18:18:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
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

Linux version:	6.18.21-rc1-g489a397a6e94
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
