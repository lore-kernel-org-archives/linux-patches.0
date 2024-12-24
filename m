Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D471BC3C
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 13:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735046831; cv=fail; b=nD8Rm+8hPwkbd6Ma42r5571sTYhOZCIKl1YTQSq6V1jFWVQCQ03MZXRIMtmXGwlQnEibaxcGc9+UXZylw81SjUC58dv/PG1bYmv39t/4ajkqxyY13vpIBPIG4/LbVYsq/XtVPBh6mxA5klOsD/JziYk5/xSGe4EOEhtNLuxQfSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735046831; c=relaxed/simple;
	bh=NQ6MTf+FfMgubbJzO/gpmEmbYY+XONP3Z6ooCZlkv7w=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ixiyx+t2+7xLcXEE+2L2lYTyJa4uKFhDXRh6oWcgvFG5Vrt8Y/wGybvoaxuA5VRRWSbdXKu9/fLAWMj29oWTalyOeDEUw3OK7nNN1GMpiodYbrVrm7Nn4dMhwZGUxmsMIeW8VghvKdGfj9hGgiQ5q14ewZYobov53CfjJMSR3tA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VWJfygTC; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VWJfygTC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnJUUoBMG8qzalm/5Fqg44DNTdMqgPV/4AMtpMHM0Ax96YorKt0jWMrHwMSTOIJCTKlAv0MRK1lP/IWnb08MG2KsMAiSPYr5IsifsZqzpd88B2qCPziNnnhK3a2EsQvAMn7BnE0P474xwAafXCJQToVs9RKj0T1ycf2+aRcx9qIxXFhmZ2A2Uiql8sYgdhjhBJaqbU9V2eAu2aEbPrEw82cdPt7MHO/uGlc0dLnrByhyH8eR65DmYXYH5bNbxM+EtvMzf0SVGhKThPILRB3IPSO5Kb5HrzJQto5Fz3M4dUMPsMdjafkE2mnc25fuZf1a0rynwfpxVv7ksHtJHIuIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlYcXeV519H0TT1KDEIWFJo3HmsnaFdWbpE5XyFW/5U=;
 b=a/MW5Ihcgigw7Ib8WhlEw0keS8n29h4fa3w3ICKWg9iJl7rzlwssFXJKWa9qZUuF53+q9FPzT5exruTCx2XG/rZdpDX+CheryCsybGNt7yXJw/l5r4O5SyrQ6oEXZwgwkzshnMEDn7s1aO4Ilb6figWPz4JQso90AAEGvHytFX+eSHFVtuNvj4tLppnnTxNhV1YCz00nkQOvM3h8/zoEsgtnabCTKY57oxCv/4knXjWQsiBdK6epK/c4+ouQqrWsxm3oB7WaQQ1j63WGEXwKF6rw/q6R8aJFOzAb9newSe0ZT516uQ/SGcvtPmvkAfyW2BU8BJMGMLWLaworLNPv8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xlYcXeV519H0TT1KDEIWFJo3HmsnaFdWbpE5XyFW/5U=;
 b=VWJfygTCcJCovBRWErMfOPikqTHopnkFSMWzLcm7hPzXFj2KLsBSjpuhks+TfSOqfmdWNY2kvY+eBD2YbYvI/jfeeUjC3VUOCh5+D8KiJAT1lKMSuw1fqRGehPqLPIvMA01QTU5SiaHINKpXCJkOw3oL+dKp0B6xPbNIi4v7PXK+bFiJNSqxHNd2yU56macW7GRJKTG3ETnRDgy1l+Gebw6Om+yrtpLM2xiEEKcXaxc9zNNT9FtM0/UpelG5r/QQlPVUriif+zK3Ud112kByGl4bdrLeaQLEGbKnTrWk+lnROmL6LS08DWiSFk0wEx0L4Gr//h3ebM+fOeiGHembkA==
Received: from CY5PR15CA0075.namprd15.prod.outlook.com (2603:10b6:930:18::7)
 by PH7PR12MB6907.namprd12.prod.outlook.com (2603:10b6:510:1b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.19; Tue, 24 Dec
 2024 13:27:00 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:930:18:cafe::59) by CY5PR15CA0075.outlook.office365.com
 (2603:10b6:930:18::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.21 via Frontend Transport; Tue,
 24 Dec 2024 13:27:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Tue, 24 Dec 2024 13:26:59 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:53 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 24 Dec
 2024 05:26:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 24 Dec 2024 05:26:52 -0800
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
Subject: Re: [PATCH 6.12 000/160] 6.12.7-rc1 review
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ba96a608-0efb-4d1a-9282-04a712452618@rnnvmail205.nvidia.com>
Date: Tue, 24 Dec 2024 05:26:52 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH7PR12MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a22caa-cc7e-41f7-ac0c-08dd241ea55b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ajErTWVuc0pHbWZ6eTAwSzBKVW9IQ0JhT1lRb0hMQU1QYkQ4WEhJbXhPbTZJ?=
 =?utf-8?B?anJ6cXcvWVBJMnFKRjZLV0FkQnc5WCsrdnFhVlg3VVo4TFJBZ2pFMmMyT0FK?=
 =?utf-8?B?djNVeDNBYVptaStxUU1QbUYwOVU2Qzh3MkhBYUo1MWJ1RFE1V01aMk9GZEMx?=
 =?utf-8?B?eXZJYzFjVWFQeXFnV2NHM3dnRGlvWUxLZ2tyZHYzOU1IVzQvZkpXdXpmZVBv?=
 =?utf-8?B?QnNURmFmWnpWNVBlSnkwNC8xRVR5UUtpOUpaazd3MHNUZzI4MTBlR0J2TStu?=
 =?utf-8?B?cnhMY0txWk9nV2xUb29uSklYVnF4eU5JdnMxbm1ySGF1a0N0aW9vb25GTWlI?=
 =?utf-8?B?dmI5aWQvTUdGb29FakV3ZUUvRDliZXFpdFRCTzIyZktjUVVJbUIrRUc4UGt0?=
 =?utf-8?B?STJJZjZ5WGN6M1dLS1pXVlg3dk5ZMWVOME9aNWRlUnVnL01wYTZEMmpwais3?=
 =?utf-8?B?YTRlcXZ0WlorZHdHQmRsMjcwUnVjVHpObUFYWmowK2hsNUp1bDg4bWxsTnlH?=
 =?utf-8?B?dFJuRVV2Vk5NR0pWdEsvQVMxWjNDQmxWRTMyMXhZS1oyVVlPUWpWMmdQQ0Nr?=
 =?utf-8?B?alFJb21YL3lpZmxMaHNPVTYrUnRMRTdWK25TOVZKSExjV1pHcXhBVFJHMnZN?=
 =?utf-8?B?V3FDRk1sVTdnTUoyODBKZU13WXpEUWU0aUtkZ1VWSEh2cEg3TnhuZnRhNk9T?=
 =?utf-8?B?T3RwNVQrQlJIdmJGMk9xSXZVWC9CYWJTWGp3NjBFVXdBUkVVcU85aFExb3Av?=
 =?utf-8?B?akV2Q2hxaVJ5OXZFSkRRNTBQL21UYm9YemNUNDg5RGN5cTBjckZnMFB4enNh?=
 =?utf-8?B?eHlqYllmQndrdU8xVEJLUXlIYjhGSEtVT2treUt0VFNrMThyMDV6TGdmWUpa?=
 =?utf-8?B?VEtRcmN1NCs3TzFFUXUrSDhGTHl0aVNDZFZTS3pkQ3BLcHArNU14SzY1ODZz?=
 =?utf-8?B?OFNhRUt6alRZMHdjbjU1bHhZbGxaVXVNSS9FeHlyWmRRNWNxSmdFelRXL09n?=
 =?utf-8?B?cXZGb3pXS2UybUpVTnI5NVJSRXFlS1pDOUZBdlFZMzhwdGlNQ3dra29OSG90?=
 =?utf-8?B?MnJCWWYyTWhheWkrR1ovVDVsL084T0xZS3VLWkltZmgyUzJObnRNVkVVTGRv?=
 =?utf-8?B?U2hvL01BTHpmMkw1ekM1UlZObXk1cm9EUGQ5NUh4UmpRSTlyc3gzR1NUM20x?=
 =?utf-8?B?QzQxbzlmMFk3b2hLMnFONFNBZnhsUTJPcHFsMUtRVnF4TzE3QUxhdllWb0FI?=
 =?utf-8?B?TGJGbWU2bHlzUnJPTmc5WDcvaWNzanRRT29HTzZmUVl2a0VCcFc5bjZhRFo4?=
 =?utf-8?B?VVZ2RWppWjBZaVBVWFRvaTZFNzI0VnBZTmZSUHFHZkpHZDNtclVKUUZqeGhH?=
 =?utf-8?B?TFY1elV4T245TDM4R0RIZ3JZN09SMkZFTjZlWFpRRVI0eExkVEdyVk8vREta?=
 =?utf-8?B?ZTFzYXRJcnNIVFhOVkpaTGJoWVNuakVuZ0I5bHYyZmF5bm5nTC83RXBDd1FV?=
 =?utf-8?B?UkZrTC9nQ0RTNk5WbW5lOTQrWS8xNGRvYzBOdzdqZG1pN1hZS2lTektnV013?=
 =?utf-8?B?b3drWkwycTdvczJVR3hrUGNVZ2ozWHFtcU1OK0pLYVZ1MVNmNndTZW5YdCt4?=
 =?utf-8?B?ckhZVUZXY0VvUTlPUFJUWm0rVlArM1JlVzBPREZJRGJMN3ljRkgxNmtnamNL?=
 =?utf-8?B?c3dpaVk4TVZpZlRhbE4zVFhZaW0rUUJMUmZ5dXZZTjE0akp0NzJCSlEyVDA0?=
 =?utf-8?B?eFcyMnpxUElGa0RaeEgrT0NaeTFONDRhd2VOd1BteTRsaGkvTmF5YkUrTU5x?=
 =?utf-8?B?RlY3QUdjMUJIU29YNFU0VTlkczZ6b0YyM0ZGZkV3VXJBT0xhbzBDL3BuSlI3?=
 =?utf-8?B?TWt2bTY0S3RiajlxT3loRlhWYThCYURiYXlOT0F2UnRlYWZ4MExmZUlEVWZB?=
 =?utf-8?B?L0NFbHNkd0JJMzNLK05KV2RkVzhNc2JaNldObExhN0pMeGt2Vy9QRWtkaHg5?=
 =?utf-8?Q?3UQHbnusoNrKpnaGYdbdPBlO+jMuKo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2024 13:26:59.7095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a22caa-cc7e-41f7-ac0c-08dd241ea55b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6907

On Mon, 23 Dec 2024 16:56:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.7 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.7-rc1-gc157915828d8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
