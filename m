Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F772DE1E6
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309942; cv=fail; b=j8p+lNDReRtpC9BuUD/KD3GJzsXvyrCKGfon5tzGb3HNwNsOL5JbmtkCwHeShjyDltgcopMlSQAi+V0XLZJAfY6vv8ZSNQewGMkgnXK9Nyqz8bGvGdjTSO2kK5QfPaesqDukk5IkxZsrYXWtZ4f3xpd+dIqY+4RWPwREIdSituA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309942; c=relaxed/simple;
	bh=+lMMHZrvfdTynt0xdpv+3qPPKIyuYvuzQPmS288OAzo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bzii1OCBQm/YPFVSpY+KaFnJftqAOf9zZ+X7ahfqW4xEdspVRZ5+MZNv5OPMyG7k/mCEJHkXelEf7dalUmU8Kr6/bMETOuW/me3FDvrEgEBcTO9inhG+T057tyhVkf2WUxD3SvdmxfP8X6l/uyjeKeLyVCNQNMvhoZhWs3C2E1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CGAbiEM5; arc=fail smtp.client-ip=40.93.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CGAbiEM5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sqNGGeGI/KaWyGAagYTVN4l5fwQeuC/EiPleD+yk4JSpfRqM84uo70fRwgd0gyT2H8k1RqE+OKUSRSP7pu3hXO3iQKIK9O3gkMlem7KP/w7xkeOFD+yj7J0pjpTnDR7PGtYViF2Y9Jz+6izgiQULu8JX0l8its86TntT54yMGq7Yu/5g+zFEU5UGQMHbcbQ0s+8mCeJEM6RegZfWhguJs0woPCbysne5P/79MgpTatZffv+C//rb2aEefc4bfKiXv3e4UDQ0/8LwteVglJwjy/dKemACzHIl1XhJu6+Ot1FlzoPeouF44cKZTc4iKTA1sHHkO7zz3grOEntTEBNQpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UfV4NT2a5GSoq6VeSMfFEDdN4+Gm4L5UJU3J27oO9g=;
 b=BIbJlEcPgzmttbLUdgHDWFJUiL5h4HX3gOdjahLb87nzMBV9tWk99poK2swf003DjDM7lODIz5t6Zi2RnTXwVxgWQ0IfEeZswxXxr1PsaJIoRaxZ4TjINtTkvI8SvoUN0U8Y5bYn0bpyK1PrZsAuVklIfazcYhEVYkCI8kW17GDNK7DThRrKJ/GVqSv2R92XSAAkI8vz7Hlxtipzkrn+4nQZ+q9lS+gvcLbKWXrl4DhQkV7wwOibovR9jpGHIvBZt3/h0R0ZwuCnt+Wt+A8fRpSDnfGv2ZdCmcbbaS02gGaEkgd2HtRpttvdm875PF1QzsP7qrgylZqG7iv20HG4RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UfV4NT2a5GSoq6VeSMfFEDdN4+Gm4L5UJU3J27oO9g=;
 b=CGAbiEM5hNGT1Ggrsq3fS/AnDDV6X3eJxXSvstPfHQ/D8EHaJrs1dw3pHNmfSQE/Ff7qdavwXSnRBtMSOW3MpCmzT9ECKfP+fhbxBuf5ib6MtyTBrMaEefWLIALbzg3e+g30k4DrwIXwt9n83NnnzCcoVVDZJMqBXmS2bDZoVTyj/BhPfN2ZjdZyLMuNzFbWxPzdfQ4KqRnSubF6ABBIu8QJ26pLZDtWBBk30vG/Zk/2lgxCw+4Is8q4s6OG6DPie1G1wmn+/qiIi87eWbwijSLaZqBy6DuDYIf8DRwfxFVQ6T63uNcMDXpgxtxfc57gKlnyJpzw3oK4EqoD6b3DVw==
Received: from BN9PR03CA0136.namprd03.prod.outlook.com (2603:10b6:408:fe::21)
 by BN7PPF915F74166.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 09:12:17 +0000
Received: from BL6PEPF00022572.namprd02.prod.outlook.com
 (2603:10b6:408:fe:cafe::ce) by BN9PR03CA0136.outlook.office365.com
 (2603:10b6:408:fe::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.17 via Frontend Transport; Wed,
 1 Oct 2025 09:12:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00022572.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 09:12:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:12:04 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Oct 2025 02:12:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:12:04 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <feffb20a-1122-44e1-b7d5-1bb2b96b821f@drhqmail201.nvidia.com>
Date: Wed, 1 Oct 2025 02:12:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022572:EE_|BN7PPF915F74166:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bc8dbf6-236b-4ead-993b-08de00ca9e0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2FrNGFpTjAveU5LR053REc2RWNrc0tKM2lXY1Z4OGJidEdYcmRML1lOR25u?=
 =?utf-8?B?Ukp3VEJyc25SbFVpbHA2K3g5V3owWldpNzAyRTIzOENjVXIxZ0R3MS8zb0Rw?=
 =?utf-8?B?ZysraXJnYlprZzcyS3U5d2cvRmtqaFBRU2tubCtQeTlCNlBEWFJnTXhYV2ky?=
 =?utf-8?B?UHpWNUduUFUxRUtwVzFRbHRiQlZnSlBOZ1J6bVFMdXlEeXo2cVdOMzJ6QTNY?=
 =?utf-8?B?ek4xdC9ycmdGK2NkY1NmemMxanlsbHUzbE5OanJkbmZydG52Z1AvV2JMNXJ4?=
 =?utf-8?B?Skc3SE1uekVtQUFzZTQzeU9nSFZkdXhZUTZITnlxbGRSZmVoKzUxWmRGV0h5?=
 =?utf-8?B?d2lVcGVvbmU4V0M0cHZJYk9nTmYrVG1EcjN4S0J1V29IZGpZYjlKajNNVnFL?=
 =?utf-8?B?VDJYQnJDWVM0RFc2REJ1NXdXUi9ueDdHVlY1OVJoa1ZpWEo0eDRpK0JadVlE?=
 =?utf-8?B?YnQ5QjNVZkd3VXhRTThkckJlK0xPaVVlMXBsamRZbGFNU0RtSTErclhMS3hh?=
 =?utf-8?B?Z1Z2c040V2pzZ2FOMzhxcEU2aGRaMVdqL1g0cXNrVks5TGd4eUpRbG5uVnR3?=
 =?utf-8?B?MjE2M0RLcGl1WEx3cEFhS1l1UjJkTDZoYVk5MnlzVzNmZHRkOHFvSXUyRzl4?=
 =?utf-8?B?eC9SY29JdmJUMmtwK0JOYmZzV0k0MllFYTFPdzk5aU5wRVcrOVhxbEt5RXBQ?=
 =?utf-8?B?VmtBVDFoWTdjT1Q2c3hvZHg5Y01kQkFGbGtoYkVQTW9nNTZ1bnAreHcycjRY?=
 =?utf-8?B?MGtZRUZyNm1qYjlmRVlHQnArRFlCNmZvSmtaK0d3TXhKZXhqeEl6WkNWb2pN?=
 =?utf-8?B?akR3bnRwMXVCcDZ5NlYxdE5yVWE4QmR0QUZnbyt5dmQ0cGQ1bTRLSEF4WDQ0?=
 =?utf-8?B?MzVtUXFtVFZQdEEraEdxSTFzcldIQ0RiZ0U4TmxtNkVYN0srbGgvQjBnaTFo?=
 =?utf-8?B?SjhMTDlFM1Z2L2NTam9zblVqeHl2aTkyVnU1ZzVCbHRVL2lRSisrUWxOZjBp?=
 =?utf-8?B?RzJOVlZSU21zWGQwMm1JckROOGFDblBUWWtHL2QvRjZQMzg2djQ1VXNqbnR1?=
 =?utf-8?B?ZkhnbjRlNnIxNTdJL3dKOEhFUzlWKzdwd0Q4OXRRSjF5VFNvZ09iUFdiRkJy?=
 =?utf-8?B?NnBnOTJxOUxDcldxdjJtbXV4S3NaUVg3NGpQMzR1ZytJYjV3L1FEQUpjWStJ?=
 =?utf-8?B?QjhNU2NRQVV1djZySytsWUJxZ2JLL20rcy9ZQml5NHh5ejc0dEJtM0VvYWlH?=
 =?utf-8?B?OWdoTm9WbktscXU1N3JEWVZZTzRRTytmbHVpdnBhNHNBeUVucGl2dXYxMW9n?=
 =?utf-8?B?NzdQMVlHMXd1aTFodUlzQTVjeitFbU5lcGZ5RDBkU2RhM1pKTTF5SG03WnZZ?=
 =?utf-8?B?RkVrNUdJOVErVEhZOVFUdDJMaUpDcnl5ZXppMGUyVGdwZyt5M0hLVDRhbXMw?=
 =?utf-8?B?ZndQcVVFNEI3bmdkMGxIMDRjSHVGcE1YOU5PSFJJMU9rbnhXSjVvbEVlWlRV?=
 =?utf-8?B?MHhxSTBScC8ycThmK29yNjluSlRUdUhSaStJN0l0cEcxaVozN1B1TFV2MDNJ?=
 =?utf-8?B?aG5HMGQvdlUzR2RUL3B5Ky8vWFZzaHZOa1IyVGpGUFpaM3ZmN0d2UzVpOXpj?=
 =?utf-8?B?TjhBeEJnOE9vK203cXgxT2Q1blFVSno2R243a2MyTW5aSE8ybW5wdGt0bnlK?=
 =?utf-8?B?U1pNMUV6cTVOekhWZjc2QzVRMkdWd0Jzd1hCVnBmVkR1MDQrd0NWbDUxRlYw?=
 =?utf-8?B?T3hwdm0zMzRqenV4SlJLSWdhRll0SHl4T3h1L09TZDBodmEwM1BudDBKbGo0?=
 =?utf-8?B?SmZEMHZwTXJmait4YXZXN1VScEZQZVBBSVZ2ak56YTQ5c0FEWUE2TXZ3L3JF?=
 =?utf-8?B?bXFDdGQvS28vajJJbTlQaEFjS0NTQTZhT0NkMmx6azJBb3krZTU1T2tUREVn?=
 =?utf-8?B?UXlNTzBhdWtQcExtN3N3MDBNa0dJN0R4Q01sVk9yV3VIYVhNSUJ1SWhZQ2VU?=
 =?utf-8?B?bWFVVnE5bGsvQzc0dVkzTG9HUXh5VlAzYkVaeGxuQThxNHRYbjlhQ0xzYmUy?=
 =?utf-8?B?c0kxSEVwNXpvbVJjMUFrREhnb0tVWlp2U0M3aUxwL21nZzZMRFVjemhYQmsv?=
 =?utf-8?Q?cMG0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:12:16.6571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc8dbf6-236b-4ead-993b-08de00ca9e0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022572.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF915F74166

On Tue, 30 Sep 2025 16:47:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
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

Linux version:	6.12.50-rc1-g8e6ad214c7b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
