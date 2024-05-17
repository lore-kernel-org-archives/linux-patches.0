Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92692032A
	for <patches@lists.linux.dev>; Fri, 17 May 2024 09:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938145; cv=fail; b=MPDjfcIY18jls2xIiBC55raqxqgzEIDa2W/YnlA3IblWp8E+vGeXjNwrLHHT0SW9p+jikrQe5aS5cuzbPbWZu4gnHimxrMahojayzX1KeDnXJV7jrSgi9Ik6DAfrDPUg49+PS8Z0ZMBbxZwKnS4Rlv03LC4ofhOHdPrZK3C2qyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938145; c=relaxed/simple;
	bh=4C5gfci8n18IQIT0A/B4gQOVLnID+WLmZPsyVwnMgOA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=u3w1C6sNeZUzvldl215Te6NdXsxycNzbb5M+qDxGXMkFD6mzSqmM+kIrLuji9AZxZYG0i8bBV51iTYQIdIR17FmkCYMW7u3ueDSpp/nFygE4LLSNlZkBRn8BLkebJcxcpyUGf0EIeufq9B38Hto0hFuZu4HdQlx4G//++6ntUrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Oxe8+gfn; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Oxe8+gfn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAMs7zXMU/JYBtTzZ21LXdLKLyk6nJIyxXhJv/w7AQ0irmrT5xsFYb+Xk2o++STpBR313ZI9mm1kBY4WKQbZz4FvnNf03K7vWByMaHA7Hp8SzcD1ggOWdfqaejJcHfmCk4+VehBmEAI7cHC/CGRY7BjPJeZzlChAMITMM5cqIlwg210s4DXDIm9Pz2RCMsEruo2bLPXJlrjLGemtiDFuyJGHOHHW2VrWXbaiNFMs/kt8hVn/JNxu6LxSurTf6FQUdhgC/Fp6L7agVr7ytLPj1Q/GgVOeIY6w+ZYvwQiRMYoqaA5A6OIDxUNt4+gTqN9YNz1hdlCSed3xXxC2J41GKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Zdlwb9FKJdjEDlbtk7eBUAT3KEwed8ZFKDs0XVX6og=;
 b=m/e7HBv4r553N+VmwRfzWjMZ1JhPV//gFy4GIpn9mOi7+a8XFIbs9vrXuHnujxUtl8IUtfuUjSa+ltGmtJnIsDG5I2NF9fhcTYvQJ3/WgPtR95lTA2WzNzKXELIm64Mo+wo6aJP40mm+ayLrQblT+1NWr8RpUucnIJNZ8NI5amTYtNdu9Dvq2nTShaWRiRFVO0Or1cwSz142qWYZMf5nPEnwWsgnUqEhQpnHIPCQTkJpF7uVgjx2UzNdLdqvhrK0fGpr0O9zThzgKLcuKi0/U+6Wknw8/wVAl8D4Nvbxxf9abi6VKAQ6QwNoefmQNgVvk4p4S5Y+cXIZTt6mFEBVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zdlwb9FKJdjEDlbtk7eBUAT3KEwed8ZFKDs0XVX6og=;
 b=Oxe8+gfnAUrrfauOnazCe+7j1IK1XfqlIoUCLjl/sbJKwZZgzIuDjkbXYjVqPl+hp/73dPyW8GARLa7s9UtQ/nAJt9kHW6FBiLYfgWT78lYd3wIed1qtdFA4O3hmyRbCsDKB3jV9AuFh4GUuWrmtLt5x1gLiAVdgjw1tQ4Q5FIr80kJnj/Lezs9ZQE/z1K2omU+A4OjO6BkoT1ZsTIzQfMikcgZ7GIfRK+tcMPVqZijyxVezRpDK31UYd0l8WMhVOsi33LJqv8M8oyucIRz3Tv9rGVO93v7s5Y0cxPBXg1dho0+zJyjM6o4ysvv7pxos1ZvU+FG2WsId2okcRKuTcA==
Received: from BL1P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::8)
 by SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 09:29:00 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:208:2c5:cafe::d5) by BL1P221CA0027.outlook.office365.com
 (2603:10b6:208:2c5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Fri, 17 May 2024 09:29:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.0 via Frontend Transport; Fri, 17 May 2024 09:28:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 02:28:42 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 02:28:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 May 2024 02:28:42 -0700
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
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
References: <20240515082345.213796290@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3809cddb-961d-4ed3-99fd-6b189edea9bb@rnnvmail203.nvidia.com>
Date: Fri, 17 May 2024 02:28:42 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 578a4d20-c81c-4454-3670-08dc7653c80f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|36860700004|376005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUNCSXVpSVB5OHhyMS9aNkVqQXIvY2pUZEdoSUMwWS8yZGNLbENadWoyTFdC?=
 =?utf-8?B?S09raGhNV2ZEK2ZqQzdkaGIyY3Yxc1BGYlFkN3pVVGtrTEZOWW8ydUJsMlZ2?=
 =?utf-8?B?K2xST2JqRFVKV0dPVFVUakttTk5qMkR0bDEzdm1DVUNHdzR0OG9JdG5QK0Fa?=
 =?utf-8?B?cUgwUlBXNVVWbFdic1dCR2FjR2JTUFlPK2Y1RjlrcUVvRVYxQ2tyN3l4dUMr?=
 =?utf-8?B?UkFYTDNySXZ3VVJ4NHRZZHdidExBWnhVY05OU21ZbGNmQ1BtV3lKQ3IwYmZY?=
 =?utf-8?B?UUlaTDBITkt5MHQvM09rbWx3aW1zTUJjb3hieEpBQ1ltQzdSWmlYQmY3elRu?=
 =?utf-8?B?UkJqNlJzNUNRNmg3M3UwZjhFL2xxQlRmam9IR1JvRjdwNnAwK2o2c0prWXd0?=
 =?utf-8?B?Y1NuSWkrT0d1aTRoWWk5SHdYNDM1Wk4vdS95aGdOV1NlQVliOFhqSlNGVjNI?=
 =?utf-8?B?eWdEbmhkZ21NSldvbjQ4RkhkcEZtZzdtNHRVYVJuWlFUVHN1TENMVkFqSUkv?=
 =?utf-8?B?SGpoOWh0N2laMXNnMzlPZndRMkVyaXpYa0VOT2F4SE5NVkw3dE5zd1c5OFVy?=
 =?utf-8?B?L0lBU3JQSHZTTWpmMmtwWkFHNGpRVVZLb3FRQVo4dXR4cGhObENZZHg3dGEv?=
 =?utf-8?B?MXJHL0F4QzN6eGtMTU9XRXZ1VHV3VzBkWG1HbWNubkR4Q3BXdk9UNHB0QjRG?=
 =?utf-8?B?KzRBVCtYeHBPeEFGU2Y3NWpYK0w2NVQvbTkrOUlzQlZVaXZEeWVpL1E0dDJB?=
 =?utf-8?B?ZHY2aWI2L3lwUmNPWHRlNGprYklUejNiemJuaE81MjN2MEVYcXluakJOZ1lG?=
 =?utf-8?B?OXM5VUpWZnlZK1NuKzgyL2xSTHlUWkZWYjU5OEk0VjVEd0FEZTVTUkgvV3gv?=
 =?utf-8?B?OVNTb1JyYWFLUTNrUHBIWEk2Y0t0aEFNa2ZQOSsyUEo1N2x0SVl3bVkzM3BC?=
 =?utf-8?B?ZUdUWDNXT1R0OEJQNVk4OTkxc0dKS1VHOGpZdjhtbEx2eDV3YWtSTTcxcjhP?=
 =?utf-8?B?bnV4YlFGTS9veTNENkh4eGNPSTVQbDQ4ekk2RlAyb1l2VDdUZmRqU1p5MGpo?=
 =?utf-8?B?Uks0Q0N3UWxkZWRCVCtCT0FNWWR0YTg0OUorVVdRMGpTampHcGd6YlJ2WHor?=
 =?utf-8?B?WWY3NVVWanpHSnNIbFZ3SUpCcmdRRjMwSnhSY2JwUGJaZGFNd1lHeFh1SmhV?=
 =?utf-8?B?TEFoYWU3dElycHdBRVdyY2tVNE13UkVXckdJd3VxV3N1RFpTbUUyZmxrS2Nu?=
 =?utf-8?B?dG1idHUrRyt5RVgvRURNY2xlbVNMejZMak82Ylp3bW04TG5Wc1ZYTHF4SUhu?=
 =?utf-8?B?YlNYbkxjUVU0TEcxVFdqK0tPNWh0ZFBXVTdqS1RidU9lZGtKVXV1VExSYjlL?=
 =?utf-8?B?YmtpaHIyVDdzZXhrZUtubnhvSFBUdGtmQTBWMzc3am0yWGRCNW1iaGdUbVZ3?=
 =?utf-8?B?cVQycnRjb0ZydzVQUm9FK1VnRFZMTGwwQlZXN1JENDBXclUwWmo0Tjc3bVNQ?=
 =?utf-8?B?ZzRQcURzNWFkY3NnZFRCeVpmTjZFcnFXTTR4SFNPcERYZytDcmcycFhRN29y?=
 =?utf-8?B?MHRBR2czcXlvWjNFUE8wN1NsZHErK0R6THBxdVlrNW9HaEUwRU13dVVTamsz?=
 =?utf-8?B?bmQrYXQyRVgyd1h5V3NlaEZCZnYwM1EvSXJCTGFTaXB2d2ZvbXVFR0VGSXpw?=
 =?utf-8?B?Wm5VTjZtTnlJaEFQSlpBQ0xGOThGcWRnTVdwTFR5SUZETzZTazArWGNzcURp?=
 =?utf-8?B?UXFscklrOFV6aHJTMkVsVm9vZU90aHNua1k4ME1Lci9xRlYyS2p0Nmw0cHlC?=
 =?utf-8?B?N3pZR1RQRHNQZU5SSDNQcTljZXFzKzJMNHM3dlJoNENDWFUxNXRiQ0hnYnBU?=
 =?utf-8?Q?HcXk/IHB9mKhq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(376005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 09:28:58.8696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578a4d20-c81c-4454-3670-08dc7653c80f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912

On Wed, 15 May 2024 10:26:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.1-rc1-g17f066a7f99c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
