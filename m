Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4CE6136
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253850; cv=fail; b=WHwD03w8HQmQQ4pZkyhObSjMBXVovqWbP45JdTTGVY5o746gVnrsdEkc6jdAQytVN9pJzK/LbxLHCLpV0wup9kP/WcbkuTomUXhfHaODjXZZymjbEiG6JsluQMts1ejw6cofF7QSrOC5rUks98z5y0/d0IdcLW32fIRlHWYv+fQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253850; c=relaxed/simple;
	bh=Om6dQ0JGNgAlNlrU9C3BfQIGauIAfcJk9oZIbfZp/iU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Jj5oB3un0qW6XWtrw5yekrK7y2jZ9PmD0e2AFIQpqwmu9acwZn5XdnPKsi+Ihre7aDkEDyb8E/LXlqtuowbNooDQYWetInB0rxswEDaJxsr4YNUoSKJeTYIOck5niTdQS/fsOYWx50cMV9ObsP4ghRquqkjTx8bg5+hc1DaZ3K8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rLoupF9m; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rLoupF9m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFcW/JT4eWWVtkjsrVYhnCcICnhTxyXxp5caNZUKqurOQ20clymhexH4cyWWLGm0VZ13D2T8OgEIuj/JHay5AEyunykrPiZGwm5gVdl4gsSPk7Su+MW162LozGb6j7vCpDNeqkLiTu9kd8VkPrHAceRyFocvhgqPATNayYprHEYacD1RaDOHc+CGbwWlF7Lv+ZU33XfCQA9BZtGTIilJjOlLuEEX1edMF0n2I86JS/dpbXeYi+D6ktUxUd78mfehTqS7LaTmSYZdyGqVK1NEAQao4EdG1mYBfAIwrDf21Us7WFUGhjXS9Nrjb6pX5XrUd/Iw8oxkR658wygRqmmAzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hLK0y8cKOUV5CTNxaIqivHecGe/EFh+dEFIUbeoi0w=;
 b=HAmAhg5j+xR0dqfvHtabDEUOrZMkOXXELjBl9O4iNtMH1UiMBIVtWMRV6mH6BJFp2/iydu3OXfju5A0p7J3nruVY3WbA2TrcpDp66XZiGmFcHofh8IzzoxpoCovXv9zsztrn6u7HaHTTHCzvV089/sgzCeWBqiYBv3tCR9obdghB8gsK5F58r9LUaP/J/FpLPp2dDFw8gOgbo8MqWz1FrC+P5lGujMHyTp+5YQQ08br0M7yc488k26aSzRkMtN/9SladjjqV+ngWPiNuUoSjzLhiE5aHZmrx+M+z+m9EelzyqC2GSU/ydqnXTa82AnBaeu36yuNY8zboA+Qmokv8jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hLK0y8cKOUV5CTNxaIqivHecGe/EFh+dEFIUbeoi0w=;
 b=rLoupF9mC23tq8USh6RTZ+T54hll70tbYwhuWROnKpSUl7yJud1LzKGy46P8eVvcnkavBTHq0bkX4xVkfHH/NhKddFw8x+30CVBIX0M/PXwIavuddN0VjF54oCoQ+3qPGd1vQMdSr/qu5Rw9VbmJ93UVg+glpGzvrhVsOBoH+efQYnUYiC/1/cDMXTyH+NEyP+4l2HcHK0OKWjVGwkcT194/8WAg3HmIVZNUS+4wI3uyUytBm99md6G44fjswZsbS5rwLh/5nM1iPZo6fMIZoud7GhFbIT7VfCs9X1zbQrd3bjdPJW8DzEOv6ChYs16lVdP+F5uj+rmiDwcN8yWn7Q==
Received: from CYZPR10CA0007.namprd10.prod.outlook.com (2603:10b6:930:8a::24)
 by MN0PR12MB6176.namprd12.prod.outlook.com (2603:10b6:208:3c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 12:43:58 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::9a) by CYZPR10CA0007.outlook.office365.com
 (2603:10b6:930:8a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Tue,
 7 Jan 2025 12:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Tue, 7 Jan 2025 12:43:58 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:43:57 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 7 Jan 2025 04:43:57 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:43:57 -0800
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
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d1f09749-df87-4f38-a2b9-bd177e776913@drhqmail203.nvidia.com>
Date: Tue, 7 Jan 2025 04:43:57 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|MN0PR12MB6176:EE_
X-MS-Office365-Filtering-Correlation-Id: 1036abb0-8b97-49e8-60fd-08dd2f18f45c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2JiaTlJUFZKRWIvcWNHVVpaQWo1R1JvZUk1ank3azVQUnhyUU1ISFlQYmNx?=
 =?utf-8?B?ZUNLaHNwTTJIbWJsNDlvc09EY2tMVzFFY3FlMXozTVozQkp3T2JGa200eUVh?=
 =?utf-8?B?ZnRhUWs4Z204Vmk1RWlrV2xnSEpsWjZEMzVaNmI4SGlPNjduTytCSmFRZUNR?=
 =?utf-8?B?NWlmckwrRU1YOCtpR2NSSm9VblAvdU0vZExrOC9MTmRrK0lFTTNqQlNMYlJt?=
 =?utf-8?B?eUluODl6OVM2MEQ1djZNcTA4QUZpUk0zbFRGeC9Pa0dGczJXNXZXcmhOSGF2?=
 =?utf-8?B?U2JjK0RuMmRNckNzdFIyM0VKUUllTjN4VGFoZVdndXJOMjRMS0YrL2tHWW9S?=
 =?utf-8?B?ME1LQnZvY3NWMFVBcXN6VCtXencrTkZ0aDZCOTRHaWljL2xRRmlBbWI4NytZ?=
 =?utf-8?B?dlIwMDkyMlAwbGNGQW0za1FUejUvSzZET3NtUTQxVVdDR3U4NTM4ajc1ZTBu?=
 =?utf-8?B?ckpmN2tTN0RQL2hXN2RTTEZBTnFCc3l1VlBZNkNMMGJRMjl2bXcwM1hIdDJG?=
 =?utf-8?B?WXJNbEtzQ0NRR25vUlJrMkxPSVBxNVNjM3g1TG5Td3ZIcDE3alk1RS9hTHkr?=
 =?utf-8?B?bE42OFlDTmNDYUZMbWROSlNPanNIU1hsMThxZUxFdG4rcGxSSzRaeDBvV05N?=
 =?utf-8?B?RkRyWHl5N3pzY3NwOVVYNDdZRDQxRGEwclpjZnRKZFVsR0crUHNIV3VFK0tz?=
 =?utf-8?B?S25wZzBsWFFuQnFhMXowTExGaloyMHhrMktONkk0QjFMMGlZZERldXVIVkJB?=
 =?utf-8?B?ZTlrZmEwSWx1ZGRuOXIyOE5CYWd6WWtCaU1UM3NIbG53SGtXZ0xhakphNjU3?=
 =?utf-8?B?alVLYkV2WXFTR0hKZE9FWkZZRkFRZjNYamNNaG5JTW1wYkRzaldhZURudkxM?=
 =?utf-8?B?VDE0MnFtejBLd3g5Zlh5OGlqajQvejVsWjlIa2RJNDVHUkNIRzBTRGh4UkNo?=
 =?utf-8?B?d00yWDl0VUNhdFpYa2UxaGdyUUdHalZvWUtMNVFxZ2YvcjV4QlAydmlkNWVF?=
 =?utf-8?B?N2ZFbUxSalR1N2E0aFdMT080cFRDcW1zUVo0bGg4UnBvMnBET0ZXN0dBeDhR?=
 =?utf-8?B?NVFYOFN5a3lVVC9Id3h0bVdJcXlYcGVuNDV4RytkWi94TW1XYk1xRmhkMzg1?=
 =?utf-8?B?MzRZakZBWTNhdWdQRVFkTGdob1JpbGVGYVFYMUtCcEsvRlRkTUx3YnZkVUY4?=
 =?utf-8?B?QmRCVkFlT0IwUm12bUNCa21IUkhDclY5RElPUStwa1huZzR0UXZ3Z3pPQXR4?=
 =?utf-8?B?REpaNUhuOWpGWi9JRzIrcHMwRlNCaHZyUnFzeVVnOFNRbW9GektObEtrQkVS?=
 =?utf-8?B?QlMyaVBvOFJPd0grcFQ0ME5QaTE3cktYNVVLL00yZ1RLbkhtMXF2UDcvdCt2?=
 =?utf-8?B?dkg3ZzRXR3ZFckRSUUhDc2dKWWFSc2xtdmZJYTFaYWgzaVlWbk80K2lGTDBF?=
 =?utf-8?B?MnRhOVhXcDgvbksxWk8yY01YcW5hdHJyM3IrY0I3dW1PVkNaRFJHU3RtMWZw?=
 =?utf-8?B?UkE0OTdXTFRkZThlOVRDbGhkdW1HNCtJQ1FYNXVFNzdlYXBhekpPUHU4Q2VV?=
 =?utf-8?B?YzFKM05KZUR2dHhUOS9zNkVZQzEwbUdTZlFsaHpEUEhUNExWUkVVTWE2dkhn?=
 =?utf-8?B?MmVlalFJWXZsbDZabzFMQWRBVlNkYUJMcVdSNnR0UFNkd1J1TU0rY29IRFkw?=
 =?utf-8?B?VEFNeXJhanJJdHNabWF6UExQcHhLdk1rTGxBcDZha2VsS2x2UWVGb08wTXJh?=
 =?utf-8?B?L2pUOUc0dk1BSkRBdmpoRFoyeDJiSTZ6am9BRTFnYlRzZG9Oa2lXZkZIeWNk?=
 =?utf-8?B?NnBUckhVdm93SHdYR1V3M1VQazVsL1pHclVveGpaRkRGZnZuZk1heDZkaXRp?=
 =?utf-8?B?WjYycnQwRFcwM2NETDdob3JCbDRleGFOQzRIalNGQlNmOCs3anZraGcrRm5r?=
 =?utf-8?B?djBUYnpIL3RDQk5mVHdzZ1UycFBISGxreGdzdUlMVjkycTlTODl4NzZkWkNx?=
 =?utf-8?Q?Tp2JbX3CcVyoL4fNjtBL18EmHFq7LI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:43:58.0800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1036abb0-8b97-49e8-60fd-08dd2f18f45c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6176

On Mon, 06 Jan 2025 16:16:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.289 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.289-rc1.gz
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

Linux version:	5.4.289-rc1-g0578e8d64d90
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
