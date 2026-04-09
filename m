Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BBB3AC0CE
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 09:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725492; cv=fail; b=lyAWs03Gi6xm5r+1k/v/4UBVKuIf/oPpF2XLpnyYKDLcquhO2haOdezgjNo1VU8JfuIARRwgFxRjcfxynyMyUiW3vU/jAIblf12riDIkP9G/2E6VoqRFARQL4i2SsTT22IyEQHEmvPrnNwGUR3gZPX2Fczn4EIIJ3qNmkxJnb0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725492; c=relaxed/simple;
	bh=vJf20nNl3uUkcf1dod5aeIJRPoMo9iCkfuqi0KwuAz4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=WC0yf5pex8T2gam5ZMM/peEcexoYHZfaYh0Hh7UShv08N4tuaO9W55N0aLVxSsrPntXa3/xzYwPaIECND/a8tfjpHpTSNqS/TMjoU9uUYUs5oIz6d13n7Afkitgwh3ptQxR8MqMfcUEG/5qqVciWcdE+6hjBMVFnnAybo8fx784=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OQpmVXXn; arc=fail smtp.client-ip=52.101.61.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OQpmVXXn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHeQ7xuO+EJlT5n3NBjx9M5VG3GrRSHqQfcn6p+S7yk4N/9qDplESEb/3iPT8Cg30ajVZCKGIkGaqzqYzOSFjf+6Sk0DdB8MmNm/fWKRJeY9cUR8OdvJXqjmTK2+gjmJDGZHMAJkucuobCTPerdupvdYA3+Q3PbPYoMykrZLLH4F/6JA7X3e5FO8w+6PBFLWk+k73zlmgrEOdjN8k2DGjhuajF4La0RSZDhfI5L70c/Il1IbjWdsTuAjOCOgNsqd5al9JK/vV8yhHZkiHfxELzRUe9wfpi3uMI1uEydGiUAgHwPz5ARWs9sWfjZCURnEELMreOVcjoGv8c/PYRbmNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2AE9NMIfXel9Bq4OBFLTskd3JVvW/5NmPhXCE79dI0=;
 b=hKWxB8IH1Ik29Zx1KMpyCpFtuuUgK4l2cSZxXjup85jYmeWi2hm9nFDdaeDf48AIlo0xO2AYG9tjeGWOLOJ9Zxl9U5qOGz1iACUxDHbJ4OiMoG7H6IhFTN8nsF0X9DaqBpUdSCMxP6NMrJ15Mw/LpgZCyytV4gsBc1B7EZKenEX7X+SAA9oJEs6ja2ESijAftkwFEJxrdlSCjcCkqiq82mikDjkEs+rIIq504AMsQN5z9BzgzPMqn/pjYBUO9txvTjK1XUgzRxQn2TiscXp/izZIbYhIKQhBGbstjPfelFIL/3DMahvB+7A8FUlJ1FUXmD+Mlj93DQJolHBeNDAKGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2AE9NMIfXel9Bq4OBFLTskd3JVvW/5NmPhXCE79dI0=;
 b=OQpmVXXn2Q4Zwkxjp1SOjRbJ1k9ZZBi+lpSc+0zxpzlFG8J2mCuw+N6+y8txLDM1qQeZDja7k9W3Flm2kHOLMoyqpsabOnUQ6sVcjBxQ8yoS6ROoqa3b4VKwUl/YLl9ke97w0D1Ps7vvICM8BSfqc2s2oUNFpy1oZWOIqH8P+qhEYk9pQTD7Rx0lPsGqbu3a85PJ3E+IoSr4gDT+Aixi2m6IUNphxeR9WWrA0P7DMGWuqaSDSYiv/xPk0odXY4lBEGvS0NpoCQdm9wycdCNz0fO8jkLLGmYLv/4MNOkHEX5A3d5gTRhVx/4/SxgM2xBjvzhJGxyMNysvbNAjhjugTQ==
Received: from BL1PR13CA0326.namprd13.prod.outlook.com (2603:10b6:208:2c1::31)
 by DM4PR12MB6638.namprd12.prod.outlook.com (2603:10b6:8:b5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Thu, 9 Apr 2026 09:04:42 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:2c1:cafe::69) by BL1PR13CA0326.outlook.office365.com
 (2603:10b6:208:2c1::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.41 via Frontend Transport; Thu,
 9 Apr 2026 09:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 09:04:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 9 Apr
 2026 02:04:29 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 9 Apr 2026 02:04:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Apr 2026 02:04:28 -0700
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
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8a6c3a22-4eca-4310-bdc7-7ae65b78f72e@drhqmail202.nvidia.com>
Date: Thu, 9 Apr 2026 02:04:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM4PR12MB6638:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e89097-e92c-4cab-b0e6-08de96170968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|36860700016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RLHTFr/KZ6IT9ErBVZU9ugMZo/c6V5hNagVNlL9NkSAvq3Ev2/ZkYI5Q8dBxgqQtbb/FCxXZ0cRHwCblET1BgJTZIDzmxWLHrrhHBK/9YbryCpfypOl9H855lyqIin1MK2ZvahGlDdfxA22Bwkm6mNWL/+TM7qArK5ekVIORNtoDLDTRQqrAr3+L2NU/H2WlVAk0agvD+7/5S9wbvBAV3dOIRhESOFp/cNDdRXOCiN0VNbgjWE5R6OM4jktjsOycH4GkMF3gUly+7fFMiB28dkh66Ztqw5hA89m5my/xodJYknZSSus4tXt7jXv0nn+60c+Yi9m2N+P7Z7FUR8Ao7Wki5n4X6sJ8VemX2bSeNoATtz2XmW028sr9sTYoK0OlzhFtB83IjHfajcISlsUTUeTP4nZZFrW2BYXWhAuKQvdcRlYJqBk2WCjBG3ysY/rZ04kHr74P0YRd/iKcmyuOSCIWTJdQJ6H+XzB2ZDu05NlIMPt4PIOoO1d7aaLtCaf6+mYQlBbt4FAp/LfvUPTeHmhXUyhRhBivfduA/dLYxiVZxbgUs63P1uTBpL7yOZMDdNW6qOK/+4Q/Vzlwe0OmFlXvFW6UbluTYubbn16p5uzjMErJqzSuyGcza44kEPx+E369vWoGiuHBpmADX54oXwdU0l04N6c7uhJ3ZRPnZBBnVhGEbS749ivSKa0ehUs0tRimTCkJBAwYXFfD4KE6zLqpHVTlrTgDlQsnhgEMSm9RuUVGud0CA7M02F/SIeGH9ZhswtBEEUj2NK6dEEj+ng==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(36860700016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X6KVU/UviovwRNNQg/J48uhjuOuF7DwwMSSQTjEmWwy0AA0w76fG6krxkH+g1TMtXZ9V47hJ6Earx4l0d8LiLI316j531DVPk4RkGc2xjePVZQxALMbeND34V6op9E0xhOSODglYmq3rqUFtniyTgLGE1JeITobBAsWPaGBk1NPKLzPYVWXjOj33AvcJ/YgczAXi1V8fnPX6wFWXgsTXILNr+qdBW1SNR0aHIBRy++qDflRELz7N53oPdBQJFrHcVtNTHc58MlLKwbPlZwxlqsKtcH/F5gzO8FXbdkPSgJ4+bO3KMIMG372N1GZJuU9aHz8vu1dnf/yz85QPisfqeIAz/WRTNDVYIoO/o7pv+7cTOIdngl4VJQX9sbMyge0ZawFfaJt6bxK+GlgmZQGNQhWJ3uwv+Esnhpnqn03oORtGE9jPOJCsiOEOAbNn+UX8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 09:04:41.7720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e89097-e92c-4cab-b0e6-08de96170968
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6638

On Wed, 08 Apr 2026 20:01:27 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.134-rc1-g69a5401c4693
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
