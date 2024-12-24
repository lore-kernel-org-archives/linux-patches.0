Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0BCA6B
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 13:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735046806; cv=fail; b=Q+RVUFyk2Br/sVOruW+gUgnkRjdG0ibaCnu3O3R5rofWEsjJnK9Y6f0ad7GQaHHMETETL/RyAmsgY2pnBMm66fpbWT84Mrt/iHkw08QXJglxfSJh5IrwTnn814N0sjJuz5cyr4B5DAsvbaBJNKZ7Cn1b0pIXeyItgx4j1gLxIKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735046806; c=relaxed/simple;
	bh=kW83zEeBcDWliLQM1XC5JRu6QQrbFCzv9WYDOeTF3oU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ro5rQ4ZebQGH67eP/Xcv2pimCzcGRHqSIwbFaFWx++6src9V/BLBVSBjJ9v/mp9NRYau1rM47dNv0Wbphv09+zLtCFaPbzwzQTEJEjE1Gh9vCMimAAICOB6S44Ci7+ZGXQJZNJya8LikFfqHdYMHabsebDAj/BEHEqycSxBtMWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C/bozshp; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C/bozshp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hv3gHSUTlq3d3JkVzSP/oqVUepvKBtsYCkX9jFKEMdYlI/Irb9Etp+4K3Lv1UVqQT5V+c/vc5DMlUxgbTo5WHlaQ/W/iCDJBSXM7TXRP6uo2htvp+7i2d8ZoZSYPGmRLvuct/tRQr5TpjSwJWSIfGpk1RuvIyFBUXoWC/pB12cXu3vu8fDA/n6TZT0NNSFOYJL2EpX17oGpF58IiPgDNA3kKJuU4fzHLlNZryEe8RP7TR6FlCeTXsw5GDXJUK2tCGfMzX9rITZxou3x9z7DVZN7CBz4txaBzlm+7uS/NSw/EYDjggB31uTYFIWkM5Th+K9cobO+FkIuomnGu8Vloug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwhiEz2TV7W04y+MtGD3Y2T3UJQGai1zq9YJp5JyLSI=;
 b=UEA8h9eRKq0pEwMq8HcbkYCLAuvXnQmonHaDS0doVRYy0Y6CEbhZV41Vg9h5okbfB7M3xuQIo3lSJI643054eRp+saZq9azVYdGoUCYpmzh+X3auDt500KAH+9lpYR3uClL9uJZnGi8aJV7s6NaGI9AmDMkwpIHg6dGhW47kADLx2g0qdRQ5mXTu2gBDxS6iqRMHFqOT1B2i4doeOuQ6UqTBLMg6zut+4sM8si8RfRwIpwaw5lA02twaI7sRSdpW9Eqq+tp2apa2vXFBnO9r656xotolQhXW84nu0n1ZYkrSWdoo6m1Qws1SXpRkBMs5nTaRvv8gQ3KXCE7GlgFcfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwhiEz2TV7W04y+MtGD3Y2T3UJQGai1zq9YJp5JyLSI=;
 b=C/bozshpDylRdV/tPCv2KIySc9fbpsHQXjNoZvxE+BmP0sWmDRw1VCVRkNzMglBjnNKLPuaplKwvacy4j1EFWzmQP2Qf8VEnY81tOy+iZzHFaZMoLSKCtNy4UrRTFf72P5sjI40CMnIg/IuT/SQl3aDe5ZPYdbHEvVYq19m3YJiB2DvvNR7HtWQUP7ycQa9bmFY4qbOyazUDXSjVF9hFtsNthAZrHAArFayxJkNF16VHqgcEHD2xZBnKjhx3N+DbTQtkxrWcEQhUDQKhRRzgrVnYxAojjGQUFft0yozJNCvHwHyzIlXv7VgznB1MHuT1Kxy0u1moEJ4W6HpZlV4b4A==
Received: from CY8P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::13)
 by IA1PR12MB8586.namprd12.prod.outlook.com (2603:10b6:208:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.14; Tue, 24 Dec
 2024 13:26:36 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:6b:cafe::59) by CY8P222CA0008.outlook.office365.com
 (2603:10b6:930:6b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.22 via Frontend Transport; Tue,
 24 Dec 2024 13:26:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Tue, 24 Dec 2024 13:26:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:24 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:23 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 24 Dec 2024 05:26:23 -0800
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
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <dfcd1027-c6ee-4817-b9ef-c6c629d40c24@rnnvmail203.nvidia.com>
Date: Tue, 24 Dec 2024 05:26:23 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|IA1PR12MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d0384c-5247-41e5-c2b1-08dd241e973c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXZUaWp2Wmgva1FvMktqUExublp2bXdsUnpWc1FaZGgvT0ZMZHYrYWNMNDZh?=
 =?utf-8?B?VzE3SE5RMCtmQmxIV0FPTVRIRlNOQk90UkVvRlJWSUhTMlU3eVN3T1B6TEhv?=
 =?utf-8?B?QTZSeG0wUlFQME5RdnI0cjdNc1loNExwOS9pdzVlY2xsbmN1Y0xtc2dkem96?=
 =?utf-8?B?cktRd09EcUFjRElYWFNEdlF0K1hEUDNXQ2VNazVqZEZiQ0RaSVdiUk9pNUMr?=
 =?utf-8?B?bk1tZ2dZSStzTjlrUWltYlhERHBGcXVUNElQYmhRRXZIL3BKdC9UVU0yOUVi?=
 =?utf-8?B?bVYrYkVBUndKSlU1TENESkl0YUx2RmtrT0t6bHR5c2loVXJYdUs0eWdaenV5?=
 =?utf-8?B?NFl1N1luL2hxTnYrbWRWRGRIZEV5UytzSEFQV0tidkN3dkNyZHl4WEhEM2R5?=
 =?utf-8?B?ejAvSlo1VlQ4YmVZOVJ4dGlGL2ltZkJvNmYxbDQ5VjVhdjNLRzgxYmxpaFRU?=
 =?utf-8?B?aWRQU0UwaS8wZVNac2hRRjlYQ080L1ZTVGRtU2NPNTd3ZUd2ZEE0dWtXNWg3?=
 =?utf-8?B?UFVKYWt2UkN6aWw2N0paZFlvSDZVRWpnMHRHd0V0a3VIWVFtcno5R1BKYXl4?=
 =?utf-8?B?ek5TcjE1b3pNWTh1elVYem9CMnNsOXEyaS9TU0tMMU44d1o4ejV6OFdsaEZm?=
 =?utf-8?B?TkJ1Qm9DTVBNbFlTRmRMamJ2T2VkYnlRU1FUSTJXc0RtZEJvYXFEekZZL2d4?=
 =?utf-8?B?LzdPdHJRdXBMRTZnRCtkaXdCZ2ZLOFZEK2pUMlY2bjd6Q1FLcWhGQ2NhbUlE?=
 =?utf-8?B?TkxOcXZyTnhldTFtS1EzTjFpVHFKMm9kTUQ2ekhBNFdiWXdicU80YkR5ekZY?=
 =?utf-8?B?U0I2SmdJbGtYSHAzSlJLYjRZNHFEei91ckNyNlRaTHZETklQcmZ4c2Zwd1k1?=
 =?utf-8?B?RDJJaWgvWEUrSUswL2IrK1ZxbVlxWmZmem9CNm5sTkwzd05WdU9nSWc1WjBs?=
 =?utf-8?B?NVZEQ0NKYStudzdSeHpzWVo1bmhyd0p5enJWRk5TU2VMR093NmpDd0pVcDVz?=
 =?utf-8?B?VXRHQkV0dEhVUU1aY0ZxTUtyM3hDV2ZkUEJObUtaYTZkN1pqaUYxTGRId3M0?=
 =?utf-8?B?SWd3aTljV1FhOU5DcTJNS0R3R0NsbnRLVm42aTZNK2dESXNicnZWa0JHY3d2?=
 =?utf-8?B?YjY5S05ISXF3cXZRTUgyTWxrRzkrd28zdmNyV3ptWnc3dlJ1N0dLVWI1Qllj?=
 =?utf-8?B?N1JTa2U3S05JR1BBVHBIblVyYlhWTXh5NzZzNjdMVGFSR0FVdHYyR2JvOS9W?=
 =?utf-8?B?aDFtYUEwakc5alRQVGxyK3JWbjhmMmFOWm0vN3F1clVRLzVCQm43Q0VKVjFp?=
 =?utf-8?B?NjJpUC9mbWN5bTMvekRPcHh4amlBa2swOFFhd3RUN0JBVVlsMnBIdlRCMTZQ?=
 =?utf-8?B?Z0JKZTY0VFpXcy83TE0vc0swTVQ4MmJUWVJIVVdyM1ozUFhJUmR5eDlUUE9k?=
 =?utf-8?B?VHZ3bzdvL1NVRitwK1R6bnIyaTNVbkdOZGtBLzVXTWlBL3k4TmNhSXJPeHRw?=
 =?utf-8?B?NUdBS1A2NEphTm04KzAxbUdlek82NFBNR1JYdHRRSHRVZHROd1hqNmtMQWpO?=
 =?utf-8?B?dEQvbG9ETjRLWXlNT3ZoS0lHdzRwcy9jc3JYSzBwMG5oaElmWFh3VzhZSExQ?=
 =?utf-8?B?MUpLUHM3WUZwVGk4QXlmZzVVVVV5TlY4TU1uUmgxZVU5Sm9MOTdYYTNaUXpT?=
 =?utf-8?B?b1ZyZnpSMnJJUXR4NkdxUGFFQ1VpOUkrTWl5K1kwNU5abzdZUnFrRnVlZVpv?=
 =?utf-8?B?cEJSTk5uM3l6RXVuRGNuanF4TEQ1bEkzM25PakV6MnNKYkJ5cHpiUzd0NGNH?=
 =?utf-8?B?NURaaVNleG5nNVJDczdzd0ZnOURCZzUrZWd6aHFNL1hkTVNBUUg4OTJNY2Nt?=
 =?utf-8?B?Wm1TQnNiV2szd05iSURoY0FTVUcxVWZNUFM4NjNsL3Z6S3BoRmJMSk4yeS9Z?=
 =?utf-8?B?Mis3MVBJOWl0WEVON25BV2NvOWU0NTErS2pKZUlSczZYUjlHMVZ3blVSM3V6?=
 =?utf-8?Q?6AX+Ya2OvCXF6MNPDztibI8cFyxCTw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 13:26:36.0345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d0384c-5247-41e5-c2b1-08dd241e973c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8586

On Mon, 23 Dec 2024 16:58:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.122-rc1-g7823105d258c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
