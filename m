Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4C1CDA3F
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694268; cv=fail; b=bJMsfcK+O4sOP/v+NLGG+kq+iXe6fUGY+xqssygJe61/GPva34G+kwV4PWMWRxCI6/lOrR/HQhWzqF4R5Zc3jYHSbMSG2DtF9ODZh7/DW+jOH+0wGf/wcUuOYPzHbhrCZr14/mcSl2DxPqk2SwTn82IXOEnlAB1Ac0z9+fqQizA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694268; c=relaxed/simple;
	bh=iGp1/9XcOGKeaXg6X7K73zev/PbVNlKoUpHs04jxP7E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=e6kjgz21VEEd+ZvyNKKNeIMh3xYDUy5QEZP21l3iaEBCv1AxYoXW2eDUUfcXZ5VjAq0TqvmjMHWtiGk89wFBcq6ILjZQ/nJyiqAJoeLOxdVWqmF8YE4FDbhNoaX4oYDnyOFi51hxWDkTzqJpQh2mGLiezNZQmo4yHaEn84x7uw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dzFLgNK5; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dzFLgNK5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjZDIek/BtR6xfcn/3gqj0Jq7Sf3qG/2dLNFyO1gmI3bJyQ3SHle3S9MWo6KEWoOovKPc62ovA0mQcN3ShHTeizJkcJJbayAm5433LFkFr5ltKvwIFBwwkpSo5bfLWpM8hFFoicWH8W/IlrBXk6tqu/cdWkUzmkDNAOi93Wj+U8HnonZ2W3ZZkVC6JAIZC93NwHpUraAu7bWrLJc0VEFUPle6CpFAS0DEgc31HevX+U7RNNaD2OAeADB4CtyC0RPErvqtgp4xRobPawLBfGpvYEF0/Va41u8xOT/FiicsxFAWOhXtYZIMvdNQYaKs7YXesK630APWQ09pnNgx6qMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTkVj9SBS2bp2vMII6sQTMOAn9MKujU+Warv9NKGxgc=;
 b=qUBKBi7KfmNTqT7a2kIa3Z465TPCKHRReCDI77HzptxtQjioqgGChcC7dfLgf+rT3nCBWtBA+yFjgU/SVvkCl1vts1Zwk77Vldnev3djdNVoSIIGI17v6nAiU3+/+/B0HTaM2sC5oGUxbnIqOulQHHKjdau4BxYgFXZOG8tPe7NXqnrN9rIIAm3GVXHVqQp6uD+yLpaW4zG76LJAiWoFkjG4IW4LZGhjZMwDSpiZi1d+Iil5mhhJOlkvJnS+WxQMit4NR6ZuaD0Iq0e3QNWsBK8U+93pgvBOv1JqtHM6X00MYPNAvYheOqEwNHkYidBanbFxlHyJ293eLrrqgI7Kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTkVj9SBS2bp2vMII6sQTMOAn9MKujU+Warv9NKGxgc=;
 b=dzFLgNK53CNXMIaqMYPDzNU19yXR4KRDsRxMpyAtb9RzdjIBkcOnsnu/xZbOq7ZyfDk9OVsFgZtPkf59pRlZUFZ/c+j3cqJNMImd5dcfkBFhdQwu7CqMqIy5ThJ6hc1N/+5xhnAmb72uBi2VrAXm6TkwSMkzrOD50mNd8FEodLrs0F47wOjmfwPEYBEkNu6IXmawqdtavuE6+T1RJz+v1KtJ0cUNG1MPHqPfK074dfdIz3vkrC2RmOzZIJlNXMe5nsWL74vY/6Uqrd+Kty3L6Gx9GHvM6a8PGIm1hyUu2udOvozbSLJZsAEtwWcv+Ly1RJudIif9k7VhjqsrbfXL7g==
Received: from BYAPR06CA0023.namprd06.prod.outlook.com (2603:10b6:a03:d4::36)
 by IA1PR12MB8494.namprd12.prod.outlook.com (2603:10b6:208:44c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Fri, 15 Nov
 2024 18:11:00 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::31) by BYAPR06CA0023.outlook.office365.com
 (2603:10b6:a03:d4::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Fri, 15 Nov 2024 18:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 18:10:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:10:46 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:10:46 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 10:10:46 -0800
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
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ae483bb2-b49a-4d7d-909c-587de436223d@rnnvmail202.nvidia.com>
Date: Fri, 15 Nov 2024 10:10:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|IA1PR12MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: f89a23fc-1467-40d1-2058-08dd05a0dbfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUJNR25zQ3ZrejZjdlZSbGdYdWxkdFFsMlg2S3lrQ3FhVkYxZFUvNGcya3RK?=
 =?utf-8?B?TEdJZTZ6WGVzcHJRZllDRjRDSFBvbUxKRTVBR3dJeTIwY3k5dGs1SVY5dDRO?=
 =?utf-8?B?K3k0UWdnc0M4Tkd2Y0FxWk1RUkZHQTJsZGlEdndBRjlKMEZrRVM3TDdVeGZz?=
 =?utf-8?B?cFdKaTlxVXdrZkE3NWpuZWp1YXgvOGVFazdlZTc0b1hDcjR1UGFMdUNlcnlm?=
 =?utf-8?B?ejEyV2NuWE1qeEczeG95c0tIL1I2OUdTbFMreWNneWRDR3U2aDJ6VklTSUZR?=
 =?utf-8?B?L1IxYXYwdDlHZjZYcHNVWVV6Z0VXUkhxcEJJSlU0K2h6S0pwcWxnMjl1SGVT?=
 =?utf-8?B?Z3Q0b0V3aUdqVFVMUWpkeFlUWGFzZmoreHdIRm9ndEdGWWRnbEF3TDZOWEQz?=
 =?utf-8?B?OSs0TW9SSVBuWHJ6WjVBblYrRFJPMlFRUFhEZTdJNEZoa3dXbUNEbWhrRmw0?=
 =?utf-8?B?c2ZuTXBGMlBUaU9WUHdJK1FVZ2w3L3FYbWZBb1FQVDdhODBoZFczVnBVTHJM?=
 =?utf-8?B?Q3Q1MzhjUDJiQk1DdGZKZXJUWWl6WlZrWXZxWjZKalFMcDJETHVyM1ZmeW5y?=
 =?utf-8?B?NlFweGs1MlN3am80enZWcDdrMytaWVJvWEVFQ081MmJFdG9CMWNjam1xbkR2?=
 =?utf-8?B?V3ovV0ZXL1picFRnbFBHNzc5WTJHZXh0Z1JrNnltQ0IyVURjOGluOUwzRjVm?=
 =?utf-8?B?MWgwZE1Kd05GWk8rWlNBSm5QaXQrRXRUZzJ5aGhvN0t1RVNYdXZ2VzczcEc5?=
 =?utf-8?B?SG9RNXBkYnRxTEt1a0RvQlhPbjJSR0tUMkZKK0Q0aDdoemNwYUg4N2NNR2I3?=
 =?utf-8?B?bkR3TnZIMlVBY056eDVTRFhLcXdlQXYxd2oySXcwMG9hZlhLZVdkODVYN2JR?=
 =?utf-8?B?UnJReWFxNHU3N3FUMHJyU3R5ei81WTZuRUliUnovQ3lBdFl5N1FXY1hDVWRy?=
 =?utf-8?B?cHRyZDI1NmVkVFhJOG5oZHhHY3ZIRnBEaFNZdzZNVTJYWFMrYkFydy9HdTBi?=
 =?utf-8?B?bFZPWnpLWUpEU2p4Z2N4RmNUT1ByMDVVSE1CQWdDN1dYWUlUMStpeHNub2Js?=
 =?utf-8?B?THFYMEhVTWszb0FwenlYNkJpSEpMSUdac0xiYWc0YlBtV0lCOHlRbEFEYnc5?=
 =?utf-8?B?SXROTFJkSGRZMGVsVVZoY2h1WTZKdEYzeis2TUZiVzdjUDRtWUhZUFRtbS9R?=
 =?utf-8?B?VW9BcDM0RUFpS1RpVUJPR3E4Nm8zNlRGa1o1b0V6ZnJOT3V6QWlRSDgrNTIx?=
 =?utf-8?B?MW1tWFlVbXgxaWVGVUJYZmtISTl6R3NCVU9kZ1A2Qm1LejdNbGFsam5XY1JY?=
 =?utf-8?B?bUYwaThua3dZMzYvcEcvbnFQY2hoWURlbHhLVFZMcGxENnozRjBRQ0FIRGpl?=
 =?utf-8?B?RkFFellwQzlWVDc4WC9xTnVSV0pxalRRZnRVNmF2NlJRMkkyUzVKTkEzMkhE?=
 =?utf-8?B?K1FtRUR3Z2I3Wkd0SmNBOW5veDYvbU9pbnRHZ09iNDBYQ1gybjFBYndNekR0?=
 =?utf-8?B?UnVUNmZVUEFvcXJFMGJaUHJDak1nbzloc3dvR3F4SVFQLzQ5ZVVBTjl0Unpz?=
 =?utf-8?B?enk4eStBZXJ1TUt5VGZBa3ppNXNjektZWEhpUFhkNXg5RzNrK3dwU0YxUTlX?=
 =?utf-8?B?TDVvZUdTYXlvNmFuQ3p6N2FvK3NvaFZpMkRBLysyOHMwMTVKSXB5Q1MyU094?=
 =?utf-8?B?blBlNWtJbnNxczI0UFVTT29Ma0xBMzMvQ09IZm9rcTVQdzZiMk5vU1Mwcytx?=
 =?utf-8?B?b2JoVldCQVd2WGVDckU0SzM0Tkx6VzNxT1ZvbVdJeGlqakxTdCttS01nKzJv?=
 =?utf-8?B?VWdJdFJCT2J5VUpCb2JURXJqYjJ0QzZTcUc1WERoZ05wSFdXSkp5Sk9OTi9s?=
 =?utf-8?B?Z0ZzeWpWRlNtVHN5S0VndnlkUHYzUEFiYVhvUXhOc3Y5a3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:10:59.8646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f89a23fc-1467-40d1-2058-08dd05a0dbfb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8494

On Fri, 15 Nov 2024 07:38:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.173-rc1.gz
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

Linux version:	5.15.173-rc1-g056657e11366
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
