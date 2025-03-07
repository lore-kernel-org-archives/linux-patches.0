Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F54320DD48
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 09:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741340860; cv=fail; b=ALUUdbWrM4TvTQ5cglFCJCtpGeS13vpmIJJVdi9BiJ4qKhus++4CrbUr6mnvMBhUfrJeru6cqVzBLV+u1FiQHyEixD89u9ChINDxbyEZ8BWgWjq1gconzSv+3Y/jXgtDuR3Eiy0Lj1PByYyC3dt/uDz76yl4yLAk8JZhionSLW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741340860; c=relaxed/simple;
	bh=zohIZbnFFc+9cwz5xoZx6LVsYWX7ryVCWMMhnJFrtP8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bbffay9OtWOjjhGL3KL5hKYcBSHCZewzyLKr8zVieBM/f/UkcnNaovMUHPL/0XvpDWmTW7PYswoCB3mfQnPjzbtLqUOg94Snt5J2QOdINR9ccEZYID7vDM6hs1RTPxij9xafbDyCOgzBnrX3eX7v94kn6bLjZQyPnBG0zpSG7oE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YOMiRY0Z; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YOMiRY0Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZGW+J3Ku4Q4yKS7jzoCw8KlrArz008VQEdcRGL+Daino8pzMfud4mphrzQwKu5BEMo7fB3DVB3miaqVV2wmwV/JdhT0PlpTMdezzxPIGIFQvPbmfZryCkpqxR+SERvngmGmROJgdXwctfJLiCUqKtAlYXTdNgYNCS1gKBW4hXVhoagE9AXdXkO9A8xdJBu5L/QSLS0B7IJiCrI5cMoFqQZQWNMrHf9M4znwQPUvBaEQXxB4277tfeZNngD2WosrXTD3IzLfVIIT9gZHk8MmNs2wwXmTZIBcijuaJUszoDqqYRK0e+r2vTxBRICtnEDehxHHZZxdcprxq1W0b7nLMOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAHwFZ4sEUqxJYyDp2jRzs//3mvxr8OtU68PMvTWfXs=;
 b=hKPDvKgUl2a4DGxnnvGTX52LyTC/aTYrfIthkJ5g3oIGxqswqwF530RiKLKmT/5alJxzY1ah1XZI/obF9KfTx8koLhezc0/kKu+uLBaWJFjPkoKEJjwnt+574K/UdCX+k+S7htMXldLdF0TAU5Epr9Jd2RFCFA89MlAv2SALx0g6k57d5W0lT3QeXhy93OqlkhjtDGQf2h57DvW+uRXxj1B91kllDWSPQQBamlEDgvlAssSXIXSBMntkR6tkeRkDaONBQhqoGtW+zjelCemoMfPUJSs0Qe9TZbvQU4xMFlSkyEaihpE/mPtY5OjK4pDYsYFt7785Baj8Q3oYkuHVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAHwFZ4sEUqxJYyDp2jRzs//3mvxr8OtU68PMvTWfXs=;
 b=YOMiRY0ZtNMAWc5CSwlY1YWtiDWtI2Bc46YjEWOhPyG9xLorMudHuA8pQpP/0Kr+W8YDW9d/LDsF1s4f4U7fcS7Ifed1mv4dCbIAi3EuIzfa0wXIfkOONQP3X1gH+qhON+Y0dr4sv8jTKX4JQrNAvpGVLG074UubBzMLMOrS2JdQEnVBOeut/Iiob54JNTUsv6KPEPOm7dP9lFnnzOr8Muk1aH1MGbSATZLiTdR2w4yegqWUvx2ei+dwyiYEZ6LgQyVRa6wIJFfWsMxYBRqiAzYK7S94+4WUTigBJ1HH1kW2scXvJkHVYybzFEnQvwdDf9WBW+YbLaUeEZ8j0snB0Q==
Received: from CH2PR03CA0016.namprd03.prod.outlook.com (2603:10b6:610:59::26)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Fri, 7 Mar
 2025 09:47:35 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::5e) by CH2PR03CA0016.outlook.office365.com
 (2603:10b6:610:59::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Fri,
 7 Mar 2025 09:47:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.15 via Frontend Transport; Fri, 7 Mar 2025 09:47:35 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Mar 2025
 01:47:22 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Mar
 2025 01:47:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Mar 2025 01:47:21 -0800
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
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
References: <20250306151415.047855127@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e2b0de0e-7a84-4a82-86b9-0fe4b1a2409f@rnnvmail202.nvidia.com>
Date: Fri, 7 Mar 2025 01:47:21 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|CH2PR12MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a37af0-0fd3-47d5-8bf9-08dd5d5d16ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE5UT3p5c1Q1dlI3VkVHSkJUV1NqbnBRdmJMRVNrK2FCNjFCQXVpdVZtYWtC?=
 =?utf-8?B?cmFSZU9kQnBRazBuMEpZMTBqQmF6cllCako3UzVGbHFSa1RSUmdCTGw3WUNO?=
 =?utf-8?B?ckhzcHRveXZlVTB1N1dGem1RRCtNK2lhN3A3ZUJOR0paYWFpL1ZYSXFOem1q?=
 =?utf-8?B?eTVwZmN2cEN6SmtzakxpaXgxTGtyZnYrTEJFbVl1MXJTNERsODhkQlZPd2Ni?=
 =?utf-8?B?V1dzM2Q2ZGVnMDFYcUwydEI0RERzRzBHNDZsQ2NNRnE1c3lLWElnS0xwTmgz?=
 =?utf-8?B?TGVoSy9FYkRaSlRHSEtZTmpzTE5sZ3U2Z3ZBSFRnR2pLZjNLZDBiQzNIazJx?=
 =?utf-8?B?NDh2UjFnbEhHZW9yVnYvOXVYLzRWaHBDbStHUXlyUW1xYmVZK3Q4MHQwTVRq?=
 =?utf-8?B?Q08rc3YzRFUxbVpHbm1seGhPdE1wazFZOG9IVW9pcTZWNlltTXI5SUxrR2ox?=
 =?utf-8?B?cjFubVdDWjd1QkE0cVlYK25sYmNqQW81VWx4UGpaSDl4MGtCWmlvaksrdEtX?=
 =?utf-8?B?VkNMSHQ1ekI2bklBUG9BOXVpSTU5SHBHUGtIOEtWc0p0d1BKUUR4Q2V2NFZp?=
 =?utf-8?B?eS9UazVCOEtrZUVmbGhsUEQ1b3JwVHhGcVJ3STM1RFNsK1NZaGNnZzlYQk92?=
 =?utf-8?B?Skp1cWJ4SlNZajdwOEtvSUtiaElDeVJ1dU16bC9pQWp4MTZaV0RSbjFwZ0k3?=
 =?utf-8?B?U0t1UEhIN2FKZWxxWXoyZTFlZ29MTGhzTGlwSWxRR0VCSjhLVU5oWG1Hc2wr?=
 =?utf-8?B?cTNpVGEvMmN4VmJ4UXBJRndsbVZSL2tLNlNNQlBmbURCK1FXMTdqTGRZZEJq?=
 =?utf-8?B?TnlaclRxRHh3WW41dGVpMk9DK1FTWHpBM3RtU0FycW5nYUFWdkZpWml5S2d0?=
 =?utf-8?B?MzZKTWpsVFNjZ0lqVUZmaTNERzhXaU9EUFJKWHk1N05qU2JuVXZNMFZHVHhG?=
 =?utf-8?B?dnl6dkZPWk1maDk1QnBBNWlKVXVsejVVUmFiK25nTktRNmpGYVJiYUlNMEp2?=
 =?utf-8?B?eW9FUWxFbGJnQ1hUa3BQZGE4ME44UkNnVWdOZTZySW9XRFV2SUI5amZGZU80?=
 =?utf-8?B?TGhJenRDQUVuNXhhODA0dDhOc3QxeEZudWdEL0Z4bzZQVWNhUUw1NDBFNGw4?=
 =?utf-8?B?Y1ZtU0NhZWdHV0J3UUhzYklyaXF0UTNOMytLTVB2YmRBbnJwckhBSHZMY3ll?=
 =?utf-8?B?WE5uWEgxQ1RUYkVQWVh0dkRxdktDaEtQTjVmeHhtZGVUOWZ0NWRXZGgzMVRP?=
 =?utf-8?B?N3dhbVkxakdEeVN6eTUwcTNNSkVoNnJINitBQThwZUs2MHZoYm1oT21xdG9o?=
 =?utf-8?B?UVd4OG85VkdhNGwvZW5kbnI5c0tWWm1mWnZVcDhVSS9RVmI1dHVNSDcrYWlx?=
 =?utf-8?B?MFlHZnRpbjFIakFIN21DVmhGZm9ma1IvbWJiWHIydGp0SS9YNVlNSHNrQ20w?=
 =?utf-8?B?VW9NenZSKzNFQ09RcmxUdHA1Vmh6MmJnOWtyb1JCaHF2cGtpSmsvTlhzcll6?=
 =?utf-8?B?eDUyaC9hSnhqSUhNQ251eTdMT21YVEVGbHZOemdTZXN3UkMwRFJiMW1CUC9n?=
 =?utf-8?B?dVh5WDN5MXRodGhWdHBldGhDWHY4U0ZHd3E0NCtTVUVOYktxb0lyaGtuQWQ0?=
 =?utf-8?B?RktwT2YxYzZxYUlHTnhJTjRSblNaRzdSL1doc0RjQ2lvUmNXQnc4ekY5ZTlM?=
 =?utf-8?B?SGl6Y1RSWEN1TWNHa1ZOZkFDUkVLRzN6VkdsY2I3a2Iwcy9FUTJvZFRZNXpa?=
 =?utf-8?B?YkZNZnFTT2p5a3Q0Ri9iVDF0SHFRNGVmWHpDOVlFUkY0WmtqU29Oa3N0ODBK?=
 =?utf-8?B?VW14WXhDaGNhYXI5NXZFZXhSYkZlUGRoRHJMZXlrSlJpckJ0Ynhpcm5pYVlD?=
 =?utf-8?B?eFZXSjBsZjNIQkxlZEE1eFMwWng1ekd6cnA0WHJoaW9BTlFVMndpTC9vQUMr?=
 =?utf-8?B?UzJPaGZ5Z29RcVlBZUIvbFNSakpDMXZMMGRVbEVlYmJYbnNDeGFGQ2gybk5U?=
 =?utf-8?Q?sL4FjxqWFjwGWx4FDssY3MdN8IvLbQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 09:47:35.2677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a37af0-0fd3-47d5-8bf9-08dd5d5d16ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245

On Thu, 06 Mar 2025 16:20:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc2.gz
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

Linux version:	6.12.18-rc2-g7d0ba26d4036
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
