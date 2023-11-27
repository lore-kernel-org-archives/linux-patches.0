Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A1928DCF
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 23:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tau3IyTx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S614i7DhaAwsWgoeGVCMo8DXBwg/3tpJzYIjFCj1qfMk6zyiDWEIx3IUNb3KJZqYcYEiOtShYUm13c6mD7iq1Em4e5kdeYcMmZWw5eALvCOrnu+ZA8B+UTHxbe7ruTNVX6HPrJaV3g/ZYPOqMStJCZxwZ/dW2mHoTy0Cn0JJlVadPXciUCHfT/Sr/qH96IjF0SmDCCcGxiNsyIPTTOFXCgYgP5V9/1BEqHxV6c06oeUqbeDqkxJnSJiE5l+cCKlZscJN+p2tJiWD53pZbyBTLTURbRPXfWor9m2We/VaM8F790oupCG2oJoY++d9PaQ76+BxrnWWDodWyfJdAQmztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XG9Y8cNdWT2ucSjtZYg1ryhzHtWqlm6iERwiuLk7UFY=;
 b=fUapzRoltS2mrpsUVPu8vDLdPtrA2ZadkJkghVknuIek9FQQYaB1jx+XZnr7xTGFwWci1ZwAl5PIW9qv+WvRsFoNjPTRleh8Fa56FZVlQnwviDCVgy9H3Zu/VEyv6wLjpvyzaVwBitebJwdU/1zDGTuPU3wK0QlPOGY1nwwW7dwWc3MOMw18kFqeAt6qNZ31DLlE4R3XoCXj3aZFcroFsod5j4uVodhFP4Eokl7QxJ8e4aBeAIq8JnLszuAZEr869h1hAfH9CQloP4lvHPLhgL0gjgrSICDQnQDxBKhIY7rmujF/Pvnw6/qc4P+0dvOFikVoL3r34/+KfntNnaQPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG9Y8cNdWT2ucSjtZYg1ryhzHtWqlm6iERwiuLk7UFY=;
 b=Tau3IyTx8rbGnFsNV1NmMmuPTUkdg5EK5qPacb2wJvqLSPugY3MrQAzht2gQDoPDIY2uK2Uk984J2gVCLelEdZdbWm9sPzOR7dZSz0fpB+m0a1EjuSvbBOU80n8gpdX+VF5GN6kFPSefNsBIRDTUoIvdtSVZC0HgeD8lJz/RqrCNvwlbWe7IqMu/m4xmW5i0TnUlwymYkaqM41kFikCU4vh39Dbg7TGV4fHQbf77JJCQM3OIxYiOf/49YpdCHiYrZ0x94JTiw4sR87pPaEFblqe9WWNy3lZvqJ9VkVC3vokZTEpbOhC9o18TewLTjOaHhLyy/dGeyzzrvhKV8VO7sg==
Received: from CY8PR11CA0039.namprd11.prod.outlook.com (2603:10b6:930:4a::27)
 by CH0PR12MB5106.namprd12.prod.outlook.com (2603:10b6:610:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Mon, 27 Nov
 2023 23:27:27 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:4a:cafe::72) by CY8PR11CA0039.outlook.office365.com
 (2603:10b6:930:4a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.28 via Frontend
 Transport; Mon, 27 Nov 2023 23:27:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Mon, 27 Nov 2023 23:27:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 27 Nov
 2023 15:27:19 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 27 Nov 2023 15:27:18 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 27 Nov 2023 15:27:18 -0800
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
Subject: Re: [PATCH 5.15 000/292] 5.15.140-rc3 review
In-Reply-To: <20231126154348.824037389@linuxfoundation.org>
References: <20231126154348.824037389@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9b0099cd-37d2-4f19-a6bf-6f1c82338093@drhqmail202.nvidia.com>
Date: Mon, 27 Nov 2023 15:27:18 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|CH0PR12MB5106:EE_
X-MS-Office365-Filtering-Correlation-Id: 137abb77-ffc9-4b82-8e1e-08dbefa06b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Pwjd8X+2DMqBaeOaPY1iPFqYpvKQlLNvzuMcxTRE19eWy4Pzo/Cbgr4c7RKb9wo3y72nabjH20sPMIysNiugCwk1GwIkun4MR2dsnttUwQ/5nOwebIn1a5puspRq+uTT3To3EiVGzJo+XF/KV8sIbF02AUwLU4uwwdgSt/ueQitRDsxPhfv/7vG+XoQTcBEXUkMPcVYsS3kKNtUWdawKhFwdvXEqRWbuV54j9O9u/bE+vsOkkpeSp1uRwFlO9kF1K6xAMC8BGa94/7UpvydovT0AUH/GfghYF4eRgRXdN1ybnlY5wk54I+xeEKFG5WMV+QrCBVMrDra6XNdhpFlS+MoWUxdMMqe/muT34tl90fGiG5J4Jpyy2hOPt2AQl2bj/LPSZCiRb1ZiR1ZXmsTcg/9iqwIztKuzOCH32CGbVxu5be0xGH87wH6BYZ0F4DfXxYaaMjAk3PtIJrWDIblBebV1C0CTBnOF2cGCFrjw0+j4W+Ab2NgCyxBeJv0mgQBvQtcqHD0wbfXouWbFkLErugiIeOEZR9O3RfLRKNE1saNd6pNJETmR5lQCV0zppz36FguETfSSkwKzxKpNeqh7irEqFlhytQtZZhtgDpja6eiYgqvHFLmbyT4xO4FirXwuhVXyORBumNh/enKuURx8kG4b4IyKc9POT6FrDZBywaDIN35UZK4Ve4DWdaKuBm/konbpk6QW/ZafcTuQJaAhMvilh4m2uILTFIhmbzLxgTaKGt9BNnYWFJDp20Kz52APZm1vp/L514DPXLcAKOdjib6uOMeAc+DZZC1F+QmX5Q=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(451199024)(82310400011)(1800799012)(186009)(36840700001)(40470700004)(46966006)(36860700001)(82740400003)(356005)(7636003)(40460700003)(86362001)(31696002)(41300700001)(4326008)(8936002)(8676002)(6916009)(54906003)(316002)(70586007)(70206006)(478600001)(966005)(5660300002)(7416002)(2906002)(31686004)(47076005)(426003)(336012)(40480700001)(26005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 23:27:27.7284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 137abb77-ffc9-4b82-8e1e-08dbefa06b5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5106

On Sun, 26 Nov 2023 15:46:45 +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.140 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.140-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    94 tests:	93 pass, 1 fail

Linux version:	5.15.140-rc3-g659e62181100
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py


Jon
