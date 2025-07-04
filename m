Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726072E54DC
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751627630; cv=fail; b=Rf0hn1Vxurr/TrhyIRJFu/7zl86ooQF5NspAwEvDP+dOwM18vnXli4eb7oFM8lZKa/lTK+g53T+JT9Q5LAjoIZnVOpEs1G5a7sJBtxky3ibfJl/ltf1rn9H+8F2G+TciuVf/2LVjnDuHc7SWU/1DAmcAFSWaLGTCx8iFxYkBwu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751627630; c=relaxed/simple;
	bh=gKuWs1J9V1amZIWFHTLc7dPiAiQ3qRYGDwAtl2pDDsM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bn2z7CUXZqQBtanG8g7gZTQI4AvFHFX/6C+snEZlrFWJ/OjnuVwuh5LyHumMEqo33VjJAdl4oM10Tei0+Bt/uCN+hVv3VzikncWG6O9NaTz16c0hhHIs0PlacP2ZhcPdMBg4CiuzOl747nFhb1Nf+3VyFKdynur1Fy2IVpHXYTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dvqefCJg; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dvqefCJg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnZ11xQjbpnHx5Pln+O4qcd2CFrgTMnZqJRr8NpsPRg+uJPzaOGgCUjKDaY3Hus6OqgjucaYctVvPyvV7mufDoFSmU0wMUIyt5BhiEEdN0FDWjJaUiIXBB6ljPbYtAR8iRfJdui470qHOUaXEm/aUhKDBLY5faUWnQy3BxLkPRioS5kY6ukUuLUNAuUBa4zid0r7P4PS1C6l6G2ejIiNMjnjsNO98nTNqmd0Izp90AsrobArz+4oXJVcO0SZbc00jHgjpnm33LDuti3zZkHHI6LQpVB/OIjpazpKvhGv0qLIpE8Koz2qt15A2ebR8TKG/MCUIwON0q2zK1QG2VFYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8MU8r2iz/7w9DQn7haT1vaDPlb9WE5ns0Yq5g91j8bw=;
 b=dDChwYxmtWR7+2cmUvwSH0reaqFH3jo06aYni3w8pOyum1PGafwlWnbeJ3wK8Ht/Ym8bHQmhpHtGxuViIHQrOhljto/ZOWgIGkP148r/DwNoDO2OdfMH9FnQeMyqjBDZs+32Jndir5KRe8c0Dl6iEIdfQQ04pkAMTZjQp6D4SwJsyEZGR7Y8478hVYgxBbgU63UJDVszgdP4rk9BiBUX9nveRt7bWUAobmVKflyM3Mk2KT4lIytJYv+HP6gHQFYNbjMdke6l/TtAQqpIyQEeFC5DooSwJ1hSKwqRAOlarKtxXjBCudHZgq2Hv+QdlfxlsrS3xSDrZdfEGMBabqGNcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MU8r2iz/7w9DQn7haT1vaDPlb9WE5ns0Yq5g91j8bw=;
 b=dvqefCJgethbMqs9InPnyhguviigZwbqsI044UKDqjn7vgQe4h5aW/oljPZAP+hlatFN4mKbZOL9RoJnZ/mdpk51iCNM/oNrdWJuy40bpJyzHNxqBv6MR7TELgqWZYH7fp9qpvt2UAWxH/X6Ee4Ur3MTgpRc1Js2kXflzgECm5oDqqKWX/WCp1TMr7ECYIOl7eAFgUso9TI9NH5bkqqQjnyvHijP1m/yrbvb6HKnKKLFBnbMq5ebhKUcU1uVAoJ5G7W6eA2/CQYgwWToePYtR4X5/i155eAMHUOakg6Kxenm0sYCpkVg4vAD1M3a8GBOuSfvndkEK//dIF/d5Y0j3A==
Received: from MW4PR03CA0248.namprd03.prod.outlook.com (2603:10b6:303:b4::13)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Fri, 4 Jul
 2025 11:13:46 +0000
Received: from SJ1PEPF00002311.namprd03.prod.outlook.com
 (2603:10b6:303:b4:cafe::8a) by MW4PR03CA0248.outlook.office365.com
 (2603:10b6:303:b4::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.22 via Frontend Transport; Fri,
 4 Jul 2025 11:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002311.mail.protection.outlook.com (10.167.242.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Fri, 4 Jul 2025 11:13:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Jul 2025
 04:13:37 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Jul
 2025 04:13:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Jul 2025 04:13:36 -0700
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
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fed1431b-a017-44d9-8909-06b06f8073c3@rnnvmail202.nvidia.com>
Date: Fri, 4 Jul 2025 04:13:36 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002311:EE_|DM6PR12MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ff5e3b-6d55-4aaa-cbde-08ddbaebd7e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0tlZ0pBZndYTjhLM0U2RGdtN3A4aVZ2V1JFdjhkTXpjSGFscTRhcGdETXdP?=
 =?utf-8?B?a3czRUhSYlJuSk9IYm9KQTM2MEU2SVhsSUNFZzBTRzhuNC9jck53NUMzM0pS?=
 =?utf-8?B?Uzh1cWZUNVZqNTNOU2c2OUd3bklXcnE2WDV1VldKay9DenppWEd3cTd5WDRX?=
 =?utf-8?B?b3NiUjAySDJHaDBDQ255Ri9wRVlYRU9YN2pOTDZFRmV4ajdRUjc0MGRSLzly?=
 =?utf-8?B?ckJNSWtwODRnSHdnbk1IT0F3LzBPZEI3RHlFbnBxUW9PQkNjOEw4VDh6WCs3?=
 =?utf-8?B?MzhDQlNoVUgxcFB6QlVpQTlGRDlkTCtrdy8xK2NUamZobFFldjRaSTlPNk0z?=
 =?utf-8?B?VU9iTWtNWlZzaytFa3dyZThRYXdXdnFTR2R0NkMweGx1OGFWaDRSMy82VVFE?=
 =?utf-8?B?eU9NeEY5VWhzZWpyRjB4S0JBRWpKS1oyNnNZcmZBQ0ZMTHN6czJlOHdNKzZM?=
 =?utf-8?B?Ykh0UmIzTE4rM253NlpBK2hrUVRWQ3EwUXdWWFp3OG51T0Zyc2h4WmFVbWZy?=
 =?utf-8?B?c0pnRmR3VEZuczFTN0E4MHFVRTdiOG1wRFdZWUw4dEdjTTVxMm9TVXdic1NH?=
 =?utf-8?B?bG1KbzhHZDdXYmhldFJCaWp2WjhGR1FLZVIzNVVNSWdGUU5ZQzNCTjVidTBQ?=
 =?utf-8?B?VDB6Z0EvQVllVzR2RmN6ODlzNGxJQ3hVMEhTR3B6cFBydmFqQVptM2pMRlJ0?=
 =?utf-8?B?U0xwb0Z4bk8yUVdBTzIrNjBoWEFkYmdjZ3BhUm1aOTgwZzRuMW9XTUkwbWxU?=
 =?utf-8?B?d1VwbzFYc2N0MGpYbHBtTktkVEVLZVVDT3ZmOFRXcGg3dXBNY2VrcWREbXBT?=
 =?utf-8?B?bCtBVTZBT1NZNlIrSE5NSkgyTWo3UklrZGllQTJFL3pmZEFDUGs3QlZGdXBr?=
 =?utf-8?B?MkczRlE4d2FTRkZhclNoZzA2NnZMMTA2Vm1mYmtiQy9tcTFuNTFGV2tKZlcw?=
 =?utf-8?B?U005Y2c2UEVwODBnWW01WlJGZmM1YXhTcnRrQWF4bFN2M2pPSEh6SWIrN05w?=
 =?utf-8?B?LzEyMDdnRW9oUUEyVFVzQy9XNU80ZDdaUGpSVGdqZ2tGZ3g4cEV2M2ZuSVRi?=
 =?utf-8?B?V0IwNjRiNE5NSlduVHhyd2Joc2d2MEh2L1hmd0lDUjZ6S0FrRWhQTVNBdHdC?=
 =?utf-8?B?eFMxVWZOQXRGR1VvWDBhMFRXaUpQVlQrU1ZDbzMzTDRmMU9IUXB0RmRxK3A5?=
 =?utf-8?B?bmN2K0R3cFQ4eXJwRXR5QmJpQ210aytNZFhpSTFxRFU2L1NObi9DaTZXSlND?=
 =?utf-8?B?TWsxWlRRQy9pSzNDNUtzV04yU045d2V3RWcrTlVRc20zajBtbFJBbU1WRFJK?=
 =?utf-8?B?Nmc2OG9NQ2JYYm41Zytpck5FVnZBekt6TFd5UWpFc2ZVWmVDSVA5WWYrTm9X?=
 =?utf-8?B?TFhEY2gzMzdzYVNUZWRKZFBIQUlnV3VOVHlNRmtHWHhSRHVNMUFkYVA3VXpM?=
 =?utf-8?B?UmRwN1Q2QlRLR0NRMEVQSFFLWlNrWXdQUUpWaUZEeXFQU050TlZTaVBaMEZV?=
 =?utf-8?B?dS9yKysrMVcrcGJwRU9meVIwc1RaS1J4cUVpaHh0ZnJxOGdCK1ZnUWRDS2Rv?=
 =?utf-8?B?NlByUTNBaXhBMktmb2Z0aG84b2pkY1BqNmRTLzRjenFjQ1FYWTV6MTJsTGNY?=
 =?utf-8?B?Qk9Cd3JBaStucUZoN1ZOdk5XbDd3TDhpOEhTUlFlSHBnSFNFL2xtRGQ0RW43?=
 =?utf-8?B?N2RMa0FkaG0zSDhzMzd2eVorSFlxNUtYUHJzcktlUEJPL01rWVdXM1BoRnQz?=
 =?utf-8?B?OVJIcUF1dEtXdFp5Z3hnbzA0aTdac2RsR25JaDhmQ2dJSW00NmFDcENPWVBu?=
 =?utf-8?B?RzdWY3JYYVFZVGJicEVQT3FPbnRtcDF4UThDaDVaeXUwUlZCSmJvUUk1WWdy?=
 =?utf-8?B?RFRldWFRTEhBTXFORHJ1blo4WmRCVEYxdVdIcXVVVGJZOTJRQm05aFVXcTQ2?=
 =?utf-8?B?eU1TbVFIQlprRFZrYTRMMThxQVpPM2c3S281cE1nR3NvUlNJS1U0UytRSlJ0?=
 =?utf-8?B?VXdGVjdGT2RHN0JoTExwVlBxSHZrS1Q2VlRNaGxKaVAwSjVUKzZReG10SjVG?=
 =?utf-8?B?cmVDQzJDYUhyUnhZandIcUxCbk43aHI5aTZCQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 11:13:45.8254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ff5e3b-6d55-4aaa-cbde-08ddbaebd7e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002311.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388

On Thu, 03 Jul 2025 16:41:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.96-rc1-ge950145d456d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
