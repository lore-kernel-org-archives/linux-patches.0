Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED491CEEB2
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 17:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693333; cv=fail; b=a1d6ieLwSqzIqOHU3lq2JkYcP7oGyRAaNIH4aYK5UyBUpdBXdJ5tj2+8PPrJLAQ236pAP6iqHuNJH05SPJmXrhGUO99D5Pv0DS7ZfqxmWd2nLfmtViJSS7iVqnC+Wk2z+k8G1HbUZv+TEOViM+xCplquFFtp2ZdLbNG2X+2AaBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693333; c=relaxed/simple;
	bh=lg1w7V/XMpUU70O2OmeaUk2UNbbqyFmNyzp8e4Ep47Y=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NTALig/y2PwubmcYcZOG2f3T0kmebpbVwsCNphHPhh4irb2lmyvqmGBltEGvRId4ej9Eep9x6jUHaAha35EdsreZ3kiPlagybOPrK3EZ+zdCd0yyZ/p7zqen1ekmFI9Bpkioh0iXu6x5I+KOdA5LAuex3sPmcnZMOfijQbBuGRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OyP3fpOW; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OyP3fpOW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tGPtMIOrWExs3LYCYjleMdAXMjHwpaKK/lbQUxwz4UC+brlwl+ZSfi50wqp4GSGTsGWSNMnrLinchqTuduZ9QXv6L01k+ejAAaD3RvnZUinGmeSD7gfLNs9hqylL1fRhkZUy6fc3GFGYCRxcNaJRLigEubVbuMgCb+5hztY8NP8p4MHiWA9cKVE+OQ7CEejxFbAmZbPYTHbV9CeVwno6I7+NZPHzaCywV+J5qYGaqmd+gUVGuVibHynPUx1dwWPbX0WFPoiZdieejiuLoUPishnuCyymcfm6Ze+A8jEDZbeiVL3+3Cbb4RgiqBthn3UBFjUPUgq0YATwvgyGgrUJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GTnM84B2JL98aHSEL/hmah6tA8QseY+VFJCkWx9Ebw=;
 b=CaxWHMFQh0p/91N4qszCXgmTPzsDCPYdsggRTTlkgOc64Q++Cl2FDmp7SqcT+kX6t5YmiQvUTsFZYBILSpenATWeR9b0FmnSa4tDSBJNeZBekznVrYi11J9+mmC/8GQjfvM4LDAHjgnBOeUHcHMKaoCSjSCdFBS/qKSQ+WrcQKbnNaFM+tcM9NBvigULtqb803wkrHfuAe56hEVvpl/z5xotEJ75AvZPH6gDc14ZOTZTLZGubruRsMtPD5Ud4Qs6twnRWyDGztqECshHx3bp407QGcxt/wSBncOlA5LXaPoDbbHPJ9Vu/nXbkaVchlAUkKUMBl30rYpdMRNXvrnn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GTnM84B2JL98aHSEL/hmah6tA8QseY+VFJCkWx9Ebw=;
 b=OyP3fpOWLKEPXaAj1J0tc8c0EiSfY8iCJ8U54t9/yAjtMBTjA1F8/HNma5A0gZZvk5zSD9U/B6rerzXHMksDIeLNOnxvjUlmsQ0cHB7YUM0TQiJqTxj8pCO1U6ijvKWiKfnAG0xyHAJ3dFduB9vmVpklNrk61dOhGuUvjWRdxHG9LwyvPJrnAzmuCYGJuIySWF49MVbg40p+9A4UkRMtZy5Qvm7UKwVMhi+tmMEK5FIhkPwHLMvPg53wXygPptG4fQ0oTZ6e1qQOSq+vw4+j+VWZ16SzWAOD2fQ4GHsPRpC5fXHDSoe2OXrLHCIciGInUmUtXG7DX1ITFqfDmaHeDw==
Received: from SN7PR04CA0049.namprd04.prod.outlook.com (2603:10b6:806:120::24)
 by PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.31; Fri, 15 Nov
 2024 17:55:27 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:806:120:cafe::69) by SN7PR04CA0049.outlook.office365.com
 (2603:10b6:806:120::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18 via Frontend
 Transport; Fri, 15 Nov 2024 17:55:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 17:55:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 09:55:11 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 09:55:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 09:55:10 -0800
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
Subject: Re: [PATCH 4.19 00/52] 4.19.324-rc1 review
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <899ea853-ecfa-40da-87c8-c9d0d17fcf58@rnnvmail203.nvidia.com>
Date: Fri, 15 Nov 2024 09:55:10 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|PH7PR12MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: c17b010b-a605-40c1-b47a-08dd059eaece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlNtSlovSTJZenJxcHZRRVRZMzNMVHlweER5U1poSVppYXNCd1F3SGZEOFZa?=
 =?utf-8?B?Zm5xUit2NndhcndjR0EvTDdpdmZRL2xVRVdncHdHR2xtdlIzYjdGWVpnSHZs?=
 =?utf-8?B?TWd3WFFvTG9KaUx3cXFxWk0yQ1YzNjU2SXFNMEh6VVlsenpueXp2dEpkbzg4?=
 =?utf-8?B?cmFCaGwvZzdpdG41OXh2OGd6aG5mcFp0NVRpVWZmWE5GMmZKbVduSXY1SkRt?=
 =?utf-8?B?SGNEWTgvU0QwaFRmaUcyeW1iNEpKMGZMUFpOWU5aUytJUWJFWU9NS2hEQmpH?=
 =?utf-8?B?cVFLVXB0em5LdVFURTdZQVR1bEV0NWE0UC9BaFAvajZvWHJvRHI5WUFBZ2Q4?=
 =?utf-8?B?bnkxemVPWTdrbExYMU0ycVJadGJ2M3BpSkFyK25tZ1R4S3huS0ZQZm9DT0Yz?=
 =?utf-8?B?WVJpSytqTXcxTVZ2N0FmTnRpbVE4bEx4T1ZPSm95UWo1UFZjRHNBZUJmakgy?=
 =?utf-8?B?VjVuWmJTYnJZKzlBSnVEZ1BxTEZBZXV4YlJDQUh2cTJSRENiWlVVNW4zYTRB?=
 =?utf-8?B?QzRDTG9YNjd2bXh0ZzlsRDl5cHlnVCs5ZXZHM3Jsdk5sbGtud04yYWhmSGM2?=
 =?utf-8?B?L29rUDZmMjZaeXNiamFGeHZtZlhHbTdKSDh2RFVnclBULzJVNU1tZW9CK3pZ?=
 =?utf-8?B?VXExQWJDV3NrUHdYK293RXBKYWtMQ05ITjFPbG5qeDZFYlRSbVJLK2ZyeER3?=
 =?utf-8?B?bFAvQUtSeHFIN0lINVlld2xmZVNUZFkrYWUydzZZVjZGdVJVTDdVWmtYN1Fu?=
 =?utf-8?B?UDJCSkVDMnNGQ1IwRWpTZ1AxZ0lwZUgxQTBBNlcxQ01oQzYwMzFuako0OTVF?=
 =?utf-8?B?aFhocFMxa0dTVzhSeXFZRjVBK3FtTTFic3h0SWdXYk13STdocHpONHBRZ0dN?=
 =?utf-8?B?aHF0TCsyUW8wamxGZmJLU3I5aVdKSHlEcU42QmprUW55WGxiZjlzYlQzMGFP?=
 =?utf-8?B?dnZXYU9rVkRPcVl4N0FwcW1CMUN2dkQwRnVLbG1scHhBUHV4MkRHUmRKbTZr?=
 =?utf-8?B?QmtVMjlMU0t3M1NEMFAxdHMzUUMvb3RnR1BtSUhPRkFyKzNid2tScWpROWdn?=
 =?utf-8?B?WXlrdVEyU0p5RTJmSzFvcHBrTXo5WjIxcjJ5OStsd1lGMWJGTzNDOVRVVUI4?=
 =?utf-8?B?OFBkaW92akM4ZCt0TE8xNStTZnp5bTZZTkFGTlo5eTFEbnAwSWlJa1hhcEdG?=
 =?utf-8?B?eWFRYzdwWTNQcEJabVhHUHozdkRSOXk5RHZMak9xbW1CeTh5WjloU3VhUnJk?=
 =?utf-8?B?RGVKeDdld0pxMjZUcmxoOTdCbXNnNmF5YjNyb3VtMVZkRGF6bWRHVWxITUhw?=
 =?utf-8?B?NXB0cWgyamM5N005YUkveUYvU3czSVVydUVtK2d2ZGFYTlBVNGs4VW5QVmkx?=
 =?utf-8?B?KzhpaEo1WmZBQVQzNGRwcEFGNzRBYlg4ejBGaWU0empsdngzV2tVYmQ4Mmpz?=
 =?utf-8?B?QWFYQVVuT2tHalpSMDhZZ3FmL0txVTczWUYwTkRDcjd4c014VWk2RGJWZ2pW?=
 =?utf-8?B?dG14blNvblZ6WmJERHNmcjVERFRyM1NjcFlqa0wyRHFGaXRPL1d6dVZ4TDAv?=
 =?utf-8?B?R0ltSzVLT0duNzVnZ3U5NkpXOVdDS1lvc2U3Qm1JbjZoZ1RCYjljWEQ0ZVJS?=
 =?utf-8?B?MGpNQkNvYUFEWG1QUWpZdWJZeU5vZ3hJNnRRTDUxNzRuSitzK3UrOS93ekxl?=
 =?utf-8?B?bFNoL3JUclV5SzFLSU9lOXREQXNYL05OZnVNVU9nOUhCM01Wd3ppTVRmZmFy?=
 =?utf-8?B?NklZR0Q3eUVVQjVHUnp5dlRybXJGOC9VVURFbjI5VlR3ZE9HeHBGREdvdm85?=
 =?utf-8?B?MnVTK3NhTWsvdWJBTS9CRkp5aENMcEJkamlHRGxaUkZMMW5GU1VleEhmYnRR?=
 =?utf-8?B?cW11OHUzZ0xzTUFLVkNyZ3hLZmFnTkI4RitKWVowSnF0cVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 17:55:25.0826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c17b010b-a605-40c1-b47a-08dd059eaece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492

On Fri, 15 Nov 2024 07:37:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.324 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.324-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.324-rc1-g3b4d1c2cc314
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
