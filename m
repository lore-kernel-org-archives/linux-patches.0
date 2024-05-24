Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577D12DDA2
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564011; cv=fail; b=OrJf97MhvJqsQibmxgfRKQEOwFc8kWI4XNfa0OjCfWNC4yCv1zusn1y2qau2SenfmDe6TV8QHlJUMBGl0vnxlpUj3d1g263clqlrRf93+ngtfmtGCMvXbi6gs7D5t7V6KwcinPXtBGX0czxDgac2LFOqYFWfsiS/aF/hRMkhr3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564011; c=relaxed/simple;
	bh=qyzvse9CCdpVWH7+SV1GnrxM+Fmw1sGN1cq9UWigmUQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=h04u0ZTxLEe48sXu9FxsqjLVZ5NpydbSz+yJTNLidB1eTywCoByuqq3cWyPzdaR/T6a1uEZ3cbhm+/8+xl1IJp5cZUkMpHe6fy2oU4L4GOgo0TDOWmmsm9JYP5ruFX12EoAiCu+R8lr7DVLd5Msbm5kgVNJgtWfNjKu15EfprVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qiPPecZ3; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qiPPecZ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQ+SDe32Hmj4M8uKsIgyHp7ozmAuJQMmiu/7ZO/76N5DFZbL2APFmsUyLWxYf/RzUDzBaLkatLYCKn9HrR6wRcLpt1cdNCJPWr9Pdxh4qJscCtqbEEltzx3IsyQZSK8iKABOYcmDrkuwVbmQADzkO6IKPBrK4dFW+00aTHOc40yizbWJi73gQfRkeQiMAqXfgEJeXAljIARdOWBAW6/kOispiimT7cqVD5tx6KxNGOg1y3CXVc09hUhV4DRPKpFcDg9fbiYqDAMIcdk9LLtVRXTnILa0PIGarHw8xfp2Z76S33/embDoXYbU8MpJWJNjYJXLknvc3yIOFsSCGjoNyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBC8i+yLuIv4eSNiUwTaQjkOya2tuWSzVR+2mZnG6WI=;
 b=YNCwGrW6wSLdtuxsOyGbT9Ihi3By3J/zpASg9vM3EaIO5/PqFGaslyVND49Y76kecnu/3bqlWy+PAEcPUHTCMO1WzOMZLWVYie8oF8JUHbvnqeqVJlg+UqPAA30eS54SqnkWjxxdbPrvvnL0HdWHopi18hdmJWf4vw2FjqCLyZACHNJzkNhveE8FEo8xW8uIRFhidENglNk5J0de4Xa1NXJLatC5WCl5Hf9sAxbomea1pDzr71E7MG4DkMMX5u/NhAfW8hKcBqJ0OqWqK4bjvdO0YaORcXQn9SLFFW+u/VDhob6iIOHnL61tCUsj+Nio/tUpqOXAkj1RR1nLIKqQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBC8i+yLuIv4eSNiUwTaQjkOya2tuWSzVR+2mZnG6WI=;
 b=qiPPecZ36NhszsjRuhO9S7InpeDh4JRnwhyEJgBWzTwLHYoFIT4A9iM3b6OxQTA9mcV+TMIhm5Swkb12MMWecCZU54S/UhaaMXVAY5kedfXAH6XpKBI4TL0iD0ZyHrxfHjpb6JBsMf6Phqd3YWJwlDetmxgkugWGD8+UIhzSndk1+taNZaeqoRkHuLJYZQtST9VqhhE9KPDvGvUa3A+zDYqm4knxX1qoRYGu4qm5NYlPdVOPqTy2MvIxI4+Pr+FaVTfcq4rjA1jO4JL29nv+MvEYtow3jPCiiWkVeO0gE2GSgFG8gZ2F6WeN84RRqnZa5qMu8M3AiCXabXynpLG3WA==
Received: from SN7PR04CA0192.namprd04.prod.outlook.com (2603:10b6:806:126::17)
 by CYYPR12MB8889.namprd12.prod.outlook.com (2603:10b6:930:cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 15:20:03 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:806:126:cafe::69) by SN7PR04CA0192.outlook.office365.com
 (2603:10b6:806:126::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22 via Frontend
 Transport; Fri, 24 May 2024 15:20:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:20:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:47 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:19:46 -0700
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
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ff41602e-7fa2-400c-9372-1ed3494e3d23@rnnvmail204.nvidia.com>
Date: Fri, 24 May 2024 08:19:46 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|CYYPR12MB8889:EE_
X-MS-Office365-Filtering-Correlation-Id: 42e093da-bfc9-490d-48ea-08dc7c04fc2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXhZMXY2dHYwZTVUWHpTVFFSblNtOHk2VXVoUVV1enU2MUhmdktMeTlmeENR?=
 =?utf-8?B?eWI3MmQ1L1pWRzV4QUZYV0dLZkpTRFcwYklpRXhiN1h5ZXlNN2hBbXlYMW1X?=
 =?utf-8?B?bWl5bi9lTnVFM1Y5N3FJT3JrNENVUncweEttaWJoOStSdWx4NzBHZGtVdmhV?=
 =?utf-8?B?cDI4TXd6THVuNzNIcllXTG5KbU00OVlHQmNNKzNZeTQwUUZYalRvd3RoWkZY?=
 =?utf-8?B?SGJUd3dFalEwY1BVSTA5R1E4K25ON0owUEppT0tNNTR4dm8zUGJ6cnhWZnJW?=
 =?utf-8?B?b1JZbTNYTlhOc1ZkRi9VQjNOZnhqZFdISGMxUldxbGtodWFqMVRPVnk4WjNN?=
 =?utf-8?B?QmRFSjd4dWJWT3NkTTRuMENrTy81Rnd1WkpDbGN1R3Q2Z1pFdEl0eDVDeVRa?=
 =?utf-8?B?UmJvczF2OTZxc3RLdmR3V0FwWWNGbUNwWm1DR1hQM1ZMdW5Fc2hsL3BTa2tQ?=
 =?utf-8?B?aGNBa0xZVHVrRG9xN3BCWlNZanpEdStGZ0FzaldVTXFPUUd0L1hUL0xzV0Vj?=
 =?utf-8?B?VVVEaHFvb0RjTnV0WVA3dlhiWjJnUUFPYmxLQlN0SE0xY1oyNTZ1RzJ3WjBv?=
 =?utf-8?B?Y2wyVHBLZk9jOXA2MkdLMi9naWQ5d2R2T0cwZXBhS0IzQkgzYmhUdU1Lcjkz?=
 =?utf-8?B?Y2NZaCtOR0UvcnpUbmRrNHRNejkyMzFSRm15Q3piVjBIa3h1VnNLZDVvZGs4?=
 =?utf-8?B?dEI5M2hkNmxGVFZ0VndZcUg1Y280a01FNm9CbFFYeFdraEI0RzRGRG9ESzlF?=
 =?utf-8?B?Qng5bzlVaHJuMXNxSkZMc01taVhNUFhIU2dtZUZpdXY3VThaMTdZNG5MNDY4?=
 =?utf-8?B?NkFxcmh6VjZydlR1b2pKemgza1BUdjhCYzE3V1lKbU1KcnUyaERhWDZ1ZnBM?=
 =?utf-8?B?YkdiMWliTGc2Z0U0OWNnMGx3TytuN2h0MEEyZnlIL2JHWVRycHVORGdGSldx?=
 =?utf-8?B?VUdoRTdIaHJXb3JOcTZNVzdDM1hUSU01d1JjWnRqMzh1SlI0eXlMWDVyM2Vr?=
 =?utf-8?B?Q3NkaFZ3N3FrM3pPdCt0MHNIREhvWnlYb1hvN3BrN3UwK1d3Y20wSWtDRDhy?=
 =?utf-8?B?cjlqODJaNHppdWp0bElZQ2xpck1RaW11U1Z2T2VweVZIc2NuSUU2WWZKZW02?=
 =?utf-8?B?QktLMmpESVJpOURuaUw2ckpwV0xsR1drUDB6bHJPaS9Wd1RyNFdSTXNHWjQv?=
 =?utf-8?B?VDFtQWl6NjdMZnc2OUFXRGJKQnMwWkcxaTlHZmtDOFVpZU1XOEhNTXEvei9t?=
 =?utf-8?B?elNtV0Y5TlZCbDJZZXZseVlBMDJZb3F0ejkxTnU2a1VtNjYwWWUvOFJjYkdv?=
 =?utf-8?B?NkR5WS90MXFaUU1EMjNQbHJPbndsd3RFYno0ajJDRXRJUGxBSUszSlFTZGJV?=
 =?utf-8?B?Q2djMlMyeCtBVlR6aWR5dHNzTVZ3UW8xNDNCZXlna01US2RuNW8zeG1RVDE1?=
 =?utf-8?B?R0ptdFZVYnlZa29heDZibEZzQWJCZ1dsWGxpdktvUEtIQW9WSUNYa3hUNUF4?=
 =?utf-8?B?TzFReCsyRjdOVW0rTHhvT3FIb2dMZHV6SzhFMGM2bGNaY2l6aHF4NjhUVVBj?=
 =?utf-8?B?UVFHZlI0enNOUU9VOU9jTGRuekUxallrSXZISFUwUncrcTR2QjRoSlpYTmIv?=
 =?utf-8?B?UEFCdE9SUktmd1RMSzhramFmQnRTb05YMmNOK2g3NGM2TDFWMEU3dHVjMy9z?=
 =?utf-8?B?M0FPRFlxTCsvTEMxVDJGSzhpL0ZNVVRsQnpFZnp5LzA2Z0pha0tNSEM3VzhQ?=
 =?utf-8?B?dFdtMTJjQUxtQzVWUlQrQjVCTjB3cTRvcUc0Z0pybzVNbEFPczdRRXEzVVFp?=
 =?utf-8?B?bWFRMThtWHcwZ2NidkpCVTBqa2FYR2llTmcybDhWcGUrUlRNMGgwcUY1ZDkz?=
 =?utf-8?Q?MjEuIckw3Dy8u?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:20:03.0497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e093da-bfc9-490d-48ea-08dc7c04fc2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8889

On Thu, 23 May 2024 15:12:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
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

Linux version:	6.6.32-rc1-g492852c6380f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
