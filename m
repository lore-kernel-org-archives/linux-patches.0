Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD74262D2C
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716679; cv=fail; b=tDxmo3YLwyZGTGHlLFCc4wVHHSvIxu79/E7kiiT3t+9sGqDptLIPaMzCFkB1akoQCQwQnU+TrQt1NZl9YyxAuizCX5dJ6lcJN7rnZgCAEMjTng3Zdxh7ZCqw2CPSCamDoaUghDTkYs8ApWv79PCN1wI5X2pF95r078ZY/ckqO/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716679; c=relaxed/simple;
	bh=CxZ0rrt3ssqf/6N+/s4R3V9DqKF9tsA3/EVCJLtyR8M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=OIrw1vsHIIRnEZYz0Wc+jfyL+EPVjd5d20a453EhpMN+1mVJdC7oIR/zb+JvlyG25v7Bv54BIYmF3aZo4aKcPkdKZ4S6Kx6EaAj11seZDuXOqDrTQLOx9M1+kk9LTK5QrNt5A96vkTSEnKVjQ/NmyWdQuDKoTv0Zw+xoo4S+0Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fhfFiUtr; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fhfFiUtr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMs/EsE7zpWHrrmnaB10clN/j3n32JT9X0UiivAAhwAaXmoYiTtg60MqALhZsmXvQgNrYx+khxiUxUWEyhuGi3sbr/HhIIl5tM1qCKSpaQ9tX3Fq2o3jdILRtFPqq8CtX0H8kTRqo2ygMTnG5uRFo6uPYaRThGYc8WfVIHBu0/3qjbjvQ6UBb/cCncnEF0jMJ8nbJSiWcTB0DnjRwHH9pNQdhyd1Nslj9raEV1vgIoOMfePojBe2NTDk21xetTE8eZiu/xfNe+SeMsDHW9/0MnFlC4hmgl/eZI1f5tiZIA1laqHzE+DY5Q5elTKGySS1ObtKdiHq+ypnYYzwWuw+BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OY3s0YiUnuVg9kWZZ5w4ixXkyzwLrMHWQIJ6RccC9cY=;
 b=wZkq12Pnp/Btk7+UIg5tOVdjTN0jpgQIp+2wtAhXpxw/q8aQHdxawkTptgXP8LdcYnCiEL2Q5xYnl5sGGsxFmozQ7xmoARi8uJ7w+pkDu2Vcnc5+Tbau6pyBjEQyUxBfzSViOfTuJofqPAqkNT2oD4AQP2Wpi/1+71Bo0EfLjnvFize34fvt34BqGO0oRxjsqvVQHRnZsD2X8tctcIWOUzNQ/8GEAvdDzzs4OsR9lNl/0nU2z/uTt2lWuHuEe++eXmdDKJAgnsjUM8C3i0dsrY0SmAcurzisMV+UslTmWfKkXpNwCNATlL2P8GKX6RyPuZSu4YMB40hM8KEDTH3Slw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OY3s0YiUnuVg9kWZZ5w4ixXkyzwLrMHWQIJ6RccC9cY=;
 b=fhfFiUtrlXZWSbTvGCLsH0d83j2FIMCm97Cd7Mz/x1/O30vVwtpTQ/bAxLqmdIESpIAG50+Ms2zvX87ETDBruBpFAmqRRb3TFxI+5gjFYhHsgfSTUzw/LFE19qhz7DdPCr0wZJZA9km+inu+rxcqF9XgN6WSDEjyej+42329p6zfW7o+rWjWGqT0TveKf9OMHuVDNaa8Lb2/BXzH4CXeufFISSNJPYqe8HvHYTAtkXfTe1mowlwRStKSzIJek8LzDQVdRoOKD0OVFoy0Koq6WEAowBhT7yURV61RhfPGJYY59nZRwoKRgpLlF7JYNqe8cJtR7dqtRsyxrrUn/XXwNA==
Received: from BN9PR03CA0873.namprd03.prod.outlook.com (2603:10b6:408:13c::8)
 by CYXPR12MB9337.namprd12.prod.outlook.com (2603:10b6:930:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 18:11:11 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:408:13c:cafe::a) by BN9PR03CA0873.outlook.office365.com
 (2603:10b6:408:13c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.27 via Frontend Transport; Tue,
 11 Mar 2025 18:11:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Tue, 11 Mar 2025 18:11:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Mar
 2025 11:10:54 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Mar
 2025 11:10:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Mar 2025 11:10:53 -0700
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
Subject: Re: [PATCH 5.15 000/616] 5.15.179-rc2 review
In-Reply-To: <20250311135758.248271750@linuxfoundation.org>
References: <20250311135758.248271750@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f09f7a96-9d81-4fc3-8978-2b133224fa05@rnnvmail204.nvidia.com>
Date: Tue, 11 Mar 2025 11:10:53 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|CYXPR12MB9337:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c461ed-68e2-4c7a-f01b-08dd60c81a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TXNXNGxlQVFva05YYW5vT0VTbWJiU2ZpcGw1eFpsb3lhQm04UGZuU2dINzMw?=
 =?utf-8?B?VlQvdDE0UWUxN0FxRHhSdytkTHdTbjNvMU5lS0hQVnVxZXZxYlkrcHJhSmI3?=
 =?utf-8?B?YndUNXVNSk9rREh2MngySGswYkFkQmxNWkdpNnhrTkdORTVkb1h1OVdFUmJF?=
 =?utf-8?B?Yit5dld6OU93VS9icXZWY25XUXhvRlN4bytJRGdta2pwbkNqNmRlZ1gydUxy?=
 =?utf-8?B?bzNYS3BNaVpocS9YOHFRZG1pVXhiRWhRUC9Oc2NUeWZPSm5IUXZ3T3crQmQw?=
 =?utf-8?B?N3orcTlLdUpjenBFVWpCbFJZL1g1cmladGt6MElGSDYvQktlOHMyNVNwcVBh?=
 =?utf-8?B?Uzk2TmhPOG0yOEZkNG1pYWo5RnlpZ1dyMExPYkxleDMyVnRMNE5VUmNNdVhv?=
 =?utf-8?B?NjhXQW1rUDE4MXpxRjlsNmIzY2UyN3lLYzBMa2I4WHhLZlU5ZHQ4cTNGQXk2?=
 =?utf-8?B?L1AzWFk4NmxpRjVORUpJOS9rQ2J3b1NkUmdYQXlhZG1JWTA5YndOZjJNRC91?=
 =?utf-8?B?L2d0Y3d5N0c5NDNsM2pCL1ppR3RQajBTZXBaenVDVGtOM000MGp3VkUrYXRX?=
 =?utf-8?B?TmdLTmhIVlR3TUhlbEVndWRYcFZ5emxtSlVSRUJIRWdEK3grQVh3cUc5alBU?=
 =?utf-8?B?YzMxS1dPdDJ6Y0NyQmlWZFp5NnNYTVc0M3lWR1pXZHREMWdac3d0Qml2ckVi?=
 =?utf-8?B?ZUs2VmNkNnhaeGZ6a1ZNdW1iVFFXRnRQQm8wM1R4Y3FDQlJiTFRYZU9WZFM2?=
 =?utf-8?B?dURiaGk1QXh5T0MxMHQ5alpoR3NlYlFwTkhyV2FYNXBOZkRCWkd2bWprZTlK?=
 =?utf-8?B?Mm5FUTBuR2FWSmZSeWFLcGh3ZEhBbUhiaGJaNzdpdVRRaW9jaEVTbFdVK0Nv?=
 =?utf-8?B?MVArYkFLb2JGcGlxUXQwTVZNdXZnRi8zeHJLYzd6T3hSVnRNeERqaDJaTmJ2?=
 =?utf-8?B?NHNLb0hDNm9DeUNZTW5JbmdNV3BPc1hXSUhXUUUzbmZoSXBwb3ZxZnhjT25r?=
 =?utf-8?B?bSs0eHJYblh2QVJMYTJ1SkhMRFdZR3FsRDhwN3hFRHRpV0FIekFBWnZVaWF3?=
 =?utf-8?B?UnMwOTZZWHVPQnNyeDVHem9XTnhwUjRlNW94Z0VGaTZKN1ZzTTFxM3h3NlVP?=
 =?utf-8?B?Z1FBelQvaWlQTzRSR1Q1RWZvS0w3MVlrdTgrSTFNRDhtMjhvazNkbmhlUWxk?=
 =?utf-8?B?clU3cG9CaEhuQ0FwV2ZWUGowc2w0MXI4U1BBVmxOT0dlUmg1eWVXOVFZMDBl?=
 =?utf-8?B?L2FGa1V2eEtGcTlrSzRMQUFqTjJvMVFvb3BidXNndk1PeDdLMG9VcHFqLzU0?=
 =?utf-8?B?OG9sQ200dm05V2VSNmxoUzJ5akI0dytBWnJXZU9hV1ptaUZvVlNzWXFtZTRy?=
 =?utf-8?B?NnVWYmFzZ0U4SGpiT29kL0V5eXcvMkIyZkZXVnZla1d3M3N0d3FYK1RtWllJ?=
 =?utf-8?B?blV6OHpkd0ErZFJrUEtFb05pNVN4ekFDSTRLTExOcUM2dmdja0g1dG1nV244?=
 =?utf-8?B?alVVV2JCcGZvWDJtRnZJK2gzTjdERm9yVXYvYmdCRWs0VHd3NmU1eW5LUThr?=
 =?utf-8?B?cldDRHRsZjlweXhkYWR6YnhnWURvWkxpNjhDUVlSYk5wcUpFYUdoRVM2Qkt6?=
 =?utf-8?B?RzVNME9kQlQrazMwRnFzM3JJVDhPblJHRmUyZjd6ei9RQmhpOEJIVStodUsz?=
 =?utf-8?B?K0FTZDRnN096Qzhac1MxV2Z2K2QrdGc3MXRHK1JKNFowV0F6cmxGV3FvQmRj?=
 =?utf-8?B?MFZRQWdRZ25rY3VROE5MVzR3ODdVNnB6b29LKy9TV0tjQTlESk5mNzJJdkMy?=
 =?utf-8?B?YkhrdlpMV0FsWkZxSnZmTTBDeFJPRzJRY2czbGJkRzlkMHRsZDlkRTZxSEtL?=
 =?utf-8?B?c1RXYlFqSmc2cUhvbkxvb25FM3ZHcTZxZmZJYnlXZ25ocFl3OFJON2o1ZEdz?=
 =?utf-8?B?T25hRnNUMDJtS1hiZ0FQZnVOcmU1VytJcThGdFNjVFA2UFFJZzVIU2k3QjRo?=
 =?utf-8?Q?22hxy6bceqyalQGcJIcvJ/Z+chmV78=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 18:11:10.7978
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c461ed-68e2-4c7a-f01b-08dd60c81a73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9337

On Tue, 11 Mar 2025 15:02:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 616 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 13:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc2.gz
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

Linux version:	5.15.179-rc2-g4372970bf866
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
