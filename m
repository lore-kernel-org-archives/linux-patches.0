Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE109213E62
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 12:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843271; cv=fail; b=C5f2cLhKNUrUsRILq8zMMEPqEm0wBNozfII6xf8RXfIRe4AbGb24StCbVhqpJrSdzkSC4Mew5K7scu5iwbT3vsDCgap9UW0sXYa/rygCe9RdNjPKInZ9IEAwdWQPH+C0r0oObibJHOx7L2ERONh/Jgg0xfw23GFvUOds5euEIvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843271; c=relaxed/simple;
	bh=5SBotOViFwIQFFAeyQqp8nNb/UBIeU/NzmrTX+WLav8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VSFwlRZJV8rpJ0iIjQln0MJkWOXqoIkLEx0jUru+jMklbqVUO3afHKLRpaCaRso01//Dew6ZOQdvkZMN/QjdYXHF0aLbTOs2gI1YGfNOKe+xPvnGXn1YFp+WjgpdhBm7hvH0cwT3/ibaZT3fQgOKzJzQ8ZILwl6yzxmUCR0Zj1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kn6irmCK; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kn6irmCK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w72B1ts1gg0l82NyESh3dg0ELhmFklfJoAg6E+2f9hKTd7cIxKOy1A2ACS/GYnS4G8k50HAiq/0CJ6Lr7DGs31P/w0OpKgwQ41B+jRoXtJbVQeS0FDcBeFpOkIbP1QYjsWgHBoqVMf829QB4QGNWZLgyDft5eOvBL8YIa7JMOh5HG52qOxgd+YoPOwFjMw08G5Gt8nBPVKm3QvwuwP6wKnaAmKrFJ3GUKbCWaFo7yit0UUZHgyAtKKweXIA2uXekHeAPVPg0jY3HOpySEbjJQB8k3+lfNIfMes6XkBw38hbxGVnlcViZFhnic3pVTON+N3TaV3LCA5S41nNhIPdAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7a8kS/9JM/ip66KmsM+pcm7nFX2ZpU4K5qXk1niF+pY=;
 b=aKaa34qv4Tw/rCB+b7dqKMirgFHazw496dEOpo6+1use3n9QhCLvOGSGVFuhSMvBFDSU3TCxgK+7O8SCfearPRi3RA5FanebyI6wfJk88SuclUK0Pf/ChJ4Ru3ccqHVEnyz9jqPFY0NCHYrbyqTgeWSuWymY1Q/p6muGlYOdSRQEewxPhBepGyaeLZNwngeIGXaoGRXtH7DUAhxjFPHKlILRSIrdAdT4JcCfx8SlblKGe+K4uDby+MUx+4LI1hpmUl+wWz692TeK6+5g/OptZc20EONAfFuHJmwhb1cSdXktQmW64aqaYixePz4Rclt3KIbO7wpOI/L3rc/fk8cSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7a8kS/9JM/ip66KmsM+pcm7nFX2ZpU4K5qXk1niF+pY=;
 b=kn6irmCK1wUlzitb3lLES8wXefQtdg3KpzxGAP7s7TFNoqmzzlDPKK4ujj5FowKZWmK2MLJjt4ZxMSmPTqpMJm92C7lymBpOPX+KdC+rmtOCjImkGmP2dTcK3uihckvqJJ8Myn/4WOznqX3+HggfvvDpU8Q+iDWgTIgTrPwVgIbMYlv4CeMZj4/46bhDv7RmyfJ6uqtspIA+AFkm+F2LqfCTseuApFbIgCYei8ltzpfCwlWq018VWYzw03cbq60HNIsfWI1U3PEk8AtMEJmtev6JWh2CpQQ0gDvXlVYsnHMr9DV4Mh4pXT6xYt5keSQ9NeSwJ21dLUlcgNY312Jm+A==
Received: from SN1PR12CA0104.namprd12.prod.outlook.com (2603:10b6:802:21::39)
 by SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 12:01:04 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:802:21:cafe::c6) by SN1PR12CA0104.outlook.office365.com
 (2603:10b6:802:21::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Thu,
 6 Feb 2025 12:01:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Thu, 6 Feb 2025 12:01:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 6 Feb 2025
 04:00:56 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 6 Feb 2025 04:00:55 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 6 Feb 2025 04:00:55 -0800
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
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <93288936-9b81-4538-b7ec-36628cba70ad@drhqmail202.nvidia.com>
Date: Thu, 6 Feb 2025 04:00:55 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: f810e573-e15f-4d38-ea7f-08dd46a5ee78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDN1Q0ZicFY4WDc4YnMwN3FaZ0I3K0lHSmIxK0w4YmpNSFJwcW9vUkJxSXlD?=
 =?utf-8?B?dUQwQlNQYThHcTZCc09ORDYySkIvcDhIcEMwaU0yNytGYlpmK1hXd0txYndl?=
 =?utf-8?B?THh1K2ZYYjRtNWhudlVJRll2NEFIblYwQ0IxNWJuTWdMSFNFMmU2K0JtSnhY?=
 =?utf-8?B?cHovdGlxR1ZrRWtnL3YwMGdLNEJiOENXNHdPcUVTZ0xSTThrbzlGem8wUFQ2?=
 =?utf-8?B?VHRhNkZ3b2QvRTlobDJTUHdJS0w3VE1FS0FlclJPbnJmOXVGVExibDNzck5B?=
 =?utf-8?B?OVF6RzdaKzgxcG9XWTl5RE1hY1FtUGpENWdlbTFrL1VkNXBTa3FqS2FEQkta?=
 =?utf-8?B?L1pSUlhvbkZoUGxxOWZoVGkveHJuUG80OVN3VFZBZUdyVkNrd2tqVzlPVlhl?=
 =?utf-8?B?UXNBc3lFWG9UYmFYQ0pmWDRJTkJJNThWMW9WOVp0d3h4M0p2N3YyOXFoeXhQ?=
 =?utf-8?B?RXExZDE3L1h0UlZ1clQxOTNWL2x5Nkc1ZnVaQmc5M3ByVnNzdElvR2pmT3Ax?=
 =?utf-8?B?aUpmOVBvZUp5U1hGZFErY0ZTNjBSWUhHSzBkWUZQOVhyODlBUGJvd2dta3hn?=
 =?utf-8?B?MDdjMWdUbDlHNnFCb2xaYXRHVVFTQ2ZFaEZsVldnWmp6Sm52Q0J3ZGxIUGJm?=
 =?utf-8?B?bDd4OHFtNHFEMVd0THVSZjcvelFJdG5QUVJqQnkrbHVuekJFaXlBdG5wbzl3?=
 =?utf-8?B?aldNZDZRb2tlWTNuVEhwbEw5S09aUXkvUVhOeWhySXBBckd0dWVWZi9zeStn?=
 =?utf-8?B?NE5mRHVkQi9MWm9MRHZNditTbTJjaUxxSTFzeXdST0RoeERhQ0U3RnNUT2JF?=
 =?utf-8?B?K1J5TEhBUXNmOVVEcnA0dGQrb2hJekRENmFLeVYvb2VrNkozUEFiSndMQ3NJ?=
 =?utf-8?B?eVk5Wlg0TmV3NjQ2bXpIU0Q1TlppMnc4QkZ1bk9IVWJ5RUNwVy9uQWhLUmlZ?=
 =?utf-8?B?diszRVBFSmhyNUtpYjZtOERVbXJRaTJJcXYyYUZ3SmVlTERaUUt4eEdhRjFi?=
 =?utf-8?B?YzNBMkN3N0l1RVJ2MlNkcWt5S0JPZXhPOE44UjJ1S3FTUGtVMXkxRm1tZ1ZY?=
 =?utf-8?B?N0FLUkRTVjFWSFBCdmlnVmtDa3ZLUEFTT3BIdWtySzVnNWt6VGxHK1IzbkVw?=
 =?utf-8?B?ZVNaQmtpK2ZNWW5ZbTRteHU3a3FuWDBFOUxwMTJydENzWkhiUGpIbjdNcU10?=
 =?utf-8?B?VUlHRlVVOHo4cEJka3BQa3JOa09YVUNtU3JreDNxNFl4dENFQWZVc0k4Vktn?=
 =?utf-8?B?UkFrYjlPMzFRcm5aTmJ4MkpDRk9STHYxRGF2di9DL1dLUmFtOHQrN1BuMjYw?=
 =?utf-8?B?Y0IyaG4wVFoyaVI0eDU5Q0NJKzh4WUREQXBPek5JVDlrTVFldjB2ekxaTHB6?=
 =?utf-8?B?ZGVTcVdmK0xvZjJ2dDhjR1RNNDdqWmxxQk9zcDlSVGh6dVZVSjhHRE5RTFhB?=
 =?utf-8?B?M2JSVGFlODVHVWlCOU81ZDdGWnpuK0ZRakF1UzM4SW1RS1NZN25WcVNRNVZu?=
 =?utf-8?B?Y2tuL29BSExPNVlNalpnU1JPMFJyazRsRlZQdkdiRlJTOC9GTzc2QTZQbXo0?=
 =?utf-8?B?NVAzZGQ0NGZGRlIvSlJtaUgxYTRpM3pPTzJuZk5xY0kvTTF4dUlZYmhIeEdU?=
 =?utf-8?B?Vk1zamJNSlduTDRkZE1yU3NlT084SjJaeWNveTNkRzdkQktBZk9oZjZVU2Q4?=
 =?utf-8?B?QWJyalFjOWJ0SWJwVFlWdk5hNHlXMEJRemNjTHdyMEsreUI0OE5xVC8rbUpE?=
 =?utf-8?B?ZVNQdmd2YktCa05CNDliRzlLZGlxZTM3SVVISXVsU1N5L1U5MHZnQzZVMWdL?=
 =?utf-8?B?ZFdab0NTcnFWMkViTXhKU2x3dmxRTm9UT2NhQmRhSC8vOUtITldvd09sV3hh?=
 =?utf-8?B?eDVtSTA4KzY2em9IZTBCNXdscTFxdUV1L2R2UldvNS85bGhPZUYxWVpUZm5i?=
 =?utf-8?B?ZUhRclF5U3d1eXdtWFFPcE5kZmlJWGY4QjYzTkYrSTA0c3R1LzU0U0p6dnZP?=
 =?utf-8?Q?ljHW6gfIAtJwTbYEXpKaTFWiD6qQNM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 12:01:03.9678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f810e573-e15f-4d38-ea7f-08dd46a5ee78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006

On Wed, 05 Feb 2025 14:38:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:43:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.6.76-rc1-g3b8d2f9dc632
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: pm-system-suspend.sh


Jon
