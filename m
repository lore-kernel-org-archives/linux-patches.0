Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A311B3955
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743171840; cv=fail; b=MfPXGh4eczvVP/yGrvBHG2/chVyxep3yD8NmC8bASi8LOUaOg+TcqTxTl/JdA1UAFOY1nhuP9S0tHnx5TLkebv1XbbJ03PUwGnnZySsFr0Lzmx8q7FhS5EJ+elyvVCNfcPrHJ2AmYxc2yVf4YtSycO1nigiaHPCJCWdt6OunZD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743171840; c=relaxed/simple;
	bh=a+3HGWPFXhv0KEG4eSGTjFg1Cmh+NUTrr8/VIkD+DuU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=myjKGT9voH9RbbST43frRckaGXce0PYjK+hddX29wdJrwL6TJ6dfrMR/BnUDLo171FicWZkJK9R/LslIcXIJJdY0pvlpISSqt+Q4C1i2oTTgzDUD7Q/Kcc0VQyDpKn8Ufzy+RRcnAC7fdpkb7K1dQbgsojOjPsNbrimNKzpf29s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CEzkNepR; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CEzkNepR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J49gZ33N2Hd8JoNEC0tKVrRFdJFmhVv8mUGmnZ/1/FIx1+f2ZfGMeq+/XkbBwG6HFFxQPtBR3IqIkFmT11IfZcUryTgO0Kc4wVsA+xDSST3RvqZ+UqhzbtY3282Zv/x8991z3euaOtMslYOKPzXmeRC8a8thAkZvsNKSYbZ2+A0pXS4C88NnAassnJuuHq36cf5gw5/hpu5GjPc1NkCghqvYja3XWab+6UJnIwNovycjLIeeYaI+eCFKTLG2Y7Ec72aVee/FkFUHjw3OsA7m3i6Sm/dlR/1nJDrFkfW/rNYX+kguiFf8XF6/uI9b/IuY/o+9PD2f7VrF9YaaNQtTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOhR79X1NyJ8oc1XUoRoIk2fk+efWPUTa1z6+GVHwhs=;
 b=ePsXilhBDH+Z3MHtK573Plp3se4WXAD2wOikRGBC9lww9VfjiyudgWEPnJ940wibOFCoj2LaXVurWCn4Ch2I36uj9eMuZ0PPXS2M5bhr6Y7rNVjH/71XTGdUPw+NBwNGFYr6n4ceHI1M9w3RcDwTd9W8dqX8+WjMjbmo4Eb+ui+uu7g+4m3xdm+/q5FGFEFNQJK9Qz9l23ptp8HG0+jxEJ+6RIVJxDvMvfgM/QNmopaK8JRR6sbIUwvtFmcVRGIT3P9oCYAeSwGQAB4L03vR/G31O8gIMS0Jy5PvzWdbhVYVE3nCWLYvMhvTWknpLvPmU28jh/JmWbzLcRYpH9y4/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOhR79X1NyJ8oc1XUoRoIk2fk+efWPUTa1z6+GVHwhs=;
 b=CEzkNepRsRI/DQ7/5bzIgt4eXlpJmQNdjCSO0xXDy2UMWpSS8t8TfFQCEgelP/JeAMcAxyzWkCAOsB+3EFzEqO/Vz3FBsuDoIKfjv1/H+m2KyAceNfWajh5WN2hMBPwTeN7Gl/LitX+yH9Tyqj5BfvVxN0vqBBpJo/sDLV28XlEbTXoz6K1ynRStO61EeFB/8dvCYcj53NKqhTNA7zSak3p5SXKlwyzV0sdExuYixC3gVXFVGrNZfjKlenl7XFpgVelW6QKCRhwPkjZ87tP4zQPZkD4rpsS7DJ9QEc1kma4O4499UPNCp6qAgoVZeas+mEBT/tieLrAZxhNv8Z5EeA==
Received: from SJ0PR05CA0210.namprd05.prod.outlook.com (2603:10b6:a03:330::35)
 by PH8PR12MB7448.namprd12.prod.outlook.com (2603:10b6:510:214::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 14:23:54 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::fc) by SJ0PR05CA0210.outlook.office365.com
 (2603:10b6:a03:330::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.27 via Frontend Transport; Fri,
 28 Mar 2025 14:23:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 28 Mar 2025 14:23:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 28 Mar
 2025 07:23:50 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 28 Mar
 2025 07:23:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 28 Mar 2025 07:23:49 -0700
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
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
In-Reply-To: <20250328074420.301061796@linuxfoundation.org>
References: <20250328074420.301061796@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e0a881cf-8a00-418d-a10d-c088bfc1059e@rnnvmail201.nvidia.com>
Date: Fri, 28 Mar 2025 07:23:49 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|PH8PR12MB7448:EE_
X-MS-Office365-Filtering-Correlation-Id: 95fc0e45-cf2b-4bfc-42f8-08dd6e042b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjU1NEdWcm9hbDRrck9rSmhRY2tPQmhMRi9tek9sZmhIOTFJZnNLbDdZbC8z?=
 =?utf-8?B?SC83UlVMSklWN0JpRWhMMmRPNHV0RVduMHI0N2t4VGVFUUVJaTZZMmdMYlNq?=
 =?utf-8?B?ckttVTRHa0wyODd0UzI2ZFk1U1IxUS9FZFBuNVlJYnRta3AvYUJML29xUGF6?=
 =?utf-8?B?dlJFRFpTOVZOa01pekR3V1RMVjBISExUdXpGTk43Q1orNkk5VE9ocjZnWDJn?=
 =?utf-8?B?YkNiSmJueTZLZEEyNEs1VmlGTU52NnVhV3RsOVhaM0pSYTRndGlHMXRnRU05?=
 =?utf-8?B?Sis4U1pLVjdhK21BWTI1RitvOXk5cWtSVlYrZkVoK1pUWWtLUjNUMXJiNG9L?=
 =?utf-8?B?YVYrOWsraVdsMUhDc20rUzN2RlF5akpDOWhTb2FUaVFadExyRHBmU252Nm1P?=
 =?utf-8?B?R3h5WDlJOGRxSzlOejl5N21xSUw0VkFlZmUrMm51UWZKSkZ6akFDNnd3YUMr?=
 =?utf-8?B?RTBEZWZjVmNYdmdFaEpIc3V3NkhVYmhDTWYydVZCelBVbCtSTmI4bHVRT0dv?=
 =?utf-8?B?N1ZSVHV6V2FQRzQwbEFvRlZSUHo4akI4TTlmNGE3dEVHK0I5K0NKNklKUFJy?=
 =?utf-8?B?Q1FZVHlZVE4yb3BWTzRpbVR2WnVWZ0ljRlgvd1AwNlJ1L0x3bWdjbXJ1UGkz?=
 =?utf-8?B?bDFYZC9uREJpU1daY25XcG9icnRLKzduZTdVaTVqYlRYK01NUjFDdDBCZmhD?=
 =?utf-8?B?QjFPbDFONS9mMm5XN1E0cWRXM1lORzE5THU3ZTNpNTU3VFNuWVhYQW81eFVi?=
 =?utf-8?B?cTYvdlc0UWJGZnp2QUVFejBZdFlNdWdtUkM1N3U3TFU1SlJCUHp1RVpQd2R4?=
 =?utf-8?B?SHZvbGQrSkpkdjZCaXhBUUovSGt5RE1nSjI3b0tJelFsSEdtVWxqVklHQkdT?=
 =?utf-8?B?RjdBcG9iWVhWSGN5bE9FNUdtVzYyQnZDR0dQRTlZcGpwSmd2aENvOGxlQlJ0?=
 =?utf-8?B?K1VNVjRnbHNNNHhhcVJ0bWV1cjh0MG5XMXdaTG9nN2dpTnJ4OWpNVzlYOXRm?=
 =?utf-8?B?S2UvUHdTRkcwbm1BazZmc2d6VzdxKy90b0w5ODM5VTFCWEgvc2RYNWtNUkFy?=
 =?utf-8?B?cDZRekZTbVFmWFZRaThIckI0Z0RJekY4YU5aQ05EWEpuZlRhWmlVeFUxeHAr?=
 =?utf-8?B?Y0JjNVlDRG1BSFJCd0J0MXpSL1BTUEQvbFp6aGFJRHZCaitMMHM2YVIzMlpG?=
 =?utf-8?B?c3ZYVjhIb0FiOFlDejc4M3hWZVUycWs0dXNoZDRkK2xmNll3WWVxRHIyUktn?=
 =?utf-8?B?ZEIzYk4zajRwbWI2TURKZG1DL2tWSnNCQlo1Y2RnVHcrQmpjWUVLUXMrQlp5?=
 =?utf-8?B?bFJSUUNNelNTQ1BYQktwSGVmd3FtRTdNZ0ZVZzZkV09kalZuaWtJSWhmUHRQ?=
 =?utf-8?B?aUkvbmFZbTNSU1FTZWZ4NG1Da1hlb3FpNytUUGZPaDNLZk5TRk5PVExaZVI2?=
 =?utf-8?B?bXhCeWRCTENKRGpsQ2dwaVhLYS83aCtKSlk1dUxKbWxFVVZtWk1FaFNFSmhX?=
 =?utf-8?B?ZnBaa0pDSE9aYjgwcWlYTisxTUZTNjlXeTZmOVZxbjlybGxaZitSYVVSTEF1?=
 =?utf-8?B?U1FXVTJHb09wV1AwM1dHS2EyQWJmd1Y5TjNibDJIWktnNmFpa3NWUjlhUE1q?=
 =?utf-8?B?d09BSlZTUTNPQ0pZRGRiWmhvR3hmS3dZTUJLWU5wbDVtWWNHS2hodTIyc3JK?=
 =?utf-8?B?ZnJnWWo1eHRpaURCemYvcjdTeWpuNFhwQnFXM0dXbFdGbUcvdjVCVXVqTXdw?=
 =?utf-8?B?Vjl3MWxzSE9iWjA1YmgvM0JpM0VSMXZadVNvbzF3NXJ3Y00rMk5HUkh3TGxm?=
 =?utf-8?B?WmJOZ3RPN1FpU0luc3A4L2ZyaVY2YW11a1JJUVN4UnBFVGFnY3E4bmI1ZXh0?=
 =?utf-8?B?bCtkU1FLSmNvci9jaTlhRHlDZVpibnlYbDN1R2l3ZzFic2RZWmhDd1BaVG5S?=
 =?utf-8?B?RkZGRWRHTkxlbUNEYjAvd0xXa3Uyc2VyYUMwb3hzR0hVSGpneHdyeUxMUjMx?=
 =?utf-8?Q?Ja2yqUt6mzudQ8tMnhxQlJM506EaUY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 14:23:54.5375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fc0e45-cf2b-4bfc-42f8-08dd6e042b87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7448

On Fri, 28 Mar 2025 08:47:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Mar 2025 07:43:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc3.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.132-rc3-g0c858fc73636
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
