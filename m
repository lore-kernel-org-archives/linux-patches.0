Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010023.outbound.protection.outlook.com [52.101.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54DB374168
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 11:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562622; cv=fail; b=XsyM61WVhU/WnryInyikiZF9d4DXKvpP+2mwaQcCQavPzMN1/0H+3Azj+NyKhHqynIl+vOCFczaCOR6J1lCN/SW2//U+uegcP5cONx/t220ui3YKbdUg/JGLljh6V5uqPTIT/uLwI7sWv2brQXApVY5k3BULhKnaWAiHolK8Cv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562622; c=relaxed/simple;
	bh=iT8+784B5SXxWeZ9XSBAfo7QgCTFEO0nQUfz6ROZlVU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Y14kOHEDnxJ2xDh4nzM5td/9wDj49B5JmZKKplGFvg+8S9yQyeN/bTHxKSRqGW//ezkjI/2fsle1dVn7GBO3A/g4SEDQ6dSiM7ZlfFIBfEfK5kO2vBMO0jXneAwanTtRehncUdr0GReo7P5/0elleFo71K+oH07ZAO0n7u5GRD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jx5imaXR; arc=fail smtp.client-ip=52.101.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jx5imaXR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wI8neenUA3wCYUoWNqdHspBoKHeGIZ7QhH1+sJkpLOUDAxLZ6VTfimoMCY1Lat2bc/mvXHUOa8R79zRgNm8qJqfU6Y6XE50Kb7fOZj/WDH6w3kPi735VVEvYp9DxkyYAxLKDphZlxrTLsEfD5LuPsajP6amuh4M+rHmZNlfbTmafMAZFdOZ9ozBufNE73w1hpZXzyxtlJg1m8ai2K/MhCYmXEElD9S51JgQfACU3dmGGZZ0BWF7H9iHYEJ+4+AUgqF/HjX7V0JwAiaQEnwwkF8vKrFOXXuNBsHFX8wmwXACYEj3cgi9MeKYIaX4DL9zhfRq8up4nWTJtUdTmtgTajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FPuyrUm6DsYIljbJCp3puKV15yE/AJYD5LkP+pPpgo=;
 b=FJOUyFqQ2RX/Tfx6AG0TYzzLcigbNfvUCDvGQNs1DT/GtL3d6aO8/28Wap1CRRE9eI5cBz5PCkS/mvIbupAIh0G1VyHZh3xpXSLVUArixlXrOZIZ3aZMZtLBSYJzWuauZC4jGT7mrJ1pH5+lAtPgTQpSXBffw5n5yyh7y61PUGyvbajDcjRWyxaIhMBVJez16ETBHLsT7lfkmCa6rVtEYbiYHCP3bvAC1+IOVd+MlWDtmUiUrIGEVvwxrfSRBZV6HmBt/ma6jRV8iRZOzcunE/kEiMP0CnrvXDuIyNGr5wIx54SVwOJWDHqtjfvoaAORFhqvDZU95JlMrhr4PT70rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FPuyrUm6DsYIljbJCp3puKV15yE/AJYD5LkP+pPpgo=;
 b=jx5imaXReNldkJYHTxiOtPIHLOmM/szsWYHcQB1LJkqU2FcmS6rzoe7a6szwso7vsThDphN7B+Pit4CeimAvpShB9Uv1rFpkuA8wO7syBgSebPrP/BCotVn5Y8gTdpHZ25bAUo5sRzjjN8kOuRBmmpQOB5Iu8jK49OS1lmfp1elsmV2O6zxvgu/RKmu1fIOzdnKdqC0XapdubDPk9ge3ZiFD7kNp2SRTBSfK44SYgyTEjUPXb+cvIU/AFX4U+v7cKi3iyHekg2zBwRNnmFKBF5+65bslWq3Ed7wU5HjFn+FjN4248YqoHnpDkAaV/YtM+r141rP79Jx2jAz4RYk7Eg==
Received: from BN0PR04CA0069.namprd04.prod.outlook.com (2603:10b6:408:ea::14)
 by BL4PR12MB9483.namprd12.prod.outlook.com (2603:10b6:208:590::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 11:23:33 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::b5) by BN0PR04CA0069.outlook.office365.com
 (2603:10b6:408:ea::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 11:23:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 11:23:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 03:23:21 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 03:23:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 03:23:20 -0800
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
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <85fc3d9f-2456-4e12-bbc0-5a31d9a85684@rnnvmail204.nvidia.com>
Date: Fri, 16 Jan 2026 03:23:20 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|BL4PR12MB9483:EE_
X-MS-Office365-Filtering-Correlation-Id: 2957ca22-0421-49cb-0713-08de54f1af1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RStUbG5NOW8rTEs4MHV0OXA1U1ppa3dqUlZYbnNVT2JyNThDdFpYVHJHbG1G?=
 =?utf-8?B?ckRraTBWSDJTb2JtK3J3ejNPVGFtNDYrWTRESFlWQS92OTF2R0RyNXZDeWhy?=
 =?utf-8?B?c3NPaDBZRFgyL09ZV3JvWnAxVmJpdTlXdXNzeEdRdnRuL0FKMjdlR1FWVWpR?=
 =?utf-8?B?VFRXV1ZHYzVHMnhqdlhCcFFjVlZiSWprQnV2b284eHZmVTF3YWl1RjFWT2RM?=
 =?utf-8?B?dFRuRGRUb3N0TzdsTUw1ZFdQZGhLYVdscnloNHJZNXptSGV4NTFkWDVLZXNl?=
 =?utf-8?B?MS9HZ244eUxZa0F6bXQ3UDl4bHZXSmJkT0xKNlBoVDY3S05IbGlDY2QxZGZz?=
 =?utf-8?B?NkNXempucXdYZm5MUXF0eEVDb00xTUJ6dG5qSTFPbDVNTnM2NzNWZTl5ZndG?=
 =?utf-8?B?blB3bkJrcjVpRmdla00vcmczV3YxVUVqWWxjMC9scFpnc1RxSHp0MG9aZjYz?=
 =?utf-8?B?TVRGeFlOSlBMM1ZoanplTjBkMVFSY1puRHlCWmIwRW0yQ3NzMys4d2JoaE5i?=
 =?utf-8?B?bW9vUXlPeEVmNDUrdWtLV1JJR2YvcmJrMUl0MUFuKzZrT2ZxU2tqd3d3TTZP?=
 =?utf-8?B?UUVScTVFQ1RIK2J5Ui9XbUlRTGFwMGhFd0kzaFIweWd4YTNHa3h3UXlGMHFY?=
 =?utf-8?B?eUp2anhxeDE1VHdFY29SUE9vRnNheFlwdWUvNVF3VWRyU0ZQOElLeHo5YzVv?=
 =?utf-8?B?Y2JEbG9iWmZRTjZNUXV2VXFwWHQzbmozSkZqS2pNTGdVcEVybTd4VUZwK1dQ?=
 =?utf-8?B?NEFyS3ptN3lud29NWmxpOVVNdy9TU1VtYkxwdUZmM0w0ZTBFTHpnMFNLbjNQ?=
 =?utf-8?B?TVhvT1VRbXUvTjhhS3pNd0JYWkdJTHE4bk9tZmdCR2ZXalVMb1RhQnE4RWdy?=
 =?utf-8?B?QjFBSVljRU04OUpTSU1JR0RCME1vWTlrZUs3aEk0US9aa1NqTHdYaVZ1dkxH?=
 =?utf-8?B?d2h6dmV6Mmp5bC83T0FTK09LYTQvcitDOGlQTEs2cFJKZ3M1LzVXT1lzc3N2?=
 =?utf-8?B?eS9Fd3VpallzYllyNnhjQVJjTkloVjZIVlBISUgzZHZDRWlLTUF6RmtnQlRT?=
 =?utf-8?B?QU9QUnJKSGpZUnR6eXlGZGN5MDA0U0RmUUZvUEVjaE1GTVRQVDI5WUNyOG9B?=
 =?utf-8?B?R2tiU3NMVFF0Y0RLc21UbnJFM3hsemYxMGt2SGRSdTFTdXY3RktnZXczNzhz?=
 =?utf-8?B?TFBrTW9kTXA5OCt6Si9IUzZjSTB5bFMvQ2YxdGEwQ3dzUW1rVG0rZkE1aFhn?=
 =?utf-8?B?eUthRk9TSkg3NGFsME8zajZEUitRa2hrUGVteGZqUCtHa0FHN0diT0dqZUZy?=
 =?utf-8?B?d0dNWWZxUmZEbytSSDd4cndPNFJpZW9GRkVzdm0zY2o2UHJjYjV2aGRMUFdk?=
 =?utf-8?B?WXlqZllmeWoxckdkRGJQQ1BkdEZ6S2pnb0pjdXFiS2c2ckJhamdaWHd4dW0y?=
 =?utf-8?B?QUR3OW4rNzRwaVc5UnBuWldaYlYwanhxWXBrczZQR2tuNTd2Qm9vcVNlWnRh?=
 =?utf-8?B?cXRTUzRUOWZNUTl4WEZTbVQzRVo4TFJrYU51K21pZTErZ01CTjV3M0JMWnBP?=
 =?utf-8?B?Rkg4YlIrYVM5UmJha1lyVkkveVpsOVptTS9LejB1Q29lVG43Y0VVVmZHRURz?=
 =?utf-8?B?YkwzQzRVeDZlZXFVcCs4b0lyN3R0ME1zZWo1MzJUMWEvSkt2OEJHVkFaNEdF?=
 =?utf-8?B?VHRxdmt6MnVHdjVqUVVNRVRHd0I5L0R0M2ZCQ2huc2J0TWdIdVA5YTRNaFc0?=
 =?utf-8?B?TmY2dHp5c1MzTUxsRnFpSVZ4V0xUb1BpNUt3OVFzalFuVEFpdEtUdGJGRk5n?=
 =?utf-8?B?Y2liNm5yQ3cxb2N5RnNnYnFST2RYYjQzWmlBaXIwcUw4QnFncmNJWldMbDhY?=
 =?utf-8?B?RjdlSEVLd2VNK2JFY2IyaEVkdS9TcnZYQ0VEbVJHWGxwVnljc2UvWFM5Z2Nu?=
 =?utf-8?B?cEhnY1VxRVVIcFV0dHEyU2VFem1jdzRaZDFYazY0eXF3bkg5dm1Fakc3WHV0?=
 =?utf-8?B?TEcyN1FGb3lYWUtTcXViQkhwVFlGSDJCZXdneGtWUnNCR2Rsa0o1ejRmOWtJ?=
 =?utf-8?B?Z2NiQStxRFFYNEFZYjUyMmxzaSt2OGZaZWFNcDAwYkNUWFk2OHhOeVpMeUpH?=
 =?utf-8?B?NEkxQkN3anBRd1dIT1pZMlVQcmFpMnVHbmV2eGM3UHZYaDhqdHJHTnprMVJ2?=
 =?utf-8?B?ZjEzSTAzQmVyNlo2ZDNOWE9WRmhtbk53ZXpMR2hSQnQ4MFBxM29YN0dCdCtv?=
 =?utf-8?B?QmpnR05qd3huRlZzb2NHaWhTQlhRPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:23:33.2843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2957ca22-0421-49cb-0713-08de54f1af1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9483

On Thu, 15 Jan 2026 17:45:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.18.6-rc1-g486e59ed73a6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
