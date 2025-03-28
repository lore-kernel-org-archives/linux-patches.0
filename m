Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA94C184524
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743183484; cv=fail; b=O++F4bpZu5ge1yMK4Ih38bxZI6HFkiRvLfrWMXqT2m9aWC3SPDU3wXwZPePGpof3pZ4PLwzAyAVotUY57EAZQmnPUCjwefc8w6Bs07JiPQ4SASya4Sl9GR/kkwTPPfvxtmQalS1Lbmj+aDImGjD/cmYhaTBJQHy7PLWmrkbMOgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743183484; c=relaxed/simple;
	bh=K53XPuiBmzKPnG59O4Rsu3rFxGG/SgkFHsiWf917A/8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=W55EcR/O2Wb/TMicNvIEEF7pqmkyawptIoz6SckVBuxeEj9AddxqJTcZ17pZBArgrsiJfINzZBfIV8UZszVYb+R8sjDolRPYRtG9jYO2v7pFN105KtTZ/IV2spZYUR4QnuHw0jRuPgW5oLHg7fDq0K9OOZjxy7TBubeJbzDiE3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MAeuQ2cF; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MAeuQ2cF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKVzI5pBdPABeeWX86nRV8848RZAHmrdKx7LhGPP6mXtT6Yn+J3adOzW54l01TxQnpM3ALmZNjqYSI/yN1X4Lip3AnQzMVUZqjBT2VwbFDIcIg557oCnaWLrd7h5Sh3ukxro/orHUUZHQ5m/6NUN3O1cGo5Cf6rD5oE2qM/9RzhklJaB3/qvEM67n942DWkRI0FMAS4l4wrh1ZZD5bV+57WwLtJkyB96OwAiQSjxOlxfv7RWoW/mowFZoGWkmvf+EyFij9OYkRFVkgRnEN+9sXyadfoRTbfCMxA7uy11qZrnNHykwvF6+oeSKuiKcDbjZXhEwtJO4hF68zNaGBPrmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtjqAHlza+3EIwWYz1Zr8OHnOWsj3JCc5dgmECVg7t8=;
 b=ec8CjHdcli10f3jxEm6EfwEOJqXQz+mdUPffKWjmz/DrFdmtyGtz8OxMoOBMfDifHjcjCysFLjtYfv3yp5P4dHk5dzSTF8KqL76JyXm2+jyOJBhzYI3Y38CP0qd/C1kd8pLc6Pic2BjIamf0t0CwpFYu92embkY17efSoYdZhWG57gwTxRuV7bHv0WwVw5DQpyllB0K2tgXdUE1imo/W4fnHlvAB6dWno+zNeFW2gzgK0VrHCZ5hJ6kxA6axihFD77AJQrJ1KXQEE31c1i5GiLIbrbv4cfspKZvjr3NO8VK+XK+Tzj4oezvTCw60py/h+phnMck0UE1GAB7NxACYEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtjqAHlza+3EIwWYz1Zr8OHnOWsj3JCc5dgmECVg7t8=;
 b=MAeuQ2cFUrT1WocxZMvq3Q83b5hCJL1miZWWaIUDm/lP+GZYSO7vZ17iP2Pg3ECVG7Tu8AYWiaF5zeSKEhcyg3kpuKdzaSAmZwviWyGhciZrYkAsTUJNh9q77PmEDdlxvrlvGyqnT5boWhVrF//DrEHjXDOFE7fwCOonaYsrVKBbEVKE7tNC4G5p5l6ffBE1aFbkZy/lIiP6CwqzgUf80IcSDRx/jkMq20aNic/zRxLOJTwJ01x0hQ73G8uJ+HNXr2t3Mncmfjjfpji/Q10Ceplgy+E0Mb+4SnEL8xpTSL8ede0cLCxB0kq6NTWqw7K441EgvCQzJ63Tygn1P9gd6g==
Received: from SJ0PR03CA0237.namprd03.prod.outlook.com (2603:10b6:a03:39f::32)
 by PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 17:37:58 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::c8) by SJ0PR03CA0237.outlook.office365.com
 (2603:10b6:a03:39f::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.44 via Frontend Transport; Fri,
 28 Mar 2025 17:37:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 28 Mar 2025 17:37:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 28 Mar
 2025 10:37:50 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 28 Mar
 2025 10:37:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 28 Mar 2025 10:37:49 -0700
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
Subject: Re: [PATCH 6.6 00/75] 6.6.85-rc3 review
In-Reply-To: <20250328145011.672606157@linuxfoundation.org>
References: <20250328145011.672606157@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d6dc0ec8-69cf-4fe8-a289-77c7663b0d66@rnnvmail201.nvidia.com>
Date: Fri, 28 Mar 2025 10:37:49 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: bcccfd0a-c88c-4fe7-3b17-08dd6e1f47c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFlrZzlPRUprK1NjU0xBSmlEQW1ScVJhS3FONkdUMWk4YmJkaG9QcTFXNFRk?=
 =?utf-8?B?YnVWZGYxamRLanRjUjhHcEQ5MUF2andvUDZDL2xQK1pSaFVacGRtYndiUUEx?=
 =?utf-8?B?NzBacnk1ZUNSaERlaDNvYlppM3BCQW9GYlExN0JnN0YyUkhkN3UzK2tpUHV1?=
 =?utf-8?B?S2xDUlB3WVFpVzVJUm9RaElPQTZqMGJGK1E0R2ZCUDZ3WDJTbnZ0dmZhK3F2?=
 =?utf-8?B?L1JyZnNpRitXSVJQMUttTjF3dnVFQWcvRk84Smwyc1BlcDNOTmZkRkxHN2kw?=
 =?utf-8?B?anRWZnNCemNYdkRBelE1dkREVDM1R0xNYzdhSmVoTmg1WGpLQnV3TE11am1G?=
 =?utf-8?B?aXJpbEgvQ2crN1JTZi94TDNaYnNCak52K290T29yK0NxalVvaDN0Ty9lUjZz?=
 =?utf-8?B?b0kvYmFCWHUzeDlsMDJCNm03ZjloSnhJN1hvenFOTHdBNFltaDJ4Y0NiRkds?=
 =?utf-8?B?V0habzBYYm96ai9XdGRhWkVhZitqNUZQWXJJY1o0QWN3MnRxZmZzZTVVRTlE?=
 =?utf-8?B?Mjk3cG52UUs1dk1Nc1JlUkhpMWxpTWs3VEw3cGl1UE56a2FIMGlrNzBGK0tQ?=
 =?utf-8?B?bzVWdzlEa056NHNPanByY3NIYUo2VTBLVXhqT0FZRzdrVTIxdkt6RE5OQTZT?=
 =?utf-8?B?S2gwaXViYWFiSTBWNm1LMG1kb1Z2ZThkOHRscFoxSC9la0JrMVJ4UGJmREJ1?=
 =?utf-8?B?UW1UTmFlbXE4NXhQc2NzK2x5ZlE5ZFEvdklwekh2akxpdEVuOUxjZXA5WHEr?=
 =?utf-8?B?NUN4VzBpZmVRRWtqTzNhSkhSdXJCS0hIeXZpbHc4QUZLYktvUW9acjlhMllt?=
 =?utf-8?B?d3c3SFFURGpIcW5JZGgvRDhFWEptVVkvcS94Tm5uWlhBMjJaV1Z3UDFoanlU?=
 =?utf-8?B?QzIvQW55dG9hQ2ZONm1lUVRBTjdNdWZ6ZWJiSmluVnNkcExPZ2hnL0tRejVs?=
 =?utf-8?B?Z29Od0EvUWtsZDZheDJQNkxCK1E1SzhvelFaN1ljaHRqbnl0TWNMSXgxTlJ0?=
 =?utf-8?B?Q3NnVThTWFErZ2F4OWtOM3UwQW5RUnU5eEk0ZVBoQXYrRHNSTHE2VngxVURw?=
 =?utf-8?B?a0xkZ3VSYWFEb3RVMjJvRkN6WEZDNDd0M2NUVDVtY1Y4T0VoL0xxbWQxNGxJ?=
 =?utf-8?B?bGh4c1FBZnRsKzlYRDRscFV5S1NHcSs1bkNsKzFQWUFubDVJNXVYNnltZmRt?=
 =?utf-8?B?NjhaN2hNY0E3MUNQdjZkMWpnMlVQRWdRanVNbzFvbFFHV1lpRk5yS3B6d2c3?=
 =?utf-8?B?dWFsRENpV0labFhrU013dnpoMHBVblBvTHYxUmRqMjRyR0x0SUxjWEVmM0N5?=
 =?utf-8?B?Y1R2bmM5MWxxbS9MY0lPMyt1QVE5d082STd2QjZHdTVzcXhmbTJ4dFdUTkNI?=
 =?utf-8?B?bGZkTVIraFNMY0tEc0pXeklvcVJ5WmxtSlZrbTVGQzJMdmZjWDgyeUsrYUl4?=
 =?utf-8?B?NzI0Y1cxUDdFRS9vMW1RTmYvV1pLK2o4M08vTVZ2RnZBQ2RjSFRwN01sM2hy?=
 =?utf-8?B?WXZyZnFOQzFSRUdyclcvY1pyWXhKNGl6dW0waHJUcU9OOG9oa1F3U1NGcVo3?=
 =?utf-8?B?WWFobC9jMkk4SVBkQ1FLS0hlTkh3VEpsNzR1Vm9TN2ZwU2M0RmM4Q3ZIdmNh?=
 =?utf-8?B?Z0w2bUFvcHVEL05IR3FwZjFSSzU0Rmw3OVE4N2U3eFRiRFlkVEF1V2EwaVhE?=
 =?utf-8?B?ZFNkMXh6MGFTUUtqMTI1d0p5QlZjeFowTUNFQkhYWnpZeWEzNnZTT0dxbG9r?=
 =?utf-8?B?S3Z6YzdReGtjYWpDZEFobVR5akNZa01YVmkvdjNucUtxTmZGandCQktXODNL?=
 =?utf-8?B?VHZKc2RGU29PMlBRRHhVSm8zWUZlV2lTNVZKUG1wQ1JaRC9CZER6SjJ5TG4r?=
 =?utf-8?B?dkZBWHlTZDRWS1lPeGZtcHgyaFJsUFNKcWw5bjNjTkJhWGgzZGRtYUltWkdU?=
 =?utf-8?B?UWtsSW0zNlZFTmoySXpwdEsvMzRjcmpPT0laY0RtNEdJTFlKS0VHRzl2VXVu?=
 =?utf-8?Q?i2mXR91buUdKm0CzRTVOslPL1Eu1Yc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 17:37:58.3381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcccfd0a-c88c-4fe7-3b17-08dd6e1f47c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155

On Fri, 28 Mar 2025 15:50:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Mar 2025 14:49:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc3.gz
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

Linux version:	6.6.85-rc3-g1a8546896fa3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
