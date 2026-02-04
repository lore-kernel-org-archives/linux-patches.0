Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011058.outbound.protection.outlook.com [52.101.52.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F40342DFEE
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236881; cv=fail; b=mJl/z2GitRmp6NR02hkSvKtxT6VL/W9LZctJBMmiqE78AZgxiv0fSbqF3P9H/Xcjyn9OLBAKqv7t3JaLJX2P89nn/IaPbo2fRQEtPvCAAlmZ+WrX+wCuiIEOCkHMCbgM6XVGqWMNxFjonMzJNv9c6Wfn+j5GZdeKffy2y/JajlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236881; c=relaxed/simple;
	bh=NTiVDr1bxl2g7nzDqfxoGV7ffYQAG9acV1qR/ezznP8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XUAoqScqoQF0ZY9440l3KvnAsnzdE4PRp1/mzmMNEKPsbvDcFYWePWatQ52oHCof1b3n8XqcxdqR28CuvP5OP5dRnszvXnSu5C5u6oheO1WFYsPH0bJj8NgcdR2+O8FyQM9vzWYLGuUNzGJOcy3CJEAtpISAiDcaUQODQEoeAuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YIEP01CT; arc=fail smtp.client-ip=52.101.52.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YIEP01CT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5teRmHY9dQk3hyrq5aVQBENjmE5Ka2Zmf8w+qHATMNiI+GTPtnF50/xSfLTgKt94fWd0fA23W+NQI/4GB4+cAOf/zgy+0b8MKBtuZVqXlVGUzLD9sbMEnSTsAMcKRD+cYfEweFHi9SEL7R4S7liaAcnYzsXxNAyFJ41IVAdvpJXvkcbRMQtoy1aFHJOuhpilXpDoUqlYxAecrB8WVhxBP7EvGGH9mq0I1EXjoiwusyfa21ftRELJLS2y9sm1lL7UOMolB8jtM0hVLoe6iURvmzG6BYzRs3IGQXTmB85Wot0uH6yzso5VjDAwUvMfSNSyw5vw4Jwxoh+o0Hn1VsCkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0QOP0vdszZ66MjD2VbH63iJZpUdRdNl0A8PrbnuJlA=;
 b=g77GQnmvayYBxH7hmZ8EpdZx5Chf9FqaRUIyaMDYMThJR0C/ts4N4gsdc5O2ubaTe/A9fsUx3jJQCfK6Wecn+4DOKdb7WbYYk3fqCnRAtyD4z7qZHKYl/603knFhXItUZlY26zMPOv6CWOYVkWB8PfExHLTBwsIbaUzMU2D19N3dvkLw6BZJo7pHzIKivhZuGSkv5TEY9/Zl3rLk5XJFaIKsCNaFgo61AwOjWh5LQYesFPF2p0AQkr89Uq5K0cSdo/iu6vDFAsUOzq9UpbwVUJgScOMBShyFstFEarNDcGf0mG6NtcbEygLaK8adr11lczaMUeMPj9jTdYAseuBiDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0QOP0vdszZ66MjD2VbH63iJZpUdRdNl0A8PrbnuJlA=;
 b=YIEP01CThLWQ+Vld+Kk0QT7rHvYJoYfC6z3Rr/Q2jo+MHe72kPUq2owDXHqx+T4KwQgTfBV1tn2j2BMsJHw/btSI5nuIRIq1CRis+kYijIH1smRi36Xk7j+VK0xarHuzJStpq232WQOPpxGsSuZUV0AmhN22VR+4dVC7IstLQKGAaIGjhy8uoDoHibSGoOEPCP47//heGBd2bf8kMiuehjytIxWV1AAKoVu2x/Sa4gHDhUtKHeCx7LS1sn3MHqG+So4MTWYeBIPYGLynm4ffaKtloI0eSr8riuclSk3PO1Fyg2kI4EUc9YaVrDTHDlcTGvuEW+A+Cv3h0++dRXm5lA==
Received: from SA9PR13CA0131.namprd13.prod.outlook.com (2603:10b6:806:27::16)
 by SA3PR12MB9158.namprd12.prod.outlook.com (2603:10b6:806:380::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Wed, 4 Feb
 2026 20:27:53 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:27:cafe::e7) by SA9PR13CA0131.outlook.office365.com
 (2603:10b6:806:27::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 20:27:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 20:27:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:31 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 4 Feb
 2026 12:27:31 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 4 Feb 2026 12:27:30 -0800
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
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c0724551-f57f-48c8-8418-8219a7736da1@rnnvmail203.nvidia.com>
Date: Wed, 4 Feb 2026 12:27:30 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|SA3PR12MB9158:EE_
X-MS-Office365-Filtering-Correlation-Id: 661cbc2e-d261-4632-c4b5-08de642bdf85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3F1U291dFFMeWV0c2Z4V2MySmRudElraUEvZkduc205enlKOVVWSVdYMUdD?=
 =?utf-8?B?eEtZWnIyZlFtTll0b3RwWmsrVXpUSTVIN0dPaW5KMnpXQytRUE1TQS9UTWpS?=
 =?utf-8?B?ZjJ6MEdyMlNhOHJHcldsZ1hWNkM4bWdpcHNncFZsMm1Ycy9mY2NaTHdWVzJy?=
 =?utf-8?B?Uzh5WkhrWm5NV1ByWkpieVFXUitqajN2MVAxSlpMbGdoUm9UeklTdXVhZkUr?=
 =?utf-8?B?cUFsNjFISVFjNEtRNnZBeGpvVXJ5Q2R0eUJJZXZtaUxxN0JxaHYyMmwyaXIy?=
 =?utf-8?B?OHdmV0llaDJiMWpsTDJrcExERjJGOUpFU0lGb1B0NVcrbDlUM29IVlJtcjNC?=
 =?utf-8?B?ZVN2Vmo5ckxvdVk5RzZTTURkbEJHeTZRSXRGYm9ySitERFkzeVhDbDZZUFZ3?=
 =?utf-8?B?OTV6WFRRVXhxQkdKcGEvcGRDaEhzY3lMaE8yYjZJMUZNNmpvUzIyU3hyanF6?=
 =?utf-8?B?cUFoNkdjWWt3OGZSTDFMMGswK3hxcmtwUVFHZHczUnRqWnFHTkJ6SWhTRGRC?=
 =?utf-8?B?QVppK1VseGwvMjQ5U0VJRis4QXhYaXlJdUIvcEtqbG53T0syVUJrdm9wVGpl?=
 =?utf-8?B?Mm94UlNqL0tpb2dPSk1DdW5mTi9WVzB3VmhEZkM3V003TXcwamFyTFI4R1M1?=
 =?utf-8?B?Sm5WMWRwTU03OEZpc3cwekdCT1Z1a0c3bFVyYWordnQ3U2ZqcUM3QTUzNkJU?=
 =?utf-8?B?dXB2Skp2bU1rWERVb2hJV044aHE1cjFKSjlsaHh1MEl1WUVwbjA0NWE0a0Fy?=
 =?utf-8?B?K3RNN2JPT283eHVWS0dUaXJ5R2hORXQ3ODlMcU8zYVBlejdHWUtUaTJRU01Y?=
 =?utf-8?B?MTBOL2QwOURkbk1hYU9VNnhaRFN2a0NHR1RGU1dnN0psVFRwYWFjWlBaUm4z?=
 =?utf-8?B?emdZdFdtZ216U1I4ZnBSQy94V2xFYTE0QW96WTdFb1lvTUZRUmFOVEgzSGc4?=
 =?utf-8?B?cFNqS1NRbnBpR3N2bFZHYTU3RS9RajdGMmdTWTFBQ1Z6azh0a0dxa01BWVo0?=
 =?utf-8?B?ZkFNbmN0RU4rbyswWUwzd1hSSzZwVUpFekxCOUhJbUlvbDR3MlJDcFBkVlhR?=
 =?utf-8?B?bFg5Vll1aHlSN0Zickg1UGRBcXJZeC82cWJ0NGJscFVua2c4Q3VGWEVCQTJ4?=
 =?utf-8?B?T0R6RjF2NlA4UlBpbVArc3hkK3ZQNnI5ZkZ4VlNGMkJtRDhSUzF6QzRLK1pV?=
 =?utf-8?B?cTh1UDJVcUdXeDNDOTFrMXpRY2J4ODJjb29nL2lLSkU4SWtXelpOTGlmcE5O?=
 =?utf-8?B?YkV5cU5seUxoL3RYYWxnNGNEUU4vVEpKRkRNcmZRTVZzaUxrd09sUWpzNE9j?=
 =?utf-8?B?L0N4M2dseG9XSGdMTWxvNUtXTlNyaThFTDJDNnpBY3d0QlMwSlVmaFh2L2pF?=
 =?utf-8?B?THlWU2F2eTRkZW9hdlY1NUpvcnpGSkFBUEV4R2FadlZYaWF6eHVsY1k2c2dR?=
 =?utf-8?B?TzkyRFg4L0tCdS9qVXZqazZqWnUxTzI2LzRYeVhXaGxSWFIrUmdGekJxaTVp?=
 =?utf-8?B?NGhKM1QxZkY1Z3hvY29jeGQ2NnM2K2FpdzFqdy9BYzRIckVmcXcxR1hEM2Nq?=
 =?utf-8?B?ZHZFcitZajcxV3dqbUxySzhvK3psL1IwRDhTT2R2SHljSHJOOFpxVmw1MjRR?=
 =?utf-8?B?WVNmTEt3RmU4Umc3a1RLbVNSSk1XbTFZWndEK2ZWQUpmcFFEaXdJZ211V2Zq?=
 =?utf-8?B?OXc3VVlpemdRWWxwamFvRnk3YTFNMFlRekU0cE82RVJWc2JVT1VMaTE1MHh5?=
 =?utf-8?B?TkFpdU9hcVJ2Q1drSFc5RGtPNDBNNmZEOTJQZU1lSXZRZSs0NGd3NjViZUh6?=
 =?utf-8?B?TzhXeEFQZ3F2eUM0QS9hOUhZNWFQODB3MS9salJTUC9EdzRsaElzK3QvWkZY?=
 =?utf-8?B?dCtIUE56SDI1NzJQRE5zejBVQ0JROWlTVExaZCtvMncwOS9TNzhKSTk4bVRT?=
 =?utf-8?B?WE83ZXFzZU83VVAzQzZDa0g1akFMTXd6N2lJUDNtZ1NvSy82TVJ1bS8rbkVW?=
 =?utf-8?B?N3Y5SFNFa0NZbGxqMitma0M2UjVjd1k2MmJ5MHFzc0NISmcvOTlrNVBwOUlZ?=
 =?utf-8?B?Ym9XSFlEanZ1RGI4TGRHTEkvOHpXQVMvaHhwY0pnMDYwUmt5OG1pOFRyeS9P?=
 =?utf-8?B?QkhpSVlBY0FlUDczOWd2YlBBLzVDVThPUWdRckM2SWRrQ3lEN0x3U2dQU1hC?=
 =?utf-8?B?NWhvMTFxc2xjRGJKaHNBQkhMWUEzcVgrNDVoT3A1cnFkT2lFN1crKy9UbDRB?=
 =?utf-8?B?U2ZjM2I4WHVBQjlvQkZlRWtnWWNnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Gn9HLz85XADRw7imaL4UqGyz3gUa3HVb/v6Os9/Ovt1DaEWjeBpASu/Zu2pX1UUjo549Fypio++ZjtHOAIoRGZcfJgjkiMJNV0Zh3iiTKhEYAS9FNU0ggIqPlSHN5n43MJEX0AZZt827tJ075Wy6WCkxqXVXV68wRrJukJ1kVRqWWMfeSjAbOI6lVq1LdVK8fWFN+plp0v0/VVFW0PXEqQW6/UK0coi3WriIO6Z7lFOfvtwN9LHbJWvskSt0vbpkNWtW+Wshj9MG94lwH0G1tskUiVR15LKKbyIwua6tVPkIMgOyyEomBSST1I4WF93dedNbS3wpNFsCplRsZm2vFxt6mpHP+Ou3V98qLfkOtV41VDogDFvuA7dXlt2PUL3mFVoPDjoSlnnXNCfsNv6wa4Nl1Gk6N5g2VQOu/3t++VvhueGkzEVwEycp2i6y5tU8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:27:52.8220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 661cbc2e-d261-4632-c4b5-08de642bdf85
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9158

On Wed, 04 Feb 2026 15:40:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.123-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.6.123-rc1-g0df15a691d02
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
