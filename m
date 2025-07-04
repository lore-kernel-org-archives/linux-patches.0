Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25C82C08AE
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751627628; cv=fail; b=cbA/rcBPb+/SPvD6hd9xil5aFHSvo/Is4wk+5ljDdocNUvfZwrldOklrR/laIgaSIbEWuCrk+a3LERqz6qzhGZCHs7Dpx23P9SAuQ2/tnWqu4/fUf2C24J2oB7n/hHRZunrn1/Z1k0wuaLoMiWDEWlLFTEkK3xvvFLmYKSIbQts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751627628; c=relaxed/simple;
	bh=wlqvC6ETh2ntXZfc2q7uoZZvzP4A6mTwn1Tp3aKQms8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UNJLQgHfP8NvLPMiBXQEkehyDZ+kw8uLwbz+FbEYIBTF1K7cy40YSDOI3hijjDfcUFvDqPEuHEX3pHUYRqEJ8Noor6N1Dx3kY7QQ8M3moXNXsstI3HTSKLuU5SWqho4SLbE5feKD4ZARuTaiZofVKebxVW/5M+XtC7+Ys72RhuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iiqiYW9b; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iiqiYW9b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUy/U7ntHs08LB/ff1Dg4EkJImDCd0VqO1hVuiLWoD7yL6R9R0noNskie29TUtRpwIvibflCMWaX4BnDll5hTNlx06BsDH8jUcwdoxIaJlvZc8FVyBVO7XRzOeR5vJRR2MTuL91GIbWLwJsBNX5SeLcoIomcM1llxUPQ8JSHVXHqeVkTXO2mXQzuv1zXpkcV+PGTdDdV2UxDESI4ilhdcv2ckQnuai6cfmSq3FskOsYW/MBwu5Rbi83Q0fLKffLEGrSQav6grqjKf6jIW/2xzwRDjBD+CBB9sCh7lhWC4HKc3WLKx5qXaQKWvz3OFxYlwePftBTrY3ptbQDaN+3+4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9isk+NoKEPPG17tIIoLxsRaEXOoXRgW+mhomfCP+YY4=;
 b=pi3xpkeJHVmRq/fmnEa6w/T6uZJl1HE489WJiKw+q1u9szuS0zfhAzfezLd2x/8kLEcOVwSkdhT1lhB7cQS8X/PDvpoLaR9Vme1tKhUQdrnpBOJGBIAiURysESX1huypJPyZF+tr8jTjKPeS/Xmh+orje0JSHgD4jrBg02QVbToJUHb3HZEF0Rik9Ub0p6x08U+WkWEoHf/Q1HRhNWluKqoHZO8I9WUaHbI1W1Jb63SM1TpCamXyaTdu46eM0Nb8MVZmg0BspCZzasqKx5prGgpiSE+xlnf24XejYWZaCHrA4J/qZrw0fvKEKcqwjASo9Qi3SYY6QhFUAZoHUkH6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9isk+NoKEPPG17tIIoLxsRaEXOoXRgW+mhomfCP+YY4=;
 b=iiqiYW9bSHnmy86Vugn+VERQcR6/U2Gto7ZevimMu+jq+o/qkH1A1aPueNuVACvgB/d0kfw1tmWrT6Qc/T7RBAbVp3vgsCjXL5waahXpTqQLyh4IYJ/+VoSIoM+PnY9hBmiqrwhc3MHQ6xlu8d9PEUpUxwdw51LCEOcGCajX/Gi6HpN5EE85IEB2OwqCLp/UTEEeXdc0kkQYnbl0ZfXEhs0b2X4saRySnBM/wyN3099cT9GeXS8OqvTU03O+qCeXNih1zwViLsGXawE4qvoLv87dLwHEt2sRn/gbeJ6G1JWOFACQk9sJ7goWUESGTugNw1QEuBYKKJTO41+WlhUQXg==
Received: from MW4PR04CA0150.namprd04.prod.outlook.com (2603:10b6:303:84::35)
 by DS0PR12MB7582.namprd12.prod.outlook.com (2603:10b6:8:13c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 4 Jul
 2025 11:13:41 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:303:84:cafe::9c) by MW4PR04CA0150.outlook.office365.com
 (2603:10b6:303:84::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.20 via Frontend Transport; Fri,
 4 Jul 2025 11:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.1 via Frontend Transport; Fri, 4 Jul 2025 11:13:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Jul 2025
 04:13:31 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 4 Jul 2025 04:13:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Jul 2025 04:13:31 -0700
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
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <836a987e-d8e7-446b-85a4-6596b32af680@drhqmail203.nvidia.com>
Date: Fri, 4 Jul 2025 04:13:31 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|DS0PR12MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e4332c-a32b-4d3c-244a-08ddbaebd4eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2haWFR6ZjBLOU1OOHdjZlgzdlJ5Q0NrQ1V1SElSTnp2dVJtRkhQcGo1UkxV?=
 =?utf-8?B?NEJzdnkyQVFicVN4MXlwakNiVVJQamhFa3AwNGE5MDA4RWxEYmkyMHZaUHl5?=
 =?utf-8?B?WkxkV1UrZm5iTndURzlqZEFyNlp3Q2orQ21ObWlJYWIrNzFoS2NOS1VHa2p5?=
 =?utf-8?B?K2VjYVlZT2xpR0NHZzlLb2liUGhORi9VcEwrK2ZJSW81ZDdtcWpKZHdlVHRR?=
 =?utf-8?B?azlSdE0wcEFEN2w2b2hmTHAzN1pRMjIwOHZMUis3VmxKRWcrNENqQU5zY3Fx?=
 =?utf-8?B?bEFiK2xuOFdzbDhRZjhWY0pZZnNGTEhHelBRTG9QeDlKeGdEVXkyMUFyVU1h?=
 =?utf-8?B?cllCZlMwYlc0dWN1dXN4a0V0bXI4SDRrRTg3RnhTRW11U3BYNTVFSSs1UFlz?=
 =?utf-8?B?TTdkbXBNMm1QaVYxdWZDeTVBQWU2MWpuNXRhbXNRVVV1bnRMOGpST3hMSExs?=
 =?utf-8?B?SlpNWmxMSFdjUy9EVkZNcFd4bmEzdGpsQmpQVmRPQmJLQ2RBaWdOWEZSdGVv?=
 =?utf-8?B?T1ZISGRwYit0Sy9weS9yaElKR01GaHZnd3d5c2kxcHpqdDhlZUNsYURpQjNi?=
 =?utf-8?B?VHhZemRtM3diek5GZUM2QjhBZFNxTFpORk9YMTdELzMwbmpISlpZdFRZSG51?=
 =?utf-8?B?OXc1M2V3SzJ3Z213bUpRTk40K1F1Sm1yU0FIV3ZpTGlrdGc2cHdEK3BncUMw?=
 =?utf-8?B?VEp2M2QzT29wYTlCbW1HaDBPSmYvYTJseW1wVEZnT3l0ZytKV3VFcGczd0Zp?=
 =?utf-8?B?UGk4SGdxQlF2c0xXU1RpQWpWUkRYdnZ0azBPbEFwT0VSYXpHYk5rV3dQeHZZ?=
 =?utf-8?B?c2pncC9YcVJBNDJ4NVZBUUR5azFQcHc0L2xlazZqd2F1TVpJeTh1RzZPOXRV?=
 =?utf-8?B?c2JFQjlhL2s5dis1Z3RhbyswK0xmbjAyQ2kwZ1N0TVp2dmtKZFIvUUplV1ZU?=
 =?utf-8?B?N1FKMjBHU0xFUit6VkV4MnIzRm1RTUpGMUdsRXlUclRaNWNhVzc4QlVhWXhC?=
 =?utf-8?B?dEQ2T2l1R2dKVWk1eVExa1RiN1Z4UXJSZFpsMDFzUVAzRjhYVWJJMStyOXdt?=
 =?utf-8?B?OGd0ZGYrMko4SzlJemduZTUwdno5VVRpbHR1U09SeFdvZFVSUXJiK3YvNm1T?=
 =?utf-8?B?T2ZmbWZQRE5KYndETVYrRlk1d2J5ck4xR09ZYitRSjhvTHIwa08yRm5EcXl0?=
 =?utf-8?B?Nndzb3JZUjFWT24rUDl2OHlCMEN2MzNzUU5XeksvRFpOcmVQaHh6TWh3S3k2?=
 =?utf-8?B?ZkJRQjR6WHZKQ3NPWjE0TFQzR2FuejcrdTRDdmx4MkIzQTZVaEJoZVNXK1Rp?=
 =?utf-8?B?TkJXTmhSbFBmWmVYeFZSK2dpektuWlkwWit2UGZKR3hSUUpqOUI2T1hiRklv?=
 =?utf-8?B?S1VBblBiaWxoTHlYOVJQMWZ0RmNUM1NxQlhHVjNrdGJTRE1ZdXpqbmV1ZEZF?=
 =?utf-8?B?N3FEYkhtcjVvQUtSR1VnS2ZRRm5KVUpXeGtFRFdxLzEvSnFmNVpnYUdCVDdX?=
 =?utf-8?B?VU1mS29KL0Z3KzUyUlgzbGlSNlhvRGNqN3d5Z291TDV5eGt6TDVUVXVLMm1z?=
 =?utf-8?B?ZmhBMkV4SDF3WklKQjFaTFZ4Z2RndnZrMTRIMnB2c0haTk96VlNwa2IwRVpq?=
 =?utf-8?B?RTZMK2J4L3ZoaHR1c0x3Sy84NjVrelArclQwNUVHWTNlaXRoQ3RoZXFyWkdD?=
 =?utf-8?B?N2dDNUlYUzdWSEZtWHNYSFl1bE5lVVVNTWNrdmZDOTJHT0JNRmg3Ukc5NnBB?=
 =?utf-8?B?TzlhSlBQUGRTRmlJaGtBR0FLUjV4TlRqa1I4UUdtTEhFcVl5QlhBNFJTVFRa?=
 =?utf-8?B?TjArTkNJVkdMWkFUczkxSlJYVmlKZlUzNkFGOGVEdXdyaDhzc3NTWUJTZ2xU?=
 =?utf-8?B?a2xLZzllMTkwK2Nyd3FVY2Vva0R6K3REcDh2MmdDTG1FMlhPRjJsRXlUbVJ4?=
 =?utf-8?B?WkI5SlRMUnBINTRsY2RFeWF0bkJlcmx1bUxITHkzaWtwWFllR3lDc3EzaXF3?=
 =?utf-8?B?OWJtcDJGc2lvZUtxclhPdms2MWE3VHA2M09SK05OUWV1TFVaTmw3eVpvbWpr?=
 =?utf-8?B?RzlmaXdtMU5zMUNERGsyaHVVVkJoS1BkN1Z2dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 11:13:40.8514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e4332c-a32b-4d3c-244a-08ddbaebd4eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7582

On Thu, 03 Jul 2025 16:41:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.143-rc1-gcef96cfe5f17
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
