Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1AC2EACEE
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 20:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816805; cv=fail; b=mBwX/6IZXDbFELl5UNaYLdfKSGICUcBlv0VTPKdkBKlWX1+36VGm2J7v+nGlBGi0/YQe4ChL+PcLtv2q17Jc4xGtIhddqUcq+aWxjy6MIuczpDB4TRLYt+gQ10wJg32VtGTyYPmqsILsT4qC/4S2Du0Z04S+Fw4FrS121rOtpJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816805; c=relaxed/simple;
	bh=Ze1s1KlA+qVQ77ZP174IC6/kuq2eG5aXMk/0eBciiaM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oUwu92/DiyQ2nbuEq93A7XSpiZo4fP9HxB4UWu9etiWO+y4zObD7klTLFQArL3hihb5JxeRbjlGeAOoy8r46HsPFfKqkG0YjFeEhTZDgwLqYaqgO9XNRGpRZIBtbsysn8h8y6y6+TEmBP3OMXIyhGHBcDIZKAucbel6KyzZaLCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=upkw7Vgt; arc=fail smtp.client-ip=52.101.53.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="upkw7Vgt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wxgp7sAcuZS6g8gQ0gvltdgRxiPVahMN44iECw5PgFWIpJ9IUB1gl9Vz7kJKNTQa/RO5ayp9PnDERdZdw5p9zYwW4q1JCRiaAfsBSJtV3OyeQygeeMslroFPjwzVX8Lb++chyyVrto77ZBtpudf9cQVMak5dY1MU18ZesP5uMmTibp4xgXiPAMQFjA+vEQ4wLxT0s1IIZtSC809unLsfCqHO6o1zp07J8zlnHYGbwiYhcR1KaDLfzQCsc9ZuY+aEMUJ4LYUdJfaSmPyypJkELe1Uh9JY3wTCSFC6zFDLNo6TAvY9Rkz8NW8uDIYD9ervrqWa/upp8Kd99YXNVEjLdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoAsyEDmVOZEP4TaIYRGZbuqBrZjwUujpQsUvKwQvEU=;
 b=wLBB5jFn53lOesC/mBTFo4D2yUR8nYNq/68+230EXkOYGzNK6V+s2XYn5OTzIID2+OwFa3OWuIQmcotnrPqaHYJS3d5FXtDd3M5G9TkPYEECY75qy9rxRBDhTvjHQ2hAl9SaFRxB4fa1YYj0TbxvymQperHgn8c0LOoAU7aXFSBG8C+pIlaLRQMvLs35bauhWC8t+29TezD5QN4xt0/zU1hZDMZxm/wXdhVFWyXULV1NDKDF60z9NSqwGONv8vy2okTsdIWi28NLtJfufa8xQLkONwiJ3oUq6R3C+FFrX2WoKBWQfqQARnejIdn3sOoFXKuGLMvEzg0xyKV5afXEig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoAsyEDmVOZEP4TaIYRGZbuqBrZjwUujpQsUvKwQvEU=;
 b=upkw7Vgtx2/XHUCxQDjLy+U/a4/4YlYwbK95PlwgzpdL5eLTiO+XDhroxVaG+DveII9t1TT5XQVFZ5MmfA5wmNpavFDvEE0KyJHi3H3ykPvfut58aj5Ry1+LHZJV3POQ4+4cJOB7bJLPvUIHaS3L0ztcNT6YfWUuN9URte5zs2woLJ5pgNilBOG2FVAeH1t/W9mxR/vdhrSDE9kMnjwrRlr5WIAZo0Cc7WV+4aUFe/cLv1NFgxdLDwb3H9BkRW/wZfsIYhJ1PljsDtB/PBl/u5oXJqzWIBfo26X680SbZN5dLydWQyGBt+/yuSuNkgp+5O/tEbhYphWHcrmPidro6g==
Received: from BYAPR03CA0002.namprd03.prod.outlook.com (2603:10b6:a02:a8::15)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 20:13:17 +0000
Received: from SJ1PEPF000026CA.namprd04.prod.outlook.com
 (2603:10b6:a02:a8:cafe::1a) by BYAPR03CA0002.outlook.office365.com
 (2603:10b6:a02:a8::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 20:13:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000026CA.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Wed, 7 Jan 2026 20:13:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 7 Jan
 2026 12:13:01 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 7 Jan
 2026 12:13:00 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 7 Jan 2026 12:13:00 -0800
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
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f641c0b8-0b45-467d-924e-757f0bc7ca86@rnnvmail204.nvidia.com>
Date: Wed, 7 Jan 2026 12:13:00 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026CA:EE_|IA1PR12MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: d966b568-e7aa-461d-3d50-08de4e2931dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEg2YmtBRXJzOXpOVjFheE45TWlIaUtHc09Bek05WDI4eFhIL1Q4VVRLZmRX?=
 =?utf-8?B?OFFQVWNXdW5zendLKzRydk5sV1RObDgwUU1FVEU0S1VBRmhpQnlVaWw4RUZw?=
 =?utf-8?B?ZEY4SUxWVy9YSU1tYW5lbDJPemVuZjFPYnZ3aXhtbDVyY3ZUM3AxNXNKaG1W?=
 =?utf-8?B?dld4bEg5TG8vVVhTMnFLckhpbUFDRUdtN2lUU0VpVG9aVzJDVFh4eEVWblhI?=
 =?utf-8?B?WGJ6S3cxdkpkOHJ1ZHREaWVwc2FzeUdNc2JmV0RQUGI4NzY1UDJyQUlrMTE5?=
 =?utf-8?B?N2Mzc2tMaEo0MGYwaHpMRzduaTBrazFTQU1jb2RUZkMvL01HSVpZcEJxVjZ5?=
 =?utf-8?B?ZTFJTFN3bCtKNGNXU1Z4bm5CVHZraGhYQ1ZUMmNGTnVJWUtvK2RGdzJLamRO?=
 =?utf-8?B?d211eC9yclQ1MmQ5Wm1yMkpOMVZ3RkVmaEdjL0RIS1FIMDExWjlSMUhwUmJv?=
 =?utf-8?B?L0s3cjlUY3RjMUQrZjNlR2Njc01zWkI5aUdKdWpmZ0plT2g5SEd4TU9xNUtJ?=
 =?utf-8?B?N3A3NFcxeXpPOG1MN3BralkrU3AwaXVRL3ZlWEFRam5XdXFRYm9TZmRXK083?=
 =?utf-8?B?cGtrU2t2WlQ5ZUM5aHMxYVRMSUp5Q3FpWkdHR3VsdUNpWVZnaUtlaURid0Iy?=
 =?utf-8?B?bXgySE1LTVZqRHRGa1hHRm5sM3JHdFFSTkN1UE9zRW1Wd0FucGxYbXRoWGJa?=
 =?utf-8?B?TXB3dDNEdGtqeERON3ZmamczVXVtQXVWWUdlaTNXWCtMWWZuZ0QwWU8vVUtK?=
 =?utf-8?B?M1JhVGpxaURLVXFFRUQxcGtIdzhSUVNlUFBSSEJWUWttOC9QYjVFM0hDN0pE?=
 =?utf-8?B?ZGxpb2xWeThoRG1LajlmMzRpMURGUDF6LzZRdE11RnpYeUsvNWhtN1lOSFky?=
 =?utf-8?B?bzRhSTd6NU9ua3R3OWlCU2dZWittNmNFUDFmVUhKMm9LTWVDUnJwaGdFU0E2?=
 =?utf-8?B?QXo2NGoyZHVheFM2dmVaOHBqTExvZktNWGNYcmxLRkxIYlhzdmZ2RHNWR1hV?=
 =?utf-8?B?YklrcCtKdGVuRDlrZWZTYW5OU29vZUoyaGJ2a2tIREpaTDlhc1lBV2NGQ2xD?=
 =?utf-8?B?WTRqblUvdk91M2NLbE51ZTRLRGRIdjBlYW5rWnpMdVlvdkhnNDNmZ0pzcVg1?=
 =?utf-8?B?TlBWUW9oTzRkT3BnK0F4aHA5S01lRHJ1K1Bwenp2SmNXTHpqQlhBVTZhZjNW?=
 =?utf-8?B?OUVIR2JsbzR2VTlkZUZubC9nRXhpTjFpaTI5bjFNSHJiZ2wxNThmVGFzaTZP?=
 =?utf-8?B?Y1BQNVJyTFdLYnVMeC9YMWgrN2JISkF3Z0xGZmp1eFBFc2VKSm45UkhXY1c4?=
 =?utf-8?B?VUo4MWgyNndXMlI3dXdJTHY1SEJuNHE0S1BxSEo1WVU5ZzViS01sY0NCQURE?=
 =?utf-8?B?QytEeEQ3czljWmMwS2s1cmNhVytxMU03cWFVQ1RWb1RKdzdsdWY1cnEzN1dz?=
 =?utf-8?B?UGN3MThrWEtiS1dJSTdScURWcjBnZlhqSGVWUjNSZmw2RWpuRHNESy9Xd1pX?=
 =?utf-8?B?ekJPSEFPNHZ4UVVhSnZxQVVOcGhvVWl1Z1VrSFV3andycFRxd2gxKzVNc2J4?=
 =?utf-8?B?ZGpYcGJMQ3dhZjNtNGQvNXRTRy9RV0tXandXOHFNNU0wMnRNbFdEZ21Obnh0?=
 =?utf-8?B?bWo0dlBMbzl3V2JxdG9mYnI1bmsveUNLYzZ3MHlLNlI1UmRKcjZ2V0pMUmZI?=
 =?utf-8?B?UFNaSVQxMHZiOC9XL1l6cUp5clY3bEhyRllxdS9oY1NlcnBtUVNPZWZlb21o?=
 =?utf-8?B?U1VzTmRwOUkxbjVqRXA5bXFzQmk1NG5SZ3VEUHRsZFVPRUxxY0U3ZjhBcEhh?=
 =?utf-8?B?aGsrOXZhbFdGRGhUU00yTTk1QkZKdThhUzJzZlMvK3RUSXRObmlTSUZKYk1D?=
 =?utf-8?B?a3BDUWRqS1Z6Y3JiTzFLZGRYVEl5YVVGT0RQNVhQMUxEU1Z0VXdQSSsybVFS?=
 =?utf-8?B?K2ZMcjBuS2pzaEE0MmN2KzhWRjk1ODFoa2Nodjd2NHhWQ1RPOUIzSlIyZzdx?=
 =?utf-8?B?RU9GNUhyTWlEUzRmRUZjNlNId3R1NkFIa3VWbVJYTHh2Mmh6R0NUTGFWdUFh?=
 =?utf-8?B?SjJSRU9CbU1zckhocFZMMTJ4enV5Y3lPdVdsdTRyMEtCckZlb0d6cVEwWndm?=
 =?utf-8?Q?pcP0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:13:16.8999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d966b568-e7aa-461d-3d50-08de4e2931dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026CA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161

On Tue, 06 Jan 2026 17:56:22 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.64-rc1-g98ddcf2ac4d1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
