Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8BD28DB52
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030089; cv=fail; b=MYIsTQ77ROgXCbZ/DEdadTDHi59Qztw9d0wzV5n2ZKc4ZdMfGrLt3ZXeMzTracuNp6bN1Lq7vkXpTpJHt/6euGgqkBHX04oXI05/iUjojhO99igJZVqlAf+OVd/45Pd4NSA7MAEdjZd5GRdAOWmnm+5B+S8+5GFLzb83OFE4Ago=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030089; c=relaxed/simple;
	bh=gjxhwYbGo92hks42UxAKpaVlWs7W9b1tGpLJ7mqeCBo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bcNNO1bcX6nQqoWvJA21qN/+H6zA8c33wkGFnT68c8RbZTFSrrSpltvU+8OBsjK5NZYkXQ0Y2zrwTDS1DMmKBll6jnITAKETfVi2cDooT0DVHJDeJ9h+kMqjRHKepJTz4ixEOD/qoVmp7IuR7ASXeXNWVeQrLimvTlY1H2Xld0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WDYHCApT; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WDYHCApT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXb5QPYchdI1yT+7Vc43yGuXzMcQ/XWHEJPU5NP/rYVwN+/rl1lqyUc76zrooaepXD5A2GU7zLq1oMM6NtHLKT2s+PvosihY/E9Ps90LfYjL68vobbW9FV3GcoFI+YMldwKDj5VIhHXqr08Q/23MLnxKeGvkfJ0QjPranIqpGTqzjLhzo6qcNJnCzFuARGgrqOC+n2glnIqMyHFG5DcflfNVztat6BcllmG9v764oo65Xwr8GE2fjDQg1oAiSGxX5MhrIvBKDzI3jPqkEhtT97DrrvWuUVyzwIwWY4m/A2+znS8/CGm3Y1lNsspxLzsqSJ7KwCq0IRZMvMEjy80urQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SK0f8AHC9uTOjTqqk7AdVSqPEHJbHHifPBz6DCiB4bI=;
 b=bOTNL1VZMH9Seb2aTW5q4kSvVu4+qYdTtEmn57NUje4Tl5ycEwrj+kZvCrif4a4FHMC9Z5jqpCQ0JAKSQ90QkWG5bfIK1vGXzZIyazEnf/+94aa4U9wBBsKx2dHXzOwpjVR201eJKhGe7eZkRUWCm6ylV7qUoWFB4INvZ7MioQeOzrSZ7MnIbBEnbQMvObxDzLE/2D4LltXmFk2LgpWSyalycuVqNRHHySK1j1UswjKxmqZ1XsaeVwRKf+NtG72pidKVKjSVCkGg8cp5IcvoHTCcdSXrpqEnH0e0XK8fX+YYTIqYAX9PcoDzG9FdDOfck91g3P6TAjReaD5KAkPAGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SK0f8AHC9uTOjTqqk7AdVSqPEHJbHHifPBz6DCiB4bI=;
 b=WDYHCApTlYBA2C91l8SetbqO9IxtF5E3/gppRABJDVdzAMOX2kQRT3cFXtKEpD7Idy/GLs/34b+xiV6FoyJe89W4M/MzZFikkTe6Z0mtxKuQBDHTYlRMTXpds6u/2AUK3MvQVBLPfINp0oRw0GUCyAgttAKQ5tld74wRIax9sF1b8Kiipf6N7kA8h9wsl0ZJjsVXGMYdWZ/0EnjvxuTywa6cMqIv3dQ8KEZLgWi1aWRHrWhWtPJDB0RXTSbUgOL4LwxsA7CfAHEET4HE0h9vrkh7PmAh9ei+6wTQNzpfXgIS/EBjda5Kxw55e2vrcAVBkCjnHMyxnxA0Fs9DqTa5tg==
Received: from SJ0PR03CA0065.namprd03.prod.outlook.com (2603:10b6:a03:331::10)
 by DM4PR12MB6134.namprd12.prod.outlook.com (2603:10b6:8:ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.34; Wed, 4 Jun
 2025 09:41:23 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::93) by SJ0PR03CA0065.outlook.office365.com
 (2603:10b6:a03:331::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.23 via Frontend Transport; Wed,
 4 Jun 2025 09:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:41:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:41:11 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 4 Jun 2025 02:41:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:41:11 -0700
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
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ff0b4357-e2d4-4d39-aa0e-bb73c59304c1@drhqmail203.nvidia.com>
Date: Wed, 4 Jun 2025 02:41:11 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb2afa6-cb9e-43eb-edb9-08dda34bf7f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUdhWFJuQmhFWVlLZU50V2o2U3E2SzFNMTJQUkxnYnpWN1VocVlYQnRyTFpX?=
 =?utf-8?B?djlpRXBQNHM4eXhZOEt1bGd4ckFLa2xycFA1ZnVXTE52WXo1RGFocERiYW91?=
 =?utf-8?B?d0hESmxWd3o0WXY5Nk1Oai8yK0ZJTkp6OTB4NmR0WHRhMFlEaXVNYTJWVVh2?=
 =?utf-8?B?amhuZDhRM1l6YXhMRTAwaDQyd0RLOW9HRVc0cWpaSGFGVW9uV29JU0FaZ09D?=
 =?utf-8?B?OWxJMEVFK2ZnbnkvZGcyS3JLbUR4VUMyUDhNZUlFdzE3TkVOdmdaZjZhNjJC?=
 =?utf-8?B?c09Bd0ZZdldYaXlRWmJRRkdlOGp5L0kxY3YvejhibzkvVXYzV2VtR2llL1B3?=
 =?utf-8?B?TXFFRmMrUGFIM0JDNGpkbFpKSXNzM0ZTdzRpSnhKUGVLOTJpQStFT2tGUWlK?=
 =?utf-8?B?blZ2Qyt4MFg2bmFaaGxXS0dFQmxSNzVUbHNWU2s5TjdsdHF1aWZLYVpBOWZq?=
 =?utf-8?B?U3RnWGpWbTYvRllSOTBKSFR6WWhjRmpJVC9JWWlOdDJzZFFBanNRd0F5d2Ix?=
 =?utf-8?B?OW8yWUFpUHcyU1N5TEtzS2IwbkFYdmFjdUU0c1c4Q0lkZjdBbnRYcG45Z3Q0?=
 =?utf-8?B?MmF3U3ZzbTdXSElOU1MzZnBodzNiUDU1bFdBbUN6S3pGQkNCMFVvejZHMDRT?=
 =?utf-8?B?WUpjOEQ2RXJtQm9zaVJpeVNqVGhZaklUazVZanVVTkR0NFZwOXp1UkFWcExC?=
 =?utf-8?B?Q29NTCtxY2xwTUJZa0lCbDJRYWRiSFpsUmxpQUtzRGdua00yaHVDUlJ3MFN2?=
 =?utf-8?B?QVBoOGpLLy9ySUFKajRvTUlGSmUyY1pqZHkzcjZWTXlrYlliTGlCck54b3dK?=
 =?utf-8?B?Zi94MlZVa0FvWEwySXp2a3RkZXpNcEMwMzFhWUlHRDhYS0FGSk5TM0ZmaEM3?=
 =?utf-8?B?cWIycGhLRmRSWDZ3Q2dUZTdDN3dsYncxSW9PMHprSEdKandLLzlDbXZlb2U5?=
 =?utf-8?B?L3hMeGdaSkthUnhkUW9lOTBZVVUzS255TWNnSDFaODRTTFRuYTF1SThEbGU5?=
 =?utf-8?B?a0h4eEJCSlVNUC9YSW8zTVEyaHdLZjloQzlJRnRZYnkyaG9QYitFZnVBVzZR?=
 =?utf-8?B?NFIwb2MvRXlGVUN4VjBxYmxjZDB6ZnBKU0xDdUZmbk1jK2huRi9MOXBqZHhq?=
 =?utf-8?B?RmxJVlEyTUVsT2hpRlZxTVN2UXgvcWdQdWtPczZrMHM0U3h3Lzd0WWdvMUgr?=
 =?utf-8?B?dGhkd1p1d1ZheGVzUHlxYVRuM3FFbVlSdVdORERJeFN4a2o2NklWMEJWNXBo?=
 =?utf-8?B?WjdMZ05iU2FYb3JkaG9ZM2p2dGJMUGZ0YmdKYzJkSUs5Q2IxSllHZU5MbHhr?=
 =?utf-8?B?OVAyZDJZTnJZWWlJclRPdk16NUwvQ2NsT2k5elRTTGtWUUpJR0pSemJtcGYz?=
 =?utf-8?B?TlExWVBma3UvbWR4SUNxQ3FQVnBBQ3Q2emRNK3g2L2NUTUpVN09RV3BMZlo0?=
 =?utf-8?B?RkNpS1BGUzZtbGNrQXNraHQ5VTFNN2dJVFBtaEp0cTVGMW45WFNoQU5nR09z?=
 =?utf-8?B?cytMK1liTnU2cTYveVJxNzZXTnpXeUUvN0s1SktSZFZHWWp0bDB0bUUxZmRq?=
 =?utf-8?B?b2NHQTdDeFl4dGptSEhScTdDK2YxS0ZFZkpmeVRjelN4eTBXWVg2UHg2aFhR?=
 =?utf-8?B?VUkrQlpxMFFLUWZaTittWExkOERoT1U2dkFaN3hnWlBKVWRseHNFb0VEaVlM?=
 =?utf-8?B?Ty9ZSTdIa3RoOVdmWjJ2bE1PUmpCdnk3ZUhvcENESzZueVpVVkxjbUlDQm9k?=
 =?utf-8?B?TG82Z1J3eUhydVJCS0d3UUlPY0dMbVZvOTV4ekJqbTFBZzZ2TlJsVGtJYlZt?=
 =?utf-8?B?Z0IyMXBrZ2hFQkFuckowK3VkaUtJSElrUnFKSXBZdTd1Z3hqV3pOc2lsSnRN?=
 =?utf-8?B?Qmp2dHJVWkc4VVUySkN0bm96UlJhNnpjWENOWFFQWENnVnlLKy93aFF2aUZQ?=
 =?utf-8?B?R2twWXdJTHhDdjNidkNIRHdMZXJkWFBCS1Q1NUJoQ0dSN0w4VjMwY0t5MHdZ?=
 =?utf-8?B?VHdySUNoWHJEY2dTMldhb1hlRWNxN0xyYk5RQm9QSGMxTGJYdmU3ZWI0NVds?=
 =?utf-8?B?VjU4YmtnU0pTdFAveDVBVTE4OEk1Wk5uNlcwZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:41:23.3781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb2afa6-cb9e-43eb-edb9-08dda34bf7f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134

On Mon, 02 Jun 2025 15:47:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.12.32-rc1-gce2ebbe0294c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Jon
