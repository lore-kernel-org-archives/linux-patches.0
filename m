Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC36C1DE4CE
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 16:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975333; cv=fail; b=OaE3uC8jsMuFBTAcrdjb1g1Ooshml47gn9fa+3R8sFdD2qeZj2GDcvSnhUfQrbLYPmU3Lpt7SU6hcaJHI2VZgFrAZBcAgj2wk6M+8/Fzs1cRdFYrNWS4VAdgy9tp20O8XMlgEElWWWeA/6E5/+ZfPSCd3hn096J00HiHMQBx6UA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975333; c=relaxed/simple;
	bh=00iyz8sJ05b5Q5h/iSo7I6CwPfnSk2gPDTDljGmVbyo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XQ8cpkGoN6DHSnyIJQKSFP/3rCrzSjO6SVTTiI4/QHWYwypojxlaCubZPDRWxI5fgvAk0h5vcIrkS77s7PYLpFdSJ4wbkmQ/R729R3OyO5Rdpud/7ihZFzx7ktAfuMMte8QoSZ/6uhGsbyE66K5zxP0Wt3x/kLwITtWTTuI6QtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bcf+6vwU; arc=fail smtp.client-ip=52.101.62.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bcf+6vwU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvGLPWx3dabI+SdtO3fxFkkkDDM152sBpotbjGyKv67TjJgMD8XYIgkBKGTJHsxaK5cSF1Jvybvmrvg1cFy4DyxNK0ZZAjdsEl7NRICRTJ8z1eNxFDCcUw5RKeOgq/h7J1VJbgiuwcflhaNJqlWPkEBskvrDtN3BbMPmklOMv4DJSIwH9Gjtw3UHXJ4MVmsKzT2F2Y4rhXMmmrKiThZvjjvUmoFEbrtnEqx389oH+VAY4MgdZ9Aqw6iKi3j0M1NEsrj5G45Z70hnWm1pd19IfobvQ/UPTzKWmMyS4t7Aeuh6+5lX9siYPEoUMmUKLxeaJEmUM+ChD6B1xMBfEBGrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0siLS7FP4zmLky49Tt02BWASToOW5nOP0Fv8hIUYLo=;
 b=e7dHnIcITu3GT33N2KvNLy5kp8wnpzLwI/SeNv8Vh16lDFJ5Q7p2v2xSuKseZi8SboHV6NxTV0VTa5zBu0NgkeTBkfIyUnMSAdUxwZ4AVAhZqtsm40qATxIMD1BlkzMh73J8dylshxNITfqubK7JlGXe5DA+KaT7LCRu/vmLa2tntmpWj4ei+YOn7D7SWRFjJGv9XV5cTbh/fqNX1PgFWRMM/izSV3mKBLe0oCeeH2NeY8o6ENmOqSBEy+GBOyRVhxve+NMLE4sW+isEMrdj75Lw8uvff6SpShBBdNrsTRhOuYvh+Pu48qzwDEeB1AxndgRFufBaQYQ4FRULDIvC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0siLS7FP4zmLky49Tt02BWASToOW5nOP0Fv8hIUYLo=;
 b=bcf+6vwU82vN9EHw/dia8OvKeqMK9D4YI0Xw6vw5AmeOIsZIZjojvO4kGWcO8r1/7q5l235EKXqaNg2ntVx76O5vWhrwINAP2zsF1T8j1yFubOB1XcrgBtAM5vh3rydqX+kwuLSgCydIN9hqbuaN4mAeZvvf3BS5xDnHpVNQZFmASbwHA3XhmkMSA7FbdxZ4gIuPwLyWQlYMuo0HdvWAVE0TjWm6pFHdzuJqK4Ri50KyGNVRwK9uJxmcQuYvLSJf6+FiG3v1rfAZ/QqBVVGz7oiIHgQAvI2/KepuYBX0+XRFm6hdRRidbjBpoIehJsZd4hOgCGP82jRsugMELyYetg==
Received: from SJ0PR13CA0212.namprd13.prod.outlook.com (2603:10b6:a03:2c1::7)
 by DS0PR12MB6488.namprd12.prod.outlook.com (2603:10b6:8:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:15:26 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::f5) by SJ0PR13CA0212.outlook.office365.com
 (2603:10b6:a03:2c1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via Frontend Transport; Fri, 9
 Jan 2026 16:15:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:15:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 9 Jan
 2026 08:15:05 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 9 Jan
 2026 08:15:05 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 9 Jan 2026 08:15:04 -0800
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
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fee10920-1df4-4aa7-84ae-29510cd915ea@rnnvmail202.nvidia.com>
Date: Fri, 9 Jan 2026 08:15:04 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|DS0PR12MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a0f791-a523-496a-3e48-08de4f9a4c59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTZHVnl4RHFaNW15bDRoeGQzRFY5ZE9EbXM1QzNzb2x1Rk5yc25iVExSNHY3?=
 =?utf-8?B?MSttb3ZCbmxJY0VPZGZzRkY5Wm1zSzJxUTdIMEVsRXJDZVZTL2dDbXllWDNS?=
 =?utf-8?B?Qkl6OWVqVjErekx6WXEvanAveHk0QVBGS2JYQmh5cHV1U1ZrQ05FU29na3Q4?=
 =?utf-8?B?MFBoMUVBQ2tiQUN1cUJkcDJGdlpMNENzNjgxNDdxZnE2L3BUcFhuNlUrMC9P?=
 =?utf-8?B?MGpENGFkSVJTOFp2ZE5XYi8vQnlDMFJlVDhaVW10ejgvSXVoZFJBWTZBOVE3?=
 =?utf-8?B?bjBnd0UrWVVHTmlvUFNrZGtKQmxNVUtUOXNhczRmdkdzbnFleVhrajIrMjZP?=
 =?utf-8?B?cERDMmltUEpoM3piN2lSWkRacmVxOXJ4SWFBV2FRM0phQlJESVJ3T0J4bXlr?=
 =?utf-8?B?bjZOckZFOWZENm01ZE04WnZSaCsvK1N4RVVmUEY4cm5vcVo4QUhPd1gyM0E1?=
 =?utf-8?B?czdDS09GK0pNVUFiZlZZdndiYXlOT1Vnai9udWlQSEJSMncycU1NS0g1UVZX?=
 =?utf-8?B?clJudjlnaTIrRWw4alA3MDJzLzZ0ZWNDbGVyT1lSNDZrRFExVCtLaWpDaWwy?=
 =?utf-8?B?NU9MWEZsUTYrUU5TcEdsc0M0Ym1lbmZWUUZOajA0MU00UEpqUWZScDZXMnFP?=
 =?utf-8?B?b3l6eWlWQ2R4TkpNNXJmSG1wRHlKZzVBRkNYUmpLaDRxWkZQcDBlTWJkamFI?=
 =?utf-8?B?WUJhZklxLzZ6eThQZUpOTFB1bVBkN2RiREo4ZUZhK0I3Y0RabUtjSGlNZUR3?=
 =?utf-8?B?MGUvelN0Wm5sR2NucDFQbUJKRWFIUTZhVm03TDJsVTlneTV6U04ySktFaVpD?=
 =?utf-8?B?RnlTS2ZPeGZzakFkMFVVUDZLRmZ2NGZXRFdaNGIwMjVJMkNSVHFiMk9mWHZ6?=
 =?utf-8?B?OGd0YnhwZllESW83RHBtVmQ2WURYTHUzOFgwMXZha25UajFjdkFvUVdnM2xF?=
 =?utf-8?B?LzdHYnlCbEUyUDJRZGVkUnZ2M28rcSt4K3VBWjB2YkpCenJiOFlRKzRrVnU1?=
 =?utf-8?B?MFFtaCtpYnUzbWl3UVRNVDlSc1lJQWd0UWhUUHUxOWhTbC9JL0dhbmhWakRE?=
 =?utf-8?B?T3dGSFlCNDRQWDh0WThPYXRpWkNDYjB0V0llNUdzSzNmdEl4Q3ZTdkdiY0Rq?=
 =?utf-8?B?eTRBcjNuVXFUaXpRY091ZWJIN01FbENNQzRpVjkwTUdHS0tXQWk4VmZNYXdV?=
 =?utf-8?B?TXZWd2gwWWpOdHNtTEk4MllkbWQ5MTd5QVJPVjNxVmpIWlB2c0tqaEEzaThB?=
 =?utf-8?B?c3ZNUzJxQkhSbU5BdE5Ld3Z5a2FlWkxiQlcxRW8vcG0wTC9vZnJUSUVkbTZv?=
 =?utf-8?B?NDJ6Mjl4MEJSdENMMWpPNkN5N1YzUm1abUcxb2hCUlFJS282RnZtWHpoTDdQ?=
 =?utf-8?B?Y2Q0SVNKR0ZQZWxpMnBtL3piWllEdzlJR0hoU3I1ZHZrT2Vqa2crWStoQkl1?=
 =?utf-8?B?NGNudk9QZHFmQ2wzYjNTbmcxNE9YZEdhYWFSMlkxNzloR1RKSnZ6MGV3Ym9o?=
 =?utf-8?B?R29UR05FMkljVnBjdmI1UTNYcTdIT3hNY1l1UWJFR2RtSU8vdDlSN1VXaFZV?=
 =?utf-8?B?c3Z4Zmlmb0RrdjJMNUg3U3BJS2NrN2ZpWkV2MVhiSVhqUjROTnJab1NWZlJZ?=
 =?utf-8?B?ZFY2Z28yQXlBL1Y3Si92M2xkL05GRlk0aTZVbEtsTmEzMDMrLytwUEx1WnR6?=
 =?utf-8?B?YVVZVlB0SCtDb2V3K3UrYnhCTi80cUxabDRDZGJ5dkpHTHZIL2Nma3VVMXM0?=
 =?utf-8?B?S1k4OU5mUlZxdHJlWjBicXBJYXBUVVVvSmhTRnlUcXpFTE43SG1WRXJieHY4?=
 =?utf-8?B?OENBTWxnVUtVY3BFcjdxV0k3cmJ2ajVMb2FMN05Ya05GN253S09ZSGdnd1V5?=
 =?utf-8?B?WFJUWVJSY1FkRjdtL3I1WnFCdnMzczREUVRFM1JSOCt2NG03bFlNVlNISmho?=
 =?utf-8?B?N0VyVnhMRkJhT21jbWNLM3lkODZxUlMxTlZaQmpkWUNqeFNWV0haRy8zSDJj?=
 =?utf-8?B?REoyd1JwYnprYUEwbmtmcnFaWkpjMFZqdzhXWWJVejNpcFBWZ2dyVWxYQytl?=
 =?utf-8?B?Ry9sYjA1MTVMOUlHSHAzelRMNnlSa0lRMlRmdDQ0cVNGaXlJWTBkdE1mMWZF?=
 =?utf-8?Q?QOik=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:15:25.6353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a0f791-a523-496a-3e48-08de4f9a4c59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6488

On Fri, 09 Jan 2026 12:43:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
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

Linux version:	6.12.65-rc1-g7f79b90fd937
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
