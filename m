Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD07326D43
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758632802; cv=fail; b=ANeyiaLnDHGnUmKrv2ufldDVr+JV9fIArIlnj9dGOoeV1mUQnD58QgAovxGnxwpq6iSxDITyvq6LfE3nfJeVINXU32ievJBX0sRCcXf62iwApZzubi0NITZyQBomebJvtpX5H/k3teiIziG4Xo5aCcgirqe5mW0ribuAskkcRTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758632802; c=relaxed/simple;
	bh=U4nTsXKqRaGXf+34Ure9FHNXWcRPnrE2IoNDR0/N0ow=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Q6MvvAlYhfT+JiMTLm8dLqJsSO1NaFroDZy8RgiF0Z00Yy4HXgWt5E4A/hQvo0NXadT7AX/4SX8T5L63SVSBKOmkAUdI4xnRhaICJri4yG61lO8yQL9DcB3NL9Mytvi0cMxos865q7OhVwGEZdjijS/tsWgqaz20JEcFF7ngaHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EsxjspFT; arc=fail smtp.client-ip=40.107.200.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EsxjspFT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tiu8YIxLwppzvywAzf1SSAmz5trhYCh+tP9vxI+Hr4ZF0M+Owx6/CoNif2q7ZV4Lqz9ILjK0qKA9NiauhJAcuRjNs7MhiwPOlamEsvIy5ahd+ONAfcCNzfiVUb6o6QdgDACveXa7SJmqmbmIOZt5FX9FJGuiu9gEr4mgZb3bUJxF7qkVPt099vtPm+CR9kJuxW7Bo2AtXBWx2DFpMNnrJXu/tQMc4WF2UlBAN/AquP8KtvsCLS1r/Jjvhw67vMZrc+4KlIPZrZq4w9OwFYMemIBTcBcbsV9Cyy8TZZhFCCQzVk2wHtsDOc2/16ueHEFHqlmy7XXPs65/aqsMteXZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LtQe6kdprHy3+XsyhAPPL9jAq4NSttIo7IUr6jcbx0=;
 b=LSKIPNzxhmrpPcYmDX+JTOCTx7eEIRxdkLWG2entTKT4XxKlTtb8Pdb2J/GOvX9mSR+NmOIJnl5l6UuLwcuSgZmRF/Wclx4udF1W5QVPjxZxUNfNYh+6+WbO5yLbKKluJzDPfcWFQO7QtyCvDrGXaV/7JNaqae+TYfGtn5GyE7bLsLTqcFtDNXOz+J7onSLIHEGH0UzTxgrZkufD0wLEyRm+VhH1uu386zgRjnmB8Da6GPVc172sHjraCFrOWyG5poOk+jRa+kEStFCQZykF4/sknq/VYa+hzTX7yfmSDYlGBJpWTzxI209QPFIx3JGx1OtoNcSVBYcDsq7wGKyYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LtQe6kdprHy3+XsyhAPPL9jAq4NSttIo7IUr6jcbx0=;
 b=EsxjspFT9qf03NnhlYS5N9Fwy+ZG2enqUTB2VVxozWwL6t1S/xszPp8BYpSOsRs3V2kimrN+4MPCPSWupSor8Nl7ETBHRaeY8DP/Oc8dhpMEZc2hFVxcyA8tDC7KCSaNrzJC5z8ZCWn8AiIJ6OZ/ca60dH6al94o8fwR9OEg1Y39XgpydYRAgI7od7vjKVDUw4UrGTgR8sdzBrli36s70z/Ahsb1HBq2iO5KoyQAmysWpJs7ALfhbjRMee+n3sB3bUTxNpygAFCS5PdWVF3W5NRbrRsXmNo1cswOjV3iJwQkDSxA0YOPg/GqbAxsyMLqIYSKi2noeXVBw2kff3R02Q==
Received: from BN9PR03CA0661.namprd03.prod.outlook.com (2603:10b6:408:10e::6)
 by IA0PPFB6B4D32F9.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 23 Sep
 2025 13:06:37 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::c7) by BN9PR03CA0661.outlook.office365.com
 (2603:10b6:408:10e::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Tue,
 23 Sep 2025 13:06:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 13:06:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 23 Sep
 2025 06:06:19 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 23 Sep
 2025 06:06:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 23 Sep 2025 06:06:18 -0700
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
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <49353856-cd48-4468-b69b-91d5bd4a737b@rnnvmail204.nvidia.com>
Date: Tue, 23 Sep 2025 06:06:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|IA0PPFB6B4D32F9:EE_
X-MS-Office365-Filtering-Correlation-Id: ec18e1c6-168d-4dec-6b1e-08ddfaa20784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2JPOUphMEJ1TXBZbVhrakVmV3lJa0pIT1NhWjhMN25UdzJnTkM0d2wyeDhp?=
 =?utf-8?B?cWVBeVpHM1ovaDRlUCtVdnFFaFlNV1JMdUlhc2NTTHRBbWQrWldFNU9jRGxF?=
 =?utf-8?B?Z3RNdGNqRTc0TjhkTDFEeUNhTW1TaWZFN0RHYmx3a1FpRER1UHQwRGdpc2Nn?=
 =?utf-8?B?RmJDWnc2S0FmaVM3YXFtVVYzQ2twc2JJQ0J2T3FzZ00xRXFscFU5MmZOZHJ5?=
 =?utf-8?B?MHBidHowdmlKcmxudkl4bmtKU0V5eVMwbGhVTXBldnlLbW9Ibm1hYkdiQWRZ?=
 =?utf-8?B?dW9kayt4TjVhTGJpUGhaMmhlekVpUGcvNUVETFNUamlhSEF5RkVJY0tWKzZR?=
 =?utf-8?B?STAyRXZTZ3NKVVJuK1N1Qk8yYnRFL21oOGtQUUwvcFpxTmhxUmdxa3Y2RkV6?=
 =?utf-8?B?U0VIaCs1U0JVeVFQUURhRzdjNEhXKzNjdytDYkVCVEVOajRRdVZCMFViSVNp?=
 =?utf-8?B?QlRZTjIrMHA1b0kyY3kwZ2xSWDlISU44U2E2bkdnM05iL2x1UnI1UGxxTEg1?=
 =?utf-8?B?c2IxMWJzd3ZpdWtMandHWEVrU2RPM01nRHFnQjhCVDNreWVhZTlXaThtTUQy?=
 =?utf-8?B?LzNDdng1QWVHb0pJeFN1NFU0WldBcW40ekNmK2htN3VQTDdueEFZWUtvSzg1?=
 =?utf-8?B?SnphZXd0aFQyNWtDZVdoNWZrbUJkVHdsZlhJUGtLQThNMTJycDFvZ25iUExK?=
 =?utf-8?B?QlQ1VDJybFhaRXZIcVlQcVdITDM4NkVOekxpRWRvZEhCc0dKTkJyeG1qaFlW?=
 =?utf-8?B?RVNiMjlTY3l2eCtVMmg0OVRuOFB6UFNNS2gwZ3hIVElBY3g0U3kzMjU2Tm0w?=
 =?utf-8?B?bjlGMldOd1RGVkhyQlBVRkhjWGNHUnFWa2NDVnJUNmtNMldBdWxCREl3NDMr?=
 =?utf-8?B?TExYaFRsNm5NRW9OYTNPRVFMR0crV29VbnRzRDBFVnk4WmY3U2hUaGxvTjNK?=
 =?utf-8?B?dmdOQlYzRjc4NnhiM3JSNkFhd3R0VDhvaERXeCs0bkpHWURhSllERUFBZU9m?=
 =?utf-8?B?VmxUT2d5dzRCUWR6NVNLRVg1NVU3ZTFUYjJoZ3dxTUR3T3JpTTY2YW0yUERy?=
 =?utf-8?B?eGJCN2NqTmRoaTFMNVdQQUtpMEVQTit4T0lLT2xIdldKNk9VNldxNW5zandH?=
 =?utf-8?B?RjV4bU1TRFlGalFzb3NNaU80bjNDUEN4UmZhcDZRbFl5TmhmdEFMdm83K3ps?=
 =?utf-8?B?SzgxbnRaWG5iZW5ReG0wRXdNOVZkV3VvRzhLVzRxM3dUcGdqTTNqVlR4SlAr?=
 =?utf-8?B?VFVXbkpxbERRTStNamdqNWZIRGVFbk9hejMxL2FMa0x3bXB2VlFnWVMrK24y?=
 =?utf-8?B?OVJVSjUyZjVsZUxIT3VqdlZ2d3l1L2VzWHViVmxDaHFTWFBYS1lZa1B1NjFQ?=
 =?utf-8?B?dXNuVjRDSXlhVGx0ZzAzS0dWdlFiODhhN1V3TERLLzlWUnFhYnJMRllLYXVB?=
 =?utf-8?B?YndIU0c2dGdMbklKQXJvdVg5enluUVZmVjNxM2pzZHNhdWJocmFqaE9oUFJa?=
 =?utf-8?B?bzBzUUx4MlQ5bFN0VVpFcExKNlFYZVJZN1ZvWFR4RWZjNkpTVG1BVkg4SXI5?=
 =?utf-8?B?eXFDWlVHaXV6TW1SQ2hpd1FmT3h5eEh4di9SNW10WWxWT01VVFNEbVZJWUNJ?=
 =?utf-8?B?d3JHeFUxbnJGb3RrMitwVDQwd0NVTWdHdGJSRGFCaVJQcnAxMWoycmRiS0NE?=
 =?utf-8?B?K0FPam1qN0FSTkFvN0xSRGIyZnloRCtPeVNuZzVzNExtVzJHb1lQcFErVkc5?=
 =?utf-8?B?YWRkWlFKVjBQaGRjRXMwdVVrVkY1bE5FdEQwSHV3Slg4VUtIUk4wTm9na2JU?=
 =?utf-8?B?Vkg2eE1WMURpcnhDR1MwUTZqc2VNbXlrSWlXeUJDK1VZbEVES0pTc3UvalF0?=
 =?utf-8?B?dHVvSUw5Rm5Ed0FtNUNyQjFlVW9razc3VEpUamMyM0tPSnpHbzFna2Rmc1N5?=
 =?utf-8?B?bjJMQ3NYc3J3SUF6UjA3MGVPQnMzV0J6N0Z2cmRuMU5DdjFYKzBGbzI3a3dG?=
 =?utf-8?B?ZFJxanRoeHgvdmttdEkvLytHU0V5emQ5MHMwRHhVeDUyR2NVVE9YWnh4OGJs?=
 =?utf-8?B?VlljZFQ2V2kyalBpVm1sTEZlb05CLzU2KzF0UT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 13:06:37.2757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec18e1c6-168d-4dec-6b1e-08ddfaa20784
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFB6B4D32F9

On Mon, 22 Sep 2025 21:28:53 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
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
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.154-rc1-gbd7dff6dbcf5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
