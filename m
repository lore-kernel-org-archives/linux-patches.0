Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70741214204
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 10:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559646; cv=fail; b=fNsgkkqtq0oS30mtLi17u5p4OPqnQkn9ni/CuU3xVsImM1u2WF4JT+e993HQRr8tHLMuI0ImzXHt3g43/epmZil6Lrfe0lLsPzsDVyMnYUEgvw/XO0ceFByZgh95lH5D9/B/0X02nq5dPcwVs0/kDSivuGJBH3L7TkOuWVj+WOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559646; c=relaxed/simple;
	bh=psZc216AKqU2OZ8szHHeghVMXLbg0bmZNZ6UBx0f4MU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Xtx/wvkrFlT7aWuvjYtpnk1U/2xXqq++YEwWHuLfMqbzKYUleIOZ+EthD3M9JA0YegJ1E7iGpB7IRnNaI/m0Fr7xoKz8fDtBFyWUT9bwjJ3N7e/md4fu4qc+jiibjGY5Xnx03RmSjVD9e5BSnvc9ZwRpfAwQlO42DzSEFOJ9nyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Plw2hgv8; arc=fail smtp.client-ip=40.107.209.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Plw2hgv8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdoIPe65PDMGA1ngyXrUR69NahL1+/lYHFBf0DaLL3LCt9zbDciG+y2F6D2wicbj1xwBphDihVkuwUiAnjX5Vb0sfS0EreqQh+GkdtG+boTzQBJk1+qAExzTuVt6yUzeh9HFeh6clquw61WdOVjMkHBLwJffzGk916M3gfIE2AO5EJFAC1Q5RYbfCsrX0M3App1xJ/+nMoZWljyRhBg1LFj/KpVFd5r0GusiwL2KHcn6efbBppMGX95NcfP2+YH8+CvQl49JYQVDoTJR91djrDoJQnBpwkBBQYKobJaKLw5aLFlVQkX0F9tKkXwG5UwLsTO4Wf2SSQS4TyEm2Ou0ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysHymHetisfDYFL5CvFEgWIFH2SJzWEfcGaV/ZginBU=;
 b=n/ttAiC+J5waMdCIPtZsOGNUcckX5M0vcB0LecQMxsfJXcs6UUqls7LhYBykA5yJ1/LzEsJgLTzbiinMkyucCDb1Nz9vYQ0tGIEApOsmC4zQ0ZqJF+MRgQMl65XzN8PVY1RFJAnrqCUMPFr9BOtrZ1Hs3ntaaBnbhHbYJQepGxtkdpyGygF/Ffj6P4CVIsCR2hATtHU+au0Bi9q1m5vKAeHD0MOlhnb4RCzf8LQOnAlfRuZszoTBp/B/rTyjomZushVIn7Ij97EAKuKyDM9Ao3iCRuaaC86xXwyWByTFR8aSq2HeGxDONKgpsgUcvnEF5M26a6rZMzfd0/9nQNiI8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysHymHetisfDYFL5CvFEgWIFH2SJzWEfcGaV/ZginBU=;
 b=Plw2hgv8GroWHHBY/Az/jBxTUv/43fnemPrbVvzSY+hO+hqSo2mGJmoA4q3uNyW4Zl7v0BH/xLuVfrLIOl7zAzNOIbTeTJSs6uF6X9XJNx5Ykp4eDxiZ1b8cHH+JPHlA84ttxS/GTqjumYnyDvjOwpFOdOCHJ4yJeNxQTd90Tl+YHZuLMygiXYvQ+yebsK+6+pgu2v4dgTGaHPGp8Kj8f8IhZqQNJFD397MQTo2kLTrmutfjE2YmkLJD00uCWi9mHOKL7/RpIZYaHAdozxW+mNQQ5qrT6q8JWV4Q+7k5ZGU6c7Yzuz2ge6izCigdThuibpcnsQBnTGkhv4K0SZ9+dg==
Received: from BYAPR02CA0041.namprd02.prod.outlook.com (2603:10b6:a03:54::18)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:34:01 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::45) by BYAPR02CA0041.outlook.office365.com
 (2603:10b6:a03:54::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 10:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 10:34:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:43 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:43 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 02:33:42 -0800
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
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9917fa19-cb51-4321-a6ac-471a08698196@rnnvmail201.nvidia.com>
Date: Fri, 16 Jan 2026 02:33:42 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|MW4PR12MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 07350b83-313f-44e5-8d51-08de54eac3bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amsyN0tTQysyVERpNDZma29hKzhtZjZnWFhiYzVUdDduTFJoN2c2MFBrdHFO?=
 =?utf-8?B?MVFLVXpIV09MaVNvRTNCdm55bUkySFBudnZieTNweFdXWmt6VnlMZFg5VlNN?=
 =?utf-8?B?WHFoM0VDc0x5amwwcDhXQkFzN2ZZaTZEZWtTK0tERmNwNTI0WkQ3b1UwcjIy?=
 =?utf-8?B?STRqb2RVZE5KalBzRkZvOFRyRkc5YkpwRE9Ma3I1N2QyTkVDUCtMN2VZL2VC?=
 =?utf-8?B?eHFoMXNKVTUwMlNiN0ErbWY5QkdzNHA3YVpSSUJ5dllNY2JRckRNd25aczRn?=
 =?utf-8?B?b1JPMGtsWjg1TERNdU5jaE1kTWVNZndCa1M5SFBCS3c5NGFOTmNnQmp6ZHJ5?=
 =?utf-8?B?WEdaSkM0cUhUVXdzMVFMaFZRcjBaTGExZHpLejh1T282VVVVdDIwSkYwQ1pS?=
 =?utf-8?B?akVFYjBjZEdWenJhZWNRSmZTbkwwMkJmaEE4QXY0M1BrWENRUnc1bDB1RkJt?=
 =?utf-8?B?bTJLTzlUakFPWCtLdjFvVzdZV2NOVkR2U3JHbml5a0p5RXZFSVhyV29JMEky?=
 =?utf-8?B?cmo4SHphR0liaEFtVGMvUnlKVi9BUk9zQ3llS3ZKeXlyNjh1QTZwUENGcjc2?=
 =?utf-8?B?Z2xXMk43aVVEZ2ZDTWxGTkNDTlVHeXNvcWduRWNUVFVQM09zelRYaEo0ems0?=
 =?utf-8?B?bEZsTStobDZERjVTQzNvRW16c1VFR0hOcHJyd1JGdk9QZ1V6Z3VQMUY1Zytp?=
 =?utf-8?B?Nm1hazUxZTU3b3BzSHdZdnRMVmg5WExhUDZTT0hiNm9MMEJPVFZrRXB2RkJG?=
 =?utf-8?B?TllMbCszak1wWVZVZ1pjMzRHc0kySlJvM3B6YStBTGJFQUNFT3NnT1lwbG5h?=
 =?utf-8?B?QTE4Y05vSVJLYzBaZkx6YWRtVURwZk85Qm1NNFE0aDR1Z1ltSDFMNGczckpZ?=
 =?utf-8?B?UEQybjhIblVJQjhCUmppNDB2SXE2YWlncWJ0a1crYktDUkZFYkFzcmN2Rkhl?=
 =?utf-8?B?cDdBdDl0OUM0cHZUK2t0ZmQ0cUFCbDAxMkNOWVNOUU9IN2NxNFJma3Nic3Bx?=
 =?utf-8?B?blVaQzkvNDNMS0Q5eExNRFBJUVV5eWpXM3p4eDdSdjAydmZCM3BsWmVyeVly?=
 =?utf-8?B?V3IyRW5BL0YxcWEzL1lGVjAwanVIZCs3a0RJa1RXOWxrbnV1SDJZZHhiMllr?=
 =?utf-8?B?Z0M2V3pGWFVuWVEzT1BjaHZ4OVZYaU5IMEgyZmVDeDZnQXVLeXd6YTFLdFpS?=
 =?utf-8?B?YWs4Zy9qU2pzenBpelZucnR5VGFqTHZMMHNXWWNEVlUwMm9waUw5YnpsYjlr?=
 =?utf-8?B?cDFIYzlKN1o2bS9GL0IwV3JsaDhpSGNuTnc2NEliWEhWdHNTSHFDanp2UGRW?=
 =?utf-8?B?YUhZVm40V1lVOTFsTFBOMzM3RnREdG5jRk8yY1NEWFYwd1VNYlpxRDc5eUQw?=
 =?utf-8?B?U2VrMURBRVV5bUxGbFdYWXVyTUovYnVSY0dUd0xyQW94QkJGY1ZNb3pRZU9t?=
 =?utf-8?B?cWZ6NlBxdnkxRCtKTkR1Smg3blNMbjE4bnFlYjlpRy9KemlVYUVLWXZpV1RO?=
 =?utf-8?B?VHpJbkhQV2V5bThiS0NheG81RzdISU5RN3Y5TUcybHNMZWdsOEluazJ2UG5m?=
 =?utf-8?B?SkZTTFBoTjYzK3VwdENwQ3YyQjc5WWJmUjNUd0FrOFRja2JpSURzOWxqWUo1?=
 =?utf-8?B?ZCs3b1kyZW9JTCsxYmQyUUJFOEIzc01NM0gvdUJBQkxYczNqSVZFWnkwS21t?=
 =?utf-8?B?UnBZeEgxc1JsVXU5Mk52dkQ3M0FmQUdWRW5Pdy9TdHFMV0lCVy9meTRjVmdr?=
 =?utf-8?B?cUpCeHlTYkE1MFlIZExhNXBpYWUrUDJkRnV1TWhqWGxYaGtJUDFxUTRkaVVV?=
 =?utf-8?B?YzcwMUhtZlkzMDJ5OHZSVHNyOE1IQjg2eThtcTNRTmh2RkpwL2RHSEQxSTZO?=
 =?utf-8?B?NmZYNmRPcUpJL3RxTjh6QzM1aG14eFVvdVd0VEhKaitEU3BkK20ySFhlTkg5?=
 =?utf-8?B?RS9BS3pkelZXSmFWSzZBMkZtcXNheDRGSCtNUFlXQWk5QmdVYjY1UUw5Tmgr?=
 =?utf-8?B?dEtFcDd2Qm1tVmNjcms3anpVa2ZnUmdIMGE5UElVdE82eWlhRld3U054WGxC?=
 =?utf-8?B?Mkt1M0lvNGJPUytqV3hiTTVtbThnSiszWkRHNjVWbU5oMjJvRURhaTloNHV1?=
 =?utf-8?B?U3EzWTVBdDdaMUQxaU9tenFKUTlBSm1DN1d1NkQyRGt2V3RMSkh1akRGR1RN?=
 =?utf-8?B?R2l6U1U4SWNFT3BnSjlPSm9lOGZ4MGFnM2Qrclh3N0FzV3RmRmtCeFI0bVBw?=
 =?utf-8?B?ZTVRd2pMRWZGMEh5S1I2cTJ4cGpBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:34:01.5194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07350b83-313f-44e5-8d51-08de54eac3bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603

On Thu, 15 Jan 2026 17:46:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.66-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.12.66-rc1-g4c3a44fdb97c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
