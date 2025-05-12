Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4D298C3D
	for <patches@lists.linux.dev>; Mon, 12 May 2025 20:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747083411; cv=fail; b=bvXCzAnLYfdfkQJ98pt9j633qT78Dda+Ypp4tJub8XY8l8g/Nbvp6tae/1b/Dp1Ma3KX5770q8uZIszw7KnDtCGx50FEC7MENMMl2ARIknq1dEzKwT6Ut+XR6irGjzjBecOsKaInZRa07RyxTM1lP304VuuDnSudePtP1lDQ3OQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747083411; c=relaxed/simple;
	bh=vmO1dyqjX+zSgblK5oYjSpckS/9eaMGFrnyE9sN4gvQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HOoNijiKAggpV/Tg1ea9ULgXcz/8ESuuqlkQz92igHy3kEcefS0083/yxSr58CdLezA9kmVjV6Vh80H7lhC2Mb5sFuvlwi9qh/g7C2FuflL3gqVLjNzs9F4l48hntdyzXzDKzCuh1CWLxMFu0Q0bXWf42jrD0dbknLQxM5O5kx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MCU2uYFy; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MCU2uYFy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTCvdVmX3faCRkOD/PYQ88PZN8ZbUmaxQARNlJuPmnYYAiIet5bkyL+iYgjrO+FG3uY5PqXf3TSYpVflLDpppToGtqokWJXNncBHN6Ty1ZJBi0sONRAF9WoBIAYSCSGvyLJ7miIu8lXwbTyRYFJflygikxyL0VUqyhABr3RM/26FFpMkrF4ITwSVbcGDgtCm28KP1ye4ER3cMOmakLy9rojZQD4dCLKxMq6GgFtx1HVbVvjM9JVJDVEBeuEnKpn2jU2KDSo+M827VwLuaBQe/elsIJqwh1oAC+uOXzrmFMd2SwkzLHGfcqdFEMw7CXyOFDujsL4ApdgB3xL2bQV7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BjOW2mzje5LsOPitI0PAvQmTlw/tSRxeiwcKxB/Huw=;
 b=EiV4VtEzPPhQEvlYuJHbiobJaLEgJQzy+Nxze67HNWTNKE1P+cXjiIc2tNBDXTuzju6Dgc3aTk+l9zuhabzs2t0od73EtcDNaoGvHaiDT08ooNiXWVNAvFOb5bAtVDlN64wdtdc9ciC/jr7UNMSERE8DecFMa8jjVOx+ZzloqNYOdSjRxhDepvokJ8pl3wEUGJsyHAesNarxvFc3MRYx9czZVMDXJgGzG9F4J1RSvCZiIeba8PpgVriWqDFeGDDbDdPVRHsx3H077pAwCyojVapQt1W2bVcKOZDJ7Q0XitQmYaiLn7uvXZ4DeNeslyfs2DXesPDfCdTl1m1yE1+34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BjOW2mzje5LsOPitI0PAvQmTlw/tSRxeiwcKxB/Huw=;
 b=MCU2uYFyYtDdGUX/zPFMWjplanri5Es9xngu8dFyjJpQM4keh6omYOfPQ5zrGLmLKPyyt4PmiJsLPw2GC4oFQq3rNFaPE4TFKVi95enmXKlfI6IiqacCaUPgB/oAKh++8/8c6nCelztCfVkpMT+1hNzaCYrUQ6tbMr3G153cnaevlMqEATbLsGr3oYU7UxydhvQYEUC85xyAAJ8NjHDQiY82YtEbcx90tJMfDJ0E+ZCKI+6UWdqP+8QbrCEpCZ/VAt5rhvAMNj8QaHHzeBIHeYihlyNwbq99qSsIkKiBJOwkQhitYAGxiKCkJnPd/dbF0DkK0vRhmyPyfBcQUyiWCg==
Received: from PH7PR17CA0042.namprd17.prod.outlook.com (2603:10b6:510:323::21)
 by DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Mon, 12 May
 2025 20:56:45 +0000
Received: from SN1PEPF00036F3C.namprd05.prod.outlook.com
 (2603:10b6:510:323:cafe::46) by PH7PR17CA0042.outlook.office365.com
 (2603:10b6:510:323::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.28 via Frontend Transport; Mon,
 12 May 2025 20:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF00036F3C.mail.protection.outlook.com (10.167.248.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Mon, 12 May 2025 20:56:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 12 May
 2025 13:56:33 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 13:56:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 12 May 2025 13:56:32 -0700
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
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8eb67167-0e45-40f4-a827-790050cd19bb@drhqmail201.nvidia.com>
Date: Mon, 12 May 2025 13:56:32 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3C:EE_|DS0PR12MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abc44ef-8ffc-406b-9998-08dd91978168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0h2MndtV2J1a2J6RXJBV3grVnVPYUJEUHVEMFR1QVRqUWxkVmx1aGVaV01r?=
 =?utf-8?B?MVk4MW5sMkt0RE9BaGRSS0tOMzErdWJnUXFySEMwbkdUQjEwdGpORkVleVZ0?=
 =?utf-8?B?V2xOeTdNblhwQm5WT1VpSGM3K3dKR0YyRWw2SHdyWkpKa21EYkRyRCswVU9v?=
 =?utf-8?B?eW9GLzlFUE4rYzl5RzFQYk1ROGNRZXYzUXcvWW9mdHI5VWpxNkFLSGllSEZD?=
 =?utf-8?B?QUZvMzV1Q3B6K3BwODhMTEhIRFJyaThtSzZrd2tOKzNJMGJaWjZLYWw2cUw0?=
 =?utf-8?B?clp0VkJPcjRtOXBhSExpaXkwdFZIMFJFQnN0c3dmRlRjdjkyL2phTWgyZ1RF?=
 =?utf-8?B?MXZQVytCdkRyL0xwbUsxWlFaSTNyTzdPL2cxVzl3YzQ0WVg4S0o3bjVYa0dT?=
 =?utf-8?B?SHU1dE9jRVd0UE5WU2tFS2NLcWozWWhnWnZQbUtnTlFaYzlTTFBKSnBoRDRm?=
 =?utf-8?B?a3dqRkd0N3cyR3pEWjNNQkNKem55V1VYL2w2UU83OExSK2ZZaW1uajBiSjly?=
 =?utf-8?B?YkRxOFpUUy9IUEJjcU8rZnV0T0tSNkFKcHExZXAxR0U1Wjd0cXVXQVV0YWZa?=
 =?utf-8?B?WEZyR0NFSE1zcWIxNEFuZEZKZVNYSjBXc0tROG85RTVwK2pNU0VsMzBTc1N5?=
 =?utf-8?B?S0l4ZysyRnB4MVcvNEtSQXFlOFlUVXhabWxWZkVGc3Nubk51Q0xmanRSbmZI?=
 =?utf-8?B?cnRKSXkvRFhsZmVzT29GMWs2Sld4UzMybSt4M0xMYkRNRVdBSFRPa0xHZTJk?=
 =?utf-8?B?cHdpbmM0YzdtUmlHMUM1dWx6TzBxcDRuMHJtUCswbTlteVhRenZBVGhPb0lF?=
 =?utf-8?B?UnNkQ2RuRFFrb1ZtZmVCQTRscnVXTWd6MlRvOTRWaWZlZzdHM2dvMm00Mm15?=
 =?utf-8?B?WDVwSzIwdjE4clkyeUtPdlNGaUZlbWZldFZOeVVIa2VMSXZjV0ttMjhjMGxQ?=
 =?utf-8?B?aEpVc0krOE4yVFoxMzNqV3JCRUZvUVA4bHdGS2hWS2EwaW5ERldUejhMOHZE?=
 =?utf-8?B?R3FiUVFiVFNCT2xqaDhSelpIaEd4V20rVzllc1JyVit0SHRrTEJybkhTOGM2?=
 =?utf-8?B?Q3JrNjZyRldhTzNIVER5Z0FzWHJEa0tJaVBqbFp0eGdGbGJBN3VRaHo3NzBS?=
 =?utf-8?B?Z1hhZjFuc1BMaXBDZFZKNC9hUVJCSHJROE1SdHlyMERmeFlFNzZsNjliT1Zx?=
 =?utf-8?B?WHpjSVFDbVdmT1p1VkxyVllaY0tCbXJMSUczWUpDLzhsdXhKYlhWT1RaQ25i?=
 =?utf-8?B?Q3BsRWhSVU0vYkgvcDFvZ2NCQVAvTUNsRXdsQldvM1BISHRlWkxUdVNBWTJR?=
 =?utf-8?B?SFpSS2JDY2pNTys0bm5kZDhLNFUrY3NnaER5cml2VHBQN21kMDhHcnk4MS9V?=
 =?utf-8?B?UWx6MEtZK0M0ejN0czVMT3F1WmEvOEZnbktVQUtPV01UdlVYazl3SXZzUTYr?=
 =?utf-8?B?UWIxZVdWWWhCQlNlVUNJeWpieGxNQUl4NkorL21JY0R1SGl4R0VFVm1VY01O?=
 =?utf-8?B?RlRtbGhVQXc2L2hvb3dQdFQ2YlVYaExDV1BLWDlyL2Y3WENVTW85aVpMTlhW?=
 =?utf-8?B?SmxuYUJmUGVmVDZEQ0JzOGtEM2JxZHYzNXAwdzJ6VXZEaXpNMkxQSFRwdUZZ?=
 =?utf-8?B?VElhT3ZXQ29aczZoc3BiUjlIS0hISC9uOVNQK1o5T0FNSnVUb3B4N1l3TDUz?=
 =?utf-8?B?dlozUXVVVnhFRkJXN0NRUzZJZzZRRWRtWENwZmx5ZkMrcDMrd2NILzI1Rldm?=
 =?utf-8?B?blFGWVFiL3oyV09teUpVdjk0N2l0ckZTSm1BYkNQK0ZTamFVRFNSZThIaHdN?=
 =?utf-8?B?bFhaWnFHc3lKREpVRWljMnRvNGh6V056Q09pc0wxQUlBa1gwN3NnTksrZHlp?=
 =?utf-8?B?OVBwREg3NDE3ajJZVmkrMWpLaWJQc0ZhVmNDVEJuL1F4VURNRTBoTEdtb29B?=
 =?utf-8?B?Z1RFOW5pNWxnRlVmRkpmMnJNTWhyU3JNZVhEMUVlU0RCQXd4TkE1eDlIUGRm?=
 =?utf-8?B?YWFqUUlKWngxM2Foai9JZldOSUJKUnVXbWtyWTg2UmdXWWVHdTJIT2lkTTl5?=
 =?utf-8?B?N0RaallKSzMxMkQ3WThmYXRsWlR2aWs4SExqdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 20:56:45.2393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abc44ef-8ffc-406b-9998-08dd91978168
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7777

On Mon, 12 May 2025 19:29:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.183-rc1.gz
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
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.183-rc1-g5aa355897d1b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
