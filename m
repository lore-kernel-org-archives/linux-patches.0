Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4D42877FC
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756836227; cv=fail; b=r36eOFAQNX97+h2KGNWdbB+xmxr69MMFIBxsyH0rIMGt+2F57ISgbEMQ6vBiBR+oONLcTLcw7XPmXDFVK13GZnRl+/LDAE/SB8+ftwO5vXg4okzfgc8WcgwyWngaK4OnCMqJEupyJ1R9HtoNu+4C9QvEMNtDhdGJGn+aRGvWvN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756836227; c=relaxed/simple;
	bh=wPWdhFJ7zueU9kFUvnCE/wv+3brfqiaNhm6VDyqxo+Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bUzHszjAv5dWObW8IuRYKE5g13Qy7u/mWk/bXareppuDsoHZGLpjI4zrne3Mbllf8WuZURWG6Bi2NsQVcFpg6+ONyqSGKO4HSMVW4GZcU9DhtdUFkW2ixjIh3IkfK17h6rfiqi+uLWsGjFUfIE1yULpy179RkPogmUvNHQnJeOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a++hnAcU; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a++hnAcU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQBH5q9IKHq6T/vva/5PG5WpD+30cDwyqSHh4aLFAeEp7uYn1QDogLDoEIFPwy1+UGvI3BRFl4SjHrbSb+DV0KVYMPUFqxq5pa1UYMsRBQMD6GAHuS2j37AdZ0ud1zV0BzYr212Mqkws6LN1+Z+yjHBcshlRgHilVZft6Aym3citzIlLi648RfyBR3gYEvylPOMVxN6T12ZkOEiS2xqZT31Lg3vOn+wzk9qF2YF9pvHF4kWGJLjSgLxTgd0NCVxWlLTQAd2q8VbfbCBJ+mfx4pPWYks2nhNvt7enOMftHeNZYxmVcQbm2Ojom3tTm+F99n4P8ABAj0qGWBcfSp8R4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1d0axylVduUkEqTYLlwjc6vXs5nBliGF5AQFDZCZxJI=;
 b=JohNWvZ6uHMb04ebOURPrie6UD5asLzaTK0ssANNqAwGd7lveVWsffmYsNWbwVwMolCKfb51ZypjgqCJ7W+VOnD5FxJupCNo1c/8pdP2dUbC0vkTcMcaw3OXNPhmqU1ukFyIKeKzwGClIhTA3OJmmpS8hGflD1vHnCzVB5sA31KJ0cVOYOHjmzlrqDjPTQDKRinGaPv3tEOa8gS9FLkfgBEvGo6CjMl34xhPcBJL7vZlOJeoBzEMuMzSKlx6G/oTm+sWtFUE/gVr7zoUdf5pdzijo7L1ApHfda2v28lq2SWgCPSu3GUbzYpI2g5T92ZhSKB9UHgs2yI+YeVXubeOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1d0axylVduUkEqTYLlwjc6vXs5nBliGF5AQFDZCZxJI=;
 b=a++hnAcUmcd+3Z8aZYIDUdeekcm1zoQLoD0HzI6oapCWzKIPEM+6yDJWbvDKytR1y+ty0RUBcjc9yZVAvCFXivPwPbinKQrzLVbo9CrPpTUMBmf6jHB9f1hPOxdRJPPxA/BZiak2jysGvFAfhE/+9EO6r/lMS1pw93gmOrBlesvP0l5Njv3V1fW0/PaY5AdgmK+uR8EJAFleIsSY0o4YTMxYNEYNPEQp5oUPulUojbCYPkeRqkllqOkjQUksE4Y4oY5dfFvjvAOSYdyZ51qH6eeWQSpjZwEHYkD6uhmVbC1upp3W7sJWHzaEK1xxoCuMxUn6mXQQ/eSvrvEjd4VSug==
Received: from CH0P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::12)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 2 Sep
 2025 18:03:42 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:11c:cafe::9) by CH0P221CA0014.outlook.office365.com
 (2603:10b6:610:11c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Tue,
 2 Sep 2025 18:03:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Tue, 2 Sep 2025 18:03:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:17 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 2 Sep
 2025 11:03:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 2 Sep 2025 11:03:16 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/34] 5.10.242-rc1 review
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c7d782fe-fba8-4a73-b18f-af6701f6ee1b@rnnvmail201.nvidia.com>
Date: Tue, 2 Sep 2025 11:03:16 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f6cdcb1-7cf9-49f4-a86c-08ddea4b0d0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3BOc1U0T0RxTEtSTGp3WDA5b05xd2JjMHlEYzdra2hQTWY5bHlrd3VpblNV?=
 =?utf-8?B?cnZ6eUFUT3l0N2Vac3FSenZNMG1DaUV4OUcvc0d4TW9kWFJLY2oyWWxiMXg0?=
 =?utf-8?B?VXRoaWs3N3l4NlpsNG8yMmY2cmdscENscjMzeWVrMnFxMlFjSHFBWG8wcDhJ?=
 =?utf-8?B?R1FUVXlWeUFlWW1uSGFyYnZkcHpkOFp0aEZYRlQ2azNEeUdjR3djUzNrTWlX?=
 =?utf-8?B?YkYveEVBVUhlazkrUUtUbWtDTjhvRTJGcVJ5Wm1JV3BCMExsZEptbWxUSHEv?=
 =?utf-8?B?cTVqVmFPeTFnenZydGUweW9QNmtYeG1zcE5xdVBranQyK2xybmo0TDNydGhW?=
 =?utf-8?B?bHROOHJQUHRWblJKZkVMSnlGWlczWS9GcG1oVm1uRllLS0lVSU4yaTJBQVRP?=
 =?utf-8?B?VDVrdmg1UzVWQXZSOEtJV0FOUEdtdWtjQWQ1OVlYdE9xeTZuVWJZNVpqNmZm?=
 =?utf-8?B?d2tiSEZUbFNlRlZNdkhzaU1Ob3QxRzBMWEY1dlptVHRyTUYzajJ3eTJRRVBY?=
 =?utf-8?B?cnkzUG8rZE1sdnJ1dmFuK0pDTWo4MnM0VC9kL3U0cGNJNXBzcmpjLy9TOHZN?=
 =?utf-8?B?NjN5YWZYNm9FTmRObkRQQ0lUTXptV1gyTmtJMWlyeGU2R3JCRUtFL0tjL3ND?=
 =?utf-8?B?RTdmUHZpYldubklRWTlySFFrc01TTEcvTGFIZ0RUeXMyanJ0akxmOUNwU0o1?=
 =?utf-8?B?VFNTS2FENTNzdGZlN1pjNUthcnd5a242Z0gxNGp1bjR6MU9NTGxrN0Vldnl6?=
 =?utf-8?B?d3dHWXNpVzRoSTQ3bWRMTnlQY2NxTW53WGtzWGJrNUNxcUx2OUlVMG04WkY1?=
 =?utf-8?B?cUVrZTB2T1VNOE82MGs2OUZSR1M5b1J3dlgxOVA2dHoyZUFTbjYvbUh3Z1R0?=
 =?utf-8?B?aTFOSzYvU2cvbzBtdlZZNU1ySWREQ3J5TWVIOHlLWVAvem9kbTNyNUZyWVU5?=
 =?utf-8?B?NWpQdXNOaXZlOWdlTG9qRXFFZS9TeGVDRWJkd0NhbXliYnU3OGJxN1FJRDdZ?=
 =?utf-8?B?SGlaQThJSlErdENRSGFOSElLTG1sNDhjZk8yU1Q0eTd4V3Z6SUVQZlZmbThZ?=
 =?utf-8?B?N20vWldtK0lFOWViVDRIeWdtdlFEeExzL2ZieGU5MGNGOFhnU1lraTZTTFJ1?=
 =?utf-8?B?cmNTcDFjMnBKdXMwOER0WFloYUdpbFh4aWZrL3lwUXRJd25FT1JNTDhtdUtQ?=
 =?utf-8?B?N3JyeXZOQXlWN2tnZGFwZHYyMDlyZnlLSlkyZThGNlJHZndJWVJiUTZ1SnJF?=
 =?utf-8?B?S09JQjhSR1Y0N0Y0azg3UStqVGNvNW1WYTVDYUtDd0srTitTNkk1NWVJRU80?=
 =?utf-8?B?eXpXa3pDVU9FdUpSNjEzcnJaYiszeU5IdjFmYnUveHduWEFLblpmLzJxRkZZ?=
 =?utf-8?B?ZnRZL3E3dWZ2OXhpUEc3aTQxMm4xbjhsUEJYdk1JSmtlQkFLSGZuNTJ6MGlk?=
 =?utf-8?B?YUh3MUdXQitQYUJIL1QyNzBmRWZ5UkZ5ajVOajhjYXRHUmdrN0ErcWN2dTNS?=
 =?utf-8?B?Q1pDN3JlOEQ3Vzlnc3dlL0ZQWFdpcWV5c1FtTUpiV3dyYlRySi83RnNRM2tq?=
 =?utf-8?B?NHFtMVVKbnNNZ1A0NWpaemFUVTd1QzlJNERUeVZvSXhidllNWGJLV1dKOW5z?=
 =?utf-8?B?ay9hVkwySmp3UGdmelFSS2RqMW1QZE9rbmtEdFBCNmM4V0ZUSVVvdTJqRVox?=
 =?utf-8?B?aXBXRXNWbE9pL1J6MisxNUdHQk5aNWJrZUZuOW84d2dHSm95OGtONXNzSWhm?=
 =?utf-8?B?TjEwdytFN1huREd3dGo3UDQ3ZGNYb01HSFU1ZEhzdFNKOGplc29YbG82UDZZ?=
 =?utf-8?B?QWliL3BTOWJVY0RNY1h0L0JnMkttQitqQVBCV1ZkbzIzOW5ZU0JwYXlabUIw?=
 =?utf-8?B?VjdIL2ZRSWVTbkhjbnpMMTBHb20zK2pCT2lEZDd2NWdpK0NpTUhrbDIyVXoy?=
 =?utf-8?B?dmdNSmNhbWpOc3hZUCs3ZExSTS9HbEVuMmJxMGpYZ3M5enlobngrVll4VEdJ?=
 =?utf-8?B?dGFxZ3hoZmt0MDRWV2doWVZLMk5TZHhNZldOc01ldFpwTWFudlZWRUcrcUkr?=
 =?utf-8?B?ZTdRVzlKendURERUZWNEc2NqK2pVVU5tSjdpUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 18:03:41.7451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6cdcb1-7cf9-49f4-a86c-08ddea4b0d0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

On Tue, 02 Sep 2025 15:21:26 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.242 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.242-rc1-g4576ee67df7a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
