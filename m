Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525B6299A96
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100145; cv=fail; b=ENgPCJcIO/6saf+xCzGddbLKgbN7omD3H3LNreb4OdvIou3RA5yAlSb4UJZWYPH7fyCFzZCwkQpmjtGJDFU0BHOL8aUAEpyuvXdaQTNT4O36Bb5lrv4pdSoX+iOeaZzy43S9R+WO6L89Z25Tyo9RSu/unqx4fy2PlGVJz+lvspA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100145; c=relaxed/simple;
	bh=Abr437MWdhJ/vo/4KGToAjYCsfvpqDTKu28OBFPEsE8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WRr2457FUBDw5cGVZeDQ9GmQEgDqRkX9xPdfqO3yIHBEtMMT/ReJfRx3npLYfis52+Zmzv8OpT3UhirXvtxxOtQdlj8shfkwYDLEbC7mLJ9HFsdQOMA8xrN8+ZmG2zwXT4ex5U61nbySr+Wgmbf7S/+68CMsMlGmGTGW3g6vquM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nvO7FRt0; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nvO7FRt0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fi2n316kTBlEbFQDFsTHDpYa5yXiiUFZYffIrhy+MSjAk6boglDPpaG6oQ2ccUnHJDfxV2UXS9wImwOBsQ3QBwMPmlP1GibAI8xijyaQBHoVWBNnQdEegxSHDGB1Y/R3+9SED2inMH6B6utnekJQPJMWhK9kM715/Fy/GzmgCaabwNhKA58Pj9B0dJORFh+RcLdKgvTP45PZSAMfpyVZtr21jMVC4cL/SRvohiQty7qFKkETaqSYVjYgt6wQgGR4+hXH5QQVGNzh6q6uv2S7y/px82UoSVq+Lxqa6NYHAqbBlw7mm8DEvjPt38BZI61DbFIqcXPpr7NIuPSX7yrP+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoCR9piR0xti2t7k3nQn+xFXyoCZ9ULsLW7rgMW23ks=;
 b=Vl9sSIRj3EXU93HXf5tITdQO2MVWtHKdVskN27GtsKCuUBESBWm4JnkJYCAEty9aA8cMDjWg0tYj/nZE73MFGWJxmtXHiKpE5gEDeG2KDSQPGHnPJjKMXrp7bao/d4q3VOM+VeELYimw0xmpwUCMzL6rEDgV7NxPZhhOuc+gRG2r0AWCg+YoX++QCdrnPbmZK4qe1qjRbrYDyr0gyLRx0bbTGCTEelzD9wyZ9IxKW8QuUOMjzUdOScDKsxPjsKICacwPG4mfsnzbdVzhEcVScZOgv61jLyJMiMN14LG47DSQEip07/AFr6gVygCp4Id3t452rq0Ofd8QfBVQo3Ww8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoCR9piR0xti2t7k3nQn+xFXyoCZ9ULsLW7rgMW23ks=;
 b=nvO7FRt0V3ikzDJzHimQzH+X51cJhmYfpJDDv0S4eoDUo33piLO4RtR/kk4u/77d0TPFTpuvpetwtW9uOAltFNdY26mCFWNoRLWnQb3Sf8M1iufZ4SRFDg559f2tcvMtMLJFL0bJ4v2EHgiwCeqj5Z/WMv1rp/bEY8vkL+1EzcBUGSZ1MT8tlpL5LgmpO9LvQ6uhtMhz2UjXd0CQnlGdQR2WPAzl6IWYtCBWSVM7GaWwlXKNeE8exiwWvKPHGEXljKsRBs50DxDrRfPQiuXOEIbC6sOdfd3UC0dhcCk7v+IMHaenkkJWnsfe3nd8uCNFcKk6Bw3UExG+aCyRHSvJTQ==
Received: from SJ0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:a03:333::35)
 by BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 15:48:58 +0000
Received: from SJ1PEPF00001CEA.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::70) by SJ0PR03CA0120.outlook.office365.com
 (2603:10b6:a03:333::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Wed,
 13 Aug 2025 15:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CEA.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Wed, 13 Aug 2025 15:48:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:44 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 08:48:40 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ce401130-8935-469d-8d27-c1047556ccc7@rnnvmail205.nvidia.com>
Date: Wed, 13 Aug 2025 08:48:40 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEA:EE_|BY5PR12MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: febd7aef-baf4-4c1e-76a7-08ddda80ead9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTdzMTVjNC9uZTVKZlFQaU5QMVRISm9pK0RTWHpjZ3VKelBzZ3R2Rlo5cGk1?=
 =?utf-8?B?bno3T3IxdWFTUkRBZnR4ZldveDFnQ1ZIZ2YvL1JtN3o3WjFRN2FucGtweWUw?=
 =?utf-8?B?cVk5Wmg1Y3JRTmRVcXJIMFFYZVdkY25yTWwyRTl5ckRZQmYwMVYzcktmNkMr?=
 =?utf-8?B?YWpwejZBYWpkaDgybTBWTjVHekx5YnVHclJyRW40amZsR1ZXamJBMmJnL2xZ?=
 =?utf-8?B?Z255R0dTY3pxN2tiYnhxOVB3UmZ4Yk4xNDZndkVHRUhCQmpQZlRXakhuSzhz?=
 =?utf-8?B?MHdmWm03eGZVQVpmb2hqb2tQMWxMVUUraFU4NmdTMVRWZzEyNWNGcll0Ukxv?=
 =?utf-8?B?UndpemEyaVpVcU50eXFXOHUxd3kraEM5bHRuNG5aOVdMYmE0NTFETGJObTZS?=
 =?utf-8?B?TXZQTEVJMkd5dGNDZ2ZRVDQ3bmpFUWdnT0p1dDg5dFFPVXZ4ZjExbXE4L25C?=
 =?utf-8?B?REg2Ui9YQ2JaSFdhWDZ6K3hKdTBCdmFMMzE0YmNQZGQ0dkU0M09tcTlCQndU?=
 =?utf-8?B?WmptQVV6YUN2c05wMjZ0NDZHbTlGeWVwcUZGQks4Rk1JUWVQVG92Y25KR0lz?=
 =?utf-8?B?NmZObVhJU0ljZHU1dHhrMDhsZG13TTBRU083VDNqQ2gxRnhadHMwQSs0bXpU?=
 =?utf-8?B?RDFQSUZRckFWUHJsVDdWaVN0ZEtFUFdseXJaYW5YZXNqanJOUXhIT1ZoQSt5?=
 =?utf-8?B?MS9lWElsRWc1WTJBdWRld2NCeDRrOXNQWmlMWmlOMHpOYnBUMTJXVjFmbHUz?=
 =?utf-8?B?WWFzQzhxQ3RlUCtDVTVpVXlvaHR6bzNJREhaTnpzTU1pU0lON2xyL0lValB6?=
 =?utf-8?B?RnI5N3BuRWNBWHM5M2dhbnE1cFNOOWc3bmxTd0JwZ2g0VE01REZEUlYyWWpi?=
 =?utf-8?B?WktYdVlzbjh6bERQWlo1OTZERk5jNS81citUK3pXZTZWMzI4Z2F5SWNqV1pY?=
 =?utf-8?B?QW1UTlkwMS9KeUhhUVlubi9LZCtYODNHRzVRVFEwUkFEaEIvYStST0FEY3d0?=
 =?utf-8?B?S3BwRStOUFNlTS9UUklQZlBEZlpKNzhoUURhZ3dWdTNwcEFzWWNUaEhEVzQr?=
 =?utf-8?B?ZzM5ZWNVTm5TaE5GbmJwWkZqd2tEUGp5aHd4VmgzUkhoZ1dkN05hSlR1MDdl?=
 =?utf-8?B?eXhqQkZnSEpkYWVMUU9PMUtZVnNWVFlQYjlnN3BFQUQzWC90UFk0MWpJUlBM?=
 =?utf-8?B?K3Rnb2JiclFQQkluaFRialhPT3Z0WFFnR2l3eU8xR0o5RWc4QXRzeisyeTlv?=
 =?utf-8?B?b0t3bUVGcWxqTGYyL0ppRGZYV2wwM2hqWXowbWF2VkVYYTdjZ2JCRGpuOHcv?=
 =?utf-8?B?dndxZitRZGV2L3Fpbkp1eTZEck1xL2FkVFJLZm9CTUdaa29PL3dZNjkrWGNX?=
 =?utf-8?B?TUxZd09qcEI0RENjbVNwcERURThUZmlrVjZEZzBBSmRRRytoMFBZVzVOaCtO?=
 =?utf-8?B?WXE0aFplUHMzRjJYVXhPaTJmMDY1ZWdndW1hMWVBRW1VR09rZG1KVWgyWVJu?=
 =?utf-8?B?NTZ6ZHdqLzMyTlVHc0xxZ2pXRnJacEFSbGpnOXV0TkxaUlg3RDdwcUlyVGZQ?=
 =?utf-8?B?eWZGWHRNS2dKWXdyL2I3NTVhSWpSOXNDY29ha2lESkd4SFBSQU5WWitCTkZJ?=
 =?utf-8?B?N3JUUitIMUxOR3ZubWdGMXcrOUJrc1ZZZ0QwQkhNZEVlQzg0dGVHSzhDTGF1?=
 =?utf-8?B?Q2tBS3dFR29VaGp3SmhUajBUQk9TRThGOXBTdEdPU09WS1QzWW5BMENRd0li?=
 =?utf-8?B?aDZaM1BFUll1VWYydUR5YmtuUDVrZW56L1pJVytlalBnendJeUQxM3M5VDdk?=
 =?utf-8?B?TXJmdnFIS0p4QkNodGdGTDV4VVZzbFZ6aFFPeDBGNEpqSFVXTVRKR0k2K2pl?=
 =?utf-8?B?dEVsSGV4bU4yMXJJNzE3bDJ6YmRhS3pXSFFXeVlySElrZGhHeURTR2hqbXJq?=
 =?utf-8?B?YTRVS0RhNUdvNmZQR3hCVk5zS0hqSFJrdGdrMk1YMXBORDJYcVNlK08rbFlS?=
 =?utf-8?B?SytML3ZwTjJhR1d6MjBUb1grRXR6Zzh4Ym1lcjRGMkFVYmRQa0FYWmcvYUJ2?=
 =?utf-8?B?Mm9lWjF5RmQwa2xYSzZyelpmQXdiTE9HNUgrQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 15:48:58.5688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: febd7aef-baf4-4c1e-76a7-08ddda80ead9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227

On Tue, 12 Aug 2025 19:24:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	119 pass, 1 fail

Linux version:	6.16.1-rc1-gcd8771110407
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
