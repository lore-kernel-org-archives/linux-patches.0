Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0885221FD0
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 10:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492073; cv=fail; b=DVji/x3oBATRUt+6pA1G+34yn8KalOoeJh5uzpYBU66J2Ws12KEyyG0Gj/10NjQ8c/wlm4cH9iVsy+fWCiksUgm2qMWxGyluKLemt4WH6woKxKjVanF7vK8RC7qLtbqCP+EbDccUzaiFUqm8DUxfUVlbqH/3T5uFyMELG3yCT+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492073; c=relaxed/simple;
	bh=ZQ+sx3cGDXQuHKfy9xtgUdzkhaG/OmfgcBLcC97Hh8o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=N/Q7gaNG+BLfQ81UmJa8SJuNvIjrBKfxZpS+N8G0ACG/UPGK20eefz1uyyeRPytVqahqVIXRPofdCXTFO6G4cy79jQtPVb9XGxhpMZOIKUw2t4dTxs3zX0g+mljJuO62riqJLQEnpOl9lBuLfDPP/MUkSHIS/N2I2N07vm8CDOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WmbZ3fGr; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WmbZ3fGr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yah5mWOtgQCKg+Z0JHeLbpJcj86OgMfAmBXH8QUwW9nsF5HkvRMfMjo418YHn0vspdLH4pqwN6lWvfjOxBsnMiuiQ6imklf0AbeQ0pb3pgFk32ZZ0S3MvMia4rDohirgdZVdXXSkW/gE5VuhDGie/edvlZh9reP/EKZCxDEfdjaTy00TWA+Io/DoDEIPlIRZo792qwGQfXECSwHAlXf3CCmrUEcyw5i4W3SMhv8TUNDSJ7UHoZ6PwvIQEjFS514Kds7mkwPJMzoAanUHcbQ6EU9KQzmsk0hRWo8HzWMi5WbidrR76UvOEpRm47rvEOfNCSaAYvua2ccCC86G7a0Bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqtVG4Rh3VJooweSv/GHUFa47q/johA9PVavucfqruQ=;
 b=HMNnzscR6GUf8ZbFrbMeNGhelWtA5TI4eCctubh7eu/VBLT+EvmE0+0ZOi+D5U8ekAFOH21vLBzPx7vIWRzqcALg8FbNabxYD93hUiBX1OG1eGtBe+aFBC9IoZvDD5b/rx4IkXQKYinSg0MHvZQMni7cOF5HNtfS0pZFWX5FAYBjCJa/8NxsDbEE+t12qrKf0YhBb6MxeTXgdOKvSOr5MtYHIsuNmSxJIsk0U3RULKYBZlW9jQqZNlaj6JKmKOrPeON1rlQYbsniyzqpVUdXA0C/+z5sjicgR6I8pNNf6SNQBt12ORPOEVTI/5C5YIRp5TtIlB+zOfEh/hrnOD2tng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqtVG4Rh3VJooweSv/GHUFa47q/johA9PVavucfqruQ=;
 b=WmbZ3fGr6lgNcl6xEvUYdfLYioqIZKPneO4cgKSs+mo1EaR5JX9TSM+hUGlXVxPruADUjwI7R2mn+CJr5lx4UG8SfeNSBTuazR3xAVoTorwUrwhi40SWINnP9/9Jna6zi33924Gi1dMs5fid3n8LKB3MGODBel+OYX0HczunzeW95yV85ravVTwdoNPb/OK7PxpDWs3H1MawF5wzJlxpV2BKzdfgf9OTD8cFQYaQ5M2TzpsJ0baw17nIcn/Myv+ueew85+JOY80JwaWqnUWmRFWHpKEhNXEeml/witdNJWw1pLVg4+2smc9rhpJHItUd5GZ+kvWq6q28wjeZ2/l+qQ==
Received: from CY5PR19CA0003.namprd19.prod.outlook.com (2603:10b6:930:15::20)
 by CY5PR12MB6274.namprd12.prod.outlook.com (2603:10b6:930:21::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Thu, 24 Apr
 2025 10:54:26 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:15:cafe::2) by CY5PR19CA0003.outlook.office365.com
 (2603:10b6:930:15::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Thu,
 24 Apr 2025 10:54:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 10:54:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 24 Apr
 2025 03:54:10 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 24 Apr
 2025 03:54:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 24 Apr 2025 03:54:09 -0700
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
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ed1e58a4-82fd-4ac4-9a5f-b66594104f02@rnnvmail205.nvidia.com>
Date: Thu, 24 Apr 2025 03:54:09 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|CY5PR12MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e16288-983a-4136-a337-08dd831e618d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WW1IaTVOOGVWUzdBZlZGSXlEZG15L3prQXgzRll4SlNvZ05QdmZsR2UzWnha?=
 =?utf-8?B?TzhHdFB4U0ZKbWlkYUxGR0NxSzBwanJFc25nZElPRjlvOHg5SVFhMmY2MGpt?=
 =?utf-8?B?dHBYdWlBUmgxZDdENi9QSXhPTko4QXNjZEFDNkYzaGpIa096TUdLN1BaUGZB?=
 =?utf-8?B?elFzQ3JEUGo5UGZTdXlsY1JhWDQvQ0JLYURLeC82QXhjLzU5eE51M3lIbGZD?=
 =?utf-8?B?U3dyS1ZGMU84VmxxQnphSHkvTmRKOGRvYldHK3JvV1hlQUpsRUJvRFRXL25h?=
 =?utf-8?B?WDRrOVJZZVlXSEZFVEZQNGo0TllIZlJyRzRySEplbXJRTkRlM0w0MENCVTJs?=
 =?utf-8?B?bUZTNVpVdUQwcWNzZFc1L1pOOEJKQzE2M1dibG1qanB0YlJQT3VwanBxaDJ2?=
 =?utf-8?B?NzI1TW1BYUM2WHJSNUhRNkFyOEEyY3hacThJYXNkOVhXT3FMa1AycjZuMnM0?=
 =?utf-8?B?a05iYm9UV2YrWG5IZHRwV3JXYVpHVnd1Vm14UjNtRVpJUkpjZWxWdHpBZlFl?=
 =?utf-8?B?QTl3alJHeWxzeW5kYSs5UnZNZFlyZmVuS2RvWlhPazFYSk94ajBJSGVJdjJF?=
 =?utf-8?B?T25FR0pBSkx0cUhVUTJhSzFqUE5FSzJHZC9YS3BCbTZENENEWnI3VUJMeFNC?=
 =?utf-8?B?MWFNSzc1cTRJS0VRdkNGUWs5aTMvdm1xOU9QQmtUV0ljNjFoTEdFclRLbTZS?=
 =?utf-8?B?UlR3dCtpUFErZzB4YTRZbkhvYWZLN3EwV2E3MTNQaWR2NmR4M0pNcUpnMGFF?=
 =?utf-8?B?NTR1ODlUNml6cHVVMzVta2llOW1lQ3pxY2kyZkNieVFUTlJxY3dURmp3eDcr?=
 =?utf-8?B?bk9kdFJsbUg3K0ZFc2N2THJGa1hSLzA0ZXlFNGNZOG5abTdQTUVpTjNFaThp?=
 =?utf-8?B?OXZKeThsQXRwdWt5cDFGYlJxZ2dEZmVPQklzMjk2Mi9oQ09NSEpSbWpDOWM1?=
 =?utf-8?B?ZGcrbGY5U3gwYWd3ZTJkaEkycnliS1h1QTVVcExLMFVFQTU0aUYwZHFGL2RS?=
 =?utf-8?B?UTZrN2V5WlhzeUFXVmxiTGVpQ09yNWNDbzhhb2hsVjhndldmT1kyWHNjaCtR?=
 =?utf-8?B?LzAzNGRrbHp1bTlPU3FvVlAydlE3ZHgyMkFNcTZlekNGeDI4RlJPb05EWUlq?=
 =?utf-8?B?V2RNeGY4dVdXdEh1MVZjS0NZME9FTzFtRUNiSnArZzZDTVpESkRtNXk3TkdF?=
 =?utf-8?B?NlBxemFSNVRxR1dJdGVNNXNZNzB2OTVnNEJpdXBxR2pxTjEvVk1qNHgzODQv?=
 =?utf-8?B?eXRZT3NOMTNoK2prWUpMQ1NWZ0tkNk1uZnFoK0FJSHdOYVpvTzFzajNzWTht?=
 =?utf-8?B?cHZlQzVsMm9jWnBmOWFVUjQ0U1B0ejNhaEhOWXV2NUd0MG1NOU5UaUh6MW4w?=
 =?utf-8?B?VHhqdlh1YlN2cUtRRDdWVDRGdytRR0d2ZnhVRHd0bmhIQit1K3lXc1FzbVNN?=
 =?utf-8?B?bzdTRFRtZUVSWGtxNjlGaHFMZksxTFhML3JiVUo0ejVrK0lEeHNmOWJ4dG9M?=
 =?utf-8?B?TXJzV1QrTHQ5emJDTGJwVUF6YkpDeWJxOUhLUWtIaHdsNUtScERZN3hhUWV2?=
 =?utf-8?B?dUlDdEYxeHUyTTlhZnNFOHRmRXBLa3h5QUR0MDVvcVJDbzB3dkk1YUVIN3Bv?=
 =?utf-8?B?VzdBdWRmbk9zSmp0Q3RNRTF4VlptMkhkd3dXSDA5bm42NnNwc3QwRFhxVjZZ?=
 =?utf-8?B?c3pZc040SmVIM1k3NDFQbk13R3V3T3pPWldoSFB0b252MjRhRTlPamx3dmNp?=
 =?utf-8?B?b1dHQTE5NmY2Q2pUaHlTUkV3VmxKcXA1WUszVFNaTElSV3NmTWtnT0FlK1N0?=
 =?utf-8?B?RWVaTkFDNFNpMlB3dFNRMWZWWXM2azcwalhZbUthNUV4TXNYRU94VFdobU9F?=
 =?utf-8?B?TXBvZnIrR3puQ0tKcy93WTAvUkZBbHFUK0FSL1MycjVoYlcralduTW12Um9u?=
 =?utf-8?B?dnJWQ1dSWDkxNzBVWUt4L2RWUXJsK1pHY0FSOG1Cc3pCUS9RcEdrZzJCNllD?=
 =?utf-8?B?L0V4YzczejlKTlloRWZYckpCZ1VidlFKZFJMUWNueEtqZ1RBd3huc3ZLS09Z?=
 =?utf-8?B?UnJCQ3NQUzN1QW9pcmdYZzhQZCtJNkQ5NHVPQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 10:54:26.4002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e16288-983a-4136-a337-08dd831e618d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6274

On Wed, 23 Apr 2025 16:38:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.88-rc1.gz
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

Linux version:	6.6.88-rc1-g2b9f423a149b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
