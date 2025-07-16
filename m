Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907312F3640
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660731; cv=fail; b=P2Cmg5vdMeqE5qjK1oGA7/uwR4Uujxl8oyFOWykfLMQ9rxbmbzInN2nQgwvM9HPdQBSiK0arDNS5DrxKLov6k9qIVFae2EhQhPFl0LwWhe4leWxUx7IiLXcNAQB/s5stHmLY41/VQxWCkSimsVJRljxXKX1b7sGcnlz/M+xQYTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660731; c=relaxed/simple;
	bh=lw1PfC34XiuRQo8rJ2JfcyBDVq9vSe8mxHivG94Tves=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qroQLOX8JEiiku8IzhxXsQCpG59ISfPdHHtH6RxC7ulk3SdEhKkS3a5KuMo0ZqPvEcrphMBhXdR7TfBson126wM898Ql0km/aKL93MZwf+L0+HNOO0vbmKzdwJgQUgqUFXDGhpqv8OUcu9dfxXwYJidXxQ7zl7woS7Iz1Wpv2Wk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qlqS5jIh; arc=fail smtp.client-ip=40.107.243.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qlqS5jIh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H1uobGjYXOxcKnghPdF9WF+5LoE1pEsynqekgqh+xnna24m7HgExC4MrrrSn1tJl4G0LjIdDr6/bAURYpuXNuFZoFsw4NXuPEgaQNOw5aa/OUXmIrPwms/ht+CxA5vDqRuaD84I69W2KeV2PVSuylJejbhItHpMMKSPFmSLksKDVnfLYR/HdEViBbyZaBT8dU0GtFaxMA5910y25Th+zAoozgvf8ooURdZMhTh8y0o+EkuljPSwyP1xMaDTwACtmAJbFwdHQwymSIRvTYU/0mWdVVokiFgdKpQhsw1W95HlR7CDrXeWtTcqEv5C9l+yVETZUa7Kp5Dav9tVPjQfSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trWL2/OXd6AQlnIC6J4ngLQ6nZy0BpNwjOREdbxgVHs=;
 b=ubRpKYQCDSJiE+78NzaWV4tHwRJTwiSvaY/CZBl84MEvqfowpX4w1F5KS38jTja1sgS7ELb4YR1HHdRpujPfMmTv32h7sfOrsqN0hlNIaAhwzM2Av/MKTasW5RLYM4ksu9Al66x+gQly/VlOu+UkL9vZVIRBIFf0OXvo3Hth5B+pGK0531BpkAsa7gGwgMCgTgg6C5puWJk9/mrUrA/dy0hXSvuu3Fk0ZhbJzxKQk99zNfIsEPAmXIV7ceoVP8nSsPG2USw/oIFW9m9mnwib8i+apGysJTtOe1bO3sNbyWz4+YKQFnvs/6j4a7xGv/UsHns2nbdQmr0nRlAxt7JoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trWL2/OXd6AQlnIC6J4ngLQ6nZy0BpNwjOREdbxgVHs=;
 b=qlqS5jIh+uXLEaKr8pn10dkBZFIyoEFKyudRY+CFcvp5G1downcVGNFaaCsngKf6cEcg51eeuPbqJtAKUp7vRVQ0nudcoil4W7864lgOEhRnGjUC4RvnLuX7/huvb5hXUHzLcewSgcwh7tU8rJu9FkDfHEr0WPrm/1yvgnG1LNJw87AorIrV+hyRFyj8JdkhW9glmL3+X73ZfNJKd/dA6fPpl+4Lbhdd7zYH1BtCl7zaJxv7Gpt4IskE3c2OLovHXmJrL3kI6pgCj30Vj9AX31dyfXb/GSJF6t0dtllxCM69DbXzIC+ERaKnCvDVndaZsdLB3eDcto8m6H7IlqLNjQ==
Received: from SJ0PR13CA0182.namprd13.prod.outlook.com (2603:10b6:a03:2c3::7)
 by IA1PR12MB6604.namprd12.prod.outlook.com (2603:10b6:208:3a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 16 Jul
 2025 10:12:05 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::ab) by SJ0PR13CA0182.outlook.office365.com
 (2603:10b6:a03:2c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Wed,
 16 Jul 2025 10:12:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:12:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:11:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:11:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:11:41 -0700
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
Subject: Re: [PATCH 5.15 00/78] 5.15.189-rc2 review
In-Reply-To: <20250715163547.992191430@linuxfoundation.org>
References: <20250715163547.992191430@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <04292422-c9fa-4601-816b-47856fd84a31@rnnvmail202.nvidia.com>
Date: Wed, 16 Jul 2025 03:11:41 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|IA1PR12MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: be65093d-55c7-47b9-f5b2-08ddc45136e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVVSU0FPQ0poMFA5T3JmaUlMODFDZmNWOHdMYUpRK0ozYmVYQVpuRHZjU1Fm?=
 =?utf-8?B?b2p6blZtOGJOTktRQUVQdlc5VzNMN3ViSVd5YXYydjZ0blhKUnZBUXRrQUZB?=
 =?utf-8?B?SW1zUXhJOGV0NnVEMXVsYmduSGFNVkdJTjZJQWoxcU1XUGJSOU1RSWF6dFRy?=
 =?utf-8?B?NllsSnN5clFWcTRTa2N4ZC9UM0ZOcXZMenBkS1lidW1CNmdONWtMc1ZIRlJp?=
 =?utf-8?B?a0p0aVg0RVE3VlNtOGE5eEl6bFhhVjJQYjArc2w2bU04aXU2cThQcFlmeXBj?=
 =?utf-8?B?dGI4aFhvWDQ1RG5FY25QN21BcCtQcWtXSGZLQy9PMDMxK0JoRnNncm5sZ2Rr?=
 =?utf-8?B?OUNtY1l2WWFiUFRmZ2xLU0lLdHdhR2xRSkVsY0hVWlkrN2ZqUHkvSFRDMTcv?=
 =?utf-8?B?V0kzbGR4QXhQcUlEMDlTVU5kL2wwVXVYNW5jQ1ZXb1JlQUUzMlJSRno1RGYw?=
 =?utf-8?B?ZENxU2dSNHhIUC9aMFBBc2g4Y2N3MFZZNCthekNPSnBaWjFyWEJlZlZNQk9m?=
 =?utf-8?B?aDlYVUVUU0pQWjJWaytBV2oxS0tSaDhndUdYaGlGazgyOUQ4Zm1OYTlkS1VP?=
 =?utf-8?B?eHRFd3MzMzFqMXZYSlN3NlhOZ2xvN0hiaGRqTHU1UDMwTGF0MktFT1VtbEg0?=
 =?utf-8?B?NGVrNU5tckN4Q3Y1aWRYRUVyMHVLTkJURi9ad1R6WHd3TTliNUE0TlFlU1ow?=
 =?utf-8?B?ZEVWMXJEdTRQc2VBQWR0OXZTeEJSMkRONHdZN1FhQTZwb2lLdi9EWXIxbDRW?=
 =?utf-8?B?Mnh5K1pFSzd3dUhuMHdTdkRvU2xTTCtTRlZuNE9EMVRjRlZoMWUvWDZCSGpI?=
 =?utf-8?B?WEQ0Q0gvM1duTnpmaUhLNFowSEMzN1g5RU1EODEvM2hqcUx0SVFlMzJJMXo1?=
 =?utf-8?B?TW84Yzlqc2RGTXBsZ0lsTmxWekx3KzhnVjVyb0pwTmtZc0orK1lvRVhzZis2?=
 =?utf-8?B?ZlFLaTVjVDB6a0JnUkZtWUQ1eS9QYmM4WDE1amhaWTJOcU4zVkZDWUtQMHFW?=
 =?utf-8?B?YTRhZDZBMEsxV3pscHF1YkNVdHBCN2xoYjN5OGJnaFdaTkFEak8wUjhRREc5?=
 =?utf-8?B?dmdyUm9HMWNGY3RQbUFtRDFBSCtzRjliYnFqTnl5TUcvZGRRR3czdDhyV2gz?=
 =?utf-8?B?eTg3Kzc2M0QrbVc1emtWNTR4c0t2dWFocnJNM3pzODE5TEpSSFNkbW5ReGJn?=
 =?utf-8?B?MkJ3V1k2cHEyWHhvTFg4MnVHVTZPbTlzRFNMV0hJeHBSbUIxblRUVktaSFNG?=
 =?utf-8?B?T1g0V3FHQjJYMnJYcHFqZW5VVkd6MmRzU3kyRGZ2L21iRWdxdUpzQW0xZ1BC?=
 =?utf-8?B?MHFvamhpOVpqQlF6NHNXRU1iYXlLVVVGUEE1cUxla3cyQ1cxdWJEY3JwM0RZ?=
 =?utf-8?B?U01VZ3RmTHNmYzM4aXZFUkZDcUxVRDMzUyt4OFV1WVZ3SmVLTVR6eXdjQzFi?=
 =?utf-8?B?SU1SU3B3clRnbFRDcHdTNXBiTzN0NUtFQXJIOFpkZ1NISUhNWU03SEZLWkRm?=
 =?utf-8?B?NmpMcE8vQ0d0YURLQ3FIV2FVM2VxdDBNeTh4RG9xcHRHZElpZXNVdjI3SWdl?=
 =?utf-8?B?a1lMMnJOTDZsWllPWTlCbXkvT1gyQjh5N3ZQOCtzUFRZM08zVXJGQURlUkdt?=
 =?utf-8?B?aXFVNGFTZGVHNytBazVLT0FwcUxpeXViYWlCY1laYTNYOEh0UW0wYUlta1B5?=
 =?utf-8?B?ek9vT01IWVlUS2ZUV0xjcmQ2NVhCRTJzTHlYSGRFV3RqSWZLMm0rNFpOK0NC?=
 =?utf-8?B?T08wK0EyUWRNaXhuM1lFNW5QNVBZZEgycCtiRWMzaXFLSUFJLy9DeDdkVm51?=
 =?utf-8?B?ZVRQZjZmSW56RE5BTVZQYWJFWWVqRzJnR1J4R0xYMWhkVy9IL2RjK1JtWlRQ?=
 =?utf-8?B?ODlUWXMrNzI3c3FpT2pVWlJ3bWR1b0xmZHpiWTRCNlNOcjl2NTJHVEZCM2M2?=
 =?utf-8?B?U3VKVzlQRWNnWHFoMTFQUEdsb0c3VzdROUxjemg4MS9mQ0Fxa2RwRlpLWjkr?=
 =?utf-8?B?MkFaTnFuRmd2eEl3b0NzSGZaUHBXYVo1enNGeVljdHFvdDFodGN6MXV1K2w0?=
 =?utf-8?B?ZmxoMTdYc2EvTndoc2pNK3lObGU0MHcvcFdqdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:12:04.7350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be65093d-55c7-47b9-f5b2-08ddc45136e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6604

On Tue, 15 Jul 2025 18:36:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.189-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.189-rc2-gd21affcc10e6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
