Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD42367DC
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343058; cv=fail; b=UE3DrFvkE/pKby/xkbfCULI/+5bmTFfJTPVFkxH5cbdQOmyV0o3dzhuFiWaaYzI5XYcnxKTBZE0h1toS4R2HFzmTkfS2xROnzCTnDfjZ1sHVS5GQnns7XoQ8uj15SoMingKFO+yQw8GcxkFuxvEZpb4oSVh7QJhTH+osU018804=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343058; c=relaxed/simple;
	bh=ivi7u4biGCTmPF9QvgO0J+RFjVfhkyQKgwSpqMebrd4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kP/4JQX1PU565/2a+iWmfQI0FHhQj+ChXPm3RNyJVdogLgXjH/mq4hThamU/NU70yd+OPR2l0xZ9xAWaSnBrcVqb1edD/lWptfYhJWhxQQm7tvRh6Hr/xl61DL1gnGIZB6CO/7IsODuIbEx79qnr1iLidUh/CKVg56eIKuCBPmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ImhecIa7; arc=fail smtp.client-ip=40.93.198.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ImhecIa7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGIHkrojelgIhBL6fV51ky79xbFYY/FGg4UNIXE0kwWHyaD8/dDsmdYotP3BmyNO2Ai8R/6T+fJWGvvjiUTWKDSWLVP+7TpD3sCDTbluJqRKeApDKQyZ9P/TjglE38cfmfyzgdNkzqDlSxEt5f8ZhxkKft9VKdoQyz+ZQu3Tsk6u0172RMKlyPa2eh5P4rV5YZwKWE3nSZopTTIiKgnP8zFQtSyu5+wq3lPgbU6q1sT8tKYR8IbY6VROQ16RcQ25/0IbA0AHtGCDgZIQ7zgGB+7NOUrgMd2/8DazPep4BA75ECql5UCSLvUWGGrDi199lKCKV0ipg/ed9MQkmE6mvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bO3dnII/BjcuaofPMx+6CU/pF7zg4cyP+Xzyq7K+orE=;
 b=B/pwt3nSCHLXV8jql/HTXgn14kcinWLvx68QsxoeY/oB0zBmmiVoBPlntn8p6wsV7WHJhFTw4t4SQHPkKNy+O/MKrJOSicDIIY8tREVV79H4VvQfQ4dM1g2ggybFHEr9X2oXoKyvgolIxiJJ5pkggDGE3Z8OpQYkEYOupVFI7mgRkOY87mhNaN4tj/a+P+uT050oGSq7stQbiGIJ8LN1rE4dPgK2iXACWTPtTTSWdCZ4Fwb8UfOhs3Ij2DIarPWK5WyBaO3qXUXxK01BZ+lEGMMhwlPpLh3A8mKzG+TNnlXkljMfmq3yRmTCZJxAE9IvtlnSS8SOrbKmKV9pV2Kt4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bO3dnII/BjcuaofPMx+6CU/pF7zg4cyP+Xzyq7K+orE=;
 b=ImhecIa7N7b1vfmV1T/WzWP9pZE4QlJlY2Ctc7jnc5CqIpjGHI7wtypsqGn6Vt5VVyMHwv9ICe9Zuwii9vW61VSjHIxwi7pWSlcWBVyHXkwfbyRqDJSn5lBSubkoyO0aqa6UWKuK06XyqgusR4py9rvp8zeXKFtVPCH3EWws+CznI37ikPkdjubX2pn9Jg4zbaCiEu2XYiqEX+owmBv4+IDyEQI7HoeG8Gn7Eo4/iSVPf9snu9vWxa1cp69g7/f0MnPQgwPhwEo3uxVrA79M7/gVbVvaeiG08uYkvXfJ6NfNek9+1hpBzx4aOYa0fqn0WllaBDFEy3oEA3M2o4o6XQ==
Received: from CH0PR03CA0333.namprd03.prod.outlook.com (2603:10b6:610:11a::7)
 by IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 09:04:11 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::9f) by CH0PR03CA0333.outlook.office365.com
 (2603:10b6:610:11a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Tue,
 24 Mar 2026 09:04:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Tue, 24 Mar 2026 09:04:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Mar
 2026 02:03:59 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 24 Mar 2026 02:03:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 24 Mar 2026 02:03:58 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1956b45f-0e8a-48a1-a753-da653fcb78cf@drhqmail202.nvidia.com>
Date: Tue, 24 Mar 2026 02:03:58 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|IA0PR12MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: db9fa854-f4e5-4f92-e9e9-08de89845088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|1800799024|13003099007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qJ5J7uqDpDDo3fV1Wo2fLYl99ax5HX7OXmNHtA6nALG0vRySgP84YDoKlGEb+vBuo2o/fngrCHPDoLqXbQhyadc0/ORmvAH7j37X9iOJHQUJc8Vu16+enyoj7vlbp5vDsLJ7tciQBli36ByqLrPaiftOyHmNBZCr63vfRBVcY0dlrU3nCCBrosi6yCrY1aFxUFRSIDh+LGaKj8Nw0LWMZBfJyEqgEAwdEOZbIfMe9gyb9un95h6wykFY4Bb8HHlkb1nncViwveWlJMM8fiJ0CNUQ/C6pgI7Ij5/lvWz0gZaDcqi5OSGre0xO9utVBL+6LHnG6zCZXERXLVBoXFSaMyRVqrrHcHVi+UkX+RKo7VcQmNDjb3diLjAiEFD0k4qwhtu62Y8brzOrw/Fp16JMHXx+T0HxmQemcpJqT+pq52wkoNRVPy0bN3o01zC2xiVwyj8tU/bZSPB1dkN+FRfMvtWMvvTOIK3yBAwEu3KbN/El2qL3olCauy1uNT2de1VKO9Edt6M0V6LA9NJPRJ3p1SSDTD63W7eoTx1OM9O4ZFs5MSqPT08ssA7ngwGyH3Ss6holbvlAoTlrk0Du97ecpPVw6XGus0JmafVwumSdwTYFgKK1PHy0xAciUYTcNjbx8QQzlIIxTGeDUicAF2aAPSO6hHz87kQn6haCU3B3rN/tiLTMdKMlYtaVpsH0EBqAaN4HOjJ3kEdNNi+R9mFeukz3oGH15+NmMl6m/M5+Q08+asy38qFjCGr1V7p8++GLEbN/d91VtKyc4sIs1tfyzA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(1800799024)(13003099007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	b/D+t7Hph3GjYQnyT22KMlwjGv91WcL8BaApAFNb4So3bIxY3SAqTtcphlGexLU9lGezJ+Lxdr+AAsVfvFzDmrnf1JxTECcBG0wpt9pxpYub460zffUuF+aPTRRV0JMt6KTBFVO96lYDR3QHPnEDLZB/DkyzrQ341OE+rNt3fJM/a0nZPbLaIO4KO3l5Pw5DNqWnrJwl1DL8JnA7Y0pV/jWqANvlFxLSUdhC7ukwy027WJ3AdNSUYmKc2Hzy+wSm46ebXlLwMgMUp71wcXhx5g76ACApU1iEE8kYPpl6dWgFj6v0NZzqjNho3bBitftVKsOWeOi02yptyaTMFYGUwqo7AAVzVsdw7YjsG57Vv1Olh/MIjesSb6D0n3pesADbdYztSus6QDlnnjwEAL62YP6Jp7Bqankd2NF+aQ7ZudNNm4jw0w/dE+OCVfz1ezFR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 09:04:11.1549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db9fa854-f4e5-4f92-e9e9-08de89845088
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750

On Mon, 23 Mar 2026 14:39:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    132 tests:	132 pass, 0 fail

Linux version:	6.1.167-rc1-g67c872a868ac
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
