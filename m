Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766961DEFF7
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929351; cv=fail; b=DuzIg2MU2lX4i/bn+8GRUBA5b4l/yXv3yR97nAN8pt3WeknHAhNJufo2sSz4REv2OKoikQX2f3v1flEDHa6Ca08ZVy4B5P42tEnsCqyXx3BvMFYhMVagMXrc3GQkk9HoXhLkvBRNP7jbtg2+S/dWoy+zS3V/PZotbgKUvBvUKBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929351; c=relaxed/simple;
	bh=F1G/fO6ik5Fcgk7eRn+ApInyGjB0rDMBeWT5j9FU7Xw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=asTR8z6D3jDMc+KJlCT4MCejGVFReI/cvknEchVZUwnDOjsj48qKy6ftsgBr0v4DqklxGhev92guu2IK+ikjbkKhbuRhSqjzgZprYxOOGe04ZZ0cxWgHdPWH4PaFDuh+QAcIqqqFaT0hjpYmlyaJYprseUckCargtszqXszu9E8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gVTyJ2pC; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gVTyJ2pC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzrOmHYklZbgXhAip0zEr8fpIqaHg1HSZRlaP5LN9mldSOnE6/7tLP3BtseKfHSzFKrF92NUHVA/ylBXjLQLtizYRN84V4mFUr0BA0tbbz53M3jd7B+ZncCIaSm2hDYs6shlSKB5gjHrTM7Zn9TuixMTEVhZ33jHl4UYPJzU+GY/cn5AV0oB0PvQlfMRMxZ33qiTKTXWSivLsV95kChcn70V/tcHXWHdILx17kQcSqk8Juo3mWJklRNcuuKWe7WGEInauxF4ajQx7RZOzH9Kuck0zhIhnTNVYEVGaKjiuVFXgIA5jR7VQinJtmk6yTw+NlpplrTSDpRuQtrSWak/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xW/MDL50y2C9mOyx2/OLA/+5rFvTF5Nc9Yt3JIykKyQ=;
 b=KouLLlXf63sfw5zNM8Hc+L2XVr2ObxkjaSN2cczkYYzb/AUUd7ySM/SZpc119DNK20khepVVwZZdg6l4mO8b+PuzNwxSeHSAz8/swQLFpyTw6C9Mmsi3XtFMLqXSLWiZHhlHfTRk3+duu2oXr+tA2VsgwkmMkJKbYsCC5avMJ8byl/mcUa0Am4pO3q0RAfGzYv/I3L+8c0CxblfOF8dAwkEMRXjvpek3/xiFUv/5e7TZBS7kl+5RclrhRzUuwn0axlBlDxCBIRpZO1x6yGUZsnHXzZ6ZNAJjOHLLZHFLdr2JE42VyYiHI/RdvEC3228ucK8UQBQdpbXh1L+sADzpDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW/MDL50y2C9mOyx2/OLA/+5rFvTF5Nc9Yt3JIykKyQ=;
 b=gVTyJ2pCYTy//cA8DMPGxxF5L1yt+UG7KJG7ZW4b0gcL8bH6g36th/As1v8sG/l20LLAlbOe3Tka1hvMSGINmemMkYHr5KSyJ1hdUxuNNGE+5O5U2Irz5UNPpgpD1sPNIjJSG1FfenuS7d9mEAH96/0D6nRaa7usyzh7ZprZxbRpLAXuFtKlOuMZbmpT7/g3qw9wDyAC//6woMlsfqCefupNkt0P61T1ANFjWAZscRwDWRkHPcRVbMsnAWC+I1yH2AVdnpq8+JqPkR+qRR3nyTdEoUoPVzzzT1y+XqxO1RtCf2fnSYKaT5x1WPhCghiMa0eIr3gbqx9cz+Q8k4zDsg==
Received: from BN8PR16CA0036.namprd16.prod.outlook.com (2603:10b6:408:4c::49)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Fri, 7 Feb
 2025 11:55:45 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:408:4c:cafe::6c) by BN8PR16CA0036.outlook.office365.com
 (2603:10b6:408:4c::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Fri,
 7 Feb 2025 11:55:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 7 Feb 2025 11:55:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Feb 2025
 03:55:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Feb
 2025 03:55:30 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Feb 2025 03:55:30 -0800
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
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
References: <20250206160718.019272260@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <94c2252f-f046-456f-abb2-1fafe240787a@rnnvmail202.nvidia.com>
Date: Fri, 7 Feb 2025 03:55:30 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d036513-6b1d-4f60-c24e-08dd476e5af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEZkSnI2cHBlV0ZzUlFpNFB1di9UNGxJekxvR0w3eEJBakZDWC9mREpvV2l2?=
 =?utf-8?B?T0dYOWx1K01rRXNkNWM4UkthdmlVTktCSjVOTlVjRkdoUWEvSCtkZzBlc3pw?=
 =?utf-8?B?enlyT1JOeVhmbW4zMU9xUXZNYmpvZnVIRWFFTHY4SkVyZzFWaDIzaXh1QWc5?=
 =?utf-8?B?WGdZc2E2eWJaWFNOdmhJOE16Si9La2FjVm5XTlFzdDNvTDZONnV5bGZqUlBn?=
 =?utf-8?B?aVFMRWVYTVN3WW4vM3EyRGwwUndnQXRtTFQzOFU1Q1NxcjlMT1ZqVFFDQld0?=
 =?utf-8?B?V3dkK2JlUWNUQkdWa0lYUi9LeWpQSy9Va2FscEN5bGpacEJ4dzNTelRBeFJB?=
 =?utf-8?B?Nm1vRjIwSDRJMUlSZnoxNktrTkp6K3VMdHpoaUg1dkZXdGRucTFrK2Zld1Y4?=
 =?utf-8?B?bUlYTFZwOU9aVVdMSmhTNHBNYTlqU2RnK2ZkMDVOVy9aZ3d0bjdVZnBXT2VF?=
 =?utf-8?B?YkFZSXlNZnRRQnlnQWFRVnlESk1nRWlBTnMyWjgrYzl3VWhmb25MUk1EbkFl?=
 =?utf-8?B?ZnhzM2JvTWdLdmJtNGVEUjhhczk1M3pCdjRsTDVPWlA3T2VmUzQ1Y0xoaXlR?=
 =?utf-8?B?NmZ2TzhyWkUyVE1oU2VxT0lKa1dnU0VRMzJHOUdkWTRxVW5NYnA5U1pXUXNE?=
 =?utf-8?B?c1RTa3RGZ2cxMUNaaiswNER5eHRVdkFzRCtIR0xqRXNnTyszMVFTZkl5S3Yr?=
 =?utf-8?B?MnFrY1RuZGN2RGFGUHZwQS95cVB2dzdYa3VSTC8xYkx1ZVJaREVxbTVCbExI?=
 =?utf-8?B?LzVsenk0OEhFUElVa20vbFlITUd0ZFY5RXVkdTM4OC9MR2E2SDdxaUc2MlJU?=
 =?utf-8?B?NlArVGplSGtHejhFRSswWElWS0pySzl4SkVLKzJJZVNsbWoyZ2h2UERtTlFr?=
 =?utf-8?B?Z0pIMGYrVkR0aUJUYVBhRERVZ0N4dlgwZlMxMlI0aGp6eHFCd015RTlxeUxt?=
 =?utf-8?B?bGczWVFnVmtOUlB3QkpLaSt4bGg5eFpKTitZd2c1MHNBeWVmdjF3WlAxV1pI?=
 =?utf-8?B?SXRjbWVtMW15MTBieVZsQkwrVjBWM2tqb1NBWlJPUGJMNDBUTnVlVXNJcm95?=
 =?utf-8?B?dWpPRDBlTTN3QkFxd1FSRzgxamVCZGMwdVRpbFBNMjJiTjdhTUtxbmlicnU4?=
 =?utf-8?B?VFNsNWNlMk5yeGxTbjV3eUk0bkI4a3NOMFNjcURPMkNjMHZXY05RRzN6WWJP?=
 =?utf-8?B?d1NEMS8zSzdHZWxreXBHWmxGa3A5c2NYUU9DYVBrVUhRSzExQ1pKVURxWWFw?=
 =?utf-8?B?OXhQSk4yTzEwblV5T09jbG5YR2tocWtFWS9RYnArL25nTnlUODYyWTExdUEv?=
 =?utf-8?B?S0dWdmhiQUVGTkJLajk1bTNFa204Z1hJeTZ1bDBrUzk0dXROajlXV2JNaGI2?=
 =?utf-8?B?TDlUbEg3YlhqUk5WSlVSdk5YUjhJSkxzYWdDSDdRSTBueTAyQnpwTG1xRmdU?=
 =?utf-8?B?K1dHamZpMEd1Q0Flc1BvRFc4NjZ2djYzNnhkeEhaSW43ZDBNLzNCT2NKWGFk?=
 =?utf-8?B?M2dBMmQ2c0NtYVFhcUZrWktkUkwyeU8vUlp1MmZWcVhCOU9hU1czWExCZFJy?=
 =?utf-8?B?SE1GWTVjenVnVzMvUmFnRURySVp0dHNPekxCQTZ1b3Z0T3lVTHNIOHlYbzUy?=
 =?utf-8?B?YmVFODlEWTJjbUZEWUFqOWpENE1DZnJvQWxoay9kOVg3U0Z0L3lQRjc4QkVL?=
 =?utf-8?B?Rjc2TXI3UDNOcUhBelJ1VStNa1diTnE5Y1FBcDNlL1g4RDhYQjFDM240bTl0?=
 =?utf-8?B?Y2tTR3NqZUFxR2ZFcTlEczlrSFpzekpuTXNiWEZXZHZzOFNaNFF5Rlg2STJP?=
 =?utf-8?B?SGJJVlVvenVZQVZXNXBsek5RTGJpNXY0SzdUcFRRMWhabkY2R01qazUxK0tv?=
 =?utf-8?B?UThVNW5ETVQ0NU95VjNvTUdiMitJb2x5MTdJaUpCTUlLeVR0QmpTT3BXRVI5?=
 =?utf-8?B?R25PQmFONHNRUWcyL2lYTWxHWWtSTVh2V3l3NmJMZWZYUU1uRGF4WmlYL0NE?=
 =?utf-8?Q?3i5FvpfFMsCJua3fQYzBYcn0PTfzgQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 11:55:45.2739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d036513-6b1d-4f60-c24e-08dd476e5af9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860

On Thu, 06 Feb 2025 17:11:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.2-rc2-gc541e7f2b5c7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
