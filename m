Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8E13A260
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 08:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994423; cv=fail; b=UIjsbEUuxvwcx/UzuQVO6l6K2qJDGurbfFrLSz5JFCsBJghlu8TpCXhryf/FZ3R4qAGeahZoj8f0LcRYkSiJAzMtaD1wJwiyD9wk7/BlJSPIL3nwLmgvN1Cs28jpatPDExJ/NiraPRwb2XkvxAKfpbKMNmS+Vll8ZD+u0twcmFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994423; c=relaxed/simple;
	bh=DJZel5Oy0MENfEF/ozy8N2tXh0Zu/68Sxr8tHeyTQXk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=euA4Y22Zhn9W+/RlYOll8vS9LpDHouOY6/Bpl5z6tVMbx6MbXJCdrzlJKPZaS+g8Ko8WByJv70g5W27bms6bdAUppf0bf9vqxPQBcgaBvQQfny/rJ0cUSrexhk5vdya04am3QlkNRD6IS7mU7oj9AK/AXAAGhT3ZOBip1J4k/b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ptoP5Csj; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ptoP5Csj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fabgTlMSqQ8cQ2SU71eGhPbiK42fUmNGP1zzY4dpUqzg2NEpjkWgYOEpucVqDrRSvuPbJkTF3cWGyPm/E04AnXzGQQPWHZF9uFhno3svmoT4gk+Ep2kCoOJ+BfuWpwL4LT5ViA7mtXzdJujUV2aa7U/U055C/HrH7wFrd7tfHJlvAm/tRjxHjaoK5wSw/VsmDui7ycWuM6lZVIC5Oo+sfgq/GCoKGYTrgMCSU/LL8TAzNXIQrlzG0H84AYPHOnU9a29JxW6A4RiDXX7fgts6Q3tvHYSmR5MPmfbg5uWmrDxHhoYI7hK1eQGAkByc83ICzNVK+SkXfJa22Qjzd3qnnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQxlTSSN0jNFIRYb6jssO+dP49Q1ktzSffKq9XSXtlk=;
 b=Hi88++24oKpfpUzRtsqWsKJ1Aso3FpTucGqiWnFhGII1aaNMgevvCZMf0UCLxx/WpTTEKXJsQb1JWVBs6c7o0NfDhCz0yPdCwUXwWtBN0ou9hgQmpSlAF4szCnTNuQ8OW8UczGP9sukWcKIBUUYraQPwsu6B2BBIV6u00Z6zDh/64gnbNQwHUOU1ypphoA9n/tUdsjVHqduDnbIzf31+4aQDwcFCs74DlI4oPjucbamEHWOFU3h4klDe4kcWNmYDu5XP/h89nfZgK4d+FZbkxSm0PxR0amBtjR+0dHLar9kgxR+sKyTnen56CJP21HMm7lE9biwb0oHlawgflQQJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQxlTSSN0jNFIRYb6jssO+dP49Q1ktzSffKq9XSXtlk=;
 b=ptoP5CsjTdcrcj1Bk6JtiLZUOw1dV/+Koezvh2Sv/2LobzdRM70Lnu8+NThTmmBued48Lj9+NykdJZXmCj3+HKoX2lOoEjqj8GDDmr1w6AHW33Hw1XKONUIzMGOFOQfvr6ymKNtJk779249/d36dv4V2uGJ7gFx1oOG21rVLe3Fp7TNGuATRFrvxKwluhDM5HpD03/DpKTHcjseK0BOwXT6O2rawEnHkcVOPKE07p1Ut8F7zVCZTMUpGt3fu+A6nfnlRtalJoCq64GRfpgAS68bDiK9Y10Z9E+kheAGIXhP5qqbdtDaXMwrTYjLlbbTNOQQtHzYFtZlH8HzXtqoxiQ==
Received: from DM6PR02CA0070.namprd02.prod.outlook.com (2603:10b6:5:177::47)
 by SA3PR12MB8024.namprd12.prod.outlook.com (2603:10b6:806:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Wed, 3 Jul
 2024 08:13:37 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::3d) by DM6PR02CA0070.outlook.office365.com
 (2603:10b6:5:177::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Wed, 3 Jul 2024 08:13:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 08:13:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 01:13:24 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bd093fe8-6763-473b-8e7a-ed642afb26c4@rnnvmail204.nvidia.com>
Date: Wed, 3 Jul 2024 01:13:24 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|SA3PR12MB8024:EE_
X-MS-Office365-Filtering-Correlation-Id: 1879878e-7fd0-40dc-d27c-08dc9b380a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEMxNG9xUC9sYmpzUXVLclBzcFpVNTVjZkIveVFCcnBRb0pxeWZrdGppbGQ3?=
 =?utf-8?B?dlRKQ0RLQ3Qzbm1wZnJHZEtZZVNHc2ZVYXBwTjNPaXdJazFWTWlRMUJ4cUw5?=
 =?utf-8?B?T3l6Q2tsY1VFMi95bXkwdWxSWnVlaUJuZnR5U2hZdGNwakQrblBuVFpGdjZG?=
 =?utf-8?B?ZFIyd1RwbVlXUm8wZmdPNnBkZzdKeFRvTlNFT3FpTFN1Qkhkc0syR3BmdHJx?=
 =?utf-8?B?aFE1cHRMc1NERUdpWk9qRmxuYkRJQW1WYnpHVmNqdFRnNGtGcS9KbWlnZ2li?=
 =?utf-8?B?ak9rWElLVUUwRUx5ZVdHZDhsS292R2srbWQrOTVvRS9KSmVpYS84SWk2akhs?=
 =?utf-8?B?WWNadTYrd0FlSUZWcVk0MGpkTmNoZHBiUmU3NUNQUEN1cmJRS2I5cy9SRVZT?=
 =?utf-8?B?UlpHU0xVVjRoTk9hSVhrSXpMd1hUZ003VFhXSVpFNHhLTGJ3V1dybnNmVWV5?=
 =?utf-8?B?Yy9ZVXF2UGhkTm1BR3RqU3ZXcWlXODNqLzR5cFVUdXg0NHdXRGhGYXJtZ3JJ?=
 =?utf-8?B?WDJLMTZxQWcrTVl0V2d6d3ByTXBYeW9KZWZVeXJPMmZUZzZYOUEvVkdBTndu?=
 =?utf-8?B?UGNYM0grRkRvSzExZG1hMk9PMHhMRzZENk02b0dCMVh0QnBKbEszMVNtdVc3?=
 =?utf-8?B?T3l1aGF3UVBPeEREamFDSG10d2JqZHZUUm96cWdha01zeHVoSElZNi93YTJU?=
 =?utf-8?B?WitrNW5pRktXTk1OWEVsQk5HTE1kV3Fhd3d1VnRkOU80OGp0bFlYR2hIZ3Y3?=
 =?utf-8?B?aG5Qd3pyTldmTFJ2ak9rcytyZmdyZkNiUmxTKzU2VzJPbEJkcHZRdmE0c1pM?=
 =?utf-8?B?dmJIMVE2Y3FYS0Z1Z0grUHJ1VTlxUy9wM1NqZkpkZk1ibkJPZ3dPbTcySGU4?=
 =?utf-8?B?NzJydDNPOGlmZmREbTh2alZKZjVTZGJ6eXBqeGZNR0VkekxwNVh2SWhWMk4y?=
 =?utf-8?B?dEE2dkFjc0ZSMzF0ekhDMWVwUjlCZUZsU2srVDV3UFo3Ny8yUC96bGJNSGwv?=
 =?utf-8?B?bVBhRGpIUkJoaXM2dnhXQysxT015QmVuVUNaT1dTSE03OXhTQm13RlRjUXRw?=
 =?utf-8?B?bVJEV29FbzZCRXg5aDJVS0pMWTVtYkJ5ZndBV3NwODlCMSt3TW9qQ0hVN09u?=
 =?utf-8?B?NGlZYWJJSzNNeVEvT1NHT3ZDTHlWUjJBcjZUcTBmYzJ4dkFpcS9TMU9xOGdi?=
 =?utf-8?B?cEp0WDhJaGszSzBQYmQwRmJGRWJscithUjI2anVuaUFNMkx4VXE3c2ZiQXpP?=
 =?utf-8?B?MXBORWhMaHZGdDZoQkZHRnlnUWRMdDA2cktRbTczQzBZdElnemROWkc1YUVH?=
 =?utf-8?B?bXg4eDZOeDNBM25yMUNpNWtjR2lHY1pIRHFzTkZNSXdqYVkydnI0K0FPSkpC?=
 =?utf-8?B?U2RMQndzWUpGM0hLQjhjVEJXS0tqUlpiNzVCZmYzRGZPRXRDT3pWSEV4eFVx?=
 =?utf-8?B?bHh0ZlFjV1FUOFRSOTRETkRrN3A5WUlWNE1XTUdNTUNSQ3doUU1GM3Y3Tms4?=
 =?utf-8?B?VC81Mjl6UVRMOHRsdEFyK2FsWk53Mmg4RmlWak5QUXp1ek9nc29DV0tabEFn?=
 =?utf-8?B?RkR2YXV0WStHQmt4cHMwc1VidzBGbTY4YjNLbnhtU0xnK2xJeGh1blkvZGFh?=
 =?utf-8?B?Y0gzeHcvMElTOWNXbEVSaXFwcEljdFZhMlpMWStkS3hDVE1Dc2pDUGd2NmE1?=
 =?utf-8?B?Q2VzQUJRaExPenM3QWxmeDNnbi9tVWVYNkQ2Szl1UzFYcmtXOWdjZFV4Uk1D?=
 =?utf-8?B?b01udzkrRlA4S3htcWxhVTFmbno2SzB1aXM3cU1GdCtteGNBU3o2Um95cWxw?=
 =?utf-8?B?TWptS2kwcDJjNk9qdzBjMWtqUWN3WVFxNzZwbmZoM1hYejdieStWQisrZmRo?=
 =?utf-8?B?Yks2dmdSZE9CdUFXUHd2S1Vsek1kN1VxSUlkT0FlVXhxNHlDU3NiUktUQUlm?=
 =?utf-8?Q?rTYeBl3wz4drmZkydrbiQuyoD+gDVLs8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 08:13:36.8627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1879878e-7fd0-40dc-d27c-08dc9b380a1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8024

On Tue, 02 Jul 2024 19:00:38 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    111 tests:	111 pass, 0 fail

Linux version:	6.9.8-rc1-g03247eed042d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
