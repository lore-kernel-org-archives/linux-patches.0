Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF3A2D9ED0
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309953; cv=fail; b=qb7qWo/Cjbyne3s/g3NnTn7NWjmYdKBrbEXaVyFAmBTD+SFkUP1Q2bT/wmldieNYhJzFHbCeNI8B3bWCWyO8t5uzyuaWSYAq6pLtvlZWd6LHqLM4cdwgykZ9FFZGsalbHTF42OfALL+56YQWj6OIpls3B4eqJkQXUvgC4KDRmO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309953; c=relaxed/simple;
	bh=EzNGGE3Ma0DzqDh1+a1DhMbeb2mZRsORN5Y3cNnjcic=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BuG/mLk8QCvl2hwfC2ReUkgjruEWF4FJhEYEkuVKnQmf7fxnNw7clPOSbBaMHwwRdpy38JAcHZetCDSopUn4+QtYFpTeQmiXPCI79hc8578wm8qNxDuFvPXgLyNeHdmiVC4afVnyGmglqvphPguF8vthW+uYJ/DisAeomSOzZH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qQflPp1l; arc=fail smtp.client-ip=52.101.61.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qQflPp1l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7zBy6r9vqBrs+yFxP1yWYy2cAsZVDhv1NmMAylV19bE/izgWsNjqk8N4qV2ErKQ4N2PZ2JOrLCFFj4Tve7BY8REdHV2hAE3i7reGGpocwdIK3Ltf80VWGibcZOG0KD2k7peKzWA6RUnaFYnjMsoOo1e5vgwL9lfQicir1rr5wLkUkRaKDlBBkd1t+iHE09BYP03qd6L5bQxsCTOTwL5fH6j6HxLLdbSBJ4fsv9SO1KQ7EG4UdY95wB0yDRBkD6g5ZdjpTR2fF905Znx87Cm5bh7rhuAjEG9+5IuMAbfV7fC5BEjeXoOffAW5lPN1ZEOGxL+YYvTrqQhDHTEdS+F+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8W3qxL5w8p15N/dgivzuvGjsyGcKZEhB5bZfgvTjpQ=;
 b=YXcGIBcGCkykQbRSz7qV0b76Gbu7IpQmQRmKNM4e2rCSEcdqpgQkSJuwxfFRoSdwJnK2Bi1nVOEMJXupPqfIn9t7cY3KWIdSr7Sh/5h5qRZZRwesZzqqCx9abXCG/C9O8XdJDzZEFSYvwC/J9Lj3tEmaqLOh18+7g9nj08v/SSRihfzgWnL7EeC6j0HNPkblIESPk8ILSNO3gpImvxKPRoW9tX+02+4l+cFraprZdZzz+2xBNFLTa1NYkajt8D+uiYIM7C9nrckBXgSiPZYVv3xi5A4Q3Ma7Wdjl4/K+tPw8eYG4yv79y78f1Aim6+LQEjemf4Yi2gNPDowtTk1nNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8W3qxL5w8p15N/dgivzuvGjsyGcKZEhB5bZfgvTjpQ=;
 b=qQflPp1l7rejK2pcrNmt32NRH9USby2K3O6pAYLwe4yNP11swkiTlAK/TFFwOttdhxh62WRdWMBIOfoaD7cwTUQM9j7kLL5Xbrm9dg1vql9h2gI5JJvwZ9xMG9ihosGBAAOvBF7NQkRp4w9W7We2Bp8RdImTjuHuFz41XuDb7MzeWomtyEZI1tuxKMhEUMazbfrlnw5OQ7fzb910VQ5ewCiwXFfsbyZ1HQZN633jkAUEB+zybgiKJeo8gTUoD33VSlRBCV9NE9C54y9tELj6JFoIC8KmLx8cyzllqoUvsgV+k1bqemsdWmQ+K1gyf+LBEDQDOGfvDC6crhN4NgDlFg==
Received: from SJ0PR05CA0190.namprd05.prod.outlook.com (2603:10b6:a03:330::15)
 by IA1PR12MB7637.namprd12.prod.outlook.com (2603:10b6:208:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 09:12:27 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:330:cafe::9a) by SJ0PR05CA0190.outlook.office365.com
 (2603:10b6:a03:330::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.10 via Frontend Transport; Wed,
 1 Oct 2025 09:12:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 09:12:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Wed, 1 Oct
 2025 02:12:11 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Oct
 2025 02:12:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:12:10 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f2e39786-be21-4895-8b69-edbe96562e48@rnnvmail205.nvidia.com>
Date: Wed, 1 Oct 2025 02:12:10 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|IA1PR12MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: dd367353-7b74-4d09-75a8-08de00caa405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2V5a3ludFNQMGU0S0JTS0JRbTdpeEJ3VTcwa0o3M2N2Z2lTbDVYa05WOEgy?=
 =?utf-8?B?bk5LYXF4NGVFZDlIY2J2V3p0R3EyNzdtbHVvcXlQTXg1TTJRalpqc3REZHkx?=
 =?utf-8?B?cGhKdytWVlJHelBqWWtWbWI0WGVZWDVIMXZCVDdzYUY2SDJVWDFxWEZVZGlR?=
 =?utf-8?B?K3F2SklZZGwrRHgrSDFLUTd0T09tcGdGaktHWGhKdEJWSUIxSm0wWW9ybVRB?=
 =?utf-8?B?cTJUWG14d2ErWXpiNWJsb21HNlhudUozTWc4eU1ReXpHbVRTTk11ZEhVQ0M4?=
 =?utf-8?B?UWI3QU1POEdhZ3NkWlVDQ0xNcWRuZDJaa1NiMlRQbTl3cThVVkxVTy8zRWRX?=
 =?utf-8?B?VXh0ZElwL3I5UkVnd25RYld5UzJKRWN2cEtWZjhlUDRhTXAxWEc1YzY1dGN2?=
 =?utf-8?B?eVRhUHJRTzRlRktpVFpLL0xVRDVuVTVHc0RLbGlzT1hHYkt3L1lLTm5QT2dv?=
 =?utf-8?B?TWJMMFFVTXhXY3NOZ2pKRkJNQW9mOTZhSmxFbURQZURzOWNBMU5oelNNR3lI?=
 =?utf-8?B?Z09TbUJRaDBiWlQ2R0NSSk1qV2FrdjhjU3M5VHRZc002Qm9WMG8vNkZoVDBK?=
 =?utf-8?B?MDRlUEhSUnFSQTZmN3JaY3ZyWjB4R0hrZk44NjBRRnlCVCttZE9sR0lPVTZP?=
 =?utf-8?B?RExQQ3ZDQWdxRjhFUVEzbUF1cW8xd0dEY0h5U01HUkZNVEQ0RVYvMnJodjls?=
 =?utf-8?B?dzZkY1BoaG1wbXB4dUJjbjZQa1VIaEl6a0QyWXZZOGs5aWxFSmFHTlRWRlVL?=
 =?utf-8?B?Y00vNlRqWXZGNXM5OXNhaXkwZ005NXlGZzgvTWw3N29mM1MzcnA2YWh2TUFs?=
 =?utf-8?B?Uk5tcVhJMW11d0pIREJIeENBWVFQY1paVy9kT0hQcjdnZGM5Z05mYW9CdVFX?=
 =?utf-8?B?U2dkQk9rdnZRNXhKYXE4ZWJVbGx0WWM2TmQ2S1BML2MvU3V3cGd0U3M5VlJr?=
 =?utf-8?B?cXQ4TG8xM1ZUclRpbU5JVGdqeXk4WlluaE8wcCsrNmdHZDJibFhTcFA1T2lE?=
 =?utf-8?B?VERFUlR5N29JdUNrYnExcnVlYWZxMHBlamdIYWI4WnRYY2g1aTlNZlRPbnhm?=
 =?utf-8?B?OFhzcGtrblJFK1dmbDNTcUF4T3pWZkpHc0dwdnowdkh5MkRJc0lkdHBaak5q?=
 =?utf-8?B?MFUxaExGRlY5KzJob3VPaVpJbVhibklhc3I1OVVPSDZzSUhVVG5Iak4xVHJQ?=
 =?utf-8?B?VjZKN3d5bjdZcDMydHVFS0t4cDhjWStPTktqSytnTGZBaEdiZFVKSlBNcm1a?=
 =?utf-8?B?QkN6cU55N1F2YnJsR3h5bzQxVkhRYUg4ZXI0UXBzbjJlYnFhZjA1Zms2ZHJU?=
 =?utf-8?B?R2U4QXZhdytsNTVJd1ljRHVGa0wvK0F5S1dHRWdzclcrd0Y1TFNkOUlYaVI4?=
 =?utf-8?B?b2xZeVBvbUkvQmJqV0cxanFBRmdQRllJV0VTdkdySUpUd2FuazlVNDdLbTZr?=
 =?utf-8?B?REtkZXVYNHI0ZktVeGtQNmhLNVZBNDdvc3R4ZU9yWi9YdWNKbHdaTURsNDB0?=
 =?utf-8?B?aGR2b0ZtNnBjUjlEQWpUaU1zVEEzaXZUNkVDUjhuRnZxN0tnc0xKOWtIdklK?=
 =?utf-8?B?d3ZNR3VEcjZ6aUd0aXArWFlvUVZBaUtyejQ1MU1XK1RzTm9ReWR5dTA5TCsy?=
 =?utf-8?B?TVFoWmZsZmhEQlloNWJNcnRULzBvRk0wai9YN01wWWdDZzNoRWR4aHkzNVdq?=
 =?utf-8?B?QTdFaVZKL01XaEhRQXY4WGh2WkNzQmg0WlZlRDJUcDZMSUsrUWIrakFKZTRu?=
 =?utf-8?B?aG5TdXZFMDNIOUoyTHVoQ3JYTUVIVXVwS3NCeFB4YmdudVlKTGgyVmZnMmFq?=
 =?utf-8?B?WDdwZkZhM3lONnpvOU1PZlkyNUZ2UWJuMTJuOTdMbi9za2JMc09oalpRcXRD?=
 =?utf-8?B?ZVFqSTIyUFRBczlHVlFtZkl5cnlDN2licE5lWTMvbG1EdUhWTlVDb1VNYjNZ?=
 =?utf-8?B?aDE5WUpJQ1VDNkJhT3ptd2MybzZ2Yk5uWjJhcjNDeDV0ZFJldUZibEpJWkFZ?=
 =?utf-8?B?U3drVkljRklzcTRHNlhZditaM1dtdUl1ZE9ubFRxRlV5WkRDMkxFSVI2cE0v?=
 =?utf-8?B?dTJvZG44SnAvUlFzNGd1d2ZqYmpDN0VnVkdNV2NjZ3NHK1o4TGM5WXRPVUlD?=
 =?utf-8?Q?RJnA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:12:26.8089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd367353-7b74-4d09-75a8-08de00caa405
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7637

On Tue, 30 Sep 2025 16:45:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.10-rc1-ge1acc616e91a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
