Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133254648
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301930; cv=fail; b=Xmkfd8zad84p+lqydo7pCcMxf7rKYeCXyjuvH8I8JWUDFcbWHhVRdT6yjd3XODwFz/14x7QI2JAsjYVO3Jyv2MfradUvO28myZIkXkn8QWNA/mfl6rCQUsRgFTKirdx6C1anV1ZZ9W2ffCvVjbE2dzaHiFZL0jIxyhgWIjrQGzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301930; c=relaxed/simple;
	bh=DO4ORYnVYbrLG+jSygx9fJ98T6xN//l4lxDUXfF+HnI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Zpvqv958JgsoMIVC5fv1qnyQCbzqwmO5kznQJgFwRb5W4TxgMe2O5eWABH3bbm53hXSKyFufTX74y+L/gYsZFYPuQr60XNjXeIkZ6vjXcdPGp0EXGs8vs/EFXTneG47UjOEsKqViKJu5dVaaZIz0oUyhsu+f8RXzWZ7Yt+mJMC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GYotuykc; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GYotuykc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwqWq1M4GyE0dfewQPleUqpIpfwYJ902dZPRMOVeMEq8GNdX2dOlEkPHLvr5xo8vj2M8HyIUVQ3vFopfUE1IoQqKW12M9Mhcp9gy2TshUiuT0QQRrO2/sNyBS8rIsueTacPg41VX84UpoL+yQU7g65qK/gaDkDV8sYsfYga2+10V2/lNjWRtq3FTr6m04KOg0SVG6uNy+0nVsf+uEJvuI2kQk/DRo+DZio53bZ4/MJwqgo+ETfMyDGzbPo7TaOA0QopITq50dWuyWOwJiSWuUovv+r74XUKsCiXbcdXCS4g5kiaDDoy8z/Krz/TLrvGc3O3pDjqwV9Icxrl/jRZNBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxWnxic5QkakBew7c8+fYnzdgmDgsMyKp39dVFxlc0k=;
 b=aWkBpCZvwEDNKVS2LKMOgZW42bUSuIDBZPY/gpMi4Tvk3XsD4sXQmt5m6ViCsmYgWGMg0C2X/6z1t4oIu9RWqKZyw5VHJCi6ru+/8cSDPF0vdlONU14a/dB3M/yL5idsrVJjdfPlNenH3ZWtC6eIDtbStE8D8DpNmyaDFNMrY257UZffVPKYb+P5QCr8f43iv/ZH1+EMIY43AkAtcSFau4cOcfa65gU/mKkKrPQOdXTqQHniNlb0Tq+TvhreoqzKSDKbUVW7AwDTk//NyGNVEVuIuVtIOPPPqKqrb1+eVLYIa38tEhPY4OhmI28SvYCscWGSOsulc4CH7OWQFNWx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxWnxic5QkakBew7c8+fYnzdgmDgsMyKp39dVFxlc0k=;
 b=GYotuykcOPCE2PGEXBpk7D78Kw5CQqRWeDHwWzYKs8MeIUGEOugx2abHb+RjiTLxfSs5uWmhhVZGEv9GowgH3i6wbUjXKn4t+9Z06Si3Ng2iWrx+gExVvI9Tlefb66RlXZfmDlTuviqb/IUTSGWICXjIfz8R1xeQzQ55bUA6Qdbb5/vCCjuAdVLF2mpLVURQr7i+hkkcNTB6n3KaFgA/QyA5o4rMtQlVwP+NJ0QM1y/59/dJebqsA9kNBJlbOicuwTShkdEtwP7werpLKGaFzEjDRKyLfdYG98gg9HhMSg4/qQtTxiALdc2xIYkvAqTHN8cbpXYPEan4AmtigoxWtg==
Received: from SN7PR04CA0050.namprd04.prod.outlook.com (2603:10b6:806:120::25)
 by DM4PR12MB5844.namprd12.prod.outlook.com (2603:10b6:8:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 05:38:44 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:806:120:cafe::fe) by SN7PR04CA0050.outlook.office365.com
 (2603:10b6:806:120::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.17 via Frontend Transport; Fri,
 31 Jan 2025 05:38:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 05:38:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:38:35 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 30 Jan 2025 21:38:35 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:38:35 -0800
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
Subject: Re: [PATCH 5.4 00/91] 5.4.290-rc1 review
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d4080d4d-581c-4c50-af91-0108bbf145c4@drhqmail203.nvidia.com>
Date: Thu, 30 Jan 2025 21:38:35 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|DM4PR12MB5844:EE_
X-MS-Office365-Filtering-Correlation-Id: ad2e2ed9-7777-42f3-0ca6-08dd41b9866f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1pJSzlJa0FGME52UXJaM24zWkY5QVZydzlxdWlwQ1Y5VGc0RkFzdlJiV3R4?=
 =?utf-8?B?L0NtdW5sM1JhWnpwb2JidDR3Q0N3NWtBODZHMCtnVFVxVTVkKzc4Vmp0RlRD?=
 =?utf-8?B?NXdGUkE5a1l5aktSait2bFlJRXk0RENOZWtRalFlZC9jZHIyRFdPLzBIUmd6?=
 =?utf-8?B?bTB6SnVjMTR3QVlybnl4dXZQZlFXaG1pNWo3R1lLOEMrTWRZYWJEQ1JrZG5y?=
 =?utf-8?B?Sk1qVE82MmtVa20wdm5vb0xoTWw2eldHNHVUbkQ0TmRPOTIwcXcyTUlWOUNR?=
 =?utf-8?B?a3RwNXJKTHgyUjJBNml1U2tuUzhjem1YQjRiQXZFVFpvN3BaWm1LL2R4WFBu?=
 =?utf-8?B?eHdFOXZCZTg3MEtFWSs3alluNVF1ZlIxb05keW9NRDJ4YThtL3RaS3Nhc280?=
 =?utf-8?B?T25TMFhrVUE0eWdxUWNVTEdTRFZJUDdRVEg5TnZIWWFiUXN4cllyc0VjRXVM?=
 =?utf-8?B?SkYwSlJJY3g1UHZvTWJQVUNpME9RWkh0Z3daaHZJa04zVnU0WXdBYnhzbEl4?=
 =?utf-8?B?UGZzNCtUcld2SUdyNEVqYnhXZFpDZU9PYWhpcjN4TnEyaUowcUZvZWwwSzFs?=
 =?utf-8?B?UHhIM3VhWmx5L2RGc2VHZ2hZbkZrMmY0akJpdjg5aGJrOXdoZDYyaSttbDVH?=
 =?utf-8?B?Q002RjZxZVprSFR6L0Q4a0FxYnV6bWdISXZJcFlVMmpvWXZ2TnQxTDM2cXBL?=
 =?utf-8?B?UGFjYm1peUZTaXhUMGVhaytEelduZWJMVDZteTFwNTlVdnNFSEJEcURGVFkv?=
 =?utf-8?B?RmQxbDNrWWxqaTltU3dqci8yUFIyNWE2RVd5M0hoNENlRnV4cUVNSnhzZHFp?=
 =?utf-8?B?a1MrbzI4dmFLRzB0QkJTVUVoUFJmREZMN29kY0FISy93TmJlbWhUTzZxTVhO?=
 =?utf-8?B?WXVVRTNXS2hDSXZJY0FxbEpQdVJHQUVaY1NrZFRHdnpKZTJ2TXJibHE5V1dS?=
 =?utf-8?B?UTNpeEhTemo0SzBzQWVOUERKemdkaTNLdlVrQUFPNjYwbngwSGtjQktqaTJu?=
 =?utf-8?B?UEdybzVXSHlWaFBMckRodHYrV3FmNWlhM2tZSkFDQjZQRlNtSFp5eHdWM2t5?=
 =?utf-8?B?SndBS0orNkZFTG45dE1qS215SnFONU5zOW1xMFY0bnpseDZERkxUeUJoeFMv?=
 =?utf-8?B?Ty8vWW1xNlhHcm9oc3c0NnptVzQ0Nk5SdVRvZGtvc29xdUwzdytIcFlwM0c4?=
 =?utf-8?B?aThXdCtjT3RwZU5jVFM5a25zMUQ0YnBxdWw1VnpHWVJ1Z2hudXlxdGxEWEJC?=
 =?utf-8?B?WUJpSUhCU3FYcm9aQ0VDcm1wa0JFVVV3Q09pbnJ4eDFveDdvRDBaUCtkMkVr?=
 =?utf-8?B?Q05RZkI2QXRoSlkxdVdzWXIxMjE4L2FjMnU5ZGJ2UnExOFhqZ3VaamNHMUIx?=
 =?utf-8?B?MUZYVUhKZysrRENPRGJVRmIwUnFJKzFZK3ZySllJRlJxOWMrS3N3am92RXkr?=
 =?utf-8?B?Y0w4WC9xZ3BrRDgzT3RIVFlKSnBTY1lPTXBxcCtBa3Y0WjNlYUVBUE5rM3Zt?=
 =?utf-8?B?YzIvaG5BTyt2YmFDT3dPY1V2ZWk5c1BGUHhoVFhIaGY3N05yNjFrd3V4RGpP?=
 =?utf-8?B?NG9ldGdKWU1lZVVuZ21wYUkzMUlBaFROQ2FwUnpuWGc0Qjg5Wko4ekdNYVZz?=
 =?utf-8?B?emdTY3JVblh6bUJGUmtjaUZpdU8ybys2SWN0OThEZ01XR3k4eUFKY3Vydjg2?=
 =?utf-8?B?ekxpN25BaFowZHRZQ1VwSXRWS1Z2eVVjMVNVbStZNnhDT2NZa0dXOXgzUE9i?=
 =?utf-8?B?dUZBcmM1RUdqaHhBcG52V3F0eFpIYmFBOTAwa0FsQ3AwWEJLSXEwMDNFa2kr?=
 =?utf-8?B?OXVGTzFvV0tuNW5uNFhpd2J6VzFWZW4xeTljSUZaSy9Jam41T2t2RCtQam9a?=
 =?utf-8?B?Q1hOZGhyQXRmNHlSZktuMWIwMEp3eVNabmlXazdyRTFWMmU2ZG9qZzBmZjhl?=
 =?utf-8?B?V1RiMVd2S243KzBoa3FUbDZLVy9ZSTlwTG85QjgwRHMzdW0wWEZoS2tzbjJw?=
 =?utf-8?Q?wihXRI5yEFlrxWG+JhC7G2Q5eKtmBU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:38:43.5408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2e2ed9-7777-42f3-0ca6-08dd41b9866f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5844

On Thu, 30 Jan 2025 15:00:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.290-rc1-gd06b29df5286
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
