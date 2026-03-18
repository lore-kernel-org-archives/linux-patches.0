Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BDB3783C9
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 08:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773821885; cv=fail; b=Ce0yCUivo7LrSuqL/splhiLZg3dTedXF4oQKgCA5nrdIgjV1UKhsSprYRIFAm05f3pQS4+tCvrl86p5QrxMSB0/dwxG8i/bBEbBjYlBdrL1Ds97Yuioz6UTbyfZBkb9RBmpg+tRV78qaWsdz0S0n05B8iMPg2sm6F4AEUMRfQnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773821885; c=relaxed/simple;
	bh=Dpmf1x5ihQnWvijImxbW0gEaERBn4c5oLpUzNDg4nkI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oAcAkknmRIS9LqIxfjl4bIy3gbU33F6ziDA7zk6+y8uys8oQKegv7nQVo6uHEIWWBdBHlrILeOvHa8zG3Yf+W/9K/ct4dDUIhK8GdAHr3a64qqjW9zFCbHfAnzf+zieNtTQJWSc7cEYdpwUfJtE44oXn8a5ooXS9oFC1bc0uBDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PDYvSUVf; arc=fail smtp.client-ip=40.107.200.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PDYvSUVf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EV+WIJt7evNBqgFZGkpgtNyseuiJfudkZ1W7pkArIhXE/b6KdAPf4O+4DuNjiPheGrYBTdFxsVqwm+ZqLp6W8TO4l+8HrAAmzzE4/d7PwhD8MMQikVwJCGfIiyWoRSjmKaXSSUuSDwYT9wPcKosB+TQb7u9VXbAzx/UjemXpS4FCzilZiT4Q6g1QcQB9xUupPyllU0WxLFAqBRsffd8EhARCd10RnFZYiRsxDXieHqWOr9k5ztSJ3Tc372NeJB5Me0SA8raEA/CPYLbjsew/WUAc5yLP9G3dxzLddfCGlMNKWNgL9d8QLDF0KiKFCI8EH4Frt3RTxzQu7Zth3vxWaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYRWj4OCAZkJRyAbrRIu84AIG+T/W8UX80Ei6WRsHMc=;
 b=WQZxFgZfgmQT9V9bo6UXkrbgUBYMDRfhayrzPrmYNy3i3PajNyrcMgMJExWMIyIl+vsky+OquJkgCDp2EacpJJ/eYjtY2UJuF3aEzT8OXUGk+9ufxHaQqBBScMSR0KWQsVxinZGSqsBmP4zZZYWcDI3/bMHR3WkYMv5+wRNeqBFL8MMngvw5H1buHUEqWW8+Xw+Tvh7rht67UXJUkr64A7yQlvztK7BAPq+7U/f1qdGF1mlgPTxx/LsyQmZHP4kJueaMRTH+L1ZJ3t4vHOMmzoaJPZQrqSYr55hdjYsOFeZrUTOpV4JyzrotQNDrDf9mALUI1UmPBC8nKZY7594vhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYRWj4OCAZkJRyAbrRIu84AIG+T/W8UX80Ei6WRsHMc=;
 b=PDYvSUVf+/UKjbOgs7zgruFb5qkwWtxT4nkcLJq6ZviaxsIcjCnYTzWX1mjhpC8xmiiGv+gJTcfK5fXjugTH/+WEd3+gjdPfqudT50naBetIImoicrMzcXPB9I0Qk0hKXTXYHwHONdSkqigh6MNnV1uaddWaqkn8IPy+KFOY9XnJcGLsOyiMgah1TdugkJOHGVoGKsuXOhpGwBIQTDlwnQKkeHifNFS4Yxeh4W0Ig/A8348IBK3i8dUL5psFW5I+Xn9AeU65mhNTsRhljzdhhzs+6+yKW9lXvQ3c1cze2+WFQMfRzQ1GjK6+Rzyihprn+/gLmPyZDOVwkee7tMb9dQ==
Received: from SN1PR12CA0054.namprd12.prod.outlook.com (2603:10b6:802:20::25)
 by LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 08:17:58 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:802:20:cafe::ab) by SN1PR12CA0054.outlook.office365.com
 (2603:10b6:802:20::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Wed,
 18 Mar 2026 08:18:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Wed, 18 Mar 2026 08:17:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 01:17:49 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 18 Mar 2026 01:17:48 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Mar 2026 01:17:48 -0700
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
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9e1e3d56-4345-4e88-a4bb-3077e1dabfa2@drhqmail203.nvidia.com>
Date: Wed, 18 Mar 2026 01:17:48 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a8c3e4b-0686-4f9e-0bfe-08de84c6dd08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700016|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ASGGCkzSwO8/pLVFSviVjs4P2yXN4zyM0/DvKPgQQE8H8AT9gYzJKDJyavVDY01KbkJUpstXORbfjukvUMT31lEEXCDebtfMkeoqlEu04OqmtKp19a75cEvdqCQR2EXOdGr0SrkPYMKeqL8EzmzuTydpYNNYdiaUp8o+jG7kmRYPz59HvQ2CPFb0WT6ypoiHyZbVxOTKqq8YrghOjua8U494wlfhQW4KGC6yLq9Ic/8GutubkRquYBYj3EUn40p+duwx3JBI4WfdrXEKsYIu6UipXblV6QeEgTUas1P2c5gxUO7nJk4/FW5hGNFFAn51HXL7kFsUsXkIBzzSGW6uYINKUBXXOHeOcKU08VUxWVKi097Uh+ooac/3Ks+da2FPkjOuU5pPiEdc8a3PXyTIF9v4IVHD38Gk30XSpuz/amqTW0aRdK0YJEpM1/dpPdWvHAPZCsc1PEjgt+cWtlVHrbK9+xLuF4TDmIA4fzlqYqEymCLP1eff1io3tbMZ9aTZJyyE6K6OqEA7PkSesL0SvNyuC9TVRJVsd+suaF0cx3nKIuw7r/xtLUjdxwkcsKJMBFbvhs3m0bIgPh9cATuHh0yBoRdwhUANclHuZifw3VyIpR4JLUVTREk+ED+N1PuC3Le2qDQ5BN9NDntFQdh1MKDYhsy+ITyiTvEtDMKVmrH2tMJLdyX8ycUw9yURwhPu8XJ2lBsBu5816F1ANCQyjkdvHspD11dBsABh6B2tZpM+07mbFR8/eZT2sYAuAreWIi6ZGA49eJJyuAqoz+WumA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700016)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FNUuYreg9/viPVeUENaKU2URvo9Sv5tUq4ZFXqeEmjWfOChXVZ2CGkTnZECJWzrH9N4ZsLJ2pe2yRcuyDZgPeuaZdCUSQg/98GnnpnzChbPForE1JQZxQVaEjrllzVST/aDmTVJNCm9k2XO0JhYLAVoFbtErdXz60/PxaxPb47BH3ZON7BUvLCuQnAn5jBlv7001X9Fn7rWEQtvZDwpdb6WpLL8DN4d9VA2fiJkwl7PrvFZeO4gKB3kHmDJzUhITiJ6Xja3elp0NmxoQ2NN/JLXwOkzOEyE9lFO7UOFGPVkkMEcoQoCqffxPs/Oq0iTQDkaJqclWAgT41jXZAGmX8im6TBS96/x2lb91xciNmh+hiEaOqxHYpXnXf4XHsMMGtuMzLPyZn5114Bd21nHLMvSanj3BJk6iuVaypfRmJ9/TAbVHIr0FO1wkq0DuCoNE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 08:17:57.8487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8c3e4b-0686-4f9e-0bfe-08de84c6dd08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450

On Tue, 17 Mar 2026 17:29:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.9-rc1-g4f987e117969
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
