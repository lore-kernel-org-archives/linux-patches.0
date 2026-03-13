Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012062.outbound.protection.outlook.com [40.93.195.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617923C3C1F
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418605; cv=fail; b=jUj6GRvJ/dB00vdbdWp3w7NOHn/27UMqgTNGEKbnkbp3y9CAgxZKUOj9D+IZIkHd/u8ap9UlknnrpmLNSRZi0ZIXApgy7yTmulJPOhLo52AfjQN4PPJS8Sc88oyzL1SN7f20E7NWBn9d6SBvpZ9FnyWqDOElfwxqCh3W315/k5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418605; c=relaxed/simple;
	bh=aMNQe5L2HMP4wakwKYjRIMta8dBbxT3mWJB1NAc5ATk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=R3wXp57rE8wIowHhqh3JWhAtna+mZ7PfZ9ne86EpLcCX0K1dDno7UFn2O8cm9rNqG6+kHTXGXKqo8KDHUKlIaMPFCfNUPVGw/sVVAOU6m8YMz1u1YgvoVsXNS8pGhsvSJku5XDyERvWpuheJ2Co3ba75PwqeGgpU2+om7OAnP5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=icIkI1ID; arc=fail smtp.client-ip=40.93.195.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="icIkI1ID"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQKpZry7ujo9mlfSn9nw3GqN/mZ8MV/BYlWCP8svQFprECRS9tLriTyw09LMu7c1//2Jbi/NZCJeMOTeu4yWUCL2SQzmKUCbBSbjIH11wdcRteNcSGBmWWmTVwUUhkyq9tWqygURJLqhvNwQTgbju5IbLMNDYIxb5LBnBTJ4pVFzKTAC5901yNlpl4dWjuwPHdnrxI4AzWrskKjRFsVGDzm8x3cyapQnqdTTKCJa9niGB02GBF/n1isWq0l5wrjkodFHh/3AuIGNwg4L4DCcrM/Mc7r+SebFibuvD0ZoDpoLJzS8qvJaHtLYtH1+QaITk9D4JLOTxfzSbSDDcuMB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQfLEJ0a/giyJHmeQ1cwQsORHDgP/Lv2c7ZUQ/oiLuM=;
 b=nXPr8XSO55E2Mo+jm1DB3EgWZW4gUYOO8SStLC9jkrKux0bvL8xRS1JuA29r8iMGo/30cVOzqV4q48bL3AS3oJKDmeSVncGbM0lsN9ailjWY7i4JIiwMA0pDVe8IcuJs1Fbh/ZU84WfjUP9WTafXRBbCH0q7caD4rIXZZCWSpBRgYWIMROkiDhgr1hE56rdO7F7eJv2MFy1mi7qW3aDI2kaKOJV7F4Z3beoLuqFiSlcAYRGRvvXLahJUyqZONNEnN5aGdMTvostiGUE69VpAZhdzRLDHTTJhm4uPKSwtnsfR05agoOkiBIr+N08nM7MdjFTreEwuqXM5b3hP4VZbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQfLEJ0a/giyJHmeQ1cwQsORHDgP/Lv2c7ZUQ/oiLuM=;
 b=icIkI1IDNPpWjYOnTlm5MmbBdNtOyZII0U5XrJkiIFessLXcW0wwrr1dbGC5kWuBxnJgso9mBWWeO5BqfYV6SnGf94EqCbvGvgHzOvL2b1CgySlB96fOkrLGSbhXT5sCb6st6B4LE/amQVDPmZ7FWtKCSHNnh3eouTHzio4hkbmxsq8Xf9C4yz939LvUp98CZkX5rbSYw8bEpSc78Z+q9d3yY9tGMY9vh7uG4Ok6ClKXHwmXf6PtzYjbmQc/WORhcF5YUW7fO5AltVGN02m4U+sKjyqiciE/n8+ozKx0+Hoe+N/ELv3Y/BK2KJaWZzudUjUaMWR0dfrTvtmQmW/4iQ==
Received: from BY5PR13CA0020.namprd13.prod.outlook.com (2603:10b6:a03:180::33)
 by BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 16:16:37 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:180:cafe::78) by BY5PR13CA0020.outlook.office365.com
 (2603:10b6:a03:180::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.15 via Frontend Transport; Fri,
 13 Mar 2026 16:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Fri, 13 Mar 2026 16:16:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Mar
 2026 09:16:17 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Mar
 2026 09:16:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Mar 2026 09:16:16 -0700
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
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bddb3680-e01d-4eb6-b6b3-c7852ad1297e@rnnvmail202.nvidia.com>
Date: Fri, 13 Mar 2026 09:16:16 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|BY5PR12MB4194:EE_
X-MS-Office365-Filtering-Correlation-Id: ba362311-4735-4975-1405-08de811be6cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zTkgX07k78b4j6PK+J0GHgxpl2+lbsiq4CHXNApdkITBdgqE0XlGhkYJmJzwZFMTmpK3Tb5C3eusVusAyG9pr755daiZAR0lEYSpfQT5vxfrw05+KBTZClgLtObz7ZGg9SLdhEp03m+YbXbTkdBuMcZQv3c4Fi0OmppNT8D8/l14x/CL+CQrzKWgTLYF0kYgIxIMoyhXWVewjVDyeBTDdkKH1GDt8mlFlirgk0LZffRjp3HPBHTm7b1FL8OesqJLvtXU3pLOMbQKa5jlg5y7zzEfn02p73SKBiHsrmrkiAbGi/mkq+toPx07AEZdxX4t9YU/3TyUyiS55amwGZqcB2vg/DhxVDHNh8ltTj24ujK+t3I6HDKo/m3Zts+l1pVpgaaWgepmUeFvGgafFuAs2rXRhCR5oisoetSYtEygVdADk7vJSo8/KZuj0pSs1gJtgbkPqOztQGWoJCFJeUuYzV8ceCIEwV8YdzpfxHkvPfRwdBIZod+mhswXF3/bXvkwgq6Kd4l6i2PwpJPUfJRsXQrVwFrZdSahmoHjMtbTbjU1qdz/v4khjSU8vnct/2aAJ9NY7E9QuaKWAH1j+oDl92fK4B0C/y4PThRVG49ApV5sU/oqyy43CesRnsa9pF/0G+EQ/kiSSJwgYjnX7L7+u8kwd5cjkvdX97MZUazZenvEZfm/XXHu5MkStm/6FjUxsth8hD9sf9iNSzWm4zs7LSb9mZIRMU4W2HCz83fEJOK5RCGgit+ejMmvV265mdOc0MVQqop0UQMJtHVDdf+zAQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3HgP4Hcu3wilfVNKdUasCg9oxSNCCTcCOBDDConTvpul9EMGEjxwSi3iYX8OpQJLbtvfBU8YP26bL2bkM5vJnHVH0wzDXNal8zjvPMluGTaQPVRMGzv7kHK28n0IDAVZOTQR4slxlU8UYkLgzu7IC2BZ509R+/aUUphgTi4/MPu8pisD3iL5y1GrP0TXW+evwNASxzhSvdtITmq/JDvv7TYjpdRceXF0ss4UhBH1md152wk0B1Fr6pEvpI4d0f4lXPOZrn2p83wwXoUnSKVCX32XusQwoFDfj6IIBKSV0DwrKLB+d+oXRvihI7+5spOH97SoMA+dAZIXjfo3cLnfE3eB6bcIqCQP5cty49uPEBtzfO3StcasgB5+Y6W8zt012eBtAUGzyzKgcTo5LpH7uj5355DahCbmQdBE1Daph2wEuNV3xg3yuWi8S13Jp1Ub
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 16:16:36.9219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba362311-4735-4975-1405-08de811be6cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194

On Thu, 12 Mar 2026 21:06:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.77 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	132 pass, 1 fail

Linux version:	6.12.77-rc1-g92f326b98fe0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
