Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB1215F7E
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744992982; cv=fail; b=ut6Dct8v+EOc6b0vUQZD7NMqUdatCEXoQHpTfxClYwzH+RZpp3CApLwEHwWUft+B+F3u/5t8KztQ+ih2pHQJQ7JHqo33ylqUCY3XnUTaviHg9s/6OkuRimfLBoPaTvPOLY8dqGZ94pHJ2lblk7izY27W84N0+RS7egfaRHHSGBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744992982; c=relaxed/simple;
	bh=8t4Yf9XD/Fqm3jTXcnA/HAM5Y5lcUDf/DOdccWzo03Y=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=rO/5aRhSQVZPlR8CKCDb9oma0xR/MS+GfLIP1OS+B6CG+qnvPJD/GustRnq7ONgFyKrSe5mIdcM4jKCu5zz/TF1hrsH+OKjymEcaPltFN8zC6NEv7lc4rMuObgOFJAYJeR0yK+7FCRFqtH1tkO2HmRo0Ujvt1CZ7JIpP4FeRWX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fpbn8dTr; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fpbn8dTr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9kccdrIzAVJpCm4TV0tCLCwotO7RBZMhnmX5sAq+THqnpJ+I4ovvi+roUonZmFfNi9jQKiWyXuJwnZBPP1W60XfoLHNsCfrhFpi6bDTSAMLXHSq7Gp3FrPMmCX5CY3a73Bj686AH5JmJlA/keSwFVuKpYYS1HdSLKxzSKvEPQuPhuJ1JxKtB9f8iXoRZ85waL+SYaqO13wNhwZBATvmfYepZvS8RnshruIGgkntW8lhtKp4gSMzwty111VQrzmwvB/CBa3W2dUqkI/JHs+gr5LqWjvcF6+kI+iz4fQK6DpRU+VdxjJgHgi9tjFQuNElqUaOu/S5HTFJRmlyDmW9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwdL2aNMGNbcpPGgAgOwzWoBdazSw7/OdpMgRFoIPW4=;
 b=p5ZFyT29dLHPpJicqWAvoBlPrJkAQTo+utqWFwFVi/wfWHJzbmDvAXGdZCwul3S8D7bLYosNX5vXULF+240bHiEXWE/QDuittcLyji+1ieFSn0ne2P8YoLH102wCVpg5/U0dJvd147rEhZ7OAVL4RW1nYfE1+127b3pJ/w6cOW582f1fWOa2ZVvqZxveoUEJAK06pCP4Z86iGQpzrffLImCjXP9tjWAOqjsEezOIPifHr8rHth1vbM3K0/FdCfr99ijlV6y5YqnNXHJWGvgf7xGlmyCskl+qMi4uQ4kOWtB6Yj8KLXoNw42IcqnXIv0l4tE8/dT0Tcd6rj4QidEA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwdL2aNMGNbcpPGgAgOwzWoBdazSw7/OdpMgRFoIPW4=;
 b=fpbn8dTrvPAWomsS0PFASMivg7WSnM6HSsLv2qKdHFlaDKsyE2rkSyCnwvLjsvrnYoYTRd/JjByoMqqfjhL1aGkQAJTx15c/jpQiIc0dPHQi9+j80kqUS5EfQPWgYjVPxgkV5gg4EZl7Uc96I5+lQOmb0EyMJjmDVmIETNv4LgSOcxlE7RhDsynpBL+xLJ6ec66c6o5QRF31TzCVgk25SvOkMeNuFLGVCTkeI5/ZzBGZZb0N+QYD43bgPzDTUUlyDipfZGx7g3wbPLEwvg73LZKxJhYhYsxIa6f/Krjx9zVDruYyst1KwIdqz2wIHzw31r9+3ZLf4PcPi9aP8sQqZw==
Received: from CH0PR03CA0191.namprd03.prod.outlook.com (2603:10b6:610:e4::16)
 by DS7PR12MB6142.namprd12.prod.outlook.com (2603:10b6:8:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.27; Fri, 18 Apr
 2025 16:16:17 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:e4:cafe::9b) by CH0PR03CA0191.outlook.office365.com
 (2603:10b6:610:e4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.22 via Frontend Transport; Fri,
 18 Apr 2025 16:16:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.12 via Frontend Transport; Fri, 18 Apr 2025 16:16:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 18 Apr
 2025 09:16:01 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 18 Apr
 2025 09:16:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 18 Apr 2025 09:16:00 -0700
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
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
References: <20250418110359.237869758@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <365ad590-aa84-44bd-948a-8b66a5eeddc2@rnnvmail201.nvidia.com>
Date: Fri, 18 Apr 2025 09:16:00 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|DS7PR12MB6142:EE_
X-MS-Office365-Filtering-Correlation-Id: aaffde4f-4e91-40d5-a16e-08dd7e9458ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFJQa3B3L2pHQUtMSEJab0k4MkxLay9VblNmRUtrMHRuSmZnVE4xcUpkcmVG?=
 =?utf-8?B?dTJqNmtpTVVwN0I1OXY2alFISGE1VC8zM3dHcHJZa0dnTFZuMy9rSU1MRjdQ?=
 =?utf-8?B?cHVUb0JNTUVkbisrckZGWTE3MUMvcG1aL3VGYVE5d09pVVpjU3JlelZNbHh2?=
 =?utf-8?B?cHNkZmUwL1d0d3N3aTlEcHpnVUlwM1AwZ1I4U0NxWlRzdm9yaEdnUllSZUJW?=
 =?utf-8?B?MTA5OGJ6bEtFMlZIUUp4RlpqclAyTWcyWmtUbGRQeFpkdUVaYUJDWXBVTDA2?=
 =?utf-8?B?eFBoWnJTYWIrWnlyZEthT29oK3Vzd2hSc3h6NUVSNDhxMC81ZHNiZVBqWUp4?=
 =?utf-8?B?NmdOR2xBZTcrWHg2UFdPLzFNaUYzL01NN25iQmJOc2pXM1kzQmx6QlBSa3Nh?=
 =?utf-8?B?NDlHK1ljQVNCTkcwUGVJS0pjbG9SSE1RSFo3d21WeHVsU1pJNzVuUWk1OGZX?=
 =?utf-8?B?V3JpV3d1QWtwMGpmVjdkZ24zRzcwNTBkNUR6R29iWkQxS2tuVWtOdG5kdm9N?=
 =?utf-8?B?Z1dKRVVaRTkxWXJzK3FrOFB2a3lRUWltYTJEWUFxUHQ0K2JvOVB0OHpvNlZI?=
 =?utf-8?B?UXZrKzJoNGlpOE5POEZSMk1EQ0F3ZUt3NzZxNHhpbUJMcTRsTXdrWnllbEtz?=
 =?utf-8?B?VGtrUjQ0L09JVGljWDVCUGVJY3p2dGNWb2M4ZlRHUjRKNG92Mm9ZU3pxSlhZ?=
 =?utf-8?B?RUxRYXYzNWJJbTB3My9OcDJJRXh6cjk1aVgyUkxUdnJNTzFkWVpMMGNRczdB?=
 =?utf-8?B?Sy9FVm1JTkFxQnkvcVptSFd1T0RsRGNNRVBTZ2Yvckw5dmtKd3NLdStSZHV6?=
 =?utf-8?B?WVJFbDRxS3NDMEg0RHA5bHA2UEYvTktIZHVjVG9qZlZNV0hTZmdvaTd3SE56?=
 =?utf-8?B?Q3haRFh3bnFmSk9xR3NyVFBLaTVXc0ZuYk8rSDF6K3M5N1QwS1hpRE1TdWpG?=
 =?utf-8?B?NmhLaTIxMVJIeWloVTNpUlU5dk5zbzdnOXdmLzNCa1liemZ2dTliK2NjM1Zw?=
 =?utf-8?B?Rlk3dkVQSmRBWHhlb2hUQ3NaQTliQVZaNjUvM2lmUldTako3dDBOUGJqMkdO?=
 =?utf-8?B?WHgwS1Nub3p4UEJ4QjZWMWUvUnNCS0MyektyVWpnMVZsY2VyYnBxVW0vSWJi?=
 =?utf-8?B?QVk5emV0NUN2eUVRbG1qcEhUaDdIQmU4NFUvV1I1S3gxVmloWmcxc3poWHp6?=
 =?utf-8?B?K3p6NE1NaEFXNGdPVFFWSk5LQ2M0Zk9OcWU4NG1zejNib3pCWGtDK1paek96?=
 =?utf-8?B?VktpeWdrUHk5aEJjYk56dzNXOEdPM2NEK0YrRUJCeFBKNUtKOWxJVkdlbkxX?=
 =?utf-8?B?L3dFbVlIcHlqV0tCNjljRDh6c1hieUIvb0lOSll0QXdXZ1o3K3QxN1hFV2dK?=
 =?utf-8?B?bVZCRm9CamRQb3VnWlRNWU1WdlUvWVpmT1RoYUpsT0JjV0ZiSjh2MjNQYmxC?=
 =?utf-8?B?MEVLT3ZHMzYwOXJQRHRLOTR3M05RNXI4S2p0U1pZN2tIR1IrQ0tVcXkxdzVJ?=
 =?utf-8?B?Q0xya1phOWRJbnNaQkZIYks1bVRteXU1Y0xSZXZEUVNoSlNRVzd1SUtVV2l0?=
 =?utf-8?B?VE1mZUpINXgrVloyMDgzaWVCcitHMitmMUMvN0FXc3M5aDBQV2pJY3grVUMr?=
 =?utf-8?B?Ym10NlY4MjZyTGc3cG5kc3d6Z1ByL1p4bURRcFdWUEtnVGtXNUphTGpJVnBF?=
 =?utf-8?B?Z2E1L1RnZUJVZ29yNE15T2g0RGRXcnBYWnVBT241aWRleTR1dElObHQ2TXhW?=
 =?utf-8?B?SkJvN1greThBc3FRbUxiMzlQMVU3R1VaUmlCQlQwQ3Y2QUN1Y2xiVlNvL2lw?=
 =?utf-8?B?eWtBaTU4ZVR3aDMxNXN4Yk5yTHpHTWRHMjFGQ3Nsamp0WWpPTFZ6VC9PbVhY?=
 =?utf-8?B?aVdFVTl5OHIwUUM3emx6R2ptYktWUE1SNm02M1lNUG56MW9aanhnWi9hZ2hK?=
 =?utf-8?B?ZlBNNGFIRVlQeXd4NXIwVTBLVHpxaXpSQ1JLbnJIejRneEUyRU4yUUI5em5s?=
 =?utf-8?B?bWNKWE4zMmdjd3VIVng1ajZXMzVWTFRldXFUSVBNV3ljNlhDUm1Nb0prYVBs?=
 =?utf-8?B?Y1RYN0FmRzVqMGUzYTJVdk44UlRsWkRrZlhIdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 16:16:16.7274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aaffde4f-4e91-40d5-a16e-08dd7e9458ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6142

On Fri, 18 Apr 2025 13:05:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc2.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.12.24-rc2-g7b7562936f80
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
