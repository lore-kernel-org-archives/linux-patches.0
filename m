Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103D5139CE2
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 08:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994398; cv=fail; b=upYAgP4COoDHTWm01uxrwH/6g+uKrVxhuL4tTdNQl6ZEPockSipTWoF35QPbM3zFrsWYtTTCDOE8H/9a97QJbPreOHiF2WW0ngL07hgvSwjuGLPw8kuWGp/ypiAdoD7Esvqt16LvXroxnUj4lwPh7J5QHmasaPErVhJWUq0GYsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994398; c=relaxed/simple;
	bh=KAycR2OqeJo0jCUD8SN+xMAaIQ+UGCHcCbdjzGdf9eA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lH7G3uR5sNIKeVC7uT3fgTUIxZoRAiFVsRvmNtcWAcTo+a/uuOgUywK7j2xuHxQzMvxsNRcSKLG6J+KmbLkkELFZAEVS/KHAyRy1PGM5HE6tEfvWzQ1GhPXhb/ng67ESamQ0nQ9huZ0/917ZBruEBSrOsbozkgn7x+j09XlBqVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iH3OWmkT; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iH3OWmkT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTxAaIybFISsMWIFh9a7VClLfulAtkq/1ZaHFDxjcohl4/W4er6rf6JdGGdQbMPS+Tuv2/wBcNI9Wqu7+zOfnoS89kO5sz25s8mZdnAj+Mg8BfFCa83x4UjeFR6G0ySfSnj9BEDe+WLP4GJr36zybAQEMBGHwoj+cUu0zQEcJSfY1ngxep06eImXfZiN6bGvA219k7NWBX3p+LcHNKU3PTKCMDz2T00XdM85GMs+q8adAcB5yDTAKMbL9Zzac8oMwczpQsfAl9gwUV9oryMOUTp4gasA47NcozMpyxs6eMbLND7m/mqGnYJKldtlg5gZk45nl3sfrYy+14ewaHzV6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmEzwkPKBVO1xYX0/cgZzhIH/t+MVQvTWkeSIj72TQA=;
 b=Ef21lU6C0Fm9jKdggJFEHJbrKMYky23vvK7ezDpCJGNAR9nbLnKA5UvVUaF82L7sLo8ZfgySlskuyfg81nU/SzFdR4c6uiA4Ky8zVG4bNaPgtAmX9wlUfjxraxVWymUC2ZPlBo2j/405kJwc97zCR72TZkp6LsKtLFxbVfmSfAILdb3yswIEQGXWJ7atXWLxa21XH4rcHCbK+OqBYz0Vvj7ke1PpSa/U+HrHuOFpQ//yvwVKcEDh831CjzTJ+EwqHwwLpkXnadS0h9D+N2c7eh4qULNUTLuMalKIOr39gCUoT2wz/u1vbXwVN2F4qr2lgoGinwqZ7A3WirsCwaaGEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmEzwkPKBVO1xYX0/cgZzhIH/t+MVQvTWkeSIj72TQA=;
 b=iH3OWmkTKJTT4w+oug1Bis1wImxjyZqiYJ6Hao3to3r6t+oJXeCP3wLCKyO+mQIH7Y0z8KgI4SNT7EhU1sBcp1g/vQ7FJzs3NsZUZvPRzdJ/cuXr4nU0oF7tcfXCeNbtcnlZ7jWQfIekX03ndi8l/VQIZrEQDs+dXtjdDxc2ap9TLID55mWMazhQ7NJeNP/o78kVhW+IZmnnQyJfBArJLYKbKRtnGrMHKXyXPpsHq2sxN0hSRD/FhBFmLbus43xbjxin0AEf7HV3KZL0YnSc344+2oeD9wF8fyQpFJumpch33NVZpFKjvbcLnzpXFFwj2Cgv4SOgLI5ZoV/SrTjNpw==
Received: from CH5PR04CA0014.namprd04.prod.outlook.com (2603:10b6:610:1f4::26)
 by LV2PR12MB5725.namprd12.prod.outlook.com (2603:10b6:408:14c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 08:13:13 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::af) by CH5PR04CA0014.outlook.office365.com
 (2603:10b6:610:1f4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Wed, 3 Jul 2024 08:13:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 08:13:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:01 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 01:13:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 01:13:00 -0700
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
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <a213a020-5907-46c7-a8b4-48f495a1bbf4@rnnvmail204.nvidia.com>
Date: Wed, 3 Jul 2024 01:13:00 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|LV2PR12MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 789a6bac-6863-4749-06e4-08dc9b37fbc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0dqK0ltZy9tMk1xTFZyYit6SXRHYVg1OUhscEJHek51b20vcnRoYi9Ea1Ew?=
 =?utf-8?B?cFNHRG82Rkxyall4azk1YmR6UGIyQ1dIVCtDRzdlUmkvVFpmUWlJREw2SllD?=
 =?utf-8?B?aDRnblljbCtRYnl3SUs4ZXJNRkY4WWFKU2hORUFvdE94bnlaaFFsS2FVQ1lJ?=
 =?utf-8?B?V29PRUtvRVRSbXpYVTZWUUk0MEtPZklCRHhINlp1RWRoa09HYlRmYVN2ZUk3?=
 =?utf-8?B?YzlseFpDNEVuNSsxWU16cDZmV0VSQWxNTmlTYVZobWFpVmNuU1dGU09zWGo5?=
 =?utf-8?B?bVMyR3NJZjJsZGlRZzRQcXQ3ODhZK20xdzZQQUdJVDBRZThpWjlPUXNlZGhT?=
 =?utf-8?B?bnRpUUVhNTZ4WE02R1NFR3MyWnJXbEpvWklwSG9MTXVRM2dhaGJRV0trQjhC?=
 =?utf-8?B?Z1ZEMWd0Sk5FTlp2T0tSSUYvRndXNnd4bFlHTXlNVHl3dmI5d3hERE5wN05n?=
 =?utf-8?B?eFZJQnRtRHdNd0Q3NU9OcHc0VkdaVW1SSlVqRGlZZU5nZUh3akFyUFVkSkV6?=
 =?utf-8?B?T3FqYUZHVDNVOXpnNktaRSt4YmNRVXJWN3NxWGN0QkI0djhobDl1dFM0M0Vh?=
 =?utf-8?B?aUx2QmNQQnk1MWcrVWNkZjVCRFdWL3pjZWo3cUhmaWQ5S29ORGFhNjlVaXBp?=
 =?utf-8?B?Q284UC8veEgwcXBRdGpCbk5INkFzY2FrQnB2MzdobXBvOUFxUk9RODhLSC9P?=
 =?utf-8?B?SEtYNnoxbTdFMG5HWG9CcUp5SWpGaFNKQzAwUVJDUzlDTFVTUC80MFNCOHlz?=
 =?utf-8?B?Zi9ZbWtZNlJFUTNod1Z4azQwaytjWitRTjhwcmNnMHMvY2hIb1hMUWlmK2pv?=
 =?utf-8?B?OGl3MUpkK01qMkRnRG1kUVVuYXNXNm55V3ZGRWdPNmQ1WGJJSzEwM0ZGb3lj?=
 =?utf-8?B?a3FtYXlPOFlaNVBkSTQ2Vk5KSTlkSG5WL2grbUprZVhsY0pHVEFoSG9KdUVo?=
 =?utf-8?B?TEhxdDRzbnQwTFF3NHRxMzNEZnY1aGVGckNFc05LRkhtRFhPb1o1d0xqamV1?=
 =?utf-8?B?M2J6amltOU9EdFk1eXNUQXNlVmVaZGMvUGkzdk9tWk9TSW1UdTFBM1Ywa0tz?=
 =?utf-8?B?Z21jQ3RHV2xuUUlhbmxRZGNWODQ1bEw4SG5vTVFzektEMm4way8ya0Rjckhx?=
 =?utf-8?B?VHNMYXBDd29UendVaG1mZGdTUUF3NFp5Z1VkcG9PcmUwbUhwd0h3RjRnUzBI?=
 =?utf-8?B?MW8vdnJCRWhCL24rUDN2YmpvS1Uyb3JIZi9LNEMvT0ltQ2hVOFFkV0xpamVL?=
 =?utf-8?B?SGxVT2lGdUV5OVlhSkxjWjByS1Z5amF3R09lNTNtTU0vVVRUSHVPTVFPNDdT?=
 =?utf-8?B?OGNEb1J4OXpVaVQ2L2YxOU1uVEVLeUU0ekQ1bFZOVkN2WWZGcytlNit3bUdu?=
 =?utf-8?B?dFdmVzdOaWZWQUxmSWh0bDFZUmFUbGs4bFBjSHNBRmNsWVYrMVN4ck9ybllh?=
 =?utf-8?B?M2x2VGdiRXFLbi9OVndEZzhkWTVpNWdxZ2luc3NCME5WR3UyTGhvVGdNcWNh?=
 =?utf-8?B?T24ydkczVTVBOHB2Uk41QlVYU3dLVHUxVlVtOEprN2lrSFAwb015R0xINGVt?=
 =?utf-8?B?aEt5VVlBeUNuVkZ3eFp5NEVzTHkrdTlyRGJHVU5ZOGNlTWx4Y08zOEZDRnNC?=
 =?utf-8?B?S1V1VCs2U2pzSXVzZjh5TFlEWm5TRDZkeDBocGZKM056MnhweC9tM1NjUnlC?=
 =?utf-8?B?NXRlQ3p0aC9ZYThMT0JjWHpDYUVKeU1TeTJkVXNsVmhZd1VIQXNrU1lWdVhq?=
 =?utf-8?B?WWlFenhoQkdtcVByWktENlNOR2x2RHcyOUZaeHFmVWxDaHZ4TzZpa1lTVDla?=
 =?utf-8?B?bS9sa2RFbUVIQVRhN3hqVVhOQ0o0WmZIWGVmaGtXc0R1bExQMkgzVzFTQ3JQ?=
 =?utf-8?B?bHYvRi90SzlCb09XbnNZZmcvbXhvUlVOckNZOGhwRVZ2clpwTDBLSXIzV3lS?=
 =?utf-8?Q?w12bBQg+xXipz8+oURnkDoqc2sGwZ6Rs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 08:13:12.7730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 789a6bac-6863-4749-06e4-08dc9b37fbc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5725

On Tue, 02 Jul 2024 19:03:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.1.97-rc1-g54f35067ea4e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
