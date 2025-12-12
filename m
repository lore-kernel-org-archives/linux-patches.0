Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012041.outbound.protection.outlook.com [40.107.200.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141063128C3
	for <patches@lists.linux.dev>; Fri, 12 Dec 2025 09:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765531585; cv=fail; b=Q9dOqxIgXe8J9yL5XxqgOmNDH/SHRwklqXpSv+4VemeNWS0wd+k1nXRqTwpoAMaz5l/qZZcuTFaI/trCDQC4T9txhxOm7BOf57Esv1sn4CLCOqu0gxveYaEAnfMOX5z7LKiCVcI85F5bah8/PHMHXpayjDvmj1c9Fr6vxBYtZOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765531585; c=relaxed/simple;
	bh=iCqv2/73Osj0rxxiXx57hH7hjXlABrESkHrVIPvTFeY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dOh00LX9p5rDksAZd4BQcVfXSOT/krffJ3pF55163XPWMGyQwQ9l7rt26hqcFv+mwtxHE9OW/50nKGQgJqDDnKfhWwg1Qg47/leh1s+UXDyjlim76Rvqus2m9A14nVWq63DA6FsCNgD1CB6iKCuZkrS60nsyTgazDL8S6ezIKus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z7MrkulK; arc=fail smtp.client-ip=40.107.200.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z7MrkulK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBsF8sZK87QFupQI5L26I/50JSbAbN0JBI++Kaz8qNFNyH6NpRlt4nUOHFSYAtPcV1BTuduVMgGtTTb0QwyGiSHc2cGT0wDalSXH9ZqYYNeimE9OkKLgwi64Geab1PwI5vq2gdvq9WaQmM7veOGqng0LjleFPpanVFwp4NcLoW4a1i7vbA2EZuMv69T6vWj7DFP835t8Ygdly0bCmdKyqkkHKS7T/6bEQoG6UGzLm4LWbhOnSIvMPfJs0NSf88X4Oe+1PaVg7vqwDsGUrwGEyssdEMNcWjLsu90pHEPwnUc1O4IxFeV+ZTBIVoRGNfByqmWzEcB8DxF0FiJXKO7ejA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGbFAPSX2ceDX8D54FD1Br05dRzdhWmtAJK+W+KYTPM=;
 b=uX2aMAsXnjZs40UvM6Xmqsbt2p526Id58cz/qRnM5DpsVTIohbe3FRE8KUIsRLs1SMV6HPn+z9O8DlPju2stw+u1TJq5cjfHvIdgA93GpoXl4pnWpcBvZjRVQviHqFAeGUH5j0GS4PMd3rSTq6/QVqPRdz1ylr3QSiumYNS2+Q+uaOZbPZd/sdOL7GBSoNAAzYASFMUKhNjoDglWcRnzM3Jns1dxpUou7d29i6LNzYuvTlHIkwjJCjrD9Uy4CW9xOnXhvUsX5POgCdVwmUOWZ65ypjt8jksyWcgQ+u5XueJ+dXvC8+Bj0VIhIJ5FSrVijwRPMR9p4VH2mdj92jIiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGbFAPSX2ceDX8D54FD1Br05dRzdhWmtAJK+W+KYTPM=;
 b=Z7MrkulKUHeNvOvhxPOwFqtEpvs0+NEPtfaYNj6j9cqsV2T3fwwwj/JSMAXbXXw9HV8ddO0mojRjRGyQd+aDaEMJa+u0npyKqRSwU746MXBdkRCyPYWVVwuwtMar7+es83VUIvdp0HI5LJ2b5pAYYdZUH/+tHE7IabdJjGO2FxHHnuzzPqUBgh+eJH/+zCy7NWgsCP7t5ToxnlgllcgFIxx21Ko5B+xBodPu2MB5+4v4qhR0r3x6XowxIVlphzRVBTIPBcbSL77mHp8VtugTI21UY00RWQpk8D33rP5SFEsQcXkaJaEez28TkVCvEBPVX8EAmKCWaimH6X7WPPlpVw==
Received: from DM6PR14CA0053.namprd14.prod.outlook.com (2603:10b6:5:18f::30)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 09:26:12 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:5:18f:cafe::15) by DM6PR14CA0053.outlook.office365.com
 (2603:10b6:5:18f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 09:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Fri, 12 Dec 2025 09:26:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:25:56 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:25:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 01:25:56 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b7cb8522-4ba9-4048-854e-86ca6d5c4d53@rnnvmail205.nvidia.com>
Date: Fri, 12 Dec 2025 01:25:56 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|SA0PR12MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: b756c233-739a-4fe4-0d91-08de39607db0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bk1rcmF6S0VPNSs5YjVmTG1oQjJiSVJlOVRveVQ1UkF0bE55YWR5SnJhTlFC?=
 =?utf-8?B?N2hpYzRQZG90a2lvRWlMNW9ZU2NEZnZmdXFsdEp3VUVvZHVUeXdBVTg4ejA0?=
 =?utf-8?B?czllSUZWQXk0WXFZdW9YOXd5bUttc01qbkxMc2Nsa1V1d3pidWR0akwrQkFN?=
 =?utf-8?B?d01UbUFLalBrQmRqa0VzSVpNaHJTOVpDQi9CU2thTEl2cWE2V3JkTnBCSHJL?=
 =?utf-8?B?RHk1bnVWUGtFSjZBaEtkemdSc3M3bFl1MHdaZFc4eVlVZXlyWlh0TnFub25I?=
 =?utf-8?B?azYzSVNXRDZ2dkF0RjdMZXRnNStTckhhcjhsb0lJKzhTQ1Jhb0RGa3lEcndZ?=
 =?utf-8?B?M1NDYnVXRVBVeUp6dmdIakZoNjFPdjBHRUhGQkZPcVJGQXUxcFlFNWtpdGpi?=
 =?utf-8?B?bjd2WXlhMHQvZTU4bldnMzROVmJKazlIU2w2SXZyWXI5L01NdU8rWGdKdnpm?=
 =?utf-8?B?c2JGV2tUenZFZzNGKzB2U3FsNDVBOUd4N2tlVXg2SzloWmVQc3M1MTJESHpq?=
 =?utf-8?B?Y0NKMFh4M1RvVUQyTVh2blNwelowUkFjd3VUYzJXSGE2VWZUWGZNMUc1S3Vh?=
 =?utf-8?B?MjhCOTc3VzRHelpOM1A3dXlZdWRNLzNqV09hbVloUm1YcWhubW41dHErZUUz?=
 =?utf-8?B?NFZzLy9Bb2s0OXpHTnQzU3NMbkV0cm1waG5kdk9NdHpHc2F3VUNNYW9oOUpV?=
 =?utf-8?B?T1MyWDJFcktGamlzRzBpYTBSTkw3Vi9TMUhUUFR4VHV5bjk4U1Z0M2lNekZm?=
 =?utf-8?B?azM3V1BGZ3hZZFlnalE1TlM5UjM0cXU0NGJsSkVWWGxvUDJVaDEyYXptZlV0?=
 =?utf-8?B?ZEVnTVJUdGU4SFNQLzdGd3dXUWV3ak1CQnlPUENHZVhBM1hWNC9VRE5WZHVi?=
 =?utf-8?B?bXhlR2EwOVBVV3lFUDBTQ3RrcDFGUWdna1lnb1BBL3hrbmRFM1crOWlhVXhz?=
 =?utf-8?B?NUVaTDg4bGpycFJTVm91U3d3WDFrVWNTTmtFWDl6QTBBc3NmZm5pNlUwZXNz?=
 =?utf-8?B?MitOWWdGdy9vSlRvV3ZGc2VDMmFjYXY5SjdUaFlzRVFYQzMwUWY5K3N6MzVO?=
 =?utf-8?B?c2FycW1GS0pTTFh1NjQrQnIxQlAzeG0xRUdzVDdOcW9Yc2JadVlLaEVDLzRG?=
 =?utf-8?B?bTJsSE8vU2NpR2lsT0VqU0F1LzlXTE54dEhuVHJoZWpDT3VRQlRzbDFsTzMv?=
 =?utf-8?B?ck93YUdUNExsL2p5ZXFKa0JuWCtlQW1aNy9WQks1WHkvbHE2b3V3TFFxK0pa?=
 =?utf-8?B?TnNkZ3YyMjd3cVlxM3JwSzhFVjJsWkhsN0phc0hkeWg1RGNVbFpXcldyN3d6?=
 =?utf-8?B?WE5jb0hqN1VFbE81c3BIWGFPZUVOaTNDUHVMTkZqdENCNmpIVGdhK09xZnVD?=
 =?utf-8?B?NjU4TGYySTRhZ0NMcjVGL29FK0pzWTJuYng1dDBvdjR3WmpaQTN4T2tWZEZQ?=
 =?utf-8?B?OXRuSnR1UzNrVXVsVDVESWVEY0pTYVpTWlNNN1pZaEFKM3FIZytYWU03RTVJ?=
 =?utf-8?B?c21EK3JtcGM1OEhKYmNQNlN6Vllub1cxM0VCSWdCMGJPamQ1ZlBJSlJ3cUdi?=
 =?utf-8?B?akRrRkVVcXlpUU5WOVNxNzVuYmtDMzNGQy9NUVlTUFM1WWU3ZHVndzhnSmhw?=
 =?utf-8?B?Q1RmRGEwRkJaZ2J6Ly9Ia2RUSmkwc0FUU3BNSFJnNTdxTktLcy9NTlgxTmR5?=
 =?utf-8?B?NmpicG9ZVlhJS2lUbEd6MEZiRmduYzFKdGJJMWZxTEg5R3JKeHNtTWUzcXpl?=
 =?utf-8?B?c3gzZUgvdG54ZngveDRQc3hJTW05SzdKa1VEKzRua2JOZmVYNk13QkQ4Q3VT?=
 =?utf-8?B?QzR6RjVkbkk3WVRyY1B0R3REMThRKytPRE9vNDJ3Y0VJUzRRYVEybE9MeG1s?=
 =?utf-8?B?QmZIbjFyZlZPRFJQQVArSUQ4Umt5T0VESC90cmF3b2JtS1lJVjE1ZnhRUVBB?=
 =?utf-8?B?Y1F1NE9vdDNyZU1kUENtZE82bUU0WkNqTEFIdU1KRWtTUkZ5bnlRYVYwVnlO?=
 =?utf-8?B?ODRTSmpZaHB0cFluUHgyOGwxYzJOZlpSd0JFNDBZbm05RjB1SWdkTkpSYW5v?=
 =?utf-8?B?Ujh5RFNCUXgrSFhZTFlJajB0YUdVVktrMnJFa2RXTHEwU0Nza0xqeEZCMXMy?=
 =?utf-8?Q?fUqw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 09:26:12.0121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b756c233-739a-4fe4-0d91-08de39607db0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382

On Wed, 10 Dec 2025 16:30:10 +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    113 tests:	113 pass, 0 fail

Linux version:	6.18.1-rc1-g7d4c06f4000f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
