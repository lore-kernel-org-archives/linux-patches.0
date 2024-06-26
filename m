Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DF15F32E
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719388985; cv=fail; b=IYG79Ze3mNcK3SQSLLO59P4QA1JcPZl1WUNXG/5BYj9MtuoFqzB4l9frRXJ4XIjKaMIcJGQL3VOk9aK4WP/n4zKrhGrg9rAvsDhHRaikbWYQwr2Hfr/kXUE6EUmA3hbPDbvmbnQhXALmMg7skxI25IJW1hin/eYY7qr4RAI0pmA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719388985; c=relaxed/simple;
	bh=p0dPP9e63kv4SthdqIXbPTEzjodAuC9R5lH4AtG/jgQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=YbQ0scLAMx0Do62Q91S7DB6FmTlWwubR4yzoVcfn3vtLz6JJOzTOiQxiZ7cX6MIEprKMm06CSJfqbOGJL1aZ5m/ud7vrtm38bcHIZqqKbiHb0ud3Lxj8OBQg2yH+sBHqY80SY+mYx32MOGquhM7eHON8NVNmdFsx7WgkH3QtRds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sQVl2vEx; arc=fail smtp.client-ip=40.107.223.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sQVl2vEx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k13Qo0QEFpfBZPKErkpST/x3sNjDdP3iWIRQMjzfbDHya/DuhGyrYFs/CaQXkezKR2ciRgA9pZkBjYjIHvdP3SWMNZQrta8ye+N+ryCPuIF67xsvGdZ+j6+odaSSS/N/CAaEhCpHxvOAcPpY//XFqeUptNUySuHUNGikdl/GJ9W7PrZgZYs2CwZ3kC4DaPEv5rFyfbuVfQOM+p2uSIwkjaMm+Vshfk7e/DoQ6ndEHprM4DpY6fIRkcgzQas8ce6IrFitQmQZA6vcI+9qNcQ/jL+loA7dMu2FroD9z2/9YvBiscS+M/5XhxO1jogwtInbGP9dyQROr5DpGOCunOptYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRQ/XvyCZ5dF5sjWDPYnt1EgkDkvsW1xo1qPV91n2tk=;
 b=alfPYfqJhR2Mv3XSW1o3YueDXGNZRT7Gm+942IlBImYl5jORh3HnrC4aaA6HKzyto4vZVJwtto8WyVfELGpNJrN7Pym9Xa3B0C+QB0F58GY1fVLxuPq3Odt4s5w2gxBJ168W82rrACmYjiiD7pg5b2bi2b+CZbOFyLoeecCuALbRANp4y0BJQ30xRXo4lHsEAzvoKk1+vwZHX1RetEMM80mzQWfhlN0xa4YtQl/vtOITeuWEIkwUVjS2B6YGrbyKKLM4+Q6v7a0l4GFv+Iqe6252zK9AekntTMNUk4twiCtrCqM76V9cjHWp5XORunAhAwgQFZa1jVDC9fSQipfZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRQ/XvyCZ5dF5sjWDPYnt1EgkDkvsW1xo1qPV91n2tk=;
 b=sQVl2vExuEzgPqGNYMDfe4NOdBO6ccixsui+DIGzpmCNc9+RdBwpbfOje/pA4oadiCxHeK/jro86f4b7Tu3Sx7Y8y47AjoBdFOLZr2lVWl/cGRHF7V+GBO0uLHp0DLiwvThjvynodpjOE33bdeIATTWr7O7Xd92er7h7eAeB521tcIliUZDSUTC1nczfbuusqPMIG3yeCUQ7MGvkphMAevPYboxrewuzKE4+Wyd8o/Irbs8RVy+ur8pwH7cHwKUl5W0lrUHfPBR9e/Ec+NX5zvJpiLkHbX2xBdNGBppJa7srEkHzdXdmpfIRQkrCxHr0zOHlE6fp9kASoH4ZmjXQqA==
Received: from SA0PR11CA0180.namprd11.prod.outlook.com (2603:10b6:806:1bb::35)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 08:02:58 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:1bb:cafe::38) by SA0PR11CA0180.outlook.office365.com
 (2603:10b6:806:1bb::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.22 via Frontend
 Transport; Wed, 26 Jun 2024 08:02:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Wed, 26 Jun 2024 08:02:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Jun
 2024 01:02:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Jun
 2024 01:02:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 26 Jun 2024 01:02:40 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f4a858f4-aab2-45a5-bf04-734908d1113c@rnnvmail201.nvidia.com>
Date: Wed, 26 Jun 2024 01:02:40 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|SN7PR12MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cd9f303-a638-44a4-8784-08dc95b664b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|36860700011|7416012|82310400024|376012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2ZLbE1NR1JPZ0VobEpPM2pGTER5bVhMQnV2UUZ0L1dRQnA1bGlLOXFKUWtN?=
 =?utf-8?B?WWVSTGRVNnB6NzNvNnQ5NWVyUi8rWGRqM2NzV3lONktLSTZ1K00xVkpHcGhW?=
 =?utf-8?B?cnFLZ2NBZkpXVER6ZUhuMXUycDlCWjBiMkM1Umt0a054ZkJ0dVpVNkxneGtP?=
 =?utf-8?B?OUtFdWN3KzN2Y3l4dXo2eEZGZ2g5MERrOEMzZlN5OW4zWmIzVy9iZzFQWmZP?=
 =?utf-8?B?SVdSYkZnN0UxbmNzRzhWU25tM2svSU5LV2RPQXkyUWtGOFdVTW1ka1hCUTVw?=
 =?utf-8?B?V0FNTEEzWUQ3WGVUYnlqZnRwano5MHlQRStoMjd5RGZBWVhwVGZrcXc2RFoz?=
 =?utf-8?B?K2tKQ3BwZ1p3a1RBNmpJZlZoU3FYV2FaeTlCTkJTYkVzNjhRaXlSTThIckp3?=
 =?utf-8?B?M3BvUmlaeHNvaXBCWUMyVnVUdEx4R25aVHlpd1M5UllWbTB6RTBhYkpxT2ZY?=
 =?utf-8?B?Y3JhTW5iVXV2bnBveXI1UEVsVGMxZVludm1GZElXZVFMKy9rWmoyNS9EYlRZ?=
 =?utf-8?B?RFVGOUxtQ0VqY25wVzN6R0UxdGxNci9TRlF1Vkgyd0R5SXlQamExb1M3QVZw?=
 =?utf-8?B?czlCODRvaHd5UW93aGd5R2ZKOUZoa2F5dW95cUlvbkVvaXBNTlkrMEY0dGh5?=
 =?utf-8?B?M2c2OW9EOStEMlhuaUJIc1NMRThNZEp4SWFvYVIvdlBuYVpiYWdQb09YTDVS?=
 =?utf-8?B?VitBdjErOEl2MWNvb1o5Vm1YQU9iY3FFVnAyam5yWk4wQjljZzlia3U0bjh2?=
 =?utf-8?B?Yy9IVDJhbzNQWGJacUpTNWY5SmdFWTNIMm03Q2lmVmRWQ2dqQ25nbE9rcFd6?=
 =?utf-8?B?T2kvNVpvKytRV1NSNytOcWR4SDNyZ1dvTnhaWXRkTTFtKzlWT0w3MVpXZWxX?=
 =?utf-8?B?MlRFN21kN0hlM2Q5R0pIU1hqT2cvcmxxZ3VpMTQzdTNoYnVuNVcyNUg3dHFX?=
 =?utf-8?B?NjlURU1YZ05KOW13bEgyQ1FkeWFCUFgzVVEvTEZqNERzbkRleWtGSlBWWTA3?=
 =?utf-8?B?SGhqT2NialJsNFNOR0UrTXVyOEJ5VXZvbWFJd3dDU1B2bUNGUnNrazdMWHlt?=
 =?utf-8?B?SGQ2WkU5dWFsVnQ1Mk9SWk16NHdyOGVmcmxySVRweWRGMG5yNEhaYnRCN0t0?=
 =?utf-8?B?dDBKSFJ6WWhXZ2VVSCtsMU53WVNwVVJVdTl5WlBaWFFPbEpkRVV5aVhFa3Bm?=
 =?utf-8?B?UGVDeW1FaEkvQjZBcS9vSTJ2TmdjZU9YT1hpL2JxSlBUM0YzcldOMm1xZ09k?=
 =?utf-8?B?SU9FZS9rcllXb0tSNDNFVG9kS2dqUHF0WDB0KzZiYUxXUDUzRGo1VHgrRVJO?=
 =?utf-8?B?Q24vNjZiOG8ram94UjdzUElNWWRXMzhjUlBVSWM5VklWMlNQcWR3d3hHWXFX?=
 =?utf-8?B?VXpqR3FHRkhZRVhnN2FPVnhOUmRaeVBnSGE3TzRndUI5dG9USUM3dnZUTUpC?=
 =?utf-8?B?Z1g1UGNmaUVxWWhQMnlON3EybGhzMTl0eHZMMHVTanExTFZKcmFBWSswUkNZ?=
 =?utf-8?B?S2VONytVZ3paSFR3djNOejlVY1M3N1NJTW9UQ25JMmFpVDZGeWhxUHY3UkVn?=
 =?utf-8?B?RXFqYVRiNGJKOGw3VXJndHJiQVlSckRtS3Y0VUdseTBwcDVpNi9RVnN0Mkhr?=
 =?utf-8?B?ckQzUjNPMEpIT1IybEovNXJPRXl6NW9LWitiT2ZiN0x2UUM5RVU3UnhpK2dD?=
 =?utf-8?B?ZmtadXVOaGFMZHc5dzdJWnZDSStZTUEvaklZNENtSGZKNzBhVW16dmZBR2xj?=
 =?utf-8?B?by96RTYxS054NVJnajFHSGV4bXE4TUlRaTh6SHBtWFVKMzZIeUF6OHl3ZXRY?=
 =?utf-8?B?bVVoQkpmQzZhUjlZKy9KM0JQK20rekpwWXBya1M1Q1pWRC9NZ0JIQUtacEZ3?=
 =?utf-8?B?L3NnbndvOFZIS09mZDFrWG5VR3A5L3pXcHhFanR6VHlPRUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230038)(1800799022)(36860700011)(7416012)(82310400024)(376012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 08:02:58.4238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd9f303-a638-44a4-8784-08dc95b664b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931

On Tue, 25 Jun 2024 11:29:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.7-rc1-g681fedcb9fc6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
