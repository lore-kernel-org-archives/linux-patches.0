Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12C316B751
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384619; cv=fail; b=DBLMFSK9Gt5+Ala/v/b6eaUbtQ8MVItuYs4li9yJfJfG89SoPx+V2wtdhfCbGD7Jf/HyDqDPpsGvmfKU1kdRhULcISGVnagGfvq5t1kiToKHaT/lgTY0/WdPoW9AOqj3mF2YcA2cnmeULNJcz9jEVleTiQS5L52xLY4r31d1sNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384619; c=relaxed/simple;
	bh=3QQxPXUzhM2jOIUaqQg7LuoudaoAEkUINXZieDDiEBI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GCHIy6Y0qBX0rMNZpDne5Qq8ESHZXePmEIhPEL1mUcl6ilPOCja8fKum+CO0LGeVQEbViohbuug+/tjB2dCREofN/uPP08mFCSlMOaeFh9s6iT7SdDIrEs+VigHyOmtciZt2R3sSdajciDvkJUZMrdqKqVD7XFHu57sPArsZf8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=soxhMDok; arc=fail smtp.client-ip=40.107.95.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="soxhMDok"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDhZeZub/52wzE1bfqiezyIfwRTME/8OuCg2rRwHyoFQNs+6NaCv/KC43XW5wY5DvASGXzft5U0BUGoLDLwxK83oqSgXJHIA7ncQut7OIOLSqNwlFqhyMqrvK6ECuUNUg9c1dHH2nQPQM7mKzNKCJ5WLXzz68oKaOxa+xfQPyjBpIgUao+90RrFuY691fDB7fcyw+9eFDXK5wK2BQSa6wQdhjWsJ2hrC4CKkcCVX6n5e+y8oH0ua77GHTP6QrxCGhTxulsaBLV6VSRjm+C5ukyEXYQJb1yGBYLI4RPcrt9dWRHvqwW3HknW11LNOQKu/39nepxicdmekPMhypqQ3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSskJUi+tyXoAYpwfyRjKS3vnSzaA3OJvKZiTkOUxgA=;
 b=WrHqUx2V5kMV2kpPkkooYdW9gsJaZve3f6EtH3h8yww726jNv3s8jA1tnqSk/kQvVSvWpktnSJuU3tQDrXX3X3UFrAKX70pRPCKNyKa9XE09VRbGKP3ZEe/UQQ+FDMCHqaVPqHOH792hPhqWpDR07NiKEGVjBSxaiQVSjig3RxupFR8eXcNkBuzrdkTHQeIDlntAgVm1XVAWMqC+O6Mm7CKzWaZYtyDH8jJdb9TR3cDungml66IZEVlIBdqSMBN3fJiVt1m3zNsOnBUDE855eUaRHIF+G9mlzwMEnWIY7d8/83inczTqntjzz5YiNZEppEbp4BdHT+560+rGeHdtkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSskJUi+tyXoAYpwfyRjKS3vnSzaA3OJvKZiTkOUxgA=;
 b=soxhMDokxT2Ac5NNe1sSnczSCNr70Cf0roMq4eU9O8uqkDMLOd5X7w7ODhB/h9iJkYQoDIQktSMUyqJ/UOu0dIjgnFEYrWBKaUy5LeebqKunvGi9kOVZ3wgAwxL47Ej8BLe97ME3oIvXqGgYubF2YSHb37jKNXF5uqbFMXTaoCC5ltWK6ADW95uZDdymROoW0Y1cqxMED8zEdC1MrRPerZrZY6jk4rGR7PVfnMBvaWdhnChbdhcCAspo9pyGh4/OUx6mKggv1VtSDeZopRqMuYvVVHsH/IURayWrMCS6TG+MspqbJX8ybXGyvtoRhfwZwFNIxO1IlB1KK3reRl6CsQ==
Received: from BN9PR03CA0925.namprd03.prod.outlook.com (2603:10b6:408:107::30)
 by CH0PR12MB8464.namprd12.prod.outlook.com (2603:10b6:610:184::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.26; Fri, 14 Jun
 2024 17:03:31 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:107:cafe::2) by BN9PR03CA0925.outlook.office365.com
 (2603:10b6:408:107::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.26 via Frontend
 Transport; Fri, 14 Jun 2024 17:03:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:03:31 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:10 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:03:10 -0700
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
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b5266440-41e5-4036-a72c-d0a5a8cbd583@rnnvmail201.nvidia.com>
Date: Fri, 14 Jun 2024 10:03:10 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|CH0PR12MB8464:EE_
X-MS-Office365-Filtering-Correlation-Id: 439ef102-cbfc-461e-bba9-08dc8c93eb32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG16VndiNmw1U3dEbStxOFBGOGsvMng2QUZtN09USHFEWnR2RTFubXJDY29G?=
 =?utf-8?B?VzZ6Uk1pMUJ5NElUaHZXdmg1eHkyKy9TUkQzTEJMZ0ZPaVVvYmwzVWFxcWJ1?=
 =?utf-8?B?S1liVElQUHpOUnh1Tmp1OEFha2E2UlJzek1HSm4zZjhiVjVSZFA2c04yVDlo?=
 =?utf-8?B?N2FBTS9JY2dWVjkzdGhkeDdnSW1nWW9oNWxrZm13OGNIV2VPKzlhWTV4VWRW?=
 =?utf-8?B?T2txWDRCWWZKclhQU1RTS3dIN2JFK3hIWnh6V3dZVEk2Tjl4T2wycVBPTnBw?=
 =?utf-8?B?aEk1V2dqbWxMOW9FWlNUWHFoYUxid1lkbXVjUDlscDVZL04rcjZRdVNWai9C?=
 =?utf-8?B?ZWhTZ1JpRnBlZzdwNVlwbnhlaFVmdUd4NFlUZ1R3ckVOQ01Mb0lWaEJGSk5q?=
 =?utf-8?B?SkswUnNXSWE2MVJlY1FZSFJ0b3VKTGxrd21oa0NISGM3K0Y1d01wb1lZbFhK?=
 =?utf-8?B?a0s3a2VmY2J2NkkwcFk5ZXBQWmkyWGc2Rm45QjNMakFvbklMUTBmQlE3RVc1?=
 =?utf-8?B?cWxZTXp1SWorcmxad011VTBsZUNFcHhuN2g2L3ZmODR2cEVoME40TmJ1bHlV?=
 =?utf-8?B?aERFVFN6cTRyWkIrVFN0cnU0amkxdjJ0NGhrdGc0NitxU0R3a1JzTU5kYlNK?=
 =?utf-8?B?eldYcmIyWlI5d3JXTHlyTjI2TXI1dHhjN0VJd3pWTjNOSytxcVYvRTNneko0?=
 =?utf-8?B?N3BYM0psU0Rua2dqZGxrNlBWQS9lVURndjUvb3JIZjBqOUd6OGcybjRud1RC?=
 =?utf-8?B?MEFLOHpWV2Z4Zkt5bExPcnJ0TitQUC9uYUF0YldOREZrbllGTWxXWmpjTk91?=
 =?utf-8?B?SEpCR0hIWmx3cm9HVUN0MkU4Yk12eFZPNlM5SURrdTA1YXYrYkhIYW9MMERH?=
 =?utf-8?B?UGgraURjdlo5ZVdZblR0N2hJU3VyQytCcGRoaHJJWGhCMEZDcFAyRW80WHBI?=
 =?utf-8?B?Qm5MMHovQk9BUVdVOGlTMHM2Sm9nTkRhWTJ3UGJvMkhCTGwzR1FQYUF5eGh3?=
 =?utf-8?B?dXVVMlluTS9ZVXFxcTN5eWd2YUJaR0pGTVczVlpDUXQvOUE2ZWlhckRhUHR2?=
 =?utf-8?B?dUJ1TnhDRExaaDFrdDEvZGxZT2RVYS9zTFFIYm5FTklGeTRycURPWXVONWdI?=
 =?utf-8?B?ODdWR3kyOFhhNUxJMHFWQlFmSE9lcEVCNHJLTS9OSGgvSEEzWGgvUTB3WFU1?=
 =?utf-8?B?TVBjVFg0SHdrUFdKOTlLcmdURm5LRlF0UmpVN2NNZzVWc0U4S2tsdmJ4YURF?=
 =?utf-8?B?citYNGQ2T0FqR2oxR0pKZWpHajE2WmhoTzg4cm1kU1oySlpPdytnWDVjc2JF?=
 =?utf-8?B?Y09abjNlTU9WRmEwS25yTUw0OGlLK1F0YUZDcm51VVVnYVhnZGhEQVVVQXVr?=
 =?utf-8?B?ZG5FL29Fc3ovR0o3YXJzY2NabG95RkRoNG5BYjlVcU9Ea2xNdm9VWklmWGhw?=
 =?utf-8?B?U29JOEJDQ2t0bTgyUDJzdW5NUmx5b1UzejhVVVY4NUJ0YWcxT0V0VXV5NEV3?=
 =?utf-8?B?Nis1clg1NytnQ3IrRWpUdFk4Y0RMZFgvaitoRDNJWlNrek1PZFNiZ1J5dzJk?=
 =?utf-8?B?MFlnZEl5NU91YjVLL2EyN0RVSzZDUmFJR01nN1dxMk8xYVBWSHdvVVRGUitq?=
 =?utf-8?B?VHB5WHh1WFppQ2k2cmZ4VnlIR1R0US9yc3F6SllGTmVSMll3bXhrNmJyVzRl?=
 =?utf-8?B?NVRXdEhaUC9KWjBtWlB0ZlRQcGRwdG5QbFlkRlM5RGt5SDZuekdRUXdqbkZS?=
 =?utf-8?B?NTM3d21rZjBkaEhxN2F6c3ZXVDVGaHpsN05naVJpZGdtbys3YzcyVWQrQjRP?=
 =?utf-8?B?cXBMMlBKbjdCcENrOXdXYVZvaDdYV0hFSmJCUGRQYUNOYzNHMlVqazFsTGh3?=
 =?utf-8?B?NmswUDZhNHNrODdLU3pnQ3pENXlVZTQ2ZitaWjY4RmdqRVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:03:31.1944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 439ef102-cbfc-461e-bba9-08dc8c93eb32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8464

On Thu, 13 Jun 2024 13:31:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.278 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.278-rc1.gz
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

Linux version:	5.4.278-rc1-gb5a457a9ff04
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
