Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BBC20ADC9
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138806; cv=fail; b=iG1LAd91jyrn6XniulbLXodHbK9qW4wMRx9Sa5sT9PAbNfj095kAagByPD+TlDeeyUJtCBOpCo7eSJtGejuKs7zcGpoiOhAe9DkdrZgvq6El514go6S9oz6hr06E1gUF4MjFbU24oKj/8crDvxI7AxxX6vX/hpr1OsxbX4MiiD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138806; c=relaxed/simple;
	bh=rlNXY372e8zu204ZBRtu1reXpRe/eE8DmIKQzrkpIxs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=u83Ibu5NXCoysv6EyOlA/3KPWpqxzLnThTuOSHlBhHbCsUsGEUy336egWXD+0xyjAgDaEN35P6TNx/b4rAstSUPQiLsb7pId8vmAEuVI678G8ZNL6V+qnml6EUH745ods0meGyZZYXwS9nGC8dLxTnYOBlZSEVkVa2KNEnEWXEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=edGwVLxN; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="edGwVLxN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+4i1ax88p8WzBCD2eCP5TSwBTyycpQe7jN5vmVzaZyQe/5cLFTgsDUd9l9IldZlJ3jBPzK+cB2fBjPWgwM4qs5U9yGDYli2qRQ4TpnAzZXg5vOea59/+/Yu8tQ8yN8s8kCO5ha6+lk/Na4AVr8P85uz8tcF3wuVyxBP42zY0GRSRWsTPer2E2Jc9wFjTH0iOFOkQamvY30Qb3CJzV5ZpQ8T53uUNeL5Sm6cUF55TPiodGVHpOwBmYPCJp8vATZRXgdaWRqfrK8/uWw17autNqc0qMbcfyxZK2VPRglvmRZscin7EXdrtsJYXB0rSdwDSLqyO/ydZo4U6yYYeSrz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fldLxa342FidErEMj4OO8CxxnaozO4zkr+PH5wbOpU8=;
 b=WGb18khFffA6r/+Q1H7Iu1plF7mnokQ1Xs6yq20kF6gipBsUG8qYmSJhR3G62t5so3bj5OjqiJrg9ly+iSpQltJe7q2oo3B1o+unGQ+xZaEh93QApFM1cXTVGORzUPFUYjlYmSvoigv+HpcU5C9MNSiBWo4Nr4lCZBSzov3nXIjv173UwvTjd7HPjCBP/qjXKzJatBsTGUrREMLPCNLNw3qnXujnliBnnIhZDVLuV1Lj5ypCRaprgmDSY0/d2aoibiWLHCzoDRLn9BZKJseIBNk5AwEBIkR4dIEnDJpO6ZBw/W4kxXgQZZ/yI2tA70FlFhB747j86AxAWbj4yF+vkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fldLxa342FidErEMj4OO8CxxnaozO4zkr+PH5wbOpU8=;
 b=edGwVLxNIyTWTT+SPD8ksWNMkLTMZ8Crgj6Fiew4NtvBnQRefuWbdXwyvI+6CJrrSohsOTf0AtGFJ/XaWTX6tI9VhlLS9oj2anfFPoe3awZhR3HwF/BZbrU/De1iDAnACI33pvlva4WJmhObkj4GaN6ZkTz6XQLqm9z3/zsTXmTDAGJfeYiYaUXOrvQxjLdT1uz0mqgBj+990Nk06UG26YGoDvNWWciSung/2ouPI6KQiDRY0FcecrUeblWJm1H+S27L3EgamEDoqBp5eTJ9suvJif0wQtDwlHa9puaioE8tW4MlUpelxLMo45o6/RJ0MxUTQwjR32bpYIbvHKvUrQ==
Received: from BL1PR13CA0198.namprd13.prod.outlook.com (2603:10b6:208:2be::23)
 by IA1PR12MB8191.namprd12.prod.outlook.com (2603:10b6:208:3f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Fri, 21 Feb
 2025 11:53:15 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::47) by BL1PR13CA0198.outlook.office365.com
 (2603:10b6:208:2be::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Fri,
 21 Feb 2025 11:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Fri, 21 Feb 2025 11:53:15 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Feb
 2025 03:53:08 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Feb 2025 03:53:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Feb 2025 03:53:08 -0800
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
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
References: <20250220104545.805660879@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3dd1d827-3d26-4e93-bb35-1d2a6dfe9051@drhqmail201.nvidia.com>
Date: Fri, 21 Feb 2025 03:53:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|IA1PR12MB8191:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b747c16-bf7b-473e-de0d-08dd526e5362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3A0MlV6azRiYlhySmxMMkQwbVZZaU5VK3l4eksvL0IvMml5YW5VaXN5aW80?=
 =?utf-8?B?cm9XcnQ1UWp3N0NFRkhGRDcxS1VreXBVK1NOUW93czdKcUZtQWRsQlQ5OERW?=
 =?utf-8?B?ZWVuU2JaNWkyVlMvczkxZGU3MVpxSnFKODIrMUxsVEluQlBPR2ZNSkE0MWRV?=
 =?utf-8?B?NlM2bVVZZGZUQWEvQlRCa085aTNyeEtZNFJIcGtPRm1EaXl6Q2JNSm9XWnQw?=
 =?utf-8?B?Z0ZqZytBdkR1WVl3UE4wZDFIT3dDZGd3enl6U1hhNFpXdURXcnVwanBlektm?=
 =?utf-8?B?T0tiOVgzeVdQNHFPdEsyVFRIcmczcnZYNzg5djBnTnZJOTEzaXZWQmp1VjlS?=
 =?utf-8?B?QmU0UHVpdTExZHBHVzBiekgxT2NJSHNtYXErMmdmNUNtaCtBbkNRc0h3YVBl?=
 =?utf-8?B?WTZSTVpSVXdCTmREZER4c0NmckR4SFh2czdPTXRzeHlVYko2dXhKWUtJUVpW?=
 =?utf-8?B?S3lTZWxwSXM1czZzVllFWWNLSnpBZjlpZllGR1h5VExac1JldTFkRitiRFJ5?=
 =?utf-8?B?VmlISjVqVVVxd0IzbkVPaWdMbko2SW0rVDhBN3NMU2JQbS8yZTRRa01JV2tY?=
 =?utf-8?B?Y3NaOTZ0cWI3bEhJVlpxaHMwd0ppT2NxV2V4R0NBWnFKVElDR2phbno0QnRE?=
 =?utf-8?B?UkhzaFVWMXo3YWl3WlF4VFIyeGhwaTdFN3NYQ2dyK00rRjJZb3NaZm1SaTgv?=
 =?utf-8?B?WWhmT0ZhczZjSDBEc2YyWS9YSFo1UTAvQ1l3YlNyRlo5eDJvL2VjbXg1QU8z?=
 =?utf-8?B?OEFYWFV2U0o1M21jcFdJdDR5dkpUcm9MWEl5V1o4bXFxZ1V2MG9ZRzlYZ0hH?=
 =?utf-8?B?ZnpCdFRXdko1THFaaVhoeTIrOWRqUnVrR056am1yaU1HVHdhdHJvRVhnT2pF?=
 =?utf-8?B?TTVVQ3YrVUc1ZTZlU2Q2MExVNFdua2NiVDVMeEhtZjdzeFZFV3ZJQnJTOEJU?=
 =?utf-8?B?Y0MvMjhXUjdWek14Nm4yTHhzMVIrVytvV3U5anBucXFJdFVnbjBNamtZcU5E?=
 =?utf-8?B?Nkw0VXRadEZ4MlBQdCtqa2MyWmxWWUViQkJsbGFBTU43ZXdSWDljN1J5WURn?=
 =?utf-8?B?RXVaUEdlN0h0ZGUvWEpUdGQ4bXFIL25qWVZGdjhIYWlRRzRHRnBCbUl6b1dV?=
 =?utf-8?B?OUxuSjN6bW42cFg2cHNhUGJiMWNCZmlpVE5OZnBpMDkrTGhERUhZdlhqbmdz?=
 =?utf-8?B?OHJUcWxGam9yTlFiTGczTTZ3VU9UR3ZVbXQyYnJMQk92V3NyblJodGJSZU9r?=
 =?utf-8?B?TG1POGloQklTcDZxYmFrN3J2K2ZEVGc0bXVxc0J5SlVFdUZRM3ZHeEVVOUxs?=
 =?utf-8?B?TGIrUDNUWUh2cHY3NW9TVTJXaEhpY2dFL1RBUmx5cjJiS0JsV3F4SmR3Znov?=
 =?utf-8?B?eTVlbjZGdzR5RnhiWUxFV215SFBRcVUxNE5JNnFNS3V5cVhoVTl6QlFFZWVJ?=
 =?utf-8?B?YVpCQTJSRmhyN0RnenRiTFFjdkQ0RTNWVnkwWWp1aFRBWUJTNGNuRkJzRURR?=
 =?utf-8?B?cmg0WXhPS1JhdEVaRytadFNmSEdvOWhKb3FBd1ZFRG1ub1E5YXB4V0Exc0kw?=
 =?utf-8?B?TVhLQUhTWDVITEVhSGZKWVcxRXlkRkNXVTkxOG5TbUVxOTBlSXdDS041dXVS?=
 =?utf-8?B?d083ZHJFem1SdUtnajhkSnV4ODRmMGRTNnRFeGRiTThCWFFVdUhBK2YvTDh5?=
 =?utf-8?B?aDRyWFNsSmJDeDZUT0hySTYzMWxKVDNGaFdLdSs4YzEzSUZ4WXlyUFhLT1V6?=
 =?utf-8?B?MVhLdmNsb3htMG5VYmQ0eDhjdGNMYVpZV1dsUm9zV21Ia28zanMvTHVucW01?=
 =?utf-8?B?TzMxbGxGTUxGczZEV21kVUdxL3dHa3daMVhrdWxvTllWYm1aNkk4WDNBbUtq?=
 =?utf-8?B?VUsybUQvSEo0bDJla3RWSE5JQUdGSFBMSlVhWGdUa3NIdTJ5aCtVUGwyaDE3?=
 =?utf-8?B?OFVzNnBGMDgxbDNCWEVvMnNnYnliVXZpL2tvUmFMWnZNKzh4Y1pYUHp3YVFz?=
 =?utf-8?Q?AuVoVcP3tTsI9nG+YJk5Wo6vajQzCo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 11:53:15.3471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b747c16-bf7b-473e-de0d-08dd526e5362
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8191

On Thu, 20 Feb 2025 11:57:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc2.gz
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
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.129-rc2-gfdd3f50c8e3e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
