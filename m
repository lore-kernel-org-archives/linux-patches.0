Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26DC16DC28
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025479; cv=fail; b=FCfpXdqLJu/375EX2A+UkfOVIqf/KBbUxn2Jk4HsyGf8UEsThqomlVt2eUUVQiGMaxpuZpnlXABjfQCikhOdecTLU5TPkHRdtfDxAwOKMa06/HbWr5VtPRZ0m8qMiaT19m+ypAL/BIk2fUHV5hucfVqJZBkzwaQQcEsQb5KbtEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025479; c=relaxed/simple;
	bh=vrcgrKjlcGlX5EUQqZeGmhF7uo1G6dZFxG1hbXfzbFQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HmM7+WDm0UDDGvBlq2qrJ99eTk3WBE3irznrwCR5Ye0+CZgHe0+jt1y89DSyENWsjil4wsrgBJm+uyxezaRXWqj6pUHuK4YfflfVMOnr4XuyqTlBHtoZic7booOn6pKqk8AlL7JPMgRBkufKLh1Z4jCM4cgD2W0nRBBuqSClJlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EaRJsTeQ; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EaRJsTeQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LahSVX6uWPq9TOZWsVDkJ+/sz9SWK2EwJRSBHcv8ug7jEwG64iN7tMDWMRTClEnTVeQFF+1Tib+jA2mJMAfwZNX33xnuQzpk4ePt2gxWjq2mI9yHgNdaoRfb0XkZG8Gs7xYeAgKfY07S+N0XXXQdI7/mpfKcr4Xjf2rpipRHUlzVQKf1nh021LYmgYwWCSAFvJ4QLMFuLl57qHdljndjp8Q9V63NYAN0UgD0y6Lp3rUU/ZEMXOS4zWs16xspH0pfOYi9ssSrbO42CVU1TfztlRPmC3AJPJheglOTOopl4CoxLgI2LJBkT16wLXD2H3+lhSlx1pyJs3P0vW/6PYP9sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCI6MVn5y4/5Q9R0L1hUPqnzC0i7S+RIuBwjYgSyYsQ=;
 b=nwHHgl2aakASa6rVlv4u3PV2pNZQuOXIM/kRI1Z3yfQGNv/1TgxyFftUs4QwW5+D8XkQsw/vSIG52A24X7qKg5WyZLgPvHz9onVgkd8ryYus98hJBVcRbw5wLxX+FgtLQXYklWZA+UsWtuu5AsEk2KHAO9RmtIad1y8osK+SYxxld+RP/Q+In6htCoqmxtFtLm0/stjhZa5+1BrnWBdJ3bXi7QAr5+rAJo3oTXzouThJc01n5KvCOVQd3N0jeF0Sk1BOpyDCyoT6oSp54mar4PjJ9/eTJDRznV9wfKLdSVJMTGhyn5wW5U86h7EkBIzNUezGq7Aa3HaFxBbIYN97GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCI6MVn5y4/5Q9R0L1hUPqnzC0i7S+RIuBwjYgSyYsQ=;
 b=EaRJsTeQS57kl/YiX2KXWiosHTtRgsU8pFrrreH5G82HWLzI002J9yVMe32bxcOgDVqDfEIUKRNAPDX0LwWMm6CgF/I335Fp26Vj5TvBHacv8i1sW3/Px8A3vF41YF1yDoVm4oYxowTxpvh0bRmsL5+wcj+jEJH4WI4Su+jv3zXGCQ5yjGGV6m04XQtOwhSEbk3NAOkDmdWa3pUemQctISJuQYSqqbc7L0QHbVTu0JkAur0CjWh65ULtWXyhsQigQir20dwzpdAjxJqw2VB9bLEXRe952P6F/LF5zD/wHV1NjXOPMWluKu83islfJuv3JVDNqjkSFUSb3PRZ3fkoXg==
Received: from BY5PR20CA0001.namprd20.prod.outlook.com (2603:10b6:a03:1f4::14)
 by DS7PR12MB9043.namprd12.prod.outlook.com (2603:10b6:8:db::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.19; Wed, 30 Apr 2025 15:04:32 +0000
Received: from SJ5PEPF000001ED.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::82) by BY5PR20CA0001.outlook.office365.com
 (2603:10b6:a03:1f4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Wed,
 30 Apr 2025 15:04:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001ED.mail.protection.outlook.com (10.167.242.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:04:32 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:04:19 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:04:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:04:19 -0700
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
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f84163ad-2e1f-42ca-8546-7e077e13f4bb@drhqmail203.nvidia.com>
Date: Wed, 30 Apr 2025 08:04:19 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001ED:EE_|DS7PR12MB9043:EE_
X-MS-Office365-Filtering-Correlation-Id: b45dd4ac-2d7e-43e5-5b4e-08dd87f85051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEFVZUF3MHk2dTI1Ui9QZ0VFbFBwcVM5TllGOFlXWGVZRVJ2R2VKZXVVRFdx?=
 =?utf-8?B?QkVyY2R3dTFsWHN3cWxZU0ZsdTNKZGxkK2RIZzEwaEg0Tm80dy9MYklxRnlD?=
 =?utf-8?B?U1pGMVY3YnI4dUNrcVhGQVFEbUFleC9YUTBBUjJ5alZWSFhJcGg4Vm5NeGZH?=
 =?utf-8?B?Yko5dmVWNkh3eEFYVXVMVG50RmVPb2NzY240aSsyL2pZekQ1U3huc3F1QnNO?=
 =?utf-8?B?VDhtVlhnNUlSS2hiQnQrMG1BbG1XRG9JbGhyenI5TFFvWHFFM2x4RmZtZGcr?=
 =?utf-8?B?NFY0b2JVdmxRMXZvYWxlQzhrYy9HMlNXajdSdE8yWldhMWxnNTVxbW5ZZTJa?=
 =?utf-8?B?T2ZHRzd1YUJXSXJVWXYxZ3hVOGRUWWJ6RGMvYWlYTzNwRFcwQ1I0KzNCQnN3?=
 =?utf-8?B?REpBbGhNMjlxT09vdzJ1QXBQUlJ2OWVnWjZOdlZzMER3cUR6anRQSU9JaXBj?=
 =?utf-8?B?bEV4eWVYY1V5WmdiQzFtRmw1eHNZSGFZQTZUTXpBcnkyZkhzNFNOTGZCZjFH?=
 =?utf-8?B?bTd1dEY3OVBxUlVXemdPRTA4SHBKdEhkaGRYeFpQQ255eHRlZUdtOUtKNEgz?=
 =?utf-8?B?OWEzNWQzTlFZWXg1MHh5dWJaYVJZS0RyNmp0cFRBL0t2RVZkRzdkS1Q3VHRZ?=
 =?utf-8?B?SW9JRE1CV0FxcWNGRGsvbHRIZGdtT1dkV1l1UDZmQy9pdVhEaXVTNVRONFFp?=
 =?utf-8?B?ak9HQTllYXlZMkp3L3ZUaTNsLzU1RFFQMjd3Z0hVVWVDNXAyQnI5Yk9ZYytk?=
 =?utf-8?B?N3lpajBhTnVad0NXVGJQejhhNDdnMTFWTjJjV1lxOVp1N05IaUFLWGJHTEpL?=
 =?utf-8?B?YWFkQm95bEZxVGpQcUdpUWVNTzI4czNwNXAvUml1dmtZSkpTZGRoaXRMSm9V?=
 =?utf-8?B?bWFJem12V2hNd1FDY202L3dLd2t5WFJSTXhEOC8yVHpBN2NwQm5LeU0rV0NU?=
 =?utf-8?B?MktHZS9ha1J6M0FoYlY4aWZJMFlkT1g3VlZ4LzVjcVFuT0NQUTFDMmRJSU43?=
 =?utf-8?B?dXZSeGszVGl5ckNGdFVjdUhhRWppVjZJYVZVc1ROcFlKT0VTSDNtTlhjZ0ht?=
 =?utf-8?B?N1hMVzgyelBGVm55NWVVZUxBUzhabmRleVVIdFF0aHgvRjZHeUtOVzZ2WWE0?=
 =?utf-8?B?cUpWUlJXelhsaUxSNjFzNWpMS1QzV3oyckwxWHVXV2Exb3hSeDNQVEgvZnNP?=
 =?utf-8?B?UHZRMHJkSFp0RDdNS01pK0ZLNzY5TmV5bmJwVlkvK1ZDNHNkQ1ppRE5pQnUz?=
 =?utf-8?B?SW5HV2VOenNMQmVCb2g5MHArbjR1eW55RndocThGSnlsZ0Q2dmtYYXRHSU04?=
 =?utf-8?B?YyttbWM1UUdsd0d0MTdnWmV3TVlPUk92ZU0xT201RmRobWtaZUlzOGo4TXNN?=
 =?utf-8?B?dmNQSnRXL2VVUzBXQUZqdGhEcWJSMkJmVXFETU9qNWw0ZktTaFplRTAwSmYx?=
 =?utf-8?B?NDVvYXFzNjRtMFkxVzBsbmVFdjFnRDZNTUFCOU42UkxhejlycUp5anlWVVpG?=
 =?utf-8?B?YnpPRCtPUVBrYkQ0bEJheHVJZFE4V2hsRlc1NlFhSW1ZNDVUMHFhU2x1M0tm?=
 =?utf-8?B?NVpDWXlxRXNYS0pLbUlxdVpnUHNwUUI0bmN5NjR5T3ZLbWZIcCtudG9yUzc1?=
 =?utf-8?B?V2tqT01KclVqdnNZKy85UFJkVFhRcVcyUFp5SysxSU9oY2NaMFZ5U0VaeTdW?=
 =?utf-8?B?MzdLR1JKU25LZEpUYXlSTDU5MXZrODNuTW1RQ1U0elhyT1hHQnEzU2R0R0tF?=
 =?utf-8?B?RUlHMzhsZ28vaXI1bmVuU2p4R2E1d081cTlDVXJVVkVwL2VFNW1CaXVUL0NR?=
 =?utf-8?B?NjBnMGN1UjIwVUhwVFNSckI1aUMwYVR6TExyOGxQQXo3ck4vaWxMdjN2b3hj?=
 =?utf-8?B?dk54d3p0K1paZWMrU0ZLd2J5NnljbnZNZ2NjZVZlRVRWY0EvMVJYcHpyZGlM?=
 =?utf-8?B?M0xSL1Axdlc2b3BGRjlVdjFjbXlpaC9sdUxvUDRkeFpzQ1FTS2s3c2p2Rklj?=
 =?utf-8?B?d1RlTlRXL1MxTHVMMlhaY3hjb1lKLzhxZWRjbHN0bFcyMVlNaHNRMzQ2bTFF?=
 =?utf-8?B?WGJBNkRuT083NDZOTVVBTmRHOGRvNTJkMTBtQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:32.4895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b45dd4ac-2d7e-43e5-5b4e-08dd87f85051
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9043

On Tue, 29 Apr 2025 18:41:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	104 pass, 12 fail

Linux version:	6.6.89-rc1-gcbfb000abca1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: boot.py
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p2371-2180: devices
                tegra210-p3450-0000: cpu-hotplug
                tegra210-p3450-0000: devices


Jon
