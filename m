Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43E8440C
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 00:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441859; cv=fail; b=CGptNCKiHLpCQkPV8+j+aYfeEX3PyynVqOJkHM2lgWdxKevjYMtVD7t/fP128DdEhB/1iCO5PYzJ4r62AnkFOH8dzw0kCHBKK9c796mENfARgfCcFNONpsETmKq6iOZ68kpWAJdPTktlZ8qj4UEzvEX9TYYTXN+bjXW6dhXBeVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441859; c=relaxed/simple;
	bh=F8qAgD30KuioPJa6pVS1yB11hLW47tQpvbN4bWfEhSs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=h6tJ8qEnmIwU7jCxd28dhvUo+whO2L3igjcCxEeGDNSTBbs/zuELqB1Z1+TCtpNevbqfyYc10FGWlZLRVNhNCBd9royZcaCzMWjcVMCiem/j0RF3Lsms9BTt3EV1nlIrq654trxgRzItjwlr+JRK/4/9UpaHJUIQkSqqtmgMsFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MNF8q42s; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MNF8q42s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=us3WMC3g46fnnQUGSGeYN8nh9wI3ZLViekbw1oXVvL8GQEAKcNouLnJQtz5GYvOa7Z0VjwTWnabvYLX+ocXBfDeWzdUgNPVFAvK43MTDGHXrJMBiC6JkiI7ZWlgqI7IzXyUpD0QSVVe+6iAv2HrZOlHn3ZarbPQrqYoOD7jPKI0Mw/waFA2UayMpwapzswLJUQ8q09YEpGH43IBNRND5Y4hCyMJSdxRPJ5kRZb+AOctdJ15I2+ybmJYJCkJsLwjQqvaLsBCoSuWDF529pwaQq9Dg8gWMhozznCAzmJzsWLusU6XUQRRbUefMSTsXyhzaVfp8qax1THDlTSxtcvQA6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3m3dofRe2eRcwU2oljqGSutXnhuUPv/DeOpjyyQHRA=;
 b=v2U/yckTL63Bxd4uxPSdQYWmZZORl5BJKouNoHEAw8CLlCBiB4fcR7SP45LcasZIwNAOfnAeSHH8AreBa25davS1Ii0tx8Cqf6Z+Ejo+z3UjAdLy70yg3HWRxHfTruwxr99rOmSM5EU1S1ArJq2ca7nZ6WC+4RvWAm8MycbWvDjWMuPk0b6NOk9OskDGgWD6U8upYUGq68IEEdTSR5OaYQcNdsslewiNcdNnmrTnJZEWUZ0yifNe9F3I/N1i6YoCIwV/gESmd+tAVIX/n+j/tib1QCi0BQzOJvAVSdFJtUr/rA/O5KfxvFRIitLq/0ZUEC1e5k2Vjp9vIrETfh9Tqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3m3dofRe2eRcwU2oljqGSutXnhuUPv/DeOpjyyQHRA=;
 b=MNF8q42sxcwcILPywdFQ30AIinPp+FKIM0H9awMo8oPgi3GjHCLnLeRA+z8JozPXyk5WpUnt9EBLTquIo9KaHUwi2tJ2/QFjRjBaAuPjAj69n7XfatIFlMWqQsQPtsJoLy0bLdS1s7ddIv8naW0M4WZVrYEAh0Zeqk2AZ6lACEMSRjoHzAEjP2hCXWCpHHxlruf9m0ebXUavpJAhevFY5z5s6G/Db1+cFWXRJ7ujKfy6B5HV1y0Oo06nz+uR5zR0gpVGrypsI4Uq0Cf1lAz3n7oXhVcqd5NUh1+fDEZ3c3ePdx8brOK3WNzfDcOXBuFkvRTE42MIrR2IXdd2rw8XFg==
Received: from PH7PR17CA0014.namprd17.prod.outlook.com (2603:10b6:510:324::29)
 by LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 00:04:09 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:510:324:cafe::e) by PH7PR17CA0014.outlook.office365.com
 (2603:10b6:510:324::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 00:04:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 00:04:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 16:03:49 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 24 Feb
 2025 16:03:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 16:03:48 -0800
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
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d0347183-4195-49ba-8a58-04f7163a841a@rnnvmail203.nvidia.com>
Date: Mon, 24 Feb 2025 16:03:48 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: e4d5df83-9387-4054-65c4-08dd552fed47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGJsS1JNR0M0ZEI0Yy9pNGF3cnBSZUs3MHFkOEgxWXlhS293OEtuTm4xNWFV?=
 =?utf-8?B?akFpRkllOHIva0tyQ0hlSVJ3aG1HZW9SVXMzM0xobldFTmVIcGN4MXVJUXFW?=
 =?utf-8?B?U2pGLzRCTy9Qb0VOaDVzVE1aTytHYmZNQTFldkZzWk9BRGo3N1dJSUNvRGl4?=
 =?utf-8?B?K2lUTGV4ZTZ1cU1nZ2IrWjU1Z0xQKzlTdmJjR253ekV3OUh0dnF6S2NDOC9l?=
 =?utf-8?B?WC9YSlVyNWpualdrZXRWeHVJZUc5OVdhV01vc3BxdmtoNjB6eEZ5ZzlhQzVS?=
 =?utf-8?B?SmpSU1M5dzc3cnBBTU9CUVp0K0o0OURhUW9OTUtJc0dXLzZERzYzcTIvdk9o?=
 =?utf-8?B?TFVrb3NBRXREMlRMY1AyTCs5QVJoUE13WTIrQmFCR0RVUk5GaFpMb3NJYnVn?=
 =?utf-8?B?aVVsbUZwSEd3OEI4d0Z4aWN0RFl4MXduNlMvNkRkbnJWQWtXc29nOXBONjl5?=
 =?utf-8?B?QVZEV1JEVkR4cDFHby9QbFhRTHBJTGtSQ0hod1FLVTFkR1l6RUVTekIrTlRl?=
 =?utf-8?B?TkRjWWE0UzVIYjJqSzZiaGdBSVQ3bXozYUZHaG1LYzlpekJiOTh6WGdENHpZ?=
 =?utf-8?B?VGNKVENQVE9MS3d6YVB3Q3Z1djR1QlBFbXY0NnkwazVwN2pFTFQ2cDZyLy8y?=
 =?utf-8?B?TUc4enJYbjNDTUJ6WVlmNWNZajY2c0FlVWdWb3ZEbjk2bXQyVmx2dyt0UjJZ?=
 =?utf-8?B?WmlDRU1HUmwra2x5K09YZ3kxeUw3Rzk0US9QUWlBQkdtMEZIR0dJMkNZcnBG?=
 =?utf-8?B?K3BXeERXVnZyWnpYNzZPK3VBRFljN2psbVBlZ2JwUDd3YVBCM0cyNEpRQVEw?=
 =?utf-8?B?U01kcXBrbWVrZG5JN2wreEpYalVJSnd4aTlqbEszOXo4MVFzTjdQMnlMcWZr?=
 =?utf-8?B?WCtrcG9HU3hCSjVDSGNqY01FUm5rZEV1TFpOVUpRdVpIeFR1ajVRL3VGd1U0?=
 =?utf-8?B?cXZjZWh1b3RRKzVNVjBIR0hGSXlGbTNUOHpqaDhYY3V4Zy8rR1h6aG9YeG1K?=
 =?utf-8?B?M1pOcmFpL1NKeWlRbFQvdzJRcHdLemFJTFFkRTlia054am45WXdEdko1UDhz?=
 =?utf-8?B?OS9jOXhNTU54Z2FkK1RIWURoVXpDNG9wTXFZbU81WHIyR1JZd0JpcmJ4Q1NK?=
 =?utf-8?B?dit5aWJrelVZNHpoRlNXTUlidXhMQWJ4bnlia00xQ0pYNlhlNmFzcnc1T3RM?=
 =?utf-8?B?Lzl3SXJyOU5NZjdJd0d3d3FjRW4wdnV4Z3pUNkxjczZlRmM4OWhubU1DWTEx?=
 =?utf-8?B?SnVtSUlWS0pDSGExR1RQNWIwRHhoNWJCL1FNMTFacWdoNEc2RzRGV3VOTHg2?=
 =?utf-8?B?YzhXTGVOc1hUTCs3WVZoLzZNbVVOLzVHNVc1bVBNYSswRGN6UkpBajJRWWlu?=
 =?utf-8?B?U2FmdVJIUEFsN2h2Q0VKYllGRUJsaXRlODRjeVVxSDFlWUFIWHk0RFJhQkdT?=
 =?utf-8?B?cXUxanlHdUdqUExrNlhEQkFpNUdBSTVobnNhTDRKZStkbi84dXR5YmxIbW5j?=
 =?utf-8?B?UnB2VFprbHQyNkU1QlNUeHBZZXJEVjdRWDdZaWEvRjJTYlVHVXpjSnRRa2c1?=
 =?utf-8?B?dGp3alJPZy9UeVNjWDNOM09rL1lzMW4wcTY0VndaOXRoUmhXaFdXMEt3Nnhy?=
 =?utf-8?B?eUFhQXZkOUN1cS9QUldCd2FLejFEa29XM1RSelhpaGFVRnNYQ3VJOERSZEQv?=
 =?utf-8?B?R3Vpa1RxOFl4NFNuQkdNbUl1aGFPaDJwT25SUlZNZjNFeTVERUhPRWdsSFBR?=
 =?utf-8?B?Vk1BUXFmTy81b1J2RGtJVFFEQUEzRVZsUERuSldvckxHcW5OOWhBRFgxd1NB?=
 =?utf-8?B?cHJSbEtZOXpuMHozbU5CSmd0UDByUkFnNEllRUQrSDJNWS9OWXBUak5xUm1S?=
 =?utf-8?B?QitqSFp4S2RsTlBmbStwVjBEZUdWZmxzWndkTysvWFdMSGh4QmVhcVpFOXJv?=
 =?utf-8?B?VXJkeDBxVTFMSlQ4KzRZZ0kwRnlkbE9ROVRxcG1Fd2NmM1U4ZGNCM2NPblRq?=
 =?utf-8?Q?+L6kUS4sgIUYdJM1syuXPsPJ/ceboY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:04:08.7306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d5df83-9387-4054-65c4-08dd552fed47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110

On Mon, 24 Feb 2025 15:33:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    32 boots:	26 pass, 6 fail
    72 tests:	64 pass, 8 fail

Linux version:	6.13.5-rc1-ga2f5d7b5cf50
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra124-jetson-tk1, tegra210-p2371-2180,
                tegra30-cardhu-a04

Test failures:	tegra20-ventana: devices
                tegra20-ventana: tegra-audio-boot-sanity.sh
                tegra210-p3450-0000: devices
                tegra210-p3450-0000: mmc-dd-urandom.sh


Jon
