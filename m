Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE24B396B7F
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772019786; cv=fail; b=i8CAGBhw9CVXRIAQvzISmSiqMFiEyOV8ugdp75bkMpeJ8gmlfjj391pEm4wFNNCy/k3nAY5B+63WIV8Yp0BgMR26ngOOvoOuDSNl2oWsGyPX0WNVNjlfJ1iv8xmjmgVn1/9FwLN0jEV1TueIUsjFmqEZ0hH9oNGrRgHpppJ0CTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772019786; c=relaxed/simple;
	bh=e8avlhggIVK61vl8+rQ0eFWUA56dP6HaZfIrlypPo9A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LJrhIaxxsYOXOKHXzw7UIPF3sJWu41ZqfEHU59lEaKejcJAz0grpt3n39sPKbA6F8wcCWzgEE5f5yrcvASWg9fxEZvaTO5ZLUrjxTfrYzcWnbUBR/DLNFPWDq469NIEX4kOXhmbjaOoyMazCIB5r+zD1eKL/pzQUuLaXTSAOf9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pObrS1Zs; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pObrS1Zs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJ5tDxYFvELjCSY7aj/rJNGPrXRny1GV18DZuq2khU4bLwMQ/V56kqr/ndiC4acWs63XlqHxC9Uti6qQ4W5ehnpBm2E9eGGWX0WP2jSx9SCfEaExKf9RBG4E2X4b8SBH4PnE9NBu1u54P4mpeLWWeo3PikDLhMq0baThQ4KJxdZS5B2PmSksL8aw58oySOCD+odMLyScVnne/enHPrD/cYiRjct7cveLmBsBhG/Ztu+Rxsy5kc7bkSMTW7uSn1iZuytse+C0H27E/2gKCwoASWZREgJLjMdM9KEv7L9LNCHgrx9RBAsoXyN8jreSuc2dQ9NUJQUiw+VI1XUOAAIoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9BqN7iuBdMOjOQQzpILINcgwTdb7fZA3iS2YwDm2F0=;
 b=pyPEZvZUqkHbVUZIUE22IDoes/AKAp9ciZlMo5UXXDWB0JtAvQr/8K6qo+dmPuGWmF6/qQeQuEC9rorfLlAbEYt05aZmwcaMwa8q4cAhM48dQwDgFK5ITwpJXQGzTSf7g/iShjiRZZ0aYKIt6FUKcK6Nch2vsR5m0NW47hBi/Tpyx+K/OTTwZ/GHbpnOLCbltAdSFraIX+tq+00vY6psL9HBwfnzWcFXlAz+iUHBXMdzSD7YSgge+PPej5oV40fOBLWWkb2/zIuDGSyViqrSvXGDXYwccvm0akms9IkJ6qgTYerDAPVKMRqaSG9f9PT90xVql/YxCMT/SRtI8eDK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9BqN7iuBdMOjOQQzpILINcgwTdb7fZA3iS2YwDm2F0=;
 b=pObrS1ZsPVXhjjZfrvjixgLdJRo+xSSA2IICEcD0ioehS+0yCH3r2B6TZyNCGrS5WqDTFz1R1WwU9FWvDI8fV2UEZfcEtkcs2egmYZj1dstFo80OdFC/ofK5X88FHUCo5Ub31tr14PzzETfAK/vYt1LQ7y7dLj6At4ed9Ey1y9X8k8znlQlGSBFF7vZI/VVGNr/cXYZRKNsM3zfdk1dHfIkGN7NAHxByxiZ3eYnkPiuJlle+CoX/5VVviC5I/+tqdyfix2fJXc3I2ICYNEVzZCuOdLODL/E9Evb+NFgyI5/XYm9sIlAhXm3Ofr8jmW4e6XnNcxKmos/WKpIdLUqQ4g==
Received: from SA9PR13CA0091.namprd13.prod.outlook.com (2603:10b6:806:24::6)
 by SA1PR12MB6800.namprd12.prod.outlook.com (2603:10b6:806:25c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 25 Feb
 2026 11:42:55 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:24:cafe::36) by SA9PR13CA0091.outlook.office365.com
 (2603:10b6:806:24::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 11:42:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 11:42:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 03:42:38 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 03:42:38 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 25 Feb 2026 03:42:37 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc1 review
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <dfd70f0e-657f-4558-8fed-7fdd5b391802@rnnvmail204.nvidia.com>
Date: Wed, 25 Feb 2026 03:42:37 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|SA1PR12MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 441b55b1-e8a5-4997-20bb-08de7463045e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	D9KbkPOBTknN5E9x8Uoo9dfMq1WK2d0XbtCC3uid+nt2A/Bz9mpKDbesDQ37r6lfcvw8Vc1H2Q8caMo7BMulBgK079Wyn/JyhS7xCSOo+qo7fX4yMyi3hWz4bPgJyQHMOLobTeTNqsfCO5wdUuD86blnRf9fbh4PK0iLlbM/7vJgeTJBxQ07Xucj8/ek5kupnTSXiMv7Q5KkmhAoklKZbas4rYYs5Ro18HZ7plgWKfa6Hmd2sC1Y35VzrA5l26yYLsI03obskur4NUQnIWqrFSN4Ss+fa5iPvDHZIkftEwerTw4SdSKYODzjOVZcKs7bk/BUjx7sny8cke+if5gbcVY9nMH6E0X70dAHqiObQBy9YUxFK8XCSjQIbQo3ImLocoZdBgfjMSz6EDEl/b6o/4Fn3KuqtbpdbzSsG2QhgToQ5+bEIQUvnz3nkkkTQIjm3ouhOJv2kaOMSZ+G+guYiRdPUdbyDgd0pTmuUR2EZ4sLGbR8gB5nCpfWHEceuBKDQVuJ9braYZ3qJVLP6yPWGPVQwBHRY5vysaWUU5Z4W1ibOaSjHEzhwnyeyDBoz/bvOHGr05ygymFZhbVgpnKETE/Bfk5K1fTXIEvSRXbUpttMbVY8CNqGYnjMydUQtm/BI6tdsleCZsJ/18oKgHEMG577FNBpTDdeBgP393twIjB23x2/wdpFjK5fSpbO7CVlGJA9s/vxfggwsEhws4k5iK7n37FW2oyHpiLwZOD9WBqY5MLh6TEzXoJxp5IWJPH9iduZpJGRD2aWUgjx66qUjfxUPutTnEkAuvOZzLH1GoD/cGYsXdbFGsAZDOjBFwszwByC5TvQqU+KW90jU0V8Xg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6FN07eZKSH2jgAaMaiCA0LyLErZruQDOn+QUxDWyzJl14j76dlfb6uE0niC0sb8ilm4BzsGJzS9solZ9SAVAtlKB/vWch8PrYlMKlXW4mQlp3LvR9RZPEknVTEEEkK1E8dSUoamE783up5JQTvJtH/97wBDoKPOBqVE/kAN+LwDLf2Tpu9EiJ3h10fsmuAS7sk0zMJkYdjAmftUW3YxKB4Vlu1+LUopve9u5v8k2Reu0s4TAGh3slJTTcmqQdfgilbXcN0893G3uPqhwN4DlyV9We/T8cp4duCzto7Gvhe7qhx3Gtyb1LoICWRCaiFf1BciO4iFkAwvKW5LHJgDrSN/W29GHz134EvMD356g+Uz6ZYs4ev1Ht2ELImjEn/a/lXF2nn47M/uDrUKlIQBeCJlUEZ1GOIRZXylukOrfNAUUq2gmPIAkQNUlAviILzYq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 11:42:55.5701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 441b55b1-e8a5-4997-20bb-08de7463045e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6800

On Tue, 24 Feb 2026 17:15:26 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.14-rc1-g24498817f13b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
