Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909003A256A
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418715; cv=fail; b=ALl8HDQCVKlk9BdHVPMvq2CsxoI37eFb8BhKp3Ul6Sc+bSyhVmmE//2ncWiCmqV/2vkHrZQicHmNoWxieHOIn5hxjjgAleY3YkqxrFAwtu0CWdCn4vj5Nr1qK+1YzHGh1KWLgXaxY084FSkSKDfNjgrsUjbQWfNAhyBGv/apjtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418715; c=relaxed/simple;
	bh=reQ2SGJPbEyXEjCph4oTXgqm4FqK/W7+8sl0zgwpYAg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=OXmGF/NF5vTZegi3GBcsdbmvlibDMlxfcUlRMoaynw38o7rkiiro6cGRz/aU52CFibNbcsl7MxrkU6nGTLCWZzr0tks/eDri/YNDyhgaYhoBbUuarC7vSjnnCKhZmK5fQwJdSCMeUr91lnKCRfzikN4q2ZT17HSj8TjR2XhOvag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UhG6QGvY; arc=fail smtp.client-ip=40.93.194.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UhG6QGvY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTTbveyFPhJMPAQH2lBkH+FGPOAYX9WocjhxEUucexkd5TW92gSFk3SnMupZgFxT6hn0F+5O7rFJVAkFm+i18UGLu3ARvaCrD0BEtZZgW+tyT8zEvmKO2qqX3ve0s7gVeTzzMmyTzHNMaDQkSc9Zuom8UTirj+erI3iODXZWLa5rwYr7Fc5xxysooeJQpsqHpt4jzXigO8Q9qy9jbGJIhyxxFyDeZxD/dEl8DXRSRJQ37hl0X2JQpa38Hfci0RnzfvojSUD2JLC3nQoPVrXC8reUz0aKeI6C/xA/oLKcJJw9kLVUY5MO8DGl+iBtJzKMq0jKbU4bdjXYLjOkVE56Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhFyU0f1DuVfH7Ad98ZfKkcDpl8+dlxpDiA7GUA2YKU=;
 b=INm6nv2w36Tt1DzouHnd/xtPPcB9QaKTqt0CrQgBZul49KnIsPaPq0OR4W/MK5k6jMKODg2UCVeFQekARfPlUwNiFPimsatFeqwYlpp1PEYxFtDGapqk4VcitdAw/8cfGA88be16G8fwjOldL0mN/QOxLJDRSA6fIHtmHtD2d23OVeWzFOaPsNd3/STR+zIT3VfkgsMDB7bnuJAS1Ynrbn9AIA0tB2V+ZDdxINgVQvYnyQ7ubgQTT5v33W17DBbS7Ve/quLEqQ4ofeEOOood91soHXYJkg57Yykh/lMwx3a3py+yFMsbZhO5t7RDtjMSjH7Y7vMlYx6yl3H7vCCsGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhFyU0f1DuVfH7Ad98ZfKkcDpl8+dlxpDiA7GUA2YKU=;
 b=UhG6QGvYwicDHL56TY9oClL6ZumHdc/EYFEYBgx0N8deFQjMvrUChGG7GJjdwLDbR2QN/g7Zt39j+3BHpgly3IV6D3wWWTlsiGLbhJipo+btkYqjHas+fViXTiiJ9lAYDejK54XIMlNuLo2goqUVBDnWjgw4yXuwBojWz4GrBPhwMbMyIOuSG2u+AZwnZ+IZaIOrUzsrwbQqucxSg69rNI86p4H38CW/o5sMwZpWEnUvFuearSQd8a2XhVQzJACpTOhkI6z1eXOB7YetJN4kxiVS/ggVzUFv0VuaBnoA7tWJikSb8tczAFPTixlKHKsx2dLp7AnMiFvVvOtUrDeYww==
Received: from SN7PR04CA0097.namprd04.prod.outlook.com (2603:10b6:806:122::12)
 by SJ2PR12MB9164.namprd12.prod.outlook.com (2603:10b6:a03:556::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 16:18:30 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:122:cafe::8f) by SN7PR04CA0097.outlook.office365.com
 (2603:10b6:806:122::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.27 via Frontend Transport; Fri,
 13 Mar 2026 16:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Fri, 13 Mar 2026 16:18:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Mar
 2026 09:18:18 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 13 Mar 2026 09:18:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Mar 2026 09:18:18 -0700
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
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <92fdeddb-1671-413e-a1be-9e88322ecd11@drhqmail202.nvidia.com>
Date: Fri, 13 Mar 2026 09:18:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|SJ2PR12MB9164:EE_
X-MS-Office365-Filtering-Correlation-Id: dab1ffa6-51f4-4ced-0861-08de811c2a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	drdf5T0cG3BgCbCIjTwPDZFMpabWG0QTuslYowqs4zZU85tBO1MYQMU/gGaS6WqcToymPQS5YYP2xiLOZNPkXTAXuRS9K7U7RVF1cis9+tHS1oLDurHKHSJc2dQjKxanteDf4o+Ur2i2802K1ntyE8rQ775UwR8oQXFi5hfw6bKuhiTrDG1d0E5OuMRYybr2e5s4fXZW9ZglFMbUWM6MqV55yflXxMbnxQTfdQwA7U/kMF8sHaPqjSwv9LGX7wyvIb5M03Q8/8DzyJApw4/OHk7sJqP5z0jvQEdY7Rfsyxc/2T35RX5w2VOgIx5fGrnU7M8HZe+dT9cZkaLOQXZCJlEAQV+ESO5XMOcaILwG5oI1NlTx343vJtArbSVX+YUbAb9cacybSUK6xHll0NNYC0Hr1gEB4w6ZClCUu4AvQzltDJqvyExo1wZyspYqyZdDi8QkbS6wdMCC4lI3/QcBaABieCzsSyMUgBFTs9pfccBKvvqUStua9rX2G5cWGEOgLzewHsCNX5U8g2FOKbKmSRU5ley8Tscg9ACwoA3JpRl5wtd+6CltJ0IJl8Xduq6eEgO6fMdjWLrAL20DdHo2fSXPy3+J0Gjo+a4DMQdP6iSoVlH03IjaPXgoEJFKFz+wh1mJbt8A2khmTUbGqmQj8fd1vVKhGHhU0Uu5mKA5iAifiP3roXJuaTdydzjioQwsSioh0d+7KbTWftCDiUWduU1iWKSTp8jYlDKAxJ1QKLigWSz4+JZZh27xM+RJdhye5ORDJxSWYM+jRf75Fy4o4Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p47PZv5tIlo7VyMFlJOaUl7coW+r6IIzNUGrUWfAa9q015FF8kRFRRSMztvjzM9ZyctmfMmEH0whDe6FvTE/hxpJsS8ZBVRIqr1Y21ZjzLehmFSbXN3Dz7rZWHRQjvTw5GEvt9XSZ2E0YIpjfnA2ypXH+ssW7dQ2wLcTQ0c4r+IV1Xj3rIyygDdKc8t7ntTyivYFrYNAZS7TEqvJ9pjWPGrlRPWoMoWD0x25r6kBeK46Jvj8C1KX3VYQmnLG7xnInNpaWyTsuQasMOmDD/K6PgVkVFkaTqCI4l/z+5Z1SuxaPBP80/juE4dFLOwqPssEPTMEneF07jkYOxbOCV0xICXyP0AW05KczGqyCO0l4gY4RB4f5KGoVrAd/uKuMzp6MJKelyBkINM7HWjKmMpF/uCB8a5eDvlC16KUI08LLuub7fyqLBifCYpaGFZ0hkh1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 16:18:30.3321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab1ffa6-51f4-4ced-0861-08de811c2a73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9164

On Thu, 12 Mar 2026 21:03:32 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.8-rc1.gz
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

Linux version:	6.19.8-rc1-gc1996363ec4b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
