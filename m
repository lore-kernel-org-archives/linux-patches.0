Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29F1F78E0
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753906240; cv=fail; b=I6DIpkA9PVyyLQcCwPQMOPW/vXK9iYLGEkEdPqYSHBBcEl3i2jocGABP3ovavbIKvlgwjh5sdKP2EGo6ZVUOdqFtVpmG93s+rBL9HU7ixFqD6GmJHANKPjTfU3EewTiaW5wil7H7ajkdsZa5L+/shr7SvfcrAbodDInrnepUzWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753906240; c=relaxed/simple;
	bh=B9SKvoOoxOyG6mdcg5Sz2w4K4Q5GaACBKnybPzCpdrQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=awRb5nwD+YMv0C38Rx3depcU2C88PV0riB1ss8V3QgpWa1MH/we13tgDuzuGzSOT2tYiX+YqatY9b4vsGuo6nHzPG8D9s6TKlpmAnmLSEndvJMdiDUzWvPwGhGfWPFvtld17pS2Ae3CqaqDi+hXLvsoAvMuqyeWQN8uWjj/Gu9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QUuP1wrw; arc=fail smtp.client-ip=40.107.243.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QUuP1wrw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvogfrzxDPvTaYxRtnvZlVCdjpBgk4QUznh0UVdh/DfzTjh+csautNi2E0Fb8/auquHLb+SC25dyIWAkdZ34EeB70Z/Dl3fL2Rrb2YtBp0vtrbcLSqnMpgPJ5XFjWMQEVBddshaupqeiULCMMi7GyOpRdz9QE0SL5bhmsVoARnypMkGTXcchuLhNl0NFbIqlWqDMKn08ZGhFWU87JtYEiQzmJ44g8B4h7ETiYs3vcHlKwX+BqARGoZVmTI5j9QWxPUQD1pDwnoFvnglwF2b6Se27WHUMWegGey8U4jrm5Q3zUNyrklIVVCD4a8bJePbyQM5Zs+iriVRThbfcD+QYXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/RNhBtyFGyWZRS05H3MG4GrxM4cYn5lqc6z33+JWvo=;
 b=Gk7a4LWAtfQ6fL08NZCCMFoYJIdulICpSqwNzW6wkn7OxSy2KRWn1uZPZ18Lsxg/kZwGUQVlcbvfZdtUjXepWmXhnn4vDrdC5LEvzGKXnYJKlX4xq1xKZ08KyGUQdekKdbfHNzW1uDAq+RW2Q85H6xwrSyBviv/j2UrJvKF86LgiIbcQjYwsqKcCBlYo+Y2/mcBZ9LBDqs3Yn/CcineiNwpzUhXlzRuMIQL39L3VfQcFDBrDJd9vy8ujBu+UVGTYC/bDu4d3gK+U6/vKMpfNxRYgmlxb7JH1jU84JO/G2YbmjErJePFtBw3Q1zxu9M0SnPIEsTIO7A2+6qnPalyDBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/RNhBtyFGyWZRS05H3MG4GrxM4cYn5lqc6z33+JWvo=;
 b=QUuP1wrwBVXx6hniaOgBAssxO1QFudCT4n0y5e8Jbw8ndoktAP9JVBx+tb/T+Ev1UKSqCxG5whxLAJ4EaQeM5ymiIhUPPMeNhaoTKsGf3LG+u8G4vZ/Xvmyb5O/BFwwfjAbkMzCGj/bUTgn2+6vKP2OijVD5i8SO5iv3njnGU4SnsFa5DGfbXXXljoIkCHvMSjGw6/eRuak0z99IJCpHaGZrzYY+5kYTEovemzl4zb7ryfo8BwJPsqAJWEzLxFow1ymkUhLEGTyo27oVYDWErT+7A/ETlRzl5ebAzhA+ZGPOQVy6qDmBaYJhp2P5jpZdOF/u0HTmv9YOWM5F0RXvjQ==
Received: from SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::17)
 by CH2PR12MB4229.namprd12.prod.outlook.com (2603:10b6:610:a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 20:10:35 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::e6) by SJ0P220CA0008.outlook.office365.com
 (2603:10b6:a03:41b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Wed,
 30 Jul 2025 20:10:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 20:10:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Jul
 2025 13:10:14 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Jul
 2025 13:10:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Jul 2025 13:10:10 -0700
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
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7f80ec7c-650b-419c-85d5-f61faad518d2@rnnvmail201.nvidia.com>
Date: Wed, 30 Jul 2025 13:10:10 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|CH2PR12MB4229:EE_
X-MS-Office365-Filtering-Correlation-Id: 623414af-47d0-4875-9269-08ddcfa524f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NktTMlpjVGd3VnQ3Tkp6cTV2U3AvdEZlMGlxWEpwd283dTFOTEZxNEozalVY?=
 =?utf-8?B?UDZneTdEWDlnWUZ0UTdnRGlheUN0S3c0VDY1V09DMzBNK1JxUnpyUGgvMFVF?=
 =?utf-8?B?OFdSMXZsNGNneUFDNmlTVndFT2lDb2FIZ1N0MkVZNjFKa2hCM3lIT0Z0bWpq?=
 =?utf-8?B?bjM3bmVGaURUTmRyN21zTjJvSnFlRnNvdDVzcHZjVWh5Wk0zcU9iYUd6SDhP?=
 =?utf-8?B?ekN5UXZ4UXJzUkp0T2oydkZTQklESm1kcmpxSkxYWXdwei8yL0YzZGJPcmhD?=
 =?utf-8?B?Rlo2ZUpvdDJBTmU4OWU5bkQvRnhjMkFjdHpJdU1sM3FSRWZEd3FrUEhIS2tt?=
 =?utf-8?B?dk4yMUd5anR1SDd3Kzh6K0xOcE9Oam41MGl1aTUya3Ewd2krYVVURElpZFZp?=
 =?utf-8?B?Wm1ZbHEyRk1ZZ1ArUDVlYVlaQWlnaXJOTm5Pd29aREsrbG50S2dmWVM2NXQy?=
 =?utf-8?B?bFpRS1NZRDNwbmN2MlBaMXZpRFZHZDg5YTJNZ2U3WjY5Q0ZvRUFPSUF1R0dn?=
 =?utf-8?B?cnZCWmY5SmJ5dVZuYmFXRXR3cExHZThHeGJUN0FQcUNTdG0yMFBGRkg3YWlj?=
 =?utf-8?B?dERGSjErckV1UnVHQVVJZFI1UmhLU0R2ZDU0RkxEZ2JuQ3ZxWFpSMlA1bDVN?=
 =?utf-8?B?SysreGh0UllCNjRSTjhoUDRQYkpITUErTzZoREhTUG53T0ZYeDFjSHZua21j?=
 =?utf-8?B?TmFyaWNSTG5qZUEzYkNEOGd5VE1oSlhOMzM3T2Uya1BOT0Nhdy9qN3F6TU54?=
 =?utf-8?B?b0orNnQxN0ZsSEV2UUJLT1hNeW9VdW5xQ25sVjBJKzJFMXc0dWZvbGVDWW1N?=
 =?utf-8?B?Q1N1L0RZNG4rYzRCSXo3S3NvN2hjRjRZVlNjOU8rZ3JGSmVqTXZlUlpuOGFE?=
 =?utf-8?B?SWgybnpxTENFZnRXYURkL2N1YTcwN01TRTdIUENpZVEwOGliRm0vUnNNcDBD?=
 =?utf-8?B?YXBCQU9tUXRSYjN1anMydUFTS3ZoMjZscnQ2RmVZOXczVnBDRW1xMURSY3FC?=
 =?utf-8?B?TDhtTHpEeXBDb3dwZ0ZyOC9CeHkzZFppOWRWRGNpZk9VK3VEWUU0aVdMWDMz?=
 =?utf-8?B?TXJxVk1kY1hLRVc3dS9ORWJMcXdMTUl3MlNsQkdCOUJkc2xpRHZPVzE2dzRF?=
 =?utf-8?B?NW1LaXhmNWpBMld2M0MwMjlzdFVTN3pPZC9ja2trbllOenpPUUI0NFJac3NB?=
 =?utf-8?B?dlhvVkIrdlBFaHNXcTBaT2duQkpobHp6SjhTRFM5NGRlTVBFdnE0UkhaNlBj?=
 =?utf-8?B?dmtMYi9sZzBWSnlwWFVuc0JlSlB0RWswS2R0SmNqQ0tEdDg2NGFaS2lRSUdx?=
 =?utf-8?B?UHdZb1FkaGlSZVFRb0p4bWJMRGYxeEpKdis2TmVFV3NNNFpxM3FmbU5JZWta?=
 =?utf-8?B?ZWJUcWRIWW9pUHpZYjFpVWRZbU1BdFkraW5iREVaTUZxME1WdG1YYjZzaUpG?=
 =?utf-8?B?ZzdBcWVXQXhQVU1NbkUxb0JHVFNITldvOUg4NWYxbUh3R3hwR01uUVFJWFRn?=
 =?utf-8?B?QXdDdEV4WkpMZ1YwaDk1ZnpyN242M25hK0dYRFMrYmljQVpnM3I0b0tLK2Y2?=
 =?utf-8?B?OXNXaHNpdW9nK2c2QkFrRVd0eVA1dlBPbkN6WDJGR1EyYnNuaVREMUlDWTE0?=
 =?utf-8?B?U3ZSSkE4ejRPUWovYnJ3VlhYVEZNRGNZK242VWhldW1zemZzSjBLVXFVOC9J?=
 =?utf-8?B?UkIwdGZBRFJ3bGE3VmVuUTNGQmJlZEt2Y2haU3dsVnhreG53TU4xSUF5aEcr?=
 =?utf-8?B?WE85OTlUT0R5YUdnbEFWdU03Qm55Qi96TlVKU1FDTFo5a04zdk9FTUJrVC9w?=
 =?utf-8?B?bFJxL21GbUdPN1lqMC9hZzFsa2toeUZDL01IbTBwMTRtOVVXbXlITU1zM3h5?=
 =?utf-8?B?VGVleUFmKy9NajkrQ3pQZjIxQ2NYdnp0R2RTZk9BZDVQelpzL0VKbEVIU3M4?=
 =?utf-8?B?dHVWd0pwWStaeHVaV0NzV1B1M0ZpTTB1Slh5d1EwK1M3eUxtZ0FnNVVLTnp1?=
 =?utf-8?B?MkMvM3g0R3kyUTRhMXJQVS85ZTFzNE50U3VVK0JtT1RyVWdKQlpIUGNWWjhM?=
 =?utf-8?B?ZExLcnVSeVVwVTZtR3JZa2J3eitZUU5tRlcwQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 20:10:35.2320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 623414af-47d0-4875-9269-08ddcfa524f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4229

On Wed, 30 Jul 2025 11:34:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.101-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.101-rc1-g1a25720a319a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
