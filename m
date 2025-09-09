Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC5C239E7D
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 08:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757405126; cv=fail; b=HkzD5K+ztp+rI4myj4dAmxCcoVSTRd+sqmKVzFzv74sZqYDjun0HHo+8S/F9uA9vxnxhr9s7iXeokHufd2o3xQjlfW2tV2DF73SflEhFg1Y09IOXCoLMcr+94oIvLh5h0WKcj8AR0FC2nfhk4RKTUGnFUxqAe2qGhaQYozp6EVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757405126; c=relaxed/simple;
	bh=7WUntigBqdL6nNE2r3z4SoAavDXDW7MgEeOy6YjelUY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nWxT+U8+SG45zJ9DvJEpnf3F0fu2/DGyEn9feowQu1mHVKYZsOWEIrzFz4l5sdQUzG1WatnMbjqnK2uoOkVCq5+RPY2Q1GD0LtRtFEw0HUCi1PD9iq2yOsioJ894RcY626vOO2+ufSBgEeBXcfsuvcoaxjYKFZ4oyPc2nQ6X2cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WTZQ2YtW; arc=fail smtp.client-ip=40.107.92.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WTZQ2YtW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBrxxCB1c+nk3RHQ9YFuMz0e0F+kiewQDNWnKFc5ELipiYnqvY/bFqmoV29w6cn0GOjAgqeRsLbYudeb55qHcj1abyoFe/LtxEVGtkrYaPgo0AV4d+XfisAkcAzsMGumbXNZBOLxV/URZp4lb0kFl1ftO7kkDHA86+Ib378DIYuPIz9BjYDtoWt0c4uqm7WYXmFIf5S7C2KOn0I/sakkFgQ65hBzISz+zWAidVoPtJF+TCDkHM3sTlVu4QP62X8KLh+XYuvu40p/EmOGAHe033LoODvAlfgBRIqxLs5SNWnKC0zHNmF1y2tU3/Fhv4ynaj9dfcrWVufJSei81UU37A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeUVUAenc5lnSjDR7tihO1ybKCAPdHDKP3ynOPPRFQ4=;
 b=SWRqZyL3wKbXe+uKBJnMNPxg9hwmpfirPnfKFzcvQGOLPfXcnIVtH72n0ru1dbUCXLfx2niteBCWdeBT4BejzrbWQAGUMWVYXnLbXB15/5Pw7W+gC/BGcmCaz/VITxPwc/TFTLn1yCYx4JpWSArvS0/aSZLipb0ZWUV1kSpW/4xPC88K5kYLL+b5HcW6L98ekqy19K0RuF4nGIgdQqGLJW1z4ew6RQLbLfkl+tD4RmND9LDdzaw8zfAEvTaWkQbCzjlR/BplM/9mfYYMr9USB6hlQmhb274kOjRy2wcLo7XOn4t7hq4Pkq8yqsje70/F9onZqthl8rOxpCq1Uhqddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeUVUAenc5lnSjDR7tihO1ybKCAPdHDKP3ynOPPRFQ4=;
 b=WTZQ2YtWbX6kx5aQRQa86w3qfPytjqCOk0KAFibmPT80LaPMZgfIpqNyllJjRoic1DUeiYMZBNDKNeVxCJtrUSgcIDttazjXgLTo0ev9uSmLvhuEUOOHKkXt6dnrkywFrRXht50OrnS9pqqkjycnwzpnCcCOCVOilp4nZD7XAkBMcW2QtkB0tx5NXPniNG0X9d5x8g4ONlLHvPsJC7FuV4XwQwPEJ3APg85ivWbP9aVdeChROfYHpBrkrz9Jd5CQspDbJCQqwrEQmKe71eIkzTyIeKY+CFOHwgZvTg7gmXrKsua85o3DfHS/mD9K+E61IS1JAAB1n+vuzTkS165uAQ==
Received: from BYAPR06CA0014.namprd06.prod.outlook.com (2603:10b6:a03:d4::27)
 by SA1PR12MB7150.namprd12.prod.outlook.com (2603:10b6:806:2b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.33; Tue, 9 Sep
 2025 08:05:20 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:a03:d4:cafe::df) by BYAPR06CA0014.outlook.office365.com
 (2603:10b6:a03:d4::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Tue,
 9 Sep 2025 08:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Tue, 9 Sep 2025 08:05:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 9 Sep
 2025 01:05:05 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 9 Sep 2025 01:05:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 9 Sep 2025 01:05:04 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/101] 6.1.151-rc2 review
In-Reply-To: <20250908151840.509077218@linuxfoundation.org>
References: <20250908151840.509077218@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a1d56f98-3ab0-4391-9891-ec58713b86a9@drhqmail202.nvidia.com>
Date: Tue, 9 Sep 2025 01:05:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|SA1PR12MB7150:EE_
X-MS-Office365-Filtering-Correlation-Id: 684f1e3e-622b-4d12-7c4c-08ddef779e13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzVYUkJ1T3ExVThBVUZIR3pIL0pBNTRqL0ZOV2oyVHZLWFhNZFBtUWhTQkQ0?=
 =?utf-8?B?R0U5Q01BL1BIMmExUFB5cjZaUld6Z0x5QklWRHpHVmp0bXFLQ1ZjcUdkM0gv?=
 =?utf-8?B?eHg3dnAwUERMQTQ3WkZxMjRHTCtOcllkQkxnZVFxT1ZpTnp3MnJWTE4wU1Bz?=
 =?utf-8?B?eDNLVHY2MjFHYXh3UzZuc2w1cHB4QnJ6MTllakwyK28xcDJtbmxPZzB5bllV?=
 =?utf-8?B?N1E2M0VxVk1xelYxMGpBb1dCU0R1Z0U3U0lqQzFlTDMvVUZtUHo5OXNHQTA2?=
 =?utf-8?B?bndQZjNGVHoxdXZBdE4zeEpLL1I4MFZzVTVLSzJRNFJLazJLdjJnek5JOElE?=
 =?utf-8?B?UTNTWDMrTzhWNThFTU4vZE1BanhCeFQ5bElOQlVkcksvcDhTM0szWEZQTndi?=
 =?utf-8?B?dmtsR0tzWmtMN1N5UHhnQjhNL2JOVFlFQWdyRzRVd0VqMFdTU0FkNjZ2bnJB?=
 =?utf-8?B?MFh5bDVWYlY4S3lQRCtTRHl2Mi9aRG1YYkNtTE1sdUc3NXJnV2loeTd2Z2Jo?=
 =?utf-8?B?SEpQQmx2by9XTkJJcnUza3hzUXR5SFN4UTluakVoZC9XNGVyc2ZJU3pLZUxO?=
 =?utf-8?B?ZVZYVzhWSUdFODZRL3VJcFNiMmJrYXRWNkdRNkI4OHluekhLMm14bHhyZ0Rl?=
 =?utf-8?B?TGcwdjVkOUVtSklhVzRiWDNiWksvdTZuVUlNakY3ejh1YlVoRWs1VFNFUStT?=
 =?utf-8?B?NjZuaE1LUUN2UWdoeURjbjJUVjl4QnIwQjA5RkRpSXdFdDN1Wm9aRUZ5Rmg0?=
 =?utf-8?B?REtaSWczeCt4TkU3QnIyZ2MrZVo2cndHU09pNzF3cU1nV2xIcnBNUERseWFX?=
 =?utf-8?B?NWlhUWwyWjl4bG1CUURidkhYR1JoOEpqMDltQjlUS1JDdVVWNE5Xb1VHVXdx?=
 =?utf-8?B?NnBFRVlNTzdSWmR0SHFqQ2VuV05tdDFheGZKaDRidUtTQVhHaHduMitHZVhy?=
 =?utf-8?B?ZkdaZkY4eC9ob1NJY1RxTWZzTlpPSlJXS0pYTjM4dzZnS2tRRlpqSERoMHli?=
 =?utf-8?B?OXBsVExoeTJVUnZKb1Q1REEvMjhRUy96UFV4SjNHMVNXVWNLZTlNNTV0TkhO?=
 =?utf-8?B?SnVOQ3ovWWxKcjRLMUhZMmZ6S1l5T3FlWjRrU2xydVRmd1d0MmZMRDFsOEpC?=
 =?utf-8?B?UmpUZDJNMDZpQnFWRXpNbldMRUYwVkJ5RVkwSDZlamNmT1NSTUZtSUFzWFJU?=
 =?utf-8?B?Z3hhQ01vb244VU1WL3RGWDBJSVJGdDhEQ2REQVltNk5pUGF5dzdRandKbTJW?=
 =?utf-8?B?MVQrdkNWdEN2c1J0aFE5c3N4bGVWcjNKZ0paQ21DZWpGWVdlM1ZLRDBlVVRn?=
 =?utf-8?B?RWVtNGgrNXB0ajMyd2ZmaENmTUN5NEIzdUZTY2hqK2RwSWM1VWpSN0ZCREly?=
 =?utf-8?B?bThPZHF6WC9qSXZOTW9ZazBtNFdQcEFKS05yY3ovbTk4bW5IaVRHSW9xQ1gy?=
 =?utf-8?B?djA4TDFiVDRtZHVPUEFYb2xTYi90OHFCQkNtcE1HeEdQcnBiMGFMcmJTRW1j?=
 =?utf-8?B?NXVqVHJZZU4yQU9OaW1NWDJZditKMWVid3lLZlNIUHFMOTRoNDZzc0dwNmFG?=
 =?utf-8?B?MWxvdWpLb3A3U1VBdFVLTWpzaVkvVFloMHo2UzZWYVV0YnJ0bXh4TUZ4d1BF?=
 =?utf-8?B?K0hJY0p2ZVE0VU9sRFlUeERXdEthK2hWYUhReUkzZ2s4TXhzTEc3QTRuNEpV?=
 =?utf-8?B?SU44SkFOblJVWHdnUXIyR0d3dU40ZlN4dGJhNWZTNzk2L2FQMmp5eC9DR21w?=
 =?utf-8?B?Tkp4R2RCOGNVL2tCa0h1cXJLZFQ5T3o2NnVtZ1IxREZTdklBVEFhOFJyL0xo?=
 =?utf-8?B?ZmkySEZKcjU4bzlRTG1SVjZ5b2FnZW01RE5xZ2YwRHFuNjNybmNGWTRMdEJw?=
 =?utf-8?B?cDIrMERTRkdhaWM4K3p0REhUbWZCSUttallGU3RCMi9iS0hEYkJtb0s1S1U3?=
 =?utf-8?B?cGFnTEVEUHpodnBZeVVBbm5QczkvQU9KY2o0d2VRdWtZcjFYblhKTjFQSjFk?=
 =?utf-8?B?NkJOYU5SZEhoUmIxWElyMUFTYWovR3lRWlhvYWpCVTRoNlY4K1VrRzFVdm1z?=
 =?utf-8?B?MWlhVDZHenJ1eEIvS0R3NkxMbDR3c2RvczZsdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 08:05:18.7788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 684f1e3e-622b-4d12-7c4c-08ddef779e13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7150

On Mon, 08 Sep 2025 18:04:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Sep 2025 15:18:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc2.gz
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
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.151-rc2-ge60b159208e6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
