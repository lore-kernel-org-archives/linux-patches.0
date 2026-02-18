Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001E31A57B
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771403004; cv=fail; b=rdR6sVKjsqU0aLYRoCsq9sP3Kp+eWe7BKGbeQGU1URODzgl/XlCPHvJ1urzz61W7gMyAgueaVxX9j48pRPadwST1DAxMLnUzU5Hy8kxcyjVFO7jGii0ocqYocf9OHxMhb5M/jtul8Ia8zNqqVqqdlNm8jq3VGhrYIsIaEnalE7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771403004; c=relaxed/simple;
	bh=isO5zi/t7SJw2ULQ6RvVtuJ0v2RnCFCdDR4IhhF1lKY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=R57yLqiwyUkd6pzjYL8/y1niRnKhhAp/ekaJwDdS9Impzp6CYjWsUUDd3X0DP5PYqBHfp4ZRjsiMMbQOjcAyFZ2VCwyjSvglu1Oo9xrtxSSNRFBS1JpwzI+iUv37VWCm+CGZwd7sgSTuD7z8MdQNYu/PNNVjWKATFlgteYFhvh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SMrR/Ff1; arc=fail smtp.client-ip=40.93.194.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SMrR/Ff1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C1sSVGlBy/GBf/ausEWT+BjdMYFWcQWNW/vfzzYB7SOUG4225lWC5Uvmll4/M9FvzVbxo0dL3H0TRAHgczzk7ah66Jg1Od3cjNdRbfdpS6hJicRwlqcCUchqv3X/zTVATH4NOpPKMeGVQaKmJ/EK8Bf6FOIK3RlhBMEwDKwTxUR2OgHoOGBjv70dhTmMhYIEDW36jhPTYfJ0RFdRguyWR8wz+s/YEgrgfP7JG7xBk7IOjMWwH1tH9MHmnMMc7ZRiy09BI9/ffj0z1YawBtATfsSfIV3IOeGtVotcNhru5LJ0cJg4I9Wrt3e4wxiaIfn00HnQIapXKuZvBoAdofE47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/c2stLHNz720g5Csj5IrH8SjjKTFVuW3DOv47vIvEW0=;
 b=W6I56JkjLjVjuCpxm6dA+oDKg6a2PekbSy7OaM+G4v1lZ75yW2bz/rEnKim7KoV59IX6ACmPmxeCGArpO2tTHFy7VSWHRAZoxf+UkWa4Nuc0OPCE8tOJUXlrqIUjh3odTzZKoD0lK2GAC3ATO+BR8Sq4uVCq8kArudtsQZebg0Fz+Z9woNZaT2enzHNz9JJ3oZB9zdaK7Tnrze3S1lQZgNbgD+45I9ySAlTwi+15w3pGC3OYbQ8YwiSwwHCteMWaRmq1Lu4WOlm+CIZvJ5KlVnAE/oZH+jeQb2Y5/WH2e6wVdC5O0ofEzPL+nF4FnpuYHbrMFVn/Vxg+TOQ0X0WL4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/c2stLHNz720g5Csj5IrH8SjjKTFVuW3DOv47vIvEW0=;
 b=SMrR/Ff1BHtzF5ptJZ88kwT1PwfEgkDWmo9KgQdMwnvm+gN0d6H/KeCfsX1egQasYlSFNNa0/927+/K1gCtgfkCsTGk92EoGxCCsBb8/z/0MqYxoCyjtRYVIfmB2wpY4e4u29WxnR0/ciC17lR0mWuGEec5m1OFhQS9LVaL3/LQHJ5HSfwxSAkcOqf8xXwV1Uvj4JeeVSe3mK2g55EccStDeMaJsmJoRBxvYMx0pDPwYb/DZmT0g/ELVK9AnuB1Xfmnf0NhGL2TFsEs/1edeP5Jh7UaXNfOHJtLMo9I1nE6pooXK9nsr/Cml06a8Zt1i1kEIVDhn+m0JPvzLNstIEA==
Received: from BYAPR02CA0028.namprd02.prod.outlook.com (2603:10b6:a02:ee::41)
 by PH8PR12MB7134.namprd12.prod.outlook.com (2603:10b6:510:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 08:23:17 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a02:ee:cafe::8c) by BYAPR02CA0028.outlook.office365.com
 (2603:10b6:a02:ee::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Wed,
 18 Feb 2026 08:23:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:23:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:23:03 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:23:03 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:23:02 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6532d42a-a646-410e-a37b-f70b2d97b9af@rnnvmail204.nvidia.com>
Date: Wed, 18 Feb 2026 00:23:02 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|PH8PR12MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: c6ea0549-3b95-425c-7354-08de6ec6f7e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGxXYjl1dGlzRHZEUy9kV3F1VlNFd1ZjRi9qQk91UmwyU1dSL0ZGZk1UaUJZ?=
 =?utf-8?B?czlsZXZ5YUpKZXVUaWxVZDVWU1I4QklhaGVJc0k1NXVBSUMzdUZKZ1JSQVg5?=
 =?utf-8?B?NVYySW9sTUM5Rll6NHM2RDl5TnFoMVRjNHI1SGtSOE9MOHZYTWdscWM2ZHV4?=
 =?utf-8?B?R1lBRlBvSGFsWDZtdVZMNDZnaUVWTlU2R09lRjl1OHNzWGZLbGs1VmJFR0k3?=
 =?utf-8?B?eFNnTGNGalNRL283Lysyc2hCdy83RThCYTA4eHdXRzVmQmMyVVg1WkYrNWR3?=
 =?utf-8?B?Zjc1dzAyclUxK2hvSHk2QlNOa3k3TEJ0dWcyL3IzTkNaTEk0ak8wWm40QVpE?=
 =?utf-8?B?WmptMUNIZE5RNnBtRmZLMk10WHVta2FDa2NNd25xSW1ORlBhaUpFRHNWR2pN?=
 =?utf-8?B?VmE2WnJ6SWZPTXNRcUcxaWs1MVVkZ3MxVllCdFZURlJUZm5TWFlPR0RsNlVI?=
 =?utf-8?B?VVg4eDdKV3BwWEdyTThjZGhKLysraFVZWXgxM0ZPUUdhaVdJM3NXUlgvcld5?=
 =?utf-8?B?ZHVsSisrUnNNZ3hiK3RQR0JXQlFyYnRvRjhiaHY1dkVNNTN6RjJwYUZmaUZy?=
 =?utf-8?B?dDllSWltenppY2Zrc0UxSHYwMDlCVnRiVllhdXFzcXN4TGZvSEQydkFTekVH?=
 =?utf-8?B?QUw4bEFxRWt6Sk1scDFCQXRLTXJJMmZPa0JvU2JHRTN3VlRtUFRQYk9NTy9T?=
 =?utf-8?B?bjZPTWxUQnJJdzM5T2RETnk5N1hiTUFIYTBkRTNMMVlSK0VwbmhlN3lTcmNs?=
 =?utf-8?B?Mi9nSXlOS0dKS1FkbWdwcktWVkpmZHo3MU8wazI5VWZBY3ErZlpCRHUramhU?=
 =?utf-8?B?MDF1UTYrZ256cURoaTVGZ2lVdFJOZmY1dXRsdnYyL3lGeGNzQmd1aVhxZHoz?=
 =?utf-8?B?UzV0OU9sV05GYVhMSFhBRFkrLzRyNG1NRjlaOXpMMnc2WUk2U0ZLZUN2SWhk?=
 =?utf-8?B?QmkxTktJOGNORWdRU1VtWGRJaU1wT2QzcXNrWEl3WTF1a3k1OGtVSHRRUWZ5?=
 =?utf-8?B?Tk8wTm1kaWE4WWFFNnJpYmdMUFZPWUJEWGlzcDVlVmtJbUdnQ0FydVV4NmM0?=
 =?utf-8?B?VFlDSVA2c2xCb2Q1MklGYWxhbUJQL3M5T3FYMlFBN05SS3NQK0VPREVFWXVq?=
 =?utf-8?B?ZnZrbFIzQ0RMNW5KMUZnU0h3b1R4ejJZa3JjTXcySENUVUEzR3NCTGZjekt3?=
 =?utf-8?B?d2lSejgvVWJVUVN0REduU2g0eEJWUWNTUjBjZzI1TFZOZ3lQVXRSNHpVdURk?=
 =?utf-8?B?N011Z1BwOUVhRVNyV1d3RkhVc0owOVRIR2wyN0RVYUlaZFBmS1ZLQndkNEdS?=
 =?utf-8?B?TGwvUEZsU1BKcmcyVXdIcHV5cGg3MkM3eTI1TStudXNLdVZqakoxZmYyd1dG?=
 =?utf-8?B?bUFUQW5MZkF4MVllTHZHQVA1NXJTcmIvdDlWVi9CazBHTk00aTVRcVkwRWls?=
 =?utf-8?B?OVJVdDR0ZDR0bUJjVzRhQlVBMVBZLzhyTUJlbEZuekIyQitqd2NZZGtoM3Rk?=
 =?utf-8?B?TEo0SmMwRW1BNmZPdTlKemlaUHRJSWtYZ204MjBnVEFHamxIRWZIQWNoSG9l?=
 =?utf-8?B?VzUzWk95VTh0U3h4YUhDbWZBaEpsdzdUOUoxTUhkc3dya3pPUkg2YWxaa1VH?=
 =?utf-8?B?bGxJUUEzUTM1SGFQanJ0VHVST0s3VWRpN2h6V21EZkh2U3JXTFczS3NOZHRq?=
 =?utf-8?B?SzRLNkRnTkNXZkV3a3JJWGZaOXVLQWlKTEdhZVg5VXpCRU1jRjlLQ3pRUG1O?=
 =?utf-8?B?dWZsT0NOeWY2akdRRzJyK3ZqOTlrelZsdXp5RFNjMGpiTnNTMC9pSU9yajZh?=
 =?utf-8?B?KzlVRDY1N2xWUGhnSTlBT0tNTmRyS3hjZTQvRW53REhleUJTclAvaUZKb2g5?=
 =?utf-8?B?VVZuNGZJYTNOTWtHNW9HZmtlcjVDdGlQRHRIRUlVN0Q0Vm1LaHcxZ01yZDBP?=
 =?utf-8?B?VGZVTEhMczBXei84T2FDQWJLd1k4RjI4NlQ2VTR3WTJ1NDhGV2xCNFo1MEE0?=
 =?utf-8?B?ZEFXeEh0ZlB2ZkU0M05na1c5UW9zZmg1clVKSkVSb3hFOUJHU0E2MFdMSW1p?=
 =?utf-8?B?M09LQk8ydTNmWUIyVm9RdTRBNGJobXZEV1IvN29iYlVZOTMzMFJDUFhlVEhG?=
 =?utf-8?B?OXo0aFpkN1kreXR2RXVqb21lejEzK2FVYUVjTVhTQzNDVXg4Rmh0Z0IwVmhO?=
 =?utf-8?B?NE5aVCtxZmtLK0FqTURFdE5qZ2h4M1FUTUtibXpnWVJiNVk0c2ZVbEFpT1pt?=
 =?utf-8?B?SGtNWUQvaUZiVHNBZXhNSnpEdW1RPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n/d/eHWZdw55SjZ3S93gt1oNwMXDUEtLoTKs9bxIU3dKeaTNXmjgR78HHTxRlhTAI1ZRwSzv31yOv14IOKhI393K5TzPX6MCDh6L/CkeZcVUC8BeUn+9QQXuAm2JLolhoKFNZbxSUeMpdl+6llP8PmOx4bGwVkA+qER8F/NgEueqIks1hH1xofPIaR8w1GQ1Ah0sDBCiuodt9hh2JCdAizEw+DUzxOY6BBDpASRuqWNLK+vNN86qBuZAPh1+jUc4woZJNIgJ6hfFfX3ksvtYQ3zQhQWdNP50TInHIE99UbbrphooqbDrdOMqmy/qnjCMHzT8gJmlESnle4tdEHM+u8ASlwb2COocPQx2bnEfMA4DCeSdibD7J0l9YtlkOtybcYNpEIxRT3Iad52DUW/JANDJB6Ww7rLuJVmBbFoIbCEow4xoVwhL0EYUYMIraF71
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:23:17.3714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ea0549-3b95-425c-7354-08de6ec6f7e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7134

On Tue, 17 Feb 2026 21:31:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.18.13-rc1-gbfeb67747626
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
