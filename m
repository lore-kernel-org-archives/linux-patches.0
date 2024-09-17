Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492201CCB30
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586377; cv=fail; b=BjVxkuGJdncgeJF/oJwJFOiY5jKfCVmIPPB4DyEl0Tfyb58Fu/oc9TadwfCtFLBmjvS/U+dwdmIsmgYPsCQPrVgZZAEO61U0YRIrbKYugxNwh43RaLPjxxcup5MRmBHsMfrwM3ymXqBhyuGg0i2921nYjt6xPfCQOfo7mb0kYvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586377; c=relaxed/simple;
	bh=kwCoJLVaK6v07yYTz5McZTXLXk0cj3v4oHLSmWhQEtQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DcxaOTAZJcnLk35nP3/PTiWk8PdG/9K37ZR9yeOMWPHjpVybB0hg1InQ/w/ZEKm/DNymMP7Libt8jp34GqVBQbHUkkz6xQUVZnL/XGGbLUNYouqExTv8k1YeOIOYTT/yZjmd7ms4ugvfLt41uanLeSb2DDAjcAcrCU3eLU/BU8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JpkeuDa6; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JpkeuDa6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qav67mDaUZ4hWxLH3w8ocGWRW7Q4V9EyPogUNboj4eA3j92HhmOWMsmK18646Rwdwa+fUc/7fFwMnSGcpXvUZM57XgRcwpWfz+Tdf3Hnc9Ok6z6PIgbkXXz4O7uuJOF7uC7GSfDwtXiZkpNSBee/uPpH9tpQ5RP5wHkFmHuEsips1bhqYdKUV5GmtDP8v81VQYJi6SBg+VeFp6mcGQZ/q1QU431eBnsEhTRK5xvnICChJlTeeY3ZLlgjmgXqxCb/EuJy/nVaIuu7HYMRKzfgCJdS/CE89CN9q1DJjfvAka2v3ynrb1KeGj/yJ2c3cO0SYO70l0dhjY0ON0bqTkYYhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxv7V/HOtQv8NRMchAXfFoPOKSKqrPwd0suWvHatD8s=;
 b=RJcYr0CZIUlWzeyNy8nT8AeSdScpmlk1eG2fYuaDZnSM48W/Q7WGc8Nwa//AKECdNjXR/G3J3KkfwV8zJ+cmkM+UgRc8S6oWGx1htnLRUHuZEDOu34H5U/E8JMw9kqHbecCcByy4vRj0PLUpO66ZXdKEOAMPqHoEoCgWKVsecDJO/GRTtfYdNyu0lCBA/eVSm6XAzYqTVFR3gBZH+v1NSRvQZVRsoYWEXR6yDAADXR3WhL5fc79EZ7AeMV85a4kdstyROvHrmJUJulUIaQy4Tf5HS+nBSx1lTU3SY9yIHOgRY/vfIyYXGOBdQzUQixUU9oWhonQcPYYrJHHXgne+JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxv7V/HOtQv8NRMchAXfFoPOKSKqrPwd0suWvHatD8s=;
 b=JpkeuDa6yj4HXCJfXdhrtX5Idt2t9yHrxAb3A8a6P8Z6cxG1Ca6rbKM4Veo45Pawe8WpUOzOnwZW7K/JymICzISCP0VbOP++K7h5d80XIa3yk9H8m3xvbhfQKBDQYbeF51um5iya434sNf20oKsvK2EP0pBM6w3Tx8LLsq3q8CTXm9MVWh5q+6e9mHkX41m1GTWDD8igU1F+vD4lWBAC/hDmnviEIHTQ5z+6FixL4xTSj0MpVWwnJ51tkENDsKozvuuaCrcjPxNrzY2oGSuaprsd7a2+OveQIDR+uhG/djSwYXuOClHFNYD3xDzW8CbAbdpPgu8sjjcNpEHddL19gw==
Received: from SN7PR04CA0039.namprd04.prod.outlook.com (2603:10b6:806:120::14)
 by DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 15:19:31 +0000
Received: from SA2PEPF00003AEA.namprd02.prod.outlook.com
 (2603:10b6:806:120:cafe::7e) by SN7PR04CA0039.outlook.office365.com
 (2603:10b6:806:120::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Tue, 17 Sep 2024 15:19:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003AEA.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 15:19:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Sep
 2024 08:19:19 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 17 Sep 2024 08:19:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Sep 2024 08:19:18 -0700
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
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0919b09d-fca4-4abc-9e29-e27a984533a8@drhqmail201.nvidia.com>
Date: Tue, 17 Sep 2024 08:19:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEA:EE_|DM6PR12MB4124:EE_
X-MS-Office365-Filtering-Correlation-Id: 828df7a8-d29b-4943-c33e-08dcd72c20ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkVPV0g5OURnQVRFNXNHbzRMYzkvR0RaSU1VcHJZODdNTGpIOUxDc01xa0dz?=
 =?utf-8?B?dGZxc0F3U1pSSEFtbnMvM0JsOWxQNTFycXJHaVNLZGg3dDFMU3AyTzN4Yllk?=
 =?utf-8?B?dTM0RGRHNW9SYzhDY3l5NTNLOVNmMmdFK3d0SWJ3b3hZL0hXNW94QzMzcVpS?=
 =?utf-8?B?Yi8yQUN6dy9UcitrRjg0MnQ4TlMzM1pDRzE0cWk3WTd0SEsyNGtTcldIWVlh?=
 =?utf-8?B?ekRQMXBLaC83M21waE9HZVpuNmlVV0sxNmFvMFY5eE00ZjFZK2tCTkx1Z09M?=
 =?utf-8?B?ME5wRkdTR1FqaXBBN2lYdlBMQm50b2dBTm1jbEM4cU44ZWZKeFhiK1l0Vmhn?=
 =?utf-8?B?bU5Id3B1V3gyQ043ZUhrT0ExcVJLUDV1eHplYnVlZWR0dUx0YlpVT3RORlQw?=
 =?utf-8?B?b0M2WWhabGxMWGoxSWpBaTZQMWFHMFJxbmZFdGVDM2xVNXU2SlpHSFp0ZFl4?=
 =?utf-8?B?TGZKMmR1LzZWcC9lT0JLaE4vRGdiMU1ldDZpWjVBVTRPWVJEd04vMTJydlBR?=
 =?utf-8?B?enVvcTlTN3RUdzB2TGhURkdLTTNtczV3dHlPU1E3MHVxSGo0QzhuT24vTm5l?=
 =?utf-8?B?S3BoQ1puK2RDaTFtaVJCc0tLUnlDTzZ2bHBlTkZuazhad2QybEU2TkZhYWhO?=
 =?utf-8?B?cWN5VTh5Ym9FQ1ZzdU05VkRYWENhZU51ZHgrMGpKcUlrTlE0OXc0YW44UnI0?=
 =?utf-8?B?cWVSQVNWMXpzM2d5UFBubnZwL1lGTzg1eUpLKzFRdmNYSVUyUWJlZUk2NHM0?=
 =?utf-8?B?WlcyMG9JaGxRdU9yOXVsQU15cDZXdzRmMlVUT0J0T3VGNTR6Z2g3U0lhbnpa?=
 =?utf-8?B?ektYL210S0hQY0lvZUlBRVo0ZUVwa2w2UFJmNHgrRFNySTBtRzNLOHQ4cUpP?=
 =?utf-8?B?WG5NdU02endTbUFWQWc3NlJlSGxWS0hYdjR3bHNIRWE4ZHU3Q0lXMldLU2h4?=
 =?utf-8?B?c3VoZ1IrUHhJYnEyaklTWjNPdnh6TlJyR29PZzY4dUFVMzV6MjlocXVEL1hW?=
 =?utf-8?B?OWRxQU85RjBjKzFCVWNsbWNQNncrT2lSeGVhdDFSaXlNUlg1NDVhaUhiNGx2?=
 =?utf-8?B?M0cwU1luK2N6aE5qVUZlTW9WQ3ozNTRjc3RtbnBjdnFjcFdzQVFjbFVpRExl?=
 =?utf-8?B?eHpsYVdUVUVRbDB3aWpPcUVqRWF1Y3kxdkhHQnRMS0QwbmFpQ0lFZG9YTStp?=
 =?utf-8?B?MWJ3Z1NVVWVUeE9iUjdOV0tQK3Z0Zld3T0lLSXV1ZEppZytORFpKSEJvcHdJ?=
 =?utf-8?B?emY2bGpZNFJ3QncyQTRvb2x4TVZXRW1nZUZBMkVmQUlGcEZubHpvQmpZazNO?=
 =?utf-8?B?YWd6ZUxXZ1IySVBSdlNYck9jUG92VVE5Skd5U2J4NXBBQTc1Y2FJZTdMK3Fh?=
 =?utf-8?B?WmdocFFZMXAzcjV4dXl1NDFkWFZzUk9sSktsb1JwT0J3Slk1eFV4azVtaW9U?=
 =?utf-8?B?SUpJY2dCaVR1RjU5N0VEcFUrdllwWDVHaFNIZnpNeU5DTGpvbWFKQ0lxSXFZ?=
 =?utf-8?B?Y0pJMkZ1cGJVWS9VTm9CZi9xdkdJS2ovT0cwTDFxdEJXSUVlMHBvWFRKSll0?=
 =?utf-8?B?TWFyL1FtYnFvWnFWNVc1RVNXemRSczBvd1BpUWg3dGFhaTQ4NmREcllqU01C?=
 =?utf-8?B?Q1dxLzcrY29ycU56eDB0aVZDOEVqSFlqNnV6OUdGZ0wyMmkvVUJYaDNQRGh3?=
 =?utf-8?B?K0wrbmFQU0duTUNTWWhaLytuU2U3RVFFNGdybXZQZ3dPNEZhMUg5Ny9LNVdp?=
 =?utf-8?B?ZkVYR25lL0crUWFKS1BvMExHdC9JeHZod1lzKzlhR2E0cEZZWUtXYXlPUzU5?=
 =?utf-8?B?alRQTnlmRU5Vb1Fjem9VN1JLaDBuejFiNXBvL1U5WjI1Wnp1NU0vdHZhaUJn?=
 =?utf-8?B?Tkd3THZNSU81QWdUQVR3Si8wU3dPRWxaanNSS2wwRlk1eFRvRHk3QkpkaUV2?=
 =?utf-8?Q?XHhhTCV0i/DZ02BPIMG6ft/A9Mc80EYs?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 15:19:30.7094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 828df7a8-d29b-4943-c33e-08dcd72c20ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124

On Mon, 16 Sep 2024 13:43:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
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

Linux version:	6.6.52-rc1-gfd49ddc1e5f8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
