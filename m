Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010010.outbound.protection.outlook.com [52.101.85.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352443EFD0F
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773863379; cv=fail; b=DzvKCMgQUQ/8uL4ke1KGgAF7YMo9qSbMTgLkFkEVfcFQt+VzBdUMg2EGkvPGRgQ4KCoi8rQjKAF0jJXujDczsUfhu7Hud+x+vbstToJmgLw1bMbxK4bwfof1oIHjuH18J8ZbVqg1tPy+OaSh9jgQklp0lc3E26ORs6IfKl8dWZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773863379; c=relaxed/simple;
	bh=/IVFsJFXvMMUXlTudr6GBFMEpcfh/BcdFkStt1qmujI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dNR3D4MBr4n7ggiWyCWtcY5zuViOoYnrND/CH25rdNRD6vTRET9Ujdl2Wl4PnBg3wel/5RQuICV9H91/f3GVI1MUcQ+oXNhtyrdiVgXc5UrVCy8onyk0M3Sk7TmtQcsLupCigU043x5Ydvovk7P+6S05dljcThuGutK+D3ad2Pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nvCmMFEQ; arc=fail smtp.client-ip=52.101.85.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nvCmMFEQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHvSJG3S0JWam2eNbNyUIkWY0ASAXWuJaF+MMg2rc5GhK6eHwwJDLi9ngvyFpNtNc2p36XXUhCrQxWuM9VADps5ooR340AlW0hEuYtVD3Ox7WdBNaWBBHUeqML7FM8Dvj8EUQUWHTfLbemj6Iolm7vHF/MV7BWAH02BdmSnQv8BMjOlxTi9KdAFTz3AJjWs+C1i2WcEScVnKBTBWiAB+K10VPShR45UQ97R77f8dBd1ESSXXUEnxqoO6aZPbLRGpn+rGce368qcnMDEoD3Jv9w665ZZlTbUJeJnXRCZy+YLzA7Pmmvsp43/h1WkT9yFIpZnzhk4VdDAzR3e9GZb4IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7M2Vd0J4yntfVqENXHwL8kb0p6OGp7PXMP4Saj7wN+U=;
 b=C2jRpCMfcElM2uhbhBcsMDNXjdgjzE/Q/47kQuTNRgKJsz5WlAjlgBPMUeQEjUB4dUYoWdbBPsO2SExV28kIwuOUGAWNre3A6X/1rCxD+D9sxS8XTQ2ErX7TtX64djc/PkvR86xF0sJDLoHzsJ0AhY3eQjz24ebCDtubgNNVqOLgFUeM6GDKLIxcIc69BBhxmBvNZQZ5lJep6yhQ9odHYdSJmaLEHSrA+9aVwmFGqYL49G/aI4i/9rTsgk+UG7bYxhr9vDwcXlGB/xlqWdPBImZwbNJ9PFSgWMUdGywCXR/pUA0kKhQS17OS/nFHJmq0IxrV74C/GuqLtc4twPxeCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7M2Vd0J4yntfVqENXHwL8kb0p6OGp7PXMP4Saj7wN+U=;
 b=nvCmMFEQpbmy4OsNQfhFYXrsYVfNr0bBbuUmtf4L1k2Dk2wNirZ3koaTrYhiKCF5TErv0Ot3xqKs0gY4w2iK4al+YvTMve/BTJohy5NyII7JTc3qR/qji2J+L+ZW0Nxoc+P+STa2R+dFGoT/4aNDBhqNct/xS4Kl5KqemDQZONEvOzV4ecdWRlSMr4QINRWhTnsldVAc9ENT9tTso9aYEBVUae0xcSCaCUgF546IE0fmB/WNRdzxwf7OLlStTFepABD7iYmcbn2IafbMOsE2p2heBbCo+X+BwiLPt3xu+bU/uSRb+LwSRWj5foEATCsolAcqpJUDujnVDP3Hyn2jqQ==
Received: from BYAPR05CA0105.namprd05.prod.outlook.com (2603:10b6:a03:e0::46)
 by DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 19:49:29 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:e0:cafe::5c) by BYAPR05CA0105.outlook.office365.com
 (2603:10b6:a03:e0::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Wed,
 18 Mar 2026 19:49:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Wed, 18 Mar 2026 19:49:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 12:49:09 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Mar
 2026 12:49:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Mar 2026 12:49:08 -0700
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
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
References: <20260318122547.233850204@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <878a804f-3f78-4616-964c-d792a982b32a@rnnvmail204.nvidia.com>
Date: Wed, 18 Mar 2026 12:49:08 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: eff6d98b-fc11-4a9b-9a97-08de852777f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|1800799024|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	teFNzBUVTIsf8vxdZErAITykNAVDG60CAEm6Iuy1pctwoHSBdUYN04W1qitgsW4oMEHSCXqKxksSDDjme0j11Uhivj6TlsTk9FVbb+vEwRnRuJwhAPZGCFW7FyCjS+GhoLr8OojWKbcyp7KhMVoC/8MICVcvLbWj4ygos7rBF+XMBfb6eZKg0WTFpJdWFQG67mvaal2zqeqzaoUg1YxnU/uEQn02vbtQ2BdV5NQBr+K4ynE/CmnEIu+l1SeD1PbElJPeCjUHYFxZxZJ5slq7gwrbfz2kBWOWt3H1nW9LNtrvIIqTv9cSZClfc97+hRy/t+IQ7JxsKIxMFLOsMnrqXTD8u4lRVWKjaJ233m5Ayt6GaIA8GqHA5ew4oc1FLMZphuafmdq7jgCcE4xYJa78tVMj0nhtgFF74RbIqprjZ9uRXjtz/c7MwnkoJVDZBGD5djogDPrAYHecpMAiYGDQSyTf5MmfDGmyJdO7VpWkZsUs7djGA0sx+RWoelgw1XOGgWmet5tHq63kiIl1IOiOsiTvjMHEAVbr7sp1eDZvCjt/kmPKUQxvgJ+vbXYp7cKj+PveFL0MOnZVn07j/mZKaNUNniZ2QqyFJDnsNQfRm6Dn7ZdL+ZcebuTOaz48n0sNiQhSjPsvldIV676AhbwYS9ZpJs5LUXLmYjO/9WVPgxwCcaGHiZGTfkI2L/Q79Vlzxogt5ZoPv6dh+qCxY7vG79fS0fo5vGbqCBoEAPJNCaAlJFjlEU+g+LRuUAB80jrlZ4SlLMl+boCq1jR++1egtA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(1800799024)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d438VeEnxowdhAPE8GL0Pz9yyfEPMpKiZo9fvekfYzduLyM4AuOI9hKel9x3PLCSvL4sfEWm2xTfP+ElE0nG48Iy6QjcdJjCCjyPaMkDNcuW9DmFbGS/NoSDEeFI9sKAqTS/BD4G5oFpF3Mw+wzrlOktk9U9CSdyUNZ0/2u9ApCEPHulH9Buwd6Qg+GHiJIp73fBAtb0d9XVSCkSW0OLQOpVvhvbseXoUFKLRfdfBfoh47jyajueC70H3eG2Ed12R6ZH8ncVTHkOyO7AGtYjCUzhctwN2JKy8j1/4y39hUPA/sZcGTi6GvjmTviIuM5Sbm1WlPSgqHntHxa60iCEda3xLqa5+HQDapTrnxTOWETraR0oAY0fB5c41CauOpI5Uh0TyOzb+JqstWhdVOw5RbA3ZBmQtxTwpZ8W0rNAeiQomXYVei/A7Yk4h/evA5Z7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 19:49:29.4722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eff6d98b-fc11-4a9b-9a97-08de852777f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743

On Wed, 18 Mar 2026 13:28:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.9-rc2-g08e4691d3bc0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
