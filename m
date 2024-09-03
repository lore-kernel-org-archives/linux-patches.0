Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C2B1C987D
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353081; cv=fail; b=ey8+0iEA/rOg5q/Gj904JoyHa3F5BX+nGaB4Dt3ErNNG1h3Ga3fMIPcQOHrpKwgbxln9wyThUB+b6utg3gGSm9TNNdqH/mmhXJ10GH0hSgYOMqjapaX97mSiB3ihqx+A3Ez2XqLefZXvgPfhfHea4aQBQMFSs+uUQPvBbZ75QMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353081; c=relaxed/simple;
	bh=HSdnnqnn4TItdt/py2SyjzAuCaF0a0hiT/xliF402PI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=S7dV1NxwLzgq/IMQ4brdIvHWpCx3eXqlb5yJLw1EBnhctfJu84QHOI5KuOI3zFV/Ugw9IXhJ5Mck8oDN7NyexPOCIj6cMFoyyRh0n2XkglkIIFN+wb8zsKJHE6e1KJ2F5ERq5QBkp64Q/f1jM/Sq/KLgx1MMQQVUQPWUTEmT4Tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uJNWO86p; arc=fail smtp.client-ip=40.107.96.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uJNWO86p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1m3+M5HZYVEpdaAQ7ViaRsGIocen1Cwosu+YQHuxwz5N1hx08bt7GF/vg3RbAbCw6CoNfXodwYUA7jCYINvVa1lyGi4SX7dV2ggAtE6282l8vI9+jWTiXmMantxHPZZtxPy2yKtclkyva7/l4K23IwRgi7omrFgLyBiv/dN9bgLMRr6X6nBKLnoB17LieZ0sJZ+ujvgW/OIELcgJlzh77pebt1qF+el0IwKn6D5SAbE7uMYZ1ROarH6djEDRpEZLmWLC8VvE4dt4VFqOLmXVdvYb94jHZMR0mTqx8ukXteQpzCjzg09TATraslQxTgpqN/5Bu1Tcof/zfbyCrYhsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycNIu9tWcf9ghOBBGKCLo3PqV4kbyz+aSI4L/xxmkrA=;
 b=C9Zi3tyy/lAZmwfUsD4zJBYAn8Ns9+j7qY4aw77Yay+gUa/3XmKjhs6EcKef/NwYgGiTXQUrDef/5qs+CtTbrOwCrXvyiL20446akK7halChrhK17syo01G4nonIy7KVktQU4+287gT9TYCvj5b4fJ+E5JgmVnFjzCHLh6xiMqp6G/SiGFhvdJTvAmWYy2V/iJ5oq9gAzNzzff99LyueFqkmcd7gnBNYaP2I+17r4owhpEcckD6ao8cqmiumIvCqrwWJNAEAxQSF3cBnrRqn4bpoPu8h+ChSFutoJEeLqzrp6476Bk3WAF0Bh134sieKIHV5iLtFbjPZVpp2+vUOVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycNIu9tWcf9ghOBBGKCLo3PqV4kbyz+aSI4L/xxmkrA=;
 b=uJNWO86pQG8bOOIYWoTNKy7Arqe8vqt+CUV8jSaphJGrBusAxXl5U9kPPQTxsPflt1MmfB2le/B7EMM6/0zzCngRXvYEi0MAsqhYZtwrSzgBSoLbd/XISwH2+oHr1fA5qSZCpuDFTzDdb9DTdiMzkjaqqHTAwlzICCnVT17aDww/PGEIMcOGoJ/k0KZZUXI1Gt8mP78Qhdkf4MVR0IF3qTEX+Vr681OWm2cJiLZCFOXemFgUe51H4xva2Ex9+IJFmjBUU5KSW9TvAas9Nss3JWXDzN9aiewpKHzOq7G5zuxrlD82DgbWdqyZSnus0PN+73idXF7r4/c7UpZ4sRZZFA==
Received: from DS7PR03CA0245.namprd03.prod.outlook.com (2603:10b6:5:3b3::10)
 by IA1PR12MB8465.namprd12.prod.outlook.com (2603:10b6:208:457::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 08:44:35 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::84) by DS7PR03CA0245.outlook.office365.com
 (2603:10b6:5:3b3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24 via Frontend
 Transport; Tue, 3 Sep 2024 08:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:44:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:16 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:44:16 -0700
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
Subject: Re: [PATCH 5.10 000/151] 5.10.225-rc1 review
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bb8368ff-b611-4967-843d-8959af281b8c@rnnvmail203.nvidia.com>
Date: Tue, 3 Sep 2024 01:44:16 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|IA1PR12MB8465:EE_
X-MS-Office365-Filtering-Correlation-Id: e67349cf-e18c-4d73-d6e1-08dccbf4a379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVdZODNRSk5wbys3bk9BWjBaazgxSExaSVY5N2c4OUxwQy9ibHlQd0E4dzUw?=
 =?utf-8?B?TjArbk9nMmtOQUU1cHRManhUeWc0STI1N2RraTk4ZVhqdVZNZTkxMGpkMmRi?=
 =?utf-8?B?U0wvbzVYZHlqS0krMXdHN0szSE5acXJvc29FOTQwSmtXbk85cVA3Zmk5d2RO?=
 =?utf-8?B?NTJVd1Q2bXNjZ1dMY2lZS0FhK2I4UGFDRGdYbXRvWjBsZ1hvaHJ5anRhaW9H?=
 =?utf-8?B?L3B6bFZkN2d0LzM3SVVIbjFQQnptQWNoR1BIcnRsY05IaHpUNzZRQm5zMXF0?=
 =?utf-8?B?Yk5rVGNid3dmWDl6MkNGUE1sL0NQTUYrdVNPNGgyTXNBVzFnZ1Z6WTRMYUhD?=
 =?utf-8?B?R043dS9UcjZNRm5BSDNidHgrNlZtY0xycXAxNDM2TXI2OHhpVm5BU0FReDd0?=
 =?utf-8?B?WVhzNzk3eU83SnFObzA1UFQ4bEIzSW00V29EbU0xNWhGTWRqOHgrVS81Y3o1?=
 =?utf-8?B?c2ZkbjNtTG9wcnBaZDJDeU5xdmFJWS9xRmRjSWt0anl2SWhPZW16NEt2ditC?=
 =?utf-8?B?NmtPN3ZGaW05TFV2VTNyVDRkd09RenVsay9XRCtCVDRBa3pNVm5sT2VoTDRu?=
 =?utf-8?B?U0NqcXZHdjVBTnZvb0RzMHFKT1FLOW9HNHJmOTJkcm1CeHRnV2JWelMvRWZ2?=
 =?utf-8?B?MEFRZU01RU56Z2ltRmRWSzE0OG51bEVEblh5dFI0MnJtSzJLRE53K0FKbUNz?=
 =?utf-8?B?OUNqSDA1YzVPc09Ib2hUZWtKaDFMMml4T3o4S0Q5ZFBGRUsrd3Qwc1UrSExp?=
 =?utf-8?B?d2dHU2tCUU90U3dWUXUxNXBycTY4enVLUDJQQ1RIZGFsamptWHR4TWk1dWpa?=
 =?utf-8?B?S2x2MGFFK1N4eU8rVGwwcjZRWnhxYVB5bVdqR0lVYzJCcCs4RHNOb0l0YkNO?=
 =?utf-8?B?UW0xRy92eXc5eVljazZ4YnV5VC92TGVsQlpnMUN3OW1MWWcyNFM5dFpvSEJX?=
 =?utf-8?B?OEs2RGhiNjZ6azVldFFtMmVKVzNzSGJGbUY5VGF2ZFVyVVpJd0NUV0MxZGJi?=
 =?utf-8?B?Qk1tWGcyUXkxeVR2YWlEUHltdDQrQ2s5TkY0MGo4ajk3ZFJvYktCZG9PYmE4?=
 =?utf-8?B?a2xFelpqNGM0SkdnRG9OODFkb0prZThyRXdaWGFBVnM5K0w5WTF6WTJSeGNQ?=
 =?utf-8?B?TzhiRVlLR1A5UnB5MXRZTWZzM2l4T0x3ZU5MUWN2QzNDMVV0ZWU4ZVZkUlBM?=
 =?utf-8?B?U1ROSTlRSjJyQ2xnNnlNQlRnQVBrbjgrTElnaWJzZm9IR0oxU2dQN1kzT2ZK?=
 =?utf-8?B?OWhBSFFrc09BeUdQYkZDWWFjeHEyRHhxSmxxMXJsTGRSa3pubUZzZjBkOVlK?=
 =?utf-8?B?Q2Qxd1ovRmxydWpEOGFjb1NKQWhKSUlSWDNGSzVCUHd0RzJTSzlqMkl6QVlK?=
 =?utf-8?B?Wlc2YklkK2NKWXVob2tFVFJiZU1USXh0eHBEbGlLL1lEM3pjZC9Cak50MGdC?=
 =?utf-8?B?dTBVME53YmNJVEs3ZTdIckZKY0dNbURaWXBrUmxkUHlCbHRpb1lXWjJydEhn?=
 =?utf-8?B?VlBQN29hejhRZTM1SlhqUi9PS0pwZCtZVjZLS0E3RkpwbnF0dkFJQmQxa2Zs?=
 =?utf-8?B?bFZYaFhJditROWdtVTlVNFhhbjY3S2VZTC9jeGV1SjFuSTJRa2pQOU5URUF2?=
 =?utf-8?B?MTAzV0lpd3RaeGJVRGszUXdZY2c3WHhkUHh4aDdMNXhwUXdVaGFmZHRmZ1RM?=
 =?utf-8?B?bWorZkhDdDU0SGhMVVV6N2Y4MlAzRmVjY3FUdDZsc3RRWFV3WElmMW1VMTJ6?=
 =?utf-8?B?SzZaUHJUZElweXo5UmNXZCtvOGg2alhMb3AwcUxuNHVHdzJublNEOHZTNFIr?=
 =?utf-8?B?QmJia1VEWHF6OTRHSmZnc1l1ZzZ2RWJYWFhIYjVtejcxSVBJR0sxVTd5QklG?=
 =?utf-8?B?RFNCZVFlZloyc0U5OXM0dnp4MUg1Y3p5V0ZVQWlGcjcyTC84OXNoczZqQ1Bq?=
 =?utf-8?Q?0A8YQ5XKZNbyCYrlA31rVFJEhEhFnZ0m?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:44:35.3491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e67349cf-e18c-4d73-d6e1-08dccbf4a379
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8465

On Sun, 01 Sep 2024 18:16:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.225 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.225-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.225-rc1-gee485d4aa099
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
