Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A126255F3F
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867934; cv=fail; b=q+nIG/eiD8s+kgAhc+BKfu+md0EdZuN7nxN+HZQzuet0O1xBQ81xyBnnPO5+3ezMx6WRMQu51MYNQqgCa0xoqTRSGuXfOIJ150uvV7DEykKiGD3vW1YD+cMmj/YmQI45ISfLGsSM1AjtpV0Blt1ue2NUzN/meOnPfUSSgIS6U0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867934; c=relaxed/simple;
	bh=cFhglFjYRKYap1lP78hpxhYac5M3wNwFbR4poBoReZg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=s6V4HGqcOkIQvoN9r8Y2FH6Wq8S2jvQwvHdx9MHQlaXaJacOMTF6VT2nFc9wu15NqjEo/11kiM1O1HHHdzyY7I4XD2DbqI4b/oyMUsCeVNB7Ti9xfGEr5xMuSr5lxufI4wUhHVOgBAS1mP3BIGP5MWWtypVxaeFeijqfJI69KEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KtKd+Gtc; arc=fail smtp.client-ip=52.101.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KtKd+Gtc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kcAbh8+O+3a4xQzFEArf38Tdc2UuDtYOhkazJu6Wg4uEFFtuQmmaUxDamz4vvrb61+8DUhx8ZPtlWIRilDmIM7xC1FeZd/JNPwLV/iXef4GG1dLTdVS87+UTWNnzVq6hL78cDil+KBiBT9QkXethYhkuLfTehFbYne2RR/lZPa3uTpsSeFzrHMX91t3Eckk3rGhGCYVAnt+VyTC0nuEVlx+p7JRZ77zhdaCtCmty91lq2C1cOrQYFVQyAJHUDLe3maARy8bmcgc9QAkTGg29ikTK2Tmin4qYRsBZrO3iOInEN8ba8+6+4M242vhhjvZ8Sof0ndttlmUKR+pmnZ9ZRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2t6zMtjD2IJE3JM3K6KuQi1YNMZJZ7Tgf6s/gOUam0=;
 b=AWBAaMKRqYr/k9DXuEg76iQ18pC1vqdCwWIVxmmfWu53VhDLkWnv+avw5g2LlHyr8YeQtmAp/3jHRCaNklz+9YIh3SyN5YxDrcISGLKopVoZ8c1QKevzDc4w6UVKAYfT52eJGC7wMWAvGem9qG9dKhflyvFNkP2KUfsFffta4oSASKQ2MIDlYao5wSWMJ/KXg6bROv2INulrgqMjMQPRMrpgFBO+My7Fv/Bm3jQLqfHylJcb/TANfYgJV7ozk3Z2+HzNlbaNxxKRWVQqsbWoiMB8E00fmGSjracWEccQsF08epl6SEiyS9/Lj945LNcIbhmyz2HLMI3tCVOeJRyLMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2t6zMtjD2IJE3JM3K6KuQi1YNMZJZ7Tgf6s/gOUam0=;
 b=KtKd+GtclCSnhep5SCYi3ykyG07ZIgFfGtDSfl7JJgAuWmaJAKm9DcL7JmXKRh6wifv6jLUXK9Zbj76yuX8ddFGdUpIXGdNHVLxgfz5Q1afYOIomcfkBGSSfVfb5DutBHI/KaEKpsiOsApJeWogjD0SMsAJYa3oHMczcYOp9Tjpjvx5p1wbRh/KN+hNHRrF1hx9ncFXCOA/W2EOFzdpzqJFyj3+ZjRFLXxtUSSMFrtys204mKCK7WfcQdYEIMtg5ke03iK8NAx+UXjOZdyNoyXCkZrN71JRxHbUWIYeSEL8e2wjDKi70yZqqmaJt6vYFWuBqRnj39+jrkz9XAorNQQ==
Received: from BN9PR03CA0663.namprd03.prod.outlook.com (2603:10b6:408:10e::8)
 by PH7PR12MB6442.namprd12.prod.outlook.com (2603:10b6:510:1fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 11 Nov
 2025 13:32:08 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:408:10e:cafe::e6) by BN9PR03CA0663.outlook.office365.com
 (2603:10b6:408:10e::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 13:32:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.0 via Frontend Transport; Tue, 11 Nov 2025 13:32:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:31:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:31:49 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:31:49 -0800
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
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <137901c3-ac7d-49f8-9bfd-cb2f910feebe@rnnvmail204.nvidia.com>
Date: Tue, 11 Nov 2025 05:31:49 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|PH7PR12MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 89d316e2-84f7-4f36-d553-08de2126b610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3d2MWxhbHJlZ1VCdWxlcW5pNGh3Z0ljKzVXaGIyd0hkd3hITEZ1ZUVFcGc2?=
 =?utf-8?B?eDJYOTRCeEZoemdvYWM5a1hIYTV5S0FyOWZDZkxHTDExYkFmeTVTNmFvL2tz?=
 =?utf-8?B?N25Jc0hLaGNRWU5QVGpsSzBjcFc3ZldkeFJvTzUxa2c2dThwTysvRHJyT3lF?=
 =?utf-8?B?RXhRQmU2ckZ2S3BaNTFhZnRHTFVGbitlUkRLWlpxejk0TGRiR082aEhEUVBO?=
 =?utf-8?B?UU9CTFI1dkxvOTR1TkxyN2xGeWZtZXl6clBLRlVvQWRnelBhRGxKVytoVXRr?=
 =?utf-8?B?Q0NqbjJDaXkzQ0gwQ0VFSk5QRHFGcDdWajFHcDg0Y3FZYkhBNEdXY041RG00?=
 =?utf-8?B?U3NTbStTUmFod29wVWhyNUZBOUhFdHpYSG8rMVBaS0VQQlNIQkJkdEFEVTdH?=
 =?utf-8?B?ZXFOSHNOOVc2SERBYi9YTFVoUUV4eFROMktCelZEdTFhUmJtU29YTGpxQklh?=
 =?utf-8?B?VkQ2ZTZ6bGhRQmdJTWx0MWZ0WVBITURtNVVlRW1VRSsyeE4xVm1yVUJDQ1Fn?=
 =?utf-8?B?U25KdWpEWEE0eDcvUW1uaitGVjJOM084QWJQQi9VNlN0cDRxRVJJaFNZVHdl?=
 =?utf-8?B?dERTQjJ6TjBGUnlBTjNXQjRTamcwMEcreWx2Y0pKOUl2NGgvU2M2ci9uOHcy?=
 =?utf-8?B?VDdjNGFVRnhNOUZ3N2JaYVljTVcvdXFoNE5lSjc4YjVNRGlySzZIOXdMTmFi?=
 =?utf-8?B?UWlTdkVqQTBEUndBZk1DM2lhM0R1QXpYa1g1T29sSEdaMHZwMGowTE9BZTVB?=
 =?utf-8?B?WVhGNU1RWXV4b0praVEvaE1mVHdWZE9GOHNsRVZycUhHL0s0cVBLbXc2TXo0?=
 =?utf-8?B?S1RwTmcrRTVJdTJKTWRjY0JHS2l1QmI5N3JnaXNqR3FRUXB3NDBmNlRpdXM1?=
 =?utf-8?B?aUtlc0pxSklMWUhhQmJHdnAyZ3psdXFuM2YySXdnSkpaWGc2MzgwUDRIdXl1?=
 =?utf-8?B?RWQ3bUNudVhtcGNDYzhsak9aaE9USk1LemlxQWYxQkgvb0p3K2RLSVpjdE9m?=
 =?utf-8?B?Q2lhMEFJMjBKMjJ3QUsrYTUwQVNUZlhMUmJKOWxkNmxPNzlXdEpKT0psNTY5?=
 =?utf-8?B?cDA0VW9ITlQ3a0ZSeHJSL1NDVUNnS2lnREZiU1hlNktuQkt6clRSTlAxNXEw?=
 =?utf-8?B?ZXhCeW5NbWF0MFJlNnZXR1lGU2ZoNHBCNlVPMG40WDJMMGZiMVhXV3ZLUFJ0?=
 =?utf-8?B?dS8yWXIzMWNaUGk5SlVUc1g0L2VaMjc3alp0YU5kVzNyUE1YOG1hTUdWSmdu?=
 =?utf-8?B?ODZXOGxjVHlVZVNBUDl5UjFDbHlYL244RVk4ZWdOSzVzV2VKVURCNXV5ZStR?=
 =?utf-8?B?emxNSHphZksycHVTbWZKYjY1OGU5Y0JVTEp1TUd4SjBKcnRXL2ZiSHg1MGEw?=
 =?utf-8?B?bzNIREpGd2hzOFlLc1dUVE9seUNwTHpwVzh5QUU4WHptM2FsdlNVNGYvTFFj?=
 =?utf-8?B?cDlPWUcvaEtPM0pYa1pwclZ3ZUFFZmZBaEVFU3RMZXRQdDVTRS8zU28zMG91?=
 =?utf-8?B?bC9oV3I3UGIxQmJvbWdEZzJiUGJmT1Q5NkJ2cTVXSnN2Tm1KOUNSVjZUL291?=
 =?utf-8?B?T2JJQUlmdVZ4NHlVeG9Qd08zakdMeWF3WmwyTGRqZ2NXZTFidVVyMmVQMTgv?=
 =?utf-8?B?RGlWYldFdmNFUFRablo5Y3ZNMGpYaU1QZVRHTzJDbkZmM3NibHJBUXZtbGk1?=
 =?utf-8?B?c2QvY3lGL1ZibFMwU3U4MnVySzZXY1NzaGlJbWVJYmF5eEh1OW9ES3VMQkhj?=
 =?utf-8?B?enI0NW9UbEZrS2xnTWpRRzBiNmxxSW14WGxZS1FRY2l4bFZuTWNNNmJhZlR4?=
 =?utf-8?B?OC8yWS90UDBkYUlPU2cxajlQVTUzTTh5MHV6dkp5bVYyMUUycDJxZS9NK1hy?=
 =?utf-8?B?U0dNamdIWjJhNU5wZ0FRMWhzNXZTa3lTcnpBQjFmdys5OHlleVByM2cwQjND?=
 =?utf-8?B?Ulgvdk5ua0lVcXpaTlpSWWdESWN0eVBBYXNkb21PaFAzWFFFMXBma21vc3JW?=
 =?utf-8?B?ZnA4Uzlid0tGa3FxcCtGdUt2Wm00bCtqNitaMldERGtVdGJNM0JKakJpYnJY?=
 =?utf-8?B?YTFPVG1EbUEza2E3cFRrY2RaWmsvaTJvbGZxeFo5dTY4OEtMTXhlK0o0R0dJ?=
 =?utf-8?Q?DwB8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 13:32:07.8302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89d316e2-84f7-4f36-d553-08de2126b610
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6442

On Tue, 11 Nov 2025 09:32:50 +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.8-rc1-ga0476dc10cb1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
