Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE817C6C
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 09:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717750964; cv=fail; b=O61u+GO7QFZR8uhOd4q8nifX1K1+HFb6zJEMFszXKdCtEgAoQ43s2RhVihKiaEX2/aPvx5RC4clo3ZMe5koBrun5GClLH0oU/I3d36cbPLvU596xoMC6wpmmt9wXac+yzkj3twg6jB8JSF7vzwSel1arvjWRxIIHkC9W81G/UvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717750964; c=relaxed/simple;
	bh=0eP1vqwIzuTrLuACZFsabIIJvHvytzDKotmaUrAt03Y=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=djf0KP4+ZrucG34Mvd7FX3DVt3EJ/4StyPwuG4eNKC7XKwGNNaWegSQwwyxIo0wyeZlRzCutbr6MZs/l8ZEYbB+K0UJ5HrLrPmmRTMjKCFlwk+GwC8FLUGYJ81NgpsAF/UhHzMElZjgNt1xAI1Hu5NewXCDm5NaWwuexPBQuKx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UWzn9Uqe; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UWzn9Uqe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nS2X+HyAeNf3RzS8kp9QyiDcaCe1eFzG9EV0ulVyHMRH8IhoDfcT1GkL7unsXO6tGzLIFM81V2TPMCdw5GWjGvGnB+DW/YckHY3KJsf0WmwuWWF0TT4EWuE1CLfPAaa6zbzMDA32o0Y6KI7tVzcMik1yamWb/63lDEDVUGKxqPJ7F7cYZqWimItA9byWAEE6Js7e3FtShNtBHVcZ5McyojTFCiZztl38oO7RUuThKgp2Ml/mT4UVaze5YBXb4LJpMMw5sQYTdpgFIMhddpPuKK2QxPPy1vYqe1j9tJQzG3jf4C6s6vGs4oTKYuTje49N1cgzCpPgFk4tzL/M+HGcQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vqf3N90TSuxVMG/YpssE18ySkNEa7rE8aIMa4Q+LDc=;
 b=RBUODbi9i0DfO8JGrcTGDpT0Thx3N0Ox3taMjGAPyuXveXD9YDGyxSqJNtATfHXmFtL2FynWej54A6rqQe4+2ugp3K8f3mQ52DZBfNjcrbitLpJ2lurVAI4wEsKjI3jb2p2Kck86UI08cIhHwEKOXweRrCyQt+2kLFLd00FV6OHDlkOVi+GEky427CFYvlnBeAUip+y6OXwYKyzVNMbjHrAawVie59XUgXpZqR+VctjTZzYng6ADT0KNFixwZCKzTsU5JYxpnRtUoZD7wjTVl/M/guWTfKZT3iTtfVtmk0inpCLu7mJfVVcmVxtCS+WsKOr8SxCZFC98Geq1J7KkCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vqf3N90TSuxVMG/YpssE18ySkNEa7rE8aIMa4Q+LDc=;
 b=UWzn9Uqe+Sm5dh3Yzfm8dTIqRTu+KFCUWnudlWsDEVFKJf5cmLYgve+E0Gc3V7C8FLe+8WTk7JkvGFM5p0RX8QVdTpe2lsGqZVbfSy37dSshtwV65LWKSHLbOF/qF2QiNTTu/AC0PfK+xqpXU/A8Yn+RlHE8QOZlcshkVQnUKETlr2klI5J18kz1N/kpa7Rej3k+xyD5Jd36s6xgu1gXh8MuFmjnOmmjyAKrGmBy60TI3gBh4/xijM7W142JDOe4/LJ7jEvue41ZGDUl9qfaSMbxQO6qir+JH6tSxgCkvZqwpbafVGWcefjfZdSlPrV6dMg8tVqPR0622ZsXET8IhQ==
Received: from BYAPR05CA0043.namprd05.prod.outlook.com (2603:10b6:a03:74::20)
 by IA0PR12MB7626.namprd12.prod.outlook.com (2603:10b6:208:438::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.35; Fri, 7 Jun
 2024 09:02:39 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:74:cafe::90) by BYAPR05CA0043.outlook.office365.com
 (2603:10b6:a03:74::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.13 via Frontend
 Transport; Fri, 7 Jun 2024 09:02:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Fri, 7 Jun 2024 09:02:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Jun 2024
 02:02:24 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Jun 2024
 02:02:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 7 Jun 2024 02:02:23 -0700
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
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <58e78214-735a-44e9-8e2d-589e63627b3c@rnnvmail202.nvidia.com>
Date: Fri, 7 Jun 2024 02:02:23 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|IA0PR12MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: 329cd8bc-3340-4016-6303-08dc86d094e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0F0ZmRMOEZ1a2x0WGpxQ3VVNEdJbTJ4K1FtQllNSXBvSmZTeWZZYmVDaVBw?=
 =?utf-8?B?OGl2TnlxOHVDUzNDMVZIaUYwL1k3U09hTlJKL0JJNTJ0M1BKSlZjUTlaOVcw?=
 =?utf-8?B?L3hJVFI1Y1RBQktnRVoxdng5dnJiZm1UV1Y1dXhUT1ZaS280Mm5NTGlEOUM5?=
 =?utf-8?B?K0ZTVisrN2p6ZUpIdFNEREd3dERhOUJyS01odGxTQ1hucW52T1E0dVdDS3Bx?=
 =?utf-8?B?ZTBoMzk2d3FxcXNjWGpkQ1FaQnVDcWhiK1pjQUlmSmcxSDVnMytRWVlZeFp1?=
 =?utf-8?B?LzY4UWl3L3V3MG5DQkt5VXVmZUVsNXk1UWk3WXpUT2NaZlBIbU1LcE5FdkVB?=
 =?utf-8?B?dVAzbC9kQjRvaW1tc0F1ZlRPQk1jMW5qR1lMdnZwbGhmMkhJOVJkNFhSQ0dC?=
 =?utf-8?B?blU5Z1NZK1lrTy9aZUNjeTlsMVJyZEQxT0treTZxOXB4aVdXbnFYbEErL0p4?=
 =?utf-8?B?cE1zNzBYQVZIUG15Nml6TS81Y1FDMHRZMmRGTDBocm1jOWF0WXJBYVdIWkdY?=
 =?utf-8?B?czl6Y0JORS84ZWFpZGJWWjJUSXBmUklWd3ZkOURUUlROZS9ub3dIQWxabW1K?=
 =?utf-8?B?dnp4dWdyelhmWFVQek1GV2NYWE5ZbUlvL3BzVURXUnAxTVZsbWJzaG5ja01Y?=
 =?utf-8?B?Y0hJc0xISnFUU1J6UXpwdTJrd3c1dkVkSC91M1dCcmhiTzJrQUNKNmkrYnZi?=
 =?utf-8?B?R0l4eEhpb0QwOWdoaVNEamxCelJZeDk4MzJDbmxwSzRjYU5FdjJIKzdRK2lt?=
 =?utf-8?B?Rng4Q1FTRk9iUzZ1Yzk1a3dTS0I5MHUxRzNycW9SWENnU1VIWnRrY2xIdTA3?=
 =?utf-8?B?dHEzbjJkNy9GS0pHUVo0eU85czIyc01ZSzBLeXZvOUVPTG9BYW44Qzk2ZHZC?=
 =?utf-8?B?RzdkQmpuc2dSTkFCR0JJaUpUTzQ3RUgyZnBmdFEzNFFWLzFHaGhjNHh5WXNF?=
 =?utf-8?B?MHR6QlBVeHg2QWE2WmxrVWE5bDlxcFRIWWcxSEx2dmt3dzl1TW95UDBNQytv?=
 =?utf-8?B?SnU1T1lBM3RrRUptYUVkcWpjYW05U1pWYldlNVZTOTZNd3pZUUpqNEczMTVo?=
 =?utf-8?B?R294Mk1DSzRaY2hGMnJHUW5TdHR1VUNHcVF1OGxoeHZjOTRXRlkxSnpJMmQx?=
 =?utf-8?B?eGRVcThPQjhqZVUrRmJha1p3d01hMG45UUJFcTFCcEdMa3NhZ01KM25ZdmdU?=
 =?utf-8?B?VnFYSStaODFqZzQzVnhsOG9uOU9VckswNGpJeC9oZjZGTjFucnRQczAraCtq?=
 =?utf-8?B?ZU9veXAwbHZxS3hPOUxRaTN0WkNYdWtVdHpBS2FjNnZEa1Ewb3pzcHZTYlNh?=
 =?utf-8?B?b3BIUDdHd1NSWFA2emQ1RlRmOUZPdTBtQVVDWWtzTHkrQklham9majNSZHhp?=
 =?utf-8?B?bW5YL3R2WmYzZGJjeFNMbnlXVXZMVUdHLzR3a01ZTEpNTWw3S3JQV2R1Vmgy?=
 =?utf-8?B?bnVTbks0NVRzaEdIU2Q1NnpLbUtoZHUyazVsSUNlU0xWRDF1V0JBMEJ2QXlO?=
 =?utf-8?B?QVlKVDlIbUtZa1RTbTBWdWw0YkRxdml4REtUMEdrMHNxaVVwZ2tUSVltUjU3?=
 =?utf-8?B?cUIxVTkybllOYlNOazJWWXZSRGpkZ01uYkFESkZ0TGRycW5UckNwNnkwbitB?=
 =?utf-8?B?eFNOSmFRNC92VnJ5RlgrREVoUjl5ZjZ3b2szanJVK3d4ZEJWT2had3g1OFhB?=
 =?utf-8?B?K2xBamx6YUdJWlNDVDRUV0JFTDVHZ2lOOVZZL3J6VG8wN1YyTklNTXIzbzJN?=
 =?utf-8?B?WnRPYzRON1NCY3U2RENXdnZzdlRiVDJvN2gvUUpXd2VVT3Q3cEcwQVdYem5h?=
 =?utf-8?B?KzhZSklrODdrM1RILzYrSURsOFdyVTV1emdYaUphcEsxa1l2d241aDdyZ21Z?=
 =?utf-8?B?cmRRLzUrMDJqVzhkZ3JSR0hzcTd1TTYwc2h6STFlekJmalE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(7416005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 09:02:38.8548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 329cd8bc-3340-4016-6303-08dc86d094e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7626

On Thu, 06 Jun 2024 15:59:39 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.4-rc1-gfcbdac56b0ae
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
