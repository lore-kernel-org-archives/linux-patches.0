Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF90E660EE
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gBBrlErm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC18kJPpZa3nYLGkgb6B2l/ib56+V7jllRSGD3bxkAaITpWgrtL5fwU7rnIUowCaBpl8RBv1klmLN/YbB+8ZWpVvx3NW/CQwExMxGahaG3UgBYc5u/aw6PHAyAT/ELUlRGgwGTu3rDIXUd1EirCgzNn+jqFSXSfDzsWLHzj2Fe+VgCq/Qqs9Akel5uzKl0cdHfhnLCCw+i9uA91uxYIKHCuXzGS0F9p4k16X9Oyo3xjuvgRtmUKqKkhb72dqYHE+aO+qtiwGfB+FSiUWMprxhMd2FxgrtAoEGpDjL0EsFJINg/zD0eD8X8N59MLP/6zKoZPpdYRd3mjG5IKbGS+ZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw20cbtOY30Tx2NDhcT7cGABauNoAi7NzJo1EwN4AKM=;
 b=io1koXjCLCqksBoF6GVnXadESo99xsD48hTer2SDRfi1fY6Ne9eAsHQn/B49F6DiuW7Syhe11SoReTr5+u8kNLx8ROE+YgCQz/uiwrs0HdMTta3fOfHq2jsAwS3M/SzrYlvrMYCqCmk8/MaS6k9pgXeF46CQi40SMiEfSk3c0JeKOoDJq0Lzghoo1qYs+oXmZ/zJL/uUj4MoFaRqML9jWqXywSC8zvHckrlEQ6xZWzlYKQT0GSgSCZ3kiGFyBIyk8lIVevwHriHBJqh7Cm3CM9vVyF8oASY1YgT820N9XSge2KAtckMjtkG29XX/24479LUYfzoXMN40XyA5F62TZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw20cbtOY30Tx2NDhcT7cGABauNoAi7NzJo1EwN4AKM=;
 b=gBBrlErmwKGmTWBEY+8+aefgDLvx0T0jK/kEkMFsH0A2szjAKPZ9oODfw6COWn9jo6V+lq5Z/WVvjWs5CPeDAkReQ+V57ZxBk8CmL5U9J36tPJ/oXoAtjEfW78wLreSZNHl4pGTOmrl3wWV9fMZeYvDhQ5apVGZANQXng/fh50PHaGD/SCxK69CGFsVNpCWxHIwy9mtcGyQUkQE9hSmlltfqfhHONqh4d56d4/UjrwxPDtgpnhsnoOkQ18K+qVOOq1qFOwVO+Tc7abbuDnW39mW/v/jicwDpywQkdL7MbOcasRvvGW70qf90RMAzE4QMPhal41k/S4nW4F8CrJM48w==
Received: from MN2PR07CA0009.namprd07.prod.outlook.com (2603:10b6:208:1a0::19)
 by PH7PR12MB6980.namprd12.prod.outlook.com (2603:10b6:510:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Tue, 12 Dec
 2023 22:19:07 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:1a0:cafe::21) by MN2PR07CA0009.outlook.office365.com
 (2603:10b6:208:1a0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Tue, 12 Dec 2023 22:19:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Tue, 12 Dec 2023 22:19:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 14:18:48 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 12 Dec
 2023 14:18:48 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 12 Dec 2023 14:18:47 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/53] 4.19.302-rc2 review
In-Reply-To: <20231212120154.063773918@linuxfoundation.org>
References: <20231212120154.063773918@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5cf4a532-de54-4f94-8c5b-44def4daed56@rnnvmail204.nvidia.com>
Date: Tue, 12 Dec 2023 14:18:47 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|PH7PR12MB6980:EE_
X-MS-Office365-Filtering-Correlation-Id: ae34f33c-86bb-47dc-6a19-08dbfb605b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aXyHSbEqlK4VCG+OaSAFOEF/xsegd82kM2nYqwwXaxcaY1ckHty41DAtchaPdytiamDZpgkPCdNKA+KOTLgzBGXaN1/hc0IwSF5xyx8IXGXNOj7ZtZg4czYcAdj4Lm+pYsCOCrAlVsuNw9XthxJ7O26RJjUCjPdeaP6HyA0sgUxaldJO7Dbz9EshGOY9rLn7jyuVhgkq9JDDSimUU5WI/mcFr2Fh3VrHxTZohATUoE72PeA56ElPUjoYmsGz9gGz/fJiG7kNnpaFFaoAInrWicjk0gpeIZ6W21DFA5ZFqajC15wIUxwvKKdkMV3aFhLe8+MyL+m3S3pB7yqVbka68Cw+vIOsNnmIKZ5hf44uVA8QIjckHt0yHU+BYMHklPZslcyZrNasVvWy1vDVGzAOV6Aepc0mzlmrCmuOccSoQwEE4EsD1E0Ks1PNbLe4ram+ruhTb9IG3e+fEK4NJ2JVDJefwxI3t1AW1Z0qklVXdleJ2GZZs00DqX3PE0S0K58g4zQlHanEWI4Sxpm+4jkbbgzpqDwWa9nBDRUhrG3NdBxRklVz3pls63Syps8Ido9siQuzRaTMPyMn1Ginn6+em3/8KtLbOglwyb1sTuTfpD7agg24i/mZqOkXAIqqhpI9G4tvYjb+hYB5A1ffJtfwWHgTW/sCLplzJI55TRwe0GfK955kiUi6OvVWkoExyrruzAscs/svuYLhTtkjwlzkrXhqlRg1G3E4Mc6pzHVHSp9GqCcB55DhrobEKA4Bxs1y6/dq5af3MYDOcyTdG5cveK9ene5bKe1zx/T+ftnBOgs=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(1800799012)(186009)(82310400011)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(2906002)(7416002)(40460700003)(5660300002)(82740400003)(478600001)(31696002)(356005)(7636003)(86362001)(966005)(26005)(36860700001)(47076005)(6916009)(316002)(426003)(41300700001)(336012)(8676002)(4326008)(8936002)(70206006)(70586007)(54906003)(31686004)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 22:19:06.9568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae34f33c-86bb-47dc-6a19-08dbfb605b61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6980

On Tue, 12 Dec 2023 13:05:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.302 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Dec 2023 12:01:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.302-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.302-rc2-ga7780f896379
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
