Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D5128D82D
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030026; cv=fail; b=YfxMVAV1E1jPBM1lui2zXBSdP0BexDbONi38gYyRrxAPqtKNKH5NWhGa6KBkI4Eo6trSyCkd++lt5D1PE9PxpEwnH8uOrRuHQAQPM82tsA7W95OEQpCHj9X+VTUyXJXdMsbsOBUyV5xGzgKIOzRMJI9h7fKbo1mnsPPvIIOHK1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030026; c=relaxed/simple;
	bh=bF282Sm3QeVPOhQ2PRTwEnm9Kuppu1b2OZ+tZSfOqL4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aljimwyYuAL0/vWzPh1jfWh5GZFqGXl8hbOyD6k8/eEm4q9wSX7W0eaaUlZF0vwlamhDGEzmmscbQLmN+bWVy+mOT/pe2v3s6GqMPEhwCe5ZKqTBuE+i1FFZbpBspyV80JCBT+0XPJHW3AaCCnmhk/R5E1FP1iFMj199BDiS0w4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XnU5wmgf; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XnU5wmgf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQ25bLockpTqkBfTncVK45oNF4/PMqYixBSpL7sEg+0QIcfC8XkGukIrfj/AJpGfjRbPoT99CY+CXTKEur7cTDm1+zQBH+GmqkSjDgY+VITp1hM+wuKeiZX6030c5W2stn6XkAWj7SQxloGkoA48gowx711A68SJ0ZGEIJa7RkyiwIZm+kWthXzli19reJUcCw449oEtXCiOUfFkBD7JdcPMuDCM0jzddquF5ZNjOBBYPHDOg90C8cLHVGqFeiX0EugOYyVpq3fqv/Z4G7Lo2IxrTgeruRXobnmOXg870M+8PrKDkbNJd9kskI3kELvMWy7tQzBt+mYrtMJaFfnQTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qte4hbuiSpO+PHhzWwbW7+hX2TGq1Z5YVG1L8fcj5FE=;
 b=sHUrxNSs/Y3gygiM+OscPKnWG0EJxop9a+ewHuEFAM7bSVd0+BciMZ0/pzKPamdI91/THLckHoH9YGMZQ1LPOv+yobIKmD3sl5yzwWiDnJEjQu8JW17fk3/91jKtwrxHG/BUNX2qfvquK0HLomuupkSOZDPdCbtGyvy74rawC7X4Fxs1dwrh/7jyLg902WAHUKWxsKOsfUn0I4EbdS2gZzaz8HXxIFNggxcBXu2q54wqOYslCrQv37rT23b8jUqjk/NFDHk9Xu+oQE+yCStjMW+FgLNkPGnsocpTw37w8JoP+YzSQ8lWliV3mpwIe6uYrBc0jOzu8XfdGsR8PeMDtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qte4hbuiSpO+PHhzWwbW7+hX2TGq1Z5YVG1L8fcj5FE=;
 b=XnU5wmgfIBhFUGEF1d2NN2EWx0scxhOjfkC6J+c52J/gs6nQx01+dkIjJfRG250a+nfecgU3QzrgY2r4gcQq+3LhFX+cin0uo2xL7e1OzpPtR8Bu4wBpMGr9gwVoen7PyvvU1D6laJsBoUiMcta2RERh5cYH96rPj6tJx1D4DEUgMFsqMYtVHt1taFhMTKHIEcytqsbW3LO2nXPX+IjqXBJZmPiUCZlFUhJw7RvRQmCQ8Qn7CP1q3+IsyjI4BHLfceYfX1H9Nl/xkilb0xOOnYucDrt+j/5aUbbH/0DNWagRq9FWOpInACtXGuXsmJ/FTY7ku7la7Q2pWD0fjyAR4Q==
Received: from SJ0PR05CA0204.namprd05.prod.outlook.com (2603:10b6:a03:330::29)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Wed, 4 Jun
 2025 09:40:19 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::53) by SJ0PR05CA0204.outlook.office365.com
 (2603:10b6:a03:330::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.23 via Frontend Transport; Wed,
 4 Jun 2025 09:40:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:40:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:03 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:40:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:02 -0700
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
Subject: Re: [PATCH 5.4 000/204] 5.4.294-rc1 review
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9550e42f-473a-4fae-8ee2-506c261f6bcf@rnnvmail203.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:02 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d2ce919-3ea4-4555-4a8c-08dda34bd162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THpwRVJHRk02TktoVFNaVnhaTFZYb3RMRXpTeTVUckFtVENwUjJtWlRmOUxn?=
 =?utf-8?B?R1VZV2ZWc2J4cVI5dndEdFFGMjhVVkE4eEhzVS94QlRSMlArZVVwV2lNNXJ0?=
 =?utf-8?B?ZklmWmZ2Z3FhMVB2djFCS1FQRjd4TWdzWkNweHdhY0l5aTJiNlhLbFpZUlVw?=
 =?utf-8?B?YkdJVldjMnZCVVRXaE9aY3VyY0VtaWpuenBuNU9UL1pncCtsRWNObWtFQ1Q5?=
 =?utf-8?B?OG5xc0lvQzA0KzhPL3lKTG5vQURTR3lDcVVrTHUvMElYL0lOYTE5cEhyNmxH?=
 =?utf-8?B?dS9DY1VyTTZTeDlTckVQQzk0RzRFMU5sL2VkYVRQeE1GOTFoZmFCZ2pYU2Va?=
 =?utf-8?B?dlAwTFFkcjNWVUZTMDVyZGozUldCSjIzL0lGOUk1ZERpMDc1UjgrK2g3QkVN?=
 =?utf-8?B?djZad3pMMitLZlN5b1hhNWlNKzc3OCtPbTdPODVzZW9Bblg4SmMzeEJlL2F1?=
 =?utf-8?B?UUJsb3Rza2x1elplMVhRdXJ3VnAvc0E2aWdtcWNjaUdVN1B3bmVHVkFsYnJR?=
 =?utf-8?B?QmNpUzQwRmNJUkFJU0J4b1p4TDJOZ2RjRnRjRFBZZEtlbFZRS3BNMlFKM3Ax?=
 =?utf-8?B?aUFzelE0SHIydTFzM1FtWHh3a3pvTXRXWmVIR21pK051MmFyd3cxTnhXOEpH?=
 =?utf-8?B?Q0EyMzFJb0h0OUd6djMrM01XcGRqYzQzSXNRRi9zdXVIbWEwYndnRDNaN0pW?=
 =?utf-8?B?TU5RMjFBWDNzY3ZEWmZYUE9QSEw3V2hNRHl2MnBsQWZEeElLYlp5MG1xbkY4?=
 =?utf-8?B?aDZLanZwM0l2alFxdThsTEJRblZMaUJ5eXhlVlBLQ2E2WTRQRHhqZitiQTlu?=
 =?utf-8?B?ZlpEUjZ1Unh4V1IrRVNiS29taHVWUEN2S1lhM09EbzZ0M2hWRGdIejFYSjJy?=
 =?utf-8?B?bjhwOE04b1NJY0s5L3AxYXArdDBXMEhkbENla3VqcDRKbTZUUHQxSWt2T2Nr?=
 =?utf-8?B?Y3haMlBnTXpSUVIyd1ZBcDVTSjAwUmtQVXQ4bDVQa2NpWFl0K2lqSDJ1RGFO?=
 =?utf-8?B?VWNvWVZmQnMrNTRoU1JPV0tuZFdWUkhNZjdndzlWMkZyRGs5bG1URVNEMlRG?=
 =?utf-8?B?eGM5SURxdmFydlNFZDFBRlNIN2NVNndVdkR3dTN0TGtGUXdoejdQV1FYRW82?=
 =?utf-8?B?NnA0T3JpMGErZ3h5SXZoSHZLcVRRSHZEY3hmSmZzN3hMR1hZdWtIcGJrKzVs?=
 =?utf-8?B?YzlPRlFVWkFvdnFjd0wycnZkWnRWMVE2eG5idmhRUlArdk5xcGNLendWVzha?=
 =?utf-8?B?bnRsTTA0cFlsN2F3NmFnNUtkQTlkcm5tK1lxQW90VXNQTjZMWXdkQ1FuR3BK?=
 =?utf-8?B?U1h1Q3I1NnpCRGx1ZlhNR1RmeWdLVHBLUTBEd2VxVW5GMFd0Y0ZOZndmaStB?=
 =?utf-8?B?MS9mSVF0Z3hIQ1k3cWdjSm8ySGhLMExmNGdvOHdsNzVqK3VHNFhram54QjA2?=
 =?utf-8?B?aCtKeUdmZHUrZEJnVG1kMzJmOEtSak9rTVNaTit2cmZkQmdkMktXb3dmSi9l?=
 =?utf-8?B?OFcxNHJ2Wi9KM0Fxc1cxS1grcUNtQmVjcWUvUHh1RTdieVo4YU1FVnhHb1R4?=
 =?utf-8?B?Z0MxU0lkN3UyZFpOcWNKK0hCK1E4aE8yOFcxNjZsYldMVmZTMFQ2eWI1QVJo?=
 =?utf-8?B?TzhoTlpsYTZxakpaWW5YeFBjL2FvT0xLWnNBVVVQdUx5eEdtU2lhMkR4QkJl?=
 =?utf-8?B?MklqcW0xWFdhUnpwaHBtbllYU3F2V2tGQWs4K0QyZisvMGNkcXZscksrd0J3?=
 =?utf-8?B?TllXNHRCS05qalBQZnVENk9rSFhyeXR5ZHlaSmlNajgxKytyWjEvTDBLbzhX?=
 =?utf-8?B?elFpZ1p3bmx1TFBZU1pXVjU4TVZ6R2g2aCthK3BCaXJMUVJqdHpMMldkTWIz?=
 =?utf-8?B?UUhGYzdRU1NFaHZrYzh5Rk5TRGkvcERQc3hCODlJYVk4NGYxN054cC9NMnVJ?=
 =?utf-8?B?L0gvYjdEaTlRRnJEeW93MnNQbnZvOHZlVnJUeGR1Z3l0VWlyRzhERUJHcnR5?=
 =?utf-8?B?Y2VxcmxYdzBIL2lDUGQrK2VuNVFLd2Z2aGFzSUUwNDdqUUI5VHJtVlZ5a1NU?=
 =?utf-8?B?V2lrUkp6VXdJU1VGN2ZpdnkyRHQwUHd2WWdndz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:40:18.6856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2ce919-3ea4-4555-4a8c-08dda34bd162
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426

On Mon, 02 Jun 2025 15:45:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.294 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.294-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.294-rc1-gdbf9e583326d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
