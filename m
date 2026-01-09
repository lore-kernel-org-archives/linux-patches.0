Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010058.outbound.protection.outlook.com [52.101.193.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69D635966
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767979944; cv=fail; b=YrfhBdktRl8zf/8n/ejku1S/TGYTClabDIO+ZH0Mx4i88+KiRAFo5WTe01LND1PeqH1P7BFS+FrqJ+ehrdBWHqxF/mZBQUpM3fGtpGb4UlXqsNRdB4lrOoq5y+Zh+CuShpTCHJeaBKLBnOQIoOA2+VTP1boFTv0nuZz8iCW1q5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767979944; c=relaxed/simple;
	bh=IfUp3Kvl6x6wE16fSXOUO3KUMynOrFbfqriW7hf4Uu4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DlxLBNo2XscTrTZqTawoDdasLjVH/lvvWpfKpw0j2eqpRrdOInChRNhVdG4ZwrRsDYqSR1Qw8Ebv2IuxXFHfHYXwHuz2DA69Maz9ACM/LKNXDTxBkyjilJHYGkkAwuMFlLUWDyI6NjLEzfO4mICJK0QmbBH5G4jt6hAiPWbx6vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s7mgd7I0; arc=fail smtp.client-ip=52.101.193.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s7mgd7I0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6piQfTuuEA4ytbY8vU3zr6toDmZz8SLbxB/yFYYrALJAPJ4x8+1MN61f3uXvKxOfhbjbkf3LAb3HG3krdVxPlUM392JkEz8e5o02gVjPYHqb5YzOCuYpf+8rxNvUqApAB6FCgyGslHfC7t9DL2lzJwQZaXfmwLqMyb4mkVSNLhwrBqNORrFHDvNr43WJbrDXZAeNs6OwigpklN6EUUPk9gl9cyeEyMWuTpXiYOWplbAGYHyYMKYqferrtyvf6vpMCLAZjVhc8FWMPvGbIO9erLDvzekb4o4nr8yyZYeorbbiSOei6sT1cODmZxcJO85o0A5S1pBv3bnPxcz/pnLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjz8kSpiNWTEB3CIZHSjsTA7k2X9Jh9sylJPCaaTKr8=;
 b=in32X3uGr548syXr9GlPCpZ96/709Tg1xSm4wgAssZbx7hOfoiSZEsTzELVzlEMovJd+iTCBTL5ZUeIRCIeTHcFMlt+LJ2wxShHRSLbF9NQforh2PVf4Qo4DsHGyIGbIhbdOthXVYICo6RqI+SbnCrXOgjYOH+KYPvs/S1KMEOm4vp7mXTaOODILVJf3h6l6Cjk0oBTdtbbw5cCf34w4JFrku2wDVl88JwMj2EOFUlVIy2XSRyx5G/BAsa4XSWhLP0ZmPdNMeKZikYsqn6SFaICyqF+aRl64hQ1q2gdREpN5+teUlmOsRCzMX1LjSXKVwF5uymBT23FO93XmL6mdLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjz8kSpiNWTEB3CIZHSjsTA7k2X9Jh9sylJPCaaTKr8=;
 b=s7mgd7I0JthnHgmr3v4qDhYTXgotbUvQ5u+BQyh3E9H7UO9SGFRDpFmRa4NQ6GxXnzjOb1E1kRzpVZGHohNygjFn81Dy8Vjk+X0wXO1aYs8MtaOSTL+x7QCDhRQzMOs29M51V25dAtFdG4Qxj8rrnVMWpSRZiYqqaoEQJqIBx1MJW/KqtNSgC3cDzfYnz7G3ieftghpV/IrMO+miajHzad1nJXuL51frRAKX5vHPvkq8SYAR4BSeZq+BenDoafV6eVBnRLfd6d+ac6AYEZwNuw/wsWWUhi5APrIEkL82hiIuTkzP2pASbQ2jaaErKv5/tVsifKP9O8xtT7vK6ojY0Q==
Received: from BYAPR08CA0019.namprd08.prod.outlook.com (2603:10b6:a03:100::32)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:32:18 +0000
Received: from SJ1PEPF00002318.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::53) by BYAPR08CA0019.outlook.office365.com
 (2603:10b6:a03:100::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002318.mail.protection.outlook.com (10.167.242.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 17:32:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 9 Jan
 2026 09:32:01 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 9 Jan
 2026 09:32:01 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 9 Jan 2026 09:32:00 -0800
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
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1e0c46cc-d011-45af-83d9-5ca11e49c7b7@rnnvmail202.nvidia.com>
Date: Fri, 9 Jan 2026 09:32:00 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002318:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d833e12-a41a-4bcd-3fa1-08de4fa509c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXg2SFVrS3hpV2VvS1pLamJxclQwWUxmcU1mNFMrb04vYm5FR0VIVVRoNzBF?=
 =?utf-8?B?V2tpR21tdlJSMGk2dDZoOUs1dzVXb0c3bStUVFlvbTI5ZlF6cFpiU3dyL2VP?=
 =?utf-8?B?Y3d0ZDA3cFZHcmpoZlBwRlNlK1Z3bjNubGEveklPZTlWeFRqazhEck1QMkJy?=
 =?utf-8?B?SWFCQlBmYXk1Ly8rdVdxOUpoVWptblcvRHliQVhaZzA3bHdxbVhBVkZtNERq?=
 =?utf-8?B?cXpyVktRd2dHQWRnbHJTR1pLNEx3VEFWQVordGxXdFFlTm4zMkpRTzRqbXE3?=
 =?utf-8?B?aE1wVEx0YlNTOWpiaVhDR05pTjdmSlZyMTV2bUZRWDVvdUVLZFRXU3NyeFZO?=
 =?utf-8?B?WHZLbG1kUnl5R0tVREIzb2h0ZTRGd2xTTzJvL2sxZ2V6Zk1hTXpaVXhIS1A4?=
 =?utf-8?B?SjNuMXhVcHlBOUw0c1JHV2hINm53YmJaS1BvdHVaSStSVlM0QXorRUo0TkVv?=
 =?utf-8?B?dG9idGErTVIzZ3JaY2ZqN2pSMExiZ0hUcW1hZ2JXelgxdDRoaFA3WVVqazRW?=
 =?utf-8?B?MWhyLzd6OGxaWUtjdHRENlAvUzBDQVBQb0xycHdpVjRuQ0FBWU8yUVlSMVJU?=
 =?utf-8?B?em5aTzZENUQ0alJjdW1KZ2h6TTg4VlZFeVlGYnVIWWJBdVpPZDdvRmp6MlFV?=
 =?utf-8?B?WTNJRVNYQmVYRHJrSDhuck5mbWtlRzI3RXNEVVp6OWxMSkFzUXBZMmVjUjd0?=
 =?utf-8?B?QTBDT1JDQ2RrVXpPczNOeFlCQWIvQ1M0aEd0cWtTU25UejRhMHFMOFBsVXZC?=
 =?utf-8?B?cmtVWVdMSWNVcEFHSmM0QS9ZbXJTb2cwc3owU2Z1ME1seWZkUVduVWdvTlNI?=
 =?utf-8?B?cWpmSWROVmJBak1GS3B0QnpoWmxBeFFRVUQ4eUtYc0YxVnNKVkMvSW5QVDdt?=
 =?utf-8?B?R0F0YjZnQXQydU12dzI0NTVDRkM4bVBxQmNYeXFMeDZ4Z3dNdkY5TzgvNDB0?=
 =?utf-8?B?ZXoxSnk5UnZMellKZElEU1Uwb3AvM21xcjZtbHJENjZQU2JFUnZkWEY4OEg5?=
 =?utf-8?B?ZDVaVG80ejVpay9GYnIzUFJ1Ylk4ODl0KzhZUW1CQm8rSkYwOTB4T1I4WkRj?=
 =?utf-8?B?bW9pN1hSVFY4dno4WmRZZVlENzNhNXNpRm1vSmJEQjZ2Y0NJTmJWb0tiQkY5?=
 =?utf-8?B?aVRiTnhoaHBoYzZMSVBQTzUrK1J5YStMMFRrcjJTT2k3NitCT2g4ek5reWZx?=
 =?utf-8?B?clpMNVFnWnJMWXAvdWEyK01yT2Y5V1Z5SDk1Wkxoc1B6cjVEVWVwYVAyT0Z4?=
 =?utf-8?B?c2NSZEZDWS9nZEY2ZkRFSnQ3RkZjWkZVZlhyRE5TckY2ZXg0TFYyc1ltSmRK?=
 =?utf-8?B?L3hKVUtCeG1EbFNSaW84ZG1wVGtCWWZpRjZCbUlSWUdLRDdFUEV1OUNMWkZ5?=
 =?utf-8?B?bk1RMnRlbHptNWM4NjFFZ3ZRd2xnR0Mxb1YzTGptRHcyN0xjMVRJOEhkWkhO?=
 =?utf-8?B?NXg4Z1pZTXpRUFJtRDZvU1M1dFludWFQdDQ2SWlzRnVjckNyd1h0L015UVBO?=
 =?utf-8?B?ZVN0dXdpaG1pWFEvcnNLODlHV3FWSDVMaG1LaGN2RHF4MU5yU0RodVpqY2Js?=
 =?utf-8?B?ZVRFYVlmMU9QMjNNS1VHV3dadGFNQmt3RjFZVEgwSVFIOGErMjRxcE5IT0sz?=
 =?utf-8?B?L3Y2MDBuN1k3VkE1aW9iWFdOdm5iN29LZlZJeEFOUlRPczVRTFV3REpxY3lv?=
 =?utf-8?B?eUljOHZqUUZ2S1kwVmszTmROUlE3akdSak4xR2lwNXR2VVphenRsbUxiQ2dX?=
 =?utf-8?B?NGFucXdMbHBVak1SMk91TUVlZ2NINWtVS1VwOEFiclpPeldKUFYwU3QzL1FP?=
 =?utf-8?B?NXNkNk1US1FDNkhoRVZBZmNxQWFwSDN1eFcyM29McVpXWEQxWGV6Z0JBNldC?=
 =?utf-8?B?M2xNZ1Y1VW1lVlUybmNCdEFMRVJ4OU5wUGNDSHM0TDhBSEtkdVdzUS9lSkw2?=
 =?utf-8?B?VTNSWk1hSWRnMjY5ajY1SXNnaXR6ZE5LOU5tbGhnbTBzb2tJR0RURzREeDky?=
 =?utf-8?B?MjJTVUVrbGhZSnFTSmU2NXBIY1piclVvL0tqSU5ndlBObGhTMW04TzF3NmU4?=
 =?utf-8?B?dmZ2Y3E5ZjB4M1FTVlBkZGFzYWxKRXU4SEwxN2s0bDNJbXRGT3dibmlJZU9P?=
 =?utf-8?Q?bS6I=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:32:18.4787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d833e12-a41a-4bcd-3fa1-08de4fa509c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002318.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428

On Fri, 09 Jan 2026 12:44:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.5-rc1.gz
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

Linux version:	6.18.5-rc1-gc4b74ed06255
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
