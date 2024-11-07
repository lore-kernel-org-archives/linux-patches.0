Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A99A2101AE
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987034; cv=fail; b=BpvkQH1ytOnZzTeDSJWFQtTq3Vzohzda0n5qLnu+Z7wgOxELQcgmccvl6UOYkLEKM+p2w4eY4S/rhHFrXFy8fafZxWJxqp7hAPosfIKUTzZmkBZtRDPb1cpr6AmuiSNXS1ZQCfkMDUjcUX5SegffWvyAcSC+LYu/pF2lD1L23HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987034; c=relaxed/simple;
	bh=rVGfOBx87PZBHDC3JtdCzNJ6S6JNlWHR/m+7WRtIuDI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dQu2qj1t9PHXxUqyQ9JLWx7pNXhQPQ2dNaLZHNndra0ww5W2ZToN9zOL5qqZh6Dlo88qwtdDaed1l2QCDHRguv67p/dIkUoTwAijyfHEAfC0VdJcJy15tNXF7jb7GP8G5HM5KO0/D57THC12bT0+VfiuEvX7K9XksPPmP7BbxQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o1gua6/M; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o1gua6/M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoexcJCiZFTDnNQQwADSJfI2G3kAqK0GcwHb92bFxGJMzZ/iPX2WD8oZ7DQQCxewbNKZX9iQuqm/LGuXslvhqDpM5myLYECbjA8yeKogz139d/aXojSrjnzfJM6y0PlODZhKW4TuKTWWS+9J9Ros+HczidQOhCsSMNW5Nk/V3CXAdbO7OilQk+yeH6Bx4k6neUiScQMI8jI2lGYKvGZVCj/FOHV4o+AEk2qgUxcFh75s31I/k2weuknjphhBze67VfnDJxzxipPDGRs2d0YT3ijw4mdzUlJj7Rd7DfkwJWSGrhK7vH7MjOKV5qOqDJASafEnBqmOhr4nUtfhn7zc7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3wYJkMQ1bzqup7Hur8FCcDoOm4rgX8eAxlPnUDjAIc=;
 b=MwOSOfZsjzd9Dbupn2C3L8VkV0wccgYN3n6GzyhGYv3fAe5tkpy5ouVFN/Vo6Tqg0NU8G303Ry8iQhY9m0WwEh2+gtf5p5LoCHfLV33UwOXr6psdbHNs6/Nu+4rJzVRoY/33U2+03/1VitosHhY4mBtMp1s+MW7j3HdnVAxZh95F2UOTnf+uXlm3Y4p64gBTOxfAuY1H3nExpYzWfljDVbLkCAbe03S2gPe3/8VybYqSxJBxC6tqi0uQE3a8HTyvgYMval3G5FmibNMaHtCDghaljlGK2uRKHHny6LDC8IKfOHsZrfn9q/tldKikcnokNEKShEs8BubhyTnJx6nHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3wYJkMQ1bzqup7Hur8FCcDoOm4rgX8eAxlPnUDjAIc=;
 b=o1gua6/MFts/Xaf8rHosAwJnFSwyC4NmHqmD+BH/sJRy1BHttu0eOr4l4+tih+ZGSPfKYFSaQ2q3fdohNt3dCA+sRGLRvL4HZZ7ahBzteh9BmJd6M8ev4siPcuemXSupdwYKekPDetrq8rONo1XAEL+KoW3ZTqcIRokDY4y1BWjUBCE3YCFKcYRpsf8auQeqkLAle/BwhnbN255rN3xVWM0FoAfd9FPkaR4sUPkhaJ1GCqzj8f5S/E5Yc/s23byC+uZOcDPWNdQR55ShXpqZaiSYjSvEiORe+K51q4txeoFbERy6lzgT94YCpntbeZyGbNHFXjF81qt64Ug05NO0ag==
Received: from SJ0PR13CA0066.namprd13.prod.outlook.com (2603:10b6:a03:2c4::11)
 by DM4PR12MB6398.namprd12.prod.outlook.com (2603:10b6:8:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 13:43:48 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::f7) by SJ0PR13CA0066.outlook.office365.com
 (2603:10b6:a03:2c4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Thu, 7 Nov 2024 13:43:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:43:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:43:32 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:43:31 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:43:31 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/151] 6.6.60-rc1 review
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5d20e45b-ff2e-4dfc-9c3e-6bff0d74b775@rnnvmail203.nvidia.com>
Date: Thu, 7 Nov 2024 05:43:31 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|DM4PR12MB6398:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4a5d2c-5eb7-4532-c8a0-08dcff323386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UVhRcmFURXN2WGxoblVJWFVSWFNZVlBIdDIvN2ZmK2pLQVQwa1pjOTZLMDBo?=
 =?utf-8?B?V1lPdVI1ZHltUUVXME05Yi85dGtRWG14THljTFgwaVlLeG1iemlrcFVHWlR1?=
 =?utf-8?B?b3NrY3NtTDhrRmVaeFZDbGtscEZacVo0bXVmbW1rU01qMHJWTnhRaGpSSlYv?=
 =?utf-8?B?cWRIRkd5QVNZUzBRbVpkc1hmRnVKQThCQkdwUmxFY3FHclpNQmhZT2RBZ05I?=
 =?utf-8?B?L3QwQkhycERmaVljVEljUWNjK1NpWHNaN1lYbzlTNk9ac055QmxKSnVQMEhQ?=
 =?utf-8?B?L0JyYXVnTnVSMmZmMExjRVBsS1lOemxqOWs1ZUVBSGkvVjlLRE1jdmhjdTRT?=
 =?utf-8?B?S3VnQVp6MVk2YjIyUEZMSElSSWF1RE1IeUZ6dEtXL1Z5bHA5eDlPNy9MVkRD?=
 =?utf-8?B?bFpoa2RTR1J0WjdtWUF4MzFwbjNTM0Q3SXA3OEs5UTkvWU43clh0aXVFYytF?=
 =?utf-8?B?R0pLSnN6Vm45N1Y5UmN3YjR4N2Z6aCtlNnVWQlNiODk1ZkRRZ0psYWpKLzF2?=
 =?utf-8?B?eE40eExobWo1Yk9XaWNwZnRvS1FDd2dTc09xd3JObmNZeEpET1FpR283emw4?=
 =?utf-8?B?SjkycEpud2o4bUdSMkRDNkN3cm5OS3MvbEZ0UC9FbEF3R0l5V1RYY2xvZFRh?=
 =?utf-8?B?UFo2VkpsUHd5S1JxRkMyZWQyUlk4TTJTalVxcnd2bi8xajB3UjJEVitKK0py?=
 =?utf-8?B?SzE1dmFhK3R4d3RmSEozeHlNbkkyTnZ0RGhOUTdRUFdmc29kQVVKZVVpQS9i?=
 =?utf-8?B?cTlpRzY4cHFUZWtrcEN6T241ekoxbHhpY052VGNXUlBCcDE0TWJHTmk4TlBa?=
 =?utf-8?B?QkJWclYvV3BJU1A4SXg2MzJGS2J3S0p1QWJIbXd4eCtJaFF5WEUzbGhNK2hm?=
 =?utf-8?B?Y2JzMFFxcUQ5M01NTENvYTFGMGNWWE9scjlzbk9MQU8vcmdxVWViMjNlcTJK?=
 =?utf-8?B?N3dYL1d4NFEzOVBES1pqNGJZd29YVUJyZGtINFIrd2QwRXhUNXB0TWlhSkpn?=
 =?utf-8?B?SHdYNDZWczllRzVtZ0R4NE9URUFvS1Z2L29sYyt1aUp4OTh2U1p1eWwrZTIv?=
 =?utf-8?B?L3hHTXZGSFhSNEpodElUbjRSdnNvN21zdXpVY3A0MnF3dk5ia1lKd3J3RVdK?=
 =?utf-8?B?VVpoZW45dlZrdnVEaHJUOEdXNHdicDJqOC91RmRiL1hNREVtNXZwdXRTNEIw?=
 =?utf-8?B?dTUrbUluRG5pUnU0L3hpNTBuY0Y1ODNGbE8xWEhmL3lFVUU2QmR1b2I1NnNG?=
 =?utf-8?B?bFFzS0xmdEVJTnpGQW1wQ0x4cWpXVi8wTThtaE5rRnN4SnEzVEEyeFhqYmJO?=
 =?utf-8?B?bG1JUWF2OVJNNlVTMkx2NDd5MkVXUTkwWWtpVlhEeGd6TFJPbVZ1em9oRlBW?=
 =?utf-8?B?b0RHVVBkOGUzRkYxeVBKNXB6MXdxN21uNDFqSXk5TmRQWnh2dlBUZ21scExo?=
 =?utf-8?B?cy83VVdtSlVIdlU3Um54NVhSaTNWT0E4SkZtMVlNSTRGaCtRTmhRRGhweC9M?=
 =?utf-8?B?byswRWh0Yk04OWxmaVNNZXcvVjNwS3Y3V3V0MzA0QlhYbXVjYm5QdHczVHlB?=
 =?utf-8?B?MUhTTElaNyszQkJzcllQVklwMFdZdzRDRlQrcUs4akhXZitJQ2ZkRldsdStV?=
 =?utf-8?B?K0ZHS21zWHpNQ2RnTDZ0THlKMXdCR25EVmpjMnNzdjh2c2VRVnFic2lnSjRP?=
 =?utf-8?B?ZFkzT2UyRnd4ZTN2MW0yWWMrNHAxWUszT2hJdkZxYW4vQnBvQS83cGsyY3Jy?=
 =?utf-8?B?WmEyTTFXWmpRbmNPSnVSVjFHa0kzVGpudm9hUUZZbUVkQVFLZFA4emozUTha?=
 =?utf-8?B?RldJTDlWa2phL284TWRKUXg2K1ArbnZPcURkOXVXbDlpZlNyR1lkMi9saVcx?=
 =?utf-8?B?dlQ4RXZheC9uUWxXeDB1N3dwOGdGR3lVTC9YTmduUGJzNVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:43:45.7217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4a5d2c-5eb7-4532-c8a0-08dcff323386
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6398

On Wed, 06 Nov 2024 13:03:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.60 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.60-rc1.gz
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

Linux version:	6.6.60-rc1-g2daffc45f637
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
