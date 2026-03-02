Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEDD3E0C4C
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457261; cv=fail; b=bGiroM3HS2a8XCZ2RKcLWbX1M+qesjUCHTHkqMmgr+WDruk6YLSTDt4ntRn550B+8olQT3WY3szObzw5SLnKlmW7atCX3IMl9PKxZrEg3kneXFsEvmeB/0TE9ZbXwWoInbGurxvypCaK6NdmzVtVBso2NiIdL4wjRFvoc0Uu1kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457261; c=relaxed/simple;
	bh=xWoD9NdaFR0DG7HdY3T1lpOvCD31drszdk107lVmzFM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Uo46CtB74OBawH8vYg+L6LEKUn4mJSeO6wHQMmBB/4rLDKJhWiQibokJrgejRMq6/e4Luu8cTrXeFdLHeLDCLb/4PfbY6OBIQj8hJt0pSfjHzb4vt6/d8VMCE8KesbfEFbAiNmMmYauJVQYclBfp9CcrL0qkZ3dMLB/L63sON2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gNW8E0/6; arc=fail smtp.client-ip=40.93.196.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gNW8E0/6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aw34XGMs3IQlP3rEKXn6jdYkZ6czcPfJ4fAcVGmv/Gizz8iUjiuE+VWFmeBSnc6shDHArijGdkLI94LejA4mj6Hi6nkwNQRVbeW6qsDXdGLMAERBqBBYavg0Y2qa9pXN0Z0X6UsW2Ap6fV1lmZqOZkC2sIBVcK9d+Ay/fFgiLiRtL9jv7B0tcDiYAtLkcEV3DP0E6PdUKxzsMemTTRU+34RfcA65pHCaK0G+1OAlDoBobk/NQFhMFDruUKLWTDAibmRoEvK1qf5UdYZXW4bgFY/wE0J4iA6AffO6Fup+XvS7o6YwiGXI8llpq0wGnQaL1OYEZ7ZOQQNLJTI24rsLpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSVjtjPvQU7jJoaSgCYyCCUEnRUYlhDZ65gAAylOksY=;
 b=mbKE6+uNoMFU0YhBM0tIOxHtChUjv1Fwn0eLqgzJxPWkIpDJ701gWnLN5EAV/ZtJa0PmWVwsK3eF9foAjz45h4Pg+XH4jQ9wvisLsiTroG5Fyeubq647Qh9L58xAlTkTXBei/GdFQ0DFyQZ9fNzuYscMeoCZWj5FhcL4gKvaHUzpxQTQcC+1PnY8kQSuUlP1h5A2Zw/RGJgqJ9+EEUpu3BvjlnPxZFPb7PtWWDBFSE6nsGHsv3AF4OK0ldPrA2ogvfQ0ht+r7yc5BjcGIghAjk7wK7ZO+l9HaLBosQ9I8TD3kYpnBpXxUs5d6ocp2VeIuHH9+WRe1hKu1GnYZoeeBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSVjtjPvQU7jJoaSgCYyCCUEnRUYlhDZ65gAAylOksY=;
 b=gNW8E0/6DYyCt9rryZR7Sgpp+TCa4SaqH4oKE4L1MqNpe33JVgQb5AFUeR0vrOuoYpkMQB414P0A0giwajUOfYKeW04WVK0R9ZnvkSZ7qrUAwTKZ64sMmFrHNAF0mWtzQoRrZzxusk/s4BWc/8U1BVDrbQFf6h7XZmfX+O4ZoITQp63N+W1LM7wSTFYBaH9QuBmzjMbuZtV8Bpyq9TLFfRGZZVT2HTL54ex09jDvi+UugEwROa0hhB6X8j7jv6+wct3T07oK06ZQ5zl0Guh76R07XpcIVs4zlWKJCb/fbFRj+OtCr4Vw3r3Gkeq+AAglCanakFUqyd1f/PHbQvavmw==
Received: from SA0PR11CA0183.namprd11.prod.outlook.com (2603:10b6:806:1bc::8)
 by LV3PR12MB9355.namprd12.prod.outlook.com (2603:10b6:408:216::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 13:14:13 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:1bc:cafe::fc) by SA0PR11CA0183.outlook.office365.com
 (2603:10b6:806:1bc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 13:14:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 13:14:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:51 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:51 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 05:13:50 -0800
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
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
References: <20260228174736.1542240-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1b93ae0f-8d49-4b40-9ec7-f0712b170865@rnnvmail205.nvidia.com>
Date: Mon, 2 Mar 2026 05:13:50 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|LV3PR12MB9355:EE_
X-MS-Office365-Filtering-Correlation-Id: e55b381b-2060-4e33-2aae-08de785d9919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	WSrsfvRKHyXWxTEGmJtoRYUJgTtZaQFvswrvbKnxQpRqTkKLDUTGyVKz4hgR9WwvkPSOIq0w+TqSVtvVVmw63HMFQBoFEKCEhC9MbXarsWykBXTn74uHqkLdhLxhgtVygrdHKCjsaf8zXUd9j+JPcjhDLgfXhA2xkZ0zTWMIBkXOpV52Dns8dYKR5b9sJX+q5di/I2FVZyFyqN46xO3BspG4Xp9DoTGEo8MtVmw2FkptVoD+Spxy+MYVrbmv4zBL4h3oKSlvBdJhTEVRSuauwPAdl8ET37S/37c07VBB1dEKuJb8yramb0K6EAoHWmDIuH244SFK8Os0LHNrJkRVkHhOTZOrfRQN1r41gCedzcjhnSIZa7Yeu9yFV68ECTGY5s9XCiEPPGsk6/mQUCgzXgTHteKgS+D4MtvT1872U7fKlvqka64cxS+hynAxsJfTBQgzAOPysBeSprmXp6NQ1ptODfUXMaCh/5xnfFyVBn2GQzrMEJjOf2Hh41b6SfHbcf/jjPJ0kRhpnBvRCFJYyr387t7IhqVbJ/o5ygKA2CkEobFaN1ORzxIIlNXo+K5fu9Gebzg+3H2BSm0Ay04VJZfhEMS2Ea3qpGSHuOPCd9s9k2b0/7BGjEadUeQuwJF8WaiAjrbotoy2tKPdmo3V+nk1rDIZD3IW2ieFSGghUbgc38iR0iJMbpD4+UuqRaGMmbjNA1Ua79v5eQ/OAvDyouD4OJGRnJ/2PY9Ui7LiltpBKoz7nBg/4UQ/g2mgdGEzpCmwfQV33HJehCOFTeEAmrZlwM4B2oEDeM4TszD/z727miYN9Eg86Co+my9zkAlDlzOnuEUFoCvePbnwld0dnQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ui53AAWB58+MI39ElM+RLfiIfQr0YRkv4XpCp7U1VWgc7Y4L5xGHcYGQ4l5J8XhFIK+Oo6QLbMOcQTvfTk5wOJjqPmTbLV0yg46skyPV6/9U1WsK4k8HujjRMrfOpH0XWvaakOI+nwVnVFdydMlNFV3608OxmR/zvZTizoyWkw2rukvLRqkgh2/zeMMUGVQyUo2pCHhf1e2m59w+j70Xi5tep8uqLk9iHVCIAhwqwkhOteCvz1IdwyCRmugHMq4B+/CKH5ViCKeuLnqpEgzRsrQ0EtDwbhHRxfAoRbMqGdFWGeDxTNTGVy+vRldLspWZJw27WDF9lDMUEK8W+mHmre1aC0Uh4My/KfP2c4N8RIxdxeY9iVraqnzPtE3d5bRe7CajC7a+wrlSCk3kr/NpXz19VDRY/kC7N/McBmEFSKZ5ewjB7HWkoaZ80KUA038+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:14:12.7584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e55b381b-2060-4e33-2aae-08de785d9919
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9355

On Sat, 28 Feb 2026 12:47:35 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 05:47:08 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.16-rc1-g73a348d1aca3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
