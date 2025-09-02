Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A82345758
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836276; cv=fail; b=QGYEv0Vt8BLanSnDi/4YEK77Snof57m1NXaR9PCRhx0z1LAB068G19JxmTRuP+i27CHoENecBjfnf9oYScGvr53YjpvhHK8ozJgVF1BoDf7qvP3nCjlh15G47EELwpZy2DFZPiEs6vCdU1m8mzgysAo+grbC03Qb5s4i/YqBKXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836276; c=relaxed/simple;
	bh=gzHKKg608dKA43YbcHyfiwyGqMUaOGxdKzTPoAZUnyM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VkksTALnqtr98l1swZYLUnO0jgQ/mm9rp9D9r6Ydb8mASVB21SDa52+RklgMu4MnaE3oxKhah6vYysnFISfW1GbzkTzFXjVMOj8dyiF2b8wOtcAjHbtzCWmdZfXY6Wn5ehaqjTYR6x1DFQbrf2PfjMCvozsLpkBev3yoBsv23Vs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S5iMU7Gt; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S5iMU7Gt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wjv/9PVkIDr0fbeqjnFUox2LHUByeYLaHVl7OjrYTdsfVIyKcEGVUaLbedQ8e/EoNCN804M82KeM2ZdGNzIR4HLR7W4bpEjDMT8JQbn42S1rTt5saTIx8bWHfgvMpa8wlZ8w70PeJJJyptdbdRJSH38jxaat/eN3403sfnEYtOnK6Aw4lkKaGQsL4DhXzr0RDVziiWxMvJWHK34lZGFRFQ1g/veyWEDV1Esf7qQgfdefyo/V1NfugWrbHN2hZIspipcpsvUveHkWPjjs5csr1P6xLSkk9Xs6ynlMSBCe721P4hHQXU96zfXQ07BkJoEn384RLP0DsiPoq6Piwxb50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4bqumQFioj1uGpsRWaI5ehTXlxGyZfQ+wnUrp51CsM=;
 b=txqWCSIPJ3t+DdCf29U3tGkar3Vdr+AJimFWJ42xCTGcf9Oe46+S7eH+oysN0t8PFjNJRb/McMdpLZ45ppyYfLCaLIaoOa+co6VYgdbWcb/fHXpSo15OakouDIdR10qLeSsZ9eLoa6uLr/LPgOoifW/KfFYhA1TnhyT8zasht7aqH1F8/X5tiFSUVemr6+Ljkd7ZzPq2vzcf8Z2jexsVta2oURd41XlQRS9rHu8PHgkzr6ROXq/OXxCNnbAenhuOQqa76ZY33E1wStyI091vYRz2BKsyAKNAPj6swTluC3a6jT+/0QOVZ3xs34eWYocYMYC2ZgP9O6D3t5baEb8tiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4bqumQFioj1uGpsRWaI5ehTXlxGyZfQ+wnUrp51CsM=;
 b=S5iMU7Gt9W8MI0vemm2RfoRRFq18PqukXnBlp4judJ9mRD7oZeU98aWyTK8cc2YVAxMmLvjZl14BXcV/Hmbigoztrfm+wGT/Zw/lJFFICEuD2OGwAHypFa6B/QB1MwWEkvnnK2eqSo3WlVlcLEtzAf1L/Tt9BY7CTypPyf6SZi+RcfrUhl5D7hyKQhe9CUekPgAu/TkqxVmQPiE1ZAAsuTa4hXuhrITjoTYEmzw1FYlWWWmMj07IZzY7ABgmB9sbAYyO3Uv5pduMwgJDvFJ5i4i9ty7HsGyKl7So/IO8/ZEQCYmDvoz5a2x5HQ3TCrxSHj3sEmzBbp5I1H8Hbvot6A==
Received: from DS7P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::16) by
 SJ0PR12MB8615.namprd12.prod.outlook.com (2603:10b6:a03:484::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 2 Sep
 2025 18:04:28 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:8:1ca:cafe::a0) by DS7P220CA0011.outlook.office365.com
 (2603:10b6:8:1ca::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Tue,
 2 Sep 2025 18:04:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Tue, 2 Sep 2025 18:04:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:48 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:46 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e8ff1c27-0b0a-4f3b-8ee0-74d034932a33@rnnvmail205.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:46 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|SJ0PR12MB8615:EE_
X-MS-Office365-Filtering-Correlation-Id: 933f2b3d-489e-489d-c294-08ddea4b25fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlA5TjJuWmlMN0gwL05CRTJ3TldaeEVSMVVxdEpEL2U4WGlYZWRYeVc2RXJo?=
 =?utf-8?B?OElqeWlkKytDWUpLcUNkd1gvb3ZXV0trSTZlVFlpM2luUFEybGl5QTRHOUMr?=
 =?utf-8?B?RDNvRWZEUTV1bVBzUkhhS2JTdmhSdW1haTVHNVNmZWkvUHZXejJoV1Mva0ta?=
 =?utf-8?B?QmFVSytac24zRmJYRi9wMWQ5S2g4TlU1RGRVVUc1cmw1UHdVemRLRzQ1b0hv?=
 =?utf-8?B?N2s1UGFiUUhkSWV0N1k5ZEFhSWk0aE1aSis5MHBHRE15dDZwaTBwVFM5RDZQ?=
 =?utf-8?B?bWc4QkRQU2RleUNqQzhBQlRoelNSc2dsNTUwc1ZqT2wwdHZIMElHYnZ5Q0FT?=
 =?utf-8?B?YUw5QVhta1hVa3VWUG1kekZ6UDQ5VHl1SUpRbEpQT3BwUlJBUFFxcFFJV2NU?=
 =?utf-8?B?Qm82d0s2eWdvTS9UVGJXcXFaK3VlRlBZRzlrZmNoVWJWamZqSUx6K2NKSW5U?=
 =?utf-8?B?TmppZnR2YkFqN01XWk5rVjZFTi8xOENBZjg5b3ZkUFd2cTRJZWJtaFA3dEVI?=
 =?utf-8?B?WFB5S3Zidi9TcFZ4Z0w2Smc1NkovSitwOVlvdVRWYlhPK0lVKzZ6YVNac3JN?=
 =?utf-8?B?MFJ6d2xxRTRRa1o5UGRvdWUyZ09tUzFrc2gxY2lubENDNlRNRm0vbS9QUTlq?=
 =?utf-8?B?bnZMK1kzajJzNHNRNThHMEljUEk0Q0dmRnpGdWhLQmY5ZDBQQXJjNG5DMFY5?=
 =?utf-8?B?ZFBHU21ISUU3UEZaa1htanNMbDlZelZIaTQrMGloTitPQk1yQmx5RE10YjVu?=
 =?utf-8?B?bWRHZ0VJZzVvUzRBSGFZY2hIR01tdGJGaXJoaWw4ZTVNUzNpMHdLdWhoSU9Y?=
 =?utf-8?B?dGFJZStqSExFQmZqT1p1dHpnajU0TktjcktLMElMQ29ZVmpMUFVoN1RjdkIx?=
 =?utf-8?B?QmZvQlRZdWxCdGhoeUtOTEc2d1MyUDgrWkFJM0NITUZ5K1JKSDdNdm1OZVZK?=
 =?utf-8?B?YjlSYmVVYS9taFFUb0xXY3R5VVdMcmJxZElNMS8zQlUzNXBTZHNRM00xUndQ?=
 =?utf-8?B?T2x4V3dHS1paS05uckJ0YVhtTVBRcXN0cWdQaytOM0N1eUQwTkFRVmpKL21t?=
 =?utf-8?B?STN4NU9EQkFybDFoRmI1MmEyWWh2Mzd3QnFXL09SWnlOanVBSTc2dUd5QmZC?=
 =?utf-8?B?alZHdC9rWi9RSDhCUWFBTW9sRmtzRnJxeitIQkxWTEt5VUkrWVA0aEkzRzEr?=
 =?utf-8?B?L3ZGd2xZVkVOVVUweC9Fank1VHRxWndWeXpJL0loVFE2MGdySW1hY1NDMkg2?=
 =?utf-8?B?eUJYSkNicW94MlNyd3paME1hK3dJOWJPR1E3cUFtTzNQY1pUaFlIdkRxY1JJ?=
 =?utf-8?B?YmpoU1A3dVhrd3JCNHYzSW5FM3EyUXczOXoyYXdIWnhIYlA0TDhJNjRCMkJp?=
 =?utf-8?B?VTNCSlYxQlJQTkdsRmFRNWs5eUVTUE9MY0IzRk02QnBNWHd3WjRwN0VheVc0?=
 =?utf-8?B?SmpnM2pSZ2xSazcrc0s4MFltdkRkNFpMY2x3MnpJK1ZyT3hFSFJQek8yMjB1?=
 =?utf-8?B?a01pemE0RExGMVYvRXdhMjIxbSsxOExOVmNhS3ovcHMrUlhlbmNXVkw0U1cy?=
 =?utf-8?B?OUsrSVVENFgydDVvVnV3eUt0WEFNai94TlNhKzk4M1dBanhSVEFrU2hXdGlR?=
 =?utf-8?B?VGhWYmVpcjc2MXNFY3pDdEtvTXg0YnNqSWZjZzRuTDgvMkdGSzVKWUJvYklT?=
 =?utf-8?B?bEFuYzlub3k4MVJHNnBZdytURzFxSzFSVklNTlp3aWs2YXBzMDAvNWJPbXpi?=
 =?utf-8?B?NzFiMEpTOEVnWkFzNURkNWFpTkk2S2FVOUUrVFFNY09lNnMzenBmRVRKbFFa?=
 =?utf-8?B?ZGpVdXBBVjhyYUtLMkUydnU2L2tyd1hqT2lsdGxkRlBRWUpFeENmNFp6ZW02?=
 =?utf-8?B?UnF3clVTREdnVU83WGR0MnlSNno2bE9OeUh2TTR1SENwTGRJTkJVSDVsMkl2?=
 =?utf-8?B?S2pSY1dPT2wyZWdhbUkxVi83OUx4UzdMZFJZaDBsVGYxZWsvTXNPZ3VITnY3?=
 =?utf-8?B?b0VPbm9KZUFpV1QzMzV1Ukc4c1NtRlllNitIWlJ4V3NZMU5wL2gzUkxZUTRy?=
 =?utf-8?B?eC9kdk5WSFo2NHowS2RhVzl6Q1prNlo2VElsdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:04:23.5565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 933f2b3d-489e-489d-c294-08ddea4b25fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8615

On Tue, 02 Sep 2025 15:19:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.45-rc1.gz
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

Linux version:	6.12.45-rc1-g4459b7afd68d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
