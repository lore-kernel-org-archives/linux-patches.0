Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF281586D0
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718826739; cv=fail; b=ZA+KBaOWwO9VsQqkmG1VhPZR/pSWMYlte7l13JGwBXLiCaXqPqNBawtA4rPzE+tLxba6jOPgwMSD7bC8WG465ixDc5J3n4jWjrHOyohq0cuiRxtcuj5F5/SRfJ3RCuyGQfqcjgFzq9PYiInfcpj2h9P6luTwQxRxZXQ3j5tXL10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718826739; c=relaxed/simple;
	bh=ahOMJZi7SIcizNcGuUQgqJV6BshjaoXGGC7LEq3aC1g=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=r2dHN4LtMcuMqlffjuLOF4nR0xkzKExQoqhm3PM06r+ImvjY3snwrUkEcivOGtGp916qK9CYd408FIX3BCjHCMi3j3HZ4CWh2r39tOxDG+e8IyjiY+V7B7usD+iDCzJlt6hvRRYLzALzib1JpQcqLFBF62tDnrwHikGLqIXHQS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=knQ4dHY1; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="knQ4dHY1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff0jN/DVAniCWIwP+/cTsfoj4uaLTJyHuuMXpeLHHCcWgmOua8nlF0FdJ7usbI66kIXoQb+wYDVcaXWrMj4CQ/PqvB5eHaTGPtR/tIA0rM2g0S3StqxsJCUGdrXRaJ4+MRHZUNTcGTlcHgVzibzFcsU6gjtzAHwsTIiLv1mQTfh6fVuJs6R8E5oJGJiH0O3KlxTk7LnTEn3MwdXINaKRdS86BANs61qQWWtr4MUIoCYgEklzwwTfdHCUh1+jRhAwnV09ezaAt8paa+43IejbRKMCtbDTIIR+Mx5i0hE5735nZn98BTnZvBdtKmveAooS+eozbWDkBnHsdG3cE2xrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct3OSQAA7GZ9lF0gsCXcGyjPmSqWwWJumwvklsUX1cc=;
 b=ftCNULE0qqZJZ9RoITDpGMi6RNyNExt2ZAxLtmXm76Pzg+k58/u5uCw1/1cZQ067fd0p7SMOZZkZ5Xv+7CaJwbwb9ZYlkzizkWscd5phwe1sUAYQ3mr7S+1HN3Yb0/F0Csj22LirRHHi2YTo+ujO8qbUiLTtvdohluxpLcQx5PS/AbGLFn1mQt/DTMBHLn6GSlLwW2hKsmiPJAOLS3xgLGlgynQB6GGmthTYJ0JCnwJ5tHCL4mb+jPdEuXU8OCUb7QIllNbNswsgk5KtOk9KV0Mw6vxJns50cGSs2cWyPOak43vZjX4zpn1Ll3/WS2X3zPtDWWDaVXunGzy4QpRMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ct3OSQAA7GZ9lF0gsCXcGyjPmSqWwWJumwvklsUX1cc=;
 b=knQ4dHY1iVpFbu8u9hbGddgS5Ax8uWwiZO59QjnSpJeAN7IWQAO3fVeVauMe9nfLSx2xXN9tuJFkbBcJZfP3KrSIcNaVS72SqjX/FgUkViuX0784SJYipqiojxw2OUZCEGY+vsth2mMPTkF1/DUy48W6KMrZRaXC+dhZl9ctQI8V5dWON2icwuoi5Tfckux7BLH9L9T8N2z+LqeE6NjNFGWw6TAoVOd0utXx/Sq/dTPmdjVfz1Uay660Mj6jXFLFIbftHhfI3lRcN9cPBtCDOjlfCpFprhKABuAruPz9ztaoZJCslkE2gZp063HRTiZN7MF4XgBur0Ez43JNWGBd5g==
Received: from CH0PR04CA0055.namprd04.prod.outlook.com (2603:10b6:610:77::30)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 19:52:11 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::7a) by CH0PR04CA0055.outlook.office365.com
 (2603:10b6:610:77::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.33 via Frontend
 Transport; Wed, 19 Jun 2024 19:52:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 19 Jun 2024 19:52:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Jun
 2024 12:52:09 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 19 Jun 2024 12:52:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 19 Jun 2024 12:52:09 -0700
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
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <12533d02-fa0e-43fa-bf8b-7112d62f164c@drhqmail203.nvidia.com>
Date: Wed, 19 Jun 2024 12:52:09 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: bd25c84d-2ea6-4721-321c-08dc90994f8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|376011|36860700010|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmhrZEhuenFBd1B1NE9uUVpRbzBmSFlpbnRtMzYvUU5CZ1dWRnk0WGFmdnNh?=
 =?utf-8?B?b0RkalJrTjZTY0xMWFFJL29nTHFTa01TQjdFZmExQmlob1hkemZXSGo1a0xu?=
 =?utf-8?B?elVkNWpuYTlCRzBYN0ZrejZWa0E4S0xsdm9GL0xyTlN2dHVBTWp5RU5yQ1F3?=
 =?utf-8?B?amxGYW9MZVA5TzQrSzEwbGdkSU80bTZhVW42RVV2V25ydjN6eTVYRW04U29L?=
 =?utf-8?B?ZC9hUXlBb092UXU2QXpOWU9URWlTVHhJSGlBSy9OQ25mdGQ4MkVXOGRVelZ1?=
 =?utf-8?B?dThRVElJeHJxdFRLdlpPL0xJWUNENjYwNngzVzkxR1p2YjlEd0VqMUtNNnRK?=
 =?utf-8?B?NUErSWY5di8zMjVNekdSb1BoWVJGbHZaR3JpN3drbUF3Mk9NUUQwTC84Ukkx?=
 =?utf-8?B?ZXJEZVpWUWxYWXBIZyt6UXVwc0oyNmhWOU45akRVemEyRlhKSVFyMFY3TXFN?=
 =?utf-8?B?SHVqbVY4NDVuajkyWG41QWNmbTNVR1J5NjkyRWxpMDRnQVVyN1FZQ0toQlRm?=
 =?utf-8?B?OEZZTEk3ekN0V3hWQ0Z2a0NrRUYzNjBUUXpablRSNHRiaWx3OGtPTGtiTGY5?=
 =?utf-8?B?cSt1dXpkT2JBakZybW1haldqakxPVHZtQ1FDREpDM2UwWTU0TEp5VXo5NGxM?=
 =?utf-8?B?WGxURjlFVmxGczM0Z2ZXWXlOTnh4NEdHV3VXN3FVY09EMGh6Z2JibnNOQzQ0?=
 =?utf-8?B?Kzl2OFVndVRJSkhIS0NjcmRQOHhkRXN2NUNRWU9BNFlvWVI3NjIyem44aVVR?=
 =?utf-8?B?WkNZN3BFS01uWGpSZXZoOXh1NzJmVFgwbE9pbVd4aC9IRnJmRGEwOGdHa21Q?=
 =?utf-8?B?RTdUYnBoeUhyQ0J4cTZrQWFLYmlUajk1WjZtTEZjYVNEaG1Oazk5aG1oM3pr?=
 =?utf-8?B?OThBMC8vNWRoR0RsZlJqMnNMNExXTnJCZU9CUTNFZUZpYStQcmVMaThZQUFR?=
 =?utf-8?B?OHFSMlN2RnBOa3hQczg3T1BmVWxHSEJITjFabnZnUHhFTGlSaGZTV3p2b3dU?=
 =?utf-8?B?WGwyL3I0SlJsOWt0dENlcE1YN2dJWDV2aDZJYzVyUExSOXV0OTBwM2ZhNkhr?=
 =?utf-8?B?dWdUK3ZXbk54UFZLQW14c2JBU2FBaWZhVVJERi8wRnBoQTJMMWs1bEYzT1VY?=
 =?utf-8?B?aUpvWVp1cXlJYkk1NkYwbkw1dExndlNhZU9xV0Foc1FRa1Rwa0czU1h2Q3VY?=
 =?utf-8?B?UmU5NGFBa3ozc05QTmc4K05xR0Uwa3JBSVZ0UTZ2N1NnTnFGbzRvOXBXeHdJ?=
 =?utf-8?B?UUN1QXpJdmlIb0Z3UXo1eEFPUzhVdjU1eEsxSVNya3NaU0FNVFZCeW5HVDYr?=
 =?utf-8?B?NlQybUFUeUtGdlFJRitaNXdtL3hxVWdOT3UrSDNmQ1J2WHhuTDVmUlpCM1dE?=
 =?utf-8?B?RFVQbHFWMXpEelgxcUVMUEc1bFNIMXFZWWlMa1gvWC9OUXdNZzVZV1NIT2Vv?=
 =?utf-8?B?cHN3YmlJbE9JQjhlVHdKeno5dWdxWTY1MTdBQjRZU2diU1hSaXlBeXNaRDA4?=
 =?utf-8?B?VzlLRk5OTkdFWjRTQWF5d0VVTnRJbHdEY2NJOUd5NmNBb0crVlhVZSsySG9w?=
 =?utf-8?B?dFlZb0lnbXU3bHRNdDJYWHZZUSs1aFN4WHFtMW1ZM29ERW1zdXJFTEh5d1lT?=
 =?utf-8?B?V0pUSW1IUTdoTnJiaktmRlduamFxUGtieVFJbFBrTzg3b1I2RWJCUDMxUTRp?=
 =?utf-8?B?TTJ2VDdtLzQxWXhiWlZnQi85d2ZyL0N1WnZRUEpyS1dSRXFydHBtOUFiZE1O?=
 =?utf-8?B?WEd6TStNOWl0RjZLMUZoMVBHWm5iYmZXUFdlYnlMZ2RXQkpIMjVWR3FTRGVP?=
 =?utf-8?B?RnJFalhXdGhGb3F4SUh5Y1djQWlWeEFrM2k0MXN6WDlQMnpHL2w1RnlJd0Fr?=
 =?utf-8?B?ZXlBbzkxdzk3RWhSa3pyc3pjVDU0eG0wSGtmd0MyWDVXYWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230037)(7416011)(376011)(36860700010)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 19:52:11.7254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd25c84d-2ea6-4721-321c-08dc90994f8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909

On Wed, 19 Jun 2024 14:54:03 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.95-rc1-g0891d95b9db3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
