Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274A51FF1B2
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526341; cv=fail; b=HhYYXIyw1LTDJpZdkDvp8ok2XfypYI98P4ARCPisdrlIUKZyThAWG6Kvb1AE/wvglXMW19c+WkRG9vJ6RbfI67OMyRZJBc5jElYJqoGM7J7W/POAu/Pv29eLbDptsG+M0Izc8VIQrOWzc/JvJ632Ap4kFyBlZs9tfWEuSgM6Wc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526341; c=relaxed/simple;
	bh=ZcoBcQ9MYUKhOBqGDqSENC744Fg71+IJtxI7m8AVT9U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=h6bfCe2DHXqm+0VTRvqi37wAw7KCrqeGHnHicJJ0+X410EirxMkhC3suS7BVvcEHTgDX1Qua6bUTqarCjNYUnIc9b8FOMLDHfO0FLUYP4j9u7cX1oWEQCH/8fUAna7hFSyWMwb0KI9eRuPc4brQpVr3XG/q7B+HGH74FOkV4LBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DFp4WlmL; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DFp4WlmL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sT1eEnyQLm0urak0J0dNMluIUb9j3kW6+M57voLrfNcj/9WcER7Xdg0uXSPsioVihs9kkGPt/fvBzHOBct4SpgZlaPptEo8Fdz1+1elXt/QrO0r40xpJUWQ7m08oUSNnVmnmTPUY1+M1Yp2mLJek8rJVoan7h1S3uw6Otxfkp49OyMkwBxSPMWJue+6fQlldrAM47Zy7mdt6r3lVhY2c6lOdUbzMUpB6mfMlruSTfFn12LfHwDdGrUvBEC8La+NFxtiuJI9r34cawLtQqlT7dVp45Yo6LwV7/az/u+f7cvRDL8q0MdpE0EXX2itVbw1m+GAmPLAwoHZQT9IxVt2yhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgw35Qi4+VCH50/b+Akq8QOkGZL5rik0mMBRuY3J120=;
 b=B2m6YVPgjAPQAQp3sZCZ4xmhV9xtZQqjVZDB9raQQkSsf2TPCoR4Vtm8Oz1HKq0c+qTVoVuq7Enx6vjaPfgEmH07+L9W66JwcBspxwRaKpKqdN7Q+vG+8LJE9Xbs+syNwCNoKVVe06eOUPAX9ldGxXPzoeTcofWaXM2w8X+aX7/6RfNr2rq3fkyB8Sg4BbmPV67m6ZZ6CWrDhRJn6Ifl+g0I7/72OUk+2yVxzPPqtjIiEfDbZN2EPuICHteWN/kEGubdisaLIVDMyacP+VhmC8BFPIwmoSwatIwsj0JKVuZoY6JbAowhLguCMtk7PcpfAHJcBqQKm6Q6RceuDCpl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgw35Qi4+VCH50/b+Akq8QOkGZL5rik0mMBRuY3J120=;
 b=DFp4WlmLJHkRG241MiW3Nb4JrFu8BjyeH1KfXlH9oAWeDotsaxzF6Nyd6KI5JxWNuXZp8hf1g5HQaq78y8zYPLJrhUSQJAcNIoKyI654xKA2LOwxPAKpS7ohlEkWp7NG0uJONWvu3CNBKo1Z+pSx2IeAnQz/FS7eBNMXIfqh7pyHtk6f3tW37t4SqSdInX7St6VeSeXfef7GBPl0lltuvWGls+nFPLseK+G9lyfyk5pd1XGJxJK2aWxDaXe2/Cy8xfjeRDDbqawQBnCWy3pcOb+7+QoPx/YZVpJgQ3Q0gpM0SPWV5wNeXIU7Q2QF7GPLA4f6ZsgWG3GTUkICaiK5vA==
Received: from MW4PR04CA0253.namprd04.prod.outlook.com (2603:10b6:303:88::18)
 by MW4PR12MB6804.namprd12.prod.outlook.com (2603:10b6:303:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Fri, 14 Feb
 2025 09:45:34 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::1c) by MW4PR04CA0253.outlook.office365.com
 (2603:10b6:303:88::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.13 via Frontend Transport; Fri,
 14 Feb 2025 09:45:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Fri, 14 Feb 2025 09:45:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Feb
 2025 01:45:20 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 14 Feb
 2025 01:45:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 14 Feb 2025 01:45:20 -0800
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
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fb0ad22b-3777-4ef9-b478-445da3524b39@rnnvmail205.nvidia.com>
Date: Fri, 14 Feb 2025 01:45:20 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|MW4PR12MB6804:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2b7e8c-963e-45f8-b263-08dd4cdc5411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkxoUWwyb29nVDljQlY2QXV2SjRLNkViN1RNMGFmU3k4OUVGMHJ2K3JyZnI2?=
 =?utf-8?B?WDQweFlFNFppcm12Q3JJalZHNStvRWtuWVhzYTdYS3UvSXFTdVpUdUlXNXkr?=
 =?utf-8?B?a1I4djlNbm93RW9kR0F1V05ManE0RTFaaFlIZ0QrYWdCQVVZdUpsc0tZN1hj?=
 =?utf-8?B?aFdnbUtUMDhGdGNsbU1YdTkwNUdwSFZNc01rejdPRzJwclJIY253bWtGVFFZ?=
 =?utf-8?B?YXVYYWxxc2h0R0F0L0JCcDF6UzNwclF6QnJYWnZJem5DWUdMS00vaFNUV3pm?=
 =?utf-8?B?ekFwZTE4Mm5kUDFVbEFPSGhFUjEyRmt1UEtLNVpnZ2pickV6dVRGVzFobjAv?=
 =?utf-8?B?TXg2d0dBK1F4MGgvanh1UnFLTk5NZkd6WUdWejVDdzQ1VTlxUU9Zc0o2MUJN?=
 =?utf-8?B?YXUxQy9tTHZMY000MXZmRlhEemdRMUh5RU9Dc1V1TmlmcUV6Q0FqK0Y5amth?=
 =?utf-8?B?M1lDTm44M09NSnlOYjlrR1Z4TkREOUpmcjBibVpqRFUyVjF0N2p3Y1BlMm0z?=
 =?utf-8?B?Kzk0cXBzUFU2ZnI5dmNlK3JoQ1BiMkVNMTBLSjFaNnBGWWNKUVVGUHRMKyt1?=
 =?utf-8?B?SHdiY0oyaXNoWDV0KytFemVLN2lSanFsM3Y3UFBQbWtmUjZkQmdiRFMzSTll?=
 =?utf-8?B?SWprK3ViSFJ1b3djS0pWVkZzVlRlRFZqRXV6NFZNaW5ralR3ZGNUMUxMUmJ0?=
 =?utf-8?B?VEZuR1FMdDBSNW1GTHl2MjhLNkgyMG9DdGN6OXhNbDc2eDErYkRLdDNoQ0VF?=
 =?utf-8?B?VjJ1dERRUTBIbUlJbmhCRmc1c2UrTmVtYmNTS3ROVmNySUVCNzRWajJPelo4?=
 =?utf-8?B?b2FZN1NwNUQ4YndOTVhiZFY4ZVVOWk9CWUE3WlJPMWRzTjNXcDNaOE1zZHJZ?=
 =?utf-8?B?enNIbnAzazJRQjlEL0xWbnllN01JdkVGTS9pRWFndi9RMEpybnpab1RKV3FE?=
 =?utf-8?B?aFJhenBQRGFmTXd0V0E4WXdhQytuL2VNV3loc0dvT3k2cnB0Z0xUL05tVmxr?=
 =?utf-8?B?TDd2UDFRS1dSNmt1WEw2dDlzVTVZb284UG90TjM4OFhWNXNHeHZUOEcyMktP?=
 =?utf-8?B?WTFSMHdTS1FSVGhkVDBJYmgyc1BBUHk3RXp2OUNrODVDT2g5R1ZKemRjdXNy?=
 =?utf-8?B?ZnFZRlYrbVV6dTVZaFNXR0Eza016ZmZheFJadlRpK2FyYkZtTVVQcStuV2RL?=
 =?utf-8?B?UTZ3MTJVU1B0MkIzTHB2Nzh0UitlRHVHcDBBVkUxSWVOQndob3pDem9NM0w5?=
 =?utf-8?B?M3MyMU5hcGRBZmttYmMxdS9aSG1ONU5IQzllcHQ5VDR6c3JWemdrdjE3ckd6?=
 =?utf-8?B?amh2dnpmYTc3OHl1L0JlVi9QcGVMSkNXRWVtVUk1UzU2NWhVVXFGbVBJNGtw?=
 =?utf-8?B?aGtjVmFyM29CbnBGN01KOUNtOTg3TzV6L3dDRGVUY0ZoWW1RZ2hnWURvdDNY?=
 =?utf-8?B?bkNmYWY4QlpMaksrbFhBcFhpcXZaUVFtN010ZWg2NW4ydjhuZk5Zem5rdzcx?=
 =?utf-8?B?OGhjaXE3VlBTY2paSlBOcFZFNFdPU1dBbnY2ZlpSeHU0TjFhbWhnbVppNm1m?=
 =?utf-8?B?Mys2eEtTREs2aGhCSFc1VjJHTmo3ZHowZ1JlQVJPMlNCbTFPWUlSU2xjQXJ4?=
 =?utf-8?B?Z2lOM3JQdUM0RGZXeFdhQjlkTkp2Zkt6MU04c1FORHBjRGNwM1NSMmNYb2pH?=
 =?utf-8?B?Z2JiT0RqRDMyZktGK1Fpd0NFbmo3YzNQckdJaTNyUHV5bXBQY2k0ek5CajlW?=
 =?utf-8?B?VE9vdHB1MXgzWXFhVnBCdWFhVjIrdjFQTEJGQXloUE5qNzNRaDhLMW93MTVB?=
 =?utf-8?B?cWYzNXUwNHZmdXBhK214TTRwa25FUDRlb3FSYTdOL2tTN2dOK3JrM0xsQ05V?=
 =?utf-8?B?a2F5bWw2M1lKb0tjUXpteVhPcTF6dDRmdnQxRFIxNzVabUYyb05jRE8ydjNx?=
 =?utf-8?B?bFF1TjkrMHR4eFhEUVl4L29rcmIyQUZ6ZnJYVThLTFJRS1dpNU53WFJyYXFJ?=
 =?utf-8?Q?mLUwQeZ/TtH5B2z0SDflrfaZtx00Q0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:45:34.3127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2b7e8c-963e-45f8-b263-08dd4cdc5411
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6804

On Thu, 13 Feb 2025 15:22:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	103 pass, 13 fail

Linux version:	6.12.14-rc1-gfb9a4bb2450b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
                tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra20-ventana: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug
                tegra30-cardhu-a04: pm-system-suspend.sh


Jon
