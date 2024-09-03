Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F0019F413
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353232; cv=fail; b=UmjcE2AmrC5HJhFAsOTrcEMXKrHX/4rlRKO3MMTNHNPmBhaiIMCIN6GfpYDVUgBrljG33D17nx8EZ/vVv2uQevDvHT2cSw+v+HZmD2nD8KezvxAE3Z3EYIhRBqWOZnUYIRwx/Ehgv7mwQbDjK8ZZ0jQaRRQL4KP1Vv/rjPenSks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353232; c=relaxed/simple;
	bh=MIgG/sPs9Lk9f/Cp4EjngRkdtWd+IcZIG1Is69ropMg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hIBJVT8wwU3TxWkTR491eTkBFnvfqQsipoyGk5Mz0R1d+4VedLk5PgukbWJ+0VL0qb0roc6vtgdb9M2WUmakT/bYctazkdC1BCXMkPlfhVmAF4SYIstdFWnDgb5eL9tdyL0rpvLw9vDwcuZFKnl43DmuHfuGOMIR49B4KE6R/5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MwMWXaH2; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MwMWXaH2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bjff42o+juFCFCeamt/RYoWcpN6bCaJrbeoOElqBbSyauaptiMfx4NuzGDIy3cH/Nsj4mzRiUSn2sevV9z3Rezbx9ZiOc8df7i0r8lV7ra1pnzlDbcfPrH1XKzswmENJ+j2u72LfvPxncWOG8bX9VaGPG+uohQqFoAx1buvvwK/EbK+dr6pumZigC13TymjuKCQMNhk1xqvEi+0r5Lbbd1nylFHonxizEVmhPSZIvdr5R5Tsa093msDjO27rx5s+LPzNwj0dPDUurNqwnIH2eLP5vzeSRwo+E4dD7sA+5Nrqa/JC6FPWypMbA+JJSYFobx2x5sUIK1sjQSVjpSyCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exOCVEVTNE9glRFwMe6XSbsLOOCZTgmHLs4g/IcO5a8=;
 b=Jy3cyYVsVZZvE1unwTmRKV3WvNmLeqjoTK9eJbTQlmCyYCGdaVazqdkJy+Bv7XjuJ6SgxwbA/kDWzc4ZlAorW0bfXoOGZoy4ykvcgHRrAWi8l7oQJslFsdT7+ZBcSToMKI1fWBda2elOuwby3NNrgShMAisZnmUlNp1YmWSbYAMGSk91Palzf6+glHdg+/P4X2e/B1eT2zZOBgIw0uxVNA8kn5/CSJ9cUsqgyxIld4Vv/t4G/NczRhoASDtlY2hgmxWS7U2TLi+Ff/mjW/ZuW8HD3DQKpUsLSbvUSwlQIMc31CSnpEjFd6f4RhUarTvYfG7RYvtxqiVzq9D+cQ5pag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exOCVEVTNE9glRFwMe6XSbsLOOCZTgmHLs4g/IcO5a8=;
 b=MwMWXaH29khRaO8CwKy3h0s0BvfoJulRmbeZmXHav1WG84gjw4dKKovkBPNz+dTniXOCmaRFzeH+OWkSRpGnfZYb/KoyHBYZeoACSX579XzxEDsh6FlLETyFOGyJD32P2wREhjN6Rudg/yA9ukZz2EE2PuEHWHAS4uO/YUyHLWZxBPKx6LBzvd1Oz+dkfcKevKIauUAiOmsROY310eM/8E4/SC13vFhwErs4aLmEgW/+WBwxO3zPyMstCF/JHLdGH9zL/wR5AVqI2Q+vP6qKKngK0Y3iL5bqYhvolhQEapKBH1MId/eizI1w+6UbYV+0EZac4d44vWq3XTiNU6VZnA==
Received: from BL1PR13CA0233.namprd13.prod.outlook.com (2603:10b6:208:2bf::28)
 by SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 08:47:07 +0000
Received: from BL6PEPF0001AB57.namprd02.prod.outlook.com
 (2603:10b6:208:2bf:cafe::43) by BL1PR13CA0233.outlook.office365.com
 (2603:10b6:208:2bf::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14 via Frontend
 Transport; Tue, 3 Sep 2024 08:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB57.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:47:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:46:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:46:51 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:46:51 -0700
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
Subject: Re: [PATCH 6.10 000/149] 6.10.8-rc1 review
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bb201184-29ae-42ed-bf8e-082e27ab9a98@rnnvmail201.nvidia.com>
Date: Tue, 3 Sep 2024 01:46:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB57:EE_|SA1PR12MB8641:EE_
X-MS-Office365-Filtering-Correlation-Id: 4377bae9-406a-49a3-d5a6-08dccbf4fdfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUlFa2k0aFdjR25pMXdkTHhXT0FSMVc1Q3ptYkNZMnNhSDhubUc1djFsbkFJ?=
 =?utf-8?B?am1OTy9MQkNGUC9GczhpR0dzTHNoSEplS0dYRW1BNDRmelA1TTQxUnp1QmQr?=
 =?utf-8?B?OWJiK09qV1RnZWdpaFNtcjJDZHFDZWh0YUhpaWg1UlkyRjluZVJVNHhQUmpC?=
 =?utf-8?B?clk4OHl1bzR3dU1PZXhEYXJYUitsNHNSMnNiWndaVWhVRHhwU1NnckZicnIv?=
 =?utf-8?B?ODI2UDNnNG1OZlVkSjFNMVpWMEJsWVRkTGdCcEdVT0V5K2hFTTE1YzFWYS9i?=
 =?utf-8?B?RDZ1eGxDbTdZb1F1VXkyZWJLajBlT0tCQTZHVnNtcHBoTzhoQUdtQUV0WVFH?=
 =?utf-8?B?U05zVHBXQkQwWWthNGZSS1R4L3ZoVVJJZ3pnWXk3ZzkvVUk3UWJKTktWcUwy?=
 =?utf-8?B?RlJsbHZJbW1CV0hjd0oxTzRQMTJ3VTN0djhJZHI1aUVNN1FEUTVwQWxlMXlW?=
 =?utf-8?B?R3BWVCtsTkE4MFVQTUI0MjNMUnVJdEY2S3ZtNVBIY3Y5Zkh3U2d0S05US1Zp?=
 =?utf-8?B?eTNGT3MzdE5yanUyOXZEamhSVHlmVmQ5UUxZWTRtK2tMN1pPaDJ1TU5mLzk0?=
 =?utf-8?B?RlIwalBIeVM5NDQ1eklDQUtCakh4VVBuMjBxNUxkakJldlM1WEVQTVZZU2JP?=
 =?utf-8?B?NEFIQS93dDU2WDZUWmpkaEpTVGs5RVJnTUM3TExKd2JYT2VWcnk0ZjRadXVZ?=
 =?utf-8?B?dFB6TGtsdnpSVTc3VmFNMERtZTM3OEdnRzhRbDdWR2V2czhUU2Z3dG92MHpa?=
 =?utf-8?B?aU0vME0zV1lvSDNRQUpyU3dnaHVodWtsaG43VW9pdFFodXZJd0UzM0lJNmU3?=
 =?utf-8?B?cjRpNFNqMm9mcmVaV3B6TXU3alc5Qkt6dnZ3bGVhRElQSC9raG1IUWYvNHYw?=
 =?utf-8?B?enI5K0dWbGRPYlhlUUh3VUo2YWt0U1BIZnNTTlJDbjdNajh3bkdad3JKY1dP?=
 =?utf-8?B?OEllSVBDQi9yZHFwUVRvZ1V1S0pwQU1ZWEJ0VmlneUJNY2IxTHN1WXdWQjNi?=
 =?utf-8?B?dGlVY3k1bDlRT3ZubUd1QlB3dG1zNTd1UTUwMU5ScVRTM2VBNUUzYkY1a1Ew?=
 =?utf-8?B?SUxsM1d0czNnYS9zOTRxb29lNXVsbzJwVFc4T0M3cmU0d1d3Ry9ZRzUrK24w?=
 =?utf-8?B?anR5ckVQZmZHYWEyd0R0NkZzejV2SGhEaDYvc0ZPR1pYbTV6bW5NRXZTbFpv?=
 =?utf-8?B?T2tqZUxBS2FEYnhSZ1N1QjJ4MElMVDJLRjNqTGdHMnJ2Ky9McC8zRTYyM2J2?=
 =?utf-8?B?YnoyS0VLdkZlNlN1ZjZyalA2ckliSTNsaEkvWDAyalFCZk1pR0RPSFFtTW85?=
 =?utf-8?B?dFNFVDFqbWl2dG9LUlM3eGFPWVR1dloxSkdPendCdTZJQ3FKVUh3cmduZXdQ?=
 =?utf-8?B?K1ZKUThIQTRqVThoUkhiSjNmNjFRc1oyMzJWbkNZdVFtVmZlU3k4VFhDRlh4?=
 =?utf-8?B?ZDVtQ2RJc0EwZldUZHZ5OXdlOExBNGVEcmhTUU5CYW9QNzcrUlFiY3E5bysr?=
 =?utf-8?B?NzVITjB4cU9zbVU4WlBMZWpSSWxZeSt1dzVZYXBuNXdLOU5mbmFjbWdpTTVU?=
 =?utf-8?B?SGZTZjFtWm1WOTliamdRMlE1cmZWOEYvSHhpNU9sWS9CT2JwdVZXZFVkMjRN?=
 =?utf-8?B?NStWK2dadi80a05MdTF4TDVKWHhxWEl3d3JwVkwySlJhbzFFa2M1KzlZYVBs?=
 =?utf-8?B?MHdaa0NpSTd1UnUvK2dYUUVCcURjUXFiSzdQYWkxbCs5YTVacmdxdUh6QW84?=
 =?utf-8?B?TzZMTWt2WCtUOUExdU9iQlhtbmZiUHhyT3Z3RXlLc08yTkRWSGVPdW1FTzRs?=
 =?utf-8?B?L05KbjdpZDY3MmtYU1JSaFhvY1RDNmxHWDQ2c2gzaTU0VmRveW92WjdHTzl1?=
 =?utf-8?B?ajVOMitaVTNtODI5ZWtoSlU4SHJveUpFR3NkS1BkZERDd1YzOHQ4dHZjOEFJ?=
 =?utf-8?Q?dhsfLI4dlPYg8BeC7J+gpWkDvfbNjJgS?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:47:07.1533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4377bae9-406a-49a3-d5a6-08dccbf4fdfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB57.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8641

On Sun, 01 Sep 2024 18:15:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.8 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    106 tests:	106 pass, 0 fail

Linux version:	6.10.8-rc1-g88062a11f41d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
