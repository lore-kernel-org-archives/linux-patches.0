Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A1817C7B6
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013879; cv=fail; b=mF4l/MT6FJtNevXC5E7kU7VHpseFSN496s1RJ7Rl7rduO9k/7vEmD/IJfQG0zXxk9TKLjDUeuDjqxnAkvN2Je805/Z3WE/ffpO8ADYFCb90MeSdw1NYFqg4IszY9fI5eiBQZHrnJmkGjMcvCRxz1pjkr5AUBTg6zHJ2TzO0xj9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013879; c=relaxed/simple;
	bh=FkG61ohKZeAFsiuhXPCDpSlwG7B33h/3OEg1fRxa2UU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CfixjPEbTgX2Yv61mBDVRkg5QFm5pY9r74xCvr1bEW3okiQtYHPNMqjjEbOw1WRGvL0YgAyIbKEWG2PT7HLoZJiPRyICxno2NHFeb5m6iid6EyGy7zjtqMfybO78oY44znobdAZzTPSEJALJvSHN7nQF4hGmk7E+rK7QOXY7lbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UBMPID/z; arc=fail smtp.client-ip=40.107.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UBMPID/z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jo0ADxIBsKUDKfIB9H2gyWkK1HjKb968/6wETRq5wqit1+kdQ1la/ZTuisJXdEF9uH1I1J/CYvZD5+0wmDzhsLu6u8Erl2vdH8OOyuEwmxCP0CctK2ebrbTXfBUEpE2GovR+UArNXWomeuh0/jthKo5ggV85oWfvPM/gC4JuX7kl/Sz5Xkp0kN2+YhlIhIqQ6QVROADKttPqHzmLFSw+oeE4m5FeaK9WWFwLXDd8kU12usw2lLeWBRJEtphSdjU6qqTWC5lKKmIJjj6It03NB2qQZvxdSCIYSqrc1ooMm2q3E4YnArQfWqoBX3DBH43CzpnZb/HOq5Y4YtqnaSXEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAT1oMadbNKMZnywBmgvZfzTOwSBgekLZhTXnLgWvVA=;
 b=V8XqkXhnE/T9Fi7N4RFL0oTx1tA0EUfZW1piURN/YYPpmqmwGOT+wtEe9JwecatBJF0jzq0YtgGWo5bBqbjICyzoxDxVUQ5dYxM74AdIbwP94don5X3rX3XsGsUg1CCAnHnBlK5Pn7Kya4Kqbs1enE3zk1Gh00XeVSMRa3B4s47wlYbVJj8r6WQTGOdxhdVs6pZ0Q/lVTvhFA9cBq1JYpxtlFrla0lDIM8qgCCAIaj9sQ0rmJuLa1QlEVgT9ozePDcVdZYNbzPIRqMU+WDqFlkJ4wQMIAx8oBuFbeneCtaxFWpgjhlvdVIT2VW9+vZrzbhzu1LLt7Rxjxp2+lEyoiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAT1oMadbNKMZnywBmgvZfzTOwSBgekLZhTXnLgWvVA=;
 b=UBMPID/zHr2Syq89oWIEo7TIWpPk+SKA1NCVFqbU005rqKFYP1rBCyPkhbUQBH4OQqQfdfEFxnzdAARU54pP8qkLCpyuI7jlZK8j3l6rMq7BlG8Gqx30XwINh7+TF6QDUKrX+m71NZoiqoTg6mzROVaFh8slV+CVzjfldMevsQvlDie70RYNz+SOxyY4vZzDEb9Ks2/4L1EPiwM6nUcQQrUnj9MatrLlYW2REKlghG1H5u2XCx96DgisAnuRC+ayM1UKUWDjNxKmw1ACAP2WOIBrH3Qr8/km9v3AhD/nqSna4c/WB0XQba3Iih6TPx6mvq2/ysN1t6uVkSr1Fju1CA==
Received: from BYAPR06CA0035.namprd06.prod.outlook.com (2603:10b6:a03:d4::48)
 by SJ0PR12MB7067.namprd12.prod.outlook.com (2603:10b6:a03:4ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Fri, 26 Jul
 2024 17:11:13 +0000
Received: from MWH0EPF000971E6.namprd02.prod.outlook.com
 (2603:10b6:a03:d4:cafe::89) by BYAPR06CA0035.outlook.office365.com
 (2603:10b6:a03:d4::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16 via Frontend
 Transport; Fri, 26 Jul 2024 17:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E6.mail.protection.outlook.com (10.167.243.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:11:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:10:57 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:10:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:10:56 -0700
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
Subject: Re: [PATCH 5.4 00/44] 5.4.281-rc2 review
In-Reply-To: <20240726070548.312552217@linuxfoundation.org>
References: <20240726070548.312552217@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <61a0c03e-454e-48d9-8d81-3e68fc2b0182@rnnvmail202.nvidia.com>
Date: Fri, 26 Jul 2024 10:10:56 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E6:EE_|SJ0PR12MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a79492-56fc-4e60-1223-08dcad95f3b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjZuRFlheFBOSFhCNk9qY053enVveEVVam83cHViY256Nkw3VUdiRHFlWDEz?=
 =?utf-8?B?alJYMWgvNXNSRk9sTFdTeWRSdENCV3VQS3REOXI3VWQ5MzZlMXdyaHZqZ0Jq?=
 =?utf-8?B?M1piMUZTcjlQSnV3aEdEZWh4RFhjWk9OK3AwZjAvVWxBRVdkL3MyOFNPZjBm?=
 =?utf-8?B?Q0JRVS8zVys4L082d1RzLzVLSWpnRzRlcnhkSWkwaFVmaUw1SURpcnVTa1lE?=
 =?utf-8?B?NmIxaVJxbFlTYzJyTE9VZDRBemQyOHFSWGt1Q0FjWHNaa2VxZno0QjN5T2Vq?=
 =?utf-8?B?R3piVVpqQ3RtdVhoUlZUWnNabjREM2hsSDRHamRhd3F1YjZsclVEZW5XVGxu?=
 =?utf-8?B?U3k5K2o5T3lPNGZrc25adVhhL21aU1NQdlliYTNLWHJ0c0Z2WC94VkJINncr?=
 =?utf-8?B?M1JGMXJ6UU9acnJBczU0cnhLV29yRWQ2QlA3ZlM0SWZucU0zS0loTnp4K0c3?=
 =?utf-8?B?bnI0TXRrNG05MFFxOHBnS2ljc0todGhvWjVncFo0aCtVTHNQclVQakZmU0My?=
 =?utf-8?B?VXhVS0RUdnhDcHRDSkpmZkY5elp5ZkF4S2VtV1ltLzV2VGVOdWdpT0pialpM?=
 =?utf-8?B?S05HU0Exd1VhRzNZRFJQcUQxLysrbDJkTDVod0JabDd4cUc5K29FNW5JOC9D?=
 =?utf-8?B?cmpFbFdad1R3dFJncENDVnNwN2ZPcnJIWkd4RFdMSlB4VzE3UjlaM01xaURD?=
 =?utf-8?B?a1dRNmVRazBqY3lkWHd4eXNXa1dNSjJGL09kSTg3ZTV6eVdIY2FLbkgyZEgr?=
 =?utf-8?B?QUFqeVByWDFlODg1QmZGR1drVlJqMEpDZUJsaThQallhZmxIaFRSQU1QYlB4?=
 =?utf-8?B?emxaR0ZmYkdBRWtrVE1GMjR2N2Jrak9BeUprY2ROOTNlOXdMSGZQM3IrNlN2?=
 =?utf-8?B?dGpYaS84QyswQjhIMS92Y3EzbnVkdTdOMS9Pbm5vVmxzM1BTNGNuSGJoTlFL?=
 =?utf-8?B?TlBEcTlCanF4SUJCb1hOcDNCMW5CWE5vdDFWV2ZzL2tlaHRnM0s5NERIek1X?=
 =?utf-8?B?SWJyVFF6djlpc1BTSEFaUGQyeVBtbUFvNFNqNHRWYjdoQWtqbm92MkRlbWx5?=
 =?utf-8?B?amJHbDIwa21OdUN2dWh5bGhtZllacXJFL1A3ak9yczdnS2htVWRKRkhPUmFq?=
 =?utf-8?B?Zk1EMSsvV0JjQzNtdGxJTUsyOTBwdVVvVDlweWRDWmxucU53Q2FmTDJmaFdi?=
 =?utf-8?B?UXorQ2VEL1h1MGpPV0pSTEFoQkMzQVpaN1JHRGlrZlJwYURDQUVjQlBzUnN4?=
 =?utf-8?B?RlBpR2NmbkxIRVBxZjU4STI2ZldHbmFOMjJheTFLV2FjZnp3ZWxSUWJFWThF?=
 =?utf-8?B?OHZpb2lCRHlOZjR5ai9YbEpNSVhDQ2tGWWJ0MEtSakk0TWgzL2Exd0VrL3JE?=
 =?utf-8?B?bWxwdXpOYzhHZW0yZjBOdmFKMStGUCtZZFJXVHYwckNhUis0MWRYNFVjYm9B?=
 =?utf-8?B?R01ESmVTOGJCR290cDFNSkxzTW9EWnJwNEdYalY0Z3IrTEMvcGVHaDJ5Um95?=
 =?utf-8?B?YTNIbGhiOWFCNHl1VktzaVZUY0pRLzUxdncwVWFXOTNtelprZkwxem5ZUkhY?=
 =?utf-8?B?eWN5bHVkMFNybm9hRDRPTVo2bEo1Wm44ak5CazlNZm1TWkNUQnhDcEpXd3lE?=
 =?utf-8?B?NUpLU0dVczBVSXQ2WWU0V2MxOGVoUzhrU3V1bVZ0WEsrZzduMFZISVY3b0R0?=
 =?utf-8?B?TDVsbmlIRjBldkJQTTllUEp0ZWFlTmNHOWVpVGd4UmZleFlnaCtUM1hvM00y?=
 =?utf-8?B?eklRQkJ4MnRzMHpmbWVjZlltL1k4UnA5dTJVdDJDZ3Rlai9lblhFWGl5Zitw?=
 =?utf-8?B?QkNHY1hFdTFKK2IrbXhHdW1qTUMwRTNVdkc2ZmhSeW5NL0RLRzVRNWZSTVRk?=
 =?utf-8?B?Uk90YmFNYWc1eVhESU1VWjFSRm9qdU5Kdmdzc0VGcEZjdzQzbE80S0JPYTlW?=
 =?utf-8?Q?lXbAKAFdClhT6U6wCuh/YqBitS8cTpzy?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:11:12.8955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a79492-56fc-4e60-1223-08dcad95f3b7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7067

On Fri, 26 Jul 2024 09:13:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 28 Jul 2024 07:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.281-rc2.gz
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

Linux version:	5.4.281-rc2-g6b3558150cc1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
