Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055CB283691
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286921; cv=fail; b=gOz61mke0eaBpkgQw1+FrVdCVxvS42ElS+47LhNejEsvT1iZQYeABWT0NLXsH/IYiKYHbw71kTrmhag+Mlro4pu2dG0SjdDtIPukWe68FZ0Ra5BBfxbCAqMj07Bqxtd0qEQXDUln66rOtle/apO31H+bxAeGD6JAnx8Lco+plMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286921; c=relaxed/simple;
	bh=mkNqqQ4VhHkUfhAmInPz/Ui2gCfASQ3LPz6EOAsUZd4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sBLJI+K//M4beJCXeiViNiBclMR5h/yvPd+eQPZV9m4Zge2/wU9PMFynHbCzaR3GlQJzyITqQHT9V9kWhKPpmb9Dx6S/nq89LegwPq39wiQ46fl4tLlrTzJCwE+rTIbPnd7lQJcEH02JYvawmASMTWjDDn0Gjw+fsPLSlYy43yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eLY05ERx; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eLY05ERx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UURGQfRiGuKZaQvWRj7uP/ihRMjYQseejIErAZ1xbJKeVMhgJoJFZcseem9oMUKJtcM9VGqt/AuGBmUG7iD5upT3sBGUF3Pkiol+ywRX2DsdAwFc5a2rj3zYNIYz5MlR2kgL2NtaXdN7ESHvOwZ5fNV0c5A/uVc2Hh3PenzU1IyG0VZRHfBwgBS+DTcpYg4sIGzIZACwo6CDSedl8YV5WigVK5rPC3ZYcnJ8cEU4RESIpxsxQ0oK5fn8muPaXXiwsFnqlFSRGDCw7Dd9EnZglP4/0aFofVcqMzPuBeGHjuVeNxdPhzUVN68huKH67+U6Yhg+kqvgcXcHN1ItvNg9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRnroBSgvS4uDswFwOPORcI22NolYnH5lrZg+cywVsI=;
 b=QMw5E6knnq3TdTSga1Gc05h6Bl9Z6Pwd26cJhxWH4jjw3qrkmO3iIljSygnuL18weLSo94IPNIYgtSJueZdPyTl/D6dk22st5M2P3pgOCCI4LOZjpIPbvpH5PdxMJYI/UYgQicfnv4gqK5lkNEqt+ybUFNQA9Pzt16E9xbIxuzjqVrx3Xr6LTQrN1JuoWcFjWUSXsG9hfRgux5whXCBmSMZlz0yoDfB4jNb8EvYy+IP5jNNj+P1RLKwGPk7vpIEBzz4w2n2fbgJiYReBYnU1Hv8NHG/R9MHMT4bRANgdFGNlIAUPZzIRdfj2a3bZu8WfYIhOkhBVewPxI4GxGBMh3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRnroBSgvS4uDswFwOPORcI22NolYnH5lrZg+cywVsI=;
 b=eLY05ERxgPG+bEeeFbYgxDsJgV62ELCaI3KR2yCKeoYxP8EHjdcn2rxfmv79VdLaOoZ4HFuMTCidXStUEv+Pp76dLNvCFdpmQCsKU7d65774cUA0LWvB6qhZ6/OE130xx5LflwmYSYdWQHBa51N7KzixSstMmsUb2eiqYAxl4R1j1j9w1T4RAKgSjaDECxbS8MXlwROOvAa76CXsFJo06jekFvNzoQP2/Yw23e/fsoVXWqaJpOo3bsy1hoBlFXKXscFQ9b5h90p9IVHH/zeR1tgxrTf69cMWlbLv4NmU1BdUMzppBl/vsArUpiFLFYrO9E55Ay0p75F9z8MbmLJYjw==
Received: from BY5PR13CA0021.namprd13.prod.outlook.com (2603:10b6:a03:180::34)
 by DS0PR12MB7679.namprd12.prod.outlook.com (2603:10b6:8:134::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 12:08:28 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:180:cafe::da) by BY5PR13CA0021.outlook.office365.com
 (2603:10b6:a03:180::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.19 via Frontend Transport; Thu,
 10 Apr 2025 12:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:08:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:08:14 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 10 Apr
 2025 05:08:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:08:13 -0700
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
Subject: Re: [PATCH 6.6 000/269] 6.6.87-rc2 review
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
References: <20250409115840.028123334@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <103b2b7a-5319-425f-a972-58236dcd7bd0@rnnvmail204.nvidia.com>
Date: Thu, 10 Apr 2025 05:08:13 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|DS0PR12MB7679:EE_
X-MS-Office365-Filtering-Correlation-Id: b14cb5de-0d9b-426b-17e0-08dd7828675c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHlNd2dTODZDWlZFR3hWUG9scHl3L2gyNFBlYlRBRE1CM1JONWNmd2tSV0pF?=
 =?utf-8?B?VUNGNGZTaFM1S0dpMDJoTUE3aXBqaDNsaHVSMnhFSzNxZUtpRWxLMlJCWHVX?=
 =?utf-8?B?K2I2ekEyNjUyUzAyYVQvWXZxNFZYMU5sV0c5M0RhRnVDZS8vR3RiZjFlcVdo?=
 =?utf-8?B?SWdxU3g2REk5cUNmYzJlWThxcHZyd1pqUE5ubE9zQjNMM0tNdTYyMXhvNkNp?=
 =?utf-8?B?NW9yOTBWR0UzU1hMOExjTTNGdFNoRDBuSzE5Q3M5ZnR5UkFqdGZJemk0ODZD?=
 =?utf-8?B?Y3lLTWNRditXVW8xNUlNQmZLMWtiY0dja3JTL2NicUY3eDJHbDNSbVdiWlBi?=
 =?utf-8?B?MUZPVnlGNkVvU0lWOFRkUGR4ODNQelJjbWdvaVJDMWxtUEFVdHNhUDBWUWRT?=
 =?utf-8?B?Sk1sbjE0S0svVUF6aWxtaEpHTTZ5dnhXUGw0VFBiZC92bDNkRnN3UUlnSlVM?=
 =?utf-8?B?dEVvaEhiK0FvMENsbXYxR1BxTForMUpoTmhUNk0wZ0tXYUtXWURJMmN3N1Vv?=
 =?utf-8?B?WWh3MGhMdkhySVpEYnU4Y1ZEbk04eTZrSktLUEJ6VEdxMXVPL1ZWVnNTVkZX?=
 =?utf-8?B?UEdkT24xMkVhNXdlK01MbHlqbm00U2RkYUdQU0s5YVlhdDRiVTNSQ3VJM0pa?=
 =?utf-8?B?ZVJQREwzdXFIcnBKREVFQjk3MkRsODhjQjJxcW9ITHpzdVVXYkFobTZKOFNz?=
 =?utf-8?B?cXl3b0hzRmpRbXdtNTBOaEFpQ2JSQWF5UkVIdElVKzNSblRTa0kwelhvQU5P?=
 =?utf-8?B?aU1GUWVqV2tHakx5YXV6d1pIb252eXdKSlNuUUZrdGV6djhXYWJFckNNeUJP?=
 =?utf-8?B?dDlVdVFOSjRxVWEzRjdxVHEza0pDbzZWSXJSbCs3UEU3bngwMlF0aFZnOU93?=
 =?utf-8?B?UFJSUEpWY3NpOVl0VE1YRGJLbFNndFBEbFcyd2hrSkpuVldxcElWbjRnRHRi?=
 =?utf-8?B?bkR0WlpxNGxCeC9wTDhzTk9NclltUFZOVng4WUxTSFY3dFZDUkVvOHl1RWlZ?=
 =?utf-8?B?TGVneDY5YWNOVjJZQkMzaHhTTGVUd21TRjE4QnhsbytOaHJ2TVkvWUtwb0do?=
 =?utf-8?B?SjlyYXcvMFp6WGFnSk05VkIzL00yM1VObktZWCt6V2h1YkFIVkNhUDF0Smt4?=
 =?utf-8?B?eS81V2xodnZkQWdvMzBkSVQvbHF2TGliY0xHQUZBMmgzeXJNTVNCM2ZCLzN4?=
 =?utf-8?B?MHppZ016WUFya1RUQUN4Sis0YUhLdElRUjhyL05id01hWjZqWklYZGtwTWJv?=
 =?utf-8?B?cjFGb1dBaFk5Z0pQRW42ZDdBb2xKdWdkbnhsb3piTlZWQ1o0WjNvcE5nMEc3?=
 =?utf-8?B?WjdzVlJ2MWVZbzVjSzR1Rk42QUlWU1IwcTdQdVBrQ2UxR3hvUi9lWE41a1lx?=
 =?utf-8?B?aThXSHBZT3k2MXJwMlRiSDY4Q3R6Q0ZKVlBqRU9xUi83Z1VCU0Nja0NMQmFP?=
 =?utf-8?B?T0VvV0Y0YUxoQ2FPd1dmcFJTQU9BR3AzNDR3ekZTZDlsYk5HMWxzSkJjNmRv?=
 =?utf-8?B?R3dkWlAxOGJ2RWJDMldPSmQ4K1ZpSmllUkdsVCtUUVNleWlHd01sY2diNDVu?=
 =?utf-8?B?WWJLa25zdUErWDRaK3U1OUdhV2xGY2FFeHhJWU1NV2ZIZE8vSXJpVWwzODI0?=
 =?utf-8?B?MHQ1UWNwVUVQNHBCalJiNmlISXZlL2hxSEhzam5ybGV6K1RlNk9IUmhnQ0lI?=
 =?utf-8?B?cGdZK2xpcjZhdTJNQlVKb1p6T3BlWC9SVUZlS2RyRC9mLzVNSHg2UktzbCtW?=
 =?utf-8?B?QnQzdjM1QTltcXk4Tjk1QXZWYnN6NVF5OFo2M1lDUS9uUTJhaDFQOENtUWNV?=
 =?utf-8?B?SlRvN1lMM2FxQ0FCYy9kMTREWG5WV3V0cVlNL0Z2ZU1BUWprZ0xBcXVDN01l?=
 =?utf-8?B?QUtobHROU3NjUko0RytxcUtDNUFTbU4yZS9RSzZWVENmV0V0SHpQNXpxTkhF?=
 =?utf-8?B?dldweng3bkdFSkxRSWl1WnlCeS9pbGlBTHdQdW1MS0tUU3F3VnlKdTZyUFZz?=
 =?utf-8?Q?UfQMHyyHvq5lVkqQo0QZB7jAnVvrAI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:08:28.3498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b14cb5de-0d9b-426b-17e0-08dd7828675c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7679

On Wed, 09 Apr 2025 14:02:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.87-rc2.gz
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

Linux version:	6.6.87-rc2-g327efcc6dcd0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
