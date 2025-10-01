Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010009.outbound.protection.outlook.com [52.101.85.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347392D9EC4
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309923; cv=fail; b=peysmzCGj9zPtvl0Ox9sguNjt7/36sXGXQMCfHjwtkFzrUuJvMPQeH1ZZkpIGCwmdIR9wEAGkXjRLGeDvZPRcE5ny7JFCpviM4m0exl/CdvJN6qqlXTg5CdhYAGvGpLC35IrgIXEb4QOOmzyzs7XLWfjOwk3foXD4dWkpopx51M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309923; c=relaxed/simple;
	bh=W4XPqX+fQmniVZktm/XzHWjkcNwyG2lFl/NLFQ6Pias=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TrB1Nr5fPB9OrRqxjyAoZBBg4yZLkdTfMDsZVf/U0jPWA6EWmEA+8oGdu3mjCVAcwsEEXQKZwcEF384989spoPZh85OjbuHnHfzIRHkBCcxkZedehQXmAyXjg7dEsOghOlmcSDrLTg0ZkzTiXyHp9gIRA6wrSBJ2Dm7yFHg8PBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=orcye1/m; arc=fail smtp.client-ip=52.101.85.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="orcye1/m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0NbYHhk5ahehNDJ+3VDGivYvLZ9THg+I+2oH0baQNvJ7LqJrSw5HmBzSezJD8qSDobSdQ1JWFsSyjT1z/M9TJ8J0fliFi6M6GQ3T3H0W52/ln3evh37yGBYmGZP1qsgI5rGy8sfMAqGbHsZQAUTcE3oJfwOXQ3UojetU3aEnU4OQdeOWWcHAq3ULNJOYKhPFdHuIq6fDNjXmp7EjEgAQbVaneVPlYdAqGFj4W2bXaWqHxg3cOROIGK/vi1VZoImflM/ik201iNJ0lt7yRlg8JvpI5NZV9RshltZ/+/TlEZoxyKn8AxI3774HyZg4IurWiwRQLO2pfFMCdmeK1oayg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iP3+BakxImK+JYqoQ3glbJ87ssCw0B5eWoVTo2GzEQ=;
 b=O4hLVCfkBe8ljh+ePTKrsZY4sMEhCkOLcvWWQk9aGvlUIm1mHYvpeeX6WOOkvD43QmtltGPpUKkHbzQtkFPjKb1UHCkG+bj2VMtmRXrYZnHfrta07WExMIqoL/HM7Mh8YAnO8a6Ry8oQ1S8sgmhLKhcx5mLJikGxD5p3ZXXv88OLaOX880wpgbkgTaD9hFxZW1F1lOoTG2dFp87JUjjW0LMu/ZvnBG72eZJFSOUa3aQctIjPfGrXXGjT/FBZGF2SJPBZsQ7wjCoGQa5EheZ9+n7u9RGuwo54UGR60YKL5OBRdnP+MkeuLg3gYNathLr7EVVaV6t/NNIPJ7Tnqht+Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iP3+BakxImK+JYqoQ3glbJ87ssCw0B5eWoVTo2GzEQ=;
 b=orcye1/mkTItYaOZheqTm/1L1Gtaki0v52b3k9FvRg4njoxwA5N/6I/SrfEHFUXfyc+tZvvq5xnWqw+T3ls50eNi+fOhgfW/LixgoYQZCPj1LUBUQ2YLJi9jKSO7TwVIMmWkVeLW1zWH3cJ3XzkUgXoIuuEU+5lpi99uQjwXb4CSPOA8omEl1KljZmtBl5IS8pRTpyxCDxz2Gu6itrBquxlhnogb33bIHBz9WpEUIpbOD4I4AwU87FHzXj5Jxuuhq6YT+PaichxmwS3BNvN1V7a4YCEYaDavu82XBkNtr+kqhRVQ+Gx5gmiRUAQPlxg5sOWXxFWwxkzvEQOU0haM6w==
Received: from BL0PR02CA0113.namprd02.prod.outlook.com (2603:10b6:208:35::18)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 09:11:57 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:35:cafe::bf) by BL0PR02CA0113.outlook.office365.com
 (2603:10b6:208:35::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.14 via Frontend Transport; Wed,
 1 Oct 2025 09:11:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 1 Oct 2025 09:11:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:11:45 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Oct 2025 02:11:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:11:44 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <21ad6f5c-0355-405d-85cd-d598395fd30f@drhqmail201.nvidia.com>
Date: Wed, 1 Oct 2025 02:11:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 1432d5ec-1f35-4d5e-550d-08de00ca9270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1Rrd1pVZ1g2ME54TDErQW4yRkdydVFRM2gzeFUvb3VhbmE0c2x1MW0rZTI1?=
 =?utf-8?B?Z3NhMXFSYTVJNFFVZHUrZjE1QU9XZDN6ZXpDa3cvbzc0VklnNXFCZ2VJSHhx?=
 =?utf-8?B?eFZ4d0pZRjMyc1l5aytNNjhnZkNqZmRpa0xPanNFN0R4RGt6cUxhN1RwUWk1?=
 =?utf-8?B?T3EydFhac212YUZNZU9WbTByTEtiM1ZpLzhHd0hNTVVFbWVsRU9yVSt3NVU4?=
 =?utf-8?B?emZhK3Q0Nm85anVzSHczZXVuVEhkbjQrKy8yM2JvZVBtWDVxbXNSemhLVzBt?=
 =?utf-8?B?ZGFxKzc4bkMrVDR5UWRFVWZ4UGZEbURiRnpPYnlSVkdkYVhCeWlLUzRYbWV4?=
 =?utf-8?B?ck84ZWNqdHY4RXNMRDZOamZybWxXYkt3NkdZMzV1Y2NBbDVXQS90cHorT3lR?=
 =?utf-8?B?MlplUFFtSG1MRm1QdHpJRVBHUEpNNy9GelMwZmZFWGZyZlR6aU5HTU1QcE5p?=
 =?utf-8?B?Qkl0ZzIwMUttbEZzbHNTeWlwQXNMNmY4K3ZDQ2NLd1cySktDbnVwQnNkYzJW?=
 =?utf-8?B?dmJ1YWZXY0pta2tFNmJncU9KU0tGUTN4ZWtwMFRpZGxNR3QrMGw4Y1haRWMr?=
 =?utf-8?B?eU9jYjV3N2FiL1dnY01JbWRONnpwYVYwWm53MzFrYmR0Y293TVc1VjNBVDBB?=
 =?utf-8?B?V1hDcEd6TXRRSlV0bUVPMm10dDNycGtTemVNZmttY01vVjNSV041OFBzN3lR?=
 =?utf-8?B?bjNveXNQRVpqeU5GeWh3SWtwYi9seWdLSUlEQVM1bzZCZGYwYUhzNFhVeXFV?=
 =?utf-8?B?akR4MTZLVTVCZk5mNEV6ZUtZSkQ4S0w2TG8wa2FoSktPU2lTZUlFRGxHOFRT?=
 =?utf-8?B?dm1uamdPUW1HZkV1ZEdxNXlhNUJ6TFNua1MvZ0pZOXN4RXpwdDgxSEdobS9S?=
 =?utf-8?B?NkhpNmZ3U1p4enNodVFjTUZKelBBZzBYZzFORmpISUs2aDEzVTU2MFN2K01t?=
 =?utf-8?B?c1VINklMbldaeVdDWGtYVjVkd2J6aGFEZ2xQMytGQi9ueFRPS3M3Zy82ZWUy?=
 =?utf-8?B?Ni9WNWVEbWhaNU1KTVFISEtwd2lHY1IxWHZJbDdyOEZWeGhMeEgxV0o5dmc3?=
 =?utf-8?B?ZzIxbWR5ZjU3MFdCNjNzcTBObXVmV0lCMGJGVFQ2NGE3MFYrRVJ5QlN5QUlj?=
 =?utf-8?B?akorbUpQc0J0Z1JSNHVXQjBYNUNSTzMxSEJYN0Nja3IxcHBYNWUxeG9pSzds?=
 =?utf-8?B?VTdMSWVjWEo4dk5CZEc2RkEvaXRDeUJSOEFKeTVrWVlXdjBUV2trNmJtNXZV?=
 =?utf-8?B?c21laUxYdlZWdXpCeVpwaU9VQnBRT3dFeHJFeXFvdk9zUjNsL3h4VlVDOGwx?=
 =?utf-8?B?UUZWUXhGbVh0d1JLWlRHeG5QSmpENHh0NmFWdzhVZzZINE8rZ0ZYMm0rQzVS?=
 =?utf-8?B?L0k2UVgveHhnblNEdE4xNEFwUm90b1hwNkFTZTZ3TFRGdEt2ZWwreEhkUTRx?=
 =?utf-8?B?RGVpRkV1WFpjUjVobFRrZ2pqbVFCWmZ5d0NjZFlaM0xuVThVZlh2NUVVZE45?=
 =?utf-8?B?b0g5Z2dMQ1V5OWg1UHVpYVprWjdsYmE0R3A5aTJJZjA4bURyNU52Ync2YnBi?=
 =?utf-8?B?K0lkMlZUOEhtZ2t0Uk9MdXNwRkhZV1lHbkxtaW5WZ3l4WFhpRjdaS0EwaDVD?=
 =?utf-8?B?SmlCcmM2d1NPRWdsemxKZ1VpWHkzRXQ2L3VuMmE5UWlBTUdlRktkcmJuZmdk?=
 =?utf-8?B?T200WFhXVkUyb2xLUlptYlVHSWRRQWR4K1REWWdIZlRaOCt3WXc5WTZZTUNB?=
 =?utf-8?B?MHRLZUsvREdTclpnWU9mQzFkSGlVbDhsN2VMTDNmNWZCdzRGaDlXMnU4R0tr?=
 =?utf-8?B?S1YrUk5UYkFwTjc1Lyt5eFROc3I5WE54M1ErY1c4dWc0ZlNHOHJSSC9mVjht?=
 =?utf-8?B?K3hHZlBCRWg3eVE4NzFwTWFoSEI4Z1ZUMkY3eVIxNFlLV2puRHBBenVnTUhq?=
 =?utf-8?B?VHhNZ1VaS1BzTnlvcFdEVjJmeXd6a04ycysvU3F2cXNibmpDdlhJT2pPb3ZJ?=
 =?utf-8?B?OHlQQXkwK2pDN0VlU09KUUlIV0hhdDZxZUUzVSsxSHovbElidnJnTkh5Zm0w?=
 =?utf-8?B?OHk0emd6UWF0b3lGUEVHREoxVUtqcGdiY2lnV1VRN25jdUJyblV3ZGE2eFVR?=
 =?utf-8?Q?XEkM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:11:57.1690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1432d5ec-1f35-4d5e-550d-08de00ca9270
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088

On Tue, 30 Sep 2025 16:45:30 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
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

Linux version:	5.15.194-rc1-g2e59a3f5f544
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
