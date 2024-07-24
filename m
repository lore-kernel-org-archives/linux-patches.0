Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1CD3D97A
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721806564; cv=fail; b=jwhqk+gX4zNtE1SZygfr4XM7tavppWeWaY+ln9qyBqiTi5/7xB8FCaxYracCXlvxMLA/5ZXFqNatLGSRC6SaIrvsJXFQBYAa51Vi94cD6ZFwLHH9ql1Xw29BY480lf+x95PRHzohSR9F1loJ9yy/wRHhUJoxAIZJzdyM3SQDXUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721806564; c=relaxed/simple;
	bh=EXYWGfeaKIb+k8TUGl+DxdjBD0ZNtB64YhuH+N6gezQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Hl/rNgNZBN44U5k+MfcEYplWmYnvHTIy03gAqx1W6PzYBJx/KtkId/17fMGcDENMvHStNEWqqX9JVy7fLmXjc0UddbnF8xvort21xfUDEFXvbfd82qdpYZbvjs5mAOt38XjWcdWJohw8QBKqIrFSQV5QjyJraV2O4jdOtCt2JJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s/fybxDN; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s/fybxDN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwbC9jppomhKhAvkitvztmPYUrb6XoIII8bQs2gKL2it7d+qlSx1Eh29akpwpQz/BA02y9opUuGlB5Faff0jLoB3GHJiaoZzH58KEVQNQvS5DByLUTvAUmJ3FQuFfVbD86+Oca6/1PzLSQcBKmX3zra4A+GhrpwQBVrR/wHnmvkjJ0CUDwE/Mim9Jp18t+QU15e+HBDOYZTFA+64iPonH01p05zox8z/No6dexEa3n+37IxmMRnxAR5SUVogdmQwMRjUjnMgKp6ACnIauhA0165z1io6svMRt/n0kmqM4Z1uib1kt+vOPbofVRVZUdizY0FoUCrcA5g5Gf4dvpEfNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZWkf0xUDF14VnkFO8bIzIz8uh84eLrvDt6Mh2M4wco=;
 b=JP8qS2ZeczG3BE2Vttb7tCGOckNEkx6fEYy13l4ntsGtJJnbTL19sCNiSZC++CDbZS9pYIDkmPxreu++1vnIp7ngvjFyPtp9+c5syVunUWFaw6uPQDfdXtQqYqb7/UuWtd+uvAZyzU1mA227fm74fzvJQLWh535G8noA1VaV+ONUXnHoik3bTxR525dCgDD+hOvrR3tkOwjQi/bv3H8IpWMpZgPdRYuBcltfmkc+F9XUSxx2scQrwNWyfCcxqWg1c7ChX0J+JqP36wmstcdH7DVoDhm0QBSqQZxl1ztQMo/zqYxByZ7Zmgw632VK1FdwOiH5yl1vYAV4tpruxAgr9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZWkf0xUDF14VnkFO8bIzIz8uh84eLrvDt6Mh2M4wco=;
 b=s/fybxDNmjnE75aXX0wbSJTDpvPYgOwAahq5UPlxJiCMAQOXN3hpO2iteo0Aat7+nxO2dEUcCycpOil+SgkjJX/ZWShIQkDolypv+YGFp7R1XKDxXXy0JR1LADfNm3n/NnXjHCfixKdqRkCpp8naHvX6b0Xf/T08mcsk38wuaqNkIIUQz/QELrZf4OqM5wRlc1WOYTd3fMg2W7I1bIduKTDO7QJeHOVtTT4Z4+7/25Mt47Dx72cawaAJv8lw1d3IT0yeUVDWy9dX7VkBc4SG/hcTU6VuXzihRspO/tpgypzOAh0Ax5CErLf1Rh65dXIwjFKtEPF9BP35AXhs16EbZw==
Received: from BYAPR11CA0078.namprd11.prod.outlook.com (2603:10b6:a03:f4::19)
 by DM4PR12MB6064.namprd12.prod.outlook.com (2603:10b6:8:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.30; Wed, 24 Jul
 2024 07:36:00 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:f4:cafe::96) by BYAPR11CA0078.outlook.office365.com
 (2603:10b6:a03:f4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28 via Frontend
 Transport; Wed, 24 Jul 2024 07:35:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Wed, 24 Jul 2024 07:35:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:35:45 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:35:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 24 Jul 2024 00:35:44 -0700
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
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c7a8770b-8104-4017-a3b7-296b6f02ad20@rnnvmail201.nvidia.com>
Date: Wed, 24 Jul 2024 00:35:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|DM4PR12MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 728fee6a-25fd-4046-2362-08dcabb3434a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVBIR2RTK3I0MDIvZlNoeFpLZFA5UkdXckNuclpwcys1ZGZ3MWIxanhOdnRs?=
 =?utf-8?B?U3ZJMnpLZVh2TWhjaEwvV0plM0RhcUFBSE83Vi9rSitoS1g0M3NBbTdsZkZU?=
 =?utf-8?B?TnpyeGNLdnFaeDJKR0JKenlXbG1TRGNCVDhVS1FUVFlPQktoa0RVLzhSYkxa?=
 =?utf-8?B?cmVJbmJUeDFIc1lyUUpvS3RSSWJJRHJpYW5HSThKWkNXTWUwek1vTXJIdW1I?=
 =?utf-8?B?bnBrZFZ2RnpmL0RDanN6ZVhLL3dkLzhGT08zQWNuM2IwRnlqdENqVzUxN09Q?=
 =?utf-8?B?NWRwQW5Yb2NyTXZId0E5Yy9pWnY2bFVNcVZzd2YwTHJ4QkFmY1ZzYVdzb1ZG?=
 =?utf-8?B?cng0STB0SmdPYmFYSkpkMmpmdDNrRHdGMkRVTkQzbldBSkRrYmhMeXpFSFlv?=
 =?utf-8?B?ZndKbFIxckpLWFVBK0hkNlBGQUhJNXMzYmxhNUU3YmQ5Z01pK29Pd1ZHU0xS?=
 =?utf-8?B?dWgwTTE4T0FuWkF4NGlNd2dYYVJBM0ZhUnlZOWVZR3RIWDVHc0tuRkxVL0xB?=
 =?utf-8?B?S0RLeG9jYnpwY3l3dUErdmMxc3EyMnlsZDdUV2xzZEJ1RitQaUhZTDc0bEJr?=
 =?utf-8?B?R1FERFA0YVR1TUxUQWcrMzdPYzNqaWwwMjRWdVJHNFIzeGVVNWhpUTB0Y09w?=
 =?utf-8?B?Z3lwaHJsc2k3QVdyM3FPdlZyWWFZdzQzRkp6SUlWRG9LYXpmcjFRdXZScUly?=
 =?utf-8?B?QkR2UTVPVFlqODBzenFORUdhUm1COE1lbTlnYmxaSFpWK1JmcytDOFkvSlNP?=
 =?utf-8?B?QVgzSWZnWWl5b3duVDl3d3h3bGxrT3VpN2JIT2J5T2hxSGFnZXc1UlgveWdR?=
 =?utf-8?B?cVZqT2p5eTJmNURMeUhDU2tkSE54ay9aQklNMVF3amY2SGhvdkRLK0EyS0cv?=
 =?utf-8?B?TWZDaEczUVp0dEY2QTg4dkJpUFdpekkxYnBLU2w3Y0Jrd2NZVzlETW5QYVI4?=
 =?utf-8?B?dmNzVEVhVGdTZkY0N2p3KzVZaUF4d1QrV3RSQzYwVHNFKzBITWpYbW9pUUFI?=
 =?utf-8?B?Vm9rcXl3dk9VZ3hGa0dyc3VFbEdwdDdQRFNDSlp0NGNGK2ZlNXRwRU5NNVdz?=
 =?utf-8?B?VHF1djJZUi9KcTVNNlFOeXFrRTB3R1d2dHRobzFTZDFxQlRnOVBRejMxSTFD?=
 =?utf-8?B?Uk16aG1RVEVGSnJCWERoWC82Y1MvaGtFVnMxQlpGU21aNlJXTDFsdHdRdDdF?=
 =?utf-8?B?LzJJbUJuOVRaZXNiWVgwRnFxZHhiQ1FhRnFNU1dxM2N6MGVUeTBaMm5rTmRm?=
 =?utf-8?B?RUpFUEZpbjNhVXlqbWdoaWhyNHVkSFFsS2ZiYjZONGp1R0d3Tyt1QXpLcFpO?=
 =?utf-8?B?cFpiQTFuRFdlUUVPblZXdy9ERVJqMC9EQmdWVFZHNDhYeTcrZ0FuYzBRVXdy?=
 =?utf-8?B?VzNBTVJWaVFLR3NKTm5ackwwOGpHRUxpUzdVTUo5OG9SRVM4Mzc0T0s4VTZH?=
 =?utf-8?B?SGRNWm5naFJwOHY2Z1VVOVlBaE1FSjdMdVJYWXlNVlNKcU4vbDIwMHJDY0gx?=
 =?utf-8?B?TEJJR3lXaUhrLzBHSlBSa2JQVkFmZlVyNStNL2R1S05UazVIUEJSOW4rQy9V?=
 =?utf-8?B?eCtDNTZpYUFULzVadk54SUlINTloZkkxZ1hPV0dSS1VVTWNCWDFodi96d01l?=
 =?utf-8?B?YUNNL1NoMGxWdEloa1I5cWRpaWxETUdqWDBtWXpNT20vdnZ1eGgrV05idjRn?=
 =?utf-8?B?amxnd1lnQXJMRnhYbTN1eG0rdjlrTVdYdm4xUkdvOWxua21yd2g2ZnA4K3Bm?=
 =?utf-8?B?NFhWZmpROFRLN1p5dE9HZ1pGd0JRUkRINHRQRmQ2TGdCcGovVnhFQjBxNmIv?=
 =?utf-8?B?RDAwOWRXM0lURFJRTlZ2MWw1Qm9kV0l4ZUdSYkxjRWMweCtac25VdHNVWmtq?=
 =?utf-8?B?UE1KeFJWYW96SkI3cTR1T3VMN3VDOEgxdU9yQzhVK2YrUTNvNGt5bWhVcWk2?=
 =?utf-8?Q?wNP+ZZTjykeE4MZOKokCqm3wJnajJwMg?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 07:35:59.4633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 728fee6a-25fd-4046-2362-08dcabb3434a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6064

On Tue, 23 Jul 2024 20:22:09 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:01:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.11-rc1.gz
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

Linux version:	6.9.11-rc1-gebb35f61e5d3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
