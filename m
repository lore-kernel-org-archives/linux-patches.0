Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE182173357
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 05:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728971577; cv=fail; b=f4yWB8/PS/Jaja5LNypWGw8orEt+PPtZnxzXIQAmK8gxgNbq9vFmVG3qaEmmwKvXuNV1uIq4TTFS3t/JaF5fyPEW6euDPyFDPYGvewvC5bWmD+ZUwnGzmDSDRlCnZOdWdLkvg0im43YY/tWmc38XeHge5KdY7l9vSm78q4rbyCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728971577; c=relaxed/simple;
	bh=vtppVvhMJ+s6RH38w4KWcOAnUajhfBerHK5U2RL7jKw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=KBED2yVgt2VmyNeIcoFKwo0x5VaIPZXOy1vHkRWyxfnpkcRum0tj+D+kTJmoCLlii8CFpJa2rBBDcM7S7h02/wUTdtppDM3eByignVMOIZALhSkh5pD+pAHma2VjdxlJCdzr49vHE97EUa++lg/HYebolepmNpRQGNWSm+dWAzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NDjpcl0y; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NDjpcl0y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVn2wZa+bpibwOyQZaaUoDtozpTZjJENje6cbrxJQFwU8PiiPUQLnYj9fP9uaoZqUhDJC+AMLaIW5SHkAgjRDeJZOIbKY/B/3JxxeywEFFNW2lrD00KoDjceS2kSl5L+WzD9h0XDV2ZOlOvE6m69TVGUFh+rTdl6q3qoCAaKG07x+EZHK3rNdm+1So+O33U4RwK8hLTWjMKupnrxgXJ6jtLfKnWQDP0yTxAL3t4HykYmTy19H+rb9q7sMOB+evzTHHL/uQVSdBGEZ4RtlXNeRMz9uJqc0L99E3r9Za4DhmVdHLia0PfXVzzDzMcQFfWm0ll+bggYo6SfKVI1PMhsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mhms6b//91eJc2a4kAuYZJU+p1irmdab4gmaFzs3WE=;
 b=g2e49z+GJTzIvDXsWv5GUn6BhsOBI8gs+i7Nth896K9zI1e+nEvwvHr6T0oHOXLvIb4c0ZpiKBPBErhiESegDPhH0LTcbcTn55zU4Jfl39y1QlfjCAFCip28UV4pkfCATQdrntn3PXm3laZ7lSSSvIWcso7iXMfgkHMMaBkTJ/P8qvB7gURsbbboIpMdA3i0jgJIaNbQpgPYIwgK9TjbqdudDKRI18HUdMhmS7R13ttly5ugJXx783Tqx5DD0NFcSOLr71ndnmaXWcHTi2lh/3Koxsb5jpRBBxSZkjri6E4THo64aYnNbKY7Whs27KhpbjyJeHVKqH8iSKXzJ7Rn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mhms6b//91eJc2a4kAuYZJU+p1irmdab4gmaFzs3WE=;
 b=NDjpcl0ynzrgf1xZRdo5DyrSXip4BQpxJj8cfg8Rs8eBJcGsK3gsDMf9uCsLv2q89eBdjh9szjw7jUAQ0Qh9bAoLfR4WOnH3v7lbiTxss8ZyYdQ8aAcLc/ut78xOKnUeScmIX1XIYlAiNK2wr9/oUNCvhCEfi+rmR8NTe8ZI/3o8oWDUweYi96HgAIhe+tSxzkXzD9mvz05PZnsj8STkCE9XHRjMcTKvGsgbur9fm51jd5svcs0z1HphaCeZPHLnbaFy7flfJOD/n5r1YkGg6KWXZlwjBYPVjfI+rPFq3cvuJSTB9Jr8hm5FdaCWco7LOVoZ3Om8RCYlLpS6P7C/Sw==
Received: from BN8PR04CA0063.namprd04.prod.outlook.com (2603:10b6:408:d4::37)
 by CY8PR12MB8409.namprd12.prod.outlook.com (2603:10b6:930:7f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 05:52:52 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:408:d4:cafe::fc) by BN8PR04CA0063.outlook.office365.com
 (2603:10b6:408:d4::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 05:52:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Tue, 15 Oct 2024 05:52:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 14 Oct
 2024 22:52:30 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 14 Oct
 2024 22:52:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 14 Oct 2024 22:52:29 -0700
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
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1d31b7f5-6843-406e-98d6-6344e39966e9@rnnvmail202.nvidia.com>
Date: Mon, 14 Oct 2024 22:52:29 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|CY8PR12MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: 06450ddd-2091-47fc-dda4-08dcecdd9b8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mm4xeGQ3U1Y1R2pXNVBkdExjNlF5b3VST0NPWllZbXQ2Y1lHczI3VkllbXds?=
 =?utf-8?B?UDZQbkhZWE5LMUp1bnM3clZqaU02cDlmWlZ3TU9vK0NaR1p5UmxjMXZJVDRC?=
 =?utf-8?B?cTY5ZXhCN2JWUS9xamVBYmdrK1htMVVXRm04TEhCd2MxS3Z5b05ON09DM0k2?=
 =?utf-8?B?WDZSQk54bWJFdlJOWk9CdDJ3bEhodUE2aERtcmZ4NVJxenFsM2R1aFovL3lp?=
 =?utf-8?B?b29hbmErV0hrRGNRNzc5eHR3ZGFtekJiNnlQMFhZeEhYbFVxN0ZSM0xiYTMz?=
 =?utf-8?B?VmtnY3puTnpYWE5CelZXMW5GODAwcGIvN3k0Rm5NcHd0RytDVzJUbWV1Qzdx?=
 =?utf-8?B?RnVoOGo4ZU1zNHR6RWJEa1U0UGhtTFBaK0lTSU1hN1VEU3hLaXRGS1JHVnc3?=
 =?utf-8?B?L01uS2p6cU9LeVEyU2N5QThuZkplcUxBUVJmZWk0Umg5QmpEK3p3UEU4Q29l?=
 =?utf-8?B?M2dmTlJSQ3k4S2tDQ0U0ZmVueW8yZklCbmlZU3QwK0pTbmxudHNXYjZ0OVBz?=
 =?utf-8?B?cXJhU2RmbVlmZlhOV3JWeXIrODRrNmJndXZsYkh4cVlWQUNtWVFSSE5wcGxm?=
 =?utf-8?B?WVRQcWx1TnZNMHA5RHFPWHBpVUY1WTRBaThWaE5FNEMwMUNzUVZQU21Lcjd4?=
 =?utf-8?B?bURTRjFvTDFTRkhVNytwMXdGeTNzRTBuNGhlSGFWbFp4YzF2d0FicGM0Vit3?=
 =?utf-8?B?NUVRZlFrS2RpYXJTcUptL1R5QkFWeW43eGZUeUc0T29OS3owdUNUWHRrMlpG?=
 =?utf-8?B?d3NVUTgyTm1jbUpMbjU3czVwYWI0SFhyZG4zMEdGeEhrSXVveTA2cyt5T2x2?=
 =?utf-8?B?YW5PMms3YzNoeWV1V2pOcmVMeEFFTVZtRXdaaWVnR3MyYXJpSGNkZVdhdGRQ?=
 =?utf-8?B?ZWEwQy81RmNtVnF0WjlkU2FncFhtUFVpdTRpVmFWQTRiYkJIK0xXYXlpaFps?=
 =?utf-8?B?ZmxjM3IxMjhDdDZLa0NJTmdnTkZ6L2NVREJqRjhjV24wdnlSVENxd0U4Rk1r?=
 =?utf-8?B?cTZDR0pkWVg0K29VWFRsenFTM04wNWJIKzUzNzdSc2JVZkpXV1FZQ044L3J6?=
 =?utf-8?B?WGdQU1AzbStHeUx4T3RVY1B6KzZLYVlhZktVOHIxQlNpTW9nMWcrSnhsV09T?=
 =?utf-8?B?d0ZMc3UrSG9RRjFSWXBmMkkydlRJTjFseEhWZXVwMitlOE54aXRZd09ZeC9m?=
 =?utf-8?B?VzJSQjArd2JoTlBBa1VaYXpWK25JUUwwK0hYKzZWVW9kSnU3cUxPY0NGVmNV?=
 =?utf-8?B?L2NmejY1YnAzU09IL2JHblRrV2dzODhQQm4yVmZRUStlenR0NE9INmZWRUFx?=
 =?utf-8?B?VUxPNEhwV2pUNC9VMFJCUUttSUNFcndvRVVWYXpKanVQWjI3ZXJ0YWpHakRG?=
 =?utf-8?B?SjBVRXpLdURwbElZcmRqcWpWZGVIcHBjZHRpM3l4Z2FZamIvOXltYjVkeWo5?=
 =?utf-8?B?MGE1Rm1yQ25IMkQxUm90MHdTNHdtdzd2Q3c5b21XVFNxckZtdjVPQ1hIUDJh?=
 =?utf-8?B?MW91T1hQMlhIRFBOTGkvdW1wTVpHcFF1OXp5MXk0N3RtdUZWdTNXWTh4cmt4?=
 =?utf-8?B?VkJROFM2cDVqR0ZsN1BZUzYxVHlyNEFIVVNNRGZBNm55dzlKaWNGMU9zbVZq?=
 =?utf-8?B?dkpHRGZaTHp3U2RNZHJjQjhVRXVsZGVlZnVDc3YwbFNBYWZESTRSTlhNREhF?=
 =?utf-8?B?ZkUzbk9WRHNNMzVSdnNEUDFrMDd5MFJuaUMxakxlZHBMTVNUK0loTFpIbXor?=
 =?utf-8?B?eTBmcElDMytFakp0czYrU3JJVGxCU1RscGt5b0dBcVVCak5GRlE0UTJJM1JK?=
 =?utf-8?B?ZDRlazZaMHpCR25VMk9wdmlvbHFiTDRJR1ptWk9WOStSTWxDUDdmeW1YNFg0?=
 =?utf-8?Q?64J2ehPZlFsXk?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 05:52:51.9233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06450ddd-2091-47fc-dda4-08dcecdd9b8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8409

On Mon, 14 Oct 2024 16:17:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	115 pass, 1 fail

Linux version:	6.11.4-rc1-ga491a66f8da4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
