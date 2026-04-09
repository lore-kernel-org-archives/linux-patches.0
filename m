Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011042.outbound.protection.outlook.com [52.101.62.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E63A9014
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 09:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725484; cv=fail; b=LV9rl7mRPCCngrG1MR/PGAA8uaBaqbzWEiawDj9PsqR8XZHphEx5OofwfpP87oc/BEzTYA6Nyhrqh0uG6TBzj2E3ZvGG7yIv8qe5gqoo0hQORHuIKw3klCI8MoD8nCCC3/SBv5aFLhgBFccZxoWAKrd9g5ffxf4MqwnLXhMks54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725484; c=relaxed/simple;
	bh=DIrlbWfjUpI9Uig0HHpaJgNkHE9wCTzY0FnGsoFHnHY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=si6EchK+01c2G9p+qChjfkD8MyQO2vCcz3TyyQAg+SHr22OTtItGtD+l3guTgS6APua7G/WAbc8LKikh8xsBDG70qV742xlhGUjHJ0YwlmTrDzBYHScUm8pXUBZJwiXrRxVJhYb7qTMYP0hkmAbrClNP/ww5oIPjknfqvJJXucw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TxyK7h3w; arc=fail smtp.client-ip=52.101.62.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TxyK7h3w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVqntYCvMjgUsNcSzQnfCAXBGCSC38gyVZDhzzZFwsGYwXIDzlKEPIXe6W7/sqD6xSsa3QUM4p/XlZoAwrs1nmAVW901mCCT2EsaKcWkb0z3iO6MuioqIgMV0zn3u6dUU0iCe+1p+ZBv/7gb0U6VJI6zCHSdLMd/hJCjSNijCZvEmA5fOFCi8fLBiALiIdNxzhSxu426MMnsmwkRuTANfauXRmy3xTADU6UTTC+fEkPdzyQ3eC5GOCUv9jPXDyxXmfV6BNxtpwNU7OpvZ+C/6R8rLRziCFBWuuiqUdUbUVAlkuwPl2VdHRd+AseKr0UWQnL6VrLkKiuxYf9IIriOcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2EOKPoxZnkYKNpzPsZYC+SGKcYjbZ1MrVPmrYTpMb4=;
 b=d7QEKdapIiWf2Kymx6hnH5GkSKRkrRTl4f4UJgNo1a+SExlGXAntMgQUnI0krDhp+g/oxduSrbYt6slag83rZ47SMcMZ19yKQFmAt0w+2gdSG44X2H/lmwes2W5uw1V79SC0HE6zJLvE2gEyWSiztNW62Qkcz1melHKtStrhLfUx9AGwZYFQGAed9Tp4o/NbYd21XLKylPkyikkF3AA759idvvkm0ZppQyaI8z3XcQJxJf2H7Sf2JlVVMFbOrM+VBZ//sNc3HXRgtc/3KSSaSPEv1GTMGQbZ5knp6JKfUhGmWOhNDrYXVbdkwDzGSELtPMrcONsANkw4FY/lUvz5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2EOKPoxZnkYKNpzPsZYC+SGKcYjbZ1MrVPmrYTpMb4=;
 b=TxyK7h3wBuBuRj3WZ/gz94uWRmaRaNjPQwOlI+YSPkFr+MOQwGyb3fGzNJWD8tAF993eX4qn/W1MJbl9KOoP6LZHp8Jp1ExyN6BAY6vw0K/pyyAKCJme5aJk34gJjHZ1kzIebmDZRof4sWmqi5nhxKPjHQbRrPp/YfaS0nOdL2VuJ9lDyEHYKQwFWL3UmzEcTSEMpgYbz2gmeKch+FPMsvQyWEFMOcUSVugQyvKid53YFUTaGrjc0ZVGJA39mdsuG1w1GdwUOgRkXaTJSiGQAki8sTCvu2W0cHJj86bFcUl7D+XjraL2D+DE+vkUQ+BnPOGS6+AoOLWTvj0bZsoZcg==
Received: from MN2PR15CA0038.namprd15.prod.outlook.com (2603:10b6:208:237::7)
 by PH8PR12MB7205.namprd12.prod.outlook.com (2603:10b6:510:227::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Thu, 9 Apr
 2026 09:04:35 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:208:237:cafe::5e) by MN2PR15CA0038.outlook.office365.com
 (2603:10b6:208:237::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.40 via Frontend Transport; Thu,
 9 Apr 2026 09:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 09:04:34 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 9 Apr
 2026 02:04:19 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 9 Apr 2026 02:04:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Apr 2026 02:04:18 -0700
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
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2541d40c-870c-40ec-a229-7e933c735da1@drhqmail203.nvidia.com>
Date: Thu, 9 Apr 2026 02:04:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|PH8PR12MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a695a3-94d8-4389-4edb-08de9617053b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	D+PMNIHjWKYtgyUV/CtloCU8IqBPYrtR1kVGCuineZE9u0Z+Q2HBPfmKrckyYpaT/Y+0kWBm2AwcBmeqAlO7eg6b+nwASaG0me/nACv7835shWcCKbJm3vpVmifLsFcOA+qPBKX3hMaBX6JodhllM4CZSmCH7eFnAVEciHx6ms9YQPjat2D0GmEi0O+m8ejXgVX+0iAQoZJm4RecQJVxztsNAMjehyb35x2qNU9JGmUGy+4U+0EvJNwYwSROW7Ql+Wq8yqY0J9svsLqpyxNZIz1larKi0zSWiyTn9Gd+dh+ImQ1rZPRlYGL2jqmW5yU1CtdUo8aaP3keAIQQylVp7GhNKGzSE/MK90dfTLybNFZtQHipBUZE+R9F7QUrfK1orCPFhhRwLiIBAkythM7F3hlmUoV32j/ufFiuydSrLTvg6a3JeSOfWPsTUHXTsafCQLxy16AGtCta63PuBt45unF8gDyhJeGW2p2BgjPwZHjmjFEVJOw96vOfxOskk+WPcqQjwdmePgmRDWScE1x0S0OOWoF02jGWexjw4NUqXQbd4m0/MRpMW6KZcijxaXn6Y5oqw9aj3d1xK0XVyXlb6R9Qmt5fmuDUhm+dP2ERXse1IlgnpTxFttzBACZ0zez6SZ3mDUwTL9oyHXhKLs9/gRVhx4EAnLJMww3vanHV4nOpyKfHAGcxs3hb6vf+X+UusrT1Knl1bsDi9F+HfdRE1pFChoWtmcik7hhnObZ3gSflk0biCcWI6tjDkKfr7uviS1RivOve2ayzJ/xc9/+yrQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VnKKL0mVzL4tK/JznF4/BU6/kYs1SwyHJ78Stl8PAu5cLBIv48lC2q5JNEGw0REVlq4wcWSG1J/XWZjGIiFpfR7pgh77uy0ZaNKC+Jc9DT78vPkSBv8zPexwnjgDZ2WOZMeupg7YeMn72yoeQMo528yBKWej3ms8flxN4+vh2ENmShvwy4cDVIcrqlhOhSEvGbzP8sAOFhsy2eYstYwjmreD+YiYOGdAjr55dxMYRKGw+Sr0vw/oeHMZHCzsWGAUrIYok51xG+x3R4J0dmxeYPznIUjGwpDRNs9Jtr7tmd+V9tWPUJxBNrMZ8ExYRKbKr28qmbnsqHO4rt5h86qOaBCX9E64uXuwvyuNUv/lxUj5RxW4Rr1IRpXTN8277Ch7U/n89d0Jw3dw1aYFvwXUTJGkfxNoTL0rERKE81qEN2rS7oAy31lXh9kKoXm32nKN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 09:04:34.6403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a695a3-94d8-4389-4edb-08de9617053b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7205

On Wed, 08 Apr 2026 19:58:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
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

Linux version:	6.1.168-rc1-g4de16baaa1ea
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
