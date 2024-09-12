Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6E418BC3A
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 07:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726125594; cv=fail; b=Au++iZxj3epvJOp+Bn32rF3y/fqVo2rD+vbW7gy8CCtyBADc0IE4hvjww9QX6JfUdDFi/YWjZu0WCU1SF+c7ZkxG7CD7weEBu14Sqso/30OFkcQ0WXI5faZKPXAdV4lm4/ix4aApMPrUSpP9I/gAFgghUGsFOtPRXdnDBVuA/tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726125594; c=relaxed/simple;
	bh=W3Aqh4OxOLtk0Bipy/0oGlrQoQp+ak6qbzzZm6ooJkM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ZR5GJqF+xB/VgMGfXjpVoCqsT+z2wxy4kS+HUiIkHV/xOgGcW6cFnMyWhmyRcW8xE4S6WQ1GdQNgX1dXglC7TE/b8TvZt68zInYK/PqeONP2+X9XVQpjGyQyVapY+LVDCxO4Elc5Zr3QvFvi2xgelQHnlen81/oduAZB/w/2RTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Koop5sCe; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Koop5sCe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHWrCcrwqLPHjZW8FShF/j69jtUTU5XCQkSstgbg0Gy/7S4LR7plvkFyZYOnQpGSl8Womq5rR2VeN+DqRpqLhD6RpCx/OxnQgNvemW6fxoqcrc3qR/awWTcvF9FzpERioZRh/JR0gD4fmv1eHg7cW/uE4CIjA/2W94jA7KQge5Dm3wvvCQPXT7Odrc7X+fUPi9CPNxW9fIKzvC3yqqNGsmKpL7vOJQkWThWp1qW7De/4G4OfSUY9kc1loBRI1nEhUB0pQwiPfhEUW+f3yXWPqeczHyABqJg3t2fV6E79e1tFvkUgSHRSWokbsAbWOc+Ce458AMYvvf4IY2xhuRqw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnbVICSbzBRh82Mr2DhkxmnDKYSevdsR3nBXbzExlzM=;
 b=yFl76QACo2KhZgYPe013IeUXu1vAYYwuhnkrKRFEYRcqCxxfiPgUoDUqyx8eZ/QX6qw3pT+hoaCSASPjSdy6+ajLr/s8y8SsdE8t6no9CyA3nc4IzVNAzEtKVmv41nsJrr1xeopltAy7onqEw7OmA1rESxmgQp3n8hK29ALSIGgn0+cuEoqO4MAd9QPzQR0eTdFnizNSxt3Q4iN2vbOctStFJjxd0nLEBrNk0XrDtLK6N48cIcXoScOKNRV6/7ibcP4t4IB0NB0OKIixvsGKP/eK8Kz9pkaEdZdysJo5PFKYi+M/UsDJXeoq0Ch2TfpnioDbHp/vYVykh2K6wC58VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnbVICSbzBRh82Mr2DhkxmnDKYSevdsR3nBXbzExlzM=;
 b=Koop5sCecUnQyzdt/2j+3XTPkhOP3TEzcipZIEzckcQ7Am6tQRwwlVIVsImzeDtuctqPeq9M+SNOi7bVbNUhFAtre6vQmNUhq+EdB75/eACjBK26r31bfqvq1ZfLFfJD9xMetL7kHr9s6c1DCQDkUGXo46Y4F+EjUAj6ZZT9ly//rwmcUsHls5qCIBDv+i8XYM0Mw7SR/8Ah65ifQAAXqrUDR/esQWJ7OErJVltC3LhXCwzeTIKdZAXEePsL2srJI/Cqj7qsGAWw6jVxJDGp5Jz3ip5I7LKkQuQE+oh4sONTH2nuK5tqKMsbSZhFsq4DHy0FEzrnB3Ebed3hL5xsyA==
Received: from BN9PR03CA0398.namprd03.prod.outlook.com (2603:10b6:408:111::13)
 by BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 07:19:47 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:408:111:cafe::bd) by BN9PR03CA0398.outlook.office365.com
 (2603:10b6:408:111::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25 via Frontend
 Transport; Thu, 12 Sep 2024 07:19:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 07:19:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Sep
 2024 00:19:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 12 Sep 2024 00:19:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 12 Sep 2024 00:19:34 -0700
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
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <69a511a3-af84-4123-a837-0ed1e5f62161@drhqmail202.nvidia.com>
Date: Thu, 12 Sep 2024 00:19:34 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|BY5PR12MB4306:EE_
X-MS-Office365-Filtering-Correlation-Id: 821dec46-93aa-4931-8297-08dcd2fb47de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVFwU3Y1YnZ5M1M2SVpMK3BEc2ROdk92aHF6SE44Vm1wV3VCb3lRc28xSHF3?=
 =?utf-8?B?RHdQNEpMZndyL1g2b1VLV01PN2piSmJBTFB0VG5raWlBa2pNVS82QVJmUWI1?=
 =?utf-8?B?emhvOWdkWlFmV3NOQXZiSGZXOEpIcjcrZ2xXMHJjOWpRRktySWNiTzljZWI2?=
 =?utf-8?B?Q3RuSGNqc0R0U2VBUzNSTFI5NkhlWE8yOU9pVmRsZ3lxTXRZTEtBSlFJSXZE?=
 =?utf-8?B?WTFrWlNzT2cyQzJ6dkZkMktIK2lobDAvWjhvSkRHdHBJR1FRTXBja1NuVFly?=
 =?utf-8?B?c0lCc2E2cDROYlhHb3FTWHNhdXhXWUdJOTFHK1NVc1ZTME5RZEVGcHRJSVhG?=
 =?utf-8?B?SnRnNkFWLzJ6T1BCUVFqWXZWYkM0WU9rQ2M1Zm9YUFo3WTltT0FvS1N0dlB2?=
 =?utf-8?B?SjZ2TCtjVmpzQmlKdm5KUEJIS0ZXNjFhWW1MVERPMGNaNityejlsMTRkbTRv?=
 =?utf-8?B?ck1zWU5LV0JudlpxMU90eGdPNitkVzFwanpPODB0dG8wT3ZuUjUyQk5adTNl?=
 =?utf-8?B?V0ExWk9zN1VqY3IxdkhBU1NYeXpGOFl5RkZHSmpqcUhKaW9EZjFPd29pVGt2?=
 =?utf-8?B?YUg5WC9jMVo1MVl1YnVvZGRUZmF3VytrR2JlQlY1TTVWd3VMdjFyUlVDVC8y?=
 =?utf-8?B?WXNSNERVZk5uSWg2UkRwaWhQM2F2UlpyS3BlWlBFVnZDeHA5VE9BTzdGQjJm?=
 =?utf-8?B?NDhRQ21DMG01T3JiYTZ5WU9JRmw1MWNaSVA5U2NKU2pGc2VFVVJtRGkyc1Vn?=
 =?utf-8?B?b0VjTWJqdTBqVGIrMzZleFgweVUzbFpQZThyYkZYeEo1VXk0UTlBdDhOZzJR?=
 =?utf-8?B?TUVGVnlHR3MyakFYQkkrb0tVVFhxU0pDbElPWDFCc3ZLUm1hVkp3NWl6eFRU?=
 =?utf-8?B?SVE0OFNXSWp2M09OT3h5Z3RaenA3NW5naVRCMDdhTVJvdmdacVBxTnp3anpU?=
 =?utf-8?B?WGx3MjJVV3YzZ0xlS0ROU3pCSmZXb3pSZjArNFc2YThtWFJrMDNHa3YrbXhR?=
 =?utf-8?B?ODdoUWIyN2hVd01vRU5JTUtxL0cyTmtpcmdCK3VmZnZoSTJaSmZzaWNCc2Js?=
 =?utf-8?B?R1YzVHI0NUdxa2EwSjAwbzlOQlBsNzh3OHViU1J0Z0xGcUFnWUhWdjNUR0F6?=
 =?utf-8?B?WXJIV1U0OVc0S0ZFTHNEOG9QdnhqZ3RaVThVK1VpcUhHV0FZOHF3c0VkV3J0?=
 =?utf-8?B?cFdDZlkzTldPRWRuWDltMWl1QnhPZitiRzgzeHFKL2RkZlJkZEZ3RnppSmNv?=
 =?utf-8?B?RFZhN2NhVXBibkdOOVJxR3F3RFZDZ3lYbGxYaVBQbEZua3IrK0FualNBWXNs?=
 =?utf-8?B?NFQ3RllWVWMzTC9TRlEvRjJrcGJmaWZVN0lvU0xZSGQ4V0pWU2ZoUVBJMENh?=
 =?utf-8?B?S0R4eldCOTRXQWx0Y09HOVEzbWNQR1dtR0I5UE9xL0lFY2IyYjRrRHo0NEVa?=
 =?utf-8?B?ZDh4RkEvbmVKRUd5bmV4Y0tVR1dkSytPOVl0dm85bEVCQm5MQllJK0RFUnpN?=
 =?utf-8?B?dEhUWG5pTDJUWkFhbFl1MHdVUHp5dVlJWFZwODd5QTRYeUxRdEU5QmQ2TzA1?=
 =?utf-8?B?cU5GWGY0V0pXRW1OT0hhZ2lQekoyVHFxUzhMTC96c3h3U2xXNmVKWjFUeHFr?=
 =?utf-8?B?Q2VtSmU2eFU4a2k1QU1PaElUODBlRTVuNGZBTXBPTWI5ZjlxWVU5RjVvZzVo?=
 =?utf-8?B?Vy9OZUgvWWpER1JLbGlBeG1JSHFnLzBsVkp1U0NnbXBQSUZaazRZeGhBdkRv?=
 =?utf-8?B?V2UzVU52TnVablRpODF5UTAvdXM3RkFYd2J5SWVweEdsb3RoYkZSUUpuZ2ph?=
 =?utf-8?B?TExFM2tlakc5L3JRd2NvekIyMXJlM1pFcXJybm5XWEtpUDVnZTRWanBYaTVZ?=
 =?utf-8?B?TVRIdWsyOG52MzVCOHZKa2dvWjRqMGNGbkhxMUlGTkxPdmJSMUJ5K3oxZlF0?=
 =?utf-8?Q?BT8r03X+YgMCYBeggCBZ/Xm9BVOyVkMz?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 07:19:46.2125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 821dec46-93aa-4931-8297-08dcd2fb47de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306

On Tue, 10 Sep 2024 11:29:47 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	7 pass, 3 fail
    20 boots:	20 pass, 0 fail
    98 tests:	98 pass, 0 fail

Linux version:	6.6.51-rc1-g415df4b6a669
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Builds failed:	arm+multi_v7

Jon
