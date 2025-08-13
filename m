Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D262286897
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755100134; cv=fail; b=jStcEGiJa5VRPKK+u9n75ThhWPKIv9vXSpnJqZ/5BcZxk6H2U46h8CBRhpKOAXaIXvsbNEsQw9uSkvSLUXEoIC+BXUuaj+9STBHRL3yWYCAzEGm5n+Ppjn15gVtFhxQouAFIajj3a4DJiXNpFmfCOnmm8Wmq+gp0xdpiAebhI6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755100134; c=relaxed/simple;
	bh=qPuqv9aBuU+rlTqrbBTBQD/M4tsLTK6hsFP/nn+v8ZM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GdU0hqPqOqyzUpMmcoQzapvP7FxnWlRslwo4ISi8nLwUUgrckz5w5wX0Dy6W69IVKUsSe/qLk6AYUuIvRgRA+MXkCaEN112AiSwDxiwhw1D+QMaLosK/H5QnQ9Ias5dEn9iFJV/GwoT5bW7qaFVPtAvfruBJZmDy0UKlx1aor84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WiEzAujU; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WiEzAujU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ToHR53Nl9BO8fAB3nFyeMzbCTafDLOsdoBch+YpCyyL7CbRZTS5TMspH7groUH2ZScsGQ1J0Pcv5J83d6O9PHhhvZJ8xvCbiZC5zQLXgtHARZ3P0+aEh3LPHRedA67G+XM9AqbCdV6wtRA4vAzBIluNDIqmkZVDSc3Qi3BSGJ5u+b+WBsr+9mZ4I+jFQtcBcKgi5hLeEo0uFzRPe6og+VwfKHrPhPQ8fkrcX2N7JdhbkNKNVQ9VZqOFiCJGn3APHwhq+rYCCBDWzQrHmrgLO3qxQ+idoTryNm96+NVrUf7lHYTBZCnvccaWJBoxqiEI5k4KfOFzwORU5JmN4hkfM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3La0G8ANlDhO5nXdTFNt1j7oaZCf/oW/z1rZFbHJ5Ec=;
 b=kvX+RcKoTLz1Hy2LFMr0/BtimB9kDUN/PS8yM1MA1EdXscjSlCBOhLHzRSOxnRx5OjTdKqrtBpZJhGacxeLZaOcLzIAqN5/vVN8L/mwEKzFfXBRtW8kwmfSxhaR3WJvTjuAsAKtiDbVouIa2wHgXNZVhg6+6Kf+bzCrgGtJbOYLNams0CRCb10JhtGY5F6WW7rESyLV7P0RRIcr0Su6jmJa9svTnDILkwCiR3CAjbQAQzbribF8E13vPGWcWrySb4gnAO1UY6noMrGKm3yg000LpjKGZHMlaXR4gl9MllWwF63ELDwb+rbIf2bYcMzGlLuUsyobGyWqo4z2dSp9ZhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3La0G8ANlDhO5nXdTFNt1j7oaZCf/oW/z1rZFbHJ5Ec=;
 b=WiEzAujUOc9JezhC9d99AvisPGMWtIxGP6Wrq3szwcs48i6+ClUSLLct9ZCecMAQlx72VN83yvVdZC/RlTj7MasltJq/M1+Tc3LNDVf4AgXMqtnOyhiqNXf82nfFYGj7HEBxUHZMZG7RdHVIRW97KPB9L2jK4B1M5k8bGzp4Zcb/cvqEdXj6JUhWYKv3AUI0GtYugiKV3PyMxUdvw6oIlboOS/3lAR1XRBhT+Rs0MZNdcVMUGyy+H7Fo4H6cBNF4bmNlZCffnaUqKv0UtpRRXxx3T6O+Z5qZRK5KvoP13Pn2YcYf9htWw7VZmjpkMs9iNSodGI+Ca6Z04aVtRc4rzQ==
Received: from SJ0PR03CA0055.namprd03.prod.outlook.com (2603:10b6:a03:33e::30)
 by SA0PR12MB4351.namprd12.prod.outlook.com (2603:10b6:806:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 15:48:48 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::1) by SJ0PR03CA0055.outlook.office365.com
 (2603:10b6:a03:33e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.15 via Frontend Transport; Wed,
 13 Aug 2025 15:48:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Wed, 13 Aug 2025 15:48:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 08:48:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 08:48:28 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
Date: Wed, 13 Aug 2025 08:48:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|SA0PR12MB4351:EE_
X-MS-Office365-Filtering-Correlation-Id: 147b8c11-af6c-4b09-0744-08ddda80e4dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWJBWWtVekxyeXg4WFN3dVB0V2t2aENOOVRoYXF5QlB6L3NZRUVzWGU4UElH?=
 =?utf-8?B?WWVPYlROMzkxL25JSUNyTmN1cXZjNENnc2VHZ0hWbTcyNi9mcFJzVklYVEFX?=
 =?utf-8?B?ZThyZGlKNHpnYTBsMkxSUHBOVHV6WFQwSmpXTU5hQkxCbkJTZU80RmdicVUy?=
 =?utf-8?B?ZWtKSlZ6TEVmVEp1ZWdRVDY2eWtTSUx6aTFva1g2eXRnS3FSZG1vcEZLenR0?=
 =?utf-8?B?QSt0b0VXRUdGZ1ltbnpKUFhoOTFtNlVRNjByWUxMMEJrVHY2aFQxVW8vdEFO?=
 =?utf-8?B?c093VnZkVmNOWStzWCtrUWtLbUpXSWZjNFlXRHE4Tk41R0JCZWh1WVpGeGh4?=
 =?utf-8?B?UmhzVFZuYWpoUUhxNnRMeWRLelpQbzdIdXUxakVWWGF5ZTBwaXlaSDJ5Vng5?=
 =?utf-8?B?cnhKOEJLMFhnaFd4TUhxbXJKdk5lbGFTZUZTbCtwYmtabnlzdCtqaG5aYTgx?=
 =?utf-8?B?cTUwTlpQbEIxc3c3L1JrTWl6RE9yT01PS3czZVVIL0xWYWJPUXlXWXlCWmhq?=
 =?utf-8?B?V09FcjZoNG1lSWNmWHI4NW1La3hQVVZGelNCOGxEbnFrbXZ3Nm1lbEQ0YzlB?=
 =?utf-8?B?Y0pRSmNaWFJGWmREMmR4K3JRM2ZjVS9TMzY5RHZWQ3J4eWdJdWp5MkFBRk9V?=
 =?utf-8?B?Rmo2RjdPVlljTzVPUEJBVVlEc3lNQUZGQjZ1M01MWU8zV1FLazJIS2l6bTNX?=
 =?utf-8?B?MER2K05JSkZ0TFg3N1dham9hWGZpNWhXTGYwVWhYVExFUjBTMC84ZGlYR0xK?=
 =?utf-8?B?cENqL2R0Q05tWjQySTlVTUJyU1g5UkgrakdMMS9aclBXUUdOMCtXSGV3NGh2?=
 =?utf-8?B?WjE0WXBXTmtGUGlsZ0EwdzBrU0RmajJ2eVhxTm1VOXhUSlhmZXJ4N2xGK3BP?=
 =?utf-8?B?Z0lGMHpLTC9yS0lJZWVNbCtEazJ2a0RaWXZRRGhRVU83MmpZeDhDNWJCSnFP?=
 =?utf-8?B?N3g1ZksrT01OMmNBUHB0cEpmcUpQUnF2bThreUNRdmNOZ3Y0cnluaVdsS3FK?=
 =?utf-8?B?RUxaQmplSVpyOFlrRUVnM2ViSDR1eE9FZEJBdjZvRy9xbDdsaEd1TFVsWmpU?=
 =?utf-8?B?MkpacHQxZjBTazhyQVE5L2FkRGsvVms4TEZrTkloaHpicE01WUxhSi9tWW9s?=
 =?utf-8?B?WmxTVTFmdGdEZUZ5SmcrNVBYY1dudjFxOS91N0RWaTZYM2szclIwbFV6clZx?=
 =?utf-8?B?TmdITks2VlEwb1VIWU1MbGFOdnhuZ0pZY2cwU3JKazEzME9sVTM4K1J1SzV2?=
 =?utf-8?B?Z2s1TUNjZXRzQnBjdXhIYml1bFlXMjE0eHpDR1hqV1c5d2RSQ3ptV2JOVzIz?=
 =?utf-8?B?VS9EUHpTSVhPNGI2cmJ5M0preXpabTE4TjZ4Y0hBRlpYOWJDeHBmQ2ppSE1z?=
 =?utf-8?B?bkhLU3hQU29Jei9rY2N0dWxpUDBUVjFnWGpMYTQ0ZDRaUWRtanYyUDl6Y1BH?=
 =?utf-8?B?ZFJQREEySWR0VmpwZTBhVjhJSG9BSjBKRy9Tb2pNZlpaZmE4MTBHRkJxSG1B?=
 =?utf-8?B?c0ExV2xKbFlPM3hnZU9hamIyOWg4N1NxME1uRmNrdUhhVlEvRFoxU0dxcVI0?=
 =?utf-8?B?QmxiSERyRksxNnFGV1FlMXdTOVVlQXVIVHlhV1NqVFdoWVlWYkJRQVFCaDhN?=
 =?utf-8?B?Qnh2akRyVm9kUWY0cXM1SGtFOXBrb05CWEpDSUtoQmNTd3VUaFdKOGJqMVJz?=
 =?utf-8?B?empoaFNNQmxyQ0JvWGpuT1dKSU5pTG5kRlZXOFl0VXJVMXRIZDdxeEcrZVJX?=
 =?utf-8?B?a0Vrc1dKZHpzQXdVSkFQVkZmdzZnNXlGa0Z4Rk5ZOHFNNGY0eElDNkRZTHUv?=
 =?utf-8?B?blJaWTRxY0hGY1NnWmNIWjBxVVlWYkxUa2Jma0t2RnlQMkhDbFFHRXJVRksz?=
 =?utf-8?B?cFlTQVV2THAyZGt0cStwSmloaHYwS0pDeDduNW5wOTRObGE0TUQ3SGFGL2JG?=
 =?utf-8?B?WDFsb28vVCtXcmh4QXo4bDJBV2U1b3Y2dVR0ZlE2QTVSYVI5eWZmYlk1S204?=
 =?utf-8?B?bnBpa3BBYzcyai9HRStxNXZZSFFHRzI3VzVWbFFBa1Y4S2ZiNXVFQSs2RnJm?=
 =?utf-8?B?aGxoT1FTREQ5WldJRTNZa2xZbENxbit1aWF0dz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 15:48:48.6376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 147b8c11-af6c-4b09-0744-08ddda80e4dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4351

On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	119 pass, 1 fail

Linux version:	6.15.10-rc1-g2510f67e2e34
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
