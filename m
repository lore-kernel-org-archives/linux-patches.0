Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC7B2FA0C7
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761939322; cv=fail; b=o67reP+odRh4GwKirSMu41RJQEwRIghT34oY/AIeEhNKZ/b3EhgmTEINm/WSIwxGVwurL+zgO3p8im851hIR5RlaOAKvnnMbNbrRKPr/6HZKs5xD0EkIbeDmDmYDyqVMWq/m1ww5q9ulz9n6nqibbCPZ1fNJv3omQGew1qMr82k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761939322; c=relaxed/simple;
	bh=PUosNVqGXAaZ+VAV7qiWnPPLhu1AmWVbZ5GBpVLYk/c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GAu56aJzsSBBqsOSaJeUwztPUayKTtETi/tWZ3M6jmkXfRmVxNFD6SKKPw2Y+WpqeLMC4lmX/5j41VB3MYdL9D3UW6wTJ2xSkq2yFI7TWcvc2hTijBfDqmzXdoh/mX8wLPOHk19wjeQihvyZFwThqLgVN62yWluXc9BE4EI4GPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cIgy7Ng/; arc=fail smtp.client-ip=40.93.194.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cIgy7Ng/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WkVxqrQ2MTy51pdLtKd6Um1/qQz/BpA2Hn8Zbh7y62uH2cFCAHGgmSnK9Xa8YAQViA4QdRPAb6wijf03Hc4E/FAzYNM4kVp4MGLypdllcSQgrYamXPaFdkAoUvid31urdPSDckM+dXq0F4FNnahwNNEc3R4TdlgAGyyQHIpnBjKQgaRs3KleYgzX/wM9XXTbI/0LCGzhB/zi15c1LZpY9pCkzrxH9QCYVSUsTDh2WeY+74D1BJHNfynyeAZT+kXW+1QKzJDgsAXvAfjYJXaGPkyhbArTvKPvH7tQE1dIYL1t84kbtX9orfjzEi1eKlxaXzTTaFsD2zTgExa0dWaTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJYulUvE/12K28HIsP9A3xfEE558iLZIk0J7saHOWJA=;
 b=djEaiZvkBojk5Kx0oSWFuR7UAEpL1qOEHjiKfZXNMsN53y4JuZWP+dBeRgq63eQy0pqtHIdKB5myhT80kfgPEkNxZHTQJKGmO+oqzWnaAMiFE7r2OcX7f59k9ZUhkrpDfm0t6kymIPn+/PLiycwdPwbZL9rplW6acK2mIr+N8hSmADXXZ+/KqMaCpzM5PabF6/U2FgJdqSmTUJcwGgdI5AxYapctlPbelKJUty7x5KW7b9+wkHtmqRxD1B97gzgR2pB+ZBMDb4kYOgh/QL96l7Ag49tW1uoTsGzWGfejqc+Gi0hA4xaoDkCJ3V5J6rLhDBwFzbi2oA4H7wJ6a0aUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJYulUvE/12K28HIsP9A3xfEE558iLZIk0J7saHOWJA=;
 b=cIgy7Ng/89CZk3c40fBSvtiDfFSPTrWtMeoN4EQpjZv9k1tNVHJmCcZguZOdWekZOxcKyPnYkbNjmHetRCvsqg1sqyj3j3tJh8B14XsjhdFvsg0wPskH9nhbb5b6c/fezQf6jSh6tlbvUrHQSsrH+2Qjy9golwGhRFJgm08cIapcnUo6EfUeT/s0r4gaWAAkMMF3W/YPTNpx1IB9uNbOAB+UFGLL88w9dvg8qKq8z8JxIRfnrvqleqQ2qwJiGbi7fAWOVXBC0CnwDgEMZFRzGhIXJF3vpF2h0YvIJaj3DzmbzS5eUDMzTDl7lUf/49zWmPD9mKxBF+ANSwzJHFyG1w==
Received: from MN2PR20CA0044.namprd20.prod.outlook.com (2603:10b6:208:235::13)
 by BY5PR12MB4098.namprd12.prod.outlook.com (2603:10b6:a03:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Fri, 31 Oct
 2025 19:35:16 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::b5) by MN2PR20CA0044.outlook.office365.com
 (2603:10b6:208:235::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.15 via Frontend Transport; Fri,
 31 Oct 2025 19:34:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Fri, 31 Oct 2025 19:35:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 31 Oct
 2025 12:35:03 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 31 Oct 2025 12:35:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 31 Oct 2025 12:35:02 -0700
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
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <643ca2b1-b418-4273-91c4-a51987f2ef2b@drhqmail201.nvidia.com>
Date: Fri, 31 Oct 2025 12:35:02 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|BY5PR12MB4098:EE_
X-MS-Office365-Filtering-Correlation-Id: 578ce8f7-1d33-4cd9-7a6d-08de18b49e95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlJjamxkR1g1aWNnUjJjb1pNQVFNVzZRNVZlODkzZ25ZdUFmMi9GU25rcCtT?=
 =?utf-8?B?T2lTNExNYnEvUHk5T01seTdQS3ArcFRIeHdYczdCQ1krdmJ3MjV1Wm1Tb2NS?=
 =?utf-8?B?bkk1aXk4UzFZeEJwcEtESHcvK2o4Y2RLay9OWVZRSVJQVzhBZTA4S0JvSm9i?=
 =?utf-8?B?dWpzSUVyUUNNNDArNndoZWJSOW9uaDB1ZVJJMGlBZmh5RWtSR1BCMTZxL0Vi?=
 =?utf-8?B?SnY5U2lBSHF4TDM4a2dzOTFobm8zVHp1YkJjdkFNUUFwVXZDckdmSXZSdFdw?=
 =?utf-8?B?WUswa3c3RG1ZMENMOUhhcHRid01BWW5lYUJnRjNFLyt3VUdPajJhYkhjNlQv?=
 =?utf-8?B?cVBVeFdRUHgzYlgrUk5BY2FIbThKUldwUzlCb1pKN0tLeDJScmNRZ0RmME5y?=
 =?utf-8?B?bkpXaHpiVC9ROVppZTRRVUNyWnFSamtPR2hKZHF6d3J5aWpKTDFOV1l5U0t6?=
 =?utf-8?B?Q09peUZCMW92eUF3Q0RoelZla1RSMXZBUitRWHNLbjdLR0hDcVhleFRPc3Yy?=
 =?utf-8?B?UzhiMkl6ODlON2lWRGg1UkpjWVhlM0RiMnJVOXU4ZUg4MXRzVmt2VFJhS0tI?=
 =?utf-8?B?d2xnckI2YXRvNjlBNkM1Rkh5aFUwWitDL2ZvQ0s4dFZ5VzRvM3lLMDFxT3cy?=
 =?utf-8?B?UThsT2JwUEFCek8wRFJ4M3JseWI0OTdMdXpWbHV0c0dSQWpkMnU4cnVkeDRB?=
 =?utf-8?B?UDJEOVNIVHJvMUxIY1E3ZnFQUlJuclJuMVFzb25VaUNSaGdDOWpjd2l5MjEy?=
 =?utf-8?B?U1VzSzJ4Y29pdHNCVWx1SldHUkluQXpCd3lCWVF6SC9qemFMTDJacXdROFNl?=
 =?utf-8?B?dVkwd29peW5kS29TU0RaZVRBaU1HTnRPK3VTOXcvTW9vQk9ja3VsZUJiQm5p?=
 =?utf-8?B?ZzRnR0ZsNFY1cDkxUHFLUnIzVGpjR0dUSXZ6TEY1VW9KT3hTWkdnNVlQbHlr?=
 =?utf-8?B?REZhZDhSVnMwZXNNYytRR3NFd0lSemZHUnNHcVVqa0dBYUVWZ3BaelVwbVh0?=
 =?utf-8?B?eDhnRVZEcWc1bEY3K0hsVThvZXVlYmxLM3MwVm55MHpIakJ4Q3d0Q3dYdzlr?=
 =?utf-8?B?R2dBT2hyaFRjWnFPREorZm5EdTRhVlhaaERZUkE0clY4ekZka0cwQjRJUy9h?=
 =?utf-8?B?RVMwazlJaURKVVI0cGFkOU80R0xjUkZQd21YK0MzQ0ltUWplQVI0bTA3cnpJ?=
 =?utf-8?B?VCtiaFF3d1FrT2NvZk9tRTBDNGZFU3plUk9aa3BkSmRCWERzRk9RVEU5Wmt3?=
 =?utf-8?B?TlZBdGNXL0dVUWRNc3A5OE5xQzI3N2lzeU5pa1o3SFVDKzMyWjlJWjVpeEZy?=
 =?utf-8?B?SzY2NFYxK0FvS3JzYUlKaVdVdWZxMFZJSXl5MFFwdmtGS3B6YmthdlRoclZS?=
 =?utf-8?B?ZWEzRUgxRzNQWXVpQ0dQcmRvSjNCeUdpNEdYcHFlcHFPU2VFQnZUQk9NSEhn?=
 =?utf-8?B?cDM0RkJnekFGSTJpM2dEYWhVdHp5SlNVNUFmbFpXV3BPL29jaTNKVmU0QXFz?=
 =?utf-8?B?d2pHbklKdkVBOXN0Q0pma29NZlZHUHBTblVOT3oySktHdTZmQVNSYTRzeFE0?=
 =?utf-8?B?UWU5SHlTSWgzd0FPa1NiVTZ4Y0lRR3lVMG8vZytOV1RkUjhKTWxQeTRtV1F4?=
 =?utf-8?B?MENITU1RZi9ZcmtXUmt3N0ZXa2poLytZaU1WcENoODhnRWdJU1ByODl5Si91?=
 =?utf-8?B?NEZhS2hJbGV1K0dUMERXOWpRMmVsMXRKQjRJWGpTVUNJdVlOQldVcWJjUGlI?=
 =?utf-8?B?QThGU2tBbFVWZy9PbnR3SWN3b3RmeW9Qb2kzaUw3Sk9LTEF3Nm1Pb3l0OGRU?=
 =?utf-8?B?d0k0OHQxbGdYcFpwcEx5clB1QldNTkdRaytObTVYOUpQOXFtMFlnQXV3QzJ3?=
 =?utf-8?B?UVY5akx1KzlmOS9sdUs1cFA2V3lhTVI1bW9VamMwOFJNK3k2Y3Z3MFNmaFYx?=
 =?utf-8?B?RzY0VzgyWnRGL2xmSWZyYk9MN3FIUnV0elc5d2gzaGpON3lhUjNLMXloblYz?=
 =?utf-8?B?d3duTDc3NUcwR0IwcEdGMVRCaFJvMnpZaFJ3NWJiQ3ZrYW95bklibXJoSHZS?=
 =?utf-8?B?bmNIT0xuWDJBeEtkMlJudG5tUzR4Y3QvQWlCRHpIakFYbnhxenlSWEFvNnAw?=
 =?utf-8?Q?P8o8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 19:35:16.5144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578ce8f7-1d33-4cd9-7a6d-08de18b49e95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4098

On Fri, 31 Oct 2025 15:01:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
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

Linux version:	6.17.7-rc1-g7914a8bbc909
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
