Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F3320D50B
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228930; cv=fail; b=Vih0xbFI66MEo/koZa1Eamr63Akr9vi/Nn18U616wsfgnZ0BVRiNrHSaYL0oFlRIhCa8KMQJMqpEcpBOmLuSmUXcU3Gaw7rI3WH/yy308vsgc4vZhWDANTYvS+XPFKHF/Ha+uviz3sswE7XIppf5OVtQJzFgrLFfoiRDcM9esak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228930; c=relaxed/simple;
	bh=Hd/uqy4I1BkFsc3wdbqlG9KwpPlM+9+LEVFTJoEYehA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JBeoIDxzhbE4VF7J433nPnumV+qSteBnQqGuRhp3Xxw+a12yr67xx045E3ecdbiIGDdOIWdBadFcJv53t+tOt4xbpbdSvhG8f5drk/IfD6CQ0W+pciBhmSiI11qY1fYw0y06yC0n2FOQWZM9W2XG8eFPdUaqfyuRl9MHkZPgsi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WLRT9he5; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WLRT9he5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqSUF1CGHDePbQ541B1RfJFXIC8j2Mmijx74CiOCM4qTUJnRW1N6IyE4ClWpS043Bvmzj1nY6dGvTRXjaW1aj/rmBWi8tlNFXTQnmtrO6qpq/LTcwvO6ZQuHHexNkx9jyy1S8Vi1vlZmakkJUgTMog0CiPURZvoIxz9SZrA7hlJSJIKT8kjEYMdAZtJqIHGLeowVSrKUJH/ma4FKK5RRXeZxLo0Lc0tiQZxgUCfxGb9Z3xrJ5rBwTnvMRn3rmIzm58EQP5qnQ8QxW5DgckxOuwz558ARIHZdHAThCGNgRDP9sdqcFlvd1G+uOlClrBaOERHh3tpYA3ZCnL6PCKxRyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3PpQRpc2SpVVMvxlOScvZpCJyo44d2Ky/9luBwl3gA=;
 b=mqKa45PCTgc/FXZwopJVViriT8o1r+P/NKAlw16HR8QAygsaUCJrl+73mT3p4HmK4ZQAAPaAUlV3rikxuj86YL4le0iSaoqk5AU9rvUTUxup3xewCEBQQyAm5yAK2UNfnFmVt6GLQQqLlIOdcgruVXSaDim97RByCsLd5kgRhSpAjHQoRuo+2XE3ODG0mHNAwYvSVjyx7gVkE+fQ2ERGpYoJoUg4VUmNHEwYHzVybqBBk1+OCIYB8VABzBCXEUU9EZRhFajCmHG93szil4P9eAbeL3eTHK4jpqFfeMCcNmjSW9OanIzfgCX2/nwpunhcg06WvP12kIzBY7jkHDMgrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3PpQRpc2SpVVMvxlOScvZpCJyo44d2Ky/9luBwl3gA=;
 b=WLRT9he5Bj1rF7fZQVKI/tQcRbTqPgU1zN/NhcHfUhmmNaFsLi/hz4/7Z0ObOgi5mODSkbb/pOIJ4mw+ZJ3VT0KOzUApkZ7ae049S1dlU971il/7gT3qclbAwuUlWQHIFcEY3tWgM4ERwyh44WqesArDHrGfCsoXqF7ni6ii0dDUnEtFlYFEpbPttysxWAA72aevqlk3zcscB5pZlX7Hsh/gzvE8YdJPqIALOOSL+okWQqBbrdJ889NxDfhu465lLA3Rl6jSXnWGF7EaFaUI8tEPIm03JM1d50xJ6Cfm+Yu+BLe+4+g7cJ7XtlT1JsEI8zsTg0d51IPRYR3IltgiiQ==
Received: from SA1P222CA0065.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::16)
 by MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Wed, 18 Jun
 2025 06:42:05 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:806:2c1:cafe::c) by SA1P222CA0065.outlook.office365.com
 (2603:10b6:806:2c1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.26 via Frontend Transport; Wed,
 18 Jun 2025 06:42:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 06:42:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:41:52 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 17 Jun
 2025 23:41:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:41:51 -0700
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
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a7a77c58-e585-4e87-b374-ae33fd579bd1@rnnvmail205.nvidia.com>
Date: Tue, 17 Jun 2025 23:41:51 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|MN2PR12MB4077:EE_
X-MS-Office365-Filtering-Correlation-Id: 0836e351-1e92-495a-a73f-08ddae333d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTlJSHdRTW1QMkRVdmRJZDdOSHlLNnl1cHlkSWtBQmJuTHVzZmZnVXhBazRa?=
 =?utf-8?B?NU00K0FlRWJ4TzZKOE4rWWtaTzY1S0cyOHVNTlN0MkU5MUdvQ2NpUjhNaTNH?=
 =?utf-8?B?ZENRVm4yU05uRzRGTGxjWEVjUk9JTEJhejROQnVJWFUyYW1ZU0o2TnFKYlEw?=
 =?utf-8?B?YldWbWZURStqK2d2OFZJcHloQzZmZktjUWpuc0sxMjkxNHYyZkNxdWI5TW03?=
 =?utf-8?B?Rm1UVHRJeXY1MHBUU2JVY08vOVIyNTAybkk4U0RMSTBxWnU1bGpKalVpdDAv?=
 =?utf-8?B?WlR3Z3pMcE9oWWRjZnlwOHZ5ZXR4c0E1cy81N0VidkxpSkREQ0tNNFM4eExm?=
 =?utf-8?B?RWFiTkczQVgyTzlwUzBEN2x0aTJ2RVdBRUlFdHhxNXNWaldSK2J5K2ZBWVlJ?=
 =?utf-8?B?ZDRZMjE5dW5QTjlJOEdxYU1KZ0RLSzRIdzJ5SnBsSnJxMGJ3a1hXMTlKdXph?=
 =?utf-8?B?TzlrNXhDdHlkcXg1VmRPTHpiTjV2Z1VUTVl1TG96R0grRCt1RTVnNmZoQlJ4?=
 =?utf-8?B?b2FUeGdqRnF5K2xaUmkvay9oc3E0cXVHdGtlN3BhcHVVVkg1UEtBMzlOaUk2?=
 =?utf-8?B?b3VBR1E2UHBGemJKeTBWeTZTWjBmRmNkTWtFbW42QXZDMTNULytsOUM0QTBx?=
 =?utf-8?B?OWZRQU1ESFRSV1pkUTRxWTNkdWZ5MG5qbW9xbWQxaE50dWxEZFMweXQ1V3NE?=
 =?utf-8?B?dTA5eVB3N2ZzNlhUd0diV0J5Q2VsMkxqRjZIbTltMjJoT3RBclh6Mi9KSW9G?=
 =?utf-8?B?SlRidCtiSTR5VWJpcnVWZ05JTXZsNStPK2hCRWNKUkdlTVFoeUFkVmFwNHhU?=
 =?utf-8?B?cGVyMkltVzZ0WldOR1Z1ZnNBSnJXazZzZ1J0SVg5WFNkWXNUMWo4ejVROTVT?=
 =?utf-8?B?NlM2M2ZRai9VdGVTbFVic3NiMVhTVFR3STVaS2M3OW5qdCtNY0RtOFNTam9l?=
 =?utf-8?B?ZjF6YUpVZDNEeXNHQktpREVHcUlVRjJKMndPUWk4cTlZZHptVzdZaXpCVE52?=
 =?utf-8?B?ZUJQVWxkMDE2YlBmQzQwcTJuSTNLRGwzVG5lT1lDdjFqRVFRNVI5Zk91QjBL?=
 =?utf-8?B?OGUvbXMxS1h3dmU2cEdLN1QrWTJPRGNrRjBPcnNOcEM0WW1iNHNaUjRjQ3Iz?=
 =?utf-8?B?WFg2bVB0Qkl3cFUvZGJkZlg1NWdlNlo5UiszTlFOL0ZDdWp6QnNkakxOUXVU?=
 =?utf-8?B?QzhnbkhFdExLenc2UldpblZubnR3VXh2Q2s1Q0FnRmxvaUtyYWIwUzdvTlhv?=
 =?utf-8?B?eGtTY3ZUL2NSamRLTmtPWFhhRDU3bFRwUTAzZ3ppaWI5TGNwSjg5ZXRtQ3pE?=
 =?utf-8?B?MW1rUnRPU0xCTWlIeXl0dHdVZG1ZRnZHSFNpRWdLbS9vOHd4UXhhc2QxUGhL?=
 =?utf-8?B?TXNVWlFiL2x0T01FZHdkMlY0enlucmpESzlVV1dyN3lYQjV6RkxNbkhhMmNJ?=
 =?utf-8?B?QytidTd1OW9GeVFKWmlEVHRZSXdNMWZtcU5BKy9oZCszVTJ0TkNVdVRRL1E5?=
 =?utf-8?B?dm9RSVNSc1ZSQnRXdE02OXVqdjZrR0UzY0s2dXFtUVFMNTRjRmNjaFBpT0U5?=
 =?utf-8?B?YnpIc1B2Vjh4bWRKSWVpUnUxT0kxTDljUzZ0M3BTYklvSlRYRTlhS0dWYk96?=
 =?utf-8?B?RU1vRzAwUVRMYlNsdkxJSU9Ld1ZjZHREdG9ZWHRNUEtJUCt5c0VqM1RGMEQv?=
 =?utf-8?B?a3l3SWJ0NlVCaWhNMFJ0M0dmeWFTc0drZEJmNzFHZmFjU1Jjc2tBaXdQQ3Yw?=
 =?utf-8?B?Tm9ONHlLNndGZzJYZVlrQlk4R0FSVmZTQVM3a1FVL1dsS0RLUnVPQlJYenNH?=
 =?utf-8?B?YjZIeXh0NDBuZ0dWNVBZclFjd1ZCWjF0ZkY4KzNZZVg5cmFjRmppTEp2ck9K?=
 =?utf-8?B?R0s5WVAzRFk5TkJsVHhHSWdSekNmZElLeXhnclFERXBmWHNhVXdaVHcyYUhz?=
 =?utf-8?B?ejB3ZjgrZHZpaXdKQzI4MkkyWjc1QytQN05DU1RjSlZnSnRrRFJpdnA0NGZw?=
 =?utf-8?B?TzhpYk5MSXh4L1B1aW90WExxV1M0UlZvRG9ZMUVRdjh4aHhxa1k0NSszOWEr?=
 =?utf-8?B?STNHSm1rQmZtTHNRVjMzZ0hyWU5JM1U4UHZLZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:42:04.4797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0836e351-1e92-495a-a73f-08ddae333d0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077

On Tue, 17 Jun 2025 17:19:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.34-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.12.34-rc1-g519e0647630e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
