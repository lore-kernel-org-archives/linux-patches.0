Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD5A33D6D7
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 11:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772538792; cv=fail; b=EPuKqAjnRMNDm6mJHkfyecHveH4j0hgNhGeJa/YY1yi/g3syjLe/zXTa+k9vYOj612gW5W2Zq9L64L+/zl0b1rhcpUMY2caa+MHrwAmB7W4ddFCPQg3432aWC1F+jph8UQxsetYi9Ow77ePnFIatE3g47DskrpKPlrzQHoAwKIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772538792; c=relaxed/simple;
	bh=yHoRX3jGL9+yzRVLXJtTfKnM89QGXScyLik7DQNv7/A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BSpveBdWqGa2kqQcVdbOadk0xM+VlbMvoyTaGhIkXP5Jl3Gpgx2D7GR8Ry/ZN+WytZRUID9efWSic5R/xITNhNjZ89Vt3yUm7WzvjTmlFlGyo/cO+xQgcPn33IauuazKKm4UhwrYR+B8AhFjeZQeDPkDCJ+DJA4JeCyIbzGnaE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mq3XISBI; arc=fail smtp.client-ip=40.107.209.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mq3XISBI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwhDcUFOkkIMjadPg9OObHb8I6NOqbDdtC1yA9A0JQ3YFwI17kfjahKyNCpR1tYSve2vg/uFRU0rMV0S89Q3MNjhYybacj+3YAW5X+5YRHXqwZm1sEcPkPFT8WptIdyWdPH9WJd+vpvqaM7lGt+4khzqsC/ZZdCacaAWmEd3uuKeZcXzQzJBFZok+OkDNwEITMUBpzqJII+YYWNyWlFE+1fstoY6cCFp5jKGrH26YTcaEDUBiy/srfiK3brF9mpHZjAmaUc+mwqEE8NLv3BTC1vDWigheJ0wFkgJrZ3fpYfkioO7Di+Xjkb+G9YbrbdpUQoKi3tEXuUtu18l0I3JWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1S/UZE8onoW3j+dS45QLmsHkpj3xNFsTCB1ZcoTMBHw=;
 b=oreT2ysdBze9cYuD34Prox8LFJHo7ncuVtq9UuQh1cYsyKSjn/qXkthaAMBQEDsqtbuc7LnMgFLTJAVW7NMkIxHUInwiob8401CikQsOEo6FfJYAsDnHQLzG9QCS4eVNuzETw6KQQE/zbO4zwxln0YYOTNhfu93wBJQzGSN7lPyMmf2hBxIA1YBdmIJm6t8Xiablm5Y/m/fzOv04KrgUsHanOoNGptVByYbC2n7mbLUmCjeGbAF9RzX0zj0BXNltl9CdZhuq5otrZkAl88Ib36DVPPoEx9P0UXY/Vi3I4SOM4k5MmSBHf3cgsC0rkXO9gVMvz1Ja9qsd9HdGyO+19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1S/UZE8onoW3j+dS45QLmsHkpj3xNFsTCB1ZcoTMBHw=;
 b=Mq3XISBIzqvzPAMj9DoQGDhegg0l5nkNF/z7Z3frkmLapMK2MxnbfpMA8FcbE/GS9eyI7kT/1DYAYGco3dEXBp8f1S5yySgMdHGaxI9SGTqgpEwcE+Xk5bmpXqYWehpUkqffzi2q+NVKjiJ+khZrNpakRXRumK8VIhpTAnxEoqM0O46Ropq7TPzF6MQBLoPScA7gZXBkyagAFoiC39gTySSkTtqZl2ugMyE2GaBYAAHtIvrGyXhnP077Er8fHdPyvrBLssNFm7TYbMZNbF4VnUMkUnicbov/XcJtLpeK7K3yPYdnKkMTH++mBKl5xMTTBa47ua66i1130vpnnwiw7A==
Received: from BN9PR03CA0394.namprd03.prod.outlook.com (2603:10b6:408:111::9)
 by MN0PR12MB6320.namprd12.prod.outlook.com (2603:10b6:208:3d3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 11:53:05 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:111:cafe::f9) by BN9PR03CA0394.outlook.office365.com
 (2603:10b6:408:111::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 11:53:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 11:53:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 03:52:47 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 03:52:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 03:52:46 -0800
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
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
References: <20260228181119.1592516-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3ff77992-c1b4-48d1-9c00-fd5cdcf665d3@rnnvmail203.nvidia.com>
Date: Tue, 3 Mar 2026 03:52:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|MN0PR12MB6320:EE_
X-MS-Office365-Filtering-Correlation-Id: 5da2f5c6-cbf6-44e0-5b26-08de791b6e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	x+RdKUNp3qemiVKsbTc7Fl+uNhzt5D89mauKddZDTAZwTLJaeyU7vEvykHtzhiUWp8V5HQh3ptxHrOh5m8A1ir/RWUPjtHN82sjEyovLlUHTK8X7tKbnveh8biqpgaTQ5lSHAruEDp5G/3q2J+yzDVA8+QyTE22mUEd/JhAf0EyngbNXahv4j1XzTIuluy0VeDG39030BgBQc7tWwd4cjdcnLp+2D6FC3tDGh7vU/Q882//RxNV4hF5UvW6Q9CV+Y5KhzppKaxqxLVeP19NzMehXirOMx/uAYeYe1Efzczc5k559iF7U5zDWNrYX5EcYGm4Z7tcuqEQLeUmUJZghcTW3jeQb0s4uB8p7SkL8DGjnCaQiApk4TCgMJMBJByeBiHheqktvhlUAWantUmOKiuke5HpU1+uu+c9aokOpmC56cFRaBF/Pkew8sb/jZOcbUsDiXM+mBNB1TPaW2HapySCBWk1Vxg7/i6mzCDQXBJHJlxFljwN31kqbqvKcF+hEZCX09ENZr9RoIMcCoRwZeM36SbJ1NvsHoSMd457uq7AYXyPZY38tL/9Ht5ZT7LRrxplbr3NRsy5Y4L4rbDeqi/P64qDgUXvoidhBOXtCNTI1K/+7qa5yAZDeO+yhzFAdzrX4KEpN8tcHiNXBUaBVk37OVC0uQwrDTiNpFGjBoLBI3LXzMnJWc04cJCXHnp4h3cdZnHQFSs9vSAVzyo2xgnQgqEmuIHWxLgFmK0VnMGBjtdGmBfEbvgDKK7A/VK8cLQ5WtAwa4AJHMo9K69RZvfRAOXsodpzPpqhF7mIwECGnNdkCWM8tdFHDKDhrEnMsOIykthA93lrjWLqi9OFcXA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HZYCi6EC9LBHDw2cYh+OGkCeWdlpOzmK4b5iIwGtrSuUO2RaCwSfQcgnYcM/iScDIOUle5JtxGzm+EO5jC/QMw9QGY3Bk024XfNzYXu1hSldAAcP0giK+HrRd4zmn2iIgD3+6GRyr1pW95+r+BtrJVEL5yJ9SaAvjWMZFZ/KF99CHTmMy73iqQwzgfs+9M+LAXU9Hvj/uhr/t5K3larf4DCU64xPe0Tb7uyrEZAdIjlD9Jo4CGCSrwrxkN81G/SR5OXkVZF/sR54PNHdqRI9WbDcnOun5tqB0xa8yuISwdCGlzyh5P4T1wC97cNueEJ/l8XTjyWDUisdCfqW69KTcVlNMsiMr4RnyBUR1yZXAmxFRJ0cY2QdzuAhDhIrzHekpBWdRJNMWqCzQXMVuArDb6+Cx1pSoLzurxwiKLkZh2JpX7ibnKD+8KoEfkRrMJTZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 11:53:05.4682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da2f5c6-cbf6-44e0-5b26-08de791b6e66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6320

On Sat, 28 Feb 2026 13:11:19 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:11:17 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    132 tests:	132 pass, 0 fail

Linux version:	6.1.165-rc1-g9616e339ac72
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
