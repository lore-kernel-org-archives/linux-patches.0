Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4543013CA81
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462180; cv=fail; b=JvyRK4XjKJBB+8QZS0hhGivQLnBB/GvNUmKFjo1GqXSlt8jLGCS1x9ZqHgdPBrmWQLz9Af7SV1I2jLnTfgkeWGpxhXFu2JW+rBfCVxFDG/2DqQhVXXvBVEID17y5DcN5/dK6PanB6FPtNaXDAvoG/uHwMhN0SbU7ow+LSNVo0gQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462180; c=relaxed/simple;
	bh=nZQyQxIEi3q818frfY4VQTlvRZ4QxqSxbXl4fjOf8kI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=j7CTNYo5Q2HovdPpwh1KQYKbTecLToosV0HgwgC1OE0wHLxJcQm+VjlowE1ZHZVhVadMQfOH/oE5iM0TuMk4f56lPAw05SyGsMDyt0yblYhAva6szsopfOsHnhj8lKbxtfxTcG1rqDeTVc0lqfDgtwKvkDcogG32+nPj+Uil5sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nBEpv99h; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nBEpv99h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4mkXo9b62KwNAye0zYWPxF46AmZlWJ5VI/PJV6VCL9r+rZW2VFXG0g0ka8mpgubARXEdSnwpKnAyCdOD4UqjBoeJ6UyUdK3qutHuDIPc9Yvh2bcExQxo4GSVwA2psxKJ19tZNVc74xjfqaWdX+NDMEgw2NIcy2ZbMN1usoqC/ptO4Lu2th20YuKotP2JQA1TzUHtxBkpgJ6yTxVEBf8LayxQcA+pKvSMEl5ITK6th3gR+k2x4l3kDK/Th62M3p5twys0wzMql/J51rIo3X/pj0MZ56S+bHvSpB2fqk1F8WXhnSBKfJt6zVrX1gt+o0EPbXdtVPD0p6P5GqwWt4cKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=memyL1sJxUQ0vRLWelXX70NxHdMeQFOTF0iDmElwkR8=;
 b=sUWeaC2JGF72vBEQthsi5r0qhTnK2/LwKRBo6pogCbvXq62SkJ6dfigEHrDCGcpxlUdbQEKDCSPeEutsjJzv0qv1j8sYy1ws8/02g2bR617dpaw9gBGxpG/b2y5lg3Gejm8AANccfas04TeZb1Tfvb2KQgFCk/3HVJdv686RXyZYX/xStt0Q3gVQwllIAsr5key1w2ToH4DZFjk7olmCDRWVh9VmPC8PEJ/JVtU10DoKAVqvGrylehb+M1GWbwEzHybTEP9PTltRxJIJAqTE01sYLWDz2SFacXoQW7OiJGb9ExjbXO3aPLDUHoB2E2bxwz8XxL0PhpaJ0z0ufcHBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=memyL1sJxUQ0vRLWelXX70NxHdMeQFOTF0iDmElwkR8=;
 b=nBEpv99hJfZWi7nGy8tXpDVsxUUI/ivbxzMYI/pVe218wYL6OuadLXDMvkcURP3Td993BH2QSgc8WFjV7YzGfghuKNNjcgZ+vLS5GFU1EEYfMNgJOr9adl7lU8+EDNIChFf6WWD8sAFkUqR7x94wi+NUq1P5yqhixdqWW1BhqmTgfzkaV6ohPkubBvtKP8EMbeQdrToZIfhvXpOsaQ9p5LJ8p9iyGnRm67NWdfnAh45m6puwvhVbf1KiiO9M74SHbSam6XwSSmdctKaLROILYAA8GjmK2PTbe7++4l1z+JuS9kOElgbBve1mztIDAX6ZiYy86zGpOidxUi2ZgBlgNA==
Received: from CH3P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::12)
 by CY8PR12MB8363.namprd12.prod.outlook.com (2603:10b6:930:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Fri, 27 Sep
 2024 18:36:15 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::2a) by CH3P220CA0013.outlook.office365.com
 (2603:10b6:610:1e8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.23 via Frontend
 Transport; Fri, 27 Sep 2024 18:36:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Fri, 27 Sep 2024 18:36:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:01 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 27 Sep
 2024 11:36:00 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 27 Sep 2024 11:36:00 -0700
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
Subject: Re: [PATCH 6.6 00/54] 6.6.53-rc1 review
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c2c3da11-7d4d-4062-9dc6-6e8f7b179a9e@rnnvmail202.nvidia.com>
Date: Fri, 27 Sep 2024 11:36:00 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|CY8PR12MB8363:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ac5b2d-b8ff-4bac-a295-08dcdf2344e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0tXWGpSeGtNZDBKM2x5WE9NYVlVR2dCa1ptRldia1JYT0xJaFI4V2pWeWFH?=
 =?utf-8?B?cjZ0amNNanhubDZ1VWkxbUQ5cXVxSFordUxRa3BPbTkxbE05dng2VTFmL2ox?=
 =?utf-8?B?NDJRMEJCTm1SdGNzUmlSMWxQUTBYdXQzQVEvWXlFOEkzQzBweDZWaVMrOGlX?=
 =?utf-8?B?b2srdHJtWnRNZ3orUnNnaWlzaU9YazJvZGpwcStUVlJndEt2K3VXam1vQlJv?=
 =?utf-8?B?TmluNEwxdVBnN0ZCQWR6TnhxdFpWZDZWZURnREdERmJCUTFGS2h6MjJDbnhX?=
 =?utf-8?B?eFhwbEJZa2s1cHh6TUMycTdTZWlVVkhSVlYxMm9TUE5mZU9mcDBtdjM5ZEc0?=
 =?utf-8?B?K1JrU0xwYlV2QklKa2ZtbXhPcFVFRG1GMDh2QjlFUnR3QVo0ZnhROFkydFBK?=
 =?utf-8?B?VDljTmpMNXJ0cCtvZ05JNlR2Y1hCZ3NQNCszMlVkV3h4UmZVYk5URXJoNytq?=
 =?utf-8?B?azk3blJtMGd2YzhNMDhjeDU1OUtTUHk1cUx1Tk9LOGJUd2d0dWhPVVBWWVRI?=
 =?utf-8?B?aHduczF6MGhyanVRdkQ2YytySlJTcTlRYktvTEdoMk9EYW9YektldGE3QkdZ?=
 =?utf-8?B?SVZEekIzRFBaaDh2TEhsWkFkdWRxMmhuWDBEZy94VFhnRzQrZnhTQjl0RlpR?=
 =?utf-8?B?QVNJUUxtVzd4YWlMMlJvNGJocm0vQnliR2dNdTFScUpmcjNmZGVFZ1pQRUo1?=
 =?utf-8?B?Z3VZK1NucGF5bGllWFYwWk8xNEQ3WXJkTWRYZThQVllZSURDRWdSUmxmU1d6?=
 =?utf-8?B?NzlzNkkxckl2NzZVUWt4bDNPYVB4d045RmZva29wV1VLRWNYOWtRbWxldklP?=
 =?utf-8?B?ZnVHb0hhRTFWVnV3NjhadUFjQkR4emdTQ0laY3BQQkJQM3lTQzNJL0NsUzY4?=
 =?utf-8?B?QVg5bzJEVVM4NW1Lb2Q2VUNpRkZ6Q05DLzdCTmZvRVNvS0Zhdlg0SU1jY0NZ?=
 =?utf-8?B?RmpINXI3UzJKMDRncldEUStscUpLeURXaDE5Q1pybllsT0hSTUpaV00raVVw?=
 =?utf-8?B?MksyTHBXcmNKVHBIaWYxMkJhSzNnOFFPck5CbU9vQTkzUk8ramE5Yk5CeHRk?=
 =?utf-8?B?QkpzZEdHQS9DYlR6a1B2OXVoSFZIaG43cXV3VmJieG1WTXlJdkxQRzFRampy?=
 =?utf-8?B?TGJiVmxtQjZPVWlaanprNGRiM3VVLzZxSmw5T29ySFVBR00xaG5qeEhWVFZm?=
 =?utf-8?B?b3pKNTdXODBPNGw2N3Z6eEx5Q0kxQ3F0YlhaTTc4YnBMRzc5dlUvc0lIVWw1?=
 =?utf-8?B?TTJSeFV3UEVPMkZwcnhORHV4UHR6TTdkN2VPKzkrUFdCMDh5TjB0WFlHQ1lJ?=
 =?utf-8?B?SGJSQ0RQZ0FjMUdrUXMwc29GcFVzM3orUStXdjZKTitzeGVnOEtNbkpvV2Zp?=
 =?utf-8?B?dWgwNXJ1cUJwbHMrMUszcDVCZWVKUUNFTmh1WnY1WEkyS2Z0V1NrTmZDSWNS?=
 =?utf-8?B?V09aLzNTUFZwOEE0VGhZM0o0T29hSDJWQXlCbGlqRHRVOTR3U1lqU1htWFJJ?=
 =?utf-8?B?cTdDanNhZGkxaHE5OFFoQ2VxUGR2Tk45MW9YY3ozN3BEWFdUaC9RYm9BWWMy?=
 =?utf-8?B?dWhjN29Ob05lZlNWTGtPMi9yVGsrWE5HUVREZkRTQjVhMHgwZ2ROUm4zTWlo?=
 =?utf-8?B?SVMyUVVYdVREeDlNQngzc3Z3eDZkWWZmb2ZWMXJNdng4cTdWWUZNSkplL1hY?=
 =?utf-8?B?RHpnSGZuSldINU8yY3BtU1daWkI5WHVMY3lnOUZCUWxjKzhEYnNlSXpqOVRC?=
 =?utf-8?B?ZEtWWlVNR292dXZyMGtla1NPZ0g1RVBhV1Fzdy8xTm93YWEyd1NiSlppcndl?=
 =?utf-8?B?MG16UnBadzE4UEI1WXNMaGxZeUJSSG1zTTM0UHNBSWx5K3Ard3F3cnVQWjIz?=
 =?utf-8?B?YXRnc3R6ZVhSdFpBN0tHeTZ2dE51WVNmTmNmaEdYdlhoVEVoY0tkZWZzbDdQ?=
 =?utf-8?Q?QK5p3KOdRDm6Gkx+fhW8BYdkBvlLP9Od?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 18:36:15.0889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ac5b2d-b8ff-4bac-a295-08dcdf2344e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8363

On Fri, 27 Sep 2024 14:22:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.53 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.53-rc1.gz
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

Linux version:	6.6.53-rc1-g3ecfbb62e37a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
