Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D672628C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739970673; cv=fail; b=KXZW62LHV1I5EqsSGQR8KrxNO6tHhBgj33/h4NeDS4OBi37juJY8on6eGoQ9HiTBfkz3uGapw2rpzBDxFomx1fhVVf4Fdnu6nWSauP+otJdwZcttgxuGkjhgK3KhhjS8Z2ceTJtZREtvfTLH/ILko4xftra/Y2WF2iIWBGzSekQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739970673; c=relaxed/simple;
	bh=SLY/jq2hRRh5g10SdEfdS2dLjUrBZsgjBL4EETZmesc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=H1Z9XbYem42mjDRllBfaL8N9ZzwyYuPVsXeLVlfRimoSHG12PiEd64ny7DZRd1pxiOB6+dZ9ehDetG3JRP3/ebGuXI4mk+NCmjFcgA8lEflQwz8SwP0f7UP1BxVhGxTNlvRYTpPKYaEn9NP8iH+wKY1ptVUkcOrO1sI/jF40AG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=naX505jN; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="naX505jN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1HEEyJ/lPjBBlnny5YM8/idgg67sVTt/wltie4NHZIgIdQbFSyx63KY47o4I1Af4L/sEZQlC2Rw1AMmHNsxuNcjRhGo7SDsaESlrwtfdtL2698EYX4o3Ry+UKb145N9QAtcOAOBVw8gLbGOORFuPlg1oIL3re2k24SDqhbtEIZ3qI9dlNeJJYUKYf+kd2V73AyQsbz7RjjRGb3UbnFi5UBKsnUDvb6iPGE6mFkEjAYA8e+dzivUWLYquPy9TCNXcMh2xbKRsnz1WKnOtCE5/LwdouFp+Z9IE0x8DXLIxCzxv+r/ujg6JDIkLP9J812vY2RAilKdsxwoLvcMMF3GrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hsbqYiPxgcEsBbSPIdpw6NJ1gMRJqUzR/IB/M2n8WA=;
 b=FwvDd9S5aqQ5smEvxXk2c5HL4CzLsis1SLYEHFmLVMk+kffoNxr6szII7CaqsT3lRwTbjb4BWwvvWiytOJcofoqd0q3kHyTMMqLyrN6ABDNzPJjNXJxyfxt52Fb5mIS4kXe3KgHOGD/NF3oysh8MFSB/ETx6iL9iWPpNantB+pPo0xdg9V2WOIKnPwgkVkyq+QYPQxuYrpsfRStZ2QyPRUrka0QS43xP1phmzdtsWhqG9QtHiCYn54iXlFf2K5WxExkEdta8rH941OJOKa7kWBpuV5v7bP1rDK+1TlWQOxLiu37bX8t7aOagLfMYxGI/GrvWK/khsSu6LIUpG1MJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hsbqYiPxgcEsBbSPIdpw6NJ1gMRJqUzR/IB/M2n8WA=;
 b=naX505jNdMywbDeQJ0mpSFxUTeL0LqHavtiuuQl1HeZJYjEMKVjhpImla4ofGqEaTlHyUrF5FS37vWL2U9jotlGw23YtFtPXI0sr/Cd1xQcde8Qzui6dhmLKgLT74r9HkqmsPpifrBklpU8mgB+Likmz4idPevmenWEaotLAnUbbyGF20OMMoqBIXGixDtXi+pa9VAmeD+cwaTB15dR2NG+DSK2jk43NNsHrSvoKYfe/jJl+4yoeS5H4I/y0ZObM78imseqnerWhWtwtmKbnpadmLs7vEwn5wT3JfEnFPXJMF7dzU1ZyF6UHD9A8eFEdsvwlZx4ENdZIs9r5RKd6zw==
Received: from MN0PR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:52c::20)
 by LV2PR12MB6016.namprd12.prod.outlook.com (2603:10b6:408:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 13:11:06 +0000
Received: from BL6PEPF0001AB4C.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::70) by MN0PR05CA0005.outlook.office365.com
 (2603:10b6:208:52c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 13:11:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4C.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 13:11:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Feb
 2025 05:10:49 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Feb
 2025 05:10:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Feb 2025 05:10:48 -0800
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
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a6c4dbe3-0988-46aa-a30f-8f4ec64c23c9@rnnvmail202.nvidia.com>
Date: Wed, 19 Feb 2025 05:10:48 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4C:EE_|LV2PR12MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cf5a2a-d7ef-4a0a-1229-08dd50e6de90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUFBTFdnaTdyQkR2Vm56Nk5pc3lJT1FzZzdOR2RUZUhQUFI4dlZkcXlrRWxP?=
 =?utf-8?B?eHZpVkYxbW9OSURIWWF6TkhhK1FRZGhpV1Q5Z3ZaYjFEZ3hsL251aDM1bUpM?=
 =?utf-8?B?QzJoNVprSVkxNGE5a2VJa0w1bDBFaWRDSmQzMzFjZmlybnJFMG5YSUJsVlQ0?=
 =?utf-8?B?L3k2NTNYY245eVhDbVNZeE9pd0xuWlRVZUMzL1czN2l3aitNdDFKYjdxbDM1?=
 =?utf-8?B?RnF2TnNLeE94TWZ4dHpFbHlManpPYS93OEtBZVMzSE92aDNFaGlWTXA4L1dZ?=
 =?utf-8?B?aEE5WWV6VDFJeTc1NjBENkZ3dkVFM0dyTWpHSDJiZ0tqT2R1VERRL2QzNnRN?=
 =?utf-8?B?WGhmQ2s4VmR1SHczTU44WE1HaHBCLzZlekVid3Z0RDZxN3BOOVRJUVR2NVdr?=
 =?utf-8?B?aDNmM2FlblM4elcyZDRzVThuclo4WXZreC8zNGR2RkdsbGMyY2xZaEdKeDJU?=
 =?utf-8?B?bU0xdVlNSG44bEs5WVFKU0tsb1dZMlU4UUhLaUVRUnZ5MzBGdVR1aDdvd0Ev?=
 =?utf-8?B?ZmIzVDlmVHcyK1ZUVWlIT0FlZGJqZUVXSS96Z0lSM1VwVnQ5QVdXY3ZJWi9L?=
 =?utf-8?B?QmNwUldvdTE3eWg2OE1hQ2ZBL3BtZlNXeG8vY3YzR05mZ3pSeFJmNXAwaWo0?=
 =?utf-8?B?MFl3WkxSSkpsVmY5Z0hqTzNIVEdVTnBaYndjcHM4eWZJc1BvVUFoV09iQ0E0?=
 =?utf-8?B?SlFoYUh6ZHNGQWpPK0lUUFF3cHo4VEVMdnI5RXhFK2c0U0NFbkFTNVZKcElN?=
 =?utf-8?B?eitYckRKdm5xY254QmdKem1haWtCd1RZMUxzcUtFV04rcnJ2QjlmcXVYTWF5?=
 =?utf-8?B?U0ZMbHcxNXFiMVAwamo3d0ZXYXFEMXVyakloRUg3dFdjNXZtZldlRzdVY0RB?=
 =?utf-8?B?bDYrQmZCVm5LT2t1a2dWd0ZLVS9SQkk2L05vbTNBQlVvU3NTNkcvOExhRDd0?=
 =?utf-8?B?aFJsZCtwR25KVjRBYzR0bEhlRURUVVl5L2pEMmNCdzRJZW9BOHQ3UzRPZzla?=
 =?utf-8?B?bzdHZDlCNW42WUkrRFZhNWFhbTM0MHRZQXRjTldIaWNLZHBLMExVYUdQM29n?=
 =?utf-8?B?My95NmdwU0RzbGlTRThnN01idkRsVVB6SWRRRmptV0JnU2hZeUh3ai94QXUw?=
 =?utf-8?B?MjI4dVdHQWRzK2lyM3RSTmxWR2F6c2F5NlJWWkNwb09TT0xicGM0SlRXZStC?=
 =?utf-8?B?Y1FsSUZ5VUc5WUw1OWFvMmJ4Y21sakU1T1crS2UrR3BLMEpQNisycW8xWXJi?=
 =?utf-8?B?dVdTNTFJSjM0TTVuTEtoYTNRcFp1N2UvVWlMeUJRN0VSV1NYeFRnZkI3WFBy?=
 =?utf-8?B?TzdJUWZGUjM3aGlsdklUK3Q4K0dmQndSa1cvYkJyR0wzRnV1UTUwam5jWjBR?=
 =?utf-8?B?WklNejZoM3pLTnpHUysrSld5MStFSDMxb0JGV1hHVWhvaUV2dnJGc3pmNTJ3?=
 =?utf-8?B?ei9KcER6RDNBc25GQStNbTE2bHRDL2M1WERFa3pvWVg4TDhmMXNKa0thT2p6?=
 =?utf-8?B?VVMvaUpRQ0VzUTV0U1U2SEZxV1Awdjc0T2JOMk53N0RqN2hWb0lIcXhNK1dv?=
 =?utf-8?B?dU9uVVpyamJ6dVFVNFVEbU9UMUR2N2lyTXRHaTc0MzFJcVBHNGF3M1NBb2Ri?=
 =?utf-8?B?eXFhenZ6ZTNCOWFTcGVuNDVmRGVNaFp1b1BvR1kyQTVxNUZIZ2RtR3hXcXBX?=
 =?utf-8?B?L3NrSHFvRWNDZjVuZUYzalROSFpIY1ZLMjNKZXVDR3hPdDExVTJ6dTdPVmdh?=
 =?utf-8?B?TXVRTytoSGt2TXA3ZjI5ZEw4UUpENFJYKzA1SjloUkZaMXhCK3ZEbDZnZE4v?=
 =?utf-8?B?UGxTdml0d1dYeHVvUGVYcDZVZExwa1Y0TEN2azZ4YzlZVVpwc3hoOEJWRWFl?=
 =?utf-8?B?OGswa2kxY3grUE1SOHhwZkdPWmRyOWJtbUZEWkdnMkg3WUJzaWROcjlDak9n?=
 =?utf-8?B?azJ0WkFTZTYxUkRiZHIzREZjbTRuWXdoYTVKMjFyUWhyYXNYTFpSOFU4Y2o3?=
 =?utf-8?Q?rkN1/qo7SS+WkonuY6kxuuk5Mvltio=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 13:11:06.1131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cf5a2a-d7ef-4a0a-1229-08dd50e6de90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6016

On Wed, 19 Feb 2025 09:26:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.79-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.79-rc1-gde6988e4026e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
