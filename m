Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013060.outbound.protection.outlook.com [40.93.196.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75492BFC85
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764695691; cv=fail; b=jNPJwmqlUVd8sbC1NJm8RqIEbO7nvZptM4Y8griRLzNUKL8Kfvgs3mhsGgdkq7euEF55h9QrUEpmUnnh0CU1IrGYDIffSPf43KFyAM6xf9iboBc4/oxFiiQ4NRmwO8ty+yOS7EiaspD47d7SB1xBqAcgRtUcLSeCxg7TX5zHq4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764695691; c=relaxed/simple;
	bh=+PrS61dbnv3cHyUNtZKMXSK957ocicK3X6a6/6vPaAc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CjotdWzRCV5J1vQ/XJ6j8nS+dryGlihMV8yHoKG/OVFQpMz+Lgsbq5EhA7KuM86zjcWNmfPdc/gFVWZP1annCyoBKFbfuQIlk0CxieATEvP3MEKRCgbUyVcQOrhNufTgXWUerBw/RkS7zj0fzF7Ytv/642tpuTFpaW0ulv/3Cx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HHkvPRMf; arc=fail smtp.client-ip=40.93.196.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HHkvPRMf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbBbEYfyiCuqQ5GlG9FKtdUtCSaFTsQZh/0cak/e5tRs7rMrtmN+oYSO+LivkazIKJbP33NkMbmxHAOBgSeZ9CDu1qqvPQBt0EU6tKoIVUoYceBBmeNOuagHoMRHccJ4ZyJaY4/8RkODm1WRRaZ0CKe6DL2CBNoOhUe5fuRZCWo/LVEoITudmTagX+rOYcjMNk/TS8dX4K3FsoG2EELOA7rQFd82FORU+XS5XdQpOUAelyMg+txD/XhwsXKJHqaNCq73z3GRKI4VhlcK29x2f7RQdjk9jhxeT7clQob/vLW4g8IUd46APiqskomTYwFzu1LMcl0P1YybMye72EF+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORsOliOb/H3CRdr7qkSN/i3O9Ur8DzqvwFnYzaFCDL4=;
 b=BpWRd51RcndmYRIBol/lDG1ONApsltBhOzncJIem2MAEm9c8Y6xa83HvLKXa2m/3oMllLabpY69YTyFVSE+UutRJJXQQxpavZm+8avdldqC8qDK7/JRAKcQaSlfVPBrzaDWF+0FAZDcWega2sUXVW+6WT0XAz/eXblkCYA+o6N2qWgHvRcb+/6QGAgyCo58sDQktWo16G80QRGoNIGCOvDn+PQAsOk5id+uzDu8SWdjW9i9Ip52WO+oFICSRPbu2TR30lh2id+lhKc85skdoCrfFBnNbgLHmTiLytF9eElWOknUL6HtU3+Oey7Ur92PzZZUMF3+S+rteUUUq18lLnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORsOliOb/H3CRdr7qkSN/i3O9Ur8DzqvwFnYzaFCDL4=;
 b=HHkvPRMffuZywoivEY+4ypip85hSCeu/UJuBNOlupnx2HbuTNJ1tw7Wov9g4bTpaNbp8+xPl2gMI1ZTkKYDs0dAe7qRw0tqYpP4qdFtlZo6/wsh+7YWSCUVOoJHNcbAx+8bIh8zH29PyJBQajAs1bOm2J9glsET9y44BR82+4UTHsvzpabwtQ/Y/d3Cn6l934fuC4rO6ZBDGMA3RJE1bwVf5YTDrx6yV753fVO/mej4a2KHnU/VizTLq1j9/Rlf719LLRbuBkMEcWdJv7akqc5GK276AveJBI6YGkfiSl/86zaRPPwM70g0ZbGPRMQPRLW6m9siYko1X7+4E3/prmQ==
Received: from BY5PR20CA0033.namprd20.prod.outlook.com (2603:10b6:a03:1f4::46)
 by IA1PR12MB7663.namprd12.prod.outlook.com (2603:10b6:208:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 17:14:40 +0000
Received: from CO1PEPF000042AA.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::75) by BY5PR20CA0033.outlook.office365.com
 (2603:10b6:a03:1f4::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Tue,
 2 Dec 2025 17:14:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000042AA.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 17:14:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 2 Dec
 2025 09:14:11 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 2 Dec
 2025 09:14:11 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 2 Dec 2025 09:14:11 -0800
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
Subject: Re: [PATCH 5.4 000/182] 5.4.302-rc3 review
In-Reply-To: <20251202152903.637577865@linuxfoundation.org>
References: <20251202152903.637577865@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <685f7edb-de06-4ca4-a17d-b3cd61b98999@rnnvmail204.nvidia.com>
Date: Tue, 2 Dec 2025 09:14:11 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AA:EE_|IA1PR12MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: bd2618d8-0a88-4f18-0b95-08de31c64759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dTBCcVJHWVcvdWJHZDBOclZsU09uUFFkTzR1M1pHUTFsdEJvUGxUaVZNcjlh?=
 =?utf-8?B?OS90QmhiOHcrQkpnaks3dEwySzhTWXg2T1Nhczh0TVJyZGh4OXZaMzdWS3NR?=
 =?utf-8?B?Z0ZCMSt0OEJMYmxBWHdRZ3BFZmtlVUorV0xaSlVjbU9MakxvTktQVFhvdDhU?=
 =?utf-8?B?SWNsV0xhZWRLNGpLaU5saThKUjN0T3FmdmVabHI5N3lBN1dSS1V1dXhqWVZL?=
 =?utf-8?B?aVlTbHo2K09iSmw5aU04ZXJzcWxBSXJyTkFRNGd1VG4zS1A3SXJoNW52ZTJ3?=
 =?utf-8?B?R0FFR252Vm54NFh3aTNqREFnR1Q0NHhDMWFkQ1RjWnM4MWtxNmJ6WEVIem9k?=
 =?utf-8?B?eS9FeEJJREc2WkNhbXpVWlkxOFZyS1FteVErZ2FPMW0yZU82WUlGVnpWMG4r?=
 =?utf-8?B?a2JnbUdINjl3QUVyVlNJYTlWOGxkUldBanp3WWFTcnkyQVJjaEFEK0NPTHFn?=
 =?utf-8?B?SmtGaUNDMmZzVUo4UU9LQU8vT1VvZDhaNmtMdElPRGtCSTVmS01IbUNLTGgy?=
 =?utf-8?B?NUYzTThaN3E3UVByVGQ0bVN3RTgzelZmbGxGSUhNVmxzV042a1N1YjY3VnhG?=
 =?utf-8?B?OExTdHZ4YzZ2UFJpdG0zSmY2a1BhS1FQT3BZT01vaEZKc09PRjBpbGV5aktK?=
 =?utf-8?B?SjlXL0JBb2YxRWZaZUlrZWxDb2h0cjZOb3JWMFloeFR3MHdQWVc1T3loZTJK?=
 =?utf-8?B?UktXL2dPcXZZeDFtRWxYWHYvcGJrYk5KTTlIc2x6djNxUkw2Y1VVTy8rVjBk?=
 =?utf-8?B?d3JGTmVWb0VPVk1GbUFYeFlPWHB3U3lxUWlHUitFaDVBNG1iVXlyRE5YdzFp?=
 =?utf-8?B?SkRCUFZXRURxdnRpSzdhd3I2d284cnhwcGpyQ3pYNG4yQkQ4R2UzZmtSMGpG?=
 =?utf-8?B?K0htRzM2ZUxxVmdoMGFTaWJ1Rnh1WnBpUXloUWlINnlBMm5yRUdXTE5LN1Vm?=
 =?utf-8?B?aktnMXM1Skp5Mlh3NG0zK0c0d1lBWmZkK1JHVWJKZGFHNnltK0ptU0JDd1h5?=
 =?utf-8?B?ZGF1ZFEzUnQrdlhpaCtoQkJMbDA2RnFaSFlMc0FOTVJlSXdySXZCeEtWbGpy?=
 =?utf-8?B?b3pQZTRBTjZUQkFMMllsY3pSWUlYVis1Q1BpUUQ2VWdXeS96MTgvckZKWE82?=
 =?utf-8?B?cWxIQU1LUWlndUtjRFlERG13eWl1SjRVZXhJVVczbm0rekR3MHUrazdUdlRH?=
 =?utf-8?B?ZmFody9FRDN1V2JTeHhqMnh0YU9jcUUraGgzdERHeXpnRENnY2wvYTNJMjBP?=
 =?utf-8?B?QUdHenJ0bk8zYkNKcFBrT0dORUxxaXl5c1BPaTFOdWJYK2NhNUhlQ25KRktt?=
 =?utf-8?B?eWlNUHluUWtDN3cweVZ5VVhTckpCZitkemRHQ3R0NHpsQm1idWN1Q2xLVjEv?=
 =?utf-8?B?blRUR3liRHBTMDJkVzJXWGZnYk1XWTFNY1ArRzBPaDFCblRpUjdjR3lxQzEy?=
 =?utf-8?B?UEd3ekEzZDlhK3VNTWRWTHBXbUdwcDhITlVWMFVBOWpndjJud0JKaVRBLzhk?=
 =?utf-8?B?QkVjVnhaSlBPU1R3N1RKZmtZWXcwbnM5UzArckZDc0ErUm5pMWNwTitnek1D?=
 =?utf-8?B?YVhpTEZIV1d6amhhV2xqYmd4OXE2Qm9qTFVXbUIvTktxdGNhU2pOWkRncWZr?=
 =?utf-8?B?NjVCeTBnZFF5YzBmWWFUYWZZbTR4ajVBV1Brc1NXb29PY1BZNUU4N3U1emRm?=
 =?utf-8?B?TlFReU1rNGVtVEVJZHQrMExCSzNjcnBDZ1ltQW9aTWRuWjdpRlovOGVST0Mv?=
 =?utf-8?B?Qi8vY1QwMEFZYzNEdXdZSGhaZG94aUkzYUllNlV5eU1TU3NOSGoxamhWdUEz?=
 =?utf-8?B?QUcxZk9iK1FwVE1LdDNtWFM3NnpFTUNtQm1NYnI0OXNrQlBNTEpsV2dndnBp?=
 =?utf-8?B?TnhNajNUUU5RQ2Y1UUpMY3QwUnJ3Y21jSUN5SHI0SHphalo2cG56Q0dqN2d0?=
 =?utf-8?B?THpLWk1uR04zMnBoeDhaK3kxK09kOWZBSlUvemg1bjBmNlhhOVpPTGIyRUNL?=
 =?utf-8?B?V01Nd1Brd2VwdTVEdzFDZkdIT1JCREQ5RWs0dWxtWEZNTmI2dWxFWFFHajlH?=
 =?utf-8?B?WjVUTmdXMXNrSDduS0xhdVRDU0JqVlZqT1c5a25sNkJPdUZpeHVWa1pIMUJR?=
 =?utf-8?Q?bC94=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 17:14:40.2317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2618d8-0a88-4f18-0b95-08de31c64759
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7663

On Tue, 02 Dec 2025 16:29:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 182 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Dec 2025 15:28:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.302-rc3-g95d4a5c8c83f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
