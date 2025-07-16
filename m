Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230F32F273C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660722; cv=fail; b=dZ7UJmQrnoFNIu6TkwJNSxhy7Y8Kryvsn66SWn2moo9gatX/vSon6ydYFlfGeZe//K1pMJxPDJm0D78BfwYUrimjwlI0THMMblh0r40pE6AekzH+G35JibkFVZW3f85Ssz+Ix2qAXTRPbGVvEKxmASKOE9E0WELk9MpaQsqnj9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660722; c=relaxed/simple;
	bh=4gXr5sHgbsJsqf54Y42jQ8GLMZNlW7JCZtJZfkBdSRs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VZXdlmR2HshfQMdGqsYINdvbAaj2DS3dC2lgpRqVruiCQoKKd8EkceGa/YPMXfgO3UW6TwG//5mgnUmsPLELdKK00m6KIBgcBwBS7V7dJUBYQ+dvWyr/bKvUmIVR8k6VDa/eLZjjdeb6uKGEfIVA1WWpdnI22rScrrcLBmL/0AY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aMw10O88; arc=fail smtp.client-ip=40.107.102.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aMw10O88"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rmQB1ulka2P9Kl7et/JsDRh5/i47djH6CcA88KeLOgNt9hZul9YEsK9EUf4qOBZpns8wvDqCEEfiO96XUh69J8fWbsYCNhYmMxHgDlGQ6CV/J0XEdHVUc2DrkLQ9XR4LylhpHmSYVHUMISIqRLyQa8hj4Dj5pswUnmNuzRJKz6tq5cIP9/COOoTuGS+geqlZJnOsp6dNXmKdS33NWFdSt3gYDXYci6DLH9M8GBnX00Ql+SUkjyGk5uHrH/DKaY/HjckXmp7H3H83BLMPofy7H8nJLENyFOGYcTyRtH0Jj/JHaULPm5Fvivh9w2JHUvaA1BEjzRf5kO1G5Uyml5amRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDz/NY7KXF/UZIB0soA4khqic2b/z1wQ0oDoUSLWkoo=;
 b=aUq7lKNisHNOHrGSTzJaIW6d/EZy2lwohQ1R/v4n6RQeDH42W65t3z2F2fTqrR3lsx211HA8i3z5LZv3IiLQgY5gFuD2V4Bc03Jsxi/ruouS4eK5kxEQeynn7aApn/xzVGKzKkodFepZ2ppqy3OulEqi44LYMx5Ca8pDmJb5GvQu749JMs5t6NRnIpLdEj9srtIV6AiFE/AFCCziesICgzSuZtN/M/zZ3zMP/vQBT7S7UESR7uiU98N5TTjmYH3P+1cCjgleTyGjI5j0y3CNgiF7HdcVLEKeqhXi0v1SDTohkM/oOqb7qsXr4FCVfM/Wvn3URGnjxH9zfjUaTdlJzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDz/NY7KXF/UZIB0soA4khqic2b/z1wQ0oDoUSLWkoo=;
 b=aMw10O88v/DZDVVKHGQ0f8lF8Vnop3HRctj2JBeFrWTTz0R2tBsL6+DGoNGnUGBR6maztCs7I15p+8GF5qYFYdTGV3g2UCe98NJYYx8POLMnhBYAMPCA/CHjKPPF3bgoh27erJwFzrUJfEtaFF6yXFfzFBX4FFThsNOIRsienbLNOQOHAu/agVneGOr1BiSgF/Yr7jZhsl/YlDjS3m3LdsFl6Y6U55KjkOuIJMAuecCOyawO2Q+ZgqhUaekt05jb6GTyu106xNrijHIGm7YuU5K9ZlNczHfrTtg81iXNvK3cIp6NyZCcr869rRqQf1TJTeExF8QSwzWMDDm0QRD1PA==
Received: from MW4P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::29)
 by IA1PR12MB6385.namprd12.prod.outlook.com (2603:10b6:208:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 10:11:56 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:303:80:cafe::89) by MW4P223CA0024.outlook.office365.com
 (2603:10b6:303:80::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Wed,
 16 Jul 2025 10:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:11:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:11:37 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 16 Jul 2025 03:11:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:11:36 -0700
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
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
References: <20250715163613.640534312@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b97e30dc-60af-4c37-a266-70de27d8e386@drhqmail201.nvidia.com>
Date: Wed, 16 Jul 2025 03:11:36 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|IA1PR12MB6385:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f5f6a9-a93b-4a4a-8cc0-08ddc45130eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXNXMHFDQWpWNExaOXdja0hIZDNkWFZYMGFyK0xCRGJVYXl5akJDNHdxSE51?=
 =?utf-8?B?SUs5Zm1BYjFmSGE4NTRYNFlCYTNRaWRHRUVQRWlGcVhzZWxNc0FGVWN0R1Nv?=
 =?utf-8?B?czRKcmdmS3VQNm1qN3FqK1h3dTd6Ym1JZzdaUmUya09WOS9taVJiOUlUSVN1?=
 =?utf-8?B?WmZ5bnhaaFJ2cDVPbFV0WDN3U1pjYmhiTGNVMktUUFNCd3l3MHJJU1BDTk9G?=
 =?utf-8?B?NzNNemx3TG8zZXFIUGczQVo3dVY3TlppWnZISFIrN1dhd1NwRll6b2hkY0Rq?=
 =?utf-8?B?UkFCK1I4dlVmTll1WW9tNVJub1UvOWpqU2dHSnVadi9wY3BuOXhlTzJQNmVh?=
 =?utf-8?B?T1RGSndZWnhSZVpOVE1BMk40ajF4ay8xQXNVM3J2SndkZ0loTlBuOHIzWExI?=
 =?utf-8?B?a3NySlBTWDZaVDRmaFNDLzI5Nnp5M1NkcWk4c1BlQ21DZ2FwekFaTHZMTTRD?=
 =?utf-8?B?SE9jOGFxS2VxMnlPNS8xS0FGZUZxaTdFc3VlOEErMFJQUHFWZzYxSkpib3Zw?=
 =?utf-8?B?bzAvZytwaW1xak5vaStiYTJyTmt5dW9xR3FWTlZIZGZZSVYra2hnbms3Z0pz?=
 =?utf-8?B?VGNVcXNmR2JHN3lUZTRJTXlwR2lPb3dUWWIwMEhxRWFvSk55bGlIeTBuL21R?=
 =?utf-8?B?MzB2eWQyN3JOUzRGUG5mZGVEaHpieWM2WmdGdWtGQ0Y0b1pxaHpLQW1wV3BX?=
 =?utf-8?B?aXZMek5HZ3g5c3BEbGlRWXlua083Y3lNTVhEbzBVc2JQbk1oZ0xVNG82MlMz?=
 =?utf-8?B?RHVzUUhhdG5USG9VZ05QZHZkemtVd2lUWmJlMHlMeFg2MnNIYkpjbkF3MS9R?=
 =?utf-8?B?ZUE1RTFLSG1mWXdYYmZiRngrM282akdmNjNGbS9VeUpjazlzN0pHS1RNWXFh?=
 =?utf-8?B?cVluemJrV1JoZlZobFpFWXE3bDdZUVFRNW8xUXpkWEFTeEtZdGFUYXlkNGQ3?=
 =?utf-8?B?YmdZcE1iNVVrL1F5S0l4eGtkcW1waDFYM2t4NWVSSDZNZlBsVEFvT0JLWkFU?=
 =?utf-8?B?STVMdmg0ZUxqM21hZU1wTzhCNVZJdDBQc2M2L3FWS2xRVlJYN0RYU2xoeUFH?=
 =?utf-8?B?K2x3Vk9PaW1vRUNLVU1xZ1lKTUdWV2pOMVNsZzJTdnYvT2hqNTA5eHI5RXFt?=
 =?utf-8?B?K0IzbjYvbGtYeXlYM050ZW9PM1ozTC9LNkRmMGRGUnNNZzdrTVBXMktBaEFr?=
 =?utf-8?B?cW5GZWZKZ2lYN3ZVUWMvbVJ6YWxoU2FVUW5YTXNSVEtRdXdxSjVRVDNZN0VY?=
 =?utf-8?B?RmJtWkd6TGZiYU9PMktkU0dGKzN6U1RkdG04UGNxVFAzRWUxc0t6eU10Ny9G?=
 =?utf-8?B?Tmd2V2FaMWpsZFBsS0xVT0E0TGdzUFY5MERLeEEyakYwb0VWdGJxd3VoSXJB?=
 =?utf-8?B?S3lGSXFacWJUU3l0V3ZUdTZ2MStPb2xLL3ZPU0pvWndkdnNvazZUY1AzQzJU?=
 =?utf-8?B?SWp2dlVRUWtXZ2xKalllVjdwK3I4RjF5b1hibWF3ZXMzQzNUeTFXWWRCUHE2?=
 =?utf-8?B?aHhzZGhiamo1RG9mZ3RJdlltK2ZEakQ0dnZITEFtQXBQZDhFOHQwWUlwaUNR?=
 =?utf-8?B?dWdmT0pydUVHbkhndU1ra3JEQUViUE9KTzVHYVEzcGdsNXFCd1kwdjBFZ2ll?=
 =?utf-8?B?QnZjOG5BUDBZb0NQZGVqczBzazRNYkhpUkxQODlXR3ZESjEyVzBrSGNxZUMx?=
 =?utf-8?B?NmE0KzNVcEppaEVvV3puNWpMR0ZhaDBTREFUMVZTbnhIRW5jRnVzaXlhZ3pi?=
 =?utf-8?B?MjdkQTBwRzViMnBTQ3ZXdlp5RGFtTEZNQktoRzEwZ3U5N0hxanp5bDNvaCtU?=
 =?utf-8?B?RC9oNEJVQ25ZZU1IZ2N5aFRPWVl5b2xJTzdyNVY5UEdkUG1uZnYza1ZvczNB?=
 =?utf-8?B?SytrcVJRejRXVG1pNjdEQjRqSWMydTF4V3RZZ3EyaFZ6OXZUUm8vMTF0emh1?=
 =?utf-8?B?R0NTWTZMOGZXVEhNYVpxbEZBaDRNUVoxeDdzbVV2U3llWWFadXVDRjl1NVN5?=
 =?utf-8?B?a0lDZUZDRkxDT2d6SXgva2kzN2hrRFg3cjZYekdxSHFlazVJRnBHRzlsUTlh?=
 =?utf-8?B?cVE1d2JOVVFxWTlEdHJlL2d6LzV4VW5MZEJXdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:11:54.7169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f5f6a9-a93b-4a4a-8cc0-08ddc45130eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6385

On Tue, 15 Jul 2025 18:36:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.240-rc3-g2067ea3274d0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
