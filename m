Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DF37405A
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025363; cv=fail; b=auGVx7R8B5zsBx8zOWG8bSbha+aT6XbtkXoanetoqzIhmrTodq2ZXZ3UFtOR0RJh4QSW3+eKjsasyX3AbGx9P31tWjlPg+xJcR6iu8ho0sp6LQuEIxuZR+M+VLL3kEMQ61ele6juEg4fY/ygAarlosNIhY5gU6e/6mL5csj7rT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025363; c=relaxed/simple;
	bh=J/uh5A8MQmNBcVsyEeIQdP6rYdNZCSQ0fS/x1xxzu30=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nk/kwO+2+peqR6TvuDE1C643wbITapUFlFyZU1tR6OVn41pJn1gHhShl4PaO8LDv2tvd+bL5bLno2q67WheXJAc5iSAicRFIrLO8VUrfwIS4VeA1CE9yXKiTVN3D1ulWPXusoGijmcGt+6CL+XM8loAgZcXTglvsKw8qOVVNAAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Je3sSrMc; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Je3sSrMc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twDSnzHmx5hIj7giEfOdFdvHRy5aTzJVryV6DcawzVeEFxVQHKNIUh874yV7EeTwoGJ74rgMltwTfP4WCzRvv4Fb5MNXNv0L7SDXCNddn2RAcxfLhTQCnXBwUjnlzVXX7eT/v5X94am9QqiP+vng9l4j3P2ng+qPARM/Z/rBB0xJ68U3m6EdWrkJYWqOYJyq/ikUR38DS/tL5YIh0uX+9LEwX5u64SaJtiroKe3jjvplXqr+8V3cBLr7M0D8ytNJyUbdzCHo+v06jOUiMJlwwRVjHTzk5YtS48+GnJAm+zgyJivrgW/2E/5+bx1YV6D4D3py2BDdsKI61TdPh0jzdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2N6cT93tv55vkdVlso3BB569p+gIO2zoCCn3kiEYkY8=;
 b=ckZhb+QQ8vSB6KoH/3WFFP/uBBarZOqoB7psJRgZ3qpg3rE6C+E/1T7JY2/XzFb/pPr8s+/yycj9GQ/M07vCsy8JUrHoTul6VpUfGjO4yZBlxEAC2HyF0gmYnjFhc0bmlJnpUTh+awmnVDxUJas/yYQnDG8UkDYkNMGqGouR+j0FfEDkEvnfgWQFM5UlNmf6pmiOev/2y1p5bu1I6Ka9SOQ5EVOhNRqkE6WXaH+9tcegGfVdNPPrrOCk61qXRcODMZEa/FPPH3Amxj0/D3j5PjtTBNztZYBKlNmKJQdhwHbI9sWZtEpVE1P76NrGNGTHBUMhti//WkY5HxnmVfyUAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2N6cT93tv55vkdVlso3BB569p+gIO2zoCCn3kiEYkY8=;
 b=Je3sSrMcH6/g2LMmLfwjPzTfyej26gd3YpsCu6JQ1C8qhsXryP986uPrBDFCX1EFL2Qoc/N+YzfGOJXkQbGdSdVJmOSVHEQANG/Rl+UPLArNJBG+PJAVMpsaDcR5ikCB2HhubdNbG3Mv1CxcYkQKoCFk7PCMleArSGnrDGBfty8XYlDmEnrmlcguzuoIGsvAP+/77FFpUJfSlUk3BzIxAcqKV6SPO3JJ3t7rlucOqclqwwEMINm3coBnrAma0dzhWFTYlbPTG5CDVyA7O0ZIM0/IDV0fOU6jcrt8seOFVz4FhjRcuB5qp6LfNv8OLcKbMV33IHBUxYs4XGWpOYBr0g==
Received: from SJ0PR03CA0261.namprd03.prod.outlook.com (2603:10b6:a03:3a0::26)
 by CH3PR12MB7522.namprd12.prod.outlook.com (2603:10b6:610:142::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 15:02:35 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::f3) by SJ0PR03CA0261.outlook.office365.com
 (2603:10b6:a03:3a0::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Wed,
 30 Apr 2025 15:02:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:02:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:02:19 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 08:02:19 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:02:19 -0700
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
Subject: Re: [PATCH 5.4 000/179] 5.4.293-rc1 review
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <53afb249-4903-4d5c-a15e-7f67fc5b679f@drhqmail201.nvidia.com>
Date: Wed, 30 Apr 2025 08:02:19 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|CH3PR12MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: e29644f8-fe73-4d7e-6f67-08dd87f80a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG9PbVNaTG1DNTZsSGcwaUgxNWtzdG1MVzgxenV0RTFPVll2Sks5Q29CTnVR?=
 =?utf-8?B?Z1ZuZTFrcUlwdzJINkhSaTlzaFQrRXJnSHdwazllTDY2MHBmdGU2dklVKy96?=
 =?utf-8?B?RGNrUUJlRTBNQTh5L0hnTHVkdHY3TnRWN1NIK01jRWduSG5pOUlwWnVGL1My?=
 =?utf-8?B?SDRTT1hsa1g0RkMzaFZuRjdlSEJrVldwYkZoSmxTVzdqWDlPVElFVFlTeHd1?=
 =?utf-8?B?cEpLMjJDYkttVWNEMTMzSlpGVHphUlBFN2pET1hLSzlUNkRRcnVaVHY2dFVz?=
 =?utf-8?B?OVZFUXZCb211NTFYMGdVdW5Rb3FoM21WYUhBNzFHa2Z2K25kL3h0VUxOcUJa?=
 =?utf-8?B?WkFhMDVIQ0I5ZzRIYW84MWJTQWU0ZmlvOXJ4M3RscVg2T1dxdXBHYytwQ01V?=
 =?utf-8?B?SnJDQWhPRjYvcno2YlFCQ1pJVFBMaWt2NlErQ0cvNVBSV2F0QVRvVjFWMDl0?=
 =?utf-8?B?dkU0V25UVGw0ZGtvQkFqWkNHZE5TaXZVQWg1TEk5c0lydUgrem9wcGNobTdj?=
 =?utf-8?B?M0dWVUgxYW93V1JTMnJxWWhwUmliVWFDcWkxVkNLMW5mcVRtaDFuWDI2dzJV?=
 =?utf-8?B?d0xVN0tJQUIzQXNFeGplcjh6KzVNOE9CY0dOeENFU1owZUhXQzlseEFJRkt5?=
 =?utf-8?B?eEZYUXVzSDI2TEZ2b0t6Rzc4ZzNaOWRhUGJ1STBaMlFSQ3UxWmRoL0dEYTVK?=
 =?utf-8?B?Y3U2SGU5SlRNcTFjOUk4dFZBOStuRmNoMG80TVF6cGE0MXQvOWlpMis2QU8w?=
 =?utf-8?B?dTdjUXVveEZlQWplUlpkc0c1eTZLaUJFTk9aa1RHWW1yWFJYc2VTbXIwU0NL?=
 =?utf-8?B?cmZtbzRJV3Y2dkN2OStKVHJnZnBEbXpld2Y3bFhtRk5ETXl3Mm1ucndhZ2I0?=
 =?utf-8?B?SVB4UHBBUEVOZGIrejFXYnVaYWEzRnBJbjFBeEVWREtYdkVhdzRvTkUvWkpm?=
 =?utf-8?B?c0hOZU92ZVd6ZlBZanRrcE9iNXlEZEdFUUMxejBZVzIva1hiZDYvam1pOHo4?=
 =?utf-8?B?U0hhMVVZRWdVZmRxSmFhYTNNOEdqcEY1aGtGVU5QeEkrOUo5Tjd1RnhRa2pT?=
 =?utf-8?B?dGVBWFVsQk9PL293YmZWcWF5bzRZOURRNGlLaTdZb290QjlkNDNFenRGdUVK?=
 =?utf-8?B?VEtoNGFyRFVnK0N1VWpkOVU5ejluTDZWOUV1TGpnWUs1WVNGRWFyZjIvZkNR?=
 =?utf-8?B?MzBSS05VcnpRQTNOejlhK3lvdkdzVW5paDF5YVU4VWs5L1RTWUxzSXg0Slc3?=
 =?utf-8?B?UFRBbzZHUlY3OVg2N01JQmtKZ2dRWjBrS1JsTzFEQjYrdGJYaEJiS1R3cDRy?=
 =?utf-8?B?L2xmYUU2R1N6WityTWxKYkpYYVMxUmx0YnFFaVJRM1dmLzJXMmxUc1c5N0E3?=
 =?utf-8?B?Z3pQUU5PZ01ZMWdoRmdnazRoWHdDSjdQOGFvcUd2R2VXZFB4QUpkR3dLVks0?=
 =?utf-8?B?bXdnK2JFSk5ZUi9hMW5BWFBwMlNvVmZoaTVIcExOR2NCQXRoZ2R1b1FsZ3lY?=
 =?utf-8?B?QWpxOEpTL05TdldmRm9iN21pSXNianFIemRSSitDTisrR2xQRDFWWkhhNDNX?=
 =?utf-8?B?N2Nlam41QVNxcGVJYmd0dnFDb0hlNGF5cDJrOTJWUnNLeHpzcmxnT0xNTThu?=
 =?utf-8?B?WTB6aVU4c1Y4TWdMbEE1Y0hEZzJ0Rk9pNG1EdzRjelcvTThvZXl4WXFVSytH?=
 =?utf-8?B?SGxDWEZhSEd6d1pnZExGZXB3NTZsclUwSkxpVEFUZmU1eVVkaFdKemZDSGk3?=
 =?utf-8?B?bEhFUmE2OXdjTjJ2WVpwd3lBY3BQQmIyWnNkN1FWaW8vaXc3NUY2Z0xYVVJx?=
 =?utf-8?B?WE9qakw2eUVlQ0puaGNLem4ycE1xbzRkTXYvMU5DR0Z4aGJLNkNZSURxT290?=
 =?utf-8?B?UDdWcXpheGhhZGVLUllReklIZUN1WFRVSnBmT0ZqZ0c1cENnS2xjNEZweFNw?=
 =?utf-8?B?SmlUQlpMRHEyTXdDSVpaMi83cEF3N0NGVTZjU1BHM3NWU3ZrSkdLTENLUmFi?=
 =?utf-8?B?TGtXRkMwSWRIZGlaV3RLa0xGbzgvUlBMU1h4bGVaL3VXWlk0OS8wTVkvTEJk?=
 =?utf-8?B?ZTkzeHFad29XeDNEL0NqMXhUTW9lUFE3Ym1IZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:02:35.1400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e29644f8-fe73-4d7e-6f67-08dd87f80a5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7522

On Tue, 29 Apr 2025 18:39:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.293 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.293-rc1.gz
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

Linux version:	5.4.293-rc1-gd5e62da0f6d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
