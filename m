Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66DA1B4145
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 10:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084225; cv=fail; b=of+Bw0kEd7cwwb/dB0DCGuov0SRjBNlk5NjBN0dmL314e89Y2xClkpKC1WXkYpthHujxZzbetok1tI1gx8+JdxfL4qxyQW+GDlTfbsARB7zMt47zdbJS0TebJiPNSiEIiRdE5pwLM2oUak7ItIO31dnvNjVy/i7+y0XydR5uTY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084225; c=relaxed/simple;
	bh=hgkkwSL/xJ+H2F5rkl3HEW7zgQgivj0SAVUFwHIeEng=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SLbuKNf95i663c6ansHHEISJQHrEUndepZFYbb4MlfWWqfggArzEDY4KEjlDc6lFFAiZJmlx81j61+2EaL8Lrf4Dspke7Wj2GjC0plQXPvWi8Q4J5wJnXhSfsPqY7Q9GUaREP+SylcoG0mgPI3fOaGEAPyMwOoXl4Nb5shiyzck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sMwyISL9; arc=fail smtp.client-ip=40.107.237.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sMwyISL9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRd5jHtYtaGeQezqd8R9Ygt2XZVdaQacc3fFObPzCXWfSZ4UroO0YsBgO34mSGJIcvKujpfs818Clkp6vxZXJfDSoXujt8hCmAClniVW1ZPFEuuEZeRG21HADtnNBiECMhIxEo2xaNaOqVq9kbyni5wb3D9GjtKwbwC4ZaimSIHcKtDoMaU428+1ItsqwgT/LI0FTNP5S/CinpGCbZh4QFcBbSCNXbyASK/6MEkNdCrRHTTLEIHB+8MywyQl8Ga3tbPEEeUDxbblNvaMumPM2kVehT8NejPvvAgneYgzOB8AjyQGZnkgfwZO27+w9TTncBL6HrQGwoiMrrO9B/pNOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcLa/p9M+nHZYA+ZVm6qwiLv98ObDn4uLzckuPSOghE=;
 b=xytNfqvZWlSDrz55vE0hejMq0iyS2rzOHGBkDhe71j8d1stvVRPH5gsN5WmLlFeNB1l4uImpGbjn6CeOwWV2IDqm0Nkimis3hT1sprbJHFSdTOk2xfD5Sy5jD9JrjuPrDLDks78lCf0Q2G2pASTerN+c0s4gZ8rmmPLr19gzu73bNfH03paG8wxdL0+dzsXJwr2ZPPgOCzICUTQsLZbFQkwvucD6K78Z2Z5GklLLI00MpsKkPU42gk9ankopAmIh5LXkb61ho7wwdO7jEUsSMZJCFyTeE9wT6WIUltrUsP5VI7P8F8gnSoS/0tep5FtLnyv8DKvYJMPWn3/C733z/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcLa/p9M+nHZYA+ZVm6qwiLv98ObDn4uLzckuPSOghE=;
 b=sMwyISL9vy5E2+xoEsAznyd5NbuTpN5knwLCzykuq3D6WHNNHn8fBpXTjPv8/Az597nDupdfbVAa5t+n6aLw8zsFd12KIKsCTft0PUhjpU15T0s1vQQffYJNgd8JjturVMp18NjtkxxYMkKaxQojrzFh70V4Uv72FS5Lyqs7qeNg0R2qL2K2JkPAikr2Grn8CfCLCffOW4LhnMPm18rrpO2KU8te0boQw4SD3ftMtQOd6lySuqfvZ1Oh/YxT6ipcNy7mc/al4OVaGppI8EZRvOAFhIy2TUiXoXeIM9NmlGlSeOQksidzt2g+fYKqJ9X+sDWfK0Rc0Kv5JFzD6fQP/A==
Received: from CH0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:610:b3::26)
 by LV8PR12MB9358.namprd12.prod.outlook.com (2603:10b6:408:201::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 10:03:38 +0000
Received: from CH2PEPF0000013F.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::3d) by CH0PR03CA0051.outlook.office365.com
 (2603:10b6:610:b3::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.21 via Frontend Transport; Fri,
 13 Dec 2024 10:03:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013F.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Fri, 13 Dec 2024 10:03:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 02:03:25 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 02:03:25 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 13 Dec 2024 02:03:24 -0800
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
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4d7673af-8dd5-4b3c-88c3-71140aa20ff0@rnnvmail202.nvidia.com>
Date: Fri, 13 Dec 2024 02:03:24 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013F:EE_|LV8PR12MB9358:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f90b701-de06-4f3f-5530-08dd1b5d6a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anlDamxFRG5VMm9hUnIvSkF1dlhxaSs4dHNQVFpjY2ZMZTdKNE5nM2MxWjBI?=
 =?utf-8?B?K3UyNER5OW5BaTNxZ3l4eVZFMlRVbVRVWVBqREZxa21xM1k0dFdjRDc1eXNV?=
 =?utf-8?B?VXdZZ0xxSU43UVhoZFRpaHFDNWRWb250RHhxMkpVMXVyMUhGNFVGNFFUSWJ0?=
 =?utf-8?B?N3V4OEdEUG40S00xYVcyZzFyeWk4MFlkTUMwUVJzZHJQZXh2NkRZRGRlZTk0?=
 =?utf-8?B?Vk9PRW93Q0NiamhkL3U4ckVlM0hia2tUeU5LMmQ0Z0tDVkNLVC9Rd21HcG10?=
 =?utf-8?B?aUxSNWF3K0UwaW9KY3hEN05NSTRPZERkYUk5RW5KdFhJNXVjUkI2bms5Y3V1?=
 =?utf-8?B?SHBsRkl4WU5XS29aNWlwN2ZUWGRCWXdMN2pKTTNrdnRkcDlCdWhhdTFQdG93?=
 =?utf-8?B?QS9jZ3Zod0dORC9LZ3IyNzZpZW9hN25EQlZqQlIxcXRRVk44Mk1IalB3RWxJ?=
 =?utf-8?B?d2dNQUE2dlY1YTQzRU45VkF6UnUxZ3dLWThRNUs0ejdPUUNOMHViNFhlbTRX?=
 =?utf-8?B?TTRkeFBhTmxJQUcrTlRPcDdGRmJTM3ppUXd4aVJhc1krRVpMcVlmRUc3dkxU?=
 =?utf-8?B?WjR3d1ZMRWM3dk02NXlsLzhJNk9CcWxuWFlOcHhTbTlxdjdodk81OTlhK1RB?=
 =?utf-8?B?RkI1bTJYTmtCYm1YczFRUjJGNGxpejVzZUJiMkU2NURLOWphcVBYTWhROFR2?=
 =?utf-8?B?ZGlVRFozSUJacGpaZE9kNXBDQ1Jwczg1TjY3NlRqR0xzcUJRRVlIRStVYlZx?=
 =?utf-8?B?NkwwTG9GK015TWhFamV5a25jVjl0NVdVTzZxeHV1OEUreFB4dEdCbGd2Rlh6?=
 =?utf-8?B?MUlnNW05d1VlYmJUT0tTeHphREpKaHVRdXZxelZKRHpmalUrbHY2UitKRWhX?=
 =?utf-8?B?YTdNMkl1SkdyalhIcmZTSU5QbWtZN0xPRmVTdWV2Z1lnb1pXcWJxQkpleXVp?=
 =?utf-8?B?YXJJZEdaaExWMmJCcDNrK01wcWMydm9JaTJQRm1jTVdVVnFlcVdMUDRxeWpI?=
 =?utf-8?B?N0VZZFJ0WDFwc0V4ZzJld1JmSGNqc3BwQkhZa3JhUFIyNllDL3NONkp3ZVhQ?=
 =?utf-8?B?azFzaHVVTzJiYk84ZnQweDIwMVNKb3A4cUFZaWhKOXRQNi9kS29MczRCVWFX?=
 =?utf-8?B?MTZjbHV5K1E5SE1sZjBDcjEydUV0NDBCeEtyRlVXMnFaaFlyRUZiZzNpVytz?=
 =?utf-8?B?NE5EdTJNbTA3YUsvZEhGVTkzV05ONlVNejlySGI2Q2doaVptNmsrcDVJQnRN?=
 =?utf-8?B?WWxQUy9ZOHFLTlkrbkdsR2llWkZDM0dKMGF1cFUzVGw2dnljaFZMVnp5Y2lQ?=
 =?utf-8?B?TzhvcWJlQ3lad3VxSi8yMW1QTTgwTXNzRnB4QWZnN3czZkdtQzdsVkh1Q3R1?=
 =?utf-8?B?UW83Y0E4YktPZGJ4QjRObGpwOFI0MDBGejI0aEJlSC9nTDIrem9uUit4WTJH?=
 =?utf-8?B?SWlkdk05MWlQUUJZZUpvSlNlMTRVUWRoVlhLbEpLRkRjSGFWenJDU1Fhdktm?=
 =?utf-8?B?a0ZsMXpwamV5dE5TN3hSZG44Q2U4U1FneU1VQ2lDV1NJd3p1MEs0NkJUdlFt?=
 =?utf-8?B?a3ZYM05SeWNTaTYzOGxiaW9rWlVHMm4waVhtUWdNUE84L1VBVzQ1UUpBMzRF?=
 =?utf-8?B?RFRVY013MUNOSGgrb0RBS0k2Myt6RXM2cndPQ2lDUFJ4eXk3U0E5aHpPRnl5?=
 =?utf-8?B?bFBjL09WVll0RGlRZGpja1dFQWx4YUxSMkNoQ3JBT2hyUk1aVEVZUVZITjJY?=
 =?utf-8?B?MnJwV2IzelRsY1JSSjRzRlA0S0M4R2htVmdqZ01WREhNNThkRDJjTVN1OWVI?=
 =?utf-8?B?Wk5ONHNrZHJ4eEd6NW96eExtcllmai9SNXUwQnVLcEhxdVFBaTRwbC9xUVpw?=
 =?utf-8?B?TjZVUVFUVDJacWc5Z3VZZmlaWjAzODV5ZVpvNE5KcWp6WmY1SkczTGlESmg1?=
 =?utf-8?B?TGpuK3Z1Q3V1R1pGQWZCQUdkckNEQmg2YXZsWDJaVHN0OEVEK0h4bUxETXYz?=
 =?utf-8?Q?En+Fcs9cwz+jRm5YcbmbVgGciryC9I=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 10:03:38.3269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f90b701-de06-4f3f-5530-08dd1b5d6a40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9358

On Thu, 12 Dec 2024 15:49:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
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

Linux version:	6.1.120-rc1-g9f320894b9c2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
