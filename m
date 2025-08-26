Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49E2E1C4E
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230240; cv=fail; b=ZJCg6zWIFZEoaxWwP2GfqzdRGs/S678sO9niN6HXJm1BVJZ/WQChwksOc+6jbWHbC+wLCcpPoxHDc1i2jB5hflaGSVMpDyWQKpgZgsC04Lw7U0QARC/2DyIOpH2cueQT0XaJGE4bEfu5AgM4rnhCxpni3X90L7NB4dcGdCvbzHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230240; c=relaxed/simple;
	bh=6egyvUzAr9oSGAYf4YWLPTIGmpFXSQ+OY3vnuF4hdEQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HQah1zhfgHzOPElfBBHDXPZ0YzjOuJEvNRqJGUivx5M3Odd0RLSgjQUFZaDZtAOjuXGIWmDHDXjKyUOqXPG0ndN8k6sDnGV4qgBJHtIzwRMLCRQIzPfivoIYaE8xUEcq3TDgMsmxWgRM9z/9fOKy5MZaHBfnCoJ5gy7kkv+lzbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kc8zGdnr; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kc8zGdnr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cEguU9/yWLP6ixF8Y0BT0jaJYWw+kr0ds1e+EFp4t0QOaezE3nW9yavNCoCDvbPgwgZpJKafaPoYroJOFCEBDNN/JXcIe7iRg62YL+WAL/nykhsUVl7AMmMgYZpQ6rdxaKcZsN9ZB7Xidj76uLm7OmYw8nnrRXaSxKaqPLVW6VmaCXU/e7lICGtqROyj8NMH1ewvFp//em99bsE3caWE6P8c5Q4V4yhodR+HKTI4qWUaxe9s0/wtyis3xlhVYSDBLEd2e4HDKU9JmHJRO6RHPMjTFILwvCj1CLVcrYCl1mslys10qp62Uy+YicRRWZ83x3QJxpRuc1Mm0W1A5Pcz8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAylrhHiL/xjFfW6C5Qx9wwYVvokgdawf1k/cOQqw7o=;
 b=yDd+2f1fC7wd58sEMygdr79juE7Z3GHjSpPWIvl4fiO75ZRgsMcYR6uMvilpmgud4omdgOW/BrtG8WyLUn6Jo+cavbteDDaLp/XeVU4VzZ4I9AhD6AN0Ty5C9olYQVVjx5Bb5UajoWXt/Bmm0L38V1v2+0uB8VOMvxIIXMG80Aji41xQAHyV1ebt22Q4qEmfrvVfkcphALl5rVFzQw5vNS0k3SdSf2RxJWAAS0gNMQlTGdWhxwKtE7HH+9Fk56kPi3QxqQYkc4wAYJUCmEa3SijVZNJG89EY/hY1pHMCMeU4nlJrXVlAFb8Qk15iylyqcFt/tMqplYIM/N33S1Vb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAylrhHiL/xjFfW6C5Qx9wwYVvokgdawf1k/cOQqw7o=;
 b=Kc8zGdnrTcaQlVDqkhoLIUQw3+0HmCmfvzCszzu/D9H/ZsJbwsPcUu1zW9SOBffw5QKsmwHfARBpQ1E7QiM0az4ShbWl60nxBw7tK33gxMf3aUvIwwuwQgLnnauZIe3KYP7pHsO2KS0QdET191su9+gq/kdbe1nnb4S23QBAZugYOGjc4wTx/9Nb7ImTlz2uVTr8QQPQYesd2I9CnZIFZ0dcqcRlk1c01VbzEDyFoX+1jTDDJEOtdGruk+nGDqwNstXk9c1uRGVIADK5bHlP0pUqPavEYCe5S62N2Lp0jir7qNp9g+UCUqEhZs1fIbGwrSdc0Tvg7w6XTXsgNIv0aA==
Received: from MN0PR05CA0014.namprd05.prod.outlook.com (2603:10b6:208:52c::25)
 by DS0PR12MB7850.namprd12.prod.outlook.com (2603:10b6:8:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:43:53 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::fe) by MN0PR05CA0014.outlook.office365.com
 (2603:10b6:208:52c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Tue,
 26 Aug 2025 17:43:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 26 Aug 2025 17:43:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:43:31 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:43:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 26 Aug 2025 10:43:30 -0700
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
Subject: Re: [PATCH 5.10 000/523] 5.10.241-rc1 review
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8331510a-3e2d-4be7-960e-c0b4ae5af6cc@rnnvmail201.nvidia.com>
Date: Tue, 26 Aug 2025 10:43:30 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|DS0PR12MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb5bae0-9007-417f-5fb3-08dde4c81f83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTdBeXk0bWVBdWZEanpsQ3NRcE1tcjhKSXpsM3kyUzhTQ2JiY25rMVFKNVpq?=
 =?utf-8?B?dW0wMzhWZlh5M2hXZWQ3aXVtTkZOdlVWOUJKL0ZINGdmQ01xTnZ4TWZKL1hF?=
 =?utf-8?B?KzdQMmYvV0t2V2JVZUlLQnlxMmI2UkM5ZVp5MDQ3eGZ3NmMyUlE0cS9KSXBx?=
 =?utf-8?B?dmV4amU5dHJjQW9TVEI5bHpJbEJCYUFEQWZ6ZUM4M2hLSzNZcklQTUhxTVhV?=
 =?utf-8?B?Mk9lNFNSZW9BQlZZZlIvMEx2QjNQVkZ6Ynl4d1JHTWxrV2I5SzN3eWF3ZWgz?=
 =?utf-8?B?YnFhTWs3cGx5YzJjUXZEamROczJIMkJxSjFpekpOemFuR0VQWi9sRnhDeUt2?=
 =?utf-8?B?N2VpbjFlS1Bxb210NUdjbmx5Y2l1SXlyYXBtYWhSQ0dXVy9HTHpFMFF2bUUz?=
 =?utf-8?B?SWNwRVVIN2V1ZTBONmlEam9QRWZWY0ljM1o1bmxYMkJvVW4rWk1ndjFydVo4?=
 =?utf-8?B?ZkY4NzNnQm0yNUNROFhyOGZ1VFhsZ0FWMXhqMVE4VGtBK2NhSy9VZ2hYOU1z?=
 =?utf-8?B?YWRLY0FvTVVjWjZjSE5WOVNFeEJGckJTZkF3dXh5anJ2by9tUEdlaVBXRGtI?=
 =?utf-8?B?VTBBbUJIUzVPT0NrU1hzN3pvb3A1dDRxM1l4Zk1uUWd4b1RWRFp3NWNJREp3?=
 =?utf-8?B?ZjZVTVY4L3UySWtHT2Y3ak0yVmZlQ056bFFvSDZPaW50VkNZRHd0bnhlU1Rn?=
 =?utf-8?B?NDlQK2d5Wm12ZnJFaklRcXNzMFI1Zzc4Uk1jQndvb3NPekVmVnBsY3lRcmlS?=
 =?utf-8?B?aXNod3NpcEhhR1Fsclo3U05sYlEwZ09vRUZSbFEwUkVRVkIwY2F3RE5IeUZR?=
 =?utf-8?B?MlFoNUFTMFA5cnVhT1ZWZjlZemRLZE0rL25wQVpsRmN1a1hsUW9qejFDUUZt?=
 =?utf-8?B?VTVMcmxMSDZmbGY0d0xRdkNXVHJMMEJMSGZQUDlrUDZQMm5jMU1pSndrck1W?=
 =?utf-8?B?cWUraUY0S0Y2MlpPMTRpdDJkZ1NMY3dZQ1hqRkJuSndpOHNkSk5CMVNLMk04?=
 =?utf-8?B?MlhNdmJ5SFBKbktLRmtlcFhTT2RGNW0vaGZmdHREZ2I0K01uOVFFaGxjNGFx?=
 =?utf-8?B?MnJVRzludDFsSDZRZGNBWjFhVlAxY3Nkdm10Q3hrUXovZ0lPVW5VM1B4Zktl?=
 =?utf-8?B?cEthTWVSY0hEQmNsS1ZkVFpWcFVEODZjTzhWVEFLOFdQS1g1dndNamQ1dEh6?=
 =?utf-8?B?VlNGVVY0a0NJM3BYNVg1SURBU0hBNlBabk5XLzM1TU1sNHFhOUdZbzRvaWla?=
 =?utf-8?B?bDhuL2MxNVpzZzhmenpCUUxmditTVmVQRHM5QTRsT1ZNNzA0Rm9LOXM2eXFJ?=
 =?utf-8?B?Mk5VeG9TNWF5bGJ2YVREb3NVbWNkaUpZOW11cU05UFkvdFEzNUFkTFZNMy9H?=
 =?utf-8?B?QmlzcTdESHJQeTU2R1RyelhZVnNWbEM5b09SbGtnMFNKeml2NFNKdXlYRlZQ?=
 =?utf-8?B?SXhPMjhXSzY2Y2dDc3NraFdqRUN3Q3J3dHRkeHJVbGh3b3BYZGNiUEVXUmdY?=
 =?utf-8?B?b0g3Z0FEcDMwSmhuL2JqT2FhQ3Z0YisxVjM0SlY4TGN2STdSdXh6MnhiSUQr?=
 =?utf-8?B?VExvTllvSTBwQ2MzRmJvQUNYSW1xTUlBb0pPMjd6d2ZKakpXVlNGNkRxSnkw?=
 =?utf-8?B?bFZ6Q1ZrUjFScGNlY2lyN2pxSkFFR0tZTENjNCtIOFFLVTFQNjRnVHhCeU1m?=
 =?utf-8?B?NkpRODJBNVRIdDNwVGZnZnR2ZEd4cExnR0hTQVdMWkd3Qlo4dVBiakdRRnBy?=
 =?utf-8?B?S0VjSUZ2YWRjeTl4Z2JPZndsUjVUcmRzQVJxWEh1ZEhyalVYeS9ZSFhrckdp?=
 =?utf-8?B?RkxhSWM3V1UwNUhITlBNUlZCMndkejlTOFRvMnM5SU1YM01seU05OWc2Q3RI?=
 =?utf-8?B?UE93dzZDL1A0dHdJeGR4cVhwT1Vmc2J4RDE2QythbDMvT2MzaWhyRXQzeU4r?=
 =?utf-8?B?cm55WExjRWxFbUZsVmpFWUpaREtoYy90aHhITkdVWVdUSE5PSTVaMWxxTU85?=
 =?utf-8?B?OW5WdjVyTXRPWWlSdVJDSFVsN1d0RWFEOTRWVXdkcEFjSXJzVkx0b04wY2Z5?=
 =?utf-8?B?TDRVOHcrRWJSWmVzNXhqa0FQZGw2ZFB0L1poQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:43:52.7846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb5bae0-9007-417f-5fb3-08dde4c81f83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7850

On Tue, 26 Aug 2025 13:03:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.241 release.
> There are 523 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.241-rc1-gd8db2c8f2fff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
