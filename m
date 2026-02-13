Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011048.outbound.protection.outlook.com [52.101.62.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB2828DB46
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010489; cv=fail; b=jAE9u12Q+pzi6euYLLC+7/uQgKy7+33hQ7jydMCD2sQfbvtmbsXY41SY6NFU/wpzxvqunwqlbJmVq2vYKHmHNiPlKEuEz4VlonAC+qkyKy1crwqMRhBFnMIaJigRo594kxPy2cvf3qwA4x14rac9rmF5CS81+lhIkbxIHTqCLA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010489; c=relaxed/simple;
	bh=koC2ozhgJrHazuA5ZmZ9AhkeM6jTA7ETovA35KGTREk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=RzoxlG301/jg0BEdHluKwHb8MmJhKuTebu9Foe8URITGDD3qRZk6SIdSEURFujPBTrlm0Ssyxmwvc9acXuVZ3b5t/N5m/ggIUOm/6h9jdzm9OEt17fV2hPCZhjODyKSM3Fh70NORTY2go3n6D3fyV+5StlKrO+9ja+k+lfLgl5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kPYIEen7; arc=fail smtp.client-ip=52.101.62.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kPYIEen7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyrSN8Fc3kFoZx+X/HcqWNO3aQfoOYZZsZ86pvqhZw5LbzN/iyIFIC84CSP+qYfolBwxRWdCmRvawxgfocCBd7VDEDyQ4r/hWSFRwwpI37JeXot8g0Gbsomtcx1HqpJ9BhUHS6RAGsQRDt8RVp+28ZDrBEW7mZERKG6lmkxDkbUsOVapNhPOQd8WoIc75ogu0YX5hsAayldZkXmbQk6ZkOE/h65iZFWeqa3q9c9Sylws9yNvnZlLo/3NKO74OfSGWWFnNOwvaIPkV6opA6oq8KKqpjV0bDvSUYtsWs39DCV1OulI7DxiWXY9v3imgXeaKjEitbrPsSIN75Xu4kfIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2Gsjwivuq/EkYFy4Sfj77ddTkCFzU8xK5dZsUIcDaY=;
 b=RIki7lyYYjiJLYCT6DpeShKpru5joatExHcUJ9qVpC9m2Sf+dzmtZ7hxGkarDEuer0E4jAcnEubYr0xNdLcbRG5UQ4ayQ/WJaRtlMBKCO875wulcn+dTlfkXSlu3v/uqdrhx12hUSwD0IeXuY6lEozhzCbaYpEbcqZv6pukSYSORjDTKvVpXSthwePL72MbcEuggqSONbCRbPGUGjzRFCrOm7Cik62PvXNtFnQM9nXETPD2gN+0vYIXsK8T6cQSq1xCHASyXCXmcJZaJTBs+BT+n7ApLcgDJnB0RktZKLwE/bUAnyA+CSL7S9b9b5tZ5AqVyvYDlwClFBA6tNVOFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2Gsjwivuq/EkYFy4Sfj77ddTkCFzU8xK5dZsUIcDaY=;
 b=kPYIEen7rUgfXo5MeGcezFIsWZUvc6m1qJVatUm39U0eDvU7EWeBm7/nQgA/nhinKDHSyS7htqik43kUhSi3/zYl7wICTVuG+Wx5HTBAO3JZd6cwpaS/Rs2EqSDUd60DqavsxEN36vA3CJl8B2gd59BeVE+g6kQwrleGA9gGHoc0oCAOaFVASWDLB+hqZIMfPIckrecprn1VucDGBv6cukB++JayaBnCob25iCRj+/nHIFExawNKorUCGfin4Yl2zjr0TD8NnvwtTELEuaha7JB+9HbRKSH60Cb4pUldcoJUloNpq3Xk0oxJsPTqdI9ZyWpHuBF4d50iFZdCaT+FhQ==
Received: from SJ0PR13CA0029.namprd13.prod.outlook.com (2603:10b6:a03:2c0::34)
 by PH8PR12MB6772.namprd12.prod.outlook.com (2603:10b6:510:1c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 19:21:20 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::de) by SJ0PR13CA0029.outlook.office365.com
 (2603:10b6:a03:2c0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Fri,
 13 Feb 2026 19:21:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 19:21:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 11:21:04 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 13 Feb 2026 11:21:04 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 11:21:04 -0800
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
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a6e68568-8b1a-4ee4-be31-687b615a1937@drhqmail203.nvidia.com>
Date: Fri, 13 Feb 2026 11:21:04 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|PH8PR12MB6772:EE_
X-MS-Office365-Filtering-Correlation-Id: d5cd1657-3ced-437b-1d85-08de6b351110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzhBTWR3bG5Wd3JybkFheXZjMWJ6SFg2M3FuUTNWSGdtZitrZWZLUmJOYXNI?=
 =?utf-8?B?SU0yWUlIb2ZvN1FoczdHcWNRY3N0SkMvTWs0RFZpbFpqYm1hdHFCbWZ1dFh4?=
 =?utf-8?B?MStNWkhYVlJsb0puT1dXdERXd3ZURmc0NlFoZUhKUVRYazBqQ204MlRmYk91?=
 =?utf-8?B?MGQ0cW1qditTK1BkVURuWVkveTBRWUc5Y3FCY2ZMVUN1c2tVUWRGekd6NVN4?=
 =?utf-8?B?MjRQblg2WjBUUHg3QU45UzNYNVBWbFNTMHdMNkdMcXg3SmdQYzZtNFllZll6?=
 =?utf-8?B?NDFUaGJrek02eHNHQXROOWljakMwQWgxRnMrOGdtTEcxQ0tsOXppNElvb0hm?=
 =?utf-8?B?cHNQODdxbUpaMzNQTzZYYUI3RlYzcEw4bG1MWkFmeml5Z05IcFdJSEpMSlFJ?=
 =?utf-8?B?MXErZitaWUZlZjViMEVRamp4TnFSZDZjZ1JxSmcvVmlmaFRzZHJUT2lQUlhH?=
 =?utf-8?B?Nm02RVQ1Z3VlMDkyYktUQjMzbTlIMnJIakFueXR6NWMrS3dGcVM1QzRiR2lx?=
 =?utf-8?B?bUM4Qkk3WUtHa0ViTDhCYXIySWVranF6SWo0c3Z6LytJM1o0Y2syYnNTd2t6?=
 =?utf-8?B?elJKeEI2NlhiSnR5K2RKbEhsMWZyczlmcDFkNmM1Mm5tTEp2TnVPWHBQQith?=
 =?utf-8?B?OVlQTFU2Zk5oTGs3SE9WZWlXUkR1c1pVdVU3c25GaThaZDVPUzRBRjF6WVZL?=
 =?utf-8?B?dWhjc2lTckxyYjhWeUtLS2lqc0txdko4TXo2cnY1NHBydkhFcHVFUEI1bjZJ?=
 =?utf-8?B?OUcrSlBjbjdOdnNrRXM5SVdjYTVYTm9UVVJpK0hham9LSG4zM3NjQWgyWXdT?=
 =?utf-8?B?VjdyQTRkTnJNWXR5M3J1YVBOTlFtSGR1Y0tmYlErdVlsL3ZOazN3bWlPR2NE?=
 =?utf-8?B?QUdmbklHOTREVEJ4VWRwZHBmRVM3ZGVMV2t2cmpoQytwTktHMnU2VEMwZUFI?=
 =?utf-8?B?eTJvN0c3TU8rSmJUeThsdFNTWXMzbmZodnJKTGxJd2xoM0lCNS9xbjF5eDcz?=
 =?utf-8?B?RkphSzdXS2JFRkNZQ2JleXhndWpGRHMzK3lZc01ud0s4VmpsT0pYcjRpTFQw?=
 =?utf-8?B?cldOZXFCWVVQWWx6WGcxM0t0YisyUmZiaXRIK2JoMjEzRlVxaWRad3MzQUlx?=
 =?utf-8?B?VGhxUXBqanM4T2N0T2UxU0RpK3VLQWxKbE5kRzVQSm1YYUJOQkU0TmdpSzZT?=
 =?utf-8?B?bE5PMmNtTldrdHFTQ3N6WVVHSWRNQWZvdnA3b2FnSWVQZW81SW5FWG1KREVI?=
 =?utf-8?B?bDBDRmlCeTRydHk4TUgrN3ZVT0t1b1psTlVQY1k2WEEzNlJ6TDZocm9FUFNv?=
 =?utf-8?B?Y2psbllHczdGZWd2VEp5N29xWlRadzE1S2ZPdHVNODYrOUsvZjA0Y2ZsR1oz?=
 =?utf-8?B?ZHVtbzI5eFZwNjRjdjVCTHVieSthLzhnQ0hQa016MUF0UFo4aEVieFMwVDlh?=
 =?utf-8?B?eXRWN2lYZUU2R0VXdGUzdXVKZFhjcDBCdG5wRWJZTEk2aUYyemJuZkJ5azl5?=
 =?utf-8?B?U2pDU3QyazVpK2drMXo1N1RQdEtDaERPakU4ejV4WDNrMVJOYTRrRVRBTDVD?=
 =?utf-8?B?V1RoYnlpSm1kUWVlTU96aFZKWDgyMXVkRFpTZnBwVVZLZS9tWmFDQTh3NFVa?=
 =?utf-8?B?cDlPRFVkRlpMcWhVaVBsam9JNm14RGdROEwvNHpBeXlDSXZPWDdyNms5K3lG?=
 =?utf-8?B?eTArVDI1S2tVQlp0ZWFGZEJtNGRVWElsYnZGenhyblRpdVNCc1FhRytlTEht?=
 =?utf-8?B?ODVHYm5qeEprM25sMXkxTXFHVytEc09PSXV2aTBkamgybjVMOEdmOXFMYjdp?=
 =?utf-8?B?aE95eU94b0N5Tzc1MVMzaXhqME9zcGgrU0NkbDhML1hGdlJEUWwxcFo5c1dK?=
 =?utf-8?B?QWFTSGdGa1RpSjkxNFN6Uk9IUVpyb2JJSzRpNEdPM3VzeWlEbDJBU3RKdzFx?=
 =?utf-8?B?NnJyd3h4cmNydFY3MFZYQ2dGdDNycUdSSVQvaitVQ1hDRjRPQlRBUWVNTkt6?=
 =?utf-8?B?YThLRExvaG1aMGIrQ0lwTWt6bDd2YmMyZlpIdzRBM0FVUVV1Z2srVFRHWG9s?=
 =?utf-8?B?dmlKbVV3Y1c4d0F6dXNkVFRhZDlLSGxaTVlqLzcxTDByUlgyd1dNbnN5cTJM?=
 =?utf-8?B?RVgrdlNZeGxCN083cTQrbFhqdkZ2MVpuZDRyMVpNMUFpL3JRNEd2Um9wSkRs?=
 =?utf-8?B?OEM5YUVXMjZzZndQSU9ZVnNOMkcxeEtQOVBsSTlMYThYc0pnUkR0TXhYZHpr?=
 =?utf-8?B?b3hFWlord1lJN2J3aFJMZkxQdXBRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BTbHtNhSN4BImREDk1+bhU1DtwaNrqvhIO3Cx5tutrEmf0ypxhdRtj/EfilsNDyxWs+kMTCq2+rhyDTD0EPjgz6BFr+ryAlD6xSFcoKpOOEjM5zeoXdRb04QUo26AeawKYfHyo3Cgi9bcxL0dur8AvPhgjSTGcYKljfFWvTtZ+yNvYZ0F6q4gGGfyJNWOdc5rnIHY1+1kAX3nzzUufKMpuqFUuopOGrbj+OU78vzLQud8z7AgTzHiklajHFlvisndYADtiZK9M5O3YotnmBoOyFh1hR32Bq3enVVH5ICKkBpZYM59o87NPNqfGu7OkPPbrR+b1NjjJT6QTUekDzghPwkzN9R5sx0LxcvJpnRh6ZsHzeGl3b0X6NOSbF8UCJDBlUYYNKvb1M+4BIo3SotQJnh3fVVB2VhZ5wYUj3LxggB+QrtUgyjYpX145QXXvnj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 19:21:19.6682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5cd1657-3ced-437b-1d85-08de6b351110
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6772

On Fri, 13 Feb 2026 14:47:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.11-rc1.gz
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

Linux version:	6.18.11-rc1-g1dd43fd284b6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
