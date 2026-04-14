Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011069.outbound.protection.outlook.com [52.101.57.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17178387359
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153256; cv=fail; b=InM0rNB7CunmyCn1+mmnA1HMIkhgqlXLVlPPl4ZpUyFkFKvK00hOOUvWHoZcExFewrzkzVbAjMrnFL6ZBtCJChJ43/GgGan/Bqg12ZEuoS4i1GaFo3LLamzXcGXKmb+MHnS0zAWcA1k8yGJoi42dgd/Crps2A22ca19q0Or0kR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153256; c=relaxed/simple;
	bh=dbAVHU9zWipu0cz1aaOeZG5xIhgARhd0bDdtvqW5H+4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=N/+BEfpsKk5Z36LqQ2cMaxghYySP8/uI4/Hnf2CFVtrYZQ6Ujgnjef/p5/1YlyJhqqdfJKaDIDwit8F+6+FKcWUxlKqg10UWbGkppi++Odkis1j6i/96VgJgbKfoA/6CVQwGOg+5BLlOin+Pa6EdAKYGpCjFmn1sQ+ArM7WrMi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kuQY5Wuv; arc=fail smtp.client-ip=52.101.57.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kuQY5Wuv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVdWaOkq14ru0q5cGkMlniyoRb3Q6pEgzXr9Tqo2ZRLNyIdmTPXVovolJ5NQJSyTwRlXz1qv3JK+JmdvJ0LRV5XonIlLSqsAaZosSqNPtwkDOoKT9dJJX6Gs/daAxm9FyuJBBUQmKMTCI0ncumWTGI78+cxOIXFg+p7h9CYXSJRFaqp+xOU4OXgMLVqgE62WnIHaFUabuMsGIRvT63h25hI+5LpOlQIMjwiCqNsFaM9GWjfzk/CJJ9LctPpZLXmc4/vQrcnHUUyhXRWpu+gzOwqXyPb3/YBQb9iYdYtHZr83l9cBtBREf9jnu+NwSnY1AJj3oyM/Neu5Tt3dWku/vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhaN4GlTYF/ESYAds3YOZ/HSo1/UE0YcUdxffGxZhpI=;
 b=dtiBgx85bxNTaDpqhskeyK9LpdwPmlZ+dGUze0TpCDyXXpVFgS56ZaMcMXffid2ke45M+Lw2k912E1FLri83gAR2N6pYQGeohlowBJT7mNJDNmt5lOASmIyckxBOdD9+kEEY8PkcS1K7WPf7vtw4ur3zo82f9mKEGBHO4YJ8K6r/IIMhyCVWkMWkVJdujs7Qme44q2nAwOYAxSYHfZIbUHgMztiCvzdz3mZir4jXsI7eJcIwbqHZ3osX6c02di/na0ldOHsAiacjOKdai0/dtxLQH52qUGptYp4ak0ApE7CFTQ5q/74nKm6cOW9VdEUjCXvHFYdNcCGj5xcCm3EZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhaN4GlTYF/ESYAds3YOZ/HSo1/UE0YcUdxffGxZhpI=;
 b=kuQY5WuvuUABZR2Eb9POVKqqJpx8UmjSJBxwBXtJ4WMltcUux4U3yLyePSZd0xGPZKJ5nW8oZnS2COejIHXkI/MIRhFL20g+UCuqNkFlxN4Y7pWI6yDlsD1aqV8GJ8Gtps0PWsq/9CjbPFc05549lSiHOnS8TOFPSd2ZmggnZR/snU53CS9fwXGIxcLeEdsaxAIdqJ8iBrhClCpO7h6rcKScv0sewqXIyeh0ABspw04xu5IftIQNv6d5UkK0o7lJaSTqWqIyfdSFsxN9yfdeGM4VmDaAmV0s89qQJrnp4oFY2yPITb6RWFJXCnofKffrmCRS+fTjpJT1EZRlKBWXBw==
Received: from SJ0PR03CA0127.namprd03.prod.outlook.com (2603:10b6:a03:33c::12)
 by CH3PR12MB8535.namprd12.prod.outlook.com (2603:10b6:610:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Tue, 14 Apr
 2026 07:54:08 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::4) by SJ0PR03CA0127.outlook.office365.com
 (2603:10b6:a03:33c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Tue,
 14 Apr 2026 07:54:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Tue, 14 Apr 2026 07:54:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Apr
 2026 00:53:55 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 14 Apr 2026 00:53:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Apr 2026 00:53:55 -0700
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
Subject: Re: [PATCH 6.6 00/50] 6.6.135-rc1 review
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8a9e825a-e81c-4914-905a-531f0304b4f2@drhqmail202.nvidia.com>
Date: Tue, 14 Apr 2026 00:53:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|CH3PR12MB8535:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a90a4c-40fe-4da5-cd25-08de99fb01da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700016|13003099007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3EdU5KWq6DPg6PKaXQL/pcOBNKfDsGJ8gd5Th9tSmZ+sy32yZNb06oUZyV7QGjSC3ebqqIvbWN47/Y3FxKVj+aas9AsUbDgsAVDbNQvgHrNg8ud5a0nLVi32CcEmJj/Y3r2AzWT9QoLdX1AMPd5cGZQSwZuv36thOeNvv7iMbr+8I74DioQdJ0YKk8zsGDADErv13EiAob+Df86INzMDzA3g9q4YNa3sTyp+dUOGKEVem5lZpawgacgAkde43nW559X98XwhJR2Wc7F6uVcEKkeE9xkdiLxaDem38JN31U05sPxiD/B9KvuwGQ1pEilrXJVfSqMrESUCV51oWLbuY6JEsHM1yLmRmAuoqCJKUT9G32G8jNM5ursY8+4HfPzEPWvFKjIO93Z/tvPUWl5o/ftGXVc/P8x6G5sEW1ZjKnOFIrkMcmDKa+/fQafmnUqyTnsmXEZAGkWMJVWTeAek7I7bq4WQKCDDZJpJgTNXVKLTjO/XudHhzICbFuRpK791oVxZcr1iUtHINJLrXouet8AVROZGgxL2p+e2P72VWMRl28EFR0TPV8fm8txhFPbtyLbG4tFgqaKn6nkU/rG1yIPVv1U0ogNx0npEBKMuLxcEOoiJXch+O01Hn4869Vp+S6H+fDXwQhY5rWNjmvsVXfgeDw9sU9MkHmJkKKqxLRE65Y+AlhxsGUTYxuSLoas506mltYiZi1U6M/aY9+q92TzvG/uZd+5yaK19lm5vx2JlYN2xM/Tzfcd179peo/tPqxr1qEuDFY5ezNDTgl/UsA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700016)(13003099007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/io3hrSqI1N/j1WOp00RSAI7lxelONu3bOFNeIkbZNITX2L82fCxETd1ZE+vQtTNm32IkYqaxox25VCTjVbrEbk3vBCLabkbHXjC4iDTopFk/bXJTubx9t6K5A12ZNwDUwLdnYBV8lZuXBscEqSqpcn61aEesGgYXSxL/e4gD0cBm4DChOJHUXvjMmnbg6iAuCoBBo8aq2JatpFn+nB2Vhp2hhFPhNqldr6+31ohYS/b6doncGzxNDc9S9BiwP6AKMAr9jhfWX7MfBK+dgoSSc/RAOWNL2G/mPO22SiDTVedeXhW0GqxFyFWjQ5X/pIRIaOZYy0FdFvuYx6VF6OI7zIRfB+vVOxzEGPWfICJkv+h18TyrncggOkZ8krjh3hluGgK7yHQs1wAEpZeKTlp4hwzZUdIbidLW6a/LmD+shF/9hjgGohqbr7JVOk0T6QQ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 07:54:07.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a90a4c-40fe-4da5-cd25-08de99fb01da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8535

On Mon, 13 Apr 2026 18:00:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.135 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    122 tests:	122 pass, 0 fail

Linux version:	6.6.135-rc1-gd20afc4dec68
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
