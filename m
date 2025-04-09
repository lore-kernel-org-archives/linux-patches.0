Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD0525B685
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185656; cv=fail; b=leaCl+0zF4ZALtCjRBgGnlua4QdLD6aN+vMOgv+MoSKUJW1Umx0vF48i6pt1+D3l6XpR3o1LCEkk3d4ZUe0lLjFOM7imKeTtj7Kx3RxgwyvgDoMFFy9I/NW9IXt4NiaseWuo8nAfvPZKf4ln2sRlHrLB3qKHEHn3rq4IgOmi++M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185656; c=relaxed/simple;
	bh=wFUXdTxT+gU18LGF9Vge+C/YZqIYvoHUKOTXaxRrbBo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JOxjFnKRPB7CDo8RyiH2Xnodh5+/s33aZl6rUz9UeWiXrmu7zfAIafZjxm0P7KVdcya+Z1pvvS2xk7S5WgupAehkbS8uPkny6oxSWkKUnOulTUt3EKyHD8uv0OwA7MF3w9dWAGrFgi3q2srxvyGr36DhZmSCNUpOdv35614RzMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=giaaNJah; arc=fail smtp.client-ip=40.107.236.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="giaaNJah"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFWbuU4u67kFarq2D2CwdEUsFmqhjx0usjOJvBXH2OW/Y1HIrDYVuk/Oq1DYoD9exqz6RX5p+8P8+dvwHdP79jN7VSIjrQNhOiZoZxxZ+Ys3SoAX533QYGTNdEB3uNtkEc3d8DAeMwEV3Mu6eHJ5C9lLKxaSG+PNPODL5V904IwV/cyeNBwpmzEoPKLicaQxuD3+GiImc2ctecag3CyE1KdpzqfBgXg0SJYaQwNlep1By2GYpqOs25oIMktZ8Kjv1/wojF4dO5/WI6ETGSFvj3EzeJ0e95f2nQyDW4lurpLoARM0U2pvzoMUMGnkmN4Fxo2raIRE/u89BsyW889kvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzeJc3Y4uDIea6iSgothMkjYwcxragFJxil7O8rGe/Q=;
 b=iVGe52VqLWWLHwHVb57T4TYiph7mjIeVAxBsxo3KxwGTKOA48GtMO1vpu1wJGvbhZu/MRgC9EsoBldhVUaXGjb1na7U+tMV6rn95l0/JH0zLvfOOoLFNYA9PrF1Ed0C4Dy2qIO4YMBcjBGfDQqz/9mZ4KqPgYmPnu8lxGgIctFm4HJZ+sTOfoe4mk5XtVXxufP2GmMvH6wsELaTyDrqTShqooiUIaz8drlhu76rZZsB20o9Bux5g/gOPYC63/BsW5E+ts17dhFOTqeWJquPS9uht7SwWX0/32aj/oZWIcYXoRMKKt9D6qisFC/WU/70mpjKpBnf/rxbA8v2MFoQeZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzeJc3Y4uDIea6iSgothMkjYwcxragFJxil7O8rGe/Q=;
 b=giaaNJahR7+Ew+bvkgCI5A9tOmAO09KmLFeP0GPyZZVk8Yldj+XmJM6pTrR28kSHWxcpX2lsYrAbTEk1ibA3fX+9bGRMSprzAA0Vow5v/GAMNmqhwFpiqqX7OlSQUqNOhRd8DTHUvL8mSf7zYGJWVwf1TjU+V2LTjH2eR2i43C2vb2iD9rueXdAza7STRYTQ/AO1cx3oG4F7TJBJZJDOg82z9zLGa6XlKFIc7rzfKieHl6M2bMF3/xwMy1UTGGV4ycjVsicE+WLRMHEaqwJmXfIhQIH7rA7kTTAiSD4tqMTKKdVrR31gM8u0hels7FhdkaIHIXtvrTwxtn5JxW1G1A==
Received: from SJ0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:2c0::32)
 by CYYPR12MB8924.namprd12.prod.outlook.com (2603:10b6:930:bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Wed, 9 Apr
 2025 08:00:50 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::3b) by SJ0PR13CA0027.outlook.office365.com
 (2603:10b6:a03:2c0::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.11 via Frontend Transport; Wed,
 9 Apr 2025 08:00:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Wed, 9 Apr 2025 08:00:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Apr 2025
 01:00:26 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 9 Apr
 2025 01:00:26 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 9 Apr 2025 01:00:26 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/279] 5.15.180-rc1 review
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0015d367-bd22-4e86-a904-5534f697b8f7@rnnvmail202.nvidia.com>
Date: Wed, 9 Apr 2025 01:00:26 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|CYYPR12MB8924:EE_
X-MS-Office365-Filtering-Correlation-Id: b19835d1-7f38-4812-6fe9-08dd773ca4e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFJLVzlZbnV2NEl6SEYyRVJSZE9CVjE1ZVNtUXF2cStzaG45K3ZEdkU1RUM3?=
 =?utf-8?B?N3NGY1pXZlYwdEpLd2NHOTRPLzNiekhYMTMvZWhxOEpmanQyWTc5WFZab3Vp?=
 =?utf-8?B?NGdha2tza1FqZFh2aW9VVDNwc0wrWjUxazBlOFl6VXhRV3JmcWoyaVg1MkRZ?=
 =?utf-8?B?Ti92bXVyaTVEZ1B4eHl2aFJlVTN2QWJNakV2WFhiRTEzYms3KzNpNDdRVFMw?=
 =?utf-8?B?NDk0YzBsd3BPKzV5ZzR5VWZ4VGdXSngrL3dEampUMmNJQ08weTF4UFF3ajhY?=
 =?utf-8?B?cDFKSElnQ0tvSDZXKytvN3RoNEtyZEdpQ1liOGhRU3pCVnJxMWFudUlSVnpj?=
 =?utf-8?B?VGR0czJDMlk0ZmxEeUJ0UXV0aFpqUWJMYlRERkgySHMzUS9XSkdSU2g5ejda?=
 =?utf-8?B?NDhzc3pSUm8wTGVGQmVmYlZrK2I2SDFaRjU5RmJmemN6VUpETU4vaS9sWWJS?=
 =?utf-8?B?TW5rRnh3Q3M4Tk5qU3BoSmNyd2ZvS3ZxeHdpdStmcWNPam1MZ1pTYXFJREhV?=
 =?utf-8?B?WmR0SS91QnVPZUNOU01rdG14RkxUV2NIS3dienZpZDBlSTRCRlU1emplUVJ0?=
 =?utf-8?B?dHZzWDl4YStDOHIweG1YL0poSDlmUDdSSWJTUHplZHloQ1BPTjdwa0l2ZkJ3?=
 =?utf-8?B?RzgrV3JDdjVZV3FlQnQ2b1FWZlZOUk9pMHVPdG80RFE1QWpoQlFOcThsd2lS?=
 =?utf-8?B?SHp5MkVEbGtMem9ZSGlDVEh6MFBmenkzQnZCWUxZMlh6TnQ4dkVVZ05mSW10?=
 =?utf-8?B?ZkhCdU5PRkdFMElnaVZQcklFbnJnSng1K1hWWENtYWt0cWhSR2paNGVGaGFu?=
 =?utf-8?B?UHBHSVNZL1ZMNmprUzlmTEcvSXBmcVduenB3cFgzVXgvdGd0QXA4RldYMGxl?=
 =?utf-8?B?cmRwKzZUNVBLc0RPT0xyY2ZBV25BMVQ2WHNDWWhHbGVQYTgyY2ZiQlB1N2cx?=
 =?utf-8?B?a0dBMnBKMXpmcERkNTZ5QVN1S2RacThub0pLM29KWEJ3TlZYVlJCSU9FWjEv?=
 =?utf-8?B?YVVUbE53dmhqbkxhckJIMVppQVp2MjAxVDg5ZVY0cFNNaTBIQ1h3UW90WC9L?=
 =?utf-8?B?ZmhiOHdYcXFQamZYZ3NPRkpvNnplZjJPczkzTFVsbndTaUVCRWxNR1BwRXhy?=
 =?utf-8?B?V2hUZURYTm94amNhYi8wNDBXQTRGcGtKMmFTMkxrb00wN3Z4dm5nc01nYTIv?=
 =?utf-8?B?R0RRVzI3cEFlN0JnS3VHTDNJMlVac25UcGNmSlI0bm5oL2tPNEIwSXpUVHpJ?=
 =?utf-8?B?OWg0QXY3SDdJYUIxbGdURU9tenlDWmhBN3NscU41L2NNV2JqYVRxbGJHY0Vk?=
 =?utf-8?B?QWJwNkpWWUhxMGlmcjFiQlVhMFdqT2tRRzZnc0U0Q3JvTk1NMXY5TUN0ODVE?=
 =?utf-8?B?R20xSnpyZk1PS2ZIeXl6WmJveCtZSzMwMHhjRTZaOFM5cWNpcXdCeGY2L2Yv?=
 =?utf-8?B?WlhuMVZ1YnRpejRlcE5WWjlhNEJNWFJZcDJmS2xiNlZCTExUMHVIR2x5Y09h?=
 =?utf-8?B?R0NZMU1ETkd1SUdKSEEwQzhMVDZmQ1hCYk51OGJrSFBQWGRtVHRJN0xWeVJu?=
 =?utf-8?B?UnIzZVROaTZacmFjVUVCbjVqbHhYZ052aU1VaDBVMVVNa3NxRnJOS2ZWNUYv?=
 =?utf-8?B?dHNtYUtkVFBmMVJuaUJFRklOa0Frc2lrZ1ZyeE1aOUt6RzM2bmdjRzRBbUw2?=
 =?utf-8?B?ejdFUjBjYkNKVTVMZjFUam03aldaRUFXNGU0R2c5MnZmUXZwMTNoRVZZOVNo?=
 =?utf-8?B?V1ZMVVNjVWpJSlRDTDhwOVZkcjJqbldjcktwUWZrWXlzanJkMnVsZ0RWVHpH?=
 =?utf-8?B?dXowOFlWam9HbVlXSllhYUJsYlY5cFRnTnpPSG1Pb3lMQ04yMDFsbEMrS0Vt?=
 =?utf-8?B?T2d3aGptdHhQQ0kyNE9nQUJNMlJwaGZueDNxd3ZhMHhTeGVzNVl2Sy9XZkJy?=
 =?utf-8?B?b0RMZzRRczFSUWtoS1dodVl5MWpXTUpvclhSdGt1elB4dldlR2w2NldFdGdh?=
 =?utf-8?Q?xB/AQsMRWYoR21aveGRBdQf7qDw62w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 08:00:50.3274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b19835d1-7f38-4812-6fe9-08dd773ca4e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8924

On Tue, 08 Apr 2025 12:46:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.180-rc1.gz
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
    101 tests:	101 pass, 0 fail

Linux version:	5.15.180-rc1-g0b4857306c61
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
