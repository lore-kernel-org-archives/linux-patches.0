Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64B3264A86
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755698878; cv=fail; b=uBV/CKfGVteoawP3UsyhQfA0Z9XOSQSXLqUhri/X7z+d3pcghAl6MWhxRyWyy0gUMWPVzj997IT2yfVrLDvYGM9jlrVCBHNp+UjQRWJUvB3beDGNmkxrpUc0tJkxJFAsU5pVheQojk+fzYrMKtdWXm2DkLYPy9LEscQKEb8T92A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755698878; c=relaxed/simple;
	bh=nFc2IqzaHRrHfyGbhNBsaNKlLbDSisjStrBDMV+qohM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=J9qchUS2DIsRE/qBPxbab8F15D8BofLB0fedXYjFsWqo3D34GSdpyIJ/qX51Q3QD1KDRuaDYmubYXH3zcbmJMx1X9zZOJotJME0RIh3cPbhOELf2uCzgHJg/xOfOnDV+R9aWKXN09889D8K9BN7r3x+NClFcHrBsbAHimeiYI8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aizA4hGC; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aizA4hGC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jNA6l183ol7PUOK7VE3UbkhyrKVS4lq9TAMlfd4AJY49kD9C9MD9EJzq5YPW2inQulu3Q1RayNcUcJ57ubuSzKIlabEBbpYcTs4SRPYE/lFG8GZxvfIUe6gk918AiZrrFK494IURu9YkY78131lzWdQkzK98uGE0tVACHdMSb1Yu1yAhfOuoEMtAZIyX91E25TRZS1tGWbWpJZzXULkBVtNqOjrn1ClEVohUX0dVb5X7c1npRTEnvKpocSHjYlngApNYINlhBxXAkOahM/vD1gpvZYsd0naZDG9oJ9eypWBUhjc1QKd72cp5nmFbSXKA229V/A03riW+8NvX3ToAyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8NDNMuGdPLZs7tWlRpWFai7Q4/1phaRzgMI9a80/Zk=;
 b=So7WMWm7YfOt4egck18FbccnBRqBLQ2WX2WWS/4DMFWumUHDAZOLFizEtkqhAZ4hxXlF2pHpU4unpxN3lojPlVkr6tnRpFYPH94sLIAAJYwsidrChtmq7Ik+rQda+olv89pJi+EhRo9DGusrCAn/btB/0nU2sBHMSCZQ0CXmJcAuxEkQ63Q6vlMhyBbBNJ88+KfxRALRKZa/1wUSBrejVgiw95bVGftIsR4F60239/cRTMLocJXesbvHM8XRrFr0aOv1hKdV7JACQQY4riI1mlDf4kKhMSPEUuOHHVw97r9n6/BeaPTzJQK0QhrxxVwdwROkhjamL1gydmJ6bP7H7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8NDNMuGdPLZs7tWlRpWFai7Q4/1phaRzgMI9a80/Zk=;
 b=aizA4hGCGHAqJ+Q/YGCkvxmbXE3glD+7byfahTuqBPeVRYcBiTYzRdVFvIQzk7mKKW+LY5YNj4GMuCbM6Br3ZtHKWusjPyj1ynQ5PIkEh7JbJ+ueaFY9JHd+UEtuMzwalVNCWVa8IaNqdWZmzFiYG/7y+K0pecuYZfmZUI9NrPn4iFSp+fSdzusmOTicHEHBnTUQKPfcMKUL9TzoUL7mgdnZqYDVeJ66TQfO5p44glgiqpjezPNqw7eVtdoS4g3bG61uOyea0Wq4tOKKXGztlTp5AqyDxQN6D1eOqipDhks/eYfelZHylA2J3dTiPYpEoY+fR7ryfTca1xaqrkfryA==
Received: from SJ0PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:33f::11)
 by SA3PR12MB7807.namprd12.prod.outlook.com (2603:10b6:806:304::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Wed, 20 Aug
 2025 14:07:51 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::2e) by SJ0PR05CA0036.outlook.office365.com
 (2603:10b6:a03:33f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 14:07:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 14:07:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 07:07:27 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 20 Aug
 2025 07:07:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 20 Aug 2025 07:07:26 -0700
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
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
References: <20250819122820.553053307@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <628f4d0c-ce84-4f4f-867e-28c2e556afe6@rnnvmail203.nvidia.com>
Date: Wed, 20 Aug 2025 07:07:26 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|SA3PR12MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a70ad7-3e3a-4541-1826-08dddff2f35d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1kxcmJPMDM0RW52b3pXemkwb0hUVENhK2Q1OCtlUkNoZ04rVnlBSFVSZVJ2?=
 =?utf-8?B?bUw0UUNWdi84a2NzR1BzdlBJL1VzUWZwQjNRaXZ3U3M2aERkSUhqR2Y4MEFV?=
 =?utf-8?B?RXFMVW1uYitrYTRoSW96RWdjbCtMb3dFUlZTWlArK3FoRktuRHVWdzdoeHB3?=
 =?utf-8?B?MkNrL0hvT0hLcy9UNW4zSnNvb25neCt0eVJjai8yYXVRSTE5Qm40a0JSeG1Y?=
 =?utf-8?B?eFQzcUJtK2FkZGJ6MTR3M005c0wraTNEeGVxbTZaMlNZMXZod0tpTHRHVXE5?=
 =?utf-8?B?VjdQT2VXY1l3bndQNHRaTnF2Y2tNOElPVTArblBUYWVCT3ZpczJOQ0o3S01C?=
 =?utf-8?B?TkF1TmZWK1M4M3F3b2cxbnJreU1lMVBuR0hOcGl5VlQvR0FNaG8xOUR1OHlw?=
 =?utf-8?B?aVVRalAvMXIxRG1OMzJFOVErRFFTS2J5T0FYOXBiN1ZaZE9ZdnRPR2dzUXNh?=
 =?utf-8?B?M05zSFNIYWhxOExCL3VtTkJScmZYYSt6aktsN3dxbHVKaG05cG1CeW1TUFc4?=
 =?utf-8?B?ZDBjZDlITGxlbS9NS1NrZE9EZlZZcldqTWYrL3FRSWlOVVNFVlFHRkIyNjZH?=
 =?utf-8?B?akZTY3J3di9oOUp6dWxVMDJ1SUZZRlBuMjFJT3JQQUdWVlArR3FCN21PTGpo?=
 =?utf-8?B?OG1hNWxDTm04cDNqMXlUNW5BSmI5UnpzRXFudFF0WGJqNkthd25LczZrY3lN?=
 =?utf-8?B?bEhWaExHS0N2dG5iVHhsaUZPOGxkWHA5NFhtUHZUQjgrS1BZNHBSV29SQjZt?=
 =?utf-8?B?UHkzVlYwczBBOGRwR0s4UTFsK2VxWURMdFJoK1NxejdrMkRKNHZ2ZnlzMnpT?=
 =?utf-8?B?bnJwM3pIcmFGdHBaQ0k0Snd1WGF2bkhuOVIxU0ZxZkFXRy94UDhyanZIV1B4?=
 =?utf-8?B?cWQ3ZHVOZjZObnZReXIydmxxaFpPa3NGOHkva0w0bTJxTjY2bW9KK21TNFRJ?=
 =?utf-8?B?VVJob0VHYUhDblZNdFZwQmZVZUZEWjJ6b1NNSlcyRk5NKytRc3NiS2Jzekl5?=
 =?utf-8?B?SjB4WE5VK25yMC9EWHdkem5XZUovaXZIL0taaTJxUkRMam5vaHJ3L3FvaGJw?=
 =?utf-8?B?U1c4RmwvZG1zV3dRRHRaWVRYQUJPVTBia2ZWcWZ1TmI0YU8yRHFYQXB2RXJp?=
 =?utf-8?B?b3BhaHBHNDNkUXcwT2wvR1VzZEllNWNLb0drNGFKSVlZRDFlb3FrL0RUSFdz?=
 =?utf-8?B?QzVRZnprSGc5TmNOZUpZbUpHMFlNZlJRWEpYUkZ3ZDBTOHEvVmw2Rk52bzFq?=
 =?utf-8?B?MXZpMS94R3YyTGp4TS8xUWExcDJQVmZDUUdmRktMc0hZdUltdVZCMnVMbEJC?=
 =?utf-8?B?RmJpSjVMVzlUcEJmc3Q0WmhSRWY3RTBCdUFLRnBsUHp1RWJTaDFUTURqOURy?=
 =?utf-8?B?RGo3Z2pvQ0N5b2xaeFlzdmN0WWpwVlBRRnhUUFVRaEg5ejVEbmxOdWQybFVC?=
 =?utf-8?B?UmxxU0pJeHFpTTJGcXJVM01uaElvajhIZFJXZjZYYzZyU1JjUFIzRUZhSy9B?=
 =?utf-8?B?WEFkSGRqY3c5cUc1TzVpR1RWV1BsUTZSRnV2Tzh2WUpvUmMyUU5JYlErRDM5?=
 =?utf-8?B?YWNWcGt5S1VKSWJEZDQ2MGlYL2U2ekx5Zzlmb2w2OHlHdklvOU4rZzZpR3pr?=
 =?utf-8?B?RVQwOVlQaGJJa0FCN2RYZmlWcytzb0VuY0tPR3RPLys2a09XdkdGRm1lREVq?=
 =?utf-8?B?NXlTWXZpcG0zWUlaS0tGdXcrZDNONklmMzhrMndyc2JpT3lJZC9MR3VCNi9B?=
 =?utf-8?B?TjhNd1YvTnA2UTY0c1hRU0FFeUhhdXh4c1pMREJNOFdHTnlsZE5KTUhpUjVv?=
 =?utf-8?B?amozaStFRkM0UUd5c1JzMTRLZkZ2dkR3SUhtclNQMGt0REMraE8wcmd4ek9x?=
 =?utf-8?B?R1g1Rk1ORmtBME1VNTlmbXhDb0xYSUE5OGVxOHJocEc3eFY2S01QUG9kT2N6?=
 =?utf-8?B?Z1NVTXNnWWZLZ3dBN3ljU3FUMWhPaDAzZDhsb2x1bkNpZlphdkY3U3NMMjZS?=
 =?utf-8?B?K3V4V1hpSUY2VWFUQzRubndaN21MN1ZFVWtmOG42TW45d0lBUFBjNFRLaGsz?=
 =?utf-8?B?WUcveVluRmNGaXNqK2s5cTIxWHRaUjZoRUJidz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 14:07:51.3153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a70ad7-3e3a-4541-1826-08dddff2f35d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7807

On Tue, 19 Aug 2025 14:31:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc2.gz
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

Linux version:	6.12.43-rc2-ge80021fb2304
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
