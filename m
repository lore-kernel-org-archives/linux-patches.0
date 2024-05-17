Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C12032A
	for <patches@lists.linux.dev>; Fri, 17 May 2024 09:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938109; cv=fail; b=hLqwytPiwydflEKJOzu1wtasDcUg3WkSGvxjYtFq78PX4zc/OVnESxuW2Ap1cMePMEIAaKq5okVXoWzA64KxQfbqtq0X6BZ7yJ8xzotumLPyt99ZmBTJuaH+DaCrPPTJQVdH5IbtpqB6Wp6h0+m7Xn8lOk+jNFzdXwVNEcHRU+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938109; c=relaxed/simple;
	bh=R9Lx5AVUwQRQpzuou+aMsamXRLXasGHF7QvnC5vbKms=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UCU91xiDVMZMMBdgtkl010pYLNYY/0pEOnnbsYOgFLSHBNzUif0NAGYgWwyL4+GdB5O8/2TAUUuCeyUO9bBx6diuOuhUbLB/w7NMZMWRDXiBSN0YsaZ30NDd5ue6Zc+XU8FOZl0RrQRe77Rtr1yBVJ5+Pi3fNKkeIngkNGypu6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lOweoCZo; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lOweoCZo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFwMXGuCX+1SwigP8dYtz+Vp9KjatU2mSJJb4A6PavSRc39fsJr5QKO8ViklnR8kcTbqaHaeEO/ki0X7nJzOMQZ2TxulNoKwpx1kv/L1RGUcQeisqKRnlHg/0ncg66Gzhe//1zFwPsJpXVgFJC9x2asTud41rAijACqVTbsjjoJgZwSaWi2z3mzMzu/Cg201rMlv0+vYwLGoxTslIvG0wfvKw8ahgTieLJlywog+g4Z1zRhRbQskGM/71yYHAHNm/XxNWK1YAQRgufDJyPjJQpvy4kjL1svXng4ozXsBvBvjVwO/RwUsF9s0cNJ2y8o+BUaQxIs16CkwsX+vQApGYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vr12/Beokj5nDNtbL4BdIy821Q2bYAK75lpxlowTyKA=;
 b=mNIxNFR64sJJwmpeovVzMTquHGV8ShADXrIYQUbPVin/Hvi0THdJMp2W0isJ2PbT8T8MqgVa6wPtL20DKsu4lLeV6qxzj8BQkznwfyH/OZ0NsPFGkLZzg2WfL6b22VaJbMxIMulAcDCXRPhxb/qcSt+y60uiDJGCxTsz/ODShdFkZleIsQC4Fb4P/kUzoq2oUhhEAkk5sA6XB6e4ElerKe4cPfnOhONYnNpKqCK9iDBuuUqZY+KVNH5UJwJKAGEFhzvv7RSsI6IvNkPWyYOj6ME6/eCEbBQ6XCs08d73yl/VOIgGRBOwuhAN/8kONYooBJxxxQ5HoLIAHSRSxCHsiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vr12/Beokj5nDNtbL4BdIy821Q2bYAK75lpxlowTyKA=;
 b=lOweoCZoETPxWXs6u6rktzBe0X/bSZzchXIXjqitSAiEB5EwGqDA8qXP5oqra6GbqDyEavvPGSCY+/lDm5YZTygtOahEgpsyb6pkNbZmoSluLrBOy/gOAHBiRGjSW5Z2lfbU/fp8RHIq47JZ+7h7uayg8Y4LKwEB34ptOQLB/I3ZZtZq++uuYcNY5DoXLctVdpZTc42RVf9fwRQMhDPvEqLZvajlF2EMlSP6bgiFCYW6h7tj6+4/2ajSyqFKkcKZKfdmECs9ynplg2+H0sS7HbhPYIEOede9H0u5ThoYLq3VIdSxw5V/0BxEEpxqDSCzZraemY4q4hMndVJ+FZkERg==
Received: from BN9P221CA0014.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::19)
 by DS0PR12MB7509.namprd12.prod.outlook.com (2603:10b6:8:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Fri, 17 May
 2024 09:28:25 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:10a:cafe::e2) by BN9P221CA0014.outlook.office365.com
 (2603:10b6:408:10a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.31 via Frontend
 Transport; Fri, 17 May 2024 09:28:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Fri, 17 May 2024 09:28:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 02:28:11 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 May 2024 02:28:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 May 2024 02:28:11 -0700
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
Subject: Re: [PATCH 6.6 000/308] 6.6.31-rc3 review
In-Reply-To: <20240516121335.906510573@linuxfoundation.org>
References: <20240516121335.906510573@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7cf56eb2-865d-46a4-b639-02106a2b98ed@drhqmail203.nvidia.com>
Date: Fri, 17 May 2024 02:28:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|DS0PR12MB7509:EE_
X-MS-Office365-Filtering-Correlation-Id: c103178d-bdae-4a50-0dd0-08dc7653b3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEtNRDdIWStPbnJNYklzcEdZcmlPa2RQMzNGZThpK1Y5M3Z5ekkyb3ZtbTlQ?=
 =?utf-8?B?MmpFNWp5UjRrazZ2d2RveVp0VUhqWFF3a1duZDJBVlZlbktyZWFoVjZIWGg1?=
 =?utf-8?B?YWJObE95TkNlRzBxcG55V21EM0pCeGhDNHBPdUxkODl0ZGhqZCtxdGxRVTdu?=
 =?utf-8?B?QjJubFlqTHdwY3FBbDU4ck5MbkhrWnVxdFRNV2ZmZnhoRmNnd083dDVDakgv?=
 =?utf-8?B?Vnl0M29peDd5TG9RVkxMdG56MDZPeFlRY1lsOGdubG8wOENBT0gvUzB3anlR?=
 =?utf-8?B?QmpNVTJQUVdTa0orbHNmTlFlUkM0ZklQckg1UVVKNXVJcVV5QVUzYUtGMkV4?=
 =?utf-8?B?T20vTWRpTWJGVXhNVmt3aE02VHVsWVlrTS90NEhiQVFxL2JmNXZmNU10RnEx?=
 =?utf-8?B?akx3bEJacmJ1WVpYSEI1NzZTckNoS2JJV0NjT2VLSXQwR2ZJRDZZTVFGdnVB?=
 =?utf-8?B?WnhBR2pIR28wUGFvOGk5UzlvakNFc1dSTkUyN1JNWkQvUHowMkJFbTk3T3Fj?=
 =?utf-8?B?UGVTMnlxVUp3WjBGcCswRkF3MFpHZWprQXA1WjNmSkVQdUJjU0E4SDV4UGcy?=
 =?utf-8?B?S1AzSlJweXJURTFCS29EMlNNVzBxTWJwQlRFZTlxdElNVU5kOGNKejVDV25s?=
 =?utf-8?B?V1M2SzZXSzNTUWdEQmVMTVlhTEg1YWRMMTFSb0hqSUlxWVZlU21uYk1zK3hi?=
 =?utf-8?B?TTNTcEg0STNFMm1GUHExQWs4and4eVE5M2pzK3RsaGpEN0swOTI3eFY4akZD?=
 =?utf-8?B?VXRON1lOWEdQS3Q5VFVleTM1dk5FWWpnbUE2Z3QxWnp5emVmK3Z5VWtoSzBm?=
 =?utf-8?B?TzVKUW43ODdlK0phbEdkejZGUWtEMlBTa3dwUlZvRkZhTkg2N29CamYrQ05r?=
 =?utf-8?B?U1BEcmgvNEZvNmlxaG9PSDIvakxtcUovWU9IblMxYVFtYjNaLytFVmZUaXll?=
 =?utf-8?B?MkE3VElDL3VHTHFNOHBhNFNqMDVIa2ZKOWFMWGF2cllyZ0p2cTkvZElSc1Jz?=
 =?utf-8?B?d2xiNERMS3NiZFhOU2RndFNNeFBqaUsrS0cvM0pibXZJTU8yMHZUUFdVOVli?=
 =?utf-8?B?QU0vVXFQbWU0ZU92aVU5OXlLSEc4aVBOZDJJKzZDaklVSGt6bmpSMW8yUUVj?=
 =?utf-8?B?U3hsOGVhSnhyTXFmL2hyVy9mUDZaenBidDVSSUNSYzREU09ja0EvalhJWUV4?=
 =?utf-8?B?NEhTeGsrNzFWb3VpQXAwSllVTUI4a3JOUTFkTzF6VUdYOTBISWdTcHNLWW5D?=
 =?utf-8?B?ZytWWUNzT1A2OHF4YnkxeFVWd09EMzZLcVVWcWlYTnhRcHNMazhVdHFLT2w2?=
 =?utf-8?B?WFY1M2JZaTRGUjYwYm5JNkFKOG1ZVW54NkZhYldYRnlEZVh4V0w4TGJ5M2tn?=
 =?utf-8?B?UGJ3a09SNnhEaFRCNzdLQzNxZ1QvUVlzckJETFJDWXBiTi9ZNVRhVHp4NG9Q?=
 =?utf-8?B?SnZiaUVNelJlcEpyeXQ2YURsenJXOEJONFBKSnJiUk9DRUJraGZDK3VXN0w2?=
 =?utf-8?B?NXNXV2RQdmNYNGxHVG45aVAxMVRmNms4OVc4c0cvZFkvRmNTRnErWGIzaGs1?=
 =?utf-8?B?bE1IN0NTMnN3UXpXaURSTTFUOW44L3h0NGJXRXk1N2Qyem9CUWJ2T2lkMWRC?=
 =?utf-8?B?VlM1SUhrYmZYbk5lOVhVSzU3NFozZVFWeHJ2WjhBQkYvcVhEYmY0bUw2bDdv?=
 =?utf-8?B?WE5VQ2NpeUJ2TFoxWFVOeS9UcmY4LzczZnZEZ28yRXVIVHRUblZqWGdRUXZ6?=
 =?utf-8?B?U2d3WXZ3RjJ6Ym9iYUZvTjFULzc2V0pBRTZPU2ZUVG94cXNDbTQwTXFPQmgv?=
 =?utf-8?B?SU1RMUUxNE5Eckp6NW0vVUEwclhQTFRiazFoc1Y3Qy8zMEx6TVNMOWtNZXQx?=
 =?utf-8?Q?pZwgqbwNQi456?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 09:28:25.0338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c103178d-bdae-4a50-0dd0-08dc7653b3e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7509

On Thu, 16 May 2024 14:15:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 12:12:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.31-rc3-g2379391bdb9d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
