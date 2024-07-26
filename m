Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569D5684
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013857; cv=fail; b=FkZidwRJyGmjGwly1rtJoLQu2NQiDxqGrCDeI1vljTecJelBV/yciRYrfa6dwY2Hv7N9d/ypLC45rJkuwKVUDl8ReOvHqf194deXNhXctOjPZ7TVUN5rru7Qi1fYSwnFaz4wddLa7ANEhQz9E3T7kfWzqx3CvMdW4aFlPh4+2fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013857; c=relaxed/simple;
	bh=uyfkEH3Sb2fTLNUvTcSTnufJKGTI5ttpYPznm70fkaI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=R8PjwHBxJJ5y2+HhVqZ+/lUPhJHsgM/4deklQ9WrEOl/VOdQZzUPf79C1YHCUlONNWGr1s8UYk5HlY7abF+r1bT2z0HTZ2+DQPa3V9OhhtpwZyej3z/YAjDWACUBpX5i3rZS+OfUmncc8YkM1XfVWJpu4/naeGaMU8iDdMQxfJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F63Zy3MB; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F63Zy3MB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=veH8P1hsBBr8j0gqSbrMDo6iJAjTrGtiqZQL8lke9QUpPWgTyoa/cYqErg+J9VuUJdju9UEbQ/kOLcUXeIPVtZCybtj2+Kg3mFFWt0/kYdfAp629tVSdcu3u8z66eGYOCNG1lNsUbcU+pDnuO+3byAwjHO9NiuONzaUMjNiFCPDjEI/t7kCcda+tThDcjEwxSPLriZP4RmoG44ZK5BzHLR9XtV+wUfeiouDHvVoVvSa7jxgxjst5qI4WOIr0o15l0hkXqlkekJEKfOgm9A2szNd5SHmKr76jB3nCyxT8gOgKBnQgFiHPi3GbnvWWSetZriVWNog8ql8SERpJvOaxfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDDl/K/OenxfPc8uoyn8fw73+tTqIxR2XVGm8o5JKps=;
 b=CKRpSbY8/yThFaV9ur2FzJeI6LtDCHnnssc6UOCD13JvYu3xOW8XYlj4ilmSVCPNsFogcipfRlZGHDoEmXUpAzKxwtbUzBe4MGz6K/ZOrvYauQfT+KdkzSKPLpQu1/t5yJ4KJ6MoYj1VPCGBxrlCqTfeVI5oQKizB+a6us7A1yQj0H4KmxvPfHcNMmmwMwzEpYmK7GWD0CndEQmmiHIkky5yFhrukJGdk+YD/m4QLsjxZR5PII5I7BlhYfsvpyK11RIoBqc9MBpQb2NEx1X0JTQX/QvpWdK51l9a39NU0sWUTZe2Mt4dCtwLMK1aronHmMSpgJUdHM+nm8jVKs953Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDDl/K/OenxfPc8uoyn8fw73+tTqIxR2XVGm8o5JKps=;
 b=F63Zy3MBmBGj9WHOvOR4vAuenhk5ckXS+BvXh5AjRt36GIZrtkAPwsWfyiRP1hLt9h1rNqfNyHZTmDcMohN2opbTxvvCxW9tgJQqZMv5+OUhLvNMT+lLN5vW+4owOu6oX0bN5/rw4wLqxoOh4ueCGipb0QyfQA4A6np+dtU1za2Efj0FFtstNRd/es3KqD7EiY+xQAy4yyOr8cZWnM+tSr7bt0HR4qDtO29RIgvco6aNYmRmsJVsMnKqQIynceDL7h3XfWN4zOEFT8/vbR6NqNgOzJpuUUbG2Fhg156384+flEgKehPSkr0sM9kFz+tf/HAHLMI0Xs515Cc1gvYvpg==
Received: from CH0PR07CA0011.namprd07.prod.outlook.com (2603:10b6:610:32::16)
 by SJ2PR12MB8650.namprd12.prod.outlook.com (2603:10b6:a03:544::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Fri, 26 Jul
 2024 17:10:49 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:610:32:cafe::13) by CH0PR07CA0011.outlook.office365.com
 (2603:10b6:610:32::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Fri, 26 Jul 2024 17:10:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.0 via Frontend Transport; Fri, 26 Jul 2024 17:10:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:10:38 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:10:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:10:37 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/32] 4.19.319-rc2 review
In-Reply-To: <20240726070533.519347705@linuxfoundation.org>
References: <20240726070533.519347705@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a73f2482-e296-4bb1-80e7-a2288bc766ba@rnnvmail205.nvidia.com>
Date: Fri, 26 Jul 2024 10:10:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|SJ2PR12MB8650:EE_
X-MS-Office365-Filtering-Correlation-Id: 889ebb51-9da1-4552-b807-08dcad95e580
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHNKMy9iVEh3bzFld1BPcENTSnBvMmt3eXNVSVVJVU1oam9VUmh2YlNKYU9k?=
 =?utf-8?B?M0ZQWlMyVUtwVnJRUlV5NXMybytHUlE4TnVSNjk1c096U3pEdStxY00xUytz?=
 =?utf-8?B?Y3A2VlpZZDU1Lzd6SmtaaWl6cjFYc1BPZXgxU05nbzdldm1NUlBsT1FuYmJJ?=
 =?utf-8?B?VFU0VmdzRnM2bjBYVk9pL1UvajZBTUhOa2xlK1J6TjZja1R2L0dVV3BNWENt?=
 =?utf-8?B?QXJKanQyaWxRei9aRTFMdy9uSlRMNXkyalVhV210eU9Ddjl3Y0JLTW1IcUdl?=
 =?utf-8?B?RzNqV0xJVU0xdHJIYndiWWZScXpxQXZ0UEE3RjVFS2J1b0cySDJKemdNdTFN?=
 =?utf-8?B?TW9lakZjRlMveGhIYkJ5ZDNHREtHNHlNOERnRkxRVnNyRVN1T2w0UGtDYmpt?=
 =?utf-8?B?YjNySTVRSU5rQXc1Qlk3bnY4bTRNR2dJNGgxWmdGMU9MeVVTNVhic2RsWHFH?=
 =?utf-8?B?NTJTQWF0a1NxU0lKamJMZXU3b2VrSmpVOG5hWUx1T3I4bC9TNmJtVCttZWNR?=
 =?utf-8?B?MjVJMEJWQlcyY1lVUERXaHpNVFJzcDdTamFUTXFVVFFMQVRhRzRMTmFwRDcx?=
 =?utf-8?B?MGFSME9pd25MKzVyUzcrMWRldm1SVWFkQkZndHgxRDkyODlpL3I2L09MaHVV?=
 =?utf-8?B?d1pvczlsRi9WUTNvL0NlMDA3Q3VQQnpZU0w1NmFhNURxWEJTcTl2a2VXRkNz?=
 =?utf-8?B?aFZyc2d3bzdVcHhUYStYK1FreGt2V1RpdVBpVDJzdVdtQjVWNy9EV3lYMTRu?=
 =?utf-8?B?K21VbUtzRkZ4V20vRldoS25mbjFJTE81VXpHaDJ4bFRHc00xdzA5U2sxamNr?=
 =?utf-8?B?VzBnUERROFE3amQrWGJ3Rk01bFBWRDZ4Lzh0dVhkMGZ4K083SmZpS2xMTFdU?=
 =?utf-8?B?aDZsK05zMEJSbTlJTFJDcTRsNXcydHhOaWtFWExvTysxUkxtRkdzcHlxbDlP?=
 =?utf-8?B?MVBEbkNQd2d6aSs0OHRQWjBtVXNqcFYzUkVKNzBCVFZ0QW9vUytkbTFGVjM0?=
 =?utf-8?B?Z2dmdzBIa2VjTjVGc1NaWmRHVUlTZERScHRGeXRTNjk0eTB2NGRMSkFOeVJ1?=
 =?utf-8?B?M0R1SmI5WkVRenBGWWFHdGhCZW10cnViamJFSDg2WUZWNE1uWmMzL3JqU2F6?=
 =?utf-8?B?RWFzVkMzM0hxNGJWQ21EWDAyd3NXMm5WUW5hRmNhRTg2cUYrMnlTck1aS3p2?=
 =?utf-8?B?MytXZGo2UFB5ckRFMjdGc0srS0hXelUyajYrR3daQ3RTcDFsK2dsSzgweXZI?=
 =?utf-8?B?bnBvblJwNjl3YmYybkFJRUxYN0tSdTBzNk1PUEg3SHdzZlJORi9sWk9aNCsx?=
 =?utf-8?B?YVR4alhQcTN0bSs4aG02K1dNdEEyYUF3T3VrblNZcGJCV0VvQWRYMk1mQVQx?=
 =?utf-8?B?VncwcUZzSzFlM1B0a1NsRWMrQjBocXcycUtMK3NJckpoWEtZaGY0S3dveGd6?=
 =?utf-8?B?OHFZWWE0d2Jub3JsMVBWZ0RoTUt6TFpQOWNKUGVPZlVadFBHd3FkVjBYdkcr?=
 =?utf-8?B?US9mYkNIa1hUaDdURnJzOE9ISVhPS1BpM3dwS2NIdnVXdzQ1bUFnNFRhaS9K?=
 =?utf-8?B?ZWdLdEtWVVlrUlJCd3RkTkRpT3I4UzNLbFFYTkpNTFliODN1S3BjVG1YUERx?=
 =?utf-8?B?QWMzWHBsVnptWkZaSWlHaTBNTGRsS2dwb1poVlRVU0ZDVG16VFU3K1NldmlV?=
 =?utf-8?B?UGljQnUyVStzMmJZMEpBVGJJNnNXWE1nRHp6WEJ4WjFCN2dMNzUxWjN6bHZF?=
 =?utf-8?B?TCszQXAxK3JLSTkvYlk3NWFyZHpGRFk3T3hma3RNTWtnTEJCTktWa3h2Q0dQ?=
 =?utf-8?B?UVBJeEZIbjdBUFd1U1RkRjNmVWc4SFNBWDNndE0reU9QM3AwWVduKy85NVhF?=
 =?utf-8?B?U2dmeWNZWkZYZEVTZzFIQVdxOTZkREszSkxGdFE2bDFiNGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:10:49.0355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 889ebb51-9da1-4552-b807-08dcad95e580
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8650

On Fri, 26 Jul 2024 09:12:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.319 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 28 Jul 2024 07:05:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.319-rc2-g0a1a65dc05b2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
