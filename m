Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B121C7265
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 19:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732217985; cv=fail; b=lM3tUiwfa3SBsNxROjqVWpH2Gm5uYoHkLk74dib3LCNawJG5gkk1bTVvu1Uuw0VuAa541yBqJSRVTIGNYlg2OYSlPb1YrTQa49Zo7vpVRRlQ+VjKQyCz6kRICn1WP524KS3GG1tQwrMM/VmQXRGHA2nRBSfOUVF+/4tl0TLM2fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732217985; c=relaxed/simple;
	bh=zWL7fo7G3K67WYBszVD36hGL8I+0SHvwIGzVggrV0d0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UQUE334KoLst3AkYDF51G46fXwFyySHjSlwNq0uUVUkNEmQiONZt5q647E/a1gJif8BXbejsYU97HNWwirbixICnygEZCRQ8xxv/9wgS2/5BMDDZMTZDU/fOq8uBWVLn+8Wkl53RVjNBI7LYexCraHroWFa9WAn7JPPgiBiPRc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cbPI3L2o; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cbPI3L2o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtrdzAtOPp80bWcqxntNI0MqndgmkMsDVXh2LzIPdQmzgUdlR7bZEn3mVDafXDS0LO9jZTaXV84sru1wDa7BWWl29Sh/OrSSgkz2Msp6hQ1CUazmgZRDrVB891rpLW1SKkEQCJ2qm3kDmvzH1nbsocBOECk25OCe0YvLRmoc0Ib1KSX8ATVT4Zp8bjOMuxSqm18a1FE4FjK87nuspIE4Leh1NWsdmWU9CLcBmrKZYYJqyzvsp2OrOnKQxxoHEjrj3oLPri/emT6sScBNT4mYLJJIzl3bHw56OUU9KR6yExD/Y7mluVLU5+YCkmkwzuJT49wY88YBthvV4heGLgvxkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsoV5sY9eH+xsHFAdQixQwyUdI4ErPTvJ0C9xEnX+Qo=;
 b=g5BmuZXat51aGYdjZUInRt7fZl3Gc70qeAE16IUjh7PyAX0OXiARfVEesmBQT6L2/vM2zLlKrAqlay5g3M0pUV0S1A+7Min7fMZiaKOT5EHqqw2SK5YS00ZOa6zfT1CvB2T6z5hNQ8nPFxl5tN0gzaOQ17bPcAneYddvBbsyIg+73ijBgD4KFJMs37F02XOZTVaeGbiTxkcVeLF+UjGr2cyha6BYweMSqO08UwvbB9WQwadiF5MIIl1NSjiZwiqFdGXEmWmUAUo1V6jOlYi+ch3MaymxIlj0bVqqWSrZKlJAXJ29WvcVsXqcdZ6Gj9C8L9/dWxBV0iqdo5XT6bOAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsoV5sY9eH+xsHFAdQixQwyUdI4ErPTvJ0C9xEnX+Qo=;
 b=cbPI3L2oJo0fn/II67TqX6AGF0XY4hGneZWORcwdD8XG8iQ0D829lJS7Q6kBAhtihm5xQtU6nVbwrX27R3d4Y6OiM/MLaa25AJuS0LElaRfCFsUPT4RU2gt+sPkx88sZ6jKy2+gFLM6ayaQ9uqqnXL43O92tRLJyIKaZdxyAhS0KW5H1oJIBcVRCQrd/TP/TFNHBM8e/UL3TI7OsTuWbIIZwF9y7ZNdYzbfd1sVbqWNMzwh+MThDH4morQ9PR9drLMe4S8CzkXbz5v1rJSZR85aUQELdxNWWmpZ+brcIAWznllFXxccL02sb91MkcXHwE+DzPCIihJgBi+cgppdqlg==
Received: from SJ0PR05CA0109.namprd05.prod.outlook.com (2603:10b6:a03:334::24)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Thu, 21 Nov
 2024 19:39:36 +0000
Received: from CY4PEPF0000FCC3.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::57) by SJ0PR05CA0109.outlook.office365.com
 (2603:10b6:a03:334::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.16 via Frontend
 Transport; Thu, 21 Nov 2024 19:39:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC3.mail.protection.outlook.com (10.167.242.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.16 via Frontend Transport; Thu, 21 Nov 2024 19:39:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 11:39:17 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 21 Nov
 2024 11:39:16 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 21 Nov 2024 11:39:15 -0800
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
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d68d91f2-a903-4890-8fe6-108e01b7dfca@rnnvmail201.nvidia.com>
Date: Thu, 21 Nov 2024 11:39:15 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC3:EE_|DM6PR12MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a82f4f3-2786-4cd8-9bc0-08dd0a643b1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3pPSUw1ditKNnhNdmlSbWdRdnlqMmlVZjdSeXF3b1JqWTRrVU9UMUNZc0g4?=
 =?utf-8?B?MlpBZWQrbmsxalRWdkNjUWhJaVFEVkQ5enNmQnFRa09UNTJDd3g0dk9LajdG?=
 =?utf-8?B?UDN2ZUE2QlpOOGtYazlOVnEvelRGZmcweEZTMmNpSkFNSWdQaFQzNllFdXRZ?=
 =?utf-8?B?Q0liZ0lQanhHL3lqUEJ5bVJmL1g3VDFDTXcwdDg2TVVtdzZMOHV4RXZ2RmxD?=
 =?utf-8?B?ZlQ3MDk2dFVjOGRHSk1DaHpUKzRSZ2x1NjF3MHBsK2k2VFNLL3hFeEJzVVhr?=
 =?utf-8?B?S2x4OEpFWFAweXE0MFo3RnBORGQ4RmVDa1h5Z2lhaERzRUIvRk1sZG1tOW1V?=
 =?utf-8?B?czZxa3dZRFhGMGs3cHRCbWx4dmx5WUkrZytBeE1zRHJLeGptN21OcHJIb1pa?=
 =?utf-8?B?SW5kNkxjTDR2Zks5Q1h3eGtxcE0xZjdGSXlQSG5EVHdUQmRTUVdaNjZhS0F5?=
 =?utf-8?B?VXZ5MnRFZm1FbU0rT0l6WDkwdk03Q1hsM056bGhCZ01JWnZ6VVZBeVo4TjI4?=
 =?utf-8?B?MjZxS3JIZDVjL0U1VnFYUmNkdm9YcTVreHNlWVFJSGcwVkd1S1JhZDFGRFFv?=
 =?utf-8?B?TG4vVUVFMkl6bzBhbEpuaTMzM1RYK1NGYmI2OGl0Nm45ZllDSFlWOEY4cWN1?=
 =?utf-8?B?blM2RDNBSW45SDc4L1M5a1ErRloyQXU4bkVhNnNmQk5nL09PMkhIa2hGdWly?=
 =?utf-8?B?YUVwd1d6VFNxeHo1OTF3MTFzU0hoTzdmZ2Z5RUpkVDhTWHQzSHdlbm54RG1j?=
 =?utf-8?B?Y1dVV2QrWHBmaGdKU2ZBWTBUS2dIR1laN0xYcGFBRGFpdE4vdE9GTTlVVzlo?=
 =?utf-8?B?cC94ZkllZlNiT0pBV0hHRXYwbFhqSVlpOUxRblFleEJyV0o1WjgzY1JJTzUw?=
 =?utf-8?B?Q3Z5UFp6REpiOGt0QjRwN0xoT09vaEZTSWo3VHNSMStvclMvNW9iS05sSmlE?=
 =?utf-8?B?YVB6Tnl2bjNwaFF5WHhFcGRIMEhDTkdtcVdLaVpGWHovNzRNMTlvcFRPaGpF?=
 =?utf-8?B?ZE1HSzl3Qk1BNjNjNW1MZVIyUTR0enBtb28zV202K2dSODRXellEMHdKZVc0?=
 =?utf-8?B?ZGg0cFlkU2xnNWZ2Zjd1ZUl2Q2xQZ0FWaFVZbm1mTlpudzJET055ZUd0Zm9u?=
 =?utf-8?B?NG05cmFWdEh5c2ZEQndNYUtURksyaHlyandEeHNiRUorTXpmM1Y5UXBtcU4v?=
 =?utf-8?B?eTJ6UllWMEhNRmxmWGQ1TENncWluSWFYY2pJbE1uSnNucmNoWE9ndkF1M1cr?=
 =?utf-8?B?UnVjMkxnd1krMm1ia0JyMWhMT0IyUUcrS1NYTVQyMCtTWSs2WmdoUkgyakVK?=
 =?utf-8?B?aVJKZjE0WnZUQU1RMmNrQmlsVGF6cVBJRzBTWlpidVgxL1JuNXJiS3RKaEp3?=
 =?utf-8?B?TFp2SnlIVFY0TW5VYTZLeWZzZE02ZG1na2d5WThzTlVBNEphNW5jc25Qbkw2?=
 =?utf-8?B?WVd0OTh1UHJsandtbVZGbGhGd2Q0WjUrU3E5c0JqNVFaczZneU9KSWZpNEVi?=
 =?utf-8?B?SzBaL3hTWkJMQmFLblRoOTAwNEhscGZGWWFXSzlZNW5LYk1OMlRpRVNOK1Ex?=
 =?utf-8?B?NXRmUHVxQmFIVFFqQllRR1NTVmlrdlBEc3VzR2NUekk2U2gyc2tteEZCVEpr?=
 =?utf-8?B?d0hBQ3k4dWI2RHpTZUdxNEsrS0VVdmZ1Wk4zNzRHUjJscTVPeHdrdUVLUzA5?=
 =?utf-8?B?ZVhWMFY2eWp5dll2QXZLN2ZMaTNKQjE0TVpuM2VVTi8zK3EwSTRTUEd5c2th?=
 =?utf-8?B?MFRoVFJ5Qis3Y0FGM05QMWxrZXZ5MTdOeHNNQTN2VWFjVHVBc1JIN1NqWDdD?=
 =?utf-8?B?WnErQmhJSVJlcjdiUEVGMHlGYVp5ZEgyNEIvSkdFUUZNN1pCK3ZCbzhjZFgw?=
 =?utf-8?B?TFNjR09rRkhBMmV1L1lCNVlQM2NHMjhBK1BLL3l2TW5qR0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 19:39:36.0123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a82f4f3-2786-4cd8-9bc0-08dd0a643b1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156

On Wed, 20 Nov 2024 13:57:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
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

Linux version:	6.1.119-rc1-g43ca6897c30a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
