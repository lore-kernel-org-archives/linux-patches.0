Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A4158D8F
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718824781; cv=fail; b=G41P+WZeDepX5zk/JVxB0Ihcfk8zsiRhYgxcd2/2Uv7h0foI5AuvVBlZ+0tQi03M8xcQhGqLkfV47M/vPYxSc1E5amonxu2a3LWHLxIMV6L6zeMPjm5Wnn5CsXJjw25do2PjBN6VK+aVKP2d5+amYWwE+EHtdwL0M3RYxugVYLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718824781; c=relaxed/simple;
	bh=+VDjMoTvJg5ybenHUU4JUt/uTphu1USvn1LfHQLn9Pk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=uTycz2Sv8I0A3pPuuntkqRPGoj7uRsWWogKzo724sahosTdtkWDJ1lc/vL/ZFIO1UvtIdw0XpNzP5bwXA1FGmU//sO9CuZbvJad9HCLGs7SZUPqXHb0qNQKcVh0Zo8n+fFreoFAWN2+2kyZygi/bPl3eW84ifTDGy0b5j+zDCrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Kk7jAjso; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Kk7jAjso"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6EJ/Klx4c14K4B3YKVw48FfHafK7IRyZ5UIC3CGC7zRB15eEDi+qNg6KLHnIdbOwMXR9D6PcgcYLDWvFZi0xTeNc/6NqaNeVOVbyqsQ7AkGxfpSrS7yZjEBOYxbpKXmJifys5zajao/eEnZXQIsg/7Nq7a3mIgjzFNqXs0p9D7/9fx3eMGemfoPpzQ8Ag35tkRSDBJZbYtak9RTjMhK75wzlwKtinkFZtDA7UbAIjiNPgsJSEM5nAeheYMUrWT/Oooq/bwkiXmjIx41znVG87Gxa2Hu3UATP6tx3t0CwerXWF4mdUq8/edF2hqH1/zXR4Tnl2nmk37bMuZO8lVecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UR0Z+ZNsLp1kU8M+cXbuYSuwJo9RhNXd3ZI/k9VJqMw=;
 b=NRPyxM8D4ab+gADKjZkEz15aBWHBYIiuCY6QpK2e5DyfTTxnsgcMm0YN+yvRSy8ALAIKFsgQ0+8kxwAlb6AxPs77V7aijToFZ8C8wCyJyFYZQ/tuvxaEdiq4Eq/dFQ+5mj9rRG5MjWxrLmy7CK0DqbrG16NZmcS3WdhKknabewRkd2yPrB+bmfjd4ge3O7LUk58Z6dm4hNJ2rxUAbHfZtlu2MvZcVf1j1GHcFpAh9Xka5hima1sYkqQ441jjRiu20SySbPzXQ81PwucSMokeqqsSLSh0klwoYSW0tOn6YfqS083ihJhT7xGh2dQg3FdLQOMTEV40Ydc6sqPkihmWgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UR0Z+ZNsLp1kU8M+cXbuYSuwJo9RhNXd3ZI/k9VJqMw=;
 b=Kk7jAjsohCf2uIME2P/ycth+mcQff5JFyClEjXoWWjteeu27SVTVa+V92VFj+94bHYsdiTqjtthEW/eXbLAO0ITR7Gen7j8bRaFYHonZbCIYmC3kLc6HuYwiyTQYE+WhF8qu8ZZP82Kg+OlnvkOPXt1F1mGNpjqCrQHnU3+LhE/pgF/XarLaEFrygi2Mwfoi3S5+7hOJ0MYffMH60abZzyzDlocbypgMdU2/A1wxijrnnDzLg7qKOgkycVjDzt60JAl7AUA7RW9UptDsinJzeD2FTwhCchP753n8iAIWIxeVwl70TFp/2PHunWlcWTeSro9U0BvTM4TG/rLdIPf74Q==
Received: from CH5P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::21)
 by IA0PR12MB7578.namprd12.prod.outlook.com (2603:10b6:208:43d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 19:19:34 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::69) by CH5P220CA0003.outlook.office365.com
 (2603:10b6:610:1ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Wed, 19 Jun 2024 19:19:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Wed, 19 Jun 2024 19:19:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Jun
 2024 12:19:21 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Jun
 2024 12:19:21 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 19 Jun 2024 12:19:20 -0700
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
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <18beb9e3-2187-45fb-b30e-b5f5a5d9742c@rnnvmail205.nvidia.com>
Date: Wed, 19 Jun 2024 12:19:20 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|IA0PR12MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 17671b96-b7ed-4f3a-ceb2-08dc9094c07e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|36860700010|376011|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3E1SFBYdU1ORVNXM293d3Q4b1k2SVgvSDR2eGFyWU1TdVFXWE9rczBXK2Jl?=
 =?utf-8?B?d09QMER6WGV3bS9jTktLVVQ5VnY4NWNlWnNtQ2xnRzNTVUZzSmhuTXlueW8w?=
 =?utf-8?B?VFFiZ1dIOVZxcGRIYU1sOW5Xa1dzcksyKzNZN3BoNHFqZHJSVkJkTXRFSm1j?=
 =?utf-8?B?bHNvZW1NeFRtTnZmaDNkY0ZiZC8zNGtsR1B0N2RPRlpiSXdqeW5Vamo4TEF5?=
 =?utf-8?B?bmZCK3RmUXFzc2YvMmxzTVZ3ejFQRWJ1ajloLy9XaUxCU2xLcWxOYnFSd1Q0?=
 =?utf-8?B?Y3hqWW4yanIvYzdFTVlvN1VOWHVoQk5za05iamIyWUxVRDdEdEVRZ0lyOThC?=
 =?utf-8?B?TUMweHZlYmtNTXNuMjkrYWNMTVJZSlUxOU14WS8xWkZrY1NNTFEvMjJiMEJ2?=
 =?utf-8?B?RStZN2JmemxUWnJ3YS8rVStWVkFaUXVGeTUrTDA0OEFJQ2h5QTF5ZXVrUTNR?=
 =?utf-8?B?T29jOGJubjFSSGd2QlRoM1psTytqbEhUTzJTZEp3dkRPYngyeEJRUVdPVnh3?=
 =?utf-8?B?aGxFdCtIZXlyWjcvKzNZeUgzaGJoOExkaC9ZbS9WMHcrenZOYUhhSTZZYnhS?=
 =?utf-8?B?dFJ6bFdkMUpoR0lwZnZLWi80WVRPMEdKV1dYQjFpQ1NTcmg5VVpYWVpJSmJt?=
 =?utf-8?B?dzhZTDh5UHpRWGFOL2sxM1djYXl6bVdtS0paNlowOU5ybDRvMGJ3bWJ2TXZq?=
 =?utf-8?B?TWhTR3picE1melhua3QyRkc0TjdCMHpnOWlrdDFCSlFxdHc1TGxzZ3J3YVhk?=
 =?utf-8?B?NU5OQXdkRWlSeFd2bFdaZGtETWtLUlhnZW14YnZvZzd3c2V5NldpS3ZWellD?=
 =?utf-8?B?eFZuSXJwenN2dE03K2hscCtvNnEvekdCcEwwWjdXWSt4Y1hmVVNZaXJPZUVX?=
 =?utf-8?B?cHM1cjFwUTlQUm84YVRYOU5vZFJTbU9mVEk3RjRPUG41ZlBDMTY4US9TaDgr?=
 =?utf-8?B?bWdJUjJrcjRLbUhLem55Y04rdzlINmticEdNZ1Y2Y1NBcjZQZGllNk1RR3Fu?=
 =?utf-8?B?b1BkWU12NGdzampUR3A4YllKZlhJYVFkbUpBUjRaVnB1VU4xb0krRkZxVHVu?=
 =?utf-8?B?SnQyWTc2NEdndUIvclVTOFZGNnFFaWJzM3gzVzhMQTNmYlJYSXRPWkFSdXQv?=
 =?utf-8?B?SS84SDA4eml1RVR5b1h3SDltT2djY0RUL0tsa0hLVkJtdkpGZ3ppL0p3cm1R?=
 =?utf-8?B?UHdzc0ZLZC9wQ0dIaXNGMnVKb1JYYVI0dHdReHc5bW84SmVEbkVzcW9OVHNN?=
 =?utf-8?B?c3VpbXQvcnRETTlGTGlrLzF2RDkwQkdVZlcyTEduWUtLN2RJcjY5aVVvengv?=
 =?utf-8?B?RS9vbmJJVkNLbU9hSWYybWptOGd0dEUzczVjUjdKQmdNNEYxc1V4cXgwSkdW?=
 =?utf-8?B?ZFgwK3hXeGtVYklmNDNZbWpwMmNLa3pZbElhUVc5d1cvVjc0cmdsaHNOenRF?=
 =?utf-8?B?OUcrbVBkL0hWdFY2VlhWNlVxcjJ0cjF2dENnU1dNWjhIRVlOcXBGTHI4WTFG?=
 =?utf-8?B?aGNzRUcxQW9zbHFWSFhSV2JJUHNVdEVmUUQxdG9DMTVkZ1hDV2hLM1dLZ1Vp?=
 =?utf-8?B?YlpPcnR0K3pYd1NPdjFnNGtqSG56eGFDaW9mcEhPbUZKUndpUVNNcWFIdjlZ?=
 =?utf-8?B?dTYzSUlIMnhkMWVQSklXOTA4dlZtN0pKRHJLYys1MWE4RkZYSlBZRDBuSFlX?=
 =?utf-8?B?Q2xjMFhLNHF4Q2NXbmd1RWJwSDRxOVprMEVHUFlGLy93bWpROHpxWDdiaWZW?=
 =?utf-8?B?ZXZBc3NUZG92eHFwajFWM0pjYUxlUUl0bmhFN3NLcHE4YlpJM2F2UXdDRXp4?=
 =?utf-8?B?dW1IenN2TU5IQ2dqdVlCQmxBdncybHVneE1VWFo4N1AydFd1ZENBeGtlTnFw?=
 =?utf-8?B?STQrMk1qc2RxYXI5OGc3ZWpibTBuWTNDdUNuU25ERStaT2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230037)(7416011)(36860700010)(376011)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 19:19:33.6831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17671b96-b7ed-4f3a-ceb2-08dc9094c07e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7578

On Wed, 19 Jun 2024 14:52:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.6-rc1-g93f303762da5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
