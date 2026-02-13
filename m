Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1397D27FB18
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 19:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010484; cv=fail; b=eVGSWAaU1FJ/DiiUnQ9jkdQ3SFz0W92wp1FIuhD8RgTQpRVFwrgWAM9u1yxohRsWZjmflYZR7TJ7hgnAT1qI9bfqhZebSbJAB/hbGpzc6vU3Ct6aNbfyiJMNM+spkNvm6TqhS8RjodFCsAqsHBBlth6RmBt3c7P7MT8IpenLM6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010484; c=relaxed/simple;
	bh=zS5uAB4s/7HmEYYu2AlGPkuomo94A5TzWWpaiiJQdHY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=iAtSDUDuZIG+E9QbDw+64fXQWMBvQ+h/AE9fllpLHnEdn6T94PwfH/0X3FbL/tnEvChKojWHezlhjfne9+FBze0KU7imsEiLEkUIARL+7vhIbWzBiU49RrSKsGr/drp2LgLddLSCJZuiXMOBya2uUYiOzpg+AVJl7kZ6OVEnfUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nIjyaDFk; arc=fail smtp.client-ip=52.101.85.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nIjyaDFk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YU3nKDST08dYsPKqlVek334eorVpD+54euXrQ/D6zaxzfVoF5kfWtBsAKv7lmdW1TncHT3aPFWvDtJ3MHzZSLittUGfB0vmSvY5rf9rkCIHOoEocC02aBPSlqDhF8vzQhQCqT1diUXIBSdk7/x6HDCSpFmXLt9AkfXQdTxbhQi13Ppue38paBsizHea8uptolTedjkiDWlWTrcwxraRJlFEioNH/sN+3Q8/mh8xoelBjeH/J9ZPSGg3AQ2/PHRkF9AB+y8AbEECOuADYYDvMnw0FtkFgTF4h3lIq35UmPNzEtGWwykR14+KTTuXWPf1OnBp8M2goY2SzDul09y2FoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQbslmJuQEPNLRNKxc8MVIhaLvTuMy//x1DaZTOrSSs=;
 b=oDR7mC1kWWr0qdq0jC2pdBFD/SlJyDY50doCdDQvCmo/NjefJIh1PoiuH97pja4mJ8oAb7yCaTVqbOkC9mbET2QET6MyP2zATR+pnj0/uZydIGOM2rHtg8xOu8LV7Ck0I5mjeePwzGlJHi6ft6+9B0Q5u8Dby1RJYMPEqHrPdbmyJ0Wkjg88dHkiiNA0JsBOhPSCI5SN0HL2OiLj4eiJvVBxyOJxEGGzeFbVjW/HdjcMzHKgjAwjQjKwkWLknPmXMiJc7TkgRJsK9ZwJ0clebECd9vofIpdFC7zJVfhS7tFLRLr97tUMaD8YsKVQPMh8oBC4Nu68anctKnDqQlK47w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQbslmJuQEPNLRNKxc8MVIhaLvTuMy//x1DaZTOrSSs=;
 b=nIjyaDFk8x7E4o3mwStzNmAY6cBOexrA2auNaTyo9m+ZWYRThStU+xPVqCByDwOG3Y5pQf/+DO71Rnckq+F8+vZ/RSoj+RTlTfzFNpjpfzVisKUocDxTm3ygnld2aEYM0P/DNyesKTYjC5adpx7/sGeEVhzGf3BOKFdzHmEvJW+jIS0GpEKPgqVrWUAacx90Fb4yuRNGbAexSBh0oLTBNTCPs3MMM1wliGEnWIucnoRpViVVZMCSzbvMOBrxmrwlE++Dz1abCTODT8lCIZAsSww5RjmFOrl5yG3zek8K8nldDs/YdDWi0LAlvELx6zv0mIor589nRZN9DgiX84+M1Q==
Received: from SJ0PR03CA0108.namprd03.prod.outlook.com (2603:10b6:a03:333::23)
 by MN0PR12MB5833.namprd12.prod.outlook.com (2603:10b6:208:378::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 19:21:13 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:333:cafe::8) by SJ0PR03CA0108.outlook.office365.com
 (2603:10b6:a03:333::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Fri,
 13 Feb 2026 19:20:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 19:21:12 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 11:20:57 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 13 Feb 2026 11:20:56 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 11:20:56 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bb1d1e82-a4c9-45ee-8972-dbc7b61d38d7@drhqmail201.nvidia.com>
Date: Fri, 13 Feb 2026 11:20:56 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|MN0PR12MB5833:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e25a6aa-d881-4a71-862d-08de6b350ceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1QrdkRSRWJ3Z3Fiei9wUjNXVHk0dGJKckhKcXhQM0pIRjVlTUI1V3VzbW9J?=
 =?utf-8?B?TmFKUGNrSXFNZnFhUmswYzYvTndUakMxV1JYcDBIY3Q2SUxlM2huSXVCRGtT?=
 =?utf-8?B?T3FEWWc4LzhtOGdpU3pDdDZzYk1VdmRaYUwwVW00K3MwMlN1WGRMbHlrVzl2?=
 =?utf-8?B?U09lZDdvNGFhZElTSnNTQW8wUnk3WHZvM09Bb0lUanUzZWdDSXhxMWN3dFlF?=
 =?utf-8?B?TVJ3cGIxWTJOWm1acWhXVEkvSjhIdTM2QVNPMjNiOWdEQU9oTE5OcU03cGZh?=
 =?utf-8?B?STJ5dkZGejNTT1ZpVDRtZmZYMS9mNWpHVXVacWU1TFYvQzJ2aXJucE9xWUJp?=
 =?utf-8?B?VExSWjhvM0w4YXRpMmYrcHYvSWNqRGNVSy8rVzNtbXhsd2Y3NTFrcE4xc0tT?=
 =?utf-8?B?TmdjNnZyQllFdjNWWWQzRkIxclh4dUQ2eVlneUZMeVRHMi9xWjEzK2RRWG5j?=
 =?utf-8?B?MUJqR0FGUmw3Vjl4cDQ0ZnNPckRYRWQraE1haDBFWHdMdzFnZ0p1cnI5aytZ?=
 =?utf-8?B?NUtNNnZBSTdBTjJvN1MvQUtvbWhEaE9UL2hRTjNJYzBvRXBlUG5HSm5qNmls?=
 =?utf-8?B?YzNwS3UwaCtQWERNRUZ1L2dvQUZoLytFelR6dEZ4QnFlcVhNUllhSGdpNnIr?=
 =?utf-8?B?MHpmOFBZZU12YjgyWnZ4QTQwdmE0czJsQnFORVBJMy9zLzBRQklOZmI5OGFS?=
 =?utf-8?B?Y3c0M2h3b080NnoyT2RnN0ZyeW9aVjFUUFo1YitzMVJjZ3RQMSt6SHRPdHBI?=
 =?utf-8?B?UWRkeU1FdTVodEs2SXNlVStyd3dEQitBRHBVNWV0UUxMcGpGTitCSmVsTlVk?=
 =?utf-8?B?UGEwZEYyWi9UT3BoeVZHc3h5dVJCT3lBYUc4UGhETzdIandHOVdDUXJnVklZ?=
 =?utf-8?B?T3FpVHJTS2VZclBwRU1rYzdTdjk0cEdpWG03dVFUR283KzdJczZvZVN3MHRn?=
 =?utf-8?B?TkhYdWRoV2FpQWRXNkhtQWVHeVZqZmdTb2dDM0hqQmtlSllKWEkybi9BTXp4?=
 =?utf-8?B?TkhXVHpuR2VJelY4MC9HcElzcEp2ekNSVkRoeEJlYkhOZmVYanZYZjJzS09X?=
 =?utf-8?B?cFFpQTZrMXY4cmdnMWkyNUErYUxpTEt2b2NvQjhtN3V4M29mWVNFZjNmMnZs?=
 =?utf-8?B?dURGYmJKOTc2dWFxTFRvT2E3YWl0SWlFMnprRm9DcFIxaEtzVXBGdnFGNE5Y?=
 =?utf-8?B?QmFXK1BHV01qcFdWbWxqWlFzajdZUXgrb0JvTjZwNkkwbjRsQXdxeVBnb29o?=
 =?utf-8?B?aWQ3VzY1bXRpcTY4Nk1Vb0E5MWEveFJVckNDTnNVTzg5dmFCU1BxOVNwT2hU?=
 =?utf-8?B?bVZsMTRjZ20rTGVmUDRFTGwyUXd1bVY0Mkh0WCtxV0xKNkdPMjViNlI2Zzc2?=
 =?utf-8?B?YU9Vd3d1Vk10QmJvazcxVnJscHRMSmdyc1VTUVdnbnU3Z1FjZUk0eXJibXpz?=
 =?utf-8?B?YjM2UVMrelZGdDI5bUxQbHpiNDdpUk94RzhTVU5qa2cwdFFSTkdEUTJ3V2hv?=
 =?utf-8?B?eGZ2KzBtdVBMN2cxYTJxbzRSZkQvQjI1RnBISVBFUXI3SGppWVNLU0ptc3Zk?=
 =?utf-8?B?NFJFdmNRZHVRbXBPM2hLb280bGs0Z3FPcUZVdHhlNXdjRFBWS3pVeHJHL3JX?=
 =?utf-8?B?eUhRVm1JcDJ1aVpYNENCWXZobTMxVFNwc2I2UVFTcm1idGxLM0xzYlNjSXNW?=
 =?utf-8?B?WThBSEJyNTFvUGdCTnR3Z0h1dEdzS050QVVXbU50S0VUbjJ1R1U4UEQ4d1kw?=
 =?utf-8?B?M3VRbVBLWmxLOExoL0U1LzE3NHVTNFF6b3p4ZnNORVNWdVBxaGJqM0Z3eXBj?=
 =?utf-8?B?WFVsS0NaeHpBSHE5Q1JNZVB5blNvWjVPT1dkaEJwdEpYZGFZTHJrbktUTGtk?=
 =?utf-8?B?cnhFYzlOMXdNSnQva0h2dDU4TzBZd3ByYkdBcllscWpXdmlrdzZBbENORDYz?=
 =?utf-8?B?MDVzNlhRM1hIUUJDMDdYTnFsMURva3N6S2RqOTIydVQwUERWR1ZHZWhtM2g5?=
 =?utf-8?B?Y1JWK2p0ajRHc2pYSGlTVlc3eWxRa2dJWVBqcWhkM21kVFVLWGlxd1FESVFG?=
 =?utf-8?B?M1pLajlEUytwM1RBb0JxLy9LL3I5cU9XMTRJbWdVMUxKT0ZncDFseENsL1dE?=
 =?utf-8?B?bnoxdWVWcEdQK3dJblJROWdvY2JxZDZtRGZnYmhOM2ZxUjJyaUVWL1pneGE3?=
 =?utf-8?B?TkVFbHlLNlZCYm43V3BvZDl4Z1NPS2p3RW1MOWo2Qk1qVXF6SFFFWHlKN1U3?=
 =?utf-8?B?cE5NbUVtWlVlM3QxNXloK3IzOXFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5du/YZDfQLNFk9ykXQj7XgrvXvdS9TL53+bQUdaGWE5PwOvWWqHZk2SCrnhldUpE3iNk4TNP58v07PpmAX4nz5a5Q7iCHrPJtdkxGaDIIuy94QikFKoKThIVY5PHlV6As8kGEXH7BuCp7Auby/rXpupTNghREJ9Do0xk8Zwi1G802GIA9iQabJyHcd2RqueAGUM+NtxWJr/1PNnWhxGfLhgzR5aCOZAwTULmubBNl1MnnFjDA9YxjXkiuCKqFcLkLl//8JuRA7CKC6sdBgrmCR+rFWoJGhqmh4djnqFCsK+wgWzvNoMu0FmCcKj/MUI93Fdkn0878yZk1WsRiDGFzGPzRjq+yRfO3Jz6G6QOj4pnz6sGQnIwPn8LC4mBS7gKTAj7hebNL7WaSmhJWgGqsH/QH0wnxiC/RxX8eRILsbqDEcmJ/PgRfY48Dkp5Dxia
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 19:21:12.7201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e25a6aa-d881-4a71-862d-08de6b350ceb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5833

On Fri, 13 Feb 2026 14:48:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.72-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.12.72-rc1-g4b487d46d595
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
