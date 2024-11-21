Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0B01BD031
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732217996; cv=fail; b=Rqs8LzyecLalwtlbwQcttx8+f7Ud6ICUFcHe5B3nCqF+YylYDVaonPoQw5+lHZp6cs89VEeTg24iHwN6JOASk0UXjRpMGuiVox+TFdfAqOuqe3ksmNLJk46EWNB+Ea1qcNb2oHQ6A9HAcwlssqOVomAQ8hr+iK7/WwDZrBQ+Q2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732217996; c=relaxed/simple;
	bh=izhIyuWt8IS0XrNHlOwn/2WfWO+Zce8zn0AWeUxmE/g=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=D667OuFVdnxgPx2au0TuCMiyLm7Ly51Gsb8rSSnXsodE0Vt26kZsMMRWdYIfYYSWYl4BJrjwHuUfl3wHeXcAdkqd0RYH9Hd5ZX5kOksoekRbQYsrx21mfECEHOE+6oxzRjwJOuEopkhkvlcCkn9BUcacI0oW9wcTglIQdEAMpiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nln2nsj1; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nln2nsj1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QK4ILNTjtNLo6HSS+uq03FdefxexMAkQXnGiD+hiinMhQfL+u4pVlYz6kiCaEVLJswhVwmLOdLwST2AGtXH9XKyGzhRNGjeiBjhAWUeJg5SwCYbdRILywspTUBL5elp/VahMeOlw71m8xHSsZ6Nw6zQslARfT9NQX8E27P83B2h81bfd1Tg+If7fL7FffTttuavNL1Yg0uGfpOkev1xvA/n3MQEB3x3ZaRqzdaLKjdUI4+dVH4i5DpDaGLUSsnul9dk/qJdGDEMt3v2tIhKuSn5AyjxvGF7w3b9z7i+CA76TiVXBtPgRHF4xevX9++Mo3AAg0dm70hUzjuazapGeQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7IsK2zPEj/oDOVt9BC0+iwSP6xhvv61E6HTwkDGDII=;
 b=h+qDQQIQLYJLOJ6SMudr8ZIii8jstHVovE4dZ1/ixuPaGLmFcl0x2cPLt/e2oArv0QtsPyioG9Sdj4udHVYkTryUnyDti9nj1E10iQVmOE0KaUzaY1EwVsNUqVxHjxtkNUlP7WuT3JcHYgbxaBnZ4V0RGKmAgJXcJeRybxr4uZ0GbsXRNJxb7X+lg3aUNwW5K+MGrpM3uT3HcVwN2jj+JhH/aGDmEfmHlVT9/QDO6i9Zvw7g78QWxp18fUY/0fDYT4O6aUuiCysvQzIf4BIosatMcoYMHJsgOquo4dpSX74pOptidIt25YfM2UvjQJftJQMxeBmHRaj6ZkCU1rIy+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7IsK2zPEj/oDOVt9BC0+iwSP6xhvv61E6HTwkDGDII=;
 b=Nln2nsj1owxVShIGkGXv3kb25cviPnyj6cOuG0JkeBiSZh1j1vDWoDvjVul6AtKyzFckOVYziEiSHYWdc3S9pi1ZhbMS79hz5Jb4tKLyJjBWxcnuvG9naZOPhqnQid4unei9Irmq16MFdtTQQpMnnNIWbbQ5IKO3aksUgOEE4sI2Bx4ySJet1YyrKT84Db/5l5Wh4Oj/ZVnTUIMcRVS3dSIiJh6KdEfb4Wfmiy7PhRWh1XW0tQ1hUzYeBUWk5KGAi7qxDVrlvaRy/YrHTBqGJLyJe8LB2elW5ChyybmFMULrnGo40R+g9n/zqSM3+mMWLZwFunHlz2BVUeivnSlo4w==
Received: from PH7P220CA0106.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::7)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 19:39:50 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::61) by PH7P220CA0106.outlook.office365.com
 (2603:10b6:510:32d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.25 via Frontend
 Transport; Thu, 21 Nov 2024 19:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Thu, 21 Nov 2024 19:39:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 11:39:27 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 11:39:26 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 21 Nov 2024 11:39:26 -0800
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
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <89f3a4ef-2f3f-4bee-9f39-07b8146fa7a2@rnnvmail203.nvidia.com>
Date: Thu, 21 Nov 2024 11:39:26 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eea041c-a5bb-429e-dea8-08dd0a6442f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFBENDdZVGNySW0zTlNpK2FwaVB2ZmtUVlpXYlhpNWpvNUU2RzdVcURPT1Bl?=
 =?utf-8?B?SS9MdUEvMUJ2UVpqNnpRamo4eTlkRDBHd0d2NnlraUVEVFU0WXc2MzhwakM2?=
 =?utf-8?B?NkwyZ1AwUUtYazZLV3hjbkpyUkI4U3JNQlZjbUVIOSttbEQ0dnA4UE1YWXI2?=
 =?utf-8?B?VE9GRjB3UnpJNVJEVGoyUWVrbGRwRWdkNDVhZUZSdkFERW9JT081WWd0Q1lq?=
 =?utf-8?B?eXQ0aUNYRmpORFBaQ1JGeVNJMnczRWtDNHdmeVkycnRyR1JMaVdReGk0OXBX?=
 =?utf-8?B?S3o2UWo2M2NwamxyWjg5RW9PODliU04wV1NTZ25IK3pjRzlGTURNenVlaVk4?=
 =?utf-8?B?aTdOSlVvYU5FRHpqS0FKUWx1cFRuZTRNS3psR1ZXYkVQSnVEUFoydU9xcjl0?=
 =?utf-8?B?NFROZk5wZXpFNTdmaEt5MWswRnFQV1JHb0YwM0RmQlg5ZUZvMjIvOHlWSUdW?=
 =?utf-8?B?QVNsYTFCblRid0I5WjBvVktCaElxcWQ1eFFzci9VMXV2eHVvNUZ3Q1RMTVIy?=
 =?utf-8?B?NDlXdkVvMXhjOGhNbUlZb2doaTNHck9Jb2JyV3p0RnUrMWRoeUJjWmR3M2FV?=
 =?utf-8?B?TGpNU25VRXFHNTdlM1ZiKzM5K0pMOXlUeURNNlFjdWNGYTgzS3MrZ2NKUXFS?=
 =?utf-8?B?c0JwellqWnhuU2F2NzlrUktnL2RCM1FUM3dnS3pCOExqYkNxQ0k1clE4OTlp?=
 =?utf-8?B?NDVuSGZ0T2h1ZUpnUXkrbFp4eU5qOERCV3cvbEwwY0NNTml5MWVwbW8wbTJw?=
 =?utf-8?B?RnpwVEs3V1NqVzhmb3NJVEp5TUthVWFHZU9hVkFBOWJFK2N6a0JEaWxsSEti?=
 =?utf-8?B?ajdaRFM3dGJxSml0R0hqLzk5eFBTeTdYTVZjV3JUYXQxOVorRHhrd0FYSDRn?=
 =?utf-8?B?cDJtdFRZbXM0R2I1RHZQcEd1UVRoR1U5YjN1NTZYNFgzam9ybWc5a2lFb1Qw?=
 =?utf-8?B?VElBWXhEWFhYWkRGd3ZoWm5zcTAzSkVpZCtQSTJlS2pWaHJtRnlnNXJSS1NM?=
 =?utf-8?B?T2xIZUhaUVJ1Z3lEWnNnaUI3SVp0d2o0YTU5UGhiY1B0N0pDL2RKRVhTaXNn?=
 =?utf-8?B?a3MyNU9zME1Nc2tyTWJHNXREYjFzUUNyTWN6eDk0Sjc2Z3RjdHRUL2dsNW5n?=
 =?utf-8?B?d0l0bVVRdjV1dkVOUEpFK2JSNTZGcktJWXhTZkRzQzg3NGF5RFJZY3ZzQks5?=
 =?utf-8?B?aktBTEtZSklncldUb3lMTG5jQTR4SVVtTnZIWUt0VlNtbGpocm9wdFVXUEVJ?=
 =?utf-8?B?bXZ0OEUvTURlU05YbEF0U2k2UTFRMlh3QmdrVWdLdXNaWnk1Zm9NaDFnWTFK?=
 =?utf-8?B?M2VXLzNGN3dVOHFOVlltbms0dGVPSVA2NG9VUlYwY2phK3VUdWt0TE8rc1pG?=
 =?utf-8?B?Z3FCU0JjUUZBNmJHK20vd2U1T3IwRFkwdm80WE1mejA2cW52a3Bsa29ER3V6?=
 =?utf-8?B?QythQnJJN2V3VmtENlkrZEFpUEZseWtBN29VSkxiZWxPMWRDOHFHUVN2M2hQ?=
 =?utf-8?B?c3hhaHB2Y2E1eVcrRnp5U0FCVDdvNGNQTGQrckhSbElLajFSWG1NVXJMZE1P?=
 =?utf-8?B?MEZrK0NkUWpHSTh4OUlFendyb0x4eWV2VFByZ01WemdtMnpKZzdQZ243eEhZ?=
 =?utf-8?B?S08zcHAwVGo4ZVAxczU4SWRPKytXWEhPZ2pYOHpNWFczNmt3WjRCVGd0aGRF?=
 =?utf-8?B?cnBUQ3c4NmsrS2IvcUkrS2dKVUxEeEpZaFhXVFVKMHFlY2laN3VFdzkwNTBn?=
 =?utf-8?B?dFhxbC9NbkkySTM0YWhLSUJMYm9yNUl2SVlUaWl1R3daM3BsaW9vUUxaRm1a?=
 =?utf-8?B?OFJLMVk2NWlNMGRVTGcxNVYwUVBIa2NZbFhLZTJZc1NBcnlqaEIwNXVGcVZU?=
 =?utf-8?B?UjM0cDJGWVJydjczT1JkbytRbEo5bnVNdVNaaXp2NnJscUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 19:39:49.1514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eea041c-a5bb-429e-dea8-08dd0a6442f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458

On Wed, 20 Nov 2024 13:56:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.63 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.63-rc1.gz
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
    26 boots:	26 pass, 0 fail
    111 tests:	111 pass, 0 fail

Linux version:	6.6.63-rc1-g2c6a63e3d044
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
