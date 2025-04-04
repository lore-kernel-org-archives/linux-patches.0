Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5B215F76
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795031; cv=fail; b=tkHFMmRjOCSxqmscX7R9+KSNJF8gIEduCd2MCSfcbqMtcRdC9izYkM8cZeS3V1/E4X56Tavfkd6Lq5mfqPOUnRXdV73gBJxhz9IFxl+1mPNBtDm3ptemUSoLgUl1mTIezZEw7EdcWePOjwDz2bQA9JlF6fDvl7wXRA3HHGx3FjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795031; c=relaxed/simple;
	bh=oPOOViHgz10yuI8LRTkY+4lg5DnSJMjOyy7a7Lv5JLs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SPJTuoJU2WVUuU3FAz+MmoiFfRnTiwIOwqMSMC4+yCS+CXC2Kg0KtjLcNh3U8YCtJ2u34MdWkoz1aqyMU7RK/i0JBtJ6sIePBefeQkHCfcx/nR9c8LAC2JAZrYPTjCs5DiO2dc3zQa3XsfyYQqZm505Wb9NpWqIOaMWLUU47/G4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KoXRifcU; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KoXRifcU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cu6AuD6eqYy30XtaX/xf5BDbPF9RWGKnWwz5ez0jPIzXVLdOXBg7DILFJn2AzrT8S7HL9X+LOK4xJAm7kKpjEMEzCl9jfahZjHnMr2XkYdaEv8Z/7jEGa1oHNKPxPSG/vjjWHueS8w2CT7sTY9kk9jEV7n2A/1UlaRQzy0P+vAcQNXGdiB6sEjlH+Eh7n5wLf7ccbkC5v7YJ1PWZjrXqzxHZahyYmoJ4Scg9eXbCVhDnbaOxVjrMsdu4UzDMd5rCoutUe0DDdgTuDU2WQl+ZgtzOrmUsK4k1fLB5LNCjU2yLjMWBEjUNlmSzsk3yVDtubg/pdtjKn6wLpfC4XYYXEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/z0qt+fe/w565/NtP296CjAjQqHOSkodRxHKlmqNoCU=;
 b=IgJRSsxvicXu9UQkROwzXZqzkjqtxJMI/P0IOFTWZeR+zHFeolYC31exD6Odt36N+sFbhMQEUxW6WwIXpgHLX4LqdXiM8gIkHDHr+RGvGoN+K1sXJygw8Qezc+CfQTZzzr9ymEBU2LvMZhfly1gq4qlJSOuru8NxBUx1R+KkwX7aQBHRJo5QGiawhV9gJ25E6CiVm+KdJEGzFdv1NTUWq2aQl+sZZHorGXKyzo8XKRLBsvxONmsMGsKbD7sf7tTTxmqiRkcXNc/3OdrD2gCjrk30AlKYY1f2bY6w2394d3IAV9d7nMBjIYWI8I8Jz6C0bz4Qt4xAg0M8UDU45mRviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z0qt+fe/w565/NtP296CjAjQqHOSkodRxHKlmqNoCU=;
 b=KoXRifcU7YADGPJNeiK5LDUAMeQtuYGl6jl/cC+LV7VIv2Hk5ZrglVCNZV9WpKKDSVR9mmzZlbgvSSRjwmg6fPW2eB834zZ6x7eT8CTH3aREIIIV20x1Wyqq73VMLdUiFGzR65+zg6NRgCikzdBqOCP+MXsmVsL51TrHNDsPg6K3iY21QCDXd4u4lNFNgKA8NvXKdCwnsvZsU+p1GD+sPPvRWjMfPHSfUoU4w52vh1aE/22XGhYJpt1EvQOSjsve/tCbvP64+cUemPzgtu01YeGVFLQmVyqpeom2Qe9WAlWpdl4s42BQEg0G7mDMHTOWW+xBAN2gXwqcYf7htN/1UQ==
Received: from MN2PR18CA0004.namprd18.prod.outlook.com (2603:10b6:208:23c::9)
 by SA3PR12MB8000.namprd12.prod.outlook.com (2603:10b6:806:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 4 Apr
 2025 19:30:25 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:208:23c:cafe::c4) by MN2PR18CA0004.outlook.office365.com
 (2603:10b6:208:23c::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.27 via Frontend Transport; Fri,
 4 Apr 2025 19:30:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.2 via Frontend Transport; Fri, 4 Apr 2025 19:30:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Apr 2025
 12:30:05 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Apr
 2025 12:30:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Apr 2025 12:30:04 -0700
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
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8e218556-3347-430b-8fa0-1bb71fbda125@rnnvmail201.nvidia.com>
Date: Fri, 4 Apr 2025 12:30:04 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|SA3PR12MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: 71cd5844-00a5-47cb-fc1a-08dd73af259b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWlDdVAvSzlyZTB1MVB1SzBMRXRZcDNJQmJmQWZPS2RyZnpwdFdLZCtkaVZT?=
 =?utf-8?B?TjRrL1d0ZHczZS9MWFBRY2ZlcytYNFNRN3ZrajNEOVJnTm5pZXN3WVo1TnRO?=
 =?utf-8?B?Y3ZNWi8wQTNVVFNSUnFYR01SRzZYdGY3bEpidnVLTWt2RElhK1pHUUVFZFFv?=
 =?utf-8?B?d0lGdFNpWW0wL05jWFpUS29QVmx3Wm9tSVhYa3VqRU5BUEVaY29Cak4xUm9w?=
 =?utf-8?B?NlFaTGdFSHl2UTFBZ2dZb2VlWVp3TElGZmZIK1F5ZEJMQ0ZMaWFjSkFDNWsy?=
 =?utf-8?B?Ykh6Wm8zbkhaVWdCdmROOGNld1kzYkIxSVFWMEJ4OGlzM3hUTjYwMC95cVdz?=
 =?utf-8?B?TUZvRnVrUk1weW02dm1aVkc1VE56K3lHNWlmc1R4bTBKU2tFRkJPZlJQRkFV?=
 =?utf-8?B?Y2kwUmFPTVhwTnMwc0ZwV2J1REthZWlvMHZhTUdQNnF1K1c3TUdFYXc5UC95?=
 =?utf-8?B?dGtYTHRYUlBVRVRBOFFvUlNyODNTd1REb045bzNXUHVlemo4QnA0Z2hXY0tz?=
 =?utf-8?B?c1B2N256ZlFRSXpwUVI2c0p0RlkwN0VORjRYTkdqSUh5S3FtUnFWeDl2eXB3?=
 =?utf-8?B?TEtqZUJYTEtRcnZyQktOY21XTUFyR2krVnpvQzN1TFYyaU9keXRjUVFsOU9t?=
 =?utf-8?B?eWtkWmdnc1BCS3MwWkhIckcxZmtsdDJPV3Ric0g4UDdvNU0xdkQ2c1JtV25M?=
 =?utf-8?B?ckxpQXhWMUhWbnNFOVUzYTNpNzFlNzk1OXZpMkNXODU0RkZuZHBUS2pOdG5S?=
 =?utf-8?B?cHcydzBxYkpRckJyTFFsb1ZuR0NxK0lUQ0dsWTRCbHVKdVhQR1VkTGYzdlBj?=
 =?utf-8?B?NExmZFYwMzJjRjQ3MDV2OVBvYitPTzdOVmdlSVdBVzgyNEhNU2hGTllPOXZp?=
 =?utf-8?B?ZzZwUVVWR1BKRDBoNW5rQ3RYT2VKRVpGSkxyMFNjOHBOSGx3bVJ3cTZ6c3Jw?=
 =?utf-8?B?K2VFa3dLTHpmc2dPVHNENmNRTThXNzNWd3BucytVcGRrWUNIMWxzV2ZTRjNh?=
 =?utf-8?B?UzhKclE4a2xxV1VDYVNrU2QrTnpUNng2Q0pxL05OMEZqaTkzNC9WMmwvaGR5?=
 =?utf-8?B?bk5QTTg0U0VlY0tKeUpsK2hCK3RvMWdERE1vc2lpNVNVdCtRa3hGWDNvTWR2?=
 =?utf-8?B?aTdaQndnYy9JZWFzUFlvWEVIZHlQTG9UY21VazIrTkpRZ085SUFhWVYzTDZ5?=
 =?utf-8?B?bCtqZlNzU3BRZG8rYmF5SktCaUpFRk04QXBYVmlXNEYwN01UN3EyemJ6SUFK?=
 =?utf-8?B?RTMxLzlxUXhxTEQ0QThsWk4yU09hZHlucGo5REN4TVdEY0dSOXcxZHRMcHlO?=
 =?utf-8?B?dk50MHY5MWxDNUpDZVBTSWNCOVh1dEJSTVdiaU90WFdzWi9xcm9qa1BqeUJ3?=
 =?utf-8?B?T0pjUHdQTjVnY3M0anppRXR2NzY3NXpWN2M1WGxSSEN6T2hFbXJpT0kyYkRM?=
 =?utf-8?B?aXI0NTJ4a21JN0ZnM3ZtblJ3dFNzTXJnT1Q4cXhJSHc4eUN1d2FkV0RQUjlK?=
 =?utf-8?B?R2lPQnovd1hET0pFYlVURGh3NnpaMXhEbjdzd2dMaDQ0VVl2MEMwNjF4VFRM?=
 =?utf-8?B?bW5ZZERwS1lOTEJLMEI0L2lwVW5WdDBYNlF2eEEwNnhmUUliMmxuQ3RxdndP?=
 =?utf-8?B?eW1neTEweE9jeXd0RnFSa2pnTEgwc2lYY1Buem1mT0FKRTBzWi9mTnNTVzI0?=
 =?utf-8?B?VjYwcWFkMVB2MGhVbk1GdnVlUk8vZXEwUGRHWHNITG1ZYUNIQXo2SUVUUFdm?=
 =?utf-8?B?NlFxSERaRjdSWWxYdG5aTDJtQzdjcXlBQVdoUnNtU1RZdXBJU3lPemxXbGVq?=
 =?utf-8?B?SmVvZm1RSFlQNUhrYkFSMWpIYklpTW15UzR2RG1FZzRwbFF0bXY1dXBpVnlZ?=
 =?utf-8?B?R1RJNnBxRzhLNGNBNTI3VmhqZFZ6TWpiRlpGZXUxYlFRSFVRZDF1cHdJNEpm?=
 =?utf-8?Q?HdSJ5nh0N8fL7YX8PAR6dvoFiYITwQN8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 19:30:24.1949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cd5844-00a5-47cb-fc1a-08dd73af259b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8000

On Thu, 03 Apr 2025 16:20:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.86-rc1-g0d015475ca4d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
