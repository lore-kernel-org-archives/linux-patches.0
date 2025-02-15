Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2211EA7C3
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739636555; cv=fail; b=cBlouSy7OMQLB9oIpyIsC7MgT5nBiGVbPMT457aeTi+f/owiwhsbhAU9+AvFj62JB3hlmXtjQr/6M7vqd8r2T3DFVsPZoRHh7Cp1L+WkSe9BfsS/YHNXknl/B7So1w15r9k5gt7lB+M5ceLTJd3iQ4LdUSS+mvpmuvKgERNLgws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739636555; c=relaxed/simple;
	bh=YDg6pmrekFI+Asn04OmgyH+oXGGl+3CQrypGcaruB2g=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Bxz+nU9oi3FchnBCSAlsCX1pMxr0QGAlFBH9Z7QysFWCLsJlWA4dn1EPIww9UE3KyptV9zgQqubGORTmAnqgC6q49tjzBIrPxSNe9Jii8O5zSjp/gWqpgaIe0YLdeh/1C1vxReFV/IdoBVeEKMoLzdq/MaNLJdT6Mt6ecdqzfpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WqkzfAs7; arc=fail smtp.client-ip=40.107.102.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WqkzfAs7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pyU9sMwXWSHZ0oAt/Slf8HEXigEfE7KkLeQCNO+Ndka1ZHhEkTjqMdBwTRUbkSEYOh/rXLk1Br1M0cGnaBiCF6HNvwWG5LWz3X0cTkP/o8DDDHuASYuqAOG1f+CJyXm0otjOUU4U2klZwJCpUKFofZKPmACRfXyVxnMErqt9Wcg+BrAFKkAAa7wviJ3G0uVx2+L9PruTjliahmsc4bnwXmDl4+ZhnLGPNqJJYmsDczDXUac7Q+zeKsdfNveZ1bsiyPwtwIR0Yl+uoox1GjbJI1/72M81OBZgt59ZnlmRNqos9MSx9ydHHZiUkAzqdaJTzeRnvNUl7p6teqWUoTqe9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEor1svJTSEQpXyKKMpVJN2cHhMXmapdImXoL9v96i4=;
 b=mm151v3ySsPjGmK1vgFZMdsuguVv9DLjiJ18KYp5tKweFPOwXtUnRx7cdeuge9SSRo5F8CE/QW1gepXv3gn09RVCUcl9VXT3mmGKZPzZUOpUcYE/PEZEwjYuVLyQjx1Sx2EOOJeTRyq7R55BK20tpFM00RiaOb2KsIhbr3ayYCzMUDnSEErFUqT7U546JD6Ms+KIx0lIx4995vYfTflKyVC1dZzvCtGCnjSd5kYamWnZ9kW8I9jSBO5e5XBviVHOj8FniJN7VAPYNS4vFCGPdwvkOWpX0tVKKHzoIm9Mb/kAd08DGiEqS+ZNC7iyFbcpIM7YUFuEs8fTfEzHDw4z/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEor1svJTSEQpXyKKMpVJN2cHhMXmapdImXoL9v96i4=;
 b=WqkzfAs76yg2Q7Ahz0dZrmwBURA5oIfqy8No5xybZ7jCFJN/FALS4ZYcDGTRNQEHxAsGJcytqmOXDBI5k+VYwwIuhyn077/njDUVnSgkEPJIH5cR4K5+A97r98hUm0wEzjUAI5GyJnmwnKJX8unhdYKRzNRHgpthUtTKnefzhMOE8p8NDhiEYU46Kz4rgepdeN7JPKxbIabd5XKbYa8TYZQSwGXjzuVaLzkQe1NCAjTHlHFxA2t28VWvHIqSKQmBU8BE5WFlazBNoGJt9r8rz1/mnMLo0JaUS+MHCnrDVZ5K2ZJetRzyISbeViTjh26SJccvT/mdfmvnoNPrYCM74Q==
Received: from MN2PR07CA0012.namprd07.prod.outlook.com (2603:10b6:208:1a0::22)
 by DM4PR12MB7647.namprd12.prod.outlook.com (2603:10b6:8:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Sat, 15 Feb
 2025 16:22:29 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::f6) by MN2PR07CA0012.outlook.office365.com
 (2603:10b6:208:1a0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.17 via Frontend Transport; Sat,
 15 Feb 2025 16:22:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Sat, 15 Feb 2025 16:22:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sat, 15 Feb
 2025 08:22:17 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 15 Feb
 2025 08:22:17 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Sat, 15 Feb 2025 08:22:16 -0800
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
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
References: <20250215075701.840225877@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <03f14aa8-b4d4-4f13-9000-fa03c6be2ce7@rnnvmail201.nvidia.com>
Date: Sat, 15 Feb 2025 08:22:16 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|DM4PR12MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: d948e749-e13f-40c4-b206-08dd4ddcf17c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkluS2psWVVpc1hFbTc5OUJEUVNrNGhVZUVxdEdhdWJIWGdjZUFFU0ZnUThr?=
 =?utf-8?B?UFFaN0hZcUdSaHFtTnBhOERkcHE1VkNiREFVZlJJN1BFbTZUOUFKUTRHWWh4?=
 =?utf-8?B?Q1dOQUxLekVRQ1phc3ozamRCR21uQ0VDY3h2QmdFd3BIRGFPZUVVNzlaQXM0?=
 =?utf-8?B?dk1XWDkrZWV4MFRmbmpQdk9Sai84MXlxVThCZGNOUjQ5ZUljbEFWR092em5X?=
 =?utf-8?B?cFBQRVQ4WWFRSk80VGhmakxCYkRNdDdvbys5S2FqWUN4T0tlem13ZXVGUi8v?=
 =?utf-8?B?KzRKQW5QS3RwSHcxaTYzVnVFbFhBSFlWcTIyR0p2WGlYTlowNTJlODhlT3Zy?=
 =?utf-8?B?OHlWRkRPek5CSUhPQWxxajFxM0tyRy9EU2FhbDJyQ3pXczRUbTBjSGhMbDEz?=
 =?utf-8?B?TGVtd283T25UN2syM3BwQ09MMG5pTGNmZTFpb2doeVRtSVdISEI0UWM1Vm04?=
 =?utf-8?B?dE9Ma1B0TUsxQXR4QnkvNG5GU20rS2ovSlFQYldLbHMwMm85QnhWeitYeis3?=
 =?utf-8?B?U3lrWEdqSGhnaHhKbEdJNkNmK0orc0VVNzFmcGE3TWkzY1dZcE1IVVRUSkox?=
 =?utf-8?B?MXY5Q3c2V25VYTV3UjBMdE8wZVJDbTcvZkRicWUwYmNSdWh3aE9nTVJweXFF?=
 =?utf-8?B?cHJ0My9tOUtWYTVaYnpXMkVzYXdXT0JTVHBmUzBjc0RKa0JsMGdLOG1nUGM4?=
 =?utf-8?B?SkhteFMzWFlrR3NyTEFlMi9FY2licE9vVWhDWGFMZUZVTE1ZZnJBTi9kb1NY?=
 =?utf-8?B?NG5GMUVDeU9VMlFYRFZjUVVEeERHOEdKZEhqZ2RIZWh2YVh4bmdOc29KbW1i?=
 =?utf-8?B?UlMwT0tYMFVUdGhDc01MTFVOTTBBZTJCVnNIeU5wV01UdzVMTFFodEE1MG5F?=
 =?utf-8?B?M1UyZmREMHVrTlozd1RmbGNvVS80aFNuNHRQK09EL0Y1SXJjdmp1OW1NSkl5?=
 =?utf-8?B?Tk1EbDZ4Vlk1U0kwekRhbGp5M3BSMXhRRHZva0VhZ0tYRWMzNkFqcE5PVlpn?=
 =?utf-8?B?UVNCdHA3QUR1MWpESFczdE9mWkRQRFVsRC9ubDIzdDFkUG5pbmJQUkdIWVls?=
 =?utf-8?B?Q1oyd01vb3Z2Zk1VNjZTb0NESkxEMzBBRmxoZVUwSm9Nc3Q0RXpZL0hESkts?=
 =?utf-8?B?c3FqUVlUVURtOGl4eVZZUW9pcVR4WVZ3ZWlyQm5KMVVXeWU3NFEwb0xzVnB5?=
 =?utf-8?B?Y3dTTEYwb1N2U3FVM0JaSmR2YWxvcU9kRFR0MVFrMnFua0hMTit1eVpZSFhV?=
 =?utf-8?B?ZG0yY3cwYTBWTDBUd0pRKzNjOENpRXVtVUVsZGxzMzJxVTd0L0NpMFViNk9E?=
 =?utf-8?B?cUNiSjR3aCsrd1dUdzlkVzNHZ3orSnlVQ0kvcjdqUnJ1R1NSeE1PdURtWmdK?=
 =?utf-8?B?SytiNGpjc3pMZGwzL3JUUk9TZysybjluazJaeHpFMm1vSDloZVJ5M0lXaldH?=
 =?utf-8?B?d1Zhc0xsVUt5Y096OC96VHZITXFhZXJoNGFzZnBsVlRzTHF1R1VEVEJPSlhZ?=
 =?utf-8?B?Qmc2T2xHZ3draWJmRkp1QjVoSWROVGVHWXBDSm9mbWdRL1R4ZlVXQWhQWGJ3?=
 =?utf-8?B?ZHM2QjlzSFR3bnRROUliMDNpS3pvS29Tay9SUWQ1ZVNYbzM2MlpZbDQ3Q00y?=
 =?utf-8?B?YmhRLy9CWTlwUG5vU1p2Rlp3RHM3RFRwbFoxQ2JQTWowWFlVSk0wK3piTEl0?=
 =?utf-8?B?K25sTFhMMER6YldoQURtb29EU2VjdnRYdHdlc1J1SFlLN3JvcXZ1VkRGdUhL?=
 =?utf-8?B?Z3VQRlpBdVJES2ErL2RVMXRpTEFZaG9XZkJFVFM4bFM4dE1tT3VXdXVXTlRJ?=
 =?utf-8?B?YzhhdVBTcEZqWUluRy9YUlI5a2NrWkZnSVJSeExlU1BZZmxxUm54U2NGVFhm?=
 =?utf-8?B?N09DUnNRSWhnRFB6VWdzd2lmRkNrUElBWFRqc3Avb204WFRPZm5pVHpwYkti?=
 =?utf-8?B?UXYvakNNaDRVeUpGcXpNMmJpR2lFMUdsb1VmeDJRbW9VU3EvRGhsa01KOGVz?=
 =?utf-8?Q?uznb7Vj2hYBTQu07cwgJVV0rPCRmZQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2025 16:22:29.4072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d948e749-e13f-40c4-b206-08dd4ddcf17c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7647

On Sat, 15 Feb 2025 08:58:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 17 Feb 2025 07:52:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc3.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.14-rc3-gaa95ced31609
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
