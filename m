Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F836357729
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 10:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559625; cv=fail; b=KXSWd0h7hh539WKtaprdawrVofKD/6KdiYzBYcjFTs41zJFgcqQ6coj8Sel8ftG4gJsracsFbBFBOuca2SkRv4bMxRpG1RjlEd9OltPQXw2z3b7cWj8nRlQEiCq73osWWZc+rSsM+pZt+vSX5VU4uIlXBFs4u4VU7Ja+sodE9mU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559625; c=relaxed/simple;
	bh=3P/fZTCEzF+U0e4YO1NxZ6gfXYL+y8TSoypU5KgzDBM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=shiN29CrOfh7+n3X4d1D6Rn4naIS4q4uq99TpnrgjBaX9mHRVAmA4U/dk5UNA4ZizthQMnvxMhcT38Ux3PC8s9ISk2aEDey9P3gJHRNHSnYKd1A5KNtRZDj5ZR8jNa6g6bITvbJa5GRnz/HaOBcqqteVEEpCH5e5oYSPqIZNbeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mL/bqVEU; arc=fail smtp.client-ip=52.101.46.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mL/bqVEU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xpr98ssdFNPNSmgW6bXkxZFFF0G21XAT4HgA20YhZuGaYj8M+HWyVUi8gdMqsDlVpe4uEmzk8TvB4oibOGCybIpnL6R1OX71x0vq2kLHYqf9CFQO2TBXwRPvywyVDPXrKSb8drlUI5zGd+v84hagBZERMrDffI0bNoZfT+gr/4QCZdkpXtwEX0y0MBJifpnd5FiI0zeDuY3RJgzxpqzaxALXoNEYt5qYbX8syBFv2x3bj/cI/QCHBuPRpEbtAGb4Q36TOBWfcm1LeFdfOHIRjNyQFQjevDk2QwJtflLARBVx4pI2dqcFNUyh8DwR2pBepUwUY3WNgKlQM4fFhlxJcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AH6UQkjVyiZEowvIn/SKM8yhV/fW67kTcXKVW/8Zp7o=;
 b=fGMrC2D+yneEUCRu6xiURvwx1O2zgAuMgY+rWHy4q0t0ZvepbxBT8ybFViQmoFCvpIAvnzzYCjCBaLE1Q1s+KhQWz9A8wb+sZeGlYNx+Ngd7e+dY9et6Jc+AgxwksgP03I/s+HZRmrJrVA5Jy5zLw9/rbpYHcCjf0QRkdBZaVGjFbOkIg0ybTJCWxB66+ZMrXzzHPZ5fB2t06AAyfFutQ0xPLcr3Oup5Y6S3ROSKd/00+0TsV1DYjjTBsVnj5PtkvhtUTOSsmCRUINOGsp5o/RcJqrV72/1asZVRLChbGpcMPzeePVUaWpUfKt2tvgO60Zka/cLu1CN0xRwwIR3dlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH6UQkjVyiZEowvIn/SKM8yhV/fW67kTcXKVW/8Zp7o=;
 b=mL/bqVEU1NG76BisEpYGVXFyHUQD/3in9DBW7EWp6vg1J3MSnzPMsNEj6cHlKi7wI7XOowCU+JNhM5l5ltsYzdqVLfU/jjE+ciNsgqxI90HzhF2fXbj0a1agVS+7R25Nh0FPTHUbcZ7HvAhP6nR88M/rK6W4oBi1aOggYjr9B0FqEeItzK42p2YerylNHLCsT4xCwWiTrYq5UTWjZP672iaNtbcTUKbdjoFwVQW3Fn0wKe/WNZR0FceEFlLursYW8KiC4qWwGxqhqIG3yF/H4IhOXxDKcY2EDR0ew6RrfH2xfvw8sh7zSnqv7L9faSmkE69s61F07MJbwmjDd8CU3Q==
Received: from SJ0PR05CA0132.namprd05.prod.outlook.com (2603:10b6:a03:33d::17)
 by MN2PR12MB4392.namprd12.prod.outlook.com (2603:10b6:208:264::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:33:40 +0000
Received: from CO1PEPF000044F5.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::12) by SJ0PR05CA0132.outlook.office365.com
 (2603:10b6:a03:33d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4 via Frontend Transport; Fri,
 16 Jan 2026 10:33:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F5.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 10:33:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:19 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 02:33:19 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 02:33:18 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <21a078a3-9d84-4230-9c7f-c4525307e3d1@rnnvmail203.nvidia.com>
Date: Fri, 16 Jan 2026 02:33:18 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F5:EE_|MN2PR12MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f656ba0-b8f8-4b6d-fb38-08de54eab686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?am5QYzZGUzR0dGxGN3dRS0Z1M3ord0VrOGd6ZDRmUGxKL0FXK3V2MkJweGJH?=
 =?utf-8?B?OXBTcTZHM0orNnpBZlhyY2l6RFFYMzFkek51Z0pMa0RFamRuQVFDRGFwVmpJ?=
 =?utf-8?B?UkN1NjNQNFVjeTF5dGxhWHlESWdvbG1kS1BnQmN5b3JCV0VibUtueGt4TDhq?=
 =?utf-8?B?SUdwSnZkc3U4c2NLRDNtQ2xsQ0lNdlJoK0xEcjZhb3FQV0p4TUt4VnpkSTRr?=
 =?utf-8?B?Wm8zQXRNcnhWN0J1YktvSy8xdVBTNmt5QWdzeGFJaERzdkp4V3BaWXcvU1FI?=
 =?utf-8?B?TnhBS0hzOTlGN3RUcHhHQWhrQnVObDcxYlgxTXE4ZTIvSEEvVENTUmpRdGVY?=
 =?utf-8?B?NFdpNk82eXp4UFVqUWdRZFdBcXJVTXVhemRxUWNIajFwakNGa2ZsV0IvNktZ?=
 =?utf-8?B?RDFQNm4zU1IxbCsyNFF2dENOMGsrRHJvazVlTk1GRTJQalFrdk15Rytvb0tX?=
 =?utf-8?B?R21VcTUxT3haNGFBWWYzMjFyZDlCd2UwT242bzd4QVJBWlh3UExBcElGQXBw?=
 =?utf-8?B?ZVVLalNCbitmTTJiWXhvRGJjZHhSa1BqRFB4emNFSUJKZ01vUW9CcDd3Q0Z3?=
 =?utf-8?B?QzZMVy9ac2pFT0RHMnBMUTdtNWtkQUtsNXlLK2ZwdkpVYVRtNGwzbFhmcHNU?=
 =?utf-8?B?S2FubVZHK2dZeFB3NEdBNkYrbzFaK1NXYWk1TW1KQUJuWDM2Vkw0R01sUnhX?=
 =?utf-8?B?ekd4OW5uSzhmU2xUekMrVW90ZXN1SmgxY3lQa2MrQ0tZVVU2bS8reWhaNHZI?=
 =?utf-8?B?R04zS3ZWWEVVTVA1eC9SekZsU2JIeFR1R3JFS1pEN3lhdXVYcXdRUjRPNktz?=
 =?utf-8?B?VVRCNk9GNUxJOUtTcDRSdkJ4N1BiaDFvanNIVUpWa2s5a0NaZW92TEpMUkU3?=
 =?utf-8?B?MEZyNFJNRDJ0MUtkVnhFUE0rNnVhdlRSUXNKeER0NUNkRFYvMnlPd0N3ZWtU?=
 =?utf-8?B?OHVEdXlPWWorOFpwNm4vbUlJamJvck5TTkxOaEIvem8yUU5LZERYRlIvYVhr?=
 =?utf-8?B?ZldwaDZlYkwvc1p3TXVxSWlIZE5nSFcxRzhSQnJrenRFMWtWVkVVajh1ZldX?=
 =?utf-8?B?VGtQdENLb1REQU5FUzFyS0VpRHE2TnlwdjZONms0UEhreWJObldvRnVHampx?=
 =?utf-8?B?UExuUko1UFRoRjd0cm9iaGM3djZ1dEt1bWsvVWhwVFFLcnRLWngwRmJNb3FD?=
 =?utf-8?B?YVhxUTUzN3BuNWJENzY4aXdBclFJLzJ4OVRVR1oyUkJoUjZWeFZ3NEhNb0g3?=
 =?utf-8?B?a2IvU2dvSHdidEtVWHFtQ0F1cUk4UGpmbnlNalBHSnNXVCszMEZTZDFzbEx2?=
 =?utf-8?B?a1N5NittZVNuS2tMTmptT2s2RG9IL2NMdHhub0ViL09UWllXUTFKL01KNDE1?=
 =?utf-8?B?bFVza3dxT2RiWGRkMHJTTC9FTDFyOHpTR2N5eHY1STVXSmc3WG00OGVweGg4?=
 =?utf-8?B?d3l1cTBXTnBhSW1OSnIvZWR3dnFkak4yTnBsUCtqQmFZNitiZnMyb3RzRHQy?=
 =?utf-8?B?WlY2U2padkNlTS9qKzNJTDhsU21HNzROanZqWVhZTmR3YzNOZHgvUHpwR2dS?=
 =?utf-8?B?eFk3b0dKcnFjNFRQd3RzbzMrZGJ2d2szaWVDU1VZUjRsV0dCSHBZOXdCMEFC?=
 =?utf-8?B?eWdzWjNONm5vTnZFbTdEWVh2RFU1eG9iWTV2NTdvakRDUmtCbXplVXM1Y3Zr?=
 =?utf-8?B?QjRVSVFnSmc4a0IvVk1YVjhXd2VaWVBLRDYxS2Z4V1Zha09sZ0YyaEpJbHRH?=
 =?utf-8?B?bUhWNjFmYWNzemdBMGN1ZVpJdFpjQ1QzYmZYZ1ZBRzd3R3hGanlGbnJaSWF0?=
 =?utf-8?B?djFueFJzWFdiOWdzbUVQNEV6bWlCNXV4OTZXRENNU1A5QTZ0SzExVDJWTUtR?=
 =?utf-8?B?dERlMStQVWcxL0NQNy9sY3ppVWlKRXUwUzh6NE9TQ3ZqWGcrSHF1bGo0U09h?=
 =?utf-8?B?QVlYYXlLOVp2YVJwRmJvOU0yTmdYeW5ncEJaUm9lMWhFTkFyZ3NtaE1uQW9o?=
 =?utf-8?B?cG10Z2tFY0VhcDdCcnB6NVRPbzFqNEVVV1FnWGoyejhFb0VHMm8vSVZ5MEJz?=
 =?utf-8?B?aHBOV0xaSUxoYmRyUCs5c1NWbTNxaUsxS0x4dHk3UE5GUnlIeVZFejlJN0t0?=
 =?utf-8?B?RVNVRmtydk5TWTJ5eUxHd1BYQjZHSlQ0Z1VpTnc2MklOcFJVaGlUWW1xR3Qr?=
 =?utf-8?B?ckQyMWJEOS9xR3B3aUVvbnFhMXRFQWFidnpYd2pTYmxsTzFEcmtPUWxMYWVj?=
 =?utf-8?B?QnM3SFhuTU5sT1d1VG83VUlqblJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:33:39.3551
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f656ba0-b8f8-4b6d-fb38-08de54eab686
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4392

On Thu, 15 Jan 2026 17:43:21 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.248-rc1-g48eff3b1f60c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
