Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A026A003
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 16:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706026242; cv=fail; b=ROAQNMhyH+gdUikJos4QDeGLkbAF66HxLacuqXUWercWe9t6jrST524GeikbgRWBxSGC/M1h9Cn+XcD/ZmY+bN1sYxTGV/o9ckN0jtjN/Ecuf1eaNuRXmtxdxiI5tFdP1uIGVTGLxUD4/ic5zWcrxTGetvy1BWnS4HRO2u6+B3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706026242; c=relaxed/simple;
	bh=8x/U+RKT8OVKnrBEAXf/LK65xEWSbHBptzMA4BfL5Pw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qypiVwi6vasPnKEnHVTazfjEX2kHoT/0AdK5ZnhqjX2arHuZfQka94nohhQ20ZBa7S5hyst8WHrQ4X7R8v0DJOo9MRlxdARHY8/Tkd/06T/xIYA8x8y8cG6OtBflNo4ZKZDBWK+i9E+RzpQU8e57iGS6nIvLATYr5I81ezsgWWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CpkXrko2; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CpkXrko2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fp3OLOtuNvSZ8S7prMEI+nRbvmRevHIsxuDrjUmFN7GT6HNEw3obBKJfz9BrWnAgj5taD7ilXpcAJ57w5gruSFXGTY8lWEFZaehindsXtVgU8s24mHmDDjvP/yFPTw4BeWp/L5ebJDB2oLtvnID0pEFvG4yWEW0U4PBD0rR5xS+7pizrd7tBc3pXW8pV7Kb6ILhJ4jWyBe8mK524UTqOxY+31J+6j5olMyGm+km1H2kPpUqx9iEk20RMUfnfkHSwCFQCo/pnPbSPiA2k0+4+D1OjnuL2vdrpkatmrNlWzJJEPtTCQXo+rivugcZKcZ1XOqc9zduiQniLjCE60Y/bRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRLsaEYdMm6zud43VFAgWIJonCUkeE6s/nFJg6FlWWM=;
 b=cPNCWfcHM1kjYYtK6HgBoli9uppefG9uVgDIbcpLVEk2eh+KHVQQPgP9JW22xhwf6+mxWQrv/4qEh0XTXD4eHVifP9dGppibM/UKrPaQ6ad5DBebK3xZxnOon1gf0HN3qqlIf9K2zqzN/tMAvIEX6GQ5qBjbGgRHVH0p5djLFWf2tnyN/idniYK57xj7mvChI8MrReKV7umvenEjAhngGKVnjWintPnp4CKguwAfSkaC/panyL+qiinEceBAdzlCH7qOhJq3vf9vrAvIZnUCLsU1HALy4B9FnnKM0BUnZwXqdsFAD4O912amjxwv+PS1Oc3UgxBX2nWmb5vykryCAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRLsaEYdMm6zud43VFAgWIJonCUkeE6s/nFJg6FlWWM=;
 b=CpkXrko2cneoR+wCJ7x42mDyiOimM3ubId86NdD3Y+QqoGr7k4UD7+gM+G+AfHqIK1BQ3wGBdoEBmF4WnRhL6i7W1LqIpjPu1MdzMjKB25gPpXDTNT1Yhf4mNMyZdMAiJSSaHK1l0X5GEzuMRI3p+w7hB8agokTXhNJexsPnmYQRfh89+2HJFVy+sRzwGWvz1xmWjQAmVkNCRXCfAVLj/k+3LIAED8TGv5X+FXC4aofMTxUqPMflPhLqQzcEmCL0o7psDD7v4oKPNg8GJ6dTG6Clp7Nqzq7OuCXWlSe0lNbnd9KBLrdfJJsIenTF+UXuDkhJ8dP/T3NtoXDnLnDBhA==
Received: from BYAPR11CA0108.namprd11.prod.outlook.com (2603:10b6:a03:f4::49)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Tue, 23 Jan
 2024 16:10:36 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:f4:cafe::47) by BYAPR11CA0108.outlook.office365.com
 (2603:10b6:a03:f4::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Tue, 23 Jan 2024 16:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Tue, 23 Jan 2024 16:10:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 23 Jan
 2024 08:10:16 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 23 Jan 2024 08:10:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 23 Jan 2024 08:10:15 -0800
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
Subject: Re: [PATCH 6.7 000/641] 6.7.2-rc1 review
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e42056cf-3570-4126-844b-76de3bc3d729@drhqmail203.nvidia.com>
Date: Tue, 23 Jan 2024 08:10:15 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|BL1PR12MB5320:EE_
X-MS-Office365-Filtering-Correlation-Id: af6c86ea-402a-431a-8725-08dc1c2dd596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BDhMMdk/HmbM4mrfEzw/zNbyJdbV2KMzNETj0Jx8RGVN+wWWRt3RgGne4eT5Etsayynn93lqxms6vSC4+DYUpgpJ5Axlb5VeikVpvfMdwJQj3hOfwg9hVDmBtzWPnNVuflANrbkzxJA6rwUTumjqpMr1XpMbHCEOB+mDUn4iesI/bV4jHuDnNGmCBO16V7SuWeDXLVaMvI7ts67cgzvvuagCMylEHMfKYcncDcAXvJ38eq0ua0Aoup/Fly7Ki6AizbB/WwPpT1bT/G2+YXkJ53O8QHK+Trcsct+oDEZM/u66zavAJ2/mM9ERwIZtXn97HUuQZZ2FC+FPEFnJbvw2LX2AshRrR/hx3hTzVAXrEUPIsGMnxuu0mXLkoHbS/bvnsQ8ciuy3tVD4tXPkQSGOSNv/dfLSGAjE7cL7lbfcsrsaI7AwAIQ/eQZcWs7sjR7LizeETLY/bBDlQw1SHaUdWRFV+jJ3qXAis1jvCFdFhoxGfsSj3coU1ARGgpJhql/q4XYLcgCo+U8qTh4lxg0ca2r4kMlnlJWRGmyXNuEGKqufxZq46SWlH+if2vDdjuNU8+lRuLvtS/xndJwL0Jf7Rb6pydKz6O3CiMYl0LGAt9EL/fBGb3IGrgJeiCi3NXIOH9NuMoki+OXt3cmMfAI5Y+vTCWu97crN9NZb86mhNnHKmwxnTqu+599kJmwnALdayIy3DXtWZOlYKmpB3ImZ3NWEVjATw/YzuqBuQa71wLDdsEzu/F3QGjNCAG8jnzyzzWUiDs0T9DBsJuNHimOi/Bs3SFHjhLYnGuAKJhkm5A8=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(82310400011)(36840700001)(40470700004)(46966006)(2906002)(31696002)(7636003)(26005)(86362001)(426003)(336012)(36860700001)(4326008)(8936002)(8676002)(478600001)(41300700001)(47076005)(82740400003)(31686004)(83380400001)(54906003)(316002)(6916009)(70206006)(5660300002)(356005)(70586007)(7416002)(40480700001)(966005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 16:10:36.1817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af6c86ea-402a-431a-8725-08dc1c2dd596
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320

On Mon, 22 Jan 2024 15:48:24 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.7:
    10 builds:	10 pass, 0 fail
    28 boots:	26 pass, 2 fail
    96 tests:	95 pass, 1 fail

Linux version:	6.7.2-rc1-g8538581d9e8e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra210-p2371-2180

Test failures:	tegra186-p2771-0000: pm-system-suspend.sh


Jon
