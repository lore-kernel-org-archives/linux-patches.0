Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013011.outbound.protection.outlook.com [40.93.201.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA323064AA
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 10:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559636; cv=fail; b=EAj5TsHRjj53w+EE3DI69dlrpXjUMYmjP/LD95/wUTqbV9Ss1hLI337qDGs4sVrJOtZ1ZCIa2tfWYtYxycWbyNoV/yUAEyYhBVQDmrbpIwRZeoiuNQ/PvVibH436G8FZtaCFIKRjDybhGc2nahwT9+jFjt5EVme3H6hxxLwkE7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559636; c=relaxed/simple;
	bh=2NA/iPq/REOvJ8GrI1HN9nL6OQAaujCIQW/wPINdVZE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=m8f5oGnnHOfsOzlv+UTXpRDqvAAn+IfqioM8wulPTacLnDZcMbDEd8o5uFr+Hj8grQ0DilRnXYnZqrM51ZJuttZZdbbZRuYMCvPEpdIzXgq0Fd+CoEml3I3slzS3ChNSqNQKgfT/jI7tv+rlBHxmbSElgWLod4IPJpUc4i4OE1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZqXU4hZ1; arc=fail smtp.client-ip=40.93.201.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZqXU4hZ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OtU/2p0Zltl+I0vC2WPNh+bJPjPgYrnWo6Sv4nSaGH4bU8u1jd5fDmSlF6YWAOhOQsk0DuMyey2y6PJQxhxzsPujLa4MME+VWlyGpySTEQwAVDHB5zUKike36AhwquEfq30BytAGprCmhD4beGZ4zT2aA3k/d/F1Ylm8jVQPAfewVrIXkih7G70tTN9R8a97840+8zf5mM9rps6Q7iZJXGdiT5PGCOooLrqe9v6Ft88u1b3CZtp+IIndatIkVst6rKK8tmmPqi8clXvLjD6RvJ0WIiOPVZAimdNLJ0dTF8RPJIRztWc8iLPJ18LF9DF75MJm3pKjVfICZxQM9z7QRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApCKpfEzBLwLtNP07SGnmpIDi8qIvdlDZmYgWvuduTw=;
 b=ZNo36NRs+Y4mrRGlzE2qSMYOqZdoQVSgKW4aEIbE3MOaiD0hY6vr7/tSRYoKtqWLk45FkmLWSnjUv1iHoLWdbb+jSg47P9aVIQb4leKAMy277O5UiYH3vqtrcgA5JuCRPW5cQkweQSkyJa//kDlroh/wymppyuxT8NgOm3DibdrOKYCGfSXcDZ7AmWu8ukiWH33ZaaOe0YTEJu1P3OcBwWgAu0q1BbaBl4tX9HkVCN+OMku2lLqJOW5JTnIn0NXR93L9kHr7wJWwNgZ9LmqOCUWhmGlmoypi/y+4ZU32QRzsw117bftVdOjCks4HklLvF+KvTR9++tbozufaZFelJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApCKpfEzBLwLtNP07SGnmpIDi8qIvdlDZmYgWvuduTw=;
 b=ZqXU4hZ1bu1UN6ffLdF6mQ6lNzyaIhRWGCa5tlS2A0CL1ZbKQ38tiSWn3L7DOW8zyrHsonXQtUaeh0nIADXsNYYzPz9L9IKoTMxq16OS2cBfxYJWP4NRMRmWEns6GZgdcwrM1tvp3b/ng2JVYmqh43rdwQTs1u7I+WvOj6Fpjou8csXEqPpiYDkEQiwze6scFVrizBjjrtZbDi5DqbWrK88G1WEA3MtrH0w4OubJquNk6ylIi492ZYz1WD4TO0+6I3et4RQhnWALkiIGb/g6C/90rfJuQXOGWmHbwMJYbxX13n0bmECWXZoVzv2qmmE6Ik68KTGVB8F0RNkEe70etw==
Received: from BN9P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::26)
 by LV2PR12MB999098.namprd12.prod.outlook.com (2603:10b6:408:353::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 10:33:50 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:408:10a:cafe::35) by BN9P221CA0007.outlook.office365.com
 (2603:10b6:408:10a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Fri,
 16 Jan 2026 10:33:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 10:33:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:36 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 16 Jan 2026 02:33:35 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 02:33:35 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7d2b19fc-170d-478f-8b6b-ae013aa944b4@drhqmail203.nvidia.com>
Date: Fri, 16 Jan 2026 02:33:35 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|LV2PR12MB999098:EE_
X-MS-Office365-Filtering-Correlation-Id: ed94e377-75f5-48c9-7a85-08de54eabd4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEFjOWJlOVA4VHF4dE1xS0ZkSllYZU8rM3NDU2JMWVlCdjk3dCtDaFhTYTcy?=
 =?utf-8?B?RHVBdEYxRkIxMnZBcCt5eG5oWVhKNHVZaXJOS1BXbXZjWkpOa3A0MzFUVExk?=
 =?utf-8?B?L1ZWL1pNWi9rbkNMbmRTbVJyaDRwZ1BacVpDa21DM1pHdlV0T0lBK0wxdkxO?=
 =?utf-8?B?VHRyZVBqVEZzMDNsNkJzL0w1UW55cTZWTEk2T0VXblZyMWUrYTZ5U2MxTFd1?=
 =?utf-8?B?eHlXa3FhdG5QOFBnSFdTekdvL3hNQ0ZVVnlKeXRySGNRQ3B0YjRxSmhNd2E0?=
 =?utf-8?B?eW9TeWU1eVZiSE84V1dZVlVKaFEvVVcwYXByVEFheU9KczIvdlpOVE1COWtG?=
 =?utf-8?B?TnA5WTNkUitBVU9kcHZkaUJpOGNvRDUrV2phTTQyVzAwcG5SUEttNVFUUVdh?=
 =?utf-8?B?cHFySitqWXg1SzlGWUc3ZC8wR2RJalk5UERkNkh5UHVORDk4TlRMbnVtS05G?=
 =?utf-8?B?ekNmQW1WTFpnZWJFdE13SnIrZlpWVmdsREc2SDBRNVEycUppUDlPdG1TZFR1?=
 =?utf-8?B?RXhUQ056VnpKcjZkZ1p4dmNOWktFUHFNNEc4ME1WRyt6dzF2Z3p6RFNudjd0?=
 =?utf-8?B?MkJ1Q0V5UXdaYyswRmhUdUtjZXdaTm1Na09WbGlhWEFLNXNVV3k1bngweEpJ?=
 =?utf-8?B?bVdlNkdPTDJLenZOc1A4bzVrTU5GOWUwV0NVYzVCdDFDdHY1MlZ4VVN1dEo1?=
 =?utf-8?B?ZUxRbmJYWVJSQ01TT1V6VVRXcW53NHVCd1NlWEVZY20rV01TN2piRXhJNmRW?=
 =?utf-8?B?UHMvaFlVRjZHUzU4dHlhelZHTEhuVVlVOCtVUUtEeDBrYWZNZFFCZmV1ek54?=
 =?utf-8?B?Y3JHRXFWRlFac0RyMzFlOHo3Y3pGL3Q1b3p4SDBwQnI1Y2Z3aytBdEtFeDZq?=
 =?utf-8?B?bkFiZTJ1dXhySkQyNG5KY1U3eXdKVWJORzZ3aHRoWjQrU2hDa05mOFRjU2pL?=
 =?utf-8?B?UERiaDYvVlYxeEY0Skk1UWVSR0czSDFjV3Boem1WTzlUQll0eXVjdjh6dTJP?=
 =?utf-8?B?dklBdkNOZ2NkVTlkQnhYMWxkTVVBeGYyMEpVMmRmU0tzNWloQXRXbW81ZEtr?=
 =?utf-8?B?UDAwZjBVTEVKQW5sN1lBY2xDVGJPbWpOL01CZlhmc1NMZ0NvRFY0R3Y2QzdS?=
 =?utf-8?B?ZnUyL29VTFFnMTFadVZVYmZqd2lzamxKb1ZsY1hxWFFTMTRFQ2lVTXV4aUUw?=
 =?utf-8?B?V0ExMklkQml4cGVvanlrTU1EM2EzMUR5MGxGdWJWRGwxV3ZaZCtSVjhJUHcr?=
 =?utf-8?B?aDhDVWRGLzlHYjVld3lHYWVQNktoV3VkYlI0QnljOEdXWXQ5dnZLMExKZTVr?=
 =?utf-8?B?TXU4N0lIRFZhdUQrbms4SVBVZVEyU2lPdHFHcEJzdDVEakMrdm1JalRTV3Zy?=
 =?utf-8?B?aFJTdExGbUI0T1dCM3MxOG9lb2Y1M3hLZlJsWCt5VVVBdlJjSy9uOG9ZaFVC?=
 =?utf-8?B?MnoycjQyV2NoamQ1NTI3Z09qQmxFZDhnc0p0MXV0ZGFHMG9sQWg0UWtFUG0z?=
 =?utf-8?B?b1NmODR5WnpaSjhGalQ5NnVubVA1SWN4bURGRGRFUzFHQnVRbTJDZ3QrM2pK?=
 =?utf-8?B?blp4MCtPZWxKL29WNjZtOC9FU0cySWNkZHNVR1RCZVZYbXpPZUVaa1V3SGM0?=
 =?utf-8?B?WC9nd01qUEtOWGV4ZVZ3ZnpUYnlBSjhaUzE3VDFnZzlhRzBMWWxHUUJpRU9X?=
 =?utf-8?B?RGM1TzdlOFFRR2xUU29YU1ZTTmNPTXlMMjRLa0JubWxHczhqNXVDQ25HSnpx?=
 =?utf-8?B?SmhIeThoYmdjZ3Myem9ldFo3Z29BSGxTNXdhY2ZISjdQUVFCSUdpM2c5YytL?=
 =?utf-8?B?TnkzSDZFcm1PYktMQzJzd3BOWmZIZEQrc1BBdlFFaER3NHNncjhGYm9QS0t6?=
 =?utf-8?B?bGdvQ1MyT3Z2UEM3WklHckUxSXJoQytoVkFReWdJQ3JFMFBsNGFleW44RXp1?=
 =?utf-8?B?YlZoaU5DbWxuSVREbVNkQ0tzbUwyZE5iNUIyak9OOTY4Qlpkc2pFYkFxWFVi?=
 =?utf-8?B?M0lHN09MOEI4czg1THB3ZjhrRHAvL0E0cEJURjR6Sk92M3JCQ0hWVDNiWUhZ?=
 =?utf-8?B?SWhjS0dqSzNMdDgxS0F0akpYNTdwTWJndVBLa0xHUXBnL2pPMk1NL2E4WVZu?=
 =?utf-8?B?ejVtZlErLzlrbWVtS3NUWmI4TmZjV2lJbDJ5dUUzdGFWck5uRTJXWXdlSS95?=
 =?utf-8?B?Y1VvTFo5bEZqb2hFZktoVVpJZ1NVVWdMTmkwM2dpbW9iRFdIRzdJUVc0bGsy?=
 =?utf-8?B?Nkt0bXhwWTJxQWF2Nm5IT3EwczBnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:33:50.6392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed94e377-75f5-48c9-7a85-08de54eabd4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB999098

On Thu, 15 Jan 2026 17:47:43 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.121-rc1.gz
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

Linux version:	6.6.121-rc1-g71466c6813d0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
