Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011053.outbound.protection.outlook.com [40.93.194.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386E914A8E
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 20:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050193; cv=fail; b=EtSPse0iR0/yOlhgHbn37AoPGleRTzk2y1zmEQ1tFLRWR6tmUvzQ2OYjoH3lW6Ym1zhXafrDvHGLRSMaCTSsNfVUIZ2S+KAkDxxmv2H3pCWbO7kQiD43GbkXfH4fbWgSc/EOrmoBxj2HTd/CImh4KxSVTqcuIMFrs6AI8DBLiIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050193; c=relaxed/simple;
	bh=7w3dz1EoFwBeyW8juQswy64jpLhhgLuoCYaeMmaUYr4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=N2cfSyI1uwMN2RV9CrUVSG4Ix+UH/VOUnR4LVscR2Bck7UnCDKk86TEhV8i4RFSUtGHiBm1hBTSQji3woHjahGrETLXXLIO/D8g9j71JZrfRE2QDGZ3UWml+sDnuGGDWRcU2j/0RFS4LLnpvCHqkDorryvI5Zkxs4VOYvKxZ0G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IApf4+4B; arc=fail smtp.client-ip=40.93.194.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IApf4+4B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhuc0KQnVCaUsDQLXri91M2nBLYcfNWJjja11dibgGBKpXMQBbx0y7JLHfHZZi+wsubDRTDz/Q602YxPYoPMPoODPrmQqCSOQK0RpnNAF4IM5qYQxTzyjWxxN3ufymN0I+Udgkff26zyXcz6bFms3JtJtyVBbppcaq30X7Ig2fZBw/NfNvjvTKNn3OaC48ZxsDj8E/+zV0/NtthifAlRWYOAcPk+w/8aq+RrRp5woRTr9zI71ykYjSqrt0M76JKY3oaLBWYgm+jxDUhfOA/AYbZ47SqsL7ntB8xy6IA+d9UmN9m3XIVKId+nxoxlVX6dUpald/vFg4MDkqa0pMkd3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAsZDKcZC/s1xkeHn2bsOVssSJfLqYZQYO/hg1SKVpc=;
 b=xv8vuwT4rr/Q9X4/dsRi0m4D8DjM9qxi2fSX36jc9zrQoqxxgNxuiaWegr7fei6tEyVSAoY3IPMyz+N7Ngi11kiA9RAKPboNRvADS7TMPHMPG4RqKpoeUXQkjrAuPN5D8W3gwawDPAILSeHKKzs9TleuFOyzUgGuKBQVsox1XGqT+jR4BJDtKQSvZC+oTpfOTaAnqjy9c3gEY4Tog8qgfBiGzE89m/6NwL2VpmAL12gvqjvF4nTjti9GCmF061EuGCMevwuCVaWoWP+UZNLVfcI0y+1IWOiR8XMGuvbK0pEyPnd8inPV8uBa6EIm1xbBczRjU4Y38SLIodCY5Yt1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAsZDKcZC/s1xkeHn2bsOVssSJfLqYZQYO/hg1SKVpc=;
 b=IApf4+4BDwIfAVk6/egNZPlntPmXNZKt9dBs3ODhi/F0IK74Zh9bRrTS43B3QzlaOkqXrX2HnbsElTuc97HawncE7/cBJsq5oxnHZiBpjpol3kO7HYXlFzOZ7chCkw/O4BICkj2C6eIsOGESrdbAE7YWE13wAy6W9CHLTGCpZR1r5EkwXuUN/M+743RKNcY3lfTbsFZJkS1hnXf9yCvn7HCr07bWoIrcv0q744PslUecoV8SNZ4mGpn0MKmampB65cMQ1JsWrURxDBMmjHWPX+1edMSTG/nGT4UJ7kasyw8f7xYP7bXW3qHfz27V1UeFXTdJT54v8pAJ1u37hTyQLA==
Received: from PH5P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::14)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 20:09:42 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:34a:cafe::dd) by PH5P220CA0009.outlook.office365.com
 (2603:10b6:510:34a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.25 via Frontend Transport; Wed,
 25 Feb 2026 20:09:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 20:09:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 12:09:20 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 12:09:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 25 Feb 2026 12:09:19 -0800
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
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
References: <20260225155341.094945851@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e7392658-5cd4-4a82-b95b-3983f632c981@rnnvmail201.nvidia.com>
Date: Wed, 25 Feb 2026 12:09:19 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e9cb440-e0a7-4775-7869-08de74a9cfee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	GwkpyRuc/cUmI6Af44Wbbjhv+fZeI2/NM4+7QySidL5UtnzS6JClU5nPuSHAZdnCPhlYE7Q8gwVUZbrv+d/MT0TwipQwSZCBHiTTljKUDYJlLD42E0QN/ILDEF8uZ54kSdiUWiVL3WiEhkwiGNVkJUogYtQo5ln9FH45Zf0vHyTv9y6PkRXUZKVKpx42EQh9tZH0b5M8WDPuNiPKMv2uOLDoveiqGVhbqqsA24raSjbZ6bZ49ZyjqlnOO70+/eAy5jsHm/zDquKZK/Iv4oS1Dso0dEfE/6bqsASCHhNzbTYQ7yhlcsf02LlzZpeivAgbN2WK8d83E/m9Tu7kfygnYWstPF+JOs/G8FinhzIgCtN/cuoTJPgGBwyUK/Ao5HyacUBnCqipDNaOhs/uzt5kyBZZ5dSgToMEhMlnDJASvriZxow7DVRsOTlYrq7FUx3AumnSliWSKQWefaCodq7hxn8Z2gO/cS1Sm9/L/9zzB+RuHTlXTgSX6PePkVC47eTy/incllHo8pg6T3Jq63nz/dX9VwHirpat401aeKDoAHcoxWht2Gsfpm0NiI+hTMiFzfoEKOpqhJ/IGtmTiNenJIurEwvthShfPdZqwi0LcGjE4kK9GaPdyjxp1bSNsgcYly3Qp/nd+2+KDwKkippFD3+f2PtjavcWvIRDwLLAAqJgjQ3CV1zX2WmViEaqExfjOoRfb6/aOZ9zjBGCjRPkfwN4+vGveZWMaqbljhTiOYXCF3iQVo1VHfNmJKMd/d+BREN/83xQDcLztbVuMYdxn7CX6qwWW51Y6cWKw9M8NVhqa9hHDx3uaZFsIvgflKjyYD3G0VzeMe90kG0ToJDp7g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zhzxy4IhxeWgO4/4sqacmi9ubNTC9mlRRXyuk0cRHlm32e9jdHbQmj8u//Q/Uerxl+DIkS4o8yRQQDgrLjqz4JWJzKWWHHf/EoHZcnEi5JGZPbe4C/e9Yy05thVxuPD5xLNQCP1s6toe830DljnlTmDks7Yb47ld5HutZh5fhB8ZxQrfyGdqZXziVSIfT5b5EUR72KVUehsZvoSu46nfpMZzV3BPLoVqCO2t7Jt/t3qs3wnOee/VyU7GRIKBM66g4sfiZjtk0sgHZNXqMLpsoLM3wYmjPGffAr0xdp+4uZfN/Szc411PaJM/KJAfDnal90C4HD+qaMdK8QOzAv0GWR9pSVQpcy33QSnYCDBgBF1Gt8ejqReAefJKlxHdSEKSO2c81n4L6HopFkdEkxnGSB8xGRltDLwp2g9ioLPUBHv01LHG3gWtMlxEtG3ZpaNC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 20:09:41.8864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e9cb440-e0a7-4775-7869-08de74a9cfee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

On Wed, 25 Feb 2026 07:54:11 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.4-rc2-gcb2d80377c4e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
