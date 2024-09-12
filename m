Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAC618BC1C
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125583; cv=fail; b=LjfxAiRrPGObrD+8b1wfEvD/ZLA9Xzpq0T3pPMfSuYyV0V7kd7zvaT8ChXYVxXAygW5KQ3odwX57Ga/w9PjuH2I5e68QJBMiGRrHMLHHGURIvbTS1Rw364hE9qeiLZRbO98Mple0UPnLF3qnUhuYmvI0tL/9GAbKsag4lhB7K1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125583; c=relaxed/simple;
	bh=CdVhtVvDkVJGYn4zuL6SbHH4GF5WK3hOGziyjlolhNM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=K0e1uFWDJYENNLNf7BYbXcMgTvoBmhFCK680guE1EptgyvSbwB0diPkcQtYJtZ5RBAkomK938HePifcBCSeGdvdHob6xSgAjQKsXTlk+B09o7CenlDaH3nU6yQEdxC1S3NMuubF/x3rPUZSg9Bux3ro9uMfCX+tjKFYYdvV2ZQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HIab8MCt; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HIab8MCt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5u5IYacD3kFoUVYp+uQtqBeBtQYvZY3KDza3ULHVxqK93ulg0qHxzaUfK5KmHNWinKZ+/USEixJV1AoxB789WU2xuMakCUpsK9nMhuhDf3v5eIZkl503yhBcj3FZV0wEUV041LV0ToeULY+MRE/SoqSxEpCILUENOF40AQHiU7FPCLuHJISlxR28cInkFtcj3gxaiiuJ9Vuuma7hX/0tOWO/MF7J4LCfeQRp13jR915rlVi/H9T0CSSPh4jrXacII4URFuylTaWRPap5zmGn5qa4lm/wwBtKRE4KM6GcVF7Qk6ZQtN8P4wXMzAicO+EaMuaQvrVz5Mxu/7weSFyfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCJESE6XzD4TxU+Uz/0qqakXwcuDXcSL7QRoBH95H1k=;
 b=UV/Tqcx6cTYrPHV+gN4nd8fl+DANjcgKUeNC/V8jD8oHP26oNZ8G4dE6u5yxaOr4ALP5ST9mAZtdeSWal692fOfVgrP6j45NRSEhdfoliD9UDJoUVm7rYoLJI+30Am7w1BsR2XFWcWGvgRJ04DBRRYO/0eKhmIKcpqmDS7adx0m0alsAV+tr56FMs0xaxPFw8tPlhYvlZIkkI3eo47bI5h9nfe2TCf0bByxTx1QB1LxDyxEmojkCJ2/phnj9jX+sC+L9W8fL8azPoNmKf5M4kbp2iI+71clxsPsC3c9fUlI2JyXOdItVjKqk7wSB3pnjJzvCwMw9sM4QBaNDgnIJ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCJESE6XzD4TxU+Uz/0qqakXwcuDXcSL7QRoBH95H1k=;
 b=HIab8MCtHU6V3B6asghEyrjvCDR1kguhKTskPDqT2WCPuXrXl6MmpJEO8L0xH7amzsx5MysxN37FkMNHBqtaL1hr2/jWwXGgw+X19Du3Xm8KgjmXIvxGzsD851jDDu1Y/+VMfmNcqKsYWnF6MvonrHJ//w02WSZ6ZOWYpXG6rit+xWSPysmDOsnDUk5VbfWje0O4lmwH9evKCMabnsrdvr0BOGg5HUrF+gcsu7lJSRFnBITjwEzZ6Hq19oU2HzeBU2NwObyNjNhhBTpT7ndl7hKXmdWMVpvH51b6K5gl8f8Px/Rm6kz4lvk60aX05iNBnsD7KwMZCuPckO7fWEqy9w==
Received: from SN7PR18CA0019.namprd18.prod.outlook.com (2603:10b6:806:f3::30)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 07:19:33 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:f3:cafe::b7) by SN7PR18CA0019.outlook.office365.com
 (2603:10b6:806:f3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Thu, 12 Sep 2024 07:19:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:19:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:19:23 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:19:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:19:22 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/186] 6.1.110-rc2 review
In-Reply-To: <20240911130536.697107864@linuxfoundation.org>
References: <20240911130536.697107864@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bcb4019a-8062-420d-9523-fac3f93d0dad@rnnvmail203.nvidia.com>
Date: Thu, 12 Sep 2024 00:19:22 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b8bb6b-eb19-4d71-6ed8-08dcd2fb3eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTZ6cXRTZnZKampnK2ZLNWthN2VGYjk0QUtQdXVZckVWcDNBT1VncExxNVlU?=
 =?utf-8?B?OFZJTjB3MUZJYU9NYlpmMFNkNEhJWWIzWnZ2TVloaFJqTmJxRVVVWDhSbWRv?=
 =?utf-8?B?cHVWa2JuVWhjaGgxT2ZyWGdjVmdYekdGd3V2UUZ6cTNVa3ovSjY2YjlEZmY1?=
 =?utf-8?B?SmpHanBGZjgwRWNvdURwU1dqZVlyeHVmb0JGTktCMFdRdzIyaHR0Q01BeHow?=
 =?utf-8?B?OEdrei9uTC9CMmlrbkFzYlFlbUh2V0t0SnFiQy9saDRnNnhZWnRFeTBhV3FO?=
 =?utf-8?B?M2ozdSsxY05WaTlHL25XY01ja2lOL0EyMnhEWlJWMlB4b0xMa1ZLYWJndE9o?=
 =?utf-8?B?S0JzdGRVWHZsTXZHcW14dHFWTWhKbDdLNkVUd0haY1Iva0JaRnlUWFFOKzVY?=
 =?utf-8?B?K1NyZ0JLZWhMVnJSMlB1emcvM1llR1E3ODhxTEJDbXNFYnIvclkxYUtuelJC?=
 =?utf-8?B?M2tvT1dMUVVKTjBCZDFLMjFhZFpWa0QweTkwY2I2TC9NYWlZSmttWGxCZklB?=
 =?utf-8?B?SklxOWVHY004Vis0ZTBPaW51SUJsQkdhd2htYThFVHhhQS93Z1o3K2owZG1L?=
 =?utf-8?B?bHR2Yk92eTEreWlaU1hONTBJUFRTb3hyeUxEa0hwajRIZ1dYMFRqd244V3Vm?=
 =?utf-8?B?K1pKS29oS1U1RmpERXdpdzNCZ2s4WEJrdlpaLzlPNnA1cFFSUlJmWHhOQ1VU?=
 =?utf-8?B?dEhRMmtXa0t0ZitsWkswdHVDbXFic3dkRWdWTHpQenJEcytGYlJPUkQ3YjNu?=
 =?utf-8?B?OU9mcVRiakF3NlhZSGszOEJPS0RXYW9DU0xsKzJJOWg1RE8yWnpxb1lFV2J4?=
 =?utf-8?B?V2hmMTR1N3VFU3d6MzdNZnpwcmprcm1iWmxvRFRPRk11aVR5UUVEMldPa280?=
 =?utf-8?B?UE9NQmd5elJNZFRqakRiU2dBaFFqMzRHM0dwUHJPbmRhY2E0M1dlRXYyYWk5?=
 =?utf-8?B?am50MHhGdndaNUk2MERYaU1pbEU5eHZDNEx0dm1tU0NieVk5aWQzVlp4WXVJ?=
 =?utf-8?B?YzQ4bDhHZzZOSnpDdm5WTHBqaUY5a2NGa1dva0NXenR5NUZ0bVJmbE1oSWlx?=
 =?utf-8?B?YzVFaFMxQ1VJUHVRT2tJNy94ZGZvNW5ueStjb3hzcEM0TTVvL1dKWnN5STh2?=
 =?utf-8?B?MU54UjlMRjJoR1RCUE1mOHlpR2xWWk1iWG5GQTJCcFNGb0haMXR3S3A0WGlm?=
 =?utf-8?B?Rlo5MFd6b25sNkxMRlAzVVBjUU1CbEJCVmkwZXlJTmMzYm9GdU5RYzJLaTJl?=
 =?utf-8?B?bEt0UE1ZRWRHOUJaQXhKR25BMHRnQncyb0sxQkZoai9LZzV0RVo5TlU1LzYv?=
 =?utf-8?B?ZGJUeFNRbVBkYnY3MEd4SGU2bGdnTTdla0h3emVzT1hrSkY4eDJyU250MkEy?=
 =?utf-8?B?T3ZPNUlwTXFRNWQ5UXg5Tm1jcldrTUpmTzU5eDZaN3dhYmNwd1pEam1GY21V?=
 =?utf-8?B?aWJPN1lFWW92SHczOXVuUGpPUjk2dm9zRTVvTVNVQW9Xb0pkcGZLKzV0VG1U?=
 =?utf-8?B?bHY5ZFc3OHBXYVIxNjVoalNQdzR3U1IzT0VlNE12N1pMTDZVek9PN2F4eGR2?=
 =?utf-8?B?NWFGUlcyRGowR1NGb1dydDFWVFZNVEdGUEMwbC8xY0Vqa0NkbzQ1LzRURFF3?=
 =?utf-8?B?allvRlBReVlEOWZ4WHlneFFxRlkvUGtYQnNyZ2FxQjBsZHVHazJMS1hXMHow?=
 =?utf-8?B?azQ5Qm5MVm54NHZydTBpQkoxQlFLRHlYQjYzN2lGTXFBRmp5K2ZOZVFnVjBH?=
 =?utf-8?B?eUNsdFlzWGlnRy8wZEhlTmdSYjFKOW5XSmkxWFdiVmxhL0x0UzU4ZG9WdU9V?=
 =?utf-8?B?dEQ1Uy9hbGJKMkhNUFVpVW5nNHZ2b1Z2V1QveUNwVW93bUVUd1RiNWFJRVlG?=
 =?utf-8?B?YWVUWTAzT1lLTFhlMEJtOFQwdWE1bi92MDZySmNPc3VjVE8yaGZIaUdwcWxh?=
 =?utf-8?Q?0tM6MqgjKEkkHp1TpnYyZtKD6bNuiYgW?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:19:30.9285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b8bb6b-eb19-4d71-6ed8-08dcd2fb3eb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139

On Wed, 11 Sep 2024 15:07:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.110 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc2.gz
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

Linux version:	6.1.110-rc2-gb844a80a36a1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
