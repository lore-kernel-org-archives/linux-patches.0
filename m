Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776DD19B3E6
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384654; cv=fail; b=FxfByFuz7D246mbGRBEwsTATF4fAwSGtjYEC18vUsk6zSZMR8rT18UDN3Es3XPHWuXyP+0llEUebFQMZjlyiZW9Uhx3t1HXn099ABrA4dRyM/ZHWAZLxGd3XCta6eC93Sip26XuAvIoQ8j3uGjcB4DbL1fvzIQbUUxXnO6bM5Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384654; c=relaxed/simple;
	bh=WUeQ92zr+PqESOkGTQxTFYWCxSlbKEyKb4k2IQZbFNc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aQpWbPPB3vjHLKoEOoyn2KFwgp02l9VwzjCvtfGK5HYhn1QLthU1E9KuwU9f8bKEIZvEZ10fL0XxyKa2BGnBk5TND/cpBIIU/NxjJmUKyOiJWd1N0uf/ZcfigoG8CQouAmfSw35qQNJ1H9WcpDqfw87TdWCtvvcj3SayW/8Wmp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qzCVwS15; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qzCVwS15"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXxpAc+MmiRubQbdrC82Mdeb7wMVbsSFsvz/ZN3ebo9wEMxftPqyNzoWsKeLeT4vXvjn8YpmSUe5m5ixqR2ud+WtgvshNt/diQ0/3Dr00C2BQuDp6tpCO/jvz6wq5pr+NLolUYL+ccUYf2JD0wz1jcDATsPqF2yhv5BOdx4I7unrVst4KKX/Q8Sdw/3Q0R9MKytVRlAA0vxuK1KTNwyX+nZG6hNmHJQlFK1m+hsd1awC6ELb2oHOu/LwtJE9un1bFf/7LO8fEruJ4UL4uslLaHJ2dOVNcHxoluMzfSoMuFAZkAC0Guwa4VkMwP8CvA7ZwmEfrbx0cQGUy2lt0rJf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skj7SvS/Hz6Whok79ciaCjI8nv6ddWDl8d4EgmXN4pU=;
 b=kXBVdk5vZSwqiRULdiA6rNwWd3+Zy667navWL8fpyrFhD8ANGY5teOoS3naSiUJCLl66HAAo2OxCjDg5nGZJldLm5pOwFzk3MbRBVmJv0oa7kXIh3nCotD6TqVc9Tz/uDyipZKhtgZDCVeNKLQP3zq72EqRbhetbPRXTFFi7oGuXrytzH+rnDS+Ece6h7xN+OBFw/yG89eOh3cu6jdO9ZhYnfL2IZlpGeymUBFDwX7jQY/ecVzp6M2TLE5SllXg0EUyTYcN5jstIHct0/da9iwLWxWuW6JL//CombdI5c1bBQsAftQjl/y1pahip9XRfH+kNub/6ciTWMVsCWhBHIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skj7SvS/Hz6Whok79ciaCjI8nv6ddWDl8d4EgmXN4pU=;
 b=qzCVwS15XT0kihSNZC5ZAG9MoAapqk+I8OHgq4zAKTZElnF1HFJtHB0XVHQImVyWr3+XaxwM0ZwgLtRI41HHORpHDlu9Dj92yX3N3n7gq3W9mDDb8iNfMLFgwyXUhmuuqal8jtsov4VxLUZMomGUYYzjIjQXbhRVK1XuosLanUgUUYd0pj07zZRVonBCwKirm4LtcjClDMqa6U9to6MMF3Ncd89bbgPqLut1PCLM0blf3avXx2dXoJkTbS/3fu5wLL3lv8vgN9MN1Ie8ZYKzUR+LK1Q72LV5G4gJLfsqPPJQNkDDOOBmZmLyzQkGDH/x1U3JEkdsDl2yixt4dHeZSg==
Received: from PH8PR21CA0008.namprd21.prod.outlook.com (2603:10b6:510:2ce::29)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 17:04:08 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::73) by PH8PR21CA0008.outlook.office365.com
 (2603:10b6:510:2ce::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.15 via Frontend
 Transport; Fri, 14 Jun 2024 17:04:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:04:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:55 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 14 Jun 2024 10:03:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:03:55 -0700
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
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3b666755-fb3a-4de4-87d2-99e86dabcf53@drhqmail203.nvidia.com>
Date: Fri, 14 Jun 2024 10:03:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c935dff-800b-4b76-b958-08dc8c9400bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0g1enlyMFdqOWxnVHBreisyMXg1VDhIeTNza1ZweWhxNkJOWFVUaVdiVm9s?=
 =?utf-8?B?VWgwdHRsT3c5cVFYVXpIVlg4aFdzUm5iSmpTTDVzT2lOUlJqdU1zNkZvVVd0?=
 =?utf-8?B?a2V0WVRwUFdCMjVEVVJTR3pFTnd5bWpYMzVyMmRHcTlhUlkzcEdsS3hHVWdL?=
 =?utf-8?B?VGVKaVZuaTVrY2FvckdBbUxRcVRveUJibEV5cGFGVFJVclBvUE1IS1F2N0lH?=
 =?utf-8?B?YVYvZFEvZnJ2aUwycFowS2hNVWJ6TThyQlpsejM1MDh0TVhjVStOZlg5dm96?=
 =?utf-8?B?bkd4UXQxa2dBUzFnS2NwWVVod0ZmeUNnZGdST1dmTXRIQmFsQlo4U0JZTHYx?=
 =?utf-8?B?SitKVlZROC9FZFI5TkpZb2kzSEpXYXoxRTBTdTBJalRTNkcxdGdKalN5R1Bs?=
 =?utf-8?B?di9MOHNlRHowVkRhOHNkbHZ2WGxXZDJEMmFub2xuTTNCdjRSRGJudThFbHM0?=
 =?utf-8?B?MUdlbTBpZmw2bDBzVjFzL2tkMzlOdmZsNmJLZk9XWnE4aUZzd2JtQzFLSjhq?=
 =?utf-8?B?bW9OR2FlcmUzOGsxaWxyRm9xSDF1Wkw0b3dGUEtPakwvcUtVeE82d3JINm1q?=
 =?utf-8?B?MzEyQy91Ty9iVXh4bCsyTzdwTW4vTEVuQmZTUnRIOTBacFR1cXpkNDh4MHo0?=
 =?utf-8?B?RXprOXVVZDY4TVdaR0kySmovRnFzK3FYUUlNeHNSZWdCRyt5MWRUNFNEUDRm?=
 =?utf-8?B?OGZFWnVpeXhUc1NtdlBGcnlmNWl2WmtBcXFENXdDUHlWd2h3WmFBQUFJbk9H?=
 =?utf-8?B?NklXektlblRGZnMvenhXKzhTVXRXWTR3ZCt4NEdQa3FhNjRTUjFqajZxV05X?=
 =?utf-8?B?MkVHeGQ3QjFDQ1RzQ09UNXR6VFc5ZFlWdExNcllJb2MvdDBLc1lreXNhKy9H?=
 =?utf-8?B?TXdoTjlFOGZLSk5NeUJNbWlGUkVGRHNWZlpDNlZPeWhiczJac005YzhpcUlP?=
 =?utf-8?B?cWpDNmlxZXc3aHBYQnpOOEIreFJSYWl0M2hpY0NPQkkxVThlZzVwWnZScUU5?=
 =?utf-8?B?RnBqK3lia1VZRXhmTFQxZFNWZlA3bnBaNVo1MTNINitHZlRvNlZtVDZ3SUdC?=
 =?utf-8?B?T0lBTHdNdERNb3ZudlBHK3p2OWJVa3NlWFlRNlRVZS9DaTJsNWFSSnpJVGRj?=
 =?utf-8?B?TnovZXZLOEVqdGxKcFJ0cXJGTk1MU015bFJkU05Lc1FLSUNBREpmYjN2UXll?=
 =?utf-8?B?Y1N0TWptazNMSzBkbTRaWGErUytxZmd2WUlEZ2ZWWGNCU2VuODdHaHdQekhn?=
 =?utf-8?B?dURIbmNnU2FOSklETG5YbzdqMlVwSFZZVWM1ckFWdzEzUFFDTllJNW5OZTh5?=
 =?utf-8?B?OThudzVQa2V0T0xqUS9ybkRpUWVWSWRrVjdXY2kvVGVqNHUwRmRDN3A4OG1Z?=
 =?utf-8?B?RUlsYnpRTWpQWFo3ZEJPVHJBdlJhU04xUllKUEZhTkNSSVZYYndpaFJLYVpR?=
 =?utf-8?B?Q1grQ1IwYXozYnBDdFF3dWY1S3R4MFFnWTkzV3NQNmlBSG5oNXhTVHZ6TVRS?=
 =?utf-8?B?UitWYjlQYXV0bis0Y3NsNnlQUzdyRlpmQUJDb0RDcmpDd2swNVU3YkVVWVB0?=
 =?utf-8?B?WWNrSVNFZXNMVno1R2Q5Tklia1pkejhta09VbVpaOUtBM2pIcHZkMDRjSGZH?=
 =?utf-8?B?K05xQzVpQWVJbTlyTTA5WGJoMDBGczlLWmJoS3BzeWxRb3Z1QzhFUko2NENI?=
 =?utf-8?B?MG9iQlgrTlo3dlJLQk5ZN0dOYThEajFBb2ptV2Zlczd0M01jS2ZSUG9WRi9N?=
 =?utf-8?B?eklCTFNldFlUOTk1clpzR3o2TDErUEZsME9RUTlTT2p3QVF3RmZheHVFNmtR?=
 =?utf-8?B?bENVdkdsOHRZRzF1Q252SDN3ZUsvTVJWTkEwM2JIMGZDalBSRC9kY1ZucEow?=
 =?utf-8?B?RUJlUHVBTElnbUNNbDBOcjZHS2o1SDlKU0RuWHlMbXg5Y3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:04:07.4090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c935dff-800b-4b76-b958-08dc8c9400bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992

On Thu, 13 Jun 2024 13:29:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    102 tests:	102 pass, 0 fail

Linux version:	5.15.161-rc1-g382eb0c78882
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
