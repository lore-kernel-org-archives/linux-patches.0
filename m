Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7780418BC0F
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125555; cv=fail; b=mmq4TppXWqY7WoXw5x6E6s3wJJt/tEHEF+3MQV9BqWOezTfP6NxaMbbyI4o3dd+rqQHQPpn9FWgUKg36FpthzLFwacL1BkcxbdXbzEZqUuT6Zy8F9HTQJ2fERNcC+hyrK0QDCsV/3O9OCqhzD/Lp3sIpiuMM/85wsSzLG/d7haA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125555; c=relaxed/simple;
	bh=SKHEs01/ZU0GkTYHyNXoYzea5A8gn0MfTcNsBfS83aw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aexLyIlWQQGvV1W0YXydBWcmkYOliAF9RwEqRUm+TaIMxEz7xozFFphXUypm4UozJqYyP/AR3ZwN3unorjJmsbUjjyOsSTp7t3IatRKXgel1Zpy6Cwl9Ui7ioYG17IZf+ygyBL7ejIi8g9I07tq10F6I+MRFXK78LRCJmnYNWTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cru5v+YD; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cru5v+YD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sd7hqDnM/LLWIqCOJsfcSNHx+VB0f9LVC4sCwcp/+IflelI/jxu8zdeAL+D5WsL0aFs3PkjT8GPANUijSKaY41Hn69bglEWbifD05zNeGaseZ6XSIHcakDfNxUDB8jTdxDISWFQixD09mmwGEzUtJc4eKlPUWx1tHL6aC/4AFgZbDE68SkXA5fal9bqoUKrUfOXKu101Ik9uuP2lIen/w/tPofnLsQVBGW+GB5DD7fvDLC+GHnKuoCGQa5MS6sDDWWpaaR+OjCw4cdYOCvYn23wrGbsUynrIeWQXPEjBtARJjt/HrKoLy5XXVDrUK4/Pglk9xUYnfwJ3N0P+pH+v1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvwVDZknHdENdHtyUTjQdEUqvotXzIj9TNXP0OukSt0=;
 b=TmAWK0n7Wkh2FKFOeWxb4OtdgEsueDdDOxlv+56DAQF2+bhib2MqBHqmDN87RcA/qi5RrmeZxM3wzUlozhZNqg/uBtuo7o0N427Nik0ukyO1AWl0Z+rvmKsiJThd+spzQfnY5rXLL11rN5H+filW62xmWGxdXjDmFMFQdpMS7YLtPopRiMDpkkqL5zzwgB5Mwcr1Q2VTO7ZMJ44f7NdULkoX8Y+rU5IdF8qZkSm2kw0+tXusK3xXcIZcYWDubpvtm7A0bawTyvEYKszDPFbFtuSTG59eDwwscF3T1pvNVdY3nfM1N4ACIHaLsKE1TBWIbERwuuuBBUkCfgOO9fvGmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvwVDZknHdENdHtyUTjQdEUqvotXzIj9TNXP0OukSt0=;
 b=cru5v+YDZwU+lnaoTKPcfytiVCEV3e/UFq8gt3D2w3bcOA2bIjdOVZFWDdJbw/wFD4hcTU3CtKSjATB6MeUzxJ9ibkcc2NUu0stglvl+JHGzf+Kl/x1M699GVjOOQAGIerCJBE65n4Yuz1yX5ZD7EYlrFEDJ+gnbCwDbSgxlZLrdjutirG7p4Tgw1jAOPh26tDkcI0iNwg9U0xKFvnSgHjAC7msV+sIInr706psNMHRekp+TMCTMEC1EajKhaJv0/Nz3ejFNlBYMPkyahz1UZSU8k7Y5FEsROpGanU0I0CJKZ8OyU5a/IVI4FqCw2g1wrlf7TUwee7aUBqD122CEEg==
Received: from BN9PR03CA0742.namprd03.prod.outlook.com (2603:10b6:408:110::27)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Thu, 12 Sep
 2024 07:19:10 +0000
Received: from BL02EPF0001A102.namprd05.prod.outlook.com
 (2603:10b6:408:110:cafe::51) by BN9PR03CA0742.outlook.office365.com
 (2603:10b6:408:110::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Thu, 12 Sep 2024 07:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A102.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:19:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:19:03 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 12 Sep 2024 00:19:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:19:03 -0700
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
Subject: Re: [PATCH 5.15 000/212] 5.15.167-rc2 review
In-Reply-To: <20240911130535.165892968@linuxfoundation.org>
References: <20240911130535.165892968@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6582d98a-0bae-4361-bf23-fe2ee14f44b3@drhqmail201.nvidia.com>
Date: Thu, 12 Sep 2024 00:19:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A102:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f06858-cf31-4be6-7613-08dcd2fb31eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXQ2VWxWYVkvODJObGgrcnovazVHNU5CMHROQjhrRTBTWU9zUVAvcTM0RWQv?=
 =?utf-8?B?bVRSNDVqOUMwUm5leGNKNHAxUXpjaGdjb3FjNlV0NytBYTN2SFd1VWtSNDhU?=
 =?utf-8?B?RDBnK0RKcnArQU5IREVoSGJUSmRRUnB6SSthUUt1cHFpN2Y1ZTQ4cHVnbm1G?=
 =?utf-8?B?VjBiZU91SkdQRzEyeXBRRFE3TzV0L2ZGT1lYSWFBcXp5NEZjVFdqQmZnc2xa?=
 =?utf-8?B?aU1lK2xiWW9KQTJ0aWFOOU9KVCs5S1lhSmQvQXh5MWtiQjF3cGlDbCs5Mnpr?=
 =?utf-8?B?UEtKTFJyQTM0VGtSWWNmU00vTlcvYmRnTkZFdWoyM0pxb0NyREsrOTRnOTRz?=
 =?utf-8?B?cTFDeW5pb2Y2Y3BWUW5PQ0pRUC9lU1FCamZWL2dFekdaU2ZTOXJMcjJoVElV?=
 =?utf-8?B?N3NkREExZVhwVG50cG43UWlXNTRHb3RpMDRMZGUwd3RxTTk5OGFGZ1QzNTN3?=
 =?utf-8?B?UFZYMkQ3cElYVU5sVFFmQUxZRUdHZmJRZjVrSU9xTkJsb2hLNjZuUWcvOEpZ?=
 =?utf-8?B?alB0T1BudzY0VnE0MEZieG5yWEtnVWlPa1FNbDBia1JTQ0prTW5KQkdvNXBU?=
 =?utf-8?B?aFIzOEgrNDRVcG5xNXhSV1VUbjFSNkhyVnlaNlJTVUN1Rzl5dlR2MXBva21k?=
 =?utf-8?B?OVUyMDk5QXBXdDBpajI1aDJjYVpaMEV0dStvUGRZYUlYR3hnU01yajJzRFU1?=
 =?utf-8?B?V1NhRHBuTmNINHBpeDVucEhMWHVJMjRBWW9qQ1pWcmkzVjRZMXVseENQVXRQ?=
 =?utf-8?B?NjA2Q2F2dE13NGMvY3JIT3pCUjhvSjlTOEhNWXIwNXplck53UUpEaWFBN3N0?=
 =?utf-8?B?YndDNWdCbHcyVlhLTGNOTjVjRndtNHYvK25UNTJhSzBsaitEaFB1WFJ5UytD?=
 =?utf-8?B?ZTJsQzhBT2ZiYnd1QS9MSURQWXBUTExlTnBSaFRwRjNJN1ZBT20rZ2Y5ak1C?=
 =?utf-8?B?MGUzaVY4THQ2WkFXTGxMY1BZNGMvUU9UaFMyQWZsdTJmdzdielZwbG1CdEhQ?=
 =?utf-8?B?YkdnQkxMSCtlWjVQcy94dlZMVlRIUXg0cWw5SHVTV2lhTVpkL29ZNXZ2d2Nt?=
 =?utf-8?B?Nitia245eEVZbExib2VWeW5tbi9OdkUvdHpsQWc3ZVBSMHpkNkNQR0NFUExR?=
 =?utf-8?B?dXNpUVh6MytuTWdjUDZySllWUlZXcFE1cFozdzBicjBYaGNud2txUWU3SjU0?=
 =?utf-8?B?QjErWmRwUmZPUkRTUnJYUWtndXA4MGl6Y2tobG5zQzZkQ2lKTXpZTXlpcmk0?=
 =?utf-8?B?U0wrK2xORlF5Q0phWFNyclNaYXBGdVV2TnhTTEs4Um9MMHVRcmdSblpQY2gy?=
 =?utf-8?B?dXNwRjBIUkFUUTI2Uk5xTCt3WGpzdVNhVzdSY0dPaTFIQUV5RFpldDR1dml1?=
 =?utf-8?B?RWlLRUZtV2ZHdGl4NVZXV1R2bGQ0MWlSNkhXT2czc2NwcUNSRVNINEtFUC9U?=
 =?utf-8?B?TkhxeGFtZFFZdzc5ZjhHNEllYUNMbXRFK202Uy8xcUR3Ulppbzk0VFlvY3ZQ?=
 =?utf-8?B?SngyWEFlcnRSYWZtbkx5a3JBbzBldUF2UTFRQk8yRGNTeWkwZDJzdklEeXpE?=
 =?utf-8?B?UlYydFBEMlVuSjhrOG01MFNVcjcvdW9lRW1Zd3dwU2s2NHZvZkwzSjdpUkUz?=
 =?utf-8?B?Z055bXRRQ0JHaDBrWGRFSUx0c0c1eEpvSUZ6bXd0aC9DNk5PbzRzTXZBZXpZ?=
 =?utf-8?B?WDUzS09mMmJKSWhkWEc3cTYwMVR6TG9uWmxnLyt3Nm5YcFF2a3Y2Q2lDLzRk?=
 =?utf-8?B?WFg2RVcrSzZJeXhXOWZWWkxPQUVJNjFmdS96ZE1zZ21lTll0bzN4cWtGd0dQ?=
 =?utf-8?B?YmlxNjdMMVJHd1hUNVFaT3psYk1PcC81eVU5YU9ONGNMN3lWU0trczdQaThl?=
 =?utf-8?B?UXUzRVlVYzFwUkdNK0NJTGpoa2E5NFY3RTRENHlrSTUzL3V5dHAvOHd0Y2VN?=
 =?utf-8?Q?1L3RgDDWD/OFJWZ5wjFMVySkCObQdLnX?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:19:09.4344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f06858-cf31-4be6-7613-08dcd2fb31eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A102.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946

On Wed, 11 Sep 2024 15:07:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc2.gz
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

Linux version:	5.15.167-rc2-g0891f8b0a4c8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
