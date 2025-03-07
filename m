Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA7920E011
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 09:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741340864; cv=fail; b=RI2UmCmfd0M5OaB1JJC1L/kf46EunglpPgyS2zzGUAg/zGqj6WW9f1sfpjKQWfoXx2IVd90NTNLN8NCRLe5EFh4EYfpWKkArJQyh3CnYq+Ib7mBSntyrAlfuNLCvk6eP4dHKqKTQlvdKJ9Z7c+uDtXVhs5h7EEdnRlKss/6ktb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741340864; c=relaxed/simple;
	bh=E4tSTKmEgx84YW2pgmIJq1KU/EUKhtdD9pexUS6Smxw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=LSmuc48mvNYEZ51PP7MvL6j8yxeK7KqKKLOkFeNEMqYkp3545IqaY02WPEnHARmMx5h95ifgScY1gOooGUwf8WHKtV3UkKvIMEGYSpQsVJcXFYnWNnsNRS2HUzoKQLza1Lu9F9bF4DKpOFSgYA9fm1LHjfMAqIUQ7Y6cDzgApNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EOQZLNd7; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EOQZLNd7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EO9Esyty+O8JU22QD0NcmTBlW4BoFLRN4yGZWq4rJkdH3DoPJJwHETYHkovPulxWzTNo6lPDSJrL0BdAy9tepKW/Wao4h1rXG6cn6BDF/Bol7uXWO73I4cPzTcuEkniZIsyPCuQ+0szHhp+UWiVgiRzF8HMFcVZ9/+dU9ptvdU73crEK5ObVQma5K3VmNdKuhepu0I8prxGVYYenhuXjIjtBcrwaQMWAZ90A6SCicOCLb85WHkihNPBFdB8R8VT2o/8XiSH4Y47wZCPMeJIZDynwj3f0yAPIA0NVecy9oUh8YJTI2GKepsVe+uXZYU3maVXICWrC1+jtVE2GvXY6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBrJAOOtbOf62MQoQf8nETWc8ZkXrw8H5CCZgXIi8O8=;
 b=EUGDrYCdnd9MOV+HN4OecHXCHYWAuzpXSVnQtxP3mNB2uZxC/bVzThWW271YZd27JdAPFtKT1MCxgp5XjvLpjf0derRFwFyxkYIqz/PMKHy1hZi1UYR052mwmX4mJHWQN1VVgP8X59qwzZSMUYuKalr3WhLZVGy/tnNzV88COgYq0/E4/SLpl8Bvu6/5hWEctNEaCCkl/6QLmx8/6Db77CZ6PivWmTVnHrwIZ1EX7RFVEyaiM488xkP1qzw5SucVDdFnSLpyuhXxdM9LuIUHmjXXMSshHmyouH2QmKp5o6oieDl5awQimOo26ttsNUgNQkKNPlTIdXBjEvw97Mh0VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBrJAOOtbOf62MQoQf8nETWc8ZkXrw8H5CCZgXIi8O8=;
 b=EOQZLNd7hEXG5wFXYLMKCAJq5n9PXGY85QXyy9Kapa5MgGTtC0RjG+JKUn1Nt6GnQn3jxBuVDnMyVp8C/rstswDF923vK4nSgiygq41a8n+jz3wvjcxGQro/3u4OSVlHfdqAjJxypfPkpoVGaSGRMh6pHt2OXCKZFjqdqvmsoGvTRuXakRGvKTqe9mmM9KsCSbyVBMT/M2vQMzpDtwzRbD2R5OfZfO7zp7879xaGlqwn4E8gnGZNPcpF50S0L8XlH93NupvQoI4QUqOh7i/64VpyMXEEOdYguhHQKhkjg0v8TA4rtcZQMxJouTYmGnrUC2bfoOBclgn0qh96pzsPhg==
Received: from CH2PR03CA0009.namprd03.prod.outlook.com (2603:10b6:610:59::19)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Fri, 7 Mar
 2025 09:47:39 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:59:cafe::bb) by CH2PR03CA0009.outlook.office365.com
 (2603:10b6:610:59::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Fri,
 7 Mar 2025 09:47:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.15 via Frontend Transport; Fri, 7 Mar 2025 09:47:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Mar 2025
 01:47:28 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Mar
 2025 01:47:27 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Mar 2025 01:47:27 -0800
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
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
References: <20250306151416.469067667@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <25864adb-0a9b-492b-975b-7361260cc20a@rnnvmail205.nvidia.com>
Date: Fri, 7 Mar 2025 01:47:27 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: 07185c16-a5d1-4fad-a7d5-08dd5d5d1974
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFduOTV5QzNpMksvekFuNmovcndJNVU4YkI5OUZ6SkplQURpa1pIR1Nkb1RR?=
 =?utf-8?B?UUJmRHlpMlorTkZSNFdSbXlwdTRTeGhtcmJtVHkvVmUzb3Q5TE5kVDBuUTNP?=
 =?utf-8?B?N0RjSlhVUkVienNTd0IwRVZyeks3QnpubThabU5yb0tNR29xWjVwanV5U1Jz?=
 =?utf-8?B?L0t2dWNldHEvU0RwbmxJbnNFU0FYdmlRSnZIQUt6dlRubjU1THdVVWY3Wity?=
 =?utf-8?B?QXdwVVhOaFZ0RUdsZDVabyt0NS9uR045eDRwMWZyVjl5SnQyS2tDWGh3WjMy?=
 =?utf-8?B?L1hpMmtncVowd1J6SE9jYVBLOSs2eXhLU0ZXbFcrR05nNm16ZmdZVWM1ZjJj?=
 =?utf-8?B?UUJHTDdjK2pjZ2dPNExYaFRGOCtXQndIWjVpU2hnSm5EVGovaHRLaEU4OTVG?=
 =?utf-8?B?M1o3OHhEMThqQ1RXcXdBL0g3V0FBeStHWEZaS0Z2RFRGcVRmTEM1M2MxV1pC?=
 =?utf-8?B?ZTZ2MVlRWUhKdFhEVnl0MUFqVUVwcTJadXBFS0NJenpJSGVQVUxPNTZINmpn?=
 =?utf-8?B?ajNkUitnYlpnQnE3aVMvczlRZ1VnU2pkcmhmR2tBOHFzODhZcmQ0SlpQMnRB?=
 =?utf-8?B?NkVwamwvTFpBSHRyZjhJMjFnT3ZPQ04xSE1hYW9TVDNrbWZhOGMxZVVzcndm?=
 =?utf-8?B?alVOYjJNY3ROV001VHFld1VDcU9NbFZJTkZNTkNtQnZmUXd2Y2RGQUpSaVBW?=
 =?utf-8?B?NFNBbnY5aThrUG81Yy92TGRWSS80R0l0ZnlHSzkwL2w1bmdZYmhyOTU2d2pN?=
 =?utf-8?B?c1ZteWRKUUZSRmtUT1VCeEZTQjhrYjBhRUJQbEFtc21rRlJzZDh5a0F0WnhB?=
 =?utf-8?B?NHNOeHJGeE5IUGlKQy9VaGZOK2NCRFRkOHA4NXhnUkJwQllyUWVOTENMZTZi?=
 =?utf-8?B?UkQ1MXptbGNibE82ZGxzR0MwYjVBWEFiMEdIaFBTRUNHWWFvVndvRmY2TkxW?=
 =?utf-8?B?SDJoZU9yamo0eURlQ25iRnhvSDhORDBQVUUvdkFOckhNMCtORUMrTi85MlZ1?=
 =?utf-8?B?SzJiS3VTQUZLdnhtamtDNWZEUFFFSUJaa0pmSUR1SVcxclFaSUIvdDFFcExw?=
 =?utf-8?B?WFhaeDh2ejN6eUZ1WDZrUEFOMTNPSnB1WG93bGcvVlM4V0xUSCtsSzBqcG14?=
 =?utf-8?B?TUh6ZXdCWlRWVFdaSjNZNUdvVWlwamRqdWN0elZ5R2hVYlJXdUFONGVnZU4x?=
 =?utf-8?B?eElqNlZpN3ZuRThXL3I5ZVlaUHZFV2FBN2s3Z0lDaHJMQklzV0dzZWtTa2pP?=
 =?utf-8?B?ZUFCVVBUaVhLMDd1eUhoMytPMDhxYnZyQnNTVlJxb2lpeTh5d0FtRnZYTVZT?=
 =?utf-8?B?aDhKU2htVEhkS0c4bDA5ajVxT2xGZGhlbExzcVFVc0o3YjNlOWVJMG91djNW?=
 =?utf-8?B?dHh6Y2tDRGJyazFlcG9weElqN213UXJrbnFEMC9CTEc3TzZ3b1l1eHVvVWpY?=
 =?utf-8?B?ZHFITjNXaFh2ZG5MU0l6UEozMzZEcWRDSlJxYWZRYkhTWHE1NTZFRFpPd2pK?=
 =?utf-8?B?VGo3MDVlMCt3L2U0djZWR0s1QjRYUUlMWXNiekhjbWVuOGl2ckM4QVlsUGRQ?=
 =?utf-8?B?YmFjZlBCZEU3cm9BeXVVK3NTV0pyY0o2Q21jeHdlbmNZRkp3OURhOTBKNjE3?=
 =?utf-8?B?d1lJR1BJU2ZzMTRsbmkwaVJwSCsyd2xKT3ZmSzJIanArSmpzanBxbWs3b0h4?=
 =?utf-8?B?NEZLaEJVVitacE40VUFqblF2ekV0QjlvaEUxS2xPcTJHc21FdzdDL1R1WFV2?=
 =?utf-8?B?K2F6VGFoYmJiOElkckVmai8zb3R6MjRONnlTU3J6alJGcXZFeFZOR1B3RFJx?=
 =?utf-8?B?dlFNcGk4MXVncUZzSU1SemhtSHBVYWlDb1FMMjBIV2xScFpWZWJON0p2NDl5?=
 =?utf-8?B?U1JJT1VDZzkvdnJKNkhscC9HZVRNcFFHM1Z5YVBRcG44SFFyREdCNlVwMG0v?=
 =?utf-8?B?dEUzS01jVFBZSkZkd2NGVGpIeHNFUHU1RktvRXkrTjJvUVpHU0dtdGdrZWVU?=
 =?utf-8?Q?kooCxb3UVXHuHGu6XWa3fwA5Dbb4JE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 09:47:39.5176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07185c16-a5d1-4fad-a7d5-08dd5d5d1974
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021

On Thu, 06 Mar 2025 16:21:02 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.6-rc2-g3244959bfa6b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
