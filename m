Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC1921E0A6
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795045; cv=fail; b=QZMNJRaaaFeZxnvlJ3vgga6q6nkE5JrvwKM3AyflapA+1qRZqNdEK913oJHbIDZ0gSVUJr8gP/9MnyEHOqQCvfoT8SU7MZBJnIl2C52eilB3tezqo6sNsh/lXUcDUFzkPIzmJ51vzliiVW8j1V2Kz/mqMt1LasXkTCXR/MphGpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795045; c=relaxed/simple;
	bh=+Mu93OGV4ZnxRYWz9EWMeM/zSXJoEWePeZKNOmJCWKk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bEwlVcqXrD/nxjyv0ZpCBYcm+abcM8W4voGDzKQGzJ8w4L3xElndwfxnnnlUH75JIadxRHkmV3DkYAokCKLXvwM4kI4G14N71fYPpWw9VPZkEFfS0sdUhAATOOEggYThtEhTQ3ojA9uHK/dAKdZo3Gur2/oQjHCCgfTCAofZFi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I0jF6wyO; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I0jF6wyO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENlvetW1jASlx5vsWPmRqDlRaTB2m73ZrA9XeMT8iC0WIc93FUEVnOh/3iHvWUEmmQ9m9nSLTNPmINr9rN0Fp03SFTp9Jt4WOKe2dK2e5rz9FSHfpe0ieiTe9o2NH7dMO2lTHbdMbcubLka+5zVoNivJ5m0xEsxilm29hN6zFSbIdmBgACRCi7j2Acf49iGw+zgdauxOjdk/rxWV1U/bBq/MqCy68vyaMpdxvuGwoGV9RAw2D6ITyOgT6Csjz9ddn/GWrRZf6f8XM4tjFxwC8PSTI6gRRVZVj8Juha9XpXb50EoCl+aSDp7Vg6EiZ8MfxML41O3KQPFVph/XgShWsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzW5bL9TmdVGi2+DbXx2RXNsRGh+cABZ7NPmqyN7MeI=;
 b=HyK1z84qexAjGVkkanormxdRfcpKI2KZW0VAqExNVcdnGYk+H+Fx+ujlGGGpgEiGRnW8niqdnwNVFN06NMbCBUr7icMRsjS2YPNKBCuavYF1EPYqqc5o1lKJ5DhkhdZ35nQGghT/gdQ9uAvYJBgzVw7oEsqSxw2fLka+2O4da6B6vFjhwxt51o6Bpu7zaSHyFYnOVcmQg4tcdIs+gkVscg5ndM/ZzfdrkdvykNZhEPCBV5fQH/8JMwspUdSmiFQgrYCfh3YAGvQorRQl/tZGNytxmAQPt08a+X0Qx4Efr+J6UPXYXlAuq2ZuiSPf4aGtfmyshbmTxtXT8rYeqbDAwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzW5bL9TmdVGi2+DbXx2RXNsRGh+cABZ7NPmqyN7MeI=;
 b=I0jF6wyOTV15s+ubo/KdoFfMFt3kpduZ3+6/lN08kw6JX17HWnnXbSKBBQL/PP99Oub5zmOo2X3rzNNlvnEg1oOdaPN+YuuD685+YFU5JBjGC5rC+QfQGs1k1+dcBnyLuJOXIJcuNWD8sPOz9lVejTW2wPXZqcPJtXNqJ0Lwct+Ft1S6E/fSARhGicix8kHXMmtoLLlTYNuEfcL5I96GuXGDQYEEcsXzqvOFvuYP8xkFRujzmpJY451iGweOTugJSF7SkBG/pbDLsUG5bfy8Gvuk7Ss8bVBuYWsaqOzHjpB1ISK05IduZjTPqeIAZ/VK0l6hgPU5h4Bg3tZYtstFHw==
Received: from LV3P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::10)
 by SJ2PR12MB8134.namprd12.prod.outlook.com (2603:10b6:a03:4fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Fri, 4 Apr
 2025 19:30:38 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:408:234:cafe::db) by LV3P220CA0030.outlook.office365.com
 (2603:10b6:408:234::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.27 via Frontend Transport; Fri,
 4 Apr 2025 19:30:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Fri, 4 Apr 2025 19:30:37 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Apr 2025
 12:30:18 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Apr
 2025 12:30:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Apr 2025 12:30:17 -0700
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
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <44590b02-be3a-4208-b496-1946b7c99066@rnnvmail204.nvidia.com>
Date: Fri, 4 Apr 2025 12:30:17 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|SJ2PR12MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: aae3dc84-0f3e-4c59-ddf9-08dd73af2dce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHRPYW9oNHlRQTIvZVREeEF0QTFYZWZSQUNtVm5RbGlqdFdNbVdiYUpieUI5?=
 =?utf-8?B?YytRaUJvVExXTTF0SFVJV2hzZERQMCtqRXg0SWp2NzB6Y05ST2NncU5kNm1Y?=
 =?utf-8?B?bVkyT2trVG1EdnE1SFBSL29TeWVIUEwzTEkxS0RnaHVHV052YUpnbXFpOURP?=
 =?utf-8?B?aWM1S2JIOHZPYkZ5aVlKdFJSZkVRUkRPZ3pnZU9FaVZhOG1ZNGFvTks3YmJr?=
 =?utf-8?B?bDdxblQ0Z3ZVanVYdDF0RkhKVVlPYThOOVFNQ2x3d0xpbnJ3bkcyaFhhZ29a?=
 =?utf-8?B?akFBbDZZT2xJdEwvMHJLK3MvUXo4cStpSHVEUGd4cG52b1V6NElUVjI1QTQy?=
 =?utf-8?B?OWZWTDRueVIvbVZkMGtGbkpyVWdVUU1KNnBWOWJkd2NiS0lwUFRhQkJiN0ZZ?=
 =?utf-8?B?RThVa3NHOUZrSGZlV0IvbG5nN1lGTmQ5a3lVWnQ0N2FjbmR6SnNvU1UycmFQ?=
 =?utf-8?B?YlN1SjVueVRrMk51bStQOWFzcVU4QVdMcjI5N3pBcjN4YUs5T2p1bjNMSGl2?=
 =?utf-8?B?WG1RdEEzdFArWitCc2pIeDZhMlNhVnNVMmNMNFhGUW55R1dPWHliL1lnVW9S?=
 =?utf-8?B?NHQva2RXNnRzcE9oaG9KS0pzMFlBNTVBMmt2a2RSUVdOMlIrNzBPcHdQMW1k?=
 =?utf-8?B?UnRYemdzcGFhZDdjS3cvcjJpRUFLTkp1STNvMml4NlFsUVhaUExldjFhYXpQ?=
 =?utf-8?B?VG56dW5UNkNBblZhN0Fvc1JxejJsK21rVXBLMHIzNGhxUXdwYkR0V3BXM3NK?=
 =?utf-8?B?WHVCQVRNaG1zRDdiOCtMYW45RE0xWW56diszYkpLdG9RaU5XbWFGVlBpU3hM?=
 =?utf-8?B?NWlQNTVkcVQ5Y3huWWJjVTRDTGNMSWV6dEJrU29wR0RIRDFEeUxEL3VyQUhS?=
 =?utf-8?B?VFdrbU8weVo3R3B0RHcvK0hFNllvclRUMHpvb0orcktPeldTTFZsOEVVWDhR?=
 =?utf-8?B?TXdZK25TLzVIY0RzQStyc1lFQkx6U1V6SERFN3hwQUYxUENNbXhSUnlrSHdY?=
 =?utf-8?B?UFkwUHdqK2JPR3U2V0JIajZEYXlKU3BMM2VFMmM3RDEwQW4rQjBwOWoyL0tD?=
 =?utf-8?B?NnhWb3E2amFjb294REh0Tys0Y3h0MStkdXVRdFovV3htNXVrQlJpM08zcGJD?=
 =?utf-8?B?dVVMZnFudEE3Q0lBeEVJbHBsU1hlMmltTkhIbEE1Z25LZjhNN2JvYW54ajB2?=
 =?utf-8?B?NmZ2bkxqVnhpdDNHOHE4UGRnamEzelRZbjFQaklVTUpRU2g4YjhDOG9PMjk0?=
 =?utf-8?B?eU9CNmU4aE5RQlJxNkt4dzJRM25zTk4zZlduWHUyazlVd1c2QUx5K2tYbTd4?=
 =?utf-8?B?NEVOUmxZNWltWWZjcmFCTnV5Z04vMVhZNlFIblh4N2s2b1lsZ1p4OGE4T2FT?=
 =?utf-8?B?Y2V2ZDBnK0V6MlpCZ1d2THJlSWxHS0xJOE9HM3V0eVQ4aU83cWFldHErMGNX?=
 =?utf-8?B?Mkt5dmc0UWhSVitleERWUVN0a0JmSU1xM0t5azJjVmMrdTI5MnpBN1V2OFVI?=
 =?utf-8?B?aUpNTVVBRHlJWStRM2trSE1ROGpSVnd3cmRWVGNIcExNcmpDc1N1SmtGV2hz?=
 =?utf-8?B?K2JrenRuWHFjeHJHbms3ZGVvb3ExOTk4Q2VwVGNnN1l0ejBPNlJCc0pYSS9F?=
 =?utf-8?B?SXloSVF0RG9ybE9LRXNwOXhIU3B5OHA4THY2eEtuZjJ4WHRRZ0YvMkloMGl5?=
 =?utf-8?B?amZIdVEwZmttL0U0WnJWT1V5ZUltL0Nya21FVHZuR1hyWDBLOTl2VHVidW5D?=
 =?utf-8?B?c0JJL1dMVkpwTklVcjkwaW8zNTMxd2hMV2w2b1p4UStEUi9vRUlHejlHNkxC?=
 =?utf-8?B?Tk56UGREUU9HNFcwdUhaS241TXVGbFJQVitES2FsbnNwdHM4N09iWjJtUlhX?=
 =?utf-8?B?N244Qityb2UxL0hOaWJhQTNLWitWSXB0bnFhbWZxdEdrblhoNXVHRXpadDlZ?=
 =?utf-8?B?c3kvcVc5SVdJTVhFeXlzeUZxVFlnV3UwVXZSVHhreFFURnZEMGdBUUlJbklY?=
 =?utf-8?Q?ycaGyPI04lsVL3XiHST0xTBpN5YWXQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 19:30:37.9606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aae3dc84-0f3e-4c59-ddf9-08dd73af2dce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8134

On Thu, 03 Apr 2025 16:20:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.10-rc1-g8cbfaadfa0ec
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
