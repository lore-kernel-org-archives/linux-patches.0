Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19C91B970
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013998; cv=fail; b=JNrb7h1IROg5Hp9uq06IKQ8oNVSqlcxBCOFK6a2qCHah0PlfJ+sFbrZ5F0dHBIPs8VoFmZuD2yC2g2Kv1nK92kCOCA/U8XNzsgnOd5huxgESkI5YHamaJKVylc0Um30TP/UHfGPQnC2XtHYz6ai/OD19vuf7pRAkTKVgma9iLyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013998; c=relaxed/simple;
	bh=WPDqcUg5arVdssiJ1SqDP5nAzB/HLVkfvpFMM8qwm/I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HWDIFREebh9kQ/bonHGLodwzln5M0zvU8Mf1SfwBHpAPrZyc4CoNssca2c7q7aSFPuPtOoyA8TAXgh0+lWRN394rR48VXZBkzseKN/0UwYds8TZsg6xiXG9CejLv8+pnXmhWhU+VqMOVUoyESP7VV+SPETB5zayZdu/dmcXIKrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hr9YteXj; arc=fail smtp.client-ip=40.107.220.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hr9YteXj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ck+7o4w1CGg6pYqq9UQBBSgmEqr8NEO6JzU6rf5vbFnXDY1+7oOCGrt3JOcixTue3mWhfRjxeQrEoQdmSwmCgJISe5LwmQ0GYYaWoBNQDDb7ghcjrLFDszgFZWlXOm+8tDCE/wDFnXqoLiV2TAD+jA/2QVO1S4LgYY66ohHy2dxfRjHFvYvknlPA8u2+ygFbfCAR9m5iBK4WfwUTJ7WEXHhJqmKIK99XYe5AmM3W29W8yARfVzde70SV+FTWHG4VkweQ87Lp4kPfvu396RzjtfG9b7oqzCgiyB281/7J9uQUrSjcVrslRSgOMvuWi+bjxxMy5zDY4C5lpRZcPrjauQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNCM5mTPAPRHyVcp6GiEI6ErtV4WhDkp1OBSOLEEYm4=;
 b=DmAfAv8BVdEp7TF+cEXg7fVX8v7zV7bDAIx8V52LkzM9s+1suYcmq7i1TNo5f/U8ElPW68iyYS1kONipaBnvc5ml8+pWiHkrENw0ReogvmT2kmBHpux8fxK1uU56ra9FHyyr7yYgejkbJl1ltxuLDJ7zaEoBbZdYy/TQoEDDL3hKNOHExL866MUtAFaofWzCPzBoEtXeXccg2wJoJoun+6UHzFFBJ2FTVElyqxxR4nhBLiCBMV68TLgdoz8f5WNXd9JfxzH0LFdOBQUIjaKdFpfqfXRctcnHTvDvgdI8cCbGe642o42XAE+XSA+JJqMkZlDjNNMhpK9qJ4CzRJkYGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNCM5mTPAPRHyVcp6GiEI6ErtV4WhDkp1OBSOLEEYm4=;
 b=hr9YteXjZJ3Hui8J86wTcvjizFGxS8KWsDMeDytOocAPCrH7sFyz4QP8dpFpOxaxmT285/cu7Ovjdc+rJ20bbU8U/I42Tn38iOwLnFAxosBaXz4JxXwKNcLlrsiVSBjSmpg8P8xQVupUuez5dypgepM8ijOW0y4ny+XH9cJwvOT0AYDqjR0EfmLTiqyiRR+SvGtNNZPpIcPjF2lcrcxqHNfrxWGI/kTyGHnE6Rob0Rqgie1+vasszVPBW4X380U1Fy+OHabhdGEmG1Qne3LcoN4NcBQKvt8xMcOS1rqOdXEbyVjBHAIa2ei8/IqVJEbax0r1O9Z+y0AGrjzTORmcJQ==
Received: from SJ0PR03CA0331.namprd03.prod.outlook.com (2603:10b6:a03:39c::6)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.32; Fri, 26 Jul
 2024 17:13:12 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:39c:cafe::7a) by SJ0PR03CA0331.outlook.office365.com
 (2603:10b6:a03:39c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Fri, 26 Jul 2024 17:13:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:13:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:12:59 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 26 Jul 2024 10:12:59 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:12:59 -0700
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
Subject: Re: [PATCH 5.15 00/90] 5.15.164-rc2 review
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
References: <20240726070557.506802053@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <091901e4-434c-48aa-8c5c-7479072c32da@drhqmail203.nvidia.com>
Date: Fri, 26 Jul 2024 10:12:59 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: ede27e50-042c-40b0-74a5-08dcad963a59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzZsQUV4cFgvNHYydUVCY2pLS0dES1ZWZG56RkJpMTE4RU4xTDI0WjAwVVZs?=
 =?utf-8?B?RFVoZFJ5NkE0bWtZaXpZUjYvdld5R0JmdmxPNFF4RldBWXVtZ3gzbEtTTkM5?=
 =?utf-8?B?R1hSUm5WN2JlTGp3OHpvL1NCVldiS2JOTG1jMTVROFNsVHJVMGRTV3lBNjdR?=
 =?utf-8?B?eDJGYzd4Z0RzL1JLL1VROHBJSkl6cGdHUnZXd010b25BT2lKaFY3OE9odk40?=
 =?utf-8?B?SHZwdnJudm0ybDNHWURUaDlDOGJ1aitoU1gybEZCNDFEK3ZEVUZIN0Nkd1kr?=
 =?utf-8?B?ekgxNUExVFBsT0dwblJsemp6Y28yNlVOVHp6djh5LzFvUGRFcU9OSHJ1UkR0?=
 =?utf-8?B?alV0bkNYSHhoUlprSVJvQS9CYTAxK3VsU2grWnJ2bE83V3JXdnNPdWg4OGdO?=
 =?utf-8?B?aGJ6TnJpd2wwa3F2SUJTcDhSNWFhZnZLbkYyR205c3BjTXVWbUIwb3FwWm1v?=
 =?utf-8?B?Q1c3QVJxWEl3TEhTNmlRMEd1RGhhNDBsRUh6bWV1L1BLNml6Um5lSk1TTE40?=
 =?utf-8?B?SnJtcUtSaVJab2U0SUg3SEU5RjhZVlg0cWZUVlM4WWtOc3JpNUhoZm5lWjF3?=
 =?utf-8?B?SXRjRytCZ2xzK3FFZVJPZ3BXc2VTdzM4U1dFQUdnNDJ3RzRVMDhLY2t4cUF0?=
 =?utf-8?B?WkdyUnFSYTlzTE1BdnZrK1E5T1FuZnBTTzA3WlVNU285MGEySHVYTnJlMzhX?=
 =?utf-8?B?eHdjSWlwdlBsS3diMHNXSjVFeURXTCtyM2h6V1RvWDRYREg0NXl4Uy9DdHJY?=
 =?utf-8?B?bm1peUFwcmN2WUpTc2VYOVVsQVdkSnhENFFyTkNidSswRGU2TUhzNDI2NnNj?=
 =?utf-8?B?eGRzVVZEQlZDc1hNdU02K0VvUWxnN0k1T0NNWkZwb28rOGRnNEFjd1krSjB1?=
 =?utf-8?B?MERVcVFpc1pudXRwRkdndnZOSjExYkJSMTZ0d0VsVDlrM3ZTVHBRTkdpSWV5?=
 =?utf-8?B?VHdITVhKaXdYTHFFMVlHaU5nK083M01IK1lhaG93NVErN0ZURjRqU3dpc3pY?=
 =?utf-8?B?M3hMOXRFRTBEc0cxWVJFcUhFSTJLY1ByRHpZcnNsbnNBTlNWQWZtSjVoUTJs?=
 =?utf-8?B?akt3THRSSllSaEwweFRMOUdyUDhsbEtxRkQ1cWI1bXN2aGc4VGlwLzI4bHJ3?=
 =?utf-8?B?aHJ0VWxLOUFxRkt1QXRWdW5zeHA3d1ZEZ2VBRjcrL3Y0Vit3RXNzSGFTVWpw?=
 =?utf-8?B?cXltUzJ3dHFuU3haN3FUWW90OTREN2tVdDZSRTg0MkFoZG5USWJ2amZoclZr?=
 =?utf-8?B?RCs3a1FJa3NHSXBnMHRMVnJvbnlBWk9HUDV3dUg2MjJqeFF4dXNud21CaEFo?=
 =?utf-8?B?SlgvUFpWQ3A1eFdhUjZENHNJZlluQ1QwQmxJYzF4UjlwODJpQ1RJOWRHOUph?=
 =?utf-8?B?MHVWWG03eWs3TG4xamw4Zk91NSszaEgrd1dmMWZaSWt6c1QwbUt2YTRsTFA5?=
 =?utf-8?B?b2lXeGpoTHprTXBCamQwS0tPMlBMVDNCRzhsLzNiNk5nZlpGSkFHTVpORjNK?=
 =?utf-8?B?ZUxkN3QxTDYydnlSRjRMRnU2aGVmNDBVUno2aGZ4SjZzc21YdnZHa3lFaXlP?=
 =?utf-8?B?cU5FQlptdHpmamErdDlEK3ljZmpuZVg2TnM3Ty9KR1R3Ym5TS2tPZ3JTQkY2?=
 =?utf-8?B?WVF3RGVienlpSmtWVUtTZ3hsd2FnOGRlKy9FMVM0bFB2VVB3SzZqQTVwOWxT?=
 =?utf-8?B?ck9hNVdzcE13c3BiY2E5d2FuTnBWQTVuTEw3ZWZSSEo4NjI1MHVUWmZYdXBu?=
 =?utf-8?B?NEhvUEIxaE5LYXUya1ArQ0ZOTG5CdHA0NHljN2h1UE1mVkxJNUVSTnZESTlZ?=
 =?utf-8?B?clFXWXJkWS95eTNONEQ5TUx2Ykd0eVAxZVh0RzEybWVoT0dERWpCMHR2LzZq?=
 =?utf-8?B?TW0xZW9hMlZaeVhuOTl1NDRoN0xIUDdUeTVNWC9nM0tZMGc5QWYvL3p3czNL?=
 =?utf-8?Q?Q5umDusYd1XgnDFM0e75xn866YadR0iX?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:13:11.4471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ede27e50-042c-40b0-74a5-08dcad963a59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047

On Fri, 26 Jul 2024 09:12:44 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 28 Jul 2024 07:05:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc2.gz
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
    102 tests:	102 pass, 0 fail

Linux version:	5.15.164-rc2-g8730ae13275d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
