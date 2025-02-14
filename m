Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DAB1D7E31
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 21:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567506; cv=fail; b=gqo75Gmoui8Shl7ft5NEWHwF/sccRHl9iXPFlmkFcdPBjQCGY4OpS5xFLUYVOTyetpfp5RO1YCOnHGL8h02sXsaMcECxYJnI3Z0nW3SOB/CoKouPT+Twtv00xJBgx1k/nBpJ80FP1pRTbZA+bEHj9nk7/MO956a+zdTqDL9vvJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567506; c=relaxed/simple;
	bh=M+3VvoegNSUbuOWpuGrcvxA6rL005C3O8hIQ1elpHv0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ooq/yfDiZyqAoHmJd26DQSBUK0TqMuN0MJ1CimNyRyaK2zSzlxDRyKxRxLeam2pD8x9/XYLdwM0Xdv1s5+X2pCWKWU5DbJ8thX7R+4Uy3Tu4wPDwcYc1zVV8auBzahWAdDArqA4ROV4GFe5u5PXItngphDg656IdhsyK+W/K5Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RXJDJTpA; arc=fail smtp.client-ip=40.107.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RXJDJTpA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOfyn15Jm35V58WxS/86bAJCZk6dcHSeUlAhJ/1Uhmhb83Ve3U2Ek7UJaYEuOCZhY5ht1HrtMellTp0CS1XQC3UzDoGBEu07Th/ayirpKmcOgUdFlY2MBf7TZSP9C1keMht+pLMWX7+eKMzXrTuq0R7OAszHSTGQi0Qkg7p0I12VUgnt3mT8zZWlB1YHB99HwR762K1zDSjBBQe1wdzR4xMSaeDfPSPzXkknd9YzaAfzTUpw+JyITCWaZ/CioWJiUTt9pM/Y1skYSMw6IHzjtRWN3o6oE53eZTnViYW+xE6vakhcFp0M9ofMYGcd8rkNGUAn0d+Eoa9vSuh3alN5hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMdTukBSTopygK46EB3NDr7KkhULSeC0cFDJc4IkNck=;
 b=BqpLgswO8E1zsYz+52z+UkVmayDM0qZYJ9hBZDbQWh5JxFz2zML05/hHuUx92liAC6HIzyqOZvXRItMYPfZJvS2H5c0Aa2lpBmBSF9UuNWvZb1kMLLifI8h5SZxXRbethNOOEddV2VHB387vBG3vf0Q/A6cUYpHyGywX1yTtZmqTJMMhwD9OuGC9aLv0t7Q3OuL5LlD810SAC1pDaJ4jFg1q6BiYyyTTMS5ZUunYpmViyOc0P8bgnrSLLmJ3htehq/mwwqoVP/ZhLgz2lsHsCFmUO8ItaDD2GKkX6/IDVZeOGcv8n7ej4clCuZc0DAJLy8cYCrsg5Divx+iV7uMEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMdTukBSTopygK46EB3NDr7KkhULSeC0cFDJc4IkNck=;
 b=RXJDJTpAMtwJmfIYArONnoN/umUgywtSTExXT5EhJXy613z1jeJmq07T2DKrfFXossZIqtcHqpZDPv7BPVflGNbq0AAIa/M7V5dm5ejpx/3oHn/8prm1XrKaSpggc26a1z9A0E1YBJ61CkbzqtmP+zbKu5+y7Pld0NmOK1xWa+rpuvuH04JEEZW5in6rZlNHftF7chSeIzm/OzGi7mQ5XjFWGVanH36dzIGkmaYwU2PE7YfKdkkLp/N0VaAxBg595m+MMGn/ccQzYJ/vo72iImtPeirqIwv58pIHs4Wp/2LodDClERTYi7vFvkrOxeKjSrm2f2+gDp7oKmAAEgqZfw==
Received: from BN9PR03CA0032.namprd03.prod.outlook.com (2603:10b6:408:fb::7)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 21:11:38 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:408:fb:cafe::65) by BN9PR03CA0032.outlook.office365.com
 (2603:10b6:408:fb::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.14 via Frontend Transport; Fri,
 14 Feb 2025 21:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Fri, 14 Feb 2025 21:11:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Feb
 2025 13:11:16 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 14 Feb
 2025 13:11:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 14 Feb 2025 13:11:15 -0800
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
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc2 review
In-Reply-To: <20250214133842.964440150@linuxfoundation.org>
References: <20250214133842.964440150@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <26019cb1-7c61-4e66-a4df-823d00999604@rnnvmail203.nvidia.com>
Date: Fri, 14 Feb 2025 13:11:15 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 36cbd1d3-7994-48a8-7993-08dd4d3c2bc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?anRTMXk4WHlHSDI4R1I5N2xQMkp6STRzY2FhU0xIeEFBSko0UVMrZ3RNWUNm?=
 =?utf-8?B?Vk9ZLzBZeXAxL2tFbTVvNDdNV2gyY0VJbzFxcDVHaXl2c3dhb0JoYXBuMGFm?=
 =?utf-8?B?WldINnNPMzlTakExd2JWZEJtS3YrWDl5WGxseHNpenEwc0ZqNjJIeXM1aklI?=
 =?utf-8?B?cGEzQU9JbVZINjlvTnZRRHZSdDBlaFhidjlCYzk3Tmpvd2U0T0tmL1RhL3Zm?=
 =?utf-8?B?bllCc01LZ1dJNTRab05TTU9hN3dJOHNiV0tlVkpZbFR1aVY4b25tRFNnT29F?=
 =?utf-8?B?UitsaEJuV3NaVGtnMUpQekVHMWZlc0F6QStuZHFqeWJyME9IR1MxbDUyeGta?=
 =?utf-8?B?WnV0bEtoOTh6clFweTd1RlNVRWpKYzNGZ1Zib2s0NkJ4QzJOZ2R0YlUyZ3lu?=
 =?utf-8?B?NkJEb2tNRWEvbS8zbVU1SUJIYVY0alRvUWEzWkJ2dWdnWldGVHo3YXkzaW5V?=
 =?utf-8?B?bWorbGQ1aTFub3FPencwNm5OTXVGWldYdTNkOUFSN3U1OVQ2d1BIdmFaelll?=
 =?utf-8?B?dEFxa2RkSExxbURKNUxUYjlRbEpNTjI5VkpPekg3T1pzQ05wS0lrdXAreWYy?=
 =?utf-8?B?RjFOcVNncWNoZDNkRldyZWR4c3hCeDk4VXN5YTl3NkNBampodkNFbnIxbzg0?=
 =?utf-8?B?am9HUHhqc3drSUFQYlJmQUlWcHIrVk01QVdKa1dTdk8yNmQyM0tJTi9PT3hS?=
 =?utf-8?B?NjdBTzFxTHdoaHh5WG1tU1VrSlplZE9rbVFUWVIvQXRuOEJ5a3hWL3B5OWc2?=
 =?utf-8?B?SmRRQ0Nzbzh3SmVmcmJSRU1hc3F6VFpZRVE2bTZqZm5XRmxqdnI3MlE5a01L?=
 =?utf-8?B?WnVEeFhUYWhKMlpPMGoyMXkxNjZ6VDVDSERHSkpnU2VHSEpia2lxNEoxY24x?=
 =?utf-8?B?MjlzaGhyYkhKNDR1dVZNYmdlS3pZTk5BcFlxcmM5OFo4SWczRE5SSWRXMCt1?=
 =?utf-8?B?dU9TQ0FnZnRNYzc5RU41OVNRQ3ZnMFV0R2ZLMUJMV0hwdG5JRllBbHpCVVUw?=
 =?utf-8?B?V2R4R1I0SUJmNzVkaUExZUtDTXYwaGtVbnBObkdNcE9aOFcvLzhTdnE1czRj?=
 =?utf-8?B?eDZSSXd6VktIUTBGS3RKUHhFT2h6c1U3K2RiRHpraDNwUFdYRXFkNEJUdVJP?=
 =?utf-8?B?bkg0WHNXQUlNMG1XTHB6eGE4QVR2bkxKN08rVS9mTUo0UWlQMlE0bDFiNmEv?=
 =?utf-8?B?VWNZa09mNkg3NkpuemlVUnB6Tk8zTHpaMmlKaklpMUtPbTIrYzJZREVNWDJj?=
 =?utf-8?B?VlZXTVczQ09nb1VSZTJ1TnVoRC93T1pWVzdWVzhDQjNIcG4wWWgzQVNVTkF1?=
 =?utf-8?B?Y0kxZzA5UEF2bFdPNEIwUUZNU2VFRGpGNHlNM1B4UGRpeW8yUnljbVpoQUQ1?=
 =?utf-8?B?dkxsaEZxREJEcUR4T2F3aWlWQjE3amlmMlpnei9kWnY0SHBzd3pBQ3JwV2Vk?=
 =?utf-8?B?VDd4SGtXdDloUytUcU1QbVZLZXpEdHVLbldzWllNWjJBSG1vZ1hoQU5tSlFJ?=
 =?utf-8?B?cmw0Tmx1QlV0T3V1NHhhbHByRGlrczRHVG5lNkJCUGsrOHFjWU5uR3lIam5l?=
 =?utf-8?B?c1JydUc2NWs1eEMvblVneURnRGlldE5NWXNiS3d2SEU3VklIcklGQmRiSFNU?=
 =?utf-8?B?aTZiNXBsSjRQa2RpZm1RL0JmZjM1ZVRkMUdzYVAvLzV3VzgzdmFqNUx0RXJX?=
 =?utf-8?B?WTY3cFlOSTUrNktaMjZQL2xTcjZwRU1jYW02QkxNWTYyZWhKNE9Cc1ZjeUpP?=
 =?utf-8?B?a05iUGhpckVCaUpZZDZyc1FRbkU1dG1PajJsM21QRTZycUJPSERvNzVLM0VQ?=
 =?utf-8?B?NmdWcTJpOVJMMTNwZDJEMlVPL0o4NGpCcXRDSStmSUo4bUx5N1VsWk1mOUlS?=
 =?utf-8?B?NGQvQXMwbVozZ1hlK1BaUVVtWVN5eis5SVF6aEhENWoyc0RIYUhEaCtJU3Va?=
 =?utf-8?B?RUZwRmQ5bndmTG1yNGpsQ3FObC82eUxWRmtJcDUzdEY4dWcrU3puTWVObnN4?=
 =?utf-8?Q?H8Fo1sFsOxRYVwa+WRKYWPNh1rsbC4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 21:11:38.1989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cbd1d3-7994-48a8-7993-08dd4d3c2bc2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128

On Fri, 14 Feb 2025 14:58:52 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Feb 2025 13:37:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc2.gz
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
    116 tests:	107 pass, 9 fail

Linux version:	6.13.3-rc2-gac5999a6c007
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra124-jetson-tk1: cpu-hotplug
                tegra124-jetson-tk1: pm-system-suspend.sh
                tegra186-p2771-0000: cpu-hotplug
                tegra20-ventana: cpu-hotplug
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p3450-0000: cpu-hotplug


Jon
