Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778D299951
	for <patches@lists.linux.dev>; Mon, 12 May 2025 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083423; cv=fail; b=bWEzfz66N6BlOXcaG9dv6VGyz5XGO+285+Q5AC53rllyl5+Bg4HIphAecyacdx2YPUb9oqwidEfgIS8mCV32w0b1neGrnkglX9G9UBfqsGFh5ik4FIvKGTtuP3KaOdkgDwVhbicWPuiadoY90AfkA/YXg/M0Gy4iSpbXz6NzeJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083423; c=relaxed/simple;
	bh=k+FlX293KGJ20DMJXoVCAEbq1mPe1LEtiyRTMbXJfY4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JFo1rRhIaHH7QhnR3gHdGBlZG9mn/gqjlFY0NHFFzgNWMgbhqX3Na+oL85nONLXn+5Yt7TOfVDGehbsMgyYMzeRe4wpOAcOSgQ+RHcHX5nQwx7SSgb0itugHOt84K9NiAnVViP7KPsuayD9IPDxrj0k820hFPLhKOGr2d7bAZNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qGXFpo99; arc=fail smtp.client-ip=40.107.212.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qGXFpo99"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wg081BK+dnXjkqqPVGN6PnfBZ1zZ25JOMNwngHhKvRs4pYlFClOhaMVf5JsjjoMgMvA6jFJpJtSzWDS9T8/UnDTcpWXkZg5E8wUxqxsGMsMrL1KUaGzJHmUyXwZ6XSftSH54hPVmxBUewxDGeF4eHTAGz6ueCpLiPKUUv+PDTWiHZrLVPQiOG3NE6bKIlUQJVLAvXK65AuBLJ/v4opacLmqGZHBIkLVi4PxEfIymuw8ZFaufeJOsZHPeRBgaEuLCESIJWcwDCkciI21ajMhHFYMbHOSG9DUH7wZ06V91GQrIJgUpBxVVRX3mMn6FwWBNLOLVawQh6/Fd/aY+rmbsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8klr1wcXQD2mO5IeSrve5/xSAHa7alGIzeCpRcXV2z0=;
 b=A7vu2nM40+zQ5HcDIJYXU9d703EJzjH2ps4sPXWaR2EyHuMNCDdEJQYAkxfdixtgg1EMXE6GFL+drdspwhMlLR7eG6tiTpWjfC5d/CIDY8OO4MhKa+K32n9sZ47LR/lAAdy2YBUu9NElZwAiDa+DTt9+my8sp4tjFvOOc5Pz/ReMjw+7n3dFk6/nXX1Z1fbDg9relVexjySUAkzgHM3HAFW9UZvSza4Eagz49nw8s36nji+afAwFeA54/s+zVnMYRXqvkIA0kkBWRQrYLYn+ercaq7P+nfpzRpWOFSCB52OemBo/+SHlCuuyTLlMAigdZa215hH6w+hpXM+raRvJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=temperror action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8klr1wcXQD2mO5IeSrve5/xSAHa7alGIzeCpRcXV2z0=;
 b=qGXFpo9923moRldvfmFGpV3jhFcXcrPDICzuTgACxhh9cTiR9nyQYaO/kCak4ZObaMNw3TPQY9yyifPt2hJOKm6BP7K44XR436oxEXzyu6xk05rhaDlegTsHJOL1jX10cXxvsUwFvG6jOsWfRW3eTUztqmfMe/Jg56wZzpE9vhDfYKjQoQCcyZ4HM3VZPxLjIL9ZPVYUhze9bKeSewGni4jzMrS13fj710LoFdB+Qg5Tf3TK3ZgLAgeSSic/WuG5AumIoNXVTUshIqXqQwIBOHWlfkpZiHiUE7DVU9ob49r0K03RMcWX27ZHSs38ljF3zNdhXgrkhJslISipsyXIxA==
Received: from PH5P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::10)
 by MW5PR12MB5649.namprd12.prod.outlook.com (2603:10b6:303:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Mon, 12 May
 2025 20:56:58 +0000
Received: from BY1PEPF0001AE1D.namprd04.prod.outlook.com
 (2603:10b6:510:34a:cafe::9f) by PH5P220CA0013.outlook.office365.com
 (2603:10b6:510:34a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.30 via Frontend Transport; Mon,
 12 May 2025 20:56:57 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.118.233) by
 BY1PEPF0001AE1D.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Mon, 12 May 2025 20:56:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 12 May
 2025 13:56:46 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 13:56:46 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 12 May 2025 13:56:46 -0700
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
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6560ae9e-1802-4929-9a7d-a03eef3a76ed@drhqmail203.nvidia.com>
Date: Mon, 12 May 2025 13:56:46 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE1D:EE_|MW5PR12MB5649:EE_
X-MS-Office365-Filtering-Correlation-Id: 94063f60-7087-4c5c-1b83-08dd919787c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGZOdUVPd2pFNDVsdlhsbUVPNVFlajBlM3kwVkpGdzQ1d1QxbzNITTdzTXNz?=
 =?utf-8?B?NWNTdFBGMHc0SVF1Z0xHOFpwU3N2N2RpbVcvaFFCeTVnVXZWRUhZQnlCSXR1?=
 =?utf-8?B?WnExZC9adEpIY1VET3QxU3RUV2E4MFdMblk2bUZ3bFVOM3UyaEtDYWNHaGhL?=
 =?utf-8?B?NjM0L0dlc3RUMTkyQ1lISm80TlNDQTBSeUlaWHdWWmpVZlI4ZmJoR0RhVXBP?=
 =?utf-8?B?UWZWQWZkcFZRalNUODBVa2tCd3l6bHVPUkpkYmw3b2xHVTlydEh6L3NnQ0VB?=
 =?utf-8?B?Q0dzMlFXa2JHeFphZXRtenBibVQ1Ymhzekd0OTdwZEJ1dVVPTkJiRkNmNnlD?=
 =?utf-8?B?LzZuNnArZndneFIvbnU1Rng3UFpFSFNqWlJoNXJGcllxdlhqRnZVZk90bDZF?=
 =?utf-8?B?dkxDYzBqanlpQ2JEMEJTeDk5bnNjdHpKOGphb2VJbEFzMXdKQ0FZbXVNY2d3?=
 =?utf-8?B?dnBBekV1YXlhL3A4V3liVWxIUTYxNGtlZ25EL1VTdkJ1MTZBWDVqVVNPNVJO?=
 =?utf-8?B?eUk2Y1loeW1sRDg5Y1RFWmJPREU1MyszZS95OGZJSnpGZ0pydEFOWU0xczFD?=
 =?utf-8?B?WElkdmV4UVpZdFJGME45b1Y1OCtVQjRLVGZBc1ViSTcva3c4TGlGTnArY3pS?=
 =?utf-8?B?dUJnd3ZsUmVnc0g5VTc4NFRNSENnNGZINVRSZGlLMTlVbWoyYXYrc2ppTDFV?=
 =?utf-8?B?d2Z5a0ZEMHg3TnNtWVMwekJTVHg3NlY4Q0lKVnIxUjVreWpVTFUwejZLU3p2?=
 =?utf-8?B?TDJqVnJDWjhwci9iOGY2RkNYNnd1a0crWG84d1A2ZGhUaEtXbDJNVHFxdmlF?=
 =?utf-8?B?dWV1YzJYSHU1b1pUNTdzQlE0cTE5SkRVaW5MdWdwWm81K3E4Z3FTdW1mQzZI?=
 =?utf-8?B?RUhidTNpeXdnUndJZUE3VVQvNGJ5Q2tKU3d3c0Yyak5URHlmNG9JQXQ0M0Ev?=
 =?utf-8?B?WXVmNmxPRWFQTjhCTnNLSWZUYlVoSzVMejhLcGFsYXk0emlqTFZoZ2swRGQz?=
 =?utf-8?B?U1ZGdXN4cGRha1UwZU5FU21lVHloSk1EOFNFN0hYSjNDOExob1Z2M0FwUEho?=
 =?utf-8?B?aDNIcDB1eW1oNlM2WUpqOWVhNVZCQkxCZVlqT3RUN2FjNkROQW1DVXFmNkl4?=
 =?utf-8?B?UEZROVhYajJ3S0JvK3ZuWEE0YTJJZzZtcmQrNHgvY2hDZmNydFBBTzYyV3RC?=
 =?utf-8?B?S0cxa3JKVE1OZnZIdVdyK2RIODlkZTlWN0xyV2ZZeHMxclNPMHVhZlFjQWhr?=
 =?utf-8?B?RFdYRG80aDhmb1JpYkZDY1pBdnpTSUNxbnltbVpOa2d2clNMQmlZSyt6dEpJ?=
 =?utf-8?B?Yk1mejE0U2lOUWNjYlNUNzk0alNyU3A1YTl5Z3RLbU1TYXVRZ2NsYWsyVXB2?=
 =?utf-8?B?RTNJYnI2WUVBdHJUN1NScTJiWm1kV25UMStEVUl2c0xkdjBZd2ZzQmVaMXVt?=
 =?utf-8?B?cTRsdHE0UG5ZaE5sd2c3S0hDdW9Ib3cwQ2UrRmZlMDBBbGxSdEtod1hwb3V6?=
 =?utf-8?B?S2FSTm5JNEczN1N4YWtmSk1RUVc3T1FianQ1dCszUTVzYlVlelVnaHp3K2Nl?=
 =?utf-8?B?Q1UvcUsvTEJMemxWWEdLU2Q2dEViNnMwZVV4ZUtyKzZ2ZnBOdk1ER1ZncVhU?=
 =?utf-8?B?cUZpemdOUStzaVJYclQyOC9pOTQyaC9HRUhhRVJBVnVUY1NEd2c4dytJSTFx?=
 =?utf-8?B?bGROQVRzM1ZIcDh1SzRLVE5XY0NPeEZILzJ1Q3pkRWoxejExVm1ndEdCUGZZ?=
 =?utf-8?B?UXo1b0kwaGFNUmozaGxHWU53T0NwZ2t5dDNYY1QvaDk2WHA5RDNmdHp4ZHBw?=
 =?utf-8?B?Q3VHL0tSZ0dENWs1RE5ocE1rUnpNU2NPQklTR1pNUEhDL0dSZjUzcXVPUHBk?=
 =?utf-8?B?Q3NVV2JrUENvbm80eFdHUEg5ZmIxZWxIQ1A4NjFKdUszSGdlVzIvaUlCNHE3?=
 =?utf-8?B?dVVHUy9ram9OVjQ0UTI3bjdkdVpNRGdVWjR6ZlB3Q05HT0dqWkZ4djNvUXIv?=
 =?utf-8?B?WHo0cldXWnFSTi92T3AvT2ZrTkhpaHB5bUlLeTlPK3R3dkx3VDkzUkVsQnhv?=
 =?utf-8?B?Q2xmR1hWL0VuUkI3amN4S2lWeGF6SWRIV1A3Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 20:56:55.9760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94063f60-7087-4c5c-1b83-08dd919787c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE1D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5649

On Mon, 12 May 2025 19:44:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.91-rc1-gbb031f5ca8bd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
