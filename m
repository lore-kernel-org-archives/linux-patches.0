Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3983A2DB781
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670565; cv=fail; b=OMVaiUgz4cWfvmReH+aZpZwf1gHrWHf+epKE5RWv1wcUpPm/gqGNbUMwRH4cX4SDAm9Bmpkdwh3DxlJcV4EeYZbOH5uTYD61wKiZ90atgIfPuUU8vXVjhYMt4wjIOgrx0V/Hc0nXjb50zb4EgynBlznZbC+bMCuRJj7Pq+zVFms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670565; c=relaxed/simple;
	bh=x2bY5TLSueYuj+okbaC2YWopQAjxdbCauNcKhwFiSRI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sinNwhRs8dxclYQFPkg5szNpEAvdfhgbgn4k7YU3cVm2Ucv/ZUREuD6671BxIWyozdE0l277y0s9uHW0lOV/RjIeVDKquTbm6R2zRGXNUk5yaI50D8YEiVMYSojj7w3ecS2SPlsJ3Tc2zW30J2VVNJ4zFeCRaLxmO4Y27RbeTKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aTYfzXLo; arc=fail smtp.client-ip=52.101.62.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aTYfzXLo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfeoOmKX06MlCKDtipgfkE4tx/cvIwRQi4AQVnn53mNAh+myXhnnA4VEQvna6QrzJvf8APs/67+G5Oi2RvxcJpvIFm0mDlP98Q/Wt3o2g8czC3JuMP0Ofvy0R6oZ4XVqFs9gCsF6ap7HEoY/f9ZiR6zH09S/LGMzyCXDC35szQqKulWYnoei4DsR1HI4nZ6w7yT68uKNgycvqdvvniH5Z4PU0HQnVxWYJKLsymuzgQ5d2ts93qFbMxh8Iq7I87a3b0jd/neSj0ibjtzk801iTjFQKFKQrCePaRzHIcga9s7C6E5KIqsDqH6Xxo+FgWjTefnB3FPQuDt3o/g1+ttoqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQSM5nIi7pH6pCIVeBj06rx2pmLDagzcq1gHxAbhcuk=;
 b=grIUHYSfTy+SptakUOqYwoBE2HLqw8sG4ApnsTqM92znzhzWsz6BamTBrOP00cyDEy7gBjyawZBYtT6kUPy6yBqlM1/5OP4DS6XgtLNL9kE5JajcJTQwsDY14gos9plKlSvh6G7fUFIrx61HXihB4pcVEsNoJehN+Zu5Yiwm5Q8V3mNZM4mrl7yzg6vEIiYUR0fC1sYVVrjh7P07BKBB7m6Z07v05/B4rg30h2NiANKvG9kPiHI2TuYTHvTJ17BfD9+xGILaxb4VvI99RBbpODPMDkrfrKbgKtjafplEd0OuFbCLoo0k+t6uDKaYZJzt4gSRE1uBA7W4IE9kUghLBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQSM5nIi7pH6pCIVeBj06rx2pmLDagzcq1gHxAbhcuk=;
 b=aTYfzXLoca5Vu/pbGQSxRjYCmbxJFZnjdvatXNzColXZcxlfjVNtU/hZBTO2wGxFsWnzozsQPNTAxHyCw3795yuilVi6OX9SnAJLkkH75yidAp0vzxPhPqrv2Mg3H6/3g/aULb+1qHfNxlkk1cDxvFfaf/5kvTQCKNlwA8FvSdk4n3QFv2k6zruH/I2NcVMTPb2qWIFD0SlelIHalcIe1hUDcVqc/n3Xgbs38TW2/h5H4iMizajftlxiTIfpoWx79bCe8+TurnWwlu1rcRfkiTOqWTTuNkgABn6rBMdEloicIlv3803JxZAWdIGiaxoZLL281PobN8/emBFYp5KhTQ==
Received: from SJ0PR03CA0177.namprd03.prod.outlook.com (2603:10b6:a03:338::32)
 by IA0PPFC855560D7.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 20:56:00 +0000
Received: from SJ1PEPF000023D3.namprd21.prod.outlook.com
 (2603:10b6:a03:338:cafe::65) by SJ0PR03CA0177.outlook.office365.com
 (2603:10b6:a03:338::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.18 via Frontend Transport; Mon,
 9 Feb 2026 20:55:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D3.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.0 via Frontend Transport; Mon, 9 Feb 2026 20:55:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:33 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:32 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 9 Feb 2026 12:55:32 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c4c408a0-7c3a-47d7-b9cc-f8cc4ec29b92@rnnvmail202.nvidia.com>
Date: Mon, 9 Feb 2026 12:55:32 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D3:EE_|IA0PPFC855560D7:EE_
X-MS-Office365-Filtering-Correlation-Id: dbe6b650-aeb1-4331-31ac-08de681da09f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWRjZk1VTmVSN2oyRDFiRG9sS3FvQ1YzOFoyRUVOS0VNZWJoWWtUODhpOXhs?=
 =?utf-8?B?bjJHemdOM1Fsc0lNeVdlQnMzSzExZWdBVGhyV1pvblFWc1VZdUo3dGRQdzRY?=
 =?utf-8?B?Vk56aW9nUmpCVjhweHNQNG1KdG5DcXBDeUNNUTYyL2gvSWo0M0dzYS9NUXd3?=
 =?utf-8?B?bTM3M1V3WnE2d3g0OWhBOHMzOFV3S2ZoSndhUjR4K1JBbGhBNkswRUllbHdt?=
 =?utf-8?B?Q3lTcHpaRjF1OFlkMnVoVm1ndjhzdGJ1Nnpqc1dqQVlZRzJ1eVFBdkdpTnJV?=
 =?utf-8?B?TTZQZGlIYTIwaGZFTk5mOFNNWnBVZFF0TWlnNEUxeDcyTTBROEY2ME9VSGI3?=
 =?utf-8?B?ZEw3QUdwemRLOFJCMmM0RTBVZDdQaDEycnNYelJmWXp1c05pV3A2K3JIYVB6?=
 =?utf-8?B?VElrZzJsRHh5RXo1d1pjR1A1MW42NEZQVUFQVnFSVXJLNUtHS1pRR2N2UGFZ?=
 =?utf-8?B?QkZFdzlDSTU5YjAyVEpDZml6bVJ2bEN5TndaSUg5V1hJQURvYmdVUlV6NjVw?=
 =?utf-8?B?aDdIZ3QyWm9EeTlmQldRTlB6VEFkVXkrd2NiU3ZmYWo2dVkwdEVJcjB0ak1o?=
 =?utf-8?B?Mi9aWXIrcXd1SWdBZXJxYklnUGVnM1E1bTRoa21oQ3FySy9sbFVLNFUwQUUr?=
 =?utf-8?B?MU1NTTlvbTBPcTV2cGVIVDI1K21uRmc5NndLUnk3cGlSNDR1M2pPNStJdWhI?=
 =?utf-8?B?eEsvTVVEYmZ3YUVtcGQybHAzRFB0d1BJWkhjenRRaFoxejYxRUVWUDl1Nmpq?=
 =?utf-8?B?Z0JPWHFkME5hWFRLTDRsVk9Eb09HQzRiRWRRYVptKzNvdXVTdDVGMnhwSkdk?=
 =?utf-8?B?Q3NoUC9IUlJoTy81WHlpN1R2QlliV0srNUpiSVdwb1hBYmtNbnAyRUh4djZt?=
 =?utf-8?B?KzZOblg0TDlJSW9iWVN5cllmRlplMzNxRTdnNjRKdW90ZnhxaVlyL0puTXNr?=
 =?utf-8?B?TjROamg5em82TDhXbXVzWXV0T1VTT2E0M0dyTkpoTS9WMVdHTU5US08vd2Jl?=
 =?utf-8?B?VUJUeWpHV1N6NmsxUVdMdkwwWS9sRnNRT3kyUkpSL1V2LzNINFp0aG5JVU5B?=
 =?utf-8?B?S0J0OXJtdEo2U1ZoSVVueFVBcjhZRTVMZVFDNzVMQ0grUzVCVnQzNkNmOSt6?=
 =?utf-8?B?WUdMNUkzT1pkNGpaRzBlcDAwT3c4bnp4cUdaa09HSzhGTGl4eHpoN25FditR?=
 =?utf-8?B?Q1lWN1drd2VJWVhHaElEM3E3S2hFTVp1QlR2ZmRqRUxmNVRWMFp2Z2V3aEgz?=
 =?utf-8?B?MXJhYlBjL0ZBaDhEYVAwQ2IxZHBYNXpIRkFvQnREaE8rVkVKblpHejQ1Sm5K?=
 =?utf-8?B?YUM4dFBtN2s0YjYwaG1KZ25XUnlySXMybEZ0Vzg3YmVXbHZEeUhsZzd6UUIz?=
 =?utf-8?B?YmZxQmlpbkd5SDhhRzB5ejZyT3hQVnBuR1FjNk1ONXlDdUE0ZzBzYVBHR3Fs?=
 =?utf-8?B?TjIyRGU3aE1WdzFvTmZNL2gvR2Z3RFd2VG9WdVFTalRGZVZkcGVkMTVvZ3JL?=
 =?utf-8?B?aUNNY25jdlYzNjQvQWpmbG00K2pvYWN0SXFsU1EwenNFMWF0RURFQzF4cmpV?=
 =?utf-8?B?dHdJL1p1UERkWWZRV2pubE8vMTMvRXVnUGphbFhITVdUcUVldEZVdlRKYmxs?=
 =?utf-8?B?RThQK2VmKzdqQXlIZ21Jc2ZFU2tWSldyTEpZTktlQTVqM2gxRXRxQTBtem5y?=
 =?utf-8?B?LzhEbFVQcWMrMWZrcG8zaEM0NkRCTWp5VXVCcHduci8rbklXN2dRUXZDa2g1?=
 =?utf-8?B?Z1BVeHhCbXFlZEw5UUhHZGRsUWJwclJGMzRKYk9EZkRsWEpoa3Z5YVJwQ0RU?=
 =?utf-8?B?cXBaK1hDbVZzNmxvVTFNNFBMVGkvYWM0SzVyZmxxWThjVHhEQjQ1bmY2Zld2?=
 =?utf-8?B?S1Y0TU9HOU5hNVNyVEppVTJYUUNVLzhGZm5aTHFDZnRvc2Rnd3llakZoNUdJ?=
 =?utf-8?B?UW9MRHdFT1pidVpzTzBGNE1tS004eUhzT0U3ZTVCSXZBaUtLb2NxenFEQkcw?=
 =?utf-8?B?bm5jbHczdnExcUxQa0hTQUVETTMzbEQyVmdiUGhBaXY1aFlEZjFVSjlGR0J3?=
 =?utf-8?B?THRRSXNOWFVFZSt5bkNSVFFRSERzQ0FRTDZzNGVlZ3ZjaTZhQVNZZE9pL0lN?=
 =?utf-8?B?VnZNN3FKOXdqYkF4WnBJTFo3Z1RRN0dqTTFMTlhpRWRMckM1QThscGNWdThD?=
 =?utf-8?B?cmU1ZUxRU1lIOXpuNm5CS0Vta25sdTNQVzJKZElraG1kTVJ2eG90S2hrYkw2?=
 =?utf-8?B?bVZwcXo2RVZVSDEwVWp2dzIxN2xBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JO5xGiPycG5v4ao/ElDxD1Jg/Q5YsJU0+xYzEk6l5wCU9RSDIq83eWRZHbP8lP1WJrGPA2chagc8Yuf7omuvcDCk9fOQhJQZeCZFFjlHJHPByOXgTTMyodMQny7DouyxfVv8vQUllip/pfaUCSvP2kYgxAtPmbEBok07jPjp7l7F4CpNvc/YOPeHonrMP3v+bqfTsgFb81p54VbkLXZ4XkEUB0QWOZ1ngRHW1Ka9RRBHI+kwbRDDcoxgJjVnPDoi5MnFvWnZf/Lxgyafk9gFSArSkr5mjH6MC+CNh22GNMjRuo/hcS1gVKxl00ugpLt5UNnXvtAyO/wCRPrHNHrQ1rIzi3yjMmKQXPS1YsKLUzh4GXM88LbJizRjlb/A/r5GHfBfkhIzfhFNUAZG1WxI6zn4vOedgz7a39+jedsT8v8pc9s4VhMT7qXzrP3f2mez
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 20:55:59.0611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe6b650-aeb1-4331-31ac-08de681da09f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFC855560D7

On Mon, 09 Feb 2026 15:21:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.10-rc1-g0aa40b8da17f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
