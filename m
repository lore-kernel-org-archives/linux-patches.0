Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB52DAFA3
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309938; cv=fail; b=DI45x/yiQz4CVZzrMSy21E9UgogmOQ9J3P2zYT5iRl1O76axLXQCWmlobk4kgZT+v/xW2iJayqnj6pjn5L/LSpPOTcMM6upywJdykJLB8y+op+zMVmA1MWPjdmF7evBS+9ZWubQ1oYZaxUnxZyYgn6uiHkn6i4AlkiWME9AGpcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309938; c=relaxed/simple;
	bh=N6Pw2quToeeDOik5zqwfGA7CLgS62ry0X2cW0fDQh/I=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TVVFHr+32p8r/cmn+inVJT7e7pJQPEF97CVskPsSrL/Qnow+IjNdo5ulCLg9AZrTOsFWmWw4qiB+10npJk1XpopqQLaNYYeaZtr4keCGhjIZKFc5wwTxuh6Pv3MmNms9vaWNQYffZLcApyARSOUS6KYgGyfgR0z9CKf3UhB5nTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YGR7aXeY; arc=fail smtp.client-ip=52.101.62.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YGR7aXeY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7ovVVnCqm0aUIR4WgN7u6ePuSjYqYVvska8TO5iby+irixg/XeNpP4hc2gFlW/7927hRN/Z68qeWG4BxWevy2Ewt+dOZ+0mIKxTcpZtBLX+ZkgqifCsjftAbebWIti3skGlGow3hMEfls7pxbSMH9H/TGwVI1hAJHsryXnNQ7ASpgOzH5Q3lqvrpdUg+iQJP4LFmVWb4M6nt/ybl+/UDg67DHjYaxHBk2RJEAMBOKtHIbPxaVEtsFufIw7NfSa7tu4B3iXwRD9UtPRZN33wTWRs8etaIWEq3iYH5ve2AUQuSTVWQ61pW5XHJWMGUUdXzFds0YIXlbh/nLiFrp5bCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgK9i5wa168ns+cZakgl1dVliD6rVmVVqbRTQUU2Ocs=;
 b=ZtT4nTDqwXuWWIFtJhNpLzeMir6xuy75YvMhtDCwuTE9/WchcStAbhK9UAUj/LtgcEodUb0TNoULkx8RKcuiOuXRBaGBe+LZBpAlbZU6Y2qJhcaboYJbKLMJLkS48xMGBJGBL15jzYCbE+0K8GeQ6SLljmdsNrcXd45FAUzwxGtZ4zM55VwOn0gqDucr1yAKCAJBY5Xv/0FoKUp5ghzjEfLV5mJ7ejhgeiWdHyOGBmwhFeM/9zIVSZb/KIxZi/Byp3BiLXzGnXOIEDdMfFn5MrVoRRhjQhSK+R7yqnn3/K78ag9GBhZu72r86K/HLeJL6WrmsXzzSWlxmv62vnW0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgK9i5wa168ns+cZakgl1dVliD6rVmVVqbRTQUU2Ocs=;
 b=YGR7aXeY3QqnCGgH/dxicb7EngCLrLcMiUnm9K82lu4mY0V9jjruc4ibKfWHk+9HYLv2BaktYpOMqREpLf25UBfoiFaLVCPFZvDi+w45CseEnnRwJhHyW3orKGBYbbiL4V7cybnB+3cPll/VFRbvhw6bfZ3n8ab+39bXtvGE9G421C2+6A0Sd/Z8AxWpfRah/jcxhloU9IN94q98AHV1g5xjF6YzRUnqMz8jFKpZfPjSqUp2Krvnj2WNOZs1izZq5YsnySmZFxPp20hylExTKmh+7edTd72WI1rBCdTiCkm37n+V4B2cbhwvD56Fu4hYZmRClCz0DcePeeYUL5z9mw==
Received: from BN9PR03CA0300.namprd03.prod.outlook.com (2603:10b6:408:f5::35)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 09:12:11 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:f5:cafe::27) by BN9PR03CA0300.outlook.office365.com
 (2603:10b6:408:f5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.14 via Frontend Transport; Wed,
 1 Oct 2025 09:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Wed, 1 Oct 2025 09:12:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:11:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 1 Oct 2025 02:11:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:11:58 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2ee6c8ea-d336-4208-a77c-fe69bd83228c@drhqmail203.nvidia.com>
Date: Wed, 1 Oct 2025 02:11:58 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: fed18c01-f7ca-4aca-1243-08de00ca9a70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDhIKytHV3RjejVDZ3VVKzdvdzM3bE9YOTgwZVozZXRjSDVETFdOaWUxYzE4?=
 =?utf-8?B?dVhMd1B3M0k1L1lJd2I4eDJSS0xxYldoWWVEYlU5SmlWeW9jaTdTY2thSFJs?=
 =?utf-8?B?ZDNvemJ0QUhCMFc1bkQ4VFkyY2N4MGJ6NVQvWHUzSkZIeDkzT2pRdXNzUnlN?=
 =?utf-8?B?SVo4OVZoWUlPWmJpM2lMNksrNE5jaGoxdkFTZDhOeHg2ZE5kdXYwcThic1c2?=
 =?utf-8?B?azJCcE1adGsxQ255MHllNmdLS2MramNjaE5SSFlQZHZ0WWRxdE9vRGxvT29l?=
 =?utf-8?B?YTdjMlowM2Z6ZCtmVS8zWGJrWkVDZTJ2dldmbk05ZkdRNEpSK3Q0MmlKcmI2?=
 =?utf-8?B?V1htM2RQWmpUVDEyUHBtUG8za2JKZ1VhSndBL2h0RGRWM3pUcjk1eWNMTVBI?=
 =?utf-8?B?UUNENTN1bCtrcWY4cThqSVNYNUJMamhhNzNjUXZ2YUhXcEpuTDZOb1V3SVdE?=
 =?utf-8?B?ZloxSFNrUkRyaWFPZDUyTW9yVXMraDRGWVBENENnZllzeXoybzllalJrWWU2?=
 =?utf-8?B?amdvY0hQR3JESVdrRm5KNkZFM1lrekdnYkRzZkJNTGtxSWRSd3R3TjJ5Rkpm?=
 =?utf-8?B?VHFhNWZ6TUU0QWdwc282TEY3UmZnNGJ3elhiRjZacjZ1cGgvNDM4Unpha3h1?=
 =?utf-8?B?OTVzWkdFWVk5dDZkZE9ERGZPWkdaYW05Ukt0OWVWYmh3a083Q1VnTWo5cm5Z?=
 =?utf-8?B?TWk3T3BZOFNLQ3RLZm81T0lZbTFURU1IbGhLOVpGSXJlVnp5d0c2eHVvY0Vl?=
 =?utf-8?B?SU51TmJSMHBCQUxycW9XZ3NuT09yRm1uaGNUUDROWnoxWVgxWG03TWpYZ2V1?=
 =?utf-8?B?RUhNRmh5b25rTnhaUnVMQTRzcW5CWDI2NEYzbVd2b3pYMG5jVStyNThWRm9O?=
 =?utf-8?B?TUxHTm5GRGgxODhqUTViRXl3bmljdEIyVjhFWU1hbmdLWjVYWDNua1ZnS2Z2?=
 =?utf-8?B?VzNJcVZMS29Ba0ZQd0xZTW9jVjVUSy9rQm1xQjExd05Ua2M2YzQ2VHQxN0tZ?=
 =?utf-8?B?SEhoaXVwOEVaTHFKaWprZTgxZVI2TEN3blhGMGViZWQwQjlRLzhRcDVmbkc4?=
 =?utf-8?B?NFJ4WkNGN1BwcHhJTUVvT0NmREROdUZZMzEyai9DYm45eTJLdWpSZk92K213?=
 =?utf-8?B?UUhtM20yN1BKT0ZOREg3bjFoZVlKTEtMRlZrN0svUDdaUGJBMlZJTWhZb091?=
 =?utf-8?B?dDhnaXVqTVp2UEFOZkNYSy80aGNDb2srTzdFck5Gc1JUK3k4YnU0RngxSmdH?=
 =?utf-8?B?Z2dnRDdwSktqbDRlR3ZZY2w2ZmRRRWwxQTRBR3p2aFh5bHFvRnZ2TjY5cGhZ?=
 =?utf-8?B?NHdkZkRqbENmbnBJNHN6c29KL0FBR3Q3OXFSYTk4ZU1lTzdHbFFyWE5nbHJu?=
 =?utf-8?B?U0dabXhYNGsrd0pYUmJNR1lMK0hYRVVNKzFlSm1ZdVNMN0kzaVo1VjlNaDZ1?=
 =?utf-8?B?VzFqTTM0ZmpiTEJvSUFYYUR5VFhVRk92M1FZN3R2OGNNZWt2Y3o5bWk2am01?=
 =?utf-8?B?VWVmcFR2bDc0OCtQVjFtMGV4T3F5bUZsL2l1NGZISEJoS2VaTXBIbEFsV0t4?=
 =?utf-8?B?ZWIvS0pucTNQd05qYTZrTlBFTjZpb0o5NXlCd1JtWDIvMnc1a1grbWFjZEVN?=
 =?utf-8?B?SFgyT1RiTDN1c2lJZllJOXBEL3Y1YndXOEFoWEZQRnNkNjhLZXpsdVJaODZq?=
 =?utf-8?B?ekxDcmZjbjB0VW1qa1BLM0FLVElnazBSMC9IREVGYjVua0hidVhKemY3MGll?=
 =?utf-8?B?ejFlSm5iWjdXK2xsMlJXUUhYM1dwUU91dDdwUExYS25JZDNJdmt2U2pHdnZl?=
 =?utf-8?B?ZVZCaHc4Qkllc0doZDVmSkd4ZGIwV1FwUnRrUlhtZkVZdW9HOVp6THYwSVZ5?=
 =?utf-8?B?cUV1L0J3bGxEMW80ZDlYdmViZWxJQWZkZkVrR1J1OGp0OVg5N3Awa1NneDdl?=
 =?utf-8?B?MTlvQ2NwY1lZKzdkK28rZ1NnbzRuZUtGcWVpb1QzRUNiQjBjd1lqaXlPdld0?=
 =?utf-8?B?SjdOQnVnQ0FGY0xzN2NhakdxSXRqK2xFNDdMU1YvbnhpZWp3YzVnK1NxbTVv?=
 =?utf-8?B?UTR2eks3UnpscFhMcDFSeEk5c2ZwWnZZVVB0SVRqbFlJdlV4RmlESnRiTmlH?=
 =?utf-8?Q?D9cs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:12:10.5898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fed18c01-f7ca-4aca-1243-08de00ca9a70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645

On Tue, 30 Sep 2025 16:46:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.109-rc1-g583cf4b0ea80
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
