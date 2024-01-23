Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023463105
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024526; cv=fail; b=jdv2caeHw+/kVCJ4HrfmQatBvZZjE8r8slvknjWuDANDg7tdlVaMQQl9OeiwgHD05HVCIvKViNeNdcziXjd5o9IuWSvBDk3/c65eqp3UcVUPn4YbwY8kDWEuOVpYY8ZW165aaldPO9nsSYxRZP8bA9iqQfhAlskz5TGlbvSGOA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024526; c=relaxed/simple;
	bh=fSD+SNinuwVks/RjDR9MSRUNC8MstnBHoGwY5bz9v1w=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hlkDZDr2lM2aGac+mkodtXMuXd5WjCKIF3+zVxyVxG0yTRGZTtkf/yyDhqtE3IpvL8nujXrFj6PYrvtCSmOHepl5HeHxY7ihElcoh2IWFAao6RPR0aCW2iesqgpI4CEnS/+2rwxtIZpZTWHsSFvFd6bvSJh3fHRt0JYzZ22b8p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q9NnCN6w; arc=fail smtp.client-ip=40.107.102.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q9NnCN6w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV61A1+LSLxNfYFKhjEtWtBuJ6OG6YY/6/mPKA1OrGyULTu74EhnlJpjygRMbSnpwiOhoD4Z187F9iHrYAZXeZGdxukNtu5HaXFGpYcijSwswhcu1IcufNCqASqpaKdqZEwGb/R3M+ldVVfCY3R0+EVOc79QI7TGny9vKnWDqmzMTod40QgY0itB376KGFC+eEBoE9GldbZQBszuUJ7S/bDkkhz4asXPUZJYL9tFlzJYyOwIqd/bcYjW/Qf19/rCZmT3Dhc0oL4WfHN9g7V2FgSRZ1eYyQ5Y4zIax9WEZDi7kIzkc4oA8SrS+SDrvNnKQRzGIKcpoWF9QvFAbOT95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQVB24dC1oDP4A/woKDEeq38Z3U+lJT22jdzWBVtRuo=;
 b=HJtd5wDuFWj+0fMDn9omfiQTClL/kaL4Ma/kDlGhGw+q+3JGeU1T9IGYrt2pPhL3z9I6ncR0EN4feSGI23t7ur3AoDxLQ2ocgKnxHyHkW2tAKCUnmho37z/6YXhWHpPGEGp+fnpMkwtLxK5jocGuN4p7yI5XhfS6JMZk2QlwRycRUEpJ07LghbIx0kUYSTuFmsVnUQSYHtW+MrLe1TK4wlnN3y/zDqAJCFbtn+/Hbt6Mg2NKL6t5lyn/ItKI8wUV0lRDNkUV5pHgjP5Yytq+mS6ACWW+Fjj/9J/IDBnEMt/ZzHA5K5osy5zNpiU515HgTFBzTUJEOKUVyeqUMWnFEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQVB24dC1oDP4A/woKDEeq38Z3U+lJT22jdzWBVtRuo=;
 b=Q9NnCN6wVoBh/xL5pYKZYTs07BBe/6apYN1u01/mJ1H4n85u8sd0LULoTw2v+e8ebiDxDi6u7gHvlYa7E7RfnqucqWrQ7UyduNxqUAQP7EYK7263S4ohbzxZe7CyIie9JStCt3bIqy9H+/G8Opz0NFDmmzs4LkrAXKiPqx8OeoQtXcRod8a4yYHjcui0TNuU/gGHUR2/cOHegv3SRpGSsgI3iqzg28NIDlB81Zue8xzskHJUS/P8JwuTl16ZT3UsyZSb0u18/83+jAHi7CgrdQYsDDDxhyAmR9uBr0yHLgt9sDAdXpSmlhkGXmsBLfX9WJsNAefG4xW7zofMe/xLGw==
Received: from DM6PR11CA0046.namprd11.prod.outlook.com (2603:10b6:5:14c::23)
 by CY8PR12MB7436.namprd12.prod.outlook.com (2603:10b6:930:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 15:41:59 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:14c:cafe::7b) by DM6PR11CA0046.outlook.office365.com
 (2603:10b6:5:14c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34 via Frontend
 Transport; Tue, 23 Jan 2024 15:41:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.16 via Frontend Transport; Tue, 23 Jan 2024 15:41:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 23 Jan
 2024 07:41:44 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 23 Jan
 2024 07:41:44 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 23 Jan 2024 07:41:43 -0800
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
Subject: Re: [PATCH 6.1 000/417] 6.1.75-rc1 review
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <137ef2ea-1c75-427b-a81d-fa62977a915e@rnnvmail204.nvidia.com>
Date: Tue, 23 Jan 2024 07:41:43 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|CY8PR12MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: afcc9a32-e26d-46b6-35af-08dc1c29d684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WZ+jxCrOTA8K/wxUh6ULCZvrueI74e8BiONtckzYhfuCabNrFVR+snYr5VslHED/k2NdTxKUbkMlQ09a7pL8KHiFTxdhKpt2PZVQupnqu+0Zu8dQQ5hTxZP4TukSd1+dJXRYZsc/Hs/jywzXCAxqljFrXcvQ6rf+dnz/flCFFdPjhqM/NX2O1e/lmo20+uidMG3hUXVoYh5JdqaPPXzS7DuCAxxfnz+PagQkDSAcTc1cWuJaj4kjUtUhOkcd02Blf4i0ffmLkKCx1qF8vZNtaco227zk8weP/YQfgSTFVNNFVIpPw4mBNVRGu1PXSpjDYFM6imrknAgt94TPlgBHjXySDCl6C/1VgTMYWWkkTesu9NOdPJBg71LvK9hHPatLyO5hs8a2DjfvMO4vwuRcZLnY/p43RSy80ph3jFuGL/OsUJQbQu/qTUCUVHwPB5PnLhSf5My0uXqd1IkrHdtVItwdVfPo7pdX1k4pVWXEPnLKpLdqkQn/2pQ8syKaOBNIDI+lQkKo8o09OvUJ3F56pYwRtHtWt/Dkpd/iVOzWxJjjpBoTjFWLPWH6ihuGsbGLRe3WwDuUjdozT61er8hQYbTej1X8DQCQQXhRCAL9BvtzmKjqjisiRCZf74V6rkjSQRlHpssL4pb/8d06TkwmHMhHXnKv/iOqE+XJcapidtZaRim9IXE9U5P0PG09dO/sPQtakGgu4MRks70/bRryglo3cog4lC5Bs+FtBuNUgqmY3c2AES57wU8/Cm2OgGViW7QGM87d+LmZy/cPLV9ZRKf8kSW9LQLUcETU0/obMfQ=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(451199024)(186009)(1800799012)(82310400011)(64100799003)(36840700001)(40470700004)(46966006)(8936002)(70586007)(70206006)(8676002)(2906002)(36860700001)(7416002)(54906003)(47076005)(6916009)(5660300002)(316002)(41300700001)(356005)(31686004)(83380400001)(4326008)(82740400003)(966005)(7636003)(426003)(478600001)(336012)(26005)(40460700003)(40480700001)(31696002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 15:41:59.6587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afcc9a32-e26d-46b6-35af-08dc1c29d684
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7436

On Mon, 22 Jan 2024 15:52:48 -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.75 release.
> There are 417 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.75-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	26 pass, 2 fail
    96 tests:	96 pass, 0 fail

Linux version:	6.1.75-rc1-gb74a57f4a549
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra210-p2371-2180

Jon
