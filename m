Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E52253956
	for <patches@lists.linux.dev>; Mon,  9 Jun 2025 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749473340; cv=fail; b=fZ/bTNDlz+/jzbn9CpFbF362nBoEpBFjVT+ejGE/hrHNfKMYFfxIG1YHMkmUSG9ePWFRzkY8A+D5ncJR9YrzGwvV3+c20xBUpvXnsbqmn+FVDvupubfEkpuwbtIAaMnI9gBJM2ve+Ztqdxobxgpmz+TeXdG7XZc+HXMolgLcrc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749473340; c=relaxed/simple;
	bh=l8nYKVyjG14+XuU/mqvsNVAvubwZ/MBdAPI3EsWS3vE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=m/W5cT0O8rXfo+oH7M/J1OuJLQTxc3LPqXDkMxLBXiNZIlftok+8YOy6dnEOgiSnDp0n7I72iuOm3rBIh/H6Kb5aoEdFzAjft7R9jRo7UMQdZ/KNUAsV+EbHScSNn3yz6T/H+U1ED4LkyUEC0yuOJ6V9sWKz2ty+D+AH+iY2Ggk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f96cVBWt; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f96cVBWt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XM0XWfoEoGmKhN6zLtBZrwO3iqyRZoQPVDTO1y38I4H1ICxffyt7gOPVFuKsj4yctt+OfM4sRCdTgTfpDGIL7ODpWQdKU644hAQLM6gVnFzdacq9CeOtoTtGp9rSLPI9sadnnmkJtz30OwSB5rD706zxsVT26unoAmc9NAUUn07AAJetHTXRUJbSiqedeAJnnqJuH8K4xVG0Ws9u4h+Na5LevbuTSkEh5bE0YphPRyyiRQgafq9c/sD84FnLtyFQuTWJwfSAXb615hP4ANEnE8650mHPyKKhx3/Euap03oAZdlT5dBB2nyr+3pmcxFOVuoHstP95KzBttTPdh0BcZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aaai0z5HGxwzYMPXjINyfQ4EZ0COXAqrQ98S8Usi4uE=;
 b=iwzzU2PAoV5tad0DoCbgdUR0LXhofjcLxYdm3GXoMx9/25sYrw/aRmfdnyNlqK2jI+0YSe6d5wYM+yxVcfEJ9phWoosYNVKPwvIm2ioANrPp3HiMnFOi+fIUlAfOQ+8c/n3+3C+JZllRSsvivh01UMmTkyN92oWjp5QufcB7jLAVJHFU39fKri70haurrxzfAR18d8J4/1leDKBHo/GCiiRCiUIZHKo7uFSxzNKVXx/6HpM4B90WCaI5M7RlWH3usXwbo2txOQUmUijpsMhVY2PQJNXvEzp44smOtDjiop5qnn2e4oh/dfPdRyTpzx2VPzjk3tKzysll/vid61wefg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aaai0z5HGxwzYMPXjINyfQ4EZ0COXAqrQ98S8Usi4uE=;
 b=f96cVBWt6hi5eZWAkM/Hmb/ti5myP0LNJ0LzhSO2W+bdlbAYvjwtavMwzB6MkbkWWpnjUq2wbxxImEFGWvsp4DNe0QE5U5pnNx6EAZPCLbwFzeQMpcS7maWAd9MrD7aDr5R1464JW7Di+qoJPnJTqA4OJ/6nUhrtt9nnfvQTD5J+4sHZfo0oyeZK0H09D7aEE1uImwMsNNJIEKPYaSMzglrxPGMENIK6MU1Fv+8yVaCaoEoqWKErBxYlZB3kj7hoxUvn2fpCnv2EXnBSQg2zd3uGgRyI2Qi2FlnUHwEjf6z5GmjBbL38j92SJB+LVv7GdOo9fHtrl11FdC0V/gOaAw==
Received: from SJ0PR03CA0386.namprd03.prod.outlook.com (2603:10b6:a03:3a1::31)
 by SA3PR12MB7857.namprd12.prod.outlook.com (2603:10b6:806:31e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 12:48:56 +0000
Received: from SN1PEPF0002BA52.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::a0) by SJ0PR03CA0386.outlook.office365.com
 (2603:10b6:a03:3a1::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 9 Jun 2025 12:48:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002BA52.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 12:48:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 05:48:40 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 9 Jun 2025 05:48:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 05:48:40 -0700
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
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f2bdbda8-3ba1-4045-b231-cce83ac7ddcd@drhqmail202.nvidia.com>
Date: Mon, 9 Jun 2025 05:48:40 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA52:EE_|SA3PR12MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c70d66-1a69-42a6-ecab-08dda753fed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmpHWk9KT3A2bEFUYjMwTWgxaGp6UXY2Y3FBdU9DTGxmVjJxaTJZMkZmWG9T?=
 =?utf-8?B?KzI2dVhUMDZCQ0pzYWRpSU9wTWIxeG1tNm9rQmVwNXh3dW1Dek5RajhOZGJJ?=
 =?utf-8?B?U1NWMzRaTWh2WE4xb2ZyWHF6NEVvQjkwOVZkSFNYQWxqR2lieE5QdUxZM3Jk?=
 =?utf-8?B?ZHU2dW5EYTh2WjF4cGpsUzlzaVcwRGlEVHNSWjZzQmRxa2tlZnI4TXJVNTJK?=
 =?utf-8?B?cW1HL0NkWElrVWtFYW1ibG5vMThidUJKS2I4N2tCaDBnTklvZmxXUWRzNWNI?=
 =?utf-8?B?bTkzRjdqMHIwN0xNa3JEeFlnRVlsQ0U4b2huNDA0Yzg2aGZGdlFRWUlQbm1i?=
 =?utf-8?B?RFVEbjJoczJkZHlTZDd0Unhvd3pJWVh6cUorT0szdGxjK1l5SFdibGhEcjNP?=
 =?utf-8?B?TURDU2ZwNU9vZFN0MndkN1owNEovR0lUbEtMV1VuK0dRcmZUaHdkVUt2SlBZ?=
 =?utf-8?B?czJJbFlWQjNrMldvN0I3UXpuRkpRdVQrR1BtVXNlQjQ2M0NVdGtETkpsU3VQ?=
 =?utf-8?B?V1NPU2ZzSTh0eHlDeFVqU0V2bkxZMmdyaWxlQy9XZVlXQS9YdzJmT2NHa1du?=
 =?utf-8?B?S1ZmRlF2WWJGWUpGOC9RZ0JnTHFsaWE0ZnZhS0I3TnhSUCtUa0lDTU9hd0g0?=
 =?utf-8?B?dGJZMGFrMnUzeU9zUjEwMUJIcENybVBTMGVLU2dnWEd5c0FscGFwVEZpUysr?=
 =?utf-8?B?d1BCbWRpQ05TeCt6YlZPbDRYaVhXK3pxTUpTVDZ2NVNKVVBKZHZlemFOYVB6?=
 =?utf-8?B?QkxyUjlNNEdRL0o3NkwwMkV3ZDlFcDQ1ZEcvUTlkKy9SRGNOYTduV0pUUlVi?=
 =?utf-8?B?NW1EMnJrajZReVd1RmN4b2ZQTEZaZUl1RW5pT1AyTDFnUW9lc1k1SzNiTVpU?=
 =?utf-8?B?bEFRSlFkS2RELzFTQ2hrNEd3Mmd1eHAxOUxzaEEzRHlFQWhjc3hCaytpZGxI?=
 =?utf-8?B?MWVNck9SZVk5OFpKQURpSnluVWEvOElKKzBDZksxWUZxQk9DWVFvVnc3bHFQ?=
 =?utf-8?B?ZlY4a1lFc3Eva1pkZURHV1JsbVJFd1NidktoS0EvM2dHWGJuTkRkdHNUWHVt?=
 =?utf-8?B?N0VZSVRmakxtNDZQSy91dGMzVXN5K3ZiVFMrcGVtUTZBc0FtcnVTS3lidUFr?=
 =?utf-8?B?Q3lrTi9WK0hvdElDN1lRUktudXQzWWRtOFR3NGI3R0cwQjNIRk1nbUZFbmZw?=
 =?utf-8?B?c3kyZEhmcXJNMU51dzN6L1R6WHJPTDBrWDNhMU9RbDJ0K3ZQM1ZVbXU1QU9I?=
 =?utf-8?B?OEZWZ0wrM0xWdmhYUDZKTE5YOHVDeHRVVDRYUHFyRmtKcEU3ME5xd0ZaNGVI?=
 =?utf-8?B?TVVYQ0VFYjAwQkg4aG9PVWJ6dXJGbWFrVDllVHBuOXVUSlozZHUrblNEUGRG?=
 =?utf-8?B?bFFaTE16aExQODdMelZvbGE4dDA2dllnV0YrKzNjVzZKd3JhNktUQ045aDMy?=
 =?utf-8?B?SUlodmxFQnNrMGo2TDNFNGhlQTVYNE1tYThWaDRkOC9SVXRETjFYTm42aHNM?=
 =?utf-8?B?MVVnT0ZEK0V1RHlkZGR1ZTh2cTBaaHYzV1lTOTBEK3ZxYnR1bnBqTEFzbzAy?=
 =?utf-8?B?REZNcWtidDhEUXhlb0VnOGZ4TDFycEtJOElmaG1IVDYraTl0Q1UwZ0p6b0gz?=
 =?utf-8?B?bjF0ZUVJTmswT3hXRzVOUVB0dlZicHNibUYvcE9vdlpjdVpJSXlvb3VzRlhk?=
 =?utf-8?B?cFBadDV1cklPWmNMLy9Db0VDWDc1NzNScmxyOEU0cjRpYkJ1a0VVRU54eGJu?=
 =?utf-8?B?KzRmN0U5ZEdxaVRjN0pQSW5WR090LzRkT0VwaHJtaVhuMzE5WWR1UWZ3dGJw?=
 =?utf-8?B?TjQ3U2U4ckQ3ZXppRFhhbVhWbE9yZUtMcWNZT05td1d1QU04SVJQYjhUVFV4?=
 =?utf-8?B?SkZkdWc2bHd3SUlWVExRUHB6elJwWUhETFZXN3hPZTN4UXIzK3lmTXVORWk3?=
 =?utf-8?B?N2dvdHgrNVZ5bFZ2RWxoOGQ2MmJtWGlQWjd4QlNUeVA3OE4zbzdNenB6eG4z?=
 =?utf-8?B?ZzJqUFYxZisrcDJYV25pWWozMXJzSXdRUmhBeGJVd2xlODdBSVY1VEdQRTdk?=
 =?utf-8?B?SUQvc3RFcUlFNzdzeW8wYTMzUWFxcDdMa0NOQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 12:48:55.3801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c70d66-1a69-42a6-ecab-08dda753fed1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA52.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7857

On Sat, 07 Jun 2025 12:07:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.33-rc1-g6fa41e6c65f7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
