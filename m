Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE65214228
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764684170; cv=fail; b=NUWos5XmtYSyQZ1leQ41Q5tl8VdpE5XzpzaqNRTluRiZ4ThwSXZJ0UTL66D+6zc8Go5dLHtm0UdE0PSSFIH2Jr6TltBRSYWp7bpprNgLh3yxFjTEdbxocHY6+EkoRCdoKz8xHHYkMk+gi0kUdv3kAMq0HqhazUn1DfNrj5zF/T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764684170; c=relaxed/simple;
	bh=677btk1OwzjQvHxD4TIIOWturcfi2KfAio/kwnU1p24=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SGCcRyej2gGCo6ZTjUhD2N1a2ArnZz7SO6ZzNvVktoGkraM0NzGx48kbZ2KWYAIYDLkc4by+zS10JCq94fNPgS4Fj+sKQz7RS5FOp4CTI79OsnDzYf9f0WGMDrOFYQFyHYHeak6re2io2XLYgQ4tOL/Z3bdC/xdT3vsCZUbqp8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oPdEZRE8; arc=fail smtp.client-ip=40.107.200.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oPdEZRE8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtEABh3ma7J5GdX6JKBzAAIgq2vAH8xV30MzNY+dEpdlFqz6QAxjT4Y70Z/13MwmlXTVQSeI5ikOUsV1b36eoIOLgQw7acdNeKJhw/fNPzMvZ2y0EpKyvaxfvK7DuIXDRzBRiWhWrgz70O2w0qpUqJXHHq/ZtH0gKYL0MgMHVChefpN0kZsVNOqRZgJ8KdDlKG8Uy2FgPKFqDLoO87ClwVU6b0g81/pCZHIiSsDv+gLmWhQBHkQrfmIVWIOfUTiOMMBqJS6Azgve+pQxQAvR6DySLfzYsjdh/Pp4FTE7xDby6kESKZnj0P1ObLdMBzdmbuOwHBJenkoIWxk+12vehA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEChPb6rgDeRXk9d8O7R1A4pN+Ah019FgkjCSuT7xXk=;
 b=tmjM8SWiwmz+rJrvRtsM7erNrCEsPjOMlGeoSDUUbnj36uCL/venZuYsydr8BpKawqNYCDEHhcRn2OD5mYMSwbsirtbcEFlDfJTjWgJBf5F4PaSvsrorwmR5n0RbAZoiHt3gIjR5M9HPEj+Wwp8aJk8P+R1GAIEcDIY4oDU7D8bEMHlFqvbJjZ0Ahv57kbSNphr7YEEAtJVhZk3vTIcfjA8CbcQXWpDGSInuSwIj1h4p2asZec3Xk4NTi91sFRiPRJ0r4yui4Hv5Ea20Gwh/GCptbHZBTzRuKpd8cJP6jF+OBfBv7I/kkZs54IzQC91I9YsdSjSK3oaTDW5VT/XnHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEChPb6rgDeRXk9d8O7R1A4pN+Ah019FgkjCSuT7xXk=;
 b=oPdEZRE8LOVi5brsktCijvINag0s0HQGJdHse4EY+7B3DvFuRZEInf8S5Cmr0DKDV9E1xe4q2Y07TpP/lrwaEMIQhMy1vM0g8csDA5QgXmokhIt3eLp897PmD1p1wD3jxa0tcbpkD4Z88makSOtfNzzUxlERXYmwB+lJEywPgJx8kBBa0SpUEKx5XijJIhg5Ts6yC8SyQQ6bCYWS/GJbF7dSTA/XTT6nUrwcD6+nhajv+HAbgngn36xkCFAIOmvvAhTO8r/5K43xY+8xNcEeW8xCJ8GvLTwhWckoBMtSE+tiISVoE5KaNxe+FutaOJxNj32EVhQhO+93J1+GlR7V7A==
Received: from BY3PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:39a::27)
 by MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 14:02:44 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::df) by BY3PR03CA0022.outlook.office365.com
 (2603:10b6:a03:39a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Tue, 2
 Dec 2025 14:02:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 14:02:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 2 Dec
 2025 06:02:25 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 2 Dec
 2025 06:02:24 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 2 Dec 2025 06:02:24 -0800
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
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
In-Reply-To: <20251202095448.089783651@linuxfoundation.org>
References: <20251202095448.089783651@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b50bfccf-5833-4d47-9fe3-ee8903c4545e@rnnvmail203.nvidia.com>
Date: Tue, 2 Dec 2025 06:02:24 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|MN2PR12MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: 23f6c949-97b7-4836-e02f-08de31ab76c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVUxR2tTZURrN3NFYkxUK3RHb0lpbTUyZVg5WmNIN0dWRnFRVjVsMnduRnRF?=
 =?utf-8?B?RVlNQjBMaUVwL0kwR0c0U3lZU2FnWU5CWnFkajhlZ0o3NFo2QmpKSzl6aUJh?=
 =?utf-8?B?OU9hTmJlWGJId0lNTXJVUGJ3Sm1tZVVsR2dOYUovay8rV0NXbVRocVpBcENW?=
 =?utf-8?B?bGJVbTl0SVhZcGgxNVEvOGdQMmE1RG85djVmaEtnajJuQVNIcUxaK2ZPN25W?=
 =?utf-8?B?VldQcVhERnRmNXFTWG0rS1NqZzlsTm5VZVA0SlZMaERRV3JKNGVtYTFLaWtN?=
 =?utf-8?B?ZG5nUGhrS1JOaTRJRlVWdVovUk9LNlpRbmh3eTJIa3NpUEwwT2ZONzRFbDVr?=
 =?utf-8?B?bS8vOHVhSmRBRnlZd2V0enlSQkNGWWFRWFY0NWxJaUhNTUdTaWpqZHRpc0E3?=
 =?utf-8?B?WHJ5dSthUFhta2U1eU5PWloxZjlLTGV2VzAxWUNPMXFzRUlzMmVSckFZeSta?=
 =?utf-8?B?LzRXM3lNSStUK2VnNHZSeWRZMm9OeFNNTUV1RFNuU0VTanRTMjRWbmR2N05V?=
 =?utf-8?B?R1FWVGhaTDN5dGRBVllaQjRKZ28zd3NiNHFxWjVzZVJSSU8xODNEbEM3UXdK?=
 =?utf-8?B?VzVYSjFCbXJvWk15K0k5L29NSmloRVJQWHdYOXRHTUFaeUVCRzhYNEo0MWsr?=
 =?utf-8?B?VjNxZU55V3oyY0pkVUVlRFhpek1od1dlazB3ams0SjBPbnZJciswQ3NpSGo4?=
 =?utf-8?B?N0RaeGwwS3ZMUnJzNFYyalJvaFJBOUx0TzVVcHBsQm96TCs0aVRqb0QrbVdr?=
 =?utf-8?B?TnBab2x2Ti9Uclk3U3lUR2xpenZqWWk4bCtFNEdjQXdiSFJNSEF3dnNzTnFD?=
 =?utf-8?B?MGtEdkNNTmE0SS9xeG5tcTFUMnJKVDYxTnFtVmFSZ2k3VlhiVTlWYTN2TjVY?=
 =?utf-8?B?RFpmTnJuOXQ3T0dmV0FYdGZzNktCM3F6b0ZJT1liSFZjZjluVmswdmlYY2FW?=
 =?utf-8?B?VHBpV0kySG1qazA4VVZHbVBiMWtjLzhpaDNpTzd4NmlDeWdIaHhxV2lyZlBa?=
 =?utf-8?B?SmNzc09ZdzVjUGx2cVZlTGM2ZGpRa1FPRWJOaTliZkhYcW9HbFdiWVhwUjFx?=
 =?utf-8?B?aThBTWMyVlNpWEkzcTgrSkg2L0J4MmVOeHRhZmVxdmQ3WlhsVGd5bFlxZENp?=
 =?utf-8?B?VU1YYy8ra0xaMGJzVVJqTFRzNTBLdWdxMHRJWDNXb1ZnWU50TXNmcm5HRUJB?=
 =?utf-8?B?cmxzRlFpWlZuNDh5djZCaElhZDAxSm5pWDJvUU93SFptSHR5U2NFV0o2MTBN?=
 =?utf-8?B?MTJ2aUtVVEpMTSt4VWdaS0NKZ0h1RCtGTGp4Wk9XeDVnTkk3Z3ZMbFlQVUpv?=
 =?utf-8?B?eS90VlN2QmhkUUxaTzI2WTZOYkhCdnBNbUd3dG54bC9UZkhJZ0JOVmhNMktt?=
 =?utf-8?B?TE5RVWZTUGxRRmQ4YmtlMWRBMkUvL3g4d1dSS0NrN3hWUmRiMXlyM3RzVGJH?=
 =?utf-8?B?U2pNbjk1Y056WG9aZmFId1pmTHdMc1VXM1FSZGVhdXV2KzI5amI2QnBJSnFO?=
 =?utf-8?B?bkpadHRjWjI1RC9tbjM3UzUvejY3SlRldDhETDZwQ1d3bkpNNUtYeGM5Z0VQ?=
 =?utf-8?B?dU5xcUdFNDMzM2w2S3grYWRqN3JrVkJ0MWY5NVArUVhvTEljYmJTYkhiVll4?=
 =?utf-8?B?TFBBSDk5Tm5SQkM2Q3dvditJQUxiMDQzWTFmaTZFUUYwbmVSRGZlZGg5a25N?=
 =?utf-8?B?akZOVGluUGRqaExyM0tYeVdDcDdGRksrclcwWjM1dGR3UmZBdUY4MkxPMnhK?=
 =?utf-8?B?MFpUUC9lZ0FvWVhwR0dNd2ZnbDU5ays5VnBnNmZ3cG5VKzNVRkN2VUpRT1Nu?=
 =?utf-8?B?R3VXeHJ0aXplMjk1c2ZHeWkwSHdzbFllWi9wQWtlN3NDSGpOc3JUbnZYWjg4?=
 =?utf-8?B?emVpSHp3ZTBWRGdTWWloYzl4R2JrSjBlTEtaUWxHVTR3RUlZSkozMnA0M0tH?=
 =?utf-8?B?YjM1Ukl5QUNNbFRCR0gveldUZjRyZ2g4M2FYWmZBUlRtN2RLVVZzMTlMcWFD?=
 =?utf-8?B?M00zUnpldEE2a2swc2JWYm0yZEpqYjlJc1RFem9IeXJEc3gxZE0zRDQ0eTZs?=
 =?utf-8?B?MVBTYnFMWDNXb3pxWFd5UzhhM0Q0dDVQbTAvTS9SVk1ubW85VjNxWmVzSTF2?=
 =?utf-8?Q?onT8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 14:02:43.4331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f6c949-97b7-4836-e02f-08de31ab76c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080

On Tue, 02 Dec 2025 11:11:16 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Dec 2025 09:54:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.302-rc2-ga03757dc1d0b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
