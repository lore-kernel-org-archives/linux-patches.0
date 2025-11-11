Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664433AD85
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867933; cv=fail; b=OQ1EzYrniOaerFowa8yKjKEiG7GhSYwqFml4RXhb+KaxgVW302gQzi3BIqLwsRkmBkLG9FsmGvYXns98IU6BDFGtfm0eyB2uq9XFlnuFroiOAOvqWmNejSjoFfv0Lt5oZbz/0g91Cc9xoxKKvikc77LVAjHeXcZp90KsrZ22dRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867933; c=relaxed/simple;
	bh=lQ2NBtIoBo6C62YihVDcneucqwjPVO4Js599XSGK1as=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lsyOEWFMgab46G9+bqtvzMVAg5Qu3xR+519csIBL7ct4ExRUv3qQXnGraYfxWJoug93PsgHHr1WZYZxytNk4C54IsZg3lFJGPsG30pAbTIc8/MMf8+koqGc2KCuXLmD6OHYqceseJY3fEtSY8cZmPE3LwdYkFaRE+yXEcnZpv+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OboYiWRd; arc=fail smtp.client-ip=40.107.209.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OboYiWRd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTSG22cSYxv0/PK55/42CaTHDEGMVZI0V1xN6eiCIj4PiOhmdOQSLlNQsPvO7HS7RvjjkeporaBdDsssOYNiwwPkfHN+mKpL0HyhFfINyl0BIYPkM0ZQ1D4eoT0bQD6qFC8fZMH7NBgtUGPfkvAPZnkxhq8Stg1cV7pOzY+NPFPmng6iuqb7YyQtXXiLzEA1VkBgvr14Xh5jXq/Lr+9FTwp4ZSQ91bUlbSsacu4MvAmut53nhbvGsN8ttVdKJrQLQKnX9IzUlmXxJXmo3Ae4Hq3UEfXFFmDCfmjBFPtbVdjyfp+F5c7Vvn2OEsmC/sK/l+paUz/tKB7GNGrdEim+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkXAmQ8ZzgNpFGoKXMJhRrNgqEwr541sIAyRUNfvALY=;
 b=IzSBBY0amq0q8CGiZ50FsmrG65FvTQHDDUQgt+fgOveK/DSBGKWBw/Gs0OYw1Qecwrn5umwH7v4Vncycg8OqiCAAmL+f2Szd0Qxe+uEEB61wRSXYXKjn3eN75EoMHv/mNJ3eHgrl40I6Il5xJJnzNXMI4YXYAmF1jzD+oYubcXKZpxLfG2Jb6mO9zUEyul7JhfwrUz3C2V+qAllhrZ6vtGXvEVwL7u70UVyEh4exJFu0ozkxHA5RocHEzB3P2R8D5cm4ev67eHkPY1OniebUTuLsjAbGsnM7C3ApYM5aMPK21FfDg0vZunTWeuThxs5Aetc23LNaqg/W9SN7Geouuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkXAmQ8ZzgNpFGoKXMJhRrNgqEwr541sIAyRUNfvALY=;
 b=OboYiWRdc194d2xE7SYagm/94l4UZNOsNriqcWOZqYDNHS5hj2gRVvtmuFUsJg8/2xYzOyMXq3+6CwTN7EqJbJV+dcloN8BZz6V77OIDbDP4pscDzN1Zu2fHDx4py+7+T2xi4WtAxPfvOpKucBQ6WLWnuylNFtZkep1g0XpK6GlWuBnGGZGtErjTC8CUdihmpTlIRiYI2BAX4i/vPcDAIzrK19x/yXajlEQywVhKoQK/N8XZQ05Q8Hc0cb1mhEE4Z74nBbPibsaZZ+w/CzSIOTFUsLI8nPQNLdApAEw3jglGA+R6ErropUQjrxkvv/nSnI4BqeDX90DEfdAHAqLlYA==
Received: from BN9PR03CA0681.namprd03.prod.outlook.com (2603:10b6:408:10e::26)
 by LV8PR12MB9271.namprd12.prod.outlook.com (2603:10b6:408:1ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 13:32:06 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:408:10e:cafe::c6) by BN9PR03CA0681.outlook.office365.com
 (2603:10b6:408:10e::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 13:32:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.0 via Frontend Transport; Tue, 11 Nov 2025 13:32:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:31:47 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:31:46 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:31:46 -0800
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
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
References: <20251111012348.571643096@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b662c7c7-b4e0-49d1-91b4-8a336ebde9a2@rnnvmail202.nvidia.com>
Date: Tue, 11 Nov 2025 05:31:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|LV8PR12MB9271:EE_
X-MS-Office365-Filtering-Correlation-Id: 392f0208-4d66-4ac6-2e86-08de2126b4e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFRmdW5ENklRQVRFRlpPdVVFN1ROL3lKSmlzV1plb1dCUUgvclNFeVAxT1Jj?=
 =?utf-8?B?dDVvV2JMaVQ1TlpCYzJkN2ZCMG1McjdLZm1MN2ZkNjZUaEtIaFlUNmhOOVha?=
 =?utf-8?B?Z0NKZld1KzBPTFVKMzhWN0hkWnpJUGZCWkk3WkVBWHVRbjVSMS9PL09VZ0hJ?=
 =?utf-8?B?anhIZXBkQ1NWYlZZRUl5dnhhSjg5WFVrWW5sSU1WZG9nWTcrSy9GUFd3VGtK?=
 =?utf-8?B?VDE1bWFPa0VHQkt0aFlrcHZNQWJKVW1ZUWRnOVdTY25kMkU5OGpCYnh2bUN5?=
 =?utf-8?B?OCtwYVRIdVlHaUYwV3ZsT1ErSHY5QVF6enBEQ1BBRG9VOWdtK3UzMVpiS1BX?=
 =?utf-8?B?cnVUWHl6UjJUM3RNa0h6OVA2OTJWQmN5Z0FaZFF5VERRVTM5NHN2aERxS2V3?=
 =?utf-8?B?S0RjNDQreFByeTI0aU03ZEtwMDR1clJVUndua3JVZ20wYWpITTFRTDFHUGtl?=
 =?utf-8?B?QWpPVUErNGhWUHlqLzhLdWd5M0kyMHpJWE9PaGFZeG9vdzZoRCs3cEJOcWx1?=
 =?utf-8?B?blRtdDVjSm0ybjE5OGwxQ2x6YWI0SElRZFZ3QkJSOFUwTUJvdSt5MmZQdkJi?=
 =?utf-8?B?QVlOUTl4ZVZGUmZqQVZsUC8zcjdZUkdzZ2xOS1FSa2hoWS9WcHFvTmxpalpE?=
 =?utf-8?B?bHRrKzJTbmlHK2FxSkJiZGNXTTllaDMycmgyVkwzZnZyUkViaXFOaEpCYzRv?=
 =?utf-8?B?SHlJU1poWXVFbVU0UXd3blh0UHl3ZE5lQTNUS1BPVU9lU25qVVo4NU02aXhv?=
 =?utf-8?B?cndxbi9qZDhLSTZodDBJOXNSeWp6d2pWYXZkbTZzdmJaQ1BGcjJkSWVnendI?=
 =?utf-8?B?YlluQm9rUlFTNGZRWU5yNVE2K3I5TjQ0QTFsNU9WL2xheFgzVmtCazFUOEty?=
 =?utf-8?B?a2xkKzdsS2JGQ0RzZlFta3pScE95WGFZOGtGTldqcXgxa080M055eERYdGJy?=
 =?utf-8?B?ckRoRUU2dDIwWmljVVhZc2tNOFRVUURsN1RPbmZkMkEyUTJFaG9kQUpleWkx?=
 =?utf-8?B?WlBMVjErbnhuK2F4VjV1MkNncS9nTUIrM1hrRGhFc283REpYdUtTb052Q1ZX?=
 =?utf-8?B?ejAzTGpYTUhwUHZUeC9hdnROQ1pQZWJOSmNkczhJWGk4RnNEWDFSaXNHbFdT?=
 =?utf-8?B?clp2L0VGWG5KSjFyeTkwektmS0dvb3hDOGc0aFNoYm9uM1A2NlIwRmp2RTlP?=
 =?utf-8?B?NzhiRk8zOHlUZUIzYjRaS3RZQkprSk5vTmRzWFFjZ21BYmQvV0VEUUhBN0Vl?=
 =?utf-8?B?ak05ZDZDOS90b0w0TG94T0ovMEhxc0xtMVpDOXFSWTBUQ0lLTXdHVHorSlhQ?=
 =?utf-8?B?MUV5eWhZb2wwUVRqZnIrQzNkWTFsT0xPdzBDcHNBQkVMMUxCc2sweGV4UWl4?=
 =?utf-8?B?VTgwd21tUkJpNXVWZ1dCQXpIcWZEbXo2aWpYTHRYTmJxMjNOUkdwOENteE9Y?=
 =?utf-8?B?U0lUWVltN3VVSHpacmJmVG93UnlCRHp0dVhrS0luTHptVC9VRVc0c1dYdXBF?=
 =?utf-8?B?azlZUkt0UGpFT1R1dG1NcGhUUEp3OHY3U0VRVXl0cGIyM2kwL1U2bERGWGdp?=
 =?utf-8?B?ZWw4MkM4a0hNR2dDZzZmMXdCdnRoUitmdzlTMlBHNTEwMVJMUnlwVUcvWHd1?=
 =?utf-8?B?UCtrdzl1bmk2UVd0eGN6NGt3WlYvK1BXVU43UVdMTHVRZHpqYm5KRmF5aHRT?=
 =?utf-8?B?L0lJcjRycVo1KzBDTEkzVTIxUTdlMnBlSitRRm12UDVZc1JocXZhbHA1c2pO?=
 =?utf-8?B?OGhRRlp2VXpGNWc1YlIwbWpwRXJ4a0Q4Vmg2eUthMXAvVTdCeWt6V2VJQzk5?=
 =?utf-8?B?MU1wVFRCcWhKblBBREg5bWF1b0xyNEdmRzB6N3pVc2lmQU93NWFKUGVuUk9Q?=
 =?utf-8?B?ZkN6b0hzZmRlZFRJZUIzVXA5QmdKV2gxQkhCUEpvaVc1WUh4QWczTGZHUVll?=
 =?utf-8?B?MElLNmFFYVFHS2Njeks1MXNka1JPTUh2dmk5M1R6U2FZU3F5ZEpPdGRXbytw?=
 =?utf-8?B?WTdTVFdtZWhKVjNnWXdaZi9ReEZaUzJ1QjJqYUw3d0NWcnlvS1ozY01CbHg5?=
 =?utf-8?B?SzJDbDVmN0l4aEV4Nzlja3ltaFFhejlxMHpXc2ZoaXNmVFhlVzJ1RjlZdS82?=
 =?utf-8?Q?VfAQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 13:32:05.8614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 392f0208-4d66-4ac6-2e86-08de2126b4e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9271

On Tue, 11 Nov 2025 10:24:49 +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.58-rc2.gz
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

Linux version:	6.12.58-rc2-ge6b517276bf6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
