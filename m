Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3491B4145
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 10:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734084213; cv=fail; b=ZB0WeFET81IZcBSIHZEXMReBVzEouqOzFaxrhtkw+BnodvZEZ2nzfK+TVqq/GwgOMBvNsHEaejoGubfIR7GUtmfUt7JrBDjUvJ5lbnlSa6fcJHfHrtc034aIaafJIk4X/5mqYc+ksG0SEfhIUKinzS/A1xxgF9D5Ln7ufG7XsRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734084213; c=relaxed/simple;
	bh=7Oik1DX/7x6u6irTSzz4SZrO33JJ6CMVU0zsn9DktTc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=OvOkpzB3QJ0peDg7IaWJDaCQtiSoABX7MU8BAVcZyWDeq4Ue4r9YOffgqpuM+dX1ENnG0qdqgW6WK2uC0uliMQFIRr6s1o5tfJUnmM/D4PhonyULLFKyAt5J4Jq5yNQkkqyJYr0Obb0MOBmUuNLlIH/yrO2h7ZMraBQ6CA0nz+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=etaEdItE; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="etaEdItE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7w1KBXUeXQct9J72r5vqSKftE5geuk2gFKh10cZhy9AwpQNCIb8xppbX7EgFDKMgwmogcfs+F2Q/MsTJ+Cx/AOORvdrxCDKx/wgTPN/RJgy0YGhKGA1O2u+clnitwwi0/TlRe4m38EB1wj1KPzBn3NDxkbJnZ+0eCSFnBu5RfYRwgcImbI7JE0MWWuUIDYaIRtT+FqdThuCsUgnQHJ65hXy/iV/QTGYIOihyL18PeaTy9AEKfe7JWGme4MW0y3ZunqrknrnsUzVtaxmJzEH/QXzbY5D+xwKAi5oHUlED9xZyRaYcAsgL0yy6ki3a2QaXMx86ZxYGs+wVR6dF/gLig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7pZt00Sv1wwINTwdNTdejPdlGKjGXPeZMZNPoQvxKk=;
 b=l3IxlpDNrwE9BQwSvLUJyt05Fs6CGbJM6AYYMgEV6RgcDtBvDEuW6BcmiQbI1IWFXiRH18Pl+OirihnSZXGwtNul1lbel+T1zOUcYhbIcLAg0CaE4x1bkoJ3u4H8ghJG8Cbxyz+Ce8c+yDLLRXc95ONgfu7DYN6gaVRlkmfT72plKh45meNHmYPvAmbYAzK+HalJOkFECB6oNz/Ox2HEZyiwsJ/8PSqWzAq/fYdk4+VPeZ4/atmuukGgl/rMzafuvsmQJBGMvJfPa+z9VDN79m9lMX+X1wN5nbpjURZZJztMavqAcDhSRpUXlD62bnSMGjbiATaHP49JBS6kWvtQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7pZt00Sv1wwINTwdNTdejPdlGKjGXPeZMZNPoQvxKk=;
 b=etaEdItEH8bkrwZSVL47fWPv5FJrLxIeGB+mcP9QGrKTO1DIt/oVN7lAyqmyIgUm3QpcYW8d6UXQ99az1aTCk3AH20ZX7+Bb2zgS0mTQtGqZOWZlvanzk0HV5MxVaXAd8EMzVpzAn2FjMd9yWdhU/tQhVYMN4svpmw+fTHhFgWugzxDFaSBtDV/Y6mZqBKKXtKgQsjue+2MJAC9O+oO6STyHxXOjG5mSOyXQiMtd7xbQ/hxfxCxX3xLdd747X2loC6tksMZPXRwnTxkOQW9F0e/pX6m0KMaP9BEnwcBIYY373Wt3BmdBh3R2MXP+8QjBXCu/CFj3dO3OE0doPMlZ+w==
Received: from CH2PR05CA0057.namprd05.prod.outlook.com (2603:10b6:610:38::34)
 by BN5PR12MB9512.namprd12.prod.outlook.com (2603:10b6:408:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.18; Fri, 13 Dec
 2024 10:03:28 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:38:cafe::3) by CH2PR05CA0057.outlook.office365.com
 (2603:10b6:610:38::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Fri,
 13 Dec 2024 10:03:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Fri, 13 Dec 2024 10:03:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 02:03:18 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Dec
 2024 02:03:18 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 13 Dec 2024 02:03:17 -0800
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
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4c2038dd-a948-481e-bff3-b0e4283b43eb@rnnvmail202.nvidia.com>
Date: Fri, 13 Dec 2024 02:03:17 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|BN5PR12MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: a19df17a-2dc6-41a0-84f2-08dd1b5d640f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWlUS1VublM2NFJuUmhJa2RTcStsV0xna2lpOWpNK1dCV0FOOXozR0paYVM5?=
 =?utf-8?B?SVJiZ0RObUcvQXc3YkZIOXZMc29yUXU3ZmN0emQzSXNVdHZEYVg3NHA3RHZp?=
 =?utf-8?B?aU9lWi9OM0dUSnczQS9VTG5hM01kZThXYU9JQ0tJTS9XU0hET0syN0ZRSWln?=
 =?utf-8?B?NXJKNHRCVy82clhjT2J0UHBqZnZwcU5kMDM5VUEwSEtKOVR2OFhoQ3JvcVp2?=
 =?utf-8?B?YmsyRU1NN2J6QlFKVGVIcm0wZWNDb1h1UjQxYUVweXlMR3FSOFVqd3pSSWRJ?=
 =?utf-8?B?ancyajZqWXRZUGRVNEZ0YjlESUYwdzROVUZJTUM5RkxVSVM4djRKNWZnN09q?=
 =?utf-8?B?ZHN4Mml0SlAzV3NKMHVDTERKOW9HUWxSNVMwcERxeXYzM1pQTGFRaXF5Zlgz?=
 =?utf-8?B?RVNaTzFobzFvbi9EQWRFWGxHbXpMaGdHdmhZTXB1dk5iSjJoKzV2dmRGOU16?=
 =?utf-8?B?UzJWd2xhRDhPQ01YZjVLUUNqUWdZVC9MdkR3Rk9VdkdjNkdjQmVxekVyZWRH?=
 =?utf-8?B?QmROSkFmdTdrU0lRYlh4bGNlazMwS242dGpXTGJ1c1FrOEllL05qQ0RJd0NK?=
 =?utf-8?B?TlZrZTFqVjFRQnhTVi8yVHhPNXZqaWlTZDRrckV6aEYvRnlwRnc4UGQza05K?=
 =?utf-8?B?VkdRQVNkYlpmSlRkNktSaEM1REw4a0wwZTYxbE1ETUlKTjRRaGJxZWhOWEMr?=
 =?utf-8?B?LzFpNnFvVlBvYVgzZnBjeEFDVHovOVIzYmYxS25YZlo4eWU2c09SZFNoM0Nv?=
 =?utf-8?B?blo0QkRaUjdZSlkvQ0dDS2UwTDBYNG0zU1NreWk1N013RTZ1SnpvdVhXYmFx?=
 =?utf-8?B?SGRGakhMNlRXWVUxNUpKaW1MR1JxQUc0MUozd3lMaG9xbU5ETHlndFkrVFRX?=
 =?utf-8?B?ZGFyZ3R5K3hXWW1rcVNGeElqeVloN1RBU2ljdGdPWXZQalNBZXcwVTVsQktK?=
 =?utf-8?B?cUQrN21SZVBaeElHMGZjNzdOSnRCeWhvMkdCK0o0TTFvN1htTFp0TklrcnBW?=
 =?utf-8?B?WHhDNkJJOW1mVVQ2WUhsTFJWSmVtTzZaWVJqaHEyUHAzU1dJemhka214cnF6?=
 =?utf-8?B?alRjWVlZWk5SdGZxdnhxeGpBNGhUclIxSU9vRWVrVjltdWlwYkJXaW42eUJ0?=
 =?utf-8?B?a1dvWEZhemVVcjhSMklBYmxYb0hVYUg5U2FsTGgvY24zZm9lTGxKNXlweHFJ?=
 =?utf-8?B?VXY1Yi9vTzdmeTlJbWd2Sm9ScHRtRERJRkJVNE9va0RZY0Y1L2h0ajk0a1R0?=
 =?utf-8?B?L3QyK1M4YXgvUk9FT0NJWmpMMVEzekUyVFdOVUVTam83UEtQbkhXUWNGdkh0?=
 =?utf-8?B?K2JiMTNRMzRrSHc3cHlRMVNGRkJ1Z1MvQ1lBRHlrbEZGLzllU2w2OU5LWENp?=
 =?utf-8?B?Vmpab3lsNm1INzZHZmNNSUx1dk9DSUZZUVRyZUIvbnpyaXl2VEZPWG5Za3ph?=
 =?utf-8?B?L3dUbGFVUVVwQTdDRzVYTkU1TldjSy9UQ0swKzFKN04vRXQ5bnc5dTNmNlpk?=
 =?utf-8?B?ZXZUbzRBTkM2V0E4ckpFSFhuVXlRZGJkUjErdXlabmc0ZVhyR0RzaCt5clZa?=
 =?utf-8?B?d1VxeTBDdXZuQTBjUEZvTWY3ODE2ZFdZKzJWVENvbE5sN0hJQTNOeFJLZDlv?=
 =?utf-8?B?S0FrOHRkMWM3TnV0MFZyZEMxSWdpaEVOUkF4TFRsMUZ6QmhJNE9vVWkySXZF?=
 =?utf-8?B?Zkp5eUhXZnBZT0ZoTFNLZ21lMy8vTFJlWXI0RmJQYnFhOWFCZTljY2lXZlFZ?=
 =?utf-8?B?cHE2bzFjN0tRNzFvUVc1Znpmd3pNUXZzT3NjTjBxbmtMdmZ2NFNmMWVwdHZG?=
 =?utf-8?B?N3VCSHVPdVFmUERnMVA3U1AzMTBLUkw0RkNXSjlrVUJhZDh1SG1KaDlMZUdU?=
 =?utf-8?B?YmNXNkQ5UWtnSEF5Y0RBWk9ZKy9hK2JvU2ZXWUN6UUlPeTd1V2N3NW9TYUcw?=
 =?utf-8?Q?h6RPZ+w3aMwALP4bsFqZbdlsL+Z6a2vV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 10:03:27.9563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a19df17a-2dc6-41a0-84f2-08dd1b5d640f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9512

On Thu, 12 Dec 2024 15:53:15 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.174-rc1-g4b281055ccfb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
