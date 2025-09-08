Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CDC30CD88
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343741; cv=fail; b=g9npE9gmrTpmqw1vDqFqwhPwUhHalEXdQ4iCbioX86F/e9aaymxLj9ccWcRFJ8EYkstlm+MIERDCoJ8PuyzkWsqu7S+CEP6q9nE6s1aucS31IqVEUNaEFK7ahBml18ZIhK/pbmGvRkCx7XUdDWiGeSlx/XSwaoVJ8T9pYIda738=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343741; c=relaxed/simple;
	bh=JoPZ5K9lK7Q8C0OfPFZRsW2M9hRjJ5sRL2o1wnXm9yg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WpuKxRPGorFcpl8ANcPqsVgn6kVWjexA8oGLij2GPmtUeRk6zGjWBhyC1OCvKrQWjfg8i/CTI2UaerChBnehqRS4hgXHUzS+ZnzfklYGmkmMBZuE5qrJxnR7KK4MwwWXe8xvBxwEDekL64RCwl74X9zduUZ9zGQyDDMKAHcFIUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AQr/Kdte; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AQr/Kdte"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfLVJ3XECV1Nu72Nk4EDB72vfZ9QYguCJB5DONsjCpCKEx3ep4GRB3tmDO+J/CH+YwcUdgphH3D7u6JFo/VhiC9t7gQhjHw7mVNh9XAYLSRKkjOOCQqJD9v0yh6+DQz9Xf38+Z1tVffd8dV7SUX2zQx/+4UHstpJmfAlx+kyoys1AZllJTwlwQl9ZFE3KJtP5jvq5lc/nkYQOKtxGLaUq16pwu8eUtJI9vhcWdBnxZOCySqCz7YdYeoNPIdIcnN0C6qoVdC1AtBnMkfywHUGUewKZU6dhnMZkKS2Uu1jhV+ythjOs1RbUKf0CZzsDgOYVFn1IdsVKecHA7NxpeVNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=22Jb07TDX9eMUwPOL/99Z0TwY5bLnyBmkbIizQXxaBU=;
 b=Ra29hHJyV2gb1hEZ3meGcr2SAufUMksQy/mW6QbXOkG3ohe+ADdhIkasJQqeSsebsq+PFtPiGPQvz70mU1mNjQx7lisvbtzCFO2KrlMf8erJc/rS2oNRwaT5mg0zsMQM1dEAvwQDM6ydumHq98mFkoQBoAqkId364EDas8ax+JlwhSjwKLkrCKqRU/V8nlzasOtJPlT021jGPKcubHbmY7OCQs9KL8/0BqKzYn0phUSIh2tjapFEkudy1MhO1baldtPGIdY42RgB8JO4KUJWckuGlH6rrBrpf8JxxkLedlcgKPNTzS88giMbY9X1QED/DhByjc8xeL4jbJ9uJ1ts2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22Jb07TDX9eMUwPOL/99Z0TwY5bLnyBmkbIizQXxaBU=;
 b=AQr/Kdtei/vIqyTiSrXIC3JAfko4Hiw9AIPxn9GRkDiNp1+LJz0OaF30Ya2NtyvkxJXmMj3U8Qbl/J/f5CTKR7HffO5V/RSU9+XhI9FPKlzRZ7c7ktBDTuDl7k0czHusieTs+3l8FDCQg7GN+enNhZTjbIMN6txvS/FsltwccGPGXr8fCkt02o8D7/O/1VnQ88DgkTgtEb8//FJZVYpqd5t9UQPgamya37KJbVLp7C7NNpcZw8nXYw43JXpxaNKiC6qFEKbmjI2NPXCPtR6Vks+uM4uRueglJHq6FSep+hlp6p35mHYR+6J0UNnBj0WCWPAEp+lCCik9/71xSAApsA==
Received: from SJ0PR03CA0344.namprd03.prod.outlook.com (2603:10b6:a03:39c::19)
 by CH0PR12MB8551.namprd12.prod.outlook.com (2603:10b6:610:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:02:15 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::8d) by SJ0PR03CA0344.outlook.office365.com
 (2603:10b6:a03:39c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:02:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:02:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:44 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:42 -0700
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
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cb958521-10f7-4301-b1b8-54784e3d88e6@rnnvmail202.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:42 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|CH0PR12MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 4750d14a-88c5-4f7e-3be7-08ddeee8b257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGFZYmhxeXJkYTJJVWFtQVg2WmZ0M01RSXVWVFUvcGlINzgwZmZXV3hDYzBN?=
 =?utf-8?B?elp4ek92MkdzZGd2bkt4UERtRjNDcVVtTW94ckpXcUlRMlU5MkJkaDVkdFlX?=
 =?utf-8?B?QkJlT3JnR3R1WHZISHB4dCt0MDFaVk9wUVRsY3NKMzNvd1Iwc0F2aWFEemZM?=
 =?utf-8?B?UWFLRnZQeUNwN3MwN0ExbDd6cGEzeXhmNnMwNDM2U1pLczNzbTVWT1dwcGF2?=
 =?utf-8?B?c0lZRTZYVkQ4STJrUlphbXVlc2VLZ3BCWWdNV0VGYWNPakZJRW1vZktOSHJR?=
 =?utf-8?B?K21uLzJtR0V2RzRVcTJXTk1yUjdHdEhhanIyMTN1bWhCdnVpbWVudjRwblZy?=
 =?utf-8?B?YW5waXlzZmdjRXM5THF6UHhKWkM4VnB3cGR3SlB2QmFLYkVoUHVyUHJzYkdN?=
 =?utf-8?B?SE1GNVlkL2tlK1ZoVXk1blFObFpsa2hnK0xiRGx1Tk5xQmhnK2xtQ0JXY3d0?=
 =?utf-8?B?Q29tRXI5OVQvMTM3VDAxTXZROWl3NENXbVB0R3JOVjc4OUtJRytmZzFuU3Ru?=
 =?utf-8?B?bnkzM0h5Nm13OW1sdTVpaE9kNFpublIvUlVpUkhaMjQyVmNmOTdMTSt0NVBj?=
 =?utf-8?B?TXNCOTFuK3RCZlBFNTRua0s4QXZwWDhHUTh3Y1RuM3d6VjFyUkNxejhRczVN?=
 =?utf-8?B?TGt5VVFLSW5QWFhFSk00OXV2SktBUXRVQTJjQ3FidE5uTUpLY01yQVMrYmVo?=
 =?utf-8?B?bCs3ZFUyL0NnRGg4RjhxdDFGVE00RnJEcWhMUDdDakNJTEZBTWU3citYa3Mz?=
 =?utf-8?B?aHgyREVSaHlnbmZKMm9uVzJsUEtrU0NQaDZ4Z29wcWJwNnZyQUx0b2xOQ1BN?=
 =?utf-8?B?M1N2Mmdmb0xCemNYMTZpNlZyVXJ0ZWNnMnpKRCtvN3AvZjIzbGhvL3ZPM1Vn?=
 =?utf-8?B?L0dRMDlHdFNFVEloc2RvbE5Mcy9uNmRTNGI0TmF1eXN3aXJnS3hndCttaHZq?=
 =?utf-8?B?WWZibC9aanhXRExZbUVnb3lSQWZyYkN6NnVkQnJORFRwZ1Q3V3RyNUhwRDl1?=
 =?utf-8?B?bE5lSnUzNGw2am5sbXR4SWI3bGxwajlGK3g3K0ZjVWk5WmxZWjY3a21oVDVw?=
 =?utf-8?B?Qnp3UmVYN2ZHbHh3RmVoVElncjM4OUpFT3JnSTc2dmRJMm8vR29xV1BDQTFp?=
 =?utf-8?B?YVRiYlJiQnB5bDZPUGlsZlFsUmt3TlFtcCtnTGNPVzhyeVJrUzMvQjJZbm13?=
 =?utf-8?B?bHJoREJTSzMxTlFyNk8zd2lkUG9BbFZOemZ6VVFLQnovbWZWVHRVREY1YXZu?=
 =?utf-8?B?ZWhHeHFnNXBDU1dwWS81T085b3RMWTNpbEwvYTVOMGNvVDZhQSs5RnQ4NjZx?=
 =?utf-8?B?UDVIbnB5QmJlNHRDOGN6a3JjakVwTExYOHpRNUNibEJGZlVkQTBzYURiUHNU?=
 =?utf-8?B?dkQwUVJtTVB0dXk4QklhT1hFaWozSEhLRHNneXB6enJTM2RGNzBkSEJvbExK?=
 =?utf-8?B?S215Q3NyMDdQUDZQME44L0k5c0pHMGJqREJUZFNHcjFYSElUYlhTWkl2Wml5?=
 =?utf-8?B?K0xNU2lob0hkRDB2UEcxV2FkVU9pMEVsM0xjS3FXdlNybVpFd3lFeFNSYmYw?=
 =?utf-8?B?cHFkaGM2WFJTa1k5Mk9VSWFsN3R1UXZ2c1VraldtN1BqMXRKNDIzRHpjeWZ0?=
 =?utf-8?B?Q1pDbEdFSjlOeldIYkhqNUJpMURUYlhMNEhSVHYrOFFNZFg4QzdobTdTSWhZ?=
 =?utf-8?B?SU5iLzEvM0I0c1JpOS93bzVSTDlLdktpQ2tjMkJNSFpEdThVdXBCS3pkcUhZ?=
 =?utf-8?B?VE9kVVdPWEhGcVd5TGFheDRFQ2VuMTFCeEo3eVBCaHB5dTFxUFR5eURRaFNj?=
 =?utf-8?B?T3FsYk1ub3BsMmJ0d040azJZT2hpbHU5V2tUY3JOb0NONk1HbjFJRE1MWXNm?=
 =?utf-8?B?T2lZRFNabTBwSTlVbm92dnE1Y0tNUUQzeUQ1bktHRGxqc1JvV1k1MXZPZC9q?=
 =?utf-8?B?ZFRtUDRveGJGdmFWWVpBQlZNcTJvcWtMSkt4TXphTWd0UXpJNHNzK0plTGpn?=
 =?utf-8?B?aEdkRGl2WkVxZXpFdWxHZHRuY0NJdUhaUENucnlsMnZVVU85L1kwcklTc21P?=
 =?utf-8?B?MGFvU1V1ckt0akh1aWdHcnphenUyRVJmeGVsZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:02:14.6996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4750d14a-88c5-4f7e-3be7-08ddeee8b257
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8551

On Sun, 07 Sep 2025 21:57:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    119 tests:	111 pass, 8 fail

Linux version:	6.1.151-rc1-g590deae50e08
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p2371-2180: pm-system-suspend.sh
                tegra210-p3450-0000: cpu-hotplug


Jon
