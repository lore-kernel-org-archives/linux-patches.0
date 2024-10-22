Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DC1A4E92
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619780; cv=fail; b=LqkLYW6fjYklVB6XkED2FfK9KX9TtJx3s1628i++7JJ9NXJ3y0pEP8u248AJfE0wRELUz4PAH2lLh6idds3P55rwnSt3+4FH9D88HE5RT6bDYtUUX/0dzejveWXUdsqgmNk0LO9DxWN77qoyQgFs4xSbMIOJeHdoumY2P2+S7zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619780; c=relaxed/simple;
	bh=Fbj9/hPG7n2qB8Mwk2Mku7qajuvbKG9C9nV23PPn3Aw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LlKvWlIMDK++/v9QDKpss0EVrEWhnA9beNycz9GwM3oroAc4TAj1IwiXoNUsh+5It8vWP0xFwq6eCSs3w1XkaWTfewIdTV+UOsKgDUZuufGzq3WGEzT8FKdlva8r/MziprgVxU91uFvuBLn52NBCEkkdUBvHk0KE4WmPyTmruLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MAo/ETK2; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MAo/ETK2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0C5/iqvYVUlF+O68SR72NqMJYPkn4RweNI64D3Qr495msgo6Cb8hXGhYgU5oOntF31e3sxNaJlqNuQ+yIZFkxtpjDHs+9EVDLn11r5++g3JtiquCWWRmUCl99St9VTrACXWPvl5uGOWqETjQKgUj9KSBTqJeHUP7Bd4up4q8zVWfZK8rNF/EFTB9DlMPobgaqiHSwiW/g7Sj4pa9FWhe+jqpqJBAxTyIMkjysogxrPLn3wEtLQNy6dJOlrLaK0hZDX33vouyd5G5e6+9KjNSbicEjWp/6do8jIK3QUUTfTGYuXTMInUstGW0cmuY+6TOPDCBqwhBigkZ2Ii/1gx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8vy2kx4OyGMwTMQBscz6AY213PZcHqDw/OVNpOsIwY=;
 b=pbQbdIK/NiX5ygNDgd9ATqs2ckk83kagWNMHfv4vGS+V/xYtBwcZz0dH/EaQJN4rGSezeZz14X1k5+o4XfZFiFTV0pM736euzwzmUsXykv4uWSXMY6iYFrZpc0svXweKk8ZaHFwHmhYLrXkZqra4I7sqYHR5sLR85ULEO3z0T8ND6uqRvI3NVwd0LPY372rCSQHeIgE26Jz1dzLMskajsIvZxfynkfv8R5KKiznMJmGgm98+sJ1OeU4CNMjezMrl85QDBRiQZ4Sb/MjXPK9oc1GIjk+GGOJZH7oAIydbsAO0Ge+4qI/+wqTJBXmXb0yN0yHcnoQaqCoxnWsaPNarbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8vy2kx4OyGMwTMQBscz6AY213PZcHqDw/OVNpOsIwY=;
 b=MAo/ETK2edpT6dJaShlekHKAXtqoB0ajKn9Up6I7N05+/AWtkeqteVp+NhnuVycdWar3sHB9HfzgN1T1+lNJsM1QVUo/399DascF8lpSJuRrsYQssRhszIOLCAAtmLco0PF6c/OflBvl0ARxTtCaxIjmcKGQ4+Two92bEdvRoMh1IiDpvxqUBgukcHz4EKsTsCcHaLggKTRmEIFIN0KbkVyaWDu6ZM13PxvdID8GABcc/pM4ZKRguDngdweVmR8MTf2M8voKCXVuVsVg+VG0q2g0bAwbuuwxYHpF7fyfaDaNDplGT+/m1WoMpuEfSks5Ck+SgMaPvBRUrCPijrnQsw==
Received: from CH3P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::23)
 by PH7PR12MB6444.namprd12.prod.outlook.com (2603:10b6:510:1f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 17:56:12 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::28) by CH3P220CA0001.outlook.office365.com
 (2603:10b6:610:1e8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17 via Frontend
 Transport; Tue, 22 Oct 2024 17:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 17:56:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:55:55 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:55:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 22 Oct 2024 10:55:55 -0700
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
Subject: Re: [PATCH 5.10 00/52] 5.10.228-rc1 review
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d6ae5bbd-93b8-490c-8baa-e8f85541fdea@rnnvmail204.nvidia.com>
Date: Tue, 22 Oct 2024 10:55:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|PH7PR12MB6444:EE_
X-MS-Office365-Filtering-Correlation-Id: 54aaf705-ea38-41f7-7273-08dcf2c2d0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V09Gd1JBcXVqMVdScXVGS1FMMWs1VEZ2Sk9sbmNiSTJtVHhlNVNiY2wrWjNh?=
 =?utf-8?B?bm9iRitxMU5EN2FaWlpITW9ISmxmWkkxVnUzRG1SMkJEWk1vaHZhUUZzSmlx?=
 =?utf-8?B?UFBYYVUrUy9GQkExTG9aUWdYZnU1RncwS0x1YTJ5NXJ6TkxsZ2pvRzg0bGFI?=
 =?utf-8?B?ZnZhVUR5bW5LaHFvYTBjVWN2cEdROTV1MWkwMjJXZGVYQ0xzUnJTYStrR3Bz?=
 =?utf-8?B?bURtdE9rcldqOWdaT2NHalVnWTlwaDN2c3Y5eUNxQlJSaGx1YWd0U0t4K3ZE?=
 =?utf-8?B?cUhGUXQ5WWNhaWZsSnplVE1NSGhiQm13a3h0RnJxa3pJejFBMVMvVFV2Nk11?=
 =?utf-8?B?SW9oSmpxUkhQSnlpUUxqaXMrR2x0K2RTQnQzdjczUmlQQzlYWFZWY2h4TFdG?=
 =?utf-8?B?Q0hqNzR2MmRpRC80WTVmdklOUDFHV3l4SmIrS3dMZnJERVZOeXBoZEQ5TnNy?=
 =?utf-8?B?c3l1bUlPcWo5WU1xRytoU01wRnp6bm5zdmVBR21VQTlYUFQ0Z1l5M09BS0xY?=
 =?utf-8?B?Mk5JTHdxTTBMcFlBMTNkUUNVTnF0MW04Y0Q2Ukp5ZVhReUZkYUxvTTVrZFdI?=
 =?utf-8?B?MDVFRzhSN1ZQL2NpM2Q5d3VoYWlwSVZrOTBJMmhEV2lTSFFkdnVWYm8zSmRq?=
 =?utf-8?B?ZStBY2dwNlVobXQzS1E5czJNNUpkenp6ZWNoK1NXOHhlbjlDZVQ5MXZNZExS?=
 =?utf-8?B?QjE5aVhQd2VnOHViNVh3L0I4dFlab09iQ081ZWIyYllBdEdWYmREQVFSS0hO?=
 =?utf-8?B?UkJZekJuU0dwL1pLdDVjaDBqSnJhWFJFODArMUpIU3dtN1RGMFFqZjlQemxt?=
 =?utf-8?B?QVpLUTN3ODNvYzBZeGNuMXdscHZONUJNRW16cHJsMjl6akxNd2RSbXdtdWRk?=
 =?utf-8?B?bWEzOXo4VlpOdUtwTENKMFp6bzRtTHUvOHljaTVJdjcrZFVSblpaVkZFbnJZ?=
 =?utf-8?B?cTlveDAxQzlSeDEzcjdrRHhPZGFwdzNuSlpsRm5uQ0FnRHFFUkpWZk81ZjZP?=
 =?utf-8?B?YTltQnNTRTE2czNzRE1DbjAvVHJvaU5NbjBFTE0ydXBPN2tmREhzd3VDZnpD?=
 =?utf-8?B?clFuVTdmRjkraHM1U2s4RlIvMUxyb1FSODhkNjZjN0FIOUpPZUprd0FVYktj?=
 =?utf-8?B?KzhpL2ZjTEg3WGFnZlpsNUNWeXJLYnRHSE9lRkRrQm8wb3NmRlVEeDFiQVZF?=
 =?utf-8?B?UG1zT1VIQ0owV3Vwa2ZRaGdoYkQ0RVZnajB3SFkvNmZaMWtYb2kxbGZaZFU5?=
 =?utf-8?B?encxSjZoeDB5WERZdXpsc251UVJiS3JKd2RYYWxaS0ZhNWlSaHM5TDMxZ3Yy?=
 =?utf-8?B?MUl5ZzVZWXpuZkxOaVc1elRHU0QraHl4NjNVS0tkbG5Md2h2b3VSUDhKYSs2?=
 =?utf-8?B?TWxxTzM3WWdQYTNHYk5jTzU2cXBDWk9WZi9wRnFPYktXVXk2aDhLY08rTUZw?=
 =?utf-8?B?dDg1SGs1dkhzRCtvdXJvbmZRL3d6eVpMRWUydjB2ZkJUN1BCNlZkNmFsTkFp?=
 =?utf-8?B?RHltcHAxK0xxQ21zUHZSNHc3WU9Rc3lqSTFqWFpDMm5hV1hFZWdqUzQxcUYr?=
 =?utf-8?B?NENoYmt5M0tJbmdhVk9UelhyZ2xyTWgyMkY4L0NOb1RLSll0dGo1WFZrOVVj?=
 =?utf-8?B?WFQrcldmRW15YnhQWUxSTnMxem1mbi9jOXNTN3hMVktCOWxMRE5SVXZQelcy?=
 =?utf-8?B?aENzalNjWC8vSW80TU5jWVE0Z1VsTDhsUHN6THdnQXRCNlpwZmEzbkFQQnBx?=
 =?utf-8?B?b29DNk9QeGtBTlBTU0E1OGpISEFwV0toSm9EclQ0NG5YaFgwdGpKNGZ3NXlu?=
 =?utf-8?B?YmtUSXVYWWhteUdwd2NNUlcyM2MrN2NBMUJCanZ4bnUyRlVtVE5JZHBrNnN3?=
 =?utf-8?B?NTNBU1VxRyt0V20wSWRRd3RPTm05TUtTdjRTQnp3NEwrd3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:56:11.6286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54aaf705-ea38-41f7-7273-08dcf2c2d0a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6444

On Mon, 21 Oct 2024 12:25:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.228 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.228-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.228-rc1-g11656f6fe2df
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
