Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC255263C8A
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755698866; cv=fail; b=PUFDGlZ/9xQaUNrfgkNarOQXPe9asStWRONEcPH46vbmsx7SGyt+feyCsRLb2taf7GMzzvmDBEHEQZwN3yP/3PxjHpasC7Om9X8n2/Y+zgMYFrp/tQYF05GtK3MCdKL/PXk7kEryrwPAHTlqp0YawzsHPVxwnpbIvZU+/ws24gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755698866; c=relaxed/simple;
	bh=QC66dz35DBnuIMhS4BwA/Crh43LxkqBFOETTNMvVg7o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=mL/+7atVPO2Mq6hhhM8M89rlVWUD69IB+DdEa7EATjNsaEQjTujHpRQK/QiSXEIhkaoRUiDPczVbp8KwPQiP8AEspraLV7lg6n3wln7mHnG+Jh2YInwjctmexxOQ/i+tEAcaB6vvKe85TxihEAoV/69hpoi9t1kH2eL7cr/Yxyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=byqtjvap; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="byqtjvap"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9IGlBAluANHnArlA83LEbZpvWMJwjb8Lg+eVQGeIZiEexoiPQoL1un+T9pohKB7n8umjzK/h9Vr9JwL4EnA20JqioiRFDkCPO32qwDjaWbu1KHfezr1/ehLeDaULX1eFFd4M/y5bdUFKO1FIW8DGbToHSDTG1PMHcWvnANXJYJsRkjfe3rq40THX/WIFVBtzL6aLfKchwHR656PpJe2NUySQk/5SYnw9KAp5pzlQ6g1+/lfXLf6VwbGzcVe8810ICV1JseluzpEe05tU1YgSXo3W6UC6gy45Q7ES4MujH/7ph2SjnpTLY50dgnZH1fvcf8pSnz5DNxMo6tz3eNozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAUA7FRbbyoWwKR0dHDQ7JCRX+8xlSzubBdZ6XrA5Kg=;
 b=tEqtZ8hFSBgL4YQasR1XzHR/QGJdxGmGQmzy51NHB2af7+gtGihHKJC92LhVpcFfrcRB1vlqTP+/XCQXt/gxQkTq/wsSqEAN8u6u0H3wiQaDjPqWl3LNfgVhaQTy4BOvcMEJQwwR0aJuFTieC9cuVAUbpC9FcFedJPF/SpYQ7PHpD2CCuRIgIluOsSrzDW/cWBBexRWearWx9GjxU/Aj4XFuZWh8YIQZQuY/M1wy8N4PWnqVbNNM4rk4sTmJ8jW1D+kp5Stg6wyX6gE0R/bQlQjNfhR3hGLzYtpqBMeFqHfLpLwGxljnFAvXhF4k+Iou+rz7rg+gHnnCSp5Plfr37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAUA7FRbbyoWwKR0dHDQ7JCRX+8xlSzubBdZ6XrA5Kg=;
 b=byqtjvapaZEqVP3m2cufBpjF5EbURLQw4eFYPbSvJy85zbGALs4JLtvs5Sqmikcz4qPXnnIOsaedfgzgKaMu+2VFyNhk4qIDBsh7NnUj1JbbhTcgtDJDqGm7KifFeqz0RS9KOHl1UU5Dzi9oC7gsdv/jb5teH3iF6CAoEdUjYoy9n4Y36SP434unsuDFZwQDseW6XTDEhliThufEvd2xyw7GqpXGUEysQP/MqbVEkVZuIt452IPsZtSh6pWBSOLfP01PpINuGi3c6LmPzCfh8rCFFidSemEZgQl58mBY7BwsCw/TrR+WxhmuqCrc6olG3sL0bxZMAYDYInQTuWln4Q==
Received: from BYAPR02CA0027.namprd02.prod.outlook.com (2603:10b6:a02:ee::40)
 by CH3PR12MB9282.namprd12.prod.outlook.com (2603:10b6:610:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 14:07:39 +0000
Received: from SJ1PEPF00002310.namprd03.prod.outlook.com
 (2603:10b6:a02:ee:cafe::69) by BYAPR02CA0027.outlook.office365.com
 (2603:10b6:a02:ee::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.14 via Frontend Transport; Wed,
 20 Aug 2025 14:07:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002310.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:07:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 07:07:15 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 07:07:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 20 Aug 2025 07:07:14 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f9aa411b-c485-4d4a-b7cd-10e64fd42089@rnnvmail203.nvidia.com>
Date: Wed, 20 Aug 2025 07:07:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002310:EE_|CH3PR12MB9282:EE_
X-MS-Office365-Filtering-Correlation-Id: 62e3e8b8-3722-46c6-46e7-08dddff2ebe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1RtcHpqWGp1N0hzZHM0QU9STk5wNE5zSHVya3B4RE9YZWNkT0xHK0ZSUjVq?=
 =?utf-8?B?eXc3Q0IvZVJ0bDZqVnVMK0NJbVNKRVJYNVZGMXp4dVJRdnJaZ3hqVHBuRmVL?=
 =?utf-8?B?VmY0VVVQdjM5U3l3NkxvcnVQdm5IY2RQV2FxMERQclp4Y0VCTzdQdHVhbldN?=
 =?utf-8?B?em9vdzd1Ulc2bTBBcjlnU1lPYWg1c05jSmtMblZBVWJCZ085VTQ3Z09vWkxu?=
 =?utf-8?B?aUpHWG80RDFNcnJFcVJtYWt2U1N4V0twTk5EeDRZWEtjY3JlY1hJSjVnc0ox?=
 =?utf-8?B?YjNQVEhPNXZkTEdac0RjNjZvZmJMeVZEdUtFemVhOGw3d0hGUXJOMFoxaGs1?=
 =?utf-8?B?TjF3cnRpbDZLaDIrUkwxK3hTcmxXMGNHQzVTRjlobkZ3dkFBZ0NTVjZLN1dN?=
 =?utf-8?B?TkQrdERlUHJkdm0zWTRlbmJCby92a2FQWHJnL1F0SFI1dVUzRUV3cUR2cFl0?=
 =?utf-8?B?c0ZqeDUvdnBqbE5WTHBqVmMzZUZhMHZWWndqZ3NDT3lVT3RkSm1Mc3EyMmFY?=
 =?utf-8?B?Z2g0dldJWTE4ZUJYOTVEaGoxRzZpK0Nab3NjaitjOFErdEcwZGFyY3VJc1dS?=
 =?utf-8?B?T1ViRmNid0lhbEkvQWc1Tk93Q3JZdWJ5b213WUFuNTV0dDlCWkhEQjlnaG9p?=
 =?utf-8?B?bGM0ZzBsdjljNEtjNVdMWVg4T2Z1MGFvUzZlekNPTVZxNTlWQnZIMEhsYUpE?=
 =?utf-8?B?RThNSlJWaUdWSkRjcnhjc3FFT0FaTTZMV2kycU5pSzh4MC9BUU45N2pidWZj?=
 =?utf-8?B?NDdIU3hSRmIvSmhQemdhTlNaS1pXbGRoNUo0TENBem5rWXo2QUVZMk1EMElJ?=
 =?utf-8?B?NW0rZnVUTHlBM2JxWWJQd2c2MG9uU2NWUllZN01KcmNGdzlHVFNsdThERXd6?=
 =?utf-8?B?QUFVMEI2WUFHc1VpUS9lckM4WjJYUFY0TjhpMDBzc0ZNZ3NTUlhOYURvZDlt?=
 =?utf-8?B?QkhjdDdzSTJaUitJd1pBZVJrN1RVbVQrWDJUNHJVeEkwVFoydFl5TnRxWWlo?=
 =?utf-8?B?MHdZdU5PL1hIVVlENVZoYkhvaHFnMW00UmM5cFhCYUNzaTZYNHRXZmJYeGhN?=
 =?utf-8?B?bGg1b0dyUkhDYzEyZWtDQnl2RnhMYXkxeXIzMHk4Z3pXbWJYNFVUZXhuTDhm?=
 =?utf-8?B?dGVIQlZBYnRKbUJMWk1Fb08xSGlrNVlIU240Y0hNcy9aeVFrSnN2MHQrbUxp?=
 =?utf-8?B?RGZqQndhNitucm1odVJUclRWTnRnVGJsNVJHZGpMakVJdEYxMDZZdFhrYXhJ?=
 =?utf-8?B?WS9vaHpLOHZJZVJVMXFMYllhUFBtSlViUUlEZ3FQUTdlVkFBZ0ZJank4R2VS?=
 =?utf-8?B?d0hDZDlhK2dvR3F6YXVQWlI5K1VTNkZzV1lnanFPYmVBYmhYcWh2dVdCT3Zj?=
 =?utf-8?B?Sk9XOXV6L1VuNWhsU3ZlbVFjZXpzb3FIalBxamxiYmF3QlEzMmdZZDNQVFIz?=
 =?utf-8?B?OHNDK3VPSjlsSEdiWlJVZmhYWkorUG8vQ1d1TkhoL3RVMjJhTVQ3UDBoQXlY?=
 =?utf-8?B?VVpIRHlxakcvTURzRU9yaTJNNkgybW9neWlJNTV3NnIxUzY0MUU0M1lSSkFP?=
 =?utf-8?B?bXJIdWpGa0pQNFJ0RnBNczhobkkyM1pRbURySGRkak1DSEdOMFB0UDlKVnEw?=
 =?utf-8?B?d2s0VGV4NXhSNFZxNFcwTGd4Smc4SVB6NHhCblplTjlsNkN4Yi84dW5QS2ZN?=
 =?utf-8?B?TGVqZk5hV25kb2dhOTRTZnQrb0RmcjVvdjc1TE1wR0tDdkpKUFlYb0dvOHBv?=
 =?utf-8?B?VklkS0gxVW4wU29ac3pnclRTL0FsWlZUeUZJNmpITjVLUm0raTFFak5xVFlG?=
 =?utf-8?B?VEN3RWJ1S0c2dGpjd0xPNUozRDFHV1hLOS8rYVlOYi9pVXBaNWtjditIb1p1?=
 =?utf-8?B?OW5xWHZMUVVERTVuNTdJdVVCSTN6amR3MXhUa3N6RThzbWlNRVk4Z3NLQmc1?=
 =?utf-8?B?UXZ2SUVMbTltZE4ySVZOZm5mOFhwd3FHeVRZemdocUlQNE1PMEdiQkllaWd2?=
 =?utf-8?B?YklhZURjOHQwenM2ak9RL1VxUEt6UWgvRVEyamZYVkFoNEtKdCs5dVhKSzJq?=
 =?utf-8?B?cjBqaWZ2NHA5WDEyM2dtckNXKzJSMzBpMWt5QT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:07:38.8674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e3e8b8-3722-46c6-46e7-08dddff2ebe9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002310.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9282

On Mon, 18 Aug 2025 14:39:46 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 515 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.11-rc1-g1cf711608500
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
