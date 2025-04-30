Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AE93FBB3
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025456; cv=fail; b=U4lNI25oh6ROCZzyPA/4YbC1i73mDnBUH+/LEb6B0qIlvvMv6sdAs2MfWVPpC19XEOCg4gDwaYB5to09AZOcYPRWXsifa6t15hAXATwWRsVIO1OEYKWdwvWqSlYFXKe6tuzLgyREY45iQWuRKVuFHpHa/AvdaAJ5+Scr5LJlDvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025456; c=relaxed/simple;
	bh=KCcAw49YZPg7SHwbTa/PmsHFQxMyF/CatQzQz/LG1Mo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gUU3EoXIAqk+/F+t0Duy6hv0C4a0SFqztKU6bDJRqFbTb+w6numJcBTNbI31vkLTEBuxr/TYG48JcsiTO73Jkt7K1KwrIy6WPUsr2hCjTXNDEuB7F9IZDpR4mXH/0tMid/By8RJMW9ucJynbLB8hDylykMLigpcytBZXkaMfbFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZMXS0ZN2; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZMXS0ZN2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xu4K7OngWVd49guoROfaU2UZmroCxyj67092d72dzS/v9a6csdWvONNjeDXyWfi3o/99tDV6RA2FTM0BPatjog97cSS1qOxK3OxIev8YneeBGgPXhcttTWe0H41/UyO1PXsdMNgjlj6GPceuSYYuioKsOsCT/EtBkzpgMLw3HMSxvIbSAU6n0n54qsTNfp1p5TjeLeI7AdPjJHCY3djYlEpjvbJ39urKR+hZaobTt6f3eocOJTQygenETPqJ6avD2OHDlUhImeGJFlt/Uz1N8PF/o7EtkhclkP7P3W2dModolivNfhT6ry84UhdoUg7gTUXMp+oX/FAY+DV6bABVvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBEYjfVu35cvFYSADNug6ElgwNsIO0QrLPKEU/5iX2M=;
 b=PDKCWXxEQPLe6yccSpDRdkKMOKPEGxDeChGQ0qXx+hNFA2l2PkQp0AaEf+32NAYVTFHh+FqnIX5GTWPTDsg1FlkrI/SI9GN+Y2cmBDu+sOX3Xk21h+TEk7PC7OZjpZvkZLELQoaEz3Fvj4mPZkzOoy9ud8CWBhVzPW5LGHTaAlncopOXluk0DDG5UMlII3Q9VQhGvrU2qq91BnHBJmMkVYjtKp9A9Sx3ox5BvWchc+jGDJtbQgA+UJFcnd4S2y5e6/ysZpSIbP0W7NVYUy41YCmzPmyRTxhEZMiuL71A28keEstTPh/0JWk/6j0wUXOouEr/YFMqO5ow8XAZFJbc1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBEYjfVu35cvFYSADNug6ElgwNsIO0QrLPKEU/5iX2M=;
 b=ZMXS0ZN2Q5whSJKkYVlVVit4jVRJD7+Db9ccHzjAHDNeYQyCbrg94fP+pPdJ8eap6wUBvqEOuhvrLxHJwtYilvQCgHFy7Ci1l/4/5UU00iT2VHVGK1nN+XIA8qHPx6koyfPuhdhTzSPj8zgu6Stwazed1HyoozSL8h1Z8OBIu11QxbetfL5cVyVjrF63RrGGlrRyRB4i5D+bo2sk8nfc912S2R/ewUotUPuXRbfR4v6rxanqpOEyLmN9uyj2oGq+cAKQ/u60DnCMCibjM0+MCPxVchLAtIikGS/7aFmfuEwRDfA7suNkp3sgNGRfeeko2FS7Kx4k8Q11QdVcK8iBeQ==
Received: from MW3PR06CA0020.namprd06.prod.outlook.com (2603:10b6:303:2a::25)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.19; Wed, 30 Apr 2025 15:04:08 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:303:2a:cafe::94) by MW3PR06CA0020.outlook.office365.com
 (2603:10b6:303:2a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Wed,
 30 Apr 2025 15:04:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:04:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:03:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Apr
 2025 08:03:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:03:53 -0700
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
Subject: Re: [PATCH 5.15 000/373] 5.15.181-rc1 review
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91798154-8fd9-439a-8807-fae9e7216512@rnnvmail204.nvidia.com>
Date: Wed, 30 Apr 2025 08:03:53 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a8bb67-7233-4b83-c127-08dd87f84187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cS9xczFqVXVKVEEwQUpTdjJPODJwbVY3Yk5NZGx3eC9JZkh3VVg1MzhQRXJs?=
 =?utf-8?B?M0Z3RVI4RXRTSWwzSzR5SUM5V3VZRXlodTl6djN4U2MzcUJGNVcwRVhoayt2?=
 =?utf-8?B?L2FXVDZPSlUvYU9ySTl2cjhkUXRad1ZKaGI2dTd1Mm1XMTM1UDF1TkkxU0da?=
 =?utf-8?B?aFpHWWRQWlBISmVZYXAwMGJMMWRWNmlQOUhQMDQySmcvamc3VThkTmRKZkxU?=
 =?utf-8?B?ZW42RjFqZVZONlgxSGJDemhJYkRRZ3BJdmZNS0JVZC9TbU9tU2I0UFZ6b0Vh?=
 =?utf-8?B?T1FrbHk4b2lwOXFPeWFBYUszeVJvZXFGcllkMVA0T0o0VEZWS2hvQVRIOGdo?=
 =?utf-8?B?dzdmM2xzNVpUZmNoSkRGaExnZGRoWlNiaHltYjljVFRVZXg3d1lMZ2tuTit4?=
 =?utf-8?B?TVZBRWVpNFQrWW5Kb2FvNXN6WnNjUFY1eGhYcGdpK2syTHY3TzE3bDZFUzVx?=
 =?utf-8?B?ZmFUUDh6RUdaclBWT2ZwY0hyV0ZsRTA3bkJtTkV3WFhQU3V3bTl3WFAzNTNN?=
 =?utf-8?B?aTlIbytySHljN2M2NUNvemtZR3lnbitmMkp2OXNBeW8vUVhwNHJNdUFQak1V?=
 =?utf-8?B?am54c3YwM1pQM0RUNk5jREVyWVZiZzF6bWh4RmRwM2d5MXpmRWhnb1hSQmx3?=
 =?utf-8?B?T0twOWdBaE05VW5uQ2lYNVdrRVgzbFR5bnI3M2M2OFNJdlVKUHVsUFRoWnJC?=
 =?utf-8?B?YUhPWVVGUkYzSU9MeWNiOXVJMVJRbmN3bmpsQTV5V3crWTlBRHVSNlFZVXdV?=
 =?utf-8?B?M3l0VzBvb2FrNmJtOUtxR0V0L3JyRHdPZ044eDh1ekhQSCtqVTdOMURBbzRp?=
 =?utf-8?B?UnpCQXpKdXBaNEFjNzkraWpmem9UeDNHZWg5YUtlUUcxSzJ4NjA5QlRLSk8z?=
 =?utf-8?B?VEZEZkYwWUJCak5xWU1EbnBJWk1xU1dZSUdmMzRROWtza3A1NEJkUVNkanJP?=
 =?utf-8?B?OW82QVQzcVJRZ1h2R1JKZllOdnNVRGlINDVob0NnU3BCdUhJR0xrTEVJZmpU?=
 =?utf-8?B?MXh2WUNHUzJVeFJGUW10ZHc0RHJQa0hNYWpSZU1zdGlweVRteG5lekdzcW1h?=
 =?utf-8?B?S0h0Z1BaRXc0SGJGQ0E0bjBITVlwR2VpeGtOcDEwQys2M3BnUGd1Q3pMNzdS?=
 =?utf-8?B?eHQ4ZE92ZlZpV3hzY3F4V0hmTnZGVzk3enplUFNrWXd6K1d6WFFjWlRRK3cw?=
 =?utf-8?B?RjlvazF1ZFRDVkRBekhNNGlHbG5SeE9kdy9IWFRRV1c5ems3Wm1STlo5ZmV2?=
 =?utf-8?B?b3dWeEkxdG9ydFVYTElGN1hxd29ESFhOK0NWTkdVOUxDbmxROTNmRmZSSFlu?=
 =?utf-8?B?NTAvdkdDNXB3T1B0NEpEWGNtUENicTNsWEgzSk9lM1pCU09XbXo4dmNZUXQy?=
 =?utf-8?B?aDZucnU4blNvMll6dFhkRUpmWkp3bEJzcTJ4Wm1PeTRDdUFFcEQ4R0lUTVFV?=
 =?utf-8?B?YmhlWUVsYmpUZ3BubWpCUHNTMFg2cjNKc2Q3VDVLR1RPYjVLaUhBYzZIdmpI?=
 =?utf-8?B?TmlMUWk5OXRwSDVwRXdBNFBSK1BvUlFFb3NrM3lNTDZTS1hudHpoU2N4UEZI?=
 =?utf-8?B?N0hNOFZsNVRqSFMzQmQ3T3BHZlFUeFBQczVpeXQ0aWl0aVFXRlpMOS9QaXRy?=
 =?utf-8?B?QldvN2NVRXRqN29QQ0daUk5QTEtkeDdpZ2RNQkVMcjFHYm5hY3R3N2N4MWd2?=
 =?utf-8?B?b0lDb2Vrc3dvVWJKSmxxWlU1bVFuUjBuK2JMbzRUNDN6cE5GWS85OWppREJE?=
 =?utf-8?B?NmhtRDNLSW1pblJqbTNlMWhFSXdtaHhLY0pZSW1YRkVuUldtNVYyeC9nMXQx?=
 =?utf-8?B?WnFCNWMvT2owc0hQZGVXZFpTc21XZmk3OHQ1TlRTWG9KNGJVTTh1Ynhidkc3?=
 =?utf-8?B?eHBzWVZCNzdSWXp2L0xpNjJRU1NyK25vVWQxdnR6bU8ydWtxWFRyZmIxV0hx?=
 =?utf-8?B?UnpuaUk3OURqejFRNGhlOUt6bEZrN3F0aStvMEVXZjRnSDZvdEJtaCtETnZT?=
 =?utf-8?B?TVExcTVrNnRJZ2JKaVVIZUVDOGJvb2Nqc1NZa1NNOEhpcGtQVjFLd3JGUnF5?=
 =?utf-8?B?c3J4ZU01djhxdzRrTHFlTGpkRE1uamZLSEVTdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:07.6334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a8bb67-7233-4b83-c127-08dd87f84187
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400

On Tue, 29 Apr 2025 18:37:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 373 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.181-rc1-gc77e7bf5aa74
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
