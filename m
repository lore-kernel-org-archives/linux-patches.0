Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2065.outbound.protection.outlook.com [40.107.100.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1786D80C15
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720600503; cv=fail; b=HRkL6Q85Dl8cHMQIqT+0l4mt9trFuAJ2NAfLaPmPa4cCSCP1nvZD7Be3upAPUx9YQmCmK+eepTNvfsgyPBPgVJDrwKZaFD24KExxB20s7eEJ0FgMRhyeTofGZfZVOOaU8IfPSRT318oSpHEi0XLw+BklUnQMTXD062zBWgiE8Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720600503; c=relaxed/simple;
	bh=scm/jL9LHcNoS/+DpH0wSSyNOpzDBY3wKBIFKEzs6XM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ie35JSepZgd0bDhN6dwyfHBywbVGSUM0euAPLyMLnWDoHxhpYdlHpyPR5+s6lqNX9j0SeAGczMQuiePFhT+DSxYCq5kXmZFQeui/JeS5zpuyVi3G3D+4o4r5AZwQ3W7v002E/BsRIhRY8aaeM7KYQDiIs1ILZlpv+YVhHZjC7gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lBuDx0NV; arc=fail smtp.client-ip=40.107.100.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lBuDx0NV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNm2Lin4E8YgyKIIh7kaGMRup4bB4k/yF/hovnSzCK5dpKGlttnn8MhqxapUhWITgM/DybF84xszriP3Jp1lAvsFU+EklygFajyZEX083ZKZIs6tWVuUVTlZgEl2eYHssxwBR5cIrUICnQ7mybCIdxHFTStrTOjRnn57IgsSCuP5IQUj4O4pEz2NC+habtLCJBu77uoQQpHtkOO4PbAgqG2QO1/mBPSyFIOndAr8fNmYzKcPrcZ+oivc3sYN87XAILvUnq7HHdOM18ID4I8F1I0Fmf6ji3EtC4A2qojNlhK0HWseIzJTQf8cACpKYPnCynjVJajiK9ZgHjHJFxz71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7MKANKoZALLbRySBEm2PgP83oPDOOPqfxgj3WgST3g=;
 b=TaXQRiuQN9ZfRGVc7mRFbssa0laqBZfN5ouKa0FumZ7S86IF/fAVDFnR2WWtn34TCS3KrJtowpZxjAiWpIg/bDTVeoGroi+Rn0Z8ENxsZfMD7CbPYQF76hJr7TkpV9PVAFEa22icKWlBySJD8tt/Eghm1qBpxK5Iu8HUSJKaZjfhrZ05O40CfU5lLbMS18MzTL2hw1Nx78J0dUwYzDJG9kxSZEXgnhPRcrDkwarw4N7jCwru/DTAx70fyMsT+c77M9KVzwshFkQlBLIsECPfj619jhFz7F04asPGo8DXkvl+oLjCS1xZeLuSbFcqpcYSJh6JYCfZq1RKC4HAsuWX2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7MKANKoZALLbRySBEm2PgP83oPDOOPqfxgj3WgST3g=;
 b=lBuDx0NVZ8y1eGOKB49qElvnUKHYt2BuIP5M8CnC8x5qR8vzZkSFHIkIqQDzn3aX3cR6SsKU61eTTLa527av7ZinnA4v5Yn0Kw+q7UOCEEWY/r+uWSSuFfi6vnYFTMVYNnuzDYt6aJSzAFONK1CZFvktBzm5tK2jwKcrODIdS5H4RrEfyvtDIKcnQu1J91D/j0WGA0I6uv4VNhmdJxVUD/YwdpYHwQhiSLfi/K8Q7ddSvx34HHaSBsNoaOQkhR89ySNLgpZs2EcwhcRbzmUFOUhgtL95q6l5UY9SVIyfVAGH1noh6Tg9fVj/0XaL1Fkq+XV9ab2b9TO1psn8yTv63Q==
Received: from BL1PR13CA0110.namprd13.prod.outlook.com (2603:10b6:208:2b9::25)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Wed, 10 Jul
 2024 08:34:58 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::63) by BL1PR13CA0110.outlook.office365.com
 (2603:10b6:208:2b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.21 via Frontend
 Transport; Wed, 10 Jul 2024 08:34:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.17 via Frontend Transport; Wed, 10 Jul 2024 08:34:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 10 Jul
 2024 01:34:41 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 10 Jul
 2024 01:34:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 01:34:40 -0700
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
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d93abe00-a39d-4500-9cd2-c86927a801b1@rnnvmail204.nvidia.com>
Date: Wed, 10 Jul 2024 01:34:40 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d33322-d8aa-4e2b-fc5d-08dca0bb2ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmM1dCtQVjhlYTRHYjFxU0pIb2NYZGM0TGc3TFh3aDVKYUFMNWxEWHVicHRk?=
 =?utf-8?B?ZXZrdkRKdEc0R29aSVNvRVowOWpkRFRxcjljTGNxdG9VdTZKcGpLdklhNnUx?=
 =?utf-8?B?dFdVd1lQKzBZTTJvNll2MXZDbmxEZnhOQVpBdmV3YUVUMlFXVWx5Y2Q2NDQ2?=
 =?utf-8?B?UlhCY1ZzUTZwdHRQSnBYbnlHWTEyN2lacGFrVW9odjBSOWsxWGhNeFJNc1Rj?=
 =?utf-8?B?aXh3alNUeVRBcmRpQzlKa0poUEplVHYwU3RtWktGaW1YL08yTUFJOU9uNXFy?=
 =?utf-8?B?OFFrRzJ1SWUzZVlnVnZxUko4dTF6RDdsNVpFUGE1cUV3YVg1ZEpGamVCb2Ni?=
 =?utf-8?B?M3dqOE5meFpvNG5UbGFUR09HakRHVmc1bGpEWkc5U1pQMWF2R1QwOTRURzd3?=
 =?utf-8?B?MWtPOW1TUVBwSUVsN2RFOXE2ZUFwbk9QK3BNRkxKKzVVNEpRcmJ4NWxJc1BP?=
 =?utf-8?B?Q2dwZ280cnJ2dXNpcUJaWXBNNm16TWtKYmYrTUxyRHQ4UUhHdkJJQm15YzZ1?=
 =?utf-8?B?QU9udytXTHJYVXRFUHVaT1QwbURLbmsyTGpHQmJCZVlEQXZ2RzArUVJqZkZ1?=
 =?utf-8?B?Wk9taU9zOGdibmZqMFdacnhKUnZJbHQzZGlQcDBDOTNPaWFQMzN2NDluMEZl?=
 =?utf-8?B?dzkwSEhEb3J6VkNsa3lBZG50VWhSVG4waXorWVVlMG9QMlFPTWRXMjh2YXVw?=
 =?utf-8?B?U3h0ZmpBUlN0RnliMER2eTFodDVOTnRneFdZSU1HREtyNk1QQVA2dHd2NjBC?=
 =?utf-8?B?L28xbGk3TlBZMmxHdjJBeERYcXp6SWF3Q29OU09YTi9OZS93bUdpQ25STnJN?=
 =?utf-8?B?N0h3THZ4cVpBYzRFUTBjb1Y3ZkgzMk44S3dDdi83L2NycmdybVlDaDQ2UVla?=
 =?utf-8?B?MzN4SEgzckpJdTMzdFJ3OThQYUFPSThGMGZJZi84WUZNMzdMaFpFakJYdkFI?=
 =?utf-8?B?N1IzT1dyZ0FzUmJTZEluZHZic2YramlPY2RqQXBsU2QxcXhaZVI2R2N0b1R5?=
 =?utf-8?B?WGEzTlBvWHI0YUcvZkdZVU1iS2pyNzRLK2JhREdWNGcyaTBaODR1c29xZmda?=
 =?utf-8?B?cHJrWXNRdHQyVVFDMGxMVVVkcmdRZ2xqKzRCSE9ZYlVIK1gwRXB3ZjRLekZ5?=
 =?utf-8?B?SGZPc3VDTE5GR04rMTJBRk1JQ0RpZWd1QkJsV3ZKVG9wZWlva0hYMVl1c0xp?=
 =?utf-8?B?NUZiTE1KK0hwVnl3MzdObnkrKy8yMklzWVNYeHJSdnRCQkNDWmFlaUZJVWk1?=
 =?utf-8?B?VWpueE9xYWZjakFwRDBhWmJ6VWk1dlNMSUsxVDQzMGNiYmtuVWZ4NEJUZllM?=
 =?utf-8?B?V01nT0ZtQ0dVTEk2WXJKS3M1MFdMZE1WUlJmY1RCcHMxSE9nSmNIV1hhLzV2?=
 =?utf-8?B?WnI1SHpOQytsKzJhQ0Q0QncxTEhOVUwxdjR3WFltMytNZGFQVHVGRWZzYTNU?=
 =?utf-8?B?YXRsaDVHV1laK0VuSTJCZXR1UFA2K1lraG1SSnIrOENTTnhCUDlXanFzZGFG?=
 =?utf-8?B?cUpIYUgrVVpjUWNSOFZicWhzZFZLdVVHaDRWam45UTdtU3JBeHhTekM3dGk2?=
 =?utf-8?B?cGNueWpFd3dQR1FPQW4rZUZyRm4rY2hoWGJzeWlWNUd2dE1KOEh0NFVzRDFU?=
 =?utf-8?B?bUlySjU3Mjc0QjFDY3pCeGtVcWpMS25CMWI0dG9MRDFVTnpySWovMkxFVzQv?=
 =?utf-8?B?ZFNwVXdGVW8wRHZhMU10ZElwWjJJTWVRSjRwaG9SOG9GRVRHTENSaGhFYkVq?=
 =?utf-8?B?S2hSVEdxTURSY2Q3R1hPcVFRRTk4Tnp3WHp2NkgxWDNsU1NUYVlJNGxYamQr?=
 =?utf-8?B?S3JIRUhpOTNLYUdQZ1BaaTdFN2hRdWFLd2ptVThSdTJKNStwSVJpU1NxeVRI?=
 =?utf-8?B?NGNUYXFmMzlLclo0SFFmYVJ0cVhPVDRiT2JYcGFqV0Y0OHh1NmM1U29YZGNZ?=
 =?utf-8?Q?gvyRme6j/WPPwTTyYvYHcTu6MQbnfBfF?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 08:34:57.9629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d33322-d8aa-4e2b-fc5d-08dca0bb2ea4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

On Tue, 09 Jul 2024 13:09:23 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.98-rc1-gb10d15fc3848
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
