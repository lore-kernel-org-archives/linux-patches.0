Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2BA253B49
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739526347; cv=fail; b=JVPI0KWyxkdh380geM4wJGEIpdq3YErMTnAhu9YQUxtVknsNbdHNF3s9rW678Logdlp8S6PwV0pJ51b/tDe7S7SShEvX5uJwopBmIm2D86YZhFRaN3FPsvO7TZIxSAI7OSlS+fYzwBnnDJCVF3TSQHxG/Hzy9GC7GfnJ3K+euiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739526347; c=relaxed/simple;
	bh=XRF87itbzMS/X8NQt4qJG4Oe+NOAtvuawlfFtKENzJE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VJmoypTk5vXLWBiagL8q04XzMljIaMZpU/lyhWZ7O7PwfJyg/5Rhomqr+p66YtBFUu0pgluOseq3FIKFEUBqM6rIQQbk8lehbwocw3X+dPunbNM2WJ7RRrbSFhSc/XfU02cl9IuDfdGGk575ZbfI5h5uJHAJWjQUyz/dcDlXnD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a9IqWend; arc=fail smtp.client-ip=40.107.236.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a9IqWend"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQrbpwVItHLyEUDj2G1Osmf4LUjWFZRTP3aH4X4DFFlqYyl1YbgslpfAqMZ9Qo6fN8C7PlBYrVsFILJd/j2/AHIQr5RwQKtXgrKbCu/ax/9Q97n5IHooazd3Z5wt32DmmbiTCns/tFOx6dUUe/YhVgHqeVgjZSzla6rItV4kJrba8h5QC8jwjdALlSGme87wQWVUsm2IyJpw2VhyzXF8lhvdY5yZCOaUWmOvGq9KWKXZIgGJVLaKc1cgIMB/aAUUqVP1dTjkWCHWCAlkShdR7i2nkH86rVyIVs4zJPdm0m9VWX3dMVcf5AfN0UHCzaLbkCQoNhXSvPAUZrBWGIChpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4zH65LZV+bJtORLpGyL/t6SjFRB5ii8wk+ViQS1tws=;
 b=YHA5vfEbWLlFBhm76JIcTYQd2qodKuUGSi5JXpaDUUtCokreHC/MBABC5BJx4GheXoiLYO/bUiHQadW/P6gvWsG9+buVX3fYjCErF8qqZSxNNsrUCYUHxM/FKVW69E5+G7qUfFUtL2OuoOXyQQIwee50QUtc7vFFFT8XaUTzcyUaD/x0MOR18WMafaU+YFVaJVSNO980mHZPXEJQ23iATv9TWXXwTybI6tVCmAUDU3F6HU59SrwLRrCguiVAdx5wkWh/chXMnGtxdqdueEa6sOVWnKz3AVw7c7XWSrsR2rDMUDv/YJlfvREjAsHlbqJ6IKirkOlJj8xn+3iF7Z+ZsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4zH65LZV+bJtORLpGyL/t6SjFRB5ii8wk+ViQS1tws=;
 b=a9IqWendLKEl0AF7G2GvhaBx0iwhX1lSRiciA9VSE6xu6+5PrjmwLYgd3XR1GLEeiDEmcR9YIqzSUVLk/4TCtafwxSA/Dk3cG2CvEf9QgGca2/3ig7xIQcjibgmVQXg+jh7oJnveybWBY/iHBVIeE0oIYU3odn7vj3q39w6crMO45ZFA5+1rPevuYbaoVFfgiiCZFQSutWONUeHA25egwa7jnGtJw23fMBvJaj7N1i5vn2MH/MHVUB37+3YuZZtTRti/mHynOhOKsLb0rfqQWriG2D0x7DzF+Y2ZweJJ54HFUoYqjHdraGfGoHBY8kUniMQMBIFXWigDeYARMjftBQ==
Received: from SJ0PR05CA0006.namprd05.prod.outlook.com (2603:10b6:a03:33b::11)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.17; Fri, 14 Feb
 2025 09:45:42 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::50) by SJ0PR05CA0006.outlook.office365.com
 (2603:10b6:a03:33b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.8 via Frontend Transport; Fri,
 14 Feb 2025 09:45:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Fri, 14 Feb 2025 09:45:42 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Feb
 2025 01:45:28 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 14 Feb
 2025 01:45:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 14 Feb 2025 01:45:28 -0800
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
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <29fcd607-3048-4bff-9017-d0dcba5413c4@rnnvmail202.nvidia.com>
Date: Fri, 14 Feb 2025 01:45:28 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 66446593-59d6-4fff-a133-08dd4cdc58e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVBhNkU5L0RmaXdsODhhaG43RUlXdFROdFZSVDBzNitUVFFuSnhLeW5Zd3My?=
 =?utf-8?B?R0dMNkVvbVdCY0hSc0dHU1ZlV2FNUXhFMjJPcEtqU05rbzJwVzRPY2VNQVFw?=
 =?utf-8?B?UWpsaEM0bUtsWVQyVXYwUytYa0VnVS9sbk9wbFBMOWJlSEowc2MxbUo3b1hl?=
 =?utf-8?B?ZW1ycVRweHZ5clBSQS9hQUlwei9rbDYzM3M0eGkyK1huTGRvQlYwY2NyYUFx?=
 =?utf-8?B?WVU0SndwS2xmb3hNWW92VVdGdlo0eFRxaHBDL0ZQVXJmZEdlOStmMHpCblU2?=
 =?utf-8?B?TDUyWmo0OXdQelBEaTFNY2Z4ZkRuZU1UUEkxNDNzQXBWVHF4emNYVm9uUUVV?=
 =?utf-8?B?dy9JMVZoSndPdnRIVmhJcTAvOUNvSk5UZ3ZwMXpWaVJMTkhjU3E5T1gwdzBr?=
 =?utf-8?B?eHRGeC9GSEZjOTNiUkdOaHNCL3hJQitJNG9LczdWcEtWN0xJQ1IyRUp1ZW1B?=
 =?utf-8?B?cCtWTzhxeDJGVVVVeVRoL0JxSUhFUVhSdmIwdW1xQkRxckNVM1ROelJJVUo5?=
 =?utf-8?B?eUJyRFBvUjl4UWx2QUw4UStPSktmektjQ21Sb01zVEw5Z2xvQno5ZElDS1RO?=
 =?utf-8?B?OG16T05JNGxBeTZzS2J0cUk3dkJNajZLZ1JBeGJycnNPSTkwNFZEc05xRXZP?=
 =?utf-8?B?NGdua3ppWmllNkRvUUZkbi9ZdFd4OWtFTHFYZDJNcEc2czNQUmpXWWgwWlh3?=
 =?utf-8?B?V3FvZ3FBaEZycjFYQThPNUNoNnFrUVV5Q0JIQXJ3aXF1RXJVd2dBekoyMXkz?=
 =?utf-8?B?M2FGWDh1dVNnM2lxZDNWZlZDQ1NlcHF5dVoxaVZXMCtoQUFlSld5bUY2am5x?=
 =?utf-8?B?Nzd4OGw2M2RuYlA0NHdlY2pzUndpK2VJWDFRS21KYzBCQUtadm1ma0JkMlk2?=
 =?utf-8?B?U0RtQWhocGpiTlNyQlR1eVZaKytGRFlqQmZhTzMyTW1BT3U3d0paenRUWmlK?=
 =?utf-8?B?QUR3Z1pWSm5xcnZyaHgyaHNEWGw4NlZkZjZENUJPNTR2cjVkMUJwYi9uRzV1?=
 =?utf-8?B?cUFuWHlXOHY3RGlkNnN1UGUySVRNbEFtR1ZRTHQzcVFmQzFtV1JsUGJpeUg4?=
 =?utf-8?B?SFZiaFJJN295elZnLzNaZWJwOEhRdFpVbHRYTkFKSEdsdzAyMGphVU1KendT?=
 =?utf-8?B?V0EwOGZYWUY4R0pmSjkrOXZwT0FWVTAvWWF6SDhEMFlEK2NoTGJTNHFHTnUr?=
 =?utf-8?B?bW5HWlkvcjNsVVFNaVhURCsxRWpGMjBrb2dOakl0bnpldTg0eUR6WjQ0RTRW?=
 =?utf-8?B?elVjRm11MGFpSWp0UlNOWWZENWdCZXJjUlNtU3JJWVVHbUUwclAxOTduTEJ1?=
 =?utf-8?B?WExsTFkzczRyUnVoaktYNUI0WE51eUhTRUE2cXN0ckRtZXdCaWZLOXBNNko1?=
 =?utf-8?B?bXpONEpkNy8vK0RDUWMvTEJGeE1CUFBVZzJHTDBGRGZ6OGJnZjFFS1B3ZGxF?=
 =?utf-8?B?eVpmdXpnck1NQXJWYkhzQkJHbXdkeUVtUm9vb1U0ZWZJcmhLK3lhb3BWUUo3?=
 =?utf-8?B?N2MvU1dtSFZDem15bVJ0bldmSmtLalFEMkxOems4RXFlU3hHK1N2WXF2bkpM?=
 =?utf-8?B?MFVlK1BRcjdzclhPbUxyelRHZTBXSEQ1YjVETDNMT0hxeWNIaGY0L3pFbUtn?=
 =?utf-8?B?TGtHUTdnRHhad3BacVNpc0IwVDUwY1Nvb1Z5YUpEK3FXVkpRNTF6M1dEd0FZ?=
 =?utf-8?B?bTRYcGpHM1p6NzlETjdOc2htSExjNjlJdzlFOHpYNGxTVEJJK05NejRwTlVE?=
 =?utf-8?B?NW1kRm5nWXZ5T0VDWS8rZ0Q2d2wvUFlTM1VJa21xSzNjSktqNy83RURkSnhE?=
 =?utf-8?B?SFEzNGhiU3pwSHBYM2I4KzA1QjYwTEo5cTdNRkFwNnE0TFhUWWtGajJISHdC?=
 =?utf-8?B?WDh1UmhDbnpidHdSdDdiYVVHbWovbGZlWm1Md1Bkell5RUlkNk41dTl2WHVY?=
 =?utf-8?B?WGFLd1FzaTVHbk9nOWtiYytsTUhJd2Q4akZNSEZYWHNRQ0s5SUZ3NVg0cW8v?=
 =?utf-8?Q?YqeW+V3pp4pjA4rOkY9e/euQUjMTa0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 09:45:42.4085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66446593-59d6-4fff-a133-08dd4cdc58e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475

On Thu, 13 Feb 2025 15:22:45 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	103 pass, 13 fail

Linux version:	6.13.3-rc1-g50782d9796dc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra124-jetson-tk1: pm-system-suspend.sh
                tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra20-ventana: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug
                tegra30-cardhu-a04: pm-system-suspend.sh


Jon
