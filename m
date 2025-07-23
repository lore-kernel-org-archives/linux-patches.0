Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FD028B4F8
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753270560; cv=fail; b=aNmVJ0G2uTuX9MyOTTnkniOxYwD/2u4xPESrSY4AYeyCxKEkDDj6EpK2ybNR2p+8BbhlFIUJImpT3JBDKjDL89wLAJ2slkg17NVlYGx2VBWPP6rLNGjJA5HWCqSznBWDsjUNyI0KoLqDCD1eszy2Oiaaw5YKz4aKY2dEQJ2G1bE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753270560; c=relaxed/simple;
	bh=I2ieB44M/99O+fY5XB/lbPuVKW6D/akS7+7VOm/SHn0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ApS7IO9D+5Z/jEQvLJTrzzJUc/uNobyL6x03gVFGaMSTB1YWk0U7+kFW/wzuRoc5pWnTeTPAv9+bT1B99bVTUspYzWe7Zir6xRO7G7nBvYlXbw3wxj60UIv83zrBsiz6NR6o1NHZe5XgJNEqR26bv7z4R7bA86FOQxLqOr/9jyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PKhbkQX5; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PKhbkQX5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pz7ATGPIdGlOipecmuF//8Bis17oMkDVrl353EyTAtAp8sEEbB2MVg1+ch6Im2lTfXOflyvfh8uHMNpexIlTgNzEqNnk4MOvrpTA8rGICqTa4qS9K77ubqmA06BJJ+kVTL4i4zFe6fEaWWK1MmQa7MDrMmWObNDVFWZiyIXtNsBOqI9j93oYO/xWf0FJInqm4POTMsV6ZF5rkgvrsTXdXqthpYUjMk1N2K/DsyX5UlsHCRNWUeI3Wrolk9EB08SXr8d3j7pWU7jaUUNjIV+JusDlBF8siW1Rl1UWsi3MWjo2cCoGT0w88BkGTyaDPB6JgK00jGu2XdTev5c3ZJA8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNth6tT4s+EO7b1kUMyqJjfRmJNyyLeV3OohHjyRKF4=;
 b=p8s0fqhtCwbsbR1Tq7IaNXeoLNhoh7oHjqshMQRf9IOMf4RfNpmANOe30nozUS++6CAs+gK4vYRwxRaj0cglH6xilh18MjIt5czxpD16356wsoFWHiKuGGDgtRZk5uU0ljsD6eoGRFFyHmVRxD1KEarkPxlXUIeeGV60tFmQU+gy8uD3l3Y4OkK+MVlNnYhMdQPUblQeVZrBebi5Fx77qfg4Kj3eNoTyYxFd2hiJz+o7x5+w36ewqVwY4vWpb91j3wEkZImOLMa7hAX80k96OTrM2NYyAFau398bANbg46J4umrVRh3ktMST1HidpTQbMNVKWogG4zwXzpDazsxSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNth6tT4s+EO7b1kUMyqJjfRmJNyyLeV3OohHjyRKF4=;
 b=PKhbkQX5Mi0sCvmcp3ThnGapAh1e2lnENRXUDX9v1dK/3DEK63TC1eNRvX3Zm4DZZAkTW52Z7PTpRmBcEiNCnKlQr8nKHMU5RVbOgdAgX4EMCKPuEi9Oz4Ub4lBllW74HDyFRIkwrTNgmfrTiyh4/GOXackUXJinK5gXswdPdh1juLRGBnstjmkKEC93yaxFaZ+3YHHGp84pgPHVozjSp1FOEYnod8qNIxVD4r5Jn3ulwwBq5r7l0xcBgiIBZGsfP1jM5HbP0YiYL8nDA1kR5Wu3h9p42PINlio7Y+00wSOca6ynATz0HayGeC4fsf511QmqAbk+Yf/LwrEeHPfpVw==
Received: from MW4PR03CA0161.namprd03.prod.outlook.com (2603:10b6:303:8d::16)
 by SA3PR12MB7904.namprd12.prod.outlook.com (2603:10b6:806:320::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 11:35:56 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:303:8d:cafe::8f) by MW4PR03CA0161.outlook.office365.com
 (2603:10b6:303:8d::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.23 via Frontend Transport; Wed,
 23 Jul 2025 11:35:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 11:35:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 23 Jul
 2025 04:34:57 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Jul 2025 04:34:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 23 Jul 2025 04:34:57 -0700
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
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a76969f7-6861-40b4-930f-f5fa148b5b2f@drhqmail202.nvidia.com>
Date: Wed, 23 Jul 2025 04:34:57 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|SA3PR12MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: 85835de7-bd51-4148-2fcd-08ddc9dd162f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K05pQlp2QndhNUlvemtZSTRTRDZML2lleENJL1FYTm5Rd1JWRE1NSU9xc05a?=
 =?utf-8?B?VzZuRGp3aEE4cEpGY3lKQ1hyUFNIa1dtNGM2VkErOGhaMldRUDhZaWRVYmNX?=
 =?utf-8?B?SE9Ob0VjVzVmYUJsWk4zSmpFS1k2Tmt2VldYYUttTk55c3lhd21XZ1c5SVRX?=
 =?utf-8?B?UjdYZm9xbll1L1Q5bGtTWHZ3RWh3UDM4ZUM0Nk5Qci9qektRVWlhVHdUWEFD?=
 =?utf-8?B?Z1RwZGN3U2NjN2d5MGFqVmJmSGRKZDRMWWQ0QXg1bWtmSytwL00wUGJjUmgr?=
 =?utf-8?B?RUdZUkhUQTkrRmZpOGV4QWxKb1YvVkF5cFBiWm1HYUhxNUF1RE5GZ1N3VVRG?=
 =?utf-8?B?QlhHUEJ3endmS0NQVUFaNk43eUViTHMrOTU5NXUyNTdzVHdpeWJIK0w1emEx?=
 =?utf-8?B?eGRZM0tkNDlkVTUydnE0c3VUZHpiTVRsVzVBL05INEQ0NWxUV2Y1WjRRU1Uy?=
 =?utf-8?B?YkM1NlY2eVZjTmQ3SS9Mb2lRbXphL0poWXpQY3k5Vk1xZSs2L1JkeHZyTDRV?=
 =?utf-8?B?bmZsSHR0UC9GSEZDdG51RXJMdzR6RVlsU3pTYjNhNHFBUXdETGxVRU1jV09Y?=
 =?utf-8?B?VkxXSlJNem9la24rSk1OZ1diT1A4dDlsbm5tZEEvUXRGeFF5U0dQOWluVTJT?=
 =?utf-8?B?Vk9TTVFmdXhDYUxSOEl5ZnlmNG00WXY4eDJXL2RvRGtrT1EvditKWUsydXdD?=
 =?utf-8?B?eEdqVDVOcVBUYXd2NVU2a2VQT3NmQkpxYnB3aUJwUktFbW9ibHJkQ3NMYVRU?=
 =?utf-8?B?RElhTHpocjh2dThoR0ZJbytQSzRHWWs2R1ZzdDBBV3FmdUxmbFhQek55UnZ1?=
 =?utf-8?B?cE8rS0tvM1IwV1NHWXRtOUN3Y3pmUWtqalBJN3lNNHZHZ0lXbjdjRVBZL1g3?=
 =?utf-8?B?cVpPV1NKUUhDcU1QaGlVY3ZOVDJBMitBZXVCMDhrSVU5UnFWSDlDVjRjK2FK?=
 =?utf-8?B?ZFRaM1FYRytEeTM3V044WFhuellBVExMQUhjSmR2Rm9aT05vTHJhWlhsNmxV?=
 =?utf-8?B?bDJBWmRQWG8yTXJ0RUZKQnBHcWFDbEk0Y21JU3BIUkcwRkZsSVlTbTlnb2du?=
 =?utf-8?B?Zy91QVcvRkpJNzZ5U0JtZWs5eUh4M2RxYXVpNWpyQTgyZDZ5eGtzNURIdytm?=
 =?utf-8?B?UEI5ZzR0NE1aQ2NGbHo0WHI2aFJ1aGp4Qk9HYm1ZMEpaTmhLaTV5Z0tIK3Jt?=
 =?utf-8?B?T2c4SVM5dGcwaElDcHFOblVzVWtWUUZRdDlPZDVuM2pJN2VSeVJMK2hieHZu?=
 =?utf-8?B?Uk1TZWxXNFZOVFJaaHZqdXN3Y2RHRi9DNmd3WktiV1RyWFlrbGw3cEh2ZUc2?=
 =?utf-8?B?TkZ2dXA1N25nRWpQaFBrYzM1RDBFdVVTNmZyNnpJVkl3Ris4QW82cXQvcDNI?=
 =?utf-8?B?czdGRXlsdGV1Qy9tMHdHRFA3YWhVRHZZbjhYd1J3WFFCdEVXTXhta2gvRnRM?=
 =?utf-8?B?YlI5YlFTYlVkVmhIY2x2VEVxV3RpUFpLR1dMR2FCMGNNY21xbGFjMUNVODlm?=
 =?utf-8?B?MFBlRDdNdTJnYUk5a01VSFJaY0ZYc3Z3OWl6UHExRFJZQmUvTmlRcnZIVjd4?=
 =?utf-8?B?cVJ2azdBc1Y3OC9ZWVlCOXVBblFxY2JhVTE4UjFmeHdTUVNlUUdKSVJzc0do?=
 =?utf-8?B?ZWR1NWtkdTgvSitEcXlFT0lTZEswMTVLU0lGZll2NnBrQndvTjhNNVpjOHJC?=
 =?utf-8?B?TEF3LzRSbHhicExkVUJqRm9XUnIwNHZSalY0U3BuWGdqNDIwOUpUcjcrbXNo?=
 =?utf-8?B?T0I3UDNDalBIdGp6T2FRazcrWVRaOGtGbTJ4M0EzRU5iZFJLMjJ5SHFFb1lU?=
 =?utf-8?B?VEN1c1daUTJRWkhFaHFEZWgwSUJSSzZJdVNKK0RaMnJQV2U0NVlFT2RGNVAy?=
 =?utf-8?B?NkxBN20vM0xnNzMzc1RGaGJmN1k3T3ZEaG9TdmFuK1BZZUlneWdWdzFBbG1y?=
 =?utf-8?B?UE5KSldiSkNScGxKR1p2TGVnMzVKcW9uWnN5UmdxQzg2SU9sNTNoSmRORWZa?=
 =?utf-8?B?ZWE2anVFK0JLRWw3WFFoVU9tZWJwQkg1SE9nNWxZQnc4NmNERkFZV2Z3TVE3?=
 =?utf-8?B?d01sZERvUzV1dVp3NnorRkg4UnFFWGd3Yzgvdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:35:55.2914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85835de7-bd51-4148-2fcd-08ddc9dd162f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7904

On Tue, 22 Jul 2025 15:42:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.8-rc1-g81bcc8b99854
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
