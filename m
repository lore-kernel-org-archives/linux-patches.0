Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012033.outbound.protection.outlook.com [40.93.195.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C70528DB56
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995371; cv=fail; b=bz91HuxnEtKgWZrbHQMj1zJS5QTWxfMF1Ui0r4iFYy3mpOC7Vl9Vs+9kDJ0PaSp3ARYSjZ/+Hxf1dPswpq57FtxeseJ9YM1Oo4hIxBbbB8KxMLmHbUju1ZSEuTXoLSdRq62liB0xoxZXmZigZ0yAnbskqMFVfdiaLfMhW8Kfa4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995371; c=relaxed/simple;
	bh=T4BokbxfZOVWkgBLsIH5AdX93HEh7NJT6FW/RPP8lso=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=KgPmeoI5d9/nk9at1FSy0pENyF3hTke3eyKZKy4QFlAkWOFKhJGWrGbEQQ7mXhC+cU83hSEQkaIRmgDQQS0Z5RzdWZ8Q9iAQqXXKEWLWQd14SQVJh+e7sIpLt2eSi3yoWMSacTMRdp09HMtUtfpfrU+0fcsxIvpBp9tQ/m0uu7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PmOT6ZXc; arc=fail smtp.client-ip=40.93.195.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PmOT6ZXc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4z1I/CM4CSQwvoG/HTJKISGH7CTVZFddJ2DX5+evbYZq3qHp/4iRMMnKz84HgZ9G6wDoMxyD0TyFai/FKfr/OlaSCgHPpPXIb3UB7rXmlBXXVeQHDPtlCAN3D3ICV8ubgSnHuaOFY4fTj3IOemIWxuLfse4bGT2q22tjlMrKivXpzaTeqz+8wQYxxb3ljaiG9NI1ejCSuhAnzoRMw8tPoPU0QErvEaVeuMtwSUXxUUJn8N7CpjVq48HgyjNFQ9IZH0tI1iiY02qAwDRH7tze0MEImL8mrNYKIeVVSP3brYUF/DYPS4l98rWlXPVGKWwCtfqB52WtOHOnyU33fpJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GinZnOUp+tWCV9cw2QiZEtcMCWD9Tjtm7a6kz4hGdpE=;
 b=Aykx3VITtQpsLiRajEu+7cT84WAspC3PIkP9c5EIx9RxCSqV9W6/LtT18csCsxfRlJVrptme8E809gV2uFhU4RpgwkBug+vlZzTCJow/CrBcpfgFqiGEOu5EOzJQWShOqBFoDY9D1i4WJxWZbjxD3R/g8nPgU284+JIuVqLsHf+DqmZPxLZ1O30pAiRjGzOVrTgsFvy9kjAurCRL5zf7Ta5cXxajtha79Hq6zUe0Kv9aQR4UsaHngztF0KuTcTJcKU0vVXanO6QzVn13hGYWRgR3enbMFdnOfV1Pjg8w4miRN1WduWdrKShWMcvL1OycqgzG0zCXrx7lF4u7P/0Mgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GinZnOUp+tWCV9cw2QiZEtcMCWD9Tjtm7a6kz4hGdpE=;
 b=PmOT6ZXcgvd6m7eG26Ef7hmlgbiaEpfXR+dBUwFyg/PE4JHy7GN9rNIp4+o50X54GmCPPFanY3hE1xgLot3NFZTd8jrGMi+Tf2BR5tb5JJ55dsza75z0q83kut2OwG/pMrK3QtEYjDnBceTZWFit9TlDHcSWc8SWXyIwMX/r+EzrzV9Mle5prlwS0cstSp4iggBKndqH3agn9pdJpuM1jO5sFM0Oifxr60zfxf8AcDCIippR9b1yQ5JIZXECmUtXbit4R88s0MpqlsHzMlplCPitxJV+bQZUxzt5LvMkXlVDhh/KLrBh8skIVvmpLsc7b8FlOJDHlIfNjBsiYswWnQ==
Received: from DS7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:8:54::8) by
 IA1PR12MB6412.namprd12.prod.outlook.com (2603:10b6:208:3af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 13:41:21 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::b6) by DS7PR06CA0053.outlook.office365.com
 (2603:10b6:8:54::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 13:41:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 13:41:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 17 Dec
 2025 05:41:09 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 17 Dec 2025 05:41:09 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 17 Dec 2025 05:41:09 -0800
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
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
References: <20251216111947.723989795@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <46f4f1a6-18da-4d8e-b73f-b04ca368edb3@drhqmail202.nvidia.com>
Date: Wed, 17 Dec 2025 05:41:09 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|IA1PR12MB6412:EE_
X-MS-Office365-Filtering-Correlation-Id: 04090133-533f-4c62-0276-08de3d71f614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?WHc3SjQwZjNCb3M3RWwrUGZtOGp4dzIwY0dDS0VrRk83VytwYVRKWWZWTEF1?=
 =?utf-8?B?OXBSWDFhUXJRNXdYTHFCaENEVE5KaUt2V0c5RndkVVM4Vy9RN0xISWJBdHJM?=
 =?utf-8?B?ZmVqM0Y2WFNXa3UxWk1UQTBJSTAzQ0dLNzJwZ0lJakx0ajBCbTkyL0ZmMTFI?=
 =?utf-8?B?cnRUVFZ2cUVRYU0wZXFaUGZJQU9hUVYyN0t1TjJ5TERVOW0yK05aOVNFVkhV?=
 =?utf-8?B?TXQ3TUNtKzFqTUY4T2NuRndkNjYvYVhDdm1nMUticy90YzExTGdUajJRMFIw?=
 =?utf-8?B?Q1hiZjBCYll4Vnhjam9Mb3FIeldXZ1BZTkdUN0pVRU04emdnYmRlbDVoN2hP?=
 =?utf-8?B?anQwcnZXeEY4VC83aHF1M3NJNTFlU09lekYxK09DUFhGeVl0cHZLZFpjeGky?=
 =?utf-8?B?a2crdHB0YnVMNEp0azBwbVd0T0dDSDJzOHhFbXlzU2FVeHpMZ2hYNlBlL3RG?=
 =?utf-8?B?R3drRytEY2lPcjNjWEZvRkZvOGc1M0hMR3laQXdEdTN6eHBpRmhxOFA1akpt?=
 =?utf-8?B?bFFyOEZNaEhXUHpXVWJTRmVkQm9ZS3N1cTAya1NCNEkzbU5WNE1Nb0l6L29I?=
 =?utf-8?B?bFpmcSthcFdZYVc4aW4vMGFYMU04S3Y3SDZoaVVpQlNwVUhVTTBQVm9EaW1t?=
 =?utf-8?B?ZU1FSHYzOTZyR3VHTUtxQlNGWkl5RDM5NWpxMVNZVUtkbjd6TzEwYXBFTDRv?=
 =?utf-8?B?amtCblVsSnZkSGZCZmdGeFpDdzVucTBSM0ZmRVJkYWVyaTdzUldQdnRqaUJ0?=
 =?utf-8?B?TC9CQVcrRFlsV3dUd1pkdUxBU2hPNUtFUytaYWJvYXlyN3NoZ2lCcXA4SDRT?=
 =?utf-8?B?cVg4UnIxN3VCTlNUeFgwdUJObTBlbm1PVzZFbXV0cXhBc1MzRnF2ZjdNeGlI?=
 =?utf-8?B?dVIzdFQ2NU5Qam1oZ1NrSkpGNUk1TGRPa085MHlLd05LTTl5NzJNUDlIUExB?=
 =?utf-8?B?Q053MExWOGoyeCtkQy8rUHZQODdmOXBOakxrQUE4MDM1ckxQMGZ6RFNUcGlZ?=
 =?utf-8?B?RzMrM2hDYk1zSUYrOE5xZEJLK2o2bnlDNFNzNWtwTHZXRmdITVZVZ2xjdXA3?=
 =?utf-8?B?ZW4zWlYwVFlwaDZFMXhoVUNaR0Y0RUEzY0VFMnJMRGVlcVh3OUQramdOZHYy?=
 =?utf-8?B?dFpCbDVGbktWeDRyMWF0NSs2K0xyZlhDeXVNUHNrYWtqbnR2TGtlejFaa0lX?=
 =?utf-8?B?dUt0QzgvV3QzUmtYZXBFWkJSWkI0RE1oVW9xeTR6SjkxSjlaQ0ZWVVhSWlFM?=
 =?utf-8?B?WjJTWlJORnV2Rm5YUGdZdUplTE9rejU2VzZ1cXpTU0Z5d2UvVC9VSDRXSkU1?=
 =?utf-8?B?UDE1SWlVdEs5S1BKeVRJeVBoSFJ0dndnT201NUVZU0EwRUIrQTBDdWZYNUEz?=
 =?utf-8?B?M3lodjN2UG9rZjhPMlYrSCtHenZBd2k4ZTZaaHlwUHRQM2JtSSt6a3grU0lh?=
 =?utf-8?B?eVZ1cTI3dXE4R2t4R3Mrc1E5NXRHWWFzZmNGS1V1R2R2R0RhWllob2lqcmo2?=
 =?utf-8?B?N21YOHNrd3RaRW9iU0FvMFBXZ2dHb1ZtZ0RKSXNOckJsa3RHSjdobW5GbDRI?=
 =?utf-8?B?NG1rNTMyRWozSHB2KzNUVlRnYVhkNm1KSUQySE82TXphYm5UdmloNXR2cFNJ?=
 =?utf-8?B?eU5DQ1BlSUZNUUQzeG83UTZKNHJ5WU9FQWEyRndwU3VkTHN3V0JPTkh3S2Ni?=
 =?utf-8?B?L3h0WFh2Q2hDR0p5ZUlzVGRyaEwxV1JtUG1ZWHZJNjFRMTVUVmp5SkhEdXVY?=
 =?utf-8?B?eUJUMkFyRGNhVlp5UDl1R2w4RHZYZExNdlJrd0RGa0tyL211UkoxK0tNWDYz?=
 =?utf-8?B?Y0g1UUJIVFcyaFFQOFpLOSt6bkY0MlhJc1BBdFZ4bzM5VUtHZnV6dXdVQlBB?=
 =?utf-8?B?TExZdm55ODk1M0ZwbnkrSS8renlybWFFYUpoSGJzcnAwTzY0a1p6MEU4bW5U?=
 =?utf-8?B?NkIvMy84WnpNcVZnaFBKamQwWDZ4dURUMGwySElPcjZVUE8vU3NrVEFRaEY4?=
 =?utf-8?B?Z0k0MkVyV2JMcUI5cGlNZW5VZGhoTEZ0RFJmTU9PZkgrZjliT1FTczNVNW1K?=
 =?utf-8?B?OHV2dFJncXpEMDB0K1ZmSkxpTTJudllSbWlrRkJwQXZwVVl2UTZBMzFhZnYr?=
 =?utf-8?Q?Ig0M=3D?=
X-Forefront-Antispam-Report:
 CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:41:20.1367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04090133-533f-4c62-0276-08de3d71f614
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6412

On Tue, 16 Dec 2025 12:20:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:18:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.13-rc2.gz
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

Linux version:	6.17.13-rc2-gf89c72a532b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
