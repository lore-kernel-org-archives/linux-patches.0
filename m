Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFA42DFF2
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236886; cv=fail; b=GhLwV+AeUYTz7y5WpdPBzjG2KzpW0hrpxdNkWDwPlK0zOcXbi84cm8zNyKCqB4Qubi8lhkG3u+cRhLUh0CKXOhDCCMMQnMO87IcaELcEKYxZAot5mWCzT0WJakl8bR8kcp9RUvuLgpD3qnk4iwND+WKGK3JDLqtrRlW++NlrLbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236886; c=relaxed/simple;
	bh=zB9IRGXBrN9MLXfHCT3qHRy+zIPM0fgYW4R3lAPwQfc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SWXPCmj1rP5DNU0jjcSoECmDdCTR3YQF4QjwlVarYNmmdTubZKzFSUe55JiQ6/mzZq+CW4CLN3H2Z4ots2f4DJOWzKEyKTNMOne8b7uylXQ23BxPZQABs8rSh/O3I41UVyoj0K/uxKziJT0EfS1LvHVE7geiZJH4/s7+HbcQg9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GW+RTf1H; arc=fail smtp.client-ip=52.101.193.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GW+RTf1H"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WaK4nidstj+pB+v2ZgURpZSsDXxaYoQIgKVMRJco12Q0x69U/zW4UsYXctCnSWG7EJFJGEuBfBOwKnrYH4F48rdoJ1qAkMmWziCsTS8YqU6RHqXttiue8kAF36QNleGK8P+uB7//DYhbQ5f+PvjUEcg6KxSZ4TKzUlpyXS+uYzzmLVwc8flEg5tOoZDo+dZQ0H3qtpB0t/DzpU3ugxAt2wY3/wCpDQCARnn8C4xI6VbPGAsT1zoAtEQ+zRLfG5LkbCpeW/CKJ+wz8GKAyks7WuNMd/tF/2I0MVsxr6MTw/njpN9SA0MQIexcsk53fvJdmdmTdPfvNaOQXq1x+JurFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsjfpRZHyunkT9r7bJqaNBT3Qcz1tQMYtpD+DCZ8K/k=;
 b=G4sf8XJVhr7qhdCY2+AN+6I+P+qrFIxCGNA9ZsHj1RMwGMTnQAxEtXjMmfQMCg2fFOc6wO0OEGS3TS4700Luoin3ZK/D8VyIFvxAgAAqYfu4iErgUulaHEk5c0EpOTevO48ZAVpHcvx5gQkiqwOFY4dmYV8gDJmpFw9auOvd+hYfr3e12h4NRa1kGMnBCII1/auFqy4La7ZoE4JGEFb/ZuAZYXnektAqtGdejtjwnVmwSK00iEVY9uBFnFm6Rt2vvHI9bGHzB4w4kiAL8EPH7Z948YQxXHGiEhZ6i+vuacmcNH7WJYSbEKWRQ7om6geo88kbU1IPqtPJf6NKejYRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsjfpRZHyunkT9r7bJqaNBT3Qcz1tQMYtpD+DCZ8K/k=;
 b=GW+RTf1HB2dJwsGl0wO0Ki/8q4v9mZraNSwxdZBPFTzPMXdif1htIFxBz/xfC7vPIFCNi+oGFr9tKQaMWGKemh2XzmU5PjFyPDK0Ker7gx62SDQPaktedN00lgFzFAMssL3WeR6bpv/Cag0S61TaHjNLlAH6mz+pbVE5sadSNLWDyeYl0e0mXRlJQSRJ/VswaBBtYqVH09PT645dBJrPbp7QTbpJND8sBHbgoGSS6iObbhESg7TxuIRZC/uixfsIN2cH//zXbcOkD/QKsVS+xlzQ2NKurq/mFiPicelMLygqt7BzO6Purx2fw24skFNcvMHh2c160l3VhgJ4qtZ6sQ==
Received: from SA1PR04CA0001.namprd04.prod.outlook.com (2603:10b6:806:2ce::8)
 by IA0PR12MB8862.namprd12.prod.outlook.com (2603:10b6:208:48e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Wed, 4 Feb
 2026 20:27:57 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:2ce:cafe::e8) by SA1PR04CA0001.outlook.office365.com
 (2603:10b6:806:2ce::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 20:27:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 20:27:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:38 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 4 Feb 2026 12:27:37 -0800
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
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <097246e1-16c3-485a-9a5b-b1ca49d2984c@rnnvmail203.nvidia.com>
Date: Wed, 4 Feb 2026 12:27:37 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|IA0PR12MB8862:EE_
X-MS-Office365-Filtering-Correlation-Id: f2508918-5d3d-4c72-b3f3-08de642be230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eSs5dk5pL0VtOUJtK3ZiOS9xaTJUYVoyS08xTk5CQkdHMnNlV1ZmNnZhK0xG?=
 =?utf-8?B?eGhjNEhNbmp4aDhmUEQyYTJMUHlmYkR2N3Y2VWZhRkFlOGVZK2w2UG5nQVhS?=
 =?utf-8?B?ZFFPNkpyVDRrRTEreW1yWENCbHk5UFgrSjlYVU1HZExad2RWcGo0ZzdXYWZh?=
 =?utf-8?B?MzgvM2tDZXpSRW5YU0xNK2xWc2g0WHlLZUJhbGc5R1c4NDdZRkFQeTdWdmtQ?=
 =?utf-8?B?RHFTSC94dXVhempyWmkxZElLRmNwd2NCQlFMRDlZek5oR1cybFFFRWs5Q0or?=
 =?utf-8?B?b3plMXFTUmU4QzlLZUFVS0RHblVLK05VK0plUjQ0UFZJTThlQUJOUFRKTlJs?=
 =?utf-8?B?K3pxRGJGcWs1Sm5SMC9lT1JVQXA2bVNSYnJvR3NsaXl5Ylg2dFlheGlJL1Uv?=
 =?utf-8?B?OU9lZkNBWXUrTnVNNU5GVkpqbFpFVnlFQUZaZmJyUUhEODAvZ05lZlU0dXJO?=
 =?utf-8?B?U3UrZWRnWmI2dXlDSmUvYStzWmZmUW1VRU5TQnliQTZaNnZiemVOZ3JOK3JK?=
 =?utf-8?B?UDZXQkFHTWZwS3JWc2VSTi9mUW1DbVBlVFhkN3FlZlN4VHZvM1VyL2d3Z2sw?=
 =?utf-8?B?V09xNDdORWNKTW9pdWNsOXcwNUJJbldIQnpSSlYycThCYXAvYnkyd3NtdTBX?=
 =?utf-8?B?RkxTNlNvUUFNeTd3TUlCUko1M1B1NnQxYUZ0VDZ1OEhXMllETkVyR25ISU83?=
 =?utf-8?B?dlJ3NlFRcEhCcHdGeVpBMlpaeTBLVVB2MWpMSnlGOEpIclI5L1Z1UVQ4SjV0?=
 =?utf-8?B?VlNoMGVmbU1hMHl3eFZ6RVhGbTFMZURiYURnVnpva1NGK1QzajNDNmxnWCt1?=
 =?utf-8?B?SlloWkgvN2tSK2k2Z21QbkNXeUYzMGcxbkNKTXhVVXNyTFNzOE1Md2c3ajN4?=
 =?utf-8?B?a0VGSHdueHEyODJEclErZjVVMVV5QktNMEVUajFReGhVYUJhMDRkdmVNS1lZ?=
 =?utf-8?B?TFNkQVRsRG1kWlNNa2paM2tQNndGTVQ2STFNWmJkOE4xUEN5Z2lOVVJTSGd1?=
 =?utf-8?B?TGxrQzdkN3FXVGFQVlNkK0pPSGM2ZTZjTXpKdmxJeWlYdTc4MFVkdEJaNXpp?=
 =?utf-8?B?ZjJwdFJVNWxFbzh5b1Bja3dGUkRLZTU3aUNSMFJ1cEl0NW5UbnRGTFpKU2Ur?=
 =?utf-8?B?cGlla1E5eUVBZ05GaGdzcjc3ay9KdGRxLzNSRjNkTWZ5dVNhSXFkM1N1ZFV6?=
 =?utf-8?B?VEtRNTh1K0ZOTHo4eDVZY2hyU21laDEyaGMrWUl4TVZnNUZiOVhaKzBuTVE2?=
 =?utf-8?B?SHRmQWFSYS9WNWVRYlI2TjNMbHlEZUd0UGNyYmdUNTlmc1gwRXEyK1o4Sis1?=
 =?utf-8?B?UkcwNzU4TkY1WVU3WTVKcVdBN3RwTCs0VXhucUtPdUtJalRkRE10STR0SXhr?=
 =?utf-8?B?Y1AvNFZMZXk5SXIveXNSUXV2WUg0U1FxdGpMOGFCaHgxNGFGQzk4bGtnKzNU?=
 =?utf-8?B?UlphSWVLdXNCZWxWaURjOTVLNlRTclpWdHUxMDdxcCszZ0tDUDdUNnljaHli?=
 =?utf-8?B?YURWdFBKbXV4RVRzaXFhUCt3YThKWk1MYWpWQnBnd3ZKc294NDExd2I2TDZO?=
 =?utf-8?B?ZTNYaDZHNDlPQWE3blRNK2VhSDc2UXU2aEdVZ0R2ak9oNm4xZks2SnlWMDM5?=
 =?utf-8?B?a2g0V205RlJBY0szeFBFUnhlbHljWEk3RkFGTnc1aEg5OEVuaSt5N2NCNVdp?=
 =?utf-8?B?NkNYd0dQalQrcU00NExDUUlrbkJYWTBXZHluUmVEdXdkcllQbTN4Wlc1UGsx?=
 =?utf-8?B?ZjJRRFR4bGhyV1pZVjRYSzhuazljUXA5SFVYalpxWmtrcFg2dzA5NXppU2pC?=
 =?utf-8?B?THlYQWtxWnhGcFBHS2VJOWRCNTRiUGwwVTZBNHVqY3RNTjQzU2xUMmhySUlS?=
 =?utf-8?B?MVlEcGtTa1FRMnhFeHRpVmpyemxzK2JDMGsxV2NEbjlpcVZpWUtBVHlnMCtK?=
 =?utf-8?B?K2lIeXNnK2YzM1FBU0lVZnVOQ0w2V0t1cmVac2tJUVl1akovbzVBTzNEc3RB?=
 =?utf-8?B?QUpBemZ2eWdpU2JabmliSllnK3Y1c0U2alVUa2sweHNnbGJoZHBGVEpnUEQ1?=
 =?utf-8?B?aGtoa3crRjZ5WHpIZjJ3UFdFdjJNUXVGMVg5UXd3Z2NvZmdQbFpXSHUwbklN?=
 =?utf-8?B?clpyODVybUJhekFDTmc0S0FMRllyOStnQTlwN3FqRTUvVkdoN0YyZnl5N2tC?=
 =?utf-8?B?WUN1RTVWNVQySVhyYnc5SXU1L2pBeHFtQWIyUUd1QUhPc2ZVdUNGY09wbGRi?=
 =?utf-8?B?UE1ud0NiY0dxMnlLQ2pPd2RHSjRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fr7PqEMeKlGqokh2Bz0UxYZiPbw5eGAMPn/bnGAcLlJ5BvbBeaAyUvSIKbZXFLYMZzafYhTyS5+kxq9/U9KsK9IiRuXiBNY/qTqTCuIvtPSsMbOM1KwVhkLTL5Ww9n1JngIAL21ii5LEsluISNTsDSPSgHnmf817Ka/yjAx2yGWTBqXuBmDK1bS/5wXSQQumUuXQaMh5I68TkM/moM3+DurtXc0i3S3RCZPHeAu+uYFYoSUlIj428BsSVOcjFJ88eGDU3WKca056YFHt6zcEMYDmjZ/Mt9zzmjTHydYPwDu724Y0AxsBv+qVKeM6MhL0yAOs5v9k8f0TkofH34krYDDDCgTPa+sH7+QYK9oHMPOGpUMqj/eyFmwvDm03xrmLT587Prcs0vyo04+WjNoHKwLYN54IZe0He4yXUBTGN9zpjB6lgqicfGUHQgGYBIlw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:27:57.2842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2508918-5d3d-4c72-b3f3-08de642be230
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8862

On Wed, 04 Feb 2026 15:39:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.69-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.12.69-rc1-g07626bd7083f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
