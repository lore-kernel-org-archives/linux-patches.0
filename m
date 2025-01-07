Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9102F1DF995
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253865; cv=fail; b=sRVErl68XxydDWKLSEh/hg5FK7JL3APJowH+yKeFatCBga3vll7RWwZ75OwlHwFRapwCsSGdD1qVht1wVd+EU1cnM8o/iw+MR8Vt4AG9aIHYjizV/fd7G0wtJ9ctFuhsHWPNhan3HILaqvkx+oOmrz3oMEfkc77flaRPnaS+Yq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253865; c=relaxed/simple;
	bh=c93+9nVNRlsmQ1qnWIbTM4k6nbTD6wfOF0YIrDLWIMk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Lhfk3GEmEf3bGDKBh6X9JX5cmy6uTHT3p/y/LmLzSpF6yAOBP+j6UFI925xuTHMo12pRES/AKEHVgMi0Ms0fgD17nDfLreYGD4oKUaVVebvTuZ9UBvJGd2rHi3RPnv9OOnxvSKefz6yozteq4EZfKKK1ooQh/VfOWrNvFO/s/2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O6Jw2xG1; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O6Jw2xG1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nUxpdkcQNiR8iLYYjWUCuS1VOgHsco4ZB+0OfPtn37Gpl1BafWI5/pPJoDQL32jvJBBjyrogNzAWSRD+RQs6/7a156IYoYIao43k1JPecGmILXFFxrunswJAiz8c6QfDnMoH/M2GnUZFir1KcA/H4OrNcAg1TH5e12u5KK6HBNPUEM/nIQJJZaV2smtOPIUB5j5dsUQTH69+U73rn1tCPhFIr7cuWSvFNLKSCtT1PgoWG9dA2LkupF5cGO9pu3gDHEuQ8HsK9R1xv0QVlfNQnS+bS61Foa5uLzz04yCGSM+ppR+KlBETbt+KnhE8wdbQEc0ncdBPz9IGEM/2E1vO4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bblEY6qEC/5VHfimYg4vZcvX4gWdwXMUyztlkZ3+3A=;
 b=ZSjUDuj39WQTBT3OuUd2A86gBDEgvoyIpzoS7RTQ4AupUj18BeZrotEU50QyEHP3HEYrfWBjqUDsWIytq5RJQFziYRRgMA8X2ygwpOmFtqA5msHjRa/GintTZN0AYGL00s7cq4DPpASzCGwLuDpDsq2ODxWfz/oFmFsFg6ufrU10lC1TwarLkMXGpYP0oJ2bDJV6qyTSBtGphOzVa40RaNUhbgwtStA3WWNzQ0SVfiq9sSRRQbzPJ3PlwejpCB6QlDNOhs5B8I6/diYSV21OrNSS9GxY1yf7wz7NkBymFYC9Ydoonn7mCsMexVD/kGvjvd34vQ/e9zj2/a9+vZ7HzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bblEY6qEC/5VHfimYg4vZcvX4gWdwXMUyztlkZ3+3A=;
 b=O6Jw2xG1fcDCwdxdG6EbTYdtlhLP+8KM2md8VMqIQEdFohdaCnyFLSqRyh/lY00MYR+wzRdpyK6TMi931NYllea6baGiafVYQ6EVtY1zK9zsuUpj8Tmdbq3FFw0JleNirOhoe0/AgASuIZPYVKu2WFw/xh1ddO2FFlTArnvgS2JKBUttF2io7mYB3tEVyztFomaCkrMHethlJjSRC+tGJBh9oTqG85mlFH44GQyKrrifNMjN0jJ11ORB5/QNvRPd45ENSZWH1hvYah0aNLpo1A8IRnYZog6ObGxjSuXEKiNAG7JkKiabzgHy5yQuXHZ2Kadq9/Oftwd265X0epXBfQ==
Received: from DM6PR08CA0054.namprd08.prod.outlook.com (2603:10b6:5:1e0::28)
 by DS7PR12MB6144.namprd12.prod.outlook.com (2603:10b6:8:98::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Tue, 7 Jan 2025 12:44:15 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:5:1e0:cafe::29) by DM6PR08CA0054.outlook.office365.com
 (2603:10b6:5:1e0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8335.10 via Frontend Transport; Tue,
 7 Jan 2025 12:44:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.7 via Frontend Transport; Tue, 7 Jan 2025 12:44:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 7 Jan 2025
 04:44:05 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 7 Jan 2025 04:44:04 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 7 Jan 2025 04:44:04 -0800
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
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3e464f02-4879-41b6-8402-e44af70e4ed7@drhqmail203.nvidia.com>
Date: Tue, 7 Jan 2025 04:44:04 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|DS7PR12MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: 77394614-a461-47c2-7c11-08dd2f18fe53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3Z5QlJYVzhzMmpiRlBQdWx4S09DYmZhdkxoVjBPWG9XZlAyZEovaE1FaW1V?=
 =?utf-8?B?eXBNZWRDOHhNM20vdkFDODBhMUxqOThVVDhsS3o2SS9NU1RSTWZrOXFwTjNa?=
 =?utf-8?B?QUVJdU9pTm5Ba1M5L3FJb09GdzRCV1duNXBRNVBIb3NHK3VKSldBc3lyVyt6?=
 =?utf-8?B?N0ZNTjVYclRCVzl6T3pVcDB3ZjlySXNaZEFYaG10aG1ONGMvYjJvQ0JQaDE3?=
 =?utf-8?B?Z2ZWaGlTZWVwajFFeTdyOTAvWEdOWGhTblJ3SkErbVdLZFM1QWVqeko1ZDVw?=
 =?utf-8?B?aDgxckcvNmR5TGh4Q3Z0c2U0YW5EOW5VdFF5MnNEMEN5bzR4ZXFBVHlqbXo5?=
 =?utf-8?B?KzV5QzZuMlpwZXpvRGJMS0dCeXRqSS9vOVZRMWNRemFSc1dwNnZFUkFnRVBR?=
 =?utf-8?B?L1RONkNLRGh1NER3WUIyOTkxbjdLNy9QR2xKS3V6UnJvMGRlZEdBREhtVHVa?=
 =?utf-8?B?WHhJeDZybnJoZldsZkJvM1ZxK1FqcmM0eElhZ0NJRlNLU29oTFdPSUYzWEs0?=
 =?utf-8?B?N003SlFXbEU1MHZVNmRDR1NNSUxUaldrbUVSdWJ6M21HZmE1dE0vbVoyM2ZR?=
 =?utf-8?B?QStzRnZkWGl3TWJQTGtLUlBJanl3MFZiYkx6Tkhaa3VQcldRRlBGYXZqN0hR?=
 =?utf-8?B?VklBem9YVHVpQjVhOC95ZDRZTExXc2xxM0JXM1NBWkR6YlZYOG5mTmpVdDJy?=
 =?utf-8?B?WG9GZXlwVmRtR1pGUUVqZVBOamUwekUxaTJ4Q1BYeHFWZnowRGtFWGtPbVZE?=
 =?utf-8?B?NGJuVXhySmZSU0RzQ1FyK2gwVU9zUmdJbmx4VDVHWVhqaUFOV3l0NzYray81?=
 =?utf-8?B?aXpqTm5aRGdOQnA5SFpTMFVHa2FwVXpNamhxUmdhcUtmRERaeERRenp3Rlp3?=
 =?utf-8?B?dWhNZ21BVlpKMzBlT2syTWxLd2ZVM0w3UC9XSE5zTDNoR0wwM0dNcHF2eFp5?=
 =?utf-8?B?cms1cjgwOFFuRWpqZWErWisyUWhjYWJkVVk0UzN5QWdYVEZVWVVaRVFhWmlC?=
 =?utf-8?B?SVJ3T21LbzcrWFpsOWQ0d3dMeTZEakZBSVJzdjJNVHU0OFd3THNtR0dpOFBz?=
 =?utf-8?B?UlpjKzg0MU5CYmZIV25hZTBGVzNTdEZZQ2ZpdXU3bVRDWGt5RW5CNGRwakJ4?=
 =?utf-8?B?eXZrSmlGUUNMKzhXbWR4OEZvbVR6bVBEaUZrUnJVY2dYMjFHeFRNWklaOFlH?=
 =?utf-8?B?RUR2OFlNd2NDSENyeG0zQ0RPdFRSaGtLckdmK0xacWdvaEhrTzBCcjlMSEFT?=
 =?utf-8?B?KzF4WWQ4cXpPT3FGQjlNdEVDZHlrdjJVbURWSSsrcWJ4S0ZCcVA1UHVYZkRP?=
 =?utf-8?B?NjdBbVFVSlVPd3FJaVBtQ0FlV2ZmTnRZdGJFMXVIRUowWkVjNHRBS2Z3cWJl?=
 =?utf-8?B?TUcxMVRDUXJtcWVHbmNhTlJ2SmhOWjNaSFV4MG1MUWtZc0Y0WVl0ZWNyeFBr?=
 =?utf-8?B?Q0dwZEJVMVA4QTFXTkY2elZTSGYyRnpERkpjNnhKb1FDZm5kM3p2ZVAzZFNr?=
 =?utf-8?B?K1FuQ1lWcVVGUWlFMnBCU3JueEF3REUxcXlnMVlrREJSOFE4Wm5jWk9VbnNV?=
 =?utf-8?B?Z0hJcFd5ZEdmNlZxNVFHZUdpZm5PZVpWKzVlZ29kRXpzQjBBckNCZW5pc3VO?=
 =?utf-8?B?WVhXS3FsbGdjbVBXNTR4cVVVWFNCZlhtMUJvQlVnZGlCdTZpNGlDbkFlTFpK?=
 =?utf-8?B?b29QOXRwRmVQdTlMKzhjaHpXNHllOTR1SjFxZ0g3c1lJaWFEcDZKeDZSNE9S?=
 =?utf-8?B?anlXcHBMWkJWY29ad1ZuWkVJNFhiTjUzeEluRzExbmNYbGhYdDVZQTh4QWwz?=
 =?utf-8?B?Z1EydzE2eFZnN0N6Tlg4bkJNY09ocVN0cXhVc0ZLOEZhMUxxUW1DcklHUGZR?=
 =?utf-8?B?MDhqUTNLOVJabEplWHhnYzJHaWJaTVNPTzhqSG9UTTlaTkZrd0haeE5aWk1S?=
 =?utf-8?B?ZDZJR1dEOUlIQlNpcysycGlMR28rYXl5RFc1WlptNHE2WVFGTzE3T25sQ05m?=
 =?utf-8?Q?e2ReMFm85arv0TnAGyAMSKP40mBu2Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 12:44:14.8145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77394614-a461-47c2-7c11-08dd2f18fe53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6144

On Mon, 06 Jan 2025 16:15:24 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
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

Linux version:	5.10.233-rc1-ge0db650ec963
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
