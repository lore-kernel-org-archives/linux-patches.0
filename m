Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7FF2F3634
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660871; cv=fail; b=WeOrX/OSKYutW62DBDJxmAbq7Iaf/xlaQZzF3nY/UsWi+LxDRwAKeC6B2+6+yN9OO3NFleEY5ElOWya2pKsTvT/c1U2jJsrOl2CbZG5ebWMjv+OmHfmkerolIUoJeJSEAutmxVUuR0oqgPdA7rVq6TYgsop0BLXykShf04TxAnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660871; c=relaxed/simple;
	bh=fjp3ivY+3gSav1V8h/c05c0S6NR8uy7lnH5wRM6hh5s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lNGshgsZVko74M2MpZjCNzSS2rEB3fIZ0SrcxHpqSJsu5d854Fv3LvVMN4xNWjRzWCtZ+J8TS2tbf5OhSPp+r61B3F+UFaKk2bfuhjUEKJyC+aAke0yEia3f+bFBc0SEN3o+jU4LRJ+8sTv6vNuKb+udp5BRq2RYJ1IRy/ZakOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fAvcpizw; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fAvcpizw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISMSqN74yIXxXxxx6H7PnkzkVOQD38lV4dp/c6GOAsGAzKVSl0qhFVh7L7vo7INexxTDrPPRYN6PKH1Sfe0M4T1Avr54c4MG2rJm3tmuElT5BDQtT39o+pyKV5XsCCdNnfIeS7RQ2kR0Oa3qpvBKBS3E8PYfz086OysT9s4g78J1BmtlpgBhwmFipSDUvzfc3U3qdm2cS6/uGFfsktQW0xMw/esXjcYFviYurQMtIFGgHlBVKph5sw2CoGxw6zckBFeyQop6Evo0lkSkYQfSmMFU9046f7vLHFclrXT2yNnBdW+pPxcemTQASV/8VMv7d+WxHQ84H8GZken3UKA74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fzi83jcvL9yl9JKGXGlN8DU4K+sENnZ57jKaZUqKZ1A=;
 b=EyXyaTv3MI6yH6WBCI1xrNCoA44/w07MGmQnN38Eoh+XAS1Ejn3knT0W6EOteqmK71/NDbeENGWlyWqBrzN3OOU1Rx2IAWklNcZmtkHM8d4ql+LBjom3KoJvRZUovd0/PLqaoxEh8oV8CXjBdsYNOk1b3vZcYsWBTBRwGMjoqaWoxS1FK56acpD808M5IXIqEj2tp5uRlVY0OVrQMERrS8caA429nTs9TZR1cghHHdCWicr+ANhWkWkpznDezFltQkZf6gqq1CyzP9FammzugdgiBXxwK8aQ4ZCBpBdU0Z7xrk/sy8F3xKoBmebwCVrqmEi1xLM7IzQiu7LeeZmKHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fzi83jcvL9yl9JKGXGlN8DU4K+sENnZ57jKaZUqKZ1A=;
 b=fAvcpizw7XaVKTNSnmvnndGgkWPDCu3SsjEl6VFYhmxsZ9z6odv2sl4HoS4LoGYOa7rj/skN21H/WyJbLSN/+mv9XA+HgKRp0pWK5Oa1DilXxcBGx2Pn7KBQ3y5yUC8dxGqNYxQijyBfwVa/3SPBbQ38jS4ds0qItXYtpMn+8YlQHUKnsZ49X3ROLquoBtU+V9zTBNwico4r9F6sy+U4d/+OX+QEfUGHTXs9d2bLHTUMMep86HfKAiYgvFYOTcmfGDsrveN11O5ZK8xVaA0WhjTyuCZxZevjdeKAhBg8CamsJhJbRYeyGUYK3dWFg5W+nEximTnRwhjP7ZnSTfWOWQ==
Received: from MW4P223CA0017.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::22)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Wed, 16 Jul
 2025 10:14:26 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:303:80:cafe::8a) by MW4P223CA0017.outlook.office365.com
 (2603:10b6:303:80::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Wed,
 16 Jul 2025 10:14:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:14:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:14:11 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:14:10 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:14:10 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
References: <20250715163541.635746149@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <604a546e-196a-46c7-967a-95bcf08af705@rnnvmail201.nvidia.com>
Date: Wed, 16 Jul 2025 03:14:10 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b44024-1a53-494c-6e55-08ddc4518b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDN2TWxnT0hMakVIZytSQllOanMvWkJCalBBeWpLcVd6S1JpUFFCQmd2MmZY?=
 =?utf-8?B?Y1o5QXA1TUgvRlM3Sk40T0hGQTRpNVNraXpEU0xpRzRJTldLY0J3YXNLRnZx?=
 =?utf-8?B?ZFNkdC9kYUxwSXEwd1lHRG5GdWZWT3hIaWRQME9FWkhrcExRd3o5alk0T0gy?=
 =?utf-8?B?K09Dcnc2S28yOXIyYmJaSXg2SVF4SU8zWTdLNVdxWEZsc0hBS1V3WncybnZS?=
 =?utf-8?B?OS8wSUNSQTlTa3Y1Wkt1dzB5ZmtSNVNVRkg1TGRHWWF6d2FrYVVCeWJpQW9B?=
 =?utf-8?B?alc2RXk3MVhwOTdham94SERrb0Jud0xhS2V5RHd0MXM5RzZHM0sraVJBczJC?=
 =?utf-8?B?L0RJUUo4T1Rrc0MvSjI2RzJRTmlFdWJWTFZjdWVtRWJFUGxpL2pHQlliV3hR?=
 =?utf-8?B?M0VuODZkeWppdk9IOXdDWWwxSkFlOEtnb0RaVGp5d0ZwTVd1WHUzKzBTZnJ5?=
 =?utf-8?B?MFluaS8wamI2UGxTQWNWY21kTWIyVmcxTER2b2J0NWswQldKdWJ3a0hScW9X?=
 =?utf-8?B?RHgvdEJsMDZlbEdWV0NlNUdsRVFIeEdTaXk3ekQyUDFVMDVWSjNtRkpMRDRR?=
 =?utf-8?B?WHR6eEdSelZRZE1OdHlDbEJEQ1VsWWl2aWdyNUFDbnlsS3RBMDk5UDU5Q084?=
 =?utf-8?B?ano4L1VEQUJnbkRxT3lTdGQvRGFLYllrSUtWRkpqbHpKWjk1cDdVMXg2eVIv?=
 =?utf-8?B?TDlEdjRBQkw4MkNiajVneE9Wa3VQVURkMjFFUFkzOStFbXlJemFYcnJqcXdK?=
 =?utf-8?B?NDAzeVVJNG1FWk91OUovK1ZENHVHOXRadkxRL21adnBveHlxNjVoMDJlMzBF?=
 =?utf-8?B?ajduNmpkV05FUTdGbk42cmJ6MURKM09sSUJsSXNSVTFwTkxWUkFzL2YybHZC?=
 =?utf-8?B?TGY5aTloTmg4eDc0NGFMM2hMS3RqODIyU2RKUFc1bkRVRXBaclhVWktIallX?=
 =?utf-8?B?cWxiKzdRSDBJUEt3d2dJOGg0Ri9OWUhLaFBsSnhjVTNhNm5aYkhmTmF2SHVV?=
 =?utf-8?B?cFNVdTNTaW9ZRUk5WnVaU2l6SytpR2wxM2F2NjlWYjZjWGtadm1HNWRzVkpi?=
 =?utf-8?B?YUpwNjRVcUNxS2poK0k4N0dnTEg5K3lmaTcxM1hBcVJ2MWNkOG1KbVhVdm9U?=
 =?utf-8?B?RFFjc0JEQ0R1VWFpc2R3RHNSWWcrNTZpNEdadUg1NW9yendvUStBVzAzNmhn?=
 =?utf-8?B?Ti8zcWFFY1ZKcm9DaVU1ekFxcFI4ekZrQklHSVNQRlpxWGh6T0g5Y1Z0cnll?=
 =?utf-8?B?c1A3RHM2MXprYXM0ZTZvQzh5SVpiZVVNMHVyYXo1K251OVUxQXpFZHBrMVQy?=
 =?utf-8?B?dFRNOEMwRVUyWW0vbjNvLzhtek5TQnN2SUY1SGFKL0hVQXd3eXM2Z3ZON01x?=
 =?utf-8?B?SStUU0FqZGdVdGMzclNlb3lMWVptNW9EU1dOY1RqZWJaTWJ0MHV4U2FraHBp?=
 =?utf-8?B?UCswU1YxSmJjSWIxR3hlYUVrMU0xVE9hWElkb2tsSGxLc1NsS0pMTkJ2RTVw?=
 =?utf-8?B?blh0R0h1d3ErRk5xSThqMHBhUXYyZCtFZkYvM1hSWjFYemJUajl0TG9LTW1y?=
 =?utf-8?B?TldmWDVxK3IwMWJRbUZSVm91QWhZd3p3cFY3MG8xaS90NERncXl0bFNSR21k?=
 =?utf-8?B?bG90WjVDcy9lR3FYWWUza1N4eUtMOGhwaEhLWmN2dFkzcXdldU5PSUxlYkhN?=
 =?utf-8?B?SlNVc29yQk9YTXVqaG9TcGE2R25LTFNZMjlyVk53dU4yQUtFaG1LNGI4aUpN?=
 =?utf-8?B?T29xU1FNMW9EcGFPWnFhSVF3cmZFcktlbERHdlhycEkzb3l2SGpzTDZwVzdF?=
 =?utf-8?B?SEI4eWJNN0krRmVIakZUWHNUbTExOVN5OXppcURqbklJZmk1ZGdFT2pTcWxj?=
 =?utf-8?B?MG1KazR2Uytia2ZyM0JiME9sTmNJM1AzZDJkZ3Q2WU5hc1c2RW9QRmJ6eHVo?=
 =?utf-8?B?SUhDcGdlMXBNbU96SEtsSzVNZStCYWdCM0ZETE9ZSEtWTmp0YllMOTZZd2VD?=
 =?utf-8?B?VDFpeG1RR3FETU5tREtpeDJwZEtqSS9naUlOV0w1b1A1bDhRcDNpOHQyRnpI?=
 =?utf-8?B?c1B2cmhYTGlIZm9uazBCd01NcnlYT3krNEw4UT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:14:25.9055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b44024-1a53-494c-6e55-08ddc4518b04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088

On Tue, 15 Jul 2025 18:37:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.146-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.146-rc2-g33f8361400e7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
