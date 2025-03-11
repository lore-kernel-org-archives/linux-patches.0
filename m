Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353FF22B8BC
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687357; cv=fail; b=kKmKYHPgUIWBtiLo6YTNGC53omvtQmw31y/JTOUxfASo9Q7up9YH+DMYEL/vf9Q/6AXn+VJLWE5PpjCOBf0n2p0hmUo0RC/TUhK74UPTEjxPSKwMg763ksOhLLj9HyQTby1c+GZsYX/7AKFQdSbvBlJjb5vgHNm2rp83ZsHw9aA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687357; c=relaxed/simple;
	bh=Tk4ciimmQBZZrZrMpZrHeP+yjepFK8Bus3Qxx8ZVuCM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=A5uWItM5BS7k4wFv5DjBOJZ2OOXxq89KCEVibt7Tu+4Szlm7Xah4cbBbI8D718v4P5EI93QyHwg45RAg+/Wlw3QP23vrOAsNT52G549lIRHbJTEZ62brPjUKeKhoJS2M5kGWhUeWDD5Mh8nWMz9s4ImEpSnw58PzySNxCF+DKSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cWDGvWhA; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cWDGvWhA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JSUieMb6/G+OIhSTQ8e1ErsTBrHaYxI0cI1vBg7CySrDjrFLnlzt+V7DH3lDXfsRWTXym+t/f6MljQTbhq0d57k1r55mXRFSwaQXMWQ5IqL9bolxsvVpdwBGv2Z9PF14RhYojfbSax2Tx+8xGebqF5DxbutQyvM9XaZ30CNzsYu5r+TuwlFSH7E7qAhKu90ZexCXiUkBTqXm0KdbpBBdvojEe/+eNAleWxLVzjvoQ7qLnAHLD19q5mFpi55vq9QFUTFsafiIc+88gUmk/wnLmX0DW9O8rXBI4B98FjvTQNPwCgSj/xd9Cl5hPFSWT2TJzMSBzH6Sf7Ij+Dv/cQiQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLZnUk8uzegQ4mZ4jQnS8Qs0V5dNgxEJwOhpCrS2bi0=;
 b=gg1zBt1jj7g+/4tujK0E+GsoPBLUICbLec3rEzOGr4BV4s0Ozub3sCXHuKcA58J+ATEzVrOYONnqk+547fZZncWtaQsXZGnQIix2kcdt9a9fpPgcoHjX6UlbGt6GAXfRJlap6jZLZZGeSzV6MKLiZWM7+L2lEyQQRVnotSCj37rwF2dVR0H3XAaGGxyMVWo2PB8DzCELnPrKfYIVmeZC+Nc3E7RDAAzLGTTysVTL0ghFYNCdcCk/Mv7wFAcGrApnGgH5Y2QLSaaZVjy/Jt4cDChMMt7cNjsGa/fUYpchHc2yIwWSzB4uBrx9M0g227twhJ37ws7o2a+ndkUZ8rXaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLZnUk8uzegQ4mZ4jQnS8Qs0V5dNgxEJwOhpCrS2bi0=;
 b=cWDGvWhAFbdekgl5CBez1yhE8CwYJbctN6i8b5bCCK04ueKuekL7kgTPRxxZMw2D3qltAICDoj03y45LCcq866bNYLHA6PnSNqfLkDpp+HHx/iAtQI989lFKr8wybcU3PQuCHMgZVv+G1y2EFR662O2JZ1FW3GXBO9c7KGY6iJCjt/slFAubpM2iCBQ5RiaSBZCGfIIpieQxnFxA9IOBeqsPOiXXEXzvaTbAQ3E9db/7nfhxT/eKbDaKyf+mBDYmpP4WKBrH1ZsIUTh273hwTxaEDQ2QWWkeFuByRk/kWmh52F3r0ycKLsK8ehWir07+5Nz7vXz2QOMcgC5an+Rk1Q==
Received: from SA1P222CA0198.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::22)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 10:02:32 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:806:3c4:cafe::a2) by SA1P222CA0198.outlook.office365.com
 (2603:10b6:806:3c4::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.27 via Frontend Transport; Tue,
 11 Mar 2025 10:02:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 10:02:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 03:02:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Mar
 2025 03:02:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 03:02:18 -0700
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
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <65b397b4-d3f9-4b20-9702-7a4131369f50@rnnvmail205.nvidia.com>
Date: Tue, 11 Mar 2025 03:02:18 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb76fbe-e369-444d-0f37-08dd6083d70a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmRiMzVTaDZuMVpvdXBRSEVnTlMxdlo2WGpIMG5UQUpqK3NKZm54Y1hlcHln?=
 =?utf-8?B?MDZvd3BwUmN1Rk5XQ0h2YWZBU0lCMDBNZnhnWW9yTVFaZWlyeU5vZk1xRnJF?=
 =?utf-8?B?TmU2RkI5dmsyZkhpbFIzbWxUWUxZOFA2a0pIWE1oU05YbjRuTUhHeTlxYU5P?=
 =?utf-8?B?YjIwc2ExSWRLbGViRE5IUjN6anlycU4wN3ZPbFA0T0JTRjRkL1IrU3hoS0NO?=
 =?utf-8?B?Zk1CQ09iTS9KTVYxcnV0U0hYRFBUR01oUzRUV1NKeENqc1JINTJmMEdOQjRI?=
 =?utf-8?B?Y1NDRU53SFhic1d6MkFobjRiL2tpUDNMTEFvSmhyYlRxUWlYdDFYY2t6OWdL?=
 =?utf-8?B?c0NweUlFR1FCUEwzOE1HL0h3UEtLRXpwTWI5ZUk0QWVhOHZ5N0FrMFVZQjdu?=
 =?utf-8?B?M2NQRzZSU3QveWJoSWRDendQT3Y4ZndGaEdFMXZEOG82eVhhNzY3YkpEL2pk?=
 =?utf-8?B?RFRFN3Z5ZUJqK2ZWTUpraU9BY3FoWmc1UVJYOENUWitnUVRiMUgvQy8rcTNk?=
 =?utf-8?B?MzArSUszWUNuRW1ReW1ZbWV3aEFDZWNyUENlUEdnWDBqM3BydUdpa3BJNSth?=
 =?utf-8?B?VEt2NXhtVFVWNUI2R1N1c2VvTXY4MXpNUDZKVlRudk9NT1d4NnluV0RSTDRt?=
 =?utf-8?B?TE9OdVVyamxSeGJuMW9WeTQwejM2RDAvSkg4RlNJZkR5VzFqRndXUVU5RDlh?=
 =?utf-8?B?TnoyTDF0aXNpd1d6NVN3eGNyaVM5KzBURXRnSlFwWHoxMmd5N1dVVWt1cHhT?=
 =?utf-8?B?Wng1dTh0LzZpa0M5NXgyYUpXSkttQURTQi9LSzlrOHIrWW1scWc3QXRoVTZ5?=
 =?utf-8?B?MHRiYlo1U0U4RGZqTVIvd3VXcE5aQVNxWWs3QUJjb1dkVGgvbW1xbWpJRDJF?=
 =?utf-8?B?cE1vbk5BbkxoR3BnSjVzUFRmb3luWTkwekwzcGxKKy8zY3VBR1RIWnFvVVl4?=
 =?utf-8?B?ZlNkZnNKTEZnbjFwZDdiQUdrRlE4R2d1ZG9NU3NYK3VrM2hIVjFmM1pyQjh5?=
 =?utf-8?B?V0ZnTExaYytDbS9GUzc3YWNoTjl6OExQaVMydDZQWkNDakQ5UjJDSUZGQlBU?=
 =?utf-8?B?N0dMWHFvNjJsa0FMZ3YyU1gxbU1JTDBQdVdEUk1UQzlRTGY5K1U4cWxhdkt1?=
 =?utf-8?B?YW5UQkdldG83YjdlRi9aZkhGVGNUSCtyRjVrY0I1Um1JdjRlNEYrc21DTzF5?=
 =?utf-8?B?SlBBTU5lclZYcDB1ZFViS3RnTCtENC9vUnE5eWw2R2dWRFBEOWJBSmRNUzdz?=
 =?utf-8?B?Nkh2QWwrUVg5cXNXbGZkK0N6ZUpEUTg0WUNrRStjcU5HdlVRV0o5RjV6amRi?=
 =?utf-8?B?VU5JSVFEZVBGVklHanBYR2JUbDVydXdWZjE2ODExKzZXTzR0Z0dpSW9Jd1B0?=
 =?utf-8?B?TWU0U0M3V0g1S2N3RnpIWFRWZFJnbHJaQ05uR1M4VHhCeVRBQTl1cTFxckZW?=
 =?utf-8?B?SUJGVWxQbUlqR2pseTc1TkZsNDBHZnVRQ2VKZUwxbU5hb1BlT1ROQ01vSnFZ?=
 =?utf-8?B?dkNnU2h0L2VKSHVZQUVGSXloWkJSMFpBRUFuVnR0NWZ4OUtQaVhEc0JJbUR2?=
 =?utf-8?B?OVRSS0l5KzZSdGs1UjVmSXNPVUVRTUVoRWZUcW1NM1ZsUFVuZXZUMjJ1bUxx?=
 =?utf-8?B?WHdBZU9OWXpCZUJ4Yis1cDF2TmJsb2dVcVZVUmNvYUVObmFYbFMxM3RUR3NU?=
 =?utf-8?B?ZzlOUzJoZ2QralJRYWhNRnlnRmpkelJNSVZtdmp4b0s0QXhoOTJidDIxZHhS?=
 =?utf-8?B?WURkL1N4d2w1MUdaOUZQQzZiOUQzL1l6VHVpb3dKbEhMc09uMW9GektveEVD?=
 =?utf-8?B?MmM1TXFzeHF1R0hCMXNROGhFM0UyZkR2Z251bzJrT1M0U3dkYU9hMkdRSCtz?=
 =?utf-8?B?Y2tDSU5od2E1TVhjWHEySU5uN25oVUl6VGxNeUtSc1EvRzdIenlTdWNhNUJL?=
 =?utf-8?B?MXdHY05xZmovZWRQamgySFBrcVdRb1cvaDNrWlBDaW44OE9mdWhqRHBzb1gw?=
 =?utf-8?Q?Q8UsXTfCB3pnNB7KeKY5mnIzGEO4jk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 10:02:31.9815
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb76fbe-e369-444d-0f37-08dd6083d70a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132

On Mon, 10 Mar 2025 17:57:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 620 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    101 tests:	100 pass, 1 fail

Linux version:	5.15.179-rc1-gcfe01cd80d85
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
