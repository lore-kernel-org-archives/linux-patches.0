Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4211C5F3D
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738330640; cv=fail; b=QpC15/QT8qxJWuaYrVEb7jJk58tSGx4Y9sKDzoWmFQb4HuU3nTb5w6j1u+4KiDsnjyVfvm9REhY7Onr3Afco4NGcl9bgAr+P+22ewRfBpCW1Tc64cJAw9LSiiYajr5nbmDhhy6J83FTClPRyfNT4LUjsNSg4TG44yDgAT/JoyQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738330640; c=relaxed/simple;
	bh=mquDQ9G7LUc3Pi8d9FGVNXrlfJ+O3C8v9J2O7/9dDHU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DnXOCv3y4ucRXe/1CCjEZGue9K3dVZJ7R7gYxKzqmsMR9p18NKf9/zzVfzrq5mxX0x++FRXqfnbCIGf3oyxd3ekbcTxFlzjZ1b1t1tDnVJx8C333qtSrECDtsFRFXBrD98Gob2+2jqzPQL/R1miDdLUZqOhxSuRDGQNM9JyCfMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RA2hcts4; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RA2hcts4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahm9+W+gpjZ2KM2OedLT30M7a30ILMuaUMokaff3bRBe3LCCL7nKob2R0mmXEZ8gfmwvd3w03qqpNVZ1odxmT15cjndrxkq0v9BSxuLO4bNR3OjZHvkrdj8cvPpYtD9RAHebsAjJ7N2Rkk6mqoKosWJGM7ozqa4tTY35iC5PvpSxVu+HM3NMdCHUCwrahCn5y2wDBfZn7l42Yxfz60PCZAFqpL4Gk98DZfmPdxJehfOU4XKDuuQgaxKLqKbBhLAeMNGshF9ox3plNn9vDzZwJl4vIRXAF/v3LdzN9HpgZrI4pKuxvu545c6Cd1aBV0hjPo3m9yCKcRp/nNraePMEPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B74ohBKO7XAj6Ws/Z9K8qZwL2zryUvpYKVzem02jThk=;
 b=VXU9pqQZbmInwv/F5mHdrSgm8Vx1MRPXXckOTvG206se76lN9gufRCNcr8CE9iOzyD0keNUGu0vNVCERtY7Lq7qgQsipaiX7JnHyNHN/3zePfmNw1jIjBMh++eEHqNFB/dImhzwIL9RZFndG0y9yqI92UG+EDNEqe4FtQb+AJVYi6rY7ZUyhQJZ2VKTXaZ22sM4j8sq8C6o0OgxD7botY0zwaVMHA2wjECRa6A7TeHoKs3k+EdPlRU3JinBAtoS3gvKe6cOS1sv6RtCYq+MvfdHJAJ3hRSb3aRXNEA/w9useRdIl+z+sn1yblS+Wz5IcPtRyY1X9tt8Je1qqI9iEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B74ohBKO7XAj6Ws/Z9K8qZwL2zryUvpYKVzem02jThk=;
 b=RA2hcts4/1GnZNDalQbGSaT2EOG8nnH9U9QaKYs+IsjbL/F4SJMnrAaeMZ6EzqXvI7MnbFXL7/bC7xIc5NreagQMKYrc1EjRMeA8C/DwPkhPXxoC/0IHRmPKWnFuxylwloWpogfoPkdiikjcGxuZNAnNvsqtICzYkEgSap8Gp7tTZYqBmEgtJ2AjEUP6nWC6XmQmvyjU31kddHO5y95kuZrGuulXCY83PpmGd0iKeSSXVgNNCPYRT2okI3k+lE6vCEfAzuvOFFQVz5y+ykSOWTZeJLMO/XL/JjiKSLjXi+DMmqxPSRFUlEe8KWbhpFol32YCeW7qa80OHnj9zyJvEg==
Received: from MN2PR16CA0050.namprd16.prod.outlook.com (2603:10b6:208:234::19)
 by BL1PR12MB5945.namprd12.prod.outlook.com (2603:10b6:208:398::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.23; Fri, 31 Jan
 2025 13:37:09 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:234:cafe::ee) by MN2PR16CA0050.outlook.office365.com
 (2603:10b6:208:234::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Fri,
 31 Jan 2025 13:37:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 13:37:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 31 Jan
 2025 05:36:52 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 31 Jan
 2025 05:36:51 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 31 Jan 2025 05:36:51 -0800
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
Subject: Re: [PATCH 5.10 000/136] 5.10.234-rc2 review
In-Reply-To: <20250131112129.273288063@linuxfoundation.org>
References: <20250131112129.273288063@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5a302e59-50d1-4fe0-9707-32952a0c9255@rnnvmail202.nvidia.com>
Date: Fri, 31 Jan 2025 05:36:51 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|BL1PR12MB5945:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f1664b-58c2-4748-c07e-08dd41fc5c20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXRGbTYrRXFlQ1R1VmRJbE1yTkxzZStGaGpNMml4N3luUklFRHhRMUlvUDB2?=
 =?utf-8?B?OHlMSWQ2RXRxaEpqaTdaZzZDbE5MUmpDbVl5N2VxTm9Yd0E3R28xMTZ1WnpM?=
 =?utf-8?B?d1JxR001MDFVL2ZOeVpIdUswQW0vRi9EK1JST3VVOERZNzBnUDA4bnhHclBD?=
 =?utf-8?B?R3dndGprd3RHS0dZdlh0dG5jWWFiUVBKek5zbk5oWmxsZiswcUJBUWwzeGdm?=
 =?utf-8?B?NnBaMWFIZUZkK2ZkU3dBY3RvamtPSTdDME4xTUlQM3BySTIzQ28zeXZrdW1t?=
 =?utf-8?B?THdPUldJTm5SOUViaWlydmlSRXpoUXZkWkp6dk9XNmlLa1cwczA0L01qQzRo?=
 =?utf-8?B?VjI1RXRNUCtwSjlhdk0vM3FZNVBIYXgzSGV0REtRbTlpM2IzT3ByME5TVEVu?=
 =?utf-8?B?WVNHaHVNaXFZOGVOUCs3Vy9wbEltSWI1M29CVitiTWh1YWUxM0x6azNFdmFM?=
 =?utf-8?B?dlpwQnRaZ29zSkd5Y0F6MGsrSTdtU2Jmdnd5VWNTTllROHBXNXQySWVWVHZK?=
 =?utf-8?B?TGRnbHV3aUZueURIcHM2RGlPQnJMQzNwRWdsMFFwbHVIaENXL05TVDJlWVpE?=
 =?utf-8?B?OHptVlY5R0EybG80TS8rTE13L2gzZnE2Q3Zydkt0T0pxWEFSU0VyYXJZcGw5?=
 =?utf-8?B?aUJaQkFyS00xSG5nMnorVUFwM1ZGdld4ZnBCMXlzSXlLT3pnU21Fam8wUlcz?=
 =?utf-8?B?bC9xSFlPd3hMTGZZVDR2WjdGcFFxRmdwS2lwbWFOb2thU3VLUHJPN1NEU3lW?=
 =?utf-8?B?eXpnSllPdm8rVzdBNnZnbzNXNkp1YXNIL2JibHlPWWRwU1VuWWdlc2NWeEtI?=
 =?utf-8?B?RnFRQW1MM1BWYlR3RlB1NkNyVDVqS3BBQXN5dEF3a05wK09OVXdqN3dNZ0d3?=
 =?utf-8?B?ck5qSU1USHlLSGJRYzhnbnVVWWpzR3h4eGl3UmhncUhpNk5UWUFHWmg3UDBx?=
 =?utf-8?B?ZFNFcURKRStoSS8yYnpLR00yUWp0Rk9xa1FQOXBpTUlacFRTb0lpZ25RK05O?=
 =?utf-8?B?eWNIblNWTi9KVENRZCtHQUFHUHJlY2F6b0pNZTFNWnB0OXlIZ1lHNWxZajVV?=
 =?utf-8?B?OG5qZDdrbnVaOVFQb1RNMGZyUWtoTU5LR0hBa1R1Y2lYQkpZTWc2Y2U3Z1Vr?=
 =?utf-8?B?dDgxVTBJdlhRSXBoWHVITWRnWmdTbzd5dGg5OFlWdWVBSGd0TjJWb3VDamxD?=
 =?utf-8?B?NDR0bFZMRmNXSmY0REtORUZNbnFKdVd2S0wrdzFiTFNIWUZIR1hqRU4zb2li?=
 =?utf-8?B?eCszeWtXb2hoVndTdmF2U08ySkV3aFRkVjVqS0xCeStaYWZuV1JpeTUrSE4x?=
 =?utf-8?B?TFcyMVlxR3o5U3lqR1ZTc0thOEwxaitSK3laNDY4c0Q5MHFmQ1BiNVYyeUE2?=
 =?utf-8?B?bDY5YWVOWHEydjhFa1B4QTFTVkVDOGtuNGdVQ3ROWDBad0ZYV2x4dk9qZDNR?=
 =?utf-8?B?Tm5uMW93aEZVRFZJSDZ6V1dPaFVzaFoyTHRhcG43Mi9GUENMaWF3alhyYU5F?=
 =?utf-8?B?eC9MR1gyTFRXZUREUXQ0WjZTM2hGZC9WU25vbkhTT2h1N3lQM2dzTWVVMkFS?=
 =?utf-8?B?d1RqNzdSc0ErQVR2WlZLRTk4NDBiZjZWZEk4TmYxR2RoRjBvSXRhenNnMktN?=
 =?utf-8?B?dCtJdi9wNWgxVHhpL0dveDRCSlFuLy9vU2c3UlFNVTJUcEl6ZTMwdGhNd1VU?=
 =?utf-8?B?Q3JMOXc0Nk03ZnBuNnBQUWM3cUN3VG1ZOEFvMVA5ZW9yVlV1UVcyQTFDTmZx?=
 =?utf-8?B?bE1KZnJMMEZJbDVvZnBqVTBTMkcvZTBVZ2IxWG5CNG5MTDZYRVBsTnlmOHpX?=
 =?utf-8?B?WWpYbUFpMEFYMEc3d3ZEaTBCc29hbjdpMlFBT3ZqdHFZME1IN3g2VGg1Vmd4?=
 =?utf-8?B?VDdLMXR6Zzc4UzRwa056Z3FOY2JvYlBUMy9IME1ibnFzOTd3dHI0ai9UREpQ?=
 =?utf-8?B?cXlhbDltMFdyeitPYXVVUGtFcHNQN3R3V3R0ZGF3alFLQmh4c292QnJLUWFi?=
 =?utf-8?Q?tzCdJs07hX54RtMxQECKt2NtHSYO0w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 13:37:08.7661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f1664b-58c2-4748-c07e-08dd41fc5c20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5945

On Fri, 31 Jan 2025 12:21:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Feb 2025 11:21:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.234-rc2-g99689d3bdd98
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
