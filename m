Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0086D25B698
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185819; cv=fail; b=d4x2oNb5tRmHhE7uBaZtlUF5b5MT5G3TZz71jAqkKOLgeFUfMuZIVjUYe6AG78el4eQk2aIUL0e6zu13Sj4u6vK4xaf8CJnNgKqPWX/2gD+SWFYK2mE0Ac0EAwAoHxOkDrWYWGFBDESgbQu1SQkK0pGPTy9sQEvy7NwmbYx7tPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185819; c=relaxed/simple;
	bh=fsD2uSP+xTS5VEYtgHfD1CG2rl2RnEORDZCs4rhytzc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VpdmsPvRgyRoY8ugf8TbIdTn7I74Em/cZOgt/fMuvMooUZrNbYX1sbzkTY8YJPv//ysSLBrhf06AAMW5xKLJ2itSnlcd7OTof1rtHyTjl8NXTyoe1zG0pHxbLNDC4G6PaZlVHSL0uUaqNyn4dJTRPwW6KzMpipWMeN/TMOhuDjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hsaxc56i; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hsaxc56i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WATe6ws1YoBdAWalCbCe3RaRq4dLAhhPvE7SGNpdl3F3SxCAQF1J7+NhzIfOiUboXF/0834RURmJ8b1BxIRbMMPsw/RQVLOrnmGqQGA/9cmn7byEdY9RM1bBHsAZ6k9t3sQNi+ZrRK8Pcp1BvVFwVngnuQhmbfnxv0PvK9oivC+lxXl31zq8w6A+Elzc98ograPh9IB1e7Stx07iyowscdoZs/aWTp0H0zvB9lpFzgvhx8kg//ZdfjXnzU5G2Y4mos9C2BeGSHcWN2OiSlDGfEb2sz2AKnCwuTPa/HU6wPvWul7yqq82ikt1J2z3tadrnikkAywxisZ/Rl6auhrxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfRPf26RAI7ufMjLWA16WxPfumGVDjpu31hpBkoGMQg=;
 b=b+Sv/q6EJUeiqEriIqp/CjrkZpaQ1PmxGzLp/vxFGe6vjgfVsqbw3NXshlLD+PxMMI1iMo7waFuYVXSS5xg6hI4Gax12xEKuDZpFIhKUEfO2ZVFFM9aI4ikpgiIaUcVSSrGyL5Zt0sIUtGhW95sMRWt7NcSw8wRvHO9usMmC4i0QCIsIM6/3ZIL4ONn2bPRAZXaafHX23keVLZAk530/twkxcxtQWR9clV4wL26sBfYZAAV1KXNOXU4YMfnVYI0FpD+416XI4WOoxj9NCaF5D7MagLZu2v03OWq9zlor+kt9rbg2O/Iz0PthOxRDTU4cbhDVid8SvCTt67uZ64NDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfRPf26RAI7ufMjLWA16WxPfumGVDjpu31hpBkoGMQg=;
 b=Hsaxc56izGnlZFwNLgOVwaN52DQFjS0k0I/skLfWrIuj75LrF3GzWyvFMqUt7/IW2CGAzO2EexvjsC+Rr8N7owXp9Uss8ojZx3V2orsTy4FXuSsbMaZrMqlG5kLYgRgp93H/tMWAPbXCjr0uvLE0LN+ra9yNv6pzrtEXrKOkUlRv467Ym/s+f9cTNFfoUl62Wkp+owWIAql0anCHh9aeh4CYUoJwyncKB5HGSM8awGVlslm4j2E28sljA0pqxJnSLRJT3toQi2NpcBRXv7vjC8pu20CHMz88qfRkudwCoKd99qaXO/QGbsmQlGCd0kFq04PWDM5Qu7/DHY+alhPAIA==
Received: from MW4PR03CA0268.namprd03.prod.outlook.com (2603:10b6:303:b4::33)
 by CYYPR12MB8940.namprd12.prod.outlook.com (2603:10b6:930:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Wed, 9 Apr
 2025 08:03:35 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:303:b4:cafe::2b) by MW4PR03CA0268.outlook.office365.com
 (2603:10b6:303:b4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.36 via Frontend Transport; Wed,
 9 Apr 2025 08:03:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:03:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:03:22 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 01:03:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:03:22 -0700
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
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc2 review
In-Reply-To: <20250408154121.378213016@linuxfoundation.org>
References: <20250408154121.378213016@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0723e4f1-7102-46e0-8758-e542c5cbc12b@drhqmail201.nvidia.com>
Date: Wed, 9 Apr 2025 01:03:22 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|CYYPR12MB8940:EE_
X-MS-Office365-Filtering-Correlation-Id: 966e8010-9027-4cdb-74a8-08dd773d06ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjFNUGQ5RWd5QnVuLzE3R3k4NzAxeEVVTnQyZk5vN3M2TE1zSzEwRnQ2Z0Nz?=
 =?utf-8?B?aWJjazBON1VTeVZiRmhDTHAxSWF1WWNVWGw1aktjaFNhQ2NsV1lzeVl2WjNC?=
 =?utf-8?B?eFdTRVhFQzhVRDVPOXRlcTM0YzBaY3drVTR1WS9laG9QVkFacUNqN3NWT3I2?=
 =?utf-8?B?aG15alRNNHJDT21NemRReDdDeldVVUpNMkl4MFBmRXB4UUVZV01yTmpiOGUw?=
 =?utf-8?B?YUFYMzlDUDFIb25mOUxLeHFvQ2h4c0JITTlUckZUUkRsd2xWT09QQXNxNHlY?=
 =?utf-8?B?RjIyM0hrTGFHQloxZ2lsemVsSTlMWmFqWk5tMGpJNGxFaHBzRGVzbGdmekky?=
 =?utf-8?B?ZlF2M1QzRGxOS0wvd2VCdDNySjVycHdtank4ZE5TOGIrZ2lMeDVVN0RuT2RH?=
 =?utf-8?B?OGViWi9OVXoyTEJJUjViNmcyTVh3NHIvRjJaKzRGUElQZGpncjJpbjZ6M21v?=
 =?utf-8?B?ZDNFQ3lmWFRqa2FYNGMwdWlsUjZ3ZkxpcCtvU1JGTHBrdEVuT1J2SVhsSUtN?=
 =?utf-8?B?MzRHQVpaQWZwRlpsUVVITE5BNkNOYkVoUjMrd29tV09EOGw5eUZQYjVZSFdL?=
 =?utf-8?B?akhmUm9sV0UrNURmaksyZGlTK05tTTcrNk54QzJDZURNcXlyb2gvaTJ4MUp3?=
 =?utf-8?B?eUd1b0ZhTXpwNk1STnE0YXlxOThrVXR3ekRqK3NtRGgrOE9ONE1LcXVNckxV?=
 =?utf-8?B?Q2g3K01mSGFJOHA2TFcyeEdMZzBQbVZVeWszT04ra3JWeHdITXJRWUFXVWdI?=
 =?utf-8?B?MGJjRDlCOGNyS2FxRlFlRWtXdnIwN0ZNTiszL3RuYVo5amZ2UDZmZVN0R3Zj?=
 =?utf-8?B?NlAyd2N4ZmFOZm9YMTBpeGJaYm5HWEljNlVJRXo0MVBDaHVLekgwWkpmcERL?=
 =?utf-8?B?RVVMOHVvYVdHemZHK1lpVU9QeWJVenliOSs2TTMvMzlJdVJ1UVF5Y0F1TlJZ?=
 =?utf-8?B?dEdDMlVlWGdra2poZzFUY1N5YVNyWUNhNEVXbXNDUVdxOG1vcENXV2NFSDRj?=
 =?utf-8?B?SUNYcU9Qd0VtWHZKRHc3WXZkc2J6MHVUK2FjY1d2R3FwZ0k1T053aGNLWDBz?=
 =?utf-8?B?elY5Z3BTd2lQZXBtLzNreEJuQ25pVFMzd1FFUXRyNDVDK3dWZXMrZEdoTGls?=
 =?utf-8?B?dHRXWjIxdWxBTVNxTE9hZzRCZzY5b3lZWDVjL0xzU0NBSk9pRHQvYjEyQTVF?=
 =?utf-8?B?cVRSdGhla3lZTXZ2dTRaeW5FelcyV2Z2aDY3bkdTK1JoejY2UFFlWGRYb2pl?=
 =?utf-8?B?ZDdrby90SWVLVHRZczhiRE1aSE5UWnduelBhQnZDOHM5L3FnbWplSENyVzZP?=
 =?utf-8?B?NmlrVEkzWVlqRUxJMTFYQTBMRTdJZFcva1hIRi91MmhqMWVLU3ZLSXNRTkJK?=
 =?utf-8?B?Q3drU1NSVHdFUVVmUk55Mk5wdGExdksxajE1MEtqQ3pwMzNla2owUnZCa2xV?=
 =?utf-8?B?T3dtV3I0ejBRMXVCSE84dTNwcUlhWTlSK0JSVlB6SFhmTFJOWHhwYjl3QlFj?=
 =?utf-8?B?MkNLV0ZyM1RZNUxMVVFRVEd6Nk1ETlo4OUtnQ2xkTmlKVG9UbkgzcUFsakxk?=
 =?utf-8?B?ai94d2FqOGRHUnIrUURyWXFqajRnOWUxTlVYdmFWT3dMdHhIb3VwMjNBQVVi?=
 =?utf-8?B?aVlYbVFpZ3FyNGlrYUxENzFRV1lSMU5FbENGQ0VjRzlqbVdKalUwYXBCSEFh?=
 =?utf-8?B?YlIxZEZtc05ac1l6SW1sSFcxSncyWWlBcEFvaXBmeTJldTA3Yi8yNlBQYWNX?=
 =?utf-8?B?VmRrZTg4T3FhSWtESUFLVzZ0RlBndWc1SlZrTmEwZHc3d010VjVJTi9XVXdO?=
 =?utf-8?B?OWtyblpzc1BqU01qK2VzNDRLby80UkZ0RlI3Z3c1QXJ4eitxVmhSajdBeEU2?=
 =?utf-8?B?UkhMc25FMGtQaG1yRmxPOXVaTHlFQS9MUnV1b2NrNlRPT1dVQUtWZXFTN0Ux?=
 =?utf-8?B?clk5dzFZZzAwUXNSZU9yNnR5RFVqK0VoVGV2eW1PaWhZQ1BxTG9QZVJ3LzhI?=
 =?utf-8?Q?2MqnT9ZdKDkSwfolSYeSuK3hk5TGTk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:03:34.8254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 966e8010-9027-4cdb-74a8-08dd773d06ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8940

On Tue, 08 Apr 2025 17:53:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 15:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.23-rc2.gz
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

Linux version:	6.12.23-rc2-ga285b6821aeb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
