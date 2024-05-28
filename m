Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE2316A39F
	for <patches@lists.linux.dev>; Tue, 28 May 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716898486; cv=fail; b=DGnHOaa89TXbz7qyRfRV9s0vkT3IXH61ouY5VZXpQ9KyYcSpxvqlxzFF07cFWMbY2VyV/bG5OVXxZFaPwa+iygMSkcwct3vNqBRMzi3KFLln2NQpxcFdqr9i2W1ZUKRLwAv0eTECEtib8teGHWFQJg6l8tMQvNaS3Zoqak5umys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716898486; c=relaxed/simple;
	bh=mrXQgVwiwI0ZgiL5dDuiaZ4pkAzuHRCF2/uwHKrG764=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nbhd1gyNMPBI2G6OZ19I0MZ85lbPuvDecYdBJN9Ch3I7lZEzrBXgbdLUN1NuSf28AMIX3UFkSvT2nj+8e/bA59dYQoYfeGKN1sURQH3UYdEBY0FnauaTEUdFW6LNcDO9nSmB16+VSQX0a5sqiI+jOlgqqFmZcdCmpx8Q+xBzFtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t4maeNy/; arc=fail smtp.client-ip=40.107.95.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t4maeNy/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGTLyUu8tQ65CI62OwUD07XwyskhySCLqzHlN4s3YWDbKM1y0pk2pF+rU1l6HIkqi1Rt005gVePjybojqgCz6FE0CfMTykEVuMGT5BrC2vH8I6wwZaNBr/ZnU83yA0U/yGNMV4DnTleV0GDmbjXivJoaqwgDpn+IrUv8QkmZrqJF+cUtjDFEmz8b7rhXvAMRPcYPC/bvhq2lnBHyiOLBDUhYhQsydJOzRBl8/CUiGK9y/Wsvd5AkhTaE8cwtyIxPkCkWGaqtVcIPrJ7lYWtxzPAc/Lna9gn1o+NW3k8v9I/bW2rw52+cJ74283+ocbxCNDdJSzWFf97ThPJuvFoJZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjHfeVrjENcaNrexZ/Kzekdojf2GsK/4NDtwMqQOrz0=;
 b=Fcjzk+VMMuE67sJjP52mP+YWgsiGrMvV9HK3ar1GqaXh8pMgeMS7jzEy95JxhYuBmD24UoKfDAdLfXfUrEnniNjU5cnKl4YuS/CU6DAsKecLBeUmGfJWkPd1GobP6PLGpQm0malpE4nSPNqv3dpbC/tAYIURN8BTxw7QJ448N1xczOpqlgCn45TSqjlHQ4TosqF5eI+LCLt2tQs8MWghNcN9krIXGLCQ4GT7kQ5Jt4dkjlKoIOrqYTUVdlhjpPVQyHvAYoxzNcGJg/Ff3aMbJaunAyWgVXHNcUDfBHQr6Hd2XGCqK5n63vOGKQhtyKCVjWBt5/Csk6TPg71bmU8CPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjHfeVrjENcaNrexZ/Kzekdojf2GsK/4NDtwMqQOrz0=;
 b=t4maeNy/Or5X5EFUPSd5w1gQnskC982EgGmv9U3ZcJizSBCI9kEmLkdaRjdF6i15GYCZFz02Is4vppbPEZfvNzINLC+rLH063/QWZg8NPDxgU4P4tYq+i3sLyLDPo8t/yr5krMSbzKkMnCNZUR+RIh0r4NcDl4vVeEMXnvFZPfrUXDovPoWY40y7okIB/sfeIeJZHlCI/6fVhN/MJo2BGTeBDlRrACwvEG7yrI85LyLP+jji3PkDlJ/ZNJOilJKUSaSLCPf73l1KcbmY7EsAodZAokQc+Hg8b7hxJcw3qE+34cTwwakNhs/Oou4LfQjNjBrDeCksJXBm+lDIH2CGkw==
Received: from DM6PR12CA0027.namprd12.prod.outlook.com (2603:10b6:5:1c0::40)
 by DM4PR12MB7502.namprd12.prod.outlook.com (2603:10b6:8:112::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Tue, 28 May
 2024 12:14:40 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:5:1c0:cafe::57) by DM6PR12CA0027.outlook.office365.com
 (2603:10b6:5:1c0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31 via Frontend
 Transport; Tue, 28 May 2024 12:14:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 12:14:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 28 May
 2024 05:14:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 28 May
 2024 05:14:25 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 28 May 2024 05:14:25 -0700
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
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <03eb034e-5adb-4003-9149-3598f4b57f6f@rnnvmail204.nvidia.com>
Date: Tue, 28 May 2024 05:14:25 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|DM4PR12MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a5b245e-9b88-487e-11bb-08dc7f0fc011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWRJdVBybUQwUUIweEZHcXlSZ1lRYmhwRWM2T2tJanJpMHRyK3JqTUt0cjdx?=
 =?utf-8?B?eFZ6WXczY0p1VDRjZUFUN2d0a0doclNuKzBEZTVDVmkwQm5pdXBkZ3Z3TTlB?=
 =?utf-8?B?NFJ2UFBCMlpET1F4TmFIZGxVb24ybnZOdk9iVTAwMTFCbHBoQ2RzL0VrS05Q?=
 =?utf-8?B?SkxKbko4NDR5dVg1aW9YdDBKNTVISGg2bjJoWHVJR0tWbmNDdEVYbkoxV1Rp?=
 =?utf-8?B?TU1RdHZkcnI0VUtYQlRqaUF4SUdiNUpHOE1hZm51WUtqYmVvN1BjY0ttNmJy?=
 =?utf-8?B?TWVsa0ZZSU1TdlZORkF4dEYrT0kzTlRLcTEvN1NlVFBEUFhnN2QzQ0ZwVC85?=
 =?utf-8?B?d1FXdkVXVTRpYmFMQWY2MEJTbEdjaSs3QW9ZdTNqZ3AyVG5idUdRUjk5SnFU?=
 =?utf-8?B?REg2cnlRMk5aZDF1WThNbWg0aVIvZWZtaHFqSXhrU0QrbEpPTmRBbVd1YmE2?=
 =?utf-8?B?dStPYjZEamliN0tyeG5iUlg0bFgvWTZwb1V1QUdkeU5rMjdzTlhYaWlCZmJN?=
 =?utf-8?B?QlYzN2tZOGtnR3Zvc0lTVGhwY2swMTF1ZGRHUWxJOVlZaUR5WjBtRUp5NXJQ?=
 =?utf-8?B?QUp1OUdmR241ZFJMYWJwMFBiRHUrOWg4UXR6OTlNQjk0ZHFhMGp2OXRqTGta?=
 =?utf-8?B?WlR6SDdxeGh4ZEhrejc0TEQrZldnL2FPWE9ZS1Z3VjlsSXlZNW5XSEplY1Vt?=
 =?utf-8?B?eEJYVWozcVl3eS9OeHQzUUtCOGhRVFpwRFQvakdaSW94ZzFTZlBVUEc0TVZZ?=
 =?utf-8?B?a29nTHpzQ1g5c0NiVGFwdjRtOCtFdjl5OFNsdTVxcEFlV0pCTkg3ajZVdmZs?=
 =?utf-8?B?UkN6UFVZWE96MWIzbFVIelQ1bU1Vc0pSbjJ5TnZnUjlxTVVGZEVRT21EcmlC?=
 =?utf-8?B?UTU2NGpkak40L0lodE5rdTZwTU1SYVZNbzlreWFodFduZlY2bUtPT3gzcjVz?=
 =?utf-8?B?bWZXVTk5UnAreU5hbFJQOFdnM0NobnlnT1JUeUlla0tTK0pVWDl3Q0JCWU8v?=
 =?utf-8?B?cFJwWDNMdm54UUhaSS9kUGRQaElxSExZZGVhZW1SN3BxbWVmcndvT3Z4QWtK?=
 =?utf-8?B?ZERWT1RuRU9kUjFoSU9ENXMzd0JHU0kvQVJYWWFFMUJZd1dEckxJQjcwajNm?=
 =?utf-8?B?cm43U1htMjB4SDF6Z0tPcjl5QzhtTkVtamRRellhbHdtcVRuVVdTNjY1UGxq?=
 =?utf-8?B?ZVB0ajJtSDdVTUROTVROQ20raFdRaTY1Z3VIemp0U1VuY2hRSFNzQ3IrUjNL?=
 =?utf-8?B?UlFqUVViWmE1NmdXQktrbm1iZTNxUDNmWGtsMVR6ajZaUTBvenJpdzUrQzMw?=
 =?utf-8?B?Q3U0cys4TE9qN2gwUEdKSnphSGVQVUJQaElucERlaXIyUEFIQW1CNk9OYzgw?=
 =?utf-8?B?YUZwK1g2OFdvek1qL1dMTmtRZldWeUdDVHd5WjZ2YWtta3UvVXZCdTF3UDdn?=
 =?utf-8?B?b2N1SENlUGxUaTBwSEVYbVI2dlNOWklZT1lna29xcDdHQUlxb0Rsc2d1aUdm?=
 =?utf-8?B?eElOZDRLMWdMSE5SRU1Dd2lxZjZwMmdlOW5DaUFCcFdqWkRKeXRZWDEwcHpH?=
 =?utf-8?B?YjkrdEtWRTJoazNPaHNiTGVHKzhST1c4SzBLaU1qYzF1d1c3RTBwNGVjMHZO?=
 =?utf-8?B?dWpBUXFHTXVKTlpZaG9nZ012SjJINFNYTXNtRy9pTGJDc1J2d2VqdTJ4bzdw?=
 =?utf-8?B?d2Y3M2tpNU1mbG9KRytWVkRvaFBVYjlHakpkYjZ0N1I5OGQ5aWRjSXBIQno0?=
 =?utf-8?B?RFZGZmZvcGlXYkMxbDA2RkR6L3V1OFo1WXJ2YmxtQ29qUW15RU82aUJScFU0?=
 =?utf-8?B?eW5DYjRGS213N0tTbExLa1dYOUtrUjBOWUZmOXNCZk5BdjVkZS84aXFxRlg3?=
 =?utf-8?Q?1vR6m8d2czH+F?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 12:14:40.1786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5b245e-9b88-487e-11bb-08dc7f0fc011
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7502

On Mon, 27 May 2024 20:50:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.8:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.8.12-rc1-g5a8ebc9c48a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
