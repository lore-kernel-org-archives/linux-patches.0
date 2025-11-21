Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2474D2C08D0
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742523; cv=fail; b=pBx5lSDVO2XiJDGSHyFVXAUwfIYop98EoXrq5RpYgYFr9SXKdINFl8jKW1pO2HXraVBSLl0Jc+xY3NnplPwa/gqW/O8KFpPtoUuYNAxUwBNTgeJxBueGZKV1gJQqhzjCIi6vqUeW9Zk7uupoGXtZl/cu557ZoFhu87yk9mt6uaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742523; c=relaxed/simple;
	bh=M4oAHXhPrA7eRv/XIsmNXJ9zdV46S/ZYPrdLOazA/ag=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=D43pdro7xGsfO0qiLvtiMyf/cHnbpjrX7QMB5I0zqHcJ/cC9athnko+UPG1zNJGUCZtBTzt9NgJ1SCdpYlLEKv12W4KuVGG7HsoROjqwV/pp/1lPAFSw4ikxVpzqQg1XS+pHs5y0Gepo5KJVO4EgBB6uNDCAdHcbxbOdyu7RQvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UzyVOiTd; arc=fail smtp.client-ip=52.101.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UzyVOiTd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKUI0QjZrvcLLm/mg5ZduwQf5r3MmFXXQpHwuFBP2aHlMm+oPBOuPfOca7/0BMWts8x2j74F4nEcKNkpj8rStdtmtNrMHlFDD+GbJLcF3TGCpEaj5UP5nsy6f3iEPaDjObvyNEvA0WYbHmhgGcXKSB0bjYpwydSV+s/5wC46je6dpD7YUUBgzd0lhLkp1QBTdHX6OVBBNSeZygtZpThE+Enqedgfa/XSOoXNq4MvAm4vSRVie+cYLU2KGNJ1H/Fn08DqqIJOesNoqY+u3hbs5auiv4kYjzQHQfGh99Pzim/0TGzB/7busNxP9VE+aB1HnnrVYEWe1SXnqiCPttAkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0usIkoGz6iy37HVF1JwfK3ivuxE8m6X2byOodeBC+c=;
 b=XUSMLkpbGbfS/eWBybdMiXUpJBsGt96hbpw0L9HfccwxX+rINRQ6ZwZXtjhdErEZhLyyMB8AlTaGk8byhLLh8k8y7TXvw0H/x6wBS8PukJN/fHZeuqp9IlajcBYz6/VP5MGUuF2H4UfZj/m4ZQ94ZHrifJwY9AgqqDkrIXsUbmledSKwAfHUV7eddiPb5VZKDFBBImTPXE/GAtqnwCgrGNxGtXHqceycxYZgdiZxL02xm/1Bbw+otu6fnQYmLyuYzD0CIgGZ3J1BMv9uMMVeqv5qDV5LCpI0ATfgcF8Tte+6LoEUxc9RlFeCRzA4hqxl6sKuB3s8fEGxPM9wY6as0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0usIkoGz6iy37HVF1JwfK3ivuxE8m6X2byOodeBC+c=;
 b=UzyVOiTdp6sIstJsavNabZl7qQ7P36TjIcESjGn8LcaK43V27W8QNbDUJRhXKV5r0zNOcuDOEhsL4IkdbP1bfPLkvfEf/BaSGlKlgiadr1G2R/tq26Yle/oJdNnlrZmm4Jpl+hxqIAGIScyj629W3szZuybmNpRXJJT6er1KM/hDl6Zcx2QebCLOUA9U2j9IN7htxnZF5OMJkW5pz7kkU9GdS6gptuAVDUCHjSeX4Tf0QQO3L+PoYR9Q5LlI9Isq/NlOAl4DnA+xeaaD9ZMqt+ioPsJF5b7hcTWdCRwQz8tFpwGb0QAPJyPvAf/wPZ2AiNikrV2pXzZGpL/zlPE8Hw==
Received: from BL1PR13CA0388.namprd13.prod.outlook.com (2603:10b6:208:2c0::33)
 by CYYPR12MB8990.namprd12.prod.outlook.com (2603:10b6:930:ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 16:28:31 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::30) by BL1PR13CA0388.outlook.office365.com
 (2603:10b6:208:2c0::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.4 via Frontend Transport; Fri,
 21 Nov 2025 16:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 16:28:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:11 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:10 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 08:28:10 -0800
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
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d941b1d4-d96e-4b31-8299-aa9cb4a44472@rnnvmail203.nvidia.com>
Date: Fri, 21 Nov 2025 08:28:10 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|CYYPR12MB8990:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b41677-8c9a-49ae-9281-08de291b0230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkxKMnlzbU02Qk9yNm4yVlVSVWVmM1NHNTBQZUF2UmJPc3g5ai90VmhpdmUr?=
 =?utf-8?B?dkdiY1czYVBKcDlTKy9XQVdCcVVoMHBMeUFiVFhBR1I5RVB4NTY2dWg5UzY2?=
 =?utf-8?B?cHRNL0dEOFNjUGVVUXNTWWlTMDdQTzB2Q0Vtb0YwNkpaWU9haUljU0dxTTFw?=
 =?utf-8?B?MkRzOW5BS0Y0K3BVdTlRUFJvMU5LV256N2RIbjhqOFlnMFlwRGFzQjdudnB2?=
 =?utf-8?B?cm84M3JWVlI2MHZvUDBkSk5YaGE1NWt2LzQzSlNIa0lkeXVYSlhhNDZ0eGpW?=
 =?utf-8?B?UnUwQkZHaHgyMDlPSldaUUc3VjJSYy9jQ01Uei81ck9pV1MwODBxdUlENnJ5?=
 =?utf-8?B?MlVXK3dpR1AyZnNiUjFKNkdXcnRJSjZ2MlM5V3ZuRGUvUzBWeXA4VFlzdGZx?=
 =?utf-8?B?UTgzUllSNitoaVU0SENPSGJlNWJQZU1mU2lCSDlVNG1saW5BY0FheGJvUFJM?=
 =?utf-8?B?UGR5bUgxL0pTNUZzaTc4aCsvL0FnVThibGpFMUF6UFJFVHhjMXJEcXVGODN1?=
 =?utf-8?B?MEVqVVZabmU2SHkxbGw3dnZTeFg1SG91SkN3OWFLeS91VDZYZ1JDcnovQlpW?=
 =?utf-8?B?ZkN0UWpXRllPQU94NXVuT3pwOUVjUEZoTFJrYk5oNnBRWHprT3NKOFhTcWtF?=
 =?utf-8?B?YjBjRDNZSHFzYjV0SDl2VWZFbW82L0hoYTNZTFo4U0U3bCs1bUlJcTV0aU9z?=
 =?utf-8?B?c280ODBBK0JMOWI3VEQ3L1ZibWdwSExMMnFIZW1HemtCSUdiUU5sZjZrL3V4?=
 =?utf-8?B?MTdUbVovMTEvL3IxV1QvWVE3RXVXMjBkM2xrelhBaUg3b09GTGpHYThWY1NV?=
 =?utf-8?B?WVJDTDk3c2dFVmQwNzZUN2lqMzhVdnJZYnpLQXNkb21HZnhjd1NTenUvWmc5?=
 =?utf-8?B?bExzTXBteWZ6dVJjQTNUQnY0VWFPamp4U1MvanZqVzUwdldld0NIZDZ1UjVp?=
 =?utf-8?B?OWZFL25jVnIwcXBGR2hONEJyRFJoQ3IrT2NzZzVwcFB2V0lBU0NVMkM2L21o?=
 =?utf-8?B?ZVBjK1k2VlBZVGhWYk1pNE4yRk1kUXdvUk1XUHh3Y0dCcGxRcVpjWFJHVTQx?=
 =?utf-8?B?Z01MZUowUVpiQkhteDluWkh4ZWQ1SnNCRjhhYW0rTEhmeUdjdHZlQXAxWWlO?=
 =?utf-8?B?WEpycjMvblVDaFcxMWFKZGlpK0swL0lkb2dNWEd4cjVVcTQvdld4K0JZbVRm?=
 =?utf-8?B?bmlHWnNyL1ppUmZzNkgya1Zrb0ZkOTRHZVlNaVNIU0ZtUEc2ajFLNVAxZkEv?=
 =?utf-8?B?VzFvZ3pZZFdZc0lIUU0rbjlCUDJaUFFGSHZtUDNLcnRkYmtCUDcvazNIZ2lw?=
 =?utf-8?B?NVYvbGpkaUdpeFZzb2NLMHhoNE9lcmF2NUM4a1pUZDE4ekdFZUF1NVlRR1lq?=
 =?utf-8?B?a3drb0RLNjNGWk42N1FwZ2xqMHUvNi9qbFhFWGdaUFJRSnEzWkFaakIxSnRz?=
 =?utf-8?B?L25YWHA5V2UwcHZFOGowNDFtS3F2T3hEUExXUDQ2TDdmSTgyWDJtY0t3c3FZ?=
 =?utf-8?B?aGhlT2thQUhXYW03aVUzd3JTWnVNU3FIeS9RcHJUajFzUytuTWhsVFZOVlUx?=
 =?utf-8?B?dXdKRW93L3BXbHM1Uys5U00xTjNSQTcvdlNMZnRUUEhzTE5MVVJ6RUtZbm5t?=
 =?utf-8?B?UDZTOGRuam9yNXI1UjBNK0J6L3FHWkoxTFlCdFdvOEZ6OTJNTS9GbENZSXV4?=
 =?utf-8?B?WTV0TGVuNCtQd0srb0dRdnU3L0pDU3FNWGUwQlVrZXJpd2IrL3FoOW9QbUU1?=
 =?utf-8?B?bHNzKzNacmw4OGNJbTRNRGtFbjdZWDBRZXJVRU1yM0k4VnVrUG8wREFLNU9y?=
 =?utf-8?B?dGQvd21LM3BqOVJsS1BLTlgwcEYxN0hSN3hnbWM0YUtuZmtJZlFUcWRoNnE2?=
 =?utf-8?B?RHUxR1l6UUxXaEo4ejRzTHJKbk5TZTJtcEpoOGIyOW1KWG5GdVVwUWVUZjNC?=
 =?utf-8?B?SG55Zk5iR0NJUW51VDc5NzVFQjY1Ukk5QThlcHR3NHE0ZWdHN2xSd1dBektK?=
 =?utf-8?B?RTg3UnRZcHVxSUNVRGgyNlJTdWxGQ1gzVjJqMktqbElxS3NkNHQ3bmNvdXFP?=
 =?utf-8?B?Mi9xS09ZRGxmdldZM0Y0M2FXZTkvcTBJaFoyNTQ3VzRaZTZOcWNYT2N2RXpi?=
 =?utf-8?Q?iGmA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 16:28:30.8944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b41677-8c9a-49ae-9281-08de291b0230
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8990

On Fri, 21 Nov 2025 14:04:59 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.117-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.117-rc1-g69eeb522a1e2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
