Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DDC153
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 19:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723924064; cv=fail; b=rKprPgKy8TgGQ4SZI5OoPp2+deL6Y5zr874HzoafnBMFAO/2xOFqSHjATWl5GJu1Zr7yMtrnr4o2EJvNneMEUCKVR+H2PXbSZQclXKJGhhXfH8+KHthAT/LKGoS8fpEsH/+epca6VGcKHmhDposM74hb5hFCOycrLvYB/8FSEgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723924064; c=relaxed/simple;
	bh=wk/UFTFnPQG60u6I9wDk3nSwiPjE4vAKQi0kAXneiZc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kFpcxH3Pl11wXObi0sXRC6aAch1uur6+utIIy1FU8uG0qQiCqOq/YycSvsNHPxOC0J55830q1mnZyxCRcaKn7gGN4cFeBUsv0DVqVsVFwUOIXo6uYHv/96KA88RwaECL1w+H8S8GaPgtP1LDV1gHqGoIqE0JFvDIq97LIjaK7/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S9SHzW3D; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S9SHzW3D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BhTo8PNmP1ydEJ9iShUvrWGFpN1zrzybb/5rHkqgl0yTSo1wfM3lKSL4hMwW19mPqk4DxEE3dvwai7MCxWCX235MblpUaQXKxudpD1bazgxdz9T5rEJ9iNUTuTETiNLoXXatL0r9jWMfFQh4OqjBZFCncA8JIVU1CkTvULqVJNamEfxsYURJwuZ8ZF8/HoPI4JoRVUJ+2MPkvoNKDi8Uk6fEMdl3Y258q0QqtlhQ3u5hQUVPQZQB/gb+joEKMW0MlTL0GoY48AFosNUkJpN6Cuhax4w6xAbZIVtwnBR4lTvu//SOm+32xl2hWl+OkfeaeYXa9wAJAJB3KRpsKDkIVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkB/7C9DUqFsgke/VqKZjYbKW7O8lPMF12yDKXHdV9U=;
 b=Xhh7mzeLgyajfjLNc5krbbMVPwgBT315xywk91dArCxvOZ4UOqAEJZTVQrot8t+J87n2oxqBO/N59No/74MyK7aaSN2J3pH60ufBc1bwHgzGyXlECKHsBDBBVBVXsgyxPZgYHvVK/plN2Q5hRZ4QvAdWS6Kj4EbXD4pPxR9L5vqksK0vKJigOTnFNP3mcWtGxD4aKkpHeetrATTPij24/yJxz+5SJ84NLKX3jLMN9t2wO/lFYyMnLVV48lNnjcjkvCkBgsSUNg8Qpe+dVGjdpWcxtis01jVBijAKKVGzIZ7Sw8+GIzxBGyGyY/Cw3/T0m/DwyizVSua5K/M54iT/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkB/7C9DUqFsgke/VqKZjYbKW7O8lPMF12yDKXHdV9U=;
 b=S9SHzW3D+j9iWm9YI9JQFNUlBsWrW9f13oqFKpzvUHi//gT3GzMhplJT5NH1SWpGxpxNBLRyFxip7M+lFctv86/kX1rsx0G5BFrnFk2xvk+V1AXFj/6XqdIuzE+xUajOKoj+QVp/SQYMPRwS39o4n7kG7wjVeCybWhVJnW+eQ8zuIxX5ZMy/Re/adU8EhEeVZ8qroydo2v27P28QPmQrNTZ+ey/QMc4++cuy55XsREuKxN4BLbZ/qgmavfoWyhMVyIeQ+xklRM7edQs1so+ef7tE83ix8mdFKbDJM3rerUSWwt8lJTZsnJOmvlIKyYTfSm3of1QKlo+a7sQDUZeRUA==
Received: from CY5P221CA0087.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::30) by
 SJ1PR12MB6364.namprd12.prod.outlook.com (2603:10b6:a03:452::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.20; Sat, 17 Aug 2024 19:47:39 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:930:9:cafe::68) by CY5P221CA0087.outlook.office365.com
 (2603:10b6:930:9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Sat, 17 Aug 2024 19:47:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.11 via Frontend Transport; Sat, 17 Aug 2024 19:47:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 17 Aug
 2024 12:47:38 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sat, 17 Aug 2024 12:47:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sat, 17 Aug 2024 12:47:37 -0700
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
Subject: Re: [PATCH 5.10 000/345] 5.10.224-rc3 review
In-Reply-To: <20240817074737.217182940@linuxfoundation.org>
References: <20240817074737.217182940@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7bd02540-b9c7-4633-bc36-6d0a54424b99@drhqmail202.nvidia.com>
Date: Sat, 17 Aug 2024 12:47:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|SJ1PR12MB6364:EE_
X-MS-Office365-Filtering-Correlation-Id: e3f777a4-6147-4d05-26b3-08dcbef57307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXhpbXU5djg4S2o5QU81ZHhSZVRDYTBZUUNWaTlreUY5d3doQXFjTDJ4cUhy?=
 =?utf-8?B?M2hlOVdGblo2czVPV2I5ZUxVUGJWRUhrZy9weEhWb2d4bHRKUE8rUUM3c2dO?=
 =?utf-8?B?TU9JRXV5MlpIa1dVYUE1Yk84NG5Eemp2S1QzNTlUbzFlSUV0aWw3VzRJZEo3?=
 =?utf-8?B?Tlg3Q3pkR3k0YXZTVUEwSjcvaFBKbTlWdXBqRVRkZW9vQmRYT3lEM2VocVBq?=
 =?utf-8?B?aENTMkswRlNtcjU3b21VK2drRngzT3UyZDJOM0s2RGRKbiszck5tZnp6TERm?=
 =?utf-8?B?RVUxVmExRTAzZlNxb1FpNnpkMU92dER1dlRsamFYS25lRi9uNUo5L2gvSXNl?=
 =?utf-8?B?TS95ZVgzWCsrVmN4YW8xU3Z3OFFtL09DWFNoNlplNElabkRtS0taek53NVV1?=
 =?utf-8?B?NDNJcGcyYk5zZm9wL0FjTHA3bnZwQnpHZ1diRmoraHN3ZDVuOTRkVDQ5MmpR?=
 =?utf-8?B?RDJoN0ltSDFCaWwyT1pJLzg0T3U5VVl1RHpKU0JFa0FGV2dNQjE4OG9QeTY4?=
 =?utf-8?B?QmwzSXJ5d1lFN2pOK09NRDRMdVVrYXVVMFpkZ1BsZ2YvR1ZId2ZjNitxVTBC?=
 =?utf-8?B?bFFQN2xUQ2hDcjMxbzg0ZzNkTmhkL3lYOGE2b0pQSmVTall3eElaNDlPcW83?=
 =?utf-8?B?TUhJSFhVUGVsemoycTRlSnJ6T0ZFZnl1R2VKNDJUaC9vUDlpS3lQY01DWDh1?=
 =?utf-8?B?R3lNZUNqMmxMN1lscHVWL25GL1kzU2xveFRLbit4ZFordUtOLzJzSXBCVndN?=
 =?utf-8?B?Nm94VUxyaHM5b0FmN2QwaStHUi9HYnZ5amUrWStBSitld3hlalVET1BpNFZa?=
 =?utf-8?B?Ni8zRXFlaDNGbGFWbTBlWjhCRkFyTXVMc205dGVsUGpTOW9CNllQUkxydEVB?=
 =?utf-8?B?SXBobFZ4UllKNGlESUZrS05oUUMxTDB2dWNMSitiUGFkRVorcTN2VjRDMXk0?=
 =?utf-8?B?RlM2TVQ1VENlYWxYU0VDaTM1QTllYlFmdHZBZUZYNjE1NnJjVnBORW5uV2RD?=
 =?utf-8?B?Um10VFRRQzJPU1l3R0hlMm8ra1ZQcnFZRVJ2eDBqd2c3MkpJWGhtalllNGsx?=
 =?utf-8?B?RmNBVXBsYUx5cmFNYnBTbXNIRGVSYU1mS2grVFZWOFdBalZmVm9acDk5OUxH?=
 =?utf-8?B?ZW5uYnU3YTIrREJ6RTdaTWdzL3R0MmgrbUFLTXhnaTQwOWdURVptWUhMOENG?=
 =?utf-8?B?dkoyMzZnRld5dWwrNC8xNXpnSUVNbFhVeUlIdEVtMmt6VjJKRGpnTnc3RTBn?=
 =?utf-8?B?RGxOS0ZtQlhlT0Q0VERnOXF5Y0ZCOWpOK0NxYWdXRXgzbVNHNXJNNU5nN2NL?=
 =?utf-8?B?MlV2V3dMbXFocmRCOS8yTTVtZThCY284aVBhaDdDeWNFR252dWV1SUw5ZEVu?=
 =?utf-8?B?cVhkUFdZNEk0WmtNV3RKU1RCdHp5TEFSRVJ2cEd2ZmhiUWtWbmpPYWhHN25x?=
 =?utf-8?B?M0tFT1IycVZjMU9KbVdQbE5WT1lnQS9ISUJScXJxaTJYVmREZ1VLUmFScklv?=
 =?utf-8?B?emFuWnVPZE9mNjJqcWJnbkg4cGZqV0w4ZnQxZmI5aHFHN3U2U2NmMFBoQzVI?=
 =?utf-8?B?Y0h3SmV4WnhUNjFEL1lQN0tSNG9xRVBmeUZvVFJESnovWE90cVRKT2ZIQk9z?=
 =?utf-8?B?K29hakVKR2JLNHBEYlhRN1RycGZtU2VMTFkrMzlQUWlJRHFBekZ4c0E5aFd4?=
 =?utf-8?B?bzBGcU5rNXNmYytLUi9MT2Y2dUxLK1FmZFpXUy9JZHhPMDl3SDhIWTRRKyto?=
 =?utf-8?B?Z2Z2UldGVXc4YlQ1MTNCTVkxTXFCQW9yVnpESWs5bG53UHI5K0NXdWxlUE4v?=
 =?utf-8?B?QkNGellNMDUxVHJGUGZOd2F6aHg5RHYwVTVFdVNvejg5V3lJQnREcmxWMVZL?=
 =?utf-8?B?bk04OEpiTHp1SUVjd3RNSkpYaXhjd3B5d21QRWdJRTdoNDExWXVIS2toQ1p1?=
 =?utf-8?Q?mG3Bpd11Qg6Jhv6XSB/4e4966zfPvZNC?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 19:47:38.5412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f777a4-6147-4d05-26b3-08dcbef57307
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6364

On Sat, 17 Aug 2024 09:51:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 345 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Aug 2024 07:46:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    68 tests:	68 pass, 0 fail

Linux version:	5.10.224-rc3-g2810e3a9f5d6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
