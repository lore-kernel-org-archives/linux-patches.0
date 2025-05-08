Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59BC23DE
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697573; cv=fail; b=D+eijLjW4k8mp7zpPGpsKVZqLp06JFykujUqbjfriDh757u5UsjoWPdqLdRNN05U06QKjLYwj3jL/bc7Lmx4RilqPPO9EqAjEKTkJQVwe5VD+molNNNqOUE1B9hqvSRIGsT9htHdofG0bmmlRbHJNomgBfHYdGrcJf+MU2+dDzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697573; c=relaxed/simple;
	bh=5Ofuzq3h5Vq3dNHUXfoJSWD2nh6W6Uu041KKoFOuHp0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=T1VZEwe0Y0rf80u2WeM+dqbacS6A60veatDbHKKIs4gUFWvOOBQyEK7S0PVs8P5HBL6TGJEu+9WDfkKeQLf4j5pHDRLHRXH9CY2f5vADB9RNlE/f6+EXqmLi1MUkhwMz2zdjssGQZ4GP9PeU+PxYkfun9W26TNMl1hQfuCbneAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BUB4obXm; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BUB4obXm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G1k7bFOFY6P+i3y6wU85VB9W0GSSvXkHFcxrj9QrxOAR0ry6W4brCDFf8xp6P0KbJ6FeeNBIl7lrBClPDoQUxJ3Vuav2KFhU9GWGU+lT4H8gC/+Xb4QuhvjkznbyNIHSc3Li9dDgvebxsgre20L8ZDJb3ub3rmSupHi2LZfnMBl0kGLZvqRSuyPhqMYMQWr1zPbP75TBjDZRipoSFbBZFibTtwU+MdwluL9yadXVNKSmv3b3NBVX0Cq8Atqtgz17/L1WB2GhVADy0/vssj3b/hAGkYgB1nJz9bB7OG7V2wTqoIWli7Y37QITbIDRkNwPcb3Xy0XdQ6Pnl/GQBQj2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1gfuG2sCbL7dqilo4hx/AOyrqv6smqIs65rYXwXEJs=;
 b=D0nVesHbixyrkhfdiGoqu2qhseJzrTa8F/hxhaCJm1lDrsabuzK9u27POrHQSgx43WLDDzrT7HN7VyBbBMT80CG2gJlMzbn4ZDBPwiP9ygkvxO5WILV+MCASeGxqxb3OiG7eMkDwkRhc17s8MRwJmLN+TztoO25Jtf/ulL8rLFX+3cuCGcTcYbgJg7BuBz2dTrFgXr2tLC7UogDhNLzegPHzpxvqY8vHf4tSqNtC4bBPgj2GQNUSp/+kVCM1vhceMyZTHDaFPSctmLDtZoWjLxJiuk1T7NDh7GcPReyxGhtI5PR0XdCpz5k2rodve5tNRRcnECGQWNUwKCGUhafdrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1gfuG2sCbL7dqilo4hx/AOyrqv6smqIs65rYXwXEJs=;
 b=BUB4obXmPqO+Z3b/w0rJ6tzi3/rlhmg3NO1QYvifpL6JyFN0lvAa/ZweUq6B8RlZzwlysI+Sw5Y5IiMAEcphFAs8EnnmJKXA5y2aL6TGns3+YvtV7L8y4VvjTcFp2+PAthtq6Cbb1oEZKdy5QvHXfCaAgMv8AD+WAtpYcGK6GN1t9nEe1j8dZLgT23MHtL1OZy9zNyR8kKpro3EKfsuXIi4MNZrgL00i3k5lKkCL+eLaBRFteNoYxzBePsvoQT1KK6yg0uvmFaWX4lPEYL7IkrLA57LOLa38mCVKEtudX9MqtLKpRkFLKB2SWNgJlkCiFtuvMgIHS1svHQ/PmJ3TnQ==
Received: from MN2PR08CA0021.namprd08.prod.outlook.com (2603:10b6:208:239::26)
 by CH3PR12MB8877.namprd12.prod.outlook.com (2603:10b6:610:170::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.20; Thu, 8 May
 2025 09:46:03 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:208:239:cafe::bb) by MN2PR08CA0021.outlook.office365.com
 (2603:10b6:208:239::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.29 via Frontend Transport; Thu,
 8 May 2025 09:46:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.3 via Frontend Transport; Thu, 8 May 2025 09:46:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 02:45:41 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 02:45:41 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 02:45:41 -0700
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
Subject: Re: [PATCH 6.12 000/164] 6.12.28-rc1 review
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <eaa8a5a9-1442-474e-9e5e-b7c0db0b948c@rnnvmail202.nvidia.com>
Date: Thu, 8 May 2025 02:45:41 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|CH3PR12MB8877:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cdf9a8f-19a4-47c7-6e1b-08dd8e1525d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1lvdGpHc09JQ2huNUdkdit2VGpEaHdlUDlRNUg5TmVGNnRQcDhYUkdJaTIy?=
 =?utf-8?B?Z2d5cVJiUHMvSWhCWXJxUHRoZzR4ZHN4Sm5NNWp1OE1IYVFod2dUWWdkbi9C?=
 =?utf-8?B?ZkNQd0V1bW9UaXdHYkpHcVBjMXF4WEtCVS9yc1BHMGJLUEJSckVFN3F6aENa?=
 =?utf-8?B?TG9zeVFZYms5ejlzamZ4RU03WVFzb1BxeFkwcVlkK2ozWVB3TkxFRnl1TklS?=
 =?utf-8?B?K3JPb0dsN0U4Ky9jOXBrblR6SkJoS0NmNmRoSnlRTHZYU00rT29CcTBZZG5V?=
 =?utf-8?B?d2NkUytUejZnb0hTU2ZWa1VLZmF5THVqekJNNFB4em5iV20rOUFEd0xhR3dl?=
 =?utf-8?B?YkNvZmsvRENrVVdEV3ovNTRyNDRpOGpYd3YzaGtoNmhBQThwV2dGVVJaTmdh?=
 =?utf-8?B?ckZucG1OQ3Q1aVBnU2NxclQwZUxiSVVHSE1RMlJ4VEtkejh4QldranIxTzhi?=
 =?utf-8?B?ZG9jYzJld2xoSlBEMCtDSWlmdWl0bzF2Z0pSanRKVS82ckJPbTlCclAzczRV?=
 =?utf-8?B?RTlQbSs2bGlZMnJteXpHaURyb3BseTJlaXVzWGdVWWtzQ1pZdi9wMVF0bWhL?=
 =?utf-8?B?NndWUnBSYW5wL2FEVGpsQU1tUEhBSENXNmp6MW1BNW1oU01HOWJzSi9na0Uw?=
 =?utf-8?B?bUVtbjA2cVVNN1lwSkJ5bEZ0WmhqTUZEck50dDMyKzVXaDQ0enhLckRoOFdh?=
 =?utf-8?B?bUdqZVM1VklWSjhsSFZjS0Irdi9RZytlKzdHT1UvdklrVjhwWVNhZ3NzWk9Y?=
 =?utf-8?B?ZmhxbnJ6bjBPQ2FVcGJLQmJpVUZHTkNROTNlTzBIZ2svNVNSZldURWs2ZGxi?=
 =?utf-8?B?OTRzdHpoYVp3ZzlwZi85ZHcxeTZEZ1lnRXhsaWdHMnFoNmN4SjdheitEWG1K?=
 =?utf-8?B?Nng4NUlRKzYxR0MxYzRZMmU4TTdzTW9IMjlsWjZUVUMvMENQeFZhZVNBY3lv?=
 =?utf-8?B?cFRHNFV3dGFmeUF5NGpKZSs1MWpMRkxrUG5LdGMxbDkzSFpKaFZUcVA0N3pY?=
 =?utf-8?B?RTBQeUFCTzVzVDNRMHg0b2NkZGQ1d21QMGx6NWpLemVpUW55Q1BwMWJnVFM4?=
 =?utf-8?B?aFdOUzZvSjR2Y3lzY0tySUl6OC9XODJZNEVJL1E4NlByK0VETllCSHBkaXFa?=
 =?utf-8?B?cFlYTnU0TEtHUjlQcmRFV05xcmFsczhzRW05Nk1WYzBUTHRVR2N3dmswZ1pu?=
 =?utf-8?B?NHBVVkhBUVVSMHhvTzN1OUpqSkFLckd6bXBneWpWQ0praVAzQkdMdVdLOHRy?=
 =?utf-8?B?aktNVFJ2ejhSbFYxQlpWd1VjaUh6NzlJdEZxbGFnM3lVYktia0dEQUk1dEo3?=
 =?utf-8?B?enVLOFJDUjRHSVZEMURZZTNyM28xeVZ2V0Z1eGcyRisrMjNhUnkxWXVTRGY4?=
 =?utf-8?B?QTJUVnNQeE1zT29OQlVnalpTTEpNQklxR214ckdHYmlWTUJOT3pmWFZpR3p4?=
 =?utf-8?B?bTBhdU02REFiYkxOL0pEZDdKbXlwM3pDVUh4K2RQR1hTYU9MNkxVTzM3a24r?=
 =?utf-8?B?N2U0SXZ3OEEvY0o0Z0c3d3dGMFkvanU2TG9SMlV6OWJjek1Fays1Wmdxa0w2?=
 =?utf-8?B?VWExemNPZzNCS2JRUFFHNjYxN2VjRXp5SHNhRS9DNmVIR1JzUkFUU0pqd1ZN?=
 =?utf-8?B?MDZDSU5MVHMvZzFPTEFzYUp1THQzOU9lVG9PelE2MnRPejh2dEJ0azFRdHJ0?=
 =?utf-8?B?TzhHZU1PRGxVRjFZNHErZThsUENZRlVSQWFRaDFjeWw1OFJ3dVZ3Mk01Rk1K?=
 =?utf-8?B?V1FtWGk0K20ybkQyZktNaWdrVEFXbTk5T1dBRHc5SWg1TkZuZndUbFh1NXE2?=
 =?utf-8?B?RU1wZ2Z1WGV5aTc2d3RVWEw0NGlpMUN1RXJ2RkdQM3lWK0ViZXJ1OHBka3BT?=
 =?utf-8?B?bHh3MEYvZmpMOCtSSmRqRFVCbWdWZXNtWm9SQklNM1g3QVhURnUrdG1ENmxD?=
 =?utf-8?B?K2pUTjBweERrZ0g0dVNaLzhtRVE3Q1N3Z2J0Mno5Z2xHUzZuUUdhL2RsYklu?=
 =?utf-8?B?ek1DZlpLNy9Fdm1aZnN2RTU4dWVneUtyUDUxQnhMckRPSUJuNDlMcGlhMEJj?=
 =?utf-8?B?R3hHa3A5SkR1d1hzeWI2UTVIVUtmRFBFZG53dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:46:03.4413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdf9a8f-19a4-47c7-6e1b-08dd8e1525d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8877

On Wed, 07 May 2025 20:38:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.28 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.28-rc1.gz
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

Linux version:	6.12.28-rc1-g483b39c5e6de
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
