Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5F21D018
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697566; cv=fail; b=VZ3xcQ2eOpw1hQudcMLrhgaw5xJXgw0H8jdNwklZ7Jz3EeC5ub9ahXFcUuahie/bI5gkRFF6hcd2wRXu22X0tgAAxDLCwIOdzbB4LCublJ+v0O5pR8fQqr6XOkFS9xGr7NhWH87IRmNbDYDvY5ktCizO8tGZxucJ16Slz82QEAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697566; c=relaxed/simple;
	bh=FciMyiE8YYs3lbw4yHqKojA+xPE9QXp6a9KJlp6if/s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JrCK0pdWSwKNQRoo6b0NUtg8zAXDR6fpw6K1OV46q2DNcQZj1POSfW/x9Xwr2Knd8yhNlGhxQfekjUUU2YE6/hFtPQPuvInqOS9PrYA9t6rOfav/zN2okcTti2MpxXmos34CaZIObGO5c9QtUNPCjEBW/eFWnweZgdfyYaa3MjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kr5pRaLL; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kr5pRaLL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b89tzu4hxYlhTNQsixTiYsigmht4T+85VKvmZU2idgc1/YsbllTgmldIH2K/MR0437tqiRyP0YcRplvqC6PvZILMJJrc0g0kQh7fgdsarbmNzQaLCpNb4NlpyPEO9YZq2EzmSo9Bc7vt7zIDl8j+7YtUmmT06LSfXFkIZBOkLtkNivyAeRp6Ib0ahKo/GBoWFdjK12GDfkboafR8Vr18mUj4vWyej+2AJdjIk9oVSUgD3Q5W0G2OFytaImD7LqWxlSNfzv2A3xMlPxbW0/AgsBHpbqSk8XZOecXzILBf+Opi+EfdQJ74N2lAs33j7xOLA8GVuoeZu1yQ/UPN8r8EoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMTjuonjJugBdkEYU/4qj9Irnttp7BkglLuLMJD3kJQ=;
 b=kqydLennbleD+cHSOGSg2nwS6mNs+rceo3/scdXtPnRB/umCcOvz+qI1JN/nI29K84upyoEsG7Sm8YS2pOnBLsoCA4HkdLIgsLsfrFGirXaqi67VrlbKAjFuxopk1GvoT78GJiHnJ3Q7EU77MrE/9ktayXk8RqM0G/CG2E2sFXYqAv0OdGlP67iJhaHU5Ddap6YIIhTlmbNu9MhI8gpZOR4bg+6BFpR8goQ/+rN8TNVrEUKZ7VXNnCtPZTE/ehnFyvZIwAWEOCuuyFIh98CZ/7c3+1phL9o38+vr92cQj8nuJVnELr7ZPY/ZABKfx+wwGaNeyNapsNCHfztBymvTNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMTjuonjJugBdkEYU/4qj9Irnttp7BkglLuLMJD3kJQ=;
 b=kr5pRaLL04DwJcLtC+rGP7ig9Q06vZnEiOYgfi249Uwjkrvir1IqzsF2q4q9t+SowFQvNPLiXTX2iTMPipcTyPyHA3UdcrnVpAENapMCbh2trnie0ehmkcDDwr1Gng0DxhDq3ft/fiKVIBhbUP9A48gCDE1QymksJKo7tJ3ci/G6CAHuNm9QOmjLlxWey+nSGxacOhr2/6WFdCal0my0V8/L0Z2m0bwi488H2kQ+hoBBPfiP1801XLuTyhKlWchcbYppJADDdnA4Y3EQcE4CQqJhCSNTZHpTI9uxofJU4YklWALy0woaO7b/5HKBqqOHYazV3I4jsoxAc16F6zuuDg==
Received: from LV3P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::34)
 by PH8PR12MB7303.namprd12.prod.outlook.com (2603:10b6:510:220::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 09:45:55 +0000
Received: from BN3PEPF0000B070.namprd21.prod.outlook.com
 (2603:10b6:408:234:cafe::b) by LV3P220CA0013.outlook.office365.com
 (2603:10b6:408:234::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Thu,
 8 May 2025 09:45:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B070.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.3 via Frontend Transport; Thu, 8 May 2025 09:45:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 02:45:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 02:45:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 02:45:37 -0700
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
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc1 review
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <70d6e220-a1c4-4353-84fc-6373cef87ec7@rnnvmail201.nvidia.com>
Date: Thu, 8 May 2025 02:45:37 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B070:EE_|PH8PR12MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: f7aded5b-b84b-49eb-1e5b-08dd8e15209a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWFueDN2bXhSamRidmk1OTQ4dzZiN0cwU2N4b3Jac2NyMUlLSHNKcnZoaWMr?=
 =?utf-8?B?eVVMWmpNd1lsbXZOcUNyemlJZm5DZjROalZnazZxcis0NmhSRGhRZXdZWE5o?=
 =?utf-8?B?b1Z1a1paRmhjaFRZTU5oZStDOUdub3dPMy82NC9wR0lKRmQwM3dGZWlhdEU3?=
 =?utf-8?B?dE1rWit2VnRiTEZQc1BYQmpsZDdDZ2dOY2Y0dDV5N3JoT3AwQU9aY2tBL2hh?=
 =?utf-8?B?S3FCLzNVNVkzWVlYRWc1YnpmbzBvMkZ0dUc0K0xXWFdmNEJQWFEzTW12RzdR?=
 =?utf-8?B?WG1MUk5uR3FoSWM4cGtGVERDV0VjRkZGWXcvakQydDA3SEtWVGRXbGFEd1ZT?=
 =?utf-8?B?UmFkY0VoV1lQV0owbFprQlNxVEhrbjlzMU5EVzJLc1o3cEQ0R2UrTDkyMTcy?=
 =?utf-8?B?bmRKYWt0VDBQOTFKdDdTeHhiK0dFYnNBcmNLdEJkYUpSMUpKcXdueVF3dzhI?=
 =?utf-8?B?bm1NRGlZaEpubmVwT1VQem15a3RVbmpsSG5OYUJSYW5sNmt2OHcxSmN0UU4v?=
 =?utf-8?B?cWJ5S3hERlJYd3FrYnRWWUU5Nis1VjBBMzNOK3FrTkdaTHF2ZVVFc21CMk5M?=
 =?utf-8?B?aWxhdmhGTTRPTUs2bzdhMWYrMS9UbXkvNk9YclZGdmxiTWZ3R09xKzNJV08z?=
 =?utf-8?B?SWxrUkFFUUFWTm14UTBLRzNFK2RiQ1JtZmM1ZHJNMlBDRFVwa3BSV2l1cVM4?=
 =?utf-8?B?UW5pVm4yNnRjTkZ2UUU5VlA0MkQ1MHhzNm83a0NVbVVBVkJrK1FMaktDcExu?=
 =?utf-8?B?OVNqelVSVW5zMTdLU0pYMTNNK1haNzZ3WVJ2TkRibzZJS3VOTFNHL2QxbGhS?=
 =?utf-8?B?UjFVVzE4QzN0M09JalZ3bkdXK01JMFBQT05maTlIaVBJUTJOOXlzOE5UYXov?=
 =?utf-8?B?ZitzWlBUUlZiUDBHUm5PMUtycUxtZUV4UExmTFdqYXRtQVR4dUZCalNpMVR0?=
 =?utf-8?B?OXZ3MkRqZEQxcVZKSjdWQndXejAvMHFjODNPWmVIZWMzaTZNUW1tUGpyNFFZ?=
 =?utf-8?B?MlArb1NXMWhnQzlzR25SdmxUV083N2thYnUxeDd5Q215VzJsTVNZR0kvQXB5?=
 =?utf-8?B?U0JUUjVsNmVBWmJhTHZjZ3lQQlNNU2k1Uk1nYXViZlVqdDNvWTJYZXZSU1ZK?=
 =?utf-8?B?eXZhVk1HcnlOUkN0Q1hQbUlsRW1XRDFYOWdnQVpOcUxBbFhiTGp4VjZBemlY?=
 =?utf-8?B?dmM5ZjlOWUlBbUNqaklGcWhEVDduRFpsckp5VGt0ZEJHWjZOMjBjVVhBUjFn?=
 =?utf-8?B?Y1RtZ2trd29XaTJ0UkpaU2tDUWxDK3p0WVhzT3VZK0I3czZZMjRzQmpDQ3Nj?=
 =?utf-8?B?NXE2SHJ3S25MenV5b1VTQWtGQ2dLRE1rWmladVNCSEgwQVB5TkR6bXdWc1FT?=
 =?utf-8?B?NmZxcUFuU0trVHIxQVhRQUxuWklWdUtVejZETjV4TGkwZnk5bWFpZ2ZoOFBm?=
 =?utf-8?B?dkdVUTRKcjU3dFV4VHlmQWNSdG1PTzZma0I0bHlhVnc1ak5MTEhibXI2VWZ5?=
 =?utf-8?B?WU9iY2hQZTc1ODJZS2ZmMG53WjhOL3NMa1ROVkdNaWsrZDFQcmFoVnM3dHdW?=
 =?utf-8?B?MmdqRTRiWDRna0dZV1g2NlcwTzhVYTg1VnNWYlQzVS9RNjM0R3FZQXJyaUlw?=
 =?utf-8?B?aGJCRTNoSWtOUW9UdFg3MERzdXN5bGNuamZWeFZCcS96QWRpVklHZHp4V2tS?=
 =?utf-8?B?NkVSK1lqVVhRdmNwWUtaMzVRZTdWUmxyby9LKzQ5eGl2TWsxVUM0SGdwd0xG?=
 =?utf-8?B?NGU1TWpERU9LUzFBMDFBWDdiY3VBRDhUT3BRVG5Wczl5bktabDNCTVh2dWIw?=
 =?utf-8?B?cEhtQUx1dlBaeDFoL2plZnpIUU5JdU1mdHlwZHhYb1ZueHNmazVVV0F6R2o3?=
 =?utf-8?B?clVYUEpRUUFaSXhRVEh5bTE5SUJtM2hlTENoelpsSUVZU2tXSVUvdTlmZ2Nn?=
 =?utf-8?B?Q0pWcWFXRWFiTk9MWDBjOWdpeVZXK0dBZmZabXRnWW45WnNSVU5OamkyNm05?=
 =?utf-8?B?QkxXY1Irb2ZCUk5rUWpwN0lvdnpZdHQ5ZTZPcWl2Z1IzSXRXckV1WlVWVSta?=
 =?utf-8?B?RDdCSUtsNXNTZEFJSXNNS0VuaWVsVjExWTJxZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:45:54.6827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aded5b-b84b-49eb-1e5b-08dd8e15209a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B070.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7303

On Wed, 07 May 2025 20:38:56 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	109 pass, 7 fail

Linux version:	6.6.90-rc1-gaa44cc8c73c5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
