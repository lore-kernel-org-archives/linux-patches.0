Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A530B3DBD7E
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343084; cv=fail; b=FozW/8QEG6jho8sN1H3k5XCv8vh+OXgZnTVxEAGUf1HIJMMri4PmJYColkdwV9/gF66kK0CmRTdOfadCyD0B4Pww/6OLWKWTOpvqirRaxMCuVMTKivt+D8P8funEypjenVhQLzpWTk0Ecf54NAG/2jssMQHxgZyCX+7Cys92XaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343084; c=relaxed/simple;
	bh=srqYu43gX6E84sOBnLbBhE+A5NhRJvNjZg7ksPsTU0M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HE+OIlPEf+32WoI3Kb/tdgSCFjoKJ/QGMSU7ECd9hB4i5YIUblZyG0vgnuZUABmbipTUQIALf/32ceOAisZrI+uIacErjHTY+kTl2EI8H4/dWLkhTaCcJa8sNjKlOhwkBpL/fDVFnLFJfclWeKTC3VyxooBWjI2VIMkx2BnmXcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OFzceRFh; arc=fail smtp.client-ip=40.93.196.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OFzceRFh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=do9mQNnOqJ343I0ePMhfd6mt+L2JU8Z64XfC6fwxAx1cF/M3Eta91At6PmJ5/Mjm034FlXRy+wFPB/5sikupbWNMviS5tZdZZHpNZOOCMxmZdclglqq6jeik34OOPDr8ZvUhwCUbwnXsj6bw/glI4fjF1tbwljkkEk2qqLwR/oI1KJMeFLaH0LXKkZkrrfnZOlX4Le9wcwBmjfdHC4WVGCUOTdLmZzO4WEK1tOjSr8FB9jIcw51ixTsVSmT1ZofZj1yNUBiODnX3NkBXEUEpFzL4QGyU90FpjwTDG/YqdhgObVqgNex0/DDuM5q3r/3qDvgzMzCNyhlbR/tT+OBedQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1v0wM2yBXcRW9/gscMSpd44sy9l2euM/9VsPnSMmx0=;
 b=SJhol41lrl/WaVlRNqYsiL/l0rEF/RNrro7lO0XyKvWCa/5GO/BLQw/17OgL1F2NggJFYfm6OISe6ByST9mcSfCIEvUg68gi6b6Aor562PwIRULF/C+O2smCqUyopqhdLcd1ucLP1H6Fg2VQlX9TEiJqk0RaF3LE7xR2etgfZO0rZzZZKlrMB1XhHgbdOPsUhGBaNptR7VJs5/len60Qgt0i9kMAle6yY9R4Ga+gGmqtGfvcqRSSDSa6r72oY/rI+uMLvDoZrs8f8tK6qDZsbQzdBsi5egeTn9XlduBJnFLHw4rHKUgsUvGdCPJCuCL/8GY8rervd7XvxwJKuOLiAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1v0wM2yBXcRW9/gscMSpd44sy9l2euM/9VsPnSMmx0=;
 b=OFzceRFhAMvrTqoasXBeVsRQsI9+mQmgq2m7Pj6HpWb3fFSwQoNkF6PlGAHdkgsPnb36IU++qc/fsndJ+HnaDEgO2LjdbmLLqNxa61CIwmr293l/X6eiCXZ2SWELrvytkGU5PLxSrZeiQm5QESiKYa6/KiKjd1NWjDkHJ5Pk++2SiAAe96z3FiX++GaPcwom7CwdfmiLbuycawm6o4ZpVpYYe1uAE3vhl75f/usig+Z2KRawCMhlW08L1dJ7a+A/PW2fKvPqBv9vSxMQaVOSEhXjTb85mXya99gvkZwF260N5vSPaC6DkgoC9cKfcX2lkVV3E6423gR8pKsOx113Dw==
Received: from CH0P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::28)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 09:04:30 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:116:cafe::63) by CH0P223CA0018.outlook.office365.com
 (2603:10b6:610:116::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Tue,
 24 Mar 2026 09:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Tue, 24 Mar 2026 09:04:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 24 Mar
 2026 02:04:16 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 24 Mar 2026 02:04:16 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 24 Mar 2026 02:04:16 -0700
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
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ed2b0f10-6583-44c8-9be9-3283d2eb22d3@drhqmail202.nvidia.com>
Date: Tue, 24 Mar 2026 02:04:16 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 89379073-da6c-40c4-4b36-08de89845c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|7416014|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l+lwTE4C/qRkGXbMMi+ATx0Eu+DOljlT5IUurE3NpwBe78lADfM5Jnd7L7cq/Dc8fwoHE5IzPwkhgzqc5/eU6kX5HYMjxV//43LGuLuZead7a51lJVE1lmRXnIJ6wz2EZA6Y4lMWV+Iph4xBQy50vP/mfELYDJtJ/mgBLzfk9MvAjoEh7ALM1sfjpude60LdUtxGk8JwraxJfPlRs2z0ulOb9MRaIsqk8ab9ivYhNeKQX6cvAyUHPI1GO1iVyKV91jYY+BVD3f+VvoqNxbBG30QtUKQyvyF7YVRMqLQqmMsXLto6bCBzfYZL9iC3BEvI0ZVDZKylD50ZgZHtMoFNgxGDKSV0UZS5VoE7sn9IjHuxibt7qhZX1cI0WC+JN1VleCjZde2LK0k2XZsGxYXWyCaZrnjVo3QZSer3YWdV3TI1K+qCwerHq/ESzMkYvIWlvI0g9k3QyS9ILWO7HFWAK7EKAnba7lDu9LMUJVRvjySrUi5ayeqWkF/N8PfbmdoohMssUt6l0Yc0d1aM1uc+hOXInfdiHvF0oVXVd4OIlDLuGMsHwLrfyVkWYndRqDHeUR4NRp0KPZH0MUDwbOpOc/oFO2bj+J2JFFkISpbkSreIGwvBa7iSGXIU/4TQVMYKlo+6MGYZ3ZM93PGy1dMX0+PeVk6JYcu0vVjB4Di0zNuQnjNtvX9ZpkbkSFujcoIy44k7qMHAfepF2Fh+NZiqYVGIapc7WsJW6se/C3LPnzRdvdO6oShivYC+45s4z+lkis3FJQPl4+liI6CpfhicNA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(7416014)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ik7sGkciPDCWYdyt8xe7IRN64uS1jX7oAkm9vqjfdDBR2HFgwgXL5gf1kfaARRXqwYyXtJVKrANbsPRSAVPXkdOpp9isP9o9bsncDyOCV4nC0ZTA3FooBzUsn+tIEsMpd/RxjNfolL6vfSMTHganzf/d/Avwx8mLhrth7CaTfQoFK1e5mZfg39gehTsuyEUw2iYKvfJ3p8Rs9fU6ApcqNoImxGXX587d8Hq0WAYkdpxzCWsFarOPVsfHWiTJ0rXMhHlAA6Jbqzf9d/rYqjL8wt09RJ7yxx2LaCJJNnNZyKGn2uKPAd+QSXCTI4v9ngfbRaiwXSotkUhIvI9M0m9nYuTAzOSaVnueAcsJA2j9p4GvQ+QEl04VbVfJXay8km6NvNR3ZU0Mhti92IvuVOJ08XaKvzub5OrIuXDy0sJVEg1NVVtAXyWahorow5dkYbWM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 09:04:30.5510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89379073-da6c-40c4-4b36-08de89845c1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527

On Mon, 23 Mar 2026 14:39:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.12.78-rc1-g461750713daa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
