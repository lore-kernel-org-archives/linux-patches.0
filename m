Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2752D73AB
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764842477; cv=fail; b=fozL1t88dteCq9EtlwzIFAQJ5OpOY1zes/uk61wMdPAjnqnoLVfk5qISsrNW0rHr2qrnfNV9aozde7bKkIj9WlSbItyrz/+8l8vsGa3R5nllyuK7uPw7R2hr9ya/5tppDVUq/ZbVuunN7XkhwYazkvkQUVRefIuAckTaDVyn5zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764842477; c=relaxed/simple;
	bh=ZErUyHcK7OhI8Av7PLlI8h6rVOMeui/akltawe4lam0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=QxAvGYQxN3zguzgrORNJs3kzPJrw52Gdh+hhRb4QUSUU7syxQzYWN6k0bmxc+2vAS808U9Ye2iBWOt7KKAp7LypaerzGUHBnvwizQIL44WwL2V4OQR3o1KegIoW0QAU8QUHg+lfUrKbWiNKUbND1hzsTbA52w8vQoA2DFcNjIK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tw1gl+s/; arc=fail smtp.client-ip=40.107.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tw1gl+s/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTRu8EQ7exlB1it6lEYlaTt4e4SWqoVymdqJt8q7/Ss3qbtWSczf5zRolg+Z8Tj+DLygxGy6dTgSwR4ceN/JV3NUyiY+BCY19Mf+/kSB7gTiAH+OxcLKngwz0WYg7+3pbeXugAOd3UNYFryh/N2umWhpXUa7CgcAi9OXB2o2xAji6/+BRg+P4YOj7LGXhXGvfmaEBKpx6MqBgWcW7gfY82hlTVweuJtMX59t0jGGwWPcOoZgRcUVXVRZ3TryAxNodl5AUbMul7HlZfWYSw8f45iSHMb5LQpz61GM+omtcfR3TGZa0D0++GJM2bTh4bgJar1Dpxz9RBXwOd5m+ZGSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+FxDOsIe5rwOW6/TM7ky0I32DJDA1N8BhldFMsbgB4=;
 b=LlgrQo7yo0sKnA0M0ESglkiFiI+4MfrceN/Z9RdJwEjTf0oHagI/iDDQt0VwNI8En0EWiAatKXfp4ZBjjHKQ4rRdSmeS93pZloQL/s6jAXVWjPv3JQSZce4U13FrUforUceAaemUOGqVr8o8AQuts33HoALS50eLtu4P7ytsEPfbkYWhAaZaFfGLVBzRHxp0OUQWIeXyXEIR6bWsFBXFARorTXeoqXk24AeCTakULwx6E3RuSA1Wkr4O23aEmU/gKGBous7Vk4BHAZ1X6luuHOEYCZhWyjpGdE4HJ2vofh6F28qLIYmEKYPhyPjTH6ds3N7VFfWfW18PySBXb9duZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+FxDOsIe5rwOW6/TM7ky0I32DJDA1N8BhldFMsbgB4=;
 b=tw1gl+s/8lWfpNAIqkx6j0kJLoholVlBEBTtEwltbJKDmZVv44MbjefFD/2sDmeMcwC4iaVLv8wboRtLmmlzu+NdT2DmAebSmy6TYSqdJ47WMK0bluPt+ddudPRtCKR1q4NU2eq0IUcShaEL8J0HF6cpe49w0m6FRL+XdsacYy2LEL8klYUDGEDljqs9wkCcwjq4qLCsqbJQ5F0j/mUL9nH2MDugcYyI0TEu+BQvwxgL3opUGlareSEA/aEzSLhh4rctJgsti625CuBQmog0q3waikDxBjD7NsKXnjXdO9Jc25hWhwiYx1+dTVgZ1BlRw725kgAOYc+RXYgXEcvPpQ==
Received: from DS7P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::20) by
 IA1PR12MB7543.namprd12.prod.outlook.com (2603:10b6:208:42d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 10:01:10 +0000
Received: from DS2PEPF00003448.namprd04.prod.outlook.com
 (2603:10b6:8:223:cafe::24) by DS7P220CA0030.outlook.office365.com
 (2603:10b6:8:223::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.11 via Frontend Transport; Thu,
 4 Dec 2025 10:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF00003448.mail.protection.outlook.com (10.167.17.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 4 Dec 2025 10:01:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Dec
 2025 02:00:57 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 4 Dec 2025 02:00:57 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 4 Dec 2025 02:00:57 -0800
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
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6ea5a326-7add-4c67-bf04-833b4a85fd46@drhqmail203.nvidia.com>
Date: Thu, 4 Dec 2025 02:00:57 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003448:EE_|IA1PR12MB7543:EE_
X-MS-Office365-Filtering-Correlation-Id: 564ea29c-602f-45d7-1512-08de331c0ccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUlFeVNPeTVvMEw1QnMvc3J3RmpQZy9uVXlsVk03ZXp2algrelVrVnpNLzJ6?=
 =?utf-8?B?S2xOZEdPMzBISEJnVEFJdWdpWnYybVREZTZqcVEyZDU2MmZ4Nyt6NDNFaG1T?=
 =?utf-8?B?WG1iOC9BVUloYUlycmhoY2JMZGJDaFJ3V2xhVytDMDFQRS9KV2VhcHA4UE9m?=
 =?utf-8?B?YnkzSUJWTGhzZ0VwSy9VZFYyclo2UmY2L3k2N3RDcnlKNnVSU1F4QmtMMG8r?=
 =?utf-8?B?Rm1nQkxuY3RNSENDNmNaRnROOTZab3M4b3R1NHVJQjd1Y0s2UXJCdUk3Mkdy?=
 =?utf-8?B?SXBQeVlzQk9CNWFPVXV2UVRtalVmbmJKSFRzZEVTbkllblFmUnhKVjZ6TTky?=
 =?utf-8?B?a3RDbEVmMDVkKzY5WTkvenhwTWM0di9nWjV1L0plNHkzaHg5MGJNeERDRmxV?=
 =?utf-8?B?OGVacnFaVVFkenpaNDJoTHY4bkZWYm1rcTZqQzYwNlVtWEdCNmZqblpYaTQ0?=
 =?utf-8?B?VUJlN25iUWZkWXlweUEzbG13RWJwYitWMUN0Q3FxNEtGWUZSRVlQSmZSTkNP?=
 =?utf-8?B?Qk1qWVZjcE5yTzNjaEZNMUZHdTNGK25ObEVoc1pqWE9RbjA5WVcrMWJ4aWN6?=
 =?utf-8?B?Sld0QVRtaFZ0bGpFY000SktEbEduMnJaV0pHUDZqTVBwVFBQN25kU0gzV2Nh?=
 =?utf-8?B?VFRWY2NGcHBpUHNtUW5SbUFyU1lEVlNMcERsdjVFQStuYkh4SUl5VldFbEtC?=
 =?utf-8?B?djUrdEdIZk5PelhXTDRyQnlIREdrblRvMzBFYnVWNXk4ZHdPM0lIVUdjbXBO?=
 =?utf-8?B?UEhvNUFzNHJwQWxIRlBvQnVFSHhkaWxlOUxjNkQvTU9NSTUzUnQxMjI0UlJT?=
 =?utf-8?B?a2FtYVBJc1NsMEtWaVN1T2ZkQ1RIaGNMbjZvaGVFZ0E0RkE1ckZ4c29CWGJO?=
 =?utf-8?B?S0ZvNlA4SW1Kc0VpOWRaeXZIOHJVNGw5Zm9VeDBjSWJxTWJ1RU5KL3M1bk1Q?=
 =?utf-8?B?L1p0Z3JNZ3Yvd2RYSzUwZ2duTFRjWkZlZy9PQ0F2c2NqTjA2MjgzQWc5cG1Q?=
 =?utf-8?B?anRHUGRtaEJFSkV0a3l3QUk1bGgvVWdjcWdreThadXNuSURvUVhzazZyWXEz?=
 =?utf-8?B?blRGcEVKcUtiSXZveEtNNmtKMXFJZUxRa3YrNzVvL25YQnpjZlRickZjc282?=
 =?utf-8?B?VTVTNlVLUk1HM1JsOWRiWFNndjl0Rmh1ampKTUsrWTF1V2JUMUpOTE5lSXFZ?=
 =?utf-8?B?dXQ5RjU0KzRZZ1BSbk9hVlUxK2VVaE4wYjhEOXJNbWxRa2Z4VDEvTzZDcXU1?=
 =?utf-8?B?czVuamFkOVRJbDlHYURYZVc1OGwrN1NoT0tZRjRUN0l5eDFmK2RCeGI4UFNu?=
 =?utf-8?B?SUZQdUU3K3AxYi9PR1EvSGFEck0zV1ExcGQrMVlGUUl2RTZ5Qm8rR01DbTh3?=
 =?utf-8?B?VzV0MmhWSlo2NnFUbUMreXh2dkdmeGIzck8wd1lkNThlK2JjRzdWbG8zWEh2?=
 =?utf-8?B?VEloaUN0VjlaQjlha2RWM0JmekJtWnpSTFE3YnN0R244MzF1TUVXWGZZc0RK?=
 =?utf-8?B?UjZxY2VrcU9Hd2drNnQxM25nb016NElyM1RiTWdmcVY3Ry9JU1B1TTBBYjZM?=
 =?utf-8?B?UzN3a0EzTm9VVmsxVFFUdFJnTGdDZUpGQzBEVVZyc3owcmVleERYT3FaRTB6?=
 =?utf-8?B?NUdBdFBYQ1BDOVl4M1lIOEpkbjRLV3Arc2lwd2xiRVB3ck9sSDhGSmEzM1B0?=
 =?utf-8?B?dG9VWE9VUHFWSGI0SnFHQWNmYkltZzVvWlErWW04WHN4MjRzRUNxTXJ6dS9k?=
 =?utf-8?B?MjU3c3Y4K1JpM2tFalBDNGlLWjNIZUs0cGkrYWd2YmNrZVJ4WGdRL0NjYVVI?=
 =?utf-8?B?Z0pYTnhhdDB4bnBCeGxjWUNzdU5iRit1UFNuejc0QVcvaVE0STRBNUNjZUw5?=
 =?utf-8?B?VGhIUFl5YVJ3OEY3ZWZ6eEZYRk91eXB2MmpGdUNjZ0lOL1Vwa1d6TDNMU2E1?=
 =?utf-8?B?K0hETkFsSnBleExRc1NYSEs1Wk85L3hzcHRsR2RxS21tdHE4NVRIZkRKWmtx?=
 =?utf-8?B?R1lDQXdhaHJuMjQwOGVDMzFPRVg1dkNRMm1CUHdQT1lCcXA2Q3E4TGtOUTdK?=
 =?utf-8?B?RFZBY0Y0TVlBdklYaDZpUmxPbHhjZ094U0tRWUtZWHZKdzN5Ui9LUWQrWjJi?=
 =?utf-8?Q?qgMk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 10:01:09.8625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 564ea29c-602f-45d7-1512-08de331c0ccc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003448.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7543

On Wed, 03 Dec 2025 16:26:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.11-rc1-gc434a9350a1d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
