Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1213164BC
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230244; cv=fail; b=MV66jLryiFyz6zU618XvdXrQ5lyvhavmvQOgroiXrkEYmHEnWDuefYKrCGCwgLHvdjflcVybLQusZoA8sq0/yJsTaqyZ5W/jO6TDvGGjD5d4MZcdtZ/UzBIFoUyIO8Chb2EkUMPZO45u4oVuoN7OcXGt3Bt4pJBEgAZamiPqVDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230244; c=relaxed/simple;
	bh=SN/7g5ixFKfN+qdhJB9AFJZZwEaIvEPS86tGvAxrAF0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SozlrpLN+VWkEEDtoF1EsrWcfTKWBj4gPPZq9zs9VnySz0fb7qodnx70MemWQFy5J5EJffBFxVLr8Fc17vyBhy78bu+MeWBXXIKYaoNO+udN8EbJiJ1lDZnk/rEk1i7sChmPZvVc44Kpv7jyoBodwk5o7xwRW4AymWVlMTrxl6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UtQMepf5; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UtQMepf5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oG8ElnOORiJxuuzZgrzDOhZx7iOjkpRoiYe6Qx5P6NhOlv999FjgHUtdkORCh+PAU/ErGOnwLJ7Sw5Bzpx7GEJyzc8xjtwY4S2fe9O0jfGyjkiX3KnGK8ELH1WPTN1ruYRhlf+vtYj0vIp0qT0si9hypATvwMu5I1sLzZ6yzwcUYfQvrORGH+WNYR9x7j53rIxxejCve8uyZi00Wx40pF0iSuYenHsdr/rHdJ3i+aUhxIu9+3Z8ON0tUJB0KCZppJRS3i1FcUpHQxqFVzCMlmXAgLK9Dc6w7pOPodsykzVUbFQIe40RsMjxxfeO/zrvSGLtok4Mwb4De4hPt4tiwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX/09ZAjwoYnRxTyEFligUs9jReupxZt52tjx5qMZdk=;
 b=KbhTl7ubtGla3kGiYHm4gPjgSDvJCv0CsnthNeVW0gENXvVmAorCg270R2dfgXzXewN619Bew6mVM3NrbeBORnbw49pWc+9tfxkzrAg5V+YdqBg0W6vvaZ35GHLXdsQH7NBWBnUQqjJlZPPT6W2LaPEL2cbsdDHoWKIuD29y4WrxxPus/royh6qFYcZfLASZGbZa3UWDa7utWBI/OafpevrTzhT5YUnR5naiDHIp/klBwDERbV8DTXFNs4flFrvt4vAcd4+1sl41qWYre5Yc1JtanoizXKpvnLkPFXe1AWBHKMdoyeqzd0Yd1PIqK5kivRxkRJcJIyFC42TotoBdgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX/09ZAjwoYnRxTyEFligUs9jReupxZt52tjx5qMZdk=;
 b=UtQMepf57V3zuibiQOl1ofqnHehAfWf4Czb1d8VX1YqECA3Y0COc/xgxuuHPXtwCpnWxjyGUJTExvhCuXrQeCf+Xfv5rxjX50QW1AOg+h5lRoj9swLtt43vqsga2wBbchDOK6/Ymalka7Um89Q8nlzrfur3iOpmRw+Ktd0IAC+qvtrFzhKFM1Z8Loi+IaXtV/w1rzkW7F0v4f91gMSmZWfCJHJdCPQbU9e/ioVK0bj9T1AFvu/zrs41orPDGLFSFbBzHtWh/0WI7ses0OBT3ODj0f5Q1B5u695wVvFCQq99emXMxTveWhO/ePBJB35dvZL0qIYj9SKuhQ+T7t1XoIQ==
Received: from BN9PR03CA0797.namprd03.prod.outlook.com (2603:10b6:408:13f::22)
 by BL3PR12MB6548.namprd12.prod.outlook.com (2603:10b6:208:38f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 17:43:58 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:408:13f:cafe::8f) by BN9PR03CA0797.outlook.office365.com
 (2603:10b6:408:13f::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Tue,
 26 Aug 2025 17:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.11 via Frontend Transport; Tue, 26 Aug 2025 17:43:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:43:39 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 26 Aug 2025 10:43:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 26 Aug 2025 10:43:39 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/644] 5.15.190-rc1 review
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f143006d-2d09-418f-8ee7-d53c4258c7ef@drhqmail202.nvidia.com>
Date: Tue, 26 Aug 2025 10:43:39 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|BL3PR12MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dcc863c-4c76-4e1e-dc13-08dde4c822a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUk0US82V0RGTDVWL1BoVW1MRUc0NmFSQllWeUt2RXdNNHIra3FwekR3RjVa?=
 =?utf-8?B?RHBWbjJLM2ZzRjdrTE9LcEJJc2dqZ3Z6OVFtanlEUFhJT1dMKzZOa2Fjc1lZ?=
 =?utf-8?B?U3UvTExCMDcvd0NKYWlIN2hPcVpZN0RtTmI5dnY3Z3M0SzdhSk96UzJHbExP?=
 =?utf-8?B?L1EwTkdXVTBsTU1MSkJBVHVhVmxGSTI0dlY5bGxETm1YYk1oTWJEMURkam9w?=
 =?utf-8?B?WTBmTjVBaER4TkZZMHcvRmIyeWJNK3hpMFE4RUlpVkxTODlPMnZlS3BvNFFj?=
 =?utf-8?B?dVFIaXF3cmNUMWxiMDBlWS9PcThhTldCYUxrRFkzbVh1S3JlVkNtS1pRVkhy?=
 =?utf-8?B?UmVkUW1KUkVzZ0FNdExrODFrN0wvZHRPcis1ZzVVZGhHZG1wZXl4ajRrKzhX?=
 =?utf-8?B?YnJwSUxkQkIrWG9US0V5VEk2RS8raGMvOE1sZVZoRVBQcmozdTZka25DMmM1?=
 =?utf-8?B?WlU4MEs3NnIwSk1vaThaZEVIeUNxbjVUdmFWVDdNcHFaY3dzL1FsYUNVSFkr?=
 =?utf-8?B?N1VxZnFFUVhzcCtPNGRtRzNJdllubzUrcTc5TGlJUWNacGFnQVZaanhrQUNu?=
 =?utf-8?B?bzlYQUhETmNiajVRbFNNWFBnN2dUSndKNTM2QzJWM0JGaDNWWWJMTS9OQllv?=
 =?utf-8?B?MGtiNTZZZXJDSlNFZ1J5TVNtSFlLZm1LbVFGL2NnNngrVTdua1hPck0rS0t5?=
 =?utf-8?B?TXo1N01TK3dvRERkY3IyQXo4eUNYR3pGODFSOEhQa2NoaTZOWVVhcFR5bnZa?=
 =?utf-8?B?ZE9IOVlBcW14SFd1ZG4yM3pjNEVIK081TnljR1I0S3ZUb08xMlNUZUtlajM2?=
 =?utf-8?B?NUZOa0x4LzJlNUlxRVlOZnlFcC82SWtSeEZCVFFab0U1UFNKSVFLTzhPdEtr?=
 =?utf-8?B?dTVmYnlIZnl2NGFkRnF3ei9NcTdxbFhYMEtsN1Q4c1FHZHZkUURhK0VBWjBV?=
 =?utf-8?B?eG1ibTBFNWhpbUU5dUJ2VFlIMlpHZlFoKzRJVEdSYTJ2czFOQ1JQRUlwNThQ?=
 =?utf-8?B?VmpyWHBpZUlqNmpCU1dYMWIzd0VMamtqQUVhMStKdnpSdDVRd3QvMHhDQWdE?=
 =?utf-8?B?L3JpRzkwWEEwMktlSERSNjBCZTF5Y3FGQ2ZmWEhLVHFybWJxVjBYTFcyTlJ0?=
 =?utf-8?B?V2paaU5KQmk0UUlIMHZtd3NUWFZvaXFWZnFpeUJjOHZRRWNOUnM1Z0xEdndB?=
 =?utf-8?B?UkpqUldTMGZYRTEzZzdYNWtDQXY1YkVscEduMXNvZ0dHK2ZaWU9JdjJYT2R2?=
 =?utf-8?B?YzNHaWJwN0M3RkdvNmpoTkoyRGpDSWhYc0J4SzZHd2Nmdlgxam1GR3RLQnRi?=
 =?utf-8?B?eDZpVEhpVC9Ld2F0UlhMY1lwSW1PTkN5OEdEUWEvb1FKeG1LUDlTMGFIVmQx?=
 =?utf-8?B?TjYyejlVYWd1cTRLNVZhMFdZZEFiVjh4OThqREc3bmdGbnY1QkFWRk85cGNN?=
 =?utf-8?B?VFJrM3NkVXhva1pYWTVhek5ONkU1NTVRQjBRbU02QXl5OUFJSXNwZWJBRzRp?=
 =?utf-8?B?cUJGVFFWa241MTFhL1BSM1JYNmoyMk9aSFpqL2Q3a3ZCbXRYTThnS2FmOFoz?=
 =?utf-8?B?OFh2dldDNnM0NFdIV1JNckw4dnlKdjdMeWF3a0oyakl5aEwxdnJyREVUZVps?=
 =?utf-8?B?S2RrcUkyMnNUODdaQlpaZ1VqYzhac1dDKzF6WHlLeWtxNTErYlYyWWRaT0lB?=
 =?utf-8?B?THZiK3gzY2E4Zko5V2JmL3JFeEluQWVOSTgrSzZYU1dRK1E5NzdsM0I3ek5u?=
 =?utf-8?B?QXhCYTc0Y1pnc3BQWlhKVlR4cWZzZGIzVWlJODhhSVgrN0ZTNzI0WnpuRXda?=
 =?utf-8?B?TllxQU92cXlTdzg0L2RTWWMzY1pqYnR1TXJzTmpwRXBIckl1cmNodUQvajdW?=
 =?utf-8?B?TUtxOTcxYXJNK0E1eVl3VlBYSGdjaDZtZ3VrR2Z3Tld5R25BRUhwZUpaTUFR?=
 =?utf-8?B?bTRmNHFNTklBN1lOWXVOdmxXbmFQVEw1aHRIVjRPUmVtOWxhWmlPV0hyN05H?=
 =?utf-8?B?S0o2OFdmRlB0WkxuQWs5eDEySCtna0RGZEM5VWc0VndqZVhyMGV2SHZyelBY?=
 =?utf-8?B?SmJpbGw5NGlubkJ3UTVCdWYrMTR3YlZ0azZqQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:43:58.0376
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dcc863c-4c76-4e1e-dc13-08dde4c822a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6548

On Tue, 26 Aug 2025 13:01:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.190 release.
> There are 644 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.190-rc1.gz
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

Linux version:	5.15.190-rc1-ge09f9302f92d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
