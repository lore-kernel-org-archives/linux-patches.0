Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B964112DD99
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564138; cv=fail; b=KDhUdh64ZXXekyFzmbIuq/B3c4F0zVgvWmtA2NXywCR1d3/MOj3VSh4pU7Xj3shWEHY1asFLr92NrRHddWuvkFwSaWKFHpAj1Lpy0TkfGkKZQeIrE6GKZ9W5k1VA+lGvyPsBw067X5O5SRM1kYM7o0cmFu1SQmYU3pnCsiSqAUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564138; c=relaxed/simple;
	bh=/GATzXolcKovYAiV+G7M2wyIiE8SvGb490Al2rOLHUc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LsADOremPskgbkGWc2XAzehe/DzRrKZ+sy8XJRbFK/XCb6fKU47FusbF+fcy0aSOZL+yIAgu6TYajvmTRORDOb0R9N+HEE6XzATNY1Esbqeh8XWEXYmJPZAWKIK/0x02xLOC38hi/xVB/ZP9JQy/gub2HjmBFn768LBriFO8108=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rCHbJ5JC; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rCHbJ5JC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2lI97A+0G4IRWYEKwG08vaw3NrmdBxvuIqC0yKa2qSfJ6DHQgbZoY+JOD87aRB6BwiIHVL50IDDnk8yX0WIh4G+FtVLGId15+7l9CZmL+JYj5z6fKRjM1XW+wT9vT/+afJdF4V3G+6zivmZIejrV2Y66U10sh176Rdl5/T4wCfUEIG+chBqYZBDwG1aw6ZPHgcigkOOuNTFzPH4g0KH/cOQLfY+0wgrvn5r+r7QULcHGlGAHunVZRLV8gtp14AvWTPjAUL8b0OV7kBxTkFtY77pUkI9lJBszVGHEPD9sRRmOvZCWLycxcRC42Z5LV5HZmkm2dba+LzUMoiNtcRsCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=991QfFR7UUzhHs2V0sVxT8/LpUf4Rq55FYzfIh+0H7s=;
 b=fwIlJ7jHs1QTn5tDXpyxgIC+4ADkn6VIb4eFShO2KiVG0iz0bGV2o1gKb0MA719XgP5NULHQ5mbkQkqOtrGnGnUq30F4tK4P+jAjoa+Qgf3AFmVJ6HgTMKp3HQO1AslLK7jVjhQI/ol7n0OBH8AVq94SqeNu8GQRtYyMazedgZ7vje0DolDu8QVP37gOz1pt43yEvlsfzOtXfz7peBooV0hoiPUn7y98f57XVGRJdJdaJk/zAf96ybX1tCbAO1bCZeeCWIsNoO3ZRQuc9F74WtOpithtc2cIdKKYO5O0w1CxWscA9LWHbZwr7zPFmkEn5DggiSxs2px/7tUVk4/IyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=991QfFR7UUzhHs2V0sVxT8/LpUf4Rq55FYzfIh+0H7s=;
 b=rCHbJ5JCG64BKlkcwhRQhOWrYcI+dyUhuR+FNlky7rSiZi+sBwj/8i9+l3d9dkdOUYNrG20gWamIWuHTHTVDdEb5RrELK9u1aHOe8FqQ6l6fNkwKL/WAmXCsdcZwkf0PYyeLmxfNoATTQYCvTRUb9PUummhio5SHXHoBYCVH1LaWmCMbzjHyPKNbNpc4Zex9LeVSQS4pT3v3hDks9DxhGWjbvgGODEOlpRMKRg2lJMem5Kfn1OBpHhbHrmwMrwGbIVeKpNSMJ6Pu7xuCBcy/JjMpWKE31/1uilslKujw9qrccWTr4ks9jHQwu7Aiws2lT2pOEupZOZWZ+CURIacqDg==
Received: from BL1PR13CA0235.namprd13.prod.outlook.com (2603:10b6:208:2bf::30)
 by CH0PR12MB8507.namprd12.prod.outlook.com (2603:10b6:610:189::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Fri, 24 May
 2024 15:22:13 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:2bf:cafe::17) by BL1PR13CA0235.outlook.office365.com
 (2603:10b6:208:2bf::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.9 via Frontend
 Transport; Fri, 24 May 2024 15:22:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:22:12 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:21:55 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:21:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:21:55 -0700
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
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2f530277-c441-4291-8bb7-fcda02276e00@rnnvmail204.nvidia.com>
Date: Fri, 24 May 2024 08:21:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|CH0PR12MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: cb824583-535a-49e6-f861-08dc7c05497c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|82310400017|7416005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGI0S1ArQmJ0MXYwRVlwYjVvUVhsQnZ3SFZJcnIrai9IVlk2b0tuZHdHTlU1?=
 =?utf-8?B?KzJobmFoT0dodnBHWjRJS1AyRTNMKzljU1g3QVlBRUdyOThSTTJ1cXpnclFr?=
 =?utf-8?B?TCs1SjBLSHA2V2o1TEk2ZkZzYzBvZEgyTGVWYndrMWVWajRXWVNnRHNJRXlz?=
 =?utf-8?B?cVBEc25yYmNJM2ZqcVd3RnB1NkQzTnEzUFVxdDQ1MjVWdExxZGVucEtmWGtq?=
 =?utf-8?B?bVhMc2hkL25vTWU5ZG1jT0o4YVRaTTZaTlliMG0reG1OSURMTVNxL3NnaGxG?=
 =?utf-8?B?Szk5MWkvU0VZTTl5SEI5clY3RUhGRHozMHlGSDhWZW1vREFMajg0L0svK2lu?=
 =?utf-8?B?VTk4NWRLRDZ2QjkwdEVGbm9uR1MvWWI1ajQrdWEvak5oMFQxem1GVlBmTk9R?=
 =?utf-8?B?alE1cHhyeUlRZFl5MEFuRFNpdWNCV2JUbkN3K29kZU9EVWxQUnFHTlZjWnBo?=
 =?utf-8?B?QmdQYVJpUVRMbEJON0VRaCtmOGwwM3d1TmpHSVhBTWVXZEpvVVBxbnNtRFhP?=
 =?utf-8?B?TWpDcVhYaldDK0lLZkZraU1KQmltYWg2YmVQdU5LRkZvMmtVanlFRjEvMEFo?=
 =?utf-8?B?TWNtMS90QWFzSHFRaW9KQzBBQnJDMnlpL3hucFR0bW9BVGlXaEN2T0R6MmRm?=
 =?utf-8?B?UTY1enpJRlpTZDFVSHVEQm16RlBIVWo3L3JNekxpbzJFd29MSGVIdkRucWtH?=
 =?utf-8?B?VXhCU3EyekFVVWZ3a3dwUmgxVzhxcURlVlQrSDB2NWwxWllzVkFpRlBpbU9E?=
 =?utf-8?B?d2RiLy9tdWxsNU05YmVlMGgrZ2F6VHQ5Z0dIQm5adDlBcElTQUU4VytjKzNx?=
 =?utf-8?B?em9VL0R3TnRySW5jMmZxbWdrSm5BejlxUzNmU2FJeXpDM2FLN3ZkWmdNVFVN?=
 =?utf-8?B?Wis1UENWTmtrY0lzaW1HT2tROThFRmFPLzY3YTRZblFYV2Z6SFl3eUVQcEVW?=
 =?utf-8?B?RnlJOW5QempPbnIySzgwVnAydTdZWU9WY0ZwbGxlNDhVVEhYTTJLZUhEYXRk?=
 =?utf-8?B?SU9udERWV3MrTENucXlLaVZiUXpnRnlCTlJWSDdWOWZDTXJ5MmYxUFZ6bTht?=
 =?utf-8?B?ZmkwT1c1VDRHMDJmOEtqMjM3U1NyeUY0WlBBMCs4MmtKS1dLYkVrNTRoUDho?=
 =?utf-8?B?ZTkwT2lHeWdKRGVKd2JQN1o2VVFoMmw1cWY0ZE9tS2p6WGY4MnMrSHRFRkFC?=
 =?utf-8?B?REs3M0RQdnZUWSttVjdDTVUvNFF5RmRoOUZhTWFwTFduRWRweEtuSDhYczZq?=
 =?utf-8?B?c3JDWXVpT0dyOXkwSHhNZWczREFkcCt3VkhCdmFyU1MwV2hnM1N2eXZmK0FL?=
 =?utf-8?B?OXpiN0x5WjI3UDlCVFU1ZlNueFNVU3U2dDBBUUZBVkJSVE5rbm81U3djMUs2?=
 =?utf-8?B?OE9icHVLMVhXTk9wUmJMK2RVM3ZWYzlFdnRBQk5jbnlBcm9oRm5seElYeEUx?=
 =?utf-8?B?LzVHMytIcWdqYzdMMFBnQ3ZmNEhJY2ZLTXlldWR2aE13cDVwL2RKN3N1eGtl?=
 =?utf-8?B?NUhwOUdaQWxuUmtXNHVZM05KN1RnaEhZWXQrdW9tOXdnc0hNcjkyeHJKdTVq?=
 =?utf-8?B?Y3BveXBUTllmV2N2TUtIdHFjTUo1S1NBRWJBNGRmMURjbTR2U09xRzNkY0tL?=
 =?utf-8?B?ZUpNQTJkbnpNM0VCdmlFQWRNcy9TYmpTQWJCRkUwUkhxYk1tNFBaL0UwWUVM?=
 =?utf-8?B?UEZWM3JyUmxJOGU0V29NYlVpeTJGTlhiM0x0U3lzaFBoSVlaaWVyNGVvWldO?=
 =?utf-8?B?S3VWQWMzbStJanJzVzJWNXE1aUFSK25EOTNHOXdWQXpSbFZVMkdsck4rWXl2?=
 =?utf-8?B?bGd0ZVY5bXlRbHlmUVlIWGUvVzNOTVJoSkFXRy95WnBkR2p0UGpMZDN2R1Bk?=
 =?utf-8?Q?eNbTA6BYnerHX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400017)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:22:12.7500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb824583-535a-49e6-f861-08dc7c05497c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8507

On Thu, 23 May 2024 15:13:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.8:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.8.11-rc1-g32c4e507b5b1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
