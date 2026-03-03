Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFEB3BED66
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547165; cv=fail; b=AHM1DJ+laHBYVStjCuy34WcPx8RldVArxKFCEMM+eWlcoY7Mpv5aKyVokzGbDAs18ZGe3DkFvz2L3VjpHaud78a4lRtbXu4h9aR9+npzB70ntU3UPxLBXlpD2qWDGADSHG9Czo5B9c6r+4dZ2GmvWMv24ElBk/Ji+UVMXzgpsuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547165; c=relaxed/simple;
	bh=5WDDQjBS4czDLkUNzktphV97qTYCEMpDUfRIBJRPU/4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UxQtT8tHst3w/YoHicIAUPBqzywxEDKjie14bN/315w9OVni+pn9Wrb+yxv2k/kqOFrx1Dpx0n5hgr8L2afA+rPPQZWpm8tGCBGVk9aNh/vBbPWUjdir2B4Tzdo1r9Zt1KfxiFFKw+JJvQ7xHEeK5cB88OP04KkZEkIzzTnhMxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ho6ga30o; arc=fail smtp.client-ip=52.101.48.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ho6ga30o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n2axPBveGX6Wr3nSa+PNZHcZSLO2KtV7hnoqnU49q9q5A9H/B9vuWwygtGoQBGHmv/EBWxzvk9Z35ym7m0Zo2B+su/cPA33Oq5f9gOLozW7cOEkP2b7yFq2s0jVum8MR0Fs8nwDTF5gw5FnC57bknFZgcbFtAJFYX2sw5YOidz9sjJTQg9n9vqSFYlNaHFjKXPcP2/b//+TTBZF9Y2weX9QKV6MZicWboT3Zb4jv+gW1hVlMmys9Bz65WPF3qtklzxd8hrayLgdeuH/pEFPHQ8SwziOhLYOp0D3bl5fag3HAw7ZDZu9lDAZzg1A+SOwFHo77Wu2ZlHVzySzhcJA1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyWAAvv1ftHVdJGCm8EV9Wbb87PuAKN3CcLbWVFntXU=;
 b=dW4jtKwbozbXWAwb9AFeSXAiUdIJT/JWXwOtPEDiFdHsbfKXNbIzC+RzDOLa6kiXOAOXMIupO6xEH+M2QcnBLqcaX3Vo1sTWibLCqedH/X9YAFwcY86ftwLAXuszj1P4YN5XsaKVYMNYPjtKtUmbyU72tlmh+GSDx1QHTkq6lKkrhQIr7vdLKCOmLCprLSOLJGVxgCvqF1GBIO4GCV0ztuxdhIOH2ddKgnNow0N0Zxw4GJ3dbuj+mouw+ALzFGDnQVa/Uxq0W3CxvLMN1+Ry6CKj3WSDhNMPPxLCewKWEx/WrzsklDII524CX0OURh/rsRC0FNhiI+OmgiAPa0dX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyWAAvv1ftHVdJGCm8EV9Wbb87PuAKN3CcLbWVFntXU=;
 b=Ho6ga30o6KvzRnKaUR7t4GNGrBO1nMea2JOO9T1dQylB/ntEzc658PUGhwxppg38fTKPXC8TzwRHT8X/fnlOx/IUvUqwdiZzVBPE4b5sYdSLP/CIPK9MKiKipb7CMf4KGr0f3mJwFq/WDzSVe4n2s8+gLR2Iak0utcdGV778Am1Mjp27iNfEfnFbKs2D+NSIZ+7gSr7n/J2DUWhRSakgQTS9Ij2v5ebj5/UudDV0yP44cw+DCizmaFHlfgUTJ1HkgDD7Nh70kGfBlrjkJCwwfYtcGS45+O8HJsNTloPM0/PkY8WJdHKaNLRQkzvWoA8Keo59cLM6lGtztKra8+sVPQ==
Received: from DS2PEPF00004567.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::509) by SA3PR12MB7998.namprd12.prod.outlook.com
 (2603:10b6:806:320::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:12:34 +0000
Received: from DS2PEPF000061C2.namprd02.prod.outlook.com
 (2603:10b6:f:fc00::215) by DS2PEPF00004567.outlook.office365.com
 (2603:10b6:f:fc00::509) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.3 via Frontend Transport; Tue, 3
 Mar 2026 14:12:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C2.mail.protection.outlook.com (10.167.23.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:21 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 3 Mar 2026 06:12:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:21 -0800
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
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
References: <20260302160934.2521545-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fb7b10f1-3645-4c4d-8dbc-dbd73c0253c6@drhqmail202.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:21 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C2:EE_|SA3PR12MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: a28b7ae1-8b3e-417c-1efe-08de792eea89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	eGSbScApPF/0WdS8wPGP+O4Llm3/lHCCvBCdqB99CDzRnchCHV//nfeLm/4gky3yNkRb+FyRBz+C2jzlmO5/dbwb9nVpe8kM+7Fwr1Pj6NzGVVKS0Rc/BWoe+Je86zqX0zs/zXXnHGy8CJWrmYzz8gTmJR8FgCr/kxOFyEnXENTlqhzMYxYbRshoeSCW+wouvh+V5v66QPMN38NqzewrLZrZAb8D1q1MZaMnq6zN4PT0TFYu8KT7wXqkcY9CopY7nT1I3BkaOIeokU6j8rL4v4giCvxNyJ9x8TR/01hzDj76+Kl+HUzUQNOL+hjYPejVkwNddEj4zz0G3gy4GOsd+DpQf61l4g0HTXZj4rBsZYGM+Ay5XYEiAkFgWDwgFmzQlM7xby1T/VX9vxVJyk08db4CvzPfB49g/qar3u7hoFsUq8blrGkorSU3JUZyOWGjiVq0YezZcrSGeBgNJ1lxAGXik2/6V5AGy6Om7y0wtfF1LIAPujb3T7xA+BdF4GqpL1E8ok86DkieKFMFXT61cb9KT4ZUiHu06RkYQpNICFG9Ly+RMXgsjcP5b2AEbqZlKuqp8DILOf7cXrh2X3+eTBivhMlQZZttOEIpsEuKTSjDzm8IxeMzTcz/zCfwsFj6/pT0CvYpyYA9yDMTLsPFYwhhhzS6QQL44aLz3/tULvt05rKHqEsk83dTBgMj1/O7BtXWzPXOl0Q5WTFI/zint4qnEIRVURoeDfA0iqr3T3lf4B/yx86ZLptFkhFD4hmcZzvMmoYjJLJzt0yIaVNkRlrOWlvaBrpfp9vUI7huBAf1GUxYMSuI6bUVRm4kKuYjRfjjbdxDUt0yq7z0+vAkaA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4x0CCOojBxoEconZhYdB0gqHgpI7rJU+pJEULmfmq3uWU2yGJjym30MmFA3i5iDMp/t8TAGLBhB0WvVhF40M7zv40LT1IQRC2O9Vd6cRDWLdS2aQlogoahKNXcK3vFH9XfLMFoJ0L4MOJNDA9BSNcTLtUr130p0yNxJDCvWNe4114pJ4dvhPXklalEwhViChSZnqB80UHX10bgNi1rlbuv1lbX7uEF6pXYeNv+2jVxFqjr3/19lkqzLYClL00DhwwTp6SVWaL5Hd57Iw9Da/Uneu7BqFhKQDWg7qqPOXYPjkS8twVj9e2i1B5FVUjriWVxnprzk+uNkvSG1hQV2lTOUSe7J1JA1/XBvT2h8njWuliK+7dXVCO/aeXPzyIpUW5TevmxJj3oMsOo/ePKQRgU5iuyf7QuhHnR2Od45tcLvNAfdNdfLxi7yHADmZq4lJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:34.2428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a28b7ae1-8b3e-417c-1efe-08de792eea89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7998

On Mon, 02 Mar 2026 11:09:34 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.128-rc2-g75f409c1a106
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
