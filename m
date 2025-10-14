Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011024.outbound.protection.outlook.com [40.93.194.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1801C314D26
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447393; cv=fail; b=rTtCnk4nO3cVx3JR2n2/rpPCwjU3TC8WcZ0oSVXgqRPwJ7CFW4cprpizkVI1igmCBgAMquED8Ewo30D9kkaGZc9IlFWS8+DW+egVje9YntC+DCZZ0wAnYdA7A3TZV9/phFOiJkpHkeXSsJshSzUtYIByl/1v3cHyMVXSZqlDWfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447393; c=relaxed/simple;
	bh=hHTY3lagEKGpADDJMZeElgni3uoNswthC5ZuI963uOE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=FbrHb1xZNGIcOS7u8F5DHwfwrnkunetqTN85Qthi3b/3ffhLu07Nn8nrbQ+UPnqkaWWlLMvG2g5BXbX1pFZAM/6FZwZCCRWwyBzJrXEJs7f9dzmgTALl40P2z8VUL8hV4yaxQnYpsym2tvp/Ef25j32AJsJzmraIspeZMcw/QwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=km06Z69O; arc=fail smtp.client-ip=40.93.194.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="km06Z69O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNS+AMjj8+jMSN5j8tj/bGmZzUlQ++Dx6dUvCvhH2LaB25UP3JumORcR8FHuTqI0xLTwTTtaOP/E2El7pg45Pgu+49pJ4dcOSxFCzUwgODDEDdzv2Wtu55u4Ykz8XJy1QIMTSWZubhyQSngKY9VGpCWXUG7DXHL/J3NAIPpuYUr+ndGR8SJsq+RF4rZJB7276RURKHKw3bjINNjMiA+h9Lr1LTq9+C2P31bbmkJO42JBe6LuYlfHp9EZh1m7Vxm2upna6zWxQs90xjeaFuLTrT3lZ1kzfSR1KkpoPyePT4rg70Mal4oAhTMvqO8Dlw/19wX8gYPp/CIsW7qqqDVp7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GhgYqLZJASRQCqHkeqrgMNv2oAfh0OvOgr3ikasAQCg=;
 b=rCA8wY8G+OFasv1nV770AjYbNef/EpeFOG5WUTG/6Qz/N3enRORW/KHJo7YNHjCJ53ouHEvbi4pA+cJ0Q9+D7lrqHhKF+1usE4f9TYqlb2XiCwU62lSCzM3YOWnhXNgnVD00Rv0TUk/CP2fNUixuuQxMdgXSJseYwttzlxYt6GFNcWF7C9wE+NEpKJcrxlyTMtNobODB8O3HT06S+++8Q/MXfk/3AvIXvyoyaEYTWAJ5PBtByejCvsJCleteOfeDW28ijMOl2DTeMvZrxIWCsYDR7QirMuTC7zkcnQNHi9pPckeGFiT5wtPvojC8LHZeh35QoomTWdXv+Df3M4ropQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhgYqLZJASRQCqHkeqrgMNv2oAfh0OvOgr3ikasAQCg=;
 b=km06Z69OQz3QvB4PZb7PkNVKfnFKEuM85RsQr5p/8cWtRvl8QpVDxXXcjG6ovkJkrwrZ34FS8WgrUgCslBiOEao0+IKiTHi2pV2LUzjEhoaivVa1KIQfm0KYbnHKzg3l11aWA/nDVMs8N9plF26H47VezE74h3pUa3qumNGmuRj2OXuSRRKwQjCFwNjZUupLwps6pAJzGdVe8sBLBBS7fYft1PAEyB8RkgCaQUIH2jvfJRkWwns5jtTcD3efIlBNNlq7nLTDbtjnimx85puXDELNNA2LcmRHHfsdzjbZd+mHIdGPX3e5vfRZzDU97gYvlVyEDD+OoUGBiDWiqWHhqA==
Received: from MN2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:208:236::35)
 by MW3PR12MB4457.namprd12.prod.outlook.com (2603:10b6:303:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 13:09:46 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:208:236:cafe::ef) by MN2PR05CA0066.outlook.office365.com
 (2603:10b6:208:236::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.9 via Frontend Transport; Tue,
 14 Oct 2025 13:09:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 14 Oct 2025 13:09:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 14 Oct
 2025 06:09:29 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Oct
 2025 06:09:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Oct 2025 06:09:28 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/196] 6.6.112-rc1 review
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <610c90e2-75d2-41a3-942c-9adfd07cb00b@rnnvmail205.nvidia.com>
Date: Tue, 14 Oct 2025 06:09:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|MW3PR12MB4457:EE_
X-MS-Office365-Filtering-Correlation-Id: 22648bdc-d485-4207-239c-08de0b22f283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDM1WklGNEpNeHJsUUEydklaNnFHeEtWaE15UWZGTkRKZnhwMW5LZS9LUE9W?=
 =?utf-8?B?NlVrMVYwZFlMU245dERaa0xpUFFFVElKMW1iVWJITlZwbC8wWGpsV0hkYkRw?=
 =?utf-8?B?Z05neXJPZW5tdHFicE50VGF0bXF4QXJlVDZaS0R0dy9aL1lxWEJ1QWtQLy9h?=
 =?utf-8?B?SVFSWk42bUF1NVIyKzFLWk5rV052Y3NNbE1ITTA0UDlLVmFzQjM3MmNxajl6?=
 =?utf-8?B?MjJzMEpoWjhrWU1CN3ZtSEtMaVU5L2FTcTRMMVM0ZzdFT09tQmJFTHZKWkE5?=
 =?utf-8?B?QnZFL21TbEJnRW9BVW9JamlKYUN3cG96ZmNoZ1Q5cEJldy9qVDNJdkpGTlhp?=
 =?utf-8?B?bWMwTEhxcGRVM0FpK3JWWFRSVXpCMHUwNmt2WEMvL3M3OHNqUnYyTFZxbm1U?=
 =?utf-8?B?cnJLbytoYzR0OEVyNVdMcThQTlIxZzM0TWVJUmlvMTh6N0Y5M0hzays5dnA1?=
 =?utf-8?B?R1IvcTZZbU5aakZQYll1eW1SL25kRXhiOFRyKzk4NDhUY2NuSUEwWTVIMG94?=
 =?utf-8?B?cmpyVEg5ZlFMQjFZTktiV1Qyd2ZRVk1IS3JDc1g2N3Bpd29paXRObTBSZTZ2?=
 =?utf-8?B?Mm0xSVkrek1NeDJvL2xwWGpsNUVqa2N3L0V3bGtoZTFPYXBwSTNBL1dpd3Jr?=
 =?utf-8?B?RDYwejl4R3JMbVBCbFVLdE4vcm1ZVVh2YlZwaUROTklUNmRpSlJkT2RqTzFq?=
 =?utf-8?B?YXJhdkNPVEpFc3Q2Y2N4d1ljMlgrLzd0bW1vVDNBL3FOL2hEVVhJMHc0KzJM?=
 =?utf-8?B?cy9Iem5tdzlKOTA5NWNCSTdNWGkzQ2FEMXUwQTdyNnJUV0R1QjJwN2VLL1dm?=
 =?utf-8?B?SE9sQmJkQUpGK1FBdTh1enF6cllDWVFKY3I5dzRCYlN2bGlmSVY3VG83S3Iz?=
 =?utf-8?B?RytnL0ZPUGtvUW4zckpJWVdIT2FOSlVRL1YrQVI1dWl1VG0xVlRpQUlvOGM0?=
 =?utf-8?B?UEI0WkJUN0E1WHdocjlONFNySDQrdVdmYXo5cllwQkEySWl0eUluUEhBb0VR?=
 =?utf-8?B?Yk0xOHZrNzVyZzJQUW1pNEdXVzFBQVNNbWQ3SlVhc01xTEFMZ1hqeEVUbWUv?=
 =?utf-8?B?djhKZ01WZkZ4MGRCdUIzNHdnUEZUMm1vcHFqOXFiL3Q5Y2VRMytJRTFLOTFV?=
 =?utf-8?B?T3hVNS9GWkhxbTNvaXQwVHJ3YlM3SFJrQVY1ZThUTVE0V2k0dm9ObEFBbkpU?=
 =?utf-8?B?clltMGozRk1vbmNzVlR6WFZUOFZyYWtLZDdWWVl4bC9PalM5NHp3UUtib0ZE?=
 =?utf-8?B?OXBHQkppOHlvWTJDZVd4YkRwTmpYL3AvTHlxbjdGWnZYbWMwMGU3aWt4eW9r?=
 =?utf-8?B?V2N1ak5YdkFVOHpDN29vL0hxUjNKNllHdDdFQSs5WUpwSVdLVHBpU3IyZWpu?=
 =?utf-8?B?dUN0Ykc4OWR4Sk9TeEw4aXVUVHRpeU9wUnpYQUo4d25maGY1RUczV1c5M2Rr?=
 =?utf-8?B?QklGU2RMcTQ3WnhaeVp1TjlzUHA3OTg0akdYaERzQ2duQlhIaC9GTnl5dlcr?=
 =?utf-8?B?YmVUWFlOU2V1QlZuY3pCWGMzdlpLeHI3SnBSdStCVi9EREdEVW1TbkU3THpB?=
 =?utf-8?B?NGhrZFpsSFhsa3NRelUzbHRFR1NmSUExNk9UMFNERSt6bTl3em93V1VoNi8w?=
 =?utf-8?B?eE1nNXpQT0R2Y09RSnhieHRTclM2dmtsTWZjYlN1bWRwZTlEazgvaTBLWDh4?=
 =?utf-8?B?YTFOUnU1cmFDTUtpY1hSMU0zNnVoLzYyWi9VOU1pTkJMa2JPLzNUZEFYZjFT?=
 =?utf-8?B?QmZvUlZlSmtzQ20rUEc0V0RFb1VGTitGWlNkQmhPeHF0N2JNZEpNcXprWEU5?=
 =?utf-8?B?U0dOWUdoNGZLcnoyaHd1d1c4Y1Z1ZHBJbU9EeGJac05pcWRkbU1UM2pYOTlQ?=
 =?utf-8?B?UkNKSGpTRUNLOXJFSGpaZWhTUk5pb1BCZXJ1VmFzYzgyT3cyMzlqaVAvNTVo?=
 =?utf-8?B?ZzQxRnRyd1VmNUpVRjZOTWxIMTFYWTJVZ0JnOUM4M0NTczhrU1AyWkRldkE5?=
 =?utf-8?B?Vk9wN3BRdFM2Z0t4QTgyRTJkekxEbHJVYzNsRm9Jb09WcTl1MFJuSzFFVC9X?=
 =?utf-8?B?RjVLSWJZNklYOENkOWxqdk9MOTQ2eUMrdUNuY1ZQNnlscXZaaUVjaVd3VHVs?=
 =?utf-8?Q?Qwtc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:09:45.6722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22648bdc-d485-4207-239c-08de0b22f283
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4457

On Mon, 13 Oct 2025 16:43:11 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.112 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.112-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.6.112-rc1-g07c1c4215e92
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
