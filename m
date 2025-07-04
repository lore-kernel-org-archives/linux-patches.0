Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EEC2C15A9
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 11:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751627637; cv=fail; b=cAqN0UeQnihfOQtGW/Av+uYBnBet+uYe8suajU/1nHzwOmqy5symm4iD535FT8uze/99VcfvTmbKsihGqwmxA//YA07rdOnQ/9gZUzoORZvGEamoVp0IfnX60rvRMi7f0m6RZnyksIpeOxcaYPRETukbOK0xEWxuamW4ptmw6Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751627637; c=relaxed/simple;
	bh=wcIPjq3alzlA6cnyKRHQa0zkUCvDCfxDhPke3T1ZfjQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BSbeeHhTq6NJH+eLhifvmhNhUKC+cAhykuRNtn7QoW1xAss2XAnOkPOdg3rsnW+OI+GuxIspcdiNRkQq8QFww/jc54rLaGwrVcVmnHPCgm9tntGYdkuHcvLx65SdGL+Xx7ndrFhOb0U6wjKnX/+XqNkNP6kdjM2474yzCfd+Ak0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j7ZmvUTu; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j7ZmvUTu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOinMpKUhKUpMiB27RVxbX+IFyUQObCE3LkWRmEX295UdKYZ7YWZY8PUol5p689AiEAIoA1vRdP5LA7O78w0gMQzKVStlsMwgSvsMLr8EayvibFyVV3IXzZgZTRKvMUEpN5hJkxnHHH9oTBDt0gmICDAdYe7RoNUtp7syU/usP/dw++EisxIQNrskoRVSW+9+qtHkQFk+YB7BTODj+ZMHXRDOq5HepWyulA5EF5+dobBUl9AKLAXklDlK1LfZN61oJMVlNjL1WQIp6g3PCR71LphlMMvZXhDRpV11W59WOIb2kKpqx2lgiv/bydHmHWtUpx594jNqQmvjljWtDycjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oyk8gDVfyvBIPM6270SKrMOUk4bQMVFrWRuJxtfOAYA=;
 b=dCKRPlRgOadFDejWCbVNCJ8Kg3O/V19chL51YXywbjJsJUo0iw2l1kHmAWomMf5Bd+mlVgl5YKAfuC6+a5UbqPgRBo13CAAcnpLROaOmrzkOIM+wilkGQQ64y1sttc8x57Qyw7fEg+ru4AO7w2DCry72M2DemoeYdT2TDpDHOdU+tPBasWYjJUcI67wiyzanL9qiXltIl6UuwWHDFDd2T6hMJlvXCUXxT0LW91fWu42OkqZM3yMv/7R9sAFDM0LpJRAVVITwZEFuVe5f3lD3HaylFGsAZhPZiM4LLptzQ12Kj/E0qjxYn4rZgnIiptiiJxYj6CWHb7jfsoSdykw3UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyk8gDVfyvBIPM6270SKrMOUk4bQMVFrWRuJxtfOAYA=;
 b=j7ZmvUTuuGVuEIARaAA+CGh4U8rmHF9Ofwf4Z1EZYuN/IG/eYNpgqbCQwJkRnOTW+tytkTFS+s17RjeEnwpyiDR3G/uRo4x1FvwWr8winsprUXW8dU6tCw3YQf5D7v6fh7i9k2lU52/abieQpBS3atC4QOaAFWI49kKnrUWnVxkiERbFqyV147cg/L9ciM+SJo7im3tYd+rPUhcBZ6BEgnqtC5yiUu4SuLgI2s/8C62Q3dfsQ1ttJlS0amIo91RNrmpqwR2fgwEkKTcZ7kjSIoX/C+mFvZ7l59lXpV8Oh8IlHUN+Yc0SwanrJP+a2FFh3PBp9Kf5oqQmTkU64KaeYQ==
Received: from CH5PR02CA0010.namprd02.prod.outlook.com (2603:10b6:610:1ed::22)
 by BY5PR12MB4289.namprd12.prod.outlook.com (2603:10b6:a03:204::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Fri, 4 Jul
 2025 11:13:51 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::83) by CH5PR02CA0010.outlook.office365.com
 (2603:10b6:610:1ed::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.23 via Frontend Transport; Fri,
 4 Jul 2025 11:13:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Fri, 4 Jul 2025 11:13:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Jul 2025
 04:13:40 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Jul
 2025 04:13:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Jul 2025 04:13:39 -0700
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
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <898ba668-044c-4853-9b0d-608d99b3787d@rnnvmail202.nvidia.com>
Date: Fri, 4 Jul 2025 04:13:39 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|BY5PR12MB4289:EE_
X-MS-Office365-Filtering-Correlation-Id: 53baea5c-4cab-44de-be27-08ddbaebdb4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1RsNlYydURjbW9RdHUxdzA0dlAyU3hXWk9rMzBackUyWkRaUzFLN0wrcWJQ?=
 =?utf-8?B?cXd5ZXpaY2IvaW9vWWM0MlQ1SnA0SUwvZzhRNVZFcytpS1JqNUNDT2JNcy94?=
 =?utf-8?B?UTVQaTlGYXo0QjN3OTZXMmY3enZ2NCs1WVlzM3EvMnl0bUNEOVhySGhQZFFM?=
 =?utf-8?B?WmFWNUpVR25vR282TUN2ejlxaDE0R3c5UkVaQUtyTGhmM1RGMDIrU3Ard0V5?=
 =?utf-8?B?YXo5SkRiN3I2Wld0dlRlRkNCWWwxK3N4a0ZseS9yWFMxcitzbXZSYjJWS2cr?=
 =?utf-8?B?ek1keDZtVlBiaWhUZGxncTB4YVZsRXJFZ2UvdTluTUlucE9ZUHVtSWk3SHRD?=
 =?utf-8?B?eTZNVXVLcjJHR0xLTnRJeUFmZ3JtWFNQRUxtd3ViM3lpTzk3OTdxMTloSTRo?=
 =?utf-8?B?NG1WbFhGTUxnY1Jncm1RU3hqUS9BMmVaWDJrUlNhak5tK215c2lzeFozNTRk?=
 =?utf-8?B?UzRaMkZndERaVVlQUXo0dTdSV1pJZk9zVEZVVXFkampxZi96VVpsaUY5WDR5?=
 =?utf-8?B?bjBKdkNPODBLK3JwOGcwRlJ2UHlZTVFxempaUklhRmtsa2E0QWdHOXllaDFE?=
 =?utf-8?B?R3B3bEpiUGxQR3BsSVFpYWo2YUZ1YlJ4b05yNzFsbEJxWCtQcTVJa21zKzhq?=
 =?utf-8?B?Z0ZCMi9mUUM3VTdIdDV0N0txcWFnVXF3Z2xsV21OSHlZZWhtcnd6bkI1ekJq?=
 =?utf-8?B?N0tiMWJXN0YzY3U3V0tsV2lVWTNraDhxVTNzNkp4ZmNVS01QUFJ1Q3RkNUVC?=
 =?utf-8?B?TGJXc2tSeGFETDg4QTNqZ09VMmc1eC9FMEE0bW5nb2xyN0dEZnFOdEhJZm9n?=
 =?utf-8?B?NW02cmlrRDljNXMvR2wvekdRUVdnVlp2VjVPREpmcUl3N0F0dHhLdnV4K05Y?=
 =?utf-8?B?NU5LQjE0Tmp2WFIwRWVQR3Y1MTQ5bG53MzVVVU5Oa3NHWndoSzZtMm8vUVl5?=
 =?utf-8?B?cmRRbFVNR2M0bm1OdFBPLzEvWks1UnpOa0xxQk55bFN1dmYwR3ZnUUh0KzFw?=
 =?utf-8?B?QUpGVkFFaEZLUEFuWnExa1VGU3ZwcnN1VTFzQVpEYXc3QVdIalpEVzFUVWps?=
 =?utf-8?B?eG1NdHpKTHQvT2tqNDNOUkFSdHBCRzN0Rkg3Q3lNNUhJSzJsYTcxRFdBL3lV?=
 =?utf-8?B?aHVjNzltNUR4cmZaTHFlemZNOEhMNjVMQkhLUzIybTgvY1VuVXRBdGhlb3JN?=
 =?utf-8?B?SFArcWZWOVNtSi9iaFFhTVVLWjhqb1BqSnFkZFEvOXdUZFllN2k2bzlxYktH?=
 =?utf-8?B?K2svSzliVXUyeFBySEJiZGg0bkFOdHRZZmZYOEFFSzk1Rk1jSWY4RUoxTEx1?=
 =?utf-8?B?MisvaUdlOXowd0xPbWhUV0JiN3FZM0g5aWp4dE9iOUs5M0NxRTZ3RS9NWjNC?=
 =?utf-8?B?YWpRZnN2dEJ6S2dBbnBGVGpZeWh1V3dxYzJOZmVEUitTc0lIV1FIR2huZno1?=
 =?utf-8?B?dGZjQUM3SHJEUEQrZWMxRHpkTklUUjJyUGpQelFnbDlCZjVITlRFdHF4NFp4?=
 =?utf-8?B?NWlrNm9UNGRPa3ZFNHBLaXJkQytpSU40QnVLSkc0SFBIekNQZnB4SkJXbVJF?=
 =?utf-8?B?SExBbS9JS0pidDBUVHcyNmt2QkdwL3JaMUx4aDNhRkRzMHJ3dFZJeWVjRjJE?=
 =?utf-8?B?Nmt0YWZsUXVjTk9aYWZBeWJ4QkUyQUIvTWdNQmtaRytndDdOcHRKajQrbzE5?=
 =?utf-8?B?dEJ3NGxkS0FSUEZEV3BSMlRrd3M0bmxPdjJwY2tleDJES0NlSTR1Wi9EekJB?=
 =?utf-8?B?aGRnNGxsSzhYbVpicWlkVGMrcjFkVW9XWWNXMUFCZDlOa3dSUXRDU2J3NWsv?=
 =?utf-8?B?K1hRNStzZWtTUTU5bThrNDlEdDdRSVplcThMeUlaa3ZyeVkxT21maUZsZmRE?=
 =?utf-8?B?N1l1cHpyV1JjeVhhZDN3OVBlbDBRUkVIV013ZFM3elVZSml3LytDWWNINWFC?=
 =?utf-8?B?SE9ub3MvYjQ2V0wraWpSYjZWekVuTGlrK1YvY082N3hYaEZPV3dMTldwS0NO?=
 =?utf-8?B?Vy95ZGk0eDY1Y1lYSmJ0Z2p6ZklPdDExcGlkZExacW4vYjJKR21ZbGt4bXI0?=
 =?utf-8?B?WGcwbXlXRkFXdytEaTg2R2pobXhIbmdqeGdPZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 11:13:51.4374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53baea5c-4cab-44de-be27-08ddbaebdb4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4289

On Thu, 03 Jul 2025 16:39:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.36-rc1-g08de5e874160
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
