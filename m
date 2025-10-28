Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D709530E823
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650965; cv=fail; b=e0/SaYZ1RBMmgaxuw++8nQC4Jy2hi+o8xhJh2flVb4n0c4buC5Re0/N12zDJXr9pJCqDa3KW9WRFGwDo8keOqaWKTUa81Y/VdL0ei5kGCLWsyblsZi6h51ORbyNTKKbkxKP3BvFIjxMqYg42hj/FuIm3XnNurja7HgLEDtJyYmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650965; c=relaxed/simple;
	bh=2pXnhIIqyQpn0ptIbf73vuL5ZNrqutm7xfJfb1dofsk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=B8WXbJGFXdcyTD6L3T8CTiMyJcpl+g+5kx3hNXIN+u3LGawyYYys7lGHX8/TGDRTRgfsUwh5YHbrUfzJsTe8bnj+lQ0zA3uqMR9OYQx0e8529Ogzj3860D6U3+bvOHdfsu/GVy36XlQ6qqMe17KyDYU0QxEI+mqqO6D3PjZbrwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bOcF7cXw; arc=fail smtp.client-ip=52.101.56.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bOcF7cXw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRBPyAJCIvyzXYcbz8dUDUI/bYCjhpYm6pfOBr9brnkRbZjwG2gitxgmjBTdlr1rtT2DMFgbzx3fcCCM3+ibEeYkeyxEnznhjStIEtg7GGhRF+dLpzk90MGEp9CVJG0pU3Y81idsoSyVxHHzm59r7ddW00t3wQofxV1HPv3STVWam0QXhnyhrB+M7lYYf/XcpXHvq5PRb+8S4FwCO/aygkHAvNl4AZaPLRaeunx5E9orFKXav6l8rffEofvtPvp4+3jRISkr2uxfKUQC6l8W52/CcKlDL44gx5pGt0+QaSDMVPNYMIlmGfO4id1R/8AdAV2GMsElCnhQz/YS/u77Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgdGobpqgTJ0Xz8pWv8ZrOkMvDUM92QwUFN5Ymj/8AM=;
 b=Am7O9wKv4FwgzDemIMCDpZsk1ga8migxofbdzziex1KhuIoWzIrnNu6B12kzQJw2LG6MDzcrJFrY8TkJKReGIxY2RFkkNhQn0f+MuxingOc/yFTgMLKx9D/uELHW5vWZqpbuQ/bcuaqsTNLcwwKVgR2tyt+JfCxFuTpyu/+pWctgcYL2wUaHFGYh2lpy1BSBFNZhyCsQQ5V6Ndz0chvZ4fMYWDJgRx/0dd4FPByTG35JrqJQt0sWZKNK5woN3/zjSUi6jRL/PKntTSEHjoImfW5PUUHYisGYtAREVsz5bOGNvvLxSlAQiZTHFJTAHwZqp34xr8SYvXmvNGmLD661MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgdGobpqgTJ0Xz8pWv8ZrOkMvDUM92QwUFN5Ymj/8AM=;
 b=bOcF7cXwKKBpWOfH/fWR59s/U2eB8mnEZ89xr8rEUdxgUzeErL4fsAUUrAz0hWvVxJe4oDBKoBVgjpmumcXl/Lsa5Ru1f8hx4v7T+i2bQRbm/aO8E6LTAdFvgx9rUNw9+F6izH51z0CC/K06Z1Zveo3jtxuDs4/7aCH8Y7ezvqWiQ5q8TAbpsjZChqxUAYcI2ExsDEd/O7+gkXKHeTCdavF7vBi4hRymv4a43PbIHE30x5GnIYEPqElyQ52uVqcWw0KNFgUSJ+doL5os3BEgvOKCWBNwh1IJRigJTQwvnPoUDxKg5y17Btp1YvHhMnMupP4jcCrHQb77S6uCPQZ2eA==
Received: from MW4P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::21)
 by BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Tue, 28 Oct
 2025 11:29:18 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::1a) by MW4P222CA0016.outlook.office365.com
 (2603:10b6:303:114::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Tue,
 28 Oct 2025 11:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:29:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:29:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:29:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:29:03 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7e4886d5-ee87-43df-8914-bdaeea9f9fe6@rnnvmail205.nvidia.com>
Date: Tue, 28 Oct 2025 04:29:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: b734d4e8-3a08-4d04-e6b8-08de16153bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVNNa25UUDdHYUwrMGNmcy9LeTJrVWs1RG1sRDhvRzJjS29UMndNUnFMYnRr?=
 =?utf-8?B?cU9hdTBlK01MamRkam9YZ3VHODhxclMrcVdlSGlHOW9DUWJUbTNja1ByTDFl?=
 =?utf-8?B?d3BGV01VSjFrQXRXQXNKbmZxVWVTczFaSVlhNndHZGZCNlRRVVlhd2VDWHhB?=
 =?utf-8?B?a3lacFJXbXJTWjk4UzhWbk1NTFVaeVJVTkQrT1J3YllEd2dFUEZITnBJbXJS?=
 =?utf-8?B?eFg5U1ZBTzVIc2p5WnV3QUc4MzVCN1lIODgyWldza1NpQUtaTGtXakxSQ2RH?=
 =?utf-8?B?MnBDWUFNRzg5QzFQWVNZNXZBZUtVYVBXYVhBaS9sL2Nvb2R3MHlXMEwrNEIv?=
 =?utf-8?B?WFVYVFBzbUE0S005TzZrTENGN2RZaFhFTDA2ckF3bEcxQnhPLy9LOFJ5d0lr?=
 =?utf-8?B?R2Y2M29nWEFSTllMNG5FUGhZWmhDaWFqa3FaMm42MTA0MnFXNHUxSmZraHVL?=
 =?utf-8?B?NTVxSlNMSFF2ME5NQjNpWFlEaGgzTlJhZ2VFUU0ra3BPVWVMUnlkZWM2YXVW?=
 =?utf-8?B?TEQ0Q1cwcXFJdFZHSXhOQk84bDEySGtDdGhudENHYWZQbURqZ0ZEZkF2a1Bq?=
 =?utf-8?B?V21kUGc5YjhLalJTNlVsdlpRb3ZnS2p5bkl4L1VTQ2hKR2RoRUJSSWpkb3RI?=
 =?utf-8?B?ZUJQa0ZrclBrSFhWSmt5emlSSlp4bGZkMDdFYldzK09Vd05HNGVqM0ZuMFR4?=
 =?utf-8?B?RUxzMFhwQ0tmOWNzRzE1OTkwMytObXRYUm1WSkxIYkpPZjliVkFZRjhhSjFk?=
 =?utf-8?B?U2toMUF5byswbWIxazNCMHlOcjhkSDJOVlJJT1ZrcGMzekk0WXJEZ1ZMNUhT?=
 =?utf-8?B?eHZiZHdnaTBQS0d4UGlieDE1cDBoNmh6cjJ6TW9GbHh6clZ6SXR4cFBNaHp0?=
 =?utf-8?B?di9udk51VWhKa1JqNk00Y3p6V1AvMTV0QjEvMFJCZ2tZd3FnaVhkd1E3UDBB?=
 =?utf-8?B?QnFod1VIajJZZmgwQ3ZVZytzbytQUi9sWHd6aGRPcEY0aEYwL09WeDdpL0JW?=
 =?utf-8?B?a0pLRmpZUUh0UzlOYzBWRGw5bjRuWmgwMmpqeHRPQnd2VkxkMzdtVFc3M3dR?=
 =?utf-8?B?UlRFSGpBNnNUVzhpRVg2Y0dyU3ovTUVxVTNiVFNnWmE4RHlHV21zRGtYSDdD?=
 =?utf-8?B?RENuODZla1ViUElVU2FpYkYrOG1ZY1UvbWkxbm1sOXg3OUQ0elJGbWI4UVA3?=
 =?utf-8?B?dXh0YndRUnUyMlhOM2d4ZmZOV21qcUdnd0NIMWF6OXRnME00aUZzckQ5amxV?=
 =?utf-8?B?Y1B4Umc2RVNPRGNmcXRGMnkyMTlMQWRzQzBnMTZXWEhmNlF5QnE2MGhGZE4z?=
 =?utf-8?B?ZGZCUStQYXZUMzlPOXNWN3ptaWdTMHB1Z3k4UnM5UXBkZ3ZWd1FuV1JJOXB5?=
 =?utf-8?B?eExQeHV0RmJnRzhlNzdpcFRjRS9VMTJhTW9ObEttVnYwNy9hUUZOUEp3Y0Fo?=
 =?utf-8?B?WmJyVnFzcHN0UFhzUTFyWVRXOUF0bmRsazFDRVc0WmhXOGEya01ybW1FSDZi?=
 =?utf-8?B?V1hKdk1YOXVkb0hHOFRKd1RoaDIzZ0h2ZTFsQVR1dW9SMmtmOUp2OEs3UnNX?=
 =?utf-8?B?Y2V1alNoS0pKdHpKT1NadXZYVGQ5VWVQWUVaVHE2Vi9iaDB1V0gxSmVxM0xO?=
 =?utf-8?B?NUVkbkNEbmIyY1pTVW1ZNUJqL0RpR25idWFDM2FDM3REOHlWUU1Cdm1QdnpC?=
 =?utf-8?B?S1V2M0cwaWJtUk9uYklIbUlUNEZzck1ic2R4OTI0VHhDUFRodEFMQWNib3ZL?=
 =?utf-8?B?ZGxWNFVqeHJpY0hNci85R2E5Ukh2VzRBS1BYYStQQXhoZ3dtYWlVMGExc04w?=
 =?utf-8?B?RSsrM3gxVXBSRDYyQzRUNUdjaWZaeFltSDM0d2Vja0FCYW1pS1p3bW9wNjF6?=
 =?utf-8?B?WTVpR0hOMzZMZXlnaXRZeWJaYWVqcDFscDFtT3hoMUNOZ1NQTk8zZ0IwL09X?=
 =?utf-8?B?Z1pGckQvSEhkK1NUTWhuRzFqRnNkTnhRRlluc05ZVXVBbkliL2tUR0NlQnBk?=
 =?utf-8?B?cmt5am54WFlnVmF3NkVaSEg5SEFkVmFsMzJ0UEdXVmZORlhBRHc0ZnR0eTU5?=
 =?utf-8?B?VGMwdDB3NTF5dTV0NEZUc21qZnBCc2Y5dys0YVAxbEdUOE5GVzliaC9XNFpq?=
 =?utf-8?Q?0+8A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:29:18.5273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b734d4e8-3a08-4d04-e6b8-08de16153bc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193

On Mon, 27 Oct 2025 19:35:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.56-rc1-g426f7f601ca0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
