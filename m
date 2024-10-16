Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255321E3DC
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729072937; cv=fail; b=eEIf0cuETMPTk8nDdg/1PYh1m1AWuO6T4XEbYON+Eplg+QabpxrbLLPYyah2LIfWvmSWXIGQipQVS0mtt7PffES9850y4dJoSOS0LqVY4skx9Wae8r8dz24W8V8WIhussP8u+sodU5KkF0eZy4gwHYTCJvKuYtZgrX4jU6QwVho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729072937; c=relaxed/simple;
	bh=TZ8u5q4SKay/tHsv/0ZD/WvBEwMZD44xmTkaoNWQzWE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ugnESEoBpcr38qq3rcRrxpTF8j+ENMnYfVb3o0nhnaEg/kqh+TnaPIijU9e3yiemI1dDH8qJEZMwy/0o/s/PhZTMh4iqreOftwZLalVNwngix6arHX3j957gl8Tl21oRVI9TnN66HUvFoyc/6PP3TX6PKl4D8dLz89Lw6XmjTo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gH6OAptN; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gH6OAptN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqfSzAz+ieChLuLo0zf/clQUfSnQgR3+JrGhd6TmfSsoepSw4lvEXN5ERyP56iEMypu7ZOQK3EVXy9bTIktboZCTJDQWlJbuiMEgOIQpXQIQFMPOLmA6xAJkqIhHj5W2BAjtwdB9OOSCffE4mRoWvvo31kU7iFKt/gqOAGxmXubJyGTMVNkviZC6bsWtLBB8ntzQTWGVdA9bOJZLRtq9D2cB1JyBD1C1lCnIKgu36/npvza3RFJ8QFXYypGCs0JLn1nMZHbM4390+29m8qd8/8HD3W2o4rRSlSt79a3saqCYxBJJXWaKbMlXGT+V90XI6Ushr+0AYyDMhaI00PXbyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qdxdHGjixoBpQQfv64yaZxVo6ZhE6tzZHFsNj0AhEU=;
 b=DEO+OS0BQPKQ5jrj46sWBDZ4+2mK+RaEPVveMMQADODfAs+ktCSmQaRzlLH8W+ye01UiC3gaMxm6/9j4gkV9+slXbGufEmlRmJuna9M9PG5U9FVfieOaj1ykvZRriMmgdtad2C1JYBoZCT/sEx5WdDruIah2vL5sw+3T7C0uDqqCuwcI5S24xpcPQhKS9TSE3Al6555axEEjDt/ln90kxcbgqeXEVgiM1/hbbDAMYjmmuLLG6havoCPWRSBwZaRZxXmZk4nX+ZcpmxzpsnzjWoQnR2BIPpaLutF7FQfCO3TUmAS+VOuPnPwQNJq4bm8l2EM2JbOYhegNuVJcrfPMxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qdxdHGjixoBpQQfv64yaZxVo6ZhE6tzZHFsNj0AhEU=;
 b=gH6OAptNXY7Erkhp5esHZYmpBtEnJ7gE0VlZf4D9xIaxXXtUrW2+6VYvWc+fgVxcG74ZdnNrg4/eaKI4P6QtC6H9nkCe0ihNKKD/Fhk2Uj0xBwD8fKeXbuJB49jKa1RsZKtyDumZBV874DqMmDh9susKN0yHZJQvHnPrlEd8aT+44thDzVx5VL4/dOntrFn9M/HfpbOJ9TASBKnLLoztoPKI8+cPmxrsVUGUO7FrPD7Cw+J9ul/wYMml6xep9Z1t2qrQeYlUSRooQ0io2XJBEIV7jn0nabxqhxfygyCHsySpjt5lNZTLf9n6SXbPIPlMXg4gXFBAddqVnOadpQGMKA==
Received: from BYAPR05CA0097.namprd05.prod.outlook.com (2603:10b6:a03:e0::38)
 by PH0PR12MB7470.namprd12.prod.outlook.com (2603:10b6:510:1e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 10:02:11 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:e0:cafe::dc) by BYAPR05CA0097.outlook.office365.com
 (2603:10b6:a03:e0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.7 via Frontend
 Transport; Wed, 16 Oct 2024 10:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17 via Frontend Transport; Wed, 16 Oct 2024 10:02:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Oct
 2024 03:02:04 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 16 Oct 2024 03:02:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 16 Oct 2024 03:02:04 -0700
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
Subject: Re: [PATCH 6.6 000/211] 6.6.57-rc2 review
In-Reply-To: <20241015112327.341300635@linuxfoundation.org>
References: <20241015112327.341300635@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b64adc95-191d-45e2-8efb-acc139935f89@drhqmail203.nvidia.com>
Date: Wed, 16 Oct 2024 03:02:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|PH0PR12MB7470:EE_
X-MS-Office365-Filtering-Correlation-Id: d8e8feca-9276-4e58-52c1-08dcedc99a75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTFrMllRbmFyUi9NbVJRV1lhZUZNczRBU0h0Mm1jdFpSNGZ0bXRUQXU2aUFH?=
 =?utf-8?B?aXlCMUlWK29CR3luYzJ1YXl6a25iTUJtYkpuWTNKU05hUVVvTCt6a3dHQk1j?=
 =?utf-8?B?OHRNRjIvOERKLzJ0VWdJVHBJY0hpM1piZzZYbnR3SmtmaWhEejlQT2IxWlcr?=
 =?utf-8?B?eFdMK1AyTldGQVVFSnJJb1NpUWV1djVPTlRDVE5RV3l2MkJoWkxVUUhvUU1U?=
 =?utf-8?B?UERUaHNZZmQ2WmRpL3VJdkNZL2lPRUQwU3JkQzhkSFZuNVhFWW1RenN0QXg3?=
 =?utf-8?B?K0NJMmdjY2xTWW1qbUhRMjlqdU1TR2dFNEdPYXZGVHZZWVR2S1gwekhmekh2?=
 =?utf-8?B?azYwMmVaRXppelg1QVp6QzgrN295K2s0UGJqWWdYV0JlVXVzUW9UakdzL3No?=
 =?utf-8?B?R0ZpREtuTXljMzVHeUJHSzIxLytkWUlrT2t4cExXa1ZHOTZ6bmZLLy80SlVx?=
 =?utf-8?B?bkFnSng2ZUhRcU13dzZtYldNVmhkQi9DdTBWT1hpWGVzY0o4S2xweU1aY2hI?=
 =?utf-8?B?bUdCU3ljTXFTbXpYYjI5SXU4ZUtmdTRaUGdpNGlOVmVTSklGSzNOcEl1aDFP?=
 =?utf-8?B?Z01pQ3FxQkNEMUovZ3IzaU9QVUtyeW9nZzQyQmNVaTJiYm1neGRIYmFTUHVH?=
 =?utf-8?B?czF3ekpJWTdkYXJCbThRNFd6ejZRWmFrM2RxeXkwTm12SG9TU3JFQmRzZkh0?=
 =?utf-8?B?R1g5aGYrYS9wbjFGODc5ZjYzUVJuTzBrZGczSCt6NXZCKzJjeUZMMzNqYlY0?=
 =?utf-8?B?eEdMZUx6TktwOHJRdTZPR0xBdTg5WGNueUhyeGZtNkM4RlhYRzMxanVFYURu?=
 =?utf-8?B?Z2NoSWY3bUpJOUNtTjc1a3l1MER4SUNlMk5WenRyNWlUc0h2RzNLQnlsS21I?=
 =?utf-8?B?emJudVFBV3JVZ0N6Z2ViNmE2eUZTS2JTZU54bEtSTGR4eW1yQUFtZHBqQ0F5?=
 =?utf-8?B?amVJU0VmSnVxVWpvRXE3K1ZJTG4vSERsbTVFbkxUSENEbm9UcWRsNDVBaWY1?=
 =?utf-8?B?SjZmVDZFTTY0ZndzQjFxLytONVdEazc5djJWc3dZN3RwWVM0SzBxZXhzUkZh?=
 =?utf-8?B?VDFOeGI1TUdRK1lYZnJjb3lDb0p3OE5YZ2pwTVZvMHVOdGtaT1hEK3R2N2h2?=
 =?utf-8?B?Ukh6dnFNdU1Ldkg2U1ZreTJvWHJ6UFkycXhiMGZqSldVSHFrdENBaS9wSGdn?=
 =?utf-8?B?L3RiTzIwcHJPM2dxVzkwL0VYbVF4ZUg2MElrVlloaHlJS2FFcXVGays2NEZw?=
 =?utf-8?B?NXA2NVJkM2V1T2t6S1RsMEJuUEdOb3VFRUpiUTFkU001UWYwVHJwWUlrdEwr?=
 =?utf-8?B?TWg1QlNvYVo3ZDYza2syM0FBdEVRRittcXJsNVRFUTJyTkxLNlY0M0UxUUN3?=
 =?utf-8?B?S2oyMjZPQjJ0L25BUUVpTStLNFRldmhCZGd4eC9jWkhtRGU1Ym1kTGZWb0dT?=
 =?utf-8?B?V2FGZ0lrbUNWbkhNelRmUVNIODk1U0ZndGpKZzhCZy92THR2Y21VbTZxVTFj?=
 =?utf-8?B?cHhGRlEvcnRwZW9FODhUTDlUdGlQRzZZcW9mdUh6cWJybEhsRThhLzJUdjAw?=
 =?utf-8?B?Ynk2UXYwUkJvcVRFV0V4ejlKMjM5M0JuSS9DRDdQQ0dTTysxOFc1Z1VyY3NR?=
 =?utf-8?B?YzhXeGx1U3RpaytLMXpBMzY2a3laOUc1ekxKOXc5ZVZONTdXbFBSSVJ6SmFn?=
 =?utf-8?B?Y0U3YzkxZjJKU0dDRDlURXA4MEQyakMrbEFHT0N0bWdMM2dOOXVuQmIzd0JQ?=
 =?utf-8?B?eFYvV1BKYlZRTVlRc21hRk53aitWTjluSnhqMnZJV0hLQkdydzBmK29hc3lh?=
 =?utf-8?B?M2hiSG1sWWx0bWY5b1NqZ1VKSjBINC84K0ozaDVzTmZsUlpRS1IvaXZDY29X?=
 =?utf-8?Q?uX3nnQw8fNhE4?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 10:02:11.4888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e8feca-9276-4e58-52c1-08dcedc99a75
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7470

On Tue, 15 Oct 2024 13:25:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.57-rc2-ga3810192966c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
