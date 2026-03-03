Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011008.outbound.protection.outlook.com [52.101.62.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECB836E492
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547186; cv=fail; b=eAFHXkCBE3m6DRTh2RWpb/i1ywlHfg2MGmkAn1MWunojGiiwMxrQzjLiSFYUA3YMxq/Mo4B4dL4AtQ/hz0SoSZ1N4cDKvVoPiiQYExMjkJOy4NI+x5ll/eKt2ZTCXlyj9xl5GJ2r4JFisqe5usTrfwdaQDDaWaEGvuWzT+LF104=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547186; c=relaxed/simple;
	bh=UnZ+syPBQ0YqxH2Z5b4Hp5tW7nfsQubupsc4cLIdQp4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=UyTjNTzaV9EkQsoMEBVIeZU7qppyMuQx9lF8r2ZY8dKPQLuDtKkw4giCUqGQil6bGXywZK2/AriOVqtLXw2mIhjlpF1olYF2DSH1qSqHGtOAmtTymAVStTMhjFkH4DtXC8NSjkD8YcfPsD0jhjCutaYD69Qfx43LJ+PJyiS3Tfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K4DxBurx; arc=fail smtp.client-ip=52.101.62.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K4DxBurx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bbfm+9iPYB31u5Gt3qBdPmWtZRDULReZm/6ZZGIhXO0JXDW2rLKQsD6+n70IIBoPDCcmzrSO+gdB6WJGNmC6Z9hubORIfYu915reyyBrudJkNAv1eLvHXHUGh7Wq+kEgzRf+uwtEFuYW/CZMqq+Ilrccnjl1RqLPb10luHihTCig3KaBdO00q+VuFL1bD+HRtBckJoelO8nCFL9i5zfHt4dRE2GAcPeCSRajCPCFqXYrT9pbTo5iD8uIYb3mR4qGvA+PSpoGQ+/PhQocol9ae2aKxFTHKZdKEY6e0gFDAmrgPUIFTqZHET5FFU+6BffuUUPXeA0TVU5cynefIueHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHBVas+UrzYvbXXX5X5PhD2hgKIRQVtdUnxpGRGOJJo=;
 b=xzAai64QwOuHhj3TPKCHiNBkAYodG8YMJhivG3gpFcHb2j9twgYaqMFtsTE3Rhf7pV63iZKQEDgvM+XRkPv+ARIhW+Tfsfbtr7zx9Gs/7mA/FysT9j2uVRJUjqgFRKE8VuWPMqvBwH2wfpF/t+lQXiXaLCj71KyJfUr525Ky3bZ/tBxyC5NH5SYwGjMyO5X9AMvQscuHGTXXbFX3G5aWJIGrR6CRChpKlVsX8WcQTV3aeOfo25+eONnpho0L081EeKAhm7Uc3Mbz96Lai/aOFAn/PLy3mSyNQsT+pUVucuybI0nW/YOkZcJlcQ0pSiFKUFt368oO4gh/ITSKn2qJqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHBVas+UrzYvbXXX5X5PhD2hgKIRQVtdUnxpGRGOJJo=;
 b=K4DxBurxKliM9cwXLGU3MBpyJrvI/UR/wNhkE+DMOkhacm3lz3fEJk8qaWMxPWGZm5QjHJnEIjjDRGDczwadV6wEeCH3isAqo0WSuJmxXHnOqX+DrE8vdS4dhB2WNpMw2/aUNmueS17dQTJWIxG414SMtIq9kRARZpIJcl3ETIhNauqwV3tT/R2cRCdCDeDDMgdSWXs73mgGSB1A/Xc3EhfeG8zArOFfIzEyODQt96Dnve9ACA1o3zzn9j81DOhDMgdTPE5SFiebBBnundMA0tBoe7zgMMacybufoYTNGe5RmLQgV29W+tOryB/Hma0RsTWBm5ABS/2w8Ix7DcjPPg==
Received: from MN0P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::27)
 by LV3PR12MB9259.namprd12.prod.outlook.com (2603:10b6:408:1b0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:12:53 +0000
Received: from BL02EPF0001A0FA.namprd03.prod.outlook.com
 (2603:10b6:208:52a:cafe::7c) by MN0P221CA0009.outlook.office365.com
 (2603:10b6:208:52a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 14:12:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A0FA.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:29 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:29 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:28 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91bfc64a-e7f1-43f8-9a67-f515837b9ac0@rnnvmail205.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:28 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FA:EE_|LV3PR12MB9259:EE_
X-MS-Office365-Filtering-Correlation-Id: 31d2b539-514d-40a1-a722-08de792ef60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	2HeoBbNtz8a18mx/KPkIK+4OfRFoxcxvvzBeyIX9ev933fuOPlcfHh24hJs+9U6R747B0HJZ8qPopI5JXKU41s2zNAwNkovZeEC5yF1rQF7j794sAY29CfUDqfuqsdRaJJ2pE0i5+cggkZbj1ECDsM0TzTT2i4xuyDssnwMryNrPlIyKaUGhwqqMe1iY8gta00JMqE84AHMI5U4xi4nzOwNQ8JomCxSkgxpQVEttg1gcziIPqk10MkfuFCxk+ZXEa+vK3Jo0Ru3LDiuDd6iMyi+J4sHT0xIH/R+Q7wVB3azZNnYKwIM6Y6PRWn1h2rSB9CAjhTSwqjnAVYuFHb7TNN6r5wX2K0PTwe42R8kUe3wVS7BQqAXI1yiSHvrytvTrWH7KuG7DOtbzDUPY7hhx6Y/ruMlNCVBijhua5S86vhk7qhPjlDX4O2RkkdjKRRE5I2iHtOVoTT7Z+R1Pc3hnYVcdraxUOAkUa3CrHfSjiEpJSLEkTfy1/VE3LW+CbjlDJfmJo7FkerraOjDfKYOscifZR9IuCKAU6hop61IyXzWW1MACtIWmWJu1GewX/VGSBh16qcPPQ/06cbyBQp/Xa0SSkIWKuq7nZaLA9lKzVb9HdO61ahtWqNdNkTVMocCvEe5E6N1T8Fv959ndaQZeRtzARHJzXUYzt14YbLLj2XUD8QDlHcUGPB4AxYSXbN7blnSIZiCrze8P4WFYCr/e6mw4BzNZnFDS1laLkhl9kbZbasFzqBZdG0eD8qK8uqJ15jMNORx7z1Kh/jC+9cMZW1gj+qQ+4ziGViUxs/tdfPFu0SPkZWm/iVdZgXx66/yrPpsOail343ppwUOdm1x1Xw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hSvofUkCzD1ULMTx99FhV4KxzvFO2JiogW2SaUFsdTiKsZj28EJg7NVagmdtZh6f3J0y6pErxgn0PQGJZocuxQRVECX3kDZRcW8O9zWl7bbyPTTsZ2OzYrkBAx53O2jByPCOebmCe/nSDFrikVviSY8bYoplQs4l0UqtkgTgjA4XvyKqP3NGfk9yo6OLoRySfq7YeZ8oaqDHhLH6Rtvx3Aw6bRraL+bTAtqcfK5WxpBwOhHNmbSQ6lFJsVnWZp8cTXqQUM0cAT5bF9DQyvGITy+2sah4mi3832nS3GKo246pFAAlIbLKHaKV0FX6IjOS0UFHkHzIBOJG6iCoN2yYjNOQC1FN5zyYoFrzDcK+bW+b6SX1utDPAaMhREg4jUO2FWqqFgL9nWiYVfd9cFR2r6YIpNX2kKUpQOmzGFmjsi8DAnxwGCiBuviNLjtNjUGF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:53.4666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d2b539-514d-40a1-a722-08de792ef60a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9259

On Mon, 02 Mar 2026 11:09:18 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.12.75-rc2-g191be03a0d8a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
