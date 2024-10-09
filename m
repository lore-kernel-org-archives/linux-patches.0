Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684641A2541
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728485980; cv=fail; b=fyLQSm5Ty7n7+qWW+X5JOD0BcVfCNXUN860boSUE2el5dlD2UiR27WfM/lvmEHFc58B8bd+TQ7DfGBDAwqistmv9vh/sYdcvuWF0ptobC12e9WVSX/9dgTrmQ7B1o9IHF742DZCa3tW/brEkg6HYaZaW6WpI6ymIFPCwh+H2VYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728485980; c=relaxed/simple;
	bh=DOZlnvGRyabINgCs+c+7C8x2tfTVhfGwtJ9Q6GREv5Y=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FXX6qnyZo2pbJX+lzF+KwQVjf7y153OylEl9jUKib97XZSQDbrJBHu+owvEQFZJhGgQikKrGg7U1kM0bCDPvZGwLDV1sOm5uktefN3KBEyxrFCwrUg5k9d1ObycO41P1Sr1HnznqN4m6rOLxZdQq+2RUQVpkyf1Di3/irJ7OMLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L4VTorjz; arc=fail smtp.client-ip=40.107.93.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L4VTorjz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPZ2ON9hkMGhKHwAnM30oJ51YmF9evXeIAO2Vo4gFpZhNPWFmYU8N3lleAgztduKL9srmUYjMwVXuJQL+9ww5QV4VgyZ4GYJ6K5TYR9r/4SpFPqvFu8cQ83gVUoI5RnbGCKpIp75db2ywSemKMxbUkdf5Sd8TUewYeUPFdqn+YoGX+HtFLTEtpmJKg24Xt+AE0kgF/bjTHJT5c682ISNy1HlD5vcf7mwlw38//vRjDA5DYy8YUdkn7hmMek0aroA5gavhcr7p51kRu+V0XQ+JpYi15qyKfO+BBqjF+zGVT5L8MrV9v5ie7uGscFV5e8caxntUaHKtKMh9mftJPsWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFS3ecRBgRdztR8Qzdz3EyD3TlH4oa/MKdNoknxFzrQ=;
 b=qK6i3QSA86ezDscoClgzGkFXxzzb3ORwfqr8QExfMJ+iaZBxJq/vjaJYrmv92hQETeP0nprOwwdkBWUrs2o5kjhXKesTACUmOY+Wln0+S8fAlpR0UoLzJhbKVYnSwjUBfjnJjC3cNRrBKiYCvNywtWrF/qJmu8fUHDwu8iTYPexhSv0uz8NA/U+RTFzMAj/EwusINm65e6+HWJnhFyyfuEF4cXmz9VEiYF6CqMp3vUHt3rFAOwWCzherLYanuwUGyPCxsouTdpG2U053HdMJUigHJw5RGw+VShymKv4NI4QG4JCDd+MZmbXGm/bSsRAh6i/+sZyyMLMVXT6ERlI0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFS3ecRBgRdztR8Qzdz3EyD3TlH4oa/MKdNoknxFzrQ=;
 b=L4VTorjzpTzfM8RXTZfP55JtRWnORS8M3Pcyh4kZRPpw697Vr+7/02hRS+BJyhCPHMmVQDmhS2yGvprKgcToE8+Id7oELS9PS2T4PVXZGwawlBKTIefyGB7PS/zZ+ue+paxQdX7JUVSHhU4hNQujrOQzlsQiJjYhNh2LimXbiOcmX7oSjOI4wei/mqXNiqNFQGFXTKUlS/8J0p7yGBpkXvXgiydfam3OpLKuWKdrkv3O1p8rk6JTYGCfqq4iv2onZGlAqi+DUJ+PL9PpL0/OpC+WoBCox1Qx7YqMquaKrz46r9+zjjsR2yqhWVkVoUJSwOsxKk+uLgqoCwzgnaMGQA==
Received: from BLAPR05CA0010.namprd05.prod.outlook.com (2603:10b6:208:36e::19)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 14:59:31 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:208:36e:cafe::b1) by BLAPR05CA0010.outlook.office365.com
 (2603:10b6:208:36e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.6 via Frontend
 Transport; Wed, 9 Oct 2024 14:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.0 via Frontend Transport; Wed, 9 Oct 2024 14:59:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:59:15 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 07:59:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 07:59:14 -0700
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
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <526e573e-c352-484b-9b24-1f83abc93f8b@rnnvmail202.nvidia.com>
Date: Wed, 9 Oct 2024 07:59:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6cc5b2-013a-4dbf-0137-08dce872faaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXJrM0lCb3pWeTB0dlVHb2ZrNDNOZjc4TXkydmM4aXBGejZoUWhYQUdiY0E4?=
 =?utf-8?B?N2FTdDVqM25ORVVyU1o4cmh6NHZkUlljamF4cHBGWjdwSXJNZ2xHUjJ3bEx4?=
 =?utf-8?B?V2tWMUdoYzBrdDYwY3FSN05HS1l3ZFg5MEx4WTdLWWRXUG9KRTY0M0syVUEv?=
 =?utf-8?B?Q2NrMVZKT0lCd0ZQcXQvZjV1Vm4rSisvWWZhWVlIc3lqWFUwNUZpbmZ5eVc0?=
 =?utf-8?B?U3htTXN5R3FMWnloWE83cmN6T2YwUUlBMk1pbkVOemNzR256cXdSRzFjcmJS?=
 =?utf-8?B?TXc5WmU5WCtNMTdGZE1ZR0Vmbi9sNlVmTTRwTGw3Y1FhU0ZUNU5xeFp5bTc4?=
 =?utf-8?B?NkF5ZU92U05wc0t0VzZ4Vms1dXZtdzhza1JoV1pSc2dqcVlhVHc0dkovMHBX?=
 =?utf-8?B?a09GYUx0SjhRLytTbDV3aHMycC9EYVVaSFp0MTZxa2FiY2hMZFYyeE92VmJX?=
 =?utf-8?B?REUwNyt4SFdQQTJPTG1QdFFvaWF5QmFwWSs5VGVEVFBuUzFiVElOZlF4cXNN?=
 =?utf-8?B?MzYydXpVSmsxMDJIR29GdlEyYlJzd253YWUveDkzMWcwVEdmdk5JejZ6RUxN?=
 =?utf-8?B?Y1lndThBUWJHb3ExVEVGVFdIWm56THJEVWxRRm8rOGZVUFJSRjY2czJEWGVq?=
 =?utf-8?B?NGpXcTlkRGdxdW5qbldqdGRxUDdJRGF5UmlFZjMxZzk3aUx2MHBMZC90Mk1n?=
 =?utf-8?B?emFJdXpHRDc1cEJYQ05NS3dSanN1aFl3a2c1Rk9Fak5qcXJxYTVtWXBwcEhG?=
 =?utf-8?B?cHIvRDJvYVIzWlBtNDNFbkZsU1Z4U1VHc21LbDM1ZjZxaDZIUy9MMFNaNEdP?=
 =?utf-8?B?SzhkUlVxeG5vVFlKY0RPbm12VVZyMk9NN2V1WU1ZRWJiS1NuQSs5QjJUWU8z?=
 =?utf-8?B?aEhsaGpITDRubmV6Z3FkOFhRSFJCNklsSktSSVMvRHc4clk2YnFEbGk1TkZl?=
 =?utf-8?B?OGhqYkxreExDMWZOUENwbExlT3F0U3hkSk9SRXdNYmNvOWFGb0JPenRjSW42?=
 =?utf-8?B?ZStXQ3VXL0xUNExnWm9NK0hkbm9VbVYrR2hiQ29OMEUxcitvVkZXMEhDT2pa?=
 =?utf-8?B?c1QybDlxc2tKMVkwVHZyTkNGR1FaOHU3M1RIeG03Q0lKN25GazBicWZpbGxH?=
 =?utf-8?B?eXJPTzlpeGZaMVFUMWYxd3BkcjF4SFF0M3owOS83dTJBK2ZyZWpoZnNQMkcy?=
 =?utf-8?B?SEtTZFNIZUUzZ3Nla3M0bHlFb2U1ZUMyc0MvcnJLVDBmNW90U3NIYkpYN0N5?=
 =?utf-8?B?UlFGSWVxc0NmNGt6RXRFUUdiRW5RN1dTSUhIQ3U5bjA1cWI3Nld2bzc1QjRR?=
 =?utf-8?B?SGVMcVdhMy9EdDBqZGRIU0VHTkZ1Y1MzZDdjNVlHejFUZnVBVVROdHhOc0pH?=
 =?utf-8?B?Q0ZhSlRFdGg0RU1WdmJNQzZYVGZRdStKdG1pSWRDQVFLQkZ0M053N2d2VDQv?=
 =?utf-8?B?cENpcXplMTJYd1o4d1R4RGJuQm5rTEd3OUZ3ekVLYi9BZ0FnWlhYNnNRSk1T?=
 =?utf-8?B?ck9pRHhQNXMwZlFqZUF0cmpiZ0tqUVJyV3JYOXgweE5mMVN1NmVKaXVLeGY5?=
 =?utf-8?B?UUtLK01SWGdyOHcySWRralpBSXZVbWUrYXJXZzBFTmN1NVhKWWsxdlMxNlpW?=
 =?utf-8?B?VDlwSHZTSzU0R3Y4cDRJRnhTK0pZQ3l1c3lpa0M1NXV3UDM3L0Q4Q2l5a0lk?=
 =?utf-8?B?cTYralNEendTdXUyMXErYnMzUGxJSE9NeVZWdmhxU3o5U2Jua0VPTGxsN2tK?=
 =?utf-8?B?TGw3cDB5MG0zMG1ramN5U1JQa3VsMW05SmZ6UGZTSnRwd245cVhtaTJJQTYx?=
 =?utf-8?B?WW9TQXlJeUgySlRvbjdUdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 14:59:30.7097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6cc5b2-013a-4dbf-0137-08dce872faaa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010

On Tue, 08 Oct 2024 14:00:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.11.3-rc1-gdd3578144a91
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
