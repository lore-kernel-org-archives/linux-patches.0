Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010062.outbound.protection.outlook.com [40.93.198.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C78532142A
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764932334; cv=fail; b=KMrP9D0FgsaUwEsXeriUNE0j5eNVxiggtEw9wAc9oZ57pV1E9zHVxMcmJ0zHCESZ4NtlUnC02OMlnKRhuua4XqXYgfWPZJXpilF0Oinhn9GXzYq2WEKjZYXfrXVW8bPXQ/rdFvd4ncH6jSU6aG3wJvQVaCkrhKHrypQ5VG9OU60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764932334; c=relaxed/simple;
	bh=ckQWkLopEABS5Eifc66IZpJcCTjaF4YAq+bg5mNTWlU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=JOsLojYAWpfEFNTA7WUKQmL16g6xOBMMNW+EzGsPYGCie5j5X1yT0TgYuQ6QApA7S/ugHR5X/LtmMG57uGfeNs2Dg++XCyharLry+mqRf9/pTnfm5CzHO6rHDUa3Dmh0Dqrr3VDwzZLG6ZYIbUupCEOXzBgL6DNjPQumvtLkfhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AtVcQPVO; arc=fail smtp.client-ip=40.93.198.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AtVcQPVO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0zLBmHzAPmDrWb652IsmnQH0BE0Xhcit0fbE5oqREpc+rOpxVJOUgeHmTCUPFGTYS8NPWmPQagHyHXY9S9drxrr/vK3NkT4JwIPoMBfxAsZEPrK1wkc2l0qEN56Dak58Co/IxxkNI7x1jTETZfBbMtfTWw8W9jJOxVLQXdzLotYwRR7pCHfk77YhqPTMs0diJv6ec/nA0C+du+hy92w9X8q2eFOr+c70JsppsSYklUURJxw7/MP8NZ1BOHJYu9FE5ht9VJ0MtIyYuazpCF7iZB/KHdwfKPqtPdfOg01uqa+fRazW7+sSWhmST9vv3ETe7Ync/cbtJh1Wt+ybfNu4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PX/nfAwniaLmMKXsaI4KnekIlcrz+FRShwc/cT32ZUc=;
 b=TxBZBjiUD8fzdZBqX8PuaWVmrsUC78geQZcRIbFlFos81/deCRbjOOZNDTd2VNzKC7inq4eDyotifrHasnwIyTvDt04HbQ7FCp2v2sZg9tNUEp4hPgwG1vaKuMBqnIUTcCI7mpJNJoEN/3yk8qspzCaCtaAj07DYRdj9N+SuqnbUmVzM79st/7M6W1i9+N568SmFzEQy2IWHt7rqJNJ5PEJOyVzNRyYrgvfldOutNXoZy7ZLOTrssByGBMQt4EONtLc/74BfS3qTDlxg14Vy4lmPVDuuVVdItlE1i5i9rNY5pNVAWpnGZdl86FvC0t1BIpEQFZn+OHbok3LKasNC/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PX/nfAwniaLmMKXsaI4KnekIlcrz+FRShwc/cT32ZUc=;
 b=AtVcQPVOGIcW7yjFPQuAi08a9JANs2m3xnDEweQnkIGTLvREO5ssdld71t5fA2GvHbEfMdvQamhPjaESR+602OUWmmSL5DsV3lWLiOomSADlCGFl+/FNAMSnYveVUVV6iK3XOXtTcHqfhhLmfqMP9FsslBSfl2IYcnffK4GAWXeWMfOF0cKfUyYf+OU9IR50+y/p+uK3f73aZvopeTgunzKQVUYcJnQZ3N+F5xH33CZsI9fXozi6Wcqy4tvZOnkVHc6/xdgY/XmxGwXImeguTe95Sa8OM3qK04fKOZN6gioZ6T59zhnlYZR+yX9TyWF4y8pAvFc1jJNbA9UDoUCjKQ==
Received: from SN1PR12CA0063.namprd12.prod.outlook.com (2603:10b6:802:20::34)
 by IA1PR12MB8467.namprd12.prod.outlook.com (2603:10b6:208:448::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.10; Fri, 5 Dec
 2025 10:58:44 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:802:20:cafe::c6) by SN1PR12CA0063.outlook.office365.com
 (2603:10b6:802:20::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.11 via Frontend Transport; Fri,
 5 Dec 2025 10:58:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Fri, 5 Dec 2025 10:58:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 5 Dec
 2025 02:58:34 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 5 Dec
 2025 02:58:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 5 Dec 2025 02:58:33 -0800
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
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
In-Reply-To: <20251204163821.402208337@linuxfoundation.org>
References: <20251204163821.402208337@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e2aeb84d-a8d9-4d6b-8b28-881f3086cf91@rnnvmail203.nvidia.com>
Date: Fri, 5 Dec 2025 02:58:33 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|IA1PR12MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: a7fe907e-829f-46b1-3bb8-08de33ed41ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWJqUFpKb2ZENWVoejZINURIOWxySU1YbW5NSGNpSGV2ZklleWNVbHpIdUxv?=
 =?utf-8?B?WHBFSmhYRzRVMGQ5VUZnRFlKbmVqbE9JWmttU1NTT2EzdlNWZEUzWDl5c3B4?=
 =?utf-8?B?bFBIYUIvTm5sVzlEaFh4V3hDYnZEbVZrZ2pUS0Z5QmQzbUhZWkk4djdkbGxo?=
 =?utf-8?B?TEExRy9zZWt2MTVEVHhueXlQQVc1bW1yWDhZYlNxQnc1eUcra3hrWkFPZHlh?=
 =?utf-8?B?dFppaTlUNWc4SnRuSmZadnZSZHNDcnFoWDI0dW0zMW1jWWQvai9KeU5ld3lU?=
 =?utf-8?B?bmJGOUtZMzY1aWVCZHR1bWowQ1BQbUVVY0N6K2RHMTltS05saC93NEU2ZGFH?=
 =?utf-8?B?aXdWMnp6cDdWRlE0OFB1alUvblJjL3BSVnVEdXBoeVdoSzVkTHU0VGUvSmRy?=
 =?utf-8?B?cE1IV2VJUitSNlZnK0R1clExdFFSZ0V6Qm1JcjZIL0dPWXRHRE1jZytiZk5W?=
 =?utf-8?B?TjF3RUgxcG9wMWJjc2pzZmZLWndScWNaZUJTYzV1b1BFT1JvSW5NQjBMaUZK?=
 =?utf-8?B?ZmN0ankwVkFQQ0NGSVBzb2s1MjZnTjlnYmJMb3MyVDRNU2ZtUFlJc2doMU9z?=
 =?utf-8?B?YzV3cGlmVFVQWTlqQ2hOd1ZNMnVLZk5RM2NObGk5OWZFS1p3Vm01QnRGL3Fh?=
 =?utf-8?B?ZVI0a2FqVXlmQk1NTEdCdjdvQXk0MDI5Ukl2SEJLMmhlY1VTcU4ySy9VL1Ur?=
 =?utf-8?B?dHkzUDljK2xsQkpMMkM1WFVoWUEwZkFsU0x0amNTTWR5L3hEMnpoT1V2WFZV?=
 =?utf-8?B?RFlOUW9mS3U3b0x0OUU3bTZoMWV2blQ1VzdqM3hraVBXZlNtSGx1a2xzbEV5?=
 =?utf-8?B?UmNwNG9xT2RYeGtVWW11eHJsM3dIOW9FRUF5eFpqVEx3S2lkVE83a01TRGpW?=
 =?utf-8?B?Tmd4cEUwaVdwWmEzYlA2ekV0bkNkbGRmSmV2d3RWU0JtNEMwdEZWTjJNc3NT?=
 =?utf-8?B?V25mS0dtSTQ0T3VLcEthcm1NKzZvRXhMU3VTb240NnFIUTRVVmNQdjlEYm9F?=
 =?utf-8?B?SUJLYzBXZndDdmNON202TnpncGF3YSs2RGdkc3k5cnpjOUM1SFlqOXZNV2Yw?=
 =?utf-8?B?cm5uZm9VOVl2YkFBTCtPbHl0NHZlSmpVaVZvYkUrYlRhMTZObnZzTnl1bjQw?=
 =?utf-8?B?K3FxclZ6dnNoV0FDUDhYTms3T3BMaHRPdFRJUzFmV0lBanZSUlRpWEp0SFkr?=
 =?utf-8?B?OUJkcVZ2YlhsaWRYMVMzbzdObzVOeDBpOERoRWRMaDM2NStyc2cwQnJvbzFm?=
 =?utf-8?B?UmdvYVZVOUdkWjlaUWdOcHpYaW9ESkNlUk5qN2FRN3NJM3dzakgwM1hTOUtu?=
 =?utf-8?B?bXB5UHNZc3huOUxteG9Xd3lYZTlOYUpxTGhtNXZra0EyVEZsK1Vjbk1Qd1Zy?=
 =?utf-8?B?ejcySmw3MkFSbzlKZ2NLQ3ZVL3N0bHVzZTFkVzRMSUpONm1jWFhZdEY1eXRp?=
 =?utf-8?B?YlA1SGZMUmM2ZXl5TVZKOXFnSnBGQmc1NlpSZWRiSE1HWmNsTVJhdGNzM1dC?=
 =?utf-8?B?K0t1Z0RHRVdGYXZKcWpTWWRNbWliaVo3V1NySEJ0K2pPWklBQnd5WXZ4TThL?=
 =?utf-8?B?WnBPY1VtaUQvazdUTDNaTzlmT1BBS3IzZDlwVmV6UnZMem8wUnFrKy9Sb3BL?=
 =?utf-8?B?dFl3S1ZvS0t5MkFlN3lGUTdMSVo3bWc5OHlmcCtNRENaOUgybFVTczZabDVH?=
 =?utf-8?B?ZzhCREVSdU9qQUQwbFdNNGF2RG5DcDBSTXRMUFhpZllJc2xFNTRlNFRxZnJF?=
 =?utf-8?B?Y0Q5MHFZbWlHcXBHa3pUMkZkWTQyR0xiZUJZV2FoQmZIYzRwT2xvSVR5bnFF?=
 =?utf-8?B?WGJCbDVqb3UwUmhSb0s0d3YwMjlrWXgrb1BIMWg0OTlRQXFBSDR4U21tdGJ4?=
 =?utf-8?B?K1lwdnhkM0JQbkJjd2Myb0h5YkZGOUp6UDRRR2EvWTNzeGVJWXY0bmNRL0dT?=
 =?utf-8?B?Vmh2Z0hkSWxHc3FBU0xmMUsrSGpORHJwaXhrUzkyZ3NBUzVwcmllWUVxM1VL?=
 =?utf-8?B?amtWN1VkTEdleXR4R3NmTVgvTDVuUnRqRXpPcXhIbnVrM2ZvTDVpeGthaTZw?=
 =?utf-8?B?QnVhYjdxMndXbnBNbnpqQUZnVkdieTc3dldUUnkwZzZ4U2hCRGpwME5kSDcv?=
 =?utf-8?Q?p97w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 10:58:43.7914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fe907e-829f-46b1-3bb8-08de33ed41ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8467

On Thu, 04 Dec 2025 17:44:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 387 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.197-rc2-g19afef1f91d7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
