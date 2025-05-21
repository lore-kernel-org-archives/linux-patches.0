Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CF822DA0E
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816331; cv=fail; b=DygVmh176BfwymbsBydL2SVxo8YtxderlXDGrc0/DF8hMnLFxLgaWv8yDC6jyGNUHxSzO6DsB3HqDzht56aieWZMKP/q8Bsn9F8iprnhS2LWHYrmB+Xai5ZEStgacZjQjA6I8nkhHOem9mt+L8knZqjhRpivsBQ2dulKARY68ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816331; c=relaxed/simple;
	bh=4CZoT/uYiowmoduA2jk7KFewbBa1c+Pe/VY2vZS9iU8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=PNSEnPXdT+nGaNKJJSspVfr+3bUzQ+NjlWYUfAxQg+4EddNyIBlBAVRME4SmKgJOzuILCw53Tj/Acg3lCoSMe4jqdoSbZncmiahoUbRQAmE0/B4Wr1UhOHBF/LqQAOCm7Y4ACi9p3LoY/PZSYFFfwns7kmKOfJYMbMejh17AxnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pZZ3WYkg; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pZZ3WYkg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oo8vkMvg3Zg6k9rpeju17eO0XBlU90krx5a/Bk9D4nAlRrImlQfYT0rsWG2A1ORB2YJCerLr86AzNQrE/JfQUbm/grYcVv5zC3DL6OntceQZZbi4V7sg+Vq3qQbm93dErOerA60gsWFd8CKpDoBt70/a+uBkwToOuR/2tHf8cHPOA1iSPFyc1nT89zC8TF50Z8Euru7Iyv05nEULHcVKt4ju7iuWVAfO+zpnmm6ojKpyn3tFEshv/26udEi3/xj6NR6nVcUQ+JnTiewAU29IpqcUtxpybXvu0pcvf3zDbL6oMP3zvpbYp1y8BD4yoaIJ90rhxrgDn37zIkXpDcmc2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dp16jluErk8IGVdayfsAXhuFHzFMu/zfbz2DX/zW/WA=;
 b=T6c9NgYgSXPY0RPS00pzTTAvbKNtF+gATWlXRxT8/Ewd/gC0gObqiBwcXKw1iz3qhZDItjsE4+CJn6/HIDY6NNHLMe8Fbdom67G+1Hqa/4vPWTwajJzmohz1QHJ8+Du7EPnr63eeLSqi/q1ScZY2euLW6/C1ZnEsZpBB+w3t850rQCEdmUXhcGPMSOvRWcxJDEx+/A70OIsQtBXjwAnIRxv6VsxIa9EEQWUXHohi0SvmGoqyyv8LAd9V+HFeWiJMTmbbt5VVe8Xv7pyYpU2nheBYwtQmz6b6vlKFWfdcgi7oIXcucf/w4f26S0U+4hHaHaorbfmh497rkUZcevZd8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp16jluErk8IGVdayfsAXhuFHzFMu/zfbz2DX/zW/WA=;
 b=pZZ3WYkgLWJj2YN1wah9BkeSHFgnvQcDentx7ZJmkFLGx+VpBEdYBn8EJz5wGmojtQUDI1KT5UHlhaJE+apVaZWYyc+uKqD9qPLTx9S81TF+DnycDr0hDjBoNb+dWcOjHdCKJqnxFMoiI8/dneulGGqAkC9smAYrmX7K2oypCf5KNGYXkqeJhk+O2i75OcGzCLyj9Y7XMsgXTzziVgkKwS0O3GjKAJM2RbdKjZZK5ouyJN7egumxB/3Q+CbRR3TP8w9A+XnUsk7YelLa8kcicNtBXGLaP9vteMUtUB+LbEsER5f9jqDqA2g8piE2GmLvFbTXwuk8bRtZI++UdfHxtQ==
Received: from BLAPR03CA0122.namprd03.prod.outlook.com (2603:10b6:208:32e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 08:32:05 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:208:32e:cafe::71) by BLAPR03CA0122.outlook.office365.com
 (2603:10b6:208:32e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.29 via Frontend Transport; Wed,
 21 May 2025 08:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Wed, 21 May 2025 08:32:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 May
 2025 01:31:52 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 21 May 2025 01:31:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 21 May 2025 01:31:52 -0700
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
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <41c29ef2-e12c-4932-a1d6-6a6183d8f269@drhqmail201.nvidia.com>
Date: Wed, 21 May 2025 01:31:52 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 153a9f1c-d207-471a-db86-08dd9841f7b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEpPYnMyOXhnSkNHWG5EK0kzeHFGUDdDZFhIYW1UbFM2STZmSnRlbnlWeVJF?=
 =?utf-8?B?U0J0STAzb1lpTC9tRUtnMUxta2NRbkc2dWJscDY2OW1GUElJeWNESStvNlVQ?=
 =?utf-8?B?L2UxVmlqQVZvNGFPc20rOVVsekkyakhEckdpalZrWHJ4Y3MvMzVVWGxXTXk1?=
 =?utf-8?B?NEFwTzJtYTkvdEJFbWJaY0I4dEJxWmVQMHJNYXF0TC9pa0k3NWRMT3VLWmxC?=
 =?utf-8?B?dDMvZWtIZ0QrRFp1Y1BlSFMwbHFXc0dnTlppTnpPYUpLZU83bU9rVkRkZUV1?=
 =?utf-8?B?cnZ6SDViNll1TDlRZStsWmQ0WnFBRGMyUkpYMGRpb0hRNGhTZzY2OC82bnll?=
 =?utf-8?B?eStLMGVTdXlneG9nVVFIdS9qZVpWZ1VnZDUzcUNmUnBkQUtMT0pMOXVnd001?=
 =?utf-8?B?UnJuY2ZhL2VyTzE5MzNGelkra1BlWktHMmNvRm1tVUhkc2lpZDNHZFhDMFJw?=
 =?utf-8?B?dU92VU1hb3l0bHU3N0J6dnNLalM4TXE2MEtwUHZlcUJxL21SRTN3eWRtNTlJ?=
 =?utf-8?B?YXZQcXd4OUc1WHZEcnZUTkMyNnd0VHA2aDR1alNKTnV0ei95RjdYT05zMkZF?=
 =?utf-8?B?OVNqVHd1LzFmQ1RZVzlJK09STUowbURwN282VC95OEZMVHh1TUFuUGo4ejlQ?=
 =?utf-8?B?STNhcjVDcFJGZHprM0R1TEhpbUFvVmdWaC9aQUI2THR3aTdJcVc2TEFublll?=
 =?utf-8?B?di9ZdHl6cTVaMUJqekZTYW1WR0F6TFVTeFBvaU5WWGdkK0dWemNBN3VzRUkx?=
 =?utf-8?B?V2JSbzdxMjBBZ2lObE1lM24vQU5YZ3g1ejY4aWN2MHpXL0s2bC8zdklWNldS?=
 =?utf-8?B?UlZuelRzZ1U0YkhhaGFRSzEyY0lRc0tqbzVzWmtWNVBuaXV0YVYySDQ5aXZq?=
 =?utf-8?B?TVFwWmJNQ0tTbS9sWjZrU2Fuc2xZOUdOZUo1UlNuZSt5WVQyYjNNWHREdlE4?=
 =?utf-8?B?M3NoQUVDV01XUUdnZ244Vzlkak1FOGh2c0NnL254QW1iTzZmaUIvVE1xQXlC?=
 =?utf-8?B?bXZHNlMvL1pNcXdMOTQ2dHY0ODJIb0ZVSXM2cW9vYUNtVVdiTHNhNi80MVhm?=
 =?utf-8?B?MEEzNVg3eDJ6Zi84Y1NHdkUwallPOWNSYndwRmNRK1NIVHdjN0Z5aytETGQz?=
 =?utf-8?B?MDNUNk9NZGozejVuVGpCL1Y1SVBhUzNvUEQ4MXpJNW5oUjVpZ1NJZU5oNnAx?=
 =?utf-8?B?YnkycXQ0bmN2OW9CdE9DZklUWHZCUTJJVUJCM3JSR2N4VlN3ekd0bzZ4cUta?=
 =?utf-8?B?UzZtZzFXZG1OZUp4eHJwdVdYTVpnQnFyL080T0VkTDNzemtnWEsxOVJLdXoy?=
 =?utf-8?B?QWxWb1lSWEhNdGo4QThBN2tsMk1TZ1RnMkgwSzUwNzk1YUluNVNWc2RnczdQ?=
 =?utf-8?B?QmNna0s2dU5UbmlsblRSSkFtYjFZdVlyRkVrRm0renJlbm1tSHR6eWw4Nzcy?=
 =?utf-8?B?ZjczWWdCemdMelFWeHIzZzZ6U2F2VHlONm1ZVnhnaFozNHpHMHhIZjNjaFd0?=
 =?utf-8?B?U1M4TmloSTQ2WGVzTmFlbW9Nd3dtY1Evelo4NloreTBIMU8zOVYxWnBhRC9L?=
 =?utf-8?B?Nm8zbkZrVTMzVU9BeFd6SmcvR0hFWkV3QUFWanBvZlBqeFRXeFZWaTRNbWcz?=
 =?utf-8?B?N0FUaGZPWXFXSmRoZGJubTlTT2JuZmY2bmxReGFsaTJGdnZVbjRTM1pWN0NL?=
 =?utf-8?B?UUYvTlh4VlVjSVAwTis2bmtCakxpR1pNOElldWM0UjNzZFV5TGs5cFdSTzVD?=
 =?utf-8?B?MjZZSkJJdGlUa3BicHJlSGtibjFLRkpMdFlMRVptYVU1cUVOQWtQL2tDUHpM?=
 =?utf-8?B?WWp4b3gxdDRJVFk1NVIxNG4rK1VMQ2hyVkQ1UFNVVTBlOWdCU0djUEk5WFFM?=
 =?utf-8?B?QVpZVGt6NzFzb3pZU2gwcFp0L3JXSnlCcUlvWklDNXpESXlpN25NTStEVnNo?=
 =?utf-8?B?MHJGU1QxRmY0TWdQRGJEdzhjYVFUZDUyYWoya3ZJWTIyeHBudC83ck1SaTBK?=
 =?utf-8?B?ai9pbmltVEdLVW5nMERoUUx5NHQ5OXhEZ04vcmtBV3ZLZmhjTmJKTGlGa0hh?=
 =?utf-8?B?UzBGREp4eG9jV1ZtMXhiVXhrSDF4UUhPdXBCZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 08:32:05.0893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 153a9f1c-d207-471a-db86-08dd9841f7b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

On Tue, 20 May 2025 15:49:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.8-rc1-g75456e272f58
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
