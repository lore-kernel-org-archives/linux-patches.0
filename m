Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE7B18BC0F
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125554; cv=fail; b=SAtrymjN+JDVO5V1fcnHiwZgXxFsRJajfl1h2Ipo9tXfP+m8rJTDSo0lx0/43/C7CDj44BbLCAtyhVR1hXpYyLJ99MhAvqOb8zjH4s3ppvQtRD8vqY6v2f/U49hp/u4HgMGsPR2x2os6MjS+KmQylE6IKrjWjFtNgnqWCk1tkbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125554; c=relaxed/simple;
	bh=vhZemoPMWvEb0M2S9R7SWK5fhOer1+BEO18jiMRc3ZA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=llDD8fOp/+9n5pYaNAR96g7tZAGX0bH16SOSF8P4E4x7+adqke+M2SkO7djxUs3RXAyS/fBjfxAEsMq4ZRMsT1oxOWVBifia5EVXxW6Rs/hZlM4gAxBSBAMh9tlOSKiKAi9BSaterFi4ljYbC9k5hJuZGg+0+0cS2eoTqkQjgnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pIR6EU0/; arc=fail smtp.client-ip=40.107.94.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pIR6EU0/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVmeZEQLfsKIzHI4zxSJOK2VLESe8tGw/2m9CdUwzMKuZenWW8S6iRkD8/NKM5nn5cjNwqPOSnOX4hsWfQGi3NA/2NKYyz1B1mUoBH6BI3BatU/aDg02syOs6gQ+P+2gB1qNweMsFLeBhebGF4PXJ/6Hk0oPGD60LjGTVpvPB03kcUV9b9oZEMNr3Zjs786uvSJdhNN68w7R8e4t+NbPFwqqtgChaz2MRK3dydFF3RJoOOzIt4ZBuJ9dg5LxGHN10nrfwVNIBBAjxnWXotcNVeZh6ydlvg9ybj6Yn2J4LCyEw3aADQZgifcBcV2B95ooqmMqRH9z4s0zg+T8RNGntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zuv06LWTCABJ8NnhT5/G2S0DPlGt0Tbl0wyN0tu7xOg=;
 b=YIeQ/tvUjsht0hjoJ6pWfQ4ZlcDcld365DE7/72OVOPKSwy+g32BWBBljyjNqHc0HUpyJkHs6W2TXNZErF5OVbQf52lNTHc+lGzl9PKQ0Cc7RIr+UgTPLc7YK+mh7jglE3qJoOeL9UQSTtIfkDYqzIDpX68f4T3ZrwRDzPGSTINjjeTaxVRKp+WT1PNqkQVSwL2cWrW26w56a5Rs652No0dBnOks9UUTu27OpGMFgwqMDueyv0iXB2BAJNxel+vc6xpC2nyDcJ9yQh4W/ghmEB5C0vjzwo9oc4pl5WKK49Va+CwtM/g2jABuQ/SC3RFyYoWR/+ibSrdNaaXHxObA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zuv06LWTCABJ8NnhT5/G2S0DPlGt0Tbl0wyN0tu7xOg=;
 b=pIR6EU0/nUKMF+uP8BhH60nZy6GwPmyVkuyGR2Uz4LPqy0l96rwRymFYECJLucwpAaSnQ9cTlL1+fim5nel+/7YeqC6NIcx1jCWNNAad2Zkz5tm3lTEmztomZmtfaUKaDgrwSRbpg2TuU6CoHVhtZVb1IEvbX50IDBaOrBAAnwJr6rFI7+5mUPav+zx3ZxOUl/BFXULcdYomAtWwKx1SyHz2wPCD/A1rRbTXxrn0weHQMDNOoMKwC0SYxt/3x9DxzOwzCpsltgi5B3i1P8CdzVo+0Fs6umDhCeRD3P4MEUksF/RAyTHjmBtyJN9AZTQ8bjc0HrC4h74nJ3S3SNxv3Q==
Received: from SJ0PR13CA0065.namprd13.prod.outlook.com (2603:10b6:a03:2c4::10)
 by MW6PR12MB7072.namprd12.prod.outlook.com (2603:10b6:303:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Thu, 12 Sep
 2024 07:19:06 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::97) by SJ0PR13CA0065.outlook.office365.com
 (2603:10b6:a03:2c4::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Thu, 12 Sep 2024 07:19:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:19:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:18:52 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:18:52 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:18:51 -0700
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
Subject: Re: [PATCH 5.10 000/185] 5.10.226-rc2 review
In-Reply-To: <20240911130529.320360981@linuxfoundation.org>
References: <20240911130529.320360981@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <abcbd86b-2e61-4625-bc42-8713510ab7fd@rnnvmail203.nvidia.com>
Date: Thu, 12 Sep 2024 00:18:51 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: b635f37d-1e43-447c-200f-08dcd2fb2f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGdZc1BnVURjSnNTek9DME5JRDhsOFYrWjF0WHNVNFJjQU9YdjMvVi9memdG?=
 =?utf-8?B?RWk2L3RYYURSZjRlSVpyL0tFUkNHYy9Dd1hoYXl3OFptcTRLbVQ1ZjlrODZT?=
 =?utf-8?B?djd5Si9aK09LSmJjRm50L2psbC8xdFNqbnd4cFp0TVRKREx6TkpDVEo1RC9Y?=
 =?utf-8?B?Qkdya2dHb2p0S3BHWnNnM0dQOGFUdDUrMVpEc3I1WlZranFyVzdjaDMydXFx?=
 =?utf-8?B?NTZVd1IrOE0zbHdNK1g3MGpnM1oxenFHeUZDcEdyNnRSQi9pVUtFb1J4dFE3?=
 =?utf-8?B?R1Q4VkMzQldJemlWSW9XQXpWRXB2YUhRVHBUaUgxcjZQdFRQMm02TjdxK1Ax?=
 =?utf-8?B?V2IzelQwU2NIRnptMVJxRjRCWjcvc3h2L05CcVFsaDBxcWNFZm81VUtobjJC?=
 =?utf-8?B?ZC9BYlZiT0VCeERIVU9tekhqY0ZBc2I0bVhVRnZXVUozZW5mZndIMUJlKzNN?=
 =?utf-8?B?M1BXVmpUTk56YndiemptT1dxQWhONUM4OHJkdGx1S3hyYlV0N0VhTXZMdHZo?=
 =?utf-8?B?T1JaOHd2SFg1N0xQUkw1aC85Wk15MlFmZHgrdFpuU0NMNUd2TVRyc2dpUEJh?=
 =?utf-8?B?VjB3WUxTNHdlVGJQYTNnblBJV2dQL2U4SWdwbGhQL1dYdlhXVE11akl1OG1W?=
 =?utf-8?B?UThGSG1kWFd3a0NTbURYMjhxeERGbTlwY0w1YUpUL2tVT1BRbk1jSlJNN0FS?=
 =?utf-8?B?M0Vsb1VxV0oxVkQ3T0cxay9hdWQ2bkdpRmxuRk1vSVJqcWxVRnpxQWI4SkVk?=
 =?utf-8?B?VU9KQ3FEU1ZLOURTbG0vZ09yNzNzcEdyOEFTSjg4eHFXT25rTk1nQVltYW50?=
 =?utf-8?B?MlRqQng2em9Odkx2c2NtQVgrY1gzN00wUGhwdDZQVURqSWZUa1VQTFpPSzNB?=
 =?utf-8?B?Y1lPZ01Ba3hUTUtIektHU21WM0YwUGtQeHVVZHlQbHNKcFhpT0hEWW5jVTRS?=
 =?utf-8?B?RU9WTWZCTmJ6ZUViZ3ZXSGxBczcySjJFdWJPRTlzRW93NkZxRU03QmVCczMv?=
 =?utf-8?B?R0FqaWpFMWtydHdXRVB5aWFQT1lpUit5SEVRNmN2OHk0UkU3Z1hWWmY0eXE2?=
 =?utf-8?B?ZnJ3eVVscWgzcGFBV1JWMHYrSkV3YTNpRCtlaEFYWHVPVXRaZWV3R0JBVXVy?=
 =?utf-8?B?SXR1bnVoV1liT1ZVUzJtSTZDeCtZY2VMSE1ic2RlejljUWQ1eUZ2ZGRNZnFx?=
 =?utf-8?B?cHRIbzlIS3o2eVl4WE9nUVhXbjVpZ0wzZm5sclpZWlV1UU1Ham9xdnl0bDFw?=
 =?utf-8?B?MCtyN0dCNjVOWitFOTdVWDVLN3BuZ3VRSXNsSjR1c0YxTG9wVEdwWm9NM2RS?=
 =?utf-8?B?cmc4N0tTNnZlcWh3R2pPWDZxS0pWRUFTOWdlcEl5ZHc2UDEyWXN6R0kySTY0?=
 =?utf-8?B?SHJvUElBTXhlV015QnlYRlFpR3FuZGx2TklqZ0k4d2d6NDNheG16dU5xSFRL?=
 =?utf-8?B?VWMva3kwRmVmeFFCWnUvZ3lSand6YzVGK3Yyc0NBUW14S2MzK0gyRzJVVUtC?=
 =?utf-8?B?aWE2Q2tMM3llNWkyYXFmQ2RQODhwWkpUODRmc0VHdXljS2VWMHdkWGljdE53?=
 =?utf-8?B?NWMvaEY0N3Q2TWd2Y0grVVgrbUJQVDJ3eXlzRnFiQ0J3NUYzY1MySHNtUGk4?=
 =?utf-8?B?RURtekM1cDd1SFJ4TGtsdjNxREs0NVlVQy92Z2locHVCeUpndTZpK1QvMzRD?=
 =?utf-8?B?Y2hHU25qNFowWGxkQVRCdGMwaFhqV2Jna2V2QnZkSUxLVXErL2dUZTRoZ3BM?=
 =?utf-8?B?bHo5UnhvdzMrMGNtdldVU2Z4dHlhMS8zcndWUDBZaU5mbDdjUjhBQTVRWjFt?=
 =?utf-8?B?YWRLRnM3TDI0d2pPaFNWSmMrbTlMTWlNMStpMkhjMjNhYldaa1U0NXRPakZn?=
 =?utf-8?B?d0pKb291RXhlU21ObE5nSmNSazRKWk1CSDl2bzlxK0dyT0pUV2w4dndCVmJr?=
 =?utf-8?Q?CqOADX62cQwCkHPEywTxbPRzHNOg6bqH?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:19:05.4960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b635f37d-1e43-447c-200f-08dcd2fb2f90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072

On Wed, 11 Sep 2024 15:07:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.226-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.226-rc2-g6cc7ac2e6d7e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
