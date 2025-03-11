Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D71E2606
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687142; cv=fail; b=EIa2KJQ2YwEXh8xTK3h4+8eIiVxxquhiLYdZ/Yn52VeIU6Q5uAO2BORNIdcPhe2OjgdP2w6Pg0novrlWi/uE7BuUqheEZTCdqu9jwAh1uUSH0h3TUl2re/cFMW+brQqn1SuTAzeES9dokI8E+4sJCJmd1sngIQixX6s7ZnY60Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687142; c=relaxed/simple;
	bh=N7N5LT15WFN1Q0eZbyNx0phLsVnKqPdMBFJgOsqNrJM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aXb/iY7UEZBupI7U3jaNz5CDobX5u0Erf9zP0ZAMkh/9QpY/RkN5oFxC0Eax4SrXpXGnc0q/0MUG4w9ro6LQiLdrAjlMxlvNTIHPZHfXPRt2nayE426uMjpqhy2nn4hCFZsOcPfPuNF9H4JPekj/qXEFx5YWbqLIQ1pWfGfVkpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nCdbfHwX; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nCdbfHwX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b14cz43MIHBAGFv7mpn2A8oB+9SolrxAoPnR6h0NYFNgympm4t6tz1El8nvlgig/3zVgwvbbPVbEtIGcNTFEYBoi875RpCvetE+q6ogRFApszekJdDnclrA0FtD0mOfSWNJMgiST2ih8R2qwwteAhSU1uelxU+f2lZ46Am1CqdvNajWGP0GL+nsjht+9Yj68NDx9QK0d7XYQIcZIZnMlSZ9JrZOphF5S5aGlE3c22LH8hzXvhO6HSHTuLZ7sSehuSL1CR9TRczvkwT90fWVD22G3ZNcPLLjvUrSWFvC86ctQkjItbB046q2EocDMknKXhlC072rJ02OE1TgC3bEAUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8J/Ht6qJXzNhHols3I9EMUniuQJ7BFtRe4uDLN+N90=;
 b=XanFwGdS5XCQK46Fxvpy1Rx3vVHRTNontj3qICo9MSGawW42oho9VEpcil12qgFveQhvULzUn6I9U376gfV0gmnc9KX24yGpJNIs+OyK8hHSACvkZtkh87zAnLFRti9oMFgk6kxytOdoyL5PKN926+KYmNnwVaGpOM8gXArclhWK9PAIf8nw9F3b8uXg6rNEoy19YURhPPo/4tRfDdS561JPrgbP3CJkuFjJeptO5+CLDDaeaSNxO2ekc0vVevAnjE/CiZ+Bs4SiWP90T685XsATlA/1aOVXyQZ6Vv4oCn+J3eBU5WnPlkkhSoUqw5Xanl9u/knFgg1IZZYk9lO//w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8J/Ht6qJXzNhHols3I9EMUniuQJ7BFtRe4uDLN+N90=;
 b=nCdbfHwX64ZRrP4WSXjKBJGTjShtauXSqDnNjX9KH87z1Su0NYid2wYFZVTgxUbf7vWV+pbXtuyzvCniVvBst2vaDVKoq84+oT9Ghb9x3dzs7UDGBQeLnQSRLLSlXFEeTxmYuXJVMjcaqANS0kdkjq5g4xqaxp2v/m1gINYbPWh7zuKZO+2Tuc9V89+LODVhQa9ADz7f/9Qz9XnbOeXAD7b/eUdJOwZ4svmVNy4bxa4LhXckDmRVL50JrpydhEQVs3+adjwc7jP3PWzMvgYee1mMYGdsVe2lG4Jont2v5o2G9xGcMkyNAPp6sb6TLC1CmKbSuJG0D1CwqPkAt3jrpA==
Received: from SN1PR12CA0045.namprd12.prod.outlook.com (2603:10b6:802:20::16)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 09:58:56 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:802:20:cafe::cc) by SN1PR12CA0045.outlook.office365.com
 (2603:10b6:802:20::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.24 via Frontend Transport; Tue,
 11 Mar 2025 09:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 09:58:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 02:58:46 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Mar
 2025 02:58:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 02:58:45 -0700
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
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9f68a7ab-046a-427e-b68b-0e60e4107248@rnnvmail202.nvidia.com>
Date: Tue, 11 Mar 2025 02:58:45 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ff68b45-b690-4f11-2777-08dd60835697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTF3eHhyWDlxd3F0aFl2ZFBGY2hSZitpQzJvUUs0b1RLSFRWWDhocE5UYm1r?=
 =?utf-8?B?WXlVd2tLSUJIZEhoYnl3NTBJdUlFelF3Wk1kSG5qM1FTSDgrUERYeG02aGZI?=
 =?utf-8?B?QjYvekRIL2VRclRHSWFrUW1XbWZDUTgvVVh6NDRpZWtDRzE1RmYrU1BMS213?=
 =?utf-8?B?RXRQRFpHK05kRGpDazd6TWdrYk9GS0FVMk1zVEMwMVBvWVpqYkJXcVBaN0ZY?=
 =?utf-8?B?MG5hU2llbDZFS2ZQZHlma2YzUWFVNkVtTk5vVWpodDJ3MTcvT0h5ZU41U2Qz?=
 =?utf-8?B?cVViTWE4amdoOGNZUjB4WUZxcjI3Q0UxSEdMV3FyWUxrRjVRVHJ1U2MvNksx?=
 =?utf-8?B?UlE1czFTSlhoaVNjRHlaOWpRZ2ZFeFVZdmVCQ01Dd0tCWFJmeXdaajhJTXpq?=
 =?utf-8?B?aThtRFdpV1B6S3dlVVpMbTVNS3daaHhzR2VONUhWNHhPTVVqeERXNGdtKzRr?=
 =?utf-8?B?UE1KNE95ZmdQbmtuYjJza2oyWU16VTZOcXdhKzJmS09Fd1IyMlBRdllnVDVa?=
 =?utf-8?B?a25yakU2OEQ5Umd2YURSQXYrMko5amxpWEV2RlVOVGJJN2hBcEVHU2lOVW8z?=
 =?utf-8?B?NjVVS3VFcU8ya2hRNHdWTkNnS3M1RXpSVjlwVkNBRTh1bGJrbmFoRVlyWi9J?=
 =?utf-8?B?UG5mSkxNT2dwbGRTU1Z4bWFsaWVqWUQwUFFDZjhCemc5NjhlUUprd2tDU1FU?=
 =?utf-8?B?YVI4UHIrcVZhbUdoeWs4aHVMTW9FUXBYS0NBODR0VlBzc3FzcmM4cWZLeEJr?=
 =?utf-8?B?SzE4d09FK1Flb3haRnlHeXlrb3U1TUlqMS9KTWdxc05QaTBKTDVPQmNXa3M4?=
 =?utf-8?B?WUdFUzkrTm9XUHJuZUtJK2Zsd0UvY3pMTVh1NHdSbkZ0NlN2c014K1REcTRN?=
 =?utf-8?B?RUFOTlBBRW9yUG5UUkRUejlHYlY4YjJWUEo0QzRHSXF0Nkl4Y2p6eXJPTng2?=
 =?utf-8?B?cjhndGJPaW9WeGtJV2tnOExiS3NCSjJLWFU4Qm5hMUVnSGg2R2hjdU1jbXdv?=
 =?utf-8?B?ZEsvWWVicHlwR1NSZTdJTG1pOGRHaDZjWithbXZHRDVRWVZIaUZqUHA4SzUz?=
 =?utf-8?B?TDl3VG5rZHZ4Si9EZXk5OEM2RjZqSENtL0U5ZDRIVWpTekQ5akVmWEM3Rk1O?=
 =?utf-8?B?WU4rV2VsUGQwazRRSGd1U2lRRC91Zlc4ZVdOSTAvWkoxT0ZxSHAvSncxcXl4?=
 =?utf-8?B?UXdQcDdJRjM5TW50NzdVT0J4dVlxOFdMdmh2eXZQOWYwNmNhOURmMjZZcEVk?=
 =?utf-8?B?S1F2RkcyV3c4YzZpaDdTSUVwM2Y4c1pVS29YOUhKOG1hWWhiSE5BbWZIayta?=
 =?utf-8?B?Q1U0bUF3OEdYN1NaT1BzTVdGVDJkRCsvRlZpd0RLSjdjSUV6SWR5RVBlYy95?=
 =?utf-8?B?dTRtcFBBZUIxSkpXTTMvWE5Ma1hteCsrT1F0c1ZidmRIYTRwcHR4WVFFYVR5?=
 =?utf-8?B?cUF2MndXa2FaMHhiNzVZdWwza1ROU3NzVWxRR0wwb0VabmRELzNzdXJZcWNl?=
 =?utf-8?B?VXE3bVV3Q0FGd01WZTJaY1lWQmRSN29mM3plUzF6cEM3WGkzbHJTQlZaczV1?=
 =?utf-8?B?TisyakFpRXIwTG1lcXlLVUJaZnJVN2JhdFRlWnA5dG9lUDQzS1pad1UwWWEw?=
 =?utf-8?B?a2ZrT01zZG8vaGJqQ1gyVXhIRzlwTzczNWwwRFJDTjJkNUJWMXI1aHd5emlV?=
 =?utf-8?B?T2xwNjlDb0daVFMzM0VIVnc2Wlk4UWdoMWJTYkQ3djJ0bEdIazhOWTl0dWJX?=
 =?utf-8?B?NitVekNiOFBZUlpxdHk1U0Rid3JLQ3pNNDZBL2kxTGJCK25wa3REbFh1dXpM?=
 =?utf-8?B?bjgxZVlkckZJamZaSXBkVGtrMktIdGRWelVxRGtkNmNXUUhFY3NrTE56UGJ4?=
 =?utf-8?B?Y1Y5RkxmT1ZITHhvVThlZW4zU1gvWUNNNEhqSFIzNWY0QXFXQm0yMkdZcitL?=
 =?utf-8?B?d3o4MW5kS3loUVdCSzVuRXA1Z1hrYlVIT2s0d0hVSEtIcGNweTV3eHpBL2lT?=
 =?utf-8?Q?7uU7oHPBKOPWaDi8dSMdzDFI8G7okA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 09:58:56.4801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff68b45-b690-4f11-2777-08dd60835697
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241

On Mon, 10 Mar 2025 18:04:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.83-rc1-g70aba17a9467
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
