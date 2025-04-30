Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C387405A
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025488; cv=fail; b=np5t7NMAGo1dOS2HLrApKgpRKET3wntZBtyotaF+qEcbQV9YuP1tuBLKRQw5JHRNbmiT5e3DqGzHLuweUGiMBPaGEsOUUoJ+tVaMhglNENRV8c7Fhz3qdgph7JAsb+XuyF7yQZLq7Rl2uQ3HZSHfqKTjY2BgaD69SbyGFwXoTso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025488; c=relaxed/simple;
	bh=HYeufuFY5lA6fap9GT3wU3KyF7z5qaGW7/2CqQFKwN8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=s08c/nt9zwNTz+xV2dckeeXZFwa2kaum+Tn495G7ML6lnnpaJ2whxk4LVq6ynaZik40PopYyQKN5uK3l3GAy7ZIMer4aYN0dd0tF0CZg7yLsknbkDUiRHdpHmTRE8VfInGQBxRjD+/pSfzpO4yN20ZABrTSOXxcquLcSPiILocw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uIuIQONa; arc=fail smtp.client-ip=40.107.244.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uIuIQONa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjXG/POHSA2H9DQ152gB0EiLk57Is7EQoz4WL5fULB0K6x5q6KbIt/xrESXriRLmJi3inapU993BebyaPyqP9M5sfYIq+s00xOyHuex6bBMDTEJLxAxp+nFrkrNawjswlTqgPWL9ONIpB/r2AlnkivqiKQGKP2ayKpcehc68MptPQT0Ey1h3ZcCLvNWFlzjLEP4kOJxTRamBs9VIUb78TZG1X0aPa70KWMt4AuNjBo9HrsM9439F+GRZwELwh014wtzbHgptFyjSmh1I37xbcx4GvHqY3vHqJHgcWU+bm2ovDnHdTyA3h8o3yRm07gMOCI1QohamAg4iexyxTBNeEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7iVzzOSCOzVby64QwsZqGBvdRPJUA2C2DTLR+U+efE=;
 b=MZId+ZVMM2mtlpG0uTOnVe2hxYQzH4gA1wqztwC9pvHPQbKLw4Oz+4j9PN5skMqrA+OTcRMzg6Rv3yxBGanU5h+vx/uZKMhntwKcGwww/lr4kjoh6AFT8rkMWEwGmRPPOH2XZLppgqgOP54GASnQpyrF+eANS9QRrOsd7BeZ9C0Q8BKthcb7oYGfOCFaGlL8NZm+lQeYsblrtOo5b9ihzhJ83Ka0FdghoiVmWOCnSaoXLF3IhETAj5k2SWsKs0NpmPdwtqVz6/v6465XLXR/f6mFgu5QYfihGgJW+wOVKm+4ZcfnJ4t4oAB1Xaa6lI5TNHGeUSKWVFIg19dNhVs+FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7iVzzOSCOzVby64QwsZqGBvdRPJUA2C2DTLR+U+efE=;
 b=uIuIQONaN59GvzSm0xTguVFfA+CV2+o1DD2/OGP+GOM5QJdwpnHSJ+kUtWySmLfer6Ycbe2yi5YMFeTCHGynGI1g6cuNDkyEgUE3bUdVF6uWLqXrZsMWUVICEradx0gV0yU4qi09pr9OxdmxK6AY9JmWUJEejmcYOGL8cVWwRvJNhP5PhhtuZThnz1VGNPklG3u1VQQfaXjROcSMqgmjCdoI4Ntn8zfeKc45qfsMSmEI5cFPn8cl9zrrqzIft1WPtmWs3LUpZW95OXH7GH0A7dJJjeYcPE2w7QBNtPLEiHOp3jrlDV75dSaW67T+jRWFD5fpnHWfZWz1t9+wShFNaQ==
Received: from MW4PR04CA0221.namprd04.prod.outlook.com (2603:10b6:303:87::16)
 by MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Wed, 30 Apr
 2025 15:04:42 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:303:87:cafe::7a) by MW4PR04CA0221.outlook.office365.com
 (2603:10b6:303:87::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Wed,
 30 Apr 2025 15:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:04:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:04:27 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:04:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:04:26 -0700
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
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7e440929-ec5c-412c-8639-01b2fa73ef63@drhqmail202.nvidia.com>
Date: Wed, 30 Apr 2025 08:04:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|MW6PR12MB8663:EE_
X-MS-Office365-Filtering-Correlation-Id: 187c7616-400d-4782-7eef-08dd87f855d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2syelFDYk5WZXBmd1kvK3d5T21XQjhWUjVGL1UwYm5mVnc1bHJ3T1R4NnI5?=
 =?utf-8?B?c3kzN2pSK2t4ZXlWb3hSZUl3LzRXeXdBVGhGc1dGRGN0VGw4akthTHR4UzR5?=
 =?utf-8?B?b042VTJNLzd2Vjl0OFRaQXVMeG1FQjJtUERrSnd6SU5Wbmphdld3S3UwNXBn?=
 =?utf-8?B?TU9qZjhmQWt5VG1GYmpvY3BSaG95dE1Sa3lKZ1JrU2w5eDB0bzRud2tsb3d0?=
 =?utf-8?B?VG4rWUVLRWRUNDFkOXFKMTN2YWVTc1VFdEJMR3h1ODBob25ZL0tZNi9wZDJ3?=
 =?utf-8?B?N1lqSDYzZVlrSDNQcDZOMVBvdFNjanNXR2ZYNFg5bDgvalBnWitYdjJZNi8y?=
 =?utf-8?B?WTV6dmRmQ01EeTkvT2s3UVc5cUdtWVNZQSsrOWljd0xOL2tWdEp5em8vL1BB?=
 =?utf-8?B?NUdzSkpIUVRNMVM3N2RqRDhCTjhIelA5RXZnMzU4bU9mWW05SzlXMzByTFh5?=
 =?utf-8?B?Vk5oNS9HcjI0OWh0aTl2ZzJYQUllbHpHZ0cvdDJYNTlmc2d3ZG84OFNJLzNv?=
 =?utf-8?B?Y0d1VGMxSzhEaWJaK0ZTb29zN1IvMkRrN2hDcFlKWnhGd25ZYWpqMVoyUkxX?=
 =?utf-8?B?WUhHYlVHaUZhdzJiTzlEcURJRUdzVzNtcSs5TmZ0anRQVXllWWd0YUltSE9p?=
 =?utf-8?B?UnFFcmg1eGV4b3pCVWJyN2tFQ3VXRUdtSmdNVEhSUGgwa0p3YU03amU3VkEr?=
 =?utf-8?B?QnloeERIcmhzbUJycVdjQ2V5Y3U2N2h0ajMwdWVQRktmQ1ZhcFV5UnZzQ1VL?=
 =?utf-8?B?MFVvbHFPN2wrai9mckdCWnlaT1lURGh4S0gvY2xCT0hRa1NSQnVBUnQ1M1Zy?=
 =?utf-8?B?YWgyTkNTTCthd1hMVU82ZjFiTFlGOXhrYzZMMXRyM3ZxT2NtNFpqZFVYb3dZ?=
 =?utf-8?B?bnM5VkE1ejJ2d2VnS1YxSzAyTXZzUjQxdnh3TGsrN3RyZmZUTjRMcnZ5VTl1?=
 =?utf-8?B?TFQ1aE8vSW82eU8yNXlYWXFNMFJ1K0RYZzRMaGg3bjRUSXRNeUNWQWdzRzlU?=
 =?utf-8?B?YjZKQVZBOW1McExCMlBSOHBpc0pOUk1EMXR6VUJuZUNCSStVM3pRdkpJdzhI?=
 =?utf-8?B?NkNlR0tUbEZubCt2NzNjanhZd1g3bi84ZE5qNWxjWC85WGJockhWc0M5OHZF?=
 =?utf-8?B?VHhMQjdQQlNWK1IzUHRDUEo5aXgwUHdBT1JmeERRejEvaXRZNCtmQWNUVXlK?=
 =?utf-8?B?ZjZnV2trZWl1WVJmWmQrK01yd1VsQ1NPYWNUM2JKVEtDWE5oalhJQkJ3a3Y2?=
 =?utf-8?B?SXBydUx4Yll6aTkrN3JIaDVLUzdQKzRDbUJBZENDQW1oK25SRWZIbTJ5VnZp?=
 =?utf-8?B?MG5JaDdzYXFTd3crWVBzTGxHSzQ2SjJ2ditTckM1OU1ZcFZBTGNubFJTM083?=
 =?utf-8?B?SzhkbmxqcHI4VG1IZ0x3UnJrTjNrSFR0dnM4eG94aEY0VVhuTk1UOGwvM2k0?=
 =?utf-8?B?ZVdISGUxOUpuYlNHc2tIRDFYb3VxVWJVMEoxL1VqWDY4WE1UWTBRTWZpVDJ4?=
 =?utf-8?B?UVhwZ3pRckV1SW5XYmlleTVDbk9nWDA0ZFc0ZXRDbzRGRXo1aTlhL0xwOWJv?=
 =?utf-8?B?eUlhMjZuNVQxNTJCQ2dTZTdKa2c0WTYyQ2t3NGpEcW9Sd0ZQcDZZUjI0RVlx?=
 =?utf-8?B?MjNUVkptZTBBV05JNXhkcUF1US8yTVpqZXF0MmZwVEdUOW1XTHVlWVAxVWlU?=
 =?utf-8?B?VHdPWHdzOGxsbkdVV2NIVDJRWUVPOUhaeS9LSGFLL21wMy9aYTNMZXVjVGo5?=
 =?utf-8?B?NXVjSnEyNDRGTWtDd3UzaU1LdGZZY1RLY2ExVDZWNWJHMCtFQ3R6ZWk2T1B1?=
 =?utf-8?B?bnYrK21oMWVaeDNYU0Izazh5UE1pUzE2ZXJMUjlPaFNVdmFRZndVUGttUTJC?=
 =?utf-8?B?dEMxZTRPK1lPV0svWDVEcXUzK2hLd3lFalV0MDZvWXJYTGprUzVHL0YySC9k?=
 =?utf-8?B?cTFhQUhOQ3NrTXUrTVpTUWVNMHRuMGx6UHdGSHp1eS9OZkt2cVkyZnErU0dX?=
 =?utf-8?B?c2JWaW1tdnlPZUw5RTZvQWNGMkVFTXdRdVRjeEorRzVuT04rTlVzU1BnSkF1?=
 =?utf-8?B?S3E1WGxmbE5JNnh6bUdhYmRpRWpMRllZVnNYQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:41.6753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 187c7616-400d-4782-7eef-08dd87f855d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8663

On Tue, 29 Apr 2025 18:39:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.26-rc1-g990f4938689a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
