Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AF2E2DD2
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978897; cv=fail; b=PdLEWkan+k1PBP5gGdOaklbKGoIqmamp5Ra2sjidnwTGcyQOvvOW8vKy8sNWt+23nxHvrEwai07qmVDjUv3xIqlc6c0LCZjMZM8U5ySymxvkgQKqhoJ7/2XZ1HKjG/DTxf3YjDVVjnhEL1N666tN/eoJFHi1+NYrk9VTYVWlRG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978897; c=relaxed/simple;
	bh=XnoG0eTx/cbyTzRp2mwL9lDeWdvwqChnhCLF6qj/6pg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=iQhmeeHvgFNegt9Fs3oM64YbGWuTnPLJ7vRBbGa+BKPkx+/nqjxLKqZXbzWjEQm1IFEFryfNT8S+QpOurJpiQMTzEujJNf4grPzwf9cm/UJTK8dGL5cpezW/++anmiZCshp3+o9qH0SI7LFKjB3Xdat0usPPgPOM1vE9N8jNz5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WKU4uFHJ; arc=fail smtp.client-ip=52.101.56.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WKU4uFHJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6BX6RSwUkr9XEM14Zn3GUY9VizTkSOgt7B0AC2K636ZMXr/+6brxI5z+wrrAhLEr2Q8CX0rcHTICVxTf9DmWXX9aqmrHO8tVqawCV8R1SzZQ3OPLKxE49iQ/zSE82qXYUk9LL0Dil+fQzaiA1Yxt136RxWnQnphwXLMVv0QWMJFjzFlO4M+wi7zjq9F/oLDzYRkh9WiSjzfEMyhSW3ZAnXeFq3+9ppqew1QDn+fphEkJTlK8MUBsquGG6jfYaQCtoERzyIiBQJG0Aoj6wB5ghI9u8IErS6YCjcFR+IG8agevy2/ykLXdeqtPRQ49pZmNaXB6Z6kh6/B7phHR7Qh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBHejTszKNOYk3F8933STkL163Pu3j3f41gl13XVH/E=;
 b=f69Tek2nxoJoURq8oxYZT+1Q3FhyVxCiPaX09ZSIxwqyYn7143bdFsqqCcMjDksW/XS0AMP7BvryWTccbw6G6XS/8bSvHR5oh910GKQKB962Pd7Aqc7iMPFPDrepcGRb4VaSLwvocGdT/g2GWtlovWEAJMHpBKDI31c3wQbd7jJGZNeEwtQO5icnxHrG9z2+WrU1CMWjWbO7rrGfohfoomJTexan9uDPpk/f6c97Yr/uCmKRhciSUgmIMdUmROZ6ShXlYim8EvK5cgdIgljDoSKqMswqCfvRBb+FBUZ1PD9Piaj2nj66otzY74ggzHSXsNOWtYa8ZsBUA6V2x66fEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBHejTszKNOYk3F8933STkL163Pu3j3f41gl13XVH/E=;
 b=WKU4uFHJzohkR7k27dhL6NGTtIK9Zb590MUCxJuNbf6Psng6FGTDUg9Ld2U0NFn13SdNmxyMo5igCD2KmIC38fP1BHGIZTM5aarm6OhFJhkLXFnSVD1YaeGaBWw5ZCDEGsD3aNXFH8Pt5Ivm8e/z4L3ezFXNlR8aIqoZ5Z7rYft1tmPuKoq4DHaeNi1HkQLEnoBKL6l939RXCcoi424q2PLdFIeQYHux+MPhBU+gSuHmU7KogAJaNOQYuLGQUc7rnPbmuquRQMl7NjetW33QLti16WBJgjKo6G8Qmxx+z/mGuTKJVKQOAl6gaKX6ZVfmLFVQbAK14YoK74P3xxpY+Q==
Received: from DM6PR06CA0042.namprd06.prod.outlook.com (2603:10b6:5:54::19) by
 BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 13:41:27 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:5:54:cafe::65) by DM6PR06CA0042.outlook.office365.com
 (2603:10b6:5:54::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Wed,
 17 Dec 2025 13:41:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 13:41:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 17 Dec
 2025 05:41:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 17 Dec 2025 05:41:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 17 Dec 2025 05:41:15 -0800
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
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7624824a-a41a-470d-a32e-eb4afeb4758b@drhqmail201.nvidia.com>
Date: Wed, 17 Dec 2025 05:41:15 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|BL1PR12MB5825:EE_
X-MS-Office365-Filtering-Correlation-Id: a9d14078-73fb-42c2-f953-08de3d71fa45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVdpcGoyOGNMQXdOL05yVDA2RVFLTFpFQk5mdGxpNlVTbUl6ck1uaDBLY3ll?=
 =?utf-8?B?bGJiSFlzeUVWWTkrYTVCdkQrOHRhTDBHVVVqMkNJR2dkUVVObEpWMVp5K3JE?=
 =?utf-8?B?Y3hNV3g0Z1dFakNaRzVXN0tMc2xjOWYyVldKWkFOVkNXWXJEMUI1YXh2N21s?=
 =?utf-8?B?NFFlUGVuQ3dxWkJqZEpxcVhoOUUyYXZ2UkMxYXVFMEVjQUNJcytNWDlObVJo?=
 =?utf-8?B?RHoxWmlPNjhZeEcrTTRwRklaUkY0MTV2QTVFM1ZLY0tCSzlYeFcwQi8vOWRU?=
 =?utf-8?B?NmJ4dFpGR2FtVDljL2Q3UlMveWl3bjBxT0t2TjZIQVU3bEg2M3NjdkdSdTJ3?=
 =?utf-8?B?cW9zVjVLNUxOeHR1QkxOdUZPQUJpOXY3ejJ4cksvY2Q3NkNTcXNFZHpJL3VY?=
 =?utf-8?B?U0dxQzAyUDhVaUVaN2dEa3VDZytUSDA1MUcrSmN1NDBLYTBlY0RMaWwxdnBI?=
 =?utf-8?B?b1FiTnVJTDR2a2xlcVRYVkIzVzEwOFZuTFRqVzNUM0xEbHlOOGg1NTY1OHVV?=
 =?utf-8?B?K05Ha0NMbHI0NE9MV3djK1ZZcGJyaHRLcjN4ZlMrVGVFN21kR0hOMlhBVmI4?=
 =?utf-8?B?SkVRWDVxVE5uOFJxRlg2ZW9xY2hLWUQxL3dVSG5jZHZpU1JKajVoNHpQOWdZ?=
 =?utf-8?B?cm51dVhjYjFMV3hSYTQ2WVlxQml3TFVjTTUvUENGcVRWM1dWVWJhVFQzcVhT?=
 =?utf-8?B?bWJsSnk2aGlreXNiVG5aU0NtN1Jjd3o4ZmVIeWd1TWx6Nkl3dk1NWlBzVWFp?=
 =?utf-8?B?c2RwK2R5RmFYa3VUWTFDbjhjc1Nac3Fia29SVHkxNDRWdGFjYjg0aFFyQjVF?=
 =?utf-8?B?RXVXVkNnUURLUmhuK1h5Y0plbDRpRFJ6TFd1RFlQUDFoRTNZV2JqQ1hBZWs4?=
 =?utf-8?B?cFprR2NaZ1dUWFNSQ0ppV0grbis5b1R3Zld6cFZRSW5SVTVVMi9NQ1NhQ2FF?=
 =?utf-8?B?Q2IxYWkxZDdZZDBiTGRIdGtWY0F1Y00xNHo0VFZtTjJ2bjJMaUZmdW90c1I2?=
 =?utf-8?B?OU42d1J3MnV2SHhlV2pzUkxIQXV5clh4dlUwN2tORDlsWlJ4UjYxa1BMZytZ?=
 =?utf-8?B?Nk5VZUhMSEZyRTlHUjRyUU02WktvWUE5Y0RlMDQ5VjFRSmxwWTVBZFptMW8v?=
 =?utf-8?B?Ykk4R1B5MElzNkdXSEtvdU9UNnRYcE91bXBzUmQrekhrVmhtd2pKaDVKUnBO?=
 =?utf-8?B?UzJDNnZHdjA3SWV3RWpSdmlsVVZISHNFVmY5a2VjbnZTamRscUxiYW1LZ0tl?=
 =?utf-8?B?Q3hJV25TQ1NrTVk4bEFJWmxtNFVRKzh0blZ4UkdxbWNzL2tNdllEMWpjMXFQ?=
 =?utf-8?B?TnI0cVpyTzBYVVc0QjNsaSs3VkFHblNKb2lrRHNwV3VlNWJXYy9GV053ekNX?=
 =?utf-8?B?VTN4ZXU4Z2NoNjk3d2tOMFdNWWxJWTVLYVRMSGtzekR1aDFxYXpXRFk1ck1Y?=
 =?utf-8?B?aHZZcTZwWm9sQ0pxeE9IR1NEbGRVT2RHeGdFWXlIYlRqendSbnZLQVNSeTBr?=
 =?utf-8?B?UXk5R3RETWhEclI2MzJzUnIrQ3l0QkdmVU1DWFR0MlZ3bC9PbWJ3ZW5kT2xw?=
 =?utf-8?B?MzBtczQyR3htdjFoUUh5U2xKUmFRZmQxYkh4OGtYTUF4aHFZSUpQa3Y3clVT?=
 =?utf-8?B?VS8xSVA5YWFMUjJ0S3F5TFJGNGlNMU1zZlVNVlFzVWFIS0tnSmN3c3dlV1hi?=
 =?utf-8?B?TWlyL0ZTRDhiSWIxdy8xQUhRMk5kY0thZTg4bnBwSVJNT3E4N1lmMitKLzJv?=
 =?utf-8?B?ZEYwSGRxSWRnMVp1ZDZ3a0pJd1VxRStFT0lPdzVXK01pR09icldSUzhNSW81?=
 =?utf-8?B?b2YxOGRLd1JpUWtKbHFWMUZGaEp6bGJKR3p0R05wV3I0ek1nZUVvSVp5bFhM?=
 =?utf-8?B?OFJ0ZnZJK25HcUpkWWIxa25zWGZpY29kVit2VkIva0lHSnNtZGE4aW5MdjNB?=
 =?utf-8?B?YzEvNmd5YXNLNGZkOUk1c2ZRSW5uRjdjdTRWaUs3VTBuMXJ5SXBGUnoxSHJx?=
 =?utf-8?B?T1hqdlQ2dmpDV2ZRZ214YXd0THlLbitqU3JDR25pekVaeWpnYXh0Z2hSSklq?=
 =?utf-8?B?b2JDaDkyQ3VKb3ZQRmY3QkdFQlZscXdKdmMwMUFYMGhBaVhmSDhGVXhDR0Q4?=
 =?utf-8?Q?4CSw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:41:27.1708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d14078-73fb-42c2-f953-08de3d71fa45
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825

On Tue, 16 Dec 2025 12:06:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.18.2-rc1-g103c79e44ce7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
