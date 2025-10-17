Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABAA1D5CE0
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725315; cv=fail; b=sTr9aZO1HskNjcP0WK2RD3yOUCHBnthl7StP0lWVtfnnT3ySL8rvuLuLhXhOi0i/EIH5P1U54uDxJBJdEG0xYb/z+E5hBqUKatWdHFBJ0lftTZW5TV+ob3pqcAIBlpXHJERYZb0hy7upinMDtE75yUoe7FG33okIS4KooTjnOMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725315; c=relaxed/simple;
	bh=IXUp4ztWHZu4/Wrmzg/EroYKXI12rXVboKlurJ5B9ck=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VFD7yXxIn3258u/zFUipCluio2QBF9YJPjehOY6ANesBKEOQY+8BS65hrOYGe+w2LF9BGUnq3alAHZYeUJyEsDk+kFAjeLRaaN3J3eeaZ0v4AOCOmRPyducCyixsEa65+FhX1snabUFURi/hRtJwh3drqRSwU1gXEdQ14H7b/J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tKXOqPeK; arc=fail smtp.client-ip=40.93.195.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tKXOqPeK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvnOOeS7fI1I/98vnVEaTm01UEVdeaLSK2bzdPntKTF2KrPPyRSJ25ceKssK9W9UtWvQZLEYm/KDgHSrG0x6mFqm6W8k3CF1uSdQBkwhHGttTc9hj5as+Py1J0zXzbQM+5o3g2iyc5cjKHaeMsYaN092rANzMfU+IDdoDAv6x20meZ+8bIJ5wCVGog4DetNVMfAUtuL8QqZRO+cVwaZzxKHptfs+yROIImqR2sitZfdZpENDoEHmw6/vVJ2vcrUL91IdS0+hWMmZ47MqTaJvdJgoPIL4tDr7JlaLpqf8SwEK5yRtL//fFdZ7F2KLXbCisHzmNgSIXlXffbVGW9YkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/XrJwFm8Z7ECuyJ1xMV9hTIetyF2PKJcG+RDnQ44OE=;
 b=fF/s3HgLckA1ViX/CDPZEt6dyoFJWm/Y4O4MRvFcDWXkWdZXapm+gbG1V0BnOEL4eHuDJrAmKJZIFJqIe4mWlOdSfajgwgzA1rxz6qoFyurHZrflDgZ9i4IZJSB/O8UOmPsqXbAo4ZOOclYxW5M7NkWihYEzH91OZbYVjBFHrTRjTv18WI9V5D/3EjIe8oAfi93RHEV2gY8zpO4X4C6+Jg1J4H2SNx1rrigMET7glpusumsOUM6BwCJBBvKQCEyvQQ/YMOyorsNkSCKV61K/Px77NAzPgm07l/2OAD0ur5byX2aIRYwzbf3woNrFlgsUMA8YYbMv1/tkzmkL4dMrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/XrJwFm8Z7ECuyJ1xMV9hTIetyF2PKJcG+RDnQ44OE=;
 b=tKXOqPeKCQ50MPV3asPmjp1T0COcxZFbwGkzT08nVf0FTaNSrnWz8fLVXihs+4RXv7T40z+yTPmgt8rc2yaV5Zd4ocQ8sVKasQSa+bWIttn6m55dcIK+Lx+quXa/skI07w17PRWL3Z72g34D7Zrle57vUfoSWrnmfRyQasMlOdQ5XHp2EMKQgD2+MZBnzpH4fq875sP0WGK2bxKUr6Cj8VI00hAil5gLXo5oz8sSfAOEc6vs80OW5OtsGKaVGTpBRXkeZZnBjG5cA/WzqHvEK5epeP8cSnioyh5/cJVGtnLmFcqTh2KXVOqxtmDo7ZsC9YRy3TQUfO/0KU+w0Vgseg==
Received: from BN0PR04CA0066.namprd04.prod.outlook.com (2603:10b6:408:ea::11)
 by PH8PR12MB7181.namprd12.prod.outlook.com (2603:10b6:510:22a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 18:21:48 +0000
Received: from MN1PEPF0000ECD9.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::f2) by BN0PR04CA0066.outlook.office365.com
 (2603:10b6:408:ea::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.13 via Frontend Transport; Fri,
 17 Oct 2025 18:21:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD9.mail.protection.outlook.com (10.167.242.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Fri, 17 Oct 2025 18:21:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Fri, 17 Oct
 2025 11:21:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 17 Oct
 2025 11:21:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 17 Oct 2025 11:21:36 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <12a34a62-1811-4e6b-a80a-2fb8fd631c02@rnnvmail201.nvidia.com>
Date: Fri, 17 Oct 2025 11:21:36 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD9:EE_|PH8PR12MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: d5100477-f402-4cda-4552-08de0daa0894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmdiaEdENnlCQ0VCeHVMUi9ycTh3WWpSNUNBamhHb3UyT2YwNlFTME1na3lB?=
 =?utf-8?B?VlZGYnUwTjRWbVZwcUZLUGd3cHF1Y1pyL2JTZVhkU1VISmU4RlJxb3gzbGNw?=
 =?utf-8?B?MjdHaW81ZUZNOVFnRGNoRDdGZkhzTm1CRmRXWm1iK0dQMGxqVG9pOVBFNTBB?=
 =?utf-8?B?WFRvekREdFB5Ymx3ZGNwdzVvOWsvZDUxc0tDenFUSTB6MmdHRDNBcjJzSUFE?=
 =?utf-8?B?K200SVdEdU5OMFA2UmVlMGNzMFppcGNSMlJjVkJWUm9HbEh2RnlLWE1RUzdn?=
 =?utf-8?B?dWEveUJmOHliN29NdDAwV3AvRkZzeVFXdGN3RVZYTlZzUytXTDFhUFFiZXo0?=
 =?utf-8?B?czQwNDRYT01GZzlIbDQwbkdrRldZWmJUQXluOVlNRUVPcndvYjdqYm1LOUxv?=
 =?utf-8?B?UG9pNXFCVWlWNys2OEVSMHo4bEFTVklacHVJTjRvVG5MaTE4OXp5RElYVjZ4?=
 =?utf-8?B?S0FUYmtEZmRsMi9walNTR3NIdGhRTytvamF6ZTkzSThJbkJMZTQzYTlyc1pp?=
 =?utf-8?B?NGF5blBBMHpRQW5xTTd5QXYreGJBZDJ2eFR6cHdpUVYzSEFWNWFobWR0Q3kr?=
 =?utf-8?B?ZUtWbmU4cTU0RWQ4alZpTXhiaTFjK2Vwa1VaVURlQy9aQTZGVEFQRWZ0b2sw?=
 =?utf-8?B?cU5QallGMWs5WWhiaUF1bmVBTW9Bb0xqQ1JTZy96N3ArVUtZeWNRakFBanVS?=
 =?utf-8?B?dC9VQmxMZlJWdDJtQ1o0N1dzQmlyV05NdGtBZVl2aGRBOS9PQ0NFV3hoVGtM?=
 =?utf-8?B?d0ltWkVIVy9VUTFvVjlIRGsyRG9tUWc2STRkRTh0d3NCQUFyOXhPWjVaczlS?=
 =?utf-8?B?L2JqVmdRazhLOGVvL05PR0YwOHRTSTNXdEF0dERlTlMzZEE3dTNsdzVmSi9B?=
 =?utf-8?B?NE9EenFqTEo4NERnVEplNU5hMVFObVJST0xIUHl1QitGVjU5ckpWZDRQM3JO?=
 =?utf-8?B?OHV4TmNtK1E0a0lkZDJIWkFzM0RUVXgreWNCbGJEcDY4c1E2RmNMYXE4b084?=
 =?utf-8?B?L1lMYjNHZmw1NE13dzVWN2I4RzloUnM0MldLMEJTbWdJNGtPU1Y0bGJKdjB6?=
 =?utf-8?B?MVVkK2hwanJzSzJ2UnBIOS9JVHd1TGlrRHB5ZU9ET1Zvc0RiWFlyODFmRjBr?=
 =?utf-8?B?UnZFVFRrck5XSW1LMXZLQkg1ZzkzT0xiQ2xRR1Y3WldHRjdhbS93Qk5DNjZ1?=
 =?utf-8?B?djFWNlNwSEdsTm01UzE4WDBaZVFDWnBJUFVnRXA4ZmxXbkpzK1RwamlHUE9Y?=
 =?utf-8?B?TjZDUW45eEhhUXZiMGgwMktZWHVxajNsMHg1Q1o4YnN3REdGYjVSWnlPOGNP?=
 =?utf-8?B?TFpwRTZ0WVI0b3NYSGsxcVBUd3VWdXhGaGVjZGRpL09ZNEZIWDlTWkRyclhS?=
 =?utf-8?B?VXRLVFNHbjNmYTNGTUw5MU94TkhiaWF3VmZqRFd1a0lnSlpSZXVkRmc0NW55?=
 =?utf-8?B?ZW9CRUlZSGR6N0NQSnJNZGZqeUpUK2V1VVhwZ0RkVUgzbEZFbXZuZ0xwdFVs?=
 =?utf-8?B?R3NnSVlvMmxmalVuZmpJTmVrOFlqUDREdTFNekRmOWlSTmpXYWM4a0d3YzhK?=
 =?utf-8?B?Y1pLcEN2eVhVU1dTSjlVOUkxWm51UVhJMEswQUtHc0p4YjE3SmlmSlFHV25Z?=
 =?utf-8?B?cEVGNjBjY21yTFVVYlFXODBaU29uT0dhUFVIajU0RnhkMkhqMy92NDJtK0l5?=
 =?utf-8?B?bklhRHRmNVY5Kzc0TW41by9qaC9DVmtSNFNYMmY3RFliZFNHOGVUaFMyR0x2?=
 =?utf-8?B?WHZZWnB5Ym0xUWVtZ3hoUEV2UEZRMjZQZ3ZlUUdXT0pTTVhyTmhONDdRczY1?=
 =?utf-8?B?MklrK0xKa3dWenJtc3FkZTk0UFI5d1RJcnR6UE1CVnpXM2UwNGVoZkpPOUVX?=
 =?utf-8?B?ZG5GdEg2UkJaSVhEak56d0JSYUxDRE5uS3FCTndUSFRpM01wVTFsQmMyL0ZZ?=
 =?utf-8?B?TW9IeWtQQ05mZE1XUmFLL20rbVhPaHNlOXJOdnEwTDBybG1kd1VqMFJTZE50?=
 =?utf-8?B?cWxzVkFKVzhNOHBLOXFWdTJUQ1hvWXB0Z0h6Yk5UMTFQZmwvQmtZR2dEb1p5?=
 =?utf-8?B?Z0xTdVhuWWRkTExTRHdIcHRsRDhiUjZuSHdKQmplLzdPOVFlcDNzeGszdUxQ?=
 =?utf-8?Q?g/L4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 18:21:47.0982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5100477-f402-4cda-4552-08de0daa0894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7181

On Fri, 17 Oct 2025 16:50:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
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

Linux version:	6.12.54-rc1-g6122296b30b6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
