Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752AE1BF32F
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837344; cv=fail; b=Vg2ssVD16PmD7EDP5NLkXaBEkZzmdBwjjpQwxqpSwyjKX/D2GIgrzk6pj8ZzG2Qa5l0+B01ovpzMt/0jW4etZg7pQHjSgrrZPNtAsfAl1g6r4lBhwX9Y/rZ+YLijPo2SSW7pI6ZNU8kyDW78xyMkFsdFF0pB7oexflUkPXUb/iY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837344; c=relaxed/simple;
	bh=tUXiAkKcoKIky6Xwpb0BaD3l0V7qh7OveYoF9L0A9rQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hVk8y9+d32uDyTQW0sX2tKhSaZkSHDjp0kUSbSrdyI1N5fxoiRdJVYPN3nMha8sOW5SxGMf0w+LaSkcL3v5rVSMwjEe8HThsNMZ+Wohd/He1Lrqkg3kIwSo24ksx9ZPw+Oy+KqxTLpvhO1ww9VSo6T96W3X8uPUljHa5lfJH9VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mwtmyba+; arc=fail smtp.client-ip=40.107.212.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mwtmyba+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCfDkIUCCWBfEfAnzY0mZLW7O3woy/TDX3CZf8I0KlxXI+A5aBSicfaZ557EUbQ49rTIj1UL9pAep0jZYSba4OQuHbvswb0U3HUmoGCGRLnRvSgX5bJKwklTOCFzgtaABfARnoWVYKChZsNAF5gU0v8Xmy9EqjQwsNOn8T3A7vFLhE8vpwV5r2QSBbcrpSlXBxhYVGS1zHcJRkG0nLOfkTC49NKgQPD6gp/zHNf09/kDeTxniUXEcpJnCNVQUbOuuaLyBrynuqCKkEBI5qCapzZDaE1swI1qnPwqNaV8KxY+I2FHOZUvmbScKOxCD5Lwwpy3Izk5UzNzoqvOPxBVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8inn0e+BuFhg3r0rqjMC37TLrog0XT0gL0oTcX4Vfo=;
 b=yjt84/sDP779f5e3kFjybJXKwwH6hWoDlKiJXHVyAASF4uVUp1Stgi3/zF5IDWulEB4Jz+I5EDD0Hckjr/fGI4GCykyJLj6sLYlym9jKsmAOny+JnqrXV66ob+APUo4MD5Jqiw4TItdneESqAD2b/JZxI1T3XdTKZa1/oOQi66C3OtQ2+dL6tntftfPYF3MwtH3MyaAxqxXkdXY0n4KGl4w5XnnmLME9jui3k+RQx0CNjiJhlrrnF4/ZF9Fp6AtvliLni3+SIetLij+WOR+D56fKaSYPK9/KimmUoxzFZKuzKdMnWBz/tNJWPL/IMvKcRKGdJy0djSvzI+zEOcpfGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8inn0e+BuFhg3r0rqjMC37TLrog0XT0gL0oTcX4Vfo=;
 b=Mwtmyba+yYD8SZRt9cwqknyif/6DXi6E11CFyXGiu1fGdc6LWt7gL93eiIfXj2Mw4zit3iFFHb0Moms7PIiIProrpsVluVl9P/xaUApsuyef6TIvgbEvB+6BUqzHsTHoFk5Ks8Wi4jh00TvO5CSbd8UV8kG2d9YyeSRj3Xyq9POKA7ApvKXGzYn8k3lHy/0DO2mhKWo7DFNfb5wK9PO9FaB0DFXF7RU5NLox96Iwn3snISbM5IVSVE7FArRDB1oPsJP9o+SvyV/SoefGDkKJxgYaH3K3mrb5l7PcFQTezSrP00R+A6cy2rkhCi8mKXu9Bf+qt1P/jX+xbBShHMVqog==
Received: from CH3P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::7)
 by SJ2PR12MB8928.namprd12.prod.outlook.com (2603:10b6:a03:53e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 19:42:18 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::d6) by CH3P220CA0005.outlook.office365.com
 (2603:10b6:610:1e8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20 via Frontend
 Transport; Fri, 16 Aug 2024 19:42:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 19:42:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:42:07 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:42:06 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:42:05 -0700
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
Subject: Re: [PATCH 5.4 000/255] 5.4.282-rc2 review
In-Reply-To: <20240816095317.548866608@linuxfoundation.org>
References: <20240816095317.548866608@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d709d779-2a55-40d4-93fd-2626ac6974f5@rnnvmail205.nvidia.com>
Date: Fri, 16 Aug 2024 12:42:05 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|SJ2PR12MB8928:EE_
X-MS-Office365-Filtering-Correlation-Id: 92476c6b-185f-4663-e176-08dcbe2b892f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3M0Qy82Uk1Ba20zLzIyVlZsRGhJUThWOHVvL1FKN0h4cXdFaTJTdkNZSzNG?=
 =?utf-8?B?eWRVQXZpYlpjeXpZYkVQY2xqcHNBZW12Q1ptK0ZRNWJsWXlQU1hMMTVwMjVy?=
 =?utf-8?B?K0VtVXpMaWRHVmRUZE84TVJzK0dudVgxV1N6eVFRNnFydHUydy9EV0w1N0xr?=
 =?utf-8?B?Q3prQmFiTFVKa050SDhGM2RRTnkwSThsS2hmY2pmTkhUZXNSdHJLNXdqVHIy?=
 =?utf-8?B?YlFxNFFSaG9rallQNllYSGhXTkNuVGNuY3ZKSTlLWHpKd3VDVG9Ob3U3Vnhq?=
 =?utf-8?B?UFg0VlhrT3lFNUJ1aEtPK0Vmbm5UaWYzODdTUE51OFpkL1k0YzdXRnJqUVlF?=
 =?utf-8?B?WWhMcTFMckNZT3ZLNEQ1d2pZRmp5TlpqMnorRTZjVG1LdHhLN2d2M20yMHFO?=
 =?utf-8?B?TUJIUVVXbGZ3b016WUpyK3VKLytKL3VyZ3hYVk9uNWlLdlR1ZVFmTzRqQzh4?=
 =?utf-8?B?M0EvdDhSampMWTl0TklCeGgwUXN6Q0l6TXNkbTBhS3lMcXVnV1pFYlNRSkJW?=
 =?utf-8?B?QVhDYWZydmhSS1ZINitnRmo1SFIrMnRhVlI4aTdCaTFCQ1MvT3U5Tnh5U3RS?=
 =?utf-8?B?MUdneFNTK0dtY3Z5enpReFFZRWxjc2xYL0xIZ0RwSGFqaEp0V0NIa09ldk8w?=
 =?utf-8?B?Sk40ZVR5dWNZcGx2MHBCM1B4azQ3SVFLREYzZzIwd2g2R1A0Vm9PYmRVL0ZQ?=
 =?utf-8?B?WmJJREVrcDRRdFI3WWNKMEFVcU9DK3hrcmJONXpESWpveVJMakJvK3hVUCto?=
 =?utf-8?B?aGtMVDM5MEUxc1BCb3ZiK1FvZDcwS1VhQ2M1TG5PckgyRmVSdG9WMHdGOVJl?=
 =?utf-8?B?ZHJoaE4zZW9xUHBUN2tKWGNYTDhFZHEwRWozdElOU1VLSUtlZlBrVWFFeDZv?=
 =?utf-8?B?TStsR0FSYjlUL2gzdCt5WFRjbE9VU0RCRTJmVUVQWHpYTC9zNEozTDFDeDlj?=
 =?utf-8?B?VkcrdjlnZFk1aHlrTU5CWXV4S0xoK0h5QXRHTjhIUXhMbmd0NldGb1dhaU93?=
 =?utf-8?B?TWs1eHpGSkRmaUYreU52dE9iaEk4aGRrSm1JM29TU21UdHY2aEhmMTU5ZU5G?=
 =?utf-8?B?RXpGVGZucks0ZVpHZFl2dU90Ni9DdHFneHZiRXZ3YXZ4OURPbWZKNVU4bG1H?=
 =?utf-8?B?b2hXMEpEWCtVa2RlK2xlM3kvMmxvY3VoQmhWUUZlNHJtUGh5cFc1MHE0RDcx?=
 =?utf-8?B?VkRqeDdvZFFDdmVSbDc0L2ZOcTFIRHRqMFhDUzBHZWZ5cTlaVUwvMWxtb3d2?=
 =?utf-8?B?dkgyUkVHanpyUEx0d2M4WkRteGtONlJPbjArWDFDZUFmbS9iTVRWUFRtVGF5?=
 =?utf-8?B?ZjVUcEpOUmFnSDRrZkhmL3dwTXRqaEVSWDhENTBNVEFaQUpiNDU0UU52U2ZT?=
 =?utf-8?B?Z3Ntc0xNK3RWS1RiNThhUHZVZXZOZmE1M0tNMW1MLy9mS2JrdnRwVXUvTnh2?=
 =?utf-8?B?cWZidW0xZWxpTUg1aXp2YWZqb05ZaFNrcGFiNVdGYVphc2RUell5UWcvNVZ6?=
 =?utf-8?B?QTZyVStaSTJhcCtEMjN0ZmhTNndHWWFubkRNMWROSDdickF6bTlzTHp1L3BM?=
 =?utf-8?B?eTJESHh3NTlNY2orNUEvYTJackdyZ3l6YnVNaHFEVEZScXJLVnpFbGl1OE03?=
 =?utf-8?B?Tm0vU2V2UFAxTkV6NUl3c3ZCeGNmbXdJYlNVMzVSVVpaS0NRTXBTOWdTTjJS?=
 =?utf-8?B?LytXeXZwVTc3MjN4aUF3alQ5NjBidFNvc3VuYkNYZDhMeGlXQ0pNZFNtNXhx?=
 =?utf-8?B?SFpweTFBUjlKa2VUY1YrSjZwakE1dXRyR2luNWNtVEtKVkJ4R2RPbjBldFZ1?=
 =?utf-8?B?Vzk0NjVQNkpVTTdWNDFXU2MxV3d4NklYQ2VhQnNYOXRMQWU0bnplSmE0N3hS?=
 =?utf-8?B?OTFXY1o3M3hpdi9xVFkxSzUvSlZ4aldQa081ck1IYkNZOVFjM0RjSldIOFhH?=
 =?utf-8?Q?ejy4h1maRY5hwfv3pPPdrE1pFQ3rZzT0?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:42:17.2380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92476c6b-185f-4663-e176-08dcbe2b892f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8928

On Fri, 16 Aug 2024 12:14:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 09:52:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc2.gz
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

Linux version:	5.4.282-rc2-gda98fb7f23b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
