Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A8B14885B
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301951; cv=fail; b=qmalt/9ALbZXtbtzCcYfHFFKAhya23ZWnOxxojItIbDDKE7IijJs7sjrb63RKrNl8hOxg4N9lNkbWyJ45K6t7TK4TGesixHpPRueMf9pDsx5U0JQ55Dk7tWmFkPPgUhzgHxD48LUk3bMpCPl5EeERthmQNREI36eS5meW3O8648=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301951; c=relaxed/simple;
	bh=ZbzcetNWJX8boZmUdLDBpGHFsy4wTnKfKGdYtoelu/o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WipXeoK6jBPQQznQ/K4ygsOqJDhLfroibueAWR8ni8+mNyAU+F7FzklKdHwTka+GWCE1B/z9c/6G1QPW0t7M33ZwLVQrPl0oFqdECisixckRLSTi/DFlItuT3KQ6paJmB5GxfeoJVNXebyQPj4GtgkSD4Qle6da9ywxRoHigFxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NjitSD6Q; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NjitSD6Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jL0C8hXyplr3Q6VL0dAwut/2kn+BsxBkrG6+poylhmm2Rciw9vnPPh9/RvjROe2y/vswGng0N6A7PtGyAnImJD68UL6/wyveAC1UuNZrEJvsG663XqEBX9T/cUjIpaDKP0GhPT/bhfZ7Q8ldt7NkUCrtIih2WZDWU7ScCWdBAI5nH1SsWqIaafJ4ivS8rmgKIh55hLIzaqOCHfXaDLr3J9pC75z17Wt6pYEFXH6J5h77yAevKuT8GBe2hZL12nDw4dMFVfaLAJUdGNS3ItP/9M3gBQVAFF0Ly7aS3HixHbfUqUJAyBDdtW739VI5zXZSPbBYfAIVOZaV8ghDu9d4jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+T8bkQrTk/kiAqSzgJk6Pv+a+8JJHWNPbgyck9ys3g=;
 b=AhVoQzOTBcRhs3mF7bLA/u5BEK7Py4DwIDP1eT1rXL7dhF4Gy36D/FVQCcQs2j7ox68V4ohHRd1sgfExiThvsjZV56MT/lASjqLHr/eeyiC4uinbE83wepoAnVBWJbQ8qZ7fSLHMn74aJjKcSW1kPUCndgx8hlmQOP3lFFBtohrxxhVlthVVeKiqQ1yryAJ9RzGXsR+wtxbVAfa4P/KXY84efw2k6Bk8x1fvOgB2kVwekhhdrdmXmFp11dv+QdfDsJSsXu7D3CGPmK4ZAWeLkYN5+Zsbs+dqlA6mCrcIlJOCWfKE7k8ibmNkqapwHZi/ZtcL2Rq07pbxqjAlshycdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+T8bkQrTk/kiAqSzgJk6Pv+a+8JJHWNPbgyck9ys3g=;
 b=NjitSD6Qz8uMtd1IExmaBF3e+eIOQ3dyPPVFo9v1qVoEKeUfy10/SYhC9rGOvO72AVZIbNCv6qoOa78fZ3LEm6eTTy2P4FNiv06zW6dVKMLZkjsB8rpwtuQ4ysupwxhJDVzMuPhLsAZycbSphPTCmHOSVCI/WzQPwj0n4yaSgj79ZGeffl/WA6S6rQhr9B4QggoW1akd787vU1t0scRWdQyg+x/QNz7wFNsD26SBerxSFEEqgcfYXbNG6EpRNc4fqAwTji8a+RAKlApYqBUU8ned9ZB5iDyYQzXHUmEEPfj3ReMJZRgIeUJMfnXV5QOHQuviuNzvmy9FzItXxvMOIw==
Received: from DS7PR05CA0010.namprd05.prod.outlook.com (2603:10b6:5:3b9::15)
 by SN7PR12MB7132.namprd12.prod.outlook.com (2603:10b6:806:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.28; Fri, 31 Jan
 2025 05:39:06 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:5:3b9:cafe::1) by DS7PR05CA0010.outlook.office365.com
 (2603:10b6:5:3b9::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.18 via Frontend Transport; Fri,
 31 Jan 2025 05:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.5 via Frontend Transport; Fri, 31 Jan 2025 05:39:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:39:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 30 Jan 2025 21:39:03 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:39:03 -0800
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
Subject: Re: [PATCH 6.6 00/43] 6.6.75-rc1 review
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b4d01db6-c138-4425-a72e-64a9c0a07058@drhqmail202.nvidia.com>
Date: Thu, 30 Jan 2025 21:39:03 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|SN7PR12MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: 7632fba1-fe91-4881-af50-08dd41b993e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODcvcnZ5dTJ3aWVFVEZhdlExbkdFMm03TTJMUElybWtDeC84OFdwZ0FLU3Ay?=
 =?utf-8?B?d3dVRkFXSGpsNVVyMU42VU1sZSs4RXR5Zi9KTEVtWkVFRUhieklmOEtNejQ5?=
 =?utf-8?B?QjBYd3MxTTN5cytoLzlaajNHcHlZM1JQYzdwVVNiNTZ6L1AyMW9QR1VtM0xR?=
 =?utf-8?B?clRZbWFmZmoxSmxuS3lXcVdiQ0ZSeVZmK3RINXRPdWpNSVVJT2dSN1JKendR?=
 =?utf-8?B?Zk9Tall0RzRIWmdTb3hGa2xyL1VnRjN1anY5aitVOVZuR3YwN0VZbU1xUUtV?=
 =?utf-8?B?SVhUWWU4d0lZQ045cWVEbHdrM3FmSklhU3VHMDQybTVabnpjQkpVRjRiYWpJ?=
 =?utf-8?B?STBjSWxOUkw5a3FhWEh6L2QyVTN5NEJJSWFTUHNUb1Y2NlBOcVhoZ0Iycmh6?=
 =?utf-8?B?d0ZYWS9HUGhwU09YVnBrNys0SGFKYnJmWUdrWnRtRzRXU3JKR25QYjdJZjRV?=
 =?utf-8?B?bU5zc3VCTDUxUUxlbjJJdDhUcmNreHJRVWJlamdzUmJTR1VRTENYd2Z1bjZ6?=
 =?utf-8?B?cnBUOW1yT08xVmV0Nmg3MG5CWitxOVRFY3FJVWZ4ZHl3RTJRcTJDM1hqdGty?=
 =?utf-8?B?RW5YNTlZaS9PMWFvQVZLZzd4M3JFRzNzL0NJRUNPVHZjckFDdVdpak5Pakkv?=
 =?utf-8?B?RWcwbEpac0JQTUwrUU5laGVnREpTWVZMNGVZVis3WWpabzhGTnZXSXRFZ0FG?=
 =?utf-8?B?RWxVMWlyOEJFU2VBS2NkcGJETDdyN2hjKzZCbDJ3eEtKMCtiSHg1Y3VPK3JP?=
 =?utf-8?B?bVIyYzVKdGhZQzVFUEU2YXNIV2l5anEvQjc4Zyt0Q0JQV3NMKzcrRGhDSnIr?=
 =?utf-8?B?eWExTWwzcWo3WDZNSTE5WFlDMUh3QjUxUkp1VnZjZlVLbDdzWmZIL2dpQ2Fn?=
 =?utf-8?B?VE1rOGJwcFZKZ3M4bjhEVnhDeFpxMldiV0wycjM3cGVhVERRQjc4MXJrUmkz?=
 =?utf-8?B?aCtwaHlVZTJ5dXNKazFtanhNWDF6Q0ptcjFFeVF2WnpiNjgrSUhIUHRDeFBz?=
 =?utf-8?B?T1lXN0FjNmpxSkkvRWV5Q3pyOVVEUG9YeTBkU21GeFhaR1o3NnRQSldQWkRn?=
 =?utf-8?B?T1dWNlV3eS9jUlkxRlpJdDk1ZUhqdGtoVkZhY1RBaE1IRExaTndyM093VDR0?=
 =?utf-8?B?U01raGFEWDFKYUZOL1d3TXJzV204K2p6d3cwOXVIbVJlT01lVjJHYytmaysv?=
 =?utf-8?B?YURFMmpIL0lKeXJVUlpOR09nemo2MEVjM2JFT2FJVStuczVwVmRPUjZQQXlY?=
 =?utf-8?B?UExiWWtBWTFWWWZaYkZESlJxRTdvd1ltNnk0Z3JCdUliRWxOUFc2RE0rNyty?=
 =?utf-8?B?YlRTeTZ6NWw4RHpyY1RHRXp0ZWN4em9TUis0NG1DUTNSak8rMU85YmZ5Q2lY?=
 =?utf-8?B?bGdUOUN6bUxqa2E4ODdQUlFGeUZWb3A3N2g4UldwUzRaTUR0eHRsUzQ3d0xy?=
 =?utf-8?B?TGd2TEttQUJtS1RYbzA3Sytad2tnOUMxUkJQVTN2N2NVTmpSaTVzb1MvZm9O?=
 =?utf-8?B?Y3RZLzA2R1RLY2lteG9mZEkrU1RyOUdmNVNxSlRhWk1TTkQ1UzZPYlNvNlEy?=
 =?utf-8?B?VDI5TTRJa0xqVUJkSFY0cjJUbVB0T2FLcnYyMTB2VjZYcU1qOVJqdklSWXlp?=
 =?utf-8?B?ZitIUFFSM1FaZ2E2SWtKRmk0djZ6ejFNSUkvKzRTUkw2VGhJdFhRYnNMdEVC?=
 =?utf-8?B?NXp6citxak5TalNJN3F6RDhQWWVkTW5pWExHR0s5N1gwb3FxbnN3RGFoWDAw?=
 =?utf-8?B?Yjk3MnZueG1hZEZMK2hQelRSRW8rdDZMSVdZbGJxWjNEL3FpZEI2bUVHWnpl?=
 =?utf-8?B?Sm9pbGtya1ZiTXdwMVh2aFVHRlRjSnBWOS95bVRzRW9BbVJpWVYwc0RVQTQ3?=
 =?utf-8?B?Rys1WlMzWGFKOUlVRmZXUnMwTnA0L2J4OXJUUXlISzdXNFp1cHVqb0xQUjhn?=
 =?utf-8?B?bHJVU1VGM0ErdFdWRnFlYmtsdnIvYVM4V3U4dWF0NUdZWmNVZXE3Y2hJZHVZ?=
 =?utf-8?Q?HPJ6WA+70M031EsBeNcB6LAnvX2MFQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:39:06.1236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7632fba1-fe91-4881-af50-08dd41b993e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7132

On Thu, 30 Jan 2025 14:59:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.75 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.75-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.75-rc1-g2c44b59139a8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
