Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F4528A1C6
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068385; cv=fail; b=Bk3OGNs4yGRznXYBxRhYngRQPYTnq45NnoR0+CQvkwibpWAQZTh/KMbX+QfjmCkKdwcpHgkQCjbCfsTi85aPl7D2LdwhFGxckdAO3L0MhmJ1rwfpUoNx1BWkFETDGXRgJ/SmCnPsUKw8xMlwe9nBoHIiArglvJe4FL67vtY3f4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068385; c=relaxed/simple;
	bh=Pyt7UbMLN3rSIyz/tXvyyT5Jc8rH2SeguT9P5Ew5X1s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=X2/FbiT57ggWt2NimgydFRGlhvmAVsC5s7brCdJj6vXMHTWsyJNg4vnnA//htdgZNZbaCIzRGUKW1/l7FK6AdFT6YyfWFwVuzAZPhAMKmqWq7aLzZn9viZHoHq/0e2wvGDdpfItI3OloBTgtjXUErlCSuaEp3GxvaxgfiwlaRmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fsDuRr2i; arc=fail smtp.client-ip=40.107.244.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fsDuRr2i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9oSSb+/8FELO8H/n1HZTgB6KkKtOBHO3y5QQXCYl9LbuTfO6KV0OWD1EGTu1LqLVjXqXCA0kBMMyjGEvLmXlyCBLmHz5BTD3CPjAkU1TseXeE8iM/ofhbnkuaFjF7ltSoQE12RQ/RgjdEZIsI5vI2UGqUuZb+5MxMmvfqDf4ruVELH+ROzu/oyemEJY8i80Ami4w74hSReATvHW/e1IK5nKYt5pQ64pJKxGdXzAbHpZ+xqMlIYw3yIsZobi4RlvH/0FBKtQHirDR7Y+dWzHlrjR1bg3FE2PfNviddS/jE18PDfkbTme6Y1QTQ7fCoBGrrKFZB/NfvzAebRlYPgTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuHPUVif5Qs7ZVjR/LEyhVf5Vl1WcpPf8MF4LiK6lHI=;
 b=M9hbBvvwNSJzTQF4nYb0W7Bie3oQxXHE6GmZFC8yefafKA7AdY3xaOvI2OwUCPV3UZcsNqdkULeOH9Q1tS825BVBJLuc18IyeiOX0C2orIA1wQG86Npp3j4oyyfvBTDsL96MXIYYmChiipyQ6xM4vGVsr4Qvo7Ij6EGnZiYag4tFnWn29ZZcFB5DVVIHEkdtKQIaAk7tLaiVfXaVqvDorA0hx1sgQz13PkFeA+d9DwXVDqJzAVNkHXnY8Imcw6bMibPD3vfE6bgIYMdyOByBL235XsKboa8Sta/g8sXxo4a6C6MWd5Rlz2u+lSpx0kS8TfTeVCcVh/3ujV0e5VwgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuHPUVif5Qs7ZVjR/LEyhVf5Vl1WcpPf8MF4LiK6lHI=;
 b=fsDuRr2i4aYlV4I3gSWAU/LwMplI00Ag4YhwvtDRSmzvzniIrFX0tZfQ1o5222xpB4nnxBQ8C6LwLOBifFR0//Szin62fv7H1QTtzpKxfLbl2CumYEztW1RJKztJqrZ2xvjwOKBP0cBaN3EVfBRdhTB6Jdib82QCIPrLXz0megKSxmhHW1ve/qQFpTxut6nBHaDePwu3EpMR+y1/a+DBW97XXZvpWql+Uhl2Zs5THMpZh+Fkt/YQm5L/ZOoESRbVg99GIkmVfagnqVpddkpk012ccoQINpCToj4R/MEIdLeiS397us8e9G/HcMLoXm45L0233Cjo2+WnAmvKVDOSZw==
Received: from SJ0PR13CA0125.namprd13.prod.outlook.com (2603:10b6:a03:2c6::10)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 13:39:37 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::8a) by SJ0PR13CA0125.outlook.office365.com
 (2603:10b6:a03:2c6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 13:39:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.1 via Frontend Transport; Wed, 9 Jul 2025 13:39:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Jul 2025
 06:39:17 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Jul
 2025 06:39:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Jul 2025 06:39:16 -0700
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
Subject: Re: [PATCH 5.15 000/149] 5.15.187-rc3 review
In-Reply-To: <20250708183250.808640526@linuxfoundation.org>
References: <20250708183250.808640526@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <973d47f5-4c3c-471a-93ed-47f664fc965c@rnnvmail203.nvidia.com>
Date: Wed, 9 Jul 2025 06:39:16 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf47565-1ec0-424d-af45-08ddbeee0be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2ZnM3NwbGh6VXRFdVI3dVVicThyT0huRTdIMXo2RUZ4eHAyOXRTU2RXZ2x5?=
 =?utf-8?B?d1NqT0JJS1ZQMnFQS3c1R2xVdnFTVGdaU2c3Zi92ZjRpamUvREVWUUdLbkty?=
 =?utf-8?B?V0piZjFNZGFCQm13Q2JVMFQzVVFVREZRSWJvYmJsUW1OY1NFTkxsMEU5N3pX?=
 =?utf-8?B?TlJVZVRaS0NsdyszMEZlSEZBWlo3SmJyU2s2b294WjRkVStPNitGN0NTYXlF?=
 =?utf-8?B?eTRLb0dhQmhNSU9wY0FLSXJjRkxsRU1JSndwbktBMjM3SVhhMDQ0Sy9wbDlz?=
 =?utf-8?B?b3luaEZtMk41cVRXVytNckxYQWd3ZzBGV3dIcGp5emc4SFBNYnNkcDZ2OHJv?=
 =?utf-8?B?dkZXUUN5YWdXK0JHbDhycVZmRHNQT3pxYjEyMkRrK3p1RnY2Q01CMG5KREUy?=
 =?utf-8?B?b3dpWnR4TUVYNWJxREhuaHhzNGFQUGl0ekNndXphd2pDd0kwZnI5Vm5nYzJM?=
 =?utf-8?B?U1pkMDE3OWxlS2ZMWnQzempYdFNqbExpYkpJU3I0dHlMQmM3WDV5cERkdDFJ?=
 =?utf-8?B?YllyMHc5U05IOEhMSWZMaEVxaXFWYUlrcTZBVGVPVHUrZndPQk9WYktWMUNx?=
 =?utf-8?B?MUFBQjdrR2p6enpKMEVLQmx2di9EUmVpTlBuUVFocEJVWGJKdGF3NFovVEZJ?=
 =?utf-8?B?ckNJSFN1dWxuLzFKWWtYSTNGNmRMdUF1am1MWHNUeEIzWEtnd2xEMWs1LzlT?=
 =?utf-8?B?bVhKazVoaWhzU0YvdkhQL3pESkZXdnFpeGRHL2lxQUttSTArT3lTWXdaTFRn?=
 =?utf-8?B?TnM2RFpmZTlvV0hEdWhBd2l5RWkxdVg3TTUyaW1oNmFZay83dlZzYUNERTFU?=
 =?utf-8?B?Wi8xMUZIYkNIVU1LZENiSHBiSE5vZzFJMXBZa3IvSk80a0Z6Nml3cU9PbVI2?=
 =?utf-8?B?bEYzdFJkRzdobWtXWE8vRmVwTFVMdG4xVTVMeGh0NFlOakFSRjdpTW5HY0wr?=
 =?utf-8?B?TFhkdzZFclVxcFU0aGNjKzhMZyt3R1hISTA3S3JySmY0TUx1VUVybGUyWk5H?=
 =?utf-8?B?cVV0UkhHblhYU2J6czlhTDBRZEZWVGZmQ3Y2WTQweXByNTAyNEdvQlVvdmtk?=
 =?utf-8?B?cXZXa0g1VXgwOHZxVUFOV0xmRUE0alBhbmh2bHdPZm5COVA4TXZ2QjJQK05s?=
 =?utf-8?B?enUrV3NySmhGWTNqWGY2ZWVkbkUrSndhaHZHMENScUZTKy9pc0JEbHZ5Y1Fr?=
 =?utf-8?B?dzcvZ2JjTk1CN3NGSHhTRll4OFFCOVY0QjdVazFDcnhsMTI2NEVSSHpDVzhK?=
 =?utf-8?B?eUdNVHJrR2VKZUk0TGFaenlKWldJZTRNa3lHTytLRUVxbEwvT3hLc0xldU9Q?=
 =?utf-8?B?SXRjbDN6ZXZjaTN4MlVUcXBzRFVkbmhtR2Zzd2pDYTRMVVlLSWNMRkFIWWlY?=
 =?utf-8?B?MDNFTjllWGpuUmhHT3NNQnJzTWVjclVlaVJXaEVmenNra1NNTS9LSk9UNy80?=
 =?utf-8?B?WG42MlFlZUcyWEUvRWtHVnpXUTFLMDBWQ2gvRjUvSkdPWEVKeTEyNXVQU3ZD?=
 =?utf-8?B?cVlNS21LN3RPeVQ2Zi81YkIrMjJ4MVhOUld1amEvUVBCdjR3QlpLZ1g5U2hW?=
 =?utf-8?B?Q3RTeWxvWTF4eUp1OHhnMDMyenArOWI5ZzdKcVJwUWhXamhyNjNyZ3NzRXVx?=
 =?utf-8?B?SDVZRGNMQjlmbnlDZGU5VGZad2NqTkhPVDVJaWpTTHdtM1N3WVNhanlGZUtN?=
 =?utf-8?B?clFyOWh3TlIySW12UWxXdE9YbW9ERTJQeDVOTUpjUjFkY3NQZ1pySlB2T1M3?=
 =?utf-8?B?ZmVZNTl6ZXFKc21QZVJKVFFMKzkvem9pUTRvZ01jekQycHROWjJJVEI0LzQ5?=
 =?utf-8?B?bUxUTTVpbERJNmZTWWw3NWkvaEpuaXZFaEl6VTNTR3dtbnN3K0RpVmptMFFF?=
 =?utf-8?B?TUxYMEZ3U1BFNFQ3RmpnS2htcndZSlNNbUlzdzdLa1B6QSt5aHREKzBtbXF6?=
 =?utf-8?B?NFJMR0ZsQjlVRlpnK2ZyUVFaTEZXS1JzQS9SbWhsak1YeWhDcmZtSzRKNTZl?=
 =?utf-8?B?UEorZVBXdS9DRGcvUlRab25rc0o0RVJ0cytILytHVDhZc3pjWGdORWZXWFhh?=
 =?utf-8?B?dnJ1eWF5bkxDRlR4b2VhQVRJSmdmdWUzc2lJdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 13:39:36.6508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf47565-1ec0-424d-af45-08ddbeee0be1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654

On Tue, 08 Jul 2025 20:33:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 18:32:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc3.gz
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
    105 tests:	105 pass, 0 fail

Linux version:	5.15.187-rc3-g09eb951d49e5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
