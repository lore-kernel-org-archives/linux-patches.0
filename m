Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226CE19D087
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697557; cv=fail; b=Byssiji8YpxUQ8pknbHU1fqz6I3/v+IpDqagi/XwBs9yabeG30VTHBPMY8IN/vbHM4cj8mfrDxr17COgIpvqMFSvxjpSnl4K54kWPALyhz7fUTUadXjnp75r6zFyrfbOXuIcmH1SbhssAn8cVJaKM8PtpjFZHBZqu1xHWg7WQig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697557; c=relaxed/simple;
	bh=OMeGnk5X+lUv8hgnhUtsoS8dxfuCywsTV67DmMUcxQs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Gpf6sFxOC8uIxU40GawtRZ/j9oqnIVIzQZltGQlsL76DBsA+KZY+CP7Al9HcD/q6B38e8i3FfTYmBqVMq7uyrIael5bN18SR9G7kLJQz6sZBM9jfCyvaJ52T166V+JGhTkcTui8qi3U4vcGAg2V+YmNqQcTwgEGRhIZzWzVEfSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KDP3+jJ7; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KDP3+jJ7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfzigxAxq0xF+zTpO93fr5gToFCG8EYuoScpKehbRI4YtO2OWpivLzuF+Zzfp/78Wkiqqz1Tm8ziVoazVyZnTn/KXAeuPBw70uG00Xs+2+aEXWPQtRGtV1W7R+PcQBoG8BgJLyzprgvRDSOx8ehuYiT4MYov0DY7CRbniz5VnWmZOJwwfWYKRnGixnJq4jaXS/j4XXxZsYpr6y2ky3zLX9KRmVqdkNoonudzMWgy9qvuqR8YJkDZ6nnzEYymR/P1EV2DyyRGsDDgzD99SD+oawIr3FNWnvTe4ABg9Ux/MaGoCX/Xy8GmmcIt7cWdprbNs8LwJItjU+Rhmoqb1k1Vcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1T1h+0vIKWZXZH2gslTe2U0QP1+iZnMwLpQW7x2ULJE=;
 b=sGprGAG/Q/eExCg+5i5SQsyX0f8OE/JnLOHNJzurOjnxgEFvdLhnT5G15+Qqj2mQ6K4TNlDmFtIFApvbmpRtiX0IXLb2GjL7LhgiIGOgCG4fSJb4PQwjhJxIix8mK4iGimWSFp+ErsenRltzaC39LblROA8K7OBmz536mVLs5bdEAKhJLDa//SO7FyIYqbOVXhz1FJXAMY7DxeeNjqvdycz7hVI9mMFnieFReQHiUo2qwVoY0X6ZBwueDUTEdhv9CWFeNwudOrjNRpdYxU+tmvJ1otWOKAsTJAF8ZtFAiWuoyPZ+5641K3lv7y7Z2Sn8JFpR4Hsy4//REpgEvqn0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1T1h+0vIKWZXZH2gslTe2U0QP1+iZnMwLpQW7x2ULJE=;
 b=KDP3+jJ7ik1IvPjmDwpVsjfeuyMh45SZVg4r60NUnEvzir+hkZo2Cqxv8/yDFV+bVn4mktGuRgpideqbuAZV3zB6xktG0bkWYvzq8Zhx2klpJVMMjST/qP6iCTCGwpEHahRcYb30fvx4mmsSTiuql9IO2YEsjrPkEvHf+23zxEgLd9LI+mnSsGxRLc2x0ejPmXKMxF0RcsL6uKphm6teziJEcddUNZ/pvc1Ja1Hm0NGuypcZ7gytufKSD2MXYfxpD0uVEi+qZQ1rMZo0a+TR8v8UzpJSxuG18ozONAaCh2NPt8INSGa/3bill2hFFDkUCICJKDTYKbGAHmrjQkk6EQ==
Received: from BL1PR13CA0097.namprd13.prod.outlook.com (2603:10b6:208:2b9::12)
 by BL1PR12MB5876.namprd12.prod.outlook.com (2603:10b6:208:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 09:45:48 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:208:2b9:cafe::27) by BL1PR13CA0097.outlook.office365.com
 (2603:10b6:208:2b9::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.19 via Frontend Transport; Thu,
 8 May 2025 09:45:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.3 via Frontend Transport; Thu, 8 May 2025 09:45:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 02:45:31 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 02:45:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 02:45:30 -0700
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
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
Date: Thu, 8 May 2025 02:45:30 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|BL1PR12MB5876:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff513bc-ad7e-4b19-3565-08dd8e151c93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3FaZHl0czNDZjU4aXc5bWhmR2Zqdjh0dExXRXd4anlZUnBKd3NwSnhHdURl?=
 =?utf-8?B?N292ZHBkRmIycFBzWGdRczA1dHVkQXR4MHR3K2NGN1dtYVFwbVZxczc5MVJ3?=
 =?utf-8?B?YmhuVmJVT0t5Vnlva1NuQjNuYVJnYjhZYkx5WWpYbzdRQklMcU9CTnFSdlhE?=
 =?utf-8?B?MkpFODdkRlhnOVZkVmJOSXpDVTM3MTkvSFJwUjk4K0gvZUJwQTd2ODJweGVZ?=
 =?utf-8?B?cXU0N0xSNDZMamxyaU9odGlWKytEZU83WFpoQmcrSkwyN3ZuWTF3Z2hoMHdV?=
 =?utf-8?B?T1pFWWlRdlhsRFlsQWtyOWZFempvN0xjaWtYanhSajloOURBaHJqYkZ2eHQ5?=
 =?utf-8?B?VzdGeXZuc2Jjb0ZqZit0YTd4NWtTc0lPUDBuNjlBK1pydkpqR1IyYktjN1VE?=
 =?utf-8?B?T25TeTgrQ2xiVWs5bUtnNjh0eDZvMWpqYjlWa292T3VGVlFFVnA1TzY1TWZX?=
 =?utf-8?B?d09Qa1daV01JRlNhMmwxT0p5VkVGVVpNRmwxRG0rNjZxMDcralZ2MnBDczlS?=
 =?utf-8?B?d3BmVzdYdWtmWTl0WVZtS2JrU3dzT3NEUU9EcGNsMVZlbXc3Q1FoV0NlalB4?=
 =?utf-8?B?ZW45QTlGUFF2eWthcmM5MjR3ZTU5M1p0dGIyVDhlMDg2amZaUy85RE9Ua0NI?=
 =?utf-8?B?NnJaQ0RCdXlZbFdFYmRldjJRd0RPSHk3WUtUOFdFc3J6YmY0blJPVmpvTnhI?=
 =?utf-8?B?OTZKMkxJSzJsQ0RoYzNHTE1KNjRBR2RQaWlCNjR3R2FKQWF6YzVkV0RzeHU5?=
 =?utf-8?B?NWswQ0l2eFpISFpKMmQ5VkFJL1hEWjhXcGRWMWtRbWIxc3BZYVp6b2ZvdGM5?=
 =?utf-8?B?VWRqSzdQNHY0TUNtbktSTzdXSXF3VE4wWWJoYTNzWCt3V1FtckZ6YUpYOGlq?=
 =?utf-8?B?M2xLWXROODJmZ1pPZ2h0enY4cUIwNTgzQXR2N2xjMEZhZmd2dENhQ1E3TWtR?=
 =?utf-8?B?OVkrem5UQVhRL0I2NUl6dUhBSXRHaDI1N3dlYkZ4SEs2RDJOUGlTOWlHdDBD?=
 =?utf-8?B?ak8yU1BUeFRGOVhyODJyV0NJMHJDZDN6bzNiVEx4MENWRGtHaEpUQTNnZ2Y2?=
 =?utf-8?B?aU1NRHNoRmhVNFdiS2RQRCtYT3psN1c2eDJrY25sdEMvOWVZVzBCNXRKMTEw?=
 =?utf-8?B?RE1QY1ZFMWpkcTJ5U2I5MWFMR3NScy9FTUpwYnBRejM0d25BNmVUQ1lFdWlp?=
 =?utf-8?B?K05XQTI4b1U4M0gvcFJmUzhLekI4N21jL0lXdEpoQUliaUt0RzAvMmFBS3lF?=
 =?utf-8?B?MVdycXBVQmVTeTJKZDZqSDRmZWxVSkdPVysvOVBmQVpuK2FyeXJHZFAvMStG?=
 =?utf-8?B?azZuTWlOWTlsd1Q0OVNrY1BFQ0Y2K1JtamJKWHB4TlE1RXZwOHovOEdKNndy?=
 =?utf-8?B?NHNiNVlnL3pSakhRcis2cVdPUGJLa3ZPTU1NSW5xY3AzV0FSM0FKa3BuK2dZ?=
 =?utf-8?B?YjhSN1pydDRHQStRR1pUYjJoR1hieU0xbUhSdVpRcjI3Ymt2QjNrc3RFSFYv?=
 =?utf-8?B?TStaMjJsU3BHYlhSbVkvZ2taM2lXTFU0SG12NEZ3NStpQm1aZ0NwOVh3SXRa?=
 =?utf-8?B?eWNmbXVDaDZac3dBWjg3U0hzTXFFWkNZZm5ZWE1RVXFjaHpyMDY0c01yM3JL?=
 =?utf-8?B?amZZUXpDK2NxN0V4clBJQ3Y4MzU3clVlWFgrdk54NFdaUEhkY25QMjZrTVZ1?=
 =?utf-8?B?eE4xZFdyMTgwbDdlSTY0dzRQclQ2dHdZOFdhQzJESnNZbHlUUEpDanFRWmla?=
 =?utf-8?B?NWVqeHhuaFVobkI3NnZMUlYrN1FZMU5TMWFVSlVHVklpdVFqWUJDSk4xcTJi?=
 =?utf-8?B?cDIxOWpWU3p1MmZIWUxoaHRveXZhMkRJaStMOFRwWHpzVjZRdDV5N1did0VB?=
 =?utf-8?B?K0txK1ZaRVFhd3p0WGVMYkJlb1pEbUZLYTRDR0w4S0dCK0dSYkJuY09VUkxH?=
 =?utf-8?B?WjBkWUhxZUVLZENITFQvUVVoOHRGVjJGTXRBSnliTjFKYTg0ODEwRXlNeGNL?=
 =?utf-8?B?TzhpRGlkREptM3FLV0xNUTZHc01sZTl1elB4dnJJbTBlSFU3dWN6dVRBdDJ5?=
 =?utf-8?B?N01UMUtHRWswN3BGNjNvelNnRTk0RWhDTHhuQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:45:47.9360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff513bc-ad7e-4b19-3565-08dd8e151c93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5876

On Wed, 07 May 2025 20:38:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    115 tests:	109 pass, 6 fail

Linux version:	6.1.138-rc1-gca7b19b902b8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
