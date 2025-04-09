Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78EF25A620
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185832; cv=fail; b=AQ/wY3wfOQdXw0XRwtMvUBLgcAOs8sOBRIGUy+myU/fDUpPaGH7R+ZGNr/ABi5jT0017xeKCAc7x+0qgY4z9EDkA5R30wlEVtLNKxkYentCq6bfojn3ff0RkXFlxcBcWDDOp02HA6UJh+kMVoZvLQbCwkOtm374lk7+s9jEUsBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185832; c=relaxed/simple;
	bh=VnGnjtv+wJxQpx0amNskXuJinQMoi5Krb3nNuANqbUw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Zkz7pwTX7ssbxSIjOxJ6tNiRVI9KhTp808xOxkPIEed8lvP7XnOblhVxlZLmXh1aGNCRMwOm9M71v9DJDJfZbGNNI/ca3RvFEfkHljrQ/YbSbUVMvuPDlYUut86WsJShaN8LjOa//xn13MQ4XLzRD5uMpgnr/uIrlQqPI3oKh9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I/rycZxP; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I/rycZxP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oa/IdUD+XvW6ye6TJrjeGJ9d5DshaJO3ZXU340bh40zEgD4N6OnVu+yDMegYstOayozEZtnbFtBXTe8Bh0heOcx4YpchMe1QWSnijDhg6a9ZiDBD9fr/DrHHwDqTcyp7WJbkZLTsnE42lqVcbeQNdMHXSfgzluP6BHTa0HFjxe5BN1LWtt/qc1IXAXmBCY0fzt15E6wwyuPDaqywJjH4D8TYFROLvX8cetSSl/CgOWG1Mlbb+8sYC8inGX22h4emdnDgjiW8FVYiz9MjISRjrfzq8V8jEvS50etrNPxJawpvRhw7GSvm8BajTo/IBIrCAmGEUTMEA3RA2uPRB6uqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYh7xVE9Z5PDJmrFYjqYWf4iHzJfUMzbT1W2UIwaiCU=;
 b=PWzcIDoCCc0FNh55XZBNMbK2Siq51KFG+I23rO4R3KbMo1eTkVsMYPlTHepTp+r7aij06zNC69TX2Qjb5r08UgX/WwJ04nWCo9x1DXHIPkq+isUiKJ2OkY2dqRHPj7cEXPVWJ1711LtUm3stHQn1NBX8+fHg1sbJT1EdBcACSJtMV20XlPSZxexGsAlxTdXTv9fSDcei/bvOj0rtYy3mGb4XOq1acVDJ/hpwNYtQthUpDC5mvuD21vfrBnaozSvKzhvEBeoTDx3vami06uTs1b69W4Pz1Q8P7XclEOSG8iStrsNK8N5JcgjldKkR5eYAIrJsr6qxKGDnL0InAWnEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYh7xVE9Z5PDJmrFYjqYWf4iHzJfUMzbT1W2UIwaiCU=;
 b=I/rycZxPBpcGF/WUjGVYwfw5DvP7LElP5ttVXYXXti2b456Mx1Bj9A9AKtUINtxqTbnfoAm0qtWpW3oWjYvSy5cJbc/0J8CgIGet+Pg5twy1hZiBuJh9cUpq1OwEzJ1bxwe4YnpEP7kpZouErJ3+WRk2m1WGOgGPZNeYStZpXeWuBSHb4SSQiZv/MrJBuSCFweQKGMJ0dY6HdJxIpKgJ8ewP0g0VrIbA8TUyjO599Ox24Vi2tNtXTL89bCtIDqUvQOMVKaHpG4oUr9NXTZ+UEYXhafD3cgdHlHY5CM37JnivWZ8HfISnjQu0aYY5O1VcgTCZnHijH/g2qkHbYfaOyA==
Received: from BN9PR03CA0363.namprd03.prod.outlook.com (2603:10b6:408:f7::8)
 by PH7PR12MB6466.namprd12.prod.outlook.com (2603:10b6:510:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Wed, 9 Apr
 2025 08:03:43 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:408:f7:cafe::8b) by BN9PR03CA0363.outlook.office365.com
 (2603:10b6:408:f7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.36 via Frontend Transport; Wed,
 9 Apr 2025 08:03:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:03:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:03:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Apr
 2025 01:03:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:03:26 -0700
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
Subject: Re: [PATCH 6.13 000/500] 6.13.11-rc2 review
In-Reply-To: <20250408154123.083425991@linuxfoundation.org>
References: <20250408154123.083425991@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <04308975-fcab-4776-9298-762f7af8a26a@rnnvmail204.nvidia.com>
Date: Wed, 9 Apr 2025 01:03:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|PH7PR12MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: 4663d501-afb5-46af-e20f-08dd773d0b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWJXV2J5UlZ2eXIyckNxb2p4bEMwQld3aXZNTzg4WFQ3c0Fsa1BVSmV4UkU3?=
 =?utf-8?B?UTdTc2ZQb29qelV0SnZOQkMrd2k5NjYycmFaeENpeGY5SmZSQWtRL0xUd3Ny?=
 =?utf-8?B?NnpycHlNeWl4Unh2bU14ZGMyMjVtQnJkZW5PTmlGS1Q0aCs3bTVIVVNLOHNh?=
 =?utf-8?B?eW1ubFVJZmFhSEtzY09DMENLVCtZK1RzYk9JMHpFK09PaDFQMXVrU3VOR1da?=
 =?utf-8?B?MjcrM1N0U3Z2VnBiYWV1R05QTFJQUUhjVEZ6RHowNlZXL0VWT0ZMV05vQStk?=
 =?utf-8?B?SVcrOU5UR0R2TVhwNXR1N3RYaGk4K0JONUZ4OEw1TU9wNVdXc2RhWHJPTTBp?=
 =?utf-8?B?YUx0akppUWpueExRZVhzQ2pDRlhXNE5iTThZS3NsZVJkZWZrM0tSMStIeklW?=
 =?utf-8?B?MEw5b1ZMMEhyRjk3V3hrRUpkR3BRdTZod0FHNk1mbTh0RHNQcG9ESzVCL3gv?=
 =?utf-8?B?eVJzQ3JPcmRBTXVGbm1oL0xFTG5RSFdWaXRQWjQwWU9ReFRBVERjSEI5eHhj?=
 =?utf-8?B?NTd3Qnl6RnZYb2ZWNmlLcDBQMVJ2YUdNbS96ekk0YzBSd2pFajRBVVd5SE5Z?=
 =?utf-8?B?OUQ4K0dudTQ5UDZwdlVxRStCb2FaaitnN3JaU05HSWpNYStSNVhVdHQ4L0JJ?=
 =?utf-8?B?MFNLV1JoVUR2VFZJZ1oxcElqRDJLVTJubzQ2bFRNR0p6TUZuWXdELzZUTCsz?=
 =?utf-8?B?OVZPSXpjazQ3MWR6b0Q5OTFqOFB1TEExZFFDc0Radm1kbk9jN01aNUY4V0Vs?=
 =?utf-8?B?VVE4K01KWk9TS3F2TFJ6UHVkUkJOUnB3c0FIZDE5alhZeGluV3oveXhBejlZ?=
 =?utf-8?B?bU1ndnNkN1FaY1NIZHN5L3Fub0ovSUNPNjhZY0hxTTFGM3IvQklWNnRDejVI?=
 =?utf-8?B?TW9WZitjbmlQNmIrdm5kaSswSGRmZUZxY2U0Ymw5MGpUL2dWNWNsbnRZYWty?=
 =?utf-8?B?ZGU0dzN0b29kTkNlWkhyaFRSSDJlMUZkUnBPaHM2ZGZFaXE1RktxcngrQzJy?=
 =?utf-8?B?bWhtZkRrVXhWWUgvZ1psUzlLNEhDUTVKRTNmWVh3dGxaMFphVHJ4azFTLzhw?=
 =?utf-8?B?aVVHOENaUXZRNEZLaFhwVkZRanZXZFh5S2piU2Jpd011Zlk1VlZOMXNDUWtS?=
 =?utf-8?B?c09DSGtQNkxzOHBZeUN2Z3ZGVTN3TkdzS0xXUFEzZG1XNlRBbzVaL1lqWVpO?=
 =?utf-8?B?OHMvcVhnWjh2NkgyWFN5MnFNQWZ1Zld6UUFhbVNyRWRnQldBS2FvVS9LY0h3?=
 =?utf-8?B?alFUeVhVN1ZaMkJ6eWZib3BmMUpqTzU0UThyMFJ3U1JuWC84VVJHc09LVUs5?=
 =?utf-8?B?bXh6REhaZExYWHROUVFQTVV5VlJxODR6dnJEb3hWVkpOQjIxTVBkalIrOU5a?=
 =?utf-8?B?U1NVWmdUS0tMNU9MdTlVcmFtaFVpcTRNbWtzTkVnODlQODhPYnpFZFRWdkpZ?=
 =?utf-8?B?d2szdlZIc0hRVS91QkR3YnF2eGJrcWJKdGQ3T0FFMlJqVHJmUW5KL0htaVpJ?=
 =?utf-8?B?bkZaL1M5R3dWTXd3ZFVrR21YcXVuSTdnUzU3VGM1U0FNaUdQUlBBQVp1Mmhl?=
 =?utf-8?B?MkxhRWh0ekNBemQwS0ZBTmpZWUtNdm82ZHpSYkRBUVhtdFJrSDd5WDVvTWFQ?=
 =?utf-8?B?dk13NXFSY3N4Y2tnYnNRdTRKaTFCLzNWSHRYV2NOUUV5MVdncnhEdlNyLzVv?=
 =?utf-8?B?N2ZJeWt4L0RDcFY3LzVTUUlzdk43VzA0WnozbjZBNmg3UTVUK3lCZnhRaXF5?=
 =?utf-8?B?YTFWaHR3TXQrQzJ3Y1p5djZNY3FyWmw3WkxZdGZvSmJHYUVXb3h0ZXhOeU5H?=
 =?utf-8?B?SWM2RGIxdzRrM0tqZndJTTdKa2JzUDdyTXdkcnQ2QlN6bWZreGlSOVNDVlpT?=
 =?utf-8?B?RTR0SzVzdkJ1TCt1aEF2dVJLcDh6bkQ5RC9HU2srekNSUm5jMFBDUFFIMDZv?=
 =?utf-8?B?WHE0eGtHdmJWRVFNT0lnanVMb2Q4Q2lDYVhaL25XL2pSR1Q5NStKaXJnTW9w?=
 =?utf-8?Q?XFbvW6ZByO1lzIVzhzGOrCJDJBU/tU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:03:42.4244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4663d501-afb5-46af-e20f-08dd773d0b7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6466

On Tue, 08 Apr 2025 17:54:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 500 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.11-rc2-g45ef829b9715
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
