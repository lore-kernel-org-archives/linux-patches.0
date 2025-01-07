Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776A41EF0B8
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253877; cv=fail; b=QuQKPXWU5Frh788h3E4qiw1+ruEmAj9g6Q4H3NaN5mGthF+0p2UsGHA2ynOnnQyUedAh0ulNgizmOKjBy9PELBXSn3rAbFerS7y3gF8yoytr7U08oqzKnff6r+CmopHC1x2lwDw1acWgwpNh4d9HxoqKGUuQn5d74skw9epKzJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253877; c=relaxed/simple;
	bh=/4ci7fONeufpU1d4EAO8PwmVgOD4q0gziyMALlPhTMI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IAZaLEu9jbc77+AsOlsw00H8TyYNmqqXj/lTW5XFgLPJlQPiYNgG5VqOwjbWbDBYeWiZTNdp1pUUjNx52/v8bMk9USkPiKyTntFbPKZdolDe6kcw/Vrhw5W+VIDdN0Uxnr9s7lwHTXSoISLUh/ffdW7SoBhI4j7CALR9Bhx7gPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ap14P9Fe; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ap14P9Fe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YoiNtgdcWs2VGxTFK+Mq45HteRjXULNYt7JEcbRX+ZrtNtOILFG9Zp3oQ0HKtQwTGGBYZtmdJILIKVbvvuQr6icmiJ7+qs6IbklDTLPB9ltuD+A/XsgyotK1rrkTynABeR/654pU/gA72OQM4FzgMJWk1hQDcMPrMVZF7FIU8IGa/ndLktcFOS5gWUfcwu8/ByX/EGUxo0mNorBBHUER0P0DKwt08bzX0X2aA7bcApAT5hpZPZe2CDZqt0QsiQeW7zLRF+Zu7B2Jferr34+Sx+uSX99TDH6VWiyICZsxrJFG38ZabGCHlzczuO9RtlX4cupYrXZsq0U83J3aa46PYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ik7zHnqxrdweXz7V5EiFsBIwDaPOacP8H7vqsmB7ZVQ=;
 b=GqQa4dnKofohfKUASa4YS64A8Jz+SfVqPLiz6yzptWteRU4GeRcWrXyz62KxVZ0shtZcJdIaswvB8eZ3iEiAqdUGohPK6pV9l5s5k4F5/w2vfK+6vIf5nQ7iC5jKlERq048akED1mi6Tlo8T1ogmJhUwvoEEzmgGzaML6hHR6unfcYVnQZui20nbGIKc67qXpdwCmnI++1AULt4YGCdPJjqRobjFZwc3vGWgZjuNhPfq9mCZd11kn7QcJucyxGwEZ3uC/Lt9wrRln0xdefJM0zOZklTRuTZBOHvdVpqDs7L1rdQF9e/dPEEn+a6TiyYAOquXVlEkn/uWYKhto/g5Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik7zHnqxrdweXz7V5EiFsBIwDaPOacP8H7vqsmB7ZVQ=;
 b=Ap14P9FeWU8A56odJqKtW9hsbRbLh547g3y6YicNTYU5iqudcY5HsTViQ7XyKL5QvVSlF4QwJTtM5aIz+vyckulFHk9zUGzW3A0QkeZq2SpRRbvmhr6kb/RGQisMYNWdgwk9eltLD44byS3LHoFM3hygWZ2ctGAAqBX2sbN2epPxJHbsJZEtrvKksASjMCUTFjDOkthyHWGlz0SCnUB1HkNJxl1+91R14wZAbzGG9ixLNDbNnu8SHW0zE4fQv1Y/Y9A0OzxgPT1OEvQ1sL2lPIwoRy820qeymxA6xc61gTeE/9jNzNriQLt0ie7bnc2vqGRtJa6hzrFixcqm2Eh6rg==
Received: from BN9PR03CA0941.namprd03.prod.outlook.com (2603:10b6:408:108::16)
 by MN0PR12MB5977.namprd12.prod.outlook.com (2603:10b6:208:37c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Tue, 7 Jan
 2025 12:44:26 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::f4) by BN9PR03CA0941.outlook.office365.com
 (2603:10b6:408:108::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.10 via Frontend Transport; Tue,
 7 Jan 2025 12:44:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Tue, 7 Jan 2025 12:44:26 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 7 Jan 2025 04:44:19 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:44:19 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f8afd903-47d6-47f4-9f1f-a8d230d79c41@drhqmail201.nvidia.com>
Date: Tue, 7 Jan 2025 04:44:19 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|MN0PR12MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fff8eb7-86db-41e5-4419-08dd2f190523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXg3c3NVcGlhTnExZDZxU0s2NEp1Z0N2N2lQRDdaQVRCcXdabU9oMXk3Z3Yz?=
 =?utf-8?B?blo2SzVFc1I2VFNNMHRjN0RJZVFwTmtRNWxqN0JncEk4RTVjRzdGOWlBL3Fq?=
 =?utf-8?B?VkowanJSaEFRUzBaOEJaSEorUmQvOEd4d2xQZDNJY0FFU2h1RUpubVBwRzkx?=
 =?utf-8?B?a2kvZFhDeGtqL3dyUjhaeVphQVhkcFVjSERmN0tpMUFyS1Fvc1VvVWVMa0RL?=
 =?utf-8?B?cVZhSFRVcnh0QUljbE40OFVLby9GSXYxOU9mRGU5Vzg2bTVwQmpZbFVPalUw?=
 =?utf-8?B?TTgrQmFmT0R4d1BUT2xZT3JoRlBZVGdtKzNYRGZDYzBuekFEM1BuSytKQWhy?=
 =?utf-8?B?UEMrZEM5LzUrMXVydmdwOGZubzRMN1kzV0dkSWU2SXlqUndBL0ZRTjlqOFhN?=
 =?utf-8?B?UE9CZzJBMjZjYnVIZXFNWVVOeXg1aFdTcWc5ZjhZbzhyVE0vbnNKMkFoY3V5?=
 =?utf-8?B?UzdPbjJBd24veUIyVDVRbGFWQTZ4djkwQUdvNmNNZlh6TnJzcTFqcnp1NFRy?=
 =?utf-8?B?M3pPZllXTTZieEVMcUZmbUNvUCt0ZG1JWjBDMDZocTR1QjM3Z0d5R1Q2ZWFD?=
 =?utf-8?B?cE9VYmdlWEgrTWZMSXRTQnZBLzNReTRJMjJGeXVFclZhTTVDV0NveTB1c29R?=
 =?utf-8?B?b2V2aGVCR1NpeEhvbFB1WXVjMjF0RUNFOUdJaTMwNjVWZWpIbFU5ZjlIby9L?=
 =?utf-8?B?S1N3dDNzK1E3QUpZTzZXZGJkRXRReFRnaElaeHArcjZoRFVNVUVLSVpXWm5D?=
 =?utf-8?B?eTN0MnBvcTlqVGZFQzdpZ2IwRnowVVk4VDhQNUhaOEl4bVc0TnF6aVY5K1Z6?=
 =?utf-8?B?VkZzQlFWS2xXOE40Zk1WbFJTMFVEK0Z2U1p6N0hjajZ2UjdwT2tHWVdVY1dV?=
 =?utf-8?B?bEdzWnBmbndUK0IzS0c5YzJWcUlNZTdPMXd6ZG85K2Y2VDJJRnBZVnlncHI1?=
 =?utf-8?B?djRoSGgrL0FoNENZOC9PckVFLzNzejNnWVNwSlduUWhEdzEzQVF3WGRZMTRj?=
 =?utf-8?B?SWc3MDVGYWF3NkFqTDhSakkvbjJHbTdyc21yVENKNjlMMko1UkR2dEZKTDJZ?=
 =?utf-8?B?NHJtS1drMG5YVG13M01WNXZhaE5kWlZOQUhvMzhSL1NtdGFnUzNXNDlzNytX?=
 =?utf-8?B?b0l2Y003aE5DcDFGSGlwVkpQbm00cTBIUUpFa3BUVmQxSWdtZVAxUk9hNGpE?=
 =?utf-8?B?b1E4T05nS0hpcjN3Ri9MRHdkZ2U5V0xSTXBGSmppOTh2QzBlRjdkVGN4NXNo?=
 =?utf-8?B?MTNzbG4rYkpFajNlcjhtaDBHQVNMRDRvMWZHd20rUlIxR1RLU1dQYi9oS2xE?=
 =?utf-8?B?NDlLcFNUbmRPSHRBVkdzeFpzZkx1S0F1YWExcmtwYkowa1JaMGhFYXhEVW9h?=
 =?utf-8?B?US9LSHljNzBMKy9WYWdsTWFMNjU3dExqNXZ0Yys5RGk4dGJIUndjb2w4b0Vm?=
 =?utf-8?B?c1NDbWVPbjJwSytmczBIM0tqb1RpaDVGbS84MGtxaW5DVXhwQzUyY0tmd1Q0?=
 =?utf-8?B?enk5QnFFLzljellucVB4N012MWgwVGxNbzIvRGszVlZFYUJFU1B3MEUwb1la?=
 =?utf-8?B?RWdmdERSQlpFb2VIWFpFVXVmSmFVTzJ5U2R3NUNkQ0hveTJReTRhTVJzOU9Z?=
 =?utf-8?B?bWZRcEhJbFBBN2Q0S0x2RjcvaktFRS9RY251K2lVaWhuM3dVMU1pdjRTTkov?=
 =?utf-8?B?aEhjU0RoanBQRHRiNk9PUmZZRGozRjVocmtxQUJpbmhXQTZOOUxObWwzb2VI?=
 =?utf-8?B?ejVObFZUaUI4dXNTdmtTZjJIM0JKOFF0RXZ1U0tKZmg3bVFaVGJ6Q2tKbnJo?=
 =?utf-8?B?MmdYT3hSL3pKVklBdy84OWMzaG1NeFdkQmhyWWc2WDhDUEdxb1RGcTNCSG1T?=
 =?utf-8?B?YVc4MktlL3owVDN0TnJza0w0Wm1HaEg2QjZabFRyOXlsV3RGejdxNEVjZ3lJ?=
 =?utf-8?B?T2locDllRFk1cS9BNS94bzBqL3c3c3YvUlBJZHBVNkJkOGtGVjFiWkJEOXdU?=
 =?utf-8?Q?3U6reydjKnRjWuvtM/LGz5IBhGlarA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:44:26.1644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fff8eb7-86db-41e5-4419-08dd2f190523
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5977

On Mon, 06 Jan 2025 16:15:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.124-rc1.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.124-rc1-g88f2306b7d74
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
