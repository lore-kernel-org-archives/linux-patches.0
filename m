Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2751C0DEA
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 18:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462164; cv=fail; b=oZnpLfsDqaNqLYgRmyxsgl8akfMYFHpAxcQ9pOhYW/A5u4WZejhbFzkKuQYHgV8N/i9cAph5AqKpPymIamk4uqIK54dX3FGnufYWBB3uLhqOum5bh/e0PJAiLVde5x+zucg4W3eCLbqleDWdinqCU0eC2THMIUtzIeONB33SemU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462164; c=relaxed/simple;
	bh=17dBu/bJ18oec0EyF0N8adrhaj6lmfZ7CqxTn0zT7gg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EYvjcmvaeykQ8q8oM2yAPpzHSzoG6OfD9p+F8yO/8rcSicf+mVDjzYbTFxiQUKyAC3x/ZYigenvzKwek0aegyyKh6FF8vaKObyeUDPafZ90IG6p6J7aYXKrXyCHLQySgW93spaiBxxbj/vCaNlmsENEfpgED9mAuz/8HahMyct4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=at6SoP5z; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="at6SoP5z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZmzlrHGtY+P7xD2O2rZnIf0SDHtgJpPjvflJ6Cd/ZcJucCHxlss4fb8rPxDJ2IjZ6kbQTcSPOQ1/cY3d3rUaIbmhqCbTGGK+lAABTkVqW9qruNO8f7+2GDneNg0j8W9REZIMnCt31aRyWHiJs539h9/PC0Sgk6vLo9WmdsoaSVrL7s/lYWB/rLPapiOi7kTxReOJERfwBlw5CZq9B7yF+Og1Du068fU3cib1rP7TdLE7eSME8dNAngn7pFlkCtS1yBu1CUtHy5xcuIYtnU3hpqmx6PFGzcveF+c2GDMJTpSNwXNrT41ObZmN7GVa3lQzA5W4oMXf5RzY1Aevn+MQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1OgkWGlWXVIGoHsqd1uRYgI5S2W58tB70DDDArbRYA=;
 b=q7/Fy0BpEbQfBuwsVtRL29qa9247/R100BW2iRfmtNbSGzEwWsviFRaPpkIp772JvsLTk/3p5lnHgQ0VbGNQd2aT0YYYccA+qEtcEbm0RA66lzSFGuWsR6+beh+iAKJNerx/mmDZHKTgXZ6xggNTzqDU5pn831h3ruQYw5qo7jMmgNwxKr7cU2HFdnDwgKlnSjDCWTY5dNC3DkrF9OKEekPUlogCPe/BaDrFKDVhWQQrbJU0hGxd+DzmqcFLHNviNEdQHx3xvEWnPoK3HBwLsm3NcZrCdPoFVzQdXTty2ruIU9vw2/tv/p3cVr2Eam7pd5aBurLSJ8pj7FZ6POQmYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1OgkWGlWXVIGoHsqd1uRYgI5S2W58tB70DDDArbRYA=;
 b=at6SoP5zaHr4ctBjEaUayDEpB2N9ekGniAJa0X2/TzFKyhrgNJHJ3pq4JSYNYBuqPmvS3m+zgL0vLjfp4UYN3vTiOOEWFHthuPyjNmgzvDE5qwkdYDt7gi0M39QRZnTiSjwx/AmIeT4W2nRQtw5Gi4ZszGzLHlfliA96FtwKXAMaoO5y5THE9fz4ls5tsIqMONKG2FjouWcAaIvaUPVS/NJ3OvOvaGhHhnd30gUwQWa9CwOHxOORo1Ukub3QPgBwpVnTXCG3ZvaVwwEryxuKr7Y0Ildw+PvaV3XMQFnOZwR3vvISbZgFUSkDJFjd1DQmfhYsiv/LfX8/Cy9md5qiug==
Received: from CH0PR04CA0009.namprd04.prod.outlook.com (2603:10b6:610:76::14)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26; Fri, 27 Sep
 2024 18:35:57 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::d4) by CH0PR04CA0009.outlook.office365.com
 (2603:10b6:610:76::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21 via Frontend
 Transport; Fri, 27 Sep 2024 18:35:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Fri, 27 Sep 2024 18:35:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:35:43 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:35:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 27 Sep 2024 11:35:41 -0700
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
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e9793705-4c56-4d06-9f02-91c7f4586296@rnnvmail204.nvidia.com>
Date: Fri, 27 Sep 2024 11:35:41 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|PH0PR12MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 925d19ce-3970-4eaa-fd29-08dcdf2339bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alM3QVNCQUhrVVk5ay9NQ2hkcHAxQ253TzFvREFlb0psMDlaZ0hEWFlKNjJB?=
 =?utf-8?B?dWF6UmszMWg2aEhOQ1VUcy83d01ISGVuc0hmYjFoRlZLQlU3ZkZ3WFhyUjRL?=
 =?utf-8?B?Rm9UNjM4eTN4T1RjK3dDNjRwN3E0OC9JZHo3VmpRTXptVXN0Mzl5T2lGTEsx?=
 =?utf-8?B?THRRSFV6RjhUU3ZWdXRoZEdDdkxoeDllVHExTlJZWVNkS2MxUGx2K3ZsTCtk?=
 =?utf-8?B?dmhDclhPQWtKYWxQejdXYlRDTjNRM3Y4NGx1WjR2ekczMVZWNDIvbGpzQkNu?=
 =?utf-8?B?OHJtb0hKTkJmSUdMcjdWSmtCaWk1N2liSCtMTS9PWUZJQituOUZmUE1maFhh?=
 =?utf-8?B?cS8yK0M3Yk13WnlKQ0RoZURlWmdabm1pV0ZybC9XVVVhbEg4T2ZKUnlvWXho?=
 =?utf-8?B?b2swME5lNFFRb212S1lHa1JxVnNLd1hLZ29BNjN1UGJVYjZhMDA2S2tNZGhp?=
 =?utf-8?B?djVRTWUwc0tDaVhodERPTFBuNTl6ZjVGbktNUlFLc1lxTTRteVh3OGNlcjlw?=
 =?utf-8?B?WG1PeEVrMndOZXdmRWdNQUxPcnA5V3F6MW51Y2wxQklKWFlNZGZQRmhwanhh?=
 =?utf-8?B?d0JXdzllNmZRRHhUdU5UN1lhNlo4amQ5MmtYbUM4RFprcjJaYzMxeFNjbkU2?=
 =?utf-8?B?SmVQSUdrWFM2V0V0WHp2Snk4YTFReHc2MUsveHgyTnNZeVFBN1BVc0tSUHN3?=
 =?utf-8?B?Y1JEeGREVVA3R3o0T0tZZDlvZjFUbUJCeTBnNkRITmFNQ2czVkNZVVYwdTRl?=
 =?utf-8?B?TXBHSjdrZVVaVUt0TlM2UEJ6b3JFeCt0NHppVXlydnRLS3VnUzZZcy9oUmhS?=
 =?utf-8?B?QkMvOUpXL1htZ3pkTXlkSmhpRDdnZGVPQk82VWtsWEUrUjZvdmNIdW1UK052?=
 =?utf-8?B?WnBWUDFiM2hsaHFqK0dRRGR1a0M3MkE0REc5ZWVIM2tIZFV3SGxmWjBvWVh1?=
 =?utf-8?B?Q1J5MVNWNXFRN0FlcVF2OWtkMDNmOC9nVjAzazZ2aWpVRi9tV3dDL2tXbTlw?=
 =?utf-8?B?eE5xYzdSWmtLaktVeU5ISWl3VnNOUUlBVHNrMmlQL1d4YjBLZWxFS0RsaW55?=
 =?utf-8?B?SXRuMXovMzNWRExadjd0MnlEZWZ4MnF0bkFISDJwV3B1TjRNTGJpMVpaOUNv?=
 =?utf-8?B?SkdRYmk0dURrbjczU1VRVndDdHNrRzcwNk10SzRmZTkzdmtHNG55M1NaeG1S?=
 =?utf-8?B?V1hlckxueU9XRkovRlVHeUJOcmd2YlIvYmpIS3VzRkFQZ0dYL0RvNTNnNmlI?=
 =?utf-8?B?eDhuYUlKUVd4UjcxTGc1Y29lZU9YR0VMTnBYSWR6L0pWcEsrQUxmbno3WUkr?=
 =?utf-8?B?aHdKS2xCTTlqcmo2eURrVDVCYmVVVGZZTVZzZnYrSTV3U3lINkhOazd1Ukhi?=
 =?utf-8?B?WHFibmJJYnhEU05idDZ1Z0ozZ1BITnFLZU5FaVJEcVpZZmp4VWhhQ1J2bDF5?=
 =?utf-8?B?OExVVElyenJqLzFvOXJCN3lvRVZRcUpiV3lCVjl6UHY5alhQd09OVkkvdHh3?=
 =?utf-8?B?dlZTUll6NkRNTTdLOFArNWpKcWMxbGRmSnlOeE9RaTc1NElVcFRVRFhBT2tD?=
 =?utf-8?B?bzBERmowVHFPeWxXSXVxV0U4aGM3L0R1ekJGS0JQdDdkUmdYZUp4N2hLckMv?=
 =?utf-8?B?YlQ1dkQ0WGNkTUVMdFR0WjlVdll4b1g4WExMS0N6NjVyMTZNWFZaL0JZeXRv?=
 =?utf-8?B?SHpOV1JtMzRkS1dEM2tVdElYcFJJWml4SFU2OUN5RWMrUnpsODd2TTVCQUlR?=
 =?utf-8?B?Q1dtWEJYRTNqSzkyY3Y4U0FJTENFZ1NSaW5YejlGMEpVdmV5Z2xYTzRLbTJ5?=
 =?utf-8?B?MkVJYy95N2IySnYxcklRMXduTmpLeFhGcjcvMG1IRUxyYjdXaTFKUU5TOVc3?=
 =?utf-8?B?dExaQXhyL2VQdnNQTUFNUExKM0R5bG83T2dUNmE1ZVVXNHNsby9IQ2QwbzhE?=
 =?utf-8?Q?1VUy5wDxYLgHVhF9NDJ4aPyPaYa1CK30?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 18:35:56.4054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 925d19ce-3970-4eaa-fd29-08dcdf2339bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864

On Fri, 27 Sep 2024 14:23:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.112-rc1-g4f910bc2b928
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
