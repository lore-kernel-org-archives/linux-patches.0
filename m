Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F521FA6
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 11:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cV514MTd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0ZLuee+Swt9tvQVhL89zWeALbSLwePY8nBbaYaw/fpmPKzZE40QBMPII46r4w6rQaAeNaUeBUUequtqOzcEqHAf2pWV4fo6AFXd9WuZjeGX+ILQKMwCwZuS5tzgb/ScMkmZXhFhpA/eZlK31f7OK6EQ7t7D2Pjgw896ZmYv0tKGTPeQYM9oWslpwsvObJLd8u3x7nMSpJq/aWm0tlE/5+H1P1Wgmbnk7KjD/wa2rCTzZou7TFR/kELf+SNgsv2UjUxnsoOAfVwJ3J2nx0UDg0vMBR3b5qHE0hRoDriXOOnHPPHZ9D13kfuNMvSc/nP0u43jzHDkmZo1msCGfUNrlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HAunBpzE/P3yt14l9WU1rikHkkoPrAGF30s+829QxM=;
 b=ncHZEhyRHDEpaCaom3Khhy8pvD+onZfog5nuO6OboROXlWD8bnlfPxU5uNZsxBfvU/LZBdEjsOeK04y4PCsAgTNjMYiFmL3DXeGmyxyfG0ZI4ENsdNNi2o3j0WyxTm1bprgV1OO7EvQg34I/cbglba6pfuhKt1m2XqLQDAUpTje6kY6jz3LQu5RNp6HRSufjfxj4WxNmdNj8CrM29CJw0L+HOdS2R+Y7HO60OmhYrH+z2V4bVLoFNUHXaXFLj9ljiaAucPTgn2TZh1lSR62waMZlC4+ffkX+IlyJK/rBUnaHO+fSlqKkSILcsuJo80zyghXYR56dz7sP+EDBNIXrrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HAunBpzE/P3yt14l9WU1rikHkkoPrAGF30s+829QxM=;
 b=cV514MTd2uEp8W0/OIhtwFlZUIvYtBTYrSaAQbcj/AcWiWXOkjM9OPysKJtms+rJMFXTWoEl3dr8QlbTsJT1Qo02SHU/GHoUNgUXitKDmpDeZYxKe8f0vM1gbKvez9hM1auBedyWXIiU0ALXbSjgIufdUmM2z4bMDbgs98j/GkR0bqTMFYjx0b7MLKV0r71FxO44OCOSodjQ1vyhLuLPy0irlmLKQETeY1eo1m6QalA6XTT1Rc9npmi5gsAfuJAdlmQfq1grCaqnwB7e60j38tihi99Nk5qExZ7eOJcNJj+JFRIj7QPxHkb5ooxi1zbWo0Db752WqHq78djTEi4NLg==
Received: from PH0PR07CA0037.namprd07.prod.outlook.com (2603:10b6:510:e::12)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 11:43:19 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:510:e:cafe::fb) by PH0PR07CA0037.outlook.office365.com
 (2603:10b6:510:e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18 via Frontend
 Transport; Tue, 7 Nov 2023 11:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6977.16 via Frontend Transport; Tue, 7 Nov 2023 11:43:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 7 Nov 2023
 03:43:01 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 7 Nov 2023
 03:43:01 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Tue, 7 Nov 2023 03:43:01 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4edfecc8-cecb-4911-b263-f32bd3e18bb7@rnnvmail203.nvidia.com>
Date: Tue, 7 Nov 2023 03:43:01 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea36f1d-ce0a-4e59-b5b1-08dbdf86bcea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	81CpAOzFIGd23fKlXaoW0J/JLW7c8u4+L9D62F7/XHXmIK+MUKAbDqZ3hnawqyNUoXuNolNCLi5L5kYMohz5uW7euoKci0HK2QRX6JSxu8pzfwETZRraV1mzxSZ3Bo4+jl1VwEreJgLvirHcysJQYIJO3MCzAcsz0RKT5ef4Atk/KVHzLxwnWsQDfwTjFJ0dO5lOk7DSJwQ5TTUeMh98c9zAy6zcmvvCkn//Bgffw3JEPGgCW/++2TlWXz4agp3TMjbXvpleVoB48SoN2AAu54lQVEoW5rogoXen7fGkoRp49dmjKnnGRfi2HqTfdmtWwGkq3b3h5XS6RSsU7Tl1+lWO3Q36LGGT5s9H2h+gf0DpH0hbu1fNvTqaLk651hviMAXY4URQsnnaQSIbjXvpTy7NE/BNM4vVVinjdJekf6D+M6rLpGYsgkwjePm4c4j7uMb8qfm2+5AX8WOilLHo42Z0vHG+XdaePWjdfQdzvu87bzvUHqUlo6s5e+XCEvZCTkGICC+ESFSJDSRms7suLyZQt1rUf5K29s8HsCHmh7IYENXVSQlwZbOqf5AyNYvzeZKe+BLcqE7ZZ1XWRRpYIz9bmjL8Cyav5VIOMAjzqlqLAaLa4wuldCQiTy96x3LYr5LcEvQNvdhWRU40zin6PYQKsuHulukw+4LD1+gEOL/7MAE6ljlsud9+yh1o3rEuBnV3igUr3YgbkRPyHJHUdFgnrEvrWbEu9H3H/nUndjE0As0WnBjb9uhc3NaV6l35CDwqY43HPeiWOpCbrOEBK/lpOLef78PihAAQ6rqQ/aE=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(396003)(376002)(230922051799003)(82310400011)(1800799009)(64100799003)(186009)(451199024)(46966006)(40470700004)(36840700001)(966005)(478600001)(36860700001)(40460700003)(4326008)(7416002)(86362001)(5660300002)(31696002)(41300700001)(2906002)(70586007)(70206006)(54906003)(316002)(6916009)(8676002)(8936002)(356005)(7636003)(82740400003)(336012)(40480700001)(47076005)(426003)(26005)(31686004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 11:43:18.9761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea36f1d-ce0a-4e59-b5b1-08dbdf86bcea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274

On Mon, 06 Nov 2023 14:02:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.5:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    88 tests:	88 pass, 0 fail

Linux version:	6.5.11-rc1-g73d52afec3ab
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
