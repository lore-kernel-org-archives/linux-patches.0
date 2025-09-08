Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B484315F
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343699; cv=fail; b=oES+msaanljZWV0/eT4kt805hGgIiKVpkp2XPN+5HhRcvZju2fQVu9Buk9VIF1crAWs9ydo0OlmqQ/UngfdnLhrO7JmcPwecxmvzZV715m+WNXYH3YcYr0UWRr0g4e1SiOuk+NvGzMwSdTMeqe88KmWziym9KlcCYjUC5JoUoYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343699; c=relaxed/simple;
	bh=KiriYk+gMwczc9DHJQwtRlYOQ9AqKycv7giPzEp6mXU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Fu775+A6TrHv5HWQ+gXlGoX3FOXK/8zktC/iM9QeS5uAzHX3Bc/lj9LMDbCzLXf1MwUhrNy0MJEoH5UX+/AyZ37Z5OETkQv921WUTQH/QhboV70LNJgF/H+QG+KGI3a/uItJCDATWPldDHoDLLLS+gRcE/g7Y5txUZdeMvuZY+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dLv0GuES; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dLv0GuES"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMXTpYZG3dKjysittp4jEbK//0i8ulrV8ZUJRjufCFegR02zktHbDRN4chQ3PjAtPeobRQ/kLpyp1PnGZ2bnrjLhQhWLlLbTkPl9xTAeh2JCn+so5FPO78zyTMg/us1u53noGoNzZfqfIw5p7nGXC0gicgIt0Uc8tAMwoUthpDTjoLrySoDEtk0y8mn/VG7EqAoruVG6XwOrmQrrM0YeQMs2HWdljxFXQNsZrQAOqs0lPx2RafjObY7PW1FtPqpSK5ZNI92kxlUvcS631H+epS7m8crBQg5faEGcAqDyLOuRTeAM7oHJAq9ldYND1Csd5TuKJpP2aH0x5shUH0zw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99tJolIXS+mdgDhsbBCI4ppB/qUnGjjSFPLe3GMjQj0=;
 b=im4xCL+S3yFvLhE1R1m75aOYwpLLA4u5DLyP5LWgYkVH+ATiZEt71hBLEaVQbfvrVRijriIPCuh/+Xn5wcKpOfzV8Mm88tmjXWW7nP+ZGDo86Aas+nJKTithq/9mzf8+LIrV5Voz/4yvquVewTXTf6nqvN1+sg/1I49J5oJwy23jZI1fKBheZStx2CUQ8CM4rvqWqrXUj2LDLoGBszZjna5/tvQSNYBHt/Fk1pHRGPX3Gm0LeGWeVAGHN2xxObiII3/C7cIbq6g4CeA7FbQYJVMbTw0MG+3vPr+L8lMWG7hgZi61tXZFOrJ9QTZW1EYZdD2cPa/hwJsrzRY3KeNSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99tJolIXS+mdgDhsbBCI4ppB/qUnGjjSFPLe3GMjQj0=;
 b=dLv0GuESeD4k88C0g7sNBOz4R6Tp61LmkzJ/Dyu7VFcqMIGR2O84zElZTsdi+ew25A5shMri/r8WagfPaebUCEePDIFgTJYQrkPI7AIexH2k2NrGF8S1vnP61Om4BVOW5VIZJbUt/xlZMUhoFGWF3t3966/3XGL2kZwJltbecwtzkhnIaNwEonZ41sNIBR8fu9dAtCVCTxM1BXeHCbXXQGjoi1K6cl5hXVrEhlziI11VpvC9U4xXCEkS89+8vPRLBNQHWS5OOdEO79+SFsx8AbhGVWopoycFyBN+I61FnIr74AfSQNgFsJSrx4JvDXyxF9eQM0xLQPezvTkjqls8UQ==
Received: from BLAPR03CA0072.namprd03.prod.outlook.com (2603:10b6:208:329::17)
 by IA1PR12MB6282.namprd12.prod.outlook.com (2603:10b6:208:3e6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Mon, 8 Sep
 2025 15:01:31 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::a) by BLAPR03CA0072.outlook.office365.com
 (2603:10b6:208:329::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:01:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:01:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:14 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 08:01:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:14 -0700
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
Subject: Re: [PATCH 5.10 00/52] 5.10.243-rc1 review
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cd0e4e17-cb13-4724-990c-e2449ddda205@drhqmail203.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|IA1PR12MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: 8321dbde-80da-436e-39f4-08ddeee898b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWhVaHpXSXNQMWtpOUJWb2lPWG9uKzY2VmVYaDdPSGkwYkdLS05CWmZrN2dW?=
 =?utf-8?B?Ull5MDFIc2xnaGtZRW05TzNMcUpBUzZkcXNqTEtibkRLMHFURHkxVzkwZUpU?=
 =?utf-8?B?ZHNSb2lJSUtTbEh3RkZXenBGS3duczcvTGZDb01HQXhkQmxMdXNzRVBBbFdO?=
 =?utf-8?B?b3hld1JOWHFIRXhyYTczL1Jtc2pBUDBQMUg2cmFSZVNPT1FYdnNBUmFFR29u?=
 =?utf-8?B?am9OdE1EWmxWSUpCRmdKWmNSenhLUFRXclhKcmdJY2JPK0hKa3FmQlgySTFp?=
 =?utf-8?B?YWl2VmtPMG40R0FWelNvVWFHM3pSU1Fsc3ZyWGJrMkxDSFJLNFM1RFYvYzhi?=
 =?utf-8?B?MThLT2Jjbm5peU1qZWc3WkxsNjdXL3RTOFdhNUROdFNyQkRJZTBVQ3RUQVVs?=
 =?utf-8?B?RlVzcnhJd3Y1Sm5tS0FDeWdyNkVGbWJFSitueDJlT2ZpTDIwUXJGN05lR2k4?=
 =?utf-8?B?TU9LVEZ5R25vZm05K0paWFlKQjA5OVBJSHEramFJYjhJT1FKQzBLZWFDS3lv?=
 =?utf-8?B?SFRtZ3BQTDdLRDUyVFFicE5EYUZ4UkxJUEx1eGx5YUFYdjkzUTYwMWpZUnBl?=
 =?utf-8?B?b3hrYXAxQUVIOTEzRklDNmhLMU1JSTFoVll0UnFUNXlaY3Z4MkdubTZNb3Qv?=
 =?utf-8?B?and3VUprbmExdXdCYklPdWU3ZGRUTEdJbHFYNHMxQ1N3UlRJN3JoZ3hlWU4z?=
 =?utf-8?B?SHdMNFZnQStDQ1diSlZvUFd5K1hxdnVUeDlpaUowRmdKREZ4SHM1WVVRcTUv?=
 =?utf-8?B?U3Jxa1VuRmRmaHZUVW04ZStGVXh2Yjl6TjNDR25IaGR4WGtxb1E5ek05S0Fj?=
 =?utf-8?B?N044aU1uYmNIQ1dtMEdvODRYem14SWUvSU01SmRWVkF6ZlBDWWVvcFBpR0I1?=
 =?utf-8?B?UlM5YTM3Tk1yazRwQVdYckVUclJwNUpKSVFkUnRXa2ljZ0t0a0Ntck9rYVRn?=
 =?utf-8?B?VmhOS25BNTY2ZmxsWGpZbDdmL3VqQVVvTzFmMElpUmlDcWVlRjFOMmk4dkty?=
 =?utf-8?B?L1pZcFhQMG9tdTlwSzR3MkVhczJmakNJZzlBMzJWeHpSM2tJelY5cStmcVRO?=
 =?utf-8?B?S052RG50Qy9pY0s1cE0rdWJKeVhkSjNJVFlHN1J4czJ1WmNyRlZGaVZXdjNJ?=
 =?utf-8?B?Mno4RTExajRjMHZpdXE4REVnY3cxbTZnN1VUYzBRK2lNd2lZRXNCOFJ5Qlh5?=
 =?utf-8?B?cDMrNEF1ZmFoUGcrYkR5Zm10OUpOTkVreHNyaElaZjZYV052Yi82aWhGc0RF?=
 =?utf-8?B?NGR5VEJaNjF1SjhYNEIyNS93SVZJTnBwSDl2RER5MFlhM2tOQytJemllZG5J?=
 =?utf-8?B?UC9hRDlXK2hOSXFHSkUrLy9idytFc0JtbUFBRnVnQkRtamhRMlJER0ZHV0dL?=
 =?utf-8?B?TllaWCtUb0pid1MydStUMEFPWnd5aHJrN2hLdkd4NnlYeUVMSnhjWXhCRndF?=
 =?utf-8?B?eWQ5RnpiMHA3RHVSbkVpdDZhZjZubUd1cG5IRmVya1UzaUtpa3lqUmpNcGVR?=
 =?utf-8?B?TzlNbi9nRGEwZzBoR2NZQmZMSFZ1aFR2ZEZ4VWFXbVFEUHRGNEVlVUV0SVUr?=
 =?utf-8?B?dnc5WkF6RkpHcDBvQTg5RG1QdkcrV2dUQnlLeWJXVG81djIxN0NFaE9JazdC?=
 =?utf-8?B?d1lZd2lpMnBHWFgxNG5VaFlhQ2xpenNIZVl6bVVaUGVtcFZGZzJUSHkxRVEz?=
 =?utf-8?B?ay9aSTVVbmx6cTV0MDVqVFEwNEJWMU9yWU9OazFnUXBINW0wWUw2UkhSMHky?=
 =?utf-8?B?MElnd0pOZVR2WUR6clZpaHRJUENxRGVUdTBJN1VEQytTWWR2RDc1ZU1INVNk?=
 =?utf-8?B?YmsvUjZLWWllUTVCUlJqVzJEMjVNa0NlTEttNU5lWE5XbWwxQ2dwVnBFUHdT?=
 =?utf-8?B?V3RHY3R6dUxMSWQzWDhIVWE1WDZRY0p6ZkpvNEo3OXBaYzdXUFVSRlhzOElI?=
 =?utf-8?B?Wmh0ZExDWmZaMFZpTUF1QTYwQ2hUeGwrbXZvaEZVNGZCczNXMDBUVU1FUmM2?=
 =?utf-8?B?Rnp1UW8vbUNHK1RFaGkyTXZkZHlCd0FFR1ZJT1UzTm04RUtnRGUzTGk2YVVu?=
 =?utf-8?B?MmI0N1RJTWdsSStyMDZLYm5SVGtzMzl4NVhzdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:01:31.6508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8321dbde-80da-436e-39f4-08ddeee898b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6282

On Sun, 07 Sep 2025 21:57:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.243 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.243-rc1.gz
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

Linux version:	5.10.243-rc1-g910e09235335
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
